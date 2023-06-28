/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import {
  BrowserDataFactory,
  BrowserOperationFactory,
  BrowserConstants as Constants,
  Log,
  MediaConstants,
  MenuContext,
  MenuOperation,
  UserFileManagerAccess
} from '@ohos/common';
import image from '@ohos.multimedia.image';

const TAG: string = 'browser_RotateMenuOperation';

export class RotateMenuOperation implements MenuOperation {
  private menuContext: MenuContext;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    let orientation = mediaItem.orientation;
    this.changeOrientation(mediaItem.uri, orientation);
    Log.info(TAG, `changeOrientation: id: ${mediaItem.uri} orientation: ${orientation}`);
  }

  getPropertyValidOrientation(orientation: number): string {
    Log.info(TAG, `getPropertyValidOrientation ${orientation}`);
    orientation = orientation % MediaConstants.ROTATE_AROUND;
    switch (orientation) {
      case MediaConstants.ROTATE_NONE:
        return '1';
      case MediaConstants.ROTATE_THIRD:
        return '8';
      case MediaConstants.ROTATE_TWICE:
        return '3';
      case MediaConstants.ROTATE_ONCE:
        return '6';
      default:
        return '';
    }
  }

  private async changeOrientation(uri, orientation) {
    Log.info(TAG, 'changeOrientation start');
    let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
    let fileAsset = await dataImpl.getDataByUri(uri);
    try {
      let fd: number = await UserFileManagerAccess.getInstance().openAsset('RW', fileAsset);
      if (fd < 0) {
        Log.error(TAG, 'open asset failed.');
        return;
      }
      let imageSourceApi: image.ImageSource = image.createImageSource(fd);
      await imageSourceApi.modifyImageProperty('Orientation', this.getPropertyValidOrientation(orientation));
      Log.debug(TAG, `changeOrientation end: ${JSON.stringify(await imageSourceApi.getImageProperty('Orientation'))}`);
      imageSourceApi.release();
      UserFileManagerAccess.getInstance().closeAsset(fd, fileAsset);
      this.menuContext.broadCast.emit(Constants.ROTATE, [orientation]);
    } catch (err) {
      Log.error(TAG, `setOrientation err ${JSON.stringify(err)}`);
    }
  }
}