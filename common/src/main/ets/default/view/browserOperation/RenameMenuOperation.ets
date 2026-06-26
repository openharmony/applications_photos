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

import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Log } from '../../utils/Log';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { StringUtil } from '../../utils/StringUtil';
import lazy { MenuConstants } from '../../view/actionbar/Menu';
import type { MenuContext } from '../../view/browserOperation/MenuContext';
import type { MenuOperation } from '../../view/browserOperation/MenuOperation';
import type { MenuOperationCallback } from '../../view/browserOperation/MenuOperationCallback';
import lazy { BrowserDataFactory } from '../../interface/BrowserDataFactory';
import type { BrowserDataInterface } from '../../interface/BrowserDataInterface';
import lazy { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import type { BrowserOperationInterface } from '../../interface/BrowserOperationInterface';
import lazy { AlbumDataSource } from '../../model/AlbumDataSource';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { Constants } from '../../model/browser/photo/Constants';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { MenuContextConstants } from '../../model/common/MenuContextConstants';

/* instrument ignore file */
const TAG: string = 'RenameMenuOperation';

export interface OnCompletedResult {
  title: string,
  displayName: string,
}

export type OnCompletedCallback = (result: OnCompletedResult) => void;

export class RenameMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private confirmCallbackFunc: Function = async (title: string): Promise<void> => this.confirmCallback(title);
  private cancelCallbackFunc: Function = async (): Promise<void> => this.cancelCallback();
  private onOperationStart: Function = (): void => {
  };
  private onOperationEnd: Function = (): void => {
  };

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  public doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    let fileName = '';
    let title: string = mediaItem.getTitle();
    if (title) {
      fileName = title;
    } else {
      let index = mediaItem.displayName.lastIndexOf('.');
      fileName = mediaItem.displayName.substr(0, index);
    }
    this.onOperationStart = this.menuContext.onOperationStart;
    this.onOperationStart?.();
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
      [fileName, this.confirmCallbackFunc, this.cancelCallbackFunc]);
  }

  public onCompleted: OnCompletedCallback = (result: OnCompletedResult): void => {
    Log.info(TAG, 'Rename data succeed!');
  };

  public onError(): void {
    Log.error(TAG, 'Rename data failed!');
  }

  public async rename(uri: string, name: string): Promise<OnCompletedResult> {
    Log.info(TAG, 'renameSinglePhoto start');
    // 查询图片对象
    let dataImpl: BrowserDataInterface | undefined =
      this.menuContext.get<BrowserDataInterface>(MenuContextConstants.PHOTO_DATA_IMPL);
    if (!dataImpl) {
      dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
    }
    // getDataByUri 返回 MayVoid<PhotoAsset>，失败场景通常用 number 错误码表示
    const mayVoidResult = await dataImpl?.getDataByUri(uri) as photoAccessHelper.PhotoAsset | number;
    if (typeof mayVoidResult === 'number') {
      throw new Error(`getDataByUri failed, errCode: ${mayVoidResult}`);
    }
    const fileAsset: photoAccessHelper.PhotoAsset = mayVoidResult;
    // 更新图片名称
    let operationImpl: BrowserOperationInterface =
      BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    operationImpl.setName(fileAsset, name);
    await operationImpl.change(fileAsset);
    // 返回更新后的结果(fileAsset中displayName未刷新，在此重新拼接)
    return {
      title: String(fileAsset.get(photoAccessHelper.PhotoKeys.TITLE.toString())),
      displayName: StringUtil.generateDisplayName(fileAsset.displayName, name),
    };
  }

  public async confirmCallback(title: string, mediaItem?: MediaItem): Promise<void> {
    Log.info(TAG, `Rename confirm new name, title: ${StringUtil.garbleFileName(title)}`);
    let item: MediaItem | undefined;
    if (!mediaItem) {
      item = this.menuContext.mediaItem;
    } else {
      item = mediaItem;
    }

    if (!item) {
      Log.error(TAG, 'item is null, return');
      return;
    }
    try {
      let result = await this.rename(item.uri, title);
      item.setTitle(result.title);
      item.displayName = result.displayName;
      this.menuContext.broadCast?.emit(Constants.RENAME, [result, item.uniqueId]);
      this.onCompleted(result);
      this.onOperationEnd = this.menuContext.onOperationEnd;
      this.onOperationEnd?.(item);
    } catch (err) {
      Log.error(TAG, `Rename error: ${err}, code: ${err?.code}`);
      UiUtil.showToast($r('app.string.rename_failed'));
    }
  }

  private cancelCallback(): void {
    Log.info(TAG, 'Rename cancel');
  }
}