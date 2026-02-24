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

import type { BrowserOperationInterface, CreateParam } from '../../../interface/BrowserOperationInterface';
import lazy { Log } from '../../../utils/Log';
import type { FetchOptions, PhotoAlbum } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy fileio from '@ohos.fileio';
import lazy { AlbumDefine } from '../AlbumDefine';
import type common from '@ohos.app.ability.common';
import type { PhotoAsset } from '../../../access/PhotoAccessHelperAccess';
import lazy { PhotoAccessHelperAccess } from '../../../access/PhotoAccessHelperAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { StringUtil } from '../../../utils/StringUtil';

/* instrument ignore file */
const TAG: string = 'common_OperationImpl';

export class OperationImpl implements BrowserOperationInterface {
  public async favor(uri: string, isFavor: boolean, isHidden?: false): Promise<boolean> {
    Log.info(TAG, `favor, id ${uri}`);
    try {
      if (isHidden) {
        const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
        let photoAsset: PhotoAsset | undefined = await PhotoAccessHelperAccess.getHiddenAsset(context, uri);
        photoAsset?.setFavorite(isFavor);
        return true;
      }
      let fileAsset: PhotoAsset =
        (await UserFileManagerAccess.getInstance()
          .getFirstObject(AlbumDefine.getFileFetchOptByUri(uri), TAG)).obj as PhotoAsset;
      fileAsset.setFavorite(isFavor);
      return true;
    } catch (e) {
      Log.error(TAG, `favor error ${e}`);
      return false;
    }
  }

  /**
   * 批量设置收藏接口
   * @param assets 需要操作的对象数组
   * @param isFavor 收藏/取消收藏
   * @returns 操作是否成功
   */
  public async setFavorite(assets: PhotoAsset[], isFavor: boolean): Promise<boolean> {
    Log.info(TAG, `setFavorite length: ${assets?.length}`);
    if (assets === undefined || isFavor === undefined) {
      Log.error(TAG, `setFavorite params undefined`);
      return false;
    }
    try {
      const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
      let accessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      let assetsChangeRequest: photoAccessHelper.MediaAssetsChangeRequest =
        new photoAccessHelper.MediaAssetsChangeRequest(assets);
      assetsChangeRequest.setFavorite(isFavor);
      await accessHelper.applyChanges(assetsChangeRequest);
      return true;
    } catch (e) {
      Log.error(TAG, `favor error ${e}`);
      return false;
    }
  }

  public async deleteTrash(assets: PhotoAsset[]): Promise<void> {
    await UserFileManagerAccess.getInstance().deleteFromTrash(assets);
  }

  public async deleteAlbumAssetsPermanently(assets: PhotoAsset[]): Promise<void> {
    await UserFileManagerAccess.getInstance().deleteAssetsPermanently(assets);
  }

  // 图片隐藏
  public async setHidden(assets: PhotoAsset[], isHidden: boolean = true): Promise<void> {
    await UserFileManagerAccess.getInstance().setHidden(assets, isHidden);
  }

  public async recoverFromTrash(assets: PhotoAsset[]): Promise<void> {
    await UserFileManagerAccess.getInstance().recoverFromTrash(assets);
  }

  public async copy(source: PhotoAsset, target: PhotoAsset): Promise<void> {
    Log.info(TAG, `copy start: src:${source.uri} target: ${target.uri}`);

    let fd = await UserFileManagerAccess.getInstance().openAsset('R', source);
    if (fd <= 0) {
      throw new Error('fd is invalid');
      return;
    }

    let targetFd = await UserFileManagerAccess.getInstance().openAsset('RW', target);
    if (targetFd <= 0) {
      throw new Error('targetFd is invalid');
      return;
    }

    await this.readAndWriteData(fd, targetFd);

    Log.info(TAG, `[fd flag] copy close fd: ${fd}`);
    await source.close(fd);
    Log.info(TAG, `[fd flag] copy close targetFd: ${targetFd}`);
    await target.close(targetFd);

    Log.debug(TAG, 'copy end');
  }

  public async trash(uris: string[]): Promise<void> {
    Log.debug(TAG, `trash start ${JSON.stringify(uris)}`);
    await UserFileManagerAccess.getInstance().deleteToTrash(uris);
  }

  public async remove(fileAssets: PhotoAsset[], albumUri: string): Promise<void> {
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
    if (album) {
      if (fileAssets.length > 0) {
        await album.removeAssets(fileAssets);
      }
    }
    Log.debug(TAG, 'remove end');
  }

  public async create(param: CreateParam): Promise<PhotoAsset> {
    let tmp: PhotoAsset =
      await UserFileManagerAccess.getInstance().createAsset(param.fileType, param.name) as PhotoAsset;
    return tmp;
  }

  public async change(file: PhotoAsset): Promise<void> {
    await file.commitModify();
  }

  public setName(source: PhotoAsset, name: string): void {
    let displayName: string = StringUtil.generateDisplayName(source.displayName, name);
    source.set(photoAccessHelper.PhotoKeys.TITLE.toString(), name);
    Log.info(TAG, `setName title: ${StringUtil.garbleFileName(name)}, displayName: ${displayName}`);
  }

  public async readAndWriteData(srcFd: number, targetFd: number): Promise<void> {
    Log.debug(TAG, 'readAndWriteData start!');
    let stat = await fileio.fstat(srcFd);
    Log.debug(TAG, `readAndWriteData read stat.size ${stat.size}`);
    if (stat.size === 0) {
      return;
    }
    let step = 10000000;
    let last = stat.size % step;
    let count = (stat.size - last) / step;
    if (last > 0) {
      count = count + 1;
    }
    Log.debug(TAG, `readAndWriteData read count ${count} last ${last}`);

    for (let i = 0; i < count; i++) {
      let rwSize = 0;
      if (i === (count - 1)) {
        rwSize = last;
      } else {
        rwSize = step;
      }
      let buf = new ArrayBuffer(rwSize);

      class RWOptions {
        offset?: number;
        length?: number;
        position?: number;
        encoding?: string;
      }

      let readOptions: RWOptions = {
        offset: 0,
        length: rwSize,
        position: i * step,
      };
      await fileio.read(srcFd, buf, readOptions);
      let writeOptions: RWOptions = {
        offset: 0,
        length: rwSize,
        position: i * step,
        encoding: 'utf-8',
      };
      await fileio.write(targetFd, buf, writeOptions);
    }
    Log.debug(TAG, 'readAndWriteData end!');
  }

  public async dismissAsset(context: common.Context, albumUri: string, assets: PhotoAsset[], albumSubtype?: number):
    Promise<void> {
    const album = await PhotoAccessHelperAccess.getAlbumByUri(context, {
      albumType: photoAccessHelper.AlbumType.SMART,
      albumSubtype: albumSubtype ?? photoAccessHelper.AlbumSubtype.CLASSIFY,
      albumUri
    });
    await PhotoAccessHelperAccess.removeFromClassAlbum(context, album, assets);
  }
}