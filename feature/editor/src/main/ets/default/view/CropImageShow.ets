/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BroadCast, Constants, Log, ScreenManager } from '@ohos/common';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';

const TAG: string = 'editor_CropImageShow';

@Component
export struct CropImageShow {
  @Consume('selected') selectedMode: number;
  @Consume broadCast: BroadCast;
  @Consume isCropReset: boolean;
  @Consume @Watch('adjustLayout') screenWidth: number;
  @Consume @Watch('adjustLayout') screenHeight: number;
  @Consume cropEdit: PhotoEditCrop;
  @State displayHeight: number = Constants.NUMBER_0;
  @State displayWidth: number = Constants.NUMBER_0;
  setting: RenderingContextSettings = new RenderingContextSettings(true);
  context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  @Consume('verticalScreen') isVerticalScreen: boolean;
  private stateMenuSize: number = ScreenManager.getInstance().getStatusBarHeight();
  private preTouch: number = Constants.NUMBER_0;
  private prePinch: number = Constants.NUMBER_0;
  private onCropResetClickedFunc: Function = (): void => this.onCropResetClicked()

  onCropResetClicked(): void {
    Log.debug(TAG, 'crop reset is clicked');
    this.cropEdit.reset();
    this.isCropReset = this.cropEdit.couldReset();
    this.broadCast.emit(Constants.RULER_BAR_INTI, []);
  }

  onTouchStart(event: TouchEvent): void {
    let x = event.touches[0].x;
    let y = event.touches[0].y;
    if (event.type == TouchType.Down) {
      this.preTouch = new Date().getTime();
      this.cropEdit.onTouchStart(x, y);
    } else if (event.type == TouchType.Move) {
      let now = new Date().getTime();
      if (now - this.preTouch >= Constants.TIMEOUT) {
        this.preTouch = now;
        this.cropEdit.onTouchMove(x, y);
      }
    } else if (event.type == TouchType.Up || event.type == TouchType.Cancel) {
      this.cropEdit.onTouchEnd();
      this.isCropReset = this.cropEdit.couldReset();
    } else {
      Log.info(TAG, 'touch other event');
    }
  }

  onPinchGestureStart(event: GestureEvent): void {
    Log.debug(TAG, 'cropMode onPinchGestureStart called');
    this.prePinch = new Date().getTime();
    let x = 0;
    let y = 0;
    if (this.isVerticalScreen) {
      x = event.pinchCenterX;
      y = event.pinchCenterY - Constants.TOP_BAR_SIZE - this.stateMenuSize;
    } else {
      x = event.pinchCenterX - Constants.TOOL_BAR_SIZE;
      y = event.pinchCenterY - Constants.TOP_BAR_SIZE - this.stateMenuSize;
    }
    this.cropEdit.onPinchStart(x, y, event.scale);
  }

  onPinchGestureUpdate(event: GestureEvent): void {
    let now = new Date().getTime();
    if (now - this.prePinch >= Constants.TIMEOUT) {
      this.prePinch = now;
      this.cropEdit.onPinchUpdate(event.scale);
    }
  }

  onPinchGestureEnd(): void {
    Log.debug(TAG, 'cropMode onPinchGestureEnd called');
    this.cropEdit.onPinchEnd();
    this.isCropReset = this.cropEdit.couldReset();
  }

  aboutToAppear(): void {
    Log.debug(TAG, 'Photo CropImageShow called');

    this.broadCast.on(Constants.CROP_RESET_CLICKED, this.onCropResetClickedFunc);
    this.adjustLayout();
  }

  adjustLayout(): void {
    this.displayHeight = this.screenHeight;
    this.displayWidth = this.screenWidth;
    this.cropEdit.setCanvasSize(this.displayWidth, this.displayHeight);
  }

  aboutToDisappear(): void {
    this.cropEdit.setCanvasReady(false);
    this.broadCast.off(Constants.CROP_RESET_CLICKED, this.onCropResetClickedFunc);
  }

  build() {
    Flex({
      direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Canvas(this.context)
        .onReady(() => {
          this.cropEdit.setCanvasContext(this.context);
          this.cropEdit.setCanvasReady(true);
        })
    }
    .onTouch((event?: TouchEvent) => {
      this.onTouchStart(event as TouchEvent);
    })
    .gesture(
      PinchGesture()
        .onActionStart((event?: GestureEvent) => {
          this.onPinchGestureStart(event as GestureEvent);
        })
        .onActionUpdate((event?: GestureEvent) => {
          this.onPinchGestureUpdate(event as GestureEvent);
        })
        .onActionEnd((): void => {
          this.onPinchGestureEnd();
        })
    )
    .width(this.screenWidth)
    .height(this.screenHeight)
  }
}