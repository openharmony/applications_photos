/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { Log } from '../../../utils/Log';
import type { FileAsset } from '../../../access/UserFileManagerAccess';
import { Album, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import fileio from '@ohos.fileio';
import { AlbumDefine } from '../AlbumDefine';
import { StringUtil } from '../../../utils/StringUtil';
import userFileManager from '@ohos.filemanagement.userFileManager';

const TAG: string = 'common_OperationImpl';

export class OperationImpl implements BrowserOperationInterface {
  async favor(uri: string, isFavor: boolean): Promise<boolean> {
    Log.info(TAG, `favor, id ${uri}`);
    try {
      let fileAsset = (await UserFileManagerAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptByUri(uri))).obj
      fileAsset.favorite(isFavor);
      return true;
    } catch (e) {
      Log.error(TAG, `favor error ${e}`);
      return false;
    }
  }

  async delete(uris: Array<string>): Promise<void> {
    await UserFileManagerAccess.getInstance().deleteToTrash(uris);
  }

  async deleteTrash(assets: Array<FileAsset>): Promise<void> {
    await UserFileManagerAccess.getInstance().deleteFromTrash(assets);
  }

  async recoverFromTrash(assets: Array<FileAsset>): Promise<void> {
    await UserFileManagerAccess.getInstance().recoverFromTrash(assets);
  }

  async copy(source: FileAsset, target: FileAsset): Promise<void> {
    Log.info(TAG, `copy start: src:${source.uri} target: ${target.uri}`);

    let fd = await UserFileManagerAccess.getInstance().openAsset('R', source);
    if (fd <= 0) {
      throw 'fd is invalid'
      return;
    }

    let targetFd = await UserFileManagerAccess.getInstance().openAsset('RW', target);
    if (targetFd <= 0) {
      throw 'targetFd is invalid'
      return;
    }

    await this.readAndWriteData(fd, targetFd);

    await source.close(fd);
    await target.close(targetFd);

    Log.debug(TAG, 'copy end')
  }

  async trash(uris: Array<string>): Promise<void> {
    Log.debug(TAG, `trash start ${JSON.stringify(uris)}`);
    await UserFileManagerAccess.getInstance().deleteToTrash(uris);
  }

  async remove(uris: Array<string>, albumUri: string): Promise<void> {
    Log.debug(TAG, `remove start ${JSON.stringify(uris)} from ${JSON.stringify(albumUri)}`);
    let album: Album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
    if (album) {
      let fileAssets: Array<FileAsset> = new Array<FileAsset>();
      for (let i = 0; i < uris.length; i++) {
        let fileAsset = (await UserFileManagerAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptByUri(uris[i]))).obj;
        if (fileAsset) {
          fileAssets.push(fileAsset);
        }
      }
      if (fileAssets.length > 0) {
        await album.removePhotoAssets(fileAssets);
      }
    }
    Log.debug(TAG, `remove end`);
  }

  async create(param: CreateParam): Promise<FileAsset> {
    return await UserFileManagerAccess.getInstance().createAsset(param.fileType, param.name);
  }

  async change(file: FileAsset): Promise<void> {
    await file.commitModify();
  }

  setName(source: FileAsset, name: string): void {
    let displayName = source.displayName;
    let index = displayName.lastIndexOf('.');
    displayName = name + displayName.slice(index);
    source.displayName = displayName;
    source.set(userFileManager.ImageVideoKey.TITLE.toString(), name);
    Log.info(TAG, `setName title: ${name}, displayName: ${displayName}`);
  }

  async readAndWriteData(srcFd: number, targetFd: number) {
    Log.debug(TAG, 'readAndWriteData start!')
    let stat = await fileio.fstat(srcFd);
    Log.debug(TAG, `readAndWriteData read stat.size ${stat.size}`)
    if (stat.size == 0) {
      return;
    }
    let step = 10000000;
    let last = stat.size % step;
    let count = (stat.size - last) / step;
    if (last > 0) {
      count = count + 1;
    }
    Log.debug(TAG, `readAndWriteData read count ${count} last ${last}`)

    for (let i = 0; i < count; i++) {
      let rwSize = 0;
      if (i == (count - 1)) {
        rwSize = last;
      } else {
        rwSize = step;
      }
      let buf = new ArrayBuffer(rwSize);
      let readOptions = {
        offset: 0,
        length: rwSize,
        position: i * step
      }
      await fileio.read(srcFd, buf, readOptions);
      let writeOptions = {
        offset: 0,
        length: rwSize,
        position: i * step,
        encoding: 'utf-8'
      }
      await fileio.write(targetFd, buf, writeOptions);
    }
    Log.debug(TAG, 'readAndWriteData end!')
  }
}