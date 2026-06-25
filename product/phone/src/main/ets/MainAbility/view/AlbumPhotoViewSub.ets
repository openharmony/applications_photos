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
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import { PhotosHmBrowserController } from '@ohos/browserlibrary';
import lazy { PhotoGridViewBuilder } from './PhotoGridViewBuilder';

/* instrument ignore file */
const TAG = 'AlbumPhotoViewSub';

@Component
export struct AlbumPhotoViewSub {
  @Prop private isShowPhotoGridView: boolean;
  @Link private pageStatus: boolean;
  @Prop private isRefreshPhotoGridView: boolean = false;
  @Consume private browserController: PhotosHmBrowserController;
  @Link private isSelectedMode: boolean;
  @Link private navigationPageInfos: NavPathStack;

  build() {
    Stack() {
      if (this.isShowPhotoGridView) {
        // sidebar 在两宫格间切换
        if (this.isRefreshPhotoGridView) {
          PhotoGridViewBuilder({
            pageStatus: this.pageStatus,
            isSelectedMode: this.isSelectedMode,
            isShowPhotoGridView: this.isShowPhotoGridView,
            navigationPageInfos: this.navigationPageInfos,
          });
        } else {
          PhotoGridViewBuilder({
            pageStatus: this.pageStatus,
            isSelectedMode: this.isSelectedMode,
            isShowPhotoGridView: this.isShowPhotoGridView,
            navigationPageInfos: this.navigationPageInfos,
          });
        }
      }
    }
  }
}