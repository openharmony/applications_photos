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

import lazy { photoAccessHelper } from "@kit.MediaLibraryKit";
import lazy { PhotoAsset } from "../../../view/dialog/MoveDialog";
import lazy { dataSharePredicates } from "@kit.ArkData";
import lazy { Log } from "@ohos/tools/src/main/utils/Log";
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { PreferencesUtil } from "../../../utils/PreferencesUtil";
import lazy { JSON, taskpool } from "@kit.ArkTS";
import lazy { ReportToBigDataUtil, BigDataConstants, AlbumBrowsingInfo } from '../../../utils/ReportToBigDataUtil';
import lazy { common } from "@kit.AbilityKit";
import lazy { PhotoAlbum } from "../../../utils/PhotoBrowserUtils";
import lazy { CommonContext } from "../photo/TimelineDataManager";
import lazy { AlbumInfo } from "./AlbumInfo";
import lazy { PhotoAccessHelperAccess } from "../../../access/PhotoAccessHelperAccess";
import lazy {
  FetchOptions,
  SendablePhotoAccessHelper,
  SendablePhotoAlbum,
  SendablePhotoAsset
} from '../../../access/SendablePhotoAccessHelper';
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';
import lazy { FetchOptionBuilder } from '../../../model/FetchOption';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { Constants } from '../../../model/common/Constants';


/* instrument ignore next */
const TAG: string = 'ReportAlbumDataUtil';
type commonContext = common.UIAbilityContext | common.ServiceExtensionContext;

export class AlbumBigDataConstants {
  // 上报点位
  public static readonly ALBUM_CONTENT_REPORT: string = 'ALBUM_CONTENT_REPORT';
  // 相册事件
  // album operation event
  public static readonly ENTER_SYSTEM_ALBUM: string = 'enterSystemAlbum';
  public static readonly ENTER_USER_ALBUM: string = 'enterUserAlbum';
  public static readonly ENTER_SOURCE_ALBUM: string = 'enterSourceAlbum';
  public static readonly ENTER_HIDDEN_ALBUM: string = 'enterHiddenAlbum';
  public static readonly ENTER_CATEGORY_ALBUM: string = 'enterCategoryAlbum';
  public static readonly ENTER_SHOOTING_MODE_ALBUM: string = 'enterShootingModeAlbum';
  public static readonly ENTER_MAP_ALBUM: string = 'enterMapAlbum';
  public static readonly ENTER_PORTRAIT_ALBUM: string = 'enterPortraitAlbum';
  public static readonly ENTER_ALBUM_TAB: string = 'ENTER_ALBUM_TAB';
  // 截屏
  public static readonly SCREEN_SHOTS_ALBUM = 1029;
  // 录屏
  public static readonly SCREEN_RECORDING: number = 10290;
  // 相机
  public static readonly CAMERA_ALBUM = 1030;
  // 隐藏子相册
  public static readonly HIDDEN_ALBUM_SUB_ALBUMS = 10270;
  // 城市相册
  public static readonly CITY_ALBUM: number = 4100;
  // 城市相册
  public static readonly CITY_SUB_ALBUM: number = 41000;
  // 地图聚合相册
  public static readonly LOCATION_QUERY_SUB_TYPE: number = 4099;
  // 进入相册时间
  public static readonly ENTER_ALBUM_TAB_TIME: string = 'enter_album_time';
  // 一周时间
  public static readonly ONE_WEEK: number = 7 * 24 * 60 * 60 * 1000;

  public static readonly CLASSIFIED_SUB_ALBUM: number = 40970;
}

@Concurrent
async function getFrontCameraCount(context: common.UIAbilityContext): Promise<number> {
  let helper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

  if (!helper) {
    Log.warn('ReportAlbumDataUtil', 'photoAccessHelper undefined');
    return 0;
  }

  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();

  predicates.equalTo('front_camera', '1');
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates,
  };
  let frontCameraNumber: number = 0;
  let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
  try {
    fetchResult = await helper.getAssets(fetchOptions);
    if (fetchResult === undefined) {
      Log.error('ReportAlbumDataUtil', 'fetchResult is undefined');
      return 0;
    }
    frontCameraNumber = await fetchResult.getCount();
    Log.debug('ReportAlbumDataUtil', `get data finished fontCameraNumber ${frontCameraNumber}`);
  } catch (err) {
    Log.error('ReportAlbumDataUtil', `queryDemo failed with error: ${err.code}, ${err.message}`);
  } finally {
    fetchResult?.close();
    helper?.release();
  }
  return frontCameraNumber;
}

export async function albumReportToBigData(context: common.Context): Promise<void> {
  const currentTime: number = new Date().getTime();
  let isReport: boolean = await PreferencesUtil.has(AlbumBigDataConstants.ENTER_ALBUM_TAB_TIME);
  Log.debug(TAG, `reportToBigData status ${isReport} current time ${currentTime}`);

  if (isReport) {
    const lastTime: number = Number(PreferencesUtil.getSync(AlbumBigDataConstants.ENTER_ALBUM_TAB_TIME, 0));
    Log.debug(TAG, `reportToBigData current time ${currentTime} last time ${lastTime}`);

    if (currentTime - lastTime > AlbumBigDataConstants.ONE_WEEK) {
      await reportAlbumDataToBigData(context);
      PreferencesUtil.put(AlbumBigDataConstants.ENTER_ALBUM_TAB_TIME, currentTime);
    }
  } else {
    Log.info(TAG, `first report to bigData msg`);
    PreferencesUtil.put(AlbumBigDataConstants.ENTER_ALBUM_TAB_TIME, currentTime);
    await reportAlbumDataToBigData(context);
  }
  return;
}

async function reportAlbumDataToBigData(context: Context) {
  let frontCamera: number = 0;
  try {
    frontCamera = Number(await taskpool.execute(getFrontCameraCount, context));
  } catch (e) {
    Log.error(TAG, `get photo frontCamera and shootingMode taskpool error: ${e}`);
  }
  const msg: Record<string, number | string> = {
    'SELFIE_COUNT': frontCamera,
  };
  ReportToBigDataUtil.report(AlbumBigDataConstants.ENTER_ALBUM_TAB, msg);
}

@Concurrent
export async function getCityAlbums(context: common.Context): Promise<number> {
  if (!context) {
    return 0;
  }
  let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
  let fetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
  try {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let language = Constants.CHINESE_LANGUAGE;
    predicates.equalTo('language', language);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates,
    };
    Log.debug('ReportAlbumDataUtil', 'get city album start');
    accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    fetchResult =
      await accessHelper.getAlbums(photoAccessHelper.AlbumType.SMART, Constants.CITY_QUERY_SUB_TYPE, fetchOptions);
    const cityAlbumCount: number = await fetchResult.getCount();
    Log.debug('ReportAlbumDataUtil', `getCityAlbum : ${cityAlbumCount}`);
    return cityAlbumCount;
  } catch (err) {
    Log.error('ReportAlbumDataUtil', `getCityAlbum Get City Album exception! msg:  ${err}, code: ${err?.code}`);
    return 0;
  } finally {
    fetchResult?.close();
    accessHelper?.release();
    Log.info('ReportAlbumDataUtil', `fetchResult is close.`);
  }
}

export async function cityAlbumsReportToBigData(context: common.Context): Promise<void> {
  let cityAlbumCount: number = 0;
  try {
    cityAlbumCount = Number(await taskpool.execute(getCityAlbums, context));
  } catch (e) {
    Log.error(TAG, `get city albums taskpool error: ${e}`);
  }
  Log.info(TAG, `get city albums count ${cityAlbumCount}`);
  const content: Record<string, number> = {
    'subAlbumCount': cityAlbumCount,
    'imageCount': 0,
    'videoCount': 0
  };
  const msg: Record<string, number | string> = {
    'albumEvent': AlbumBigDataConstants.ENTER_MAP_ALBUM,
    'albumType': AlbumBigDataConstants.CITY_ALBUM,
    'content': JSON.stringify(content)
  };
  AlbumBrowsingInfo.albumSubtype = AlbumBigDataConstants.CITY_ALBUM;
  ReportToBigDataUtil.report(AlbumBigDataConstants.ALBUM_CONTENT_REPORT, msg);
}