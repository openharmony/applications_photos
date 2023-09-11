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
import {
  Action,
  ActionBarProp,
  AlbumDefine,
  AlbumSetDataInfo,
  AlbumSetDataSource,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  CommonObserverCallback,
  Constants,
  Log,
  MediaObserver,
  ScreenManager,
  ThirdSelectManager,
  UiUtil,
  UserFileManagerAccess
} from '@ohos/common';
import { NoPhotoIndexComponent } from '@ohos/common/CommonComponents';
import { ThirdAlbumGridItem } from './ThirdAlbumGridItem';
import { ThirdSelectedPageActionBar } from './ThirdSelectedPageActionBar';
import { IS_SIDE_BAR, IS_SPLIT_MODE, LEFT_BLANK, SelectParams } from '../utils/ThirdSelectConstants';

const TAG: string = 'thiSel_ThirdSelectAlbumPageBase';

// Third Select AlbumSet Page
@Component
export struct ThirdSelectAlbumPageBase {
  @State isEmpty: boolean = false;
  albums: AlbumSetDataSource;
  @State totalSelectedCount: number = 0;
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide isSelectedMode: boolean = true;
  @Provide moreMenuList: Array<Action> = new Array<Action>();
  selectManager: ThirdSelectManager;
  @Provide gridColumnsCount: number = 3;
  isActive = false;
  @StorageLink(IS_SPLIT_MODE) isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink(LEFT_BLANK) leftBlank: [number, number, number, number]
    = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @StorageLink(IS_SIDE_BAR) isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  @State title: string = '';
  isFirstEnter: boolean;
  @Prop @Watch('onPageChanged') pageStatus: boolean;
  @Provide selectParams: SelectParams = SelectParams.defaultParam();
  scroller: Scroller = new Scroller();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  aboutToAppear(): void {
    this.albums = new AlbumSetDataSource(this.broadCast);
    let param: any = router.getParams();
    this.initSelectParams(param);
    if (this.selectParams.isFromFa) {
      this.selectParams.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_IMAGE;
    }
    if (this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
      let userFile: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      this.albums.setBlackList([userFile.getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE),
      userFile.getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE),
      userFile.getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)]);
    }
    this.albums.setFilterMediaType(this.selectParams.filterMediaType);
    this.selectManager = AppStorage.Get(Constants.THIRD_SELECT_MANAGER);
    this.onMenuClicked = this.onMenuClicked.bind(this);
    Log.debug(TAG, `select params ${JSON.stringify(this.selectParams)}`);
    this.broadCast.on(Constants.ON_LOADING_FINISHED, (size: number) => {
      Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
      if (size === 1 && this.albums.mediaSetList[0].albumName === AlbumDefine.ALBUM_ID_RECYCLE) {
        this.isEmpty = true;
      } else {
        this.isEmpty = size == 0;
      }
    });
    if (this.selectParams.isMultiPick) {
      this.selectManager.registerCallback('thirdSelectUpdateCount', (newState: number) => {
        Log.info(TAG, `thirdSelectUpdateCount ${newState}`);
        this.totalSelectedCount = newState;
      });
    }
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.initGridRowCount = this.initGridRowCount.bind(this);
    this.initGridRowCount();
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.Get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.initGridRowCount);
    }
    let titleRes = ActionBarProp.SINGLE_TAB_ALBUM_TITLE;
    UiUtil.getResourceString(titleRes).then((stringResource) => {
      this.title = stringResource;
    })
  }

  onPageChanged() {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onPageShow() {
    Log.debug(TAG, 'onPageShow');
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.onActive();
  }

  aboutToDisappear() {
    this.broadCast.off(null, null);
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.initGridRowCount);
    this.initGridRowCount = null;
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataObserver.clearSource();
  }

  onMediaLibDataChange(changeType) {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.albums.onChange(changeType);
  }

  onPageHide() {
    Log.debug(TAG, 'onPageHide');
    this.onInActive();
  }

  onActive() {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      this.albums && this.albums.onActive();
    }
  }

  onInActive() {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
      this.albums && this.albums.onInActive();
    }
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    switch (action.actionID) {
      case Action.BACK.actionID:
        router.back();
        break;
      default:
        break;
    }
  }

  @Builder buildItem(item) {
    ThirdAlbumGridItem({
      item: item.data,
      isFirstEnter: this.isFirstEnter
    })
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start
    }) {
      ThirdSelectedPageActionBar({
        leftAction: Action.BACK,
        isSelectPhotoGrid: false,
        title: $title,
        onMenuClicked: this.onMenuClicked,
        totalSelectedCount: $totalSelectedCount
      })
      Stack() {
        if (this.isEmpty) {
          NoPhotoIndexComponent({ index: Constants.ALBUM_PAGE_INDEX, hasBarSpace: false })
        }
        Grid(this.scroller) {
          LazyForEach(this.albums, (item: AlbumSetDataInfo, index?: number) => {
            if (item.data.albumName != AlbumDefine.ALBUM_ID_RECYCLE) {
              GridItem() {
                this.buildItem(item)
              }
            }
          }, (item: AlbumSetDataInfo, index: number) => {
            return item.data.getHashCode() + index;
          })
        }
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Auto)
        .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
        .padding({
          left: $r('sys.float.ohos_id_card_margin_start'),
          right: $r('sys.float.ohos_id_card_margin_end'),
          top: $r('app.float.album_set_page_padding_top'),
          bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed')
        })
        .columnsGap($r('sys.float.ohos_id_card_margin_middle'))
        .rowsGap($r('sys.float.ohos_id_elements_margin_vertical_l'))
      }
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .padding({
      top: this.leftBlank[1],
      bottom: this.leftBlank[3]
    })
  }

  private initSelectParams(param) {
    if (param != null) {
      this.selectParams.bundleName = param.bundleName;
      this.selectParams.isMultiPick = param.isMultiPick;
      if (param.isFromFa != undefined || param.isFromFa != null) {
        this.selectParams.isFromFa = param.isFromFa;
      }
      if (param.isFromFaPhoto != undefined || param.isFromFaPhoto != null) {
        this.selectParams.isFromFaPhoto = param.isFromFaPhoto;
      }
      if (param.filterMediaType != undefined || param.filterMediaType != null) {
        this.selectParams.filterMediaType = param.filterMediaType;
      }
      if (param.isFirstEnter != undefined || param.isFirstEnter != null) {
        this.isFirstEnter = param.isFirstEnter;
      }
      this.selectParams.isFromWallpaper = param.isFromWallpaper;
      if (this.selectParams.isFromWallpaper) {
        this.selectParams.maxSelectCount = param.remainingOfWallpapers;
      } else if (!!param.maxSelectCount && param.maxSelectCount > 0) {
        this.selectParams.maxSelectCount = param.maxSelectCount > Constants.LIMIT_MAX_THIRD_SELECT_COUNT
          ? Constants.LIMIT_MAX_THIRD_SELECT_COUNT
          : param.maxSelectCount;
      }
      Log.info(TAG, `select param ${JSON.stringify(this.selectParams)}`);
    }
  }

  private initGridRowCount(): void {
    this.gridColumnsCount = UiUtil.getAlbumGridCount(false);
    Log.info(TAG, `the grid count in a line is: ${this.gridColumnsCount}`);
  }
}