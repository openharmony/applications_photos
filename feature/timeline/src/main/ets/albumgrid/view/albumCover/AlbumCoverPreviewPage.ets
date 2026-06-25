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
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { PhotoAccessHelperAccess, PhotoAsset } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { PickerSelectTip } from './PickerSelectTip';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { BindSheetController } from '../AlbumPhotoGridView';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';

const TAG = 'AlbumCoverPreviewPage';
const TOAST_DURATION = 300;

@Component
export struct AlbumCoverPreview {
  @State private imageWidth: number = 0;
  @State private imageHeight: number = 0;
  @State private imageOffsetX: number = 0;
  @State private imageOffsetY: number = 0;
  @Prop @Watch('itemHeightChange') private itemHeight: number;
  @StorageLink('isFullMode') @Watch('loadData') private isFullMode: boolean = getScreen().isFullMode();
  @StorageLink('isPrimaryMode') @Watch('loadData') private isPrimaryMode: boolean = getScreen().isPrimaryMode();
  @State private ratio: string = '1_1'
  @State private itemWidth: number = 0;
  @State private columnWidth: number = 0;
  @State private artwordOpacity: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @State private bindSheetHeight: number = 0;
  private newCoverItem: MediaItem = new MediaItem(); // 一个图片的封装类，把媒体库photoAsset的值封装成MediaItem
  private columnNumber: number = 4;
  private columnMargin: number = 16;
  private columnGutter: number = 16;

  aboutToAppear(): void {
    Log.info(TAG, ' aboutToAppear: ');
    this.loadData();
  }

  aboutToDisappear(): void {
    Log.info(TAG, ' aboutToDisappear.');
  }

  private getBindSheetHeight(): void {
    // xxx展开或者平板
    if (DeviceInfo.isFoldable() || DeviceInfo.isTablet()) {
      Log.info(TAG, 'this is a Fold or pad devices');
      // 560vp
      this.bindSheetHeight = Constants.ALBUM_COVER_BIND_SHEET_HEIGHT;
      return;
    }
    // 直板机横屏
    if (DeviceInfo.isPhoneUx() && isOrientationHorizontal()) {
      Log.info(TAG, 'This is a mobile phone and it is horizontal');
      this.bindSheetHeight = getScreen().getWinHeight() - 8;
    }
    // 直板机竖屏
    if (!isOrientationHorizontal() && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() &&
      !getScreen().isSplitMode()) {
      Log.info(TAG, 'This is a mobile phone and it is vertical');
      // 底部弹窗距离信号栏为8vp
      this.bindSheetHeight = getScreen().getWinHeight() - getScreen().getStatusBarHeight() - 8;
      return;
    }
    Log.info(TAG,
      `bindSheetWidthAndHeight bindSheetHeight = ${this.bindSheetHeight}`)
  }

  private async itemHeightChange(): Promise<void> {
    Log.info(TAG, `itemHeightChange start itemHeight ${this.itemHeight}, bindSheetHeight = ${this.bindSheetHeight}`)
    this.loadData();
  }

  private getColumnNum(): void {
    let winWidth = getScreen().getWinWidth();
    Log.info(TAG, `winWidth = ${winWidth}`)
    if (winWidth >= 0 && winWidth < 600) {
      this.columnNumber = 4;
      this.columnMargin = 16;
      this.columnGutter = 16;
    } else if (winWidth >= 600 && winWidth < 840) {
      this.columnNumber = 8;
      this.columnMargin = 24;
      this.columnGutter = 12;
    } else if (winWidth >= 840) {
      this.columnNumber = 12;
      this.columnMargin = 32;
      this.columnGutter = 16;
    }
  }

  /**
   * 加载数据
   */
  private loadData(): void {
    this.getBindSheetHeight();
    if (getScreen().isSplitMode()) {
      // 分栏
      Log.info(TAG, 'This is Split Mode');
      this.itemHeight = getScreen().getWinHeight() > getScreen().getWinWidth() ? getScreen().getWinHeight() / 2 :
        getScreen().getWinWidth() / 2;
    } else if (this.isHorizontal || DeviceInfo.isFoldable() || DeviceInfo.isTablet()) {
      // 横屏或者xxx展开或者pad
      this.getColumnNum();
      let columnWidth: number =
        (getScreen().getWinWidth() - this.columnMargin * 2 - this.columnGutter * 7) / this.columnNumber;
      let itemMaxWidth: number = Math.min(columnWidth * 4 + this.columnGutter * 3, 480);
      // 64: 顶部标题栏宽度以及标题栏外边距(54+8); 24: 图片区域外边距(24)
      let itemMaxHeight: number = this.bindSheetHeight - 64 - 24;
      Log.info(TAG, 'loadData columnNumber = ' + this.columnNumber + ', columnMargin = ' + this.columnMargin +
        ', columnPadding = ' + this.columnGutter);
      Log.info(TAG, 'ScreenWidth = ' + getScreen().getWinWidth() + ', columnWidth = ' + columnWidth +
        ', itemMaxWidth = ' + itemMaxWidth + ', itemMaxHeight = ' + itemMaxHeight + ', getItemMaxHeight = ' +
      this.getItemMaxHeight(this.ratio, itemMaxWidth));
      this.itemHeight = Math.min(this.getItemMaxHeight(this.ratio, itemMaxWidth), itemMaxHeight);
    }
    this.itemWidth = this.getItemWidth(this.ratio);
    Log.info(TAG,
      'ratio = ' + this.ratio + ', itemWidth = ' + this.itemWidth + ', itemHeight = ' + this.itemHeight +
        ', imageHeight = ' + this.imageWidth + ', imageHeight = ' + this.imageHeight + ', imageOffsetX = ' +
      this.imageOffsetX + ', imageOffsetY =  ' + this.imageOffsetY);
  }

  /**
   * 加载数据
   *
   * @param itemRatio 艺术化宫格每个item的比例
   */
  private getItemWidth(itemRatio: string): number {
    if (itemRatio === '1_1') {
      return this.itemHeight;
    } else if (itemRatio === '3_4') {
      return this.itemHeight * 3 / 4;
    } else if (itemRatio === '3_2') {
      return this.itemHeight * 3 / 2 + 16;
    }
    return this.itemHeight;
  }

  private getItemMaxHeight(itemRatio: string, itemMaxWidth: number): number {
    if (itemRatio === '1_1') {
      return itemMaxWidth;
    } else if (itemRatio === '3_4') {
      return itemMaxWidth * 4 / 3;
    } else if (itemRatio === '3_2') {
      return (itemMaxWidth - 16) * 2 / 3;
    }
    return itemMaxWidth;
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        // 背景图
        this.backgroundBuild();
      }
      .width('100%')
      .height('100%')
    }
    .width(this.itemWidth)
    .height(this.itemHeight)
  }

  @Builder
  backgroundBuild() {
    Column() {
      Image(ImageUtil.getHighlightCoverLcdUri(this.newCoverItem, { width: -1, height: -1, }))
        .objectFit(ImageFit.Cover)
        .draggable(false)
        .onComplete((event): void => {
          this.artwordOpacity = 1;
        })
        .onError((event): void => {
          Log.info(TAG, `backgroundBuild onError coverLcdUri:  item: `);
        })
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius($r('sys.float.corner_radius_level8'))
    .clip(true)
    .width(this.itemWidth)
    .height(this.itemHeight)
    .borderWidth($r('app.float.checkbox_unselected_border_width'))
    .borderColor($r('app.color.highlight_border_color'))
  }
}

// 封面编辑 封面预览页面
@Component
export struct AlbumCoverPreviewPage {
  @State @Watch('onAlbumInfoChanged') private albumInfo: AlbumInfo = new AlbumInfo();
  private navPathStackBindSheet: NavPathStack = new NavPathStack()
  // bindSheet 控制器
  @ObjectLink private bindSheetController : BindSheetController;
  public scroller: Scroller = new Scroller();
  private isFromAlbumPage: boolean = false;
  // private item: MediaItem = new MediaItem(undefined, undefined, undefined);
  private itemHeight: number = 0;
  private itemWidth: number = 0;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private selectCoverItem: MediaItem = new MediaItem();
  private isPreviewFromEdit: boolean = false; // 是否是封面编辑页面进入封面预览页面. 如果是则不显示完成按钮, 如果不是则显示完成按钮
  @State private isAlbumCover: boolean = false; // 当前item预览是封面

  private onAlbumInfoChanged() {
    Log.info(TAG, 'onAlbumInfoChanged')
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear ');
    Log.info(TAG,
      'The selectItem :' + this.selectCoverItem?.uri +
        ' albumInfo coverUri :' + this.albumInfo?.coverUri + ` coverPhotoUri :` + this.albumInfo?.coverPhotoUri);
    this.isAlbumCover = this.selectCoverItem?.uri === this.albumInfo?.coverPhotoUri;
  }

  aboutToDisappear(): void {
    Log.info(TAG, ' aboutToDisappear.');
  }

  build() {
    NavDestination() {
      Column() {
        this.buildCoverPreviewSheetTopBar()
        this.buildCoverPreviewSheetArea();
        PickerSelectTip()
          .margin({
            bottom: (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() ?
            $r('app.float.navigation_margin_bottom') : $r('app.float.navigation_margin_bottom_pc'))
          });
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    }
    .hideTitleBar(true)
    .onBackPressed((): boolean => {
      Log.info(TAG, 'highlight cover preview sheet swipe left or right to return.');
      this.navPathStackBindSheet.pop();
      return true;
    })
  }

  @Builder
  buildCoverPreviewSheetTopBar() {
    Row() {
      // 封面预览返回按钮
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .fontSize($r('app.float.icon_size'))
          .fontColor([$r('sys.color.ohos_fa_icon_primary')])
          .draggable(false)
          .flexShrink(0)
      }
      .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
      .onClick(() => {
        this.navPathStackBindSheet.pop();
      })
      .width($r('app.float.picker_action_bar_button_height'))
      .height($r('app.float.picker_action_bar_button_height'))
      .accessibilityText($r('app.string.action_back'))

      Text($r('app.string.cover_preview_title'))
        .layoutWeight(1)
        .fontSize('20vp')
        .fontWeight(FontWeight.Bold)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_primary'))
        .margin({ start: LengthMetrics.resource($r('sys.float.padding_level4')) })

      Column() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.checkmark'))
            .fontSize($r('app.float.icon_size'))
            .fontColor([this.isAlbumCover ? $r('sys.color.ohos_id_select_option_focused_disable_text_color') :
              $r('sys.color.ohos_fa_icon_primary')])
            .draggable(false)
            .flexShrink(0)
        }
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .onClick(async () => {
          Log.info(TAG, 'Preview Cover Sheet Top Bar finish button onclick');
          PhotoAccessHelperAccess.getInstance()
            .setCustomAlbumCover(getContext(), this.albumInfo, this.selectCoverItem?.uri)
            .then((result) => {
              Log.info(TAG, `setCustomAlbumCover result ` + result);
              if (result) {
                this.albumInfo.coverPhotoUri = this.selectCoverItem?.uri ?? '';
                this.albumInfo.coverUri =
                  ImageUtil.getThumbnailAstcUri(this.selectCoverItem?.uri, this.selectCoverItem?.path,
                    this.selectCoverItem?.getDateModified());
                this.albumInfo.coverUriSource = Constants.CUSTOM_ALBUM_COVER;
                UiUtil.showToast($r('app.string.set_album_cover_ready'), TOAST_DURATION);
              } else {
                UiUtil.showToast($r('app.string.occure_error_and_retry'), TOAST_DURATION);
              }
              this.bindSheetController.isShow = false;
              this.appBroadCast.emit(BroadCastConstants.CLOSE_ALBUM_COVER_CHANGE_SHEET,
                ['']);
            })
          const msg: Record<string, number | string | boolean> = {
            'set_album_cover': 0
          };
          ReportToBigDataUtil.report(BigDataConstants.SET_ALBUM_COVER, msg);
        })
        .width($r('app.float.picker_action_bar_button_width'))
        .height($r('app.float.picker_action_bar_button_height'))
        .enabled(!this.isAlbumCover)
        .accessibilityText($r('app.string.action_ok'))
        .accessibilityLevel(this.isAlbumCover ? 'no-hide-descendants' : 'yes')
      }.onClick(() => {
        if (this.isAlbumCover) {
          UiUtil.showToast($r('app.string.is_already_album_cover'), TOAST_DURATION);
          return;
        }
      })
      .accessibilityText($r('app.string.action_ok'))
      .accessibilityLevel(this.isAlbumCover ? 'yes' : 'no')
      .accessibilityRole(AccessibilityRoleType.BUTTON)
    }
    .width('100%')
    .height('56vp')
    .margin({ top: '8vp', bottom: '8vp' })
    .padding({ left: '16vp', right: '16vp' })
  }

  @Builder
  buildCoverPreviewSheetArea() {
    Column() {
      AlbumCoverPreview({
        itemHeight: this.itemHeight,
        newCoverItem:  this.selectCoverItem,
      });
    }
    .layoutWeight(1)
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}