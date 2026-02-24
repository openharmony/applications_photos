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
import lazy Curves from '@ohos.curves';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'common_BackgroundViewController';
const PROPERTY_BACK_GROUND_OPACITY: number = 0.95;
const BG_COLOR_CHANGE_ANIMATION: number = 200;

/**
 * 大图页背景板controller，供大图使用
 */
@ObservedV2
export class BackgroundViewController {
  @Trace public opacityValue: number | undefined = 1;
  @Trace public isBlackBgVisibility: boolean = false;
  @Trace public blackBgColorResource: Resource | undefined;
  @Trace public backgroundColorResource: Resource | undefined;
  @Trace public isShowBar: boolean = false;
  @Trace public isDetailSelected: boolean = false;
  @Trace public backColor: Resource | string | undefined;
  // 二层背景
  @Trace public backgroundColor: Resource | string | undefined;
  // 背景view层avoidOverdrawPadding参数
  @Trace public browserViewAvoidOverdrawPadding: Padding | null = null;
  // 背景view层isDetailSelected参数
  @Trace public browserViewIsDetailSelected: boolean = false;
  // 背景view层opacity参数
  @Trace public browserViewOpacity: number = 0;
  // 背景view层transition参数
  @Trace public browserViewTransition: TransitionEffect | null = null;
  // 背景view层enable参数
  @Trace public browserViewEnable: boolean = false;
  /**
   * 是否来源相机（非图库大图）
   */
  public isFromCamera: boolean = false;
  public isFromPhotoBrowser: boolean = false;
  public isFromPortraitCoverSet: boolean = false;
  public isShowSearchPage: boolean = false;
  public isShowPhotoClassifieds: boolean = false;
  public isShowPortraitAlbumsView: boolean = false;
  public isEditorShown: boolean = false;

  constructor(isFromPhotoBrowser?: boolean) {
    this.isFromPhotoBrowser = isFromPhotoBrowser ?? false;
  }

  public aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear isFromPortraitCoverSet:${this.isFromPortraitCoverSet}`);
    if (this.isFromCamera) {
      this.isBlackBgVisibility = this.isShowBar ? false : true;
      this.opacityValue = this.isShowBar ? 1 : 0;
      return;
    }

    if (DeviceInfo.isVerdeFoldable()) {
      this.changeToImmersive();
    }
    this.updateOpacityValue();
  }

  public onIsDetailSelectedChanged(): void {
    if (this.isFromCamera) {
      this.handleDetailSelectedOnCamera();
    }
    Log.info(TAG, `isDetailSelected: ${this.isDetailSelected}, opacityValue: ${this.opacityValue}`);
  }

  public updateOpacityValue(): void {
    if (this.isFromCamera) {
      return;
    }
    this.opacityValue = DeviceInfo.isTv() ? undefined : this.opacityValue;
  }

  public onChangeBgColor(): void {
    this.blackBgColorResource = this.backgroundColorResource;
  }

  public onShowChanged(): void {
    Log.debug(TAG, `[onShowChanged] isShowBar: ${this.isShowBar}`);
    if (!this.isShowBar) {
      this.isBlackBgVisibility = true;
    }
    this.syncBlackBgColor();
    this.animateShowChange();
  }

  public updateBrowserViewAvoidOverdrawPadding(isInSwitchAnimation: boolean, bgPadding: Padding): void {
    if (this.isFromCamera) {
      this.browserViewAvoidOverdrawPadding = isInSwitchAnimation ? bgPadding : null;
      return;
    }
    this.browserViewAvoidOverdrawPadding = null;
  }

  public updateBrowserViewIsDetailSelected(isDetailSelected: boolean): void {
    this.browserViewIsDetailSelected = isDetailSelected;
  }

  public updateBrowserViewOpacity(geometryOpacity: number, burstSwiperOpacity: number): void {
    if (this.isFromCamera) {
      this.browserViewOpacity = geometryOpacity;
      return;
    }
    this.browserViewOpacity = geometryOpacity * (1 - burstSwiperOpacity);
  }

  public updateBrowserViewTransition(isDrag: boolean): void {
    if (this.isFromCamera) {
      this.browserViewTransition = TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.animation({
          curve: Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
          duration: 200,
        }),
        isDrag ? TransitionEffect.opacity(0) : TransitionEffect.OPACITY.animation({
          curve: Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
          duration: 100,
        })
      )
      return;
    }

    this.browserViewTransition = TransitionEffect.asymmetric(
      Constants.OPEN_EFFECT,
      isDrag ? TransitionEffect.opacity(0) : Constants.CLOSE_EFFECT
    )
  }

  public updateBrowserViewEnabled(isPullDownAndDragPhoto: boolean, isAnimating: boolean): void {
    if (this.isFromCamera) {
      this.browserViewEnable = !isPullDownAndDragPhoto;
      return;
    }
    this.browserViewEnable = !isPullDownAndDragPhoto && !isAnimating;
  }

  protected execDetailSelectedAnimate() {
    this.opacityValue = PROPERTY_BACK_GROUND_OPACITY;
    animateTo({
      duration: BG_COLOR_CHANGE_ANIMATION,
      curve: Curve.Sharp,
    }, () => {
      this.backColor = $r('app.color.black');
    });
  }

  private changeToImmersive(): void {
    this.opacityValue = 0;
    this.isBlackBgVisibility = true;
    this.syncBlackBgColor();
    this.blackBgColorResource = this.backgroundColorResource;
  }

  private syncBlackBgColor() {
    if (this.blackBgColorResource?.id != $r('app.color.black').id) {
      this.blackBgColorResource = $r('app.color.black');
    }
  }

  private animateShowChange() {
    animateTo({
      duration: Constants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? 0 : Constants.IMMERSE_ANIM_DELAY,
      curve: this.isShowBar ? Curves.cubicBezier(0.2, 0.0, 0.2, 1.0) : Curves.cubicBezier(0.6, 0.0, 0.6, 1.0),
      onFinish: () => {
        if (this.isShowBar) {
          this.isBlackBgVisibility = false;
        }
      }
    }, () => {
      this.opacityValue = this.isShowBar ? 1 : 0;
    });
  }

  protected handleDetailSelectedOnCamera() {
    this.backColor = $r('sys.color.background_secondary');
    animateTo({
      duration: BG_COLOR_CHANGE_ANIMATION,
      curve: Curve.Sharp,
    }, () => {
      this.opacityValue = this.isShowBar ? 1 : 0;
    });
  }

  /**
   * 进出编辑大图执行背景渐变动画
   */
  public onEditorShownChanged(): void {
  }
}

