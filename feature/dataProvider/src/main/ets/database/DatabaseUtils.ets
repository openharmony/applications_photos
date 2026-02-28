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
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { image } from '@kit.ImageKit';
import lazy { util } from '@kit.ArkTS';

const TAG: string = 'DatabaseUtils';
const ASSET_PREFIX = 'file://media/Photo/';
const PREFIX_LENGTH = ASSET_PREFIX.length;

/**
 * 数据库相关工具类
 */
export default class DatabaseUtils {
  /**
   * 批量处理URI路径数组
   *
   * @param uris 原始资源路径数组
   * @returns 处理后的路径结果数组
   */
  public static extractAssetUriPaths(uris: string[]): string[] {
    return uris.map(uri => DatabaseUtils.extractAssetUri(uri));
  }

  /**
   * 处理单个URI的路径提取
   *
   * @param uri 原始资源路径
   * @returns 处理后的目标路径或空字符串
   */
  public static extractAssetUri(uri: string): string {
    try {
      if (!uri.startsWith(ASSET_PREFIX)) {
        return '';
      }
      const segmentEnd = uri.indexOf('/', PREFIX_LENGTH);
      return uri.slice(0, segmentEnd !== -1 ? segmentEnd : uri.length);
    } catch (err) {
      Log.error(TAG, `extractAssetUri failed, error message: ${err?.code}, ${err?.msg}`);
      return '';
    }
  }

  public static async bufferToBase64(buffer: ArrayBuffer): Promise<string> {
    const helper: util.Base64Helper = new util.Base64Helper();
    let pixelBase64 = '';

    if (buffer.byteLength > 600000) {
      let imageSource: image.ImageSource | undefined = undefined;
      let imagePackerApi: image.ImagePacker | undefined = undefined;
      try {
        Log.info(TAG, `bufferSize > 600K`);
        let startTime = Date.now();
        imageSource = image.createImageSource(buffer);
        const imageSize = imageSource.getImageInfoSync().size;
        const opts: image.DecodingOptions = {
          editable: true,
          desiredSize: { width: imageSize.width / 2, height: imageSize.height / 2 },
        };
        const pixelMap: image.PixelMap = imageSource.createPixelMapSync(opts);
        Log.info(TAG, `bufferSize = ${buffer.byteLength} decode cost ${Date.now() - startTime}`);

        startTime = Date.now();
        imagePackerApi = image.createImagePacker();
        const packOpts: image.PackingOption = { format: 'image/jpeg', quality: 95 };
        const pixelMapBuffer: ArrayBuffer = await imagePackerApi.packing(pixelMap, packOpts);
        const pixelMapArray: Uint8Array = new Uint8Array(pixelMapBuffer);
        pixelBase64 = helper.encodeToStringSync(pixelMapArray);
        Log.info(TAG, `bufferSize = ${buffer.byteLength} encode cost ${Date.now() - startTime}`);
      } catch (error) {
        Log.error(TAG, `bufferToBase64 error, ${error?.code} ${error?.message}`);
      } finally {
        // 释放图片资源，防止泄露
        imageSource?.release();
        imagePackerApi?.release();
      }

    } else {
      const pixelArray: Uint8Array = new Uint8Array(buffer);
      pixelBase64 = helper.encodeToStringSync(pixelArray);
    }

    return pixelBase64;
  }
}