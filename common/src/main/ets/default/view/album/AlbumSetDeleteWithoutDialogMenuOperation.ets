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

import lazy { AsyncCallback } from '../../../default/model/common/AsyncCallback';
import lazy { BrowserDataFactory } from '../../../default/interface/BrowserDataFactory';
import type { AlbumSimpleInfo } from '../../../default/model/browser/album/AlbumDataImpl';
import lazy { AlbumSetDeleteMenuOperation } from './AlbumSetDeleteMenuOperation';

/* instrument ignore file */

export class AlbumSetDeleteWithoutDialogMenuOperation extends AlbumSetDeleteMenuOperation {
  public doAction(): void {
    if (!this.isPrepareUrisSuccess()) {
      return;
    }
    // api9：获取相册内图片，把相册内图片删完，相册也就删除了
    // api10：直接删除相册
    let albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
    let callback: AsyncCallback = {
      callback: (info: AlbumSimpleInfo): void => {
        this.dataCallback(info, false);
      }
    };
    albumDataImpl?.getData(callback, { uris: this.uris });
  }
}