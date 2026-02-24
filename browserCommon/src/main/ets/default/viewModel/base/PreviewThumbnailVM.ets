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

import lazy { ImageModifier } from '@kit.ArkUI';
import lazy { IStateChangeListener } from '../statemachine/IPhotoBrowserState';
import lazy { PhotoBrowserStateMachine } from '../statemachine/PhotoBrowserStateMachine';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { PhotoItemImageModifier } from '../../utils/CustomModifier';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';

const TAG = 'common_PreviewThumbnailVM';

@Observed
export class PreviewThumbnailVM implements IStateChangeListener {
  /**
   * SwiperView单属性刷新控制器
   */
  public imageModifier: PhotoItemImageModifier = new PhotoItemImageModifier();

  private stateMachine: PhotoBrowserStateMachine;

  private mediaResult: MediaResult | undefined = undefined;

  private previewItemOpacity: number = 1;

  private centerPreviewOpacity: number = 1;

  constructor(stateMachine: PhotoBrowserStateMachine) {
    this.stateMachine = stateMachine;
  }

  public onCreate(mediaResult: MediaResult, centerPreviewOpacity: number, previewItemOpacity: number): void {
    this.mediaResult = mediaResult;
    this.centerPreviewOpacity = centerPreviewOpacity;
    this.previewItemOpacity = previewItemOpacity
    this.stateMachine.registerStateChangeListener(this, true);
  }

  public onDestroy(): void {
    this.stateMachine.unregisterStateChangeListener(this);
  }


  getCurrentIndex(): number {
    return this.stateMachine.getCurrentIndex();
  }

  onCurrentIndexChange(currentIndex: number): void {
    this.imageModifier.attribute?.height((this.mediaResult?.pos === currentIndex) ?
    ImageUtil.getSelectedSmallImgHeight() : ImageUtil.getSmallImgHeight());
    this.imageModifier.attribute?.opacity((this.mediaResult?.pos === currentIndex) ?
    this.centerPreviewOpacity : this.previewItemOpacity);
    Log.info(TAG, 'run onCurrentIndexChange');
  }

  onPropertiesStateChange(isShowProperties: boolean): void {
    Log.info(TAG, 'run onPropertiesStateChange');
  }

  onTargetIndexChange(targetIndex: number): void {
    Log.info(TAG, 'run onTargetIndexChange');
  }

  onDeleteStart(): void {
    Log.info(TAG, 'run onDeleteStart');
  }

  onStable(): void {
    Log.info(TAG, 'run onStable');
  }
}
