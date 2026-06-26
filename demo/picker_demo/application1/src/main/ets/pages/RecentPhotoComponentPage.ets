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

import lazy {
  RecentPhotoComponent,
  RecentPhotoOptions,
  RecentPhotoCheckResultCallback,
  RecentPhotoClickCallback,
  PhotoSource,
  RecentPhotoInfo,
  RecentPhotoCheckInfoCallback,
} from '@ohos.file.RecentPhotoComponent';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { BaseItemInfo } from '@ohos.file.PhotoPickerComponent';

const TAG: string = 'pxy';

@Entry
@Component
struct RecentPhotoComponentPage {
  private recentPhotoOptions: RecentPhotoOptions = new RecentPhotoOptions();
  private recentPhotoCheckResultCallback: RecentPhotoCheckResultCallback =
    (recentPhotoExists: boolean) => this.onRecentPhotoCheckResult(recentPhotoExists);
  private recentPhotoClickCallback: RecentPhotoClickCallback =
    (recentPhotoInfo: BaseItemInfo): boolean => this.onRecentPhotoClick(recentPhotoInfo);
  private recentPhotoCheckInfoCallback: RecentPhotoCheckInfoCallback =
    (recentPhotoExists: boolean, info: RecentPhotoInfo) => this.onRecentPhotoCheckInfo(recentPhotoExists, info);

  aboutToAppear() {
    this.recentPhotoOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.recentPhotoOptions.period = 1000;
    this.recentPhotoOptions.photoSource = PhotoSource.ALL;

  }

  private onRecentPhotoCheckInfo(recentPhotoExists: boolean, info: RecentPhotoInfo): void {
    console.log(TAG, 'onRecentPhotoCheckInfo enter.');
  }

  private onRecentPhotoCheckResult(recentPhotoExists: boolean): void {
    console.log(TAG, 'onRecentPhotoCheckResult enter.');
    // 存在符合条件的照片或视频
    if (recentPhotoExists) {
      console.info(TAG, 'The photo is exist.');
    } else {
      console.info(TAG, 'The photo is not exist.');
    }
  }

  private onRecentPhotoClick(recentPhotoInfo: BaseItemInfo): boolean {
    console.log(TAG, 'onRecentPhotoClick enter.');
    // 照片或视频返回
    if (recentPhotoInfo) {
      console.info(TAG, 'The photo uri is ' + recentPhotoInfo.uri);
      return true;
    }

    return true;
  }

  build() {
    Stack() {
      RecentPhotoComponent({
        recentPhotoOptions: this.recentPhotoOptions,
        onRecentPhotoCheckResult: this.recentPhotoCheckResultCallback,
        onRecentPhotoClick: this.recentPhotoClickCallback,
        onRecentPhotoCheckInfo: this.recentPhotoCheckInfoCallback,
      }).height('100%').width('100%')
    }
  }
}