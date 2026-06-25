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
import lazy { BroadCast } from '../../../default/utils/BroadCast';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../../../default/model/common/BroadCastManager';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { getDurationConst, GridLink } from '../../../default/model/browser/photo/const/GridLinkDelay';
import lazy { Log } from '../../../default/utils/Log';
import lazy { NavigationBroadCastManager } from '../../../default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '../../../default/model/common/NavigationConstants';
import lazy { ParamAlbumInfo } from '../../../default/interface/Album';
import lazy { UiUtil } from '../../../default/utils/UiUtil';
import lazy { CustomItem, SideBarItemClickListener, SideBarType } from '../../../../../../../feature/browser/src/main/ets/default/view/SideBar';
import lazy { AlbumGrid } from '../../model/AlbumGrid';
import lazy measure from '@ohos.measure';
import lazy { ImmersiveController } from '../../../default/utils/ImmersiveController';
import lazy { uniformTypeDescriptor } from '@kit.ArkData';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { TraceControllerUtils } from '../../../default/utils/TraceControllerUtils';
import lazy { AppBarStyles } from '../../../default/view/actionbar/AppBarStyles';
import lazy { AlbumSetSelectManager } from '../../../default/model/browser/SelectManager';
import lazy { Action } from '../../../default/view/browserOperation/Action';
import lazy { MORE_MENU_ITEM_HEIGHT } from '../../../default/view/actionbar/MoreAction';
import lazy {
  RightClickMenuGroup,
  MenuController,
  MenuPopUpParams,
  PopType,
} from '../menu/MenuController';
import lazy { MenuPopUp } from '../menu/MenuView';

/* instrument ignore file */
const TAG: string = 'NonUserAlbumSideBarItem';
const SIDE_BAR_ITEM_TRANSITION_SCALE: number = 0.75;
// 侧边栏照片和视频 index
const SIDE_BAR_ITEM_TIMELINE_INDEX: number = 1;
const paddingL4: number = px2vp(UiUtil.getResourceNumber($r('sys.float.padding_level4')));

@Extend(Text)
function systemSideBarItemTextStyle() {
  .fontSize(DeviceInfo.isTv() ?
    $r('app.float.tv_sidebar_item_font_size') : $r('sys.float.ohos_id_text_size_body1'))
  .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
  .maxLines(1)
  .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
}

/**
 * NonUserAlbumSideBarItem
 */
@Component
export struct NonUserAlbumSideBarItem {
  // private sideBarController: SideBarController = SideBarManager.getInstance();
  @ObjectLink item: AlbumInfo | CustomItem;
  @State private index: number = -1;
  // icon 信息资源
  private icon: Resource | undefined = undefined;
  private fillIcon: Resource | undefined = undefined;
  private sideBarType: number = -1;
  private sideBarIndex: number = -1;
  @Link navigationPageInfos: NavPathStack;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Prop private controller: MenuController;
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
  @Link @Watch('onCurrentIndexChange') currentIndex: number;
  private lastActiveIndex: number = 1;
  @State @Watch('onSelectedChange') private isSelected: boolean = false;
  @Link @Watch('onCurrentIndexChange') private isFreezeSelected: boolean;
  @State private isHover: boolean = false;
  private static readonly selectedItemBackgroundColor: number =
    ((UiUtil.getResourceNumber($r('sys.float.ohos_id_alpha_normal_bg')) * 255) << 24 & 0xff000000) |
      (UiUtil.getResourceColorSync($r('sys.color.ohos_id_color_emphasize')) & 0x00ffffff);
  // for menu
  @Prop private operationMenuListSystem: RightClickMenuGroup[] = [];
  private canContextMenuBind: boolean = false;
  // func
  private selectItem?: Function;
  private onMenuClickedForSingleItem: Function = (action: Action, currentAlbum: AlbumInfo, index: number): void => {
  };
  // animation control
  @Prop private isSideBarItemAniOpen: boolean = false;
  // hover
  @State private isShowFullName: boolean = false;
  @State private isTextOver: boolean = false;
  @State private isPressed: boolean = false;
  @State private isDragEnter: boolean = false;
  @Prop private isImageGridDragging: boolean = false;
  private onDropFunc: Function = (): void => {
  };
  private sideBarItemClickListener: SideBarItemClickListener = {
    onSideBarItemClick: (sideBarIndex: number) => {
    },
  };
  // 侧边栏当前宽度
  @Prop sideBarWidth: number;
  // 侧边栏之前的宽度
  private oldSideBarWidth: number = -1;
  @State private isShowMenu: boolean = false;

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

    if (this.sideBarIndex === SideBarType.HIGHLIGHT &&
      AppStorage.get<boolean>(Constants.KEY_OF_MARK_JUMP_TO_HIGHLIGHT_DIRECTLY) !== undefined) {
      this.handleButtonItemOnClick();
    }
  }

  aboutToDisappear(): void {
  }

  build() {
    Column() {
      if (this.sideBarIndex !== SideBarType.HIDDEN) {
        this.albumLabelItem();
      }
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
    this.appBroadCast.emit(BroadCastConstants.CLICK_SIDE_BAR_ITEM, []);
    this.selectItem?.(this.sideBarIndex);
  }

  private menuOptions(menuMode: number): ContextMenuOptions {
    switch (menuMode) {
      case 2:
        return {
          aboutToAppear: (): void => {
            this.isShowFullName = false;
          },
          onAppear: (): void => {
            Log.info(TAG, 'MenuListShow---');
          },
        }
    }
    return {};
  }

  handleClearRecycle(actionID: number) {
    this.isSideBarItemAniOpen = true;
    this.appBroadCast.emit(BroadCastConstants.CLEAR_RECYCLE, [actionID]);
  }

  private onMenuClick(action: Action): void {
    Log.info(TAG, `handleClearRecycle---${action.actionID}--${Action.CLEAR_RECYCLE.actionID}`);
    if (action.actionID === Action.CLEAR_RECYCLE.actionID) {
      this.handleClearRecycle(Action.CLEAR_RECYCLE.actionID);
      return;
    }
  }

  private getMenuPopUpParams(): MenuPopUpParams {
    const params: MenuPopUpParams = {
      type: PopType.NORMAL,
      onMenuClick: (menu: Action): void => this.onMenuClick(menu),
    }
    return params;
  }

  @Builder
  operationMenuBuilder() {
    /* instrument ignore next */
    if (this.isSelected && DeviceInfo.isPc()) {
      MenuPopUp({
        controller: this.controller,
        menuPopUpParams: this.getMenuPopUpParams(),
      })
      .key('SidBarItem_Menu')
    }
  }

  @Builder
  buttonItem() {
    Row() {
      this.buttonIcon();
      if (this.isShowMenu) {
        Text(this.getDisplayName(this.item))
          .fontWeight(DeviceInfo.isPc() && this.isSelected ? FontWeight.Bold : FontWeight.Medium)
          .fontColor(this.getTextColor(this.isSelected, this.isDragEnter))
          .systemSideBarItemTextStyle()
          .systemAlbumTextAttrs()
          .bindContextMenu(this.operationMenuBuilder,
            ResponseType.LongPress, this.menuOptions(2))
          .bindContextMenu(this.operationMenuBuilder,
            ResponseType.RightClick, this.menuOptions(2))
      } else {
        Text(this.getDisplayName(this.item))
          .fontWeight(DeviceInfo.isPc() && this.isSelected ? FontWeight.Bold : FontWeight.Medium)
          .fontColor(this.getTextColor(this.isSelected, this.isDragEnter))
          .systemSideBarItemTextStyle()
          .systemAlbumTextAttrs()
      }
      this.buttonCount();
    }
    .width('100%')
    .focusOnTouch(true)
    .backgroundColor(this.getBackgroundColor(this.isSelected, this.isPressed, this.isHover, this.isDragEnter))
    .padding({
      left: $r('sys.float.padding_level4'),
      right: $r('sys.float.padding_level4'),
    })
    .borderRadius(DeviceInfo.isPc() ?
    $r('sys.float.corner_radius_level4') : (DeviceInfo.isTv() ? $r('sys.float.corner_radius_level8') :
      $r('sys.float.corner_radius_level8')))
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
    .systemAlbumListDropAttrs()
  }

  @Styles
  systemAlbumTextAttrs() {
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
  }

  @Styles
  systemAlbumListDropAttrs() {
    .allowDrop(this.getAllowDrop(this.sideBarIndex))
    .onDrop((event: DragEvent) => {
      this.onDropFunc(event);
      this.isDragEnter = false;
    })
    .onDragEnter((event: DragEvent): void => {
      if (this.getIsAbleDrop(event)) {
        this.isDragEnter = true;
      }
    })
    .onDragLeave((): void => {
      this.isDragEnter = false;
    })
  }

  // 获取拖拽文件中各类型数量
  private getIsAbleDrop(event: DragEvent): boolean {
    const dragData: Summary = event.getSummary();
    const mediaTypes: UniformDataType[] | null = this.getAllowDrop(this.sideBarIndex);
    if (!dragData || !mediaTypes) {
      return false;
    }
    let isAbleDrop: boolean = false;
    for (let i = 0; i < Object.values(dragData.summary).length; i++) {
      const item = Object.values(dragData.summary)[i];
      if (mediaTypes.includes(Object.values(item)[0])) {
        return true;
      }
    }
    return false;
  }

  private getAllowDrop(item: SideBarType): UniformDataType[] | null {
    if (this.isImageGridDragging) {
      return null;
    }

    if (item === SideBarType.TIMELINE) {
      return [uniformTypeDescriptor.UniformDataType.IMAGE, uniformTypeDescriptor.UniformDataType.VIDEO];
    } else if (item === SideBarType.PHOTO) {
      return [uniformTypeDescriptor.UniformDataType.IMAGE];
    } else if (item === SideBarType.VIDEO) {
      return [uniformTypeDescriptor.UniformDataType.VIDEO];
    } else {
      return null;
    }
  }

  private getTextColor(isSelected: boolean, isDragEnter: boolean): Resource {
    if (isDragEnter) {
      return $r('sys.color.ohos_id_color_text_primary_contrary');
    } else if (isSelected) {
      return $r('sys.color.font_primary');
    }
    return $r('sys.color.ohos_id_color_text_primary');
  }

  private getBackgroundColor(
    isSelected: boolean, isPressed: boolean, isHover: boolean, isDragEnter?: boolean): Resource | Color {
    if (isDragEnter) {
      return $r('sys.color.ohos_id_color_emphasize');
    } else if (isSelected) {
      TraceControllerUtils.finishTrace('touchOnToSelected');
      return DeviceInfo.isTv() ? $r('app.color.tv_sidebar_select_bg') :
      NonUserAlbumSideBarItem.selectedItemBackgroundColor;
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
      TraceControllerUtils.startTrace('touchOnToSelected');
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

  @Builder
  buttonIcon() {
    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      this.customSymbolForTv();
    } else {
      this.customSymbol();
    }
  }

  @Builder
  buttonCount() {
    Column() {
      if (this.sideBarIndex === SideBarType.HIDDEN) {
        SymbolGlyph(this.isSelected ? $r('sys.symbol.lock_fill') : $r('sys.symbol.lock'))
          .draggable(false)
          .fontSize($r('app.float.list_item_right_icon1_size'))
          .fontColor([$r('sys.color.icon_secondary')])
      } else if (this.checkIsAlbumItem(this.item) || this.sideBarIndex === SideBarType.TIMELINE) {
        Text(`${this.item.count ?? 0}`)
          .fontColor(this.isDragEnter ? $r('sys.color.ohos_id_color_text_secondary_contrary') :
          $r('sys.color.ohos_id_color_text_secondary'))
          .fontSize(DeviceInfo.isTv() ?
          $r('app.float.tv_sidebar_count_size') : $r('sys.float.ohos_id_text_size_body2'))
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
      .fontColor([this.getSymbolColor(this.isSelected, this.isDragEnter)])
      .stateStyles({
        focused: this.focusedStyle,
        normal: this.normalStyle,
      })
  }

  @Builder
  customSymbolForTv() {
    SymbolGlyph(this.fillIcon)
      .fontWeight(FontWeight.Normal)
      .fontSize($r('app.float.tv_symbol_icon_size'))
      .renderingStrategy(SymbolRenderingStrategy.SINGLE)
      .fontColor([this.getSymbolColor(this.isSelected, this.isDragEnter)])
      .margin({ left: $r('app.float.tv_sidebar_button_padding') })
  }

  private getSymbolColor(isSelected: boolean, isDragEnter: boolean): Resource {
    if (isDragEnter) {
      return $r('sys.color.ohos_id_color_text_primary_contrary');
    } else if (isSelected) {
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
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_KEEP_SEARCH);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_CATEGORY_GRID_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_SHOOTING_MODE_GRID_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_POSITION);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_SELECT_FRAME);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_IS_SELECT_ALL);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_KEEP_CLASSIFIED);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_KEEP_SHOOTING);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_ENTRY);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GRID_SCROLL_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GRID_SCROLL_INDEX_TMP);
      LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_PHOTO_GRID_SELECT_MODE, false);
      LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_PHOTO_GRID_SELECT_FRAME, false);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_FIRST_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GROUP_FIRST_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_CURRENT_VIEW);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_HIDDEN_GRID_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_HIDDEN_GRID_SELECT_FRAME);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PHOTO_GRID_VIEW_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GRID_PORTRAIT_SELECT_MANAGER);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_ALBUM_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_MORE_ENTRY);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_MORE_PORTRAIT_SELECT_MANAGER);
      AppStorage.delete(Constants.PHOTO_GRID_SELECT_MANAGER);
    }
    if (!DeviceInfo.isTablet()) {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_FROM_CATEGORY, false);
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_FROM_SHOOT_VIEW, false);
    }
    if (this.isSelected && !isOpenPhotoGridView) {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_IMMERSIVE_STATUS_BAR_COLOR, []);
      return;
    }
    this.albumOnClickInner();
    if (this.checkIsAlbumItem(album)) {
      Log.info(TAG, `sideBarItem onclick openPhotoGridView ${(album as AlbumInfo).uri}`);
      this.openPhotoGridView(album as AlbumInfo);
      return;
    }
  }

  private albumOnClickInner(): void {
    if (DeviceInfo.isGRLFoldScreen()) {
      if (this.sideBarIndex !== SideBarType.PORTRAIT) {
        LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_ENTRY);
      }
      if (this.sideBarIndex !== SideBarType.HIGHLIGHT) {
        LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_RECOVER_HIGHLIGHT);
      }
      if (this.sideBarIndex !== SideBarType.HIDDEN) {
        LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_HIDDEN_ENTRY, false);
        LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_HIDDEN_GRID_ENTRY, false);
        LocalStorage.getShared()?.setOrCreate(Constants.APP_KEY_GRL_HIDDEN_UNLOCK, false);
        this.isShowPhotoHiddenView = false;
        this.isShowHiddenGridView = false;
      }
    }
    if (this.sideBarIndex === SideBarType.TIMELINE) {
      /* instrument ignore next */
      if (DeviceInfo.isPcOrTablet()) {
        animateToImmediately({
          duration: 0,
        }, (): void => {
          this.appBroadCast.emit(BroadCastConstants.HIDE_GRID_VIEW_ACTION_BAR, [true]);
        });

        animateToImmediately({
          duration: getDurationConst(GridLink.ALBUM_TO_PHOTO_GRID),
          curve: Curve.Friction,
        }, (): void => {
          this.resetPageStatus();
          this.isShowTimelinePage = true;
          if (DeviceInfo.isPc()) {
            this.appBroadCast.emit(BroadCastConstants.LOAD_PORTRAIT_PAGE, []);
          }
        })
      } else {
        this.resetPageStatus();
        this.isShowTimelinePage = true;
      }
      return;
    }
    if (this.sideBarIndex === SideBarType.HIGHLIGHT) {
      /* instrument ignore next */
      if (DeviceInfo.isTablet()) {
        animateTo({
          duration: getDurationConst(GridLink.ALBUM_TO_PHOTO_GRID),
          curve: Curve.Friction,
        }, (): void => {
          this.resetPageStatus();
          this.sideBarItemClickListener.onSideBarItemClick(SideBarType.HIGHLIGHT);
        })
      } else {
        this.resetPageStatus();
        this.sideBarItemClickListener.onSideBarItemClick(SideBarType.HIGHLIGHT);
      }
      return;
    }
    if (this.sideBarIndex === SideBarType.PORTRAIT) {
      this.resetPageStatus();
      this.isShowPortraitAlbumsView = true;
      return;
    }
    if (this.sideBarIndex === SideBarType.CLASSIFICATION) {
      this.resetPageStatus();
      this.isShowPhotoClassifieds = true;
      if (DeviceInfo.isPc()) {
        this.appBroadCast.emit(BroadCastConstants.LOAD_PORTRAIT_PAGE, []);
      }
      return;
    }
    if (this.sideBarIndex === SideBarType.SHOOTING) {
      this.resetPageStatus();
      this.isShowPhotoShooting = true;
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
    if (DeviceInfo.isPcOrTablet()) {
      animateToImmediately({
        duration: 0,
      }, (): void => {
        this.appBroadCast.emit(BroadCastConstants.HIDE_GRID_VIEW_ACTION_BAR, []);
      });
    }
    this.refreshPhotoGridView();

    // actionbar
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);
    // 整个相册宫格页透明度，Column
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
    Log.info(TAG, `sideBar onclick now data: ${albumInfo?.item}`);
  }

  private refreshPhotoGridView(): void {
    if (this.sideBarIndex === SideBarType.HIDDEN) {
      this.resetPageStatus();
      this.isShowPhotoHiddenView = true;
      return;
    }
    if (AppStorage.get<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW)) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_GRID_REFRESH, []);
    } else {
      this.resetPageStatus();
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, true);
      if (DeviceInfo.isPc()) {
        this.appBroadCast.emit(BroadCastConstants.LOAD_PORTRAIT_PAGE, []);
      }
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
    AppStorage.setOrCreate<boolean>(Constants.IS_SHOW_LOCATION_GRID, false);
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
    Log.info(TAG, `onCurrentIndexChange ${this.currentIndex}`);
    if (!this.isFreezeSelected) {
      let isSelectedOld: boolean = this.isSelected;
      this.isSelected = this.currentIndex === this.sideBarIndex;
      if (this.isSelected && !isSelectedOld) {
        this.albumOnClick(this.item, true);
      }
    }
    if (this.lastActiveIndex !== this.currentIndex && this.currentIndex === SIDE_BAR_ITEM_TIMELINE_INDEX) {
      // PAD模式切换相册时通知照片页更新相关状态
      this.appBroadCast?.emit(BroadCastConstants.TAB_CURRENT_INDEX_CHANGE, [this.currentIndex]);
    }
    this.lastActiveIndex = this.currentIndex;
  }

  // albumInfo item, etc. user album
  private checkIsAlbumItem(item: AlbumInfo | CustomItem): boolean {
    return item instanceof AlbumInfo;
  }

  private onSelectedChange(): void {
    if (DeviceInfo.isPc() && this.canContextMenuBind) {
      this.isShowMenu = this.isSelected;
      Log.info(TAG, `onSelectedChange ${this.isShowMenu}`);
    }
  }
}