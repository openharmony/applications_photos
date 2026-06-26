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
import lazy { dataSharePredicates, DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { image } from '@kit.ImageKit';
import lazy { JSON, util } from '@kit.ArkTS';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy DBHelper from '../DBHelper';
import lazy { AssetHelper } from '@ohos/common/src/main/ets/default/utils/AssetHelper';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { fileIo } from '@kit.CoreFileKit';
import lazy DatabaseUtils from '../DatabaseUtils';
import lazy { PhotoProcessHandler } from './PhotoProcessHandler';
import lazy { FaCardAlbumUtils } from './FaCardAlbumService';
import lazy { ImageProxyDataTable } from '../databaseconstant/ImageProxyDataTable';

const TAG: string = 'ImageProxyDataService';
const IMAGE_PROXY_DB_URI: string = 'datashare:///hmos_photodata/image_proxy_data';
const INIT_BUFFER_SIZE: number = 4096;
const QUALITY_STEP: number = 10;
const MAX_EXECUTION_COUNT: number = 3;
const MAX_BASE64_LEN: number = 900000;
const DEFAULT_QUALITY: number = 95;

export default class ImageProxyDataService {
  private context: Context;

  constructor(context: Context) {
    this.context = context;
  }

  public async pixelMapToBase64(pixelMap: image.PixelMap): Promise<string> {
    const helper: util.Base64Helper = new util.Base64Helper();
    let pixelBase64 = '';
    let startTime = Date.now();
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    let quality = DEFAULT_QUALITY;
    const packOpts: image.PackingOption = { format: 'image/jpeg', quality: quality };
    try {
      const pixelMapBuffer: ArrayBuffer = await imagePackerApi.packing(pixelMap, packOpts);
      const pixelMapArray: Uint8Array = new Uint8Array(pixelMapBuffer);
      pixelBase64 = helper.encodeToStringSync(pixelMapArray);
      Log.info(TAG, `quality is ${quality}, pixelBase64 = ${pixelBase64.length} encode cost ${Date.now() - startTime}`);
      // 如果pixelBase64大于900k，无法插入数据库，循环降采样至可插入。最多执行3次
      let executionCount: number = 1;
      while (pixelBase64.length > MAX_BASE64_LEN && executionCount <= MAX_EXECUTION_COUNT) {
        quality -= QUALITY_STEP * executionCount;
        const packOpts: image.PackingOption = { format: 'image/jpeg', quality: quality };
        const pixelMapBuffer: ArrayBuffer = await imagePackerApi.packing(pixelMap, packOpts);
        const pixelMapArray: Uint8Array = new Uint8Array(pixelMapBuffer);
        pixelBase64 = helper.encodeToStringSync(pixelMapArray);
        Log.info(TAG, `executionCount is ${executionCount} quality is ${quality}, pixelBase64 = ${pixelBase64.length}` +
          ` encode cost ${Date.now() - startTime}`);
        executionCount++;
      }
      return pixelBase64;
    } catch (error) {
      Log.error(TAG, `pixelMapToBase64 error: ${JSON.stringify(error)}`);
      return pixelBase64;
    } finally {
      imagePackerApi?.release();
    }
  }

  // 原图已经下载到本地，直接使用原图插入
  // 返回undefined，插入执行失败或未执行插入，数据库无数据；返回0，调用doInsert异常（插入了重复数据），数据库有数据
  public async insertOriginalPhoto(asset: PhotoAsset, needFillBound: boolean = false,
    formId: string): Promise<number | undefined> {
    let file: fileIo.File | undefined = undefined;
    let imageSource: image.ImageSource | undefined = undefined;
    try {
      Log.info(TAG, `insertOriginalPhoto uri = ${asset.uri}`);

      file = await fileIo.open(asset.uri, fileIo.OpenMode.READ_ONLY);
      Log.info(TAG, 'file fd: ' + file.fd);

      let buffer = new ArrayBuffer(INIT_BUFFER_SIZE);
      let readLen = await fileIo.read(file.fd, buffer);
      Log.info(TAG, 'readSync data to file succeed and buffer size is:' + readLen);
      imageSource = image.createImageSource(file.fd);
      const imageSize = imageSource.getImageInfoSync().size;
      const lcdSize: image.Size = ImageUtil.toLcd(imageSize.width, imageSize.height);
      Log.info(TAG, `insertOriginalPhoto with is ${imageSize.width}, height is ${imageSize.height}` +
        `lcdWidth is ${lcdSize.width}, lcdHeight is ${lcdSize.height}`);

      let decodingOptions: image.DecodingOptions = {
        desiredSize: lcdSize,
      }
      const pixelMap: image.PixelMap = await imageSource.createPixelMap(decodingOptions);
      const orientation: number = Number(AssetHelper.get(asset, photoAccessHelper.PhotoKeys.ORIENTATION, 0));
      await pixelMap.rotate(orientation);
      Log.info(TAG, `insertOriginalPhoto pixelMap is ${pixelMap}`);

      let pixelBase64: string = await this.pixelMapToBase64(pixelMap);
      Log.info(TAG, `insertOriginalPhoto pixelBase64 length is ${pixelBase64.length}`);

      const photoBound: string =
        needFillBound ? JSON.stringify(await PhotoProcessHandler.getAllPhotoBound(asset, true, imageSize)) : '';
      let imageValue: ValuesBucket = {
        'uri': asset.uri,
        'photo_blob': pixelBase64,
        'photo_bound': photoBound,
      };
      if (formId) {
        await FaCardAlbumUtils.updateFormById(formId, imageValue);
      }
      const insertNO = await DBHelper.getInstance(this.context).doInsert(IMAGE_PROXY_DB_URI, imageValue, this.context);
      return insertNO ?? 0;
    } catch (error) {
      Log.error(TAG, `insertOriginalPhoto error: ${error}`);
      return undefined;
    } finally {
      if (file) {
        fileIo.close(file);
      }
      imageSource?.release();
    }
  }

  // 返回undefined，插入执行失败或未执行插入，数据库无数据；返回0，调用doInsert异常（插入了重复数据），数据库有数据
  public async insert(asset: PhotoAsset, pixelBase64: string,
    needFillBound: boolean = false): Promise<number | undefined> {
    if (!pixelBase64.length) {
      Log.error(TAG, `insert error: pixelBase64 is empty`);
      return undefined;
    }
    try {
      const photoBound: string = needFillBound ? JSON.stringify(await PhotoProcessHandler.getAllPhotoBound(asset)) : '';
      let imageValue: ValuesBucket = {
        'uri': asset.uri,
        'photo_blob': pixelBase64,
        'photo_bound': photoBound,
      };
      const insertNO = await DBHelper.getInstance(this.context).doInsert(IMAGE_PROXY_DB_URI, imageValue, this.context);
      return insertNO ?? 0;
    } catch (error) {
      Log.error(TAG, `insert error: ${error}`);
      return undefined;
    }
  }

  public async insertWithBucket(imageValue: ValuesBucket): Promise<void> {
    Log.info(TAG, `insertWithBucket imageValue: ${JSON.stringify(imageValue)}`);
    try {
      const insertNO = await DBHelper.getInstance(this.context).doInsert(IMAGE_PROXY_DB_URI, imageValue, this.context);
      Log.info(TAG, `insertWithBucket success data: ${insertNO}`);
    } catch (error) {
      Log.error(TAG, `insertWithBucket error ${error}`);
    }
  }

  public async queryImageProxyDataByUri(uri: string): Promise<DataShareResultSet | undefined> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(ImageProxyDataTable.URI, uri);
    Log.info(TAG, `queryImageProxyDataByUri uri: ${uri}`)

    try {
      const queryResult = await DBHelper.getInstance(this.context).doQuery(IMAGE_PROXY_DB_URI,
        predicates, [ImageProxyDataTable.URI, ImageProxyDataTable.BLOB, ImageProxyDataTable.BOUND], this.context);
      return queryResult;
    } catch (error) {
      Log.error(TAG, `queryImageProxyDataByUri error ${error}`)
      return undefined;
    }
  }

  public async queryImageUri(): Promise<DataShareResultSet | undefined> {
    Log.info(TAG, `queryImageUri start`);
    try {
      const queryResult = await DBHelper.getInstance(this.context).doQuery(IMAGE_PROXY_DB_URI,
        new dataSharePredicates.DataSharePredicates(), ['uri'], this.context);
      return queryResult;
    } catch (error) {
      Log.error(TAG, `queryImageUri error ${error}`);
      return undefined;
    }
  }

  public async queryImageUriByUri(uri: string): Promise<DataShareResultSet | undefined> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('uri', uri);
    Log.info(TAG, `queryImageUriByUri uri: ${uri}`)

    try {
      const queryResult = await DBHelper.getInstance(this.context).doQuery(IMAGE_PROXY_DB_URI,
        predicates, ['uri'], this.context);
      return queryResult;
    } catch (error) {
      Log.error(TAG, `queryImageUriByUri error ${error}`)
      return undefined;
    }
  }

  /* 图库卡片打开LightGlimpse效果后，会转为激活态，需要保持与widget同源，所以增加激活态使用的数据库查询函数 */
  public async queryImageByUri(uri: string): Promise<DataShareResultSet | undefined> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(ImageProxyDataTable.URI, uri);
    Log.info(TAG, `queryImageByUri uri: ${uri}`)

    try {
      const queryResult = await DBHelper.getInstance(this.context).doQuery(IMAGE_PROXY_DB_URI,
        predicates, [ImageProxyDataTable.URI, ImageProxyDataTable.BLOB], this.context);
      return queryResult;
    } catch (error) {
      Log.error(TAG, `queryImageByUri error ${error}`)
      return undefined;
    }
  }

  /* 图库卡片打开LightGlimpse效果后，会转为激活态，需要保持与widget展示同样的bound区域，所以增加激活态使用的数据库查询函数 */
  public async queryBoundByUri(uri: string): Promise<DataShareResultSet | undefined> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(ImageProxyDataTable.URI, uri);
    Log.info(TAG, `queryBoundByUri uri: ${uri}`)

    try {
      const queryResult = await DBHelper.getInstance(this.context).doQuery(IMAGE_PROXY_DB_URI,
        predicates, [ImageProxyDataTable.URI, ImageProxyDataTable.BOUND], this.context);
      return queryResult;
    } catch (error) {
      Log.error(TAG, `queryBoundByUri error ${error}`)
      return undefined;
    }
  }

  public async deleteByUri(uri: string): Promise<number | undefined> {
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('uri', uri);
      Log.info(TAG, 'deleteByUri  ' + uri + `  prediates: ${JSON.stringify(predicates)}` + predicates);

      const deleteNO = await DBHelper.getInstance(this.context).doDelete(
        IMAGE_PROXY_DB_URI,
        predicates,
        this.context
      )
      return deleteNO;
    } catch (error) {
      Log.error(TAG, `deleteByUri error: ${error}`);
      return undefined;
    }
  }

  /**
   * 批量删除proxy数据
   *
   * @param uriList 需要删除的图片uri列表
   * @returns
   */
  public async batchDeleteByUri(uriList: string[]): Promise<number | undefined> {
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.in('uri', uriList);
      Log.info(TAG, `batchDeleteByUri  uriList len:${uriList.length}`);

      const deleteNO = await DBHelper.getInstance(this.context).doDelete(
        IMAGE_PROXY_DB_URI,
        predicates,
        this.context
      )
      return deleteNO;
    } catch (error) {
      Log.error(TAG, `batchDeleteByUri error: ${error}`);
      return undefined;
    }
  }

  // 图库编辑图片后更新对应图片的 photo_blob
  public async updateImageBlobByUri(uri: string): Promise<void> {
    try {
      Log.info(TAG, 'updateImageBlob uri: ' + uri);
      const userFileManagerAccess = UserFileManagerAccess.getInstance();
      let fetchColumns = UserFileManagerAccess.ALL_IMAGE_VIDEO_FETCH_COLUMNS;
      const photoAsset: photoAccessHelper.PhotoAsset | undefined =
        await userFileManagerAccess.getPhotoAssetByUri(uri, fetchColumns);
      if (!photoAsset) {
        Log.info(TAG, 'updateImageBlob without photoAsset');
        return;
      }
      this.updateImageBlobByAsset(photoAsset);
      Log.info(TAG, `updateImageBlob end`);
    } catch (error) {
      Log.error(TAG, `updateImageBlob error: ${error}`);
      return;
    }
  }

  public async updateImageBlobByAsset(asset: PhotoAsset): Promise<number | undefined> {
    try {
      Log.info(TAG, 'updateImageBlobByAsset');
      let pixelMapData: ArrayBuffer | undefined = undefined;
      pixelMapData = await asset.getThumbnailData(photoAccessHelper.ThumbnailType.LCD);
      const pixelBase64: string = await DatabaseUtils.bufferToBase64(pixelMapData);
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('uri', asset.uri);

      const value: ValuesBucket = {
        'uri': asset.uri,
        'photo_blob': pixelBase64,
      }
      Log.info(TAG, 'updateImageBlobByAsset uri ' + asset.uri + ', value ' + `${JSON.stringify(value)}`);
      const data = await DBHelper.getInstance(this.context).doUpdate(
        IMAGE_PROXY_DB_URI,
        predicates,
        value,
        this.context
      );
      Log.info(TAG, `updateImageBlobByAsset success size: ${data}`);
      return data;
    } catch (error) {
      Log.error(TAG, `updateImageBlobByAsset error: ${error}`);
      return undefined;
    }
  }

  public async queryImageBounds(): Promise<DataShareResultSet | undefined> {
    Log.info(TAG, `queryImageBounds`);

    try {
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      // 因为只需要处理photo_bound为空的，此处减少数据查询量
      predicates.equalTo(ImageProxyDataTable.BOUND, '');

      const result = await DBHelper.getInstance(this.context).doQuery(
        IMAGE_PROXY_DB_URI,
        predicates,
        [ImageProxyDataTable.URI, ImageProxyDataTable.BOUND],
        this.context
      );
      return result;
    } catch (error) {
      Log.error(TAG, `queryImageBounds error ${error}`)
      return undefined;
    }
  }
  
  public async updateImageBoundByAsset(asset: PhotoAsset): Promise<number | undefined> {
    try {
      Log.info(TAG, `updateImageBoundByAsset`);
      
      const bound: string = JSON.stringify(await PhotoProcessHandler.getAllPhotoBound(asset));
      if (bound === 'null' || bound === '[]' || bound === '{}') {
        Log.info(TAG, `updateImageBoundByAsset: photo_bound of ${asset.uri} is empty, quit`);
        return;
      }
      
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(ImageProxyDataTable.URI, asset.uri);

      let value: ValuesBucket = {
        'uri': asset.uri,
        'photo_bound': bound,
      };

      const res = await DBHelper.getInstance(this.context).doUpdate(
        IMAGE_PROXY_DB_URI,
        predicates,
        value,
        this.context
      );
      return res;
    } catch (error) {
      Log.error(TAG, `updateImageBoundByAsset  ${asset.uri} error: ${error}`);
      return undefined;
    }
  }
}

