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

import lazy { Log } from '../utils/Log';
import lazy { Constants } from '../model/common/Constants';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';
import lazy { CommonUtil } from '../utils/CommonUtil';
import lazy { SelectParams } from '../model/common/SelectParams';
import lazy { SimpleGridMediaItem } from '../model/browser/photo/SimpleGridMediaItem';
import lazy { ViewData } from '../model/browser/photo/ViewData';
import lazy { GridUIController } from '../utils/GridUIController';
import lazy { GridSize, ImageGridSizeUtil } from '../utils/ImageGridSizeUtil';
import lazy { StringUtil } from '../utils/StringUtil';
import lazy { ReplaceUriManager } from '../model/ReplaceUriManager';
import lazy { GridItemUtils } from '../utils/GridItemUtils';
import lazy { AttributeUpdater, ImageModifier as DragImageModifier, SymbolGlyphModifier } from '@ohos.arkui.modifier';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { DateUtil } from '../utils/DateUtil';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_ImageGridItemComponentMinimal';
const GRID_REUSE_TIMEOUT: number = 2;

class GridItemModifier extends AttributeUpdater<GridItemAttribute> {
  applyNormalAttribute(instance: GridItemAttribute) {
    instance.transition(TransitionEffect.IDENTITY);
  }
}

class ImageModifier extends AttributeUpdater<MediaCachedImageAttribute, MediaCachedImageInterface> {
  applyNormalAttribute(instance: MediaCachedImageAttribute) {
  }
}

class TextModifier extends AttributeUpdater<TextAttribute, TextInterface> {
  applyNormalAttribute(instance: TextAttribute) {
  }
}

// General grid picture control
@Reusable
@Component
export struct MinimalImageGridItemComponent {
  private replaceUriManager: ReplaceUriManager | undefined;
  @ObjectLink @Watch('onViewDataChanged') item: ViewData;
  @State gridUiController: GridUIController = new GridUIController();
  private mediaItem: MediaItem | undefined;
  simpleMediaItem?: SimpleGridMediaItem;
  pageName = '';
  private geometryTransitionString: string = '';
  private imageThumbnail: string = '';
  @State isEditImage: boolean = false;
  @State editImageUri: string = '';
  @State thumbnailWidth: string | undefined = Constants.PERCENT_100;
  @State thumbnailHeight: string | undefined = Constants.PERCENT_100;
  private ratio: number = 0;
  thumbnailSize: Size | null = null;
  @Link @Watch('resizeGridThumbnail') gridItemWidth: number;
  private mPosition: number = 0;
  @State isEffective: boolean = true;
  private imageModifier: ImageModifier = new ImageModifier();
  private useGridTrace: boolean = GridItemUtils.useGridTrace();
  private useGridReport: boolean = GridItemUtils.useGridReport();
  private traceStartTime: number = 0;
  @State isVideoMediaType: boolean = false;
  private mediaType: number = UserFileManagerAccess.MEDIA_TYPE_IMAGE;
  private otherTimeDaysIconBottomPadding: number = 0;
  @State videoDuration: number | undefined = 0;
  private textModifier: TextModifier = new TextModifier();
  @State private recycleDays: number = 0;
  private isRecycle: boolean = false;
  private recycleTextModifier: TextModifier = new TextModifier();

  /**
   * 更新UI相关的属性，用controller驱动界面刷新
   * 适用场景：宫格静止，A端对图片做收藏、编辑等改变图片属性的操作，B端同步刷新宫格。
   * 备注：连续滑动、滚动场景走整个节点回收、复用逻辑，此处逻辑不适用。
   */
  private onViewDataChanged(): void {
    if (this.isEditImage) {
      this.isEditImage = this.replaceUriManager?.hasReplaceMediaItem(this.item.mediaItem) ?? false;
    }
    TraceControllerUtils.startTrace('GridItemOnViewDataChanged');
    const tempItem: MediaItem | undefined = this.item?.mediaItem;
    if (!tempItem) {
      Log.error(TAG, `this.mediaItem is ${Boolean(this.item?.mediaItem)} ${
      this.mediaItem?.equals?.name} cannot get mediaItem, return`);
      TraceControllerUtils.finishTrace('GridItemOnViewDataChanged');
      return;
    }
    if (!tempItem.equals?.(this.mediaItem)) {
      this.mediaItem = tempItem;
    }
    // 收藏后更新
    if (this.gridUiController.isFavor !== tempItem.isFavor) {
      this.gridUiController.isFavor = tempItem.isFavor;
    }
    TraceControllerUtils.finishTrace('GridItemOnViewDataChanged')
  }

  aboutToAppear(): void {
    Log.info(TAG, `ImageGridItem aboutToAppear, index=${this.mPosition}`);
    this.initData(true);
  }

  aboutToReuse(params: ESObject): void {
    if (this.useGridTrace) {
      this.traceStartTime = Date.now();
      TraceControllerUtils.startTrace(TAG + '--aboutToReuse');
    }
    if (!CommonUtil.isValidObject(params)) {
      Log.error(TAG, 'reuse failed');
    }
    this.simpleMediaItem = params.simpleMediaItem;
    this.initData(true);
    Log.debug(TAG, `ImageGridItem aboutToReuse geometryTransitionString:` + this.geometryTransitionString
      + ' this.imageThumbnail: ' + this.imageThumbnail);
    if (this.useGridTrace) {
      this.reuseTraceFunc();
    }
  }

  aboutToRecycle() {
  }

  // 公共数据初始化
  initData(isReuse: boolean): void {
    this.mediaItem = this.item?.mediaItem;
    this.imageThumbnail = this.mediaItem?.thumbnail ?? '';
    this.updateRecycleAttributes();

    let userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (userId > 0) {
      Log.info(TAG, 'initData imageThumbnail:' + this.imageThumbnail);
      this.imageThumbnail += `&user=${userId}`;
    }
    this.isEffective = Boolean(this.imageThumbnail);
    if (!this.isEffective) {
      return;
    }
    if (isReuse) {
      // 需要确保attribute非空
      this.imageModifier?.updateConstructorParams(this.imageThumbnail);
    }
    this.gridUiController.init(this.mediaItem, this.simpleMediaItem);
    this.mediaType =
      this.mediaItem?.mediaType ?? this.simpleMediaItem?.mediaType ?? UserFileManagerAccess.MEDIA_TYPE_IMAGE;
    this.isVideoMediaType = this.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    this.videoDuration = this.mediaItem?.duration ?? this.simpleMediaItem?.getDuration() ?? 0;
    if (this.isVideoMediaType && this.textModifier.attribute && this.videoDuration !== undefined) {
      if (DateUtil.getFormattedDuration(this.videoDuration) === '00:00') {
        this.textModifier.updateConstructorParams('');
      } else {
        this.textModifier.updateConstructorParams(DateUtil.getFormattedDuration(this.videoDuration));
      }
    }
  }
  @Builder
  private buildTimeDaysIcon() {
    Row() {
      Blank()
      if (this.isRecycle) {
        Text($r('app.plural.recycle_days', this.recycleDays, this.recycleDays))
          .draggable(false)
          .fontSize($r('sys.float.Caption_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .maxFontScale(1.0)
          .fontColor((this.recycleDays <= Constants.RECYCLE_DAYS_WARN ?
              $r('sys.color.warning') : $r('app.color.text_color_above_picture')))
          .margin({
            top: $r('app.float.grid_item_text_margin_top'),
            right: $r('app.float.grid_item_text_margin_right'),
            bottom: $r('app.float.grid_item_text_margin_bottom'),
            left: $r('app.float.grid_item_text_margin_lr'),
          })
          .attributeModifier(this.recycleTextModifier)
      }
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_50)
    .aspectRatio(Constants.INVALID)
    .alignItems(VerticalAlign.Bottom)
    .linearGradient({
      angle: 0,
      colors: [[$r('app.color.album_cover_gradient_start_color'), 0], [$r('app.color.transparent'), 1.0]]
    })
    .position({ x: '0%', y: '50%' })
    .padding({ bottom: DeviceInfo.isTv() ? undefined : this.otherTimeDaysIconBottomPadding })
  }

  private updateRecycleAttributes(): void {
    if (!this.isRecycle) {
      return;
    }
    this.calculateRecycleDays();
    if (!this.recycleTextModifier.attribute) {
      return;
    }
    let daysResource: Resource = $r('app.plural.recycle_days', this.recycleDays, this.recycleDays);
    this.recycleTextModifier.updateConstructorParams(daysResource);
    let colorResource: Resource = this.recycleDays <= Constants.RECYCLE_DAYS_WARN ? $r('sys.color.warning') : $r('app.color.text_color_above_picture');
    this.recycleTextModifier.attribute?.fontColor(colorResource);
  }
  // 获取最近删除中，待回收照片倒计天数
  private calculateRecycleDays(): void {
    let currentTimeSeconds: number = new Date().getTime();
    let dateFromItem: number = this.mediaItem?.dateTrashed ?? 0;
    let dateFromSimpleItem: number = this.simpleMediaItem?.getDateTrashed() ?? 0;
    let itemDateTrashed: number =
      this.mediaItem?.dateTrashed && Number.isFinite(dateFromItem) ? dateFromItem : dateFromSimpleItem;
    let trashedDay: number = DateUtil.convertSecondsToDays(currentTimeSeconds - itemDateTrashed);
    let msg: string[] = [`leftDays ${trashedDay}`, `cur: ${currentTimeSeconds}`]
    msg.push(`media: ${this.mediaItem?.dateTrashed}`, `simple: ${this.simpleMediaItem?.getDateTrashed()}`);
    Log.info(TAG, msg.join(', '));
    if (trashedDay > Constants.RECYCLE_DAYS_MAX) {
      Log.info(TAG, `should delete right now currentSec=${currentTimeSeconds}, trashedSec=${
      itemDateTrashed}, trashedDay=${trashedDay}`);
      this.recycleDays = 0;
    } else if (trashedDay <= 0) {
      this.recycleDays = Constants.RECYCLE_DAYS_MAX - 1;
    } else {
      this.recycleDays = Number.parseInt((Constants.RECYCLE_DAYS_MAX - trashedDay) + '');
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, `ImageGridItem aboutToDisappear, index=${this.mPosition}`);
  }

  private reuseTraceFunc(): void {
    TraceControllerUtils.finishTrace(TAG + '--aboutToReuse');
    let traceCostTime = Date.now() - this.traceStartTime;
    if (traceCostTime > GRID_REUSE_TIMEOUT || this.useGridReport) {
      Log.info(TAG, `aboutToReuse useGridTrace: ${this.useGridTrace}, useGridReport: ${this.useGridReport}`);
      const msg: Record<string, number | string | boolean> = {
        'reuseTimeout': traceCostTime,
      }
      ReportToBigDataUtil.errEventReport(BigDataConstants.GRID_REUSE_TIMEOUT, msg);
      Log.info(TAG, `grid reuse timeout: ${traceCostTime}`);
    }
  }

  build() {
    GridItem() {
      this.buildImageGrid();
    }
    .stickGridItemAttrs()
  }

  /**
   * 宫格内等比例缩略图宽高计算
   */
  resizeGridThumbnail() {
    let gridSize: GridSize = {
      thumbnailWidth: this.thumbnailWidth,
      thumbnailHeight: this.thumbnailHeight,
      ratio: this.ratio,
    };
    gridSize = ImageGridSizeUtil.resizeGridThumbnail(this.thumbnailSize, this.gridItemWidth, gridSize);
    this.thumbnailWidth = gridSize.thumbnailWidth;
    this.thumbnailHeight = gridSize.thumbnailHeight;
  }

  private getActualImage(): string {
    if (this.isEditImage && this.editImageUri !== '') {
      return this.editImageUri;
    }
    if (StringUtil.isEmpty(this.imageThumbnail) && !this.mediaItem?.uri) {
      Log.warn(TAG, 'imageThumbnail is empty');
    }
    return this.imageThumbnail;
  }

  @Builder
  buildCachedImage() {
    MediaCachedImage(this.getActualImage())
      .sourceSize({
        width: px2vp(Constants.GRID_IMAGE_SIZE),
        height: px2vp(Constants.GRID_IMAGE_SIZE),
      })
      .objectFit(ImageFit.Cover)
      .attributeModifier(this.imageModifier)
  }

  @Styles
  stickGridItemAttrs() {
    .aspectRatio(1) // 当缩略图下显示文字时，aspectRatio需要不指定才能适配高度
  }

  @Builder
  buildImageGrid() {
    if (this.isEffective) {
      Column() {
        Stack({ alignContent: Alignment.Center }) {
          this.buildNormal();
        }
        .height('100%')
        .width('100%')
      }
    }
  }

  @Builder
  buildNormal() {
    // 缩略图
    /* instrument ignore next */
    this.buildImageByCondition();
  }

  /**
   * 加载各种情况的宫格缩略图
   */
  @Builder
  buildImageByCondition() {
    this.buildCachedImage();
    this.iconBuilder(false);
  }

  @Builder
  iconBuilder(isErrorImage: boolean) {
    this.buildIcon(isErrorImage);
  }

  // 收藏图标 && video左下角时间
  @Builder
  buildIcon(isErrorImage: boolean) {
    /* instrument ignore next */
    if (this.isVideoMediaType) {
      /* instrument ignore next */
      this.buildOtherTimeDaysIcon();
    }
    if ((this.gridUiController.isFavor)) {
      this.buildFavorIcon();
    }
    if (this.isRecycle) {
      this.buildTimeDaysIcon();
    }
  }

  //收藏图标
  @Builder
  buildFavorIcon() {
    Row() {
      /* instrument ignore next */
      SymbolGlyph($r('sys.symbol.heart_fill'))
        .fontSize($r('app.float.image_grid_item_view_icon_size'))
        .fontColor([$r('app.color.icon_default_color_contrary')])
        .position({ x: '100%', y: '0%' })
        .markAnchor({
          x: ($r('app.float.image_grid_item_view_icon_markAnchor_x')),
          y: ($r('app.float.image_grid_item_view_icon_markAnchor_y')),
        })
    }
  }

  //video 时间
  @Builder
  buildOtherTimeDaysIcon() {
    Row() {
      this.buildVideoDuration();
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_50)
    .aspectRatio(Constants.INVALID)
    .alignItems(VerticalAlign.Bottom)
    .linearGradient({
      angle: 0,
      colors: [[$r('app.color.album_cover_gradient_start_color'), 0], [$r('app.color.transparent'), 1.0]]
    })
    .position({ x: '0%', y: '50%' })
    .padding({ bottom: this.otherTimeDaysIconBottomPadding })
  }

  @Builder
  private buildVideoDuration() {
    // 缩略图左下角视频时长
    if (!this.isEditImage && this.isVideoMediaType && this.videoDuration && this.videoDuration > 0) {
      Text(DateUtil.getFormattedDuration(this.videoDuration))
        .fontSize($r('app.float.multiple_pick_normal_font_size'))
        .maxFontScale(2.0)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('app.color.text_color_above_picture'))
        .lineHeight($r('app.float.image_icon_text_line_height'))
        .margin({
          top: $r('app.float.grid_item_text_margin_top'),
          right: $r('app.float.grid_item_text_margin_right'),
          bottom: $r('app.float.grid_item_text_margin_bottom'),
          left: $r('app.float.grid_item_text_margin_lr'),
        })
        .attributeModifier(this.textModifier)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines((1))
    }
  }
}