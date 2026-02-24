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
import type { MediaObserverCallback, MediaObserverRefinedCallback } from './MediaObserverCallback';
import lazy {
  MediaChangeType,
  MediaObserverNfyInfo,
  MediaObserverNfyInfoForAlbums,
  MediaObserverNfyType
} from './MediaObserverCallback';
import lazy { Log } from '../../../utils/Log';
import type { ChangeData } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { EffectPhotoContext } from '../../../../../../../../browserCommon/src/main/ets/default/utils/EffectPhotoContext';
import lazy { EditorPhotoContext } from '../../../utils/EditorPhotoContext';
import lazy { Callback } from '@ohos.base';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Constants } from '../../common/Constants';
import lazy { AlbumUtils } from '../../../utils/AlbumUtils';

const TAG: string = 'common_MediaObserver';
const PHOTO_CHANGE = 'photoChange';
const HIDDEN_PHOTO_CHANGE = 'hiddenPhotoChange';
const TRASH_PHOTO_CHANGE = 'trashedPhotoChange';

export type PhotoAssetChangeData = photoAccessHelper.PhotoAssetChangeData;

export type PhotoAssetChangeInfo = photoAccessHelper.PhotoAssetChangeInfo;

export type PhotoAssetChangeInfos = photoAccessHelper.PhotoAssetChangeInfos;

export type NotifyChangeType = photoAccessHelper.NotifyChangeType;

export interface MediaChangeListener {
  onAccurateNotify: (type: string, nfyInfo: PhotoAssetChangeInfos) => void;
}

const PHOTO_ALBUM_CHANGE = 'photoAlbumChange';
const HIDDEN_ALBUM_CHANGE ='hiddenAlbumChange';
const TRASHED_ALBUM_CHANGE = 'trashedAlbumChange';

export type AlbumChangeInfos = photoAccessHelper.AlbumChangeInfos;

export class MediaObserver {
  public static instance: MediaObserver | undefined = undefined;
  public static readonly NOTIFY_FOR_ASTC_ADD: number = 6;
  public static readonly NOTIFY_FOR_ASTC_UPDATE: number = 7;
  public static readonly REGISTER_PHOTO_CHANGE: string = 'photoChange';
  public static readonly REGISTER_HIDDEN_PHOTO_CHANGE: string = 'hiddenPhotoChange';
  public static readonly REGISTER_TRASH_PHOTO_CHANGE: string = 'trashedPhotoChange';
  public static readonly PHOTO_ALBUM_CHANGE: string = 'photoAlbumChange';
  public static readonly HIDDEN_ALBUM_CHANGE: string = 'hiddenAlbumChange';
  public static readonly TRASHED_ALBUM_CHANGE: string = 'trashedAlbumChange';
  public callbacks: Set<MediaObserverCallback> = new Set<MediaObserverCallback>();
  public listeners: Map<string, Set<MediaChangeListener>> =
    new Map<string, Set<MediaChangeListener>>();
  public albumChangedCallbacks: Map<string, Set<MediaObserverRefinedCallback>> =
    new Map<string, Set<MediaObserverRefinedCallback>>();

  private onAlbumsChanged: Callback<ChangeData> = (changeData: ChangeData) => {
    this.userFileManagerOn(changeData);
  }
  private onAnalysisAlbumsChanged: Callback<ChangeData> = (changeData: ChangeData) => {
    this.userFileManagerOn(changeData,'onAnalysisAlbumsChanged');
  }
  private onPhotoAlbumChanged: Callback<AlbumChangeInfos> = (changeData: AlbumChangeInfos) => {
    Log.info(TAG, '[preciseInfo] subscribe for onPhotoAlbumChanged.');
    this.handleAlbumsChanged(MediaObserver.PHOTO_ALBUM_CHANGE, changeData);
  }
  private onHiddenAlbumChanged: Callback<AlbumChangeInfos> = (changeData: AlbumChangeInfos) => {
    Log.info(TAG, '[preciseInfo] subscribe for onHiddenAlbumChanged.');
    this.handleAlbumsChanged(MediaObserver.HIDDEN_ALBUM_CHANGE, changeData);
  }
  private onTrashedAlbumChanged: Callback<AlbumChangeInfos> = (changeData: AlbumChangeInfos) => {
    Log.info(TAG, '[preciseInfo] subscribe for onTrashedAlbumChanged.');
    this.handleAlbumsChanged(MediaObserver.TRASHED_ALBUM_CHANGE, changeData);
  }

  private onPhotosChanged: Callback<ChangeData> = (changeData: ChangeData) => {
    Log.info(TAG, 'userFileManager.on for REGISTER_TYPE_ALL_PHOTOS, ' +
      `changeData.type is: ${JSON.stringify(changeData.type)}, ` +
      `uris: , ${changeData.uris?.length} sharedPhotoAssets.length  ${changeData.sharedPhotoAssets?.length}` +
      `changeData.uris is: ${JSON.stringify(changeData.uris)}`);
    let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
    nfyInfo.type = this.convertTypeFromUserFileManager(changeData.type, true);
    nfyInfo.uris = changeData.uris;
    EffectPhotoContext.getInstance().libraryNotify(changeData.type, changeData.uris);
    EditorPhotoContext.getInstance().libraryNotify(changeData.type, changeData.uris);
    nfyInfo.sharedPhotoAssets = changeData.sharedPhotoAssets;
    nfyInfo.sharedAlbumAssets = changeData.sharedAlbumAssets;
    nfyInfo.sharedExtraPhotoAssets = changeData.sharedExtraPhotoAssets;
    this.sendDetailNotify(nfyInfo);
  }
  private onPhotoChanged: Callback<PhotoAssetChangeInfos> = (changeData: PhotoAssetChangeInfos) => {
    this.handlePhotoChanged(MediaObserver.REGISTER_PHOTO_CHANGE, changeData);
  }
  private onHiddenPhotoChanged: Callback<PhotoAssetChangeInfos> = (changeData: PhotoAssetChangeInfos) => {
    this.handlePhotoChanged(MediaObserver.REGISTER_HIDDEN_PHOTO_CHANGE, changeData);
  }
  private onTrashPhotoChanged: Callback<PhotoAssetChangeInfos> = (changeData: PhotoAssetChangeInfos) => {
    this.handlePhotoChanged(MediaObserver.REGISTER_TRASH_PHOTO_CHANGE, changeData);
  }
  private hasSubscribed: boolean = false;

  public static getInstance(): MediaObserver {
    if (MediaObserver.instance) {
      Log.info(TAG, 'MediaObserver singletonInstance exist');
      return MediaObserver.instance;
    }
    let manager = AppStorage.get<MediaObserver>(Constants.MEDIA_OBSERVER_MANAGER);
    if (manager) {
      Log.info(TAG, `appStorage-MediaObserver exist`);
      MediaObserver.instance = manager;
      return manager;
    } else {
      Log.info(TAG, `appStorage-MediaObserver not exist`);
      MediaObserver.instance = new MediaObserver();
      AppStorage.setOrCreate(Constants.MEDIA_OBSERVER_MANAGER, MediaObserver.instance);
      return MediaObserver.instance;
    }
  }

  private convertTypeFromUserFileManager(type: number, isPhoto: boolean): number {
    if (type === UserFileManagerAccess.NOTIFY_ADD) {
      if (isPhoto) {
        return MediaObserverNfyType.PHOTO_ADD;
      } else {
        return MediaObserverNfyType.ALBUM_ADD;
      }
    } else if (type === UserFileManagerAccess.NOTIFY_REMOVE) {
      if (isPhoto) {
        return MediaObserverNfyType.PHOTO_REMOVE;
      } else {
        return MediaObserverNfyType.ALBUM_REMOVE;
      }
    } else if (type === UserFileManagerAccess.NOTIFY_UPDATE) {
      if (isPhoto) {
        return MediaObserverNfyType.PHOTO_UPDATE;
      } else {
        return MediaObserverNfyType.ALBUM_UPDATE;
      }
    } else if (type === UserFileManagerAccess.NOTIFY_ALBUM_ADD_ASSET) {
      return MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM;
    } else if (type === UserFileManagerAccess.NOTIFY_ALBUM_REMOVE_ASSET) {
      return MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM;
    } else if (type === MediaObserver.NOTIFY_FOR_ASTC_ADD) {
      if (isPhoto) {
        return MediaObserverNfyType.PHOTO_ADD_ASTC;
      } else {
        return MediaObserverNfyType.NONE;
      }
    } else if (type === MediaObserver.NOTIFY_FOR_ASTC_UPDATE) {
      if (isPhoto) {
        return MediaObserverNfyType.PHOTO_UPDATE_ASTC;
      } else {
        return MediaObserverNfyType.NONE;
      }
    } else {
      return MediaObserverNfyType.NONE;
    }
  }

  public registerObserver(callback?: MediaObserverCallback): void {
    Log.info(TAG, 'registerObserver');
    if (!callback) {
      Log.warn(TAG, 'registerObserver with empty callback');
      return;
    }

    if (this.callbacks.has(callback)) {
      Log.warn(TAG, 'registerObserver already exist');
      return;
    }
    this.callbacks.add(callback);
  }

  public register(type: string, listener?: MediaChangeListener, tag?: string): void {
    Log.info(TAG, '[MediaObserverRegister] register tag: ' + tag);
    /* instrument ignore if */
    if (!listener || !type) {
      Log.warn(TAG, '[MediaObserverRegister] register with empty listener or type');
      return;
    }

    if (!this.listeners.has(type)) {
      this.listeners.set(type, new Set<MediaChangeListener>());
    }

    if (this.listeners.get(type)?.has(listener)) {
      Log.warn(TAG, '[MediaObserverRegister] register listener already exist');
      return;
    }
    this.listeners.get(type)?.add(listener);
    Log.info(TAG, `[MediaObserverRegister] register listeners size: ${this.listeners.get(type)?.size}`);
  }

  /* instrument ignore next */
  public unregisterObserver(callback?: MediaObserverCallback): void {
    Log.info(TAG, 'unregisterObserver');
    if (!callback) {
      Log.warn(TAG, 'unregisterObserver with empty callback');
      return;
    }

    if (this.callbacks.has(callback)) {
      this.callbacks.delete(callback);
    } else {
      Log.warn(TAG, 'unregisterObserver not exist');
    }
  }

  public unregister(type: string, listener?: MediaChangeListener, tag?: string): void {
    Log.info(TAG, `[MediaObserverRegister] unregister: ${tag}`);
    if (!listener || !type) {
      Log.warn(TAG, '[MediaObserverRegister] unregister with empty listener or type');
      return;
    }

    if (this.listeners.get(type)?.has(listener)) {
      this.listeners.get(type)?.delete(listener);
    } else {
      Log.warn(TAG, '[MediaObserverRegister] unregister listener not exist');
    }
    Log.info(TAG, `[MediaObserverRegister] unregister listeners size: ${this.listeners.get(type)?.size}`);
  }

  /* 媒体库新通知接口的相册变化通知监听
   * type 新接口的通知类型：photoAlbumChange、hiddenAlbumChange、trashedAlbumChange
   * callback 新接口通知的回调函数，在接收通知后会调用该方法
   * */
  /* instrument ignore next */
  public registerAlbumObserver(type: string, callback?: MediaObserverRefinedCallback): void {
    Log.info(TAG, '[preciseInfo] registerPhotoAlbumObserver ' + type);
    /* instrument ignore if */
    if (!callback || !type) {
      Log.warn(TAG, 'registerAlbumObserver with empty callback');
      return;
    }

    if (!this.albumChangedCallbacks.has(type)) {
      this.albumChangedCallbacks.set(type, new Set<MediaObserverRefinedCallback>());
    }

    if (this.albumChangedCallbacks.get(type)?.has(callback)) {
      Log.warn(TAG, 'registerAlbumObserver callback already exist');
      return;
    }

    this.albumChangedCallbacks.get(type)?.add(callback);
  }

  /* instrument ignore next */
  public unregisterAlbumObserver(type: string, callback?: MediaObserverRefinedCallback): void {
    Log.info(TAG, `[preciseInfo] unregisterAlbumObserver unregister`);
    if (!callback || !type) {
      Log.warn(TAG, '[unregisterAlbumObserver] unregister with empty listener or type');
      return;
    }

    if (this.albumChangedCallbacks.get(type)?.has(callback)) {
      this.albumChangedCallbacks.get(type)?.delete(callback);
    } else {
      Log.warn(TAG, 'unregisterAlbumObserver callback not exist');
    }
    Log.info(TAG, `unregisterAlbumObserver callback size: ${this.albumChangedCallbacks.get(type)?.size}`);
  }

  /* instrument ignore next */
  public forceNotify(): void {
    this.sendNotify(MediaChangeType.IMAGE);
  }

  private handlePhotoChanged(type: string, changeData: PhotoAssetChangeInfos): void {
    let msg: string[] = [];
    msg.push(`MediaObsever handlePhotoChanged notify type: ${type} changeType: ${changeData.type}`);
    msg.push(`length: ${changeData.assetChangeDatas?.length}, isForcheck: ${changeData.isForRecheck}`);
    Log.info(TAG, msg.join(`,`));
    this.sendAccurateNotify(type, changeData);
  }

  public sendNotify(mediaType: string): void {
    Log.info(TAG, `sendNotify size: ${this.callbacks.size}`);
    for (let callback of this.callbacks) {
      callback?.onChange?.(mediaType);
    }
  }

  public sendDetailNotify(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `sendDetailNotify size: ${this.callbacks.size}`);
    for (let callback of this.callbacks) {
      callback?.onNotify?.(nfyInfo);
    }
  }

  public sendAccurateNotify(type: string, nfyInfo: PhotoAssetChangeInfos): void {
    Log.info(TAG, `sendAccurateNotify type: ${type}, size: ${this.listeners.get(type)?.size}`);
    for (let listener of (this.listeners.get(type) ?? [])) {
      listener?.onAccurateNotify?.(type, nfyInfo);
    }
  }

  public sendAlbumsNotify(type: string, nfyInfo: MediaObserverNfyInfoForAlbums): void {
    for (let callback of (this.albumChangedCallbacks.get(type) ?? [])) {
      callback?.onRefinedNotify?.(nfyInfo);
    }
  }

  public sliceSharedPhotoAssets(originData: string): string {
    let key: number = originData.indexOf('sharedPhotoAssets');
    if (key === -1) {
      Log.error(TAG, 'sliceSharedPhotoAssets failed, key is invalid');
      return '';
    }
    let start: number = originData.indexOf('[', key);
    if (start === -1) {
      Log.error(TAG, 'sliceSharedPhotoAssets failed, start is invalid');
      return '';
    }
    let end: number = originData.indexOf(']', start);
    if (end === -1 || start + 1 >= end) {
      Log.error(TAG, 'sliceSharedPhotoAssets failed, end is invalid');
      return '';
    }
    return originData.slice(start + 1, end);
  }

  public parseAssetData(assetData: string): string[] {
    if (assetData.length === 0 || assetData.indexOf('dateYear') === -1 || assetData.indexOf(`dateMonth`) === -1) {
      Log.error(TAG, 'parseAssetData failed, invalid assetData');
      return [];
    }
    let yearStartIndex: number = assetData.indexOf(':', assetData.indexOf(`dateYear`)) + 1;
    let monthStartIndex: number = assetData.indexOf(':', assetData.indexOf(`dateMonth`)) + 1;
    if (yearStartIndex === 0 || monthStartIndex === 0) {
      Log.error(TAG, 'parseAssetData failed, invalid year or month start index');
      return [];
    }
    let yearEndIndex: number = assetData.indexOf('"', yearStartIndex + 1);
    let monthEndIndex: number = assetData.indexOf('"', monthStartIndex + 1);
    if (yearEndIndex === -1 || monthEndIndex === -1) {
      Log.error(TAG, 'parseAssetData failed, invalid year or month end index');
      return [];
    }
    let dateYear: string = assetData.slice(yearStartIndex + 1, yearEndIndex);
    let dateMonth: string = dateYear + `-${assetData.slice(monthStartIndex + dateYear.length + 1, monthEndIndex)}`;
    return [dateMonth, dateYear];
  }

  public parseAssetType(assetData: string): string {
    if (assetData.length === 0) {
      Log.error(TAG, 'parseAssetType failed, invalid assetData');
      return '';
    }
    let dataIndex: number = assetData.indexOf('mediaType');
    if (dataIndex === -1) {
      Log.error(TAG, 'parseAssetType failed, invalid dataIndex');
      return '';
    }
    let typeIndex: number = assetData.indexOf(':', dataIndex);
    if (typeIndex === -1 || typeIndex + 1 >= assetData.length) {
      Log.error(TAG, 'parseAssetType failed, invalid typeIndex');
      return '';
    }
    let mediaType: string = assetData.charAt(typeIndex + 1);
    return mediaType;
  }

  public subscribe(context: Context | undefined, tag?: string): void {
    if (this.hasSubscribed) {
      Log.warn(TAG, `hasSubscribed is true`);
      return;
    }
    if (!context) {
      Log.error(TAG, `invalid context`);
      return;
    }
    let helper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    try {
      helper = photoAccessHelper.getPhotoAccessHelper(context);
      if (!helper) {
        Log.error(TAG, `failed to get PhotoAccessHelper`);
        return;
      }
      Log.info(TAG, `register tag is ${tag}`);
      helper.registerChange(UserFileManagerAccess.REGISTER_TYPE_ALL_PHOTOS, true, this.onPhotosChanged);
      helper.registerChange(UserFileManagerAccess.REGISTER_TYPE_ALL_ALBUMS, true, this.onAlbumsChanged);
      helper.registerChange(UserFileManagerAccess.REGISTER_TYPE_ANALYSIS_ALBUMS, true, this.onAnalysisAlbumsChanged);

      helper.on(PHOTO_ALBUM_CHANGE, this.onPhotoAlbumChanged);
      // helper.on(HIDDEN_ALBUM_CHANGE, this.onHiddenAlbumChanged);
      // helper.on(TRASHED_ALBUM_CHANGE, this.onTrashedAlbumChanged);

      this.hasSubscribed = true;
      if (AlbumUtils.useAccurateNotify()) {
        Log.info(TAG, `[accurateNotify] register medialibrary callback`);
        helper.on(PHOTO_CHANGE, this.onPhotoChanged);
        // helper.on(HIDDEN_PHOTO_CHANGE, this.onHiddenPhotoChanged);
        helper.on(TRASH_PHOTO_CHANGE, this.onTrashPhotoChanged);
      }
    } catch (err) {
      Log.error(TAG, `register phAccessHelper.registerChange failed, error message: ${err}`);
    } finally {
      helper?.release();
    }
  }

  public userFileManagerOn(changeData: ChangeData, tag:string = ''): void {
    Log.info(TAG, `userFileManager.on for REGISTER_TYPE_ALL_ALBUMS, changeData${tag}: ${JSON.stringify(changeData)}`);
    let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
    nfyInfo.type = this.convertTypeFromUserFileManager(changeData.type, false);
    nfyInfo.albumUris = changeData.uris;
    nfyInfo.uris = changeData.extraUris;
    nfyInfo.sharedPhotoAssets = changeData.sharedPhotoAssets;
    nfyInfo.sharedAlbumAssets = changeData.sharedAlbumAssets;
    nfyInfo.sharedExtraPhotoAssets = changeData.sharedExtraPhotoAssets;
    this.sendDetailNotify(nfyInfo);
  }

  public clearCallbacks(): void {
    this.callbacks.clear();
    this.listeners.clear();
  }

  private handleAlbumsChanged(type: string, changeData: AlbumChangeInfos): void {
    Log.info(TAG, `[preciseInfo] handleAlbumsChanged for ${type}: ${JSON.stringify(changeData)}`);
    let nfyInfo: MediaObserverNfyInfoForAlbums = new MediaObserverNfyInfoForAlbums();
    nfyInfo.type = this.convertTypeFromUserFileManager(changeData.type, false);
    nfyInfo.albumChangeDatas = changeData.albumChangeDatas;
    nfyInfo.isForRecheck = changeData.isForRecheck;

    this.sendAlbumsNotify(type, nfyInfo);
  }
}