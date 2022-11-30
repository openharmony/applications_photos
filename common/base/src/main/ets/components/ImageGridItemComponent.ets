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
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '../utils/Log';
import { AnimationConstants } from '../constants/AnimationConstants';
import { MediaDataItem } from '../data/MediaDataItem';
import { DateUtil } from '../utils/DateUtil';
import { Broadcast } from '../utils/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { startTrace } from '../utils/TraceControllerUtils';
import { MediaConstants } from '../constants/MediaConstants';
import { startTraceWithTaskId, finishTraceWithTaskId } from '../utils/TraceControllerUtils';
import Curves from '@ohos.curves'

const TAG = "ImageGridItemComponent"
// General grid picture control
@Component
export struct ImageGridItemComponent {
    @Consume broadCast: Broadcast;
    @Consume isSelectedMode: boolean;
    @Consume @Watch('onShow') isShow: boolean;
    @State thumbnail: string = "";
    @State isFavourite: boolean = false;
    @State pressAnimScale: number = 1.0;
    @State isError: boolean = false;
    pageName = '';
    mediaItem: MediaDataItem;
    isThird = false;
    private isEnteringPhoto = false;

    private resetPressAnim(): void {
        this.pressAnimScale = 1;
        this.isEnteringPhoto = false;
    }

    aboutToAppear(): void {
        Log.debug(TAG, 'aboutToAppear');
        this.resetShow();
    }

    calcThumbnail(uri: string, imageHeight: number, imageWidth: number, orientation?: number): string {
        Log.info(TAG, `calcThumbnail satrt`);
        if(uri == null) {
            return "";
        }
        if(!imageWidth || !imageHeight) {
            return `${uri}/thumbnail/256/256`;
        }
        if(imageHeight < MediaConstants.DEFAULT_THUMBNAIL_SIZE || imageWidth < MediaConstants.DEFAULT_THUMBNAIL_SIZE) {
            return `${uri}/thumbnail/${imageWidth}/${imageHeight}`;
        }
        let width = 0;
        let height = 0;
        if(orientation != null && (orientation == MediaConstants.ROTATE_ONCE || orientation == MediaConstants.ROTATE_THIRD)) {
            let temp = imageWidth;
            imageWidth = imageHeight;
            imageHeight = temp;
        }
        if(imageHeight < imageWidth) {
            height = MediaConstants.DEFAULT_THUMBNAIL_SIZE;
            width = Math.round(height * imageWidth / imageHeight);
        }else {
            width = MediaConstants.DEFAULT_THUMBNAIL_SIZE;
            height = Math.round(width * imageHeight / imageWidth);
        }
        return `${uri}/thumbnail/${width}/${height}`;
    }

    private resetShow() {
        startTraceWithTaskId("load MediaItem", this.mediaItem.index);
        this.mediaItem.load(false).then(() => {
            finishTraceWithTaskId("load MediaItem", this.mediaItem.index);
            this.thumbnail = this.mediaItem.getThumbnail(MediaConstants.DEFAULT_SIZE, MediaConstants.DEFAULT_SIZE);
            this.isError = false;
            Log.debug(TAG, `getThumbnail ${this.thumbnail}`);
            this.mediaItem.isFavor().then((status: boolean) => {
                this.isFavourite = status;
            })
        })
        this.resetPressAnim();
    }

    aboutToDisappear(): void {
        Log.debug(TAG, `aboutToDisappear`);
        this.resetPressAnim();
    }

    private onShow(): void {
        this.resetPressAnim();
    }

    async routePage(isError: boolean) {
        Log.info(TAG, `routePage ${isError}`);
        try {
            startTrace('enterPhotoBrowser');
            if (this.isThird) {
                this.broadCast.emit(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
            } else {
                this.broadCast.emit(BroadcastConstants.JUMP_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
            }
        } catch (err) {
            Log.error(TAG, `fail callback, code: ${err.code}, msg: ${err.msg}`);
        }
    }

    async routeToPreviewPage() {
        try {
            Log.info(TAG, 'routeToPreviewPage');
            this.broadCast.emit(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
        } catch (err) {
            Log.error(TAG, `fail callback, code: ${err.code}, msg: ${err.msg}`);
        }
    }

    private onSelected() {
        Log.info(TAG, 'onSelected');
        this.mediaItem.setSelect(!this.mediaItem.isSelect);
        this.broadCast.emit(BroadcastConstants.SELECT, [this.mediaItem.index]);
    }

    private selectStateChange() {
        Log.info(TAG, `change selected ${this.isSelectedMode}`);
        if (!this.isSelectedMode) {
            this.isSelectedMode = true;
            this.pressAnimScale = 1;
        }
        this.onSelected();
    }

    build() {
        Stack({ alignContent: Alignment.Start }) {
            Image(this.isError ? this.mediaItem.getAlt() : this.thumbnail)
                .aspectRatio(1)
                .rotate({ x: 0, y: 0, z: 1, angle: this.isError ? 0 : this.mediaItem.orientation })
                .objectFit(ImageFit.Cover)
                .autoResize(false)
                .onComplete(() => {
                    Log.debug(TAG, `Draw the image! ${this.thumbnail}`);
                })

                .onError(() => {
                    Log.error(TAG, `alt Image ${this.mediaItem.index} error :${this.thumbnail}`);
                    if (this.thumbnail.length == 0 || this.mediaItem.width == 0 || this.mediaItem.height == 0) {
                        this.resetShow()
                    } else {
                        this.isError = true
                    }
                })
                .sharedTransition(this.pageName + this.mediaItem.getHashCode(), {
                    duration: AnimationConstants.SHARE_TRANSITION_DURATION,
                    curve:Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
                })

            if (this.mediaItem.mediaType == MediaLib.MediaType.VIDEO) {
                Column()
                    .position({ x: '0%', y: '50%' })
                    .height('50%')
                    .width('100%')
                    .linearGradient({
                        angle: 0,
                        colors: [[$r('app.color.album_cover_gradient_start_color'), 0], [$r('app.color.transparent'), 1.0]]
                    })
                Text(DateUtil.getFormattedDuration(this.mediaItem.duration))
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
            if (this.isFavourite) {
                Image($r('app.media.ic_favorite_overlay'))
                    .height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .objectFit(ImageFit.Contain)
                    .position({ x: '100%', y: '0%' })
                    .markAnchor({
                        x: $r('app.float.grid_item_favor_markAnchor_x'),
                        y: $r('app.float.grid_item_favor_markAnchor_y')
                    })
            }

            Column()
                .height('100%')
                .width('100%')
                .backgroundColor(this.isSelectedMode && this.mediaItem.isSelect ?
                $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))
                .onClick(() => {
                    if (this.isSelectedMode) {
                        this.onSelected();
                    } else {
                        Log.info(TAG, 'item onClick loadBmp');
                        this.thumbnail = this.calcThumbnail(this.mediaItem.uri, this.mediaItem.height, this.mediaItem.width, this.mediaItem.orientation)
                        Log.info(TAG, `item onClick ${this.thumbnail}`);
                        if (this.isThird) {
                            this.broadCast.emit(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
                        } else {
                            this.broadCast.emit(BroadcastConstants.JUMP_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
                        }
                        this.isEnteringPhoto = true;
                    }
                })
            if (this.isSelectedMode) {
                Image($r('app.media.ic_photo_preview'))
                    .onClick(() => {
                        this.thumbnail = this.calcThumbnail(this.mediaItem.uri, this.mediaItem.height, this.mediaItem.width, this.mediaItem.orientation)
                        this.routeToPreviewPage();
                        Log.info(TAG, 'expand.');
                    })
                    .height($r('app.float.icon_size_hot'))
                    .width($r('app.float.icon_size_hot'))
                    .position({ x: '0%', y: '0%' })
                    .markAnchor({ x: 0, y: 0 })
                    .padding($r('app.float.grid_item_preview_padding'))
                Image(this.mediaItem.isSelect
                    ? $r('app.media.ic_gallery_public_checkbox_filled') : $r('app.media.ic_checkbox_off_overlay'))
                    .height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .position({ x: '100%', y: '100%' })
                    .markAnchor({
                        x: $r('app.float.grid_item_checkbox_markAnchor'),
                        y: $r('app.float.grid_item_checkbox_markAnchor')
                    })
                    .onClick(() => {
                        this.onSelected();
                    })
            }
        }
        .scale({
            x: this.pressAnimScale,
            y: this.pressAnimScale
        })
        .animation({
            duration: AnimationConstants.PRESS_ANIM_DURATION,
            curve: Curve.Ease
        })
        .onTouch(event => {
            Log.info(TAG, `onTouch trigger: isSelectedMode: ${this.isSelectedMode},
                    isEnteringPhoto: ${this.isEnteringPhoto}, ${JSON.stringify(event)}`);
            if (this.isSelectedMode) {
                return;
            }

            // Press animation
            if (event.type == TouchType.Down) {
                this.pressAnimScale = AnimationConstants.PRESS_ANIM_SCALE;
            }

            if (event.type == TouchType.Up && !this.isEnteringPhoto && this.pressAnimScale != 1) {
                this.pressAnimScale = 1;
            }
        })
        .gesture(LongPressGesture().onAction((event: GestureEvent) => {
            if (!this.isThird) {
                Log.info(TAG, `LongPressGesture ${this.isSelectedMode}`);
                this.selectStateChange();
            }
        }))
    }
}