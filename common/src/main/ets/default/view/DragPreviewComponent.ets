/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import lazy window from '@ohos.window';
import lazy { ColumnSize, getScreen, isOrientationHorizontal, WindowMode } from '../model/common/ScreenManager';
import lazy { Log } from '../utils/Log';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { ImageUtil } from '../utils/ImageUtil';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { Constants } from '../model/common/Constants';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { PhotoDataAdapter } from '../model/browser/photo/PhotoDataAdapter';
import lazy {
  PhotoBrowserStateMachine
} from '../../../../../../browserCommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { MediaItemUtil } from '../utils/MediaItemUtil'

/* instrument ignore file */
const TAG: string = 'common_DragPreviewComponent';

export const PREVIEW_PLACEHOLDER_ICON_SIZE: number = 40;

const ONE_HUNDRED: number = 100;

const ANIMATE_DURATION: number = 200;

@Extend(Image)
function previewImageStyle(uri: string, previewType: string, completeCallback?: Function) {
  .width('100%')
  .height('100%')
  .layoutWeight(1)
  .draggable(false)
  .dynamicRangeMode(DynamicRangeMode.HIGH)
  .onComplete((event?: completed): void => {
    if (event?.loadingStatus === ImageUtil.LOADING_STATUS_DECODE_SUCC) {
      Log.info(TAG, `PreviewImage ${previewType} onComplete! ${uri}`);
      if (completeCallback) {
        completeCallback();
      }
    }
  })
  .onError((error: ImageError): void => {
    Log.error(TAG, `PreviewImage ${previewType} onError! ${uri}, error=${error.message}`);
  })
}

export function getPlaceHolderIconRes(mediaType: number): Resource {
  if (mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
    return $r('sys.symbol.picture_fill');
  }
  return $r('sys.symbol.resolution_video_fill');
}

enum PreviewImageType {
  LCD = 'LCD',
  THM = 'THM',
  ORIGIN = 'Origin',
}

@Component
export struct DragPreviewComponent {
  @State stateMachine: PhotoBrowserStateMachine = new PhotoBrowserStateMachine();
  @Prop isLoadImageError: boolean = false;
  private mediaType: number = UserFileManagerAccess.MEDIA_TYPE_IMAGE;
  private item?: MediaItem;
  @State isPreviewLcdReady: boolean = false;
  @State isPreviewThumbnailReady: boolean = false;
  private imageThumbnail: string = '';
  @State previewLcdUri: string = '';
  private windowLayoutHeight: number = getScreen().getWinLayoutHeight(false);
  private windowLayoutWidth: number = getScreen().getWinLayoutWidth();
  private isHorizontal: boolean = isOrientationHorizontal();
  @State isPreviewListScrolling: boolean = false;
  @StorageLink('navigationBarHeight') @Watch('onNavigationBarHeightChange') private navigationBarHeight: number = 0;
  @StorageLink('statusBarHeight') @Watch('onStatusBarHeightChange') private statusBarHeight: number = 0;
  @StorageLink('windowStatus') windowStatus: number | undefined = undefined;
  @State private isEditSaveReload: boolean = false;
  private photoDataAdapter: PhotoDataAdapter = new PhotoDataAdapter();
  @State originOpacity: number = 0;
  @State lcdOpacity: number = 0;

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear, uri=${this.item?.uri}`);
    this.previewLcdUri = ImageUtil.getLCDUri(this.item?.uri, this.item?.path, Date.now());
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear, uri=${this.item?.uri}`);
  }

  private getPreviewUri(): string {
    Log.info(TAG, `getPreviewUri isPreviewLcdReady: ${this.item?.lcdReady}`);
    if (this.item?.lcdReady) {
      return this.previewLcdUri;
    }
    return `${this.item?.uri}?timestampApp=${Date.now()}&oper=thumbnail&width=0&height=0&path=${this.item?.path}`;
  }

  // 根据原图比例获取预览图高度，长图会做限制
  private getPreviewHeight(): number {
    let ratio = this.getRatio();
    if (!this.item) {
      Log.warn(TAG, 'preview item undefined.');
    }
    return ratio * getScreen().getPreviewColumnsWidth(ColumnSize.COLUMN_FOUR);
  }

  private isShowPreviewImage(): boolean {
    if (!this.item) {
      return false;
    }
    if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
      return true;
    }
    /**
     *  变量isPreviewVideoReady及相关逻辑删除
     *  原存在原因:担心云视频过大引起性能问题
     *  删除原因：云端视频需要播放，变量isPreviewVideoReady始终为true,变量及相关逻辑没有意义
     */
    return false;
  }

  private onNavigationBarHeightChange() {
    this.getMaxPreviewHeight();
  }

  private onStatusBarHeightChange() {
    this.getMaxPreviewHeight();
  }

  // 预览图最大高度
  private getMaxPreviewHeight(): number {
    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      return ((this.isHorizontal || getScreen().getWinMode() === WindowMode.FLOATING ?
        this.windowLayoutHeight : this.windowLayoutWidth) - px2vp(this.statusBarHeight) -
      px2vp(this.navigationBarHeight)) * Constants.PREVIEW_PAD_HORIZONTAL;
    }
    if (this.isAutoHeight() && !DeviceInfo.isVerdeFoldable() && getScreen().getWinMode() != WindowMode.FLOATING &&
      !(WindowMode.UNDEFINED === getScreen().getWinMode() && DeviceInfo.isFoldable())
    ) {
      return (this.windowLayoutHeight - Constants.PREVIEW_PHONE_HORIZONTAL_MAX -
      Constants.PREVIEW_PHONE_HORIZONTAL_MIN - px2vp(this.navigationBarHeight));
    }
    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && !DeviceInfo.isVerdeFoldable()) {
      return ((this.isHorizontal ? this.windowLayoutWidth : this.windowLayoutHeight) - px2vp(this.statusBarHeight) -
      px2vp(this.navigationBarHeight)) / Constants.PREVIEW_HEIGHT_HALF;
    }
    // 直板机、xxx
    if (!this.isHorizontal) {
      return ((this.windowLayoutHeight - px2vp(this.statusBarHeight) - px2vp(this.navigationBarHeight)) /
      Constants.PREVIEW_HEIGHT_HALF);
    } else {
      return (this.windowLayoutHeight - Constants.PREVIEW_PHONE_HORIZONTAL_MAX -
      Constants.PREVIEW_PHONE_HORIZONTAL_MIN - px2vp(this.navigationBarHeight));
    }
  }

  // 根据原图比例获取预览图比例
  private getRatio(): number {
    if (this.item) {
      let realWidth = this.item.width;
      let realHeight = this.item.height;
      if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        let coverRadio = Math.floor((this.item.coverWidth / this.item.coverHeight) * ONE_HUNDRED) / ONE_HUNDRED;
        let videoRadio = Math.floor((this.item.width / this.item.height) * ONE_HUNDRED) / ONE_HUNDRED;
        if (coverRadio !== videoRadio) {
          realWidth = this.item.coverWidth;
          realHeight = this.item.coverHeight;
        }
      }
      return ImageUtil.getPreviewImageLayoutRatio(realWidth, realHeight);
    }
    return Constants.PREVIEW_DEFAULT_RATIO;
  }

  isAutoHeight() {
    return DeviceInfo.isVerdeFoldable() ||
    [WindowMode.FLOATING, WindowMode.UNDEFINED].includes(getScreen().getWinMode()) ||
      WindowMode.PRIMARY == getScreen().getWinMode() && this.windowStatus == window.WindowStatusType.SPLIT_SCREEN;
  }

  // 长按预览区通用宽高样式，默认原图比例，长图会做限制
  @Styles
  previewCommonStyle() {
    .draggable(false)
    .width(this.isAutoHeight() ? undefined : this.getMaxPreviewHeight() / this.getRatio())
    .height(this.isAutoHeight() ? undefined : this.getPreviewHeight())
    .constraintSize({
      maxWidth: getScreen().getPreviewColumnsWidth(ColumnSize.COLUMN_FOUR),
      maxHeight: this.getMaxPreviewHeight(),
    })
  }

  @Styles
  previewSizeRotateStyle() {
    .width(this.getPreviewHeight())
    .height(this.getMaxPreviewHeight() / this.getRatio())
    .constraintSize({
      maxWidth: this.getMaxPreviewHeight(),
      maxHeight: getScreen().getPreviewColumnsWidth(ColumnSize.COLUMN_FOUR),
    })
  }

  @Builder
  PreviewErrorImage(res: Resource) {
    Column() {
      SymbolGlyph(res)
        .fontSize(PREVIEW_PLACEHOLDER_ICON_SIZE)
        .fontColor([$r('sys.color.ohos_id_color_click_effect')])
        .draggable(false)
    }
    .width(getScreen().getPreviewColumnsWidth(ColumnSize.COLUMN_TWO))
    .height(getScreen().getPreviewColumnsWidth(ColumnSize.COLUMN_TWO))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
  }

  // 预览图loading占位符，ASTC和LCD加载均未完成时展示
  @Builder
  PreviewPlaceHolder() {
    Column() {
      LoadingProgress()
        .width(PREVIEW_PLACEHOLDER_ICON_SIZE)
        .height(PREVIEW_PLACEHOLDER_ICON_SIZE)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .previewCommonStyle()
    .backgroundBlurStyle(BlurStyle.Regular)
  }

  @Builder
  MediaImage() {
    // 无LCD，先展示小缩略图
    MediaCachedImage(this.imageThumbnail)
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .draggable(false)
      .onComplete((event?: completed): void => {
        if (event?.loadingStatus === ImageUtil.LOADING_STATUS_DECODE_SUCC) {
          Log.info(TAG, `PreviewImage ${PreviewImageType.THM} onComplete! ${this.imageThumbnail}`);
          this.isPreviewThumbnailReady = true;
        }
      })
      .onError((error: ImageError): void => {
        Log.error(TAG, `PreviewImage ${PreviewImageType.THM} onError! ${this.imageThumbnail}, error=${error}`);
      })
  }

  @Builder
  PreviewThumbnail() {
    Stack() {
      if (!this.isPreviewLcdReady) {
        this.MediaImage();
      }

      // 有LCD则展示LCD
      Image(this.previewLcdUri)
        .opacity(this.lcdOpacity)
        .previewImageStyle(this.previewLcdUri, PreviewImageType.LCD, (): void => {
          animateTo({
            duration: ANIMATE_DURATION,
            curve: Curve.Linear,
            onFinish: () => {
              this.isPreviewLcdReady = true;
            }
          }, () => {
            this.lcdOpacity = 1;
          })
        })
    }
    .width('100%')
    .height('100%')
  }

  private isDownSampling(): boolean {
    if (!this.item) {
      return false;
    }
    let maxLength = Constants.IMAGE_SOURCE_THUMBNAIL_MAX_LENGTH;
    return this.item.height > maxLength || this.item.width > maxLength;
  }

  private getImageSourceByUri(): string {
    if (!this.item) {
      return '';
    }
    try {
      let maxLength = Constants.IMAGE_SOURCE_THUMBNAIL_MAX_LENGTH;
      let height = this.item.height;
      let width = this.item.width;
      if (this.item.height > maxLength || this.item.width > maxLength) {
        if (this.item.height > this.item.width) {
          height = maxLength;
          width = width * maxLength / this.item.height;
        } else {
          height = height * maxLength / this.item.width;
          width = maxLength;
        }
        let imageSource = this.photoDataAdapter
          .getImageSource(this.item, { width: width, height: height });
        Log.info(TAG, `getImageSourceByUri pixelMap: ${imageSource}, uri: ${this.item.uri} size: ${this.item.size}
         uri: ${this.item.uri}`);
        return imageSource ?? this.item.thumbnail;
      }
      return this.item.uri;
    } catch (err) {
      Log.error(TAG, `getImageSourceByUri error: ${err}, code: ${err?.code}`);
      return this.item.thumbnail;
    }
  }

  @Builder
  OriginPhotoBuilder() {
    Image(this.getImageSourceByUri())
      // .orientation(this.isDownSampling() ? ImageRotateOrientation.UP :
      //   MediaItemUtil.getRotateOrientation(this.item?.exifRotate))
      .opacity(this.originOpacity)
      .previewImageStyle(this.item?.uri ?? '', PreviewImageType.ORIGIN, () => {
        animateTo({
          duration: ANIMATE_DURATION,
          curve: Curve.Linear,
        }, () => {
          this.originOpacity = 1;
        })
      })
      .width('100%')
      .height('100%')
  }

  @Builder
  PreviewImage() {
    // 占位图、THM、LCD层叠，高清图优先展示，其余隐藏
    Stack() {
      if (!this.isPreviewLcdReady && !this.isPreviewThumbnailReady) {
        // LCD和THM都没有，显示loading
        this.PreviewPlaceHolder();
      }
      // THM和LCD
      this.PreviewThumbnail();

      // 原图
      this.OriginPhotoBuilder();
    }
    .previewCommonStyle()
  }

  // 长按预览视频控件，为防止拉起瞬间黑图，设置封面uri用于占位
  @Builder
  PreviewVideo() {
    Column() {
      Video({ src: this.item?.uri ?? '', previewUri: this.getPreviewUri() })
        .width('100%')
        .height('100%')
        .autoPlay(true)
        .controls(false)
        .loop(false)
        .muted(true)
        .onStart((): void => {
          Log.info(TAG, `video onStart, uri=${this.item?.uri}, previewLcdUri=${this.previewLcdUri}`);
        })
        .onAppear(() => {
          Log.info(TAG, `video onAppear, uri=${this.item?.uri}, previewLcdUri=${this.previewLcdUri}`);
        })
        .onDisAppear((): void => {
          Log.info(TAG, `video onDisAppear, uri=${this.item?.uri}, previewLcdUri=${this.previewLcdUri}`);
        })
        .onError((): void => {
          Log.info(TAG, `video onError, uri=${this.item?.uri}, previewLcdUri=${this.previewLcdUri}`);
        })
    }
    .previewCommonStyle()
  }

  build() {
    Column() {
      if (this.isLoadImageError) {
        this.PreviewErrorImage(getPlaceHolderIconRes(this.mediaType));
      } else if (this.isShowPreviewImage()) {
        this.PreviewImage();
      } else {
        this.PreviewVideo();
      }
    }
  }
}
