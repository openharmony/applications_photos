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

import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { isOrientationHorizontal } from '../../../default/model/common/ScreenManager';
import lazy { Log } from '../../../default/utils/Log';

/* instrument ignore file */
const TAG: string = 'EmptyAlbumComponent';

// New style
@Component
export struct EmptyAlbumComponent {
  @Consume gridColumnsCount: number;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();

  aboutToAppear(): void {
    Log.debug(TAG, 'aboutToAppear');
  }

  normalColumn(): boolean {
    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      if (this.isHorizontal) {
        return this.gridColumnsCount <= 7;
      } else {
        return this.gridColumnsCount <= 4;
      }
    }
    if (DeviceInfo.isPhoneUx()) {
      if (this.isHorizontal) {
        return this.gridColumnsCount <= 4;
      } else {
        return this.gridColumnsCount <= 2;
      }
    }
    /* instrument ignore next */
    if (DeviceInfo.isFoldable()) {
      return this.gridColumnsCount <= 4;
    }
    return true;
  }

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center,
      }) {
        SymbolGlyph($r('sys.symbol.picture_fill'))
          .draggable(false)
          .fontSize(this.normalColumn() ?
          $r('app.float.twoline_album_cover_icon_size') : $r('app.float.recycle_album_cover_icon_size'))
          .fontColor([$r('sys.color.interactive_click')])
      }
      .width('100%')
      .aspectRatio(1)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .border({ radius: $r('sys.float.corner_radius_level6') })
    }
    .animation({
      duration: Constants.albumStyleSmoothDuration,
      curve: Curve.Friction,
    })
  }
}

// Traditional style
@Component
export struct EmptyAlbumComponentForTraditionalStyle {
  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
    }) {
      Image($r('app.media.ic_goto_photos'))
        .draggable(false)
        .width($r('app.float.album_set_icon_size'))
        .aspectRatio(1)
        .fillColor($r('sys.color.icon_secondary'))
    }
    .aspectRatio(1)
    .backgroundColor($r('app.color.album_set_empty_album_bright')) // bright and dark mode
    .border({ radius: $r('sys.float.corner_radius_level4') })
  }
}