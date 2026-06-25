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
import lazy { Action } from '../../../default/view/browserOperation/Action';
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
import lazy { SideBarItemClickListener, SideBarType } from '../../../../../../../feature/browser/src/main/ets/default/view/SideBar';
import lazy { AlbumSetInlineRenameMenuOperation } from './AlbumSetInlineRenameMenuOperation';
import lazy { CreateNewAlbumItem } from '../../../default/view/album/CreateNewAlbumItem';
import lazy { AlbumGrid } from '../../model/AlbumGrid';
import lazy measure from '@ohos.measure';
import lazy { ImmersiveController } from '../../../default/utils/ImmersiveController';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { AppBarStyles } from '../../../default/view/actionbar/AppBarStyles';
import lazy { MORE_MENU_ITEM_HEIGHT } from '../../../default/view/actionbar/MoreAction';
import lazy { AlbumDefine } from '../../../default/model/browser/AlbumDefine';
import lazy { KeyCode } from '@ohos.multimodalInput.keyCode';
import lazy { FocusUtil } from '../../../default/utils/FocusUtil';
import lazy { FoldUtil } from '../../../default/utils/FoldUtil';
import lazy { Configuration } from '@kit.ArkUI';
import lazy {
  RightClickMenuGroup,
  MenuController,
  MenuPopUpParams,
  PopType,
} from '../menu/MenuController';
import lazy { MenuPopUp } from '../menu/MenuView';
import lazy {
  getScreen,
  ScreenManager
} from '../../model/common/ScreenManager';

/* instrument ignore file */
const TAG: string = 'SideBarItem';
const SIDE_BAR_ITEM_TRANSITION_SCALE: number = 0.75;
const USER_ALBUM_INITIAL_INDEX: number = 100;
const paddingL4: number = px2vp(UiUtil.getResourceNumber($r('sys.float.padding_level4')));
// 重命名延迟获焦时间，避免内联非获焦到获焦样式改变跳闪
const RENAME_FOCUS_WAIT_TIME = 200;

@Component
export struct SideBarItem {
  // private sideBarController: SideBarController = SideBarManager.getInstance();
  @ObjectLink @Watch('onAlbumInfoChanged') albumSetDataInfo: AlbumSetDataInfo;
  @LocalStorageLink('isOpenBrowser') @Watch('isFreezeSelectedChange') isOpenBrowser: boolean = false;
  @State item: AlbumInfo = new AlbumInfo();
  private icon: Resource | undefined = undefined;
  private fillIcon: Resource | undefined = undefined;
  @Prop private hasStartDrag: boolean = true;
  @State private isShowMenu: boolean = false;
  @State private index: number = -1;
  private sideBarType: number = -1;
  @State private sideBarIndex: number = -1;
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  @Consume private broadCast: BroadCast;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Prop private controller: MenuController;
  // show control
  @Consume private isShowTimelinePage: boolean;
  @Consume private isShowPhotoHiddenView: boolean;
  @Link private isShowHiddenGridView: boolean;
  @Consume private isShowPhotoClassifieds: boolean;
  @Consume private isShowPhotoShooting: boolean;
  @Link private isShowSearchPage: boolean;
  @Consume private isShowPortraitAlbumsView: boolean;
  // z序控制走焦border
  @State private itemZIndex: number = 0;
  // for select
  @Prop @Watch('onCurrentIndexChange') private currentIndex: number;
  @State private isSelected: boolean = false;
  @State private isLastClick: boolean = false;
  @Prop private userAlbumInitialIndex: number = 100;
  @Prop private userIndexSelected: Set<number> = new Set();
  @Prop @Watch('onUserIndexSelectedChange') private userSelectCount: number = 0;
  private isUserAlbumSelected: Function = (index: number): boolean => {
    return false;
  };
  @Link private isFreezeSelected: boolean;
  @Prop private isFreezeAlbumInfoChanged: boolean = false;
  @State private isHover: boolean = false;
  private static readonly selectedItemBackgroundColor: number =
    ((UiUtil.getResourceNumber($r('sys.float.ohos_id_alpha_normal_bg')) * 255) << 24 & 0xff000000) |
      (UiUtil.getResourceColorSync($r('sys.color.ohos_id_color_emphasize')) & 0x00ffffff);
  // for menu
  @Consume private operationMenuList: Action[];
  @Prop private operationMenuListPC: RightClickMenuGroup[];
  private canContextMenuBind: boolean = false;
  // func
  private selectItem: Function = (index: number, isRightClick?: boolean): void => {
  };
  private deSelect: Function = (isCreatingNewAlbum: boolean): void => {
  };
  private onMenuClickedForSingleItem: Function = (action: Action, currentAlbum: AlbumInfo, index: number): void => {
  };
  private updateTitleFunc: (name: string, albumUri: string) => void =
    (name: string, albumUri: string): void => this.updateTitle(name, albumUri);
  private createAlbumSetInlineRenameMenuOperation: Function =
    (currentAlbum: AlbumInfo): AlbumSetInlineRenameMenuOperation | void => {
    };
  private onOperationStart: Function = (): void => {
  };
  private onOperationEnd: Function = (): void => {
  };
  private switchItemAuto: Function = (album: AlbumInfo, actionId: number): void => {
  };
  private resetIsNewCreated: Function = (index: number): void => {
  };
  private sideBarItemClickListener: SideBarItemClickListener = {
    onSideBarItemClick: (sideBarIndex: number) => {
    },
  };
  private onAlbumRenameFunc: Function = (): void => {
    this.onAlbumRename();
  }
  private onAlbumDeleteFunc: Function = (): void => {
    this.onAlbumDelete();
  }
  // renaming
  private isSubmitting: boolean = false;
  @State @Watch('onRenaming') private isRenaming: boolean = false;
  setIsRenamingAlbum: Function = (isRenamingAlbum: boolean): void => {
  };
  @State textInputText: ResourceStr = '';
  private albumSetInlineRenameMenuOperation: AlbumSetInlineRenameMenuOperation | undefined = undefined;
  // for creating new album
  @State private isNewCreated: boolean = false;
  @Link private isCreatingNewAlbum: boolean;
  // animation control
  @Prop private isSideBarItemAniOpen: boolean = false;
  private onSubmitFunc: Function = (): void => this.submit();
  // hover
  @State private isShowFullName: boolean = false;
  @State private isTextOver: boolean = false;
  @State private isPressed: boolean = false;
  // systemAlbumsCount
  @Prop private sysAlbumsCount: number = 0;
  @Prop @Watch('OnIsDragEnterChange') private dragEnterIndex: number = -1;
  @State private isDragEnter: boolean = false;
  private timer: number = -1;
  @State private firstTimer: number = -1;
  // 侧边栏当前宽度
  @Prop sideBarWidth: number;
  // 侧边栏之前的宽度
  private oldSideBarWidth: number = -1;

  private OnIsDragEnterChange(): void {
    this.isDragEnter = this.index === this.dragEnterIndex;
  }

  private onWinSizeChangedFunc: Function = (): void => {
    this.isPressed = false;
  }

  onRenaming(): void {
    if (this.isRenaming) {
      this.isSubmitting = false;
      Log.info(TAG, `isRenamingChange ${this.isRenaming}`);
      if (this.item instanceof AlbumInfo && this.isRenaming) {
        let albumSetInlineRenameMenuOperation: AlbumSetInlineRenameMenuOperation =
          this.createAlbumSetInlineRenameMenuOperation(this.item);
        if (albumSetInlineRenameMenuOperation) {
          this.albumSetInlineRenameMenuOperation = albumSetInlineRenameMenuOperation;
        }
      }
    }
  }

  // 判断是否打开大图,是否冻结侧边栏
  private isFreezeSelectedChange() {
    if (this.isOpenBrowser) {
      this.isFreezeSelected = true;
    } else {
      this.isFreezeSelected = false;
    }
  }

  private onAlbumInfoChanged(): void {
    if (this.isFreezeAlbumInfoChanged) {
      Log.info(TAG, 'onAlbumInfoChanged freeze return')
      return;
    }
    const tempItem: AlbumInfo | undefined = this.albumSetDataInfo?.data;
    if (this.albumSetDataInfo.index !== undefined) {
      let indexNew: number = this.albumSetDataInfo.index;
      if (indexNew !== this.index) {
        this.index = this.albumSetDataInfo.index;
        this.sideBarIndex = USER_ALBUM_INITIAL_INDEX + this.index;
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

  aboutToAppear(): void {
    if (this.isNewCreated) {
      this.isSideBarItemAniOpen = true;
      this.openPhotoGridView(this.item);
    }
    this.bindBroadCast();
    if (!this.icon) {
      this.icon = $r('sys.symbol.rectangle_on_rectangle');
    }

    if (!this.fillIcon) {
      this.fillIcon = $r('sys.symbol.rectangle_on_rectangle_fill');
    }
    if (this.item instanceof AlbumInfo) {
      this.textInputText = this.item.albumName;
    }
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    getScreen().on(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onWinSizeChangedFunc);
  }

  aboutToDisappear(): void {
    this.unbindBroadCast();
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    getScreen().off(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onWinSizeChangedFunc);
  }

  private bindBroadCast(): void {
    this.appBroadCast.on(BroadCastConstants.UPDATE_TITLE, this.updateTitleFunc);
    this.appBroadCast.on(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, this.onSubmitFunc);
    this.broadCast.on(BroadCastConstants.ALBUM_RENAME + this.item.uri, this.onAlbumRenameFunc);
    this.broadCast.on(BroadCastConstants.ALBUM_DELETE + this.item.uri, this.onAlbumDeleteFunc);
  }

  private unbindBroadCast(): void {
    this.appBroadCast.off(BroadCastConstants.UPDATE_TITLE, this.updateTitleFunc);
    this.appBroadCast.off(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, this.onSubmitFunc);
    this.broadCast.off(BroadCastConstants.ALBUM_RENAME + this.item.uri, this.onAlbumRenameFunc);
    this.broadCast.off(BroadCastConstants.ALBUM_DELETE + this.item.uri, this.onAlbumDeleteFunc);
  }

  private updateTitle(name: string, albumUri: string): void {
    if (albumUri === this.albumSetDataInfo.data.uri) {
      Log.info(TAG, `sideBarItem updateTitle ${name}`);
      this.albumSetDataInfo.data.albumName = name;
    }
  }

  private onDestroyTextInput(): void {
    this.isRenaming = false;
    this.setIsRenamingAlbum(false);
    this.albumSetInlineRenameMenuOperation = undefined;
    this.textInputText = this.item.albumName;
  }

  build() {
    Column() {
      /* instrument ignore next */
      if (DeviceInfo.isPc() && this.isNewCreated) {
        CreateNewAlbumItem({
          albumInfo: this.item,
          onOperationStart: (): void => this.onOperationStart(),
          onOperationEnd: (): void => this.onOperationEnd(),
          switchItemAuto: (album: AlbumInfo, actionId: number): void => this.switchItemAuto(album, actionId),
          deSelect: (isCreatingNewAlbum: boolean): void => this.deSelect(isCreatingNewAlbum),
          isCreatingNewAlbum: this.isCreatingNewAlbum,
          isSideBarItemAniOpen: this.isSideBarItemAniOpen,
          isNewCreated: this.isNewCreated,
          selectedItemBackgroundColor: SideBarItem.selectedItemBackgroundColor,
          index: this.index,
          resetIsNewCreated: (): void => {
            this.albumSetDataInfo.isNewCreated = false;
            this.resetIsNewCreated(this.albumSetDataInfo.index);
          },
        })
      } else {
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
    })) : TransitionEffect.IDENTITY)
    .id(this.item.getHashCode())
  }

  @Builder
  albumLabelItem() {
    Stack() {
      Row() {
      }
      .backgroundColor(this.getBackgroundColor(this.isSelected, this.isPressed, this.isHover, this.isDragEnter))
      .width('100%')
      .height(DeviceInfo.isPc() ? Constants.SIDE_BAR_ITEM_HEIGHT_PC : Constants.SIDE_BAR_ITEM_HEIGHT_TABLET)
      .borderRadius(DeviceInfo.isPc() ?
      $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level8'))

      this.buttonItem();
    }
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

  private handleButtonItemOnClick(isRightClick?: boolean): void {
    this.appBroadCast.emit(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, []);
    ImmersiveController.isInImmersive = false;
    this.appBroadCast.emit(BroadCastConstants.CLICK_SIDE_BAR_ITEM, []);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
    this.isFreezeSelected = false;
    this.selectItem?.(this.sideBarIndex, isRightClick);
  }

  @Builder
  buttonItem() {
    Row() {
      this.buttonIcon();
      if (this.isRenaming && this.sideBarType === SideBarType.USER && this.item instanceof AlbumInfo) {
        this.RenamingTextInput();
      } else {
        Text(this.getDisplayName(this.item))
          .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
          .fontWeight(DeviceInfo.isPc() && this.isSelected ? FontWeight.Bold : FontWeight.Medium)
          .fontColor(this.getTextColor(this.isSelected, this.isDragEnter))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
          .maxLines(1)
          .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .height($r('app.float.menu_height'))
          .layoutWeight(1)
          .margin({
            left: DeviceInfo.isPc() ? $r('sys.float.padding_level4') : $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level4'),
          })
          .onTouch((event: TouchEvent): void => {
            this.isShowFullName = false;
          })
          .onHover((isHover?: boolean, event?: HoverEvent) => {
            this.isHover = !!isHover;

            if (!this.isTextOver) {
              return;
            }
            clearTimeout(this.timer);
            clearTimeout(this.firstTimer);
            if (isHover) {
              this.timer = setTimeout((): void => {
                !this.hasStartDrag && (this.isShowFullName = true);
              }, ActionBarVar.isFirstUnHover ? 700 : 300);
            } else {
              //是否处于提示后移开后的300ms中
              this.timer = setTimeout((): void => {
                this.isShowFullName = false;
              }, ActionBarVar.isFirstUnHover ? 300 : 0);
              ActionBarVar.isFirstUnHover = false;
              this.firstTimer = setTimeout((): void => {
                ActionBarVar.isFirstUnHover = true;
              }, 300);
            }
          })
          .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
            if (this.sideBarWidth !== this.oldSideBarWidth && this.oldSideBarWidth !== -1) {
              this.updateTextWidth(newValue);
            }
            this.oldSideBarWidth = this.sideBarWidth;
          })
        this.buttonCount();
      }
    }
    .width('100%')
    .focusOnTouch(true)
    .id(`SideBarItem_${this.item.uri}`)
    .padding({
      left: $r('sys.float.padding_level4'),
      right: $r('sys.float.padding_level4'),
    })
    .borderRadius(DeviceInfo.isPc() ?
    $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level8'))
    .height(DeviceInfo.isPc() ? Constants.SIDE_BAR_ITEM_HEIGHT_PC : Constants.SIDE_BAR_ITEM_HEIGHT_TABLET)
    .bindContextMenu(this.operationMenuBuilder,
      this.canContextMenuBind ? ResponseType.LongPress : -1, this.menuOptions(ResponseType.LongPress))
    .bindContextMenu(this.operationMenuBuilder,
      this.canContextMenuBind ? ResponseType.RightClick : -1, this.menuOptions(ResponseType.RightClick))
    .onClick((event: ClickEvent): void => {
      /* instrument ignore next */
      if (DeviceInfo.isPc() && event.source !== 4) {
        this.getUIContext()?.getFocusController()?.clearFocus();
      }
      this.handleButtonItemOnClick();
    })
    .onMouse((event: MouseEvent) => {
      if (!DeviceInfo.isPc()) {
        return;
      }
      if (event.button === MouseButton.Right) {
        this.handleButtonItemOnClick(true);
      }
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

  private getTextColor(isSelected: boolean, isDragEnter: boolean): Resource {
    if (isDragEnter) {
      return $r('sys.color.ohos_id_color_text_primary_contrary');
    } else if (isSelected) {
      return $r('sys.color.font_primary');
    }
    return $r('sys.color.ohos_id_color_text_primary');
  }

  private getBackgroundColor(isSelected: boolean, isPressed: boolean,
    isHover: boolean, isDragEnter?: boolean): Resource | Color {
    if (isDragEnter) {
      return $r('sys.color.ohos_id_color_emphasize');
    } else if (isSelected) {
      return $r('sys.color.comp_emphasize_tertiary');
    } else if (isPressed) {
      return $r('sys.color.ohos_id_color_click_effect');
    } else if (isHover) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return Color.Transparent;
  }

  private handleOnTouch(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      this.isPressed = true;
    } else if (event.type === TouchType.Up) {
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
    .constraintSize({
      maxWidth: 400,
    })
  }

  private submit(): void {
    if (this.isSubmitting || !this.isRenaming) {
      return;
    }
    Log.info(TAG, 'renaming TextInput submit');
    this.isSubmitting = true;
    let name: string = typeof this.textInputText === 'string' ?
    this.textInputText : UiUtil.getResourceStringSync(this.textInputText);
    if (!this.albumSetInlineRenameMenuOperation || name === this.item.albumName) {
      this.onDestroyTextInput();
      return;
    }
    AlbumSetInlineRenameMenuOperation.checkIsNameValid(name).then((isValid: boolean): void => {
      if (!isValid || name.length === 0) {
        this.onDestroyTextInput();
        return;
      }
      this.albumSetInlineRenameMenuOperation?.onInlineRenameSubmit(name).then((isSuccess: boolean): void => {
        if (isSuccess) {
          this.item.albumName = name;
        }
        this.onDestroyTextInput();
      })
    })
  }

  @Builder
  RenamingTextInput() {
    TextInput({
      text: $$this.textInputText,
    })
      .draggable(false)
      .onSubmit((): void => {
        this.submit();
      })
      .onAppear((): void => {
        setTimeout((): void => {
          focusControl.requestFocus(`creatingNewAlbum_TextInput_${this.index}`);
        }, RENAME_FOCUS_WAIT_TIME)
      })
      .onBlur((): void => {
        this.submit();
      })
      .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
      .fontWeight(FontWeight.Medium)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
      .maxLines(1)
      .barState(BarState.Off)
      .style(TextInputStyle.Inline)
      .height(Constants.SIDE_BAR_ITEM_HEIGHT_PC)
      .backgroundColor(Color.Transparent)
      .layoutWeight(1)
      .padding({ left: $r('sys.float.padding_level4') })
      .key(`creatingNewAlbum_TextInput_${this.index}`)
      .maxLength(Constants.RENAME_MAX_LENGTH)
      .onChange((value: string): void => {
        if (value?.length >= Constants.RENAME_MAX_LENGTH) {
          UiUtil.showToast($r('app.string.Maximum_length_reached'));
        }
      })
  }

  @Styles
  imageBorderStyle() {
    .borderStyle(BorderStyle.Solid)
    .borderWidth(1)
    .borderColor($r('sys.color.mask_sixth'))
    .borderRadius($r('sys.float.corner_radius_level2'))
  }

  @Builder
  buttonIcon() {
    if (this.item.coverUri) {
      Column() {
        Image(this.item.coverUri)
          .draggable(false)
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
          .objectFit(ImageFit.Cover)
          .edgeAntialiasing(DeviceInfo.isHym() ? 0.4 : 0)
          .imageBorderStyle()
          .onComplete((): void => {
            Log.info(TAG, `Draw the image, uri: ${this.item.coverUri}`);
          })
          .onError((event: ImageError): void => {
            Log.error(TAG, `album is empty or its cover is error, path: ${this.item.coverUri}, ` +
              `${AlbumDefine.getAnonymizeAlbumName(this.item.albumName)}, error: ${event.message}`);
          })
      }
      .clip(true)
      .border({
        width: $r('sys.float.outline_small'),
        color: $r('app.color.album_card_border_color'),
        radius: $r('sys.float.corner_radius_level2'),
      })
    } else {
      this.customSymbol();
    }
  }

  @Builder
  buttonCount() {
    Column() {
      Text(`${this.item.count ?? 0}`)
        .fontColor(this.isDragEnter ? $r('sys.color.ohos_id_color_text_secondary_contrary') :
        $r('sys.color.ohos_id_color_text_secondary'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
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
  }

  private getSymbolColor(isSelected: boolean, isDragEnter: boolean): Resource {
    if (isDragEnter) {
      return $r('app.color.icon_default_color_contrary');
    } else if (isSelected) {
      return $r('sys.color.icon_primary');
    }
    return $r('sys.color.ohos_id_color_text_secondary');
  }

  // 切换相册
  private albumOnClick(album: AlbumInfo, isOpenPhotoGridView: boolean = false): void {
    this.isShowSearchPage = false;
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_FROM_CATEGORY, false);
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_FROM_SHOOT_VIEW, false);
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.releaseAppKeyForGRL();
      this.isShowPhotoHiddenView = false;
      this.isShowHiddenGridView = false;
    }
    if (this.isSelected && !isOpenPhotoGridView) {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_IMMERSIVE_STATUS_BAR_COLOR, []);
      return;
    }
    Log.info(TAG, `sideBarItem onclick openPhotoGridView ${this.currentIndex} ${album.uri}`);
    this.openPhotoGridView(album);
    return;
  }

  private openPhotoGridView(album: AlbumInfo): void {
    Log.info(TAG, 'openPhotoGridView');
    let albumInfo: ParamAlbumInfo = { item: JSON.stringify(album) };
    AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, albumInfo);
    // AlbumGrid.firstItem = album?.mediaItem?.data;
    AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_URI, album.uri);
    AppStorage.setOrCreate<string>('focusPosition', '');

    /* instrument ignore next */
    if (DeviceInfo.isPcOrTablet()) {
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

  private getDisplayName(item: AlbumInfo): Resource | string | undefined {
    if (!item) {
      return '';
    }
    let res: Resource | undefined = UiUtil.getDisplayNameResourceByAlbumInfo(item);
    return res ?? item.albumName;
  }

  /**
   * 当前选中用户相册数目发生变化
   * */
  private onUserIndexSelectedChange(): void {
    if (this.isFreezeSelected) {
      return;
    }
    this.isSelected = this.isUserAlbumSelected(this.sideBarIndex);
    Log.info(TAG, `selectCountChange onUserIndexSelectedChange： ${this.sideBarIndex} isSelected：${this.isSelected}`);
  }

  private onCurrentIndexChange(): void {
    if (this.isFreezeSelected) {
      return;
    }
    let isLastClickOld: boolean = this.isLastClick;
    this.isSelected = this.isUserAlbumSelected(this.sideBarIndex);
    this.isLastClick = this.currentIndex === this.sideBarIndex;
    Log.info(TAG, `selectCountChange onCurrentIndexChange： ${this.sideBarIndex} isSelected：${this.isSelected}`);
    if (this.isLastClick && !isLastClickOld && !this.hasStartDrag) {
      this.albumOnClick(this.albumSetDataInfo?.data, true);
    }
  }

  private onAlbumRename(): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.isFreezeSelected = false;
      this.selectItem?.(this.sideBarIndex);
      this.setIsRenamingAlbum(true);
      this.isRenaming = true;
      if (this.isSelected) {
        this.appBroadCast.emit(BroadCastConstants.UPDATE_IMMERSIVE_STATUS_BAR_COLOR, []);
      }
      return;
    }
    this.onMenuClickedForSingleItem?.(Action.RENAME_ALBUM, this.item, this.index);
  }

  private onAlbumDelete(): void {
    this.isSideBarItemAniOpen = true;
    this.onMenuClickedForSingleItem?.(Action.DELETE_ALBUM, this.item, this.index);
  }

  private getTextRes(action: Action) {
    if (action.actionID === Action.RENAME.actionID) {
      return Action.RENAME_ALBUM.textRes;
    }
    return action.textRes;
  }

  @Builder
  MenuItemBuilder(action: Action, isAddMarginBetweenItems: boolean = false) {
    MenuItem({ content: this.getTextRes(action), labelInfo: DeviceInfo.isPc() ? action.shortKey : undefined })
      .key(`SideBarMenuOperation_${action.componentKey}`)
      .height(MORE_MENU_ITEM_HEIGHT)
      .margin({ top: isAddMarginBetweenItems && DeviceInfo.isPc() ? $r('sys.float.padding_level1') : undefined })
      .onClick((): void => {
        if (action.actionID === Action.RENAME.actionID) {
          this.onAlbumRename();
          return;
        }
        if (action.actionID === Action.DELETE_ALBUM.actionID) {
          this.onAlbumDelete();
          return;
        }
      })
      .onKeyPreIme((event: KeyEvent) => {
        if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_ENTER &&
          action.actionID === Action.DELETE_ALBUM.actionID) {
          FocusUtil.activateFocus(this.getUIContext()?.getFocusController());
        }
        return false;
      })
      .width(DeviceInfo.isPc() ? 'auto' : undefined)
      .constraintSize({ minWidth: DeviceInfo.isPc() ? Constants.MENU_ITEM_WIDTH_PC : undefined })
  }

  private onMenuClick(action: Action): void {
    if (action.actionID === Action.RENAME_ALBUM.actionID) {
      this.onAlbumRename();
      return;
    }
    if (action.actionID === Action.DELETE_ALBUM.actionID) {
      this.onAlbumDelete();
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
    if (DeviceInfo.isPc()) {
      MenuPopUp({
        controller: this.controller,
        menuPopUpParams: this.getMenuPopUpParams(),
      })
        .key('SidBarItem_Menu')
    } else {
      Menu() {
        ForEach(this.operationMenuList, (action: Action, index: number) => {
          MenuItemGroup() {
            this.MenuItemBuilder(action);
          }
        })
      }
      .key('SidBarItem_Menu')
    }
  }

  private menuOptions(menuMode: number): ContextMenuOptions {
    switch (menuMode) {
      case ResponseType.LongPress:
        // longpress
        return {
          aboutToAppear: (): void => {
            this.handleButtonItemOnClick();
          },
          onAppear: (): void => {
            Log.info(TAG, `MenuListShow: ${this.isShowMenu}`);
          },
          aboutToDisappear: (): void => {
            this.isShowMenu = false;
          },
        }
      case ResponseType.RightClick:
        return {
          aboutToAppear: (): void => {
            this.isShowFullName = false;
          },
          onAppear: (): void => {
            Log.info(TAG, 'MenuListShow');
          },
        }
    }
    return {};
  }
}