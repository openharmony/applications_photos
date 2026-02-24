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

import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { IS_SIDE_BAR, IS_SPLIT_MODE, LEFT_BLANK } from '../utils/ThirdSelectConstants';
import lazy {
  AlbumThirdSelectDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumThirdSelectDataSource';
import lazy { Router } from '@ohos.arkui.UIContext';

/* instrument ignore file */
const TAG: string = 'thiSel_ThirdSelectAlbumListPadBase';

interface ParamsSelect {
  bundleName: string;
  isMultiPick: boolean;
  isFromFa: boolean;
  isFromFaPhoto: boolean;
  filterMediaType: string;
  isFirstEnter: boolean;
  isFromWallpaper: boolean;
  remainingOfWallpapers: number;
  maxSelectCount: number;
  cameraAble: boolean;
};

// Third Select AlbumSet Page
@Component
export struct ThirdSelectAlbumListPadBase {
  @Consume isAllEmpty: boolean;
  @Link selectedCount: number;
  @Consume broadCast: BroadCast;
  public selectManager: ThirdSelectManager | undefined = undefined;
  @State gridRowCount: number = 3;
  @StorageLink(IS_SPLIT_MODE) isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink(LEFT_BLANK) leftBlank: number[] = getScreen().getLeftBlank();
  @StorageLink(IS_SIDE_BAR) isSidebar: boolean = getScreen().isSidebar();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @State title: string = '';
  public isFirstEnter: boolean = false;
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @Provide selectParams: SelectParams | null = SelectParams.defaultParam();
  public scroller: Scroller = new Scroller();
  public param: ParamsSelect | undefined = undefined;
  public selectId: string = '';
  public cardWidth: number = 0;
  public cardHeight: number = 0;
  @State updateAlbumPhotoInfo: boolean = false;
  @Consume albumsShow: boolean;
  @Consume albumInfoAllCount: number;
  private albums: AlbumThirdSelectDataSource | null = null;
  @Consume isAlbumEmpty: boolean;
  @Consume isMediaEmpty: boolean;
  @Consume albumInfoAll: AlbumInfo;

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear albumInfoAllCount: ${this.albumInfoAllCount} isAlbumEmpty: ${this.isAlbumEmpty}`);
    WindowUtil.prepareWinRouter();
    if (this.selectParams !== null) {
      this.selectParams.cameraAble = this.param?.cameraAble ?? false;
    }
  }

  updateCardSize(): void {
    let contentWidth = getScreen().getWinWidth();
    let cardWidth = !DeviceInfo.isPc() ? contentWidth / 10 : 48;
    this.cardWidth = cardWidth;
    this.cardHeight = cardWidth;

    Log.info(TAG, `updateCardSize cardWidth is: ${this.cardWidth} cardHeight is: ${this.cardHeight} `);
  }

  onPageChanged(): void {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onPageShow(): void {
    Log.info(TAG, 'onPageShow');
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
  }

  onPageHide(): void {
    Log.debug(TAG, 'onPageHide');
  }

  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    if (action === Action.BACK) {
      AppStorage.get<Router>('router')?.back({
        url: '',
        params: {},
      });
    }
  }

  private handleClick(album: AlbumInfo): void {
    if (album.uri !== this.selectId) {
      if (this.selectParams?.isFromFa && (!this.selectParams.isFromFaPhoto)) {
        this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
          [album.albumName, album.uri, album.albumName, '', true]);
      } else {
        if (this.selectParams !== null) {
          let params: SelectParams = this.selectParams;
          params.isFirstEnter = false;
          params.itemDisplayName = album.albumName;
          params.itemCount = album.count;
          params.itemId = album.uri;
          params.uri = album.uri;
          params.itemCoverUri = album.coverUri;
          params.unionAlbumUris = album.unionAlbumUris;

          this.broadCast.emit(BroadCastConstants.SWITCH_THIRD_ALBUM,
            [params]);
          this.selectId = album.uri;
        }
      }
    } else {
      this.albumsShow = !this.albumsShow;
    }
  }

  @Builder
  buildItemNew() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
    }) {
      if (!this.isAllEmpty) {
        Menu() {
          // 所有照片
          if (!this.isMediaEmpty) {
            MenuItem({
              content: $r('app.string.album_all'),
              labelInfo: this.albumInfoAllCount.toString(),
            }) {
            }
            .selectIcon(true)
            .selected(this.selectId === this.albumInfoAll.uri)
            .onClick((): void => this.handleClick(this.albumInfoAll))
            .key('MenuItem_All')
          }

          if (!this.isAlbumEmpty) {
            MenuItemGroup() {
              LazyForEach(this.albums, (item: AlbumSetDataInfo, index?: number) => {
                MenuItem({
                  content: item.data.albumName,
                  labelInfo: String(this.selectParams?.filterMediaType === AlbumDefine
                    .FILTER_MEDIA_TYPE_VIDEO ? item.data.videoCount : item.data.count)
                }) {
                }
                .selectIcon(true)
                .selected(this.selectId === item.data.uri)
                .onClick((): void => this.handleClick(item.data))
                .key(`MenuItem_${index}`)
              }, (item: AlbumSetDataInfo) => `${item.data.uri}_${item.dateModified}`)
            }
          }
        }
        .padding({ top: 0 })
        .flexGrow(1)
        .padding({ bottom: 0 })
        .key('ThirdSelectAlbumListPadBase_Menu')
      }
    }
    .onDisAppear((): void => {
      this.albumsShow = false;
    })
    .onAppear((): void => {
      this.albumsShow = true;
    })
  }

  build() {
    this.buildItemNew();
  }
}
