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
import { MediaType, BaseEditor } from '../../../../service/App';
import { HiLog } from '../../../../common/util/HiLog';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import { NullUtil } from '../../../../common/util/NullUtil';
import { App } from '../../../../service/App';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import fs from '@ohos.file.fs';
import fileuri from '@ohos.file.fileuri';
import { Constants } from '../../../../common/util/Constants';
import { Trace } from '../../../../common/util/Trace';
import { GlobalThisUtil } from '../../../../common/util/GlobalThisUtil';
import { common, contextConstant } from '@kit.AbilityKit';
import ExifUtil from '../../../../common/util/ExifUtil';
import PhotoAssetUtil from '../../../../common/util/PhotoAssetUtil';
import { image } from '@kit.ImageKit';
import { taskpool } from '@kit.ArkTS';
import sdk from '../../../../service/native';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { BusinessError } from '@ohos.base';

/* instrument ignore file */
const TAG = 'MediaSaveManager';
const fileNameRegex = new RegExp('[\.\\\\/:*?"\'`<>|{}\\\[\\\]]', 'g');
const PHOTO_ASSET_KEYS_MIME_TYPE = 'mime_type';
const EXPORT_FALLBACK_MIME_TYPE = 'image/jpeg';
const EXPORT_FALLBACK_FILE_SUFFIX = '.jpg';

/**
 * 媒体文件保存管理类
 */

export class ExportInfo {
  public editData: string = '';
  public editDataType: string = '';
  public exportWidth: number = 0;
  public exportHeight: number = 0;
  public exportFps: number = 0.0;
  public exportBitRate: number = 0;
  public exportResult: number = 0;
}

export interface ImgInfo {
  fileFd: number;
  mimeType: string;
}

@Concurrent
async function transferAllAsync(sourceUri: string, outputUri: string | undefined, isDoAiRefine: boolean,
  isAiLableNeeded: boolean, isXmageWatermark: boolean, isOverride: boolean, sourceDateTakenMs: number) {
  await ExifUtil.transferAll('MediaSaveManager', sourceUri, outputUri,
    isDoAiRefine, isAiLableNeeded, isXmageWatermark, isOverride, sourceDateTakenMs);
}

export class MediaSaveManager {
  private editor: BaseEditor;
  private mediaAsset: MediaAsset | null = null;
  private overrideTempFile: MediaOverrideTempFile | null = null;
  private overrideTempFileOpened: boolean = false;
  public filePath: string = '';
  private mimeType: string = '';
  private context: Context | undefined;

  constructor(editor: BaseEditor) {
    this.editor = editor;
    this.context = getContext(this);
  }

  getMediaContext(): Context | undefined {
    if (!this.context) {
      this.context = getContext(this);
    }
    return this.context;
  }

  /**
   * 创建媒体文件
   *
   * @returns fd
   */
  public async createMediaFile(isOverride: boolean): Promise<ImgInfo> {
    return new Promise(async (resolve, reject) => {
      try {
        HiLog.i(TAG, 'createMediaFile begin, isOverride: ' + isOverride);
        if (this.editor.mediaType !== MediaType.IMAGE) {
          HiLog.w(TAG, 'compileFinish not image');
          throw new Error('mediaType is not support');
        }
        let fileName: string = '';
        let fileNameSuffix: string = this.getFileSuffixFromUri(this.editor.mediaUri);
        let fileFd: number = -1;
        if (isOverride) {
          let asset: photoAccessHelper.PhotoAsset = await this.getEditorAsset(this.editor.mediaUri);
          await this.setMimeType(asset);
          fileNameSuffix = this.getExportFileSuffix(fileNameSuffix);
          let newAssetFile = await this.overrideAssetFile(fileName, fileNameSuffix);
          fileFd = newAssetFile.fd;
          this.overrideTempFile = new MediaOverrideTempFile(newAssetFile, this.filePath);
          this.overrideTempFileOpened = true;
          HiLog.i(TAG, 'testFileFdIsOverride:' + fileFd);
        } else if (!isOverride && this.editor.mediaAsset) {
          HiLog.i(TAG, `save as new asset from ${this.editor.mediaAsset.uri}`);
          // 另存为新图片，从原图复制一个做修改，连带相册一同复制
          let srcTitle: string | undefined = this.getAssetTitle(this.editor.mediaAsset);
          fileName = PhotoAssetUtil.buildNewAssetDisplayName(srcTitle);
          Trace.begin('createMediaFileCloneAsset');
          let asset: photoAccessHelper.PhotoAsset = await this.editor.mediaAsset.clone(fileName);
          Trace.end('createMediaFileCloneAsset');
          this.mediaAsset = new MediaAsset(-1, asset);
          await this.setMimeType(asset);
          fileNameSuffix = this.getExportFileSuffix(fileNameSuffix);
          let title = this.getAssetTitle(asset) ?? fileName;
          let newAssetFile = await this.createNewAssetFile(title, fileNameSuffix);
          fileFd = newAssetFile.fd;
          HiLog.i(TAG, `save as new asset fd ${fileFd}`);
          this.overrideTempFile = new MediaOverrideTempFile(newAssetFile, this.filePath);
          this.overrideTempFileOpened = true;
          this.mediaAsset.fd = fileFd;
        } else {
          HiLog.w(TAG, `un-supported save type isOverride: ${isOverride}, asset: ${this.editor.mediaAsset?.uri}`);
          throw new Error('un-supported save type');
        }
        this.mediaAsset && await PhotoAssetUtil.addPhotoToAlbum(this.mediaAsset?.fileAsset, this.editor.albumUri);
        HiLog.i(TAG, 'createMediaFile end');
        resolve({ fileFd: fileFd, mimeType: this.mimeType });
      } catch (err) {
        HiLog.e(TAG, `createMediaFile failed :${err.message}`);
        reject(err.message);
      }
    });
  }

  /**
   * 创建保存图片的uri
   *
   * @returns uri
   */
  public async createImageUri(): Promise<string> {
    try {
      if (this.editor.mediaType === MediaType.IMAGE && this.editor.mediaAsset) {
        HiLog.i(TAG, `create image uri as new asset from ${this.editor.mediaAsset.uri}`);
        let title = this.editor.mediaAsset.get(photoAccessHelper.PhotoKeys.TITLE) as string;
        if (title && fileNameRegex.test(title)) {
          title = title.replace(fileNameRegex, '');
        }
        let fileName: string = PhotoAssetUtil.buildNewAssetDisplayName(title);
        let asset: photoAccessHelper.PhotoAsset = await this.editor.mediaAsset.clone(fileName);
        this.mediaAsset = new MediaAsset(-1, asset);
        return this.mediaAsset?.fileAsset?.uri;
      }
    } catch (err) {
      HiLog.e(TAG, `createImageUri failed :${err.message}`);
    }
    return '';
  }

  public async overrideAssetFile(fileName: string, fileNameSuffix: string): Promise<fs.File> {
    let asset: photoAccessHelper.PhotoAsset = await this.getEditorAsset(this.editor.mediaUri);
    let title = this.getAssetTitle(asset) ?? fileName;
    return await this.createNewAssetFile(title, fileNameSuffix);
  }

  getAssetTitle(asset: photoAccessHelper.PhotoAsset): string | undefined {
    try {
      let title = asset.get(photoAccessHelper.PhotoKeys.TITLE) as string;
      if (title && fileNameRegex.test(title)) {
        title = title.replace(fileNameRegex, '');
      }
      HiLog.i(TAG, `get photo asset title: ${title}`)
      return title;
    } catch (err) {
      HiLog.e(TAG, `get photo asset title failed: ${err.message}`);
      return undefined;
    }
  }

  /**
   * 创建一个用于沙箱的文件
   * @param fileName 文件名
   * @param fileNameSuffix 后缀
   * @returns
   */
  public async createNewAssetFile(fileName: string, fileNameSuffix: string): Promise<fs.File> {
    let context = getContext(this);
    let tmpArea = context.area;
    context.area = contextConstant.AreaMode.EL3;
    HiLog.i(TAG, 'createNewAssetFile fileName :' + fileName + `, fileNameSuffix :${fileNameSuffix}`);
    this.filePath = context.filesDir + `/${fileName}` + fileNameSuffix;
    context.area = tmpArea;
    Trace.begin('fs open and getPhotoAssets');
    let newAssetFile = await fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    Trace.end('fs open and getPhotoAssets');
    return newAssetFile;
  }

  /**
   * 获取照片原图的mimeType
   * @param fetchResult 文件检索结果集
   * @returns mimeType
   */
  public async setMimeType(asset: photoAccessHelper.PhotoAsset): Promise<void> {
    HiLog.begin(TAG, 'setMimeType');
    HiLog.i(TAG, 'file open start');
    let fd = await asset.open('r');
    HiLog.i(TAG, 'file open end');
    await image.createImageSource(fd)
      .getImageInfo()
      .then((imageInfo: image.ImageInfo) => {
        HiLog.i(TAG, `setMimeType createImageSource.getImageInfo.mimeType= ${imageInfo.mimeType}`);
        this.mimeType = imageInfo.mimeType;
      })
      .catch((error: Error) => {
        HiLog.i(TAG, `getImageInfo error: ${error.message}`);
      })
      .finally(async () => {
        HiLog.i(TAG, `[fd flag] setMimeType ,close fd: ${fd}`);
        await asset.close(fd);
      });
    let supportedType: string[] = DeviceUtil.getSupportedPackerImageFormats();
    // instrument ignore if
    if (this.mimeType !== '' && supportedType.length > 0 && supportedType.indexOf(this.mimeType) < 0) {
      HiLog.w(TAG, `setMimeType not supported: ${supportedType}`);
      let assetMimeType: string | undefined = await this.getPhotoAssetMimeTypeMember(asset);
      if (assetMimeType && supportedType.indexOf(assetMimeType.toString()) >= 0) {
        this.mimeType = assetMimeType.toString();
        HiLog.w(TAG, `setMimeType change PhotoAsset mimeType=${assetMimeType}`);
      } else {
        this.mimeType = EXPORT_FALLBACK_MIME_TYPE;
        HiLog.w(TAG, `setMimeType fallback export mimeType=${this.mimeType}, assetMimeType=${assetMimeType}`);
      }
    }
    HiLog.end(TAG, 'setMimeType');
  }

  private getFileSuffixFromUri(uri: string): string {
    let pointIndex = uri.lastIndexOf('.');
    if (pointIndex < 0) {
      return EXPORT_FALLBACK_FILE_SUFFIX;
    }
    return uri.substring(pointIndex).toLowerCase();
  }

  private getExportFileSuffix(defaultSuffix: string): string {
    if (this.mimeType === EXPORT_FALLBACK_MIME_TYPE) {
      return EXPORT_FALLBACK_FILE_SUFFIX;
    }
    return defaultSuffix;
  }

  // instrument ignore next
  private async getPhotoAssetMimeTypeMember(asset: photoAccessHelper.PhotoAsset): Promise<string | undefined> {
    let assetMimeType: number | string | boolean;
    try {
      // 获取asset时没有指定字段时无法查出结果，或抛出异常
      assetMimeType = asset.get(PHOTO_ASSET_KEYS_MIME_TYPE);
      return assetMimeType.toString();
    } catch (error) {
      HiLog.e(TAG, `getPhotoAssetMimeTypeMember by param error ${error}`);
    }
    try {
      let tmpAsset: photoAccessHelper.PhotoAsset = await this.getEditorAsset(asset.uri);
      assetMimeType = tmpAsset.get(PHOTO_ASSET_KEYS_MIME_TYPE);
      return assetMimeType.toString();
    } catch (error) {
      HiLog.e(TAG, `getPhotoAssetMimeTypeMember error ${error}`);
    }
    return undefined;
  }

  getUri(): string {
    if (this.mediaAsset === null) {
      HiLog.e(TAG, 'getUri failed, mediaAsset is null');
      return '';
    }
    return this.mediaAsset.fileAsset.uri;
  }

  /**
   * 编译完成,关闭 fd,如果覆盖，删除源文件
   *
   * @param isOverride 是否覆盖
   */
  public async compileFinish(isOverride: boolean, exportInfo: ExportInfo, isDoAiRefine: boolean): Promise<string> {
    return new Promise(async (resolve: Function, reject: Function) => {
      Trace.begin(`compileFinish isOverride :${isOverride}`);
      if (!isOverride && this.mediaAsset === null) {
        HiLog.e(TAG, 'compileFinish mediaAsset is null when save as new');
        reject('compileFinish mediaAsset is null when save as new');
        return;
      }
      try {
        if (!this.overrideTempFile) {
          HiLog.w(TAG, 'compileFinish overrideTempFile is null');
          reject('compileFinish overrideTempFile is null');
          return;
        }
        // 保存文件EXIF信息
        HiLog.i(TAG, 'compileFinish start try save exif ' + this.editor.mediaUri + " " + this.overrideTempFile.file.fd);
        let sourceUri = this.editor.mediaUri;
        let sourceDateTakenMs: number = 0;
        if (!isOverride && this.editor.mediaAsset) {
          let dateTaken = this.editor.mediaAsset.get(photoAccessHelper.PhotoKeys.DATE_TAKEN_MS);
          sourceDateTakenMs = Number(dateTaken);
          if (isNaN(sourceDateTakenMs) || sourceDateTakenMs <= 0) {
            HiLog.w(TAG, `compileFinish invalid dateTakenMs: ${dateTaken}`);
            sourceDateTakenMs = 0;
          } else {
            HiLog.i(TAG, `compileFinish sourceDateTakenMs=${sourceDateTakenMs}`);
          }
        }
        await this.closeTempFile();
        let isAiLableNeeded : boolean = sdk.aiEditorContextIsAiLableNeeded();
        let task: taskpool.Task = new taskpool.Task(transferAllAsync, sourceUri, this.overrideTempFile.path,
          isDoAiRefine, isAiLableNeeded, false, isOverride, sourceDateTakenMs);
        await taskpool.execute(task);
        resolve(this.filePath);
      } catch (err) {
        HiLog.e(TAG, `compileFinish failed :${err}`);
        let error = err as Error;
        reject(error.message);
      } finally {
        Trace.end(`compileFinish isOverride :${isOverride}`);
      }
    });
  }

  private async closeTempFile() {
    if (!this.overrideTempFile) {
      return;
    }
    try {
      if (this.overrideTempFileOpened) {
        HiLog.i(TAG, `[fd flag] close template file.fd: ${this.overrideTempFile.file?.fd}`);
        await fs.close(this.overrideTempFile.file);
        this.overrideTempFileOpened = false;
      }
    } catch (error) {
      HiLog.e(TAG, `compileFinish close fd failed :${error.message}`);
    }
  }

  private printSaveImageInfo(path: string | undefined) {
    let source: image.ImageSource | undefined;
    try {
      source = image.createImageSource(path);
      let imgInfo: image.ImageInfo = source.getImageInfoSync();
      HiLog.i(TAG, `printSaveImageInfo ${JSON.stringify(imgInfo)}`);
    } catch (err) {
      HiLog.e(TAG, `printSaveImageInfo error ${err}`);
    } finally {
      source?.release();
    }
  }

  // 提交编辑
  public async submitEdit(editData: string, editDataType: string, isOverride: boolean): Promise<void> {
    HiLog.i(TAG, 'submitEdit start');
    this.printSaveImageInfo(this.overrideTempFile?.path);
    let uri = fileuri.getUriFromPath(this.overrideTempFile?.path);
    let data = new photoAccessHelper.MediaAssetEditData(editDataType, '1.0'); // 当前编辑过后的editDataType
    data.data = editData;
    let mediaUri = isOverride || !this.mediaAsset?.fileAsset.uri ?
    this.editor.mediaUri : this.mediaAsset?.fileAsset.uri;
    let asset: photoAccessHelper.PhotoAsset = await this.getEditorAsset(mediaUri);
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.getMediaContext());
    Trace.begin('submitEdit');
    try {
      let changeRequest: photoAccessHelper.MediaAssetChangeRequest =
        new photoAccessHelper.MediaAssetChangeRequest(asset);
      HiLog.i(TAG, 'addResource start');
      changeRequest.addResource(photoAccessHelper.ResourceType.IMAGE_RESOURCE, uri);
      HiLog.i(TAG, 'setEditData start ' + data.compatibleFormat + " " + data.data);
      await asset.commitEditedAsset(data.data, uri);
      // TODO 编辑过的图片使用applyChanges会报fail to rename导致保存失败
      // changeRequest.setEditData(data);
      // HiLog.i(TAG, 'applyChanges start');
      // await phAccessHelper.applyChanges(changeRequest);
    } catch(e) {
      HiLog.e(TAG, `submitEdit error:${e.code} ${e.message}`);
    }
    phAccessHelper.release();
    Trace.end('submitEdit');
    HiLog.i(TAG, 'submitEdit start end');
    this.mediaAsset = null;
  }

  public async getEditorAsset(mediaUri: string, fetchColumns?: Array<string>): Promise<photoAccessHelper.PhotoAsset> {
    HiLog.i(TAG, `getEditorAsset: ${mediaUri}`);
    let asset: photoAccessHelper.PhotoAsset;
    let isHidden: boolean = App.getInstance().myEditor().isHiddenSource;
    if (isHidden) {
      asset = await this.getHiddenAssetByUri(mediaUri) as photoAccessHelper.PhotoAsset;
    } else {
      let predicate = new dataSharePredicates.DataSharePredicates();
      predicate.equalTo(Constants.PREDICATE_MEDIA_URI_KEY, mediaUri);
      if (!fetchColumns) {
        fetchColumns = [photoAccessHelper.PhotoKeys.TITLE, PHOTO_ASSET_KEYS_MIME_TYPE];
      }
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: fetchColumns,
        predicates: predicate,
      };
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.getMediaContext());
      let fetchResult = await phAccessHelper.getAssets(fetchOptions);
      asset = await fetchResult.getFirstObject();
      fetchResult.close();
      phAccessHelper.release();
      HiLog.i(TAG, `fetchResult and phAccessHelper are close.`);
    }
    HiLog.i(TAG, 'getEditorAsset end.');
    return asset;
  }

  private async getHiddenAssetByUri(uri: string): Promise<photoAccessHelper.PhotoAsset> {
    let context = GlobalThisUtil.getLocalProperty('photosAbilityContext') as common.Context;
    let helper = photoAccessHelper.getPhotoAccessHelper(context);
    // 隐藏相册
    let albumFetchResult = await helper.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE);
    const hiddenAlbum: photoAccessHelper.Album = await albumFetchResult.getFirstObject();
    albumFetchResult.close();
    HiLog.i(TAG, `albumFetchResult is close.`);
    let opt: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates(),
      fetchColumns: [photoAccessHelper.PhotoKeys.TITLE],
    }
    opt.predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri);
    const hiddenAssetFetchResult = await hiddenAlbum.getAssets(opt);
    let photoAsset = await hiddenAssetFetchResult.getFirstObject();
    HiLog.i(TAG, 'getHiddenAssetByUri photoAsset.displayName %{public}s', photoAsset.displayName);
    hiddenAssetFetchResult.close();
    helper.release();
    HiLog.i(TAG, `hiddenAssetFetchResult is close.`);
    return photoAsset;
  }

  /**
   * 删除媒体文件并在回收占中移除
   */
  public async deleteMedia(isOverride: boolean) {
    try {
      if (this.overrideTempFile) {
        await this.closeTempFile();
        fs.unlink(this.overrideTempFile.path);
        HiLog.i(TAG, 'deleteMedia template file deleted');
      }
      if (!isOverride && this.mediaAsset) {
        let fileAsset = this.mediaAsset.fileAsset;
        this.mediaAsset = null;
        await PhotoAssetUtil.deleteAssetThoroughly(fileAsset);
      }
      HiLog.i(TAG, 'deleteMedia success');
    } catch (err) {
      HiLog.e(TAG, 'deleteMedia failed:' + (err as Error).message);
    }
  }
}

class MediaAsset {
  public fd: number;
  public fileAsset: photoAccessHelper.PhotoAsset;

  constructor(fd: number, fileAsset: photoAccessHelper.PhotoAsset) {
    this.fd = fd;
    this.fileAsset = fileAsset;
  }
}

class MediaOverrideTempFile {
  public file: fs.File;
  public path: string = '';

  constructor(file: fs.File, path: string) {
    this.file = file;
    this.path = path;
  }
}