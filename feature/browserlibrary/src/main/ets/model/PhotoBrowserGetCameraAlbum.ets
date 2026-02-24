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
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
/* instrument ignore file */
const TAG: string = 'PhotoBrowserGetCameraAlbum';

/**
 * BasePhotoBrowserController里用来加载相机相册并设置到数据源里
 */
export class PhotoBrowserGetCameraAlbum {
  // 相机进大图需要保存相机相册到数据源用于筛选相机相册照片，分享场景需要设置相机相册筛选相机相册照片
  public static cameraAlbumInfo: AlbumInfo | undefined = undefined;
  // 是否正常查询相机相册info，避免多次触发查询操作
  public static isGetCameraAlbumInfo: boolean = false;


  public static getCameraAlbumInfo(callback?: (albumInfo: AlbumInfo | undefined) => void) {
    if (PhotoBrowserGetCameraAlbum.isGetCameraAlbumInfo) {
      callback?.(PhotoBrowserGetCameraAlbum.cameraAlbumInfo);
      return;
    }
    PhotoBrowserGetCameraAlbum.isGetCameraAlbumInfo = true;
    UserFileManagerAccess.getInstance().getSourceAlbumByCamera()
      .then((albumInfo: AlbumInfo | undefined) => {
        if (albumInfo) {
          Log.info(TAG, 'getCameraAlbumInfo getSourceAlbumByLPath successes');
          PhotoBrowserGetCameraAlbum.cameraAlbumInfo = albumInfo;
        } else {
          Log.error(TAG, 'getCameraAlbumInfo getSourceAlbumByLPath failed');
          PhotoBrowserGetCameraAlbum.isGetCameraAlbumInfo = false;
        }
        callback?.(albumInfo);
      });
  }
}