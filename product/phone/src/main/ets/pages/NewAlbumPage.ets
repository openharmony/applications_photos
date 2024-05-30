/**
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
  AlbumInfo,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  JumpSourceToMain,
  Log,
  MediaDataSource,
  MediaItem,
  ScreenManager,
  SelectManager,
  TraceControllerUtils,
  UiUtil,
  ViewData,
} from '@ohos/common';
import {
  BrowserController,
  CustomDialogView,
  GridScrollBar,
  ImageGridItemComponent,
  MoveOrCopyBroadCastProp,
  NoPhotoComponent
} from '@ohos/common/CommonComponents';
import { AlbumSelectActionBar } from '@ohos/browser/BrowserComponents';
import { PhotoBrowserComponent } from '../view/PhotoBrowserComponent';
import { SelectPhotoBrowserView } from '../view/SelectPhotoBrowserView';

const TAG: string = 'NewAlbumPage';
AppStorage.setOrCreate('photoGridPageIndex', Constants.INVALID);

interface Params {
  item: string;
}

@Entry
@Component
export struct NewAlbumPage {
  @State isEmpty: boolean = false;
  @State isShowScrollBar: boolean = false;
  @State gridRowCount: number = 0;
  @Provide isSelectedMode: boolean = true;
  @Provide isAllSelected: boolean = false;
  @State totalSelectedCount: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide isShow: boolean = true;
  @Provide isShowBar: boolean = true;
  @State moreMenuList: Action[] = [];
  @Provide rightClickMenuList: Action[] = [];
  @State isClickScrollBar: boolean = false;
  @StorageLink('photoGridPageIndex') @Watch('onIndexChange') photoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  title: string = '';
  @StorageLink('placeholderIndex') @Watch('onPlaceholderChanged') placeholderIndex: number = -1;
  @State pageStatus: boolean = false;
  @State isRunningAnimation: boolean = false;
  @State @Watch('updateAnimationStatus') browserController: BrowserController = new BrowserController(true);
  private dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
  private scroller: Scroller = new Scroller();
  private isDataFreeze = false;
  private mSelectManager: SelectManager | null = null;
  private isActive = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private isNewAlbum: boolean = AppStorage.get<boolean>(Constants.APP_KEY_NEW_ALBUM) as boolean;
  private onWindowSizeChangeCallBack: Function = () => {
    // 后续phone缩略图支持横竖屏后再放开
  }
  private onUpdateFavorStateFunc: Function = (item: MediaItem): void => this.onUpdateFavorState(item);
  private selectFunc: Function = (position: number, key: string, value: boolean, callback: Function): void =>
  this.select(position, key, value, callback);
  private jumpPhotoBrowserFunc: Function = (name: string, item: MediaItem): void => this.jumpPhotoBrowser(name, item);
  private jumpThirdPhotoBrowserFunc: Function = (name: string, item: MediaItem,
                                                 geometryTapIndex: number, geometryTransitionString: string): void =>
  this.jumpThirdPhotoBrowser(name, item, geometryTapIndex, geometryTransitionString);
  private onDataReloadedFunc: Function = (size: number): void => this.onDataReloaded(size);
  private onLoadingFinishedFunc: Function = (): void => this.onLoadingFinished();

  private select(position: number, key: string, value: boolean, callback: Function): void {
      if (this.mSelectManager?.toggle(key, value, position)) {
      Log.info(TAG, 'enter event process');
      callback();
    }
  }

  private jumpPhotoBrowser(name: string, item: MediaItem): void {
    let targetIndex = this.dataSource.getDataIndex(item);
    if (targetIndex == Constants.NOT_FOUND) {
      Log.error(TAG, 'targetIndex is not found');
      return;
    }
    Log.info(TAG, `jump to photo browser at index: ${targetIndex}`);
    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    interface Params {
      position: number;
      transition: string;
      leftBlank: number[];
    }
    let params: Params = {
      position: targetIndex,
      transition: name,
      leftBlank: this.leftBlank,
    }
    this.browserController.showBrowserWithNoAnimation(params);
  }

  private jumpThirdPhotoBrowser(name: string, item: MediaItem,
                                geometryTapIndex: number, geometryTransitionString: string): void {
    let targetIndex = this.dataSource.getDataIndex(item);
    Log.info(TAG, `jump to photo browser, index: ${targetIndex}, transition: ${name}`);
    AppStorage.setOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, this.mSelectManager);
    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    interface Params {
      position: number;
      transition: string;
      leftBlank: number[];
    }

    const params: Params = {
      position: targetIndex,
      transition: name,
      leftBlank: this.leftBlank,
    };
    if (geometryTapIndex && geometryTransitionString) {
      this.browserController.showSelectBrowser(geometryTapIndex, geometryTransitionString, TAG, params);
    } else {
      this.browserController.showSelectBrowserWithNoAnimation(params);
    }
  }

  private onDataReloaded(size: number): void {
    Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
    this.isEmpty = size == 0;
    Log.info(TAG, `isEmpty: ${this.isEmpty}`);
  }

  private onLoadingFinished(): void {
    Log.info(TAG, 'ON_DATA_RELOADED');
    this.dataSource.onDataReloaded();
  }

  onIndexChange() {
    Log.info(TAG, `onIndexChange ${this.photoGridPageIndex}`)
    if (this.photoGridPageIndex != Constants.INVALID) {
      this.scroller.scrollToIndex(this.photoGridPageIndex);
    }
  }

  onPlaceholderChanged() {
    Log.debug(TAG, 'onPlaceholderChanged placeholderIndex is ' + this.placeholderIndex);
    if (this.placeholderIndex != -1) {
      this.scroller.scrollToIndex(this.placeholderIndex);
    }
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    if (action.actionID === Action.CANCEL.actionID) {
      router.back();
    } else if (action.actionID === Action.OK.actionID) {
      if (this.mSelectManager?.getSelectedCount() == 0) {
        Log.info(TAG, `onMenuClicked, action: ${action.actionID}, count = 0`);
      }
      Log.info(TAG, `onMenuClicked, action: ${action.actionID} newAlbum: ${this.isNewAlbum}`);
      if (this.isNewAlbum) {
        AppStorage.setOrCreate(Constants.IS_SHOW_MOVE_COPY_DIALOG, true);
        let url = 'pages/index';
        router.back({
          url: url,
          params: {
            jumpSource: JumpSourceToMain.ALBUM,
          }
        })
      } else {
        MoveOrCopyBroadCastProp.getInstance().doAddOperation(this.broadCast);
      }
    }
  }

  onModeChange() {
    Log.info(TAG, 'onModeChange');
  }

  onPageShow() {
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.isShow = true;
    this.pageStatus = this.isShow;
    this.onActive();
  }

  onPageHide() {
    this.isShow = false;
    this.pageStatus = this.isShow;
    this.onInActive();
  }

  onActive() {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;

      this.dataSource && this.dataSource.onActive();
      if (this.isSelectedMode && this.mSelectManager) {
        this.totalSelectedCount = this.mSelectManager.getSelectedCount();
        this.dataSource.forceUpdate();
      }
    }
  }

  onInActive() {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
      this.dataSource && this.dataSource.onInActive();
    }
  }

  onUpdateFavorState(item: MediaItem) {
    Log.debug(TAG, 'onUpdateFavorState');
    let index = this.dataSource.getIndexByMediaItem(item);
    if (index != -1) {
      this.dataSource.onDataChanged(index);
    }
  }

  onBackPress() {
    if (this.browserController.isBrowserShow) {
      this.doPhotoBrowserViewBack();
      return true;
    }
    if (this.browserController.isSelectBrowserShow) {
      this.doSelectPhotoBrowserViewBack();
      return true;
    }
    return false;
  }

  doSelectPhotoBrowserViewBack() {
    this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, []);
  }

  doPhotoBrowserViewBack() {
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, []);
  }

  aboutToAppear(): void {
    TraceControllerUtils.startTrace('PhotoGridPageAboutToAppear');
    this.mSelectManager = AppStorage.Get<SelectManager>(Constants.APP_KEY_NEW_ALBUM_SELECTED) as SelectManager;
    if (this.mSelectManager == null) {
      this.mSelectManager = new SelectManager();
      AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_SELECTED, this.mSelectManager);
    }
    let param: Params = router.getParams() as Params;
    if (param != null) {
      Log.debug(TAG, `After router.getParams, param is: ${JSON.stringify(param)}`);
      let item: AlbumInfo = JSON.parse(param.item) as AlbumInfo;
      this.title = item.albumName;
      this.dataSource.setAlbumUri(item.uri);
      AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_SOURCE, item.uri);
    } else {
      this.title = '';
      this.dataSource.setAlbumUri('');
    }

    let self = this;
    this.dataSource.setBroadCast(this.broadCast)
    this.mSelectManager.setPhotoDataImpl();
    this.initGridRowCount();
    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.broadCast.on(BroadCastConstants.SELECT, this.selectFunc);
    this.broadCast.on(BroadCastConstants.JUMP_PHOTO_BROWSER, this.jumpPhotoBrowserFunc);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
    this.broadCast.on(Constants.ON_LOADING_FINISHED, this.onDataReloadedFunc);
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onLoadingFinishedFunc);

    this.appBroadCast.on(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorStateFunc);
    AppStorage.setOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, this.mSelectManager);
    this.mSelectManager.registerCallback('allSelect', (newState: boolean) => {
      Log.info(TAG, `allSelect ${newState}`);
      this.isDataFreeze = AppStorage.get<boolean>(Constants.IS_DATA_FREEZE) as boolean;
      if (this.isDataFreeze) {
        return;
      }
      this.isAllSelected = newState;
      this.dataSource.forceUpdate();
    });
    this.mSelectManager.registerCallback('select', (newState: number) => {
      Log.info(TAG, `select ${newState}`);
      this.isDataFreeze = AppStorage.get<boolean>(Constants.IS_DATA_FREEZE) as boolean;
      if (this.isDataFreeze) {
        return;
      }
      this.dataSource.onDataChanged(newState);
    });
    this.mSelectManager.registerCallback('updateCount', (newState: number) => {
      Log.info(TAG, `updateSelectedCount ${newState}`);
      this.isDataFreeze = AppStorage.get<boolean>(Constants.IS_DATA_FREEZE) as boolean;
      if (this.isDataFreeze) {
        return;
      }
      this.moreMenuList = [];
      this.moreMenuList.push(Boolean(newState) ? Action.INFO : Action.INFO_INVALID);
      this.totalSelectedCount = newState;
    });
    this.dataSource.registerCallback('updateCount', (newState: number) => {
      Log.info(TAG, `updateTotalCount ${newState}`);
      self.isShowScrollBar = (newState > Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR);
      self.mSelectManager?.setTotalCount(newState);
    })

    this.moreMenuList = [];
    this.moreMenuList.push(Action.INFO);
    TraceControllerUtils.finishTrace('PhotoGridPageAboutToAppear');
  }

  aboutToDisappear(): void {
    if (this.broadCast) {
      this.broadCast.off(BroadCastConstants.SELECT, this.selectFunc);
      this.broadCast.off(BroadCastConstants.JUMP_PHOTO_BROWSER, this.jumpPhotoBrowserFunc);
      this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
      this.broadCast.off(Constants.ON_LOADING_FINISHED, this.onDataReloadedFunc);
      this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onLoadingFinishedFunc);
    }
    this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorStateFunc);
    this.dataSource.releaseBroadCast();
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    AppStorage.delete(Constants.PHOTO_GRID_SELECT_MANAGER);
  }

  build() {
    Stack() {
      Column() {
        AlbumSelectActionBar({
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          totalSelectedCount: $totalSelectedCount,
          menuList: $moreMenuList
        })
        if (this.isEmpty) {
          NoPhotoComponent({
            title: $r('app.string.no_distributed_photo_head_title_album')
          })
        } else {
          Stack() {
            Grid(this.scroller) {
              LazyForEach(this.dataSource, (item: ViewData, index?: number) => {
                if (!!item) {
                  GridItem() {
                    ImageGridItemComponent({
                      dataSource: this.dataSource,
                      item: item.mediaItem,
                      isSelected: this.isSelectedMode ?
                      this.mSelectManager?.isItemSelected((item.mediaItem as MediaItem).uri as string, item.viewIndex) :
                        false,
                      pageName: Constants.PHOTO_TRANSITION_ALBUM,
                      mPosition: index,
                      geometryTransitionString: this.getGeometryTransitionId(item, index as number),
                      selectedCount: $totalSelectedCount
                    })
                  }
                  .aspectRatio(1)
                  .columnStart(item.viewIndex % this.gridRowCount)
                  .columnEnd(item.viewIndex % this.gridRowCount)
                  .key('NewAlbumPageImage' + index)
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
            .columnsTemplate('1fr '.repeat(this.gridRowCount))
            .columnsGap(Constants.GRID_GUTTER)
            .rowsGap(Constants.GRID_GUTTER)
            .cachedCount(Constants.GRID_CACHE_ROW_COUNT)

            if (this.isShowScrollBar) {
              GridScrollBar({ scroller: this.scroller });
            }
          }
          .layoutWeight(1)
        }
        CustomDialogView({ broadCast: $broadCast })
      }
      .backgroundColor($r('app.color.default_background_color'))
      .margin({
        top: this.leftBlank[1],
        bottom: this.leftBlank[3]
      })

      if (this.browserController.isBrowserShow) {
        Column() {
          PhotoBrowserComponent({
            pageStatus: this.pageStatus,
            geometryTransitionEnable: true,
            isRunningAnimation: $isRunningAnimation,
            browserController: this.browserController
          })
        }
        .width('100%')
        .height('100%')

        // Opacity must change for TransitionEffect taking effect
        .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
      }

      if (this.browserController.isSelectBrowserShow) {
        Column() {
          SelectPhotoBrowserView({
            pageStatus: this.pageStatus,
            geometryTransitionEnable: true,
            isRunningAnimation: $isRunningAnimation,
            browserController: this.browserController
          })
        }
        .width('100%')
        .height('100%')

        // Opacity must change for TransitionEffect taking effect
        .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
      }
    }
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: 300 })
      .opacity(1)
    PageTransitionExit({ type: RouteType.Push, duration: 300 })
      .opacity(1)
  }

  private updateAnimationStatus() {
    this.isRunningAnimation = this.browserController.isAnimating;
  }

  private getGeometryTransitionId(item: ViewData, index: number): string {
    let mediaItem = item.mediaItem as MediaItem;
    if (mediaItem) {
      return TAG + mediaItem.getHashCode() + (this.mSelectManager?.isItemSelected(mediaItem.uri as string) ?? false);
    } else {
      return TAG + item.viewIndex;
    }
  }

  private initGridRowCount(): void {
    let contentWidth = ScreenManager.getInstance().getWinWidth();
    let margin = 0;
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
    this.gridRowCount = Math.max(Math.round(((contentWidth - Constants.NUMBER_2 * margin) +
    Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)),
      Constants.DEFAULT_ALBUM_GRID_COLUMN_MIN_COUNT);
    Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}`);
  }
}