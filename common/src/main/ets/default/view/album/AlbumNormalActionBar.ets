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

import lazy { Action } from '../../../default/view/browserOperation/Action';
import lazy { ActionBarMode } from '../../../default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '../../../default/view/browserOperation/ActionBarProp';
import lazy { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy { isOrientationHorizontal } from '../../../default/model/common/ScreenManager';
import lazy { Log } from '../../../default/utils/Log';
import lazy { UiUtil } from '../../../default/utils/UiUtil';
import lazy { ActionBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy { Router } from '@ohos.arkui.UIContext';

/* instrument ignore file */
const TAG: string = 'AlbumNormalActionBar';

@Component
export struct AlbumNormalActionBar {
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  public title: Resource | string = '';
  public albumInfo: AlbumInfo | null = null;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @Provide albumsShow: boolean = false;
  @State totalSelectedCount: number = 0;
  @State actionMoreMenuList: Action[] = [];
  @Prop private moreMenuList: Action[] = [];

  aboutToAppear(): void {
    this.actionBarProp = this.updateActionBarProp();
  }

  private updateActionBarProp(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle(this.getTitle(this.albumInfo))
      .setMode(ActionBarMode.STANDARD_MODE);

    actionBarProp.setMenuList(menuList);
    this.actionBarProp = actionBarProp;
    return actionBarProp;
  }

  onMenuClicked(action: Action): void {
    if (action.actionID === Action.BACK.actionID) {
      AppStorage.get<Router>('router')?.back({
        url: '',
      });
    }
  }

  build() {
    Column() {
      ActionBar({
        actionBarProp: $actionBarProp,
        isNeedPlaceholder: false,
        onMenuClicked: this.onMenuClicked,
        totalSelectedCount: this.totalSelectedCount,
        actionMoreMenuList: this.actionMoreMenuList,
        moreMenuList: this.moreMenuList,
      })
    }
    .padding({
      top: this.isHorizontal ? 0 : px2vp(this.statusBarHeight),
    })
  }

  private getTitle(albumInfo: AlbumInfo | null): Resource | string {
    if (albumInfo) {
      let res = UiUtil.getDisplayNameResourceByAlbumInfo(albumInfo);
      if (res != null) {
        Log.error(TAG, `getTitle ret res = ${res}`);
        return res;
      }
    }
    Log.error(TAG, `getTitle ret title = ${this.title}`);
    return this.title;
  }
}