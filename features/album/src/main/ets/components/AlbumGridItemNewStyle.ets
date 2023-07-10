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

import { EmptyAlbumComponent } from '@ohos/base/src/main/ets/components/EmptyAlbumComponent';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import router from '@system.router';
import { WindowConstants } from '@ohos/base/src/main/ets/constants/WindowConstants';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { startTrace, finishTrace } from '@ohos/base/src/main/ets/utils/TraceControllerUtils';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';

// The item of album grid, and it's new style.
const TAG = "AlbumGridItemNewStyle"

@Component
export struct AlbumGridItemNewStyle {
    private staticIconList = new Map([
        [MediaConstants.ALBUM_ID_VIDEO, $r('app.media.ic_video')],
        [MediaConstants.ALBUM_ID_FAVOR, $r('app.media.ic_favorite_overlay')]
    ]);
    item: AlbumDataItem
    lazyItem: LazyItem<AlbumDataItem>
    @State isEmptyAlbum: boolean = false;
    @State selectable: boolean = true;
    @State icHeight: number = 0;
    @State bigWidth: number = 0;
    @State transformV: number = 0;
    @Provide isBigCard: boolean = false;
    @Provide gridHeight: number = 0;
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    @Consume broadCast: Broadcast;
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
    @Consume @Watch('onIndexPageShow') isShow: boolean;
    gridAspectRatio = WindowConstants.CARD_ASPECT_RATIO;
    albumCountMarginRight = WindowConstants.ALBUM_SET_NEW_ICON_SIZE + WindowConstants.ALBUM_SET_NEW_ICON_MARGIN * 2;
    iconMarkAnchorX = WindowConstants.ALBUM_SET_NEW_ICON_SIZE + WindowConstants.ALBUM_SET_NEW_ICON_MARGIN;
    iconMarkAnchorY = WindowConstants.ALBUM_SET_NEW_ICON_SIZE + WindowConstants.ALBUM_SET_NEW_ICON_MARGIN;
    @State cardWidth: number = 0;
    @State cardHeight: number = 0;
    @State thumbnail: string = "";
    onWindowSizeChangeCallBack = () => this.updateCardSize();

    aboutToAppear(): void {
        Log.debug(TAG, `aboutToAppear`);
        this.selectable = this.item.id != MediaConstants.ALBUM_ID_RECYCLE;
        screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        startTrace("loadAlbumItem");
        this.item.load().then(() => {
            finishTrace("loadAlbumItem");
            this.thumbnail = this.item.getThumbnail();
        })
        this.updateCardSize();
    }

    aboutToDisappear(): void {
        screenManager.off(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.onWindowSizeChangeCallBack = null;
    }

    onIndexPageShow(): void {
        this.item.load().then(() => {
            this.thumbnail = this.item.getThumbnail();
        })
    }

    updateCard() {
        Log.debug(TAG, 'Album changed and update card size.');
        this.updateCardSize();
    }

    updateCardSize() {
        let sideBarWidth = this.isSidebar ? WindowConstants.TAB_BAR_WIDTH : 0;
        let contentWidth = screenManager.getWinWidth() - sideBarWidth;
        let maxCardWidth = WindowConstants.ALBUM_SET_COVER_SIZE * WindowConstants.GRID_MAX_SIZE_RATIO;
        let count: number = Math.ceil((contentWidth - WindowConstants.ALBUM_SET_MARGIN * 2 + WindowConstants.ALBUM_SET_GUTTER)
        / (maxCardWidth + WindowConstants.ALBUM_SET_GUTTER));
        let gridWidth = ((contentWidth - WindowConstants.ALBUM_SET_MARGIN * 2 + WindowConstants.ALBUM_SET_GUTTER) / count)
        - WindowConstants.ALBUM_SET_GUTTER;
        this.gridHeight = gridWidth / this.gridAspectRatio;
        this.bigWidth = gridWidth * 2 + WindowConstants.ALBUM_SET_GUTTER;
        this.icHeight = this.gridHeight - WindowConstants.ALBUM_SET_NEW_ICON_MARGIN - WindowConstants.TEXT_SIZE_BODY2 - WindowConstants.TEXT_SIZE_SUB_TITLE1;

        if (this.isBigCard) {
            this.cardWidth = this.bigWidth;
        } else {
            this.cardWidth = gridWidth;
        }
        this.cardHeight = this.gridHeight;
        this.transformV = 0;
    }

    onModeChange(): void {
        if (!this.isAlbumSetSelectedMode) {
            this.item.setSelect(false);
        }
    }

    selectStateChange() {
        Log.info(TAG, `change selected.`);

        if (!this.isAlbumSetSelectedMode) {
            this.isAlbumSetSelectedMode = true;
        }

        if (this.selectable) {
            this.item.setSelect(!this.item.isSelect);
            if (this.lazyItem) {
                this.lazyItem.update(this.item)
            }
            this.broadCast.emit(BroadcastConstants.SELECT, [this.item.index]);

        }
    }

    build() {
        Stack({ alignContent: Alignment.Bottom }) {
            if (this.isEmptyAlbum) {
                EmptyAlbumComponent()
            }

            if (this.isBigCard) {
                if (this.item.id == MediaConstants.ALBUM_ID_RECYCLE) {
                    Column() {
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
                    .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                    .justifyContent(FlexAlign.Start)
                    .alignItems(HorizontalAlign.Start)
                } else {
                    Row() {
                        Image(this.thumbnail)
                            .syncLoad(true)
                            .width(this.cardWidth)
                            .height(this.cardHeight)
                            .transform({ y: this.transformV })
                            .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                            .rotate({
                                centerX: this.cardWidth / 2,
                                centerY: this.cardHeight / 2,
                                z: 1,
                                angle: 0
                            })
                            .onError(() => {
                                Log.debug(TAG, 'album is empty or its cover is error');
                                this.isEmptyAlbum = true;
                            })
                    }
                    .width(this.bigWidth)
                    .height(this.gridHeight)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(VerticalAlign.Center)
                }
            } else {
                if (this.item.id == MediaConstants.ALBUM_ID_RECYCLE) {
                    Column() {
                        Stack({ alignContent: Alignment.Center }) {
                            Image($r('app.media.ic_gallery_public_delete_line'))
                                .width($r('app.float.recycle_album_cover_icon_size'))
                                .height($r('app.float.recycle_album_cover_icon_size'))
                                .fillColor($r('app.color.empty_or_recycle_album_icon'))
                        }
                        .height(this.icHeight)
                        .width('100%')
                    }
                    .width(this.cardWidth)
                    .height(this.gridHeight)
                    .backgroundColor($r('app.color.empty_or_recycle_album_back'))
                    .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                    .justifyContent(FlexAlign.Start)
                    .alignItems(HorizontalAlign.Start)
                } else {
                    Row() {
                        Image(this.thumbnail)
                            .syncLoad(true)
                            .width(this.cardWidth)
                            .height(this.cardHeight)
                            .translate({ x: this.transformV })
                            .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                            .rotate({
                                centerX: this.cardWidth / 2,
                                centerY: this.cardHeight / 2,
                                z: 1,
                                angle: 0
                            })
                            .onError(() => {
                                Log.error(TAG, `album is empty or its cover is error ${this.thumbnail}`);
                                this.isEmptyAlbum = true;
                            })
                    }
                    .height(this.gridHeight)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(VerticalAlign.Center)
                }
            }
            if (!this.item.isSelect || !this.isAlbumSetSelectedMode || !this.selectable) {
                Image($r('app.media.gradient_mask_layer'))
                    .syncLoad(true)
                    .height('50%')
                    .width('100%')
                    .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
            }
            Column() {
                Text(this.item.displayName)
                    .margin({ right: $r('app.float.album_set_name_margin_right') })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)
                    .fontWeight(FontWeight.Medium)
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
                    .fontColor($r('app.color.white'))
                // shadow and shadow's fuzzy

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
            .margin({
                left: $r('app.float.album_set_count_margin_left'),
                bottom: $r('app.float.album_set_count_margin_bottom')
            })

            if (this.staticIconList.has(this.item.id) && !this.isAlbumSetSelectedMode) {
                Image(this.staticIconList.get(this.item.id))
                    .height($r('app.float.album_set_new_style_icon'))
                    .aspectRatio(1)
                    .position({ x: '100%', y: '100%' })
                    .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
            }

            Column()
                .height('100%')
                .width('100%')
                .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                .backgroundColor(this.item.isSelect && this.isAlbumSetSelectedMode && this.selectable
                    ? $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))

            if (this.isAlbumSetSelectedMode && this.selectable) {
                Image(this.item.isSelect ? $r('app.media.ic_checkbox_on') : $r('app.media.ic_checkbox_off_overlay'))
                    .height($r('app.float.album_set_new_style_icon'))
                    .aspectRatio(1)
                    .position({ x: '100%', y: '100%' })
                    .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
            }

            Column()
                .height('100%')
                .width('100%')
                .border({
                    radius: $r('sys.float.ohos_id_corner_radius_default_l'),
                    width: $r('app.float.album_cover_stroke_width'),
                    color: $r('app.color.album_cover_stroke_color')
                })
        }
        .height(this.gridHeight)
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
                Log.info(TAG, `After onClick, MediaSet is: ${JSON.stringify(this.item)}`);
                router.push({
                    uri: 'feature/photoGrid/view/PhotoGridPage',
                    params: {
                        item: JSON.stringify(this.item)
                    }
                });
            }
        })
    }
}