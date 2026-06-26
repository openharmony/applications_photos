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
import lazy { Constants as PhotoConstants } from '../model/browser/photo/Constants';
import lazy { Log } from '../utils/Log';
import lazy Curves from '@ohos.curves';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';

const TAG: string = 'browser_PhotoBrowserComponentBg';
const PROPERTY_BACK_GROUND_OPACITY: number = 0.05;
const BG_COLOR_CHANGE_ANIMATION = 200;

@Component
export struct PhotoBrowserComponentBg {
  private isShowPhotoClassifieds: boolean = false;
  private isShowPortraitAlbumsView: boolean = false;
  @Consume @Watch('onChangeBgColor') onlyChangeBgColor: boolean;
  @Consume backgroundColorResource: Resource;
  @Link @Watch('onShowChanged') isShowBar: boolean;
  @State opacityValue: number = 1;
  @State backColor: Resource = $r('sys.color.background_secondary');
  @State isBlackBgVisibility: boolean = false;
  @State blackBgColorResource: Resource = this.backgroundColorResource;
  // 防止大图背景与actionbar、toolbar背景过度绘制，导致进出编辑动效背景透明度不一致的问题
  @Prop avoidOverdrawPadding: Padding | null = null;
  @LocalStorageLink('isBlackBg') @Watch('onChangeBlackBg') isBlackBg: boolean = false;
  @LocalStorageProp('isEditorShown') isEditorShown: boolean = false;
  private isFromPhotoBrowser = false;
  private isFromPortraitCoverSet: boolean = false;
  @Prop @Watch('onIsDetailSelectedChanged') isDetailSelected: boolean = false;
  private isShowSearchPage: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  // 显示变化
  onShowChanged(): void {
    if (!this.isShowBar) {
      this.isBlackBgVisibility = true;
    }
    if (this.blackBgColorResource.id != $r('app.color.black').id) {
      this.blackBgColorResource = this.backgroundColorResource;
    }
    animateTo({
      duration: PhotoConstants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? 0 : PhotoConstants.IMMERSE_ANIM_DELAY,
      curve: this.isShowBar ? Curves.cubicBezier(0.2, 0.0, 0.2, 1.0) : Curves.cubicBezier(0.6, 0.0, 0.6, 1.0),
      onFinish: () => {
        if (this.isShowBar) {
          this.isBlackBgVisibility = false;
        }
        this.blackBgColorResource = this.backgroundColorResource;
      }
    }, () => {
      if (this.isShowBar) {
        this.opacityValue = 1;
      } else {
        this.opacityValue = 0;
      }
    })
  }

  changeToImmersive(): void {
    this.opacityValue = 0;
    this.isBlackBgVisibility = true;
    if (this.blackBgColorResource.id != $r('app.color.black').id) {
      this.blackBgColorResource = this.backgroundColorResource;
    }
    this.blackBgColorResource = this.backgroundColorResource;
  }

  onIsDetailSelectedChanged(): void {
    if (!DeviceInfo.isPc()) {
      return;
    }
    if (this.isDetailSelected) {
      this.opacityValue = PROPERTY_BACK_GROUND_OPACITY;
      animateTo({
        duration: BG_COLOR_CHANGE_ANIMATION,
        curve: Curve.Sharp,
      }, () => {
        this.backColor = $r('app.color.black');
      })
    } else {
      this.backColor =
        (this.isBlackBg || this.isFromPortraitCoverSet) ? $r('app.color.black') :
        $r('sys.color.background_secondary');
      this.isNotDetailSelectedAnimate();
    }
  }

  private isNotDetailSelectedAnimate(): void {
    animateTo({
      duration: BG_COLOR_CHANGE_ANIMATION,
      curve: Curve.Sharp,
      onFinish: () => {
        if (this.isShowSearchPage) {
          this.appBroadCast.emit(BroadCastConstants.CHANGE_SEARCH_RESULT_PAGE_VISIBILITY, [Visibility.Visible]);
          if (this.isShowPhotoClassifieds) {
            this.appBroadCast.emit(BroadCastConstants.CHANGE_CATEGORY_ALBUM_VIEW_VISIBILITY, [Visibility.Visible]);
          }
          if (this.isShowPortraitAlbumsView) {
            this.appBroadCast.emit(BroadCastConstants.CHANGE_PORTRAIT_ALBUM_PAGE_VISIBILITY, [Visibility.Visible]);
          }
        }
      }
    }, () => {
      this.opacityValue = this.isShowBar ? 1 : 0;
    })
  }

  onChangeBgColor(): void {
    this.blackBgColorResource = this.backgroundColorResource;
  }

  onChangeBlackBg(): void {
    Log.info(TAG, `change isBlackBg:${this.isBlackBg}`);
    this.backColor =
      (this.isBlackBg || this.isFromPortraitCoverSet) ? $r('app.color.black') : $r('sys.color.background_secondary');
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear isBlackBg:${this.isBlackBg}, isFromPortraitCoverSet:${this.isFromPortraitCoverSet}`);
    this.backColor =
      (this.isBlackBg || this.isFromPortraitCoverSet) ? $r('app.color.black') : $r('sys.color.background_secondary');
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      this.changeToImmersive();
    }
  }

  build() {
    Stack() {
      if (this.isFromPhotoBrowser) {
        if (this.isBlackBgVisibility) {
          Column() {
          }
          .key('PhotoBrowserBg')
          .backgroundColor(this.blackBgColorResource)
          .width('100%')
          .height('100%')
        }

        Column() {
        }
        .backgroundColor((DeviceInfo.isPc() && (!this.isShowBar || this.isEditorShown)) ?
        PhotoConstants.FILLET_SERRATION_COLOR : this.backColor)
        .layoutWeight(1)
        .key('PhotoBrowserBg')
        .padding(this.isBlackBgVisibility ? 0 : (this.avoidOverdrawPadding ?? 0))
        .width('100%')
        .height('100%')
        .opacity(DeviceInfo.isTv() ? undefined : this.opacityValue)
      } else {
        Column() {
        }
        .key('PhotoBrowserBg')
        .backgroundColor(this.backgroundColorResource)
        .width('100%')
        .height('100%')
        .animation({
          duration: PhotoConstants.IMMERSE_ANIM_DURATION,
        })
      }

    }
    .width('100%')
    .height('100%')
  }
}