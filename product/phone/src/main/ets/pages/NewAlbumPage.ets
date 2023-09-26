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
AppStorage.SetOrCreate('PhotoGridPageIndex', Constants.INVALID);

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
  @State moreMenuList: Array<Action> = new Array<Action>();
  @Provide rightClickMenuList: Array<Action> = new Array<Action>();
  @State isClickScrollBar: boolean = false;
  @StorageLink('PhotoGridPageIndex') @Watch('onIndexChange') PhotoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[]
    = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  title: string;
  @StorageLink('placeholderIndex') @Watch('onPlaceholderChanged') placeholderIndex: number = -1;
  @State pageStatus: boolean = false;
  @State isRunningAnimation: boolean = false;
  @State @Watch('updateAnimationStatus') browserController: BrowserController = new BrowserController(true);
  private dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
  private scroller: Scroller = new Scroller();
  private isDataFreeze = false;
  private mSelectManager: SelectManager;
  private isActive = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private isNewAlbum: boolean = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM);
  onWindowSizeChangeCallBack = () => {
    // 后续phone缩略图支持横竖屏后再放开
    // this.initGridRowCount;
  }

  onIndexChange() {
    Log.info(TAG, `onIndexChange ${this.PhotoGridPageIndex}`)
    if (this.PhotoGridPageIndex != Constants.INVALID) {
      this.scroller.scrollToIndex(this.PhotoGridPageIndex);
    }
  }

  onPlaceholderChanged() {
    Log.debug(TAG, 'onPlaceholderChanged placeholderIndex is ' + this.placeholderIndex);
    if (this.placeholderIndex >= 0) {
      this.scroller.scrollToIndex(this.placeholderIndex);
    }
    UiUtil.emitByPlaceholderIndex(this.placeholderIndex, this.dataSource, this.broadCast);
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    switch (action.actionID) {
      case Action.CANCEL.actionID:
        router.back();
        break;
      case Action.OK.actionID:
        if (this.mSelectManager.getSelectedCount() == 0) {
          Log.info(TAG, `onMenuClicked, action: ${action.actionID}, count = 0`);
          break;
        }
        Log.info(TAG, `onMenuClicked, action: ${action.actionID} newAlbum: ${this.isNewAlbum}`);
        if (this.isNewAlbum) {
          AppStorage.SetOrCreate(Constants.IS_SHOW_MOVE_COPY_DIALOG, true);
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
        break;
      default:
        break;
    }
  }

  freezeAdapter(fn): Function {
    let self = this;
    return function () {
      self.isDataFreeze = AppStorage.Get(Constants.IS_DATA_FREEZE);
      if (self.isDataFreeze) {
        return;
      }
      let context = this;
      let args = arguments;
      fn.apply(context, args);
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
      if (this.isSelectedMode) {
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
    this.mSelectManager = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    if (this.mSelectManager == null) {
      this.mSelectManager = new SelectManager();
      AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM_SELECTED, this.mSelectManager);
    }
    let param: any = router.getParams();
    if (param != null) {
      Log.debug(TAG, `After router.getParams, param is: ${JSON.stringify(param)}`);
      let item = JSON.parse(param.item);
      this.title = item.albumName;
      this.dataSource.setAlbumUri(item.uri);
      AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM_SOURCE, item.uri);
    } else {
      this.title = '';
      this.dataSource.setAlbumUri("");
    }

    let self = this;
    this.onMenuClicked = this.onMenuClicked.bind(this);
    this.dataSource.setBroadCast(this.broadCast)
    this.mSelectManager.setPhotoDataImpl();
    this.initGridRowCount = this.initGridRowCount.bind(this);
    this.initGridRowCount();
    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.broadCast.on(BroadCastConstants.SELECT,
      (position: number, key: string, value: boolean, callback: Function) => {
        if (self.mSelectManager.toggle(key, value, position)) {
          Log.info(TAG, 'enter event process');
          callback();
        }
      });

    this.broadCast.on(BroadCastConstants.JUMP_PHOTO_BROWSER,
      (name: string, item: MediaItem) => {
        let targetIndex = self.dataSource.getDataIndex(item);
        if (targetIndex == Constants.NOT_FOUND) {
          Log.error(TAG, 'targetIndex is not found');
          return;
        }
        Log.info(TAG, `jump to photo browser at index: ${targetIndex}`);
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
        this.browserController.showBrowserWithNoAnimation({
          position: targetIndex,
          transition: name,
          leftBlank: self.leftBlank,
        });
      })

    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
      (name: string, item: MediaItem, geometryTapIndex: number, geometryTransitionString: string) => {
        let targetIndex = self.dataSource.getDataIndex(item);
        Log.info(TAG, `jump to photo browser, index: ${targetIndex}, transition: ${name}`);
        AppStorage.SetOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, self.mSelectManager);
        AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, self.dataSource);
        if (geometryTapIndex && geometryTransitionString) {
          this.browserController.showSelectBrowser(geometryTapIndex, geometryTransitionString, TAG, {
            position: targetIndex,
            transition: name
          });
        } else {
          this.browserController.showSelectBrowserWithNoAnimation({
            position: targetIndex,
            transition: name,
          });
        }
      })

    this.broadCast.on(Constants.ON_LOADING_FINISHED,
      (size: number) => {
        Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
        this.isEmpty = size == 0;
        Log.info(TAG, `isEmpty: ${this.isEmpty}`);
      });

    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED,
      () => {
        Log.info(TAG, 'ON_DATA_RELOADED');
        this.dataSource.onDataReloaded();
      });

    this.appBroadCast.on(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorState.bind(this));
    AppStorage.SetOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, this.mSelectManager);
    this.mSelectManager.registerCallback('allSelect', this.freezeAdapter((newState: boolean) => {
      Log.info(TAG, `allSelect ${newState}`);
      self.isAllSelected = newState;
      self.dataSource.forceUpdate();
    }));
    this.mSelectManager.registerCallback('select', this.freezeAdapter((newState: number) => {
      Log.info(TAG, `select ${newState}`);
      self.dataSource.onDataChanged(newState);
    }));
    this.mSelectManager.registerCallback('updateCount', this.freezeAdapter((newState: number) => {
      Log.info(TAG, `updateSelectedCount ${newState}`);
      self.moreMenuList = [];
      self.moreMenuList.push(Boolean(newState) ? Action.INFO : Action.INFO_INVALID);
      self.totalSelectedCount = newState;
    }));
    this.dataSource.registerCallback('updateCount', (newState: number) => {
      Log.info(TAG, `updateTotalCount ${newState}`);
      self.isShowScrollBar = (newState > Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR);
      self.mSelectManager.setTotalCount(newState);
    })

    this.moreMenuList = [];
    this.moreMenuList.push(Action.INFO);
    TraceControllerUtils.finishTrace('PhotoGridPageAboutToAppear');
  }

  aboutToDisappear(): void {
    this.broadCast.off(null, null);
    this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, null);
    this.dataSource.releaseBroadCast();
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.onWindowSizeChangeCallBack = null;
    AppStorage.Delete(Constants.PHOTO_GRID_SELECT_MANAGER);
  }

  build() {
    Stack() {
      Column() {
        AlbumSelectActionBar({
          onMenuClicked: this.onMenuClicked,
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
              LazyForEach(this.dataSource, (item, index?: number) => {
                if (!!item) {
                  GridItem() {
                    ImageGridItemComponent({
                      dataSource: this.dataSource,
                      item: item.mediaItem,
                      isSelected: this.mSelectManager.isItemSelected(item.mediaItem.uri),
                      pageName: Constants.PHOTO_TRANSITION_ALBUM,
                      mPosition: index,
                      geometryTransitionString: this.getGeometryTransitionId(item, index),
                      selectedCount: $totalSelectedCount
                    })
                  }
                  .aspectRatio(1)
                  .columnStart(item.viewIndex % this.gridRowCount)
                  .columnEnd(item.viewIndex % this.gridRowCount)
                  .key('NewAlbumPageImage' + index)
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
        .width("100%")
        .height("100%")

        // Opacity must change for TransitionEffect taking effect
        // @ts-ignore
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
        .width("100%")
        .height("100%")

        // Opacity must change for TransitionEffect taking effect
        // @ts-ignore
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
    return TAG + item.mediaItem.getHashCode() + this.mSelectManager.isItemSelected(item.mediaItem.uri, item.viewIndex);
  }

  private initGridRowCount(): void {
    let contentWidth = ScreenManager.getInstance().getWinWidth();
    let margin = 0;
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
    this.gridRowCount = Math.max(Math.round(((contentWidth - Constants.NUMBER_2 * margin)
    + Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER)), Constants.DEFAULT_ALBUM_GRID_COLUMN_MIN_COUNT);
    Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}`);
  }
}