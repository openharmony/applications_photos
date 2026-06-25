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
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { PhotoAlbum, UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { Constants } from '../model/common/Constants';

const TAG: string = 'CameraAlbumInstance';

export class CameraAlbumInstance {
  private static INSTANCE: PhotoAlbum | undefined;

  private constructor() {
  }

  public static async getInstance(): Promise<PhotoAlbum | undefined> {
    if (CameraAlbumInstance.INSTANCE) {
      Log.info(TAG, 'CameraAlbumInstance singletonInstance exist');
      return CameraAlbumInstance.INSTANCE;
    }
    let albums: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemSourceAlbums(Constants.LPATH_CAMERA);
    if (albums.length === 0) {
      Log.warn(TAG, 'no camera album');
      CameraAlbumInstance.INSTANCE = undefined;
      return CameraAlbumInstance.INSTANCE;
    }
    let cameraAlbum: PhotoAlbum = albums[0];
    CameraAlbumInstance.INSTANCE = cameraAlbum;
    return CameraAlbumInstance.INSTANCE;
  }
}