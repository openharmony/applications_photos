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
import lazy { sendableImage } from '@kit.ImageKit';
import lazy { Log } from '../../../../utils/Log';
import lazy { Thumbnail } from '../Thumbnail';
import lazy { AssetFetchProcessor } from './AssetFetchProcessor';
import type { RequestContext } from './RequestContext';
import lazy { RequestProcessor } from './RequestProcessor';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { ImageUtil } from '../../../../utils/ImageUtil';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { TraceControllerUtils } from '../../../../utils/TraceControllerUtils';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../../utils/ReportToBigDataUtil';

/* instrument ignore file */
const TAG: string = 'DecodeProcessor';

interface DocodeMsg {
  mimeType: string;
  width: number;
  height: number;
  pixelMapFormat: image.PixelMapFormat;
}

/**
 * 解码Processor
 *
 * @since 2023-10-16
 */
export class DecodeProcessor extends RequestProcessor<Thumbnail> {
  public static readonly KEY_ORIGIN_REQUEST_ID: string = 'KEY_ORIGIN_REQUEST_ID';

  public getProcessorName(): string {
    return TAG;
  }

  public isSupported(context: RequestContext<Thumbnail>): boolean {
    return context?.params.has(AssetFetchProcessor.KEY_IMAGE_ASSET);
  }

  private async requestImage(context: RequestContext<Thumbnail>,
    asset: photoAccessHelper.PhotoAsset): Promise<image.PixelMap | undefined> {
    if (!asset) {
      Log.error(TAG, 'request quality image, current photoAsset is not exist');
      return;
    }

    return new Promise(async (resolve, reject) => {
      const dataHandler: photoAccessHelper.MediaAssetDataHandler<image.ImageSource> = {
        onDataPrepared(imageSource: image.ImageSource, map: Map<string, string>): void {
          context.params.delete(DecodeProcessor.KEY_ORIGIN_REQUEST_ID);
          let quality: string = map['quality'];
          Log.info(TAG, `ondataPrepared on image data prepared, photo quality is ${quality}, uri: ${asset.uri}`);
          if (!imageSource) {
            Log.error(TAG, 'ondataPrepared fail to request quality image, onDataPrepared imageSource is undefined');
            reject(undefined);
            return;
          }
          if (context.isCancelled) {
            Log.error(TAG, 'ondataPrepared context.isCancelled');
            reject(undefined);
            return;
          }
          // 高质量图数据上报放在编辑码之后，同一个ImageSource在不同线程不能同时触发解码和读取exif
          if (quality === 'high') {
            imageSource.createPixelMap(context?.request?.options, (err: BusinessError, pixelMap: image.PixelMap) => {
              if (context.isCancelled) {
                pixelMap?.release();
                reject(undefined);
                return;
              }
              resolve(pixelMap);
            });
          }
          return;
        }
      }

      Log.info(TAG, `request quality image : ${asset.uri}}`);
      const requestOp: photoAccessHelper.RequestOptions = {
        deliveryMode: photoAccessHelper.DeliveryMode.HIGH_QUALITY_MODE,
      };
      try {
        let requestId =
          await photoAccessHelper.MediaAssetManager.requestImage(context.appCtx, asset, requestOp, dataHandler);
        context.params.set(DecodeProcessor.KEY_ORIGIN_REQUEST_ID, requestId);
        Log.info(TAG, `request quality image, end requestId:${requestId}`);
      } catch (error) {
        Log.error(TAG, `fail to request quality image ${error}`);
      }
    });
  }

  public async getResult(context: RequestContext<Thumbnail>): Promise<Thumbnail | undefined> {
    let asset: photoAccessHelper.PhotoAsset =
      context.params.get(AssetFetchProcessor.KEY_IMAGE_ASSET) as photoAccessHelper.PhotoAsset;
    TraceControllerUtils.finishTrace(`HighResRequest${context.request?.item?.uri}`);
    if (!asset) {
      Log.error(TAG, 'get asset failed.');
      return undefined;
    }

    let pixelMap: sendableImage.PixelMap | undefined = context.request?.isThumbnail ?
      await this.decodeAsThumbnail(context, asset) : await this.decodeAsOrigin(context, asset);

    if (!pixelMap || context.isCancelled) {
      Log.info(TAG, `getResult pixelMap: ${pixelMap} isCancelled: ${context.isCancelled}`);
      pixelMap?.release();
      return undefined;
    }

    let imageInfo: image.ImageInfo = await pixelMap.getImageInfo();
    if (!imageInfo) {
      Log.error(TAG, `failed to get image info: ${context.request?.item?.uri}`);
      return undefined;
    }
    Log.info(TAG, `picture decode mime, pixelmapFormat ${imageInfo.pixelFormat} ${
      context.request?.item?.uri}`);
    let result: Thumbnail = new Thumbnail(context.request?.uri, pixelMap, imageInfo.size.width, imageInfo.size.height);
    let msg: DocodeMsg = {
      mimeType: context.request?.item?.mimeType?.toLowerCase() ?? '',
      width: imageInfo.size.width,
      height: imageInfo.size.height,
      pixelMapFormat: imageInfo.pixelFormat ?? image.PixelMapFormat.UNKNOWN,
    }
    ReportToBigDataUtil.report(BigDataConstants.PIXELMAP_DECODE_YUV, msg);

    Log.info(TAG, `finished to decode: ${context.request?.item?.uri}, ${JSON.stringify(result)}`);
    return result;
  }

  private async decodeAsOrigin(context: RequestContext<Thumbnail>, asset: photoAccessHelper.PhotoAsset):
    Promise<sendableImage.PixelMap | image.PixelMap | undefined> {
    let pixelMap: sendableImage.PixelMap | image.PixelMap | undefined = undefined;
    try {
      pixelMap = await this.requestImage(context, asset);

      if (pixelMap === undefined) {
        Log.info(TAG, 'decodeAsOrigin get pixmap undefined');
        return undefined;
      }

      if (context.isCancelled) {
        pixelMap?.release();
        return undefined;
      }
      if (context?.request?.item?.orientation !== 0) {
        await pixelMap.rotate(context.request?.item?.orientation as number);
      }
      if (context.isCancelled) {
        pixelMap?.release();
        return undefined;
      }
    } catch (err) {
      Log.error(TAG, `failed to decode: ${err}, code: ${err?.code}, ${context.request?.item?.uri}`);
      return undefined;
    }
    return pixelMap;
  }

  private async decodeAsThumbnail(context: RequestContext<Thumbnail>, asset: photoAccessHelper.PhotoAsset):
    Promise<sendableImage.PixelMap | image.PixelMap | undefined> {
    if (context.request?.item && ImageUtil.isExitTransparentChannelLocalImgMimeType(context.request?.item)) {
      return this.decodeAsOrigin(context, asset);
    }
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      pixelMap = await asset.getThumbnail(context.request?.options?.desiredSize);
    } catch (err) {
      Log.error(TAG, `failed to decode: ${err}, code: ${err?.code}, ${context.request?.item?.uri}`);
      return undefined;
    }
    return pixelMap;
  }
}