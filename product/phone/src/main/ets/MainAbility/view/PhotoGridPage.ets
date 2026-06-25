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
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy { common, ConfigurationConstant } from '@kit.AbilityKit';
import lazy { PageStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { PhotoGridBasePage } from './PhotoGridBasePage';
import lazy { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { dataSharePredicates } from '@kit.ArkData';
import lazy { initPhotoBrowserController, PhotosHmBrowserController } from '@ohos/browserlibrary';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumRefreshConst } from '@ohos/common/src/main/ets/default/utils/AlbumRefreshUtil';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { FoldUtil } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { ExtendedServicesPage } from '@ohos/privacy/src/main/ets/components/extendedService/ExtendedServicesPage';
import lazy { GallerySettingsBasePage } from '@ohos/privacy/src/main/ets/setting/GallerySettingsBasePage';
import lazy { MediaOperationBasePage } from '@ohos/common/src/main/ets/default/view/browserOperation/MediaOperationBasePage';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { PickerBasePage } from '../../pickerability/view/PickerBasePage';
import lazy { StatementsCards } from '@ohos/privacy/src/main/ets/components/extendedService/StatementsCards';
import lazy { ServiceAgreementsCards } from '@ohos/privacy/src/main/ets/components/extendedService/ServiceAgreementsCards';
import lazy { MoviePage } from './MoviePage';
import lazy {
  NavigationBroadCastManager
} from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { PickerBasePageParams } from '../../pickerability/view/PickerBasePage';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';

/* instrument ignore file */
const TAG: string = 'PhotoGridPage';

interface ParamAlbumInfo {
  item: string;
  isFromFACard?: boolean;
  isFromThirdSelect?: boolean;
};

interface PageParam {
  pageFrom: string,
  targetPage: string,
  albumLpathName: string,
  albumInfo: AlbumInfo,
}

@Entry(LocalStorage.getShared())
@Component
export struct PhotoGridPage {
  @Provide private isShowSideBar: boolean = false;
  @Provide('navigationPageInfos') private navigationPageInfos: NavPathStack = new NavPathStack();
  // 是否显示大图
  @State private isShowPhotoBrowser: boolean = false;
  // 广播
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Provide private isShow: boolean = true;
  @Provide private isShowTabBar: boolean = false;
  // 按下返回
  @Provide private backPress: boolean = false;
  @Provide private isAlbumSetSelectedMode: boolean = false;
  @State private isRunningAnimationHighlight: boolean = false;
  @Provide @Watch('onBrowserControllerChanged') browserController: PhotosHmBrowserController =
    new PhotosHmBrowserController(global.uiAbilityContext(), global.windowStage(), getContext());
  @State private isShowPhotoBrowserHighlight: boolean = false;
  @State private albumInfo: AlbumInfo = new AlbumInfo();
  @State private isFromFileManager: boolean = false;
  @State private isFinishInitAlbum: boolean = false;
  @State private navParams: ParamsWrapper | undefined = undefined;
  private isFromFormProfile: boolean = false;
  private readonly sourceType: Record<string, string> = {
    'camera': '/DCIM/Camera',
    'share': '/Xxx Share'
  };
  @Provide displaySearchWords: string = '';
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  @BuilderParam pickerBasePageLoader: ($$: PickerBasePageParams) => void;
  private loadNavigationPageFun: Function = (name: string): Promise<void> => this.loadNavigationPage(name);
  private isShowAlbumCoverSelectPage: boolean = true;
  private onBrowserControllerChanged(): void {
    this.isShowPhotoBrowserHighlight = this.browserController.isBrowserShow;
    this.isRunningAnimationHighlight = this.browserController.isAnimating;
    Log.info(TAG, `onBrowserControllerChanged isShowPhotoBrowser: ${
    this.isShowPhotoBrowserHighlight} isRunningAnimation: ${this.isRunningAnimationHighlight}`);
  }

  @Builder
  MainPageMap(name: string, param: Object) {
    if (name === NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION) {
      MediaOperationBasePage()
    } else if (name === NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS) {
      GallerySettingsBasePage()
    } else if (name === NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION) {
      PickerBasePage()
    } else if (name === NavigationConstants.NAVIGATION_DESTINATION_PHOTO_GRID_VIEW) {
      PhotoGridBasePage()
    } else if (name === NavigationConstants.NAVIGATION_MOVIE_PAGE) {
      MoviePage()
    } else if (name === NavigationConstants.NAVIGATION_DESTINATION_EXTENDED_SERVICES) {
      ExtendedServicesPage()
    } else if (name === NavigationConstants.NAVIGATION_DESTINATION_STATEMENTS_CARDS) {
      StatementsCards()
    } else if (name === NavigationConstants.NAVIGATION_DESTINATION_SERVICE_AGREEMENTS_CARDS) {
      ServiceAgreementsCards()
    } else if (name === NavigationConstants.NAVIGATION_PICKER_BASE_PAGE) {
      this.pickerBasePageLoader({
        params: param as SelectParams,
        navPageInfos: this.navigationPageInfos,
      });
    }
  }

  // 通过当前当前页面名称
  private getCurrentNavigationPathName(): string {
    let currentNavigationPathName = this.navigationPageInfos.size() === 0 ? '' :
      this.navigationPageInfos.getAllPathName()[this.navigationPageInfos.size() - 1];
    return currentNavigationPathName;
  }

  aboutToAppear() {
    try {
      initPhotoBrowserController(this.browserController, 'TimelinePage', false);
      let routerParam = AppStorage.get<Router>('router')?.getParams() as PageParam;
      if (routerParam?.targetPage) {
        Log.info(TAG, `enter  from: ${routerParam.pageFrom}`);
        this.initTargetAlbumInfo(routerParam.pageFrom, routerParam.targetPage, routerParam?.albumLpathName, routerParam?.albumInfo);
        Log.info(TAG, 'initTargetAlbumInfo end');
      } else {
        let StorageParam: PageParam = LocalStorage.getShared()?.get<PageParam>('profileParameters') as PageParam;
        this.initTargetAlbumInfo(StorageParam.pageFrom, StorageParam.targetPage, StorageParam?.albumLpathName, StorageParam?.albumInfo);
        Log.info(TAG, 'initTargetAlbumInfo end');
      }
      this.navigationBroadCast.on(NavigationConstants.LOAD_PAGE, this.loadNavigationPageFun);
      Log.debug(TAG, `[aboutToAppear] param: ${JSON.stringify(routerParam)}`);
    } catch (e) {
      Log.error(TAG, `Router getParams error ${e}`);
    }
  }

  aboutToDisappear() {
    Log.info(TAG, '[aboutToDisappear]');
    this.navigationBroadCast.off(NavigationConstants.LOAD_PAGE, this.loadNavigationPageFun);
  }

  onPageShow() {
    Log.info(TAG, '[onPageShow]');
    LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.SHOW);
    setTimeout((): void => {
      this.isShow = true;
    }, Constants.TIMEOUT);
  }

  onPageHide(): void {
    Log.info(TAG, '[onPageHide]');
    LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.HIDE);
    setTimeout((): void => {
      this.isShow = false;
    }, Constants.TIMEOUT);
  }

  onBackPress(): boolean {
    Log.debug(TAG, '[onBackPress]');
    this.backPress = !this.backPress;

    if(this.isFromFormProfile){
      return true;
    }
    if (this.isShowPhotoBrowser || this.browserController.isBrowserShow) {
      this.browserController.onBackPress();
      this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, []);
      return true;
    } else {
      (getContext() as common.UIAbilityContext)?.terminateSelf().then(() => {
        Log.info(TAG, 'PhotoGridPage terminateSelfWithResult');
      });
      return false;
    }
  }

  pageTransition() {
    if (this.isFromFormProfile) {
      PageTransitionEnter({ type: RouteType.Push | RouteType.None | RouteType.Pop, duration: 0 })
        .opacity(1)
      PageTransitionExit({ type: RouteType.Push | RouteType.None | RouteType.Pop, duration: 0 })
        .opacity(1)
    }
  }

  build() {
    Navigation(this.navigationPageInfos) {
      Column() {
        if (this.isFinishInitAlbum) {
          PhotoGridBasePage({
            isFromFileManager: this.isFromFileManager,
            albumInfo: this.albumInfo,
            navParams: this.navParams,
          })
        }
      }
      .width('100%')
      .height('100%')
    }
    .navDestination(this.MainPageMap)
    .mode(NavigationMode.Stack)
    .hideTitleBar(this.isShowAlbumCoverSelectPage)
  }

  private async loadNavigationPage(name: string): Promise<void> {
    try {
      Log.info(TAG, `loadNavigationPage name: ${name}`);
      if (name === NavigationConstants.NAVIGATION_PICKER_BASE_PAGE) {
        let pageObj = await import('../../pickerability/view/PickerBasePage');
        this.pickerBasePageLoader = pageObj.PickerBasePageLoader;
      }
      Log.info(TAG, 'PhotoGridPage loadNavigationPage success.');
    } catch (error) {
      Log.error(TAG, `PhotoGridPage loadNavigationPage error: ${error}`);
    }
  }

  /**
   * 初始化目标相册信息
   *
   * @param targetPage 目标相册
   * @returns 返回对象
   */
  private async initTargetAlbumInfo(pageFrom: string, targetPage: string, albumLpathName?: string, albumInfo?: AlbumInfo): Promise<void> {
    if (pageFrom === Constants.WANT_PARAM_URI_FILE_MANAGER) {
      this.isFromFileManager = true;
    }
    let startTime: number = Date.now();
    Log.info(TAG, `initTargetAlbumInfo start album query: tagetPage = ${targetPage}`);
    if (targetPage === Constants.ENTER_VIDEO_PAGE_FROM_FILE_MANAGER) {
      UserFileManagerAccess.getInstance().getSystemAlbum(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE)
        .then((album: PhotoAlbum | undefined) => {
          if (album === undefined) {
            this.albumInfo = this.getEmptyAlbumInfo(targetPage);
          } else {
            this.albumInfo = new AlbumInfo(album);
          }
          this.callbackAfterDataFetched(this.albumInfo, startTime);
        });

    } else if (targetPage === Constants.ENTER_CAMERA_PAGE_FROM_FILE_MANAGER) {
      let lPath: string = this.sourceType.camera;
      this.getSourceAlbumByLPath(lPath)
        .then((albumInfo: AlbumInfo | undefined) => {
          if (albumInfo === undefined) {
            this.albumInfo = this.getEmptyAlbumInfo(targetPage);
          } else {
            this.albumInfo = albumInfo;
          }
          this.callbackAfterDataFetched(this.albumInfo, startTime);
        });
    } else if (targetPage === Constants.ENTER_HW_SHARE_PAGE_FROM_FILE_MANAGER) {
      let lPath: string = this.sourceType.share;
      this.getSourceAlbumByLPath(lPath)
        .then((albumInfo: AlbumInfo | undefined) => {
          if (albumInfo === undefined) {
            this.albumInfo = this.getEmptyAlbumInfo(targetPage);
          } else {
            this.albumInfo = albumInfo;
          }
          this.navParams = new ParamsWrapper();
          let targetDataSource: AlbumDataSource =
            new AlbumDataSource({
              context: getContext(),
              albumInfo: this.albumInfo
            });
          this.navParams.set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_DATASOURCE, targetDataSource);
          this.callbackAfterDataFetched(this.albumInfo, startTime);
        });
    } else if (targetPage === Constants.ENTER_USER_ALBUM_PAGE) {
      if (albumLpathName) {
        UserFileManagerAccess.getInstance().getUserAlbums(AlbumDefine.getAlbumFetchOptByName(albumLpathName))
          .then((album: PhotoAlbum[]) => {
            if (album === undefined || album.length === 0) {
              this.albumInfo = this.getEmptyAlbumInfo(targetPage, albumLpathName);
            } else {
              this.albumInfo = new AlbumInfo(album[0]);
            }
            this.callbackAfterDataFetched(this.albumInfo, startTime);
          });
      }
    } else if (targetPage === Constants.ENTER_PORTRAIT_ALBUM_GRID_PAGE) {
      this.isShowAlbumCoverSelectPage = true;
      if(!albumInfo){
        return;
      }
      this.isFromFileManager = false
      this.isFromFormProfile = true;

      this.callbackAfterDataFetched(albumInfo, startTime);
    }
  }

  onDidBuild(): void {
    Log.info(TAG, `onDidBuild`);
  }

  /**
   * 数据查询到后的处理结果
   *
   * @param albumInfo 相册数据对象
   * @param startTime 加载数据的开始时间
   */
  private callbackAfterDataFetched(albumInfo: AlbumInfo | undefined, startTime: number): void {
    if (albumInfo !== undefined) {
      this.albumInfo = albumInfo;
      let paramAlbumInfo: ParamAlbumInfo = { item: JSON.stringify(this.albumInfo) };
      AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, paramAlbumInfo);
      Log.info(TAG, 'initTargetAlbumInfo finish album update')
      this.isFinishInitAlbum = true;
    }
    Log.info(TAG, `initTargetAlbumInfo finish spend time: ${Date.now() - startTime}`);
  }

  /**
   * 根据相册名称查询相册信息
   *
   * @param lPath 相册lPath
   * @returns 相册信息
   */
  private async getSourceAlbumByLPath(lPath: string): Promise<AlbumInfo | undefined> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let albumFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('lpath', lPath);
      let fetchOption: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      albumFetchResult =
        await phAccessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE, Constants.SOURCE_QUERY_SUB_TYPE, fetchOption);
      let album: photoAccessHelper.Album = await albumFetchResult?.getFirstObject();
      return album ? new AlbumInfo(album) : undefined;
    } catch (error) {
      Log.error(TAG, `getSourceAlbumByName error: ${error}`);
    } finally {
      albumFetchResult?.close();
      phAccessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
    return undefined;
  }

  /**
   * 获取空的相册信息对象
   *
   * @param targetPage 跳转到的目标页面：视频、相机、分享
   * @returns 空的相册信息对象
   */
  private getEmptyAlbumInfo(targetPage: string, albumLpathName?: string): AlbumInfo {
    let albumInfo = new AlbumInfo();
    albumInfo.setCount(0);
    albumInfo.setVideoCount(0);
    if (targetPage === Constants.ENTER_VIDEO_PAGE_FROM_FILE_MANAGER) {
      albumInfo.setAlbumName($r('app.string.album_video'));
      albumInfo.isSystemAlbum = true;
      albumInfo.isVideoAlbum = true;
    } else if (targetPage === Constants.ENTER_CAMERA_PAGE_FROM_FILE_MANAGER) {
      albumInfo.setAlbumName($r('app.string.source_camera'));
      albumInfo.isSystemAlbum = false;
    } else if (targetPage === Constants.ENTER_HW_SHARE_PAGE_FROM_FILE_MANAGER) {
      albumInfo.setAlbumName('');
      albumInfo.isSystemAlbum = false;
    } else if (targetPage === Constants.ENTER_USER_ALBUM_PAGE) {
      if (albumLpathName) {
        albumInfo.setAlbumName(albumLpathName);
      }
      albumInfo.isSystemAlbum = true;
    }
    albumInfo.setFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
    return albumInfo;
  }
}