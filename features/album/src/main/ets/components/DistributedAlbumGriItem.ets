;
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
import { EmptyAlbumComponent } from '@ohos/base/src/main/ets/components/EmptyAlbumComponent';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { WindowConstants } from '@ohos/base/src/main/ets/constants/WindowConstants';
import { PeerDataItem } from '@ohos/base/src/main/ets/data/PeerDataItem';

const TAG = "DistributedAlbumGriItem"

@Component
export struct DistributedAlbumGriItem {
    item: PeerDataItem
    @State isEmptyAlbum: boolean = false;
    @Provide isBigCard: boolean = false;
    @Provide gridHeight: number = 0;
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    gridAspectRatio = WindowConstants.CARD_ASPECT_RATIO;
    albumCountMarginRight = WindowConstants.ALBUM_SET_NEW_ICON_SIZE + WindowConstants.ALBUM_SET_NEW_ICON_MARGIN * 2;
    onWindowSizeChangeCallBack = () => this.updateCardSize();

    aboutToAppear(): void {
        Log.info(TAG, 'aboutToAppear new opp');

        screenManager.on(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.updateCardSize();
    }

    aboutToDisappear(): void {
        screenManager.off(screenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
        this.onWindowSizeChangeCallBack = null;
    }

    updateCardSize() {
        let sideBarWidth = this.isSidebar ? WindowConstants.TAB_BAR_WIDTH : 0;
        let contentWidth = screenManager.getWinWidth() - sideBarWidth;
        let maxCardWidth = WindowConstants.ALBUM_SET_COVER_SIZE * WindowConstants.GRID_MAX_SIZE_RATIO;
        let count: number = Math.ceil((contentWidth - WindowConstants.ALBUM_SET_MARGIN * 2 + WindowConstants.ALBUM_SET_GUTTER) /
        (maxCardWidth + WindowConstants.ALBUM_SET_GUTTER));
        let gridWidth = ((contentWidth - WindowConstants.ALBUM_SET_MARGIN * 2 + WindowConstants.ALBUM_SET_GUTTER) / count) -
        WindowConstants.ALBUM_SET_GUTTER;
        this.gridHeight = gridWidth / this.gridAspectRatio;
    }

    build() {
        Stack({ alignContent: Alignment.Bottom }) {
            if (this.isEmptyAlbum) {
                EmptyAlbumComponent()
            }

            if (this.isBigCard) {
                Image(this.item.getThumbnail())
                    .height(this.gridHeight)
                    .offset({ x: 0, y: 0 })
                    .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                    .onError(() => {
                        Log.error(TAG, 'album is empty or its cover is error');
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
            } else {
                Image(this.item.getThumbnail())
                    .aspectRatio(this.gridAspectRatio)
                    .offset({ x: 0, y: 0 })
                    .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                    .onError(() => {
                        Log.error(TAG, 'album is empty or its cover is error');
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


            Column() {
                Text(this.item.deviceName)
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
        .height(this.gridHeight)
        .border({
            radius: $r('sys.float.ohos_id_corner_radius_default_l'),
            width: $r('app.float.album_cover_stroke_width'),
            color: $r('app.color.album_cover_stroke_color')
        })
        .onClick(() => {
            Log.info(TAG, `After onClick: ${JSON.stringify(this.item)}`);
            router.push({
                uri: 'feature/distributedAlbum/view/DistributedAlbumSetPage',
                params: {
                    item: JSON.stringify(this.item)
                }
            });
        })
    }
}