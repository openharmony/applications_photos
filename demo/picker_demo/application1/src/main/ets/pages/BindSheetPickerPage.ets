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
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';

const topMargin: number = 20;

@Entry
@Component
struct BindSheetPickerPage {
  private photoSelectOptions: photoAccessHelper.PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();

  aboutToAppear(): void {
    this.photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.photoSelectOptions.maxSelectNumber = 99;
    this.photoSelectOptions.preselectedUris = ['xxxxxx']
  }

  build() {
    Column() {
      Button('选择所有')
        .margin({ top: topMargin })
        .onClick(() => {
          this.photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
        })
      Button('选择图片')
        .margin({ top: topMargin })
        .onClick(() => {
          this.photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
        })
      Button('选择视频')
        .margin({ top: topMargin })
        .onClick(() => {
          this.photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
        })
      Button('动态图片')
        .margin({ top: topMargin })
        .onClick(() => {
          this.photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE;
        })

      Button('select photo')
        .width(150)
        .margin({ top: topMargin })
        .onClick(() => {
          let photoPicker = new photoAccessHelper.PhotoViewPicker();
          photoPicker.select(this.photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
            console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' +
            JSON.stringify(photoSelectResult));
          })
            .catch((err: BusinessError) => {
              console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
            });
        })
    }.padding(20)
  }
}
