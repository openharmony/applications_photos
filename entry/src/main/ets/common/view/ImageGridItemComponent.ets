// @ts-nocheck
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

import { Logger } from '../utils/Logger'
import { Constants } from '../model/common/Constants'
import { MediaItem } from '../model/browser/photo/MediaItem'
import { DateUtil } from '../utils/DateUtil'
import { BroadCast } from '../utils/BroadCast'
import { BroadCastConstants } from '../model/common/BroadCastConstants'
import { ImageUtil } from '../utils/ImageUtil'
import { ScreenManager } from '../model/common/ScreenManager'
import { TraceControllerUtils } from '../utils/TraceControllerUtils'
import { MediaLibraryAccess } from '../access/MediaLibraryAccess';

// General grid picture control
@Component
export struct ImageGridItemComponent {
    item: MediaItem;
    @Consume @Watch('onModeChange') isSelectedMode: boolean;
    @State isSelected: boolean = false;
    @State imageThumbnail: string = undefined;
    @State transitionId: string = '';
    @Consume broadCast: BroadCast;
    @Consume @Watch('onShow') isShow: boolean;
    @State autoResize: boolean = true;
    loaded = false;
    position: number;
    pageName = '';
    pixelMap: PixelMap;
    @State useAlt: boolean = false;
    @State pressAnimScale: number = 1.0;
    private isEnteringPhoto = false;
    private isThird = false;
    logger: Logger = new Logger('ImageGridItemComponent');
    private OPTS = {
        'sampleSize': 1,
        'rotateDegrees': 0,
        'editable': false,
        'desiredSize': {
            'width': 0,
            'height': 0
        },
        'desiredRegion': {
            'size': {
                'width': 0,
                'height': 0
            },
            'x': 0,
            'y': 0
        },
        'desiredPixelFormat': 3,
    };

    private resetPressAnim(): void {
        this.pressAnimScale = 1;
        this.isEnteringPhoto = false;
    }

    aboutToAppear(): void {
        this.logger.debug('aboutToAppear');
        this.imageThumbnail = this.item.thumbnail;
        this.logger.debug(`imageThumbnail: ${JSON.stringify(this.imageThumbnail)}`);
        this.transitionId = this.pageName + this.item.uri;
        this.resetPressAnim();
    }

    aboutToDisappear(): void {
        this.logger.debug(`aboutToDisappear: ${this.item.uri}`);
        if (this.pixelMap) {
            this.logger.debug('aboutToDisappear: release');
            this.pixelMap.release();
        }
        this.resetPressAnim();
    }

    private onShow(): void {
        this.transitionId = this.pageName + this.item.uri;
        this.resetPressAnim();
    }

    onModeChange(newMode: boolean): void {
        this.logger.debug(`newMode ${newMode}`);
        if (!this.isSelectedMode) {
            this.isSelected = false;
        }
    }

    onAllSelect(newMode: boolean): boolean {
        this.logger.debug(`onAllSelect ${newMode}`);
        return newMode;
    }

    async routePage(isError: boolean) {
        this.logger.info(`routePage ${isError}`);
        try {
            this.logger.info(`routePage transitionId: ${this.transitionId}`);
            TraceControllerUtils.startTrace('enterPhotoBrowser');
            if (this.isThird) {
                this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.item]);
            } else {
                this.broadCast.emit(BroadCastConstants.JUMP_PHOTO_BROWSER, [this.pageName, this.item]);
            }
        } catch (err) {
            this.logger.error(`fail callback, code: ${err.code}, msg: ${err.msg}`);
        }
    }

    async routeToPreviewPage() {
        try {
            this.logger.info('routeToPreviewPage');
            this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.item]);
        } catch (err) {
            this.logger.error(`fail callback, code: ${err.code}, msg: ${err.msg}`);
        }
    }

    selectStateChange() {
        this.logger.info('change selected.');
        let newState = !this.isSelected;
        if (this.item.uri) {
            this.broadCast.emit(BroadCastConstants.SELECT, [this.position, this.item.uri, newState, function(){
                this.logger.info('enter callback');
                this.isSelected = newState;
            }.bind(this)]);
        }
    }

    private generateSampleSize(imageWidth: number, imageHeight: number): number {
        let width = ScreenManager.getInstance().getWinWidth();
        let height = ScreenManager.getInstance().getWinHeight();
        width = width == 0 ? ScreenManager.DEFAULT_WIDTH : width;
        height = height == 0 ? ScreenManager.DEFAULT_HEIGHT : height;
        let maxNumOfPixels = width * height;
        let minSide = Math.min(width, height);
        return ImageUtil.computeSampleSize(imageWidth, imageHeight, minSide, maxNumOfPixels);
    }

    build() {
        Column() {
            Stack({ alignContent: Alignment.Start }) {
                Row() {
                    Image(this.useAlt ? ((this.item.mediaType == MediaLibraryAccess.MEDIA_TYPE_VIDEO) ?
                    $r('app.media.alt_video_placeholder') : $r('app.media.alt_placeholder')) : this.imageThumbnail)
                        .alt(this.useAlt ? ((this.item.mediaType == MediaLibraryAccess.MEDIA_TYPE_VIDEO) ?
                        $r('app.media.alt_video_placeholder') : $r('app.media.alt_placeholder')) : '')
                        .aspectRatio(1)
                        .rotate({ x: 0, y: 0, z: 1, angle: this.useAlt ? 0 : this.item.orientation })
                        .objectFit(ImageFit.Cover)
                        .autoResize(false)
                        .onError(() => {
                            if (this.imageThumbnail) {
                                this.useAlt = true;
                            }
                            this.logger.error('alt Image error');
                        })
                        .onComplete(() => {
                            this.logger.debug(`Draw the image! ${this.imageThumbnail}`);
                        })
                }.sharedTransition(this.transitionId, { duration: Constants.SHARE_TRANSITION_DURATION })

                if (this.item.mediaType == MediaLibraryAccess.MEDIA_TYPE_VIDEO) {
                    Column()
                        .position({ x: '0%', y: '50%' })
                        .height('50%')
                        .width('100%')
                        .linearGradient({ angle: 0, colors:
                        [[$r('app.color.album_cover_gradient_start_color'), 0], [$r('app.color.transparent'), 1.0]] })
                    Text(DateUtil.getFormattedDuration(this.item.duration))
                        .fontSize($r('sys.float.ohos_id_text_size_caption'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('app.color.text_color_above_picture'))
                        .lineHeight($r('app.float.grid_item_text_line_height'))
                        .position({ x: '0%', y: '100%' })
                        .markAnchor({
                            x: $r('app.float.grid_item_duration_markAnchor_x'),
                            y: $r('app.float.grid_item_duration_markAnchor_y')
                        })
                        .margin({ right: $r('app.float.grid_item_duration_margin_right') })
                }

                Image($r('app.media.ic_favorite_overlay'))
                    .height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .objectFit(ImageFit.Contain)
                    .position({ x: '100%', y: '0%' })
                    .markAnchor({
                        x: $r('app.float.grid_item_favor_markAnchor_x'),
                        y: $r('app.float.grid_item_favor_markAnchor_y')
                    })
                    .visibility(this.item.isFavor ? Visibility.Visible : Visibility.None)

                Column()
                    .height('100%')
                    .width('100%')
                    .backgroundColor(this.isSelected && this.isSelectedMode ?
                    $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))
                    .onClick(() => {
                        if (this.isSelectedMode) {
                            this.selectStateChange();
                        } else {
                            this.logger.info('item onClick loadBmp');
                            if (this.isThird) {
                                this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
                                    [this.pageName, this.item]);
                            } else {
                                this.broadCast.emit(BroadCastConstants.JUMP_PHOTO_BROWSER, [this.pageName, this.item]);
                            }
                            this.isEnteringPhoto = true;
                        }
                    })

                Image($r('app.media.ic_photo_preview'))
                    .onClick(() => {
                        this.routeToPreviewPage();
                        this.logger.info('expand.');
                    })
                    .height($r('app.float.icon_size_hot'))
                    .width($r('app.float.icon_size_hot'))
                    .position({ x: '0%', y: '0%' })
                    .markAnchor({ x: 0, y: 0 })
                    .padding($r('app.float.grid_item_preview_padding'))
                    .visibility(this.isSelectedMode ? Visibility.Visible : Visibility.None)

                Image(this.isSelected
                    ? $r('app.media.ic_gallery_public_checkbox_filled') : $r('app.media.ic_checkbox_off_overlay'))
                    .height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .position({ x: '100%', y: '100%' })
                    .markAnchor({
                        x: $r('app.float.grid_item_checkbox_markAnchor'),
                        y: $r('app.float.grid_item_checkbox_markAnchor')
                    })
                    .visibility(this.isSelectedMode ? Visibility.Visible : Visibility.None)
                    .onClick(() => {
                        this.selectStateChange();
                    })
            }
            .gesture(
            LongPressGesture()
                .onAction((event: GestureEvent) => {
                    this.logger.info(`LongPressGesture ${event}`);
                    this.selectStateChange();
                    this.pressAnimScale = 1;
                })
            )
        }
        .scale({
            x: this.pressAnimScale,
            y: this.pressAnimScale
        })
        .alignItems(HorizontalAlign.Start)
        .animation({
            duration: Constants.PRESS_ANIM_DURATION,
            curve: Curve.Ease
        })
        .onTouch(event => {
            this.logger.info(`onTouch trigger: isSelectedMode: ${this.isSelectedMode},
                    isEnteringPhoto: ${this.isEnteringPhoto}, ${JSON.stringify(event)}`);
            if (this.isSelectedMode) {
                return;
            }

            // Press animation
            if (event.type == TouchType.Down) {
                this.pressAnimScale = Constants.PRESS_ANIM_SCALE;
            }

            if (event.type == TouchType.Up && !this.isEnteringPhoto && this.pressAnimScale != 1) {
                this.pressAnimScale = 1;
            }
        })
    }
}