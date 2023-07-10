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
import { WindowConstants } from '@ohos/base/src/main/ets/constants/WindowConstants';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import { EmptyAlbumComponent } from '@ohos/base/src/main/ets/components/EmptyAlbumComponent';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';

const TAG = "AlbumGridItemTraditionalStyle"

// Traditional style grid item for distributed album set page
// There is no selection mode.
@Component
export struct AlbumGridItemTraditionalStyle {
    item: AlbumDataItem;
    deviceName: string;
    deviceId: string;
    @State isEmptyAlbum: boolean = false;
    @Provide isBigCard: boolean = false;
    @Provide gridHeight: number = 0;
    @State bigWidth: number = 0;
    @State cardWidth: number = 0;
    @State cardHeight: number = 0;
    @State transformV: number = 0;
    @State thumbnail: string = "";
    gridAspectRatio = WindowConstants.CARD_ASPECT_RATIO;
    albumCountMarginRight = WindowConstants.ALBUM_SET_NEW_ICON_SIZE + WindowConstants.ALBUM_SET_NEW_ICON_MARGIN * 2;
    onWindowSizeChangeCallBack = () => this.updateCardSize();

    aboutToAppear(): void {
        Log.info(TAG, 'aboutToAppear new opp');

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

    updateCard() {
        Log.debug(TAG, 'Album changed and update card size.');
        this.updateCardSize();
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
    }

    private async jumpToBrowser() {
        Log.info(TAG, `After onClick : ${JSON.stringify(this.item)}`);
        let name = this.deviceName ? `${this.deviceName}(${this.item.displayName})` : this.item.displayName;
        let relativePath = await this.item.getRelativePath()
        let simpleItem: SimpleAlbumDataItem = new SimpleAlbumDataItem(this.item.id, this.item.displayName, relativePath, this.deviceId, this.deviceName)
        router.push({
            uri: 'feature/photoGrid/view/PhotoGridPage',
            params: {
                item: JSON.stringify(simpleItem),
                isDistributedAlbum: true,
                distributedAlbumName: name
            }
        });
    }

    build() {
        Column() {
            Stack({ alignContent: Alignment.Bottom }) {
                if (this.isEmptyAlbum) {
                    EmptyAlbumComponent()
                }

                if (this.isBigCard) {
                    Row() {
                        Image(this.thumbnail)
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
                            .onComplete((msg: {
                                width: number,
                                height: number,
                                componentWidth: number,
                                componentHeight: number
                            }) => {
                                Log.debug(TAG, `image load success.Size: ${msg.componentWidth}x${msg.componentHeight}`);
                            })
                    }
                    .width(this.bigWidth)
                    .height(this.gridHeight)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(VerticalAlign.Center)
                } else {
                    Row() {
                        Image(this.thumbnail)
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
                                Log.debug(TAG, 'album is empty or its cover is error');
                                this.isEmptyAlbum = true;
                            })
                            .onComplete((msg: {
                                width: number,
                                height: number,
                                componentWidth: number,
                                componentHeight: number
                            }) => {
                                Log.debug(TAG, `image load success. Size: ${msg.width}x${msg.height},\
                                    componentSize: ${msg.componentWidth}x${msg.componentHeight}`);
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
                .margin({
                    left: $r('app.float.album_set_count_margin_left'),
                    bottom: $r('app.float.album_set_count_margin_bottom')
                })
            }
            .border({
                radius: $r('sys.float.ohos_id_corner_radius_default_l'),
                width: $r('app.float.album_cover_stroke_width'),
                color: $r('app.color.album_cover_stroke_color')
            })
            .onClick(() => {
                this.jumpToBrowser()
            })
        }
    }
}