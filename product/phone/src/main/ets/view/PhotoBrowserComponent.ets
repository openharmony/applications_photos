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
import bundle from '@ohos.bundle';
import CommonEvent from '@ohos.commonEvent';
import window from '@ohos.window';
import { MenuOperation } from '@ohos/common';
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

const TAG: string = 'PhotoBrowserComponent';

// page of large photo
@Component
export struct PhotoBrowserComponent {
  @Provide backgroundColorResource: Resource = $r('app.color.default_background_color');
  @Provide('dateTitle') photoDate: string = '';
  @Provide('timeLocationTitle') timeAndLocation: string = '';
  @Provide menuList: Array<Action> = new Array<Action>();
  @Provide toolMenuList: Array<Action> = new Array<Action>();
  @Provide topMenuList: Array<Action> = new Array<Action>();
  @Provide moreMenuList: Array<Action> = new Array<Action>();
  @State broadCast: BroadCast = new BroadCast();
  @Provide isShowBar: boolean = true;
  @Provide onlyChangeBgColor: boolean = false;
  @Provide canSwipe: boolean = true;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @State @Watch('updateMoreMenu') currentShow: boolean = true;
  @StorageLink('isHorizontal') @Watch('updateIsHorizontal') isHorizontal: boolean = ScreenManager.getInstance()
    .isHorizontal();
  @StorageLink('TimelinePageIndex') TimelinePageIndex: number = Constants.INVALID;
  @StorageLink('PhotoGridPageIndex') PhotoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[]
    = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
  mTransition: string;
  albumUri = '';
  // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
  @Provide('transitionIndex') currentIndex: number = Constants.NUMBER_0;
  controller: SwiperController = new SwiperController();
  @Prop @Watch('onPageChanged') pageStatus: boolean;
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
  private checkedTransition: string;
  private viewTime = Constants.NUMBER_0;
  // When clicking quickly, only run aboutToAppear for the first time
  private hasAppeared: boolean;
  private albumInfo: AlbumInfo;
  private deviceName = '';
  private backFromCopy = false;
  private uriFromThirdPartyApp: string;
  private editNewUri: string = "";
  private favorCacheItemsMap = new Map<String, MediaItem>()
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  private theDeleteItem: MediaItem;
  private geometryTransitionEnable: boolean = false;
  private isShowMenuFromThirdView: boolean = true;
  private isToEdit = false;
  private photoBrowserBackFunc: Function = this.photoBrowserBack.bind(this);

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
      this.updateMenu();
    } else {
      this.isFirstLoad = false;
    }
  }

  onMenuClicked(action: Action): void {
    let actionID: number = action.actionID;
    Log.info(TAG, `onMenuClicked, actionID: ${actionID}`);
    let menuOperation: MenuOperation = null;
    let menuContext: MenuContext = new MenuContext();
    let currentPhoto = this.getCurrentPhoto();
    switch (actionID) {
      case Action.BACK.actionID:
        this.onBackPress();
        return;
      case Action.INFO.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined');
          return;
        }
        this.broadCast.emit(BroadCastConstants.SHOW_DETAIL_DIALOG, [currentPhoto, this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED]);
        return;
      case Action.SHARE.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined');
          return;
        }
        menuContext.withFromSelectMode(false).withMediaItem(currentPhoto);
        menuOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(ShareMenuOperation, menuContext);
        break;
      case Action.NOT_FAVORITE.actionID:
      case Action.FAVORITE.actionID:
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
        this.updateMenu();
        this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + 'false';
        AppStorage.SetOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
        break;
      case Action.DELETE.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined.');
          return;
        }
        menuContext.withAlbumInfo(this.albumInfo);
        this.theDeleteItem = currentPhoto;
        menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
        menuOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(DeleteMenuOperation, menuContext);
        break;
      case Action.RECOVER.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined.');
          return;
        }
        menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
        menuOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(RecoverMenuOperation, menuContext);
        break;
      case Action.GOTO_PHOTOS.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined.');
          return;
        }
        menuContext.withJumpSourceToMain(this.jumpSourceToMain);
        menuOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(GotoPhotosMenuOperation, menuContext);
        break;
      case Action.EDIT.actionID:
        if (currentPhoto == undefined || currentPhoto.size == 0) {
          Log.warn(TAG, 'currentPhoto is undefined or size is 0.');
          return;
        }
        globalThis.EditorMediaItem = currentPhoto;
        globalThis.EditorAlbumUri = this.albumUri;
        router.pushUrl({
          url: 'pages/EditMain'
        })
        this.isToEdit = true;
        return;
      case Action.EDIT_INVALID.actionID:
        if (currentPhoto == undefined || currentPhoto.size == 0) {
          Log.warn(TAG, 'currentPhoto is undefined or size is 0.');
          return;
        }
        return;
      case Action.RENAME.actionID:
        this.hidePopup = true;
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined.');
          return;
        }
        menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast).withAlbumUri(this.albumUri);
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(RenameMenuOperation, menuContext);
        break;
      case Action.ROTATE.actionID:
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
        break;
      case Action.ADD_NOTES.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.RENAME.');
          return;
        }
        menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddNotesMenuOperation, menuContext);
        break;
      case Action.MOVE.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.MOVE.');
          return;
        }
        this.backFromCopy = true;
        currentPhoto && currentPhoto.mediaType &&
        this.routeToSelectAlbumPage(MediaOperationType.Move, currentPhoto.mediaType);
        return;
      case Action.ADD.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.ADD.');
          return;
        }
        this.backFromCopy = true;
        currentPhoto && currentPhoto.mediaType &&
        this.routeToSelectAlbumPage(MediaOperationType.Add, currentPhoto.mediaType);
        return;
      case Action.REMOVE_FROM.actionID:
        if (currentPhoto == undefined) {
          Log.warn(TAG, 'currentPhoto is undefined.');
          return;
        }

        menuContext.withAlbumUri(this.albumUri);
        menuContext.withMediaItem(currentPhoto).withBroadCast(this.broadCast);
        menuOperation = MenuOperationFactory.getInstance()
          .createMenuOperation(RemoveMenuOperation, menuContext);
        break;
      case Action.DOWNLOAD.actionID:
        this.downLoad();
        return;
      default:
        return;
    }
    if (!!menuOperation) {
      menuOperation.doAction();
    }
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
    this.updateActionBar();
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
    } else {
      let timelineIndex = this.dataSource.getPositionByIndex(index);
      AppStorage.SetOrCreate<number>('placeholderIndex', timelineIndex);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + 'false';
      AppStorage.SetOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
      Log.debug(TAG, `onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}, \
        placeholderIndex ${AppStorage.Get('placeholderIndex')},\
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

  updateActionBar(): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined || this.isFromViewDataWithThirdUri) {
      return;
    }
    this.photoDate = DateUtil.getLocalizedDate(currentPhoto.getDataTaken());
    if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
      this.timeAndLocation = `${this.deviceName}/${DateUtil.getLocalizedTime(currentPhoto.getDataTaken())}`;
    } else {
      this.timeAndLocation = DateUtil.getLocalizedTime(currentPhoto.getDataTaken());
    }
    this.updateMenu();
  }

  updateMenu(): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }

    if (this.albumUri == UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)) {
      let key = currentPhoto.uri;
      if (this.favorCacheItemsMap.has(key)) {
        let tempPhotoItem = this.favorCacheItemsMap.get(key);
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

    let menuTemp: Array<Action> = new Array<Action>();
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

    let list: Array<Action> = new Array<Action>();
    switch (pageFrom) {
      case Constants.ENTRY_FROM.NORMAL:
      case Constants.ENTRY_FROM.CAMERA:
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE,
            ((currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_IMAGE))
            ? Action.EDIT : Action.EDIT_INVALID, Action.DELETE, Action.MORE); // TODO: delete edit
        break;
      case Constants.ENTRY_FROM.RECYCLE:
        list.push(Action.RECOVER, Action.DELETE);
        break;
      case Constants.ENTRY_FROM.DISTRIBUTED:
        list.push(Action.DOWNLOAD);
        break;
      default:
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE,
            ((currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_IMAGE))
            ? Action.EDIT : Action.EDIT_INVALID, Action.DELETE, Action.MORE); // TODO: delete edit
        break;
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
    let menuTempList: Array<Action>;
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
    let isShowMenuMsg = {};
    if (isShowMenuFromThirdView) {
      this.isShowMenuFromThirdView = true;
      isShowMenuMsg = {
        'isShowMenuFromThirdView': BigDataConstants.SHOW_MENU
      }
    } else if (isShowMenuFromThirdView == false) {
      this.isShowMenuFromThirdView = false;
      isShowMenuMsg = {
        'isShowMenuFromThirdView': BigDataConstants.HIDE_MENU
      }
    } else {
      this.isShowMenuFromThirdView = true;
      isShowMenuMsg = {
        'isShowMenuFromThirdView': BigDataConstants.UNDEFINED_IS_SHOW_MENU
      }
    }
    this.updateMenu();
    ReportToBigDataUtil.statisticReport(BigDataConstants.IS_SHOW_MENU_ID, isShowMenuMsg);
  }

  updateMoreMenu(): void {
    this.moreMenuList = this.albumInfo.isSystemAlbum ?
      [Action.ADD, Action.RENAME] : [Action.MOVE, Action.ADD, Action.REMOVE_FROM, Action.RENAME];
  }

  getCurrentPhoto(): MediaItem {
    return this.dataSource.getRawData(this.currentIndex).data;
  }

  getPhotoByIndex(index: number): MediaItem {
    return this.dataSource.getRawData(index).data;
  }

  async onMoveEnd(err, count, total): Promise<void> {
    Log.debug(TAG, `onMoveEnd count: ${count}, total: ${total}`);
    if (err) {
      UiUtil.showToast($r('app.string.move_failed_single'));
      return;
    }
    let currentPhoto = this.getCurrentPhoto();
    let newItem = await this.dataSource.getDataByUri(currentPhoto.uri)
    this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
  }

  onCopyEnd(err, count, total): void {
    Log.debug(TAG, `onCopyEnd count: ${count}, total: ${total}`);
    if (err) {
      UiUtil.showToast($r('app.string.copy_failed_single'));
    }
  }

  async onDownloadEnd(err, count, total): Promise<void> {
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
    this.controller.finishAnimation(this.onBackPressInner.bind(this));
    return true;
  }

  onBackPressInner(): void {
    Log.info(TAG, `onBackPressInner ${this.checkedTransition}`);
    this.dataSource.release();
    switch (this.checkedTransition) {
      case Constants.PHOTO_TRANSITION_TIMELINE:
        Log.info(TAG, 'onBackPress TimelinePage');
        this.TimelinePageIndex = this.currentIndex; // call scrollTo
        this.TimelinePageIndex = Constants.INVALID;
        break;
      case Constants.PHOTO_TRANSITION_ALBUM:
        Log.info(TAG, 'onBackPress PhotoGridPage');
        this.PhotoGridPageIndex = this.currentIndex; // call scrollTo
        this.PhotoGridPageIndex = Constants.INVALID;

        if (this.isFromFACard) {
          if (this.isPullDown) {
            this.isPullDown = false;
            globalThis.photosAbilityContext.terminateSelf();
          } else {
            let displayName: string = AppStorage.Get('form_displayName');
            let uri: string = AppStorage.Get('form_albumUri');
            let item: AlbumInfo = new AlbumInfo(undefined);
            item.uri = uri;
            item.albumName = displayName;
            //item.innerId = uri;
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
          WindowUtil.setPreferredOrientation(globalThis.photosAbilityContext, window.Orientation.UNSPECIFIED);
          return;
        }
        break;
      case Constants.PHOTO_TRANSITION_CAMERA:
        Log.info(TAG, 'onBackPress Camera');
      // Entering from the camera does not need to return to close directly

        globalThis.photosAbilityContext.terminateSelf();
        return;
      case Constants.PHOTO_TRANSITION_THIRD_APP:
        Log.info(TAG, 'onBackPress third app');
        this.setViewDataResult(true);
        return;
      default:
        break
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

  updatePhotoName(result: {title: string, displayName: string}): void {
    let currentPhoto = this.getCurrentPhoto();
    currentPhoto.setTitle(result.title);
    currentPhoto.displayName = result.displayName;
    this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'photoBrowser aboutToDisappear');
    this.controller = undefined;
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
      WindowUtil.setPreferredOrientation(globalThis.photosAbilityContext,
        window.Orientation.UNSPECIFIED);
    }
    this.broadCast.off(null, null);
    this.appBroadCast.off(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, this.photoBrowserBackFunc);
  }

  getAlbumUriByUri(albumUri: string) {
    if (albumUri && albumUri.length > 0) {
      return albumUri;
    }

    return "";
  }

  aboutToAppear(): void {
    TraceControllerUtils.startTrace('PhotoBrowserAboutToAppear');
    Log.info(TAG, 'photoBrowser aboutToAppear');
    this.geometryTransitionId = AppStorage.Get('geometryTransitionBrowserId');
    this.hasAppeared = true;
    this.updateIsHorizontal();

    WindowUtil.setPreferredOrientation(globalThis.photosAbilityContext,
      window.Orientation.AUTO_ROTATION_RESTRICTED);

    let param: any = this.browserController.browserParam;
    let entryFromCamera = (AppStorage.Get('entryFromHapCamera')) == Constants.ENTRY_FROM_CAMERA;
    Log.info(TAG, `photoBrowser start with entryFrom ` + JSON.stringify(entryFromCamera));
    if (entryFromCamera) {
      param = {
        pageFrom: Constants.ENTRY_FROM.CAMERA
      }
      AppStorage.SetOrCreate('entryFromHapCamera', Constants.ENTRY_FROM_NONE);
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
        this.albumUri = "";
        this.jumpSourceToMain = JumpSourceToMain.CAMERA;
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        AppStorage.SetOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE);
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
        this.currentIndex = 0;
        this.dataSource.getItemIndexByUri(this.uriFromThirdPartyApp, this.onGetItemIndexByUri.bind(this));
        this.isFromFACard = true;
        this.geometryTransitionEnable = true;
      } else if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
        this.dataSource.setAlbumUri(this.albumUri);
        this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
      } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
        this.dataSource.setDeviceId(param.albumInfo.deviceId);
        this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
      } else if (this.pageFrom == Constants.ENTRY_FROM.VIEW_DATA) {
        if (String(param.viewData).length === 0) {
          Log.error(TAG, 'Invalid uri');
          this.setViewDataResult(false);
          return;
        }
        Log.info(TAG, `Found viewIndex: ${String(param.viewDataIndex).length}`);
        if (String(param.viewDataIndex).length > 0) {
          Log.debug(TAG, `Found viewIndex`);
          this.dataSource = new UriDataSource(String(param.viewData).split(','));
          let viewIndex = parseInt(param.viewDataIndex);
          if (viewIndex == NaN || viewIndex <= 0 || viewIndex > String(param.viewData).split(',').length) {
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
            this.dataSource.getItemIndexByUri(this.uriFromThirdPartyApp, this.onGetItemIndexByUri.bind(this));
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
        this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
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
        this.albumUri = AppStorage.Get('form_albumUri');
      } else {
        this.pageFrom = Constants.ENTRY_FROM.CAMERA;
        this.albumUri = UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
      }
      AppStorage.SetOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE);
      let albumDataSource: MediaDataSource = AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER);
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

    this.onMenuClicked = this.onMenuClicked.bind(this);

    this.dataSource.setBroadCast(this.broadCast);
    this.dataSource.setBroadCastToAlbum(this.broadCast);
    // register event handling
    this.broadCast.on(PhotoConstants.TOGGLE_BAR, (backgroundColorResource?: Resource) => {
      this.onToggleBars(backgroundColorResource);
    });

    this.broadCast.on(PhotoConstants.HIDE_BARS, (backgroundColorResource?: Resource) => {
      this.hideBars(backgroundColorResource);
    });

    this.broadCast.on(PhotoConstants.SHOW_BARS, (backgroundColorResource?: Resource) => {
      this.showBars(backgroundColorResource);
    });

    this.broadCast.on(PhotoConstants.PULL_DOWN_START, () => {
      Log.info(TAG, 'pulling down start');
    });

    this.broadCast.on(PhotoConstants.PULL_DOWN_END, () => {
      Log.info(TAG, 'pulling down end');
      if (this.isFromFACard) {
        this.isPullDown = true;
      }
      this.onBackPress();
    });

    this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number) => {
      this.onDataSizeChanged(size);
    });

    this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, () => {
      this.reportToBigDataForCameraIn();
      Log.debug(TAG, `PhotoConstants.DATA_CONTENT_CHANGED`);
      this.onPhotoChanged(this.currentIndex);
    });

    this.broadCast.on(PhotoConstants.SET_FAVOR, (isFavor: boolean) => {
      Log.debug(TAG, 'set favor !')
      let currentPhoto = this.getCurrentPhoto();
      if (!isFavor) {
        currentPhoto.isFavor = isFavor;
        this.updateMenu();
      } else {
        Log.debug(TAG, 'update favor !');
      }
    });

    this.broadCast.on(PhotoConstants.RENAME, (result: {title: string, displayName: string}) => {
      Log.info(TAG, `rename refresh: ${result.title}, ${result.displayName}`);
      this.updatePhotoName(result);
    });

    this.broadCast.on(PhotoConstants.ROTATE, (result: number) => {
      Log.debug(TAG, `rotate finish: ${result}`);
      let currentPhoto = this.getCurrentPhoto();
      currentPhoto.orientation = result;
      let temp = currentPhoto.height;
      currentPhoto.height = currentPhoto.width;
      currentPhoto.width = temp;
      this.dataSource.onDataChanged(this.currentIndex);
      this.appBroadCast.emit(BroadCastConstants.UPDATE_DATA_SOURCE, [currentPhoto]);
    });

    this.broadCast.on(PhotoConstants.PULL_DOWN_START, (event) => {
      Log.debug(TAG, `pulling down start : ${JSON.stringify(event)}`);
    })

    this.broadCast.on(PhotoConstants.PULL_DOWN_CANCEL, () => {
      Log.info(TAG, 'pulling down cancel');
    })

    this.broadCast.on(PhotoConstants.PHOTO_BROWSER_DELETE_CONFIRM, () => {
      this.isDeleting = true;
      // clear temp not favorite items
      if (this.albumUri == UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)) {
        let key = this.theDeleteItem.uri;
        if (this.favorCacheItemsMap.has(key)) {
          let item = this.favorCacheItemsMap.get(key)
          let menuFavorContext = new MenuContext().withMediaItem(item).withBroadCast(this.broadCast);
          let menuFavorOperation = MenuOperationFactory.getInstance()
            .createMenuOperation(FavoriteMenuOperation, menuFavorContext);
          menuFavorOperation.doAction();
          this.favorCacheItemsMap.delete(key);
        }
      }
    })

    this.broadCast.on(PhotoConstants.PHOTO_BROWSER_REMOVE_CONFIRM, () => {
      this.isDeleting = true;
    })

    this.broadCast.on(PhotoConstants.DELETE, () => {
      Log.info(TAG, 'delete finish now update data');
    });

    this.broadCast.on(PhotoConstants.PHOTO_SHOW_STATE, (state: boolean) => {
      Log.debug(TAG, 'current photo show state change');
      this.currentShow = state;
    });

    this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, (value: boolean) => {
      Log.info(TAG, `set swiper swipe ${value}`);
      this.canSwipe = value;
    });

    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, () => {
      Log.debug(TAG, 'animate to data reloaded start with edit');
      this.isToEdit = false;
      try {
        let uri: string = AppStorage.Get(BroadCastConstants.PHOTO_EDIT_SAVE_URI);
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
            this.dataSource.getItemIndexByUri(uri, this.onGetItemIndexByNewEditUri.bind(this));
          }
        }
      } catch (e) {
        Log.error(TAG, `ON_DATA_RELOADED_WITH_EDIT error ${e}`);
      } finally {
        this.appBroadCast.emit(BroadCastConstants.PHOTO_EDIT_SAVE_COMPLETE, []);
      }
    });

    this.appBroadCast.on(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, this.photoBrowserBackFunc);

    let msg = {
      'From': BigDataConstants.LOCAL_MEDIA,
      'FovMode': 0
    }
    ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTO_BROWSER_ID, msg);
    this.breakpointSystem.registerOrientationChange();
    TraceControllerUtils.finishTrace('PhotoBrowserAboutToAppear');
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
        this.uriFromThirdPartyApp = null;
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
          this.uriFromThirdPartyApp = null;
          this.dataSource.enableGetData(true);
          this.setViewDataResult(false);
        } else if (this.albumUri === "") {
          this.resetAlbum(UserFileManagerAccess.getInstance()
            .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE));
          this.dataSource.getItemIndexByUri(this.uriFromThirdPartyApp, this.onGetItemIndexByUri.bind(this));
        } else {
          this.resetAlbum("");
          this.dataSource.getItemIndexByUri(this.uriFromThirdPartyApp, this.onGetItemIndexByUri.bind(this));
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
          this.TimelinePageIndex = this.currentIndex; // call scrollTo
          this.TimelinePageIndex = Constants.INVALID;
        } else if (this.checkedTransition == Constants.PHOTO_TRANSITION_ALBUM) {
          this.PhotoGridPageIndex = this.currentIndex; // call scrollTo
          this.PhotoGridPageIndex = Constants.INVALID;
        }
        this.dataSource.enableGetData(true);
        this.dataSource.getData(this.currentIndex);
        this.dataSource.onDataReloaded();
        this.editNewUri = "";
      } else {
        Log.error(TAG, `edit new uri ${this.editNewUri} is invalid`);
        this.editNewUri = "";
        this.currentIndex = 0;
        this.dataSource.enableGetData(true);
      }
      this.onPhotoChanged(this.currentIndex);
    }
  }

  onPageShow(): void {
    TraceControllerUtils.startTrace('PhotoBrowseronPageShow');
    Log.info(TAG, 'photoBrowser page show');
    WindowUtil.setPreferredOrientation(globalThis.photosAbilityContext,
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
    this.updateActionBar();
    if (!this.isHorizontal) {
      ScreenManager.getInstance().setSystemUi(true);
    }
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [400]);
    this.viewTime = Date.now();
    let params: any = router.getParams();
    if (params != null && params.pageType != null && this.backFromCopy) {
      Log.debug(TAG, `MediaOperation back ${JSON.stringify(params)}`)
      let menuContext = new MenuContext();
      let menuOperation: MenuOperation;
      if (currentPhoto == undefined) {
        Log.error(TAG, 'MediaOperation currentPhoto is undefined');
        return;
      }
      switch (params.pageType) {
        case MediaOperationType.Move:
          this.onMoveEnd = this.onMoveEnd.bind(this);
          menuContext.withMediaItem(currentPhoto)
            .withBroadCast(this.broadCast)
            .withTargetAlbumName(params.albumName)
            .withAlbumUri(params.albumUri)
            .withOperationEndCallback(this.onMoveEnd);
          menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
          AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM_SOURCE, this.albumInfo.uri);
          break;
        case MediaOperationType.Remove:
          this.onMoveEnd = this.onMoveEnd.bind(this);
          menuContext.withMediaItem(currentPhoto)
            .withBroadCast(this.broadCast)
            .withTargetAlbumName(params.albumName)
            .withAlbumUri(params.albumUri)
            .withOperationEndCallback(this.onMoveEnd);
          menuOperation = MenuOperationFactory.getInstance().createMenuOperation(RemoveMenuOperation, menuContext);
          AppStorage.SetOrCreate(Constants.APP_KEY_NEW_ALBUM_SOURCE, this.albumInfo.uri);
          break;
        case MediaOperationType.Add: // "添加到"不需要设置源相册
          this.onCopyEnd = this.onCopyEnd.bind(this);
          menuContext.withMediaItem(currentPhoto)
            .withBroadCast(this.broadCast)
            .withTargetAlbumName(params.albumName)
            .withAlbumUri(params.albumUri)
            .withOperationEndCallback(this.onCopyEnd);
          menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
          this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
          break;
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
    WindowUtil.setPreferredOrientation(globalThis.photosAbilityContext,
      window.Orientation.UNSPECIFIED);
  }

  onMediaLibDataChange(changeType): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.onChange(changeType);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      PhotoBrowserComponentBg({ isShowBar: $isShowBar, isFromPhotoBrowser: true })
        .opacity(this.geometryOpacity)
          // @ts-ignore
        .transition(TransitionEffect.opacity(0))

      PhotoSwiper({
        dataSource: this.dataSource,
        mTransition: this.mTransition,
        swiperController: this.controller,
        onPhotoChanged: this.onPhotoChanged.bind(this),
        geometryTransitionEnable: this.geometryTransitionEnable,
        broadCast: $broadCast,
        isRunningAnimation: $isRunningAnimation,
        isFromFACard: this.isFromFACard
      })

      if (!this.isFromViewDataWithThirdUri) {
        PhotoBrowserActionBar({
          onMenuClicked: this.onMenuClicked.bind(this),
        })
          .opacity(this.geometryOpacity)
            // @ts-ignore
          .transition(TransitionEffect.opacity(0))

        if (!this.isHorizontal) {
          PhotoBrowserToolBar({
            onMenuClicked: this.onMenuClicked.bind(this),
            isFromPhotoBrowser: true
          })
            .opacity(this.geometryOpacity)
              // @ts-ignore
            .transition(TransitionEffect.opacity(0))
            .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
            .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
        }

        CustomDialogView({ broadCast: $broadCast })
          .opacity(this.geometryOpacity)
            // @ts-ignore
          .transition(TransitionEffect.opacity(0))

      } else {
        PhotoBrowserActionBar({
          onMenuClicked: this.onMenuClicked.bind(this),
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

    let abilityResult = {
      'resultCode': resultCode,
      'want': {}
    };

    globalThis.photosAbilityContext.terminateSelfWithResult(abilityResult).then((result) => {
      Log.info(TAG, `terminateSelfWithResult result: ${result}`);
    });
  }

  private downLoad(): void {
    Log.info(TAG, 'downLoad run');
    let menuContext = new MenuContext();
    let menuOperation: MenuOperation;
    let currentPhoto = this.getCurrentPhoto();
    this.onDownloadEnd = this.onDownloadEnd.bind(this);
    if (currentPhoto == undefined) {
      Log.error(TAG, 'MediaOperation currentPhoto is undefined');
      return;
    }
    menuContext
      .withMediaItem(currentPhoto)
      .withBroadCast(this.broadCast)
      .withRemoteDevice('0') // TODO input deviceId
      .withOperationEndCallback(this.onDownloadEnd)
    menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
    menuOperation.doAction();
  }

  private reportToBigDataForPhotoSlide(index: number): void {
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto && index != this.currentIndex && this.viewTime != 0) {
      let currentTime = Date.now();
      let msg = {
        'type': currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
        BigDataConstants.VIDEO : BigDataConstants.NORMAL_PHOTO,
        'duration': (currentTime - this.viewTime)
      }
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_SLIDE_ID, msg);
      this.viewTime = Date.now();
    }
  }

  private reportToBigDataForCameraIn(): void {
    if (this.clickThumbnailTime == 0 || !this.isFromCamera) {
      return;
    }
    let msg = {
      'clickThumbnailTime': this.clickThumbnailTime,
    }
    let fileName = ReportToBigDataUtil.getFileNameOfPhotoTakenByCamera(this.getPhotoByIndex(0));
    ReportToBigDataUtil.setFileNameProperty(msg, fileName);
    Object.defineProperty(msg, 'ShowSinglePhoto', { value: Date.now(), enumerable: true });
    ReportToBigDataUtil.report(BigDataConstants.BROWSE_PHOTO_FROM_CAMERA_ID, msg);
    this.clickThumbnailTime = 0;
  }

  private async syncPhotoName(currentPhoto: MediaItem): Promise<{title: string, displayName: string}> {
    Log.debug(TAG, 'syncPhotoName start');
    let renameResult: {title: string, displayName: string} = {title: '', displayName: ''};
    let fileAsset = await this.dataSource.getDataByUri(currentPhoto.uri);
    if (fileAsset) {
      renameResult = {title: fileAsset.get(UserFileManagerAccess.FILE_KEY_TITLE.toString()), displayName: fileAsset.displayName}
    } else {
      let key: string = 'renameResult' + currentPhoto.uri;
      renameResult = AppStorage.Get<{title: string, displayName: string}>(key);
      AppStorage.Delete(key);
    }
    Log.debug(TAG, `syncPhotoName end, renameResult : ${JSON.stringify(renameResult)}`);
    return renameResult;
  }
}
