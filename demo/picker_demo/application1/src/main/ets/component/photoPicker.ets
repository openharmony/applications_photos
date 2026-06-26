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
  PhotoPickerComponent,
  PickerController,
  PickerOptions,
  PhotoBrowserInfo,
  VideoPlayerState,
} from '@ohos.file.PhotoPickerComponent';

@Component
struct PhotoPicker {
  @State pickerController: PickerController = new PickerController();
  @State videoState: VideoPlayerState = 0
  @State h: string = '100%'
  @Consume isShowButton: boolean
  @Consume pickerOffsetX: number
  @State pickerOptions: PickerOptions = {
    gridMargin: { top: '10vp', bottom: '20vp' },
  }

  build() {

    Stack() {
      PhotoPickerComponent({
        pickerController: this.pickerController,
        onVideoPlayStateChanged: (e: VideoPlayerState) => {
          this.videoState = e
        },
        onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo) => {
          return true
        },
        onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo) => {
          return true
        }
      }).width('100%').height(this.h)
    }
  }
}

export {
  PhotoPicker
}