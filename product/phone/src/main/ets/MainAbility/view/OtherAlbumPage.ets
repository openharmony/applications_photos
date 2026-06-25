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
 
import { PhotosHmBrowserController } from "@ohos/browserlibrary"
import { PhotoBrowserLoaderParams } from "@ohos/common/src/main/ets/default/interface/PhotoBrowserLoaderParams";
import { PhotoBrowserViewLoaderParams } from "@ohos/common/src/main/ets/default/interface/PhotoBrowserViewLoaderParams";
import { AlbumDataSource } from "@ohos/common/src/main/ets/default/model/AlbumDataSource"
import { MediaDataSource } from "@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource";
import { SelectManager } from "@ohos/common/src/main/ets/default/model/browser/SelectManager";
import { BroadCastConstants } from "@ohos/common/src/main/ets/default/model/common/BroadCastConstants";
import { BroadCastManager } from "@ohos/common/src/main/ets/default/model/common/BroadCastManager";
import { Constants } from "@ohos/common/src/main/ets/default/model/common/Constants";
import { isOrientationHorizontal, ScreenManager } from "@ohos/common/src/main/ets/default/model/common/ScreenManager";
import { AlbumRefreshConst } from "@ohos/common/src/main/ets/default/utils/AlbumRefreshUtil";
import { AlbumUtils } from "@ohos/common/src/main/ets/default/utils/AlbumUtils"
import { BroadCast } from "@ohos/common/src/main/ets/default/utils/BroadCast";
import { ParamsWrapper } from "@ohos/common/src/main/ets/default/view/actionbar/Menu";
import { ActionBarController } from "@ohos/common/src/main/ets/default/view/ActionBarController";
import { AlbumPhotoGridView, BindSheetController } from "@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView"
import { AlbumPhotoGridVm } from "@ohos/timeline/src/main/ets/albumgrid/viewmodel/AlbumPhotoGridVm";
import { Log } from "@ohos/tools/src/main/utils/Log";
import { AlbumPhotoGridAppBarManager } from "../../viewmodel/AlbumPhotoGridAppBarManager";
import { SourceAlbumPhotoGridAppBarManager } from "../../viewmodel/SourceAlbumPhotoGridAppBarManager";
import { TrashAlbumPhotoGridAppBarManager } from "../../viewmodel/TrashAlbumPhotoGridAppBarManager";
import { TrashAlbumPhotoGridVm } from "../../viewmodel/TrashAlbumPhotoGridVm";
import lazy { GallerySettingsActionBar } from "@ohos/privacy/src/main/ets/setting/GallerySettingsActionBar";

const TAG = 'OtherAlbumPage';

@Builder
export function OtherAlbumPageLoader() {
  OtherAlbumPage();
}

@Entry
@Component
export struct OtherAlbumPage {
  @Consume @Watch('updateBrowserStatus') browserController: PhotosHmBrowserController;
  @State pageStatus: boolean = false;
  @State isRunningAnimation: boolean = false;
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  @State public navPathStack: NavPathStack = new NavPathStack();
  @Provide isSelectedMode: boolean = false;
  @Consume isShowTabBar: boolean;
  @State actionBarController: ActionBarController = new ActionBarController();
  @State isEmpty: boolean = true;
  private dataSource?: MediaDataSource;
  private importDataSource: MediaDataSource | undefined = undefined;

  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private selectManager: SelectManager = new SelectManager();
  private storageParams: object | undefined = undefined;
  private navParams: ParamsWrapper | undefined = undefined;

  private appBarManager: AlbumPhotoGridAppBarManager | undefined = undefined;
  @State private bindSheetController : BindSheetController = new BindSheetController();
  private viewModel: AlbumPhotoGridVm = new AlbumPhotoGridVm();
  private isSupportScaleAnimation: boolean | undefined = undefined;
  private isNewCreateAlbum: boolean = false;
  private isSourceAlbum: boolean = false;
  @State private isRecycleAlbumPage: boolean = false;

  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;

  @StorageLink('isShowDeleteAll') isShowDeleteAll: boolean = true;
  aboutToAppear(): void {
    Log.info(TAG, "aboutToAppear");
    this.isShowDeleteAll = true
    this.updateStatusBar();
    AppStorage.setOrCreate<Boolean>(Constants.KEY_OF_GRID_SCROLL_ENABLED, false);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);
    this.parseParams();

    this.setPhotoBrowserLoader();
    this.setupPhotoGridView();
    this.setupSelectManager();

    this.navPathStack = this.navigationPageInfos;
    if (this.importDataSource instanceof AlbumDataSource) {
      let albumInfo = this.importDataSource.albumInfo;
      if (this.storageParams?.['isSourceAlbum']) {
        this.isSourceAlbum = true;
        this.appBarManager = new SourceAlbumPhotoGridAppBarManager(this.importDataSource, this.navPathStack, this.bindSheetController);
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
      } else if (this.storageParams?.['subType'] === Constants.TRASH_QUERY_SUB_TYPE ||
                 albumInfo?.isTrashAlbum || albumInfo?.subType === Constants.TRASH_QUERY_SUB_TYPE) {
        this.isRecycleAlbumPage = true;
        this.viewModel = new TrashAlbumPhotoGridVm((newState: boolean) => {
          this.isEmpty = newState;
        });
        this.appBarManager = new TrashAlbumPhotoGridAppBarManager(this.importDataSource, this.navPathStack, this.bindSheetController);
      } else if (this.isNewCreateAlbum) {
        this.isSupportScaleAnimation = false;
        this.appBarManager = new SourceAlbumPhotoGridAppBarManager(this.importDataSource, this.navPathStack, this.bindSheetController);
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
      }
    }
  }

  aboutToDisappear(): void {
    AppStorage.setOrCreate<Boolean>(Constants.KEY_OF_GRID_SCROLL_ENABLED, true);
  }

  onBackPressFunc(): boolean {
    if (this.browserController.isSelectBrowserShow) {
      this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, []);
      this.browserController.isSelectBrowserShow = false;
      return true;
    }
    if (this.isSelectedMode) {
      if (AlbumUtils.useNewPhotoGrid() && this.importDataSource instanceof AlbumDataSource && this.appBarManager) {
        this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_EVENT, []);
      }
      this.isSelectedMode = false;
      return true;
    }
    if (this.browserController.isBrowserShow) {
      this.browserController.onBackPress();
      this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_EVENT, []);
      return true;
    }
    this.navigationPageInfos.pop();
    ScreenManager.getInstance().setDefaultStatusBarProperties(false);
    return true;
  }

  private setupPhotoGridView():void {
    let uri: string | undefined = undefined;
    let subType: number | undefined = undefined;
    if (this.storageParams) {
      uri = this.storageParams['uri'];
      subType = this.storageParams['subType'];
    }

    Log.info(TAG, `setupPhotoGridView album: ${uri}, subType: ${subType}`);
    this.importDataSource = this.navParams?.get<MediaDataSource>(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_DATASOURCE);
  }

  private setupSelectManager(): void {
    if (AlbumUtils.isAlbumGroupModeSupported()) {
      this.selectManager = new SelectManager();
    }

    this.selectManager.setPhotoDataImpl();
  }

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

  private parseParams(): void {
    if(this.navigationPageInfos.size() > 0) {
      this.navParams = this.navigationPageInfos.getParamByIndex(this.navigationPageInfos.size() - 1) as ParamsWrapper;
      this.isNewCreateAlbum = this.navParams?.get<boolean>(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_IS_NEW_ALBUM);
    }
  }

  private updateStatusBar() {
    Log.info(TAG, `updateStatusBar isHorizontal: ${this.isHorizontal}`)
    ScreenManager.getInstance().setSystemUi(!this.isHorizontal);
  }

  private isRecycleAlbum(): boolean {
    return this.isRecycleAlbumPage;
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          this.PhotoGridViewLoader();
        }
        .padding({
          left: 0,
          right: 0,
          bottom: 0,
        })

        if (this.importDataSource instanceof AlbumDataSource && this.appBarManager instanceof TrashAlbumPhotoGridAppBarManager && this.isShowDeleteAll) {
          Column() {
            Button({ type: ButtonType.Normal, buttonStyle: ButtonStyleMode.NORMAL, controlSize: ControlSize.NORMAL }) {
              Text($r(`app.string.action_clear_recycle`))
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.Body_L'))
                .maxFontScale(2.0)
                .fontColor($r('sys.color.font_emphasize'))
                .constraintSize({ minHeight: $r('app.float.details_dialog_button_height') })
                .margin({
                  left: $r('app.float.dialog_double_buttons_margin'),
                  right: $r('app.float.dialog_double_buttons_margin')
                })
            }
            .key('ClearRecycleButton')
            .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
            .borderRadius($r('sys.float.corner_radius_level10'))
            .onClick(() => {
              if (this.appBarManager instanceof TrashAlbumPhotoGridAppBarManager) {
                this.appBarManager.clearAllDoAction();
              }
            })
          }
          .hitTestBehavior(HitTestMode.Transparent)
          .width('100%')
          .height('100%')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.End)
          .padding({
            bottom: $r('app.float.action_clear_recycle_large_padding')
          })
          .visibility(this.isEmpty ? Visibility.Hidden : Visibility.Visible)
        }

        this.buildBrowser();
      }
    }
    .margin({bottom: this.isRecycleAlbumPage ? 0 : 44})
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onBackPressed(() : boolean => {
      return this.onBackPressFunc();
    })
    .onShown(() => {
      this.pageStatus = true;
      Log.info(TAG, 'NavDestination onShown')
    })
    .onHidden(() => {
      this.pageStatus = false;
      Log.info(TAG, 'NavDestination onHidden')
    })
  }

  @BuilderParam photoBrowserViewLoader: ($$: PhotoBrowserViewLoaderParams) => void;
  @BuilderParam selectPhotoBrowserLoader: ($$: PhotoBrowserLoaderParams) => void;

  @Builder
  buildBrowser() {
    if(this.browserController.isBrowserShow) {
      Column() {
        this.photoBrowserViewLoader({
          isShowBar: true,
          pageStatus: false,
          hidePhotoBrowser: (isPlayAni: boolean, index: number): void => {
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
      .transition(TransitionEffect.opacity(0.99))
    }
  }

  @Builder
  PhotoGridViewLoader() {
    if (AlbumUtils.useNewPhotoGrid() && this.importDataSource instanceof AlbumDataSource) {
      AlbumPhotoGridView({
        pageStatus: this.pageStatus,
        isSelectedMode: this.isSelectedMode,
        navPathStack: this.navPathStack,
        importDataSource: this.importDataSource,
        gridAppBarManager: this.appBarManager,

        albumGridConfig: {
          isSupportSortSelector: this.storageParams?.['isSourceAlbum'] || this.isNewCreateAlbum,
          isSupportTrashMsg: this.appBarManager instanceof TrashAlbumPhotoGridAppBarManager,
          isSupportScaleAnimation: this.isSupportScaleAnimation
        },
        viewModel: this.viewModel,
        bindSheetController: this.bindSheetController,
      })
    }
  }

  updateBrowserStatus(): void {
    this.isRunningAnimation = this.browserController.isAnimating;
  }
}