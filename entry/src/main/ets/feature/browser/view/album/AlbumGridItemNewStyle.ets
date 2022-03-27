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

import {AlbumInfo} from '../../../../common/model/browser/album/AlbumInfo.ets';
import {EmptyAlbumComponent} from './EmptyAlbumComponent';
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants'
import {Logger} from '../../utils/Logger'
import {BroadCast} from '../../../../common//utils/BroadCast.ets'
import {ScreenManager} from '../../../../common/model/common/ScreenManager'
import router from '@system.router';
import {AlbumDefine} from '../../../../common/model/browser/AlbumDefine.ets'
import {Constants} from '../../../../common/model/common/Constants.ets'

let staticIconList = new Map([
    [AlbumDefine.ALBUM_NAME_VIDEO , $r('app.media.ic_video')],
    [AlbumDefine.ALBUM_NAME_FAVOR, $r('app.media.ic_favorite_overlay')]
]);

// The item of album grid, and it's new style.
@Component
export struct AlbumGridItemNewStyle {
    @State item: AlbumInfo = new AlbumInfo('', '', '', 0, '');
    @State isEmptyAlbum: boolean = false;
    @State isSelected: boolean = false;
    @State selectable: boolean = true;
    @State icHeight: number = 0;
    @State bigWidth:number = 0;

    @Provide isBigCard: boolean = false;
    @Provide gridHeight: number = 0;

    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    @Consume broadCast: BroadCast;
    @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
    logger: Logger = new Logger('AlbumGridItemNewStyle');

    gridAspectRatio = Constants.CARD_ASPECT_RATIO;
    albumCountMarginRight = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN * 2;
    iconMarkAnchorX = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
    iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;

    private aboutToAppear(): void {
        this.logger.debug(`aboutToAppear`);
        this.selectable = (this.item.name == AlbumDefine.ALBUM_NAME_RECYCLE) ? false : true;
        let self = this;
        ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, () => {
            self.updateCardSize();
        })
        this.updateCardSize();
    }

    updateCardSize() {
        let sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
        let contentWidth = ScreenManager.getInstance().getWinWidth() - sideBarWidth;
        let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
        let count: number = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
            / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
        let gridWidth = ((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER) / count)
            - Constants.ALBUM_SET_GUTTER;
        this.gridHeight = gridWidth / this.gridAspectRatio;
        this.bigWidth = gridWidth * 2 + Constants.ALBUM_SET_GUTTER;
        let numberHeight = px2vp(fp2px(Constants.TEXT_SIZE_BODY2));
        let nameHeight = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE1));
        this.icHeight = this.gridHeight - Constants.ALBUM_SET_NEW_ICON_MARGIN; - numberHeight - nameHeight;
    }

    onModeChange(): void {
        if (!this.isAlbumSetSelectedMode) {
        this.isSelected = false;
        }
    }

    selectStateChange() {
        this.logger.info(`change selected.`);
        let newState: boolean = !this.isSelected;

        if (!this.isAlbumSetSelectedMode) {
            this.isAlbumSetSelectedMode = true;
        }

        if (this.selectable) {
        this.broadCast.emit(BroadCastConstants.SELECT,
            [this.item.name, newState, this.item.isDisableRename, this.item.isDisableDelete, function () {
                this.logger.info('enter callback');
                this.isSelected = newState;
            }.bind(this)]);
        }
    }

    build() {
        Stack({ alignContent: Alignment.Bottom }) {
            if (this.isEmptyAlbum) {
                EmptyAlbumComponent()
            }

            if (this.isBigCard) {
                if (this.item.name == AlbumDefine.ALBUM_NAME_RECYCLE) {
                    Flex({
                        direction: FlexDirection.Column,
                        justifyContent: FlexAlign.Start,
                        alignItems: ItemAlign.Start
                    }) {
                        Stack({ alignContent: Alignment.Center }) {
                            Image($r('app.media.ic_gallery_public_delete_line'))
                                .width($r('app.float.recycle_album_cover_icon_size'))
                                .height($r('app.float.recycle_album_cover_icon_size'))
                                .fillColor($r('app.color.empty_or_recycle_album_icon'))
                        }
                        .height(this.icHeight)
                        .width('100%')
                    }
                    .height(this.gridHeight)
                    .width(this.bigWidth)
                    .backgroundColor($r('app.color.empty_or_recycle_album_back'))
                    .border({radius: $r('sys.float.ohos_id_corner_radius_default_l')})
                } else {
                    Image(this.item.coverUri)
                        .height(this.gridHeight)
                        .offset({x:0, y:0})
                        .border({radius: $r('sys.float.ohos_id_corner_radius_default_l')})
                        .onError(() => {
                            this.logger.debug('album is empty or its cover is error');
                            this.isEmptyAlbum = true;
                        })
                }
            } else {
                if (this.item.name == AlbumDefine.ALBUM_NAME_RECYCLE) {
                    Flex({
                        direction: FlexDirection.Column,
                        justifyContent: FlexAlign.Start,
                        alignItems: ItemAlign.Start
                    }) {
                        Stack({ alignContent: Alignment.Center }) {
                            Image($r('app.media.ic_gallery_public_delete_line'))
                                .width($r('app.float.recycle_album_cover_icon_size'))
                                .height($r('app.float.recycle_album_cover_icon_size'))
                                .fillColor($r('app.color.empty_or_recycle_album_icon'))
                        }
                        .height(this.icHeight)
                        .width('100%')
                    }
                    .aspectRatio(this.gridAspectRatio)
                    .backgroundColor($r('app.color.empty_or_recycle_album_back'))
                    .border({radius: $r('sys.float.ohos_id_corner_radius_default_l')})
                } else {
                    Image(this.item.coverUri)
                        .aspectRatio(this.gridAspectRatio)
                        .offset({x:0, y:0})
                        .border({radius: $r('sys.float.ohos_id_corner_radius_default_l')})
                        .onError(() => {
                            this.logger.debug('album is empty or its cover is error');
                            this.isEmptyAlbum = true;
                        })
                }
            }

                Image($r('app.media.gradient_mask_layer'))
                    .height('50%')
                    .width('100%')
                    .border({radius: $r('sys.float.ohos_id_corner_radius_default_l')})
                    .visibility(this.isSelected && this.isAlbumSetSelectedMode && this.selectable ? Visibility.None : Visibility.Visible)
            Column() {
                Text(this.item.displayName)
                    .margin({right: $r('app.float.album_set_name_margin_right')})
                    .textOverflow({overflow: TextOverflow.Ellipsis})
                    .maxLines(1)
                    .fontWeight(FontWeight.Medium)
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                    .fontColor($r('app.color.white'))
                    // shadow and shadow's fuzzy

                Text(String(this.item.count))
                    .margin({right: this.albumCountMarginRight})
                    .textOverflow({overflow: TextOverflow.Ellipsis})
                    .maxLines(1)
                    .fontColor($r('app.color.white'))
                    .fontWeight(FontWeight.Regular)
                    .fontSize($r('sys.float.ohos_id_text_size_body2'))
            }
            .width('100%')
                .alignItems(HorizontalAlign.Start)
                .margin({left: $r('app.float.album_set_count_margin_left'), bottom: $r('app.float.album_set_count_margin_bottom')})

                if (staticIconList.has(this.item.name) && !this.isAlbumSetSelectedMode) {
                    Image(staticIconList.get(this.item.name))
                      .height($r('app.float.album_set_new_style_icon'))
                      .aspectRatio(1)
                      .position({ x: '100%', y: '100%' })
                      .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
            }

                Column()
                    .height('100%')
                    .width('100%')
                    .border({radius: $r('sys.float.ohos_id_corner_radius_default_l')})
                    .backgroundColor(this.isSelected && this.isAlbumSetSelectedMode && this.selectable
                        ? $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))

                Image(this.isSelected ? $r('app.media.ic_checkbox_on') : $r('app.media.ic_checkbox_off_overlay'))
                    .height($r('app.float.album_set_new_style_icon'))
                    .aspectRatio(1)
                    .position({x: '100%', y: '100%'})
                    .markAnchor({x: this.iconMarkAnchorX, y: this.iconMarkAnchorY})
                    .visibility(this.isAlbumSetSelectedMode && this.selectable ? Visibility.Visible : Visibility.None)
            }
            .border({
                radius: $r('sys.float.ohos_id_corner_radius_default_l'),
                width: $r('app.float.album_cover_stroke_width'),
                color: $r('app.color.album_cover_stroke_color')
            })
            .gesture(
                LongPressGesture()
                    .onAction(() => {
                        this.selectStateChange();
                    })
            )
            .onClick(() => {
                if (this.isAlbumSetSelectedMode) {
                    this.selectStateChange();
                } else {
                    this.logger.info(`After onClick, MediaSet is: ${JSON.stringify(this.item)}`);
                    router.push({
                        uri: 'feature/browser/view/photoGrid/PhotoGridPage',
                        params: {
                            item: JSON.stringify(this.item)
                        }
                    });
                }
            })
    }
}