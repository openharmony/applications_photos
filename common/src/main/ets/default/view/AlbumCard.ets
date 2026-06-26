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
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { Constants } from '../model/common/Constants';
import lazy { UiUtil } from '../utils/UiUtil';

@Component
export struct AlbumCardComponent {
  private isAlbumName: boolean = false;
  @Link item: AlbumInfo;
  @State cardName: Resource | string = '';

  aboutToAppear(): void {
    this.cardName = getDisplayName(this.item, this.isAlbumName);
  }

  build() {
    Column() {
      Text(this.item?.albumName)
        .draggable(false)
        .key('AlbumCardDisplayName')
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_primary'))
        .maxFontScale(Constants.GRID_TEXT_MAX_SCALE)

      Text(String(this.item?.count))
        .draggable(false)
        .key('AlbumCardItemCount')
        .margin({ top: $r('app.float.photo_grid_gap') })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontColor($r('sys.color.font_secondary'))
        .fontWeight(FontWeight.Regular)
        .fontSize(DeviceInfo.isPc() ? $r('sys.float.Caption_L') : $r('sys.float.Body_S'))
        .maxFontScale(Constants.GRID_TEXT_MAX_SCALE)
    }
    .width('100%')
    .padding({
      left: $r('sys.float.padding_level4'),
      right: $r('sys.float.padding_level4'),
    })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.End)
  }
}

function getDisplayName(albumInfo: AlbumInfo, isAlbumName: boolean): Resource | string {
  if (isAlbumName) {
    return albumInfo.albumName;
  }
  const res = UiUtil.getDisplayNameResourceByAlbumInfo(albumInfo);
  if (res) {
    return res;
  }
  return albumInfo.albumName;
}

export function getBottomHeight(): number {
  // System Resource Constants
  const TEXT_SIZE_SUB_TITLE1: number = 18; // ohos_id_text_size_sub_title1
  const TEXT_SIZE_BODY2: number = 14; // ohos_id_text_size_body2
  const numberHeight = px2vp(fp2px(TEXT_SIZE_BODY2));
  const nameHeight = px2vp(fp2px(TEXT_SIZE_SUB_TITLE1));
  const value: number = UiUtil.getResourceNumber($r('sys.float.padding_level4'));
  return px2vp(value) + nameHeight + 2 + numberHeight;
}