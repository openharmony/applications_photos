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

import type { FileAsset, FileType } from '../access/UserFileManagerAccess';

export type CreateParam = {
  fileType: FileType,
  name: string,
};

export interface BrowserOperationInterface {
  create(param: any): any;

  delete(uri: string): any;

  deleteTrash(assets: Array<FileAsset>): any;

  recoverFromTrash(assets: Array<FileAsset>): any;

  trash(uri: string, isTrash: boolean): any;

  remove(uris: Array<string>, albumUri: string): any;

  copy(source: any, target: any): any;

  favor(uri: string, isFavor: boolean): void;

  setName(source: any, name: string): void;

  change(source: any): any;
}