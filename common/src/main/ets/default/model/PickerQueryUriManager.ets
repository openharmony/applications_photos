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
import lazy common from '@ohos.app.ability.common';
import lazy { SendablePhotoAccessHelper, SendablePhotoAsset } from '../access/SendablePhotoAccessHelper';
import lazy { Log } from '../utils/Log';
import lazy { SendableMediaItem } from './browser/photo/SendableMediaItem';
import lazy { collections } from '@kit.ArkTS';

const TAG: string = 'PickerQueryUriManager';

export class PickerQueryUriManager {
  private context: common.Context;
  private userFileManager: SendablePhotoAccessHelper;

  public constructor(context: common.Context) {
    this.context = context;
    this.userFileManager = new SendablePhotoAccessHelper();
    this.userFileManager.onCreate(this.context);
  }

  public async getMediaItemsByUriList(uris: string[], result: collections.Array<SendableMediaItem>): Promise<void> {
    Log.info(TAG, `uris length is: ${uris.length}`);

    try {
      let sendablePhotoAssets: SendablePhotoAsset[] = await this.getItemsByUriList(uris);
      sendablePhotoAssets.forEach((res): void => {
        let mediaItem: SendableMediaItem = new SendableMediaItem(res);
        result.push(mediaItem);
      });
    } catch (error) {
      Log.error(TAG, 'getMediaItemsByUriList error');
      return;
    }
  }

  public async getItemsByUriList(uris: string[]): Promise<SendablePhotoAsset[]> {
    let objects: SendablePhotoAsset[];
    objects = await this.userFileManager.getPhotoAssetsByUriArray(uris) as SendablePhotoAsset[];
    return objects;
  }

  public onDestroy(): void {
    this.userFileManager.onDestroy();
  }
}