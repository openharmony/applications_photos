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
import lazy BaseDatashare from './BaseDatashare';
import lazy { AlbumType, FaCardTable, IsShowAlbumName } from '../databaseconstant/FaCardTable';
import lazy {
  PhotoAlbum,
  UserFileManagerAccess
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG: string = 'FaCardService';

export interface FormEditorParams {
  interval?: number,
  isShowAlbumName?: number,
  albumUri?: string,
  albumName?: string,
  cardType: AlbumType,
}

export interface FaCardInfo {
  albumUri?: string,
  playbackInterval: number,
  albumType: AlbumType,
  formId: string,
  albumName?: string,
  isShowAlbumName?: number,
  isOpenFeatured?: number
}

export default class FaCardService extends BaseDatashare {
  constructor(context: Context) {
    super(context, 'datashare:///hmos_photodata/facard');
  }

  public async insert(
    formId: string,
    albumType: number,
    playbackInterval: number,
    albumUri?: string,
    coverUri?: string,
    albumName?: string,
    isShowAlbumName?: number,
  ): Promise<number | undefined> {
    const value: ValuesBucket = {
      'form_id': formId,
      'cover_uri': coverUri ? coverUri : null,
      'album_uri': albumUri ? albumUri : null,
      'album_type': albumType,
      'playback_interval': playbackInterval,
      'album_name': albumName ?? null,
      'is_show_album_name': isShowAlbumName ?? IsShowAlbumName.ON,
    };
    Log.info(TAG, `insert value: ${JSON.stringify(value)} formId: ${formId}`);

    return await this.mInsert(value);
  }

  public async update(formId: string, value: ValuesBucket): Promise<number | undefined> {
    Log.info(TAG, `update value: ${JSON.stringify(value)} formId: ${formId}`);

    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('form_id', formId);

    return await this.mUpdate(predicates, value);
  }

  /**
   * 插入或者更新faCard表
   * 1. 在数据克隆之后，faCard表数据将会被覆盖，此时选择图片或者选择相册时，需要插入或者更新数据.
   * */
  public async insertOrUpdate(formId: string, value: ValuesBucket): Promise<number | undefined> {
    Log.info(TAG, `facard insertOrUpdate value: ${JSON.stringify(value)} formId: ${formId}`);
    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(FaCardTable.FORM_ID, formId);
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, [FaCardTable.FORM_ID]);
      const isExistFaCard = queryResult && queryResult.rowCount > 0;
      Log.info(TAG, `facard insertOrUpdate formID: ${formId} isExist: ${isExistFaCard}`);
      if (isExistFaCard) {
        return await this.mUpdate(predicates, value);
      }
      value[FaCardTable.FORM_ID] = formId;
      return await this.mInsert(value);
    } catch (error) {
      Log.error(TAG, `facard insertOrUpdate error: ${JSON.stringify(error)}`);
      return -1;
    } finally {
      queryResult?.close();
    }
  }

  public async updateAlbumName(formId: string, albumUri: string): Promise<number | undefined> {
    const userFileManagerAccess = UserFileManagerAccess.getInstance();
    userFileManagerAccess.onCreate(this.context);
    Log.info(TAG, `updateAlbumName formId: ${formId}, albumUri: ${albumUri}`);
    const albumName: string = await userFileManagerAccess.getAlbumNameByUri(albumUri, this.context);
    let value: ValuesBucket = {
      'album_name': albumName,
    };
    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('form_id', formId);

    return await this.mUpdate(predicates, value);
  }

  public async updateAlbumUri(newAlbumUri: string, oldAlbumUri: string, albumName: string): Promise<number | undefined> {
    Log.info(TAG, `updateAlbumUri newAlbumUri: ${newAlbumUri}, oldAlbumUri: ${oldAlbumUri}, new albumName: ${albumName}`);
    let value: ValuesBucket = {
      'album_uri': newAlbumUri,
      'album_name': albumName,
    };
    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('album_uri', oldAlbumUri);

    return await this.mUpdate(predicates, value);
  }

  public async queryAllForm(): Promise<DataShareResultSet | undefined> {
    Log.info(TAG, 'queryAllForm');

    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();

    return await this.mQuery(predicates, ['form_id', 'album_type', 'playback_interval', 'album_uri']);
  }

  public async queryByFormId(formId: string): Promise<DataShareResultSet | undefined> {
    Log.info(TAG, `queryByFormId formId: ${formId}`);

    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('form_id', formId);

    return await this.mQuery(predicates,
      ['album_type', 'playback_interval', 'album_uri', 'album_name', 'is_show_album_name']);
  }

  public async queryFaCardsByAlbumUri(albumUri: string): Promise<FaCardInfo[]> {
    let playbackInterval: number = 15;
    let albumType: number = 0;
    let formId: string = '';
    const faCardInfos: FaCardInfo[] = [];
    const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('album_uri', albumUri);
    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.mQuery(predicates, ['album_type', 'playback_interval', 'album_uri', 'form_id']);
      Log.info(TAG, 'queryFaCardByAlbumUri albumUri ' + albumUri);

      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToFirstRow();

        for (let i = 0; i < queryResult.rowCount; ++i) {
          albumType = Number(queryResult.getString(0));
          playbackInterval = Number(queryResult.getString(1));
          albumUri = queryResult.getString(2);
          formId = queryResult.getString(3);
          faCardInfos.push({
            albumUri,
            playbackInterval,
            albumType,
            formId
          });
          Log.info(TAG,
            `queryFaCardsByAlbumUri faCardInfo ${JSON.stringify({
              albumUri,
              playbackInterval,
              albumType,
              formId,
            })}`);
          queryResult.goToNextRow();
        }
      }
      return faCardInfos;

    } catch (error) {
      Log.error(TAG, `queryFaCardsByAlbumUri error: ${JSON.stringify(error)}`);
      return faCardInfos;
    } finally {
      queryResult?.close();
    }
  }

  public async queryFaCard(formId: string): Promise<FaCardInfo> {
    Log.info(TAG, `queryFaCard formId: ${formId}`);
    let albumUri: string = '';
    let playbackInterval: number = 15;
    let albumType: number = AlbumType.NOT_FOUND;

    let queryResult: DataShareResultSet | undefined = undefined;
    try {
      queryResult = await this.queryByFormId(formId);
      if (queryResult && queryResult.rowCount > 0) {
        queryResult.goToFirstRow();
        albumType = Number(queryResult.getString(0));
        playbackInterval = Number(queryResult.getString(1));
        albumUri = queryResult.getString(2);
      }
      const faCardInfo: FaCardInfo = {
        albumUri,
        playbackInterval,
        albumType,
        formId: formId,
      };
      Log.info(TAG, `queryFaCard faCardInfo ${JSON.stringify(faCardInfo)}`);
      return faCardInfo;
    } catch (error) {
      Log.error(TAG, `queryFaCard error: ${JSON.stringify(error)}`);
      return {
        albumUri,
        playbackInterval,
        albumType,
        formId: '',
      };
    } finally {
      queryResult?.close();
    }
  }

  public async queryInterval(formId: string): Promise<number> {
    Log.info(TAG, 'queryInterval formId ' + formId);
    let interval: number = 15;
    let resultSet: DataShareResultSet | undefined = undefined;
    try {
      resultSet = await this.queryByFormId(formId);
      if (resultSet && resultSet.rowCount > 0) {
        resultSet.goToFirstRow();
        interval = Number(resultSet.getString(1));
      }
      Log.info(TAG, 'return interval ' + interval);
      return interval;
    } catch (error) {
      Log.error(TAG, `queryInterval error: ${JSON.stringify(error)}`);
      return interval;
    } finally {
      resultSet?.close();
    }
  }

  public async queryFormEditorPageParam(formId: string): Promise<FormEditorParams> {
    Log.info(TAG, 'queryFormEditorPageParam formId ' + formId);
    const userFileManagerAccess = UserFileManagerAccess.getInstance();
    userFileManagerAccess.onCreate(this.context);
    let formEditorParams: FormEditorParams = {
      cardType: AlbumType.NOT_FOUND
    };
    let resultSet: DataShareResultSet | undefined = undefined;
    try {
      resultSet = await this.queryByFormId(formId);
      if (resultSet && resultSet.rowCount > 0) {
        const intervalIndex: number = resultSet.getColumnIndex(FaCardTable.PLAYBACK_INTERVAL);
        const isShowAlbumNameIndex: number = resultSet.getColumnIndex(FaCardTable.IS_SHOW_ALBUM_NAME);
        const albumUriIndex: number = resultSet.getColumnIndex(FaCardTable.ALBUM_URI);
        resultSet.goToFirstRow();
        formEditorParams.interval = Number(resultSet.getString(intervalIndex));
        formEditorParams.isShowAlbumName = Number(resultSet.getString(isShowAlbumNameIndex));
        const albumUri = resultSet?.getString(albumUriIndex);
        const album: PhotoAlbum | undefined = await userFileManagerAccess.getAlbumByUri(albumUri);
        if (!album) {
          Log.error(TAG, `album undefined`);
        }
      }
      Log.info(TAG, `return formEditorParams: ${JSON.stringify(formEditorParams)}`);
      return formEditorParams;
    } catch (error) {
      Log.error(TAG, `queryFormEditorPageParam error: ${JSON.stringify(error)}`);
    } finally {
      resultSet?.close();
    }
    return formEditorParams;
  }
}