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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { PhotoBrowserLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserLoaderParams';
import lazy { getScreen, ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { LoadingPanel } from '@ohos/browsercommon/src/main/ets/default/view/LoadingPanel';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { BusinessError } from '@ohos.base';
import lazy { CoverSelectComponent, CoverPreviewSheet } from '@ohos/common/src/main/ets/default/view/CoverSelectAndPreviewComponent';
import lazy { EditCoverComponent } from '@ohos/common/src/main/ets/default/view/EditCoverComponent';
import lazy {
  KeyboardAvoidMode,
} from '@kit.ArkUI';
import lazy { GroupFeature } from '@ohos/common/src/main/ets/default/utils/GroupFeature';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { PhotoBrowserViewLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserViewLoaderParams';
import lazy { PhotosHmBrowserController } from '@ohos/browserlibrary';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { AlbumPhotoGridView, BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { AlbumPhotoGridAppBarManager } from '../../viewmodel/AlbumPhotoGridAppBarManager';
import lazy { GroupAlbumPhotoGridAppBarManager } from '../../viewmodel/GroupAlbumPhotoGridAppBarManager';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { IrregularView,
  IrregularViewBuildParams } from '@ohos/timeline/src/main/ets/photogrid/view/IrregularView';
import lazy { AlbumConstants } from '@ohos/timeline/src/main/ets/photogrid/statemanager/constants/AlbumConstants';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { EventHelper } from '@ohos/common/src/main/ets/default/view/ViewEventHelper';
import lazy { StorageUtils } from '@ohos/common/src/main/ets/default/utils/StorageUtils';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ArtisticDayViewBuilder } from '@ohos/timeline/src/main/ets/albumgrid/view/CustomBuilderLoaderParam';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { window } from '@kit.ArkUI';
import lazy { IrregularElementBuilder } from '@ohos/timeline/src/main/ets/albumgrid/view/IrregularElement';

/* instrument ignore file */
const TAG = 'GroupAlbumPage';
const IPHONE_EDIT_COVER_ITEM_HEIGHT: number = 120; // 封面编辑 封面卡片 手机设备固定高度 120
const IPHONE_EDIT_COVER_ITEM_WIDTH: number = 180; // 封面编辑 封面卡片 手机设备固定高度 180
const SWIPER_HEIGHT: number = 450;

@Builder
export function GroupAlbumPageLoader() {
  GroupAlbumPage();
}

// 来源相册、最近删除、智慧相册 宫格
@Entry
@Component
export struct GroupAlbumPage {
  @Consume @Watch('onBrowserControllerChanged') browserController: PhotosHmBrowserController;
  @State pageStatus: boolean = false;
  @State isRunningAnimation: boolean = false;
  @State item: AlbumInfo = new AlbumInfo();
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  @Provide isSelectedMode: boolean = false;
  @State actionBarController: ActionBarController = new ActionBarController();
  // 更换封面使用
  @State dataSource: MediaDataSource | undefined = undefined;
  private isFromGroup: boolean = false;
  private importDataSource: MediaDataSource | undefined = undefined;
  // 广播
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private selectManager: SelectManager = new SelectManager();
  @State navPathStackBindSheet: NavPathStack = new NavPathStack();
  @State private inputTitleName: string = ''; // 主标题
  @State private inputSubTitleName: string = ''; // 副标题
  @State private newCoverItem: MediaItem = new MediaItem();
  private editCoverItemHeight: number = IPHONE_EDIT_COVER_ITEM_HEIGHT;
  @State private editCoverItemWidth: number = IPHONE_EDIT_COVER_ITEM_WIDTH;
  @State isShowPhotoBrowser: boolean = false;
  @State isShowSelectPhotoBrowser: boolean = false;
  @State bindSheetController : BindSheetController = new BindSheetController();
  @State navPathStack: NavPathStack = new NavPathStack();
  private appBarManager: AlbumPhotoGridAppBarManager | undefined = undefined;
  private albumExtraParams: ParamsWrapper = new ParamsWrapper();
  private isAlwaysImmersive: boolean = false;
  private isPop: boolean = false;
  /**
   * 是否显示加载中(目前主要是在加载重复照片时显示)
   */
  @StorageLink('isShowLoadingDuplicate') private isShowLoadingDuplicate: boolean = false;
  @LocalStorageLink('geometryReuseId') geometryReuseId: string = '';
  @State keyboardHeight: number = 0;

  private readonly keyboardHeightChangeFunc: Callback<number> =
    (data: number): void => this.keyboardHeightChangeCallback(data);

  private keyboardHeightChangeCallback(data: number) {
    this.keyboardHeight = px2vp(data);
    if (DeviceInfo.isTablet() || DeviceInfo.isFoldable()) {
      Log.info(TAG, 'key board Height: ' + this.keyboardHeight + ', screen Height: ' + getScreen().getWinHeight() +
        ', bind sheet bottom: ' + (getScreen().getWinHeight() - 465) / 2);
      // 针对半模态居中显示的场景, 半模态高度固定是465, 所以不需要监听屏幕横竖屏的变化
      this.keyboardHeight = this.keyboardHeight - ((getScreen().getWinHeight() - 465) / 2);
    }
    Log.info(TAG, `key board Height = ${this.keyboardHeight}`);
  }

  private onBrowserControllerChanged(): void {
    this.isShowPhotoBrowser = this.browserController.isBrowserShow;
    this.isShowSelectPhotoBrowser = this.browserController.isSelectBrowserShow;
    this.isRunningAnimation = this.browserController.isAnimating;
  }

  private highlightUpdateBackFunc: Function = (): boolean | void => this.onBackPressFunc();

  private dataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.onDataLoadingFinished(result),
  };

  private async onDataLoadingFinished(result: LoadingResult<MediaItem>): Promise<void> {
    // 通知可能发送多次，只响应一次，多次pop会退到相册首页
    if (this.importDataSource?.totalCount() === 0 && !this.isPop) {
      this.navigationPageInfos.pop();
      this.isPop = true;
      return;
    }
    let album = await UserFileManagerAccess.getInstance().getAlbumByUri(this.item.uri);
    if (!album) {
      Log.error(TAG, `album is undefined`);
    }
    this.item.coverUri = album?.coverUri ?? '';
  }

  async aboutToAppear() {
    Log.info(TAG, 'aboutToAppear');
    if (DeviceInfo.isPhone()) {
      AppStorage.setOrCreate<Boolean>(Constants.KEY_OF_GRID_SCROLL_ENABLED, false);
    }
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);
    this.parseParams();
    this.setupSelectManager();
    this.setPhotoBrowserLoader();
    this.isShowLoadingDuplicate = false;
    this.appBroadCast.on(BroadCastConstants.HIGHLIGHT_UPDATE_BACK, this.highlightUpdateBackFunc);
    this.importDataSource?.setAlbumInfo(this.item);
    this.importDataSource?.addListener(this.dataListener);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', this.keyboardHeightChangeFunc);
    })
  }

  private parseParams(): void {
    // 取导航的传参
    try {
      this.albumExtraParams.set(Constants.ALBUM_GRID_VIEW_PAGE_FROM, Constants.GROUP_PHOTO_GRID_PAGE);
      this.isAlwaysImmersive = true;
      this.navPathStack = this.navigationPageInfos;
    } catch (e) {
      Log.warn(TAG, `parseParams failed err: ${e as BusinessError}?.code`);
    }
  }

  private setupSelectManager(): void {
    if (AlbumUtils.isAlbumGroupModeSupported()) {
      this.selectManager = new SelectManager();
    }

    this.selectManager.setPhotoDataImpl();
  }

  aboutToDisappear(): void {
    this.appBroadCast.off(BroadCastConstants.HIGHLIGHT_UPDATE_BACK, this.highlightUpdateBackFunc);
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_PHOTO_CITY_GRID, false);
    if (DeviceInfo.isPhone()) {
      AppStorage.setOrCreate<Boolean>(Constants.KEY_OF_GRID_SCROLL_ENABLED, true);
    }
    this.importDataSource?.removeListener(this.dataListener);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.off('keyboardHeightChange', this.keyboardHeightChangeFunc);
    })
  }


  /* instrument ignore next */
  onBackPressFunc(): boolean {
    Log.info(TAG, `navDestination onBackPressed${this.browserController.isSelectBrowserShow}` +
    this.browserController.isBrowserShow + this.isSelectedMode);
    if (this.browserController.isSelectBrowserShow) {
      this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, []);
      this.browserController.isSelectBrowserShow = false;
      return true;
    }
    if (this.browserController.isBrowserShow) {
      Log.info(TAG, 'goto PhotoBrowserView onBackPress');
      this.browserController.onBackPress();
      return true;
    }

    let helper: EventHelper<string> | undefined = StorageUtils.get<EventHelper<string>>(this.getUIContext(),
      Constants.LOCAL_KEY_INDEX_BACK_PRESS_EVENT_HELPER, new EventHelper<string>());
    /* instrument ignore file */
    if (helper && helper.process('')) {
      return true;
    }
    if (this.isSelectedMode) {
      this.isSelectedMode = false;
      return true;
    }

    this.navigationPageInfos.pop({});
    ScreenManager.getInstance().setDefaultStatusBarProperties(false);
    return true;
  }

  private bindSheetConfirmFunc(): void {
    Log.info(TAG, `Cover Edit finish button onclick ${this.item.coverUri} ${this.newCoverItem.thumbnail}`);
    let passTitleCheck = GroupFeature.checkNameInvalid(this.inputTitleName);
    if (passTitleCheck) {
      UiUtil.showToast($r('app.string.specific_characters_not_supported'));
      return;
    }
    if (this.inputTitleName === '' && this.item.albumName !== '') {
      UiUtil.showToast($r('app.string.please_enter_name'));
      return;
    }

    Log.info(TAG,  'newCoverItem uri: ' + this.newCoverItem.uri + ', item album albumName: ' +
    this.item.albumName + ', inputTitleName: ' + this.inputTitleName);
    // 主标题被修改
    if (this.item && this.item.albumName === this.inputTitleName) {
      Log.info(TAG, 'Title unchanged');
      return;
    }
    this.appBroadCast?.emit(BroadCastConstants.GROUP_RENAME, [this.inputTitleName]);
    this.item.albumName = this.inputTitleName;
  }

  private bindSheetCancelFunc(): void {
    if (this.navPathStackBindSheet.size() > 0) {
      this.navPathStackBindSheet.clear();
    }
  }

  @BuilderParam photoBrowserViewLoader: ($$: PhotoBrowserViewLoaderParams) => void;
  @BuilderParam selectPhotoBrowserLoader: ($$: PhotoBrowserLoaderParams) => void;

  @Builder
  buildBrowser() {
    if (this.isShowPhotoBrowser) {
      Column() {
        this.photoBrowserViewLoader({
          isShowBar: true,
          pageStatus: false,
          hidePhotoBrowser: (isPlayAni: boolean, index: number): void => {
            // todo lishang 接口需要更新，index改为返回实际index
            this.browserController.hideBrowser(index)
          },
          isRunningAnimation: this.isRunningAnimation,
          isShowMenu: true,
          canPullingUp: true,
          isShowThumbSource: true,
          isShowImageAnalyzer: true,
          reportStartTime: 0,
          onDeleteAllPhoto: (): void => {
          }
        })
      }
      .width('100%')
      .height('100%')

      // Opacity must change for TransitionEffect taking effect
      .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
      .id(this.geometryReuseId)
    }

    if (this.isShowSelectPhotoBrowser) {
      Column() {
        this.selectPhotoBrowserLoader({
          pageStatus: this.pageStatus,
          geometryTransitionEnable: this.browserController.geometryTransitionEnable,
          isRunningAnimation: this.isRunningAnimation,
        });
      }
      .width('100%')
      .height('100%')

      // Opacity must change for TransitionEffect taking effect
      .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
      .enabled(!this.browserController.isAnimating)
      .id(this.geometryReuseId)
    }
  }

  build() {
    NavDestination() {
      Stack() {
        if (AlbumUtils.useNewPhotoGrid() &&
          this.importDataSource instanceof AlbumDataSource && this.appBarManager) {
          AlbumPhotoGridView({
            isSupportGroupDay: false,
            pageStatus: this.pageStatus,
            isSelectedMode: this.isSelectedMode,
            importDataSource: this.importDataSource,
            navPathStack: this.navPathStack,
            gridAppBarManager: this.appBarManager,
            bindSheetController: this.bindSheetController,
            albumGridConfig: {
              isAlwaysImmersive: this.isAlwaysImmersive,
              extraParams: this.albumExtraParams,
            },
            customBuilderLoaderParam: {
              dayViewBuilder: ArtisticDayViewBuilder
            }
          })
        }

        this.buildBrowser();

        // 判断如果需要显示加载中时，显示加载中
        if (this.isShowLoadingDuplicate) {
          LoadingPanel().backgroundColor($r('app.color.white')).opacity(0.8);
        }
      }
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onBackPressed((): boolean => {
      return this.onBackPressFunc();
    })
    .onShown(() => {
      Log.info(TAG, 'NavDestination onShown');
      this.pageStatus = true;
    })
    .onHidden(() => {
      Log.info(TAG, 'NavDestination onHidden')
      this.pageStatus = false;
    })
  }

  // 动态加载大图
  private async setPhotoBrowserLoader(): Promise<void> {
    try {
      let photoBrowserLoader = await import('./PhotoBrowserLoader');
      this.photoBrowserViewLoader = photoBrowserLoader.PhotoBrowserViewLoader;
      this.selectPhotoBrowserLoader = photoBrowserLoader.SelectPhotoBrowserLoader;
      Log.info(TAG, 'setPhotoBrowserLoader success');
    } catch (error) {
      Log.error(TAG, `setPhotoBrowserLoader error: ${error}`);
    }
  }
  @Builder
  buildHighlightBindSheet() {
    Navigation(this.navPathStackBindSheet) {
      Column() {
        EditCoverComponent({
          title: $r('app.string.edit_group_album'),
          albumInfo: this.item,
          fromPage: TAG,
          editCoverItemWidth: this.editCoverItemWidth,
          editCoverItemHeight: this.editCoverItemHeight,
          newCoverItem: this.newCoverItem,
          navPathStackBindSheet: this.navPathStackBindSheet,
          inputTitleName: this.inputTitleName,
          inputSubTitleName: this.inputSubTitleName,
          keyboardHeight: this.keyboardHeight,
          originalName: this.item.albumName as string,
          confirmFunc: (): void => {
            this.bindSheetConfirmFunc();
          },
          cancelFunc: (): void => {
            this.bindSheetCancelFunc();
          },
        })

      }
    }
    .hideTitleBar(true)
    .navDestination(this.routerControl)
  }

  @Builder
  routerControl(name: string) {
    if (name === Constants.COVER_SELECT_SHEET) {
      CoverSelectComponent({
        navPathStackBindSheet: this.navPathStackBindSheet,
        albumInfo: this.item,
        cancelFunc:  (): void => {
          this.bindSheetCancelFunc();
        },
      });
    } else if (name === Constants.COVER_PREVIEW_SHEET) {
      CoverPreviewSheet({
        navPathStackBindSheet: this.navPathStackBindSheet,
        selectCoverItem: this.newCoverItem,
        cancelFunc: (): void => {
          this.bindSheetCancelFunc();
        },
      });
    }
  }
}