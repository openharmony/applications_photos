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
  AlbumDefine,
  BigDataConstants,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  CommonObserverCallback,
  Constants,
  Log,
  MediaItem,
  MediaObserver,
  PhotoDataImpl,
  ReportToBigDataUtil,
  ScreenManager,
  SelectUtil,
  ThirdSelectManager,
  UiUtil,
  UserFileManagerAccess,
  ViewData,
  BrowserDataFactory,
  MediaDataSource
} from '@ohos/common';
import {
  BrowserController,
  GridScrollBar,
  ImageGridItemComponent,
  NoPhotoComponent,
  NoPhotoIndexComponent
} from '@ohos/common/CommonComponents';
import { ThirdSelectedPageActionBar } from './ThirdSelectedPageActionBar';
import { ThirdSelectedPanel } from './ThirdSelectedPanel';
import { CameraGridItemComponent } from './CameraGridItemComponent';
import {
  FormConstants,
  IS_HORIZONTAL,
  IS_SPLIT_MODE,
  LEFT_BLANK,
  SelectParams,
  THIRD_SELECT_IS_ORIGIN
} from '../utils/ThirdSelectConstants';
import ability from '@ohos.ability.ability';
import common from '@ohos.app.ability.common';
import SmartPickerRecommendInfo from '../common/SmartPickerRecommendInfo';
import SmartPickerRecommendInfoObserver from '../common/SmartPickerRecommendInfoObserver';
import { PickerMediaDataSource } from '../common/PickerMediaDataSource';
import SmartPickerDataImpl from '../common/SmartPickerDataImpl';
import SmartPickerRecommendTabInfo from '../common/SmartPickerRecommendTabInfo';
import SmartPickerConstants from '../common/SmartPickerConstants';
import { SmartPickerManager } from '../common/SmartPickerManager';
import { ThirdSelectSmartRecommendTabBar } from './ThirdSelectSmartRecommendTabBar';
import SmartPickerDataAdapter from '../common/SmartPickerDataAdapter';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';

const TAG: string = 'thiSel_ThirdSelectPhotoGridBase';

let localStorage = LocalStorage.getShared();

// Third Select Album Page
@Component
export struct ThirdSelectPhotoGridBase {
  @State selectedCount: number = 0;
  @Provide isSelectedMode: boolean = true;
  @Provide moreMenuList: Action[] = [];
  @Provide rightClickMenuList: Action[] = [];
  photoDataImpl: PhotoDataImpl | undefined =
    BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl;
  smartPickerDataImpl: SmartPickerDataImpl | undefined;
  dataSource: PickerMediaDataSource = new PickerMediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, this.photoDataImpl);
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide isShow: boolean = true;
  selectManager: ThirdSelectManager | null = null;
  isActive = false;
  @State title: string = '';
  @State isEmpty: boolean = false;
  @StorageLink(IS_SPLIT_MODE) isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink(LEFT_BLANK) leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @StorageLink(IS_HORIZONTAL) isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  DEFAULT_TOAST_DURATION = 2000;
  @State gridRowCount: number = 0;
  @State isShowScrollBar: boolean = false;
  @State currentUri: string = '';
  @Provide isShowBar: boolean = true;
  scroller: Scroller = new Scroller();
  isFirstEnter: boolean = false;
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  backFuncBinder: Function | null = null;
  @State selectParams: SelectParams = SelectParams.defaultParam();
  @State screenHeight: number = ScreenManager.getInstance().getWinHeight();
  @StorageLink('placeholderIndex') @Watch('onPlaceholderChanged') placeholderIndex: number = -1;
  @ObjectLink @Watch('onBrowserControllerChanged') browserController: BrowserController;
  @State isShowSmartRecommendTabBar: boolean = false;
  @State smartRecommendTabItems: Array<SmartPickerRecommendTabInfo> = [];
  @State isAllMediaAlbum: boolean = true;
  @State currentSmartRecommendTabIndex: number = 0;
  private smartPickerRecommendInfoObserver: SmartPickerRecommendInfoObserver =
    new SmartPickerRecommendInfoObserver(this);
  private smartPickerManager: SmartPickerManager | undefined;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  private selectFromCameraFunc: Function = (): void => {};
  private itemId: string = '';
  private isItemIdChange: boolean = false;
  private onWindowSizeChangeCallBack: Function = () => this.initGridRowCount();
  private selectFunc: Function = (position: number, key: string, value: boolean, callback: Function): void =>
  this.onSelectCallback(position, key, value, callback);
  private jumpThirdPhotoBrowserFunc: Function = (name: string, item: MediaItem, geometryTapIndex: number,
                                                 geometryTransitionString: string, isSelectMode = false): void =>
  this.jumpBrowserCallback(name, item, geometryTapIndex, geometryTransitionString, isSelectMode);
  private onDataReloadedFunc: Function = (): void => this.onReloadFinishedCallback();
  private onSwitchSmartRecommendTabFunc: Function = (index: number): void => this.onSwitchSmartRecommendTab(index);
  private funcOnLoadingFinished: Function = (size: number): void => this.onLoadingFinished(size);
  private pickerInitDataFirstQueryFinishFunc: Function = (): void => this.pickerInitDataFirstQueryFinish();

  onPlaceholderChanged() {
    Log.debug(TAG, 'onPlaceholderChanged placeholderIndex is ' + this.placeholderIndex);
    if (this.placeholderIndex != -1) {
      this.scroller.scrollToIndex(this.placeholderIndex);
    }
  }

  private onSwitchSmartRecommendTab(index: number): void {
    Log.debug(TAG, ' onSwitchSmartRecommendTab index:' + index)
    AppStorage.setOrCreate<number>('placeholderIndex', Constants.INVALID);
    this.currentSmartRecommendTabIndex = index;
    Log.debug(TAG, ' onSwitchSmartRecommendTab this.isShowSmartRecommendTabBar:' + this.isShowSmartRecommendTabBar)
    if (this.isShowSmartRecommendTabBar) {
      this.selectParams.cameraAble = this.smartRecommendTabItems[this.currentSmartRecommendTabIndex].isCameraAble();
    }
    this.dataSource.changeDataImpl(this.currentSmartRecommendTabIndex === 0 ?
    this.photoDataImpl : this.smartPickerDataImpl);
    this.smartRecommendTabItems[this.currentSmartRecommendTabIndex].setUserClickTab(true);
    this.dataSource.setAlbumUri(this.smartRecommendTabItems[this.currentSmartRecommendTabIndex].getAlbumUri());
    this.dataSource.resetActiveWindow();
    this.dataSource.initData();
  }

  onBrowserControllerChanged(): void {
    if (!this.browserController.isBrowserShow) {
      ScreenManager.getInstance().setSystemUi(true);
    }
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    if (action.actionID === Action.BACK.actionID) {
      this.goBackFormEditor();
    } else if (action.actionID === Action.CANCEL.actionID) {
      this.setPickResult();
    } else if (action.actionID === Action.OK.actionID) {
      let uriArray: string[] = [];
      if (this.selectManager !== null) {
        uriArray = SelectUtil.getUriArray(this.selectManager.clickedSet);
      }
      this.setPickResult(uriArray);
    } else if (action.actionID === Action.NAVIGATION_ALBUMS.actionID) {
      let params = this.selectParams;
      params.isFirstEnter = false;
      router.pushUrl({
        url: 'pages/ThirdSelectAlbumSetPage',
        params: this.selectParams
      })
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_SWITCH_ALBUM, undefined);
    }
  }

  aboutToAppear(): void {
    let param: SelectParams;
    if (localStorage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      param = localStorage.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
    } else {
      param = router.getParams() as SelectParams;
    }
    this.initSelectParams(param);
    if (param && param.preselectedUris) {
      this.selectParams.preselectedUris = param.preselectedUris;
    }
    this.selectParams.cameraAble = param.cameraAble;

    // 更新编辑许可
    this.selectParams.editAble = param.editAble;
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_THIRD_EDITABLE, this.selectParams.editAble);
    if (this.selectParams.isFromFa) {
      this.selectParams.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_IMAGE;
      AppStorage.setOrCreate(FormConstants.FORM_ITEM_ALBUM_URI, param.uri);
      AppStorage.setOrCreate(FormConstants.FORM_ITEM_DISPLAY_NAME, param.itemDisplayName);
    }
    this.dataSource.setFilterMediaType(this.selectParams.filterMediaType);
    this.initSelectManager();
    this.selectManager?.setIsMultiPick(this.selectParams.isMultiPick);

    let self = this;
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.Get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    }
    this.initGridRowCount();
    if (localStorage && localStorage.has(SmartPickerConstants.SMART_PICKER_MANAGER)) {
      this.smartPickerManager = localStorage.get<SmartPickerManager>(SmartPickerConstants.SMART_PICKER_MANAGER);
      if (this.smartPickerManager) {
        this.smartPickerManager.addPickerRecommendInfoListener(this.smartPickerRecommendInfoObserver);
      }
    }
    this.dataSource.setBroadCast(this.broadCast);
    this.broadCast.on(BroadCastConstants.SELECT, this.selectFunc);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
    this.broadCast.on(Constants.ON_LOADING_FINISHED, this.funcOnLoadingFinished);
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedFunc);
    this.broadCast.on(SmartPickerConstants.PICKER_INIT_DATA_FIRST_QUERY_FINISH,
      this.pickerInitDataFirstQueryFinishFunc);
    this.selectManager?.registerCallback('updateCount',
      (newState: number) => {
        Log.info(TAG, `updateSelectedCount ${newState}`);
        self.selectedCount = newState;
        self.selectManager?.emitCallback('thirdSelectUpdateCount', [newState]);
      });
    this.dataSource.registerCallback('updateCount',
      (newState: number) => {
        Log.info(TAG, `updateTotalCount ${newState}`);
        self.isShowScrollBar = (newState > Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR);
        self.selectManager?.setTotalCount(newState);
      });
    this.broadCast.on(BroadCastConstants.THIRD_PICKER_SWITCH_SMART_RECOMMEND_TAB, this.onSwitchSmartRecommendTabFunc);
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.isActive = true;

    // save all photo dataSource
    if (this.dataSource.albumUri === '' && AppStorage.get<MediaDataSource>(Constants.APP_KEY_ALL_PHOTO_DATASOURCE) === undefined) {
      AppStorage.setOrCreate(Constants.APP_KEY_ALL_PHOTO_DATASOURCE, this.dataSource);
    }
    Log.error(TAG, 'meow data count = ' + this.dataSource.totalCount());
  }

  onBackPress() {
    this.onMenuClicked(this.selectParams.isFromFa ? Action.BACK : Action.CANCEL);
  }

  onPageShow() {
    Log.debug(TAG, 'onPageShow');
    let param: SelectParams = router.getParams() as SelectParams;
    this.isItemIdChange = (this.itemId && param && this.itemId !== param.itemId) as boolean;
    if (this.isItemIdChange) {
      this.initSelectParams(param);
    }

    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.isShow = true;
    if (!this.browserController.isBrowserShow) {
      ScreenManager.getInstance().setSystemUi(true);
    }
    this.onActive();
  }

  onPageChanged() {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onPageHide() {
    Log.debug(TAG, 'onPageHide');
    this.isShow = false;
    this.onInActive();
  }

  aboutToDisappear(): void {
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    if (this.smartPickerManager) {
      this.smartPickerManager.removePickerRecommendInfoListener(this.smartPickerRecommendInfoObserver);
    }
    this.dataObserver.clearSource();
    if (this.broadCast) {
      this.broadCast.off(BroadCastConstants.SELECT, this.selectFunc);
      this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
      this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedFunc);
      this.broadCast.off(BroadCastConstants.THIRD_PICKER_SWITCH_SMART_RECOMMEND_TAB,
        this.onSwitchSmartRecommendTabFunc);
      this.broadCast.off(SmartPickerConstants.PICKER_INIT_DATA_FIRST_QUERY_FINISH,
        this.pickerInitDataFirstQueryFinishFunc);
      this.broadCast.off(Constants.ON_LOADING_FINISHED, this.funcOnLoadingFinished);
    }
    this.dataSource.releaseBroadCast();
    this.selectManager?.releaseGetMediaItemFunc();
    this.selectManager?.unregisterCallback('updateCount');
    Log.info(TAG, `call aboutToDisappear`)
  }

  onSmartPickerRecommendInfoListReady(pickerRecommendInfoList: SmartPickerRecommendInfo[],
                                      dataAdapter: SmartPickerDataAdapter): void {
    let param: SelectParams = router.getParams() as SelectParams;
    if (pickerRecommendInfoList === undefined || pickerRecommendInfoList === null ||
      pickerRecommendInfoList.length === 0) {
      return;
    }
    if (this.smartPickerDataImpl === undefined || this.smartPickerDataImpl === null) {
      this.smartPickerDataImpl = new SmartPickerDataImpl();
      this.smartPickerDataImpl.setDataAdapter(dataAdapter);
    }
    let tabInfo = new SmartPickerRecommendTabInfo();
    tabInfo.setCameraAble(param ? param.cameraAble : this.selectParams.cameraAble);
    tabInfo.setAlbumUri('');
    tabInfo.setLabelId(SmartPickerConstants.LABEL_ALL_PHOTO);
    this.smartRecommendTabItems.push(tabInfo);
    pickerRecommendInfoList.forEach((item, index) => {
      let tabInfo = new SmartPickerRecommendTabInfo();
      tabInfo.setLabelId(item.getLabelId());
      tabInfo.setRecommendType(item.getRecommendType());
      tabInfo.setAlbumUri(item.getAlbumUri());
      tabInfo.setTotalCount(item.getTotalCount());
      tabInfo.setRecommendContent(item.getRecommendContent());
      tabInfo.setCameraAble(false);
      this.smartRecommendTabItems.push(tabInfo);
    });
    this.isShowSmartRecommendTabBar = true;
    this.onSwitchSmartRecommendTab(this.currentSmartRecommendTabIndex);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.onChange(changeType);
  }

  getGeometryTransitionId(item: ViewData, index: number): string {
    let mediaItem = item.mediaItem as MediaItem;
    if (mediaItem) {
      return TAG + mediaItem.getHashCode() + (this.selectManager?.isItemSelected(mediaItem.uri as string) ?? false);
    } else {
      return TAG + item.viewIndex;
    }
  }

  @Builder
  buildGrid() {
    Grid(this.scroller) {
      if (!this.selectParams.isFromFa && this.selectParams.cameraAble) {
        GridItem() {
          CameraGridItemComponent({
            selectParams: this.selectParams,
            updateDataFunc: (uri: string) => {
              Log.debug(TAG, `get camera callback, uri ${uri}`)
              this.dataSource.initData();
              this.selectFromCameraFunc = () => {
                this.onSelectCallback(0, uri, true, () => {});
              }
            }
          })
        }
        .aspectRatio(1)
      }
      LazyForEach(this.dataSource, (item: ViewData, index?: number) => {
        if (item?.mediaItem) {
          GridItem() {
            ImageGridItemComponent({
              dataSource: this.dataSource,
              item: item?.mediaItem,
              isSelected: this.selectManager?.isItemSelected((item.mediaItem as MediaItem).uri as string) ?? false,
              pageName: Constants.PHOTO_TRANSITION_ALBUM,
              isThird: true,
              mPosition: item?.viewIndex,
              isThirdMultiPick: this.selectParams.isMultiPick,
              geometryTransitionString: this.getGeometryTransitionId(item, index as number),
              selectedCount: $selectedCount
            })
          }
          .aspectRatio(1)
          .zIndex(index === this.placeholderIndex ? 1 : 0)
        }
      }, (item: ViewData, index?: number) => {
        if (item == null || item == undefined) {
          return JSON.stringify(item) + index;
        }
        return this.getGeometryTransitionId(item, index as number);
      })
    }
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(BarState.Off)
    .gridStyle(this.gridRowCount)
  }

  build() {
    Column() {
      ThirdSelectedPageActionBar({
        leftAction: this.selectParams.isFromFa ? Action.BACK : Action.CANCEL,
        isSelectPhotoGrid: true,
        title: $title,
        selectParams: this.selectParams,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        isFirstEnter: this.isFirstEnter,
        totalSelectedCount: $selectedCount
      })

      if (this.isEmpty) {
        if (this.selectParams.isFromFa) {
          NoPhotoIndexComponent({ index: Constants.TIMELINE_PAGE_INDEX, hasBarSpace: false })
        } else {
          if (!this.selectParams.cameraAble) {
            NoPhotoComponent({ title: $r('app.string.no_distributed_photo_head_title_album') })
          }
        }
      }
      if (this.isShowSmartRecommendTabBar && this.isAllMediaAlbum) {
        ThirdSelectSmartRecommendTabBar({
          smartRecommendTabItems: this.smartRecommendTabItems,
          currentTabIndex: this.currentSmartRecommendTabIndex
        })
      }
      Stack() {
        this.buildGrid()
        if (this.isShowScrollBar) {
          GridScrollBar({ scroller: this.scroller });
        }
      }
      .layoutWeight(1)

      if (this.selectParams.isMultiPick) {
        ThirdSelectedPanel({
          maxSelectCount: this.selectParams.maxSelectCount,
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          mTransition: TAG,
          currentUri: this.currentUri,
          isShowBar: $isShowBar,
          totalSelectedCount: $selectedCount,
          dataSource: this.dataSource
        })
      }
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .padding({
      top: this.leftBlank[1],
      bottom: this.leftBlank[3]
    })
  }

  jumpToBrowserNormal(targetIndex: number, name: string, item: MediaItem, isSelectMode = false): void {
    interface AniParams {
      position: number;
      bundleName: string;
      transition: string;
      title: string;
      selectMode: boolean;
      maxSelectCount: number;
      isFromFa: boolean;
    }
    let params: AniParams = {
      position: targetIndex,
      bundleName: this.selectParams.bundleName,
      transition: name,
      title: this.title,
      selectMode: isSelectMode,
      maxSelectCount: this.selectParams.maxSelectCount,
      isFromFa: this.selectParams.isFromFa,
    };

    router.pushUrl({
      url: 'pages/ThirdSelectPhotoBrowser',
      params: params
    });
  }

  jumpToBrowserGeometryTransition(targetIndex: number, name: string, item: MediaItem, isSelectMode = false,
                                  geometryTapIndex: number,
                                  geometryTransitionString: string): void {
    interface AniParams {
      position: number;
      bundleName: string;
      transition: string;
      title: string;
      selectMode: boolean;
      maxSelectCount: number;
      isFromFa: boolean;
    }

    let params: AniParams = {
      position: targetIndex,
      bundleName: this.selectParams.bundleName,
      transition: name,
      title: this.title,
      selectMode: isSelectMode,
      maxSelectCount: this.selectParams.maxSelectCount,
      isFromFa: this.selectParams.isFromFa,
    };
    this.browserController.showBrowser(geometryTapIndex, geometryTransitionString, TAG, params);
  }

  private initGridRowCount(): void {
    let contentWidth = ScreenManager.getInstance().getWinWidth();
    let margin = 0;
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
    let calCount = Math.round(
      ((contentWidth - Constants.NUMBER_2 * margin) + Constants.GRID_GUTTER) /
        (maxThumbWidth + Constants.GRID_GUTTER));
    let newCount = Math.max(Constants.GRID_MIN_COUNT, calCount);
    if (newCount != this.gridRowCount) {
      this.gridRowCount = newCount;
    }
    Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}, row count ${this.gridRowCount}`);
  }

  private initSelectParams(param?: SelectParams): void {
    if (param) {
      this.isItemIdChange =
        (this.itemId !== undefined && this.itemId !== null && this.itemId !== param.itemId) as boolean;
      this.itemId = param.itemId == undefined ? AlbumDefine.ALBUM_ID_ALL : param.itemId;
      this.dataSource.setAlbumUri(this.itemId as string);

      let albumUri = param.uri === undefined ?
      UserFileManagerAccess.getInstance().getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE) :
      param.uri;
      this.dataSource.setAlbumUri(this.isShowSmartRecommendTabBar ?
      this.smartRecommendTabItems[this.currentSmartRecommendTabIndex].getAlbumUri() : albumUri);
      this.updateTitle(param);
      this.selectParams.bundleName = param.bundleName;
      this.selectParams.isMultiPick = param.isMultiPick;
      if (param.isFromFa != undefined || param.isFromFa != null) {
        this.selectParams.isFromFa = param.isFromFa;
      }
      if (param.isFromFaPhoto != undefined || param.isFromFaPhoto != null) {
        this.selectParams.isFromFaPhoto = param.isFromFaPhoto;
      }
      if (param.isFirstEnter != undefined || param.isFirstEnter != null) {
        this.isFirstEnter = param.isFirstEnter;
      }
      if (!!param.filterMediaType) {
        this.selectParams.filterMediaType = param.filterMediaType;
      }
      this.selectParams.isFromWallpaper = param.isFromWallpaper;
      if (this.selectParams.isFromWallpaper) {
        this.selectParams.maxSelectCount = param.remainingOfWallpapers;
      } else if (!!param.maxSelectCount && param.maxSelectCount > 0) {
        this.selectParams.maxSelectCount = param.maxSelectCount > Constants.LIMIT_MAX_THIRD_SELECT_COUNT
          ? Constants.LIMIT_MAX_THIRD_SELECT_COUNT
          : param.maxSelectCount;
      }
      if (this.backFuncBinder) {
        this.backFuncBinder((): void => this.onBackPress());
      }
      Log.debug(TAG, `select param ${JSON.stringify(this.selectParams)}`);
    }
    this.isSelectedMode = this.selectParams.isMultiPick;
    Log.debug(TAG, `select param ${JSON.stringify(this.selectParams)}, select mode ${this.isSelectedMode}`);
  }

  private updateTitle(param?: SelectParams): void {
    let displayName = param?.itemDisplayName == undefined ? $r('app.string.album_all') : param.itemDisplayName;
    if (typeof displayName === 'object') {
      UiUtil.getResourceString(displayName as Resource).then((stringResource: string) => {
        this.title = stringResource;
      })
    } else {
      this.title = displayName as string;
    }
    Log.debug(TAG, `update title ${this.title}`);
  }

  private onSelectCallback(position: number, key: string, value: boolean, callback: Function): void{
    Log.debug(TAG, `isHorizontal ${this.isHorizontal}, position ${position}, uri ${key}, select ${value}`)
    let isMultiPick = this.selectParams.isMultiPick;
    if (value && isMultiPick && this.selectedCount >= this.selectParams.maxSelectCount) {
      if (!this.isHorizontal) {
        UiUtil.showToast($r('app.string.up_to_limit_tips'));
      }
      return;
    }
    if (this.isShowSmartRecommendTabBar && this.isAllMediaAlbum && value) {
      if (this.smartRecommendTabItems[this.currentSmartRecommendTabIndex].getUserPickUriList().indexOf(key) === -1) {
        this.smartRecommendTabItems[this.currentSmartRecommendTabIndex].getUserPickUriList().push(key);
      }
    }
    if (!isMultiPick) {
      // update correct status from select manager
      value = !this.selectManager?.isItemSelected(key);
      this.selectManager?.deSelectAll();
    }
    if (this.selectManager?.toggle(key, value, position)) {
      Log.info(TAG, 'enter event process');
      this.dataSource.onDataChanged(this.dataSource.getDataIndexByUri(key));
      callback && callback(value);
    }
  }

  private jumpBrowserCallback(name: string, item: MediaItem, geometryTapIndex: number ,
                              geometryTransitionString: string, isSelectMode = false) {
    let selectItemIndex: number = this.selectManager?.getSelectItemIndex(item) ?? Constants.INVALID;
    let targetIndex = isSelectMode ? selectItemIndex : this.dataSource.getDataIndex(item);
    Log.info(TAG, `jump to photo browser at index: ${targetIndex}, transition: ${name}`);
    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    if (geometryTapIndex != -1 && geometryTransitionString != '') {
      this.jumpToBrowserGeometryTransition(
        targetIndex, name, item, isSelectMode, geometryTapIndex, geometryTransitionString);
    } else {
      this.jumpToBrowserNormal(targetIndex, name, item, isSelectMode);
    }
    ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_CLICK_PREVIEW, undefined);
  }

  private onReloadFinishedCallback(): void {
    Log.info(TAG, 'ON_DATA_RELOADED');
    this.dataSource.onDataReloaded();
    this.selectFromCameraFunc && this.selectFromCameraFunc();
    this.selectFromCameraFunc = () => {};
  }

  private pickerInitDataFirstQueryFinish(): void {
    if (this.isShowSmartRecommendTabBar) {
      this.selectParams.cameraAble =
        this.smartRecommendTabItems[this.isAllMediaAlbum ? this.currentSmartRecommendTabIndex : 0].isCameraAble();
    }
  }

  private onLoadingFinished(size: number): void {
    this.onLoadFinishedCallback(size, (param: SelectParams): void => this.updateTitle(param));
  }

  private onLoadFinishedCallback(size: number, updateTitle: Function) {
    Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
    this.isEmpty = size == 0;
    if (this.isEmpty && updateTitle) {
      updateTitle();
    }
    Log.info(TAG, `isEmpty: ${this.isEmpty}`)
    this.dataSource.onDataReloaded();
    this.modifyPhotoSelectStatus();
  }

  /**
   * 图库预选择
   */
  private modifyPhotoSelectStatus(): void {
    if (this.selectParams.preselectedUris.length > 0) {
      if (this.selectParams.preselectedUris.length > this.selectParams.maxSelectCount) {
        this.selectParams.preselectedUris =
          this.selectParams.preselectedUris.slice(0, this.selectParams.maxSelectCount);
      }
      this.selectManager?.initPreSelectPhotos(this.selectParams.preselectedUris);
      this.selectParams.preselectedUris = [];
    }
  }

  private initSelectManager() {
    let manager: ThirdSelectManager =
      AppStorage.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER) as ThirdSelectManager;
    if (manager && manager.getClassName() === 'ThirdSelectManager') {
      Log.debug(TAG, `use cached select manager, current select count ${manager.getSelectedCount()}`);
      this.selectManager = manager;
    } else {
      Log.debug(TAG, 'create new select manager');
      this.selectManager = new ThirdSelectManager();
      AppStorage.setOrCreate(Constants.THIRD_SELECT_MANAGER, this.selectManager);
    }
    if (this.isFirstEnter) {
      Log.debug(TAG, 'clear select manager');
      this.selectManager.deSelectAll();
      AppStorage.setOrCreate(THIRD_SELECT_IS_ORIGIN, false);
    }
    this.selectManager.setGetMediaItemFunc((uri: string): MediaItem => {
      return this.dataSource.getMediaItemByUri(uri);
    });
  }

  private onActive() {
    if (this.isItemIdChange) {
      this.isActive = false;
      this.dataSource && this.dataSource.initData();
    }

    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      this.dataSource && this.dataSource.onActive();
      if (this.selectParams.isMultiPick) {
        this.dataSource.forceUpdate();
      }
    }
  }

  private onInActive() {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
      this.dataSource && this.dataSource.onInActive();
    }
  }

  private setPickResult(uriArray?: Array<string>): void {
    let isOrigin: boolean = AppStorage.get<boolean>(THIRD_SELECT_IS_ORIGIN) as boolean;
    if (isOrigin == undefined) {
      isOrigin = false;
    }
    let abilityResult: ability.AbilityResult = {
      resultCode: (uriArray === null || uriArray === undefined) ? -1 : 0,
      want: {
        parameters: {
          'select-item-list': uriArray as Object,
          isOriginal: isOrigin
        }
      }
    };
    let self = this;
    let uriLength = 0;
    if (uriArray == null && uriArray == undefined) {
      if (localStorage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
        let session = localStorage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
        session?.terminateSelfWithResult(abilityResult as ability.AbilityResult).then((result: void) => {
          Log.debug(TAG, `session terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
        });
      } else {
        let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
        context.terminateSelfWithResult(abilityResult as ability.AbilityResult).then((result: void) => {
          Log.debug(TAG, `terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
        });
      }
    } else {
      uriLength = uriArray.length;
      if (localStorage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
        let session = localStorage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
        let param = localStorage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY);
        if (param?.bundleName) {
          SelectUtil.grantPermissionForUris(uriArray, param.bundleName).then(() => {
            Log.info(TAG, `session grant permission success.`);
            let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
            session?.terminateSelfWithResult(abilityResult as ability.AbilityResult).then((result: void) => {
              Log.debug(TAG, `session terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
            });
          }).catch((err: Error) => {
            Log.error(TAG, `session grant permission error: ${JSON.stringify(err)}, self result ${JSON.stringify(abilityResult)}`);
            session?.terminateSelfWithResult(abilityResult as ability.AbilityResult).then((result: void) => {
              Log.debug(TAG, `session terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
            });
          });
        }
      } else {
        SelectUtil.grantPermissionForUris(uriArray, self.selectParams.bundleName).then(() => {
          Log.info(TAG, `grant permission success.`);
          let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
          context.terminateSelfWithResult(abilityResult as ability.AbilityResult).then((result: void) => {
            Log.debug(TAG, `terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
          });
        }).catch((err: Error) => {
          Log.error(TAG, `grant permission error: ${JSON.stringify(err)}, self result ${JSON.stringify(abilityResult)}`);
        });
      }
    }
    interface Msg {
      isOriginalChecked: boolean;
      selectItemSize: number;
    }
    let msg: Msg = {
      isOriginalChecked: isOrigin,
      selectItemSize: uriLength,
    }
    ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_RESULT, msg);
  }

  private goBackFormEditor(): void {
    let formEditorOption: router.RouterOptions = {
      url: 'pages/FormEditorPage'
    };
    router.replaceUrl(formEditorOption);
  }
}

@Extend(Grid) 
function gridStyle(gridCount: number) {
  .columnsTemplate('1fr '.repeat(gridCount))
  .columnsGap(Constants.GRID_GUTTER)
  .rowsGap(Constants.GRID_GUTTER)
  .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
  .layoutWeight(1)
}
