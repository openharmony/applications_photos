/**
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
import prompt from '@system.prompt';
import Curves from '@ohos.curves';
import { MenuOperation } from '@ohos/common';
import {
  Action,
  AddMenuOperation,
  AlbumDefine,
  AlbumInfo,
  BatchDeleteMenuOperation,
  BatchRemoveMenuOperation,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  BrowserConstants,
  CommonObserverCallback,
  Constants,
  DeleteMenuOperation,
  ImageUtil,
  JumpSourceToMain,
  Log,
  MediaDataSource,
  MediaItem,
  MediaObserver,
  MediaOperationType,
  MenuContext,
  MenuOperationFactory,
  MoveMenuOperation,
  RemoveMenuOperation,
  ScreenManager,
  SelectManager,
  ShareMenuOperation,
  TraceControllerUtils,
  UiUtil,
  UserFileManagerAccess,
  ViewData
} from '@ohos/common';
import {
  BrowserController,
  CustomDialogView,
  GridScrollBar,
  ImageGridItemComponent,
  NoPhotoComponent
} from '@ohos/common/CommonComponents';
import { RecoverMenuOperation } from '@ohos/browser';
import {
  BatchRecoverMenuOperation,
  ClearRecycleMenuOperation,
  PhotoGridPageActionBar,
  PhotoGridPageToolBar
} from '@ohos/browser/BrowserComponents';


const TAG: string = 'PhotoGridView';
AppStorage.setOrCreate('photoGridPageIndex', Constants.INVALID);

// Album View
@Component
export struct PhotoGridView {
  @State isShowScrollBar: boolean = false;
  @Provide isEmpty: boolean = false;
  @State gridRowCount: number = 0;
  @Consume @Watch('updateRightClickMenuList') isSelectedMode: boolean;
  @Provide isAllSelected: boolean = false;
  @State totalSelectedCount: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @Provide broadCast: BroadCast = new BroadCast();
  @Consume isShow: boolean;
  @Provide isShowBar: boolean = true;
  @Provide moreMenuList: Action[] = [];
  @Provide rightClickMenuList: Action[] = [];
  @StorageLink('photoGridPageIndex') @Watch('onIndexChange') photoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @State gridItemWidth: number = 0;
  @StorageLink('photoGridActionBarOpacity') photoGridActionBarOpacity: number = 0;
  @StorageLink('photoGridViewOpacity') photoGridViewOpacity: number = 0;
  albumInfo: AlbumInfo = new AlbumInfo();
  title: string = '';
  deviceName: string = '';
  dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
  scroller: Scroller = new Scroller();
  isDataFreeze = false;
  mSelectManager = new SelectManager();
  isActive = false;
  isDistributedAlbum = false;
  deleteMode: boolean = false;
  routerStart = false;
  isFromFACard = false;
  @StorageLink('placeholderIndex') @Watch('onPlaceholderChanged') placeholderIndex: number = -1;
  @Provide hidePopup: boolean = false;
  @ObjectLink browserController: BrowserController;
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  // 选择模式下，鼠标对着未勾选项按右键弹框时，移动和复制菜单点击事件的标识位
  private isMvOrCpSeparatesItem: boolean = false;
  private mvOrCpSeparatesItem: MediaItem = new MediaItem();
  private photoTotalCount: number = 0;
  private params: Params | null = null;
  private scrollIndex: number = 0;
  private onWindowSizeChangeCallBack: Function = () => {
    // 后续phone缩略图支持横竖屏后再放开
  }
  private selectFunc: Function = (position: number, key: string, value: boolean, callback: Function): void =>
  this.select(position, key, value, callback);
  private jumpPhotoBrowserFunc: Function = (name: string, item: MediaItem,
                                            geometryTapIndex: number, geometryTransitionString: string): void =>
  this.jumpPhotoBrowser(name, item, geometryTapIndex, geometryTransitionString);
  private jumpThirdPhotoBrowserFunc: Function = (name: string, item: MediaItem,
                                                 geometryTapIndex: number, geometryTransitionString: string): void =>
  this.jumpThirdPhotoBrowser(name, item, geometryTapIndex, geometryTransitionString);
  private onLoadingFinishedFunc: Function = (size: number): void => this.onLoadingFinished(size);
  private onDataReloadedFunc: Function = (): void => this.onDataReloaded();
  private onUpdateFavorStateFunc: Function = (item: MediaItem): void => this.onUpdateFavorState(item);
  private onDoAnimationFunc: Function = (): void => this.onDoAnimation();

  onPlaceholderChanged() {
    Log.debug(TAG, 'onPlaceholderChanged placeholderIndex is ' + this.placeholderIndex);
    if (this.placeholderIndex != -1) {
      this.scroller.scrollToIndex(this.placeholderIndex);
    }
  }

  initParams(): void {
    this.isSelectedMode = false;
    this.isShow = true;
  }

  onIndexChange(): void {
    Log.info(TAG, `onIndexChange ${this.photoGridPageIndex}`)
    if (this.photoGridPageIndex != Constants.INVALID) {
      this.scroller.scrollToIndex(this.photoGridPageIndex);
    }
  }

  doAnimation(): void {
    animateTo({
      duration: BrowserConstants.PHONE_LINK_ALBUM_ACTIONBAR_DURATION,
      delay: BrowserConstants.PHONE_LINK_ALBUM_ACTIONBAR_DELAY,
      curve: Curve.Sharp
    }, () => {
      AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_ACTIONBAR_OPACITY, 1);
    })
    animateTo({
      duration: BrowserConstants.PHONE_LINK_OUT_PHOTO_GRID_ACTIONBAR_DURATION,
      curve: Curve.Sharp
    }, () => {
      AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 0);
      AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 0);
      AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 1);
    })
    animateTo({
      duration: BrowserConstants.PHONE_LINK_PHOTO_GRID_TO_ALBUM_DURATION,
      curve: Curve.Friction
    }, () => {
      AppStorage.setOrCreate<number>(Constants.KEY_OF_SELECTED_ALBUM_INDEX, -1);
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);
      AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, '');
    })
    animateTo({
      duration: BrowserConstants.PHONE_LINK_PHOTO_GRID_TO_ALBUM_SCALE_DURATION,
      curve: Curve.Friction
    }, () => {
      AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OTHER_SCALE, 1);
    })
  }

  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    let menuContext: MenuContext;
    let menuOperation: MenuOperation;
    if (action.actionID === Action.BACK.actionID) {
      if (this.isFromFACard) {
        router.replaceUrl({
          url: 'pages/index',
          params: {
            jumpSource: JumpSourceToMain.ALBUM,
          }
        });
      } else {
        if (router.getState().name === Constants.USER_FILE_MANAGER_PHOTO_TRANSITION_ALBUM) {
          router.back();
        } else {
          this.doAnimation();
        }
      }
    } else if (action.actionID === Action.CANCEL.actionID) {
      this.onModeChange();
    } else if (action.actionID === Action.MULTISELECT.actionID) {
      this.isSelectedMode = true;
    } else if (action.actionID === Action.SELECT_ALL.actionID) {
      this.mSelectManager.selectAll(true);
    } else if (action.actionID === Action.DESELECT_ALL.actionID) {
      this.mSelectManager.deSelectAll();
    } else if (action.actionID === Action.DELETE.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onDeleteStart())
        .withOperationEndCallback((): void => this.onDeleteEnd())
        .withBroadCast(this.broadCast)
        .withAlbumUri(this.albumInfo.uri)
        .withFromSelectMode(this.isSelectedMode)
        .withAlbumInfo(this.albumInfo)
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(BatchDeleteMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.SHARE.actionID) {
      menuContext = new MenuContext();
      menuContext.withFromSelectMode(true).withSelectManager(this.mSelectManager);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(ShareMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.INFO.actionID) {
      this.hidePopup = true;
      this.openDetailsDialog();
    } else if (action.actionID === Action.CLEAR_RECYCLE.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onDeleteStart())
        .withOperationEndCallback((): void => this.onDeleteEnd())
        .withBroadCast(this.broadCast)
        .withAlbumUri(UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE))
        .withAlbumInfo(this.albumInfo)
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(ClearRecycleMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.RECOVER.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withAlbumUri(UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE))
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onDeleteStart())
        .withOperationEndCallback((): void => this.onDeleteEnd())
        .withBroadCast(this.broadCast)
        .withAlbumInfo(this.albumInfo)
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(BatchRecoverMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.MOVE.actionID) {
      this.mSelectManager.getSelectedItems((selectedItems: Array<MediaItem>) => {
        Log.info(TAG, `Get selected items success, size: ${selectedItems.length}, start route to select album page`);
        this.routeToSelectAlbumPage(MediaOperationType.Move, selectedItems);
      })
    } else if (action.actionID === Action.ADD.actionID) {
      this.mSelectManager.getSelectedItems((selectedItems: Array<MediaItem>) => {
        Log.info(TAG, `Get selected items success, size: ${selectedItems.length}, start route to select album page`);
        this.routeToSelectAlbumPage(MediaOperationType.Add, selectedItems);
      })
    } else if (action.actionID === Action.REMOVE_FROM.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onRemoveStart())
        .withOperationEndCallback((): void => this.onRemoveEnd())
        .withBroadCast(this.broadCast)
        .withAlbumUri(this.albumInfo.uri)
        .withFromSelectMode(this.isSelectedMode)
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(BatchRemoveMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.NEW.actionID) {
      this.routeToAddMediaPage();
    } else if (action.actionID === Action.DOWNLOAD.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onDownloadStart())
        .withOperationEndCallback(async (err: Error, count: number, total: number): Promise<void> =>
        this.onDownloadEnd(err as Object, count, total))
        .withBroadCast(this.broadCast)
      menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
      menuOperation.doAction();
    }
  }

  async openDetailsDialog(): Promise<void> {
    if (this.totalSelectedCount == 0) {
      Log.error(TAG, 'no select error');
      return;
    } else if (this.totalSelectedCount == 1) {
      Log.info(TAG, 'totalSelectedCount is 1');
      await this.mSelectManager.getSelectedItems((selectItems: MediaItem[]) => {
        if (selectItems.length != 1) {
          Log.error(TAG, 'get selectItems is error');
          return;
        }
        this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [selectItems[0], this.isDistributedAlbum]);
      });
    } else {
      await this.mSelectManager.getSelectedItems((selectItems: MediaItem[]) => {
        if (selectItems.length <= 1) {
          Log.error(TAG, 'get selectItems is error');
          return;
        }
        let size = 0;
        selectItems.forEach((item) => {
          size = size + item.size;
        })

        Log.info(TAG, `openDetailsDialog size: ${size}`);
        this.broadCast.emit(BroadCastConstants.SHOW_MULTI_SELECT_DIALOG, [this.totalSelectedCount, size]);
      });
      return;
    }
  }

  routeToSelectAlbumPage(pageType: string, selectedItems: Array<MediaItem>): void {
    this.routerStart = true;
    router.pushUrl({
      url: 'pages/MediaOperationPage',
      params: {
        pageFrom: Constants.MEDIA_OPERATION_FROM_PHOTO_GRID,
        pageType: pageType,
        albumInfo: this.albumInfo,
        selectedItems: selectedItems
      }
    });
  }

  routeToAddMediaPage(): void {
    router.pushUrl({
      url: 'pages/AlbumSelect',
      params: {
        albumName: this.albumInfo.albumName,
        albumUri: this.albumInfo.uri
      }
    });
  }

  onCopyStart(): void {
    Log.info(TAG, `onCopyStart`);
    this.isDataFreeze = true;
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataSource.freeze();
  }

  onCopyEnd(err: Object, count: number, total: number): void {
    Log.info(TAG, `onCopyEnd count: ${count}, total: ${total}`);
    this.isDataFreeze = false;
    this.onModeChange();
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.dataSource.onChange('image');
    this.dataSource.unfreeze();
    if (err) {
      UiUtil.showToast($r('app.string.copy_failed_single'));
    }
  }

  onDownloadStart(): void {
    Log.info(TAG, `onDownloadStart`);
    this.isDataFreeze = true;
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataSource.freeze();
  }

  async onDownloadEnd(err: Object, count: number, total: number): Promise<void> {
    Log.info(TAG, `onDownloadEnd count: ${count}, total: ${total}`);
    this.isDataFreeze = false;
    this.onModeChange();
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.dataSource.onChange('image');
    this.dataSource.unfreeze();
    if (err) {
      if (total > 1) {
        Log.error(TAG, `get selectItems is error ${count}`);
        let str = await UiUtil.getResourceString($r('app.string.download_failed_multi'));
        let message = str.replace('%d', count.toString());
        prompt.showToast({
          message: message,
          duration: UiUtil.TOAST_DURATION,
          bottom: '200vp'
        });
      } else {
        UiUtil.showToast($r('app.string.download_failed_single'))
      }
    } else {
      UiUtil.showToast($r('app.string.download_progress_done'));
    }
  }

  onMoveStart(): void {
    Log.info(TAG, `onMoveStart`);
    this.isDataFreeze = true;
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataSource.freeze();
  }

  onMoveEnd(err: Object, count: number, total: number): void {
    Log.info(TAG, `onMoveEnd count: ${count}, total: ${total}`);
    this.isDataFreeze = false;
    this.onModeChange();
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.dataSource.switchRefreshOn();
    this.dataSource.onChange('image');
    this.dataSource.unfreeze();
    if (err) {
      UiUtil.showToast($r('app.string.move_failed_single'));
    }
  }

  onDeleteStart(): void {
    Log.info(TAG, `onDeleteStart`);
    this.deleteMode = true;
    this.isDataFreeze = true;
    this.onModeChange();
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataSource.freeze();
    MediaObserver.getInstance().freezeNotify();
  }

  onDeleteEnd(): void {
    Log.info(TAG, `onDeleteEnd`);
    this.isDataFreeze = false;
    MediaObserver.getInstance().unfreezeNotify();
    MediaObserver.getInstance().forceNotify();
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.dataSource.onChange('image');
    this.dataSource.unfreeze();
  }

  onRemoveStart(): void {
    Log.info(TAG, `onRemoveStart`);
    this.deleteMode = true;
    this.isDataFreeze = true;
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataSource.freeze();
  }

  onRemoveEnd(): void {
    Log.info(TAG, `onRemoveEnd`);
    this.isDataFreeze = false;
    this.onModeChange();
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.dataSource.onChange('image');
    this.dataSource.unfreeze();
  }

  onModeChange(): void {
    Log.info(TAG, 'onModeChange');
    this.isSelectedMode = false;
    this.isAllSelected = false;
    this.mSelectManager.onModeChange(false);
    AppStorage.delete(Constants.PHOTO_GRID_SELECT_MANAGER);
  }

  onPageChanged(): void {
    this.params = router.getParams() as Params;
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onPageShow(): void {
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.isShow = true;
    if (this.routerStart && this.params != null && this.params.pageType != null) {
      Log.info(TAG, 'MediaOperation back');
      if (this.params.pageType === MediaOperationType.Move) {
        this.moveOperation(this.params.albumName, this.params.albumUri);
      } else if (this.params.pageType === MediaOperationType.Add) {
        this.addOperation(this.params.albumName, this.params.albumUri);
      }
    }
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.isMvOrCpSeparatesItem = false;
    this.mvOrCpSeparatesItem = new MediaItem();
    this.routerStart = false;
    this.onActive();
  }

  onPageHide(): void {
    this.isShow = false;
    this.onInActive();
  }

  onActive(): void {
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

  onInActive(): void {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
    }
  }

  updateRightClickMenuList(): void {
    if (!this.isSelectedMode) {
      this.onModeChange();
    }
    this.rightClickMenuList = [];
    if (this.albumInfo) {
      let isRecycleAlbum: boolean = this.albumInfo.isTrashAlbum;
      if (isRecycleAlbum) {
        this.rightClickMenuList = [Action.RECOVER, Action.DELETE,
          this.isSelectedMode ? Action.MULTISELECT_INVALID : Action.MULTISELECT];
      } else {
        if (!this.isSelectedMode) {
          this.rightClickMenuList.push(Action.MULTISELECT)
        }
        this.rightClickMenuList.push(Action.DELETE);
        if (!this.albumInfo.isSystemAlbum) {
          this.rightClickMenuList.push(Action.MOVE);
          this.rightClickMenuList.push(Action.REMOVE_FROM);
        }
        this.rightClickMenuList.push(Action.ADD, Action.INFO);
      }
    }
  }

  aboutToAppear(): void {
    Log.debug(TAG, `aboutToAppear`);
    TraceControllerUtils.startTrace('PhotoGridPageAboutToAppear');
    this.initParams();
    if (router.getState().name === Constants.USER_FILE_MANAGER_PHOTO_TRANSITION_ALBUM) {
      this.photoGridActionBarOpacity = 1;
      this.photoGridViewOpacity = 1;
    }
    let param: ParamAlbumInfo;
    param = router.getParams() as ParamAlbumInfo;
    if (!param || (param && !param.item)) {
      param = AppStorage.get<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM) as ParamAlbumInfo;
    }
    if (param != null) {
      if (param.isFromFACard) {
        this.isFromFACard = param.isFromFACard;
      }
      this.albumInfo = JSON.parse(param.item);
      this.title = this.albumInfo.albumName;
      this.dataSource.setAlbumUri(this.albumInfo.uri);
      if (this.albumInfo.mediaItem) {
        let mediaItem = this.albumInfo.mediaItem;
        this.dataSource.items = [mediaItem];
        this.dataSource.size = 1;
        this.dataSource.dataIndexes = [0];
        this.photoTotalCount = this.albumInfo.count;
      }
    }

    let self = this;
    this.dataSource.setBroadCast(this.broadCast)
    this.mSelectManager.setPhotoDataImpl();
    this.mSelectManager.setAlbumUri(this.albumInfo.uri);
    this.mSelectManager.setGetMediaItemFunc(
      (uri: string, itemNotifyCallback: Function): MediaItem | undefined => {
        return this.dataSource?.getMediaItemByUriFromAll(uri, itemNotifyCallback);
      });
    MediaObserver.getInstance().registerObserver(this.dataObserver);

    this.broadCast.on(BroadCastConstants.SELECT, this.selectFunc);
    this.broadCast.on(BroadCastConstants.JUMP_PHOTO_BROWSER, this.jumpPhotoBrowserFunc);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
    this.broadCast.on(Constants.ON_LOADING_FINISHED, this.onLoadingFinishedFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorStateFunc);
    this.appBroadCast.on(BroadCastConstants.DO_ANIMATION, this.onDoAnimationFunc);

    AppStorage.setOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, this.mSelectManager);
    this.mSelectManager.registerCallback('allSelect', (newState: boolean) => {
      Log.info(TAG, `allSelect ${newState}`);
      if (this.isDataFreeze) {
        return;
      }
      this.isAllSelected = newState;
      this.dataSource.forceUpdate();
    });
    this.mSelectManager.registerCallback('updateCount', (newState: number) => {
      Log.info(TAG, `updateSelectedCount ${newState}`);
      if (this.isDataFreeze) {
        return;
      }
      this.moreMenuList = Boolean(newState) ? (this.albumInfo.isSystemAlbum ?
        [Action.ADD, Action.INFO] : [Action.MOVE, Action.ADD, Action.REMOVE_FROM, Action.INFO])
        : (this.albumInfo.isSystemAlbum ? [Action.ADD_INVALID, Action.INFO_INVALID] :
          [Action.MOVE_INVALID, Action.ADD_INVALID, Action.REMOVE_FROM_INVALID, Action.INFO_INVALID]);
      this.totalSelectedCount = newState;
    });
    this.mSelectManager.registerCallback('select', (newState: number) => {
      Log.info(TAG, `select ${newState}`);
      if (this.isDataFreeze) {
        return;
      }
      this.dataSource.onDataChanged(newState);
    });
    this.dataSource.registerCallback('updateCount', (newState: number) => {
      Log.info(TAG, `updateTotalCount ${newState}`);
      self.isShowScrollBar = (newState > Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR);
      self.isEmpty = !Boolean(newState)
      self.mSelectManager.setTotalCount(newState);
    });

    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedFunc);

    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);

    this.initGridRowCount();
    this.moreMenuList = this.albumInfo.isSystemAlbum ?
      [Action.ADD, Action.INFO] : [Action.MOVE, Action.ADD, Action.REMOVE_FROM, Action.INFO];
    this.updateRightClickMenuList();
    TraceControllerUtils.finishTrace('PhotoGridPageAboutToAppear');
  }

  private onDoAnimation(): void {
    this.doAnimation();
    this.appBroadCast.off(BroadCastConstants.DO_ANIMATION, undefined);
  }

  private select(position: number, key: string, value: boolean, callback: Function): void {
    if (this.mSelectManager.toggle(key, value, position)) {
      Log.info(TAG, 'enter event process')
      if (!this.isSelectedMode) {
        this.isSelectedMode = true;
      }
      callback();
    }
  }

  private jumpPhotoBrowser(name: string, item: MediaItem,
                           geometryTapIndex: number, geometryTransitionString: string): void {
    let targetIndex = this.dataSource.getDataIndex(item);
    if (targetIndex == Constants.NOT_FOUND) {
      Log.error(TAG, 'targetIndex is not found');
      return;
    }
    Log.info(TAG, `jump to photo browser at index: ${targetIndex}`);
    let pageEntryFrom = Constants.ENTRY_FROM.NORMAL;
    if (this.albumInfo.isTrashAlbum) {
      pageEntryFrom = Constants.ENTRY_FROM.RECYCLE;
    } else if (this.isDistributedAlbum) {
      pageEntryFrom = Constants.ENTRY_FROM.DISTRIBUTED;
    }

    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    if (geometryTapIndex !== undefined && geometryTransitionString !== undefined) {
      this.jumpToPhotoBrowserGeometryTransition(
        targetIndex, name, pageEntryFrom, geometryTapIndex, geometryTransitionString);
    } else {
      this.jumpToPhotoBrowserNormal(targetIndex, name, pageEntryFrom);
    }
  }

  private jumpThirdPhotoBrowser(name: string, item: MediaItem,
                                geometryTapIndex: number, geometryTransitionString: string): void {
    Log.info(TAG, 'JUMP_THIRD_PHOTO_BROWSER');
    let targetIndex = this.dataSource.getDataIndex(item);
    if (targetIndex == Constants.NOT_FOUND) {
      Log.error(TAG, 'targetIndex is not found');
      return;
    }
    Log.info(TAG, `jump to photo browser at index: ${targetIndex} ${name}`);
    let pageEntryFrom = Constants.ENTRY_FROM.NORMAL;
    if (this.albumInfo.isTrashAlbum) {
      pageEntryFrom = Constants.ENTRY_FROM.RECYCLE;
    } else if (this.isDistributedAlbum) {
      pageEntryFrom = Constants.ENTRY_FROM.DISTRIBUTED;
    }
    AppStorage.setOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, this.mSelectManager);
    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    if (geometryTapIndex !== undefined && geometryTransitionString !== undefined) {
      this.jumpToSelectPhotoBrowserGeometryTransition(
        targetIndex, name, pageEntryFrom, geometryTapIndex, geometryTransitionString);
    } else {
      this.jumpToSelectPhotoBrowserNormal(targetIndex, name, pageEntryFrom);
    }
  }

  private onLoadingFinished(size: number): void {
    Log.info(TAG, `ON_LOADING_FINISHED size: ${size}`);
  }

  private onDataReloaded(): void {
    Log.info(TAG, 'ON_DATA_RELOADED');
    if (this.deleteMode) {
      animateTo({ duration: 300 }, () => {
        this.dataSource.onDataReloaded();
      })
      this.deleteMode = false;
    } else {
      this.dataSource.onDataReloaded();
    }
  }


  updateFirstPhotoItemInfo(item: MediaItem, isFirstPhotoItem: boolean): void {
    if (item) {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_FIRST_PHOTO_ITEM, isFirstPhotoItem);
      let albumUri = AppStorage.Get<string>(Constants.KEY_OF_ALBUM_URI);
      let transitionId = `${item.hashCode}_${albumUri}`;
      Log.info(TAG, `updateFirstPhotoItemInfo transitionId: ${transitionId}`);
      AppStorage.Set<string>(Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT, transitionId);
    }
  }

  jumpToPhotoBrowserNormal(targetIndex: number, name: string, pageEntryFrom: number) {
    Log.debug(TAG, 'start jump to photo browser in normal');
    router.pushUrl({
      url: 'pages/PhotoBrowser',
      params: {
        position: targetIndex,
        transition: name,
        leftBlank: this.leftBlank,
        pageFrom: pageEntryFrom,
        deviceName: this.deviceName,
        albumInfo: this.albumInfo
      }
    });
  }

  jumpToPhotoBrowserGeometryTransition(targetIndex: number, name: string, pageEntryFrom: number,
                                       geometryTapIndex: number, geometryTransitionString: string) {
    Log.debug(TAG, 'start jump to photo browser in geometry transition');

    interface Params {
      position: number;
      transition: string;
      leftBlank: number[];
      pageFrom: number;
      deviceName: string;
      albumInfo: AlbumInfo;
    }

    let params: Params = {
      position: targetIndex,
      transition: name,
      leftBlank: this.leftBlank,
      pageFrom: pageEntryFrom,
      deviceName: this.deviceName,
      albumInfo: this.albumInfo
    }
    this.browserController.showBrowser(geometryTapIndex, geometryTransitionString, TAG, params);
  }

  jumpToSelectPhotoBrowserNormal(targetIndex: number, name: string, pageEntryFrom: number) {
    Log.debug(TAG, 'start jump to select photo browser in normal');
    router.pushUrl({
      url: 'pages/SelectPhotoBrowser',
      params: {
        position: targetIndex,
        transition: name,
        pageFrom: pageEntryFrom,
      }
    });
  }

  jumpToSelectPhotoBrowserGeometryTransition(targetIndex: number, name: string, pageEntryFrom: number,
                                             geometryTapIndex: number, geometryTransitionString: string) {
    Log.debug(TAG, 'start jump to select photo browser in geometry transition');
    interface Params {
      position: number;
      transition: string;
      pageFrom: number;
    }

    const params: Params = {
      position: targetIndex,
      transition: name,
      pageFrom: pageEntryFrom,
    };
    this.browserController.showSelectBrowser(geometryTapIndex, geometryTransitionString, TAG, params);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.switchRefreshOn();
    this.dataSource.onChange(changeType);
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear`);
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.broadCast.off(BroadCastConstants.SELECT, this.selectFunc);
    this.broadCast.off(BroadCastConstants.JUMP_PHOTO_BROWSER, this.jumpPhotoBrowserFunc);
    this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
    this.broadCast.off(Constants.ON_LOADING_FINISHED, this.onLoadingFinishedFunc);
    this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_DATA_SOURCE, this.onUpdateFavorStateFunc);
    this.appBroadCast.off(BroadCastConstants.DO_ANIMATION, this.onDoAnimationFunc);
    this.dataSource.releaseBroadCast();
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataObserver.clearSource();
    this.mSelectManager?.releaseGetMediaItemFunc();
    this.mSelectManager?.unregisterCallback('allSelect');
    this.mSelectManager?.unregisterCallback('updateCount');
    this.mSelectManager?.unregisterCallback('select');
  }

  isSameTransitionId(item: MediaItem): boolean {
    return AppStorage.get<string>(Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT) as string ===
      `${item.hashCode}_${this.dataSource.albumUri}`;
  }

  getGeometryTransitionId(item: ViewData): string {
    return TAG + (item.mediaItem as MediaItem).hashCode +
    this.mSelectManager.isItemSelected((item.mediaItem as MediaItem).uri);
  }

  build() {
    Column() {
      PhotoGridPageActionBar({
        title: this.title,
        albumInfo: this.albumInfo,
        isSystemAlbum: this.albumInfo.isSystemAlbum,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        isRecycle: this.albumInfo.isTrashAlbum,
        isDistributedAlbum: this.isDistributedAlbum,
        totalSelectedCount: $totalSelectedCount
      })
        .opacity(this.photoGridActionBarOpacity)

      if (this.isEmpty) {
        NoPhotoComponent({ title: $r('app.string.no_distributed_photo_head_title_album') })
      } else {
        if (this.albumInfo.isTrashAlbum) {
          Text($r('app.string.recycle_prompt_message', Constants.RECYCLE_DAYS_MAX))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight(FontWeight.Regular)
            .width(Constants.PERCENT_100)
            .padding(this.isHorizontal ? {
              left: $r('sys.float.ohos_id_max_padding_start'),
              top: $r('app.float.recycle_prompt_message_margin_tb'),
              bottom: $r('app.float.recycle_prompt_message_margin_tb')
            } : {
              left: $r('sys.float.ohos_id_max_padding_start'),
              right: $r('sys.float.ohos_id_max_padding_end'),
              top: $r('app.float.recycle_prompt_message_margin_tb'),
              bottom: $r('app.float.recycle_prompt_message_margin_tb')
            }
            )
        }
        Stack() {
          Grid(this.scroller) {
            LazyForEach(this.dataSource, (item: ViewData, index?: number) => {
              if (!!item) {
                GridItem() {
                  ImageGridItemComponent({
                    dataSource: this.dataSource,
                    item: item.mediaItem,
                    isSelected: this.isSelectedMode ?
                    this.mSelectManager.isItemSelected((item.mediaItem as MediaItem).uri) : false,
                    isRecycle: this.albumInfo.isTrashAlbum,
                    pageName: Constants.PHOTO_TRANSITION_ALBUM,
                    onMenuClicked: (action: Action): void => this.onMenuClicked(action),
                    onMenuClickedForSingleItem: (action: Action, currentPhoto: MediaItem): void => {
                      this.onMenuClickedForSingleItem(action, currentPhoto);
                    },
                    geometryTransitionString: this.getGeometryTransitionId(item),
                    mPosition: index,
                    selectedCount: $totalSelectedCount
                  })
                }
                .zIndex(this.isSameTransitionId(item.mediaItem as MediaItem) || index === this.placeholderIndex ? 1 : 0)
                .width(this.gridItemWidth)
                .aspectRatio(1)
                .key('AlbumGridImage' + index)
              }
            }, (item: ViewData, index?: number) => {
              if (item == null || item == undefined) {
                return JSON.stringify(item);
              }
              // Update animation object
              if (index === 0) {
                if (this.scrollIndex === 0) {
                  this.updateFirstPhotoItemInfo(item.mediaItem as MediaItem, true);
                } else {
                  this.updateFirstPhotoItemInfo((
                    this.dataSource.getData(this.scrollIndex) as ViewData)?.mediaItem as MediaItem, false);
                }
              }
              return this.getGeometryTransitionId(item)
            })
          }
          .zIndex(-1)
          .clip(false)
          .onScrollIndex((index: number) => {
            this.scrollIndex = index;
            this.updateFirstPhotoItemInfo((this.dataSource.getData(index) as ViewData)?.mediaItem as MediaItem, false);
          })
          .edgeEffect(EdgeEffect.Spring)
          .scrollBar(BarState.Off)
          .columnsTemplate('1fr '.repeat(this.gridRowCount))
          .columnsGap(Constants.GRID_GUTTER)
          .rowsGap(Constants.GRID_GUTTER)
          .cachedCount(Constants.GRID_CACHE_ROW_COUNT)
          .transition(TransitionEffect.scale({
            x: BrowserConstants.PHOTO_GRID_Scale,
            y: BrowserConstants.PHOTO_GRID_Scale,
            z: BrowserConstants.PHOTO_GRID_Scale
          }))

          if (this.isShowScrollBar) {
            GridScrollBar({ scroller: this.scroller });
          }

          if (this.albumInfo.isTrashAlbum) {
            Column() {
              Row() {
                Button({ type: ButtonType.Capsule, stateEffect: true }) {
                  Text($r('app.string.action_clear_recycle'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize($r('sys.float.ohos_id_text_size_button1'))
                    .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
                    .margin({
                      left: $r('app.float.dialog_double_buttons_margin'),
                      right: $r('app.float.dialog_double_buttons_margin')
                    })
                }
                .key('ClearRecycleButton')
                .height($r('app.float.details_dialog_button_height'))
                .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
                .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
                .onClick(() => {
                  this.onMenuClicked && this.onMenuClicked(Action.CLEAR_RECYCLE);
                })
              }
              .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
              .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
            }
            .hitTestBehavior(HitTestMode.Transparent)
            .width(`100%`)
            .height('100%')
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.End)
            .padding({ bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed') })
            .visibility(this.isSelectedMode ? Visibility.Hidden : Visibility.Visible)
          }
        }
        .clip(true)
        .zIndex(-1)
        .layoutWeight(1)
        .padding({
          bottom: ((this.isSelectedMode) && !this.isHorizontal) ? Constants.ActionBarHeight : 0
        })
      }
      CustomDialogView({ broadCast: $broadCast });

      if (this.isSelectedMode) {
        PhotoGridPageToolBar({
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          isRecycleAlbum: (this.albumInfo.isTrashAlbum),
          isDistributedAlbum: this.isDistributedAlbum,
          totalSelectedCount: $totalSelectedCount
        });
      }
    }
    .clip(true)
    .opacity(this.photoGridViewOpacity)
    .backgroundColor($r('app.color.default_background_color'))
    .padding({
      top: this.leftBlank[1]
    })
  }

  private onUpdateFavorState(item: MediaItem): void {
    Log.debug(TAG, 'onUpdateFavorState');
    let index = this.dataSource.getIndexByMediaItem(item);
    if (index != -1) {
      this.dataSource.onDataChanged(index);
    }
  }

  private moveOperation(albumName: string, albumUri: string): void {
    let menuContext = new MenuContext();
    if (this.isMvOrCpSeparatesItem) {
      menuContext.withMediaItem(this.mvOrCpSeparatesItem);
      this.onMoveStart && this.onMoveStart();
    } else {
      menuContext.withSelectManager(this.mSelectManager).withOperationStartCallback((): void => this.onMoveStart());
    }
    menuContext.withOperationEndCallback((err: Error, count: number, total: number): void =>
    this.onMoveEnd(err as Object, count, total))
      .withBroadCast(this.broadCast)
      .withTargetAlbumName(albumName)
      .withAlbumUri(albumUri);
    let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
    AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_SOURCE, this.albumInfo.uri);
    menuOperation.doAction();
  }

  private addOperation(albumName: string, albumUri: string): void {
    let menuContext = new MenuContext();
    if (this.isMvOrCpSeparatesItem) {
      menuContext.withMediaItem(this.mvOrCpSeparatesItem);
      this.onCopyStart && this.onCopyStart();
    } else {
      menuContext.withSelectManager(this.mSelectManager).withOperationStartCallback((): void => this.onCopyStart());
    }
    menuContext.withOperationEndCallback((err: Error, count: number, total: number): void =>
    this.onCopyEnd(err as Object, count, total))
      .withBroadCast(this.broadCast)
      .withTargetAlbumName(albumName)
      .withAlbumUri(albumUri);
    let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
    menuOperation.doAction();
  }

  private onMenuClickedForSingleItem(action: Action, currentPhoto: MediaItem) {
    Log.info(TAG, `single menu click, action: ${action?.actionID}, currentUri: ${currentPhoto?.uri}`);
    if (currentPhoto == undefined) {
      return;
    }
    let menuOperation: MenuOperation;
    let menuContext: MenuContext;
    if (action.actionID === Action.RECOVER.actionID) {
      menuContext = new MenuContext();
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(RecoverMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.DELETE.actionID) {
      menuContext = new MenuContext();
      if (this.dataSource.albumUri == UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE)) {
        menuContext.withAlbumUri(UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE));
      }
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(DeleteMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.MOVE.actionID) {
      this.isMvOrCpSeparatesItem = true;
      this.mvOrCpSeparatesItem = currentPhoto;
      this.routeToSelectAlbumPage(MediaOperationType.Move, [currentPhoto]);
    } else if (action.actionID === Action.ADD.actionID) {
      this.isMvOrCpSeparatesItem = true;
      this.mvOrCpSeparatesItem = currentPhoto;
      this.routeToSelectAlbumPage(MediaOperationType.Add, [currentPhoto]);
    } else if (action.actionID === Action.REMOVE_FROM.actionID) {
      menuContext = new MenuContext();
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(RemoveMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.INFO.actionID) {
      this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [currentPhoto, false]);
    }
  }

  private initGridRowCount(): void {
    let contentWidth = ScreenManager.getInstance().getWinWidth();
    let margin = 0;
    let maxThumbWidth = px2vp(Constants.GRID_IMAGE_SIZE) * Constants.GRID_MAX_SIZE_RATIO;
    // 原型机竖屏为4不变，横屏需计算: currentBreakpoint == 'lg' 表示横屏
    const currentBreakpoint: string = AppStorage.get<string>('currentBreakpoint') as string;
    this.gridRowCount = currentBreakpoint == Constants.BREAKPOINT_LG ?
    Math.max(Constants.GRID_MIN_COUNT, Math.ceil(((contentWidth - Constants.NUMBER_2 * margin) +
    Constants.GRID_GUTTER) / (maxThumbWidth + Constants.GRID_GUTTER))) : Constants.GRID_MIN_COUNT;
    this.gridItemWidth = (contentWidth - (this.gridRowCount - 1) * Constants.GRID_GUTTER -
      Constants.NUMBER_2 * margin) / this.gridRowCount;
    Log.info(TAG, `initGridRowCount contentWidth: ${contentWidth}`);
  }

  private onUpdateRemoteDevice(res: string, deviceId: string): void {
    Log.info(TAG, `onUpdateRemoteDevice`);
    if (res == 'offline') {
      Log.debug(TAG, `device offline route to album main`);
      router.back({
        url: 'pages/index',
        params: {
          jumpSource: JumpSourceToMain.ALBUM,
        }
      });
    } else {
      Log.error(TAG, `res code is err ${res}`);
      return;
    }
  }
}

interface Params {
  albumName: string;
  albumUri: string;
  pageType: string;
};

interface ParamAlbumInfo {
  item: string;
  isFromFACard: boolean;
};