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

import lazy { common } from '@kit.AbilityKit';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { PhotoPropertiesManager } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoPropertiesManager';
import lazy { PhotoProperties } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoProPerties';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';

/* instrument ignore file */
/* instrument ignore next */
@Concurrent
export async function updatePhotoNoteAsync(context: common.Context, uri: string,
  isHiddenAlbum: boolean | undefined): Promise<string> {
  let photoAccessHelper: UserFileManagerAccess = new UserFileManagerAccess();
  let result: string = '';
  try {
    photoAccessHelper.onCreate(context);
    result = await photoAccessHelper.getUserComment(uri, isHiddenAlbum);
  } catch (e) {
    Log.error('PhotoPropertiesAsync', `exif EditUserComment failed with err : ${e}`);
  } finally {
    photoAccessHelper.release();
  }
  return result;
}

/* instrument ignore next */
@Concurrent
export async function updateFilePositionAsync(context: common.Context, fileAsset: photoAccessHelper.PhotoAsset):
  Promise<PhotoProperties | undefined> {
  try {
    let task: PhotoPropertiesManager = new PhotoPropertiesManager(context);
    return await task.getPhotoProperties(fileAsset);
  } catch (e) {
    Log.error('PhotoPropertiesAsync', `updateFilePositionAsync err: : ${e}`);
    return undefined;
  }
}