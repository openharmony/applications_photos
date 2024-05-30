/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { AlbumDefine, AlbumInfo, BroadCast, Constants, Log, ScreenManager, SelectManager, UiUtil } from '@ohos/common';
import { EmptyAlbumComponent } from './EmptyAlbumComponent';
import router from '@ohos.router';

const TAG: string = 'browser_AlbumSelectGridItemNewStyle';

// The item of album grid, and it's new style.
@Component
export struct AlbumSelectGridItemNewStyle {
  @State @Watch('updateCard') item: AlbumInfo = new AlbumInfo();
  @State isEmptyAlbum: boolean = false;
  @Provide gridHeight: number = 0;
  @Provide gridWidth: number = 0;
  @Consume broadCast: BroadCast;
  mSelectManager: SelectManager | null = null;
  gridAspectRatio = Constants.CARD_ASPECT_RATIO;
  albumCountMarginRight = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN * 2;
  iconMarkAnchorX = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  @State transformV: number = 0;
  private fp2vpUnit: number = px2vp(fp2px(Constants.NUMBER_1));
  private staticIconList = new Map([
    [AlbumDefine.ALBUM_ID_VIDEO, $r('app.media.ic_video')],
    [AlbumDefine.ALBUM_ID_FAVOR, $r('app.media.ic_favorite_overlay')]
  ]);
  private updateCardSizeFunc: Function = (): void => this.updateCardSize()

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear + ${this.item.coverUri}`);
    this.updateCardSize();
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.updateCardSizeFunc);
    }
  }

  aboutToDisappear(): void {
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.updateCardSizeFunc);
    }
  }

  updateCard() {
    Log.debug(TAG, 'Album changed and update card size.');
    this.updateCardSize();
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.isEmptyAlbum) {
          EmptyAlbumComponent()
            .margin({ bottom: this.gridHeight - this.gridWidth })
        }

        Image(this.item.coverUri)
          .width(this.gridWidth)
          .height(this.gridWidth)
          .objectFit(ImageFit.Cover)
          .translate({ x: this.transformV })
          .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m') })
          .margin({ bottom: this.gridHeight - this.gridWidth })
          .onError(() => {
            Log.debug(TAG, 'album is empty or its cover is error');
            this.isEmptyAlbum = true;
          })

        Column() {
          Text(this.item.albumName)
            .margin({ right: $r('app.float.album_set_name_margin_right') })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))

          Text(String(this.item.count))
            .margin({ right: this.albumCountMarginRight, top: $r('app.float.photo_grid_gap') })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.ohos_id_text_size_body3'))
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({
          left: $r('sys.float.ohos_id_elements_margin_horizontal_m')
        })

        if (this.staticIconList.has(this.item.albumName)) {
          Image(this.staticIconList.get(this.item.albumName))
            .height($r('app.float.album_set_new_style_icon'))
            .aspectRatio(1)
            .position({ x: '0%', y: '100%' })
            .markAnchor({ x: 0 - Constants.ALBUM_SET_NEW_ICON_MARGIN, y: this.iconMarkAnchorY })
        }
      }
      .height(this.gridHeight)
    }
    .width(this.gridWidth)
    .height(this.gridHeight)
    .clip(true)
    .border({
      radius: $r('sys.float.ohos_id_corner_radius_default_m')
    })
    .onClick(() => {
      Log.info(TAG, `After onClick, MediaSet is: ${JSON.stringify(this.item)}`);
      router.pushUrl({
        url: 'pages/NewAlbumPage',
        params: {
          item: JSON.stringify(this.item)
        }
      })
    })
  }

  private updateCardSize() {
    let contentWidth = ScreenManager.getInstance().getWinWidth();
    let count = UiUtil.getAlbumGridCount(false);
    this.gridWidth = ((contentWidth - Constants.ALBUM_SET_MARGIN *
      2 - (Constants.ALBUM_SET_GUTTER * (count - 1))) / count);
    let numberHeight = Constants.TEXT_SIZE_BODY2 * this.fp2vpUnit;
    let nameHeight = Constants.TEXT_SIZE_SUB_TITLE1 * this.fp2vpUnit;

    UiUtil.getResourceNumber($r('sys.float.ohos_id_elements_margin_vertical_m')).then((value: number) => {
      let bottomHeight = px2vp(value) + nameHeight + Constants.NUMBER_2 + numberHeight;
      this.iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN + bottomHeight;

      this.gridHeight = this.gridWidth + bottomHeight;
      Log.info(TAG, 'updateCardSize gridWidth : ' + this.gridWidth + ',  gridHeight : ' + this.gridHeight);
      this.transformV = 0;
    });

  }
}