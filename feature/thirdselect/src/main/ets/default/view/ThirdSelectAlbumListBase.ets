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
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { DiggingHoleCameraArea, getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { SelectParams, SelectConstants } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { IS_SIDE_BAR, IS_SPLIT_MODE, LEFT_BLANK } from '../utils/ThirdSelectConstants';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { NoPhotoComponent } from '@ohos/common/src/main/ets/default/view/NoPhotoComponent';
import lazy { PickerSelectTip } from './PickerSelectTip';
import lazy { PickerViewWarningDialog } from '@ohos/common/src/main/ets/default/view/dialog/PickerViewWarningDialog';
import lazy { AppPresenceStatus, PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import type { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import lazy { FontUtil } from '@ohos/common/src/main/ets/default/utils/FontUtil';
import lazy {
  PickerSelectAlbumDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/PickerSelectAlbumDataSource';
import lazy { PickerAlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/PickerAlbumInfo';

/* instrument ignore file */
const TAG: string = 'thiSel_ThirdSelectAlbumListBase';

const TEXT_MAX_LINE = 1;
const TEXT_COLUMN_SPACE = 4;
const TV_TEXT_COLUMN_SPACE = 5;
const TEXT_SAFE_MARGIN = 8;
const TV_TEXT_SAFE_MARGIN = 11;
const NORMAL_ITEM_ROW_SPACE = 16;
const TV_NORMAL_ITEM_ROW_SPACE = 21;
const FOOTER_SAFERY_WIDTH: number = 72;
const PICKER_WARNING_DIALOG_HEIGHT: number = 84;

/**
 * 接口定义
 */
interface ParamsSelect {
  bundleName: string;
  tokenId: number;
  isMultiPick: boolean;
  isFromFa: boolean;
  isFromFaPhoto: boolean;
  filterMediaType: string;
  isFirstEnter: boolean;
  isFromWallpaper: boolean;
  remainingOfWallpapers: number;
  maxSelectCount: number;
  cameraAble: boolean;
  isOriginalSupported: boolean;
  isPreviewForSingleSelectionSupported: boolean;
  singleSelectionMode: number;
  completeButtonText: number;
  recommendationType: number;
};

/**
 * Third Select AlbumSet Page
 */
@Component
export struct ThirdSelectAlbumListBase {
  userId: number = -1;
  // 相册的第三方选择数据源
  public albums: PickerSelectAlbumDataSource | undefined = undefined;
  @Link selectedCount: number;
  @Consume broadCast: BroadCast;
  @Provide broadCastAll: BroadCast = new BroadCast();
  public selectManager: ThirdSelectManager | undefined = undefined;
  @State gridRowCount: number = 3;
  public isActive = false;
  @StorageLink(IS_SPLIT_MODE) isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink(LEFT_BLANK) leftBlank: number[] = getScreen().getLeftBlank();
  @Prop private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink(IS_SIDE_BAR) isSidebar: boolean = getScreen().isSidebar();
  public dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  @State title: string = '';
  public isFirstEnter: boolean = false;
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @Provide selectParams: SelectParams = SelectParams.defaultParam();
  public scroller: Scroller = new Scroller();
  public albumScroller: Scroller = new Scroller();
  public param: ParamsSelect | undefined = undefined;
  @State selectId: string = '';
  public cardWidth: number = 0;
  public cardHeight: number = 0;
  @State updateAlbumPhotoInfo: boolean = false;
  @Consume albumsShow: boolean;
  @State isAlbumEmpty: boolean = false;
  public color: number = 0;
  public selectedRadius: number = 0;
  private isNeedFilterAlbumSource: boolean = false;
  private sourceAlbumUri: string = '';
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @State contentHeight: number = 0;
  public dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
  @Provide newIsShowBar: boolean = true;
  @State isSupportPrint: boolean = false;
  @State newSelectedCount: number = 0;
  @State newSelectParams: SelectParams = SelectParams.defaultParam();
  public photoDataSource: MediaDataSource | undefined = undefined;
  public menuWidthRatio: number = 0.4;
  public defaultGridNum: number = 4;
  public minDpNum: number = 360;
  public listHeight: string = '48vp';
  @State listCardWidth: number = 0;
  @State gridItemWidth: number = 0;
  private onDataReloadedFunc: Function = (): void => this.onReloadFinishedCallback();
  private onThirdSelectAlbumPhotosUpdateFunc: Function = (size: number):
    void => this.onThirdSelectAlbumPhotosUpdate(size);
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State isNeedTransition: boolean = false;
  @Consume albumYOffset: number;
  @State private hoverSelectUrl: number | undefined = undefined;
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @Link winHeight: number;
  @StorageLink('isShowPickerWarnDialog') private isShowPickerWarnDialog: Boolean = false;
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') private currentFontSizeScale: number = 1;
  @State private listPaddingTopAndBottom: Resource = $r('sys.float.padding_level6');
  @State isShowAlbum: boolean = false;

  /**
   * 根据字体放大倍数，调整列表上下间距高度
   */
  private currentFontSizeScaleChange(): void {
    this.listPaddingTopAndBottom = FontUtil.getPaddingByFontScale(this.currentFontSizeScale);
    Log.info(TAG,
      `currentFontSizeScaleChange listPaddingTopAndBottom: ${px2vp(UiUtil.getResourceNumber(this.listPaddingTopAndBottom))}`);
  }

  /**
   * 加载完成
   * @param size 尺寸
   */
  private onLoadingFinished(size: number): void {
    // data concat
    Log.info(TAG, `broadCast ON_LOADING_FINISHED size: ${size}`);
    this.isAlbumEmpty = size === 0;

    this.isShowAlbum = true;
  }

  /**
   * 相册图片更新
   * @param size 尺寸
   */
  private onThirdSelectAlbumPhotosUpdate(size: number): void {
    this.onLoadingFinished(size);
    this.updateAlbumPhotoInfo = true;
  }

  private initAlbumListBase(): void {
    this.albums = new PickerSelectAlbumDataSource(this.broadCast, getContext(this),
      this.setQueryParamToAlbums(), this.userId);
    if (DeviceInfo.isTv()) {
      this.albums.setShowAllAlbumInfo();
    }
    let blackList: string[] = [];
    if (this.isNeedFilterAlbumSource) {
      blackList.push(this.sourceAlbumUri);
    }
    if (this.selectParams.filterMediaType == AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
      blackList = blackList.concat([UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE)]);
    }
    this.albums.setBlackList(blackList);
    this.albums.initialize();

    this.selectManager = LocalStorage.getShared()?.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER);
    Log.debug(TAG, `select params ${JSON.stringify(this.selectParams)}`);

    this.color = ((UiUtil.getResourceNumber($r('sys.float.alpha_fifth')) * 255) << 24 & 0xff000000) |
      (UiUtil.getResourceColorSync($r('sys.color.brand')) & 0x00ffffff);
    this.selectedRadius = UiUtil.getResourceNumber($r('sys.float.corner_radius_level8')) - 4;

    this.broadCastAll.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedFunc);

    this.broadCast.on(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, this.onThirdSelectAlbumPhotosUpdateFunc);

    if (this.selectParams.isMultiPick) {
      this.selectManager?.registerCallback?.('thirdSelectUpdateCount', (newState: number) => {
        Log.info(TAG, `thirdSelectUpdateCount ${newState}`);
        this.selectedCount = newState;
        this.newSelectedCount = newState;
      });
    }
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.initGridRowCount();
    let titleRes: Resource =
      (this.selectParams.isFromFa &&
        !this.selectParams.isFromFaPhoto) ?
      ActionBarProp.SINGLE_SELECT_ALBUM_TITLE : ActionBarProp.SINGLE_TAB_ALBUM_TITLE;
    UiUtil.getResourceString(titleRes).then((stringResource: string) => {
      this.title = stringResource;
    })

    this.updateCardSize();
    this.onActive();
    this.checkWarning();
    this.currentFontSizeScaleChange();
  }

  /**
   * 发现
   */
  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    WindowUtil.prepareWinRouter();
    this.isAlbumEmpty = false;
    let storageParam = this.getUIContext()
      .getSharedLocalStorage()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)
    this.userId = storageParam?.userId ?? -1;
    this.selectParams.photoViewMimeTypeFilter = storageParam?.photoViewMimeTypeFilter;
    this.selectParams.userId = storageParam?.userId ?? -1;
    this.selectParams.fileSizeFilter = storageParam?.fileSizeFilter;
    this.selectParams.videoDurationFilter = storageParam?.videoDurationFilter;
    this.selectParams.photoViewMimeTypeFileSizeFilters = storageParam?.photoViewMimeTypeFileSizeFilters;
    this.selectParams.combinedMediaTypeFilter = storageParam?.combinedMediaTypeFilter;
    this.initSelectParams(this.param);

    let isCombinedMediaTypeFilterError: boolean = this.getUIContext()?.getSharedLocalStorage()?.
      get<boolean>(Constants.IS_PHOTO_PICKER_COMBINED_FILTER_ERROR) ?? false;
    Log.info(TAG, `isCombinedMediaTypeFilterError=${isCombinedMediaTypeFilterError}`)
    if (!isCombinedMediaTypeFilterError) {
      this.initAlbumListBase();
    }

  }

  private setQueryParamToAlbums(): QueryParam {
    // 仅限于隐私空间跨用户访问主空间使用
    if (this.userId > 0) {
      let queryParam: QueryParam = {
        filterMediaType: this.selectParams.filterMediaType,
        filterConditions: {
          position: UserFileManagerAccess.GET_ASSERT_WITHOUT_CLOUD,
          subtype: UserFileManagerAccess.GET_ASSERT_WITHOUT_BURST_PHOTO,
        }
      };
      return queryParam;
    }
    // create self invented album
    let queryParam: QueryParam = {
      filterMediaType: this.selectParams.filterMediaType,
      filterConditions: {
        recommendationType: this.selectParams.recommendationType,
        photoViewMimeTypeFilter: this.selectParams.photoViewMimeTypeFilter,
        fileSizeFilter: this.selectParams.fileSizeFilter,
        videoDurationFilter: this.selectParams.videoDurationFilter,
        photoViewMimeTypeFileSizeFilters: this.selectParams.photoViewMimeTypeFileSizeFilters,
        combinedMediaTypeFilter: this.selectParams.combinedMediaTypeFilter,
      }
    };
    return queryParam;
  }

  private checkWarning(): void {
    if (this.selectParams.bundleName === Constants.PHOTO_BUNDLE_NAME || this.isVerdeFoldable) {
      this.isShowPickerWarnDialog = false;
      return;
    }
    let key: string = Constants.ACCESSING_PICKER_APP_LIST;
    PickerUtil.isAppExist(this.selectParams.bundleName, key)
      .then((result: AppPresenceStatus) => {
        if (result === AppPresenceStatus.NOT_EXIST) {
          this.isShowPickerWarnDialog = true;
        } else {
          this.isShowPickerWarnDialog = false;
        }
      });
  }

  /**
   * 加载完成
   * @param size 尺寸
   */
  onSizeLoadingFinished(size: number): void {
    Log.info(TAG, `onSizeLoadingFinished size: ${size}`)
  }

  /**
   * 数据发生改变
   * @param dataIndex dataIndex
   */
  onDataChanged(dataIndex: number): void {
  }

  /**
   * 数据加载完成
   */
  public onDataLoadingFinished(): void {
    Log.info(TAG, 'ON_DATA_RELOADED onDataLoadingFinished');
  }

  /**
   * 重载回调
   */
  private onReloadFinishedCallback(): void {
    Log.info(TAG, 'ON_DATA_RELOADED onReloadFinishedCallback');
  }

  /**
   * 更新卡片尺寸
   */
  updateCardSize(): void {
    let contentWidth = getScreen().getWinWidth();
    let cardWidth = contentWidth / 10;
    this.cardWidth = cardWidth;
    this.cardHeight = cardWidth;

    Log.info(TAG, `updateCardSize cardWidth is: ${this.cardWidth} cardHeight is: ${this.cardHeight} `);
  }

  /**
   * 初始化选择参数
   * @param param 参数
   */
  private initSelectParams(param?: ParamsSelect): void {
    if (param) {
      this.selectParams.bundleName = param.bundleName;
      this.selectParams.tokenId = param.tokenId;
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
      } else if (param.maxSelectCount && param.maxSelectCount > 0) {
        this.selectParams.maxSelectCount = Math.min(param.maxSelectCount, Constants.LIMIT_MAX_THIRD_SELECT_COUNT);
      }
      this.selectParams.isOriginalSupported = param.isOriginalSupported;
      this.selectParams.isPreviewForSingleSelectionSupported = param.isPreviewForSingleSelectionSupported;
      this.selectParams.singleSelectionMode = param.singleSelectionMode;
      this.selectParams.completeButtonText = param.completeButtonText;
      this.selectParams.recommendationType = param.recommendationType;
      this.selectParams.cameraAble = param.cameraAble ?? false;
      Log.info(TAG, `select param ${JSON.stringify(this.selectParams)}`);
    }
    if (this.selectParams.isFromFa) {
      this.selectParams.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_IMAGE;
    }
  }

  /**
   * 初始化网格行数量
   */
  private initGridRowCount(): void {
    let contentWidth = getScreen().getWinWidth();
    let photoGridNum = (2 * (contentWidth / this.minDpNum - 1)) + this.defaultGridNum;
    /* instrument ignore next */
    if (DeviceInfo.isFoldable()) {
      this.gridRowCount = Math.round(photoGridNum * (1 - this.menuWidthRatio));
    } else {
      this.gridRowCount = Math.round(photoGridNum);
    }
  }

  /**
   * 页面发生改变
   */
  onPageChanged(): void {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  /**
   * 展示
   */
  onPageShow(): void {
    Log.info(TAG, 'onPageShow');
    this.onActive();
  }

  /**
   * 页面消失
   */
  aboutToDisappear(): void {
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.onInActive();
    this.broadCast?.off(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, this.onThirdSelectAlbumPhotosUpdateFunc);
    this.broadCastAll?.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedFunc);
    this.albums?.cancelLoadData();
    this.isShowAlbum = false;
    this.dataSource.releaseBroadCast();
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    this.albums?.onNotify(nfyInfo);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
  }

  /**
   * 页面隐藏
   */
  onPageHide(): void {
    Log.info(TAG, 'onPageHide');
    this.onInActive();
  }

  /**
   * 组件创建
   */
  onActive(): void {
    Log.info(TAG, `onActive ${this.isActive}`);
    if (!this.isActive) {
      this.isActive = true;
      this.albums?.onActive();
    }
  }

  /**
   * 组件销毁
   */
  onInActive(): void {
    Log.info(TAG, `onInActive ${this.isActive}`);
    if (this.isActive) {
      this.isActive = false;
      this.albums?.onInActive();
    }
  }

  /**
   * 菜单点击
   * @param action action
   */
  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    if (action === Action.BACK) {
      AppStorage.get<Router>('router')?.back({
        url: '',
        params: {},
      });
    }
  }

  /**
   * 点击处理
   * @param album
   */
  private handleClick(album: PickerAlbumInfo, albumName?: ResourceStr): void {
    Log.info(TAG, 'handle album Click');
    let params: SelectParams = this.selectParams;
    params.isFirstEnter = false;
    params.itemDisplayName = albumName ?? album.albumName;
    params.itemCount = album.count;
    params.itemId = album.uri;
    params.uri = album.uri;
    params.itemCoverUri = album.coverUri;
    params.unionAlbumUris = album.getUnionAlbumUrisArray();
    this.broadCast.emit(BroadCastConstants.SWITCH_THIRD_ALBUM,
      [params]);
    this.selectId = album.uri;
    Log.info(TAG, `album click finished, selectId: ${this.selectId}`);
  }

  private setAlbumCoverUri(item: PickerAlbumInfo): Resource | string {
    if (!item.coverUri) {
      const altPlaceholder = $r('app.media.alt_placeholder');
      const altVideoPlaceholder = $r('app.media.alt_video_placeholder');
      return this.selectParams.filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO ?
        altPlaceholder : altVideoPlaceholder
    }
    if (this.userId > 0) {
      return item.coverUri + (item.coverUri.includes('?') ? '&' : '?') + 'user=' + this.userId;
    }
    return item.coverUri;
  }

  private setAlbumCoverCount(item: PickerAlbumInfo): string {
    return item.count.toString();
  }

  private getSelectUri(isHover: boolean, index: number | undefined): void {
    if (isHover) {
      this.hoverSelectUrl = index;
    } else {
      this.hoverSelectUrl = undefined;
    }
  }

  @Styles
  pressedStyles(): void {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('sys.float.corner_radius_level8'))
  }

  @Styles
  albumListItemStyles(): void {
    .borderColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('sys.float.corner_radius_level8')) // 每个单独的ListItem圆角'16vp'
    .padding({
      left: $r('app.float.picker_list_item_padding'),
      right: $r('app.float.picker_list_item_padding'),
    })
  }

  @Builder
  LargeAlbumListItem(item: PickerAlbumInfo) {
    Column() {
      Row({ space: NORMAL_ITEM_ROW_SPACE }) {
        Image(this.setAlbumCoverUri(item))
          .height($r('app.float.picker_album_item_size'))
          .width($r('app.float.picker_album_item_size'))
          .border({
            radius: $r('app.float.picker_album_border_radius'),
            color: $r('app.color.album_card_border_color'),
            width: $r('app.float.picker_album_border_width'),
          })
        Text(item.getAlbumNameResource())
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .maxLines(TEXT_MAX_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .fontWeight(FontWeight.Medium)
          .focusable(true)
          .draggable(false)
      }
      .width('85%')

      Text(this.setAlbumCoverCount(item))
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_secondary'))
        .focusable(true)
        .draggable(false)
        .maxLines(TEXT_MAX_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          left: $r('app.float.video_mode_hdr_icon_size_width'),
          right: $r('app.float.list_item_right_icon2_width'),
        });
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ top: this.listPaddingTopAndBottom, bottom: this.listPaddingTopAndBottom })
    .width('100%')
  }

  @Builder
  AlbumListItem(item: PickerAlbumInfo) {
    if (this.currentFontSizeScale < Constants.FONT_SCALE_LARGE_SIZE) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row({ space: DeviceInfo.isTv() ? TV_NORMAL_ITEM_ROW_SPACE : NORMAL_ITEM_ROW_SPACE }) {
          Image(this.setAlbumCoverUri(item))
            .height($r('app.float.picker_album_item_size'))
            .width($r('app.float.picker_album_item_size'))
            .border({
              radius: $r('app.float.picker_album_border_radius'),
              color: $r('app.color.album_card_border_color'),
              width: $r('app.float.picker_album_border_width'),
            })

          Column({ space: DeviceInfo.isTv() ? TV_TEXT_COLUMN_SPACE : TEXT_COLUMN_SPACE }) {
            Text(item.getAlbumNameResource())
              .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_sidebar_item_font_size') : $r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_primary'))
              .maxLines(TEXT_MAX_LINE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(FontWeight.Medium)
              .focusable(true)
              .draggable(false)
          }
          .width(DeviceInfo.isFoldable() ? '55%' : '65%')
          .margin({
            top: DeviceInfo.isTv() ? TV_TEXT_SAFE_MARGIN : TEXT_SAFE_MARGIN,
            bottom: DeviceInfo.isTv() ? TV_TEXT_SAFE_MARGIN : TEXT_SAFE_MARGIN,
          })
          .alignItems(HorizontalAlign.Start)
        }

        Text(this.setAlbumCoverCount(item))
          .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_picker_font_size') : $r('sys.float.Body_M'))
          .fontWeight(DeviceInfo.isTv() ? FontWeight.Regular : FontWeight.Normal)
          .fontColor($r('sys.color.font_secondary'))
          .focusable(true)
          .draggable(false)
          .maxLines(TEXT_MAX_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .height($r('app.float.edit_horizontal_toolBar_size'))
    } else {
      this.LargeAlbumListItem(item)
    }
  }

  @Builder
  TvTabAlbums() {
    ListItemGroup({ style: ListItemGroupStyle.CARD }) {
      LazyForEach(this.albums, (item: PickerAlbumInfo, index?: number) => {
        ListItem() {
          this.AlbumListItem(item);
        }
        .margin({ bottom: $r('app.float.tv_picker_album_item_margin') })
        .key('ListItem_' + index)
        .hoverEffect(HoverEffect.Highlight)
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .onClick((): void => this.handleClick(item))
        .onHover((isHover: boolean, event: HoverEvent): void => {
          Log.info(TAG, `ishover:${isHover}, index:${index}`)
          this.getSelectUri(isHover, index);
        })
        .borderColor($r('sys.color.comp_background_list_card'))
        .borderRadius($r('sys.float.corner_radius_level6'))
        .width($r('app.float.tv_picker_album_list_width'))
        .height($r('app.float.tv_picker_album_list_height'))
        .padding({
          left: 11,
          right: 11,
        })
        .backgroundColor(item.uri === this.selectId ? $r('sys.color.ohos_id_color_component_normal') :
        Color.Transparent)
      }, (item: PickerAlbumInfo, index?: number) => `${item.coverUri}_${index}_${item.count}`)
    }
    .padding({ top: $r('app.float.tv_picker_album_list_top_padding') })
    .backgroundColor(Color.Transparent)
  }

  @Builder
  buildPickerWarningDialog() {
    GridItem() {
      PickerViewWarningDialog({
        appName: this.selectParams.bundleName,
        isFromPickerView: this.selectParams.isFromPickerView,
        uiComponentColorMode: this.selectParams.uiComponentColorMode,
        emitHidePickerViewWarningDialog: (): void => {
          this.isShowPickerWarnDialog = false;
          this.contentHeight = this.contentHeight + PICKER_WARNING_DIALOG_HEIGHT;
        },
      })
    }
  }

  @Builder
  TabAlbums() {
    // 相册
    if (!this.isAlbumEmpty) {
      ListItemGroup({ style: ListItemGroupStyle.CARD }) {

        LazyForEach(this.albums, (item: PickerAlbumInfo, index2?: number) => {
          ListItem() {
            this.AlbumListItem(item);
          }
          .key(`ListItem_${index2}`)
          .hoverEffect(HoverEffect.Highlight)
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .onClick((): void => this.handleClick(item, item.getAlbumNameResource()))
          .stateStyles({
            normal: {
              .backgroundColor(undefined)
            },
            focused: {
              .backgroundColor(this.color)
            },
            selected: {
              .backgroundColor(this.color)
            },
            pressed: this.pressedStyles,
          })
          .onHover((isHover: boolean, event: HoverEvent): void => {
            Log.info(TAG, `ishover:${isHover}, index:${index2}`)
            this.getSelectUri(isHover, index2);
          })
          .albumListItemStyles()

        }, (item: PickerAlbumInfo, index2?: number) => `${item.uri}_${index2}`)
      }
      .divider({
        strokeWidth: '1px',
        color: $r('sys.color.comp_divider'),
        endMargin: $r('app.float.list_item_padding_end'),
        startMargin: $r('app.float.list_item_padding_start'),
      })
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .borderRadius($r('sys.float.corner_radius_level10'))
      .margin({
        left: $r('app.float.margin_safe_left_and_right'),
        right: $r('app.float.margin_safe_left_and_right'),
      })
      .visibility(this.isShowAlbum ? Visibility.Visible : Visibility.Hidden)
    } else {
      NoPhotoComponent({
        title: this.selectManager?.selectParam?.recommendationType !== SelectConstants.RECOMMEND_TYPE_COLOR_STYPE ?
        $r('app.string.no_distributed_photo_head_title_album') : $r('app.string.color_stype_no_photo'),
        winHeight: this.winHeight,
        isThird: true,
      })
    }
  }

  @Builder
  ListForPhone() {
    List({ scroller: this.albumScroller }) {
      if (this.isShowPickerWarnDialog) {
        this.buildPickerWarningDialog();
      }
      this.TabAlbums();
    }
    .layoutWeight(1)
    .onAppear((): void => {
      this.albumScroller.scrollTo({ xOffset: 0, yOffset: this.albumYOffset })
    })
    .sticky(StickyStyle.Header)
    .borderRadius($r('sys.float.corner_radius_level10'))
    .onDidScroll((): void => {
      this.albumYOffset = this.albumScroller.currentOffset().yOffset;
    })
    .padding({
      top: $r('app.float.dialog_offset_bottom'),
      bottom: $r('app.float.dialog_window_margin'),
    })
    .margin({
      left: $r('app.float.picker_list_margin_left_and_right'),
      right: $r('app.float.picker_list_margin_left_and_right'),
    })
    .alignListItem(ListItemAlign.Center)
    .width('100%')
    .height(this.isVerdeFoldable ? '100%' : this.contentHeight)
  }

  @Builder
  ListForTv() {
    List({ scroller: this.albumScroller }) {
      this.TvTabAlbums();
    }
    .fadingEdge(true)
    .layoutWeight(1)
    .onAppear((): void => {
      this.albumScroller.scrollTo({ xOffset: 0, yOffset: this.albumYOffset })
    })
    .sticky(StickyStyle.Header)
    .onDidScroll((): void => {
      this.albumYOffset = this.albumScroller.currentOffset().yOffset;
    })
    .alignListItem(ListItemAlign.Center)
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      /* instrument ignore next */
      if (DeviceInfo.isTv()) {
        this.ListForTv();
      } else {
        this.ListForPhone();
      }
      if (!this.isVerdeFoldable && !DeviceInfo.isTv()) {
        PickerSelectTip()
          .margin({
            bottom: DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable()
              ? $r('app.float.picker_select_tips_phone_margin_bottom')
              : $r('app.float.picker_select_tips_margin_bottom')
          })
      }
    }
    .width('100%')
    .height('100%')
    .position({ x: '0%', y: '0%' })
    .borderRadius($r('sys.float.corner_radius_level10'))
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      bottom: this.diggingHoleCameraArea.bottom,
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      Log.info(TAG, `onAreaChange oldValue: [${oldValue.width}, ${oldValue.height}],` +
        ` newValue: [${newValue.width}, ${newValue.height}]`);
      let pickerWarnDialogHeight: number = this.isShowPickerWarnDialog ? PICKER_WARNING_DIALOG_HEIGHT : 0;
      this.contentHeight = newValue.height as number - FOOTER_SAFERY_WIDTH - pickerWarnDialogHeight;
    })
  }
}