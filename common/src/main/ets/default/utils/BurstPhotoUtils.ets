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
/* instrument ignore file*/
import lazy { PhotoAsset } from '../access/PhotoAccessHelperAccess';
import lazy { FetchOptions, UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { AlbumDefine } from '../model/browser/AlbumDefine';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { Constants } from '../model/common/Constants';
import lazy { Log } from './Log';

const TAG: string = 'common_BurstPhotoUtils';

export class BurstPhotoUtils {
  public static async getBurstUris(items: MediaItem[]): Promise<string[]> {
    Log.info(TAG, 'getBurstPhotoResult begin');
    const fetchOpt: FetchOptions = AlbumDefine.getBurstPhotosFetchOpt(Constants.INVALID, Constants.INVALID, false);
    let result: PhotoAsset[] = [];
    let uriArray: string[] = [];
    for (let item of items) {
      if (item?.getIsBurstPhotos() && item.burstKey) {
        result = await UserFileManagerAccess.getInstance().getBurstPhotosObject(item.burstKey, fetchOpt);
        for (let burstItem of result) {
          //获取连拍照片
          uriArray.push(burstItem.uri);
        }
      } else {
        //获取非连拍图片
        uriArray.push(item.uri);
      }
    }
    return uriArray;
  }
}