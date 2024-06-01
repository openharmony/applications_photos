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
import bundle from '@ohos.bundle';
import CommonEvent from '@ohos.commonEvent';
import window from '@ohos.window';
import { BrowserConstants, MenuOperation, ViewData } from '@ohos/common';
import {
  Action,
  AddMenuOperation,
  AlbumDefine,
  AlbumInfo,
  BigDataConstants,
  BreakpointSystem,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  CommonObserverCallback,
  Constants,
  DateUtil,
  DeleteMenuOperation,
  JumpSourceToMain,
  Log,
  MediaDataSource,
  MediaItem,
  MediaObserver,
  MediaOperationType,
  MenuContext,
  MenuOperationFactory,
  MoveMenuOperation,
  BrowserConstants as PhotoConstants,
  PhotoDataSource,
  RemoveMenuOperation,
  ReportToBigDataUtil,
  ScreenManager,
  ShareMenuOperation,
  TraceControllerUtils,
  UiUtil,
  UriDataSource,
  UserFileManagerAccess,
  WindowUtil
} from '@ohos/common';
import {
  BrowserController,
  CustomDialogView,
  PhotoBrowserComponentBg,
  PhotoBrowserHolder,
  PhotoSwiper
} from '@ohos/common/CommonComponents';
import {
  AddNotesMenuOperation,
  FavoriteMenuOperation,
  GotoPhotosMenuOperation,
  RecoverMenuOperation,
  RenameMenuOperation,
  RotateMenuOperation
} from '@ohos/browser';
import {
  PhotoBrowserActionBar,
  PhotoBrowserToolBar
} from '@ohos/browser/BrowserComponents';
import ability from '@ohos.ability.ability';
import common from '@ohos.app.ability.common';

const TAG: string = 'PhotoBrowserComponent';

interface ParamBrowser {
  pageFrom: number;
  albumInfo: AlbumInfo;
  clickThumbnailTime: number;
  albumUri: string;
  index: number;
  uri: string;
  viewData: ViewData;
  viewDataIndex: string;
  viewDataAlbum: string;
  transition: string;
  position: number;
  isShowMenuFromThirdView: boolean;
  deviceName: string;
  deviceId: string;
};

interface Params {
  pageType: string;
  albumName: string;
  albumUri: string;
};

interface TitleName {
  title: string;
  displayName: string;
}

// page of large photo
@Component
export struct PhotoBrowserComponent {
  @Provide backgroundColorResource: Resource = $r('app.color.default_background_color');
  @Provide('dateTitle') photoDate: string = '';
  @Provide('timeLocationTitle') timeAndLocation: string = '';
  @Provide menuList: Action[] = [];
  @Provide toolMenuList: Action[] = [];
  @Provide topMenuList: Action[] = [];
  @Provide moreMenuList: Action[] = [];
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide isShowBar: boolean = true;
  @Provide onlyChangeBgColor: boolean = false;
  @Provide canSwipe: boolean = true;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @State @Watch('updateMoreMenu') currentShow: boolean = true;
  @StorageLink('isHorizontal') @Watch('updateIsHorizontal') isHorizontal: boolean = ScreenManager.getInstance()
    .isHorizontal();
  @StorageLink('timelinePageIndex') timelinePageIndex: number = Constants.INVALID;
  @StorageLink('photoGridPageIndex') photoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
  mTransition: string = '';
  albumUri = '';
  // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
  @Provide('transitionIndex') currentIndex: number = Constants.NUMBER_0;
  controller?: SwiperController = new SwiperController();
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @StorageLink('geometryOpacity') geometryOpacity: number = 1;
  @State geometryTransitionId: string = '';
  @Link isRunningAnimation: boolean;
  @ObjectLink browserController: BrowserController;
  @Provide isDeleting: boolean = false;
  @Provide hidePopup: boolean = false;
  private isFirstLoad: boolean = true;
  private bundleFlags = Constants.NUMBER_0;
  // DataSource
  private dataSource: PhotoDataSource = new PhotoDataSource();
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  // The global BroadCast of the application process. Event registration and destruction should be paired
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private isFromCamera = false;
  private isFromViewDataWithMediaUri = false;
  private isFromViewDataWithThirdUri = false;
  private isFromFACard = false;
  private isPullDown = false;
  // the source of jump to the index page
  private jumpSourceToMain: number = JumpSourceToMain.None;
  // time when clicks the thumbnail from the camera
  private clickThumbnailTime = Constants.NUMBER_0;
  // time to view the current picture
  private checkedTransition: string = '';
  private viewTime = Constants.NUMBER_0;
  // When clicking quickly, only run aboutToAppear for the first time
  private hasAppeared: boolean = false;
  private albumInfo?: AlbumInfo;
  private deviceName = '';
  private backFromCopy = false;
  private uriFromThirdPartyApp: string = '';
  private editNewUri: string = '';
  private favorCacheItemsMap = new Map<String, MediaItem>()
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  private theDeleteItem: MediaItem | null = null;
  private geometryTransitionEnable: boolean = false;
  private isShowMenuFromThirdView: boolean = true;
  private isToEdit = false;
  private photoBrowserBackFunc: Function = (): void => this.photoBrowserBack();
  private onToggleBarsFunc: Function = (backgroundColorResource?: Resource): void =>
  this.onToggleBars(backgroundColorResource);
  private showBarsFunc: Function = (backgroundColorResource?: Resource): void => this.showBars(backgroundColorResource);
  private hideBarsFunc: Function = (backgroundColorResource?: Resource): void => this.hideBars(backgroundColorResource);
  private pullDownStartFunc: Function = (): void => this.pullDownStart();
  private pullDownEndFunc: Function = (): void => this.pullDownEnd();
  private onDataSizeChangedFunc: Function = (size: number): void => this.onDataSizeChanged(size);
  private onDataContentChangedFunc: Function = (): void => this.onDataContentChanged();
  private setFavorFunc: Function = (isFavor: boolean): void => this.setFavor(isFavor);
  private doRenameFunc: Function = (result: TitleName): void => this.doRename(result);
  private doRotateFunc: Function = (result: number): void => this.doRotate(result);
  private pullDownStartWithEventFunc: Function = (event: KeyEvent): void => this.pullDownStartWithEvent(event);
  private pullDownCancelFunc: Function = (): void => this.pullDownCancel();
  private onPhotoBrowserDeleteConfirmFunc: Function = (): void => this.onPhotoBrowserDeleteConfirm();
  private onPhotoBrowserRemoveConfirmFunc: Function = (): void => this.onPhotoBrowserRemoveConfirm();
  private doDeleteFunc: Function = (): void => this.doDelete();
  private onPhotoShowStateChangedFunc: Function = (state: boolean): void => this.onPhotoShowStateChanged(state);
  private setSwiperDisableFunc: Function = (value: boolean): void => this.setSwiperDisable(value);
  private onDataReloadWithEditFunc: Function = (): void => this.onDataReloadWithEdit();


  onPageChanged() {
    Log.info(TAG, `call page status changed ${this.pageStatus}`)
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  discardCallback(): void {
    Log.debug(TAG, 'discardCallback called');
  }

  updateIsHorizontal(): void {
    if (this.isHorizontal) {
      ScreenManager.getInstance().setSystemUi(false);
    } else {
      if (this.isShowBar) {
        ScreenManager.getInstance().setSystemUi(true);
      }
    }

    if (!this.isFirstLoad) {
      this.updateMenu(this.currentIndex);
    } else {
      this.isFirstLoad = false;
    }
  }

  onMenuClicked(action: Action): void {
    let actionID: number = action.actionID;
    Log.info(TAG, `onMenuClicked, actionID: ${actionID}`);
    let menuOperation: MenuOperation | null = null;
    let menuContext: MenuContext = new MenuContext();
    let currentPhoto = this.getCurrentPhoto();
    if (actionID === Action.BACK.actionID) {
      this.onBackPress();
    } else if (actionID === Action.INFO.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined');
        return;
      }
      this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG,
        [currentPhoto, this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED]);
    } else if (actionID === Action.SHARE.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined');
        return;
      }
      menuContext.withFromSelectMode(false).withMediaItem(currentPhoto);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(ShareMenuOperation, menuContext);
    } else if (actionID === Action.NOT_FAVORITE.actionID || actionID === Action.FAVORITE.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined.');
        return;
      }
      currentPhoto.isFavor = !currentPhoto.isFavor;

      if (this.albumUri !== UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)) {
        let currentPhoto = this.getCurrentPhoto();
        menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(FavoriteMenuOperation, menuContext);
        this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
      } else {
        if (currentPhoto.isFavor === true) {
          if (this.favorCacheItemsMap.has(currentPhoto.uri)) {
            this.favorCacheItemsMap.delete(currentPhoto.uri);
          } else {
            Log.error(TAG, `not fount item uri ${currentPhoto.uri}`);
          }
        } else {
          this.favorCacheItemsMap.set(currentPhoto.uri, currentPhoto);
        }
      }
      this.updateMenu(this.currentIndex);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + 'false';
      AppStorage.setOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
    } else if (actionID === Action.DELETE.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined.');
        return;
      }
      menuContext.withAlbumInfo(this.albumInfo);
      this.theDeleteItem = currentPhoto;
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(DeleteMenuOperation, menuContext);
    } else if (actionID === Action.RECOVER.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined.');
        return;
      }
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(RecoverMenuOperation, menuContext);
    } else if (actionID === Action.GOTO_PHOTOS.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined.');
        return;
      }
      menuContext.withJumpSourceToMain(this.jumpSourceToMain);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(GotoPhotosMenuOperation, menuContext);
    } else if (actionID === Action.EDIT.actionID) {
      if (currentPhoto == undefined || currentPhoto.size == 0) {
        Log.warn(TAG, 'currentPhoto is undefined or size is 0.');
        return;
      }
      AppStorage.setOrCreate<MediaItem | undefined>('EditorMediaItem', currentPhoto);
      AppStorage.setOrCreate<string>('EditorAlbumUri', this.albumUri);
      router.pushUrl({
        url: 'pages/EditMain'
      })
      this.isToEdit = true;
    } else if (actionID === Action.EDIT_INVALID.actionID) {
      if (currentPhoto == undefined || currentPhoto.size == 0) {
        Log.warn(TAG, 'currentPhoto is undefined or size is 0.');
        return;
      }
    } else if (actionID === Action.RENAME.actionID) {
      this.hidePopup = true;
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined.');
        return;
      }
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast).withAlbumUri(this.albumUri);
      menuOperation = MenuOperationFactory.getInstance().createMenuOperation(RenameMenuOperation, menuContext);
    } else if (actionID === Action.ROTATE.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.RENAME.');
        return;
      }
      let rotateValue = currentPhoto.orientation - Constants.DEFAULT_ROTATE_VALUE + Constants.ROTATE_AROUND;
      if (rotateValue >= Constants.ROTATE_AROUND) {
        rotateValue = rotateValue - Constants.ROTATE_AROUND;
      }
      currentPhoto.orientation = rotateValue;
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance().createMenuOperation(RotateMenuOperation, menuContext);
    } else if (actionID === Action.ADD_NOTES.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.RENAME.');
        return;
      }
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddNotesMenuOperation, menuContext);
    } else if (actionID === Action.MOVE.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.MOVE.');
        return;
      }
      this.backFromCopy = true;
      currentPhoto && currentPhoto.mediaType &&
      this.routeToSelectAlbumPage(MediaOperationType.Move, currentPhoto.mediaType);
      return;
    } else if (actionID === Action.ADD.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.ADD.');
        return;
      }
      this.backFromCopy = true;
      currentPhoto && currentPhoto.mediaType &&
      this.routeToSelectAlbumPage(MediaOperationType.Add, currentPhoto.mediaType);
    } else if (actionID === Action.REMOVE_FROM.actionID) {
      if (currentPhoto == undefined) {
        Log.warn(TAG, 'currentPhoto is undefined.');
        return;
      }

      menuContext.withAlbumUri(this.albumUri);
      menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(RemoveMenuOperation, menuContext);
    } else if (actionID === Action.DOWNLOAD.actionID) {
      this.downLoad();
    }
    if (!!menuOperation) {
      menuOperation.doAction();
    }
  }

  routeToSelectAlbumPage(pageType: string, mediaType: number): void {
    router.pushUrl({
      url: 'pages/MediaOperationPage',
      params: {
        pageFrom: Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER,
        pageType: pageType,
        albumInfo: this.albumInfo,
        mediaType: mediaType
      }
    });
  }

  onPhotoChanged(index: number): void {
    Log.info(TAG, `onPhotoChanged start, index=${index}`);
    this.reportToBigDataForPhotoSlide(index);
    this.currentIndex = index;
    this.updateActionBar(index);
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    if (currentPhoto == undefined) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
    } else {
      let timelineIndex = this.dataSource.getPositionByIndex(index);
      AppStorage.setOrCreate<number>('placeholderIndex', timelineIndex);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + 'false';
      AppStorage.setOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
      Log.debug(TAG, `onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}, \
        placeholderIndex ${AppStorage.get<number>('placeholderIndex') as number},\
        geometryTransitionBrowserId ${this.geometryTransitionId}, this.mTransition ${this.mTransition}, \
        pageFrom = ${this.pageFrom}`);
    }
    this.updatePixMapDataSource();
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG, `onDataSizeChanged, size is ${size}`);
    if (size == 0 && !this.isToEdit) {
      if (this.uriFromThirdPartyApp) {
        return;
      }
      this.onBackPress();
    }
  }

  resetAlbum(albumUri: string): void {
    this.currentIndex = 0;
    Log.info(TAG, `not found in album[${this.albumUri}], so use ${albumUri} instead`);
    this.albumUri = albumUri;
    this.dataSource.resetAlbumUri(this.albumUri);
    return;
  }

  updatePixMapDataSource(): void {
    this.dataSource.updatePixMapDataSource(this.currentIndex);
  }

  updateActionBar(index: number): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    if (currentPhoto == undefined || this.isFromViewDataWithThirdUri) {
      return;
    }
    this.photoDate = DateUtil.getLocalizedDate(currentPhoto?.getDataTaken());
    if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
      this.timeAndLocation = `${this.deviceName}/${DateUtil.getLocalizedTime(currentPhoto?.getDataTaken())}`;
    } else {
      this.timeAndLocation = DateUtil.getLocalizedTime(currentPhoto?.getDataTaken());
    }
    this.updateMenu(index);
  }

  updateMenu(index: number): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    if (!currentPhoto) {
      return;
    }

    if (this.albumUri == UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)) {
      let key = currentPhoto.uri;
      if (this.favorCacheItemsMap.has(key)) {
        let tempPhotoItem: MediaItem = this.favorCacheItemsMap.get(key) as MediaItem;
        currentPhoto.isFavor = tempPhotoItem.isFavor;
        this.favorCacheItemsMap.set(key, currentPhoto);
      }
    }

    let pageFrom: number = this.pageFrom;
    if (this.albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE)) {
      pageFrom = Constants.ENTRY_FROM.RECYCLE;
    }

    Log.info(TAG, `updateMenu album[${this.albumUri}]`);

    let menuTemp: Action[] = [];
    if (this.pageFrom == Constants.ENTRY_FROM.CAMERA ||
      this.pageFrom == Constants.ENTRY_FROM.CARD ||
      (this.isFromViewDataWithMediaUri == true &&
        this.albumUri != UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE))) {
      menuTemp = [Action.GOTO_PHOTOS, Action.INFO];
    } else if (pageFrom == Constants.ENTRY_FROM.RECYCLE || this.isFromViewDataWithThirdUri == true) {
      menuTemp = [];
    } else {
      menuTemp = [Action.INFO];
    }
    if (!UiUtil.isActionArrayEqual(this.menuList, menuTemp)) {
      this.menuList = menuTemp;
    }

    let list: Action[] = [];
    if (pageFrom === Constants.ENTRY_FROM.NORMAL || pageFrom === Constants.ENTRY_FROM.CAMERA) {
      list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE,
        ((currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_IMAGE))
          ? Action.EDIT : Action.EDIT_INVALID, Action.DELETE, Action.MORE); // TODO: delete edit
    } else if (pageFrom === Constants.ENTRY_FROM.RECYCLE) {
      list.push(Action.RECOVER, Action.DELETE);
    } else if (pageFrom === Constants.ENTRY_FROM.DISTRIBUTED) {
      list.push(Action.DOWNLOAD);
    } else {
      list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE,
        ((currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_IMAGE))
          ? Action.EDIT : Action.EDIT_INVALID, Action.DELETE, Action.MORE); // TODO: delete edit
    }

    if (this.isHorizontal) {
      if (this.isShowMenuFromThirdView) {
        this.menuList = this.menuList.concat(list);
      }
      this.toolMenuList = [];
    } else {
      if (this.isShowMenuFromThirdView) {
        if (!UiUtil.isActionArrayEqual(this.toolMenuList, list)) {
          this.toolMenuList = list;
        }
      } else {
        this.toolMenuList = [];
      }
    }
    let menuTempList: Action[] = [];
    if (!this.albumInfo) {
      // 照片页
      menuTempList = [Action.ADD, Action.RENAME];
    } else {
      // 指定相册
      menuTempList = this.albumInfo.isSystemAlbum ?
        [Action.ADD, Action.RENAME] : [Action.MOVE, Action.ADD, Action.REMOVE_FROM, Action.RENAME];
    }
    if (!UiUtil.isActionArrayEqual(this.moreMenuList, menuTempList)) {
      this.moreMenuList = menuTempList;
    }
  }

  isShowMenuBigData(isShowMenuFromThirdView: boolean): void {
    interface ShowMenuMsg {
      isShowMenuFromThirdView: string
    }
    let isShowMenuMsg: ShowMenuMsg;
    if (isShowMenuFromThirdView) {
      this.isShowMenuFromThirdView = true;
      isShowMenuMsg = {
        isShowMenuFromThirdView: BigDataConstants.SHOW_MENU
      }
    } else if (isShowMenuFromThirdView == false) {
      this.isShowMenuFromThirdView = false;
      isShowMenuMsg = {
        isShowMenuFromThirdView: BigDataConstants.HIDE_MENU
      }
    } else {
      this.isShowMenuFromThirdView = true;
      isShowMenuMsg = {
        isShowMenuFromThirdView: BigDataConstants.UNDEFINED_IS_SHOW_MENU
      }
    }
    this.updateMenu(this.currentIndex);
    ReportToBigDataUtil.statisticReport(BigDataConstants.IS_SHOW_MENU_ID, isShowMenuMsg);
  }

  updateMoreMenu(): void {
    this.moreMenuList = this.albumInfo?.isSystemAlbum ?
      [Action.ADD, Action.RENAME] : [Action.MOVE, Action.ADD, Action.REMOVE_FROM, Action.RENAME];
  }

  getCurrentPhoto(): MediaItem {
    return this.dataSource?.getRawData(this.currentIndex).data;
  }

  getPhotoByIndex(index: number): MediaItem {
    return this.dataSource?.getRawData(index).data;
  }

  async onMoveEnd(err: Object, count: number, total: number): Promise<void> {
    Log.debug(TAG, `onMoveEnd count: ${count}, total: ${total}`);
    if (err) {
      UiUtil.showToast($r('app.string.move_failed_single'));
      return;
    }
    let currentPhoto = this.getCurrentPhoto();
    let newItem = await this.dataSource.getDataByUri(currentPhoto.uri)
    this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
  }

  onCopyEnd(err: Object, count: number, total: number): void {
    Log.debug(TAG, `onCopyEnd count: ${count}, total: ${total}`);
    if (err) {
      UiUtil.showToast($r('app.string.copy_failed_single'));
    }
  }

  async onDownloadEnd(err: Object, count: number, total: number): Promise<void> {
    Log.debug(TAG, `onDownloadEnd count: ${count}, total: ${total}`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    if (err) {
      UiUtil.showToast($r('app.string.download_failed_single'));
    } else {
      UiUtil.showToast($r('app.string.download_progress_done'));
    }
  }

  onBackPress(): boolean {
    Log.info(TAG, 'onBackPress');
    this.appBroadCast.emit('hideBar', []);
    let currentPhoto = this.getPhotoByIndex(this.currentIndex);
    this.broadCast.emit(BrowserConstants.RESET_DEFAULT_SCALE + currentPhoto.uri, []);
    this.controller?.finishAnimation((): void => this.onBackPressInner());
    return true;
  }

  onBackPressInner(): void {
    Log.info(TAG, `onBackPressInner ${this.checkedTransition}`);
    this.dataSource.release();
    if (this.checkedTransition === Constants.PHOTO_TRANSITION_TIMELINE) {
      Log.info(TAG, 'onBackPress TimelinePage');
      this.timelinePageIndex = this.currentIndex; // call scrollTo
      this.timelinePageIndex = Constants.INVALID;
    } else if (this.checkedTransition === Constants.PHOTO_TRANSITION_ALBUM) {
      Log.info(TAG, 'onBackPress PhotoGridPage');
      this.photoGridPageIndex = this.currentIndex; // call scrollTo
      this.photoGridPageIndex = Constants.INVALID;

      if (this.isFromFACard) {
        if (this.isPullDown) {
          this.isPullDown = false;
          let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
          context.terminateSelf();
        } else {
          let displayName: string = AppStorage.get<string>('form_displayName') as string;
          let uri: string = AppStorage.get<string>('form_albumUri') as string;
          let item: AlbumInfo = new AlbumInfo(undefined);
          item.uri = uri;
          item.albumName = displayName;
          router.replaceUrl({
            url: 'pages/PhotoGridPage',
            params: {
              item: JSON.stringify(item),
              isFromFACard: this.isFromFACard
            }
          });
        }

        if (this.geometryTransitionEnable) {
          UiUtil.resetGeometryTransitionParams();
        }
        this.breakpointSystem.unregisterOrientationChange();
        WindowUtil.setPreferredOrientation(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext,
          window.Orientation.UNSPECIFIED);
        return;
      }
    } else if (this.checkedTransition === Constants.PHOTO_TRANSITION_CAMERA) {
      Log.info(TAG, 'onBackPress Camera');
      // Entering from the camera does not need to return to close directly
      let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
      context.terminateSelf();
    } else if (this.checkedTransition === Constants.PHOTO_TRANSITION_THIRD_APP) {
      Log.info(TAG, 'onBackPress third app');
      this.setViewDataResult(true);
    }
    if (this.geometryTransitionEnable) {
      this.browserController.hideBrowser();
    } else {
      router.back({
        url: '',
        params: {
          index: this.currentIndex
        }
      });
    }
  }

  updatePhotoName(result: TitleName): void {
    let currentPhoto = this.getCurrentPhoto();
    currentPhoto.setTitle(result.title);
    currentPhoto.displayName = result.displayName;
    this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'photoBrowser aboutToDisappear');
    this.favorCacheItemsMap.forEach((item) => {
      let menuFavorContext = new MenuContext().withMediaItem(item).withBroadCast(this.broadCast);
      let menuFavorOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(FavoriteMenuOperation, menuFavorContext);
      menuFavorOperation.doAction();
    });

    if (!this.isShowBar && !this.isHorizontal) {
      ScreenManager.getInstance().setSystemUi(true);
    }
    // Click the thumbnail quickly, hasAppeared is false if it is not the first click. Return directly
    if (!this.hasAppeared) {
      return;
    }
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataObserver.clearSource();

    if (!this.isFromFACard) {
      this.breakpointSystem.unregisterOrientationChange();
      WindowUtil.setPreferredOrientation(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext,
        window.Orientation.UNSPECIFIED);
    }

    this.broadCast.off(PhotoConstants.TOGGLE_BAR, this.onToggleBarsFunc);
    this.broadCast.off(PhotoConstants.HIDE_BARS, this.hideBarsFunc);
    this.broadCast.off(PhotoConstants.SHOW_BARS, this.showBarsFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_START, this.pullDownStartFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_END, this.pullDownEndFunc);
    this.broadCast.off(PhotoConstants.DATA_SIZE_CHANGED, this.onDataSizeChangedFunc);
    this.broadCast.off(PhotoConstants.DATA_CONTENT_CHANGED, this.onDataContentChangedFunc);
    this.broadCast.off(PhotoConstants.SET_FAVOR, this.setFavorFunc);
    this.broadCast.off(PhotoConstants.RENAME, this.doRenameFunc);
    this.broadCast.off(PhotoConstants.ROTATE, this.doRotateFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_START, this.pullDownStartWithEventFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_CANCEL, this.pullDownCancelFunc);
    this.broadCast.off(PhotoConstants.PHOTO_BROWSER_DELETE_CONFIRM, this.onPhotoBrowserDeleteConfirmFunc);
    this.broadCast.off(PhotoConstants.PHOTO_BROWSER_REMOVE_CONFIRM, this.onPhotoBrowserRemoveConfirmFunc);
    this.broadCast.off(PhotoConstants.DELETE, this.doDeleteFunc);
    this.broadCast.off(PhotoConstants.PHOTO_SHOW_STATE, this.onPhotoShowStateChangedFunc);
    this.broadCast.off(PhotoConstants.SET_DISABLE_SWIPE, this.setSwiperDisableFunc);
    this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, this.onDataReloadWithEditFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, this.photoBrowserBackFunc);

    this.controller = undefined;
  }

  getAlbumUriByUri(albumUri: string) {
    if (albumUri && albumUri.length > 0) {
      return albumUri;
    }

    return '';
  }

  aboutToAppear(): void {
    TraceControllerUtils.startTrace('PhotoBrowserAboutToAppear');
    Log.info(TAG, 'photoBrowser aboutToAppear');
    AppStorage.setOrCreate('isEditFunc', false);
    this.geometryTransitionId = AppStorage.get<string>('geometryTransitionBrowserId') as string;
    this.hasAppeared = true;
    this.updateIsHorizontal();

    WindowUtil.setPreferredOrientation(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext,
      window.Orientation.AUTO_ROTATION_RESTRICTED);
    this.appBroadCast.emit('hideBar', []);
    let param: ParamBrowser = this.browserController.browserParam as ParamBrowser;
    let entryFromCamera = (AppStorage.get<number>('entryFromHapCamera')) as number == Constants.ENTRY_FROM_CAMERA;
    Log.info(TAG, `photoBrowser start with entryFrom ` + JSON.stringify(entryFromCamera));
    if (entryFromCamera) {
      param = {
        pageFrom: Constants.ENTRY_FROM.CAMERA
      } as ParamBrowser;
      AppStorage.setOrCreate('entryFromHapCamera', Constants.ENTRY_FROM_NONE);
    }

    if (param) {
      Log.info(TAG, `photoBrowser start with param`);
      Log.debug(TAG, `param: ${JSON.stringify(param)}`);
      if (param.pageFrom) {
        this.pageFrom = param.pageFrom;
      }
      if (param.albumInfo) {
        this.albumInfo = param.albumInfo;
        this.albumUri = param.albumInfo.uri;
        this.deviceName = param.albumInfo.deviceName;
      }
      if (this.pageFrom == Constants.ENTRY_FROM.CAMERA) {
        this.dataSource = new PhotoDataSource();
        this.dataSource.initData();
        this.isFromCamera = true;
        this.clickThumbnailTime = param.clickThumbnailTime ? param.clickThumbnailTime : 0;
        this.albumUri = '';
        this.jumpSourceToMain = JumpSourceToMain.CAMERA;
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE);
      } else if (this.pageFrom == Constants.ENTRY_FROM.CARD) {
        this.dataSource = new PhotoDataSource();
        this.albumUri = param.albumUri;
        this.dataSource.enableGetData(false);
        this.dataSource.setAlbumUri(this.albumUri);
        this.dataSource.initData();
        this.isFromCamera = true;
        this.jumpSourceToMain = JumpSourceToMain.CAMERA;
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.uriFromThirdPartyApp = param.uri;
        this.currentIndex = param.index;
        this.onGetItemIndexByUri(this.currentIndex)
        this.isFromFACard = true;
        this.geometryTransitionEnable = true;
      } else if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
        this.dataSource.setAlbumUri(this.albumUri);
        this.dataSource.setAlbumDataSource
        (AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) as MediaDataSource);
      } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
        this.dataSource.setDeviceId(param.albumInfo.deviceId);
        this.dataSource.setAlbumDataSource(
            AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) as MediaDataSource);
      } else if (this.pageFrom == Constants.ENTRY_FROM.VIEW_DATA) {
        if (String(param.viewData).length === 0) {
          Log.error(TAG, 'Invalid uri');
          this.setViewDataResult(false);
          return;
        }
        Log.info(TAG, `Found viewIndex: ${String(param.viewDataIndex).length}`);
        if (String(param.viewDataIndex).length > 0) {
          Log.debug(TAG, `Found viewIndex`);
          this.dataSource = new UriDataSource(String(param.viewData).split('?'));
          let viewIndex = Number.parseInt(param.viewDataIndex);
          if (Number.isNaN(viewIndex) || viewIndex <= 0 || viewIndex > String(param.viewData).split('?').length) {
            viewIndex = 0;
          } else {
            viewIndex -= 1;
          }
          this.isFromViewDataWithThirdUri = true;
          this.currentIndex = viewIndex;
          param.position = viewIndex;
        } else {
          let uriCount = String(param.viewData).split(',').length;
          if (uriCount > Constants.NUMBER_1) {
            Log.error(TAG, 'Invalid uri');
            this.setViewDataResult(false);
            return;
          }

          if (String(param.viewData).startsWith(PhotoDataSource.MEIDA_URL_PREFIX_STR) ||
          String(param.viewData).startsWith(PhotoDataSource.IMAGE_URL_PREFIX_STR_V10) ||
          String(param.viewData).startsWith(PhotoDataSource.VIDEO_URL_PREFIX_STR_V10) ||
          String(param.viewData).startsWith(PhotoDataSource.IMAGE_VIDEO_URL_PREFIX_STR_V10)) {
            Log.debug(TAG, `Found media library uri`);
            this.dataSource = new PhotoDataSource(this.albumUri);
            this.albumUri = this.getAlbumUriByUri(param.viewDataAlbum);
            Log.info(TAG, `album id: ${this.albumUri}`);
            this.dataSource.enableGetData(false);
            this.dataSource.setAlbumUri(this.albumUri);
            this.dataSource.initData();
            this.isFromViewDataWithMediaUri = true;
            this.clickThumbnailTime = 0;
            this.jumpSourceToMain = JumpSourceToMain.CAMERA;
            MediaObserver.getInstance().registerObserver(this.dataObserver);
            this.uriFromThirdPartyApp = String(param.viewData);
            this.currentIndex = 0;
            this.dataSource.getItemIndexByUri(this.uriFromThirdPartyApp,
              (index: number): void => this.onGetItemIndexByUri(index));
            // 是否显示菜单栏并且处理大数据打点
            this.isShowMenuBigData(param.isShowMenuFromThirdView);
          } else {
            Log.debug(TAG, `Not found media library uri`);
            this.dataSource = new UriDataSource(String(param.viewData).split(','));
            this.isFromViewDataWithThirdUri = true;
          }
        }
      } else {
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.setAlbumDataSource(
          AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) as MediaDataSource);
      }

      this.onPhotoChanged(param.position || 0);
      if (this.isFromFACard) {
        this.mTransition = Constants.PHOTO_TRANSITION_ALBUM;
      } else if (this.isFromCamera) {
        this.mTransition = Constants.PHOTO_TRANSITION_CAMERA;
      } else if (this.isFromViewDataWithMediaUri || this.isFromViewDataWithThirdUri) {
        this.mTransition = Constants.PHOTO_TRANSITION_THIRD_APP;
      } else {
        this.mTransition = param.transition;
      }
    } else {
      Log.info(TAG, `photoBrowser start without param`);
      if (this.entryFromHap == Constants.ENTRY_FROM_FORM_ABILITY) {
        this.pageFrom = Constants.ENTRY_FROM.CARD;
        this.albumUri = AppStorage.get<string>('form_albumUri') as string;
      } else {
        this.pageFrom = Constants.ENTRY_FROM.CAMERA;
        this.albumUri = UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
      }
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE);
      let albumDataSource: MediaDataSource =
        AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) as MediaDataSource;
      if (albumDataSource) {
        this.dataSource.setAlbumDataSource(albumDataSource);
      } else {
        Log.error(TAG, `Constants.APP_KEY_PHOTO_BROWSER is null, so use all album instead`);
        this.dataSource.initData();
      }
      this.isFromCamera = true;
      this.jumpSourceToMain = JumpSourceToMain.CAMERA;
      MediaObserver.getInstance().registerObserver(this.dataObserver);
      this.onPhotoChanged(AppStorage.Get('form_currentIndex') || 0);
      this.mTransition = Constants.PHOTO_TRANSITION_CAMERA;
    }

    this.checkedTransition = this.mTransition

    if (this.mTransition.endsWith('ERROR')) {
      this.checkedTransition = this.mTransition.substr(0, this.mTransition.length - 5)
    }

    this.dataSource.setBroadCast(this.broadCast);
    this.dataSource.setBroadCastToAlbum(this.broadCast);

    // register event handling
    this.broadCast.on(PhotoConstants.TOGGLE_BAR, this.onToggleBarsFunc);
    this.broadCast.on(PhotoConstants.HIDE_BARS, this.hideBarsFunc);
    this.broadCast.on(PhotoConstants.SHOW_BARS, this.showBarsFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_START, this.pullDownStartFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_END, this.pullDownEndFunc);
    this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, this.onDataSizeChangedFunc);
    this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, this.onDataContentChangedFunc);
    this.broadCast.on(PhotoConstants.SET_FAVOR, this.setFavorFunc);
    this.broadCast.on(PhotoConstants.RENAME, this.doRenameFunc);
    this.broadCast.on(PhotoConstants.ROTATE, this.doRotateFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_START, this.pullDownStartWithEventFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_CANCEL, this.pullDownCancelFunc);
    this.broadCast.on(PhotoConstants.PHOTO_BROWSER_DELETE_CONFIRM, this.onPhotoBrowserDeleteConfirmFunc);
    this.broadCast.on(PhotoConstants.PHOTO_BROWSER_REMOVE_CONFIRM, this.onPhotoBrowserRemoveConfirmFunc);
    this.broadCast.on(PhotoConstants.DELETE, this.doDeleteFunc);
    this.broadCast.on(PhotoConstants.PHOTO_SHOW_STATE, this.onPhotoShowStateChangedFunc);
    this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, this.setSwiperDisableFunc);
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, this.onDataReloadWithEditFunc);

    this.appBroadCast.on(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, this.photoBrowserBackFunc);

    interface MsgNavigation {
      from: string;
      fovMode: number;
    }

    let msg: MsgNavigation = {
      from: BigDataConstants.LOCAL_MEDIA,
      fovMode: 0
    }
    ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTO_BROWSER_ID, msg);
    this.breakpointSystem.registerOrientationChange();
    TraceControllerUtils.finishTrace('PhotoBrowserAboutToAppear');
  }

  onToggleBars(backgroundColorResource?: Resource): void {
    if (this.isShowBar) {
      this.hideBars(backgroundColorResource);
    } else {
      this.showBars(backgroundColorResource);
    }
    Log.info(TAG, `Toggle bars, isShowBar: ${this.isShowBar}`);
  }

  showBars(backgroundColorResource?: Resource): void {
    this.backgroundColorResource = backgroundColorResource ?
      backgroundColorResource : $r('app.color.default_background_color');
    if (!this.isShowBar) {
      this.isShowBar = !this.isShowBar;
      if (!this.isHorizontal) {
        ScreenManager.getInstance().setSystemUi(true);
      }
    } else {
      this.onlyChangeBgColor = !this.onlyChangeBgColor;
    }
  }

  hideBars(backgroundColorResource?: Resource): void {
    this.backgroundColorResource = backgroundColorResource ?
      backgroundColorResource : $r('app.color.black');
    if (this.isShowBar) {
      this.isShowBar = !this.isShowBar;
      ScreenManager.getInstance().setSystemUi(false);
    } else {
      this.onlyChangeBgColor = !this.onlyChangeBgColor;
    }
  }

  private pullDownStart(): void {
    Log.info(TAG, 'pulling down start');
  }

  private pullDownEnd(): void {
    Log.info(TAG, 'pulling down end');
    if (this.isFromFACard) {
      this.isPullDown = true;
    }
    this.onBackPress();
  }

  private onDataContentChanged(): void {
    this.reportToBigDataForCameraIn();
    Log.debug(TAG, `PhotoConstants.DATA_CONTENT_CHANGED`);
    if (AppStorage.get('isEditFunc')) {
      this.currentIndex = 0;
    }
    this.onPhotoChanged(this.currentIndex);
  }

  private setFavor(isFavor: boolean): void {
    Log.debug(TAG, 'set favor !')
    let currentPhoto = this.getCurrentPhoto();
    if (!isFavor) {
      currentPhoto.isFavor = isFavor;
      this.updateMenu(this.currentIndex);
    } else {
      Log.debug(TAG, 'update favor !');
    }
  }

  private doRename(result: TitleName): void {
    Log.info(TAG, `rename refresh: ${result.title}, ${result.displayName}`);
    this.updatePhotoName(result);
  }

  private doRotate(result: number): void {
    Log.debug(TAG, `rotate finish: ${result}`);
    let currentPhoto = this.getCurrentPhoto();
    currentPhoto.orientation = result;
    let temp = currentPhoto.height;
    currentPhoto.height = currentPhoto.width;
    currentPhoto.width = temp;
    this.dataSource.onDataChanged(this.currentIndex);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
  }

  private pullDownStartWithEvent(event: KeyEvent): void {
    Log.debug(TAG, `pulling down start : ${JSON.stringify(event)}`);
    if (this.isFromViewDataWithThirdUri) {
      return;
    }
  }

  private pullDownCancel(): void {
    Log.info(TAG, 'pulling down cancel');
  }

  private onPhotoBrowserDeleteConfirm(): void {
    this.isDeleting = true;
    // clear temp not favorite items
    if (this.albumUri == UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)) {
      let key = this.theDeleteItem?.uri ?? '';
      if (this.favorCacheItemsMap.has(key)) {
        let item = this.favorCacheItemsMap.get(key)
        let menuFavorContext = new MenuContext().withMediaItem(item as MediaItem).withBroadCast(this.broadCast);
        let menuFavorOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(FavoriteMenuOperation, menuFavorContext);
        menuFavorOperation.doAction();
        this.favorCacheItemsMap.delete(key);
      }
    }
  }

  private onPhotoBrowserRemoveConfirm(): void {
    this.isDeleting = true;
  }

  private doDelete(): void {
    Log.info(TAG, 'delete finish now update data');
  }

  private onPhotoShowStateChanged(state: boolean): void {
    Log.debug(TAG, 'current photo show state change');
    this.currentShow = state;
  }

  private setSwiperDisable(value: boolean): void {
    Log.info(TAG, `set swiper swipe ${value}`);
    this.canSwipe = value;
  }

  private onDataReloadWithEdit(): void {
    Log.debug(TAG, 'animate to data reloaded start with edit');
    try {
      let uri: string = AppStorage.get<string>(BroadCastConstants.PHOTO_EDIT_SAVE_URI) as string;
      Log.debug(TAG, `data reloaded start with edit by uri ${uri}`);
      if (uri) {
        let newIndex = this.dataSource.getDataIndexByUri(uri);
        let oldIndex = this.currentIndex;
        if (newIndex != Constants.NOT_FOUND) {
          // Search for the position of new image/video after edit in current 500 items succeed
          Log.debug(TAG, `data reloaded from ${oldIndex} move to ${newIndex}`);
          this.onPhotoChanged(newIndex);
        } else {
          // Search for the position of new image/video after edit in current 500 items failed
          Log.debug(TAG, `data reloaded from ${oldIndex} move to unknown`);
          this.editNewUri = uri;
          this.dataSource.enableGetData(false);
          this.currentIndex = 0;
          this.dataSource.getItemIndexByUri(uri, (index: number): void => this.onGetItemIndexByNewEditUri(index));
        }
      }
    } catch (e) {
      Log.error(TAG, `ON_DATA_RELOADED_WITH_EDIT error ${e}`);
    } finally {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_EDIT_SAVE_COMPLETE, []);
    }
  }

  private photoBrowserBack(): void {
    Log.debug(TAG, 'hook back press from page.');
    this.onBackPress();
  }

  onGetItemIndexByUri(index: number): void {
    Log.info(TAG, `onGetItemIndexByUri: index=${index}`);
    if (this.uriFromThirdPartyApp) {
      if (index != Constants.NOT_FOUND) {
        this.currentIndex = index;
        this.uriFromThirdPartyApp = '';
        this.dataSource.enableGetData(true);
        this.dataSource.getData(this.currentIndex);
        this.dataSource.onDataReloaded();
        Log.info(TAG, `Found: ${this.currentIndex}, ${this.albumUri}`);
      } else {
        if (this.albumUri === UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE)) {
          if (this.isFromViewDataWithMediaUri || this.isFromViewDataWithThirdUri) {
            Log.error(TAG, `Uri from third party app is invalid`);
          } else if (this.isFromFACard) {
            Log.error(TAG, `Uri from FA is invalid`);
          } else {
            Log.error(TAG, `Uri from others is invalid`);
          }
          this.uriFromThirdPartyApp = '';
          this.dataSource.enableGetData(true);
          this.setViewDataResult(false);
        } else if (this.albumUri === '') {
          this.resetAlbum(UserFileManagerAccess.getInstance()
            .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE));
          this.dataSource.getItemIndexByUri(this.uriFromThirdPartyApp,
            (index: number): void => this.onGetItemIndexByUri(index));
        } else {
          this.resetAlbum('');
          this.dataSource.getItemIndexByUri(this.uriFromThirdPartyApp,
            (index: number): void => this.onGetItemIndexByUri(index));
        }
      }
      this.onPhotoChanged(this.currentIndex);
    }
  }

  onGetItemIndexByNewEditUri(index: number): void {
    Log.info(TAG, `onGetItemIndexByNewEditUri: index=${index}`);
    if (this.editNewUri.length > 0) {
      if (index != Constants.NOT_FOUND) {
        Log.info(TAG, `data reloaded move to ${index}`);
        this.currentIndex = index;
        if (this.checkedTransition == Constants.PHOTO_TRANSITION_TIMELINE) {
          this.timelinePageIndex = this.currentIndex; // call scrollTo
          this.timelinePageIndex = Constants.INVALID;
        } else if (this.checkedTransition == Constants.PHOTO_TRANSITION_ALBUM) {
          this.photoGridPageIndex = this.currentIndex; // call scrollTo
          this.photoGridPageIndex = Constants.INVALID;
        }
        this.dataSource.enableGetData(true);
        this.dataSource.getData(this.currentIndex);
        this.dataSource.onDataReloaded();
        this.editNewUri = '';
      } else {
        Log.error(TAG, `edit new uri ${this.editNewUri} is invalid`);
        this.editNewUri = '';
        this.currentIndex = 0;
        this.dataSource.enableGetData(true);
      }
      this.onPhotoChanged(this.currentIndex);
    }
  }

  onPageShow(): void {
    TraceControllerUtils.startTrace('PhotoBrowseronPageShow');
    Log.info(TAG, 'photoBrowser page show');
    WindowUtil.setPreferredOrientation(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext,
      window.Orientation.AUTO_ROTATION_RESTRICTED);
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto) {
      this.syncPhotoName(currentPhoto).then((result) => {
        if (result) {
          this.updatePhotoName(result);
          this.broadCast.emit(PhotoConstants.UPDATE_PHOTO_NAME + currentPhoto.uri, [result.title]);
        }
      });
    }
    this.updateActionBar(this.currentIndex);
    if (!this.isHorizontal) {
      ScreenManager.getInstance().setSystemUi(true);
    }
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [400]);
    this.viewTime = Date.now();
    let params: Params = router.getParams() as Params;
    if (params != null && params.pageType != null && this.backFromCopy) {
      Log.debug(TAG, `MediaOperation back ${JSON.stringify(params)}`)
      let menuContext = new MenuContext();
      let menuOperation: MenuOperation | null = null;
      if (currentPhoto == undefined) {
        Log.error(TAG, 'MediaOperation currentPhoto is undefined');
        return;
      }
      if (params.pageType === MediaOperationType.Move) {
        let onMoveEndFunc = async (err: Error, count: number, total: number): Promise<void> => {
          await this.onMoveEnd(err as Object, count, total);
          }
        menuContext.withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(params.albumName)
          .withAlbumUri(params.albumUri)
          .withOperationEndCallback(onMoveEndFunc);
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
        AppStorage.setOrCreate<string | undefined>(Constants.APP_KEY_NEW_ALBUM_SOURCE, this.albumInfo?.uri);
      } else if (params.pageType === MediaOperationType.Remove) {
        let onMoveEndFunc = async (err: Error, count: number, total: number): Promise<void> => {
          await this.onMoveEnd(err as Object, count, total);
          }
        menuContext.withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(params.albumName)
          .withAlbumUri(params.albumUri)
          .withOperationEndCallback(onMoveEndFunc);
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(RemoveMenuOperation, menuContext);
        AppStorage.setOrCreate<string | undefined>(Constants.APP_KEY_NEW_ALBUM_SOURCE, this.albumInfo?.uri);
      } else if (params.pageType === MediaOperationType.Add) {
        // "添加到"不需要设置源相册
        let onCopyEndFunc = (err: Error, count: number, total: number): void => {
          this.onCopyEnd(err as Object, count, total);
          }
        menuContext.withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(params.albumName)
          .withAlbumUri(params.albumUri)
          .withOperationEndCallback(onCopyEndFunc);
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
      }

      if (menuOperation != null) {
        menuOperation.doAction();
      }
    }
    this.backFromCopy = false;
    TraceControllerUtils.finishTrace('PhotoBrowseronPageShow');
  }

  onPageHide(): void {
    Log.info(TAG, `call onPageHide`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
    WindowUtil.setPreferredOrientation(AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext,
      window.Orientation.UNSPECIFIED);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.onChange(changeType);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      PhotoBrowserComponentBg({ isShowBar: $isShowBar, isFromPhotoBrowser: true })
        .opacity(this.geometryOpacity)
        .transition(TransitionEffect.opacity(0))

      PhotoSwiper({
        dataSource: this.dataSource,
        mTransition: this.mTransition,
        swiperController: this.controller,
        onPhotoChanged: (index: number): void => this.onPhotoChanged(index),
        geometryTransitionEnable: this.geometryTransitionEnable,
        broadCast: $broadCast,
        isRunningAnimation: $isRunningAnimation,
        isFromFACard: this.isFromFACard
      })

      if (!this.isFromViewDataWithThirdUri) {
        PhotoBrowserActionBar({
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        })
          .opacity(this.geometryOpacity)
          .transition(TransitionEffect.opacity(0))

        if (!this.isHorizontal) {
          PhotoBrowserToolBar({
            onMenuClicked: (action: Action): void => this.onMenuClicked(action),
            isFromPhotoBrowser: true
          })
            .opacity(this.geometryOpacity)
            .transition(TransitionEffect.opacity(0))
            .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
            .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
        }

        CustomDialogView({ broadCast: $broadCast })
          .opacity(this.geometryOpacity)
          .transition(TransitionEffect.opacity(0))

      } else {
        PhotoBrowserActionBar({
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        })
          .opacity(this.geometryOpacity)
          .transition(TransitionEffect.opacity(0))
      }
    }
  }

  private setViewDataResult(result: boolean): void {
    if (!this.isFromViewDataWithMediaUri && !this.isFromViewDataWithThirdUri) {
      return;
    }

    let resultCode = 0;
    if (result == false) {
      resultCode = -1;
    }

    let abilityResult: ability.AbilityResult = {
      resultCode: resultCode,
      want: {}
    };

    let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    context.terminateSelfWithResult(abilityResult).then((result: void) => {
      Log.info(TAG, `terminateSelfWithResult result: ${result}`);
    });
  }

  private downLoad(): void {
    Log.info(TAG, 'downLoad run');
    let menuContext = new MenuContext();
    let menuOperation: MenuOperation;
    let currentPhoto = this.getCurrentPhoto();
    let onDownloadEndFunc = async (err: Error, count: number, total: number): Promise<void> => {
      await this.onDownloadEnd(err as Object, count, total);
      }
    if (currentPhoto == undefined) {
      Log.error(TAG, 'MediaOperation currentPhoto is undefined');
      return;
    }
    menuContext
      .withMediaItem(currentPhoto)
      .withBroadCast(this.broadCast)
      .withRemoteDevice('0') // TODO input deviceId
      .withOperationEndCallback(onDownloadEndFunc)
    menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
    menuOperation.doAction();
  }

  private reportToBigDataForPhotoSlide(index: number): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto && index != this.currentIndex && this.viewTime != 0) {
      let currentTime = Date.now();
      interface Msg {
        type: string;
        duration: number;
      }
      let msg: Msg = {
        type: currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
        BigDataConstants.VIDEO : BigDataConstants.NORMAL_PHOTO,
        duration: (currentTime - this.viewTime)
      }
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_SLIDE_ID, msg);
      this.viewTime = Date.now();
    }
  }

  private reportToBigDataForCameraIn(): void {
    if (this.clickThumbnailTime == 0 || !this.isFromCamera) {
      return;
    }
    interface Msg {
      clickThumbnailTime: number;
      showSinglePhoto: number;
      fileName?: string;
    }
    let msg: Msg = {
      clickThumbnailTime: this.clickThumbnailTime,
      showSinglePhoto: Date.now()
    }
    let fileName = ReportToBigDataUtil.getFileNameOfPhotoTakenByCamera(this.getPhotoByIndex(0));
    ReportToBigDataUtil.setFileNameProperty(msg, fileName);
    ReportToBigDataUtil.report(BigDataConstants.BROWSE_PHOTO_FROM_CAMERA_ID, msg);
    this.clickThumbnailTime = 0;
  }

  private async syncPhotoName(currentPhoto: MediaItem): Promise<TitleName> {
    Log.debug(TAG, 'syncPhotoName start');
    let renameResult: TitleName = {title: '', displayName: ''};
    let fileAsset = await this.dataSource.getDataByUri(currentPhoto.uri);
    if (fileAsset) {
      renameResult = {
        title: fileAsset.get(UserFileManagerAccess.FILE_KEY_TITLE.toString()) as string,
        displayName: fileAsset.displayName
      };
    } else {
      let key: string = 'renameResult' + currentPhoto.uri;
      renameResult = AppStorage.get<TitleName>(key) as TitleName;
      AppStorage.delete(key);
    }
    Log.debug(TAG, `syncPhotoName end, renameResult : ${JSON.stringify(renameResult)}`);
    return renameResult;
  }
}
