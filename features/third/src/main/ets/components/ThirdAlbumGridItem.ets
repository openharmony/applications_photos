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
import router from '@system.router';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager'
import { WindowConstants } from '@ohos/base/src/main/ets/constants/WindowConstants';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { EmptyAlbumComponent } from '@ohos/base/src/main/ets/components/EmptyAlbumComponent';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
// The item of album grid, and it's new style.
const TAG = "ThirdAlbumGridItem"

@Component
export struct ThirdAlbumGridItem {
    private staticIconList = new Map([
        [MediaConstants.ALBUM_ID_VIDEO, $r('app.media.ic_video')],
        [MediaConstants.ALBUM_ID_FAVOR, $r('app.media.ic_favorite_overlay')]
    ]);
    item: AlbumDataItem;
    @Consume isMultiPick: boolean;
    @Provide isBigCard: boolean = false;
    @Provide gridHeight: number = 0;
    isFromWallpaper: boolean;
    @Consume maxSelectCount: number;
    isFromFa: boolean;
    isFromFaPhoto: boolean;
    private appBroadcast: Broadcast = broadcastManager.getBroadcast();
    private gridAspectRatio = WindowConstants.CARD_ASPECT_RATIO;
    private albumCountMarginRight = WindowConstants.ALBUM_SET_NEW_ICON_SIZE + WindowConstants.ALBUM_SET_NEW_ICON_MARGIN * 2;
    private iconMarkAnchorX = WindowConstants.ALBUM_SET_NEW_ICON_SIZE + WindowConstants.ALBUM_SET_NEW_ICON_MARGIN;
    private iconMarkAnchorY = WindowConstants.ALBUM_SET_NEW_ICON_SIZE + WindowConstants.ALBUM_SET_NEW_ICON_MARGIN;
    @State bigWidth: number = 0;
    @State cardWidth: number = 0;
    @State cardHeight: number = 0;
    @State transformV: number = 0;
    @State isEmptyAlbum: boolean = false;
    @State thumbnail: string = "";
    bundleName: string = "";
    filterMediaType: number;
    onWindowSizeChangeCallBack = () => this.updateCardSize();

    aboutToAppear(): void {
        Log.info(TAG, `aboutToAppear + ${this.item.uri}`)
        screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.updateCardSize();
        this.item.load().then(() => {
            this.thumbnail = this.item.getThumbnail()
        })
    }

    aboutToDisappear(): void {
        screenManager.off(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.onWindowSizeChangeCallBack = null;
    }

    updateCardSize() {
        let contentWidth = screenManager.getWinWidth();
        let maxCardWidth = WindowConstants.ALBUM_SET_COVER_SIZE * WindowConstants.GRID_MAX_SIZE_RATIO;
        let count: number = Math.ceil((contentWidth - WindowConstants.ALBUM_SET_MARGIN * 2 + WindowConstants.ALBUM_SET_GUTTER) /
        (maxCardWidth + WindowConstants.ALBUM_SET_GUTTER));
        let gridWidth = ((contentWidth - WindowConstants.ALBUM_SET_MARGIN * 2 + WindowConstants.ALBUM_SET_GUTTER) / count) -
        WindowConstants.ALBUM_SET_GUTTER;
        this.gridHeight = gridWidth / this.gridAspectRatio;
        this.bigWidth = gridWidth * 2 + WindowConstants.ALBUM_SET_GUTTER;

        if (this.isBigCard) {
            this.cardWidth = this.bigWidth;
        } else {
            this.cardWidth = gridWidth;
        }
        this.cardHeight = this.gridHeight;
        this.transformV = 0;

        Log.info(TAG, `is big card : ${this.isBigCard}`);
        Log.info(TAG, `little grid size is: ${gridWidth}x${this.gridHeight}`);
    }

    build() {
        Stack({ alignContent: Alignment.Bottom }) {
            if (this.isEmptyAlbum) {
                EmptyAlbumComponent()
            }

            if (this.isBigCard) {
                Row() {
                    Image(this.thumbnail)
                        .alt($r('app.media.ic_goto_photos'))
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
                        .fillColor($r('app.color.empty_or_recycle_album_icon'))
                        .onError(() => {
                            Log.error(TAG, 'album is empty or its cover is error');
                            this.isEmptyAlbum = true;
                        })
                }
                .width(this.bigWidth)
                .height(this.gridHeight)
                .justifyContent(FlexAlign.Center)
                .alignItems(VerticalAlign.Center)
            } else {
                Row() {
                    Image(this.thumbnail)
                        .alt($r('app.media.ic_goto_photos'))
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
                        .fillColor($r('app.color.empty_or_recycle_album_icon'))
                        .onError(() => {
                            Log.error(TAG, 'album is empty or its cover is error');
                            this.isEmptyAlbum = true;
                        })
                }
                .height(this.gridHeight)
                .justifyContent(FlexAlign.Center)
                .alignItems(VerticalAlign.Center)
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


            if (this.staticIconList.has(this.item.id)) {
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
                .backgroundColor($r('app.color.transparent'))
        }
        .height(this.gridHeight)
        .border({
            radius: $r('sys.float.ohos_id_corner_radius_default_l'),
            width: $r('app.float.album_cover_stroke_width'),
            color: $r('app.color.album_cover_stroke_color')
        })
        .onClick(() => {
            if (this.isFromFa && (!this.isFromFaPhoto)) {
                this.appBroadcast.emit(BroadcastConstants.SAVE_FORM_EDITOR_DATA,
                    [this.item.displayName, this.item.id, this.item.displayName, 0, true]);
            } else {
                router.push({
                    uri: 'feature/thirdSelect/view/ThirdSelectPhotoGridPage',
                    params: {
                        itemCoverUri: this.item.uri,
                        itemId: this.item.id,
                        itemCount: this.item.count,
                        isMultiPick: this.isMultiPick,
                        isFromWallpaper: this.isFromWallpaper,
                        maxSelectCount: this.maxSelectCount,
                        itemDisplayName: this.item.displayName,
                        isFromFa: this.isFromFa,
                        isFromFaPhoto: this.isFromFaPhoto,
                        bundleName: this.bundleName,
                        filterMediaType: this.filterMediaType
                    }
                });
            }
        })
    }
}