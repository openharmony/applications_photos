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

import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '../../utils/Log';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionModel, ActionViewModel, MenuConstants, ParamsWrapper, OperationListener } from './Menu';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { NavigationConstants } from '../../model/common/NavigationConstants';
import lazy { MoviePageConstants } from '../../utils/MoviePageConstants';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Constants } from '../../model/common/Constants';
import lazy { PhotoAsset } from '../../access/PhotoAccessHelperAccess';

/* instrument ignore file */
const TAG: string = 'common_VideoSplicingAction';
const VIDEO_SPLICING_TEXT:string='制作视频';

export interface VideoSplicingListener extends OperationListener {
  jumpToBrowser?: (item: MediaItem) => void;
}

export enum FeatureType {
  FEATURE_PHOTO_CREATE, // 图库创作视频拼接特性
  FEATURE_PHOTO_AUTO_CLIP // 图库创作一键成片特性
}

export const COMPONENT_KEY_VIDEO_SPLICING: string = 'VideoSplicing';

export const VIDEO_SPLICING: Action = new Action({
  id: Action.uuid,
  iconRes: $r('app.media.video_splicing'),
  textRes: $r('app.string.action_video_splicing'),
  componentKey: COMPONENT_KEY_VIDEO_SPLICING,
});

export const COMPONENT_KEY_VIDEO_SPLICING_INVALID: string = 'VideoSplicing';

export const VIDEO_SPLICING_INVALID: Action = new Action({
  id: Action.uuid,
  iconRes: $r('app.media.video_splicing'),
  textRes: $r('app.string.action_video_splicing'),
  componentKey: COMPONENT_KEY_VIDEO_SPLICING_INVALID,
  isInvalid: true,
});

/**
 * 影片按钮属性
 */
@Observed
export class VideoSplicingActionProp extends DefaultActionButtonProp {
  public action = VIDEO_SPLICING;
  public icon = $r('app.media.video_splicing');
  public text = $r('app.string.action_video_splicing');
  public key = 'ActionButton_VideoSplicing';
}


/**
 * 视频拼接Action注册类
 */
export class VideoSplicingActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.videoSplicing_listener';

  public getActions(): Action[] {
    return [VIDEO_SPLICING];
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    if (!params) {
      return undefined;
    }
    return {
      produce: () => {
        let listener: OperationListener | undefined =
          params.get<OperationListener>(VideoSplicingActionRegister.LISTENER);
        let menuContext: MenuContext = new MenuContext();
        menuContext.withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .set(MenuConstants.KEY_NAV_PATH_STACK, params.get(MenuConstants.KEY_NAV_PATH_STACK))
          .set(MenuConstants.KEY_SELECTION_MANAGER, params.get(MenuConstants.KEY_SELECTION_MANAGER))
          .set(MenuConstants.KEY_ALBUM_INFO, params.get(MenuConstants.KEY_ALBUM_INFO))
          .withAlbumUri(params.get<string>(MenuConstants.KEY_ALBUM_URI))
          .set(MenuConstants.KEY_NAVIGATION_BROADCAST, params.get(MenuConstants.KEY_NAVIGATION_BROADCAST))
          .set(VideoSplicingActionRegister.LISTENER, params.get(VideoSplicingActionRegister.LISTENER))
          .set(MoviePageConstants.KEY_SEARCH_RESULT_PAGE, params.get(MoviePageConstants.KEY_SEARCH_RESULT_PAGE))
        return menuContext;
      }
    };

  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    if (!params) {
      return undefined;
    }
    return new VideoSplicingActionViewModel(params);
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new VideoSplicingActionProp();
  }
}

/**
 * 视频拼接VM层
 */
export class VideoSplicingActionViewModel implements ActionViewModel {
  private navigationPageInfos: NavPathStack;
  private manager: SelectManager;
  private broadcast: BroadCast;
  private navBroadcast: BroadCast;
  private lastDownloadList: Map<string, string> = new Map();

  public constructor(params: ParamsWrapper) {
    this.manager = params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER);
    this.broadcast = params.get<BroadCast>(MenuConstants.KEY_BROADCAST);
    ;
    this.navBroadcast = params.get(MenuConstants.KEY_NAVIGATION_BROADCAST);
    this.navigationPageInfos = params?.get<NavPathStack>(MenuConstants.KEY_NAV_PATH_STACK) as NavPathStack;
  }

  doAction(menuContext?: MenuContext) {
    Log.info(TAG, 'doAction');
    if (!menuContext) {
      Log.info(TAG, 'not menuContext');
      return;
    }
    if (!this.manager) {
      Log.error(TAG, 'invalid selectManager');
      return;
    }
    let count = this.manager.getSelectedCount();
    if (count <= MoviePageConstants.DEFAULT_MIN_SELECT_COUNT) {
      Log.error(TAG, 'count <= 0, return');
      return;
    } else if (count > MoviePageConstants.DEFAULT_MAX_VIDEO_SPLICING_COUNT) {
      UiUtil.showToast($r('app.string.exceeding_the_limit_message'),
        MoviePageConstants.DEFAULT_MAX_VIDEO_SPLICING_COUNT);
      return;
    }

    this.manager.getSelectedItems((items: MediaItem[]) => {
      Log.info(TAG, 'getSelectedItem callback');
      let photoList: MediaItem[] = [...items];
      if (AppStorage.get<boolean>(Constants.APP_STORAGE_KEY_CLOUD_DOWNLOAD_FINISH_STATUS)) {
        let downloadFinishList: PhotoAsset[] | undefined =
          AppStorage.get<PhotoAsset[]>(Constants.APP_STORAGE_KEY_CLOUD_DOWNLOAD_FINISH_LIST);
        if (downloadFinishList) {
          downloadFinishList.forEach((item, index) => {
            this.lastDownloadList.set(item.uri, item.uri)
          })
        }
      } else {
        this.lastDownloadList.clear();
      }
      let filterAssets = MoviePageConstants.jumpMovieFilter(photoList);
      if (filterAssets.length === 0) {
        UiUtil.showToast($r('app.string.file_can_not_edited'),
          MoviePageConstants.DEFAULT_MAX_VIDEO_SPLICING_COUNT);
        return;
      }
      this.jumpMoviePage(menuContext, photoList);
    })
  }

  private jumpMoviePage(menuContext: MenuContext, photoList: MediaItem[]): void {
    // for (let i = 0; i < photoList.length; i++) {
    //   if (photoList[i].getPosition?.() === photoAccessHelper.PositionType.CLOUD) {
    //     let networkConnectionStatus: boolean = AppStorage.get('networkConnectionStatus') ?? false;
    //     let networkAvailable: boolean =
    //       AppStorage.get<boolean>(Constants.APP_STORAGE_KEY_OF_NETWORK_AVAILABLE) ?? false;
    //     Log.info(TAG, `set movie is cloud need download--${networkConnectionStatus}-${networkAvailable}`);
    //     if (!networkAvailable || !networkConnectionStatus) {
    //       // 网络不可用，提示无法下载
    //       UiUtil.showToast($r('app.string.no_network'));
    //       return;
    //     }
    //   }
    // }
    let params: ParamsWrapper =
      new ParamsWrapper()
        .set(MoviePageConstants.KEY_MOVIE_PAGE_LIST, photoList)
        .set(MoviePageConstants.KEY_ALBUM_URI, menuContext.get<string>(MenuConstants.KEY_ALBUM_URI))
        .set(VideoSplicingActionRegister.LISTENER,
          menuContext.get<VideoSplicingListener>(VideoSplicingActionRegister.LISTENER))
        .set(MoviePageConstants.KEY_BROAD_CAST, menuContext.broadCast)
        .set(MoviePageConstants.KEY_FEATURE_TYPE, FeatureType.FEATURE_PHOTO_CREATE)
        .set(MoviePageConstants.KEY_AlBUM_SUBTYPE, menuContext.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO)?.subType)
        .set(MoviePageConstants.KEY_SEARCH_RESULT_PAGE,
          menuContext.get<boolean>(MoviePageConstants.KEY_SEARCH_RESULT_PAGE))
        .set(MoviePageConstants.KEY_LAST_DOWNLOAD_LIST, this.lastDownloadList)
    //跳转路由
    this.navBroadcast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_MOVIE_PAGE]).then(() => {
      this.navigationPageInfos.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_MOVIE_PAGE, params));
    });
  }
}
