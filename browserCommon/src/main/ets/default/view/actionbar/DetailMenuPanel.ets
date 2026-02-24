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
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { ActionBarButton } from './ActionBarButton';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuController';
/* instrument ignore file  */
const TAG: string = 'DetailMenuPanel';

/**
 * 用于大图详情显示，并动态刷新
 */
@Component
export struct DetailMenuPanel {
  @Prop menuList: Action[] = [];
  public actionBarProp: ActionBarProp = new ActionBarProp();
  onMenuClicked: Function = (): void => {
  };
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @State private isFirstUnHover: boolean = true;
  @State private firstTimer: number = -1;
  @Prop moreMenuList: Action[] = [];
  @Prop moreMenuListPC: RightClickMenuGroup[] = [];
  @Prop triggerValue: number = -1;
  @Prop private showMovingPhotoCloseEffect: boolean = false;
  @Prop private movingPhotoEffectMode?: number = 0;
  @Prop flexibleMenuList: Action[] = [];
  private isFromPhotoBrowser?: boolean = false;

  build() {
    Row() {
      ForEach(this.menuList, (menu: Action, index: number): void => {
        if (!Action.NONE.equals(menu)) {
          ActionBarButton({
            res: menu.iconRes,
            action: menu,
            actionMode: this.actionBarProp.getMode(),
            onMenuClicked: this.onMenuClicked,
            isAutoTint: menu.isAutoTint,
            colorMode: this.actionBarProp.getColorMode(),
            isFirstUnHover: this.isFirstUnHover,
            firstTimer: this.firstTimer,
            moreMenuList: this.moreMenuList,
            moreMenuListPC: this.moreMenuListPC,
            triggerValue: this.triggerValue,
            showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
            movingPhotoEffectMode: this.movingPhotoEffectMode,
            isLast: index === this.menuList.length - 1,
            length: this.menuList.length,
            isFromPhotoBrowser: this.isFromPhotoBrowser,
            flexibleMenuList: this.flexibleMenuList,
          })
          .transition(TransitionEffect.IDENTITY)
        }
      }, (menu: Action) => menu.actionID != undefined ? menu.actionID.toString() : '')
    }
    .key('DetailMenuPanel')
  }

  private onBuildDone(): void {
    Log.info(TAG, `onBuildDone, menu's size: ${this.menuList.length}`);
    this.menuList.forEach((menu: Action): void => {
      Log.info(TAG, `ActionId: ${menu.actionID}`);
    })
  }
}