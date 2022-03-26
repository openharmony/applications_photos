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

import {AlbumDefine} from '../../../../common/model/browser/AlbumDefine.ets'
import {AlbumInfo} from '../../../../common/model/browser/album/AlbumInfo';
import {EmptyAlbumComponent} from './EmptyAlbumComponent';
import {ScreenManager} from '../../../../common/model/common/ScreenManager.ets';
import {Logger} from '../../utils/Logger'
import {Constants} from '../../../../common/model/common/Constants.ets'
import router from '@system.router';
import {UiUtil} from '../../../../common/utils/UiUtil'

let static_icon_list = new Map([
    [AlbumDefine.ALBUM_NAME_VIDEO , $r('app.media.ic_video')],
    [AlbumDefine.ALBUM_NAME_FAVOR, $r('app.media.ic_favorite_overlay')]
]);

// Traditional style grid item for distributed album set page
// There is no selection mode.
@Component
export struct AlbumGridItemTraditionalStyle {
    @State item: AlbumInfo = new AlbumInfo('', '', '', 0, '');
    @State isEmptyAlbum : boolean = false;
    @Provide isBigCard: boolean = false;
    @Provide gridHeight:number = 0;
    logger: Logger = new Logger('AlbumGridItemTraditionalStyle');

    gridAspectRatio = Constants.CARD_ASPECT_RATIO;
    albumCountMarginRight = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN * 2;

    private aboutToAppear(): void {
        this.logger.info('aboutToAppear new opp');

        let self = this;
        ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, () => {
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
    }

    build() {
        Column() {
            Stack({alignContent:Alignment.Bottom}) {
                if (this.isEmptyAlbum) {
                    EmptyAlbumComponent()
                }

                if (this.isBigCard) {
                    Image(this.item.coverUri)
                        .height(this.gridHeight)
                        .offset({ x: 0, y: 0 })
                        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                        .onError(() => {
                            this.logger.debug('album is empty or its cover is error');
                            this.isEmptyAlbum = true;
                        })
                        .onComplete((msg: {
                            width: number,
                            height: number,
                            componentWidth: number,
                            componentHeight: number
                        }) => {
                            this.logger.debug(`image load success.Size: ${msg.componentWidth}x${msg.componentHeight}`);
                        })
                } else {
                    Image(this.item.coverUri)
                        .aspectRatio(this.gridAspectRatio)
                        .offset({ x: 0, y: 0 })
                        .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
                        .onError(() => {
                            this.logger.debug('album is empty or its cover is error');
                            this.isEmptyAlbum = true;
                        })
                        .onComplete((msg: {
                            width: number,
                            height: number,
                            componentWidth: number,
                            componentHeight: number
                        }) => {
                            this.logger.debug(`image load success. Size: ${msg.width}x${msg.height},\
                                componentSize: ${msg.componentWidth}x${msg.componentHeight}`);
                        })
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
            .onClick(async () => {
                this.logger.info(`After onClick : ${JSON.stringify(this.item)}`);
                let display = typeof this.item.displayName == 'string'
                    ? this.item.displayName
                    : await UiUtil.getResourceString(this.item.displayName);
                let name = this.item.deviceName ? `${this.item.deviceName}(${display})` : this.item.name;
                router.push({
                    uri: 'feature/browser/view/photoGrid/PhotoGridPage',
                    params: {
                        item: JSON.stringify(this.item),
                        isDistributedAlbum: true,
                        distributedAlbumName: name
                    }
                });
            })
        }
    }
}