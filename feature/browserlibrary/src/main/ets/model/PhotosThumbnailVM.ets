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
import { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import { ThumbnailVM } from './ThumbnailVM';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';

const TAG = 'PhotosThumbnailVM';

export class PhotosThumbnailVM extends ThumbnailVM {
  onEnterStartAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    this.browserAnimController.enterOnStart();
    TraceControllerUtils.startTrace(`updatePlaceHolder`);
    this.browserController?.uiContext?.animateToImmediately({
      duration: 1,
      delay: Constants.SET_WHITE_THUMBNAIL_PLACEHOLDER_DELAY,
      onFinish: (() => {
        TraceControllerUtils.finishTrace(`updatePlaceHolder`);
      })
    }, () => {
      this.browserAnimController.updatePlaceHolder(this.item?.uniqueId ?? '', true);
    })
    this.playEnterAnimSync();
    this.setThumbnailShowFunc(true);
  }

  public isShowVideoButton(): boolean {
    return super.isShowVideoButton();
  }
}