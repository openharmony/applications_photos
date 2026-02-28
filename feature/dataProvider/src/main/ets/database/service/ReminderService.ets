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
import lazy { dataSharePredicates, DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy DBHelper from '../DBHelper';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy BaseDatashare from './BaseDatashare';
import lazy { RemindersTable, ReminderTableConstants } from '../databaseconstant/RemindersTable';
import lazy { HashMap } from '@kit.ArkTS';
import lazy ImageProxyDataService from './ImageProxyDataService';
import lazy DatabaseUtils from '../DatabaseUtils';

const TAG: string = 'ReminderService';

export interface ImageInfo {
  id: number,
  formId: number,
  imageUri: string,
  showTime: number,
  albumUri: string,
  isHidden: number,
  dateTaken: number,
  dateAdded: number,
}

export interface BatchInsertReminderInfo {
  imageUri: string,
  dateTaken: number,
  dateAdded: number,
}

export interface ReminderInfo {
  id: string,
  formId: string,
  imageUri: string,
  isHidden: string,
}


export default class ReminderService extends BaseDatashare {
  // LESS_THAN：只操作小于id的
  public static OPT_LESS_THAN: string = 'OPT_LESS_THAN';
  // OPT_NOT_EQUAL：只操作不等于此id的
  public static OPT_NOT_EQUAL: string = 'OPT_NOT_EQUAL';
  // DEFAULT：默认全操作
  public static OPT_DEFAULT: string = 'OPT_DEFAULT';

  constructor(context: Context) {
    super(context, 'datashare:///hmos_photodata/reminders');
  }

  private aggregateMax(field: string){
    return 'MAX(' + field + ')';
  }

  private aggregateMin(field: string){
    return 'MIN(' + field + ')';
  }

  private aggregateSum(field: string){
    return 'SUM(' + field + ')';
  }

  private aggregateAvg(field: string){
    return 'AVG(' + field + ')';
  }

  async batchInsert(formId: string, albumUri: string,
    reminderInfos: BatchInsertReminderInfo[]): Promise<number | undefined> {
    Log.info(TAG, `batchInsert, formId = ${formId}, albumUri = ${albumUri}`);

    try {
      const reminderBuckets: ValuesBucket[] = [];
      for (const reminder of reminderInfos) {
        const reminderBucket: ValuesBucket = {
          'form_id': formId,
          'image_uri': reminder.imageUri,
          'show_time': 0,
          'album_uri': albumUri,
          'is_hidden': 0,
          'date_taken': reminder.dateTaken,
          'date_added': reminder.dateAdded,
          'image_uri_id': DatabaseUtils.extractAssetUri(reminder.imageUri),
        }
        reminderBuckets.push(reminderBucket);
      }

      const insertNO = await this.mBatchInsert(reminderBuckets);
      Log.info(TAG, `batchInsert inserted ${insertNO} reminders.`);

      if (insertNO !== undefined) {
        const imageUris = reminderInfos.map(x => x.imageUri);
        await this.registerForPhotosAndAlbums(formId, imageUris);
      }
      return insertNO;
    } catch (error) {
      Log.error(TAG, `batchInsert failed: ${error}`);
      return undefined;
    }
  }

  public async updateRegisterForPhotosAndAlbums(formId: string, assetUris: string[], albumUri?: string): Promise<void> {
    Log.info(TAG, `updateRegisterForPhotosAndAlbums， ${formId}`);
    UserFileManagerAccess.getInstance().onCreate(this.context);
    let photoAccessHelper: photoAccessHelper.PhotoAccessHelper =
      UserFileManagerAccess.getInstance().getMediaLibrary();
    if (photoAccessHelper) {
      let extractedAssetUris: string[] = DatabaseUtils.extractAssetUriPaths(assetUris);
      Log.info(TAG, `updateRegisterForPhotosAndAlbums: ${assetUris.length}，${JSON.stringify(extractedAssetUris)},
        albumUri: ${albumUri}, ${[...assetUris, albumUri]}`);
      try {
        await photoAccessHelper.updateGalleryFormInfo({
          formId: formId,
          assetUris: albumUri ? [...extractedAssetUris, albumUri] : extractedAssetUris,
        });
      } catch (err) {
        Log.error(TAG, `updateRegisterForPhotosAndAlbums failed, error message: ${err}`);
      }
    } else {
      Log.error(TAG, 'updateRegisterForPhotosAndAlbums is null!');
    }
  }

  public async registerForPhotosAndAlbums(formId: string, assetUris: string[], albumUri?: string): Promise<void> {
    Log.info(TAG, `registerForPhotosAndAlbums， ${formId}`);
    UserFileManagerAccess.getInstance().onCreate(this.context);
    let photoAccessHelper: photoAccessHelper.PhotoAccessHelper =
      UserFileManagerAccess.getInstance().getMediaLibrary();
    if (photoAccessHelper) {
      let extractedAssetUris: string[] = DatabaseUtils.extractAssetUriPaths(assetUris);
      Log.info(TAG, `registerForPhotosAndAlbums: ${assetUris.length}，${JSON.stringify(extractedAssetUris)},
        albumUri: ${albumUri}, ${[...assetUris, albumUri]}`);
      try {
        await photoAccessHelper.saveGalleryFormInfo({
          formId: formId,
          assetUris: albumUri ? [...extractedAssetUris, albumUri] : extractedAssetUris,
        });
      } catch (err) {
        Log.error(TAG, `registerForPhotosAndAlbums failed, error message: ${err}`);
      }
    } else {
      Log.error(TAG, 'registerForPhotosAndAlbums is null!');
    }
  }

  public async unregisterForPhotosAndAlbums(formId: string): Promise<void> {
    UserFileManagerAccess.getInstance().onCreate(this.context);
    let photoAccessHelper: photoAccessHelper.PhotoAccessHelper =
      UserFileManagerAccess.getInstance().getMediaLibrary();
    Log.info(TAG, `unregisterForPhotosAndAlbums, ${formId}`);
    if (photoAccessHelper) {
      Log.info(TAG, `unregisterForPhotosAndAlbums, ${formId}`);
      try {
        await photoAccessHelper.removeGalleryFormInfo({
          formId: formId,
          assetUris: [],
        });
      } catch (err) {
        Log.error(TAG, `unregisterForPhotosAndAlbums failed, error message: ${err}`);
      }
    } else {
      Log.error(TAG, 'unregisterForPhotosAndAlbums is null!');
    }
  }

  async deleteByFormId(formId: string): Promise<number | undefined> {
    Log.info(TAG, `deleteByFormId, ${formId}`);
    const deleteNO = await super.deleteByFormId(formId);
    await this.unregisterForPhotosAndAlbums(formId);
    return deleteNO;
  }

  // 删除reminders中的图片，仅删除图片监听
  async deletePhotosByFormId(formId: string, albumUri?: string): Promise<number | undefined> {
    Log.info(TAG, `deletePhotosByFormId formId is ${formId}, albumUri is ${albumUri}`);
    const deleteNO = await this.deleteByFormId(formId);
    await this.registerForPhotosAndAlbums(formId, [], albumUri);
    return deleteNO;
  }

  /**
   * 通过fromId和Id删除数据
   *
   * @param formId 卡片formId
   * @param id 用于操作
   * @param option 具体操作类型
   * @returns
   */
  async deleteByFormIdAndIdWithOption(formId: string, id: number, option: string): Promise<number | undefined> {
    Log.info(TAG, `deleteByFormIdAndIdWithOption, formId:${formId}, id:${id}, option:${option}`);
    if (!this.context) {
      Log.info(TAG, `deleteByFormIdAndIdWithOption context undefined`);
      return undefined;
    }
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    switch (option) {
      case ReminderService.OPT_LESS_THAN:
        predicates.lessThan(RemindersTable.ID, id);
        break;
      case ReminderService.OPT_NOT_EQUAL:
        predicates.notEqualTo(RemindersTable.ID, id);
        break;
      case ReminderService.OPT_DEFAULT:
      default:
        Log.info(TAG, `deleteByFormIdAndIdWithOption option default.`);
        break;
    }
    Log.info(TAG, 'deleteByFormIdAndIdWithOption  formId: ' + formId);
    try {
      const deleteNO = await DBHelper.getInstance(this.context).doDelete(this.uri, predicates, this.context);
      return deleteNO;
    } catch (error) {
      Log.error(TAG, `deleteByFormIdAndIdWithOption error ${error}`);
      return undefined;
    }
  }

  /**
   * 清空卡片的时候，需要清空此卡片独有的proxy表中image数据
   *
   * @param formId 卡片ID
   * @param id 用于操作
   * @param option 具体操作类型
   * @returns
   */
  async clearImageProxyByFormId(formId: string, id?: number, option?: string) {
    Log.info(TAG, `clearImageProxyByFormId in.`);
    try {
      let uniqueImageUriList = await this.getUniqueImageUriList(formId, id, option);
      const imageProxyDataService: ImageProxyDataService = new ImageProxyDataService(this.context);
      await imageProxyDataService.batchDeleteByUri(uniqueImageUriList);
    } catch (err) {
      Log.error(TAG, `clearFormProxyByFormId,err.code:${err?.code},err.msg:${err?.msg}`);
    }
  }

  /**
   * 找到只有此formId卡片使用的图片的uriList
   *
   * @param formId 卡片formId
   * @param id 用于操作
   * @param option 具体操作类型
   * @returns string[]
   */
  async getUniqueImageUriList(formId: string, id?: number, option?: string): Promise<string[]> {
    let uniqueImageUriList: string[] = [];
    try {
      const reminderService: ReminderService = new ReminderService(this.context);
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      const queryResult = await reminderService.mQuery(predicates, ['_id', 'form_id', 'image_uri']);
      Log.info(TAG, `getUniqueImageUriList queryResult count: ${queryResult?.rowCount}`);
      let existImageUriMap: HashMap<string, string> = new HashMap();
      let uniqueImageUriSet: Set<string> = new Set();
      // instrument ignore next
      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToFirstRow();
        for (let i = 0; i < queryResult.rowCount; i++) {
          const idIndex: number = queryResult.getColumnIndex('_id');
          const tmpId: number = Number(queryResult.getString(idIndex));
          const formIdIndex: number = queryResult.getColumnIndex('form_id');
          const tmpFormId: string = String(queryResult.getString(formIdIndex));
          const imageUriIndex: number = queryResult.getColumnIndex('image_uri');
          const tmpImageUri: string = String(queryResult.getString(imageUriIndex));
          if ((tmpFormId === formId) && option && (id != undefined)) {
            if ((option === ReminderService.OPT_LESS_THAN) && (tmpId >= id)) {
              Log.info(TAG, `getUniqueImageUriList option OPT_LESS_THAN pass.`);
              continue;
            } else if ((option === ReminderService.OPT_NOT_EQUAL) && (tmpId === id)) {
              Log.info(TAG, `getUniqueImageUriList option OPT_NOT_EQUAL pass.`);
              continue;
            } else {
              Log.info(TAG, `getUniqueImageUriList option default.`);
            }
          }
          if (existImageUriMap.hasKey(tmpImageUri)) {
            uniqueImageUriSet.delete(tmpImageUri);
          } else {
            existImageUriMap.set(tmpImageUri, tmpFormId);
            if (tmpFormId === formId) {
              uniqueImageUriSet.add(tmpImageUri);
            }
          }
          queryResult.goToNextRow();
        }
      }
      uniqueImageUriList = Array.from(uniqueImageUriSet);
    } catch (err) {
      Log.error(TAG, `getUniqueImageUriList,err.code:${err?.code},err.msg:${err?.msg}`);
    }
    Log.info(TAG, `getUniqueImageUriList end length:${uniqueImageUriList.length}, uri:${uniqueImageUriList}`);
    return uniqueImageUriList;
  }

  public async insert(
    formId: string,
    imageUri: string = '',
    albumUri: string,
    dateTaken: number = 0,
    dateAdded: number = 0,
    showTime: number = 0,
    imageUriId: string = DatabaseUtils.extractAssetUri(imageUri)
  ): Promise<void> {
    Log.info(TAG, ` insert formId: ${formId}`)

    const value: ValuesBucket = {
      'form_id': formId,
      'image_uri': imageUri,
      'show_time': showTime,
      'album_uri': albumUri,
      'is_hidden': 0,
      'date_taken': dateTaken,
      'date_added': dateAdded,
      'image_uri_id': imageUriId
    };
    const insertNO = await this.mInsert(value);
    if (insertNO !== undefined) {
      await this.registerForPhotosAndAlbums(formId, [imageUri]);
    }
    return;
  }

  public async queryImageByUris(imageUris: string[]): Promise<DataShareResultSet | undefined> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.beginWrap();
    for (let i = 0; i < imageUris.length; i++) {
      predicates.equalTo(RemindersTable.IMAGE_URI, imageUris[i]);
      if (i < imageUris.length - 1) {
        predicates.or();
      }
    }
    predicates.endWrap();
    Log.info(TAG, `queryImageByUris imageUris: ${JSON.stringify(imageUris)}`);
    try {
      const queryResult = await DBHelper.getInstance(this.context).doQuery(this.uri,
        predicates, [RemindersTable.IMAGE_URI, RemindersTable.FORM_ID, RemindersTable.ALBUM_URI], this.context);
      return queryResult;
    } catch (error) {
      Log.error(TAG, `queryImageByUris error ${error}`);
      return undefined;
    }
  }

  /**
   * 通过ImageUriId去批量查询reminders表
   *
   * @param imageUris 需要查询的imageUris
   * @returns 对应数据
   */
  public async queryImageByImageUriId(imageUris: string[],
    includeHidden: boolean = true): Promise<DataShareResultSet | undefined> {
    const imageUriIds: string[] = DatabaseUtils.extractAssetUriPaths(imageUris);
    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.in(RemindersTable.IMAGE_URI_ID, imageUriIds);
    if (!includeHidden) {
      predicates.equalTo(RemindersTable.IS_HIDDEN, ReminderTableConstants.NOT_HIDDEN);
    }
    Log.info(TAG, `queryImageByImageUriId imageUriIds: ${JSON.stringify(imageUriIds)}`);
    try {
      const queryResult = await DBHelper.getInstance(this.context).doQuery(this.uri,
        predicates, [RemindersTable.IMAGE_URI, RemindersTable.FORM_ID, RemindersTable.ALBUM_URI], this.context);
      return queryResult;
    } catch (error) {
      Log.error(TAG, `queryImageByImageUriId error ${error}`);
      return undefined;
    }
  }

  // 软删除恢复
  public async updateIsHiddenById(isHidden: number, id: number): Promise<void> {
    try {
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(RemindersTable.ID, id);
      Log.info(TAG, 'updateIsHiddenById id: ' + id + `  prediates: ${JSON.stringify(predicates)}` + predicates);
      const value: ValuesBucket = {
        'is_hidden': isHidden,
      }
      Log.info(TAG, 'id = ' + id + ', isHidden:' + isHidden);
      await this.mUpdate(predicates, value);
    } catch (error) {
      Log.error(TAG, `changeDeleteStatus error ${error}`);
    }
  }

  private async changeDeleteStatusByImgId(isDelete: number, imageUriIds: string[], formId?: string): Promise<void> {
    try {
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.in(RemindersTable.IMAGE_URI_ID, imageUriIds);
      if (formId) {
        predicates.equalTo(RemindersTable.FORM_ID, formId);
      }
      const value: ValuesBucket = {};
      value[RemindersTable.IS_HIDDEN] = isDelete;
      Log.info(TAG, `formId is ${formId}`);
      await this.mUpdate(predicates, value);
    } catch (error) {
      Log.error(TAG, `changeDeleteStatus error ${error}`);
    }
  }

  private async changeDeleteStatusByIds(isDelete: number, ids: string[], formId?: string): Promise<void> {
    try {
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.in(RemindersTable.ID, ids);
      if (formId) {
        predicates.equalTo(RemindersTable.FORM_ID, formId);
      }
      const value: ValuesBucket = {};
      value[RemindersTable.IS_HIDDEN] = isDelete;
      Log.info(TAG, `formId is ${formId}`);
      await this.mUpdate(predicates, value);
    } catch (error) {
      Log.error(TAG, `changeDeleteStatusByIds error ${error}`);
    }
  }

  // 切换照片删除状态
  private async changeDeleteStatus(isDelete: number, imageUris: string[], formId?: string): Promise<void> {
    try {
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.beginWrap();
      for (let i = 0; i < imageUris.length; i++) {
        predicates.equalTo(RemindersTable.IMAGE_URI, imageUris[i]);
        if (i < imageUris.length - 1) {
          predicates.or();
        }
      }
      predicates.endWrap();
      if (formId) {
        predicates.equalTo(RemindersTable.FORM_ID, formId);
      }
      Log.info(TAG, `changeDeleteStatus iamgeUri: ${JSON.stringify(imageUris)}, isDelete: ${isDelete}` +
        `  prediates: ${JSON.stringify(predicates)}` + predicates);
      const value: ValuesBucket = {
        'is_hidden': isDelete,
      }
      Log.info(TAG, `formId is ${formId}`);
      await this.mUpdate(predicates, value);
    } catch (error) {
      Log.error(TAG, `changeDeleteStatus error ${error}`);
    }
  }

  // 软删除，方便恢复
  public async hiddenRecordByImageUris(imageUris: string[], formId?: string): Promise<void> {
    this.changeDeleteStatus(1, imageUris, formId);
  }

  public async showRecordByImageUris(imageUris: string[], formId?: string): Promise<void> {
    this.changeDeleteStatus(0, imageUris, formId);
  }

  public async hiddenRecordByImageUriIds(imageUriIds: string[], formId?: string): Promise<void> {
    this.changeDeleteStatusByImgId(1, imageUriIds, formId);
  }

  public async hiddenRecordByIds(hiddenIds: string[], formId?: string): Promise<void> {
    this.changeDeleteStatusByIds(1, hiddenIds, formId);
  }

  public async queryRemainImagesInfo(formId: string, lastCarouselImageInfo: ImageInfo): Promise<ImageInfo[]> {
    let remainImagesInfo: ImageInfo[] = [];
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    predicates.equalTo(RemindersTable.IS_HIDDEN, 0);
    predicates.greaterThan(RemindersTable.ID, lastCarouselImageInfo.id);

    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, [
        RemindersTable.ID,
        RemindersTable.FORM_ID,
        RemindersTable.IMAGE_URI,
        RemindersTable.SHOW_TIME,
        RemindersTable.ALBUM_URI,
        RemindersTable.IS_HIDDEN,
        RemindersTable.DATE_TAKEN,
        RemindersTable.DATE_ADDED,
      ]);
      // instrument ignore if
      if (queryResult && queryResult.rowCount > 0) {
        const idIndex: number = queryResult.getColumnIndex(RemindersTable.ID);
        const formIdIndex: number = queryResult.getColumnIndex(RemindersTable.FORM_ID);
        const imageUriIndex: number = queryResult.getColumnIndex(RemindersTable.IMAGE_URI);
        const showTimeIndex: number = queryResult.getColumnIndex(RemindersTable.SHOW_TIME);
        const albumUriIndex: number = queryResult.getColumnIndex(RemindersTable.ALBUM_URI);
        const isHiddenIndex: number = queryResult.getColumnIndex(RemindersTable.IS_HIDDEN);
        const dateTakenIndex: number = queryResult.getColumnIndex(RemindersTable.DATE_TAKEN);
        const dateAddedIndex: number = queryResult.getColumnIndex(RemindersTable.DATE_ADDED);
        queryResult.goToFirstRow();
        for (let i = 0; i < queryResult.rowCount; i++) {
          remainImagesInfo.push({
            id: Number(queryResult.getString(idIndex)),
            formId: Number(queryResult.getString(formIdIndex)),
            imageUri: queryResult.getString(imageUriIndex),
            showTime: Number(queryResult.getString(showTimeIndex)),
            albumUri: queryResult.getString(albumUriIndex),
            isHidden: Number(queryResult.getString(isHiddenIndex)),
            dateTaken: Number(queryResult.getString(dateTakenIndex)),
            dateAdded: Number(queryResult.getString(dateAddedIndex)),
          });
          queryResult.goToNextRow();
        }
      }
    } catch (err) {
      Log.error(TAG, `queryRemainImagesInfo error, code: ${err?.code}, msg: ${err?.message}`);
    } finally {
      queryResult?.close();
    }
    Log.info(TAG, `queryRemainImagesInfo return: ${remainImagesInfo.length}`);
    return remainImagesInfo;
  }

  public async queryRemainCount(formId: string, lastCarouselImageInfo: ImageInfo) {
    let count = 0;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    predicates.equalTo(RemindersTable.IS_HIDDEN, 0);
    predicates.greaterThan(RemindersTable.ID, lastCarouselImageInfo.id);

    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, ['COUNT(1)']);
      // instrument ignore if
      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToLastRow();
        count = Number(queryResult.getString(0));
      }
    } catch (err) {
      Log.error(TAG, `queryRemainCount error, code: ${err?.code}, msg: ${err?.message}`);
    } finally {
      queryResult?.close();
    }
    Log.info(TAG, `queryRemainCount return: ${count}`);
    return count;
  }

  public async queryImageInfoForSingleAlbum(formId: string): Promise<ImageInfo | undefined> {
    let imageInfo: ImageInfo | undefined;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    predicates.limit(1, 0);

    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, [
        RemindersTable.ID,
        RemindersTable.FORM_ID,
        RemindersTable.IMAGE_URI,
        RemindersTable.SHOW_TIME,
        RemindersTable.ALBUM_URI,
        RemindersTable.IS_HIDDEN,
        RemindersTable.DATE_TAKEN,
        RemindersTable.DATE_ADDED,
      ]);
      // instrument ignore if
      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToLastRow();
        imageInfo = {
          id: Number(queryResult.getString(0)),
          formId: Number(queryResult.getString(1)),
          imageUri: queryResult.getString(2),
          showTime: Number(queryResult.getString(3)),
          albumUri: queryResult.getString(4),
          isHidden: Number(queryResult.getString(5)),
          dateTaken: Number(queryResult.getString(6)),
          dateAdded: Number(queryResult.getString(7)),
        };
      }
      Log.info(TAG, `queryImageInfoForSingleAlbum return ${JSON.stringify(imageInfo)}`);
      return imageInfo;
    } catch (error) {
      Log.error(TAG, `queryImageInfoForSingleAlbum error: ${JSON.stringify(error)}`);
      return undefined;
    } finally {
      queryResult?.close();
    }
  }

  /**
   * 查询已被软删但正在显示的formId
   * 等价如下sql
   * SELECT t.form_id from (
   * SELECT form_id, is_hidden, image_uri_id, MAX(show_time) from Reminders group by form_id
   * ) as t where t.is_hidden = 1 and t.image_uri_id in (imageUriIds)
   * */
  public async queryHiddenFormIdsByImageUriIds(imageUriIds: string[]): Promise<string[]> {
    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.groupBy([RemindersTable.FORM_ID]);
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, [
        RemindersTable.FORM_ID,
        RemindersTable.IS_HIDDEN,
        RemindersTable.IMAGE_URI_ID,
        this.aggregateMax(RemindersTable.SHOW_TIME)
      ]);
      const hiddenFormIds: string[] = [];
      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToFirstRow();
        const formIdIndex = queryResult.getColumnIndex(RemindersTable.FORM_ID);
        const isHiddenIndex = queryResult.getColumnIndex(RemindersTable.IS_HIDDEN);
        const imageUriIdIndex = queryResult.getColumnIndex(RemindersTable.IMAGE_URI_ID);
        for (let i = 0; i < queryResult.rowCount; i++) {
          const isHidden = Number(queryResult.getString(isHiddenIndex));
          const isIncludeUri = imageUriIds.includes(queryResult.getString(imageUriIdIndex));
          if (isHidden && isIncludeUri) {
            hiddenFormIds.push(queryResult.getString(formIdIndex));
          }
          queryResult.goToNextRow();
        }
      }
      Log.info(TAG,
        `queryAllHiddenCard hidden formIds len = ${hiddenFormIds.length} return ${JSON.stringify(hiddenFormIds)} ${queryResult?.rowCount}`);
      return hiddenFormIds;
    } catch (error) {
      Log.error(TAG, `queryAllHiddenCard error: ${error}`);
      return [];
    } finally {
      queryResult?.close();
    }
  }

  public async queryLastImageInfo(formId: string, carouselCompleted: boolean = false): Promise<ImageInfo | undefined> {
    let lastImageInfo: ImageInfo | undefined;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    predicates.equalTo(RemindersTable.IS_HIDDEN, 0);
    predicates.limit(1, 0);
    predicates.orderByDesc(carouselCompleted ? RemindersTable.SHOW_TIME : RemindersTable.ID);
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, [
        RemindersTable.ID,
        RemindersTable.FORM_ID,
        RemindersTable.IMAGE_URI,
        RemindersTable.SHOW_TIME,
        RemindersTable.ALBUM_URI,
        RemindersTable.IS_HIDDEN,
        RemindersTable.DATE_TAKEN,
        RemindersTable.DATE_ADDED,
      ]);
      // instrument ignore if
      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToLastRow();
        lastImageInfo = {
          id: Number(queryResult.getString(0)),
          formId: Number(queryResult.getString(1)),
          imageUri: queryResult.getString(2),
          showTime: Number(queryResult.getString(3)),
          albumUri: queryResult.getString(4),
          isHidden: Number(queryResult.getString(5)),
          dateTaken: Number(queryResult.getString(6)),
          dateAdded: Number(queryResult.getString(7)),
        };
      }
      Log.info(TAG,
        `queryLastImageInfo carouselCompleted = ${carouselCompleted} return ${JSON.stringify(lastImageInfo)}`);
      return lastImageInfo;
    } catch (error) {
      Log.error(TAG, `queryLastImageInfo error: ${error}`);
      return undefined;
    } finally {
      queryResult?.close();
    }
  }

  /* 图库卡片打开LightGlimpse效果后，会转为激活态，需要保持与widget同源，所以增加激活态使用的数据库查询函数 */
  public async queryOlderImageInfo(formId: string): Promise<ImageInfo | undefined> {
    let lastImageInfo: ImageInfo | undefined;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    predicates.equalTo(RemindersTable.IS_HIDDEN, 0);
    predicates.limit(1, 0);
    predicates.orderByAsc(RemindersTable.SHOW_TIME);
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, [
        RemindersTable.ID,
        RemindersTable.FORM_ID,
        RemindersTable.IMAGE_URI,
        RemindersTable.SHOW_TIME,
        RemindersTable.ALBUM_URI,
        RemindersTable.IS_HIDDEN,
        RemindersTable.DATE_TAKEN,
        RemindersTable.DATE_ADDED,
      ]);
      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToLastRow();
        lastImageInfo = {
          id: Number(queryResult.getString(0)),
          formId: Number(queryResult.getString(1)),
          imageUri: queryResult.getString(2),
          showTime: Number(queryResult.getString(3)),
          albumUri: queryResult.getString(4),
          isHidden: Number(queryResult.getString(5)),
          dateTaken: Number(queryResult.getString(6)),
          dateAdded: Number(queryResult.getString(7)),
        };
      }
      Log.info(TAG,
        `queryOlderImageInfo return ${JSON.stringify(lastImageInfo)}`);
      return lastImageInfo;
    } catch (error) {
      Log.error(TAG, `queryOlderImageInfo error: ${error}`);
      return undefined;
    } finally {
      queryResult?.close();
    }
  }

  /* 图库卡片打开LightGlimpse效果后，会转为激活态，需要保持与widget同源，所以增加激活态使用的数据库查询函数 */
  public async queryAllImageInfo(formId: string): Promise<void> {
    let lastImageInfo: ImageInfo | undefined;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    predicates.equalTo(RemindersTable.IS_HIDDEN, 0);
    predicates.orderByDesc(RemindersTable.SHOW_TIME);
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, [
        RemindersTable.ID,
        RemindersTable.FORM_ID,
        RemindersTable.IMAGE_URI,
        RemindersTable.SHOW_TIME,
        RemindersTable.ALBUM_URI,
        RemindersTable.IS_HIDDEN,
        RemindersTable.DATE_TAKEN,
        RemindersTable.DATE_ADDED,
      ]);
      if (queryResult && queryResult.rowCount > 0) {
        let cnt: number = queryResult.rowCount;
        while (cnt > 0) {
          queryResult.goToNextRow();
          lastImageInfo = {
            id: Number(queryResult.getString(0)),
            formId: Number(queryResult.getString(1)),
            imageUri: queryResult.getString(2),
            showTime: Number(queryResult.getString(3)),
            albumUri: queryResult.getString(4),
            isHidden: Number(queryResult.getString(5)),
            dateTaken: Number(queryResult.getString(6)),
            dateAdded: Number(queryResult.getString(7)),
          };
          Log.info(TAG,
            `queryAllImageInfo return ${JSON.stringify(lastImageInfo)}`);
          cnt--;
        }
      }
    } catch (error) {
      Log.error(TAG, `queryAllImageInfo error: ${error}`);
    } finally {
      queryResult?.close();
    }
  }

  /* 图库卡片打开LightGlimpse效果后，会转为激活态，需要保持与widget同源，所以增加激活态使用的数据库查询函数 */
  public async querySecondOlderImageInfo(formId: string): Promise<ImageInfo | undefined> {
    let lastImageInfo: ImageInfo | undefined;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    predicates.equalTo(RemindersTable.IS_HIDDEN, 0);
    predicates.limit(2, 0);
    predicates.orderByAsc(RemindersTable.SHOW_TIME);
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, [
        RemindersTable.ID,
        RemindersTable.FORM_ID,
        RemindersTable.IMAGE_URI,
        RemindersTable.SHOW_TIME,
        RemindersTable.ALBUM_URI,
        RemindersTable.IS_HIDDEN,
        RemindersTable.DATE_TAKEN,
        RemindersTable.DATE_ADDED,
      ]);
      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToLastRow();
        lastImageInfo = {
          id: Number(queryResult.getString(0)),
          formId: Number(queryResult.getString(1)),
          imageUri: queryResult.getString(2),
          showTime: Number(queryResult.getString(3)),
          albumUri: queryResult.getString(4),
          isHidden: Number(queryResult.getString(5)),
          dateTaken: Number(queryResult.getString(6)),
          dateAdded: Number(queryResult.getString(7)),
        };
      }
      Log.info(TAG,
        `querySecondOlderImageInfo return ${JSON.stringify(lastImageInfo)}`);
      return lastImageInfo;
    } catch (error) {
      Log.error(TAG, `querySecondOlderImageInfo error: ${error}`);
      return undefined;
    } finally {
      queryResult?.close();
    }
  }

  public async queryByFormId(
    formId: string,
    filterHidden: boolean = false,
  ): Promise<DataShareResultSet | undefined> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('form_id', formId);
    if (filterHidden) {
      predicates.equalTo('is_hidden', 0);
    }

    return await this.mQuery(predicates, [
      RemindersTable.ID,
      RemindersTable.FORM_ID,
      RemindersTable.IMAGE_URI,
      RemindersTable.SHOW_TIME,
      RemindersTable.ALBUM_URI,
      RemindersTable.IS_HIDDEN,
      RemindersTable.DATE_TAKEN,
      RemindersTable.DATE_ADDED,
    ]);
  }

  public async updateAlbumUri(newAlbumUri: string, oldAlbumUri: string,): Promise<number | undefined> {
    Log.info(TAG, `updateAlbumUri newAlbumUri: ${newAlbumUri}, oldAlbumUri: ${oldAlbumUri}`);
    let value: ValuesBucket = {
      'album_uri': newAlbumUri,
    };
    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('album_uri', oldAlbumUri);

    return await this.mUpdate(predicates, value);
  }

  public async getNotHiddenReminderInfos(total: number, offset: number, formId: string): Promise<ReminderInfo[]> {
    const predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(RemindersTable.IS_HIDDEN, ReminderTableConstants.NOT_HIDDEN);
    predicates.equalTo(RemindersTable.FORM_ID, formId);
    predicates.limit(total, offset);

    const columns = [
      RemindersTable.ID,
      RemindersTable.IMAGE_URI,
      RemindersTable.IS_HIDDEN,
    ];
    let resultSet: DataShareResultSet | undefined = undefined;
    const reminderInfos: ReminderInfo[] = [];
    try {
      resultSet = await this.mQuery(predicates, columns);
      if (!resultSet) {
        return [];
      }
      const idIndex: number = resultSet.getColumnIndex(RemindersTable.ID);
      const imageUriIndex: number = resultSet.getColumnIndex(RemindersTable.IMAGE_URI);
      const isHiddenIndex: number = resultSet.getColumnIndex(RemindersTable.IS_HIDDEN);
      while (resultSet.goToNextRow()) {
        reminderInfos.push({
          id: resultSet.getString(idIndex),
          imageUri: resultSet.getString(imageUriIndex),
          isHidden: resultSet.getString(isHiddenIndex),
          formId,
        });
      }

      Log.info(TAG, `getReminderInfos success, found ${reminderInfos.length} items, offset = ${offset}`);
    } catch (err) {
      if (err) {
        Log.error(TAG, `getReminderInfos error, code = ${err.code}, msg = ${err.message}`);
      }
    } finally {
      resultSet?.close();
    }

    return reminderInfos;
  }
}
