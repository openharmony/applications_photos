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
  MediaDataSource,
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
} from '@ohos/common';
import {
  BrowserController,
  GridScrollBar,
  ImageGridItemComponent,
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

const TAG: string = 'thiSel_ThirdSelectPhotoGridBase';

// Third Select Album Page
@Component
export struct ThirdSelectPhotoGridBase {
  @State selectedCount: number = 0;
  @Provide isSelectedMode: boolean = true;
  @Provide moreMenuList: Array<Action> = new Array<Action>();
  @Provide rightClickMenuList: Array<Action> = new Array<Action>();
  PhotoDataImpl: PhotoDataImpl;
  dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide isShow: boolean = true;
  selectManager: ThirdSelectManager;
  isActive = false;
  @State title: string = '';
  @State isEmpty: boolean = false;
  @StorageLink(IS_SPLIT_MODE) isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink(LEFT_BLANK) leftBlank: [number, number, number, number]
    = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @StorageLink(IS_HORIZONTAL) isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  DEFAULT_TOAST_DURATION = 2000;
  @State gridRowCount: number = 0;
  @State isShowScrollBar: boolean = false;
  @State currentUri: string = '';
  @Provide isShowBar: boolean = true;
  scroller: Scroller = new Scroller();
  isFirstEnter: boolean = false;
  @Prop @Watch('onPageChanged') pageStatus: boolean;
  backFuncBinder: Function;
  @State selectParams: SelectParams = SelectParams.defaultParam();
  @State screenHeight: number = ScreenManager.getInstance().getWinHeight();
  @StorageLink('placeholderIndex') @Watch('onPlaceholderChanged') placeholderIndex: number = -1;
  @ObjectLink @Watch('onBrowserControllerChanged') browserController: BrowserController;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  private selectFromCameraFunc: () => void;
  private itemId: string = undefined;
  private isItemIdChange: boolean = false;
  onWindowSizeChangeCallBack = () => this.initGridRowCount();

  onPlaceholderChanged() {
    Log.debug(TAG, 'onPlaceholderChanged placeholderIndex is ' + this.placeholderIndex);
    if (this.placeholderIndex != -1) {
      this.scroller.scrollToIndex(this.placeholderIndex);
    }
  }

  onBrowserControllerChanged(): void {
    if (!this.browserController.isBrowserShow) {
      ScreenManager.getInstance().setSystemUi(true);
    }
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    switch (action.actionID) {
      case Action.BACK.actionID:
        this.goBackFormEditor();
        break;
      case Action.CANCEL.actionID:
        this.setPickResult(null);
        break;
      case Action.OK.actionID:
        this.setPickResult(SelectUtil.getUriArray(this.selectManager.clickedSet));
        break;
      case Action.NAVIGATION_ALBUMS.actionID:
        let params: any = this.selectParams;
        params.isFirstEnter = false;
        let options = {
          url: 'pages/ThirdSelectAlbumSetPage',
          params: params
        }
        router.pushUrl(options);
        ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_SWITCH_ALBUM, null);
        break;
      default:
        break;
    }
  }

  aboutToAppear(): void {
    let param: any = router.getParams();
    this.initSelectParams(param);
    if (this.selectParams.isFromFa) {
      this.selectParams.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_IMAGE;
      AppStorage.SetOrCreate(FormConstants.FORM_ITEM_ALBUM_URI, param.uri);
      AppStorage.SetOrCreate(FormConstants.FORM_ITEM_DISPLAY_NAME, param.itemDisplayName);
    }
    this.dataSource.setFilterMediaType(this.selectParams.filterMediaType);
    this.initSelectManager();
    this.selectManager.setIsMultiPick(this.selectParams.isMultiPick);

    let self = this;
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.Get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    }
    this.initGridRowCount();
    this.onMenuClicked = this.onMenuClicked.bind(this);
    this.dataSource.setBroadCast(this.broadCast);
    this.broadCast.on(BroadCastConstants.SELECT, this.onSelectCallback.bind(this));
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpBrowserCallback.bind(this));
    this.broadCast.on(Constants.ON_LOADING_FINISHED,
      (size: number) => {
        this.onLoadFinishedCallback(size, this.updateTitle.bind(this, param));
      });
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onReloadFinishedCallback.bind(this));
    this.selectManager.registerCallback('updateCount',
      (newState: number) => {
        Log.info(TAG, `updateSelectedCount ${newState}`);
        self.selectedCount = newState;
        self.selectManager.emitCallback('thirdSelectUpdateCount', [newState]);
      });
    this.dataSource.registerCallback('updateCount',
      (newState: number) => {
        Log.info(TAG, `updateTotalCount ${newState}`);
        self.isShowScrollBar = (newState > Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR);
        self.selectManager.setTotalCount(newState);
      });
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.isActive = true;

    Log.error(TAG, 'meow data count = ' + this.dataSource.totalCount());
  }

  onBackPress() {
    this.onMenuClicked(this.selectParams.isFromFa ? Action.BACK : Action.CANCEL);
  }

  onPageShow() {
    Log.debug(TAG, 'onPageShow');
    let param: any = router.getParams();
    this.isItemIdChange = this.itemId && param && this.itemId !== param.itemId;
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
    this.onWindowSizeChangeCallBack = null;
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataObserver.clearSource();
    this.broadCast.off(null, null);
    this.dataSource.releaseBroadCast();
    Log.info(TAG, `call aboutToDisappear`)
  }

  onMediaLibDataChange(changeType) {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.onChange(changeType);
  }

  getGeometryTransitionId(item: ViewData, index: number): string {
    return TAG + item.mediaItem.getHashCode() + this.selectManager.isItemSelected(item?.mediaItem?.uri);
  }

  @Builder buildGrid() {
    Grid(this.scroller) {
      if (!this.selectParams.isFromFa) {
        GridItem() {
          CameraGridItemComponent({
            selectParams: this.selectParams,
            updateDataFunc: (uri: string) => {
              Log.debug(TAG, `get camera callback, uri ${uri}`)
              this.dataSource.initData();
              this.selectFromCameraFunc = () => {
                this.onSelectCallback(0, uri, true, null);
              }
            }
          })
        }
        .aspectRatio(1)
      }
      LazyForEach(this.dataSource, (item, index?: number) => {
        if (!!item) {
          GridItem() {
            ImageGridItemComponent({
              dataSource: this.dataSource,
              item: item?.mediaItem,
              isSelected: this.selectManager.isItemSelected(item?.mediaItem?.uri),
              pageName: Constants.PHOTO_TRANSITION_ALBUM,
              isThird: true,
              mPosition: item?.viewIndex,
              isThirdMultiPick: this.selectParams.isMultiPick,
              geometryTransitionString: this.getGeometryTransitionId(item, index),
              selectedCount: $selectedCount
            })
          }
          .aspectRatio(1)
          .zIndex(index === this.placeholderIndex ? 1 : 0)
        }
      }, (item, index) => {
        if (item == null || item == undefined) {
          return JSON.stringify(item) + index;
        }
        return this.getGeometryTransitionId(item, index);
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
        onMenuClicked: this.onMenuClicked,
        isFirstEnter: this.isFirstEnter,
        totalSelectedCount: $selectedCount
      })

      if (this.selectParams.isFromFa && this.isEmpty) {
        NoPhotoIndexComponent({ index: Constants.TIMELINE_PAGE_INDEX, hasBarSpace: false })
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
          onMenuClicked: this.onMenuClicked,
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
    router.pushUrl({
      url: 'pages/ThirdSelectPhotoBrowser',
      params: {
        position: targetIndex,
        bundleName: this.selectParams.bundleName,
        transition: name,
        title: this.title,
        selectMode: isSelectMode,
        maxSelectCount: this.selectParams.maxSelectCount,
        isFromFa: this.selectParams.isFromFa
      }
    });
  }

  jumpToBrowserGeometryTransition(targetIndex: number, name: string, item: MediaItem, isSelectMode = false,
                                  geometryTapIndex: number = undefined,
                                  geometryTransitionString: string = undefined): void {
    this.browserController.showBrowser(geometryTapIndex, geometryTransitionString, TAG, {
      position: targetIndex,
      bundleName: this.selectParams.bundleName,
      transition: name,
      title: this.title,
      selectMode: isSelectMode,
      maxSelectCount: this.selectParams.maxSelectCount,
      isFromFa: this.selectParams.isFromFa
    });
  }

  private initGridRowCount(): void {
    let contentWidth = ScreenManager.getInstance().getWinWidth();
    let margin = 0;
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
    let calCount = Math.round(
      ((contentWidth - Constants.NUMBER_2 * margin) + Constants.GRID_GUTTER)
      / (maxThumbWidth + Constants.GRID_GUTTER));
    let newCount = Math.max(Constants.GRID_MIN_COUNT, calCount);
    if (newCount != this.gridRowCount) {
      this.gridRowCount = newCount;
    }
    Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}, row count ${this.gridRowCount}`);
  }

  private initSelectParams(param) {
    if (param != null) {
      this.isItemIdChange = this.itemId && this.itemId !== param.itemId;
      this.itemId = param.itemId == undefined ? AlbumDefine.ALBUM_ID_ALL : param.itemId;
      this.dataSource.setAlbumUri(this.itemId);

      let albumUri = param.uri == undefined ?
      UserFileManagerAccess.getInstance().getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE) :
      param.uri;
      this.dataSource.setAlbumUri(albumUri);
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
        this.backFuncBinder(this.onBackPress.bind(this));
      }
      Log.debug(TAG, `select param ${JSON.stringify(this.selectParams)}`);
    }
    this.isSelectedMode = this.selectParams.isMultiPick;
    Log.debug(TAG, `select param ${JSON.stringify(this.selectParams)}, select mode ${this.isSelectedMode}`);
  }

  private updateTitle(param) {
    let displayName = param.itemDisplayName == undefined ? $r('app.string.album_all') : param.itemDisplayName;
    if (typeof displayName === 'object') {
      UiUtil.getResourceString(displayName).then((stringResource) => {
        this.title = stringResource;
      })
    } else {
      this.title = displayName;
    }
    Log.debug(TAG, `update title ${this.title}`);
  }

  private onSelectCallback(position: number, key: string, value: boolean, callback: Function) {
    Log.debug(TAG, `isHorizontal ${this.isHorizontal}, position ${position}, uri ${key}, select ${value}`)
    let isMultiPick = this.selectParams.isMultiPick;
    if (value && isMultiPick && this.selectedCount >= this.selectParams.maxSelectCount) {
      if (!this.isHorizontal) {
        UiUtil.showToast($r('app.string.up_to_limit_tips'));
      }
      return;
    }
    if (!isMultiPick) {
      // update correct status from select manager
      value = !this.selectManager.isItemSelected(key);
      this.selectManager.deSelectAll();
    }
    if (this.selectManager.toggle(key, value, position)) {
      Log.info(TAG, 'enter event process');
      this.dataSource.onDataChanged(this.dataSource.getDataIndexByUri(key));
      callback && callback(value);
    }
  }

  private jumpBrowserCallback(name: string, item: MediaItem, geometryTapIndex: number = undefined,
                              geometryTransitionString: string = undefined, isSelectMode = false) {
    let targetIndex = isSelectMode ? this.selectManager.getSelectItemIndex(item) : this.dataSource.getDataIndex(item);
    Log.info(TAG, `jump to photo browser at index: ${targetIndex}, transition: ${name}`);
    AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    if (geometryTapIndex != undefined && geometryTransitionString != undefined) {
      this.jumpToBrowserGeometryTransition(
        targetIndex, name, item, isSelectMode, geometryTapIndex, geometryTransitionString);
    } else {
      this.jumpToBrowserNormal(targetIndex, name, item, isSelectMode);
    }
    ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_CLICK_PREVIEW, null);
  }

  private onReloadFinishedCallback() {
    Log.info(TAG, 'ON_DATA_RELOADED');
    this.dataSource.onDataReloaded();
    this.selectFromCameraFunc && this.selectFromCameraFunc();
    this.selectFromCameraFunc = undefined;
  }

  private onLoadFinishedCallback(size: number, updateTitle: Function) {
    Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
    this.isEmpty = size == 0;
    if (this.isEmpty && updateTitle) {
      updateTitle();
    }
    Log.info(TAG, `isEmpty: ${this.isEmpty}`)
    this.dataSource.onDataReloaded();
  }

  private initSelectManager() {
    let manager: ThirdSelectManager = AppStorage.Get(Constants.THIRD_SELECT_MANAGER);
    if (manager && manager.getClassName() === 'ThirdSelectManager') {
      Log.debug(TAG, `use cached select manager, current select count ${manager.getSelectedCount()}`);
      this.selectManager = manager;
    } else {
      Log.debug(TAG, 'create new select manager');
      this.selectManager = new ThirdSelectManager();
      AppStorage.SetOrCreate(Constants.THIRD_SELECT_MANAGER, this.selectManager);
    }
    if (this.isFirstEnter) {
      Log.debug(TAG, 'clear select manager');
      this.selectManager.deSelectAll();
      AppStorage.SetOrCreate(THIRD_SELECT_IS_ORIGIN, false);
    }
    this.selectManager.setGetMediaItemFunc(this.dataSource.getMediaItemByUri.bind(this.dataSource));
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

  private setPickResult(uriArray: Array<string>): void {
    let isOrigin: boolean = AppStorage.Get(THIRD_SELECT_IS_ORIGIN);
    if (isOrigin == undefined) {
      isOrigin = false;
    }
    let abilityResult = {
      'resultCode': 0,
      'want': {
        'parameters': {
          'select-item-list': uriArray,
          'isOriginal': isOrigin
        }
      }
    };
    let self = this;
    let uriLength = 0;
    if (uriArray == null && uriArray == undefined) {
      globalThis.photosAbilityContext.terminateSelfWithResult(abilityResult).then((result) => {
        Log.debug(TAG, `terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
      });
    } else {
      uriLength = uriArray.length;
      SelectUtil.grantPermissionForUris(uriArray, self.selectParams.bundleName).then(function () {
        Log.info(TAG, `grant permission success.`);
        globalThis.photosAbilityContext.terminateSelfWithResult(abilityResult).then((result) => {
          Log.debug(TAG, `terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
        });
      }).catch(function (err) {
        Log.error(TAG, `grant permission error: ${JSON.stringify(err)}, self result ${JSON.stringify(abilityResult)}`);
      });
    }
    ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_RESULT,
      { "isOriginalChecked": isOrigin, "selectItemSize": uriLength });
  }

  private goBackFormEditor() {
    let formEditorOption = {
      url: 'pages/FormEditorPage'
    };
    router.replaceUrl(formEditorOption);
  }
}

@Extend(Grid) function gridStyle(gridCount: number) {
  .columnsTemplate('1fr '.repeat(gridCount))
  .columnsGap(Constants.GRID_GUTTER)
  .rowsGap(Constants.GRID_GUTTER)
  .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
  .layoutWeight(1)
}
