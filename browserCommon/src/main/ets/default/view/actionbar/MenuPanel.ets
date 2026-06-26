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
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { ActionBarButton } from './ActionBarButton';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { ActionBarColorMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuController';
/* instrument ignore file  */
const TAG: string = 'common_MenuPanel';

/**
 * 菜单栏，包含右侧菜单和底部菜单
 */
@Component
export struct MenuPanel {
  @Prop colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  @Prop menuList: Action[] = [];
  @Prop flexibleMenuList: Action[] = [];
  onMenuClicked: Function = (): void => {
  };
  @Prop actionMoreMenuList: Action[] = [];
  @Prop totalSelectedCount: number = -1;
  @Prop isShowTransparent: boolean = false;
  @Prop isShowAddress: boolean = false;
  @Prop private isGroupDayView: boolean = false;
  @Prop immersiveController: ImmersiveController;
  @Prop timeController: TimeController;
  @State private isFirstUnHover: boolean = true;
  @State private firstTimer: number = -1;
  @Prop isPickerPhotoBrowser: boolean = false;
  private isImmersive: boolean = false;
  private isThirdSelectPhoto?: boolean = false;
  private isFromRealTime: boolean = false;
  private isSearchResultPage: boolean = false;
  @Prop private moreMenuList: Action[] = [];
  @Prop private creationMenuList: Action[] = [];
  @Prop private moreMenuListPC: RightClickMenuGroup[] = [];
  @Prop private showMovingPhotoCloseEffect: boolean = false;
  @Prop private movingPhotoEffectMode?: number = 0;
  @Prop albumInfo: AlbumInfo | undefined;
  private isFromCollage?: boolean = false;
  private isTimelinePageActionBar: boolean = false;
  actionMode = -1;
  @Prop selectMediaType: number;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear.');
  }

  build() {
    Row() {
      ForEach(this.menuList, (menu: Action, index: number): void => {
        ActionBarButton({
          res: menu.iconRes,
          action: menu,
          actionMode: this.actionMode,
          onMenuClicked: this.onMenuClicked,
          isAutoTint: menu.isAutoTint,
          colorMode: this.colorMode,
          totalSelectedCount: this.totalSelectedCount,
          actionMoreMenuList: this.actionMoreMenuList,
          isShowTransparent: this.isShowTransparent,
          isGroupDayView: this.isGroupDayView,
          immersiveController: this.immersiveController,
          timeController: this.timeController,
          isFirstUnHover: this.isFirstUnHover,
          firstTimer: this.firstTimer,
          isImmersive: this.isImmersive,
          isPickerPhotoBrowser: this.isPickerPhotoBrowser,
          isThirdSelectPhoto: this.isThirdSelectPhoto,
          moreMenuList: this.moreMenuList,
          creationMenuList: this.creationMenuList,
          moreMenuListPC: this.moreMenuListPC,
          flexibleMenuList: this.flexibleMenuList,
          showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
          movingPhotoEffectMode: this.movingPhotoEffectMode,
          isLast: index === this.menuList.length - 1,
          length: this.menuList.length,
          isFromCollage: this.isFromCollage,
          isTimelinePageActionBar: this.isTimelinePageActionBar,
          isFromRealTime: this.isFromRealTime,
          isSearchResultPage: this.isSearchResultPage,
          albumInfo: this.albumInfo,
          selectMediaType: this.selectMediaType,
        })
      }, (menu: Action) => String(menu.actionID))
    }
    .padding({
      top: DeviceInfo.isTv() ? 16 : $r('sys.float.padding_level4'),
      bottom: DeviceInfo.isTv() ? 11 : $r('sys.float.padding_level4'),
    })
    .alignSelf(ItemAlign.Start)
    .alignItems((this.isShowAddress && !DeviceInfo.isPc()) ? VerticalAlign.Top : VerticalAlign.Center)
    .height(DeviceInfo.isPc() ? Constants.WindowDecorHeight : 'auto')
    .key(TAG)
  }

  private onBuildDone(): void {
    Log.info(TAG, `onBuildDone, menu's size: ${this.menuList.length}`);
  }
}