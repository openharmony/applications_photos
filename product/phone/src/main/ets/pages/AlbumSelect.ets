/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { AlbumSelectGridItemNewStyle, NewAlbumPageActionBar } from '@ohos/browser/BrowserComponents';
import {
  Action,
  AlbumSetDataInfo,
  AlbumSetDataSource,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  Log,
  MediaDataSource,
  ScreenManager,
  SelectManager,
  TraceControllerUtils,
  UiUtil,
  UserFileManagerAccess
} from '@ohos/common';
import { NoPhotoComponent } from '@ohos/common/CommonComponents';

const TAG: string = 'AlbumSelect';

interface Params {
  albumName: string;
  albumUri: string;
  isNewAlbum: boolean;
};

@Entry
@Component
export struct AlbumSelect {
  @State isEmpty: boolean = false;
  @State gridColumnsCount: number = 0;
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide('selectedCount') totalSelectedCount: number = 0;
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  private isActive = false;
  private scroller: Scroller = new Scroller();
  private albums: AlbumSetDataSource = new AlbumSetDataSource(this.broadCast);
  private dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
  private mSelectManager = new SelectManager();
  private currentAlbumUri: string = '';
  private newAlbumName: string = '';
  private onWindowSizeChangeFunc: Function = (): void => this.onWindowSizeChange();
  private onLoadingFinshedFunc: Function = (size: number): void => this.onLoadingFinshed(size);

  private onLoadingFinshed(size: number): void {
    Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
    this.isEmpty = size == 0;
  }

  private onWindowSizeChange(): void {
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.get<string>('deviceType') !== Constants.DEFAULT_DEVICE_TYPE) {
      // Waiting: 后续phone的宫格页，支持横竖屏后，再放开
      this.gridColumnsCount = UiUtil.getAlbumGridCount(false);
    }
  }

  aboutToAppear(): void {
    TraceControllerUtils.startTrace('AlbumSetPageAboutToAppear');
    this.broadCast.on(Constants.ON_LOADING_FINISHED, this.onLoadingFinshedFunc);
    this.albums = new AlbumSetDataSource(this.broadCast);
    this.onActive();
    this.gridColumnsCount = UiUtil.getAlbumGridCount(false);
    Log.info(TAG, `the grid count in a line is: ${this.gridColumnsCount}`);
    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeFunc);

    let param: Params = router.getParams() as Params;
    if (param) {
      this.newAlbumName = param.albumName;
      this.currentAlbumUri = param.albumUri;
      if (param.isNewAlbum) {
        AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM, true);
      } else {
        AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM, false);
      }
    }
    this.albums.setBlackList([this.currentAlbumUri, UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE)]);
    Log.info(TAG, `the album uri is: ${this.currentAlbumUri}`);
    AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_TARGET, this.newAlbumName);
    AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_TARGET_URI, this.currentAlbumUri);
    AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_SELECTED, this.mSelectManager);
    TraceControllerUtils.finishTrace('AlbumSetPageAboutToAppear');
  }

  aboutToDisappear(): void {
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeFunc);
    this.broadCast.off(Constants.ON_LOADING_FINISHED, this.onLoadingFinshedFunc);
    this.albums.setBlackList([]);
    this.dataSource.releaseBroadCast();
  }

  onPageShow() {
    BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.onActive();
  }

  onPageHide() {
    this.onInActive();
  }

  // Callback when the page is in the foreground
  onActive() {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      this.albums && this.albums.onActive();
      this.dataSource && this.dataSource.onActive();
      this.dataSource.forceUpdate();
    }
  }

  // Callback when the page is in the background
  onInActive() {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
      this.albums && this.albums.onInActive();
    }
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start
    }) {
      NewAlbumPageActionBar({ onMenuClicked: (action: Action): void => this.onMenuClicked(action) })

      Stack() {
        if (this.isEmpty) {
          NoPhotoComponent({ title: $r('app.string.title_no_albums') })
        }
        Grid(this.scroller) {
          LazyForEach(this.albums, (item: AlbumSetDataInfo, index?: number) => {
            GridItem() {
              AlbumSelectGridItemNewStyle({
                item: item.data,
                mSelectManager: this.mSelectManager
              })
            }.key('SelectAlbum' + index)
          }, (item: AlbumSetDataInfo) => 'uri:' + item.data.uri)
        }
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Auto)
        .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
        .padding({
          top: $r('app.float.album_set_page_padding_top'),
          left: $r('sys.float.ohos_id_card_margin_start'),
          right: $r('sys.float.ohos_id_card_margin_end'),
          bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed')
        })
        .columnsGap($r('sys.float.ohos_id_card_margin_middle'))
        .rowsGap($r('sys.float.ohos_id_elements_margin_vertical_l'))
      }
    }
    .backgroundColor($r('app.color.default_background_color'))
    .padding({
      top: this.leftBlank[1],
      bottom: this.leftBlank[3]
    })
  }

  private onMenuClicked(action: Action): void {
    Log.debug(TAG, `onMenuClicked, action: ${action.actionID}`);
    if (action.actionID === Action.CANCEL.actionID) {
      Log.info(TAG, 'clear SelectManager data');
      this.mSelectManager.onModeChange(false);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
      router.back();
    }
    return;
  }
}
