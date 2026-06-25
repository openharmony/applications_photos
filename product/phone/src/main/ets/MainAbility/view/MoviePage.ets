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

import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy {
  PhotoAccessHelperAccess,
  PhotoAsset
} from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy window from '@ohos.window';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { TimelineDataSourceManager } from '@ohos/timeline/src/main/ets/model/TimelineDataSourceManager';
import lazy { display, Router } from '@kit.ArkUI';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { MenuConstants, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { MovieActionRegister, MovieListener } from '@ohos/common/src/main/ets/default/view/actionbar/MovieAction';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy {
  VideoSplicingActionRegister,
  VideoSplicingListener
} from '@ohos/common/src/main/ets/default/view/actionbar/VideoSplicingAction';
import lazy { AlbumInfo } from '../../../../../../../common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { MoviePageConstants } from '@ohos/common/src/main/ets/default/utils/MoviePageConstants';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import { common } from '@kit.AbilityKit';
import lazy { PermissionPopup } from '@ohos/privacy/src/main/ets/about/consent/PermissionPopup';

/* instrument ignore file */
const TAG: string = 'MoviePage';
const MEDIA_TYPE_LIVE: string = 'LIVE_PHOTO';

@Builder
export function MoviePageLoader() {
  MoviePage();
}

export interface MoviePageLoaderParams {
  navPageInfos: NavPathStack;
}

export enum EntryType {
  // 无
  NONE = 0,
  // 【待适配】图库大图入口
  PHOTO_BROWSER,
  // 【待适配】相机大图入口（UIExtensionAbility通路）
  CAMERA_BROWSER,
  // 【待适配】picker入口
  PICKER_BROWSER,
  // 图库创作入口
  PHOTO_CREATE
}


export enum FetchType {
  NORMAL,
  EMPTY,
  DATE_INFO,
}

class DownloadInfo {
  batchDownloadProcess: Map<string, number> = new Map<string, number>();
  fileCount: number = 0;
  successCount: number = 0;
}
@Entry
@Component
export struct MoviePage {
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  public deviceName: string = '';
  public dataSource: MediaDataSource = TimelineDataSourceManager.getInstance().getDataSource();
  // 横竖屏
  @StorageLink('isHorizontal') @Watch('isHorizontalChange') isHorizontal: boolean = isOrientationHorizontal();
  // 监听是否为xxx
  @State private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  // 摄像头距离屏幕边距
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State paddingTop: Length = 39;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  private statusBarChangeTimer = 0;
  private onWinSizeChangedFunc: Function = (): void => this.onWinSizeChanged();
  // private editorController: EditorController | undefined = undefined;
  @State isReady: boolean = false;
  controller: SwiperController = new SwiperController();
  private appBroadCast: BroadCast | undefined = BroadCastManager.getInstance().getBroadCast();
  private geometryTransitionString: string = '';
  @State mediaItem: MediaItem | undefined = undefined;
  private broadCast: BroadCast = new BroadCast();
  private jumpBrowserInterval: number = 0;
  private featureType = false;
  private albumUri: string | undefined = undefined;
  private subType: number = Number.NaN;
  private navigationPageInfos: NavPathStack = new NavPathStack();
  private params: ParamsWrapper | undefined = undefined;
  private hasShowDownloadFailToast: boolean = false;
  private isSearchResultPage: boolean = false;

  aboutToAppear(): void {
    Log.info(TAG, 'movie aboutToAppear begin');
    this.isHorizontalChange();
    // this.editorController = new EditorController();
    // this.editorController?.init(this.broadCast);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  onPageShow(): void {
    Log.info(TAG, 'Collage onPageShow begin');
    this.statusBarChangeTimer = setTimeout((): void => {
      getScreen().setImmersiveStatusBarProperties(Constants.COLOR_TRANSPARENT);
    }, Constants.ENTER_TO_COMPARE_PAGE_TIME)
  }

  onPageHide(): void {
    clearTimeout(this.statusBarChangeTimer);
    getScreen().setDefaultStatusBarProperties();
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear`);
    clearInterval(this.jumpBrowserInterval);
    this.isReady = false;
    // this.editorController?.release();
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
  }

  private onWinSizeChanged(): void {
    this.isFoldExpanded = DeviceInfo.isFoldable();
  }

  isHorizontalChange(): void {
    this.paddingTop = 39;
  }

  private onShown(): void {
    Log.info(TAG, 'onShown');
    setTimeout((): void => {
      getScreen().setImmersiveStatusBarProperties(Constants.COLOR_TRANSPARENT);
    }, Constants.ENTER_TO_COLLAGE_PAGE_TIME)
  }

  private onHidden(): void {
    Log.info(TAG, 'onHidden');
    getScreen().setDefaultStatusBarProperties();
    WindowUtil.resumeWindowSystemBarProperties();
  }

  private onBackPressed(): boolean {
    return true
  }

  private async getSaveVideoUri(saveVideoUri: string): Promise<void> {
    let result = await UserFileManagerAccess.getInstance()
      .getFirstObject(AlbumDefine.getFileFetchOptByUri(saveVideoUri), TAG);
    // this.mediaItem = new MediaItem(result.obj as PhotoAsset, FetchType.NORMAL);
  }

  onBackPress() {
    Log.info(TAG, 'onBackPress');
    // if (!this.editorController) {
    //   Log.info(TAG, 'editorController is empty');
    //   return false;
    // }
    return false;
  }


  // progress 100, percentage 1
  private updateBatchDownloadProgress(uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, downloadInfo: DownloadInfo | undefined): void {
    if (process === -1) { // download failed
      if (!this.hasShowDownloadFailToast) {
        Log.info(TAG, `hasShowDownloadFailToast`)
        UiUtil.showToast($r('app.string.download_failed')); // toast提示 '下载失败'
        this.hasShowDownloadFailToast = true;
      }

      failCb();
      return;
    }

    if (!downloadInfo) {
      return;
    }
    if (!downloadInfo.batchDownloadProcess.has(uri)) {
      return;
    }
    if (downloadInfo.batchDownloadProcess.get(uri) === 0 && percentage === 1) {
      downloadInfo.batchDownloadProcess.set(uri, percentage);
      downloadInfo.successCount++;

      let pg = Constants.DOWNLOAD_FINISH_PERCENTAGE * downloadInfo.successCount / downloadInfo.fileCount;
      AppStorage.setOrCreate<number>(Constants.APP_STORAGE_KEY_EDITOR_DOWNLOAD_PROGRESS, pg);
      Log.info(TAG, `batchDownloadProcess  AppStorage ${pg}`);
      if (pg === Constants.DOWNLOAD_FINISH_PERCENTAGE) {
        downloadInfo.batchDownloadProcess.clear();
        downloadInfo.successCount = 0;
        successCb?.();
      }
    }
  }

  public async jumpToPhotoBrowser(saveVideoUri: string, id: string) {
    this.jumpBrowserInterval = setInterval((): void => {
      this.getSaveVideoUri(saveVideoUri)
      if (this.mediaItem) {
        clearInterval(this.jumpBrowserInterval);
        let targetIndex = this.dataSource?.getDataIndex(this.mediaItem);
        if (this.featureType) {
          this.params?.get<MovieListener>(MovieActionRegister.LISTENER)?.onOperationEnd?.();
        } else {
          this.params?.get<VideoSplicingListener>(VideoSplicingActionRegister.LISTENER)?.onOperationEnd?.();
        }
        //保存跳转
        AppStorage.setOrCreate<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
          AppStorage.get<Router>('router')?.pushUrl({
            url: 'MainAbility/view/PhotoBrowser',
            params: {
              pageFrom: Constants.ENTRY_FROM.ENTRY_FROM_MOVIE_PAGE,
              //位置
              position: targetIndex >= 0 ? targetIndex : 0,
              uri: this.mediaItem.uri,
              transition: Constants.PHOTO_TRANSITION_TIMELINE,
              leftBlank: this.leftBlank,
            }
          }, () => {
            setTimeout((): void => {
              if (id === 'exit') {
                Log.info(TAG, 'Jump to large image and exit editing');
                this.navigationPageInfos.pop();
                AppStorage.setOrCreate<boolean>(Constants.APP_STORAGE_KEY_CLOUD_DOWNLOAD_FINISH_STATUS, false);
              }
            }, Constants.EXIT_MOVIE_JUMP_BROWSER_TIME)
          });
      }
    }, 200)
  }
  build() {
    NavDestination() {
    }
    .hideTitleBar(true)
    // .onReady((ctx: NavDestinationContext) => {
    //   this.params = ctx?.pathInfo?.param as ParamsWrapper;
    //   let mediaItem: MediaItem[] = this.params.get<MediaItem[]>(MoviePageConstants.KEY_MOVIE_PAGE_LIST)
    //   this.navigationPageInfos = ctx.pathStack;
    //   this.broadCast = this.params.get(MoviePageConstants.KEY_BROAD_CAST);
    //   this.featureType = this.params.get<boolean>(MoviePageConstants.KEY_FEATURE_TYPE);
    //   this.albumUri = this.params.get<string>(MoviePageConstants.KEY_ALBUM_URI);
    //   this.subType = this.params.get<number>(MoviePageConstants.KEY_AlBUM_SUBTYPE);
    //   this.isReady = true;
    //   this.isSearchResultPage = this.params.get<boolean>(MoviePageConstants.KEY_SEARCH_RESULT_PAGE);
    //   let downloadList = this.params.get<Map<string, string>>(MoviePageConstants.KEY_LAST_DOWNLOAD_LIST);
    //   this.editorController?.jumpEditor(this.albumUri, mediaItem,
    //     EntryType.PHOTO_CREATE, this.featureType, downloadList);
    // })
    .onShown(() => this.onShown())
    .onHidden(() => this.onHidden())
    .onBackPressed(() => this.onBackPress());
  }
}
