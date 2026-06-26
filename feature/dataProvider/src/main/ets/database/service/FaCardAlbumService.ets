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
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { dataShare, DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy {
  PhotoAlbum,
  PhotoAsset,
  UserFileManagerAccess
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { FormConstants } from '@ohos/common/src/main/ets/default/model/common/FormConstants';
import lazy { HashSet, taskpool } from '@kit.ArkTS';
import lazy { common, sendableContextManager } from '@kit.AbilityKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy ReminderService, { BatchInsertReminderInfo, ImageInfo } from './ReminderService';
import lazy FaCardService, { FaCardInfo } from './FaCardService';
import lazy ImageProxyDataService from './ImageProxyDataService';
import lazy { Context } from '@ohos.arkui.UIContext';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { AssetHelper } from '@ohos/common/src/main/ets/default/utils/AssetHelper';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { formProvider } from '@kit.FormKit';
import lazy {
  AlbumType,
  BigDataConstants,
  IFACardBigDataParams,
  IFACardEditorAction,
  ReportToBigDataUtil,
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { AlbumType as FATableAlbumType } from '../databaseconstant/FaCardTable';
import lazy { FormControllerManager } from '../../controller/FormControllerManager';
import lazy { FormController, insertSendableTask } from '../../controller/FormController';
import lazy DatabaseUtils from '../DatabaseUtils';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy formBindingData from '@ohos.app.form.formBindingData';
import lazy { ImageProxyDataTable } from '../databaseconstant/ImageProxyDataTable';
import lazy { LightGlimpseUtil } from '@ohos/common/src/main/ets/default/utils/LightGlimpseUtil'

const TAG: string = 'FaCardAlbumUtils';

const dsOptions: dataShare.DataShareHelperOptions = {
  isProxy: true,
};

export const PER_TURN_INSERT_AMOUNT = 120;

interface predicatesLimitParam {
  total: number,
  offset: number,
}

interface insertNewTurnInfoI {
  // 最近轮播的图片
  lastCarouselImageInfo: ImageInfo,

  // reminders表中插入的最后一张
  lastImageInfo: ImageInfo,

  // reminders表中可以保留的图片数量
  remainCount: number,
}

export interface uriExistInProxyInfoI {
  uriExistFlag: boolean[],
}

// 获取ImageProxyData表中是否已保存过assets对应的文件
export function getUriExistInProxyInfo(assets: photoAccessHelper.PhotoAsset[],
  resultSet: DataShareResultSet | undefined): uriExistInProxyInfoI {
  if (!resultSet) {
    Log.info(TAG, 'getUriExistInProxyInfo without resultSet');
    return {
      uriExistFlag: new Array(assets.length).fill(false),
    }
  }
  const formPhotoUris: HashSet<string> = new HashSet<string>();
  const uriIndex: number = resultSet.getColumnIndex('uri');
  if (resultSet.goToFirstRow()) {
    const formUri: string = resultSet.getString(uriIndex);
    formPhotoUris.add(formUri);
  }
  while (resultSet.goToNextRow()) {
    const formUri: string = resultSet.getString(uriIndex);
    formPhotoUris.add(formUri);
  }
  Log.info(TAG, `getUriExistInProxyInfo formPhotoUris size: ${formPhotoUris.length}`);
  let uriExistFlag: boolean[] = [];
  for (let i = 0; i < assets.length; i++) {
    uriExistFlag[i] = formPhotoUris.has(assets[i].uri);
  }
  return {
    uriExistFlag: uriExistFlag,
  };
}

// 将asset插入ImageProxyData表和reminders表，ImageProxyData中如果是缩略图，需要替换为lcd（如果存在）
// 仅tv使用
export async function insertTask(result: photoAccessHelper.PhotoAsset[], uriExistFlag: boolean[],
  albumUri: string, context: Context, formId: string) {
  const reminderService: ReminderService = new ReminderService(context);
  const imageProxyDataService: ImageProxyDataService = new ImageProxyDataService(context);
  let reminders: BatchInsertReminderInfo[] = [];
  for (let i = 0; i < result.length; i++) {
    if (FormControllerManager.getTaskPreemptedStatus(formId)) {
      return;
    }
    Log.info('FaCardAlbumUtils', `insert index: ${i} uriExistFlag = ${uriExistFlag[i]} formId = ${formId}`);
    const dateTaken: number = Number(AssetHelper.get(result[i], UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS, 0));
    const dateAdded: number = Number(AssetHelper.get(result[i], UserFileManagerAccess.FILE_KEY_DATE_ADDED_MS, 0));

    if (!uriExistFlag[i]) {
      try {
        Log.info('FaCardAlbumUtils', `getThumbnailData uri = ${result[i].uri} formId = ${formId}`);
        const pixelMapData = await result[i].getThumbnailData(photoAccessHelper.ThumbnailType.LCD);
        const pixelBase64: string = await DatabaseUtils.bufferToBase64(pixelMapData);
        Log.info('FaCardAlbumUtils', `pixelBase64 = ${pixelBase64.length} pixelMapData = ${pixelMapData.byteLength}`);

        const insertNum: number | undefined = await imageProxyDataService.insert(result[i], pixelBase64);
        Log.info('FaCardAlbumUtils',
          `imageProxyDataService insert insertNum = ${insertNum} uri = ${result[i].uri} formId = ${formId}`);
        // instrument ignore next
        if (insertNum !== undefined) {
          reminders.push({ imageUri: result[i].uri, dateTaken, dateAdded });
          Log.info('FaCardAlbumUtils', `get reminder index: ${i}, uri: ${result[i].uri} formId = ${formId}`);
        }
      } catch (error) {
        Log.error(TAG, `imageProxyDataService insert error code: ${error.code}, message: ${error.message})`);
      }
    } else {
      reminders.push({ imageUri: result[i].uri, dateTaken, dateAdded });
      Log.info('FaCardAlbumUtils', `get reminder index: ${i}, uri: ${result[i].uri} formId = ${formId}`);
    }
  }

  if (reminders.length > 0) {
    Log.info('FaCardAlbumUtils', `reminders batchinsert begin formId = ${formId}`);
    const insertNO = await reminderService.batchInsert(formId, albumUri, reminders);
    Log.info('FaCardAlbumUtils', `reminders batchinsert end insertNO = ${insertNO} formId = ${formId}`);
  }
}

export class FaCardAlbumUtils {
  private context: Context;

  constructor(context: Context) {
    this.context = context;
  }

  /**
   * 点击处理
   * @param album
   */
  public async handleClick(album: AlbumInfo, formId: string, interval: number, albumType: AlbumType): Promise<void> {
    Log.info(TAG, `handleClick formId: ${formId} interval: ${interval} albumType: ${
    albumType} album: ${JSON.stringify(album)}`);
    const recordStartTime: number = Date.now();
    const faCardInfo: FaCardInfo = {
      albumUri: album.uri,
      playbackInterval: interval,
      albumType: FATableAlbumType.ALBUM,
      formId: formId,
    }

    Log.info(TAG, `handleClick formId ${formId}, this.interval ${interval}`);
    // instrument ignore if
    if (!album) {
      Log.error(TAG, `handleClick but album is empty`);
      return;
    }
    Log.info(TAG, `handleClick updateFaCardDb`);
    await this.updateFaCardDb(album, faCardInfo);

    const msg: IFACardBigDataParams = {
      formId: formId,
      costTime: Date.now() - recordStartTime,
      albumType: albumType,
      type: IFACardEditorAction.SELECT_ALBUM,
    };
    ReportToBigDataUtil.report(BigDataConstants.CARD_CLICK_SELECTION_DETAIL, msg);
  }

  async updateFaCardDb(album: AlbumInfo, faCardInfo: FaCardInfo): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)) {
      return;
    }
    Log.info(TAG, `updateFaCardDb form_id: ${faCardInfo.formId}`)
    try {
      // 将reminders中formid数据删除
      const reminderService: ReminderService = new ReminderService(this.context);
      const deleteNO = await reminderService.deletePhotosByFormId(faCardInfo.formId, album.uri);
      Log.info(TAG, `deleteByFormId data: ${deleteNO}`);
      // 删除成功，增加相册数据
      // instrument ignore next
      if (deleteNO !== undefined) {
        await this.insertReminderAndImage(album, faCardInfo);
        Log.info(TAG, `updateFaCardDb deleteByFormId success, form_id: ${faCardInfo.formId}, deleteNO: ${deleteNO}`);
      } else {
        Log.error(TAG, `updateFaCardDb deleteByFormId fail, deleteNO: ${deleteNO}`);
      }
    } catch (err) {
      Log.error(TAG, `updateFaCardDb err: ${err}`)
    }
  }

  private async insertReminderAndImage(album: AlbumInfo, faCardInfo: FaCardInfo): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)) {
      return;
    }
    Log.info(TAG, `insertReminderAndImage`);
    UserFileManagerAccess.getInstance().onCreate(this.context);
    let photoAlbum: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(album.uri);
    let result: Array<PhotoAsset> | undefined = undefined;
    let fetchOptions = AlbumDefine.getFileFetchOptWithDate(
      PER_TURN_INSERT_AMOUNT, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE, 0);
    // instrument ignore if
    if (!album) {
      Log.error(TAG, 'insertReminderAndImage without album');
      return;
    }
    Log.info(TAG, 'insertReminderAndImage get photo result success');
    let proxyResultSet: DataShareResultSet | undefined = undefined;
    try {
      let fetchResult = await photoAlbum?.getAssets(fetchOptions);
      result = await fetchResult?.getAllObjects();
      Log.info(TAG, `insertReminderAndImage getAssets result ${result}`);
      // instrument ignore next
      UserFileManagerAccess.getInstance().onCreate(this.context);
      const albumName: string = await UserFileManagerAccess.getInstance().getAlbumNameByAlbumInfo(album, this.context);

      if (result) {
        const callback = async () => {
          Log.info(TAG, `insert end`);
          const faCardService: FaCardService = new FaCardService(this.context);
          let value: ValuesBucket = {
            'album_uri': album.uri,
            'cover_uri': album.coverPhotoUri,
            'album_type': faCardInfo.albumType,
            'playback_interval': faCardInfo.playbackInterval,
            'album_name': albumName,
          };
          Log.info(TAG, `select album value: ${JSON.stringify(value)}`)
          const updateNO = await faCardService.insertOrUpdate(faCardInfo.formId, value);
          Log.info(TAG, `faCardService update ${JSON.stringify(updateNO)}`);
          if (updateNO !== undefined) {
            const appBroadCast = BroadCastManager.getInstance().getBroadCast();
            appBroadCast.emit(BroadCastConstants.FA_INSERT_FIRST_ASSET, [
              faCardInfo.formId, faCardInfo.playbackInterval
            ]);
          }
        }
        const imageProxyDataService = new ImageProxyDataService(this.context);
        proxyResultSet = await imageProxyDataService.queryImageUri();

        const firstAsset = result.shift();
        if (firstAsset) {
          const info: uriExistInProxyInfoI = getUriExistInProxyInfo([firstAsset], proxyResultSet);
          await FormController.insertRemindersAndProxy(faCardInfo.formId, album.uri, [firstAsset], info.uriExistFlag,
            this.context);
        }

        if (FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)) {
          return;
        }

        await callback();

        if (result.length) {
          const info: uriExistInProxyInfoI = getUriExistInProxyInfo(result, proxyResultSet);
          await FormController.insertRemindersAndProxy(faCardInfo.formId, album.uri, result, info.uriExistFlag,
            this.context);
        }
      }
      fetchResult?.close();

    } catch (error) {
      Log.error(TAG, `insertReminderAndImage error ${error}`);
    } finally {
      proxyResultSet?.close();
    }
  }

  async getAlbumAssets(photoAlbum: PhotoAlbum, dateTaken: number, count: number,
    dateAdded?: number): Promise<PhotoAsset[]> {
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      const fetchOptions = AlbumDefine.getFileFetchOptWithDate(count,
        AlbumDefine.FILTER_MEDIA_TYPE_IMAGE, dateTaken, dateAdded);
      fetchResult = await photoAlbum.getAssets(fetchOptions);
      if (!fetchResult) {
        Log.warn(TAG, 'getAlbumAssets with empty dataList');
        return [];
      }
      Log.info(TAG, `getAlbumAssets raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        return [];
      }
      let result: PhotoAsset[] = await fetchResult.getAllObjects();
      return result;
    } catch (err) {
      Log.error(TAG, `getAlbumAssets ,error: ${err?.code}, ${err?.message}`);
      return [];
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  // 从特定dateTaken点往后获取文件资产，如果数量不足，从头获取，并拼接到后方
  async getAssetsByTurn(photoAlbum: PhotoAlbum, dateTaken: number, count: number,
    dateAdded: number): Promise<PhotoAsset[]> {
    let result: PhotoAsset[] = await this.getAlbumAssets(photoAlbum, dateTaken, count, dateAdded);
    Log.info(TAG, `getAlbumAssets result count = ${count} ${JSON.stringify(result)}`);
    if (result.length < count) {
      const tmp = await this.getAlbumAssets(photoAlbum, 0, count - result.length);
      Log.info(TAG, `getAlbumAssets count - result.length = ${count - result.length} tmp ${JSON.stringify(tmp)}`);
      result = result.concat(tmp);
    }

    Log.info(TAG, `getAlbumAssets result ${JSON.stringify(result)}`);
    return result;
  }

  async insertNewTurnReminderAndImage(userFileManagerAccess: UserFileManagerAccess, faCardInfo: FaCardInfo,
    lastCarouselImageInfo: ImageInfo, lastImageInfo: ImageInfo, remainCount: number): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)) {
      return;
    }
    Log.info(TAG,
      `insertNewTurnReminderAndImage, formId: ${faCardInfo.formId}, albumUri: ${faCardInfo.albumUri} lastImageInfo = ${
      JSON.stringify(lastImageInfo)} lastCarouselImageInfo = ${JSON.stringify(lastCarouselImageInfo)}`);
    const perTurnInsertAmount = 30 * 60 / faCardInfo.playbackInterval;
    if (!faCardInfo.albumUri) {
      return;
    }
    const photoAlbum: PhotoAlbum =
      await userFileManagerAccess.getAlbumByUri(faCardInfo.albumUri) as PhotoAlbum;
    const reminderService: ReminderService = new ReminderService(this.context);
    if (!photoAlbum) {
      return;
    }

    let imageCount: number | undefined = undefined;
    if (photoAlbum.albumType === photoAccessHelper.AlbumType.SMART) {
      imageCount = photoAlbum.count == 0 ? 0 :
        await PhotoAccessHelperAccess.getSmartAlbumMediaTypeCount(photoAlbum, UserFileManagerAccess.MEDIA_TYPE_IMAGE);
    } else {
      imageCount = photoAlbum.imageCount;
    }

    Log.info(TAG, `insertNewTurnReminderAndImage imageCount = ${imageCount}`);
    if (!imageCount) {
      return;
    }

    let result: PhotoAsset[] = [];
    // 相册数据量小于一批轮播数
    if (imageCount <= perTurnInsertAmount) {
      await reminderService.deleteByFormIdAndIdWithOption(faCardInfo.formId, lastCarouselImageInfo.id,
        ReminderService.OPT_NOT_EQUAL);
      await reminderService.updateRegisterForPhotosAndAlbums(faCardInfo.formId, [lastCarouselImageInfo.imageUri],
        faCardInfo.albumUri);
      result = await this.getAssetsByTurn(photoAlbum, lastCarouselImageInfo.dateTaken, imageCount - 1,
        lastCarouselImageInfo.dateAdded);
      // 相册数据量大于一批轮播数，remainCount为当前轮播图片中继续保留的数量，不等式理论上总成立
    } else if (perTurnInsertAmount > remainCount) {
      result = await this.getAssetsByTurn(photoAlbum, lastImageInfo.dateTaken,
        perTurnInsertAmount - remainCount, lastImageInfo.dateAdded);
      const remainImagesInfo: ImageInfo[] = await reminderService.queryRemainImagesInfo(faCardInfo.formId,
        lastCarouselImageInfo);
      await reminderService.updateRegisterForPhotosAndAlbums(faCardInfo.formId,
        [lastCarouselImageInfo.imageUri, ...remainImagesInfo.map(item => item.imageUri)],
        faCardInfo.albumUri);
      // 超过240删除
      await reminderService.deleteByFormIdAndIdWithOption(faCardInfo.formId, lastCarouselImageInfo.id,
        ReminderService.OPT_LESS_THAN);
    } else {
      Log.error(TAG, `insertNewTurnReminderAndImage count error, imageCount is ${imageCount}, ` +
        `perTurnInsertAmount is ${perTurnInsertAmount}, remainCount is ${remainCount}`);
    }
    Log.info(TAG, `insertNewTurnReminderAndImage result.length = ${result.length}`);

    if (!result || !result.length) {
      return;
    }

    let proxyResultSet: DataShareResultSet | undefined = undefined;
    // instrument ignore next
    try {
      const imageProxyDataService = new ImageProxyDataService(this.context);
      proxyResultSet = await imageProxyDataService.queryImageUri();

      if (result.length) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo(result, proxyResultSet);
        await FormController.insertRemindersAndProxy(faCardInfo.formId, faCardInfo.albumUri, result,
          info.uriExistFlag, this.context);
      }
      Log.info(TAG, `insertNewTurnReminderAndImage end`);
    } catch (error) {
      Log.error(TAG, `insertNewTurnReminderAndImage error code: ${error.code}, message: ${error.message})`);
    } finally {
      proxyResultSet?.close();
    }
  }

  public static async insertSinglePhoto(asset: PhotoAsset, albumUri: string, context: Context,
    formId: string): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(formId)) {
      Log.info(TAG, `insertSinglePhoto return`);
      return;
    }
    let proxyResultSet: DataShareResultSet | undefined = undefined;
    // instrument ignore next
    try {
      Log.info(TAG, `insertSinglePhoto start, asset uri: ${asset.uri}, albumUri: ${albumUri}, formId: ${formId}`);
      if (!context) {
        Log.error(TAG, `insertSinglePhoto error without context, context is ${context}`);
        return;
      }

      const imageProxyDataService: ImageProxyDataService = new ImageProxyDataService(context);
      const reminderService: ReminderService = new ReminderService(context);
      proxyResultSet = await imageProxyDataService.queryImageProxyDataByUri(asset.uri);
      const info: uriExistInProxyInfoI = getUriExistInProxyInfo([asset], proxyResultSet);
      let reminders: BatchInsertReminderInfo[] = [];
      const dateTaken: number = Number(AssetHelper.get(asset, UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS, 0));
      const dateAdded: number = Number(AssetHelper.get(asset, UserFileManagerAccess.FILE_KEY_DATE_ADDED_MS, 0));

      let insertNum: number | undefined = 0;
      if (!info.uriExistFlag[0]) {
        insertNum = await imageProxyDataService.insertOriginalPhoto(asset, true, formId);
        Log.info(TAG,
          `imageProxyDataService insert insertNum = ${insertNum} uri = ${asset.uri} formId = ${formId}`);
      } else {
        Log.info(TAG, `imageProxyData has uri: ${asset.uri} formId = ${formId}`);
        if (proxyResultSet) {
          proxyResultSet.goToFirstRow();
          const blobIdx: number = proxyResultSet.getColumnIndex(ImageProxyDataTable.BLOB);
          const boundIdx: number = proxyResultSet.getColumnIndex(ImageProxyDataTable.BOUND);
          const imageValue: ValuesBucket = {
            uri: asset.uri,
            photo_blob: proxyResultSet.getString(blobIdx),
            photo_bound: proxyResultSet.getString(boundIdx)
          };
          await FaCardAlbumUtils.updateFormById(formId, imageValue);
        }
      }
      if (insertNum !== undefined) {
        reminders.push({ imageUri: asset.uri, dateTaken, dateAdded });
        Log.info(TAG, `get reminder uri= ${asset.uri}, formId = ${formId}`);
      }

      if (reminders.length > 0) {
        Log.info(TAG, `reminders batchinsert begin formId = ${formId}`);
        const insertNO = await reminderService.batchInsert(formId, albumUri, reminders);
        Log.info(TAG, `reminders batchinsert end insertNO = ${insertNO} formId = ${formId}`);
      }

      Log.info(TAG, `insertSinglePhoto end`);
    } catch (error) {
      Log.error(TAG, `insertSinglePhoto error: ${error}`);
    } finally {
      proxyResultSet?.close();
    }
  }

  // 文件资产插入到数据表中
  public static async insertRemindersAndProxy(assets: PhotoAsset[], albumUri: string, context: Context,
    formId: string, callback?: Function): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(formId)) {
      return;
    }
    let proxyResultSet: DataShareResultSet | undefined = undefined;
    try {
      Log.info(TAG, `insertRemindersAndProxy start, assets size: ${assets.length}, albumUri: ${albumUri},
        formId: ${formId}`);
      // instrument ignore if
      if (!context || !assets.length) {
        Log.error(TAG, `insertRemindersAndProxy error without context or result, context is ${context}`);
        return;
      }
      // assets去重
      const assetsMap: Record<string, PhotoAsset> = {};
      assets.forEach(asset => {
        assetsMap[asset.uri] = asset;
      });
      const result = Object.values(assetsMap);
      Log.info(TAG, `insertRemindersAndProxy result size: ${result.length}`);

      const imageProxyDataService: ImageProxyDataService = new ImageProxyDataService(context);
      proxyResultSet = await imageProxyDataService.queryImageUri();

      const firstAsset = result.shift();
      // 插入第一张图片
      if (firstAsset) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo([firstAsset], proxyResultSet);
        await insertTask([firstAsset], info.uriExistFlag, albumUri, context, formId);
      }
      if (callback) {
        await callback();
      }
      // 除第一张以外的其他图片子线程插入
      // instrument ignore if
      if (result.length) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo(result, proxyResultSet);
        Log.info(TAG, `taskpool result: ${result.length}, uriExistFlag: ${info.uriExistFlag}, albumUri: ${albumUri},
          context: ${context}, formId: ${formId}`);
        // formContext存在说明图库存活
        if (AppStorage.has('formContext')) {
          Log.info(TAG, `AppStorage has formContext`);
          let formContext = AppStorage.get('formContext') as Context;
          // 先转化为sendableContext, 传递后再转换为Context
          let task: taskpool.Task = new taskpool.Task(insertSendableTask, result, info.uriExistFlag, albumUri,
            sendableContextManager.convertFromContext(formContext), formId);
          Log.info(TAG, `formId: ${formId}, setPoolTask: ${task.taskId}`);
          await FormControllerManager.getInstance(context).addPoolTask(formId, task);
          await taskpool.execute(task);
        } else {
          Log.info(TAG, `AppStorage does not has formContext`);
          await insertTask(result, info.uriExistFlag, albumUri, context, formId);
        }
      }
      Log.info(TAG, `insertRemindersAndProxy end`);
    } catch (error) {
      Log.error(TAG, `insertRemindersAndProxy error: ${error}`);
    } finally {
      proxyResultSet?.close();
    }
  }

  // 空卡片插入数据
  async insertNewTurnInBlankFACard(userFileManagerAccess: UserFileManagerAccess, faCardInfo: FaCardInfo) {
    if (FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)) {
      return;
    }
    Log.info(TAG, `insertNewTurnInBlankFACard, formId: ${faCardInfo.formId}, albumUri: ${faCardInfo.albumUri}`);
    // instrument ignore if
    if (!faCardInfo.albumUri) {
      return;
    }
    const photoAlbum: PhotoAlbum =
      await userFileManagerAccess.getAlbumByUri(faCardInfo.albumUri) as PhotoAlbum;
    const reminderService: ReminderService = new ReminderService(this.context);
    const faCardService: FaCardService = new FaCardService(this.context);
    // instrument ignore if
    if (!photoAlbum) {
      return;
    }

    let imageCount: number | undefined = undefined;
    if (photoAlbum.albumType === photoAccessHelper.AlbumType.SMART) {
      imageCount = photoAlbum.count == 0 ? 0 :
        await PhotoAccessHelperAccess.getSmartAlbumMediaTypeCount(photoAlbum, UserFileManagerAccess.MEDIA_TYPE_IMAGE);
    } else {
      imageCount = photoAlbum.imageCount;
    }

    Log.info(TAG, `insertNewTurnInBlankFACard imageCount = ${imageCount}`);
    if (!imageCount) {
      return;
    }

    let result: PhotoAsset[] = [];
    await reminderService.deletePhotosByFormId(faCardInfo.formId, faCardInfo.albumUri);
    result = await this.getAlbumAssets(photoAlbum, 0, PER_TURN_INSERT_AMOUNT);
    Log.info(TAG, `insertNewTurnInBlankFACard result.length = ${result?.length}`);
    if (!result || !result.length) {
      Log.info(TAG, `insertNewTurnInBlankFACard without assets`);
      return;
    }

    let proxyResultSet: DataShareResultSet | undefined = undefined;
    try {
      const imageProxyDataService = new ImageProxyDataService(this.context);
      proxyResultSet = await imageProxyDataService.queryImageUri();

      if (result.length) {
        const info: uriExistInProxyInfoI = getUriExistInProxyInfo(result, proxyResultSet);
        await FormController.insertRemindersAndProxy(faCardInfo.formId, faCardInfo.albumUri, result,
          info.uriExistFlag, this.context);
      }
    } catch (error) {
      Log.error(TAG, `insertNewTurnInBlankFACard error code: ${error.code}, message: ${error.message})`);
    } finally {
      proxyResultSet?.close();
    }
    let value: ValuesBucket = {
      'cover_uri': result[0].uri,
    };
    await faCardService.update(faCardInfo.formId, value);

    Log.info(TAG, `insertNewTurnInBlankFACard insert end`);
  }

  async insertNewTurnByFormId(userFileManagerAccess: UserFileManagerAccess, faCardInfo: FaCardInfo,
    newTurnInfo?: insertNewTurnInfoI) {
    if (FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)) {
      return;
    }
    const recordStartTime: number = Date.now();
    if (newTurnInfo) {
      const lastCarouselImageInfo: ImageInfo = newTurnInfo.lastCarouselImageInfo;
      const lastImageInfo: ImageInfo = newTurnInfo.lastImageInfo;
      const remainCount: number = newTurnInfo.remainCount;
      await this.insertNewTurnReminderAndImage(
        userFileManagerAccess, faCardInfo, lastCarouselImageInfo, lastImageInfo, remainCount);
    } else {
      await this.insertNewTurnInBlankFACard(userFileManagerAccess, faCardInfo);
    }

    const msg: IFACardBigDataParams = {
      formId: faCardInfo.formId,
      costTime: Date.now() - recordStartTime,
    };
    ReportToBigDataUtil.report(BigDataConstants.CARD_INSERT_NEW_TURN, msg);
  }

  public static terminate(): void {
    const context: common.UIAbilityContext =
      AppStorage.get<common.UIAbilityContext>('formContext') as common.UIAbilityContext;
    if (context) {
      context.terminateSelf((result: BusinessError<void>): void => {
        Log.info(TAG, `terminateSelf result: ${JSON.stringify(result)}`);
      })
    }
  }

  public static updateScheduler(formId: string, interval: number, withOutTerminate?: boolean, context?: Context): void {
    Log.info(TAG, `updateScheduler formId: ${formId} interval: ${interval} withOutTerminate: ${withOutTerminate}`)
    try {
      const formContext: Context | undefined = context || AppStorage.get<Context>('formContext') as Context;
      if (!formContext) {
        Log.error(TAG, `updateScheduler formContext is undefined`);
        return;
      }
      let lightGlimpseFlag: boolean = LightGlimpseUtil.getSystemLightGlimpse();
      let agendaSql: string = lightGlimpseFlag ? FormConstants.QUERY_VALID_AGENDA_SQL_WITH_LIGHT_GLIMPSE :
        FormConstants.QUERY_VALID_AGENDA_SQL;
      const template: dataShare.Template = {
        predicates: {
          'agendaObjList': agendaSql.replace('?', formId)
        },
        scheduler: FormConstants.REFRESH_CARD_SQL.replace(FormConstants.SQL_REPLACE_TIME_OFFSET, String(interval))
          .replace('?', formId),
        update: FormConstants.UPDATE_CARD_SQL.replaceAll('?', formId),
      };

      const templateUri: string = 'datashareproxy://com.ohos.photos/facard_metadata';
      // instrument ignore next
      dataShare.createDataShareHelper(formContext, 'datashareproxy://com.ohos.photos', dsOptions)
        .then((dataShareHelper) => {
          Log.info(TAG, 'DataShare createDataShareHelper, subscriberId ' + formId);
          dataShareHelper.delTemplate(templateUri, formId);
          Log.info(TAG, 'DataShare delTemplate, subscriberId ' + formId);
          dataShareHelper.addTemplate(templateUri, formId, template);
          Log.info(TAG, 'DataShare addTemplate, subscriberId ' + formId);

          if (!withOutTerminate) {
            FaCardAlbumUtils.terminate();
          }
        })
        .catch(() => {
          Log.info(TAG, 'createDataShareHelper, failed ' + formId);
          const msg: IFACardBigDataParams = { 'formId': formId, cardType: FATableAlbumType.ALBUM };
          ReportToBigDataUtil.report(BigDataConstants.CREATE_DATA_SHARE_FAIL, msg);
        })
    } catch (err) {
      Log.error(TAG, `updateScheduler err: ${err}`);
    }
  }

  // 人像卡片状态更新
  public static updatePortraitScheduler(formId: string, interval: number,
    withOutTerminate?: boolean, context?: Context): void {
    Log.info(TAG,
      `updatePortraitScheduler formId: ${formId} withOutTerminate: ${withOutTerminate}`);
    try {
      const formContext: Context | undefined = context || AppStorage.get<Context>('formContext') as Context;
      if (!formContext) {
        Log.error(TAG, `updatePortraitScheduler formContext is undefined`);
        return;
      }

      const template: dataShare.Template = {
        predicates: {
          'agendaObjList': FormConstants.QUERY_VALID_AGENDA_SQL_WITH_PORTRAIT.replace('?', formId)
        },
        scheduler: FormConstants.REFRESH_CARD_SQL.replace(FormConstants.SQL_REPLACE_TIME_OFFSET, String(interval))
          .replace('?', formId),
        update: FormConstants.UPDATE_CARD_SQL.replaceAll('?', formId),
      };

      const templateUri: string = 'datashareproxy://com.ohos.photos/facard_metadata';
      // instrument ignore next
      dataShare.createDataShareHelper(formContext, 'datashareproxy://com.ohos.photos', dsOptions)
        .then((dataShareHelper) => {
          Log.info(TAG, 'DataShare createDataShareHelper, subscriberId ' + formId);
          dataShareHelper.delTemplate(templateUri, formId);
          Log.info(TAG, 'DataShare delTemplate, subscriberId ' + formId);
          dataShareHelper.addTemplate(templateUri, formId, template);
          Log.info(TAG, 'DataShare addTemplate, subscriberId ' + formId);

          if (!withOutTerminate) {
            FaCardAlbumUtils.terminate();
          }
        })
        .catch(() => {
          Log.error(TAG, 'createDataShareHelper, failed ' + formId);
          const msg: IFACardBigDataParams = { 'formId': formId, cardType: FATableAlbumType.PORTRAIT_ALBUM };
          ReportToBigDataUtil.report(BigDataConstants.CREATE_DATA_SHARE_FAIL, msg);
        })
    } catch (err) {
      Log.error(TAG, `updatePortraitScheduler err: ${err}`);
    }
  }

  public static updateHighlightScheduler(formId: string, interval: number, withOutTerminate?: boolean,
    context?: Context): void {
    Log.info(TAG, `updateHighlightScheduler formId: ${formId} interval: ${
    interval} withOutTerminate: ${withOutTerminate}`);
    try {
      const formContext: Context | undefined = context || AppStorage.get<Context>('formContext') as Context;
      if (!formContext) {
        Log.error(TAG, 'updateHighlightScheduler formContext is undefined');
        return;
      }
      const template: dataShare.Template = {
        predicates: {
          'agendaObjList': FormConstants.QUERY_VALID_HIGHLIGHT_AGENDA_SQL.replace('?', formId)
        },
        scheduler: FormConstants.REFRESH_HIGHLIGHT_CARD_SQL.replace(FormConstants.SQL_REPLACE_TIME_OFFSET,
          String(interval)).replace('?', formId),
        update: FormConstants.UPDATE_HIGHLIGHT_CARD_SQL.replaceAll('?', formId),
      };

      const templateUri: string = 'datashareproxy://com.ohos.photos/facard_metadata';
      // instrument ignore next
      dataShare.createDataShareHelper(formContext, 'datashareproxy://com.ohos.photos', dsOptions)
        .then((dataShareHelper) => {
          Log.info(TAG, 'DataShare createDataShareHelper, subscriberId ' + formId);
          dataShareHelper.delTemplate(templateUri, formId);
          Log.info(TAG, 'DataShare delTemplate, subscriberId ' + formId);
          dataShareHelper.addTemplate(templateUri, formId, template);
          Log.info(TAG, 'DataShare addTemplate, subscriberId ' + formId);

          if (!withOutTerminate) {
            FaCardAlbumUtils.terminate();
          }
        })
        .catch(() => {
          Log.info(TAG, 'createDataShareHelper, failed ' + formId);
          const msg: IFACardBigDataParams = { 'formId': formId, cardType: FATableAlbumType.HIGHLIGHT_ALBUM };
          ReportToBigDataUtil.report(BigDataConstants.CREATE_DATA_SHARE_FAIL, msg);
        })
    } catch (err) {
      Log.error(TAG, `updateHighlightScheduler err: ${err}`);
    }
  }

  public static async updateFormById(formId: string, imageValue: ValuesBucket) {
    Log.info(TAG, `updateFormById start ${formId}`);
    const imageItem: ValuesBucket = {
      image_uri: imageValue.uri,
      image_data: imageValue.photo_blob,
      photo_bound: imageValue.photo_bound
    };
    const formData: Record<string, Object> = {};
    formData['agendaObjList'] = [imageItem];
    const formBinding: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    await formProvider.updateForm(formId, formBinding);
    Log.info(TAG, `updateFormById end ${formId}`);
  }

  async updateForm(faCardInfo: FaCardInfo, context: Context): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)) {
      return;
    }
    const formId: string = faCardInfo.formId;
    const userFileManagerAccess: UserFileManagerAccess = new UserFileManagerAccess();
    userFileManagerAccess.onCreate(context);
    try {
      if (faCardInfo.albumType === FATableAlbumType.SINGLE) {
        const reminderService: ReminderService = new ReminderService(context);
        const imageInfo: ImageInfo | undefined = await reminderService.queryImageInfoForSingleAlbum(formId);
        if (imageInfo?.isHidden) {
          const asset = await userFileManagerAccess.getPhotoAssetByUri(imageInfo.imageUri);
          // 若被软删图片不在回收站内，则恢复图片
          if (asset) {
            await reminderService.updateIsHiddenById(0, imageInfo.id);
          }
        }
      } else if (faCardInfo.albumType === FATableAlbumType.HIGHLIGHT_ALBUM) {
        Log.info(TAG, `updateForm highlight album, formId: ${faCardInfo.formId}`);
      } else {
        const photoAlbum: PhotoAlbum =
          await userFileManagerAccess.getAlbumByUri(faCardInfo.albumUri) as PhotoAlbum;
        // instrument ignore else
        if (photoAlbum === undefined) {
          Log.info(TAG, `updateForm album not found, formId: ${formId}, albumUri: ${faCardInfo.albumUri}`);
          // 删除卡片reminder数据
          const reminderService: ReminderService = new ReminderService(context);
          await reminderService.deletePhotosByFormId(formId, undefined);
          // 相册被删除时，立即将卡片内容清空，避免继续显示已删除相册的旧图片
          const formData: Record<string, Object> = {};
          formData['agendaObjList'] = [];
          const formBinding: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
          await formProvider.updateForm(formId, formBinding);
        } else {
          Log.info(TAG, `updateForm album exists, formId: ${formId}, albumUri: ${photoAlbum.albumUri}`);
          const reminderService: ReminderService = new ReminderService(context);
          const lastImageInfo: ImageInfo | undefined = await reminderService.queryLastImageInfo(formId);
          const lastCarouselImageInfo: ImageInfo | undefined = await reminderService.queryLastImageInfo(formId, true);

          Log.info(TAG, `onChangeFormVisibility, lastImageInfo: ${JSON.stringify(lastImageInfo)},
        lastCarouselImageInfo: ${JSON.stringify(lastCarouselImageInfo)}`);
          if (lastImageInfo && lastCarouselImageInfo) {
            const remainCount = await reminderService.queryRemainCount(formId, lastCarouselImageInfo);
            const insertTurnInfo: insertNewTurnInfoI = {
              lastCarouselImageInfo: lastCarouselImageInfo,
              lastImageInfo: lastImageInfo,
              remainCount: remainCount,
            }
            await this.insertNewTurnByFormId(userFileManagerAccess, faCardInfo, insertTurnInfo);
          } else {
            // 空图库创建空卡片场景，无上次播放数据，需要重新插入
            await this.insertNewTurnByFormId(userFileManagerAccess, faCardInfo);
            FaCardAlbumUtils.updateScheduler(formId, faCardInfo.playbackInterval, true);
          }
        }
      }
    } catch (error) {
      Log.error(TAG, `updateForm error code: ${error.code}, message: ${error.message})`)
    } finally {
      userFileManagerAccess.onDestroy();
    }
  }

  async updatePortraitForm(faCardInfo: FaCardInfo, context: Context): Promise<void> {
    if (FormControllerManager.getTaskPreemptedStatus(faCardInfo.formId)) {
      return;
    }
    Log.info(TAG, `updatePortraitForm start ${JSON.stringify(faCardInfo)}`);
    const formId: string = faCardInfo.formId;
    const userFileManagerAccess: UserFileManagerAccess = new UserFileManagerAccess();
    userFileManagerAccess.onCreate(context);
    try {
      const photoAlbum: PhotoAlbum =
        await userFileManagerAccess.getAlbumByUri(faCardInfo.albumUri) as PhotoAlbum;
      Log.info(TAG, `updatePortraitForm albumUri: ${photoAlbum?.albumUri}, coverUri: ${photoAlbum?.coverUri}`);
      // instrument ignore else
      if (photoAlbum === undefined) {
        // 删除卡片reminder数据
        const reminderService: ReminderService = new ReminderService(context);
        await reminderService.deletePhotosByFormId(formId, undefined);
      } else {
        const reminderService: ReminderService = new ReminderService(context);
        const lastImageInfo: ImageInfo | undefined = await reminderService.queryLastImageInfo(formId);
        const lastCarouselImageInfo: ImageInfo | undefined = await reminderService.queryLastImageInfo(formId, true);

        Log.info(TAG, `onChangeFormVisibility, lastImageInfo: ${JSON.stringify(lastImageInfo)
        },lastCarouselImageInfo: ${JSON.stringify(lastCarouselImageInfo)}`);
        if (lastImageInfo && lastCarouselImageInfo) {
          const remainCount = await reminderService.queryRemainCount(formId, lastCarouselImageInfo);
          const insertTurnInfo: insertNewTurnInfoI = {
            lastCarouselImageInfo: lastCarouselImageInfo,
            lastImageInfo: lastImageInfo,
            remainCount: remainCount,
          }
          await this.insertNewTurnByFormId(userFileManagerAccess, faCardInfo, insertTurnInfo);
        } else {
          // 空图库创建空卡片场景，无上次播放数据，需要重新插入
          await this.insertNewTurnByFormId(userFileManagerAccess, faCardInfo);
          FaCardAlbumUtils.updatePortraitScheduler(formId, faCardInfo.playbackInterval, true, context);
        }
      }
    } catch (error) {
      Log.error(TAG, `updateForm error code: ${error.code}, message: ${error.message})`)
    } finally {
      userFileManagerAccess.onDestroy();
    }
  }
}