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

import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { PreviewThumbnailVM } from '../viewModel/base/PreviewThumbnailVM';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { PhotoBrowserStateMachine } from '../viewModel/statemachine/PhotoBrowserStateMachine';

const TAG: string = 'common_PreviewThumbnail';

@Component
export struct PreviewThumbnail {
  @ObjectLink stateMachine: PhotoBrowserStateMachine
  @Prop mediaResult: MediaResult;
  // 进入和退出连拍时，当前缩略图的透明度
  @Prop centerPreviewOpacity: number = 1;
  // 进入和退出连拍时，两侧缩略图的透明度
  @Prop previewItemOpacity: number = 1;

  private viewModel: PreviewThumbnailVM = new PreviewThumbnailVM(this.stateMachine);

  build() {
    if (this.mediaResult.item?.thumbnailPixmap) {
      Image(this.mediaResult.item?.thumbnailPixmap)
        .attributeModifier(this.viewModel.imageModifier)
        .focusable(true)
        .hitTestBehavior(HitTestMode.Transparent)
        .draggable(false)
        .objectFit(ImageFit.Cover)
        .autoResize(false)
        .alignSelf(ItemAlign.Center)
        .align(Alignment.Center)
        .width(this.mediaResult?.itemWidth)
        .height((this.mediaResult?.pos === this.viewModel.getCurrentIndex()) ?
        ImageUtil.getSelectedSmallImgHeight() : ImageUtil.getSmallImgHeight())
        .opacity((this.mediaResult?.pos === this.viewModel.getCurrentIndex()) ? this.centerPreviewOpacity :
        this.previewItemOpacity)
    }
  }

  aboutToAppear() {
    Log.info(TAG, 'PreviewThumbnail aboutToAppear');
    this.viewModel.onCreate(this.mediaResult, this.centerPreviewOpacity, this.previewItemOpacity);
  }

  aboutToDisappear() {
    this.viewModel.onDestroy();
  }
}

