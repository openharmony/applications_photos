/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { MediaOperationType } from '../../model/common/MediaOperationType';
import { MediaOperationActionBar } from './MediaOperationActionBar';
import { Log } from '../../utils/Log';
import { BroadCast } from '../../utils/BroadCast';
import { AlbumSetNewMenuOperation } from './AlbumSetNewMenuOperation';
import { MenuOperationFactory } from '../../interface/MenuOperationFactory';
import { AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { AlbumListCard } from './AlbumListCard';
import { MenuContext } from './MenuContext';
import { Action } from './Action';
import { JumpSourceToMain } from '../../model/browser/photo/JumpSourceToMain';
import { CustomDialogView } from '../dialog/CustomDialogView';
import { AlbumDefine } from '../../model/browser/AlbumDefine';
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';
import { AlbumSetDataInfo } from '../../model/common/AlbumSetDataInfo';
import { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { MediaItem } from '../../model/browser/photo/MediaItem';
import { UiUtil } from '../../utils/UiUtil';

const TAG: string = 'common_MediaOperationBasePage';

@Component
export struct MediaOperationBasePage {
  @StorageLink('leftBlank') leftBlank: number[]
    = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @Provide pageType: string = MediaOperationType.Move;
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide loadingFinish: boolean = false;
  @State screenHeight: number = ScreenManager.getInstance().getWinHeight();
  @State listCardWidth: number = 0;
  @State listCardPaddingBottom: number = 24;
  scroller: Scroller = new Scroller();
  albums: AlbumSetDataSource;
  isActive: boolean = false; // Whether the page is in the foreground
  sourceAlbumUri: string;
  currentAlbum: AlbumInfo;
  private pageFrom: string;
  private selectedItems: Array<MediaItem> = [];
  private mediaType: number;
  private listCardBorderRadius: number = 16;
  onWindowSizeChangeCallBack = () => this.updateListCardWidth();

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear`);
    UiUtil.getResourceNumber($r('sys.float.ohos_id_default_padding_bottom_fixed')).then((value: number) => {
      this.listCardPaddingBottom = px2vp(value);
    });
    this.albums = new AlbumSetDataSource(this.broadCast, { moreInfo: true });
    this.albums.setMultiParameter(true);
    let param: any = router.getParams();
    if (param) {
      Log.info(TAG, `router getParams ${JSON.stringify(param)}`);
      this.pageType = param.pageType;
      this.pageFrom = param.pageFrom
      this.currentAlbum = param.albumInfo;
      if (this.currentAlbum != null) {
        this.sourceAlbumUri = this.currentAlbum.uri;
      }
      switch (this.pageFrom) {
        case Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER:
          this.mediaType = param.mediaType;
          break;
        case Constants.MEDIA_OPERATION_FROM_TIMELINE:
          this.selectedItems = param.selectedItems;
          break;
        case Constants.MEDIA_OPERATION_FROM_PHOTO_GRID:
          this.selectedItems = param.selectedItems;
          break;
        default:
          break;
      }
    }
    this.albums.setFilterAlbumsFunction(this.filterAlbumInList.bind(this));
    this.onActive();
    this.onMenuClicked = this.onMenuClicked.bind(this);

    this.broadCast.on(Constants.ON_LOADING_FINISHED, (totalCount) => {
      this.loadingFinish = true;
    });

    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);

    this.broadCast.on(BroadCastConstants.MEDIA_OPERATION, (displayName: string, albumUri: string, completedFunc?: Function) => {
      Log.info(TAG, `broadCast on mediaOperation, albumName: ${displayName}, albumUri: ${albumUri}`);
      router.back({
        url: '',
        params: {
          pageType: this.pageType,
          albumName: displayName,
          albumUri: albumUri
        }
      });
      completedFunc && completedFunc();
    });
    this.albums.updateAlbumMediaCount();
    this.updateListCardWidth();
    Log.info(TAG, `album mediaSet ${this.albums.mediaSetList}`);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.broadCast.off(null, null);
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.onWindowSizeChangeCallBack = null;
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, actionID: ${action.actionID}`);

    switch (action.actionID) {
      case Action.CANCEL.actionID:
        router.back({
          url: '',
          params: {}
        });
        break;
      case Action.NEW.actionID:
        this.createNewAlbum();
        break;
      default:
        break;
    }
  }

  createNewAlbum() {
    Log.info(TAG, 'createNewAlbum');
    let menuContext = new MenuContext();
    this.onOperationStart = this.onOperationStart.bind(this);
    this.onOperationEnd = this.onOperationEnd.bind(this);
    menuContext
      .withOperationStartCallback(this.onOperationStart)
      .withOperationEndCallback(this.onOperationEnd)
      .withAlbumSetDataSource(this.albums)
      .withAlbumInfo(this.currentAlbum)
      .withBroadCast(this.broadCast)
      .withJumpSourceToMain(JumpSourceToMain.ALBUM);
    let menuOperation
      = MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewMenuOperation, menuContext);
    menuOperation.doAction();
  }

  onOperationStart() {
  }

  onOperationEnd() {
  }

  updateListCardWidth(): void {
    let screenColumns: number = ScreenManager.getInstance().getScreenColumns();
    Log.info(TAG, `updateListCardWidth start ${screenColumns}`);
    if (screenColumns == ColumnSize.COLUMN_FOUR) {
      this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_FOUR);
    } else if (screenColumns == ColumnSize.COLUMN_EIGHT) {
      this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_SIX);
    } else if (screenColumns == ColumnSize.COLUMN_TWELVE) {
      this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_EIGHT);
    } else {
      Log.error(TAG, 'screenColumns is not init');
    }
    Log.info(TAG, `updateListCardWidth ${this.listCardWidth}`);
  }

  // Callback when the page is in the foreground
  onActive() {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      this.albums && this.albums.onActive();
    }
  }

  isSelectedItemsContainsVideo(): boolean {
    for (let i = 0; i < this.selectedItems.length; i++) {
      let item = this.selectedItems[i];
      if (item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        Log.info(TAG, 'Selected items contains video.');
        return true;
      }
    }
    Log.info(TAG, 'Selected items are all images.');
    return false;
  }

  filterAlbumInList(mediaSetList: AlbumInfo[]): Array<AlbumInfo> {
    Log.info(TAG, 'Judge if the album be shown.');
    if (!mediaSetList) {
      Log.warn(TAG, 'Album data info undefined');
      return [];
    }
    let res = mediaSetList.filter((item) => {
      return!item.isSystemAlbum && item.uri !== this.sourceAlbumUri;
    });
    return res;
  }

  getBorderRadius(index: number): BorderRadiuses {
    if (index === 0 && index + 1 === this.albums.totalCount()) {
      return {
        topLeft: this.listCardBorderRadius,
        topRight: this.listCardBorderRadius,
        bottomLeft: this.listCardBorderRadius,
        bottomRight: this.listCardBorderRadius
      };
    } else if (index + 1 === this.albums.totalCount()) {
      return { bottomLeft: this.listCardBorderRadius, bottomRight: this.listCardBorderRadius };
    } else if (index === 0) {
      return { topLeft: this.listCardBorderRadius, topRight: this.listCardBorderRadius };
    }
  }

  build() {
    Column() {
      MediaOperationActionBar({ onMenuClicked: this.onMenuClicked })

      Stack() {
        List({ scroller: this.scroller }) {
          LazyForEach(this.albums, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
            ListItem() {
              AlbumListCard({
                item: albumSetDataInfo.data,
                index: albumSetDataInfo.index
              })
            }
            .key('MediaOperationPageAlbum' + index)
            .width(this.listCardWidth)
            .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
            .padding({
              left: $r('app.float.list_card_margin')
            })
            .borderRadius(this.getBorderRadius(index))
          }, (item) => item.data.id)
        }
        .alignListItem(ListItemAlign.Center)
        .padding({
          top: $r('app.float.album_let_page_padding_top'),
          bottom: this.leftBlank[3] + this.listCardPaddingBottom
        })
        .scrollBar(BarState.Auto)
        .height(Constants.PERCENT_100)
        .width(Constants.PERCENT_100)
      }
      .height(Constants.PERCENT_100)

      CustomDialogView({ broadCast: $broadCast })
    }
    .backgroundColor($r('app.color.default_background_color')) // ux: colorSubBackground
    .height(Constants.PERCENT_100)
    .padding({
      top: this.leftBlank[1],
      bottom: this.leftBlank[3] + Constants.ActionBarHeight
    })
  }
}