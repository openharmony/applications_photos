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
import lazy { AlbumThirdSelectDataImpl } from './AlbumThirdSelectDataImpl';
import lazy { common } from '@kit.AbilityKit';
import lazy { Log } from '../../../utils/Log';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { AlbumInfo } from './AlbumInfo';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_FaCardDataImpl';

export class FaCardDataImpl extends AlbumThirdSelectDataImpl {
  private albumType: string | undefined = '';

  constructor(context?: common.Context, albumType?: string) {
    super(context);
    this.albumType = albumType;
  }

  protected async buildAlbums(callback: AsyncCallback<AlbumInfo[]>, filterMediaType?: string): Promise<void> {
    Log.debug(TAG, 'buildAlbums');

    let sourceData: AlbumInfo[] = [];
    if (this.albumType === 'normal') {
      if (DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen()) {
        await this.buildNormalAlbums(sourceData, filterMediaType);
      } else {
        await this.getSystemAlbumsInfo(sourceData, filterMediaType);
        await this.getUserAlbumsInfo(sourceData, filterMediaType);
      }
      await this.getTrashAlbumInfo(sourceData, filterMediaType);
    } else if (this.albumType === 'source') {
      // sourceAlbum
      if (DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldScreen()) {
        await this.buildSourceAlbums(sourceData, filterMediaType);
      } else {
        await this.getSourceAlbumInfo(sourceData, filterMediaType);
      }
    }
    sourceData = sourceData.filter(item => item.count);
    callback.callback(sourceData);
  }
}