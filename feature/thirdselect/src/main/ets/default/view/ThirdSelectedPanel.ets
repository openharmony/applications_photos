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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy {
  MediaObserverNfyType,
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { SingleSelectionMode } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy {
  IS_HORIZONTAL,
  THIRD_SELECT_IS_ORIGIN,
  ThirdSelectConstants,
  THUMBNAIL_WIDTH
} from '../utils/ThirdSelectConstants';
import lazy { ThirdSelectedPanelThumbnailItem } from './ThirdSelectedPanelThumbnailItem';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
/* instrument ignore file */
const TAG: string = 'thiSel_ThirdSelectedPanel';
const FOOTER_SAFETY_HEIGHT: number = 16;
const PHONE_HORIZONTAL_SHEET_WIDTH: number = 480;
const THIRD_MAX_TEXT_FONT_SCALE: number = 1.45;

interface Size {
  height: number;
  width: number;
};

interface Params {
  showCancel: boolean,
  name: string,
  item: MediaItem,
};
@Extend(Text)
function countText() {
  .draggable(false)
  .maxFontScale(THIRD_MAX_TEXT_FONT_SCALE)
  .fontFamily($r('app.string.id_text_font_family_regular'))
  .fontWeight(FontWeight.Regular)
  .key('currentSelectCount')
  .padding({
    left: DeviceInfo.isPc() ? $r('app.float.pc_picker_text_padding') : 0,
  })
}
@Component
export struct ThirdSelectedPanel {
  onMenuClicked: Function = (): void => {
  };
  public maxSelectCount: number = 0;
  @Provide selectedCount: number = 0;
  @Link @Watch('onSelectedCountChanged') totalSelectedCount: number;
  @Link private totalCount: number;
  public selectManager: ThirdSelectManager | undefined = undefined;
  @State itemArray: MediaItem[] = [];
  @LocalStorageLink(THIRD_SELECT_IS_ORIGIN) isOriginalChecked: boolean = false;
  @StorageLink(IS_HORIZONTAL) @Watch('watchIsHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @Consume broadCast: BroadCast;
  @Link isShowBar: boolean;
  @Prop currentUri: string = '';
  @Prop private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  public isBrowserMode: boolean = false;
  public isMultiPick: boolean = true;
  public singleSelectionMode: SingleSelectionMode = SingleSelectionMode.BROWSER_MODE;
  public mTransition: string = '';
  public isFromFa: boolean = false;
  public dataSource: MediaDataSource | undefined = undefined;
  private selectedScroller: Scroller = new Scroller();
  private dataObserver: CommonObserverCallback | undefined = new CommonObserverCallback(this);
  @LocalStorageLink('showCancel') showCancel: boolean = true;
  @State refreshData: boolean = false;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  private currentStart: number = 0;
  private currentEnd: number = 0;
  private needInit: boolean = false;
  private displayLength: number = 4;
  private panelId: string = '';
  private funcRefreshSelectData: Function = (refresh: boolean): void => this.refreshSelectData(refresh);
  private funcUpdatePanelIndex: Function = (newUri: string): void => this.updatePanelIndex(newUri);
  private funcInitGridRowCount: Function = (): void => this.initGridRowCount();
  @State isSetOriginal: boolean = false;
  private isImmersiveCompared: boolean = false;
  private isCollagePageEnter: boolean = false;
  private isShowImage: boolean = false;
  public isOriginalSupported: boolean = true;
  private pickerPanelHeight: number = px2vp(UiUtil.getResourceNumber($r('app.float.picker_panel_title_height')));
  private footerNavigationHeight: number = px2vp(UiUtil.getResourceNumber($r('app.float.navigation_margin_bottom')));
  private colorTheme: CustomTheme = {};
  private completeButtonText: number = ThirdSelectConstants.COMPLETE_BUTTON_TEXT_DONE;
  private isGrantPage: boolean = false;
  private isClickedComplete: boolean = false;
  private rsc: RscGetter = new RscGetter(getContext().resourceManager);
  @Prop isButtonEnabledInSingleMode: boolean = true;
  /**
   * PC 拖动picker缩略图横向列表pan手势的设置项
   */
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Horizontal });
  /**
   * PC 拖动picker缩略图横向列表pan手势的X偏移量
   */
  private offsetX: number = 0;
  @ObjectLink browserController: BrowserController;
  @LocalStorageLink('geometryOpacity') geometryOpacity: number = 1;
  @LocalStorageLink(Constants.IS_PICKER_USED_SUBWINDOW) isPickerUsedSubwindow: boolean = false;
  private showTitle: boolean = true;
  private isOnlyShowPreviewArea: boolean = false;

  aboutToAppear(): void {
    this.selectManager = LocalStorage.getShared()?.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER);
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.onSelectedCountChanged();
    if (this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      this.showTitle = true;
    }
    if (this.isPickerUsedSubwindow && !this.isMultiPick) {
      this.showTitle = false;
    }

    this.broadCast.on(this.panelId + BroadCastConstants.REFRESH_SELECT_DATA, this.funcRefreshSelectData);
    this.broadCast.on(this.panelId + BroadCastConstants.UPDATE_PANEL_INDEX, this.funcUpdatePanelIndex);
    Log.info(TAG, `aboutToAppear diggingHoleCameraArea: ${JSON.stringify(this.diggingHoleCameraArea)}`)
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.funcInitGridRowCount);
    this.isGrantPage = LocalStorage.getShared()?.has(Constants.PHOTO_PICKER_GRANT_PHOTO_URIS);
  }

  aboutToDisappear(): void {
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.isClickedComplete = false;
    if (this.broadCast) {
      this.broadCast.off(this.panelId + BroadCastConstants.REFRESH_SELECT_DATA, this.funcRefreshSelectData);
      this.broadCast.off(this.panelId + BroadCastConstants.UPDATE_PANEL_INDEX, this.funcUpdatePanelIndex);
    }
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.funcInitGridRowCount);
  }

  refreshSelectData(refresh: boolean): void {
    if (refresh) {
      this.refreshData = refresh;
      this.onSelectedCountChanged();
    }
  }

  updatePanelIndex(newUri: string): void {
    this.itemArray = this.selectManager?.getSelectItems() ?? [];
    const indexUri: number = this.getIndexOfItemArray(newUri);
    if (indexUri !== Constants.NOT_EXIST) {
      this.scrollToCurrentUri(indexUri);
    }
    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT_FOCUS, [newUri]);
    if (this.isSetOriginal) {
      this.isOriginalChecked = true;
    }
  }

  /**
   * 监测横竖屏变化
   */
  watchIsHorizontal() {
    Log.info(TAG, `watchIsHorizontal isHorizontal: ${this.isHorizontal}`)
    this.initGridRowCount();
  }

  private scrollToCurrentUri(indexUri: number): void {
    Log.debug(TAG, `scrollToCurrentUri param: ${this.displayLength}, ${indexUri},` +
      ` ${this.currentStart}, ${this.currentEnd}`);
    indexUri = (indexUri < 0) ? 0 : indexUri;
    if (indexUri <= this.currentStart) { // 向左滑
      this.selectedScroller.scrollToIndex(indexUri);
      return;
    }
    if (indexUri >= this.currentEnd) { // 向右滑
      this.selectedScroller.scrollToIndex((indexUri - this.displayLength + 1) > 0 ?
        (indexUri - this.displayLength + 1) : 0);
      return;
    }
  }

  private initGridRowCount(): void {
    let contentWidth: number = getScreen().getWinWidth();
    let isHorizontalPhone: boolean = DeviceInfo.isPhoneUx() && (isOrientationHorizontal() || DeviceInfo.isFoldable());
    if (isHorizontalPhone || DeviceInfo.isPcOrTablet()) {
      Log.debug(TAG, `initGridRowCount isVerticalPhone:  ${isHorizontalPhone}; ${contentWidth}`);
      contentWidth = Math.min(PHONE_HORIZONTAL_SHEET_WIDTH, contentWidth);
    }
    const width: number = px2vp(UiUtil.getResourceNumber($r('app.float.third_selected_panel_image_height')));
    const marginLeft: number = px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_max_padding_start')));
    const marginRight: number = px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_max_padding_end')));
    this.displayLength = Math.round((contentWidth + marginRight - marginLeft) / (width + marginRight));
    setTimeout((): void => {
      // 滑动更新到当前的URI
      const indexUri: number = this.getIndexOfItemArray(this.currentUri);
      this.scrollToCurrentUri(indexUri === Constants.NOT_EXIST ? this.itemArray.length : indexUri);
    }, Constants.DELAY_TENTH_SECOND)
    Log.debug(TAG, `initGridRowCount displayLength: ${this.displayLength}, ${contentWidth}`);
  }

  /**
   * 获取当前预览图在已选中列表中的index值
   *
   * @returns -1: 选中列表为空; -2: 列表中不存在
   */
  private getIndexOfItemArray(uriItem: string): number {
    let indexCurrentUri: number = -1;
    if (this.itemArray.length === 0) {
      return indexCurrentUri;
    }
    let isInItemArray: boolean = false;
    for (let item of this.itemArray) {
      indexCurrentUri++;
      if (uriItem === item?.uri) {
        isInItemArray = true;
        break;
      }
    }
    return isInItemArray ? indexCurrentUri : Constants.NOT_EXIST;
  }

  initSelect(): void {
    this.initGridRowCount();
    const indexUri: number = this.getIndexOfItemArray(this.currentUri);
    this.scrollToCurrentUri(indexUri === Constants.NOT_EXIST ? this.itemArray.length : indexUri);
    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT_FOCUS, [this.currentUri]);
  }

  onSelectedCountChanged(): void {
    let isAddItem = this.totalSelectedCount > this.selectedCount;
    this.selectedCount = this.totalSelectedCount;
    this.itemArray = this.selectManager == null ? [] : this.selectManager.getSelectItems();
    Log.debug(TAG, `call scroll to edge, current count ${this.itemArray.length} this.panelId is: ${
    this.panelId} this.selectedCount is: ${this.selectedCount}`);
    if (isAddItem) {
      this.selectedScroller.scrollEdge(Edge.End);
    }
  }

  getThumbnailSafe(sourceUri: string, path: string, size?: Size): string {
    try {
      if (size) {
        if (size.width === 0 || size.height === 0) {
          Log.warn(TAG, `getThumbnailSafe with width==0 and height==0, sourceUri: ${
          sourceUri}}, size: ${JSON.stringify(size)}`);
        }
        return `${sourceUri}?oper=thumbnail&width=${size.width}&height=${size.height}&path=${path}`;
      } else {
        return `${sourceUri}?oper=thumbnail&width=${THUMBNAIL_WIDTH}&height=${THUMBNAIL_WIDTH}&path=${path}`;
      }
    } catch (err) {
      Log.warn(TAG, `get Thumbnail Failed! msg:${err}, code: ${err?.code}`);
      return '';
    }
  }

  @Builder
  buildRadio() {
    Stack() {
      Checkbox()
        .margin(0)
        .select(this.isOriginalChecked)
        .hitTestBehavior(HitTestMode.None)
    }
    .height($r('app.float.icon_size'))
    .width($r('app.float.icon_size'))
    .onClick((): void => {
      this.clickOriginButton();
    })
  }

  private selectedTitleDisabled(): boolean {
    return this.selectedCount === 0;
  }

 @Styles
 bindTextStyle() {
   .opacity(this.selectedTitleDisabled()
     ? $r('sys.float.ohos_id_alpha_content_tertiary') : $r('app.float.no_opacity'))
   .enabled(!this.selectedTitleDisabled())
   .accessibilityDescription( this.selectedTitleDisabled()
     ? getContext().resourceManager.getStringSync($r('app.string.disabled')) : '')
   .visibility(this.showTitle ? Visibility.Visible : Visibility.Hidden)
   .margin({
     top: DeviceInfo.isPc() ? $r('app.float.pc_picker_button_margin_top') : 0,
     bottom: DeviceInfo.isPc() ? $r('app.float.pc_picker_button_margin_bottom') : 0,
   })
 }

  @Builder
  buildTitle() {
    Row() {
        if (this.browserController.isBrowserShow) {
          Text(this.isGrantPage ?
          $r('app.string.selected_photos_count_per_sum', (this.isMultiPick ? this.selectedCount : 1),
            this.totalCount) : $r('app.string.selected_photos_count', this.selectedCount, this.maxSelectCount))
            .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_picker_font_size') : $r('sys.float.ohos_id_text_size_body1'))
            .fontColor(DeviceInfo.isTv() ? $r('sys.color.font_secondary') : undefined)
            .countText()
            .bindTextStyle()
        } else {
          Text(this.isGrantPage ?
          $r('app.string.selected_photos_count_per_sum', (this.isMultiPick ? this.selectedCount : 1),
            this.totalCount) : $r('app.string.selected_photos_count', this.selectedCount, this.maxSelectCount))
            .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_picker_font_size') : $r('sys.float.ohos_id_text_size_body1'))
            .fontColor(DeviceInfo.isTv() ? $r('sys.color.font_secondary') : undefined)
            .countText()
            .bindTextStyle()
            .accessibilityRole(AccessibilityRoleType.BUTTON)
            .onClick((): void => {
              if (!this.isShowImage && this.selectedCount > 0 && this.selectManager) {
                Log.info(TAG, `onClick ${JSON.stringify(this.selectManager.preSelectItemUriList[0])}`);
                const item: MediaItem = this.selectManager.getSelectItems()[0];
                Log.info(TAG, `onClick ${JSON.stringify(item)}`);
                let selectParams: Params = {
                  showCancel: this.showCancel,
                  name: '',
                  item: item
                };
                this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER_BY_SELECTED, [selectParams]);
              }
            })
        }

      if (!this.isSetOriginal && this.isOriginalSupported && this.isPickerUsedSubwindow) {
        this.buildOriginButton();
      }

      if (this.isPickerUsedSubwindow) {
        this.buildPcCompleteButton();
      } else if (DeviceInfo.isTv()) {
        this.buildTvCompleteButton();
      } else {
        this.buildCompleteButton();
      }
    }
    .height('100%')
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: DeviceInfo.isTv() ? $r('app.float.tv_picker_select_tip_panel_padding') :
      $r('sys.float.ohos_id_elements_margin_horizontal_l'),
      right: DeviceInfo.isTv() ? $r('app.float.tv_picker_select_tip_panel_padding') :
      $r('sys.float.ohos_id_elements_margin_horizontal_l'),
    })
  }

  @Builder
  buildPcCompleteButton() {
    Row({ space: Constants.PICKER_SELECTED_BUTTON_SPACE }) {
      Button({ type: ButtonType.Normal, buttonStyle: ButtonStyleMode.NORMAL, controlSize: ControlSize.NORMAL }) {
        Text(this.isMultiPick ? $r('app.string.action_selected') : $r('app.string.action_cancel'))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
          .textAlign(TextAlign.Center)
          .fontColor($r('sys.color.font_emphasize'))
      }
      .key(this.isMultiPick ? 'DeselectAll' : 'CancelPicker')
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .PanelButtonStyle()
      .onClick((): void => {
        if (!this.isMultiPick) {
          this.onMenuClicked(Action.CANCEL);
          return;
        }
        if (this.isButtonEnabled() && !this.isClickedComplete) {
          this.onMenuClicked(Action.DESELECT_ALL);
          this.isClickedComplete = true;
          setTimeout((): void => {
            this.isClickedComplete = false;
          }, Constants.PICKER_PAGE_DELAY_TIME);
        }
      })

      Button({ type: ButtonType.Normal, buttonStyle: ButtonStyleMode.EMPHASIZED, controlSize: ControlSize.NORMAL }) {
        Text(this.getButtonResource(this.completeButtonText))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
          .fontColor($r('sys.color.font_on_primary'))
          .textAlign(TextAlign.Center)
      }
      .key('Complete')
      .PanelButtonStyle()
      .onClick((): void => {
        if (this.isButtonEnabled() && !this.isClickedComplete) {
          this.onMenuClicked(Action.OK);
          this.isClickedComplete = true;
          setTimeout((): void => {
            this.isClickedComplete = false;
          }, Constants.PICKER_PAGE_DELAY_TIME);
        }
      })
    }
    .margin({
      top: $r('app.float.pc_picker_button_margin_top'),
      bottom: $r('app.float.pc_picker_button_margin_bottom'),
    })
    .padding({
      right: $r('app.float.pc_picker_text_padding'),
    })
  }

  @Styles
  PanelButtonStyle() {
    .width($r('app.float.pc_picker_selected_button_width'))
    .height($r('app.float.picker_selected_button_height'))
    .borderRadius($r('sys.float.corner_radius_level4'))
    .padding({
      left: $r('app.float.pc_picker_button_padding_left_and_right'),
      right: $r('app.float.pc_picker_button_padding_left_and_right'),
      top: $r('app.float.picker_button_padding_top_and_bottom'),
      bottom: $r('app.float.picker_button_padding_top_and_bottom'),
    })
    .enabled(this.isButtonEnabled())
  }

  @Builder
  buildTvCompleteButton() {
    Button() {
      Text(this.getButtonResource(this.completeButtonText))
        .fontWeight(FontWeight.Medium)
        .fontSize(DeviceInfo.isTv() ? 21 : $r('sys.float.Body_L'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .maxFontScale(1.45)
        .fontColor($r('sys.color.font_on_primary'))
        .textAlign(TextAlign.Center)
    }
    .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
    .border({ width: 0.5, color: $r('app.color.tv_icon_button_border_color') })
    .padding({
      left: $r('app.float.picker_button_padding_left_and_right'),
      right: $r('app.float.picker_button_padding_left_and_right'),
      top: $r('app.float.picker_button_padding_top_and_bottom'),
      bottom: $r('app.float.picker_button_padding_top_and_bottom'),
    })
    .key('Complete')
    .enabled(this.isButtonEnabled())
    .onClick((): void => {
      if (this.isButtonEnabled() && !this.isClickedComplete) {
        this.onMenuClicked(Action.OK);
        this.isClickedComplete = true;
        setTimeout((): void => {
          this.isClickedComplete = false;
        }, Constants.PICKER_PAGE_DELAY_TIME);
      }
    })
    .margin({
      top: $r('app.float.third_selected_panel_image_padding_top'),
      bottom: $r('app.float.third_selected_panel_image_padding_top'),
    })
  }

  @Builder
  buildCompleteButton() {
    Button() {
      Row() {
        Text(this.getButtonResource(this.completeButtonText))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .maxFontScale(1.45)
          .fontColor($r('sys.color.font_on_primary'))
          .textAlign(TextAlign.Center)
      }
      .alignItems(VerticalAlign.Center)
      .margin({
        left: $r('app.float.picker_button_padding_left_and_right'),
        right: $r('app.float.picker_button_padding_left_and_right'),
      })
    }
    .constraintSize({
      minWidth: $r('app.float.picker_button_constraint_min_width'),
      minHeight: $r('app.float.picker_button_constraint_min_height'),
    })
    .key('Complete')
    .enabled(this.isButtonEnabled())
    .responseRegion({
      // 按钮28vp，click热区高度设置为38vp
      x: 0,
      y: '-18%',
      width: '100%',
      height: '136%',
    })
    .onClick((): void => {
      if (this.isButtonEnabled() && !this.isClickedComplete) {
        this.onMenuClicked(Action.OK);
        this.isClickedComplete = true;
        setTimeout((): void => {
          this.isClickedComplete = false;
        }, Constants.PICKER_PAGE_DELAY_TIME);
      }
    })
    .margin({
      top: $r('app.float.third_selected_panel_image_padding_top'),
      bottom: $r('app.float.third_selected_panel_image_padding_top'),
    })
  }

  @Builder
  buildOriginButton() {
    Row() {
      this.buildRadio();
      Text($r('app.string.filter_original_text'))
        .draggable(false)
        .accessibilityLevel('no')
        .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_picker_font_size') : $r('sys.float.ohos_id_text_size_body1'))
        .maxFontScale(1.45)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({ left: $r('app.float.third_selected_toggle_icon_margin_right') })
    }
    // 未选中，原图，单选框，单指双击即可执行
    .accessibilityGroup(true)
    .accessibilityDescription(this.isOriginalChecked ?
    $r('app.string.picker_checkbox_selected') : $r('app.string.picker_checkbox_deselected'))
    .height('100%')
    .align(Alignment.Center)
    .alignItems(VerticalAlign.Center)
    .visibility(this.isFromFa ? Visibility.Hidden : Visibility.Visible)
    .onClick((): void => this.clickOriginButton())
  }

  @Builder
  buildThumbnailItem(item: MediaItem, index: number) {
    ThirdSelectedPanelThumbnailItem({
      panelId: this.panelId,
      item: item,
      index: index,
      selectManager: this.selectManager,
      currentUri: this.currentUri,
      dataSource: this.dataSource,
      selected: this.selectManager?.isSelected(item?.uri) ?? false,
      colorTheme: this.colorTheme,
      isVerdeFoldable: this.isVerdeFoldable,
    })
  }

  @Builder
  buildTvThumbnailListItem(item: MediaItem, index: number) {
    ListItem() {
      this.buildThumbnailItem(item, index as number);
    }
    .key(`buildThumbnailItem_${index}`)
    .width($r('app.float.tv_picker_photo_grid_size'))
    .aspectRatio(1)
    .borderRadius($r('app.float.tv_picker_photo_item_radius'))
    .clip(true)
  }

  private getThumbnailMargin(index: number, type: string): Length {
    let distance: Length = 0
    if ((!UiUtil.isMirrorMode() && type === 'left')) {
      index == 0 ? distance = $r('sys.float.ohos_id_elements_margin_horizontal_l') : 0;
    } else if (type === 'left') {
      index == this.itemArray.length - 1 ? distance = $r('sys.float.ohos_id_elements_margin_horizontal_l') : 0;
    }
    if ((!UiUtil.isMirrorMode() && type === 'right')) {
      index == this.itemArray.length - 1 ? distance = $r('sys.float.ohos_id_elements_margin_horizontal_l') : 0;
    } else if (type === 'right') {
      index == 0 ? distance = $r('sys.float.ohos_id_elements_margin_horizontal_l') : 0;
    }
    return distance
  }


  @Builder
  buildThumbnailList() {
    List({ scroller: this.selectedScroller, space: DeviceInfo.isTv() ? 21 : 8 }) {
      ForEach(this.itemArray, (item: MediaItem, index?: number) => {
        /* instrument ignore next */
        if (DeviceInfo.isTv()) {
          this.buildTvThumbnailListItem(item, index as number);
        } else {
          ListItem() {
            this.buildThumbnailItem(item, index as number);
          }
          .key(`buildThumbnailItem_${index}`)
          .width(this.isVerdeFoldable ?
          $r('app.float.picker_panel_button_width') : $r('app.float.third_selected_panel_image_height'))
          .aspectRatio(1)
          .margin({
            left: this.getThumbnailMargin(index, 'left'),
            right: this.getThumbnailMargin(index, 'right'),
          })
        }
      }, (item: MediaItem) => item?.getHashCode() + item?.size + item?.getThumbnailUpdateTime())
    }
    .onScrollIndex((start: number, end: number, center: number) => {
      this.currentStart = start;
      this.currentEnd = end;
      Log.debug(TAG, `onScroll index range: ${start}, ${end}`);
    })
    .width('100%')
    .height('100%')
    .listDirection(Axis.Horizontal)
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(BarState.Off)
    .onAppear((): void => {
      if (this.needInit) {
        this.initSelect();
      }
    })
    .gesture(
      PanGesture(this.panOption)
        .onActionStart((event: GestureEvent) => {
          this.offsetX = event.offsetX;
        })
        .onActionUpdate((event: GestureEvent) => {
          this.selectedScroller?.scrollBy(this.offsetX - event.offsetX, 0);
          this.offsetX = event.offsetX
        })
        .onActionEnd((event: GestureEvent) => {
          this.selectedScroller?.fling(event.velocityX)
        })
    )
  }

  @Builder
  buildDefault() {
    Column() {
      Text($r('app.string.select_items_to_add'))
        .draggable(false)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .maxFontScale(2.0)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_secondary'))
        .fontWeight(FontWeight.Regular)
    }
    .width('100%')
    .height($r('app.float.third_selected_panel_empty_height'))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({
      left: $r('sys.float.ohos_id_max_padding_start'),
      right: $r('sys.float.ohos_id_max_padding_end'),
    })
  }

  build() {
    if (this.isOnlyShowPreviewArea) {
      if (this.isMultiPick && this.isShowImage) {
        this.buildPreviewArea();
      }
    } else {
      this.buildThirdSelectedPanel();
    }
  }

  @Builder
  buildThirdSelectedPanel() {
    Column() {
      // 预览图
      if (this.isMultiPick && this.isShowImage) {
        this.buildPreviewArea();
      }
      Stack() {
        this.buildTitle();

        if (!this.isSetOriginal && this.isOriginalSupported && !this.isPickerUsedSubwindow) {
          this.buildOriginButton();
        }
      }
      .height(this.isPickerUsedSubwindow || DeviceInfo.isTv() ?
      $r('app.float.picker_selected_panel_height') : Constants.ActionBarHeight)
      .visibility((this.isPickerUsedSubwindow || !this.isBrowserMode) ? Visibility.Visible :
        (!this.browserController.isAnimating ?
        Visibility.Visible : Visibility.Hidden))

      // footer
      if (this.isBrowserMode && !this.isVerdeFoldable && !this.isPickerUsedSubwindow) {
        Column()
          .height(DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() ?
          this.footerNavigationHeight : FOOTER_SAFETY_HEIGHT)
      }

    }
    .width('100%')
    .backgroundColor($r('app.color.transparent'))
  }

  @Builder
  buildPreviewArea() {
    Row() {
      if (this.itemArray.length > 0 || this.refreshData) {
        this.buildThumbnailList();
      } else {
        this.buildDefault();
      }
    }
    .padding({
      top: $r('app.float.third_selected_panel_image_padding_top'),
    })
    .opacity(this.isBrowserMode ? this.geometryOpacity : undefined)
    .width('100%')
    .transition(TransitionEffect.asymmetric(
      BrowserConstants.PICKER_BROWSER_OPEN_EFFECT,
      BrowserConstants.PICKER_BROWSER_CLOSE_EFFECT
    ))
    .height(DeviceInfo.isTv() ? Constants.TV_PICKER_PREVIEW_AREA_HEIGHT :
      (this.isVerdeFoldable ? Constants.PICKER_PREVIEW_AREA_HEIGHT : $r('app.float.picker_panel_image_height')))
  }

  private isButtonEnabled(): boolean {
    Log.info(TAG, `selectedCount is ${this.selectedCount}, singleSelectionMode is ${this.singleSelectionMode}, ` +
     `isMultiPick is ${this.isMultiPick}, isButtonEnabledInSingleMode is ${this.isButtonEnabledInSingleMode}`);
    if (this.selectedCount > 0) {
      return true;
    }
    if (this.singleSelectionMode === SingleSelectionMode.BROWSER_AND_SELECT_MODE) {
      return false;
    }
    if (this.isPickerUsedSubwindow && !this.isMultiPick && !this.isBrowserMode) {
      // picker子窗模式单选时在宫格页未选中时按钮应该disable
      return false;
    }
    if (!this.isMultiPick && this.isButtonEnabledInSingleMode) {
      return true;
    }
    return false;
  }

  private clickOriginButton(): void {
    this.isOriginalChecked = !this.isOriginalChecked;
    AccessibilityUtil.sendAnnounceAccessibilityEvent(this.isOriginalChecked
      ? this.rsc.toString($r('app.string.selected')) : this.rsc.toString($r('app.string.deselected')));
    Log.info(TAG, `origin clicked: ${this.isOriginalChecked}`);
  }

  private getButtonResource(completeButtonText: number): Resource {
    switch (completeButtonText) {
      case ThirdSelectConstants.COMPLETE_BUTTON_TEXT_DONE:
        return $r('app.string.complete');
      case ThirdSelectConstants.COMPLETE_BUTTON_TEXT_SEND:
        return $r('app.string.send');
      case ThirdSelectConstants.COMPLETE_BUTTON_TEXT_ADD:
        return $r('app.string.add');
      case ThirdSelectConstants.COMPLETE_BUTTON_TEXT_GRANT:
        return $r('app.string.data_inherit_authorization');
      default:
        return $r('app.string.complete');
    }
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.debug(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    if (!nfyInfo.uris || !nfyInfo.uris.length) {
      return;
    }
    if (nfyInfo?.type !== MediaObserverNfyType.PHOTO_UPDATE_ASTC) {
      return;
    }
    const selectItems = this.selectManager?.getSelectItems() ?? []
    this.itemArray = selectItems.map((value) => {
      if (nfyInfo.uris.includes(value?.uri)) {
        value.setThumbnailUpdateTime(Date.now());
      }
      return value;
    })
  }

  onMediaLibDataChange(changeType: string): void {
    Log.debug(TAG, `onMediaLibDataChange changeType: ${changeType}`);
  }
}