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
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { BackgroundViewController } from './BackgroundViewController';

const TAG: string = 'common_BackgroundViewControllerPC';
const BG_COLOR_CHANGE_ANIMATION = 200;

/**
 * PC大图页组件背景板controller
 */
@ObservedV2
export class BackgroundViewControllerPC extends BackgroundViewController {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  public onIsDetailSelectedChanged(): void {
    if (this.isFromCamera) {
      this.handleDetailSelectedOnCamera();
      return;
    }

    this.handleDetailSelected();
    Log.info(TAG, `isDetailSelected: ${this.isDetailSelected}, opacityValue: ${this.opacityValue}`);
  }

  protected handleDetailSelectedOnCamera() {
    if (this.isDetailSelected) {
      this.execDetailSelectedAnimate();
    } else {
      this.backColor = $r('sys.color.background_secondary');
      animateTo({
        duration: BG_COLOR_CHANGE_ANIMATION,
        curve: Curve.Sharp,
      }, () => {
        this.opacityValue = this.isShowBar ? 1 : 0;
      });
    }
  }

  /**
   * PC进出编辑大图执行背景渐变动画
   */
  public onEditorShownChanged(): void {
    if (!this.isEditorShown) {
      this.opacityValue = 0;
      this.isBlackBgVisibility = true;
      this.blackBgColorResource = $r('app.color.black');
    }
    animateTo({
      duration: Constants.EDITOR_SWITCH_IN_DURATION,
      onFinish: () => {
        this.isBlackBgVisibility = false;
        this.blackBgColorResource = this.isEditorShown ? $r('app.color.black') : this.backgroundColorResource;
        Log.info(TAG, `onEditorShownChanged finish, blackBgColorResource:${this.blackBgColorResource?.id}`);
      }
    }, () => {
      if (this.isEditorShown) {
        LocalStorage.getShared()?.setOrCreate<number>('geometryOpacity', 0);
      } else {
        this.opacityValue = 1;
        LocalStorage.getShared()?.setOrCreate<number>('geometryOpacity', 1);
      }
    })
  }

  private handleDetailSelected() {
    if (this.isDetailSelected) {
      this.execDetailSelectedAnimate();
    } else {
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
}
