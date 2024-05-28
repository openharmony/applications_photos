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
  AlbumDefine,
  AlbumInfo,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  Log,
  ScreenManager,
  UiUtil
} from '@ohos/common';
import { SelectParams } from '../utils/ThirdSelectConstants';
import { EmptyAlbumComponent } from '@ohos/browser/BrowserComponents';
import { Router } from '@ohos.arkui.UIContext';
import router from '@ohos.router';

const TAG: string = 'thiSel_ThirdAlbumGridItem';

// The item of album grid, and it's new style.
@Component
export struct ThirdAlbumGridItem {
  @State item: AlbumInfo = new AlbumInfo(undefined);
  @Provide gridHeight: number = 0;
  @Provide gridWidth: number = 0;
  gridAspectRatio = Constants.CARD_ASPECT_RATIO;
  albumCountMarginRight = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN * 2;
  iconMarkAnchorX = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  MASK_LAYER_HEIGHT = '50%';
  @State transformV: number = 0;
  @State isEmptyAlbum: boolean = false;
  isFirstEnter: boolean = false;
  @Consume selectParams: SelectParams;
  private staticIconList = new Map([
    [AlbumDefine.ALBUM_ID_VIDEO, $r('app.media.ic_video')],
    [AlbumDefine.ALBUM_ID_FAVOR, $r('app.media.ic_favorite_overlay')]
  ]);
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private fp2vpUnit: number = px2vp(fp2px(Constants.NUMBER_1));
  private onWindowSizeChangeCallBack: Function = (): void => this.updateCardSize();

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear + ${this.item.coverUri}, select param ${JSON.stringify(this.selectParams)}`)
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.Get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    }
    this.updateCardSize();
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
  }

  updateCardSize() {
    let contentWidth = ScreenManager.getInstance().getWinWidth();
    let count: number = UiUtil.getAlbumGridCount(false);
    this.gridWidth = ((contentWidth - Constants.ALBUM_SET_MARGIN * 2 -
      (Constants.ALBUM_SET_GUTTER * (count - 1))) / count);
    let numberHeight = Constants.TEXT_SIZE_BODY2 * this.fp2vpUnit;
    let nameHeight = Constants.TEXT_SIZE_SUB_TITLE1 * this.fp2vpUnit;

    UiUtil.getResourceNumber($r('sys.float.ohos_id_elements_margin_vertical_m')).then((value: number) => {
      let bottomHeight = px2vp(value) + nameHeight + Constants.NUMBER_2 + numberHeight;
      this.iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN + bottomHeight;
      this.gridHeight = this.gridWidth + bottomHeight;
      Log.info(TAG, `updateCardSize gridWidth : ${this.gridWidth}, count : ${count}`);
      this.transformV = 0;
    });
  }

  @Builder
  buildNormalCard() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Start
    }) {
      Image(this.item.coverUri)
        .width(this.gridWidth)
        .aspectRatio(this.gridAspectRatio)
        .translate({ x: this.transformV })
        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m') })
        .rotate({
          centerX: this.gridWidth / Constants.NUMBER_2,
          centerY: this.gridWidth / Constants.NUMBER_2,
          z: 1,
          angle: 0
        })
        .onError(() => {
          Log.debug(TAG, 'album is empty or its cover is error');
          this.isEmptyAlbum = true;
        })
    }
    .height(this.gridHeight)
  }

  @Builder
  buildOthers() {
    Column() {
      Text(this.item.albumName)
        .margin({ right: $r('app.float.album_set_name_margin_right') })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Text(String(this.item.count))
        .margin({ right: this.albumCountMarginRight })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: $r('app.float.photo_grid_gap') })
        .maxLines(1)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body3'))
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: $r('sys.float.ohos_id_elements_margin_horizontal_m')
    })


    if (this.staticIconList.has(this.item.albumName)) {
      Image(this.staticIconList.get(this.item.albumName))
        .fillColor($r('sys.color.ohos_id_color_primary_dark'))
        .height($r('app.float.album_set_new_style_icon'))
        .aspectRatio(1)
        .position({ x: '0%', y: '100%' })
        .markAnchor({ x: 0 - Constants.ALBUM_SET_NEW_ICON_MARGIN, y: this.iconMarkAnchorY })
    }

    Column()
      .height('100%')
      .width('100%')
      .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m') })
      .backgroundColor($r('app.color.transparent'))
  }


  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.isEmptyAlbum) {
        EmptyAlbumComponent()
          .margin({ bottom: this.gridHeight - this.gridWidth })
      }

      this.buildNormalCard()

      this.buildOthers()
    }
    .clip(true)
    .width(this.gridWidth)
    .height(this.gridHeight)
    .border({
      radius: $r('sys.float.ohos_id_corner_radius_default_m')
    })
    .onClick((): void => this.handleClick())

  }

  private handleClick(): void {
    if (this.selectParams.isFromFa && (!this.selectParams.isFromFaPhoto)) {
      this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
        [this.item.albumName, this.item.uri, this.item.albumName, '', true]);
    } else {
      let params: SelectParams = this.selectParams;
      params.isFirstEnter = false;
      params.itemDisplayName = this.item.albumName;
      params.itemCount = this.item.count;
      params.uri = this.item.uri;
      params.itemCoverUri = this.item.coverUri;
      router.pushUrl({
        url: 'pages/ThirdSelectPhotoGridPage',
        params: params
      });
    }
  }
}