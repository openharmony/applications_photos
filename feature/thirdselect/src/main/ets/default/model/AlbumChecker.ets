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
import lazy { PhotoAlbum, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { PickerMediaDataSource } from '../common/PickerMediaDataSource';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';

const TAG: string = 'third_select_AlbumChecker';

/**
 * 在数据发生变更的场景下，校验相册是否被删除
 */
export class AlbumChecker {
  private readonly dataSource: PickerMediaDataSource | undefined;
  private session: UIExtensionContentSession | undefined;
  private isChecking: boolean = false;
  private hasPending: boolean = false;

  public constructor(dataSource: PickerMediaDataSource | undefined,
    session: UIExtensionContentSession | undefined) {
    this.dataSource = dataSource;
    this.session = session;
  }

  public async check(): Promise<void> {
    if (this.isChecking) {
      this.hasPending = true;
      return;
    }
    try {
      this.isChecking = true;
      let albumUri: string | undefined = this.dataSource?.albumUri;
      if (!albumUri || albumUri.trim().length === 0 || albumUri === Constants.ALBUM_URI_ALL_MEDIA) {
        return;
      }
      let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
      if (!album) {
        Log.info(TAG, `$album has been deleted: ${albumUri}`);
        this.session?.sendData({ 'dataType': 'currentAlbumDeleted', });
      }
    } finally {
      this.isChecking = false;
      if (this.hasPending) {
        this.hasPending = false;
        this.check();
      }
    }
  }
}