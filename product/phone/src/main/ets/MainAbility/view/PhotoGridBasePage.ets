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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { PhotoBrowserLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserLoaderParams';
import lazy {
  PhotoGridPageActionBarNavTitle
} from '@ohos/common/src/main/ets/default/view/actionbar/PhotoGridPageActionBarNavTitle';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { AlbumRefreshConst } from '@ohos/common/src/main/ets/default/utils/AlbumRefreshUtil';
import lazy { BusinessError } from '@ohos.base';
import lazy { AttributeUpdater, NavDestinationModifier } from '@ohos.arkui.modifier';
import lazy { PhotoBrowserViewLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserViewLoaderParams';
import lazy {
  initPhotoBrowserController,
  PhotoBrowserController, PhotosHmBrowserController,
  unInitPhotoBrowserController } from '@ohos/browserlibrary';
import lazy {
  BigDataConstants,
  ReportToBigDataUtil,
  AlbumBrowsingInfo
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { AlbumBigDataConstants } from '@ohos/common/src/main/ets/default/model/browser/album/ReportAlbumDataUtil';
import lazy { TabBarUtils } from '@ohos/common/src/main/ets/default/utils/TabBarUtils';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { AlbumPhotoGridView, BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4';
import lazy { common } from '@kit.AbilityKit';
import lazy { Router } from '@kit.ArkUI';
import lazy { AlbumPhotoGridAppBarManager } from '../../viewmodel/AlbumPhotoGridAppBarManager';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { IrregularView,
  IrregularViewBuildParams } from '@ohos/timeline/src/main/ets/photogrid/view/IrregularView';
import lazy { AlbumConstants } from '@ohos/timeline/src/main/ets/photogrid/statemanager/constants/AlbumConstants';
import lazy { EventHelper } from '@ohos/common/src/main/ets/default/view/ViewEventHelper';
import lazy { StorageUtils } from '@ohos/common/src/main/ets/default/utils/StorageUtils';
import lazy { ArtisticDayViewBuilder } from '@ohos/timeline/src/main/ets/albumgrid/view/CustomBuilderLoaderParam';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { IrregularElementBuilder } from '@ohos/timeline/src/main/ets/albumgrid/view/IrregularElement';

/* instrument ignore file */
const TAG: string = 'PhotoGridBasePage';
const SWIPER_HEIGHT: number = 400;

interface ParamAlbumInfo {
  item: string;
  isFromFACard: boolean;
  isFromPortraitCoverSet: boolean;
  paramsWrapper?: ParamsWrapper;
}

// 动态加载调用入口
@Builder
export function PhotoGridBasePageLoader() {
  PhotoGridBasePage();
}

class NavDestModifier extends AttributeUpdater<NavDestinationModifier> {
  applyNormalAttribute(instance: NavDestinationAttribute) {
  }
}

// Album Page
@Component
export struct PhotoGridBasePage {
  @State pageStatus: boolean = false;
  // 是否选择模式
  @Provide @Watch('onIsSelectedModeChanged') isSelectedMode: boolean = false;
  // 是否显示
  @Consume isShow: boolean;
  // 正在执行动画
  @State isRunningAnimation: boolean = false;
  @State @Watch('onIsBrowserShowChanged') isBrowserShow: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public albumInfo: AlbumInfo = new AlbumInfo();
  @State actionBarController: ActionBarController = new ActionBarController();
  @Provide({allowOverride: 'albumInfoForMe'}) albumInfoForMe:  AlbumInfo | undefined = undefined;
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  @State public navPathStack: NavPathStack = new NavPathStack();
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  @StorageLink('isHorizontal') @Watch('onIsHorizontalChanged') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('statusBarHeight') @Watch('onStatusBarHeightChanged') statusBarHeight: number = 0;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @Consume isShowTabBar: boolean;
  @State private canEnterImmersive: boolean = true;
  private isFromFileManager: boolean = false;
  private importDataSource: MediaDataSource | undefined = undefined;
  @LocalStorageLink('geometryReuseId') geometryReuseId: string = '';
  @Provide({allowOverride: 'browserController'}) @Watch('updateAnimationStatus')
  browserController: PhotosHmBrowserController = new PhotosHmBrowserController(global.uiAbilityContext(),
    global.windowStage(), getContext())
  private navParams: ParamsWrapper | undefined = undefined;
  private newCreateAlbum: boolean = false;
  private isHideTitleBar: boolean = false;
  private paddingValue: number = 0;
  private navDestModifier: NavDestModifier = new NavDestModifier();
  private enterAlbumTime: number = 0;
  @StorageProp('change_background') @Watch('changeBackgroundStatus') isBackGround: boolean = false;
  private isFromPortraitCard: boolean | undefined = false;
  private matrixForPortraitRename: Matrix4x4 | undefined = undefined;
  private isPullingUp: boolean = false;
  private isPullingUpFunc: Function = (isPullingUp: boolean): void => {
    this.isPullingUp = isPullingUp;
  }
  private isShowOrHideBar: boolean = false;
  private isShowOrHideBarFunc: Function = (isShowOrHideBar: boolean): void => {
    this.isShowOrHideBar = isShowOrHideBar;
  }
  private onBackPressedFunc: Function = (): boolean => {
    return this.onBackPressed()
  }
  private albumExtraParams: ParamsWrapper = new ParamsWrapper();
  private isAlwaysImmersive: boolean = false;
  private hasPop: boolean = false;
  private readonly dataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.onDataLoadingFinished(result),
  } as DataListener<MediaItem>;
  private isFromFormProfile: boolean = false;

  private onDataLoadingFinished(result: LoadingResult<MediaItem>): void {
    if (this.importDataSource?.totalCount() === 0 && !this.hasPop) {
      this.navigationPageInfos.pop({});
      this.hasPop = true;
    }
  }
  private formId: string = '';

  aboutToAppear(): void {
    Log.debug(TAG, 'aboutToAppear');
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
    this.setPhotoBrowserLoader();
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
    this.appBroadCast.on(BroadCastConstants.IS_PULLING_UP, this.isPullingUpFunc);
    this.appBroadCast.on(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, this.isShowOrHideBarFunc);
    this.updateActionMoreMenuList();
    this.isBrowserShow = this.browserController.isBrowserShow;
    this.updateHideTitleBar();
    this.updatePadding();
    if (this.isFromFileManager) {
      Log.info(TAG, 'PhotoGridBasePage isFromFileManager');
      return;
    }
    try {
      if (!this.navParams) {
        this.navParams = (this.navigationPageInfos.getParamByIndex(this.navigationPageInfos.size() -
          1) as ParamAlbumInfo)?.paramsWrapper;
      }
      this.importDataSource = this.navParams?.get<MediaDataSource>(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_DATASOURCE);
      this.newCreateAlbum =
        this.navParams?.get<boolean>(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_IS_NEW_ALBUM) ?? false;
    } catch (e) {
      Log.error(TAG, `failed to get nav params err: ${(e as BusinessError)?.message}`);
    }
    if (AppStorage.get<boolean>(Constants.IS_FROM_FORM_ABILITY_PROFILE)) {
      let photoGridAppearArray: string[] = AppStorage.get<string[]>(Constants.PHOTO_GRID_BASE_PAGE_APPEAR) ?? new Array();
      photoGridAppearArray.push(this.formId);
      AppStorage.setOrCreate<string[]>(Constants.PHOTO_GRID_BASE_PAGE_APPEAR, photoGridAppearArray);
      AppStorage.delete(Constants.IS_FROM_FORM_ABILITY_PROFILE);
      this.appBroadCast.on(BroadCastConstants.PHOTO_GRID_BASE_PAGE_BACKPRESS, this.onBackPressedFunc);
    }
    if (AppStorage.get<boolean>(Constants.IS_FROM_FORM_ABILITY_PORTRAIT)) {
      AppStorage.delete(Constants.IS_FROM_FORM_ABILITY_PORTRAIT);
    }
    initPhotoBrowserController(this.browserController, this.getPageName(), false);
    this.enterAlbumTime = Date.now();
    this.importDataSource?.addListener(this.dataListener);
  }

  private reportBrowsingInfo(): void {
    const duration : number = Math.floor((Date.now() - this.enterAlbumTime) / 1000);
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear`);
    this.reportBrowsingInfo();
    this.appBroadCast.off(BroadCastConstants.IS_PULLING_UP, this.isPullingUpFunc);
    this.appBroadCast.off(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, this.isShowOrHideBarFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_GRID_BASE_PAGE_BACKPRESS, this.onBackPressedFunc);
    let photoGridAppearArray: string[] = AppStorage.get<string[]>(Constants.PHOTO_GRID_BASE_PAGE_APPEAR) ?? new Array();
    photoGridAppearArray.shift();
    AppStorage.set<string[]>(Constants.PHOTO_GRID_BASE_PAGE_APPEAR, photoGridAppearArray);
    unInitPhotoBrowserController(this.browserController);
  }

  private onIsFromPortraitChanged(): void {
    this.updateHideTitleBar();
    this.updatePadding();
  }

  private onIsFromPortraitCoverSetChanged(): void {
    this.updateHideTitleBar();
    this.updatePadding();
  }

  private onIsSelectedModeChanged(): void {
    this.updateHideTitleBar();
    this.updatePadding();
  }

  private onIsBrowserShowChanged(): void {
    this.updateHideTitleBar();
    this.updatePadding();
  }

  private onIsHorizontalChanged(): void {
    this.updateHideTitleBar();
    this.updatePadding();
    if (!DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) {
      ScreenManager.getInstance().recoverHorizontalStatusBar(this.isHorizontal);
    }
    if (this.isHorizontal && !DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) {
      ScreenManager.getInstance().setDefaultStatusBarProperties(true);
    } else {
      ScreenManager.getInstance().setDefaultStatusBarProperties(false);
    }

  }

  private onStatusBarHeightChanged(): void {
    this.updateHideTitleBar();
    this.updatePadding();
  }

  private updateHideTitleBar(): void {
    this.isHideTitleBar = (this.isFromFileManager) ? true :
      (this.isSelectedMode || this.isBrowserShow);
    this.navDestModifier.attribute?.hideTitleBar(this.isHideTitleBar);
  }

  private updatePadding(): void {
    this.paddingValue = (this.isFromFileManager) ? 0 :
      ((this.isHorizontal && !(DeviceInfo.isTablet() || DeviceInfo.isFoldable())) || this.isBrowserShow ||
      this.isSelectedMode) ? 0 : px2vp(this.statusBarHeight);
    this.navDestModifier.attribute?.padding({ top: this.paddingValue });
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

  private updateActionMoreMenuList() {
    let tempMenuList: Action[] = [];
    tempMenuList.push(Action.RENAME_ALBUM);
    tempMenuList.push(Action.DELETE_ALBUM);
    let msg: string = tempMenuList.map((action: Action) => action.componentKey).join(',');
    Log.info(TAG, `actionMoreMenuList: ${msg}`);
    this.actionBarController.actionMoreMenuList = tempMenuList;
  }

  onPageShow(): void {
    this.pageStatus = true;
  }

  onDidBuild(): void {
    Log.info(TAG, `onDidBuild`);
  }

  onPageHide(): void {
    Log.info(TAG, `onPageHide`);
    this.pageStatus = false;
  }

  // 返回事件
  onBackPress(): boolean {
    Log.info(TAG, `onBackPress`);
    if (this.browserController.isBrowserShow) {
      this.doPhotoBrowserViewBack();
      return true;
    }
    if (this.browserController.isSelectBrowserShow) {
      this.doSelectPhotoBrowserViewBack();
      return true;
    }
    if (this.isSelectedMode) {
      this.isSelectedMode = false;
      return true;
    }
    return false;
  }

  //选择的大图返回广播事件
  doSelectPhotoBrowserViewBack(): void {
    this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT,
      [this.browserController.browserControllerId]);
  }

  // 大图返回广播事件
  doPhotoBrowserViewBack(): void {
    this.browserController.onBackPress();
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, []);
  }

  @Builder
  buildGridViewActionBarEmpty() {
  }

  // actionBar组件
  @Builder
  buildGridViewActionBar() {
    PhotoGridPageActionBarNavTitle({
      albumInfo: this.albumInfo,
      actionBarController: this.actionBarController,
      isNavDestinationPageActionBar: true,
      isSelectedMode: this.isSelectedMode,
    })
  }

  @State private bindSheetController : BindSheetController = new BindSheetController();

  @Builder
  buildPhotoGridView() {
    Column() {
      this.PhotoGridViewLoader();
    }
    .padding({
      left: this.isFromFileManager ? this.diggingHoleCameraArea.left : 0,
      right: this.isFromFileManager ? this.diggingHoleCameraArea.right : 0,
      bottom: (this.isFromFileManager) ?
        this.diggingHoleCameraArea.bottom : 0,
    })
  }

  /* instrument ignore file */
  @Builder
  PhotoGridViewLoader() {
    /* instrument ignore if */
    if (AlbumUtils.useNewPhotoGrid() && this.importDataSource instanceof AlbumDataSource) {
      AlbumPhotoGridView({
        pageStatus: this.pageStatus,
        isSelectedMode: this.isSelectedMode,
        importDataSource: this.importDataSource,
        navPathStack: this.navPathStack,
        isSupportGroupDay: true,
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
  }

  /**
   * 获取使用 PhotoGridBasePage 页面的名称。
   *
   * 由于 PhotoGridBasePage 未定义 pageName 参数，所以其包装的 PhotoGridView 使用的是默认值 'PhotoGridPage'。
   * 这样会导致以下问题：
   * - 在设置与大图做共享元素动效时，id 仅与文件路径相关。
   * - 当页面栈中存在两个使用同一个数据源的 PhotoGridBasePage 页面时（例如人像一级页面和更换封面页面），
   *   在二级页面上打开大图并退出大图时，会发送通知给所有宫格，更新 geometryTransitionId。
   *   由于人像一级页面和更换封面页面的数据源相同，而 PhotoGridBasePage 宫格的 geometryTransitionId
   *   仅与文件路径相关，因此导致了两个宫格设置同一个 geometryTransitionId。
   *   再次打开这个异常宫格时，给大图也设置了这个 geometryTransitionId，
   *   从而导致三个 Node 节点共用一个 geometryTransitionId，动画执行时会出现异常。
   *
   * 为解决这个问题，给人像一级页面和选择封面页面设置不同的 pageName，以规避三个节点使用同一 id 的情况。
   *
   * 此处仅做最小改动，建议宫格后续优化代码，让外部通过路由参数传递自己的 pageName，删除本方法。
   *
   * @returns 使用 PhotoGridBasePage 页面的名称。
   */
  private getPageName(): string {
    let pageName = Constants.PHOTO_TRANSITION_ALBUM;
    return pageName;
  }

  @BuilderParam photoBrowserViewLoader: ($$: PhotoBrowserViewLoaderParams) => void;

  @Builder
  buildPhotoBrowserComponent() {
    if (this.browserController.isBrowserShow) {
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
      .transition(TransitionEffect.opacity(0.99))
      .id(this.geometryReuseId)
    }
  }

  @BuilderParam selectPhotoBrowserLoader: ($$: PhotoBrowserLoaderParams) => void;

  build() {
    NavDestination() {
      Stack() {
        this.buildPhotoGridView();

        this.buildPhotoBrowserComponent();

        if (this.browserController.isSelectBrowserShow) {
          Column() {
            this.selectPhotoBrowserLoader({
              pageStatus: this.pageStatus,
              geometryTransitionEnable: true,
              isRunningAnimation: this.isRunningAnimation
            });
          }
          .width('100%')
          .height('100%')

          // Opacity must change for TransitionEffect taking effect
          .transition(TransitionEffect.opacity(0.99))
          .id(this.geometryReuseId)
        }
      }
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(this.isHideTitleBar)
    .title(this.buildGridViewActionBar)
    .onBackPressed((): boolean => {
      Log.info(TAG, 'navDestination onBackPressed');
      if (!this.isSelectedMode && !this.isBrowserShow && DeviceInfo.isGRLFoldScreen()) {
        LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_POSITION);
      }
      return this.onBackPressed();
    })
    .padding({
      top: this.paddingValue,
    })
    .attributeModifier(this.navDestModifier)
    .onShown(() => {
      Log.info(TAG, 'NavDestination onShown');
      this.pageStatus = true;
    })
    .onHidden(() => {
      Log.info(TAG, 'NavDestination onHidden')
      this.pageStatus = false;
    })
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
    PageTransitionExit({ type: RouteType.Push, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
  }

  private updateAnimationStatus(): void {
    if (this.isRunningAnimation !== this.browserController.isAnimating) {
      this.isRunningAnimation = this.browserController.isAnimating;
    }
    {
      if (this.isBrowserShow !== this.browserController.isBrowserShow) {
        Log.info(TAG, `updateAnimationStatus, isBrowserShow Changed to ${this.browserController.isBrowserShow}`);
        this.isBrowserShow = this.browserController.isBrowserShow;
      }
    }
  }

  /**
   * 返回事件
   *
   * @returns true/false
   */
  private onBackPressed(): boolean {
    Log.info(TAG, `onBackPressed`);

    if (AppStorage.get<string>(Constants.PHOTO_BROWSER_COMPONENT_APPEAR)) {
      Log.info(TAG, `onBackPress to photoBrowserComponent`);
      this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT);
      return true;
    }

    if (this.browserController.isBrowserShow) {
      Log.info(TAG, 'goto PhotoBrowser onBackPress');
      if (this.isPullingUp || this.isShowOrHideBar) {
        this.browserController.onBackPress(false, false, this.browserController.browserControllerId);
        this.isShowOrHideBar = false;
        return true;
      }
      this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_CENTER, []);
      this.browserController.onBackPress(false, false, this.browserController.browserControllerId);
      if (DeviceInfo.isPc()) {
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, []);
      }
      return true;
    }

    if (this.browserController.isSelectBrowserShow) {
      this.doSelectPhotoBrowserViewBack();
      return true;
    }


    if (this.isSelectedMode) {
      this.isSelectedMode = false;
      return true;
    }


    this.isShowTabBar = true;

    Log.info(TAG, 'goto PhotoGridBasePage onBackPress');
    this.isSelectedMode = false;
    // 从相机进入，侧滑返回退出
    if (AppStorage.get(Constants.DESTROY_FROM_CAMERA)) {
      let context: common.UIAbilityContext =
        LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
      context.terminateSelf().then((result: void) => {
        Log.info(TAG, 'photoSearchPagePhone terminateSelfWithResult');
        AppStorage.setOrCreate<boolean>(Constants.DESTROY_FROM_CAMERA, false);
      });
    }

    // 人像卡片跳转后返回，销毁上层页面
    if (this.isFromFormProfile) {
      this.appBroadCast.emit(BroadCastConstants.IS_SHOW_PHOTO_GRID_BASE_PAGE_OFF);
      return true;
    }

    Log.info(TAG, `GeometryTransitonId: ${LocalStorage?.getShared()?.get<string>('geometryTransitionBrowserId')}`);
    this.navigationBroadCast.emit(NavigationConstants.NAVIGATION_DESTINATION_PHOTO_GRID_VIEW_BACK, []);
    this.navigationPageInfos.pop({});
    this.browserController.isFromPortrait = false;
    return true;
  }

  public changeBackgroundStatus(changedPropertyName: string): void {
    if (this.isBackGround) {
      this.reportBrowsingInfo();
    } else {
      this.enterAlbumTime = Date.now();
    }
  }
}