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
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy rpc from '@ohos.rpc';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { FileFetchOptionBuilder } from '@ohos/common/src/main/ets/default/model/FetchOption';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { common } from '@kit.AbilityKit';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';

/* instrument ignore file */
const TAG: string = 'CommonRecentPhotoServiceStub';

export class CommonRecentPhotoInfoUtil {
  private needAppendAnd: boolean = false;

  public async queryRecentPhoto(wantParam: Record<string, Object>): Promise<MediaItem | undefined> {
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();

      // 根据PhotoSource过滤
      let photoSource: number = wantParam?.photoSource as number ?? 0;
      this.addFilterByPhotoSource(photoSource, predicates);

      // 根据MediaType过滤
      let filterMediaType: string = wantParam?.filterMediaType as string;

      // 根据时间段过滤, 最长一天(24*3600秒)
      let period: number = wantParam?.period as number ?? Constants.RECENT_PHOTO_PERIOD_MAX_VALUE;
      if (period <= 0 || period > Constants.RECENT_PHOTO_PERIOD_MAX_VALUE) {
        period = Constants.RECENT_PHOTO_PERIOD_MAX_VALUE;
      }
      let isAutoRefreshSupported = wantParam?.isAutoRefreshSupported as boolean;
      if (!isAutoRefreshSupported) {
        this.addFilterByPeriod(period, predicates);
      }

      // 降序，查询数量1
      predicates.orderByDesc(photoAccessHelper.PhotoKeys.DATE_ADDED).limit(1, 0);
      let fetchOption: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [photoAccessHelper.PhotoKeys.DATE_ADDED, photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS,
          photoAccessHelper.PhotoKeys.DURATION, photoAccessHelper.PhotoKeys.TITLE,
          photoAccessHelper.PhotoKeys.DATE_TAKEN, photoAccessHelper.PhotoKeys.WIDTH,
          photoAccessHelper.PhotoKeys.HEIGHT, photoAccessHelper.PhotoKeys.SIZE,
          UserFileManagerAccess.FETCH_COLUMNS_MIME_TYPE]
      };

      let builder = new FileFetchOptionBuilder(fetchOption);
      AlbumDefine.setFilterMediaType(builder, filterMediaType);
      fetchOption = builder.build();

      let photoAsset: PhotoAsset | undefined = await UserFileManagerAccess.getInstance().getObject(fetchOption);
      return photoAsset ? new MediaItem(photoAsset) : undefined;
    } catch (error) {
      Log.info(TAG, `queryRecentPhoto process has error, ${error}`);
      return undefined;
    }
  }

  private addFilterByPeriod(period: number, predicates: dataSharePredicates.DataSharePredicates) {
    if (period > 0) {
      let stopTime: number = Date.now() - period * 1000;
      this.appendAnd(predicates);
      predicates.greaterThan(photoAccessHelper.PhotoKeys.DATE_ADDED, stopTime / 1000);
    }
  }

  private addFilterByPhotoSource(photoSource: number, predicates: dataSharePredicates.DataSharePredicates): void {
    if (photoSource == 1) {
      predicates.equalTo('package_name', '相机');
      this.needAppendAnd = true;
    } else if (photoSource == 2) {
      predicates.in('package_name', ['截图', '屏幕录制']);
      this.needAppendAnd = true;
    } else {
      Log.info(TAG, 'photoSource is All');
    }
  }

  private appendAnd(predicates: dataSharePredicates.DataSharePredicates): void {
    if (this.needAppendAnd) {
      predicates.and();
    }
  }
}


export default class CommonRecentPhotoServiceStub extends rpc.RemoteObject {
  private context: common.ServiceExtensionContext;
  private static readonly COMMAND_GET_RECENT_PHOTO_INFO = 1;

  public constructor(descriptor: string, context: common.ServiceExtensionContext) {
    super(descriptor);
    this.context = context;
    context.connectServiceExtensionAbility
  }

  // 处理客户端请求
  public async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): Promise<boolean> {
    Log.info(TAG, `rpcServer: onRemoteMessageRequest code: ${code}`);
    if (this.getDescriptor() !== data.readInterfaceToken()) {
      Log.error(TAG, `rpcServer error: descriptor is illegal: ${this.getDescriptor()}`);
      return false;
    }
    if (code !== CommonRecentPhotoServiceStub.COMMAND_GET_RECENT_PHOTO_INFO) {
      return false;
    }

    const period: number = data.readInt();
    const filterMediaType: string = data.readString();
    const photoSource: number = data.readInt();
    Log.info(TAG, `request data: period: ${period}, mimeType: ${filterMediaType}, photoSource: ${photoSource}`);
    let queryUtil: CommonRecentPhotoInfoUtil = new CommonRecentPhotoInfoUtil();
    let queryParam: Record<string, Object> = {
      'period': period,
      'filterMediaType': filterMediaType,
      'photoSource': photoSource
    }
    UserFileManagerAccess.getInstance().onCreate(this.context);
    let result: MediaItem | undefined = await queryUtil.queryRecentPhoto(queryParam);
    if (result === undefined) {
      reply.writeLong(0);
      reply.writeString('0');
      return true;
    }
    const dateTaken: number = result.getDateTaken();
    const identifier: string = PickerUtil.getHash(result.getTitle());
    const offsetMsg: Record<string, number | string | boolean> = {
      'RECENT_PHOTOINFO_RESULT': dateTaken > 0,
    };
    ReportToBigDataUtil.report(BigDataConstants.SEND_RECENT_PHOTO, offsetMsg);
    Log.info(TAG, `query result: identifier: ${identifier}, dateTaken: ${dateTaken}`);
    reply.writeLong(dateTaken);
    reply.writeString(identifier);
    return true;
  }
}