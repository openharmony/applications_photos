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

/* instrument ignore file */

import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { BroadCast } from './BroadCast';
import lazy { Log } from './Log';
import lazy { window } from '@kit.ArkUI';
import lazy { WindowUtil } from './WindowUtil';
import lazy { sensor } from '@kit.SensorServiceKit';
import lazy { ActionBarProp } from '../view/browserOperation/ActionBarProp';
import lazy { ActionBarColorMode, ActionBarMode } from '../view/browserOperation/ActionBarMode';
import lazy { Action } from '../view/browserOperation/Action';
import lazy { Constants as PhotoConstants } from '../model/browser/photo/Constants';
import lazy { ability, AbilityConstant, common } from '@kit.AbilityKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from './ReportToBigDataUtil';
import lazy { MsgDownloadFinish } from '../model/common/BigDataDotting';
import lazy { ViewData } from '../model/browser/photo/ViewData';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { avSession } from '@kit.AVSessionKit';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { AlbumGridSortHelper } from '../model/AlbumGridSortHelper';
import { PhotoDataSource } from '../model/browser/photo/PhotoDataSource';

const TAG: string = 'common_PhotoBrowserUtils';

export type PhotoAlbum = photoAccessHelper.Album;

export interface Params {
  albumName: string;
  albumUri: string;
  pageType: string;
}

export interface ImageArea {
  width: number;
  height: number;
}

export interface ParamBrowser {
  transition: string;
  position: number;
  pageFrom: number;
  deviceName: string;
  albumInfo: AlbumInfo;
  clickThumbnailTime: number;
  albumUri: string;
  uri: string;
  viewData: ViewData;
  isAllMediaData: boolean;
  viewDataIndex: string;
  viewDataAlbum: string;
  viewDataType: number;
  isShowMenuFromThirdView: boolean;
  deviceId: string;
  cameraShotKey: String;
  imageArea: ImageArea;
  album: PhotoAlbum;
  broadCast?: BroadCast;
  isLoadLCD: boolean;
  coverPhotoUri?: string;
  sortHelper?: AlbumGridSortHelper;
}

export interface EnterInfoFace {
  behavior?: number,
  count: number,
}

export interface TitleName {
  title: string;
  displayName: string;
}

export class AirShareOneResourceMsg {
  public isRemoteResource: boolean;
  public isDownload: boolean;
  public downloadFailedReason: string;
  constructor(isRemoteResource: boolean, isDownload: boolean = false, downloadFailedReason: string = '') {
    this.isRemoteResource = isRemoteResource;
    this.isDownload = isDownload;
    this.downloadFailedReason = downloadFailedReason;
  }
}

export class PhotoBrowserUtils {
  private static appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  public static getCurrentPhoto(dataSource: PhotoDataSource | undefined, currentIndex: number):
  MediaItem | undefined {
    return (dataSource?.getRawData(currentIndex ?? -1).data);
  }

  public static setOrientationAuto(): void {
    Log.info(TAG, 'set orientation auto.');
    setTimeout((): void => {
      WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    }, PhotoConstants.DELAY_FOR_SET_AUTO_ROTATE_SCREEN);
  }

  public static offSensorOrientation(rotateChangeCount: number): void {
    try {
      // 取消注册SensorId.ORIENTATION的所有回调
      sensor.off(sensor.SensorId.ORIENTATION);
      rotateChangeCount = 0;
    } catch (err) {
      Log.error(TAG, `orientation sensor off fail, errCode: ${err.code}, msg: ${err.message}`);
    }
  }

  public static createActionBar(): ActionBarProp {
    let menuPortraitList: Action[] = [];
    menuPortraitList.push(Action.OK);
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle($r('app.string.portrait_select_cover'))
      .setMenuList(menuPortraitList)
      .setHasTabBar(false)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setColorMode(ActionBarColorMode.TRANSPARENT)
    return actionBarProp;
  }

  public static setViewDataResult(result: boolean, isFromViewDataWithMediaUri: boolean,
    isFromViewDataWithThirdUri: boolean): void {
    if (!isFromViewDataWithMediaUri && !isFromViewDataWithThirdUri) {
      return;
    }

    let resultCode = 0;
    if (result === false) {
      resultCode = -1;
    }

    let abilityResult: ability.AbilityResult = {
      resultCode: resultCode,
      want: {},
    };

    global.terminateSelfWithResult(TAG, 'setViewDataResult', abilityResult);
  }

  public static async onDownloadOriginPhoto(downloadScene: string, item: MediaItem | undefined): Promise<void> {
    if (!item) {
      Log.error(TAG, 'download photo failed, item is null');
    }
    let isRemoteResource: boolean = false;
    if (!isRemoteResource) {
      return;
    }
    let downloadOriginResult = 'start';
    PhotoBrowserUtils.appBroadCast.emit(
      BroadCastConstants.DOWNLOAD_ORIGIN_PHOTO_RESULT + item?.uri,
      [downloadOriginResult]
    );
    // 图片下载完毕的回调
    let startTime: number;
    let downloadFinishCallback: Function = (err: string = '') => {
      ReportToBigDataUtil.downloadOriginReport(downloadScene, Date.now() - startTime, err);
      if (err) {
        return;
      }
      Log.info(TAG, `downloadFinishCallback photo: ${item?.uri}`);
      // 下载完成打点
      let msg: MsgDownloadFinish = {
        scene: downloadScene,
        network: AppStorage.get<boolean>('networkAvailable') ? BigDataConstants.NETWORK_AVAILABLE :
        BigDataConstants.NETWORK_UNAVAILABLE,
        size: item?.size ?? Number.NaN,
        timeCost: Date.now() - startTime,
      }
      ReportToBigDataUtil.report(BigDataConstants.DOWNLOAD_ORIGIN_PHOTO_ID, msg);
    }
    startTime = Date.now();
  }
}