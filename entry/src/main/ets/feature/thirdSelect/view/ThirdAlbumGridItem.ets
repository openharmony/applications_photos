import { EmptyAlbumComponent } from '../../browser/view/album/EmptyAlbumComponent';
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

import { AlbumInfo } from '../../../common/model/browser/album/AlbumInfo'
import { Logger } from '../utils/Logger'
import { ScreenManager } from '../../../common/model/common/ScreenManager'
import router from '@system.router'
import { AlbumDefine } from '../../../common/model/browser/AlbumDefine'
import { BroadCast } from '../../../common/utils/BroadCast'
import { BroadCastConstants } from '../../../common/model/common/BroadCastConstants'
import { BroadCastManager } from '../../../common/model/common/BroadCastManager'
import { Constants } from '../../../common/model/common/Constants'

// The item of album grid, and it's new style.
@Component
export struct ThirdAlbumGridItem {
    private staticIconList = new Map([
        [AlbumDefine.ALBUM_ID_VIDEO, $r('app.media.ic_video')],
        [AlbumDefine.ALBUM_ID_FAVOR, $r('app.media.ic_favorite_overlay')]
    ]);
    @State item: AlbumInfo = new AlbumInfo('', '', '', '', 0, '', '');
    isMultiPick: boolean;
    @Provide isBigCard: boolean = false;
    @Provide gridHeight: number = 0;
    logger: Logger = new Logger('ThirdAlbumGridItem');
    isFromWallpaper: boolean;
    maxSelectCount: number;
    isFromFa: boolean;
    isFromFaPhoto: boolean;
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    gridAspectRatio = Constants.CARD_ASPECT_RATIO;
    albumCountMarginRight = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN * 2;
    iconMarkAnchorX = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
    iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
    @State bigWidth: number = 0;
    @State cardWidth: number = 0;
    @State cardHeight: number = 0;
    @State transformV: number = 0;
    @State isEmptyAlbum: boolean = false;

    aboutToAppear(): void {
        this.logger.info(`aboutToAppear + ${this.item.coverUri}`)
        let self = this
        ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, (size) => {
            self.updateCardSize();
        })
        this.updateCardSize();
    }

    updateCardSize() {
        let contentWidth = ScreenManager.getInstance().getWinWidth();
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        let count: number = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER) /
        (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        let gridWidth = ((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER) / count) -
        Constants.ALBUM_SET_GUTTER;
        this.gridHeight = gridWidth / this.gridAspectRatio;
        this.bigWidth = gridWidth * 2 + Constants.ALBUM_SET_GUTTER;

        if (Constants.ANGLE_90 == this.item.coverOrientation
        || Constants.ANGLE_270 == this.item.coverOrientation) {
            this.cardWidth = this.gridHeight;
            if (this.isBigCard) {
                this.cardHeight = this.bigWidth;
            } else {
                this.cardHeight = gridWidth;
            }
            this.transformV = (this.cardHeight - this.cardWidth) / Constants.NUMBER_2;
        } else {
            if (this.isBigCard) {
                this.cardWidth = this.bigWidth;
            } else {
                this.cardWidth = gridWidth;
            }
            this.cardHeight = this.gridHeight;
            this.transformV = 0;
        }

        this.logger.info(`is big card : ${this.isBigCard}`);
        this.logger.info(`little grid size is: ${gridWidth}x${this.gridHeight}`);
    }

    build() {
        Stack({ alignContent: Alignment.Bottom }) {
            if (this.isEmptyAlbum) {
                EmptyAlbumComponent()
            }

            if (this.isBigCard) {
                Flex({
                    direction: FlexDirection.Row,
                    justifyContent: FlexAlign.Center,
                    alignItems: ItemAlign.Center
                }) {
                    Image(this.item.coverUri)
                        .alt($r('app.media.ic_goto_photos'))
                        .width(this.cardWidth)
                        .height(this.cardHeight)
                        .transform({ y: this.transformV })
                        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                        .rotate({
                            centerX: this.cardWidth / Constants.NUMBER_2,
                            centerY: this.cardHeight / Constants.NUMBER_2,
                            z: 1,
                            angle: this.item.coverOrientation
                        })
                        .fillColor($r('app.color.empty_or_recycle_album_icon'))
                        .onError(() => {
                            this.logger.debug('album is empty or its cover is error');
                            this.isEmptyAlbum = true;
                        })
                }
                .width(this.bigWidth)
                .height(this.gridHeight)
            } else {
                Flex({
                    direction: FlexDirection.Row,
                    justifyContent: FlexAlign.Center,
                    alignItems: ItemAlign.Center
                }) {
                    Image(this.item.coverUri)
                        .alt($r('app.media.ic_goto_photos'))
                        .width(this.cardWidth)
                        .height(this.cardHeight)
                        .translate({ x: this.transformV })
                        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                        .rotate({
                            centerX: this.cardWidth / Constants.NUMBER_2,
                            centerY: this.cardHeight / Constants.NUMBER_2,
                            z: 1,
                            angle: this.item.coverOrientation
                        })
                        .fillColor($r('app.color.empty_or_recycle_album_icon'))
                        .onError(() => {
                            this.logger.debug('album is empty or its cover is error');
                            this.isEmptyAlbum = true;
                        })
                }
                .height(this.gridHeight)
            }

            Column() {
                Text(this.item.displayName)
                    .margin({ right: $r('app.float.album_set_name_margin_right') })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)
                    .fontWeight(FontWeight.Medium)
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                    .fontColor($r('app.color.white'))

                Text(String(this.item.count))
                    .margin({ right: this.albumCountMarginRight })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)
                    .fontColor($r('app.color.white'))
                    .fontWeight(FontWeight.Regular)
                    .fontSize($r('sys.float.ohos_id_text_size_body2'))
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ left: $r('app.float.album_set_count_margin_left'),
                bottom: $r('app.float.album_set_count_margin_bottom') })


            if (this.staticIconList.has(this.item.name)) {
                Image(this.staticIconList.get(this.item.name))
                    .height($r('app.float.album_set_new_style_icon'))
                    .aspectRatio(1)
                    .position({ x: '100%', y: '100%' })
                    .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
            }

            Column()
                .height('100%')
                .width('100%')
                .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                .backgroundColor($r('app.color.transparent'))
        }
        .border({
            radius: $r('sys.float.ohos_id_corner_radius_default_l'),
            width: $r('app.float.album_cover_stroke_width'),
            color: $r('app.color.album_cover_stroke_color')
        })
        .onClick(() => {
            if (this.isFromFa && (!this.isFromFaPhoto)) {
                this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
                    [this.item.name, this.item.id, this.item.displayName, '', true]);
            } else {
                router.push({
                    uri: 'feature/thirdSelect/view/ThirdSelectPhotoGridPage',
                    params: {
                        itemCoverUri: this.item.coverUri,
                        itemId: this.item.id,
                        itemCount: this.item.count,
                        isMultiPick: this.isMultiPick,
                        isFromWallpaper: this.isFromWallpaper,
                        maxSelectCount: this.maxSelectCount,
                        itemDisplayName: this.item.displayName,
                        isFromFa: this.isFromFa
                    }
                });
            }
        })
    }
}