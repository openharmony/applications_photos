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
import lazy { BusinessError } from '@ohos.base';
import lazy { UserFileManagerAccess, MediaCount } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';

const TAG = 'PickerThumbnailCreator'
const STORAGE_KEY = 'PICKER_THUMBNAIL_CREATOR_INSTANCE'

export class PickerThumbnailCreator {
  private userFileManagerAccessInstance: UserFileManagerAccess = UserFileManagerAccess.getInstance();

  public static getInstance() {
    let instance = AppStorage.get<PickerThumbnailCreator>(STORAGE_KEY);
    if (!instance) {
      instance = new PickerThumbnailCreator();
      AppStorage.setOrCreate<PickerThumbnailCreator>(STORAGE_KEY, instance);
    }
    return instance
  }

   /**
   * 异步查询媒体库获取资源数
   * @returns
   */
  public getResourceCount(): Promise<MediaCount[]> {
    return Promise.all<Promise<MediaCount>[]>([
      this.userFileManagerAccessInstance
        .getCountGroupByMediaType('query image/video count', false, false, false, false, true, true),
      this.userFileManagerAccessInstance.getCountGroupByMediaType('query readyCount', false, false, false,
        true, true, true)
    ])
  }

  public start(): void {
    this.getResourceCount()
      .then((res) => {
        const count = res[0];
        const readyCount = res[1];
        const allResHasThumbnail =
          (count.imageCount + count.videoCount) === (readyCount.imageCount + readyCount.videoCount);

        if (allResHasThumbnail) {
          Log.debug(TAG, 'allResHasThumbnail');
          return;
        }
        Log.debug(TAG, 'startCreateThumbnail');
        this.userFileManagerAccessInstance.startCreateThumbnailTask(
          UserFileManagerAccess.FILE_KEY_DATE_ADDED
        );
      })
      .catch((err: BusinessError) => {
        Log.error(TAG, `getResourceCount fail ${err.code}`)
      })
  }

  public stop(){
    this.userFileManagerAccessInstance.stopCreateThumbnailTask()
  }

  public registerDestroyCallBack(fn: Function) {
    this.userFileManagerAccessInstance.registerDestroyCallBack(fn)
  }
}