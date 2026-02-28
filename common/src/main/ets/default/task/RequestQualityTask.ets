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

import lazy image from '@ohos.multimedia.image';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Log } from '../utils/Log';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';

export const TAG: string = 'RequestQualityTask';

export class RequestQualityTask {
  public static requestId: string;

  public static async requestQuickImage(context: Context, asset: photoAccessHelper.PhotoAsset | undefined,
    dataHandler: photoAccessHelper.QuickImageDataHandler<image.Picture>): Promise<number> {
    const requestOp: photoAccessHelper.RequestOptions = {
      deliveryMode: photoAccessHelper.DeliveryMode.BALANCE_MODE,
      sourceMode: photoAccessHelper.SourceMode.ORIGINAL_MODE,
    };

    let requestDateTime: number = Date.now();
    let requestDuration: number = 0;
    try {
      Log.info(TAG, `start to requestImage uri : ${asset?.uri ?? ''}`);
      TraceControllerUtils.startTraceWithTaskId('requestQualityImage', requestDateTime);
      RequestQualityTask.requestId = await photoAccessHelper.MediaAssetManager.quickRequestImage(context,
        asset, requestOp, dataHandler);
      TraceControllerUtils.finishTraceWithTaskId('requestQualityImage', requestDateTime);
    } catch (error) {
      Log.error(TAG, `fail to request quality image ${error}`);
    } finally {
      requestDuration = Date.now() - requestDateTime;
    }
    return requestDuration;
  }
}