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

import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '../../utils/Log';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { FontUtil } from '../../utils/FontUtil';
import lazy { DateUtil } from '../../utils/DateUtil';
import lazy { ImageUtil } from '../../utils/ImageUtil';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { Constants } from '../../model/common/Constants';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { MediaDataSource } from '../../model/browser/photo/MediaDataSource';
import lazy { PickerInstanceUtil } from '../../utils/PickerInstanceUtil';
import lazy { AttributeUpdater, ImageModifier, TextModifier } from '@ohos.arkui.modifier';

/* instrument ignore file */
const TAG: string = 'common_AlbumListCard';

const COMPONENT_EMPTY_EFFECT_OPACITY = 0.99;
const GRID_MIN_SCALE = 0.001;

// 视频删除列表项组件
@Component
export struct CleanupItemListCard {
  @State isEmptyAlbum: boolean = false;
  @State useAlt: boolean = false;
  private mediaItem: MediaItem | undefined;
  readonly imageCenterLength: number = 28;
  @State private listPaddingTopAndBottom: Resource | string = $r('sys.float.padding_level6');
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') private currentFontSizeScale: number = 1;
  @State private isSelected: boolean = false;
  private keyIndex: number = -1;
  @Consume broadCast: BroadCast;
  @Link @Watch('updateSelectStatus') isBackPressed: boolean;
  @Link @Watch('updateSelectStatus') isAllSelected: boolean;
  @Watch('updateSelectStatus') @Prop refreshState: boolean | undefined;
  private mSelectManager: SelectManager = new SelectManager();
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  @State isRTL: boolean = false;
  @State private dataSource: MediaDataSource | null = null;
  @State geometryTransitionBrowserId: string = '';
  @State isTap: boolean = false;
  pageName = 'VideoCleanupPage';
  private geometryTransitionString: string = '';
  private isTapStatusChange: boolean = false;
  private mPosition: number = 0;
  private onGeometryIdChangeFun: Function = (geometryTransitionBrowserId: string):
    void => this.onGeometryIdChange(geometryTransitionBrowserId);
  private imageModifierCustom: ImageModifierCustom = new ImageModifierCustom();
  private groupCountBefore: number = 0;

  onGeometryIdChange(geometryTransitionBrowserId: string): void {
    let oldTapStatus = this.isTap;
    if (!geometryTransitionBrowserId) {
      this.isTap = false;
      this.geometryTransitionBrowserId = '';
    } else {
      this.isTap = true;
      let uriStartIndex = geometryTransitionBrowserId.indexOf('/');
      let uriEndIndex = geometryTransitionBrowserId.length;
      let uri = geometryTransitionBrowserId.substring(uriStartIndex, uriEndIndex);
      this.geometryTransitionString = PickerInstanceUtil.getPickerId() + this.pageName + uri;
      this.updateGeometryTransition(this.geometryTransitionString);
      this.geometryTransitionBrowserId = this.geometryTransitionString;
    }
    this.isTapStatusChange = oldTapStatus !== this.isTap;
    Log.info(TAG, `[GeometryLogger] onGeometryIdChange isTap = ${this.isTap},` +
      ` isTapStatusChange = ${this.isTapStatusChange}, uniqueId=${this.mediaItem?.uniqueId},` +
      ` position=${this.mPosition}, geometryTransitionString=${this.geometryTransitionString},` +
      ` geometryTransitionBrowserId=${geometryTransitionBrowserId}`);
  }

  private updateGeometryTransition(geometryTransitionString: string): void {
    // this.imageModifierCustom?.attribute?.geometryTransition(geometryTransitionString);
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear: this.isSelected = ${this.isSelected}, isRTL=${this.isRTL}`);
    this.onLanguageChange();
    if (this.mediaItem != null) {
      this.broadCast.on(this.mediaItem?.uniqueId + Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT,
        this.onGeometryIdChangeFun);
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.broadCast.off(this.mediaItem?.uniqueId + Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT,
      this.onGeometryIdChangeFun);
  }

  private updateSelectStatus(): void {
    this.isSelected = this.mSelectManager.isItemSelected(this.mediaItem?.uri);
  }

  private getVideoTime(): string {
    return this.mediaItem?.duration ? DateUtil.getFormattedDuration(this.mediaItem.duration) : '';
  }

  private getVideoSize(): string {
    return this.mediaItem?.size ? ImageUtil.formatFileSize(this.mediaItem.size) : '';
  }

  private getSecondText(): string {
    return `${this.getVideoTime()} ${this.getVideoSize()}`.trim();
  }

  selectStateChange(): void {
    Log.info(TAG, 'change selected.');
    let newSelectState = !this.isSelected;
    if (this.mediaItem != undefined && this.mediaItem?.uri) {
      this.broadCast.emit(BroadCastConstants.SELECT, [this.keyIndex, this.mediaItem?.uri, newSelectState]);
      this.isSelected = newSelectState;
      Log.info(TAG,
        `selectStateChange: keyIndex=${this.keyIndex}, itemUri=${this.mediaItem?.uri}, newSelcetState=${newSelectState}`);
    }
  }

  /**
   * 语言切换
   */
  private onLanguageChange(): void {
    if (this.currentLanguage) {
      this.isRTL = i18n.isRTL(this.currentLanguage);
      Log.info(TAG, `LanguageChange : ${this.currentLanguage} , change isRTL : ${this.isRTL}`);
    }
  }
  @Builder
  checkboxBuilder(){
    Stack() {
      Checkbox()
        .key(`CleanupItemCheckBox${this.keyIndex}`)
        .accessibilityLevel('no')
        .margin(0)
        .select(this.isSelected)
        .hitTestBehavior(HitTestMode.None)
        .selectedColor($r('sys.color.comp_background_emphasize'))
        .opacity(1)
        .border({ radius: $r('app.float.checkbox_border_radius') })
        .borderColor($r('sys.color.font_primary'))
    }
    .alignRules({
      right: { anchor: '__container__', align: HorizontalAlign.End },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    })
    .offset({x: 6,y: 0})
    .id('row3')
    .accessibilityRole(AccessibilityRoleType.STACK)
    .onClick((): void => {
      Log.info(TAG, `onClick Checkbox, cleanup iteam is selected! index = ${this.keyIndex}`);
      this.selectStateChange();
    });
  }


  build() {
    Row() {
      // HdsListItemCard({
      //   prefixItem: this.isEmptyAlbum ? undefined : new PrefixImage({
      //     image: this.mediaItem?.thumbnail,
      //     onClick: () => {
      //       this.jumperToPhotoBrowser();
      //     },
      //     modifier: new ImageModifier()
      //       .attributeModifier(this.imageModifierCustom)
      //       .geometryTransition(this.geometryTransitionString, { follow: true })
      //       .transition(TransitionEffect.asymmetric(
      //         AppStorage.get<string>('geometryTransitionBrowserId') as string !== '' ?
      //           TransitionEffect.scale({ x: GRID_MIN_SCALE, y: GRID_MIN_SCALE }) : TransitionEffect.IDENTITY,
      //         TransitionEffect.opacity(COMPONENT_EMPTY_EFFECT_OPACITY))
      //       )
      //   }),
      //   textItem: {
      //     primaryText: {
      //       text: this.mediaItem?.displayName,
      //       modifier: new TextModifier()
      //         .draggable(false)
      //         .fontSize($r('sys.float.Body_L'))
      //         .maxFontScale(Constants.GALLERY_CLEANUP_PAGE_MAX_FONT_SCALE)
      //         .fontColor($r('sys.color.ohos_id_color_primary'))
      //         .maxLines(1)
      //         .textOverflow({ overflow: TextOverflow.Ellipsis })
      //         .margin({
      //           bottom: $r('app.float.tab_bar_line_height'),
      //         })
      //     },
      //     secondaryText: {
      //       text: this.getSecondText(),
      //       modifier: new TextModifier()
      //         .draggable(false)
      //         .fontColor($r('sys.color.font_secondary'))
      //         .fontFamily('HarmonyHeiTi')
      //         .fontSize(Constants.TEXT_SIZE_BODY2)
      //         .maxFontScale(Constants.GALLERY_CLEANUP_PAGE_MAX_FONT_SCALE)
      //         .maxLines(1)
      //         .textOverflow({ overflow: TextOverflow.Ellipsis })
      //     },
      //   },
      //   suffixItem: new SuffixCustomBuilder(this.checkboxBuilder.bind(this)),
      //   onClick: () => {
      //     this.selectStateChange();
      //     // Log.info(TAG, `Cleanup iteam is selected! index = ${this.keyIndex}, positon=${this.mediaItem?.getPosition()}`);
      //   },
      //   cardPrefixMargin: 0,
      //   cardSuffixMargin: 0,
      // })
    }
  }

  /**
   * 发送事件跳转预览页
   */
  private jumperToPhotoBrowser(): void {
    this.updateIndex();
    this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
      ['VideoCleanupPage', this.mediaItem, this.mPosition - this.groupCountBefore, this.geometryTransitionString]);
  }

  updateIndex(): void {
    this.groupCountBefore = !this.dataSource ? 0 : this.dataSource.getGroupCountBeforeItem(this.mediaItem);
    this.mPosition = (this.dataSource?.getDataIndex(this.mediaItem) ?? this.mPosition) + this.groupCountBefore;
  }

  /**
   * 根据字体放大倍数，调整列表上下间距高度
   */
  private currentFontSizeScaleChange(): void {
    this.listPaddingTopAndBottom = FontUtil.getPaddingByFontScale(this.currentFontSizeScale);
    Log.info(TAG, `currentFontSizeScaleChange listPaddingTopAndBottom: ${this.listPaddingTopAndBottom}`);
  }
}

class ImageModifierCustom extends AttributeUpdater<MediaCachedImageAttribute, MediaCachedImageInterface> {
  applyNormalAttribute(instance: MediaCachedImageAttribute) {
  }
}
