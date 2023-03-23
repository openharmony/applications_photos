/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { Constants } from '../../../common/model/common/Constants';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';
import { CropResetBar } from './CropResetBar';
import  screenManager  from '@ohos/base/src/main/ets/manager/ScreenManager';
import { Log } from '@ohos/base/src/main/ets/utils/Log';

@Component
export struct CropImageShow {
    @Consume('selected') selectedMode: number;
    @Consume broadCast: Broadcast;
    @Consume('verticalScreen') isVerticalScreen: boolean;
    @Consume isCropReset: boolean;
    @Consume screenWidth: number;
    @Consume screenHeight: number;
    @Consume cropEdit: PhotoEditCrop;
    private displayHeight: number = 0;
    private displayWidth: number = 0;
    private flexHeight: number = 0;
    private flexWidth: number = 0;
    private TAG: string = 'CropImageShow'
    private stateMenuSize: number = screenManager.getStatusBarHeight();
    setting: RenderingContextSettings = new RenderingContextSettings(true);
    context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
    private preTouch: number = 0;
    private prePinch: number = 0;

    onCropResetClicked() {
        Log.debug(this.TAG, 'crop reset is clicked');
        this.cropEdit.reset();
        this.isCropReset = this.cropEdit.couldReset();
        this.broadCast.emit(Constants.RULER_BAR_INTI, []);
    }

    onTouchStart(event: TouchEvent) {
        let x = event.touches[0].x;
        let y = event.touches[0].y;
        switch (event.type) {
            case TouchType.Down:
                this.preTouch = new Date().getTime();
                this.cropEdit.onTouchStart(x, y);
                break;
            case TouchType.Move:
                let now = new Date().getTime();
                if (now - this.preTouch >= Constants.TIMEOUT) {
                    this.preTouch = now;
                    this.cropEdit.onTouchMove(x, y);
                }
                break;
            case TouchType.Up:
            case TouchType.Cancel:
                this.cropEdit.onTouchEnd();
                this.isCropReset = this.cropEdit.couldReset();
                break;
            default:
                break;
        }
    }

    onPinchGestureStart(event: GestureEvent) {
        Log.debug(this.TAG, 'cropMode onPinchGestureStart called');
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

    onPinchGestureUpdate(event: GestureEvent) {
        let now = new Date().getTime();
        if (now - this.prePinch >= Constants.TIMEOUT) {
            this.prePinch = now;
            this.cropEdit.onPinchUpdate(event.scale);
        }
    }

    onPinchGestureEnd() {
        Log.debug(this.TAG, 'cropMode onPinchGestureEnd called');
        this.cropEdit.onPinchEnd();
        this.isCropReset = this.cropEdit.couldReset();
    }

    aboutToAppear() {
        Log.debug(this.TAG, 'Photo CropImageShow called');
        this.broadCast.on(Constants.CROP_RESET_CLICKED, this.onCropResetClicked.bind(this));
        this.flexHeight = this.isVerticalScreen
            ? this.screenHeight - Constants.TOP_BAR_SIZE - Constants.BOTTOM_TOOL_BAR_SIZE
            : this.screenWidth - Constants.TOP_BAR_SIZE;
        this.flexWidth = this.isVerticalScreen ? this.screenWidth : this.screenHeight - Constants.BOTTOM_TOOL_BAR_SIZE;
        this.displayHeight = this.isVerticalScreen
            ? this.screenHeight - (Constants.TOP_BAR_SIZE + Constants.BOTTOM_TOOL_BAR_SIZE + Constants.RESET_SIZE)
            : this.screenWidth - Constants.TOP_BAR_SIZE;
        this.displayWidth = this.isVerticalScreen
            ? this.screenWidth : this.screenHeight - (Constants.BOTTOM_TOOL_BAR_SIZE + Constants.RESET_SIZE_HORIZONTAL);
        this.cropEdit.setCanvasSize(this.displayWidth, this.displayHeight);
        Log.debug(this.TAG, `CropImageShow this.screenHeight = ${this.flexHeight}, this.screenWidth = ${this.flexWidth}`);
    }

    aboutToDisappear() {

    }

    build() {
        Flex({
            direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
        }) {
            Canvas(this.context)
                .width(this.displayWidth)
                .height(this.displayHeight)
                .onReady(() => {
                    this.cropEdit.setCanvasContext(this.context)
                })
            Column() {
                CropResetBar()
            }
        }
        .width(this.flexWidth)
        .height(this.flexHeight)
        .onTouch((event) => {
            this.onTouchStart(event);
        })
        .gesture(
        PinchGesture()
            .onActionStart((event: GestureEvent) => {
                this.onPinchGestureStart(event);
            })
            .onActionUpdate((event: GestureEvent) => {
                this.onPinchGestureUpdate(event);
            })
            .onActionEnd(() => {
                this.onPinchGestureEnd();
            })
        )
    }
}