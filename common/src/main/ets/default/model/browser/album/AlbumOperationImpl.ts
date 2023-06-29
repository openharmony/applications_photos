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
import type { BrowserOperationInterface } from '../../../interface/BrowserOperationInterface';
import { Log } from '../../../utils/Log';
import type { Album, FileAsset } from '../../../access/UserFileManagerAccess';

const TAG: string = 'common_AlbumOperationImpl';

export class AlbumOperationImpl implements BrowserOperationInterface {
  setName(album: Album, name: string): void {
    album.albumName = name;
  }

  async change(album: Album): Promise<void> {
    await album.commitModify();
  }

  favor(uri: string, isFavor: boolean): void {
  }

  delete(uri: string): void {
  }

  deleteTrash(assets: Array<FileAsset>): void {

  }

  recoverFromTrash(assets: Array<FileAsset>): void {

  }

  copy(source: unknown, target: unknown): void {
  }

  trash(uri: string, isTrash: boolean): void {
  }

  remove(uris: Array<string>, albumUri: string): void {
  }

  create(param: unknown): void {
  }
}