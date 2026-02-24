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
struct BindSheetPicker {
  private photoSelectOptions: photoAccessHelper.PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
  controller: TextInputController = new TextInputController();
  @State text: string = '';
  @State index: number = 2;
  @State space: number = 8;
  @State arrowPosition: ArrowPosition = ArrowPosition.END;

  aboutToAppear(): void {
    this.photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.photoSelectOptions.maxSelectNumber = 1;
    this.photoSelectOptions.preselectedUris = ['xxxxxx']
    this.photoSelectOptions.isPreviewForSingleSelectionSupported = true;
  }

  build() {
    Column() {
      Select([
        { value: '*/*' },
        { value: 'image/*' },
        { value: 'video/*' },
        { value: 'image/movingPhoto' },
        { value: 'image/gif' },
        { value: 'image/png' },
        { value: 'image/jpeg' },
        { value: 'image/heif' },
        { value: 'image/heic' },
        { value: 'image/webp' },
        { value: 'image/avif' },
        { value: 'image/Burst' },
        { value: 'video/mp4' },
        { value: 'video/quicktime' }])
        .selected(this.index)
        .value(this.text)
        .space(this.space)
        .arrowPosition(this.arrowPosition)
        .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
        .optionWidth(200)
        .optionHeight(300)
        .onSelect((index: number, text?: string | undefined) => {
          console.info('Select:' + index)
          this.index = index;
          if (text) {
            this.text = text;
          }
        })

      Button('select photo')
        .width(150)
        .margin({ top: topMargin })
        .onClick(() => {
          let photoPicker = new photoAccessHelper.PhotoViewPicker();
          // 使用 Object.values 获取枚举的值并遍历
          for (const value of Object.values(photoAccessHelper.PhotoViewMIMETypes)) {
            if (value === this.text) {
              this.photoSelectOptions.MIMEType = value;
              break;
            }
          }
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
