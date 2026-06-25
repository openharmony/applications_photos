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
/* instrument ignore file*/
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { fileIo as fs, fileUri } from '@kit.CoreFileKit';
import lazy { image } from '@kit.ImageKit';
import lazy { hash } from '@kit.CoreFileKit';
import lazy { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import lazy { PickerInstanceUtil } from './PickerInstanceUtil';
import lazy { uriPermissionManager, wantConstant } from '@kit.AbilityKit';
import lazy { media } from '@kit.MediaKit';
import lazy { Log } from './Log';

const TAG: string = 'common_MediaItemUtil';

export class MediaItemUtil {
  public static deletePickPhoto(createUri: string, fileDir: string) {
    let names = createUri.split('/');
    if (names.length == 0) {
      return;
    }
    fs.unlink(fileDir + `/${names[names.length - 1]}`);
  }

  public static deleteAllPickPhoto(createUris: Array<string> | undefined, fileDir: string) {
    createUris?.forEach((v) => {
      MediaItemUtil.deletePickPhoto(v, fileDir)
    })
  }

  public static createFileAndGrant(replaceUri: string, fileDir: string, bundleName: string, appCloneIndex: number,
    callback: AsyncCallback<string>) {
    let fileName = MediaItemUtil.getFileName(replaceUri, fileDir);
    fs.open(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then(async (file) => {
      fileName = fileUri.getUriFromPath(fileName);
      await uriPermissionManager.grantUriPermission(fileName,
        wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
        bundleName, appCloneIndex);
      await fs.close(file.fd);
      callback({ code: 0, message: '', name: '' }, fileName);
    }).catch(() => {
      callback({ code: 14000011, message: 'System inner fail', name: '' }, '');
    })
  }

  public static getFileName(uri: string, fileDir: string): string {
    let hashName = fileDir + '/' + MediaItemUtil.hashFileName(uri)
    if (!uri.includes('.')) {
      return hashName;
    }
    return hashName + uri.substring(uri.lastIndexOf('.'))
  }

  private static hashFileName(uri: string): string {
    let hashUri = uri + PickerInstanceUtil.getPickerId();
    const hs = hash.createHash('md5');
    hs.update(new Uint8Array(hashUri?.split('').map((x: string) => x.charCodeAt(0))).buffer);
    return hs.digest()
  }

  public static getSaveFileName(uri: string, fileDir: string): string {
    return fileUri.getUriFromPath(MediaItemUtil.getFileName(uri, fileDir));
  }

  // 因为MediaCachedImage只支持 系统文件和pixelMap，  那么沙箱的文件路径不可用，只能解析为pixelMap才能显示
  public static parsePixelMapSync(uri: string): PixelMap | undefined {
    let fd = 0;
    try {
      let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
      let fd = file.fd;
      let source = image.createImageSource(fd);
      return source.createPixelMapSync();
    } catch (e) {
      return undefined;
    } finally {
      fs.close(fd).catch((err: BusinessError) => {
        Log.error(TAG, `parsePixelMapSync close file error, stack: ${err?.stack}, code: ${err?.code}`);
      });
    }
  }

  public static parsePixelMap(uri: string, callback: Function) {
    let fd = 0;
    let source: image.ImageSource | undefined = undefined;
    try {
      let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
      let fd = file.fd;
      source = image.createImageSource(fd);
      source.createPixelMap().then((pixelMap) => {
        callback(pixelMap);
      }).catch(() => {
        callback(undefined);
      })
    } catch (e) {
      callback(undefined);
    } finally {
      if (!!source) {
        source.release();
      }
      fs.close(fd).catch((err: BusinessError) => {
        Log.error(TAG, `parsePixelMap close file error, stack: ${err?.stack}, code: ${err?.code}`);
      });
    }
  }

  public static async parseUri(uri: string): Promise<MediaItem> {
    let item = new MediaItem();
    let fd = 0;
    let source: image.ImageSource | undefined = undefined;
    try {
      let file = await fs.open(uri, fs.OpenMode.READ_ONLY);
      let fd = file.fd;
      source = image.createImageSource(fd);
      if (!source) {
        return item;
      }
      let imageInfo = source.getImageInfoSync();
      item.mimeType = imageInfo.mimeType;
      item.width = imageInfo.size.width;
      item.imgWidth = imageInfo.size.width;
      item.coverWidth = imageInfo.size.width;
      item.height = imageInfo.size.height;
      item.imgHeight = imageInfo.size.height
      item.coverHeight = imageInfo.size.height;
      item.path = uri;
      item.uri = uri;
      item.thumbnail = uri;
      item.uniqueId = uri;
      item.hashCode = uri;
      return item;
    } catch (e) {
      return item;
    } finally {
      fs.close(fd).catch((err: BusinessError) => {
        Log.error(TAG, `parseUri close file error, stack: ${err?.stack}, code: ${err?.code}`);
      });
      source?.release();
    }
  }

  public static async parseVideoPixelMap(uri: string, size?: Size): Promise<image.PixelMap | undefined> {
    // 创建AVImageGenerator对象
    let avImageGenerator: media.AVImageGenerator = await media.createAVImageGenerator();
    let file: fs.File = await fs.open(uri);
    if (!file.fd) {
      return undefined;
    }
    avImageGenerator.fdSrc = { fd: file.fd };
    // 初始化入参
    let queryOption = media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC;
    let params: media.PixelMapParams = {};
    // 获取缩略图（promise模式）
    try {
      let covPixmap = await avImageGenerator.fetchFrameByTime(0, queryOption, params);
      return covPixmap;
    } catch (error) {
    } finally {
      avImageGenerator.release();
      fs.closeSync(file.fd);
    }
    return undefined;
  }

  public static async createCoverFile(uri: string, pixelMap: image.PixelMap | undefined, callback: Function) {
    if (!pixelMap) {
      return;
    }
    const imagePacker = image.createImagePacker();
    try {
      const packOpts: image.PackingOption = { format: 'image/jpeg', quality: 30 };
      const readBuffer = await imagePacker.packing(pixelMap, packOpts);

      const file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      try {
        await fs.write(file.fd, readBuffer);
        callback(); // 成功时回调
      } catch (e1) {
        Log.error(TAG, `createCoverFile write file error, stack: ${e1?.stack}, code: ${e1?.code}`);
      } finally {
        try {
          await fs.close(file.fd);
        } catch (e2) {
          Log.error(TAG, `createCoverFile close file error, stack: ${e2?.stack}, code: ${e2?.code}`);
        }
      }
    } catch (e3) {
      Log.error(TAG, `createCoverFile open file error, stack: ${e3?.stack}, code: ${e3?.code}`);
      callback(e3); // 传递错误对象给回调
    } finally {
      imagePacker.release(); // 确保资源释放
    }
  }

  public static async parseMediaItemByVideo(videoUri: string): Promise<MediaItem> {
    // 创建AVMetadataExtractor对象
    let avMetadataExtractor = await media.createAVMetadataExtractor();
    // 设置fdSrc
    avMetadataExtractor.fdSrc = fs.openSync(videoUri);
    // 获取元数据（promise模式）
    let metadata = await avMetadataExtractor.fetchMetadata();
    let item = new MediaItem();
    item.uri = videoUri;
    item.uniqueId = videoUri;
    item.duration = Number.parseInt(metadata.duration ?? '0');
    item.width = Number.parseInt(metadata.videoWidth ?? '0')
    item.imgWidth = Number.parseInt(metadata.videoWidth ?? '0')
    item.coverWidth = Number.parseInt(metadata.videoWidth ?? '0')
    item.imgOriginWidth = Number.parseInt(metadata.videoWidth ?? '0')
    item.height = Number.parseInt(metadata.videoHeight ?? '0')
    item.imgHeight = Number.parseInt(metadata.videoHeight ?? '0')
    item.coverHeight = Number.parseInt(metadata.videoHeight ?? '0')
    item.imgOriginHeight = Number.parseInt(metadata.videoHeight ?? '0')
    avMetadataExtractor.release();
    return item;
  }
}