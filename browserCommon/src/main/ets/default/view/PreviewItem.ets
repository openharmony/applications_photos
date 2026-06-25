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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { PhotoItem } from './PhotoItem';
import lazy Swipes from '@ohos/common/src/main/ets/default/view/Swipes';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { AvPlayConstants } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy { AssetHelper } from '@ohos/common/src/main/ets/default/utils/AssetHelper';
import lazy { Thumbnail } from '@ohos/common/src/main/ets/default/model/browser/photo/Thumbnail';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy Rsc from '@ohos/tools/src/main/global/RscString';
import lazy {
  ShortcutManager,
  ShortcutController
} from '../controller/ShortcutController';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { PreviewItemVM } from '../viewModel/base/PreviewItemVM';
import lazy { PhotoBrowserStateMachine } from '../viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { EditorPhotoContext } from '@ohos/common/src/main/ets/default/utils/EditorPhotoContext';

/* instrument ignore file  */
const TAG: string = 'common_PreviewItem';

/**
 * 比较系数
 */
const DIFF_FACTOR = 2;
/**
 * 计算系数
 */
const HALF_FACTOR = 2;

const PREVIEW_PROGRESS_TOP_MARGIN = 12;
const PREVIEW_ITEM_PLACEHOLDER_COLOR: string = '#cfd3d8';

export enum AnchorDirection {
  HEADER,
  FOOTER
}

@Component
export struct PreviewItem {
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  // 进入和退出连拍时，两侧缩略图的透明度
  @Prop previewItemOpacity: number = 1;
  // 进入和退出连拍时，当前缩略图的透明度
  @Prop centerPreviewOpacity: number = 1;
  /* instrument ignore next */
  @ObjectLink item: MediaResult;
  @Link private isScrolling: boolean;
  @Link @Watch('onCenterIndexChanged') private centerIndex: number;
  @Link private curBigOffset: number;
  // 预览条抛滑
  @Link private targetOffset: number;
  @Link @Watch('shrinkFactorChanged') private shrinkFactor: number;
  @Link @Watch('onForceRefreshChanged') private forceRefresh: number;
  @Prop private currentScrollState: number;
  @Link private videoCoverFrame: PixelMap[];
  @Link private isPreviewBarAnimation: boolean;
  @Link private isFrameOpenAni: boolean;
  @Link private isTouchVideoPreview: boolean;
  @State private centerVideoPreviewWidth: number = this.getCenterVideoPreviewWidth();
  private fallBackDelay: number = 0;
  private targetWidth: number = 0;
  private secondMargin: number = 0;
  private indexDiff: number = 0;
  private absIndexDiff: number = 0;
  @State private itemScale: number = 1;
  @State private itemMargin: number = 0;
  @State private offsetScale: number = 0;
  @State private offsetMargin: number = 0;
  @State private windowLayoutWidth: number = getScreen().getWinLayoutWidth();
  private shortcutController: ShortcutController = ShortcutManager.getInstance();
  private handleKeyEvent: Function = (event: KeyEvent): void => {
  };
  private isClick: boolean = true;
  private onSmallImgClickAction: Function = () => {
  }
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  // 展开前预览条中进度条的位移，初始位置：首帧起始处
  @Link private previewProgressOffset: number;
  @Link private isFrameExpand: boolean;
  @Link private anchorDirection: AnchorDirection;
  // 解决图片还未加载，就已经开始走淡入的动画效果，导致前半段动效没有呈现
  @State previewVisibility: Visibility = Visibility.Hidden;
  private defaultCoverFrame: number[] = [0, 0];
  private selectedSmallImgWidth: number = ImageUtil.getSelectedSmallImgWidth();
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  @LocalStorageLink('isBrowserShow') isBrowserShow: boolean = true;
  @StorageLink('currentLanguage') currentLanguage: string | undefined = undefined;
  @StorageLink('isDoingRecoverBigPhotoAnim') isDoingRecoverAnim: boolean = false;
  @Link private opacityValue: number;
  @State viewModel: PreviewItemVM = new PreviewItemVM(this.stateMachine);
  @State private hasRetriedLoadWithLcd: boolean = false;
  private onVideoFrameClickAction: Function = () => {
  }
  private updateVideoWidthFunc: Function = (width: number):
    void => this.updateVideoWidth(width);

  private isVideo(): boolean | undefined {
    return this.item?.item && this.item?.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
  }

  private updateVideoWidth(width: number): void {
    this.centerVideoPreviewWidth = width;
  }

  // 点击扩展的逐帧抽取，未获取时先用首帧占位, 该方法的具体实现在photoswiper中
  private onVideoFrameClickActionFunc: Function = (uri: string) => {
    if (!this.isFrameExpand && !this.isFrameOpenAni) {
      this.onVideoFrameClickAction(uri);
    }
  }

  private shrinkFactorChanged() {
    Log.info(TAG, 'shrinkFactorChanged');
    animateTo({
      duration: Constants.WAVE_PREVIEW_ANIM_DURATION,
      curve: Swipes.DELETE_PHOTO_CURVE,
      delay: 0,
      playMode: PlayMode.Normal,
      onFinish: () => {
      }
    }, () => {
      this.calcItemStyle();
    })
  }

  //停止态两侧回落动效
  /* instrument ignore next */
  onShrinkFactorChanged() {
    if (this.shrinkFactor === 1) {
      if (this.viewModel) {
        this.fallBackDelay = Constants.TOUCH_FALL_BACK_DELAY;
      } else if (this.isScrolling) {
        this.fallBackDelay = Constants.SCROLL_FALL_BACK_DELAY;
      }
      animateTo({
        curve: Swipes.DELETE_PHOTO_CURVE, delay: this.fallBackDelay,
        onFinish: (): void => {
          if (this.item.itemWidth !== undefined && this.item?.pos === this.centerIndex) {
            this.itemMargin = HALF_FACTOR * this.item.itemWidth / (1 + this.item.itemWidth /
            ImageUtil.getSmallImgWidth() * Constants.WAVE_PREVIEW_SCALE_MAX);
            this.itemScale = Constants.WAVE_PREVIEW_SCALE_MAX;
          } else {
            this.itemMargin = 0;
            this.itemScale = 1;
          }
        }
      }, (): void => {
      });
    }
  }

  onCenterIndexChanged() {
    Log.info(TAG, 'onCenterIndexChanged');
    this.calcItemStyle();
  }

  onForceRefreshChanged() {
    Log.info(TAG, 'onForceRefreshChanged');
    if (this.shouldForceRefreshEditedItem()) {
      const mediaItem = this.item.item;
      this.hasRetriedLoadWithLcd = false;
      const currentThumbnail: string = this.item?.thumbnail?.url ?? '';
      const refreshToken: number = Date.now();
      const refreshUri: string = `${ImageUtil.getLCDUri(mediaItem?.uri, mediaItem?.path, mediaItem?.getDateModified?.())}` +
        `&forceupdate=true&timestampApp=${refreshToken}`;
      if (currentThumbnail !== refreshUri) {
        this.item.setItemThumbnail(new Thumbnail(refreshUri));
      }
      this.previewVisibility = Visibility.Hidden;
    }
    this.calcItemStyle();
  }

  private shouldForceRefreshEditedItem(): boolean {
    if (!this.item?.item?.path || !this.item?.item?.getDateModified?.()) {
      return false;
    }
    const photoEditSaveUri: string | undefined = LocalStorage.getShared()?.get<string>(
      BroadCastConstants.PHOTO_EDIT_SAVE_URI);
    const editorExitUri: string | undefined = EditorPhotoContext.getInstance().getEditorUriOnExit();
    const targetUri: string | undefined = photoEditSaveUri || editorExitUri;
    return !!targetUri && targetUri === this.item.item.uri && EditorPhotoContext.getInstance().getNotifyHideEditor();
  }

  // 大图跟手位移
  /* instrument ignore next */
  onCurBigOffsetChanged() {
    this.calcItemStyle();
    if (this.curBigOffset !== 0) {
      this.calcOffsetChange(this.curBigOffset, this.windowLayoutWidth);
    }
    this.calcItemChange(this.offsetScale, this.offsetMargin);
  }

  // 预览条跟手位移
  /* instrument ignore next */
  onTargetOffsetChanged() {
    this.calcItemStyle();
    if (this.item.itemWidth !== undefined) {
      this.targetWidth = Constants.WAVE_TARGET_WIDTH_FACTOR * this.item?.itemWidth + this.itemMargin;
    }
    if (Math.abs(this.targetOffset) <= this.targetWidth && this.targetOffset !== 0) {
      this.calcOffsetChange(this.targetOffset, this.targetWidth);
    }
    this.calcItemChange(this.offsetScale, this.offsetMargin);
  }

  // 计算item style信息
  private calcItemStyle() {
    if (this.item.itemWidth !== undefined && this.item.pos !== undefined) {
      this.indexDiff = this.item?.pos - this.centerIndex;
      this.absIndexDiff = Math.abs(this.item?.pos - this.centerIndex);
      this.secondMargin = Constants.WAVE_SECOND_MARGIN_FACTOR * this.item?.itemWidth / ImageUtil.getSmallImgWidth();
    }
    if ((this.isScrolling || this.absIndexDiff > DIFF_FACTOR)) {
      this.itemScale = 1;
      this.itemMargin = 0;
    } else {
      if (this.absIndexDiff === 0) {
        this.itemScale = Constants.WAVE_PREVIEW_SCALE_MAX;
        if (this.item && this.item.itemWidth) {
          this.itemMargin =
            HALF_FACTOR * this.item.itemWidth / (1 + this.item.itemWidth / ImageUtil.getSmallImgWidth() *
            Constants.WAVE_PREVIEW_SCALE_MAX);
        }
      } else {
        this.itemScale = 1;
        this.itemMargin = 0;
      }
    }
  }

  /* instrument ignore next */
  private calcOffsetChange(offset: number, width: number) {
    this.offsetScale = Math.abs(offset * Constants.WAVE_PREVIEW_SCALE_GEAR / width);
    this.offsetScale = Math.min(this.offsetScale, Constants.WAVE_PREVIEW_SCALE_GEAR);
    this.offsetMargin = Math.abs(offset * this.secondMargin / width);
    this.offsetMargin = Math.min(this.offsetMargin, this.secondMargin - Constants.WAVE_SECOND_MARGIN_GEAR);
  }

  /* instrument ignore next */
  private calcItemChange(offsetScale: number, offsetMargin: number) {
    if ((this.currentScrollState === 0 && !this.viewModel.isTouching()) || this.currentScrollState === DIFF_FACTOR) {
      if (this.absIndexDiff === 0) {
        this.itemScale = Constants.WAVE_PREVIEW_SCALE_MAX;
        this.itemMargin = this.secondMargin;
      }
      return;
    }
    if (this.curBigOffset < 0 || this.targetOffset > 0) {
      if (this.indexDiff === -1 || this.indexDiff === 0) {
        this.itemScale -= offsetScale;
        this.itemMargin -= offsetMargin / HALF_FACTOR;
      }
      if (this.indexDiff === 1 || this.indexDiff === DIFF_FACTOR) {
        this.itemScale += offsetScale;
        this.itemMargin += offsetMargin / HALF_FACTOR;
      }
    } else if (this.curBigOffset > 0 || this.targetOffset < 0) {
      if (this.indexDiff === -DIFF_FACTOR || this.indexDiff === -1) {
        this.itemScale += offsetScale;
        this.itemMargin += offsetMargin / HALF_FACTOR;
      }
      if (this.indexDiff === 0 || this.indexDiff === 1) {
        this.itemScale -= offsetScale;
        this.itemMargin -= offsetMargin / HALF_FACTOR;
      }
    }
    if (this.absIndexDiff < DIFF_FACTOR) {
      this.itemMargin = Math.min(this.itemMargin, this.secondMargin);
    }
  }

  private tryFallbackToLcdOnError(event: ImageError): boolean {
    if (!this.item?.item || this.hasRetriedLoadWithLcd) {
      return false;
    }
    let lcdUri = ImageUtil.getLCDUri(this.item.item.uri, this.item.item.path, this.item.item.getDateModified?.());
    let userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (userId > 0) {
      lcdUri += `&user=${userId}`;
    }
    if (!lcdUri || lcdUri === this.item?.thumbnail?.url) {
      return false;
    }
    this.hasRetriedLoadWithLcd = true;
    this.item.setItemThumbnail(new Thumbnail(lcdUri));
    this.previewVisibility = Visibility.Visible;
    Log.warn(TAG, `preview thumbnail load failed, retry with lcd. index=${this.item?.pos}, uri=${
      this.item.item.uri}, path=${this.item.item.path}, fallbackSource=${lcdUri}, error=${event?.message}`);
    return true;
  }

  //获取图片文本信息
  /* instrument ignore next */
  private getImageText(): string {
    let text: string = '';
    if (this.item?.pos === this.centerIndex) {
      text = Rsc.toString($r('app.string.selected'));
    }
    if (this.item.item?.data) {
      let dateNumber = Number(AssetHelper.get(this.item.item.data,
        photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString()));
      let photoDate: string = DateUtil.getLocalizedDate(dateNumber);
      let timeAndLocation: string = DateUtil.getLocalizedTime(dateNumber);
      return `${text} ${Rsc.toString($r('app.string.album_photos'))} ${(this.item.pos ?? 0) + 1},
          ${photoDate} ${timeAndLocation}`;
    } else {
      return '';
    }
  }

  // 获取视频文本信息
  private getVideoText(): string {
    let text: string = '';
    if (this.item?.pos === this.centerIndex) {
      text = Rsc.toString($r('app.string.selected'));
    }
    if (this.item.item?.data) {
      let dateNumber = Number(AssetHelper.get(this.item.item.data,
        photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString()));
      let photoDate: string = DateUtil.getLocalizedDate(dateNumber);
      let timeAndLocation: string = DateUtil.getLocalizedTime(dateNumber);
      let videoDuration: string = DateUtil.getFormattedDurationForScreenReader(this.item.item.duration ?? 0);
      return `${text} ${Rsc.toString($r('app.string.album_video'))} ${(this.item.pos ?? 0) + 1},
          ${Rsc.toString($r('app.string.duration'))}${videoDuration}, ${photoDate} ${timeAndLocation}`;
    } else {
      return '';
    }
  }

  /**
   * 图片
   */
  @Builder
  SmallImgItemBuilder() {
    ListItem() {
      MediaCachedImage(this.item?.thumbnail?.url)
        .width(DeviceInfo.isTv() ? $r('app.float.tv_swiper_item_size') :
          Swipes.calcPxRoundToInteger(this.item?.itemWidth))
        .height(DeviceInfo.isTv() ? Constants.FULL_PERCENT : ((this.item?.pos === this.centerIndex) ?
          ImageUtil.getSelectedSmallImgHeight() : ImageUtil.getSmallImgHeight()))
        .backgroundColor(PREVIEW_ITEM_PLACEHOLDER_COLOR)
        .draggable(false)
        .objectFit(ImageFit.Cover)
        .borderRadius(DeviceInfo.isTv() ? $r('sys.float.corner_radius_level6') : undefined)
        .backgroundBlurStyle(DeviceInfo.isTv() ? BlurStyle.BACKGROUND_ULTRA_THICK : undefined)
        .borderWidth(DeviceInfo.isTv() && (this.item?.pos === this.centerIndex) ? 3 : undefined)
        .borderColor(DeviceInfo.isTv() && (this.item?.pos === this.centerIndex) ?
          $r('app.color.default_background_color') : undefined)
        .shadow(DeviceInfo.isTv() ? {
          radius: 60,
          color: '#26000000',
          offsetX: 0,
          offsetY: 20,
        } : undefined)
        .onComplete((event?: completed) => {
          Log.debug(TAG, `SmallImgItemBuilder onComplete, componentWidth:${event?.componentWidth},
          contentHeight:${event?.componentHeight}, imagePosition: ${this.item?.pos}, uri: ${this.item?.thumbnail?.url},width: ${this.item?.width}
          loadingState:${event?.loadingStatus}`);
          this.previewVisibility = Visibility.Visible;
        })
        .onError((event: ImageError) => {
          if (this.tryFallbackToLcdOnError(event)) {
            return;
          }
          this.previewVisibility = Visibility.Visible;
          Log.error(TAG,
            `SmallImgItemBuilder load error, imagePosition: ${this.item?.pos}, item: ${this.item?.thumbnail?.url}, ${JSON.stringify(this.item?.thumbnail)}, error: ${event?.message}`);
        })
        .onKeyEvent((event: KeyEvent): void => {
          Log.info(TAG, `smallImg handleKeyEvent type= ${event.type}, keyCode= ${event.keyCode}`);
          if (event.type === 0 &&
            (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER ||
              event.keyCode === MultimodalInputManager.KEY_CODE_SPACE)) {
            this.shortcutController.listen(event);
            // 只有一张图片或视频不会进来这里
            this.isClick = false;
          }
          event.stopPropagation();
        })
        .onDisAppear((): void => {
          Log.info(TAG, `smallImg onDisAppear url: ${this.item?.thumbnail?.url}`);
        })
    }
    .accessibilityText(this.isOpenTouchGuide ? this.getImageText() : '')
    .onClick((): void => {
      Log.info(TAG, 'image onclick');
      if (!this.isClick) {
        this.isClick = true;
        return;
      }
      this.onSmallImgClickAction(this.item?.item?.uri);
    })
    .visibility(this.previewVisibility)
    .key(`PreviewBarItemImage ${this.item?.pos}`)
    .scale(DeviceInfo.isTv() ? undefined : {
      x: this.itemScale,
      y: this.itemScale,
      centerX: Constants.PERCENT_50,
      centerY: Constants.PERCENT_100,
    })
    .margin({
      left: DeviceInfo.isTv() ? Constants.TV_SWIPER_PADDING_BOTTOM / 2 : this.itemMargin,
      right: DeviceInfo.isTv() ? Constants.TV_SWIPER_PADDING_BOTTOM / 2 : this.itemMargin,
    })
    .opacity((this.item?.pos === this.centerIndex) ? this.centerPreviewOpacity : this.previewItemOpacity)
    .transition(TransitionEffect
      .scale((this.item?.pos === this.centerIndex && AppStorage.get('isDoingDeleteBigPhotoAnim')) ? {
        // 缩放比例
        x: Constants.SMALL_SCALE,
        y: Constants.SMALL_SCALE,
        centerX: Constants.PERCENT_50,
        centerY: Constants.PERCENT_100,
      } : {
        x: 1,
        y: 1,
        centerX: Constants.PERCENT_50,
        centerY: Constants.PERCENT_100,
      }).animation({
        duration: PhotoConstants.DELETE_DURATION,
        curve: Swipes.DELETE_PHOTO_CURVE,
        delay: Constants.SMALL_DELETE_ANIM_DELAY,
        playMode: PlayMode.Normal,
      })
      .combine((this.item?.pos === this.centerIndex && AppStorage.get('isDoingDeleteBigPhotoAnim')) ?
      TransitionEffect.OPACITY.animation({
        delay: Constants.SMALL_DELETE_ANIM_DELAY,
        duration: Constants.SMALL_SCALE_ANIM_DURATION,
      }) : (this.item?.pos === this.centerIndex && this.isDoingRecoverAnim) ?
          TransitionEffect.OPACITY.animation({ duration: Constants.SMALL_SCALE_ANIM_DURATION })
          : TransitionEffect.OPACITY.animation({ duration: PhotoItem.PULL_DOWN_ITEM_ANIM_DURATION })
      )
    )
  }

  @Builder
  PreviewProgressBuilder() {
    Row() {
    }
    .width(this.getPreviewProgressWidth())
    .height(this.getPreviewProgressHeight())
    .borderRadius(this.getPreviewProgressBorderRadius())
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
    .translate({ x: i18n.isRTL(this.currentLanguage) ? -this.previewProgressOffset : this.previewProgressOffset })
    .borderColor(this.getPreviewProgressBorderColor())
    .borderWidth(this.getPreviewProgressBorderWidth())
    .animation({
      duration: this.previewProgressOffset === 0 ? 0 : PhotoItem.PULL_DOWN_ITEM_ANIM_DURATION,
      curve: Curve.Linear,
      delay: 0,
      playMode: PlayMode.Normal,
    })
    .transition(TransitionEffect.OPACITY.animation({ duration: 100, curve: Curve.Sharp }))
  }

  /**
   * 视频在当前视窗时
   */
  @Builder
  VideoCurrentBuilder() {
    Stack() {
      Row() {
        ForEach(this.isFrameExpand ? this.videoCoverFrame :
        this.defaultCoverFrame, (project: string, index: number) => {
          this.VideoCurrentImgBuilder(index);
        }, (item: string, index: number): string => {
          return index + '';
        })
      }
      .width((this.isFrameExpand && this.item?.item?.frameNum) ?
        (this.item?.item?.frameNum * this.selectedSmallImgWidth) :
        (AvPlayConstants.COVER_FRAME_NUM * this.selectedSmallImgWidth))
      .height(ImageUtil.getSelectedSmallImgHeight())
      .backgroundColor(PREVIEW_ITEM_PLACEHOLDER_COLOR)
    }
    .accessibilityGroup(true)
    .borderRadius(DeviceInfo.isTv() ? $r('sys.float.corner_radius_level6') : undefined)
    .alignContent(this.anchorDirection === AnchorDirection.HEADER ? Alignment.TopStart : Alignment.TopEnd)
    .width(this.centerVideoPreviewWidth)
    .height(ImageUtil.getSelectedSmallImgHeight())
    .backgroundColor(PREVIEW_ITEM_PLACEHOLDER_COLOR)
    .clip(true)
    .transition(TransitionEffect.asymmetric(undefined, TransitionEffect.OPACITY.animation({
      duration: AvPlayConstants.thumbInOutDuration,
      curve: Curve.Sharp,
    }))
    )
  }

  @Builder
  VideoCurrentImgBuilder(index: number) {
    if (this.item?.thumbnail) {
      Image(this.videoCoverFrame[index])
        .alt(this.item?.thumbnail?.url)
        .draggable(false)
        .objectFit(ImageFit.Cover)
        .width(DeviceInfo.isTv() ? $r('app.float.tv_swiper_item_size') : ImageUtil.getSelectedSmallImgWidth())
        .height(DeviceInfo.isTv() ? $r('app.float.tv_swiper_item_size') : ImageUtil.getSelectedSmallImgHeight())
        .borderRadius(DeviceInfo.isTv() && !this.isVideo() ? $r('sys.float.corner_radius_level6') : undefined)
        .borderWidth(DeviceInfo.isTv() && (this.item?.pos === this.centerIndex) && !this.isVideo() ? 3 : undefined)
        .borderColor(DeviceInfo.isTv() && (this.item?.pos === this.centerIndex) && !this.isVideo() ?
        $r('app.color.default_background_color') : undefined)
        .onKeyEvent((event: KeyEvent): void => {
          Log.info(TAG, `smallImg handleKeyEvent type= ${event.type}, keyCode= ${event.keyCode}`);
          if (event.keyCode === MultimodalInputManager.KEY_CODE_SPACE ||
            event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER) {
            // 只有一个视频进来这里
            this.isClick = false;
            this.handleKeyEvent(event);
          }
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down && !this.isTouchVideoPreview && !this.isFrameExpand) {
            this.isTouchVideoPreview = true;
            this.onVideoFrameClickActionFunc(this.item?.item?.uri);
          }
          if (event.type === TouchType.Up) {
            this.isTouchVideoPreview = false;
          }
        })
        .onComplete((event?: completed) => {
          Log.info(TAG, `VideoCurrentImgBuilder image onComplete, componentWidth:${event?.componentWidth},
          contentHeight:${event?.componentHeight}, imagePosition: ${this.item?.pos}, uri: ${this.item?.thumbnail?.url},width: ${this.item?.width}
          loadingState:${event?.loadingStatus}, index:${index}`);
        })
        .onError((event: ImageError) => {
          Log.error(TAG,
            `VideoCurrentImgBuilder load error, imagePosition: ${this.item?.pos}, item: ${this.item?.thumbnail?.url}, ${JSON.stringify(this.item?.thumbnail)}, error: ${event?.message}`);
        })
    }
  }

  /**
   * 视频非当前视窗时
   */
  @Builder
  VideoNonCurrentBuilder() {
    Column() {
      MediaCachedImage(this.item?.thumbnail?.url)
        .draggable(false)
        .objectFit(ImageFit.Cover)
        .width(DeviceInfo.isTv() ? $r('app.float.tv_swiper_item_size') :
        Swipes.calcPxRoundToInteger(ImageUtil.getSmallImgWidth()))
        .borderRadius(DeviceInfo.isTv() ? $r('sys.float.corner_radius_level6') : undefined)
        .height(DeviceInfo.isTv() ? Constants.FULL_PERCENT : ImageUtil.getSmallImgHeight())
        .backgroundColor(PREVIEW_ITEM_PLACEHOLDER_COLOR)
        .backgroundBlurStyle(DeviceInfo.isTv() ? BlurStyle.BACKGROUND_ULTRA_THICK : undefined)
        .key(`previewItemImg${this.item.pos}`)
        .transition(!this.isBrowserShow ? TransitionEffect.OPACITY.animation({
          duration: AvPlayConstants.thumbInOutDuration,
          curve: Curve.Sharp,
        }) : undefined)
        .onKeyEvent((event: KeyEvent): void => {
          Log.info(TAG, `VideoNonCurrentBuilder handleKeyEvent type= ${event.type}, keyCode= ${event.keyCode}`);
          if (event.keyCode === MultimodalInputManager.KEY_CODE_SPACE ||
            event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER) {
            this.isClick = false;
            this.handleKeyEvent(event);
          }
        })
        .shadow(DeviceInfo.isTv() ? {
          radius: 60,
          color: '#26000000',
          offsetX: 0,
          offsetY: 20,
        } : undefined)
        .onComplete((event?: completed) => {
          Log.info(TAG, `VideoNonCurrentBuilder image onComplete, componentWidth:${event?.componentWidth},
          contentHeight:${event?.componentHeight}, imagePosition: ${this.item?.pos}, uri: ${this.item?.thumbnail?.url}
          loadingState:${event?.loadingStatus}`);
        })
        .onError((event: ImageError) => {
          Log.error(TAG,
            `VideoNonCurrentBuilder load error, imagePosition: ${this.item?.pos}, item: ${this.item?.thumbnail?.url}, ${JSON.stringify(this.item?.thumbnail)}, error: ${event?.message}`);
        })
    }
    .onKeyEvent((event: KeyEvent): void => {
      Log.info(TAG, `VideoNonCurrentBuilder onKeyEvent ${event.keyCode}`);
      if (event.keyCode === MultimodalInputManager.KEY_CODE_SPACE ||
        event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER) {
        this.isClick = false;
        this.shortcutController.listen(event);
      }
      this.isClick = false;
    })

    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      this.videoTimeOverlay();
    }
  }

  /* instrument ignore next */
  @Builder
  videoTimeBuilder() {
    Row() {
      Text(DateUtil.getFormattedDurationForScreenReader(this.item?.item?.duration ?? 0))
        .draggable(false)
        .fontSize(14)
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.font_primary'))
        .lineHeight(19)
        .fontWeight(400)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1);
    }
    .height(Constants.PERCENT_50)
    .alignItems(VerticalAlign.Bottom)
    .position({ y: '50%' })
    .padding({ bottom: 10, left: 8 })
  }

  /* instrument ignore next */
  @Builder
  videoTimeOverlay() {
    Stack()
      .position({
        y: LengthMetrics.resource($r('app.float.tv_swiper_item_size')).value - Constants.TV_GRID_ITEM_OVERLAY_HEIGHT,
      })
      .width($r('app.float.tv_swiper_item_size'))
      .height(Constants.TV_GRID_ITEM_OVERLAY_HEIGHT)
      .linearGradient({
        direction: GradientDirection.Top,
        colors: [[$r('app.color.color_secondary'), 0], [$r('app.color.transparent'), 1]],
      })
      .borderRadius({
        bottomStart: LengthMetrics.resource($r('sys.float.corner_radius_level6')),
        bottomEnd: LengthMetrics.resource($r('sys.float.corner_radius_level6')),
      })
      .enabled(false)
  }

  @Builder
  videoImgItemBuilder() {
    ListItem() {
      Stack({ alignContent: Alignment.Start }) {
        if (this.item?.pos === this.viewModel.currentIndex) {
          this.VideoCurrentBuilder();
        } else {
          this.VideoNonCurrentBuilder();
        }

        if (this.item?.pos === this.centerIndex && !this.isPreviewBarAnimation && !this.isScrolling) {
          if (!this.isFrameExpand) {
            this.PreviewProgressBuilder();
          }
        }
      }
      .onClick((event): void => {
        if (!this.isClick) {
          this.isClick = true;
          return;
        }
        if (this.item?.pos === this.centerIndex) {
          this.onVideoFrameClickActionFunc(this.item?.item?.uri);
        } else {
          this.onSmallImgClickAction(this.item?.item?.uri);
        }
      })
      .accessibilityText(this.getVideoText())
    }
    .key(`PreviewBarItemVideo ${this.item?.pos}`)
    .scale(DeviceInfo.isTv() ? undefined : {
      x: (!this.isScrolling && this.absIndexDiff !== 0) ? this.itemScale : 1,
      y: (this.isScrolling || this.absIndexDiff > DIFF_FACTOR) ? 1 : this.itemScale,
      centerX: Constants.PERCENT_50,
      centerY: Constants.PERCENT_100,
    })
    .margin({
      left: DeviceInfo.isTv() ? Constants.TV_SWIPER_PADDING_BOTTOM / 2 :
        ((this.isScrolling || this.absIndexDiff > DIFF_FACTOR) ? 0 : this.itemMargin),
      right: DeviceInfo.isTv() ? Constants.TV_SWIPER_PADDING_BOTTOM / 2 :
        ((this.isScrolling || this.absIndexDiff > DIFF_FACTOR) ? 0 : this.itemMargin)
    })
    .height(DeviceInfo.isTv() ? Constants.FULL_PERCENT : ((this.item?.pos === this.centerIndex) ?
    ImageUtil.getSelectedSmallImgHeight() : ImageUtil.getSmallImgHeight()))
    .opacity((this.item?.pos === this.centerIndex) ? this.centerPreviewOpacity : this.previewItemOpacity)
    .transition(TransitionEffect
      .scale((this.item?.pos === this.centerIndex && AppStorage.get('isDoingDeleteBigPhotoAnim')) ? {
        // 缩放比例
        x: Constants.SMALL_SCALE,
        y: Constants.SMALL_SCALE,
        centerX: Constants.PERCENT_50,
        centerY: Constants.PERCENT_100,
      } : {
        x: 1,
        y: 1,
        centerX: Constants.PERCENT_50,
        centerY: Constants.PERCENT_100,
      }).animation({
        duration: PhotoConstants.DELETE_DURATION,
        curve: Swipes.DELETE_PHOTO_CURVE,
        delay: Constants.SMALL_DELETE_ANIM_DELAY,
        playMode: PlayMode.Normal,
      })
      .combine((this.item?.pos === this.centerIndex && AppStorage.get('isDoingDeleteBigPhotoAnim')) ?
      TransitionEffect.OPACITY.animation({
        delay: Constants.SMALL_DELETE_ANIM_DELAY,
        duration: Constants.SMALL_SCALE_ANIM_DURATION,
      }) : (this.item?.pos === this.centerIndex && this.isDoingRecoverAnim) ?
          TransitionEffect.OPACITY.animation({ duration: Constants.SMALL_SCALE_ANIM_DURATION })
        : TransitionEffect.OPACITY.animation({ duration: PhotoItem.PULL_DOWN_ITEM_ANIM_DURATION })
      )
    )
  }

  aboutToAppear(): void {
    if (!this.item) {
      Log.error(TAG, 'item was undefined');
      return;
    }
    if (this.isVideo() && this.item?.pos === this.centerIndex) {
      this.setCenterVideoPreviewWidth();
    }
    if (this.item.item) {
      this.appBroadCast.on(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.item?.item.uniqueId, this.updateVideoWidthFunc);
    }
    if (this.item.itemWidth && this.item.pos === this.centerIndex) {
      this.itemMargin = HALF_FACTOR * this.item.itemWidth / (1 + this.item.itemWidth / ImageUtil.getSmallImgWidth() *
      Constants.WAVE_PREVIEW_SCALE_MAX);
      this.itemScale = Constants.WAVE_PREVIEW_SCALE_MAX;
    }
    this.viewModel.onCreate();
  }

  private setCenterVideoPreviewWidth() {
    if (!DeviceInfo.isTv() || !this.isFrameExpand) { // 非TV设备或视频未播放时（此刻预览条未展开）
      this.centerVideoPreviewWidth = AvPlayConstants.COVER_FRAME_NUM * this.selectedSmallImgWidth;
    } else if (this.item?.item && this.item.item?.frameNum) { // TV设备且视频已播放时（根据视频帧数调整宽度）
      this.centerVideoPreviewWidth = this.item.item?.frameNum * this.selectedSmallImgWidth;
    }
    Log.debug(TAG, `aboutToAppear, centerVideoPreviewWidth = ${this.centerVideoPreviewWidth}`);
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear PreviewItemUrl: ${this.item?.thumbnail?.url}`);
    if (this.item.item) {
      this.appBroadCast.off(BroadCastConstants.UPDATE_VIDEO_WIDTH +
      this.item?.item.uniqueId, this.updateVideoWidthFunc);
    }
    this.viewModel.onDestroy();
  }

  build() {
    if (this.isVideo()) {
      this.videoImgItemBuilder();
    } else {
      if (this.item?.thumbnail) {
        this.SmallImgItemBuilder();
      }
    }
  }

  private getPreviewProgressHeight(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet())
      ? Constants.PAD_PREVIEW_PROGRESS_HEIGHT :
      (DeviceInfo.isTv() ? Constants.TV_WAVE_PREVIEW_PROGRESS_HEIGHT : Constants.PREVIEW_PROGRESS_HEIGHT);
  }

  private getCenterVideoPreviewWidth(): number {
    return DeviceInfo.isTv() ? LengthMetrics.resource($r('app.float.tv_swiper_item_size')).value :
    ImageUtil.getSmallImgWidth();
  }

  private getPreviewProgressWidth(): Length {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_WIDTH : Constants.PREVIEW_PROGRESS_WIDTH;
  }

  private getPreviewProgressBorderWidth(): Length | EdgeWidths | LocalizedEdgeWidths {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_BORDER_WIDTH :
    Constants.PREVIEW_PROGRESS_BORDER_WIDTH;
  }

  private getPreviewProgressBorderColor(): ResourceColor | EdgeColors | LocalizedEdgeColors {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_BORDER_COLOR :
    Constants.PREVIEW_PROGRESS_BORDER_COLOR;
  }

  private getPreviewProgressBorderRadius(): Length | BorderRadiuses | LocalizedBorderRadiuses {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_BORDER_RADIUS :
    Constants.PREVIEW_PROGRESS_BORDER_RADIUS;
  }
}