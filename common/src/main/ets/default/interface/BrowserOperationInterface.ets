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

import type { FileType, PhotoAsset } from '../access/UserFileManagerAccess';
import type { common } from '@kit.AbilityKit';

export interface CreateParam {
  fileType: FileType,
  name: string,
}

export interface BrowserOperationInterface {
  create(param: CreateParam): Promise<PhotoAsset>;

  deleteTrash(assets: PhotoAsset[]): Promise<void>;

  deleteAlbumAssetsPermanently(assets: PhotoAsset[]): Promise<void>;

  setHidden(assets: PhotoAsset[], isHidden: boolean): Promise<void>;

  recoverFromTrash(assets: PhotoAsset[]): Promise<void>;

  trash(uri: string[]): Promise<void>;

  remove(uris: PhotoAsset[], albumUri: string): Promise<void>;

  copy(source: PhotoAsset, target: PhotoAsset): Promise<void>;

  favor(uri: string, isFavor: boolean, isHidden?: boolean): Promise<boolean>;

  // api12
  setFavorite(assets: PhotoAsset[], isFavor: boolean): Promise<boolean>;

  setName(source: PhotoAsset, name: string): void;

  change(file: PhotoAsset): Promise<void>;

  dismissAsset(context: common.Context, albumUri: string, assets: PhotoAsset[], albumSubtype?: number): Promise<void>;

}