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
import lazy { ActionBarMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy {
  AlbumThirdSelectDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumThirdSelectDataSource';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { ThirdSelectSingleTitle } from '@ohos/common/src/main/ets/default/view/actionbar/ThirdSelectSingleTitle';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { ActionBarButton } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBarButton';
import lazy { MenuPanel } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/MenuPanel';
import lazy { IS_HORIZONTAL } from '../utils/ThirdSelectConstants';
import lazy { ThirdSelectAlbumListPadBase } from './ThirdSelectAlbumListPadBase';

/* instrument ignore file */
const TAG: string = 'thiSel_ThirdSelectedPadActionBar ';

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

interface ThirdParams {
  isFirstEnter: boolean;
  itemDisplayName: string;
  itemCount: number;
  itemId: string;
  uri: string;
  itemCoverUri: string;
};

@Component
export struct ThirdSelectedPadActionBar {
  @StorageLink(IS_HORIZONTAL) @Watch('createActionBar') isHorizontal: boolean = isOrientationHorizontal();
  @State menuList: Action[] = [];
  public selectParams: SelectParams | undefined = undefined;
  @Link selectedCount: number;
  @Link @Watch('onSelectedCountChanged') totalSelectedCount: number;
  public isSelectPhotoGrid: boolean = false;
  onMenuClicked: Function = (): void => {
  };
  public leftAction: Action = Action.BACK;
  @Link @Watch('onSelectedCountChanged') title: string;
  @State @Watch('onActionBarPropChanged') actionBarProp: ActionBarProp = new ActionBarProp();
  public isFirstEnter: boolean = true;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  public currentSelectedAlbumId: string = '';
  @Provide isThirdSelect: boolean = true;
  @Provide albumName: string = '';
  public param: ParamsSelect | null = null;
  public selectId: string = '';
  @Consume broadCast: BroadCast;
  public selectManager: ThirdSelectManager | undefined = undefined;
  @Provide isAllEmpty: boolean = true;
  @State updateAlbumPhotoInfo: boolean = false;
  public dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  @Consume albumsShow: boolean;
  @Provide hidePopup: boolean = false;
  public albums: AlbumThirdSelectDataSource | null = null;
  public albumMedia: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
  @Provide isAlbumEmpty: boolean = true;
  @Provide isMediaEmpty: boolean = true;
  @Provide broadCastAll: BroadCast = new BroadCast();
  @Provide albumInfoAll: AlbumInfo = new AlbumInfo();
  @Provide albumInfoAllCount: number = 0;
  @State gridRowCount: number = 3;
  public cardWidth: number = 0;
  public cardHeight: number = 0;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public isNavTitle: boolean = false;
  private onDataReloadedFunc: Function = (): void => this.onReloadFinishedCallback();
  private onThirdSelectAlbumPhotosUpdateFunc: Function = (size: number):
    void => this.onThirdSelectAlbumPhotosUpdate(size);
  private onSwitchThirdAlbumFunc: Function = (params: ThirdParams): void => this.onSwitchThirdAlbum(params);
  private isNeedFilterSourceAlbum: boolean = false;
  private sourceAlbumUri: string = '';
  @State isSearchEnabled: boolean = false;
  @Prop @Watch('onSelectedOrSideChange') private isShowSideBar?: boolean = true;
  @Prop @Watch('onSelectedOrSideChange') private isSelected?: boolean = false;
  @State private titlePaddingLeft: number | Resource = this.getTitlePaddingLeft();
  @State private isFirstUnHover: boolean = true;
  @State private firstTimer: number = -1;
  @Prop private moreMenuList: Action[] = [];

  private onSelectedOrSideChange(): void {
    if (!DeviceInfo.isPc()) {
      return;
    }
    this.titlePaddingLeft = this.getTitlePaddingLeft();
  }

  private getTitlePaddingLeft(): number | Resource {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && !this.isSelected && this.isShowSideBar) {
      return !this.actionBarProp.getIsNavTitle() ? $r('sys.float.ohos_id_max_padding_start') : 0;
    }
    return !this.actionBarProp.getIsNavTitle() ? $r('sys.float.ohos_id_default_padding_start') : 0;
  }

  private onActionBarPropChanged(): void {
    this.menuList = this.actionBarProp.getMenuList();
  }

  private onLoadingFinished(size: number): void {
    this.albumInfoAll.coverUri = this.albumMedia.getFirstRawData()?.thumbnail ?? this.albumInfoAll.coverUri;
    // data concat
    this.isMediaEmpty = this.albumInfoAll.count <= 0;

    Log.error(TAG, `broadCast ON_LOADING_FINISHED size: ${size}`);
    if (size === 1 && this.albums?.mediaSetList[0]?.isTrashAlbum) {
      this.isAlbumEmpty = true;
    } else {
      this.isAlbumEmpty = size === 0;
    }
    if (!(this.isAlbumEmpty || this.isMediaEmpty)) {
      this.isAllEmpty = this.isAlbumEmpty || this.isMediaEmpty;
    }
    Log.error(TAG, `ON_LOADING_FINISHED isAllEmpty 2 : ${this.isAllEmpty}`);
  }

  private onThirdSelectAlbumPhotosUpdate(size: number): void {
    this.onLoadingFinished(size);
    Log.debug(TAG, `Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE updateAlbumPhotoInfo is ${this.updateAlbumPhotoInfo}`);
    this.updateAlbumPhotoInfo = true;
    Log.debug(TAG, `Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE updateAlbumPhotoInfo is ${this.updateAlbumPhotoInfo}`);
  }

  private onSwitchThirdAlbum(params: ThirdParams): void {
    this.isFirstEnter = params.isFirstEnter;
    this.currentSelectedAlbumId = params.itemId;
    this.createActionBar();
  }

  aboutToDisappear(): void {
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.broadCast?.off(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, this.onThirdSelectAlbumPhotosUpdateFunc);
    this.broadCastAll?.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedFunc);
    this.broadCast.off(BroadCastConstants.SWITCH_THIRD_ALBUM, this.onSwitchThirdAlbumFunc);
  }

  onPageShow(): void {
    Log.info(TAG, 'onPageShow');
    this.albumInfoAll.albumName = $r('app.string.album_all');
  }

  private filterSourceAlbum(mediaSetList: AlbumInfo[]): AlbumInfo[] {
    if (!mediaSetList) {
      Log.warn(TAG, 'Album data info undefined');
      return [];
    }
    let res = mediaSetList.filter((item) => {
      return item.uri !== this.sourceAlbumUri;
    });
    return res;
  }

  aboutToAppear(): void {
    Log.error(TAG, 'aboutToAppear');
    this.onSelectedCountChanged();

    this.isAllEmpty = true;
    this.isAlbumEmpty = true;
    this.isMediaEmpty = true;
    Log.error(TAG, 'albumByTypeList init');

    this.albums = new AlbumThirdSelectDataSource(this.broadCast, getContext(this));
    this.initSelectParams(this.param);
    if (this.selectParams !== null) {
      if (this.selectParams?.isFromFa) {
        this.selectParams.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_IMAGE;
      }
      if (this.selectParams?.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
        this.albums.setBlackList([UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE)]);
      }
      this.albumMedia.setFilterMediaType(this.selectParams?.filterMediaType ?? '');
      this.albums.setFilterMediaType(this.selectParams?.filterMediaType ?? '');
      if (this.isNeedFilterSourceAlbum) {
        this.albums.setFilterAlbumsFunction((mediaSetList: AlbumInfo[]): AlbumInfo[] => {
          return this.filterSourceAlbum(mediaSetList);
        });
      }
    }

    this.albumMedia.setAlbumUri('');

    this.albumMedia.setBroadCast(this.broadCastAll);
    this.albumInfoAll.uri = '';
    this.albumInfoAll.albumName = $r('app.string.album_all');

    this.selectManager =
      LocalStorage.getShared()?.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER) as ThirdSelectManager;
    Log.error(TAG, `select params ${JSON.stringify(this.selectParams)}`);

    this.albumMedia.addLoadingListener(this);

    this.broadCastAll.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedFunc);

    this.broadCast.on(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, this.onThirdSelectAlbumPhotosUpdateFunc);

    if (this.selectParams?.isMultiPick) {
      this.selectManager?.registerCallback('thirdSelectUpdateCount', (newState: number) => {
        Log.info(TAG, `thirdSelectUpdateCount ${newState}`);
        this.selectedCount = newState;
      });
    }

    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.initGridRowCount();

    this.albums.initData();
    this.albumMedia.initData();
    this.updateCardSize();
    Log.error(TAG, 'albumByTypeList end');

    this.broadCast.on(BroadCastConstants.SWITCH_THIRD_ALBUM, this.onSwitchThirdAlbumFunc);
  }

  onSizeLoadingFinished(size: number): void {
    this.albumInfoAll.count = size;
    this.albumInfoAll.videoCount = size;
    this.albumInfoAllCount = size;
  }

  onDataChanged(dataIndex: number): void {
  }

  public onDataLoadingFinished(): void {
    Log.info(TAG, 'ON_DATA_RELOADED onDataLoadingFinished');

    this.albumInfoAll.coverUri = this.albumMedia.getFirstRawData()?.thumbnail ?? this.albumInfoAll.coverUri;
    this.isMediaEmpty = this.albumInfoAll.count <= 0;

    if (!(this.isAlbumEmpty || this.isMediaEmpty)) {
      this.isAllEmpty = this.isAlbumEmpty || this.isMediaEmpty;
    }
  }

  private initSelectParams(param: ParamsSelect | null): void {
    if (param !== null) {
      if (this.selectParams != null) {
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
        this.selectParams.isFromWallpaper = param.isFromWallpaper;
        if (this.selectParams.isFromWallpaper) {
          this.selectParams.maxSelectCount = param.remainingOfWallpapers;
        } else if (param.maxSelectCount && param.maxSelectCount > 0) {
          this.selectParams.maxSelectCount = Math.min(param.maxSelectCount, Constants.LIMIT_MAX_THIRD_SELECT_COUNT);
        }
      }
      if (param.isFirstEnter !== undefined || param.isFirstEnter !== null) {
        this.isFirstEnter = param.isFirstEnter;
      }

      Log.info(TAG, `select param ${JSON.stringify(this.selectParams)}`);
    }
  }

  private onReloadFinishedCallback(): void {
    Log.info(TAG, 'ON_DATA_RELOADED onReloadFinishedCallback');

    this.albumInfoAll.coverUri = this.albumMedia.getFirstRawData()?.thumbnail ?? this.albumInfoAll.coverUri;

    this.isMediaEmpty = this.albumInfoAll.count <= 0;

    if (!(this.isAlbumEmpty || this.isMediaEmpty)) {
      this.isAllEmpty = this.isAlbumEmpty || this.isMediaEmpty;
    }
  }

  updateCardSize(): void {
    let contentWidth = getScreen().getWinWidth();
    let cardWidth = !DeviceInfo.isPc() ? contentWidth / 10 : 48;
    this.cardWidth = cardWidth;
    this.cardHeight = cardWidth;

    Log.info(TAG, `updateCardSize cardWidth is: ${this.cardWidth} cardHeight is: ${this.cardHeight} `);
  }

  private initGridRowCount(): void {
    let contentWidth = getScreen().getWinWidth();
    let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
    this.gridRowCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
      / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    this.isAllEmpty = true;
    this.isAlbumEmpty = true;
    this.isMediaEmpty = true;
    this.albums?.onNotify(nfyInfo);
    this.albumMedia.initData();
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
  }

  onSelectedCountChanged(): void {
    this.selectedCount = this.totalSelectedCount;
    this.menuList = [];
    this.createActionBar();
  }

  private createActionBar(): void {
    Log.info(TAG, `createActionBar this.title ${this.title}`);
    this.albumName = this.title;

    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(!this.isNavTitle ? this.leftAction : Action.NONE)
      .setTitle(this.title)
      .setIsNavTitle(this.isNavTitle)
      .setMenuList(this.menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setBackgroundColor($r('sys.color.background_secondary'))
      .setMaxSelectCount(this.selectParams?.maxSelectCount ?? 0);
    this.actionBarProp = actionBarProp;
  }

  @Builder
  buildMenu() {
    ThirdSelectSingleTitle({ actionBarProp: $actionBarProp }).key('ThirdSelectSingleTitle')
      .bindMenu(this.buildAlbums, {
        placement: Placement.BottomLeft,
        offset: { x: 0, y: 0 },
      })
  }

  @Builder
  buildAlbums() {
    if (!this.isAllEmpty) {
      ThirdSelectAlbumListPadBase({
        param: this.selectParams,
        pageStatus: true,
        selectId: this.currentSelectedAlbumId,
        selectedCount: $selectedCount,
        selectManager: this.selectManager,
        selectParams: this.selectParams,
        albums: this.albums,
      }).zIndex(Constants.STEP_DEFAULT).animation({
        duration: Constants.PRESS_ANIM_DURATION * Constants.STEP_DEFAULT,
        curve: Curve.FastOutSlowIn,
      })
        .borderRadius(8)
    }
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
    }) {
      ActionBarButton({
        res: this.actionBarProp.getLeftAction().iconRes,
        action: this.actionBarProp.getLeftAction(),
        onMenuClicked: this.onMenuClicked,
        isAutoTint: this.actionBarProp.getLeftAction().isAutoTint,
        colorMode: this.actionBarProp.getColorMode(),
        isThirdSelectActionBar: true,
        isFirstUnHover: this.isFirstUnHover,
        firstTimer: this.firstTimer,
        moreMenuList: this.moreMenuList,
      })
        .margin({
          left: this.actionBarProp.getLeftAction()
            .componentKey === undefined ? 0 : $r('sys.float.ohos_id_default_padding_start'),
          right: this.actionBarProp.getLeftAction()
            .componentKey === undefined ? 0 : $r('app.float.action_bar_button_margin_right')
        })
      Row() {
        // title and arrow
        Stack({ alignContent: Alignment.Start }) {
          // menu
          this.buildMenu();
        }.flexGrow(1)

        MenuPanel({
          menuList: this.menuList,
          colorMode: this.actionBarProp.getColorMode(),
          onMenuClicked: this.onMenuClicked,
          moreMenuList: this.moreMenuList,
        })
      }.flexGrow(1)
    }
    .height($r('app.float.album_set_tab_bar_height'))
    .zIndex(3)
    .width(Constants.PERCENT_100)
    .opacity(this.actionBarProp.getAlpha())
    .padding({ left: 0 })
    .padding({
      left: this.titlePaddingLeft,
    })
    .margin({
      right: this.menuList.length === 0 ? 0 : $r('sys.float.padding_level2')
    })
  }
}