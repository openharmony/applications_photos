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

import lazy { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataInfo } from '../../../default/model/common/AlbumSetDataInfo';
import lazy { BroadCast } from '../../../default/utils/BroadCast';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../../../default/model/common/BroadCastManager';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { getDurationConst, GridLink } from '../../../default/model/browser/photo/const/GridLinkDelay';
import lazy { Log } from '../../../default/utils/Log';
import lazy { ParamAlbumInfo } from '../../../default/interface/Album';
import lazy { UiUtil } from '../../../default/utils/UiUtil';
import lazy { CustomItem, SideBarItemClickListener, SideBarType } from '../../../../../../../feature/browser/src/main/ets/default/view/SideBar';
import lazy { AlbumGrid } from '../../model/AlbumGrid';
import lazy measure from '@ohos.measure';
import lazy { ImmersiveController } from '../../../default/utils/ImmersiveController';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { AppBarStyles } from '../../../default/view/actionbar/AppBarStyles';
import lazy { FoldUtil } from '../../utils/FoldUtil';
import lazy { Configuration } from '@kit.ArkUI';

/* instrument ignore file */
const TAG: string = 'SourceAlbumSideBarItem';
const SIDE_BAR_ITEM_TRANSITION_SCALE: number = 0.75;
const paddingL4: number = px2vp(UiUtil.getResourceNumber($r('sys.float.padding_level4')));

@Component
export struct SourceAlbumSideBarItem {
  @ObjectLink @Watch('onAlbumInfoChanged') albumSetDataInfo: AlbumSetDataInfo;
  @State item: AlbumInfo = new AlbumInfo();
  private icon: Resource | undefined = undefined;
  private fillIcon: Resource | undefined = undefined;
  private sideBarIndex: number = -1;
  @State private index: number = -1;
  @Link navigationPageInfos: NavPathStack;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  // show control
  @Link private isShowTimelinePage: boolean;
  @Link private isShowPhotoHiddenView: boolean;
  @Link private isShowHiddenGridView: boolean;
  @Link private isShowPhotoClassifieds: boolean;
  @Link private isShowPhotoShooting: boolean;
  @Link private isShowSearchPage: boolean;
  @Link private isShowPortraitAlbumsView: boolean;
  // z序控制走焦border
  @State private itemZIndex: number = 0;
  // for select
  @Prop @Watch('onCurrentIndexChange') private currentIndex: number;
  @State private isSelected: boolean = false;
  @Link @Watch('onCurrentIndexChange') private isFreezeSelected: boolean;
  @State private isHover: boolean = false;
  private static readonly selectedItemBackgroundColor: number =
    ((UiUtil.getResourceNumber($r('sys.float.ohos_id_alpha_normal_bg')) * 255) << 24 & 0xff000000) |
      (UiUtil.getResourceColorSync($r('sys.color.ohos_id_color_emphasize')) & 0x00ffffff);
  // func
  private selectItem?: Function;
  private releaseAlbumInfoItemCache?: Function;
  // animation control
  @Prop private isSideBarItemAniOpen: boolean = false;
  // hover
  @State private isShowFullName: boolean = false;
  @State private isTextOver: boolean = false;
  @State private isPressed: boolean = false;

  private sideBarItemClickListener: SideBarItemClickListener = {
    onSideBarItemClick: (sideBarIndex: number) => {
    },
  };
  // 侧边栏当前宽度
  @Prop sideBarWidth: number;
  // 侧边栏之前的宽度
  private oldSideBarWidth: number = -1;

  aboutToAppear(): void {
    if (this.item instanceof AlbumInfo && this.item.albumName === 'fp') {
      setInterval(() => {
        Log.info(TAG, `SidebarItem fp count is ${this.item.count}`)
      }, 10000)
    }

    if (!this.icon) {
      this.icon = $r('sys.symbol.rectangle_on_rectangle');
    }

    if (!this.fillIcon) {
      this.fillIcon = $r('sys.symbol.rectangle_on_rectangle_fill');
    }
  }

  aboutToDisappear(): void {
    this.releaseAlbumInfoItemCache?.(this.item);
  }

  private onAlbumInfoChanged(): void {
    Log.info(TAG, 'onAlbumInfoChanged')
    const tempItem: AlbumInfo | undefined = this.albumSetDataInfo?.data;
    if (this.albumSetDataInfo.index !== undefined) {
      let indexNew: number = this.albumSetDataInfo.index;
      if (indexNew !== this.index) {
        this.index = this.albumSetDataInfo.index;
        this.sideBarIndex = SideBarType.SOURCE + this.index;
        this.isFreezeSelected = false;
        this.onCurrentIndexChange(); // to open the album if index changed
      }
    }
    if (!tempItem) {
      Log.error(TAG, `onAlbumInfoChanged albumInfo undefined, index=${this.index}`);
      return;
    }
    if (tempItem instanceof AlbumInfo) {
      this.item = tempItem;
      return;
    }
    Log.error(TAG, 'onAlbumInfoChanged albumInfo type error, not AlbumInfo type');
  }

  build() {
    Column() {
      this.albumLabelItem();
    }
    .zIndex(this.itemZIndex)
    .onFocus((): void => {
      this.itemZIndex = 1;
    })
    .onBlur((): void => {
      this.itemZIndex = 0;
    })
    .onKeyEvent((event: KeyEvent): void => {
      FocusCtrlManager.handleSideBarKeyEvent(event);
    })
    .transition(this.isSideBarItemAniOpen ?
    TransitionEffect.OPACITY.animation({ duration: 300, curve: Curve.Friction }).combine(TransitionEffect.scale({
      x: SIDE_BAR_ITEM_TRANSITION_SCALE,
      y: SIDE_BAR_ITEM_TRANSITION_SCALE,
    })) :
    TransitionEffect.IDENTITY)
    .id(this.checkIsAlbumItem(this.item) ? (this.item as AlbumInfo).getHashCode() : `SideBarCustom_${
    this.sideBarIndex}`)
    .onDrop((event?: DragEvent, extraParams?: string): void => {
      Log.info(TAG, `sideBarItem onDrop ${this.sideBarIndex}`);
      event?.setResult(DragResult.DRAG_FAILED);
    })
  }

  @Builder
  albumLabelItem() {
    this.buttonItem();
  }

  @Styles
  focusedStyle() {
    .borderStyle(BorderStyle.Solid)
    .borderWidth(2)
    .borderColor($r('sys.color.ohos_id_color_activated'))
    .borderRadius($r('sys.float.corner_radius_level4'))
  }

  @Styles
  normalStyle() {
    .borderWidth(2)
    .borderColor(Color.Transparent)
  }

  private handleButtonItemOnClick(): void {
    this.isFreezeSelected = false;
    this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
    this.selectItem?.(this.sideBarIndex);
  }

  @Builder
  buttonItem() {
    Row() {
      this.buttonIcon();
      Text(this.getDisplayName(this.item))
        .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
        .fontWeight(DeviceInfo.isPc() && this.isSelected ? FontWeight.Bold : FontWeight.Medium)
        .fontColor(this.getTextColor(this.isSelected))
        .fontSize(DeviceInfo.isTv() ?
        $r('app.float.tv_sidebar_item_font_size') : $r('sys.float.ohos_id_text_size_body1'))
        .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
        .maxLines(1)
        .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .height(DeviceInfo.isTv() ? $r('app.float.tv_menu_height') : $r('app.float.menu_height'))
        .layoutWeight(1)
        .margin({
          left: DeviceInfo.isTv() ? $r('app.float.tv_sidebar_item_margin_left') :
            (DeviceInfo.isPc() ? $r('sys.float.padding_level4') : $r('sys.float.padding_level8')),
          right: DeviceInfo.isTv() ? $r('app.float.tv_sidebar_item_margin_right') : $r('sys.float.padding_level4'),
        })
        .onHover((isHover?: boolean) => {
          this.isHover = !!isHover;
          this.isShowFullName = this.isHover;
        })
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          if (this.sideBarWidth !== this.oldSideBarWidth && this.oldSideBarWidth !== -1) {
            this.updateTextWidth(newValue);
          }
          this.oldSideBarWidth = this.sideBarWidth;
        })
      this.buttonCount();
    }
    .stateStyles({
      focused: this.focusedStyle,
      normal: this.normalStyle,
    })
    .width('100%')
    .focusOnTouch(true)
    .backgroundColor(this.getBackgroundColor(this.isSelected, this.isPressed, this.isHover))
    .padding({
      left: $r('sys.float.padding_level4'),
      right: $r('sys.float.padding_level4'),
    })
    .borderRadius(DeviceInfo.isPc() ?
    $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level8'))
    .height(DeviceInfo.isTv() ? Constants.SIDE_BAR_ITEM_HEIGHT_TV :
      (DeviceInfo.isPc() ? Constants.SIDE_BAR_ITEM_HEIGHT_PC : Constants.SIDE_BAR_ITEM_HEIGHT_TABLET))
    .onClick((event: ClickEvent): void => {
      /* instrument ignore next */
      if (DeviceInfo.isPc() && event.source !== 4) {
        this.getUIContext()?.getFocusController()?.clearFocus();
      }
      this.handleButtonItemOnClick();
    })
    .onTouch((event: TouchEvent): void => {
      this.handleOnTouch(event);
    })
    .bindPopup(this.isTextOver && this.isShowFullName, {
      builder: this.buttonTip,
      autoCancel: true,
      mask: false,
      enableArrow: false,
    })
    .stateStyles({
      focused: this.focusedStyle,
      normal: this.normalStyle,
    })
  }

  private getTextColor(isSelected: boolean): Resource {
    if (isSelected) {
      return $r('sys.color.font_primary');
    }
    return $r('sys.color.ohos_id_color_text_primary');
  }

  private getBackgroundColor(isSelected: boolean, isPressed: boolean, isHover: boolean): Resource | Color {
    if (isSelected) {
      return DeviceInfo.isTv() ? $r('app.color.tv_sidebar_select_bg') :
      SourceAlbumSideBarItem.selectedItemBackgroundColor;
    } else if (isPressed) {
      return DeviceInfo.isTv() ? $r('app.color.tv_sidebar_press_bg') : $r('sys.color.ohos_id_color_click_effect');
    } else if (isHover) {
      return DeviceInfo.isTv() ? $r('app.color.tv_sidebar_hover_bg') : $r('sys.color.ohos_id_color_hover');
    }
    return Color.Transparent;
  }

  private handleOnTouch(event: TouchEvent): void {
    if (event.type === 0) {
      this.isPressed = true;
    } else if (event.type === 1) {
      this.isPressed = false;
    } else if (event.type === TouchType.Cancel && DeviceInfo.isPc()) {
      this.isPressed = false;
    }
  }

  private updateTextWidth(area: SizeOptions): void {
    let name: string | Resource | undefined = this.getDisplayName(this.item);
    let textWidth: number = measure.measureText({
      textContent: name,
      fontSize: $r('sys.float.ohos_id_text_size_body1'),
      fontWeight: FontWeight.Medium,
      fontFamily: $r('sys.string.ohos_id_text_font_family_medium'),
    });
    if (typeof area.width === 'number') {
      this.isTextOver = px2vp(parseInt(textWidth.toString())) > (area.width - paddingL4);
    }
  }

  @Builder
  buttonTip() {
    Row() {
      Text(this.getDisplayName(this.item))
        .fontSize($r('sys.float.Body_M'))
    }
    .padding({
      left: $r('app.float.immersive_compared_tip_padding_left'),
      top: $r('app.float.immersive_compared_tip_padding_top'),
      right: $r('app.float.immersive_compared_tip_padding_left'),
      bottom: $r('app.float.immersive_compared_tip_padding_top'),
    })
  }

  @Styles
  imageBorderStyle() {
    .borderStyle(DeviceInfo.isTv() ? undefined : BorderStyle.Solid)
    .borderWidth(DeviceInfo.isTv() ? undefined : 1)
    .borderColor(DeviceInfo.isTv() ? undefined : $r('sys.color.mask_sixth'))
    .borderRadius($r('sys.float.corner_radius_level2'))
  }

  @Builder
  buttonIcon() {
    if (this.checkIsAlbumItem(this.item)) {
      if ((this.item as AlbumInfo).coverUri) {
        Column() {
          Image((this.item as AlbumInfo).coverUri)
            .draggable(false)
            .height(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') : $r('app.float.icon_size'))
            .width(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') : $r('app.float.icon_size'))
            .objectFit(ImageFit.Cover)
            .edgeAntialiasing(DeviceInfo.isHym() ? 0.4 : 0)
            .imageBorderStyle()
            .margin({ left: DeviceInfo.isTv() ? $r('app.float.tv_sidebar_button_padding') : undefined })
        }
        .clip(true)
        .border(DeviceInfo.isTv() ? undefined : {
          width: $r('sys.float.outline_extra_small'),
          color: $r('app.color.album_card_border_color'),
          radius: $r('sys.float.corner_radius_level2'),
        })
      } else {
        this.customSymbol();
      }
    }
  }

  @Builder
  buttonCount() {
    Column() {
      if (this.checkIsAlbumItem(this.item)) {
        Text(`${this.item.count ?? 0}`)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_sidebar_count_size') : $r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
          .margin({ right: DeviceInfo.isTv() ? $r('app.float.tv_sidebar_button_padding') : undefined })
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.End)
  }

  @Builder
  customSymbol() {
    SymbolGlyph((this.isSelected || !DeviceInfo.isPc()) ? this.fillIcon : this.icon)
      .fontWeight(FontWeight.Normal)
      .fontSize($r('app.float.icon_size'))
      .renderingStrategy(SymbolRenderingStrategy.SINGLE)
      .fontColor([this.getSymbolColor(this.isSelected)])
  }

  private getSymbolColor(isSelected: boolean): Resource {
    if (isSelected) {
      return $r('sys.color.icon_primary');
    }
    return $r('sys.color.ohos_id_color_text_secondary');
  }

  private albumOnClick(album: AlbumInfo | CustomItem, isOpenPhotoGridView: boolean = false): void {
    this.appBroadCast.emit(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, []);
    ImmersiveController.isInImmersive = false;
    this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
    this.isShowSearchPage = false;
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.releaseAppKeyForGRL();
      this.isShowPhotoHiddenView = false;
      this.isShowHiddenGridView = false;
    }
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_FROM_CATEGORY, false);
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_FROM_SHOOT_VIEW, false);
    if (this.isSelected && !isOpenPhotoGridView) {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_IMMERSIVE_STATUS_BAR_COLOR, []);
      return;
    }
    if (this.checkIsAlbumItem(album)) {
      Log.info(TAG, `sideBarItem onclick openPhotoGridView ${(album as AlbumInfo).uri}`);
      this.openPhotoGridView(album as AlbumInfo);
      return;
    }
  }

  private openPhotoGridView(album: AlbumInfo): void {
    let albumInfo: ParamAlbumInfo = { item: JSON.stringify(album) };
    AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, albumInfo);
    // AlbumGrid.firstItem = album?.mediaItem?.data;
    AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_URI, (album as AlbumInfo).uri);
    AppStorage.setOrCreate<string>('focusPosition', '');

    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      animateTo({
        duration: getDurationConst(GridLink.ALBUM_TO_PHOTO_GRID),
        curve: Curve.Friction,
      }, (): void => {
        this.refreshPhotoGridView();
      });
    } else {
      this.refreshPhotoGridView();
    }
    // actionbar
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);
    // 整个相册宫格页透明度，Column
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);

    Log.info(TAG, `sideBar onclick now data: ${albumInfo?.item}`);
  }

  private refreshPhotoGridView(): void {
    if (AppStorage.get<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW)) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_GRID_REFRESH, []);
    } else {
      this.resetPageStatus();
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, true);
    }
  }

  private async resetPageStatus(): Promise<void> {
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);
    this.isShowTimelinePage = false;
    this.isShowPhotoHiddenView = false;
    this.isShowHiddenGridView = false;
    this.isShowPhotoClassifieds = false;
    this.isShowPhotoShooting = false;
    this.isShowPortraitAlbumsView = false;
    this.sideBarItemClickListener.onSideBarItemClick(SideBarType.SYS);

    Log.info(TAG, 'resetPageStatus done');
  }

  private getDisplayName(item: AlbumInfo | CustomItem): Resource | string | undefined {
    if (!item) {
      return '';
    }
    if (this.checkIsAlbumItem(item)) {
      let res: Resource | undefined = UiUtil.getDisplayNameResourceByAlbumInfo(item as AlbumInfo);
      return res ?? (item as AlbumInfo).albumName;
    }
    return (item as CustomItem).label;
  }

  private onCurrentIndexChange(): void {
    if (this.isFreezeSelected) {
      return;
    }
    let isSelectedOld: boolean = this.isSelected;
    this.isSelected = this.currentIndex === this.sideBarIndex;
    if (this.isSelected && !isSelectedOld) {
      this.albumOnClick(this.item, true);
    }
  }

  // albumInfo item, etc. user album
  private checkIsAlbumItem(item: AlbumInfo | CustomItem): boolean {
    return item instanceof AlbumInfo;
  }
}