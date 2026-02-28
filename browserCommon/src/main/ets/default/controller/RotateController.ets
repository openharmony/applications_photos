/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy Matrix4 from '@ohos.matrix4';
import lazy { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4';
import lazy {
  getScreen,
  isOrientationHorizontal,
  setHorizontal
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { display, window } from '@kit.ArkUI';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';


const TAG: string = 'RotateController';
const HALF_DIVIDER: number = 2;

export class RotateController {
  private matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
  private item: MediaItem = new MediaItem();
  private videoWidth: number = 0;
  private videoHeight: number = 0;
  private buttonOffsetX: number = 0;
  private buttonOffsetY: number = 0;
  private overlayWidth: number = 0;
  private overlayHeight: number = 0;
  private isShowBar: boolean = true;
  private originOrientation: number = 0;
  private isOriginHorizontal: boolean = false;
  // 大图显示控件宽度
  private componentWidth: number = vp2px(getScreen().getWinLayoutWidth());
  // 大图显示控件高度
  private componentHeight: number = vp2px(getScreen().getWinLayoutHeight());
  private calcBarBottomHeightFunc: Function = (): number => {
    return 0;
  };

  constructor(calcBarBottomHeightFunc: () => number) {
    this.calcBarBottomHeightFunc = calcBarBottomHeightFunc;
  }

  public init(item: MediaItem, width: number, height: number, isShowBar: boolean): void {
    this.componentWidth = vp2px(getScreen().getWinLayoutWidth());
    this.componentHeight = vp2px(getScreen().getWinLayoutHeight());
    this.item = item;
    this.videoWidth = width;
    this.videoHeight = height;
    this.isShowBar = isShowBar;
    Log.info(TAG, `[VideoRotate] RotateController init, item: ${this.item.uri}, width = ${this.videoWidth}, height = ${
      this.videoHeight}, isShowBar = ${this.isShowBar}`);
    this.calculateOverlaySize();
    this.calcButtonOffset();
    const originOrientation: number | undefined = AppStorage.get<number>('originOrientation');
    if (originOrientation) {
      this.originOrientation = originOrientation;
      this.isOriginHorizontal = originOrientation === display.Orientation.LANDSCAPE ||
        originOrientation === display.Orientation.LANDSCAPE_INVERTED;
    } else {
      Log.error(TAG, 'Cannot get AppStorage value: \'originOrientation\'');
    }
  }

  public deinit(): void {
    Log.info(TAG, '[VideoRotate] RotateController deinit');
    this.videoWidth = 0;
    this.videoHeight = 0;
    this.overlayWidth = 0;
    this.overlayHeight = 0;
    this.isShowBar = true;
    this.matrix = Matrix4.identity().copy();
    this.buttonOffsetX = 0;
    this.buttonOffsetY = 0;
  }

  private getRatio(): number {
    if (this.videoWidth * this.videoHeight * this.componentWidth * this.componentHeight === 0) {
      return 1;
    }
    return this.videoWidth / this.videoHeight / (this.componentWidth / this.componentHeight);
  };

  // 刷新视频真正的宽高
  public resetVideoWidthAndHeight(width: number, height: number): void {
    Log.info(TAG, `[VideoRotate] resetVideoWidthAndHeight, width = ${width}, height = ${height}`);
    this.videoWidth = width;
    this.videoHeight = height;
    this.calculateOverlaySize();
  }

  private calculateOverlaySize(): void {
    if (!this.item) {
      return;
    }
    if (this.videoWidth !== 0 && this.videoHeight !== 0) {
      if (this.getRatio() > 1) {
        this.overlayWidth = this.componentWidth;
        this.overlayHeight = this.videoHeight * (this.overlayWidth / this.videoWidth);
        Log.info(TAG, `[VideoRotate] calculateOverlaySize, fit with full width: overlayWidth = ${
          this.overlayWidth}, overlayHeight = ${this.overlayHeight}`);
        return;
      }
      this.overlayHeight = this.componentHeight;
      this.overlayWidth = this.videoWidth * (this.overlayHeight / this.videoHeight);
      Log.info(TAG, `[VideoRotate] calculateOverlaySize, fit with full height: overlayWidth = ${
        this.overlayWidth}, overlayHeight = ${this.overlayHeight}`);
      return;
    }
    this.overlayWidth = this.componentWidth;
    this.overlayHeight = this.componentHeight;
    Log.info(TAG, `[VideoRotate] calculateOverlaySize, item width or height is undefined: overlayWidth = ${
      this.overlayWidth}, overlayHeight = ${this.overlayHeight}`);
  }

  private calcButtonOffset(): void {
    let yOffset: number = 0;
    let mat: number[] | undefined = (this.matrix.copy() as Matrix4x4).matrix4x4;
    if (!mat) {
      Log.error(TAG, `mat is ${String(mat)}`);
      return;
    }
    let scale: number = mat[0];

    let overlayDisplayWidth: number = this.overlayWidth * scale;
    let overlayDisplayHeight: number = this.overlayHeight * scale;

    let bottomHeight: number = this.isShowBar ? this.calcBarBottomHeightFunc() : 0;
    if (overlayDisplayWidth > this.componentWidth) {
      overlayDisplayWidth = this.componentWidth;
    }
    if (overlayDisplayHeight > this.componentHeight) {
      overlayDisplayHeight = this.componentHeight;
    }
    let xDelta = px2vp((this.componentWidth - overlayDisplayWidth) / HALF_DIVIDER);
    let yDelta = px2vp((this.componentHeight - overlayDisplayHeight) / HALF_DIVIDER);
    let toolBarHeight: number = this.calcBarBottomHeightFunc();
    yOffset = yDelta > toolBarHeight ? yDelta : toolBarHeight;
    Log.info(TAG, `[VideoRotate] calcButtonOffset, after calc: this.overlayWidth = ${
    this.overlayWidth}, this.overlayHeight = ${this.overlayHeight}, this.componentWidth = ${
    this.componentWidth}, this.componentHeight = ${this.componentHeight},scale = ${scale}, overlayDisplayWidth = ${
    overlayDisplayWidth}, overlayDisplayHeight = ${overlayDisplayHeight}, bottomHeight = ${
    bottomHeight}, yDelta = ${yDelta}, yOffset = ${yOffset}, xOffset = ${xDelta}`);
    this.buttonOffsetX = xDelta;
    this.buttonOffsetY = yOffset;
  }

  public setComponentSize(componentWidth: number, componentHeight: number): void {
    this.componentWidth = componentWidth;
    this.componentHeight = componentHeight;
    Log.info(TAG, `[VideoRotate] setComponentSize: ${this.componentWidth}, ${this.componentHeight}`);
    this.calculateOverlaySize();
  }

  public handlePhoneRotate(): void {
    if (!this.item) {
      Log.warn(TAG, 'currentPhoto is undefined');
      return;
    }
    const isHorizontal: boolean = isOrientationHorizontal();
    Log.info(TAG, `[VideoRotate] handlePhoneRotate, change orientation by menu originOrientation: ${this.originOrientation}, isHorizontal: ${isHorizontal}`);
    if (isHorizontal !== this.isOriginHorizontal) {
      WindowUtil.setOrientation(this.getWindowOrientationValue(this.originOrientation));
      setHorizontal(this.isOriginHorizontal);
    } else if (isHorizontal) {
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
      setHorizontal(false);
    } else {
      WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
      setHorizontal(true);
    }
    // 用户打点
    Log.info(TAG, `pra ${this.item.uri}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(this.item.uri),
    };
    ReportToBigDataUtil.report(BigDataConstants.PHONE_ROTATE_ACTION, msg);
  }

  // display的朝向和window的朝向值不同，通过display朝向得到对应的window朝向枚举值
  private getWindowOrientationValue(orientation: number): number {
    let result: number = 0;
    switch (orientation) {
      case display.Orientation.PORTRAIT:
        result = window.Orientation.PORTRAIT;
        break;
      case display.Orientation.LANDSCAPE:
        result = window.Orientation.LANDSCAPE;
        break;
      case display.Orientation.PORTRAIT_INVERTED:
        result = window.Orientation.PORTRAIT_INVERTED;
        break;
      case display.Orientation.LANDSCAPE_INVERTED:
        result = window.Orientation.LANDSCAPE_INVERTED;
        break;
      default:
        result = window.Orientation.AUTO_ROTATION_UNSPECIFIED;
        break;
    }
    return result;
  }

  public setMatrix(matrix: Matrix4.Matrix4Transit): void {
    this.matrix = matrix;
  }

  public setButtonOffsetY(): void {
    this.calcButtonOffset();
  }

  public getButtonOffsetX(): number {
    return this.buttonOffsetX;
  }

  public getButtonOffsetY(): number {
    return this.buttonOffsetY;
  }
}