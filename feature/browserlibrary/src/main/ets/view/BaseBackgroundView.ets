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
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BackgroundViewController } from '../model/background/BackgroundViewController';
import lazy { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';

const TAG: string = 'browser_BackgroundView';

/**
 * 大图页背景板组件，随大图页是否为沉浸式状态而变化颜色
 */
@Component
export struct BaseBackgroundView {
  @Consume @Watch('onChangeBgColor') onlyChangeBgColor: boolean;
  @Link @Watch('onShowChanged') isShowBar: boolean;
  @Prop @Watch('onIsDetailSelectedChanged') isDetailSelected: boolean = false;
  @LocalStorageProp('isEditorShown') @Watch('onChangeIsEditorShown') isEditorShown: boolean = false;
  // 防止大图背景与actionbar、toolbar背景过度绘制，导致进出编辑动效背景透明度不一致的问题
  @Prop avoidOverdrawPadding: Padding | null = null;
  @State backColor: Resource = $r('sys.color.background_secondary');
  @State isBlackBgVisibility: boolean = false;
  // controller元素控制器
  public controller: BackgroundViewController = new BackgroundViewController();

  aboutToAppear(): void {
    this.initParams();
    this.controller.aboutToAppear();
  }

  private initParams(): void {
    this.controller.isShowBar = this.isShowBar;
    this.controller.isBlackBgVisibility = this.isBlackBgVisibility;
    this.controller.isDetailSelected = this.isDetailSelected;
    this.controller.backColor = this.backColor;
  }

  public onIsDetailSelectedChanged(): void {
    this.controller.isDetailSelected = this.isDetailSelected;
    this.controller.onIsDetailSelectedChanged();
  }

  public onShowChanged(): void {
    this.controller.isShowBar = this.isShowBar;
    this.controller.onShowChanged();
  }

  public onChangeBgColor(): void {
    this.controller.onChangeBgColor();
  }

  public onChangeIsEditorShown(): void {
    this.controller.isEditorShown = this.isEditorShown;
    this.controller.onEditorShownChanged();
  }

  build() {
    Stack() {
      if (this.controller.isFromPhotoBrowser) {
        if (this.controller.isBlackBgVisibility) {
          Column() {
          }
          .key('PhotoBrowserBg')
          .backgroundColor(this.controller.blackBgColorResource)
          .width('100%')
          .height('100%')
        }

        Column() {
        }
        .backgroundColor(this.controller.backgroundColor)
        .layoutWeight(this.controller.isFromCamera ? undefined : 1)
        .key('PhotoBrowserBg')
        .padding(this.controller.isBlackBgVisibility ? 0 : (this.avoidOverdrawPadding ?? 0))
        .width('100%')
        .height('100%')
        .opacity(this.controller.opacityValue)
      } else {
        Column() {
        }
        .key('PhotoBrowserBg')
        .backgroundColor(this.controller.backgroundColorResource)
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