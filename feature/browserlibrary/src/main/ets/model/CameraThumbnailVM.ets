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
import { ThumbnailVM } from './ThumbnailVM';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import utd from '@ohos.data.uniformTypeDescriptor';

const TAG = 'CameraThumbnailVM';

export class CameraThumbnailVM extends ThumbnailVM {
  onEnterStartAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    this.browserAnimController.enterOnStart();
    this.playEnterAnimSync();
    this.setThumbnailShowFunc(true);
  }

  public isShowVideoButton(): boolean {
    if (!super.isShowVideoButton()) {
      return false;
    }
    let lastUri = LocalStorage.getShared()?.get<string>('lastUri');
    if (lastUri === undefined || lastUri === null || lastUri.length < 5) {
      Log.info(TAG, `[thumbnailBtn] lastUri not exit or is captureId,
      not show video button`);
      return false;
    }
    Log.info(TAG, `[thumbnailBtn] lastUri is ${lastUri}`);
    let fileExtIndex = lastUri?.lastIndexOf?.('.') ?? -1;
    if (fileExtIndex === -1) {
      Log.error(TAG, `[thumbnailBtn] no fileExt, not show video button`);
      return false;
    }
    let fileExt = lastUri.substring(fileExtIndex);
    try {
      let uniformTypeId = utd.getUniformDataTypeByFilenameExtension(fileExt, 'general.media');
      let typeObj: utd.TypeDescriptor = utd.getTypeDescriptor(uniformTypeId);
      if (typeObj === null) {
        Log.error(TAG, `[thumbnailBtn] fileExt getTypeDrscriptor is null ,not show video button`);
        return false;
      }
      if (typeObj.belongsTo('general.video')) {
        Log.info(TAG, `[thumbnailBtn] last uri extion:${fileExt} type:${uniformTypeId}, is video, show videoButton`);
        return true;
      }
    } catch (error) {
      Log.error(TAG, `get uri file type error:${error.message}`);
    }
    return false;
  }
}