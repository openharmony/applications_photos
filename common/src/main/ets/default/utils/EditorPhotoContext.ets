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
import lazy { Log } from './Log';
import lazy { EditType } from '../model/browser/photo/Constants';
import lazy { MediaChangeListener, MediaObserver } from '../model/browser/dataObserver/MediaObserver';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

export enum LibraryNotifyType {
  NONE = -1,
  ADD = 0,
  UPDATE,
  THUMBNAIL_ADD = 6,
  THUMBNAIL_UPDATE,
  REMOVE,
}

export enum EditorStage {
  NONE = 'none',
  SHOWN = 'shown',
  EXIT = 'exit',
}

export class EditorPhotoChangeListener implements MediaChangeListener {

  private context: EditorPhotoContext | undefined;

  constructor(context: EditorPhotoContext | undefined) {
    if (context === undefined) {
      Log.error(TAG, 'EditorPhotoChangeListener bind context fail');
    }
    this.context = context;
  }

  onAccurateNotify: (type: string, nfyInfo: photoAccessHelper.PhotoAssetChangeInfos) => void =
    (type: string, nfyInfo: photoAccessHelper.PhotoAssetChangeInfos): void => {
      if (type !== MediaObserver.REGISTER_PHOTO_CHANGE) {
        return;
      }
      if (nfyInfo.assetChangeDatas?.length && nfyInfo.assetChangeDatas?.length !== 1) {
        Log.error(TAG, `onAccurateNotify type: ${type} ${nfyInfo.assetChangeDatas?.length}`);
        return;
      }
      const uri: string | undefined = nfyInfo.assetChangeDatas?.[0]?.assetAfterChange?.uri;
      if (uri) {
        Log.info(TAG, `libraryNotify adapter ${nfyInfo} ${uri}`);
        this.context?.libraryNotify(this.notifyTypeAdapter(nfyInfo), [uri]);
      } else {
        Log.error(TAG, `onAccurateNotify uri: ${uri}`);
      }
    }

  private notifyTypeAdapter(nfyInfo: photoAccessHelper.PhotoAssetChangeInfos): LibraryNotifyType {
    switch (nfyInfo.type) {
      case photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_ADD:
        return LibraryNotifyType.ADD;
      case photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_UPDATE:
        return LibraryNotifyType.UPDATE;
      case photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_REMOVE:
        return LibraryNotifyType.REMOVE;
      default:
        Log.error(TAG, `unkown nfyInfo: ${nfyInfo.type}`);
        return LibraryNotifyType.NONE;
    }
  }
}

const TAG: string = 'EditorPhotoContext';

/**
 *  图库进出编辑上下文
 */
export class EditorPhotoContext {
  private static context: EditorPhotoContext | undefined = undefined;
  private editorType: EditType = EditType.NONE;
  private editorUriOnEnter: string = '';
  private editorUriOnExit: string = '';
  private editorStage: EditorStage = EditorStage.NONE;
  private notifyHideEditor: boolean = false;
  private isVirtualAlbum: boolean = false;
  private isOverride?: boolean;
  private epcListener: EditorPhotoChangeListener | undefined;

  private constructor() {
  }

  /**
   *  获取上下文单例对象
   * @returns 唯一实例
   */
  public static getInstance(): EditorPhotoContext {
    if (EditorPhotoContext.context) {
      return EditorPhotoContext.context;
    }

    EditorPhotoContext.context = AppStorage.get<EditorPhotoContext>('EditorPhotoContext');
    if (EditorPhotoContext.context) {
      return EditorPhotoContext.context;
    }

    EditorPhotoContext.context = new EditorPhotoContext();
    AppStorage.setOrCreate('EditorPhotoContext', EditorPhotoContext.context);
    return EditorPhotoContext.context;
  }

  /**
   *  媒体库通知处理
   * @param changeType 通知类型
   * @param uris 通知的url
   */
  public libraryNotify(changeType: number, uris: string[]): void {
    if (this.editorStage === EditorStage.NONE) {
      return;
    }
    if (this.shouldSkipBroadNotify(changeType, uris)) {
      return;
    }
    Log.info(TAG, 'libraryNotify action is required in editing scenarios.');
    switch (this.editorType) {
      case EditType.IMAGE:
        this.imageHandler(changeType, uris);
        break;
      case EditType.VIDEO:
        this.videoHandler(changeType, uris);
        break;
      case EditType.MOVING_PHOTO:
        this.movingPhotoHandler(changeType, uris);
        break;
      default:
        Log.error(TAG, 'editor source type is none');
        break;
    }
  }

  private shouldSkipBroadNotify(changeType: number, uris: string[]): boolean {
    if (this.editorType !== EditType.IMAGE || !this.isOverride || this.editorStage !== EditorStage.EXIT) {
      return false;
    }
    if (changeType !== LibraryNotifyType.UPDATE) {
      return false;
    }
    if (uris.length <= 1) {
      return false;
    }
    if (!uris.includes(this.editorUriOnExit)) {
      return false;
    }
    Log.info(TAG, `skip broad notify while exiting editor, uriCount: ${uris.length}, ` +
      `editorUriOnExit: ${this.editorUriOnExit}`);
    return true;
  }

  private imageHandler(changeType: number, uris: string[]): void {
    Log.info(TAG, `imageHandler, changeType: ${changeType}, editorStage: ${this.editorStage}`);
    if (this.editorStage !== EditorStage.EXIT) {
      Log.info(TAG, 'imageHandler no need to process library notifications');
      return;
    }
    if (changeType === LibraryNotifyType.UPDATE) {
      const idx: number = uris.indexOf(this.editorUriOnExit);
      if (idx === -1) {
        return;
      }
      Log.info(TAG, 'imageHandler set notifyHideEditor to true');
      this.notifyHideEditor = true;
    }
  }

  private videoHandler(changeType: number, uris: string[]): void {
    Log.info(TAG, `videoHandler, changeType: ${changeType}, editorStage: ${this.editorStage}`);
    if (this.editorStage === EditorStage.EXIT && (changeType === LibraryNotifyType.UPDATE ||
      changeType === LibraryNotifyType.ADD)) {
      const idx: number = uris.indexOf(this.editorUriOnExit);
      if (idx === -1) {
        return;
      }
      Log.info(TAG, 'videoHandler set notifyHideEditor to true');
      this.notifyHideEditor = true;
    }
  }

  private movingPhotoHandler(changeType: number, uris: string[]): void {
    Log.info(TAG, `movingPhotoHandler, changeType: ${changeType}, editorStage: ${
      this.editorStage}, isOverride: ${this.isOverride}, handled by MovingPhotoContext`);
  }

  /**
   *  退出编辑后清空上下文
   */
  public clear(): void {
    this.editorType = EditType.NONE;
    this.editorUriOnEnter = '';
    this.editorUriOnExit = '';
    this.editorStage = EditorStage.NONE;
    this.notifyHideEditor = false;
    this.isVirtualAlbum = false;
    this.isOverride = undefined;
    MediaObserver.getInstance().unregister(MediaObserver.REGISTER_PHOTO_CHANGE, this.epcListener, TAG);
    this.epcListener = undefined;
    Log.info(TAG, 'context clear');
  }

  /**
   *  是否虚拟相册set方法
   * @param isVirtualAlbum
   * @returns
   */
  public setIsVirtualAlbum(isVirtualAlbum: boolean): EditorPhotoContext {
    Log.info(TAG, `setIsVirtualAlbum ${isVirtualAlbum}`);
    this.isVirtualAlbum = isVirtualAlbum;
    return this;
  }

  /**
   *  是否虚拟相册get方法
   * @returns
   */
  public getIsVirtualAlbum(): boolean {
    return this.isVirtualAlbum;
  }

  /**
   *  设置是否可以通知做hide动效
   * @param notifyHideEditor
   * @returns
   */
  public setNotifyHideEditor(notifyHideEditor: boolean): EditorPhotoContext {
    Log.info(TAG, `setNotifyHideEditor ${notifyHideEditor}`);
    this.notifyHideEditor = notifyHideEditor;
    return this;
  }

  /**
   *  获取是否可以通知做hide动效
   * @returns
   */
  public getNotifyHideEditor(): boolean {
    return this.notifyHideEditor;
  }

  /**
   *  设置退出编辑时的url
   * @param editorUriOnExit
   * @returns
   */
  public setEditorUriOnExit(editorUriOnExit: string): EditorPhotoContext {
    Log.info(TAG, `setEditorUriOnExit ${editorUriOnExit}`);
    this.editorUriOnExit = editorUriOnExit;
    return this;
  }

  /**
   *  获取退出编辑时的url
   * @returns
   */
  public getEditorUriOnExit(): string {
    return this.editorUriOnExit;
  }

  /**
   *  设置进入编辑时的url
   * @param editorUriOnEnter
   * @returns
   */
  public setEditorUriOnEnter(editorUriOnEnter: string): EditorPhotoContext {
    Log.info(TAG, `setEditorUriOnEnter ${editorUriOnEnter}`);
    this.editorUriOnEnter = editorUriOnEnter;
    this.epcListener = new EditorPhotoChangeListener(this);
    MediaObserver.getInstance().register(MediaObserver.REGISTER_PHOTO_CHANGE, this.epcListener, TAG);
    return this;
  }

  /**
   *  获取进入编辑时的url
   * @returns
   */
  public getEditorUriOnEnter(): string {
    return this.editorUriOnEnter;
  }

  /**
   *  设置编辑进度
   * @param editorStage
   * @returns
   */
  public setEditorStage(editorStage: EditorStage): EditorPhotoContext {
    Log.info(TAG, `setEditorStage ${editorStage}`);
    this.editorStage = editorStage;
    return this;
  }

  /**
   *  设置是否覆盖保存
   * @param editorStage
   * @returns
   */
  public setIsOverride(isOverride?: boolean): EditorPhotoContext {
    Log.info(TAG, `setIsOverride ${isOverride}`);
    this.isOverride = isOverride;
    return this;
  }

  /**
   *  获取是否编辑覆盖/复原
   * @returns
   */
  public getIsOverride(): boolean | undefined {
    return this.isOverride;
  }

  /**
   *  获取编辑进度
   * @returns
   */
  public getEditorStage(): EditorStage {
    return this.editorStage;
  }

  /**
   *  设置编辑资源类型
   * @param editType
   * @returns
   */
  public setEditorType(editType: EditType): EditorPhotoContext {
    Log.info(TAG, `setEditorType ${editType}`);
    this.editorType = editType;
    return this;
  }

  /**
   *  获取编辑资源类型
   * @returns
   */
  public getEditorType(): EditType {
    return this.editorType;
  }
}