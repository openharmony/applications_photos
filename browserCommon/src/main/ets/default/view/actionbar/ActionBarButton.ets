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
import lazy {
  Action,
  ActionID,
  CustomRenderSubMenu,
  SubMenuParamType
} from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { common, ConfigurationConstant } from '@kit.AbilityKit';
import lazy { LongPressHintsDialog } from '@ohos/common/src/main/ets/default/view/dialog/LongPressHintsDialog';
import lazy {
  ActionBarColorMode,
  ActionBarMode
} from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { ValueType } from '@ohos.data.ValuesBucket';
import lazy { IndexFocusOrder } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { LengthMetrics, SymbolGlyphModifier, window } from '@kit.ArkUI';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { MenuBarPopup, PopupStyle } from './MenuBarPopup';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { FocusUtil } from '@ohos/common/src/main/ets/default/utils/FocusUtil';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataSource } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSource';
import lazy {
  SourceTypeAlbumDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/SourceTypeAlbumDataSource';
import lazy {
  AlbumSetDataSourceManager
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSourceManager';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';
import lazy { MediaOperationType } from '@ohos/common/src/main/ets/default/model/common/MediaOperationType';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { MORE_MENU_ITEM_HEIGHT } from '@ohos/common/src/main/ets/default/view/actionbar/MoreAction';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { ActionPopupManager } from '../../controller/ActionPopupManager';
import lazy uiObserver from '@ohos.arkui.observer';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { FontUtil } from '@ohos/common/src/main/ets/default/utils/FontUtil';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { util } from '@kit.ArkTS';
import lazy { systemParameterEnhance } from '@kit.BasicServicesKit';
import lazy { SelectMediaType } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { PopoverDialog, PopoverOptions } from '@ohos.arkui.advanced.Dialog';
import lazy { DeleteDialog } from '@ohos/common/src/main/ets/default/view/dialog/DeleteDialog';
import lazy { DialogCallback } from '@ohos/common/src/main/ets/default/model/common/DialogUtil';
import lazy { PositionParams } from '@ohos/common/src/main/ets/default/view/browserOperation/DeleteMenuOperation';
import lazy { ReportToBigDataUtil, BigDataConstants } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { CREATION } from '@ohos/common/src/main/ets/default/view/actionbar/CreationAction';
import lazy {
  VIDEO_SPLICING,
  VIDEO_SPLICING_INVALID
} from '@ohos/common/src/main/ets/default/view/actionbar/VideoSplicingAction';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuController';

/* instrument ignore file */
const TAG: string = 'ActionBarButton';
// 显示多选按钮动效持续时间
const SHOW_MULTI_SELECT_DURATION_TIME: number = 150;
// 隐藏多选按钮动效持续时间
const HIDDEN_MULTI_SELECT_DURATION_TIME: number = 150;
// 跟手弹窗宽度
const DELETE_POPOVER_DIALOG_WIDTH: number = 400;

const MORE_ACTION: string = 'TimelineActionMore';

const IS_HIDE_ALBUM_SHOW: string = 'isHideAlbumShow';

const storage: LocalStorage = LocalStorage.getShared();

const INFO_BUTTON_COMPONENT_KEY: string = 'Info';
const FAVOR_BUTTON_COMPONENT_KEY: string = 'Favor';
const BUTTON_ARR: string[] = ['Info', 'Favor', 'soundFilled', 'videoPlay', 'videoPause', 'sound_off_filled'];
const BUTTON_KEY_PREFIX = 'AccessibilityComponent';
const BUTTON_KEY_PREFIX_BROWSER = 'AccessibilityComponent_Browser';
const BUTTON_SHARE_PHOTO_BROWSER = 'PhotoBrowserActionBarButton';
const BUTTON_SHARE = 'ActionBarButton';
const BUTTON_BACK_CATEGORY = 'AccessibilityComponent_Category';
const SHARE_ANCHOR_POINT = 'shareAnchorPoint';
const TV_MORE_INFO_MENU_WIDTH = '272vp';
const TV_MORE_INFO_MENU_COLOR = '#E6FFFFFF'

let isEntered: boolean = false;

// 半透明
const HALF_OPACITY: number = 0.4;
const HALF_OPACITY_TV: number = 0.5;

export interface EventVisibility {
  isVisible: boolean;
}

/**
 * 长按手势属性刷新
 */
class LongPressGestureModifier implements GestureModifier {
  fontSizeScale?: number = 1;
  dialogController?: CustomDialogController | undefined
  updateResCallBack?: Function = (): void => {
  };

  constructor(dialogController?: CustomDialogController | undefined, fontSizeScale?: number,
    updateResCallBack: Function = (): void => {
    }) {
    this.dialogController = dialogController;
    this.fontSizeScale = fontSizeScale;
    this.updateResCallBack = updateResCallBack;
  }

  // 手势应用
  applyGesture(event: UIGestureEvent) {
    // 大字体模式下才需要绑定长按事件
    if (this.fontSizeScale && this.fontSizeScale >= FontUtil.LARGE_FONT_SIZE) {
      event.addGesture(
        new LongPressGestureHandler({ duration: 500 })
          .onAction((event: GestureEvent) => {
            this.updateResCallBack?.();
            this.dialogController?.open();
          })
          .onActionEnd((event: GestureEvent) => {
            this.dialogController?.close();
          })
      )
    }
  }
}

/**
 * 通用 ActionBar 按钮类，集成 action bar 中常用按钮
 */
@Component
export struct ActionBarButton {
  @LocalStorageLink('isActionBarColorNormal') private isActionBarColorNormal: boolean = true;
  private isLast: boolean = false;
  private length: number = -1;
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('IsCloudDriveInstalled') private isCloudDriveInstalled: boolean = false;
  @State res: Resource | undefined = undefined;
  public action: Action = Action.NONE;
  onMenuClicked: Function = (): void => {
  };
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public isAutoTint: boolean = true;
  // 是否连拍图片展示页面
  @Prop private isBurstPhotos: boolean = false;
  @Prop colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  @State popoverOptions: PopoverOptions = {
    builder: () => {
      this.delete();
    },
    width: DELETE_POPOVER_DIALOG_WIDTH,
    offset: {
      x: -px2vp(UiUtil.getResourceNumber($r('sys.float.margin_right'))),
    },
    arrowPointPosition: ArrowPointPosition.CENTER,
    autoCancel: false
  }
  @Provide dialogCallback: DialogCallback = {
    confirmCallback: (): void => {
    }, cancelCallback: (): void => {
    }
  };
  private showDeleteDialogFunc: Function =
    (deleteMessage: Resource[], confirmCallback: Function, cancelCallback: Function, isAlbumDelete: boolean,
      isExpandPositionParams: PositionParams): void => this.showDeleteDialog(
      deleteMessage, confirmCallback, cancelCallback, isAlbumDelete, isExpandPositionParams);
  @Provide({ allowOverride: 'dialogBroadCast' }) dialogBroadCast: BroadCast = new BroadCast();
  @Provide dialogMessage: Resource = $r('app.string.common_place_holder', '');
  @Provide dialogContent: Resource = $r('app.string.common_place_holder', '');
  @Provide isAlbumDelete: boolean = false;
  @StorageLink('isShowDeleteFollowDialog') isShow: boolean = false;
  @Prop moreMenuList: Action[] = [];
  @Prop creationMenuList: Action[] = [];
  @Prop moreMenuListPC: RightClickMenuGroup[] = [];
  @Prop flexibleMenuList: Action[] = [];
  @Prop actionMoreMenuList: Action[] = [];
  public isThirdSelectActionBar: boolean = false;
  @Prop totalSelectedCount: number = -1;
  @Prop private isGroupDayView: boolean = false;
  @State textRes: Resource = $r('app.string.common_place_holder', '');
  @State iconRes: Resource = $r('app.string.common_place_holder', '');
  @StorageLink('isPhotoGridFocused') isPhotoGridFocused: boolean = false;
  @LocalStorageLink('isShowPortraitPage') isShowPortraitPage: boolean = false;
  @Prop albumInfo: AlbumInfo | undefined;
  private dialogController: CustomDialogController | undefined = new CustomDialogController({
    builder: LongPressHintsDialog({ textRes: this.textRes, iconRes: this.iconRes }),
    customStyle: true,
  });
  tipPopup: PopupStyle = new PopupStyle();
  actionPopupManager: ActionPopupManager = new ActionPopupManager();
  // 获取系统字体
  @StorageProp('currentFontSizeScale') @Watch('fontSizeScaleChanged') fontSizeScale: number = 1;
  @StorageLink('isCloseCompareTip') isCompareTip: boolean =
    AppStorage.get<boolean>(Constants.IS_CLOSE_COMPARE_TIP) as boolean ?? false;
  /**
   * 是否方位过隐藏相册，访问过（false），未访问过（true）
   */
  @State isAccessHideAlbum: boolean = false;
  private isHideAlbumShow: boolean = true;
  @Prop @Watch('updateColorMode') isShowTransparent: boolean = false;
  @State isShowTip: boolean = false;
  @State isAccessibilityManuallyHideTip: boolean = false;
  @State isHover: boolean = false;
  @State isMoreMenuShow: boolean = false;
  @Prop selectMediaType: number;
  /**
   * 当前屏幕宽度
   */
  @State private windowLayoutWidth: number = getScreen().getWinLayoutWidth();
  private timer: number = -1;
  private bgColor: Resource = DeviceInfo.isPc() ?
  $r('app.color.transparent') : $r('sys.color.comp_background_tertiary');
  private immersiveColor: Resource = $r('sys.color.ohos_id_color_button_normal_dark');
  @Prop immersiveController: ImmersiveController;
  @Prop timeController: TimeController;
  @Link private isFirstUnHover: boolean;
  @Link private firstTimer: number;
  @Prop isPickerPhotoBrowser: boolean = false;
  private isShowHiddenGridView: boolean = false;
  private isImmersive: boolean = false;
  private isLeftIcon: boolean = false;
  //在选择模式下PC和phone浏览大图为true，其他场景为false
  private isThirdSelectPhoto?: boolean = false;
  private isFromCollage?: boolean = false;
  private isFromImmersiveCompared?: boolean = false;
  private isFromPhotoBrowser?: boolean = false;
  private isFromRealTime: boolean = false;
  private isSearchResultPage: boolean = false;
  private isFromPhotoGrid: boolean = false;
  private isTimelinePageActionBar: boolean = false;
  private isSearchPageFromCategory: boolean = false;
  @StorageLink(Constants.KEY_OF_IS_FROM_CATEGORY) private isFromCategory: boolean = false;
  @StorageLink(Constants.KEY_OF_IS_FROM_SHOOT_VIEW) private isFromShoot: boolean = false;
  @State actionMode: number = -1;
  @Prop triggerValue: number = -1;
  @StorageLink('cameraShotKey') private cameraShotKey: string | undefined = '';
  @State private isShowMenu: boolean = false;
  @State private movingPhotoMoreList: Action[] = [];
  @State private isShowMovingPhotoMoreMenu: boolean = false;
  @StorageLink('targetItem') targetItem: MediaItem | undefined = undefined;
  @Prop private showMovingPhotoCloseEffect: boolean = false;
  @Prop private movingPhotoEffectMode?: number = 0;
  private symbolCheckMark: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.checkmark')).fontSize('24vp');
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  @State private isMirrorMode: boolean = false;
  @State private isShowBindPopup: boolean = false;
  // 是否已经显示了比较提示
  private hasDisplayedCompareTip: boolean = false;
  @StorageLink('isShowSearchPage') private isShowSearchPage: boolean = false;
  @StorageLink('isShowPhotoSearchPage') isShowPhotoSearchPage: boolean = false;
  private albums: AlbumSetDataSource = AlbumSetDataSourceManager.getInstance().getDataSource();
  private sourceTypeAlbumsDataSource: SourceTypeAlbumDataSource =
    new SourceTypeAlbumDataSource(getContext(this), Constants.SOURCE_ALBUM_MIN_COUNT, new BroadCast());
  private onLoadPageListener = (name: string) => this.onLoadPage(name);
  private onTabChangeListener = (componentKey: string) => this.onTabChange(componentKey);
  private subMenuExpandingMode: SubMenuExpandingMode =
    DeviceInfo.isPc() ? SubMenuExpandingMode.SIDE_EXPAND : SubMenuExpandingMode.EMBEDDED_EXPAND;
  private updateResCallBack = (): void => this.updateRes();
  @State longPressModifier: LongPressGestureModifier =
    new LongPressGestureModifier(this.dialogController, this.fontSizeScale, this.updateResCallBack);

  private onWinSizeChanged(): void {
    this.windowLayoutWidth = getScreen().getWinLayoutWidth();
  }

  public async isTipPermanentSet(isTip: ValueType): Promise<void> {
    Log.debug(TAG, `isTipsPermanentSet ${isTip}`);
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    await dataStore.putData(Constants.IS_CLOSE_COMPARE_TIP, isTip);
    await dataStore.flush();
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear, actionID: ${this.action.actionID}`);
    WindowUtil.prepareWinRouter();
    this.getLanguageMode();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.appBroadCast.on(BroadCastConstants.SHOW_DELETE_POPOVER_DIALOG, this.showDeleteDialogFunc);
    this.tipPopup = this.actionPopupManager.get(this.action.componentKey);
    if (this.action.componentKey === this.tipPopup.action) {
      this.isShowBindPopup = this.tipPopup.isShow;
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.dialogController = undefined;
    this.isShow = false;
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.appBroadCast.off(BroadCastConstants.SHOW_DELETE_POPOVER_DIALOG, this.showDeleteDialogFunc);
  }

  updateColorMode(): void {
    if (this.isShowTransparent) {
      this.colorMode = ActionBarColorMode.TRANSPARENT;
    } else {
      this.colorMode = ActionBarColorMode.NORMAL;
    }
    this.isActionBarColorNormal = this.colorMode === ActionBarColorMode.NORMAL;
    AppStorage.setOrCreate<boolean>('isActionBarColorNormal', this.isActionBarColorNormal);
    Log.info(TAG, `updateColorMode, isActionBarColorNormal:${this.isActionBarColorNormal}`)
  }

  showBgColor(): string | Resource {
    //pc设备按钮正常情况下不加背板颜色
    /* instrument ignore next */
    if (DeviceInfo.isPc() && !this.isHover) {
      return $r('app.color.transparent')
    }
    /* instrument ignore next */
    if (DeviceInfo.isPc() && this.isThirdSelectPhoto && this.isHover) {
      return $r('sys.color.interactive_hover');
    }
    //选择模式下PC和phone展现黑色高亮背板
    if (this.isThirdSelectPhoto) {
      return $r('sys.color.ohos_id_color_button_normal_dark')
    }
    //沉浸式和默认
    if (this.isImmersive) {
      return this.immersiveColor
    }
    if (this.immersiveController?.enable) {
      return this.immersiveController.iconBgColor
    }
    return this.bgColor
  }

  private getButtonText(): Resource {
    if (this.action.actionID === Action.SEARCH_VALID.actionID) {
      return $r('app.string.search');
    }
    return this.action?.textRes;
  }

  private getButtonTextString(): string {
    // let context = DeviceInfo.isPc() ? LocalStorage.getShared()?.get<common.UIAbilityContext>('photoAbilityContext') :
    // LocalStorage.getShared()?.get<common.UIAbilityContext>('photoLibraryContext');
    // if (!context) {
    //   Log.error(TAG, `get invalid context`);
    //   return '';
    // }
    let result = this.getButtonTextStringEx(getContext());
    // if (result === '') {
    //   result = this.getButtonTextStringEx(getContext());
    // }
    Log.info(TAG, `getButtonTextString:${result}`);
    return result;
  }

  private getButtonTextStringEx(context: Context): string {
    let rscGetter: RscGetter = new RscGetter(context.resourceManager);
    if (this.action.actionID === Action.SEARCH_VALID.actionID) {
      return rscGetter.toString($r('app.string.search'));
    }
    if (this.action?.textRes) {
      return rscGetter.toString(this.action?.textRes);
    }
    return '';
  }

  private getActionMoreButtonBackgroundColor(): ResourceColor {
    if (this.isMoreMenuShow) {
      return $r('sys.color.interactive_pressed');
    }
    if (this.isImmersive) {
      return this.immersiveColor;
    }
    return this.immersiveController &&
    this.immersiveController.enable ? this.immersiveController.iconBgColor : this.bgColor;
  }

  @Builder
  compareTip() {
    Row() {
      Text($r('app.string.click_to_experience_the_image_compare_function'))
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
  SpliceTip() {
    Row() {
      Text($r('app.string.click_to_moving_photo_splice_function'))
        .fontSize($r('sys.float.Body_M'))
        .maxFontScale(Constants.FONT_SCALE_STRONG_SIZE)
    }
    .constraintSize({ maxWidth: $r('app.float.grid_more_height') })
    .padding($r('app.float.immersive_compared_tip_padding_top'))
  }

  @Builder
  hideAlbumTip() {
    Row() {
      Text($r('app.string.click_to_experience_the_hide_album_function'))
        .fontSize($r('sys.float.Body_M'))
        .onClick(() => {
          // 无障碍情况下双击消除气泡
          if (AccessibilityUtil.isOpenTouchGuideSync()) {
            this.isAccessibilityManuallyHideTip = true;
          }
        })
    }
    .padding({
      left: $r('app.float.immersive_compared_tip_padding_left'),
      top: $r('app.float.immersive_compared_tip_padding_top'),
      right: $r('app.float.immersive_compared_tip_padding_left'),
      bottom: $r('app.float.immersive_compared_tip_padding_top'),
    })
  }

  @Builder
  buttonTip() {
    Row() {
      Text(this.action.textRes)
        .fontSize($r('sys.float.Body_M'))
        .fontColor(this.isFromCollage || this.isFromImmersiveCompared ? $r('sys.color.ohos_id_color_text_hint_dark') :
        $r('sys.color.font_primary'))
    }
    .padding({
      left: $r('app.float.immersive_compared_tip_padding_left'),
      top: $r('app.float.immersive_compared_tip_padding_top'),
      right: $r('app.float.immersive_compared_tip_padding_left'),
      bottom: $r('app.float.immersive_compared_tip_padding_top'),
    })
  }

  isAlwaysEnable(menu: Action): boolean {
    const list = ['MultiSelected', 'gridDisplay'];
    return list.includes(menu.componentKey);
  }

  @Builder
  MenuItemBuilder(menu: Action, index: number) {
    MenuItem(menu.hasSubMenu ? {
      content: menu.textRes,
      builder: (): void => this.renderSubMenu(menu),
      symbolEndIcon: DeviceInfo.isPc() ?
      new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize($r('sys.float.Title_M')) : undefined,
    } : {
      content: menu.textRes,
      labelInfo: DeviceInfo.isPc() ? menu.shortKey : undefined,
      builder: this.isPcMoveMenu(menu) ? (): void => this.buildMoveSubMenu() : undefined,
      symbolEndIcon: this.isPcMoveMenu(menu) ?
      new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize($r('sys.float.Title_M')) : undefined,
    })
      .height(MORE_MENU_ITEM_HEIGHT)
      .margin({
        top: index > 0 && DeviceInfo.isPc() ? $r('sys.float.padding_level1') : undefined,
        left: this.menuItemMargin(),
        right: this.menuItemMargin(),
      })
      .padding({
        left: this.menuItemPadding(),
        right: this.menuItemPadding(),
      })
      .contentFont(this.menuFontStyle())
      .contentFontColor(DeviceInfo.isTv() ? TV_MORE_INFO_MENU_COLOR : undefined)
      .key(`ActionBarButton_Text_${menu.componentKey}`)
      .enabled(!menu.isInvalid && (this.totalSelectedCount === -1 || this.totalSelectedCount !== 0)
        || this.isAlwaysEnable(menu))
      .onClick((): void => {
        this.onMenuClicked?.(menu);
      })
      .width(DeviceInfo.isPc() ? 'auto' : undefined)
      .constraintSize({ minWidth: DeviceInfo.isPc() ? Constants.FORTH_MENU_ITEM_WIDTH_PC : undefined })
  }

  private menuFontStyle(): Font {
    return { weight: DeviceInfo.isTv() ? 666 : 'medium', size: DeviceInfo.isTv() ? '26vp' : undefined };
  }

  private menuItemMargin(): Length | undefined {
    return DeviceInfo.isTv() ? 0 : Constants.MENU_ITEM_START_MARGIN;
  }

  private menuItemPadding(): Length | undefined {
    return DeviceInfo.isTv() ? 0 : Constants.MENU_ITEM_START_PADDING;
  }

  @Styles
  menuItemCommArr() {
    .height(Constants.MENU_ITEM_HEIGHT_PC)
    .enabled(this.totalSelectedCount === -1 || this.totalSelectedCount !== 0)
    .width('auto')
    .constraintSize({ minWidth: Constants.FORTH_MENU_ITEM_WIDTH_PC })
  }

  private moveMenuBlock(albumInfo?: AlbumInfo): boolean {
    Log.info(TAG, `moveMenuBlock selectMediaType: ${this.selectMediaType}`);
    if (this.isFromPhotoBrowser) {
      // 获取大图图片类型；
      this.selectMediaType = AppStorage.get<number>("isSelectedItemMediaType") ?? 0;
    }
    let videoFlag: boolean = (albumInfo?.lpath === '/Pictures/Screenrecords' &&
      (this.selectMediaType === SelectMediaType.IMAGE || this.selectMediaType === SelectMediaType.IMAGE_VIDEO)); // 只有图片或图片视频都有，视频录制相册不显示；
    let screenshotsFlag: boolean = (albumInfo?.lpath === '/Pictures/Screenshots' &&
      (this.selectMediaType === SelectMediaType.VIDEO || this.selectMediaType === SelectMediaType.IMAGE_VIDEO)); // 只有视频或视频图片都有，截图相册不显示；
    return videoFlag || screenshotsFlag;
  }

  @Builder
  buildAlbumMenu(albumInfo?: AlbumInfo, index?: number) {
    if (albumInfo && !albumInfo?.isSystemAlbum &&
      albumInfo?.uri !== AppStorage.get<string>(Constants.KEY_OF_ALBUM_URI) && !this.moveMenuBlock(albumInfo)) {
      MenuItem({
        content: albumInfo?.albumName,
      })
        .key(`AlbumMenu_${albumInfo?.albumName}`)
        .contentFont({ weight: 'medium' })
        .menuItemCommArr()
        .onClick((): void => {
          Log.info(TAG, `buildAlbumMenu click: ${albumInfo?.albumName}`);
          if (this.isFromPhotoBrowser) {
            this.appBroadCast
              .emit(BroadCastConstants.PC_MEDIA_OPERATION_BROWSER,
                [MediaOperationType.MOVE, albumInfo.albumName, albumInfo.uri]);
          } else {
            this.appBroadCast
              .emit(BroadCastConstants.PC_MEDIA_OPERATION,
                [MediaOperationType.MOVE, albumInfo.albumName, albumInfo.uri]);
          }
        })
    } else {
      MenuItem()
        .visibility(Visibility.None)
        .height(Constants.MENU_ITEM_HEIGHT_PC)
    }
  }

  @Builder
  buildMoveSubMenu() {
    Menu() {
      MenuItemGroup() {
        MenuItem({
          content: Action.NEW_ALBUM.textRes,
        })
          .key(`AlbumMenu_${Action.NEW_ALBUM.textRes}`)
          .contentFont({ weight: 'medium' })
          .menuItemCommArr()
          .onClick((): void => {
            Log.info(TAG, `buildMoveSubMenu click: ${ActionID[Action.MOVE.actionID]}`);
            if (this.isFromPhotoBrowser) {
              this.appBroadCast
                .emit(BroadCastConstants.PC_MEDIA_OPERATION_BROWSER, [MediaOperationType.NEW]);
            } else {
              this.appBroadCast
                .emit(BroadCastConstants.PC_MEDIA_OPERATION, [MediaOperationType.NEW]);
            }
          })
        MenuItem()
          .focusable(false)
          .margin({
            bottom: $r('sys.float.padding_level2'),
          })
      }
      .width('auto')
      .constraintSize({ minWidth: Constants.FORTH_MENU_ITEM_WIDTH_PC })

      MenuItemGroup() {
        LazyForEach(this.albums as AlbumSetDataSource, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => {
          return this.getAlbumHashCode(item, index);
        });

        LazyForEach(this.sourceTypeAlbumsDataSource, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => {
          return this.getAlbumHashCode(item, index);
        });
      }
      .margin({ top: $r('sys.float.padding_level2') })
      .width('auto')
      .constraintSize({ minWidth: Constants.FORTH_MENU_ITEM_WIDTH_PC })
    }
  }

  private isPcMoveMenu(menu: Action): boolean {
    return menu.equals(Action.MOVE) && DeviceInfo.isPc();
  }

  private getAlbumHashCode(item: AlbumSetDataInfo, index?: number): string {
    if (!item?.data) {
      return TAG + String(index);
    }
    if (item.data.mediaItem) {
      return item.data.getHashCode() + item.data.mediaItem.getHashCode();
    }
    return item.data.getHashCode();
  }

  filterList(list: Action[][]) {
    return list.filter(item => item.length !== 0);
  }

  private hasMenuContent(): boolean {
    return !(DeviceInfo.isPc() && this.flexibleMenuList.length === 0 &&
      this.moreMenuListPC.length === 0 && this.actionMoreMenuList.length === 0);
  }

  private getIconStatus(menu: Action): boolean {
    return menu.actionID === VIDEO_SPLICING.actionID;
  }


  @Builder
  CreationMenu() {
    Menu() {
      if (this.creationMenuList.length > 0) {
        MenuItemGroup() {
          ForEach(this.creationMenuList, (menu: Action, index: number): void => {
            MenuItem({
              symbolStartIcon: !this.getIconStatus(menu) ? new SymbolGlyphModifier(menu.iconRes) : undefined,
              startIcon: this.getIconStatus(menu) ? menu.iconRes : undefined,
              content: menu.textRes
            })
              .margin({
                left: this.menuItemMargin(),
                right: this.menuItemMargin(),
              })
              .padding({
                left: this.menuItemPadding(),
                right: this.menuItemPadding(),
              })
              .contentFont(this.menuFontStyle())
              .key(`ActionBarButton_Text_${menu.componentKey}`)
              .onClick((): void => {
                this.onMenuClicked?.(menu);
              })
          })
          MenuItem() {
          }
          .focusable(false)
          .height($r('sys.float.padding_level2'))
        }
      }
    }
    .padding({
      left: Constants.MENU_LEFT_PADDING,
      right: Constants.MENU_LEFT_PADDING,
      top: this.menuTopBottomPadding(),
      bottom: this.menuTopBottomPadding(),
    })
    .onAppear((): void => {
      ActionBarVar.isMoreMenuShow = true;
      if (this.timer) {
        clearTimeout(this.timer);
      }
      this.isShowTip = false;
      this.isHover = false;
    })
    .onDisAppear((): void => {
      ActionBarVar.isMoreMenuShow = false;
    })
    .width(this.getMenuWidth())
    .radius(DeviceInfo.isTv() ? '32vp' : $r('sys.float.corner_radius_level10'))
    .key('ActionBarButton_Menu')
  }
  /**
   * 大图右上角更多菜单
   */
  @Builder
  MoreMenu() {
    Menu() {
      if (this.flexibleMenuList.length > 0) {
        MenuItemGroup() {
          ForEach(this.flexibleMenuList, (menu: Action, index: number): void => {
            this.MenuItemBuilder(menu, index);
          })
          MenuItem() {
          }
          .focusable(false)
          .height($r('sys.float.padding_level2'))
        }
        .width(DeviceInfo.isPc() ? 'auto' : undefined)
        .constraintSize({ minWidth: DeviceInfo.isPc() ? Constants.FORTH_MENU_ITEM_WIDTH_PC : undefined })
      }

      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        if (this.moreMenuListPC.length > 0) {
          this.moreMenuListPCBuilder();
        } else if (this.moreMenuList.length > 0) {
          this. MenuItemGroupBuilder();
        }
      } else {
        this.MenuItemGroupBuilder();
      }

      /* instrument ignore next */
      if (DeviceInfo.isPc() && this.actionMoreMenuList.length > 0) {
        MenuItemGroup() {
          MenuItem() {
          }
          .focusable(false)
          .height($r('sys.float.padding_level2'))

          ForEach(this.actionMoreMenuList, (menu: Action, index: number): void => {
            this.MenuItemBuilder(menu, index);
          })
        }
        .width(DeviceInfo.isPc() ? 'auto' : undefined)
        .constraintSize({ minWidth: DeviceInfo.isPc() ? Constants.FORTH_MENU_ITEM_WIDTH_PC : undefined })
      }
    }
    .menuItemGroupDivider(!DeviceInfo.isPc() ? undefined : {
      strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
      color: $r('sys.color.ohos_id_color_list_separator'),
      startMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN - Constants.MENU_ITEM_START_MARGIN),
      endMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN - Constants.MENU_ITEM_START_MARGIN),
    })
    .menuItemDivider(DeviceInfo.isPc() ? undefined : {
      strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
      color: $r('sys.color.ohos_id_color_list_separator'),
      startMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN - Constants.MENU_ITEM_START_MARGIN),
      endMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN - Constants.MENU_ITEM_START_MARGIN),
    })
    .padding({
      left: DeviceInfo.isTv() ? Constants.TV_MENU_ITEM_START_PADDING : Constants.MENU_LEFT_PADDING,
      right: DeviceInfo.isTv() ? Constants.TV_MENU_ITEM_START_PADDING : Constants.MENU_LEFT_PADDING,
      top: this.menuTopBottomPadding(),
      bottom: this.menuTopBottomPadding(),
    })
    .onAppear((): void => {
      ActionBarVar.isMoreMenuShow = true;
      if (this.timer) {
        clearTimeout(this.timer);
      }
      this.isShowTip = false;
      this.isHover = false;
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        FocusUtil.clearFocus(this.getUIContext()?.getFocusController());
      }
    })
    .onDisAppear((): void => {
      ActionBarVar.isMoreMenuShow = false;
    })
    .width(this.getMenuWidth())
    .radius(DeviceInfo.isTv() ? '32vp' : $r('sys.float.corner_radius_level10'))
    .key('ActionBarButton_Menu')
  }

  @Builder
  MenuItemGroupBuilder() {
    MenuItemGroup() {
      if (this.flexibleMenuList.length > 0) {
        MenuItem() {
        }
        .height($r('sys.float.padding_level2'))
        .focusable(false);
      }
      ForEach(this.moreMenuList, (menu: Action, index: number): void => {
        this.MenuItemBuilder(menu, index);
      });
      /* instrument ignore next */
      if (DeviceInfo.isPc() && this.moreMenuList.length > 0) {
        MenuItem() {
        }
        .height($r('sys.float.padding_level2'))
        .focusable(false);
      }
    }
    .width(DeviceInfo.isPc() ? 'auto' : undefined)
    .constraintSize({
      minWidth: DeviceInfo.isPc() ? Constants.FORTH_MENU_ITEM_WIDTH_PC : undefined
    });
  }

  @Builder
  MenuItemBuilderPC(menu: Action, isAddMarginBetweenItems: boolean = false, isLastItem: boolean = false,
    isEndItem: boolean = false) {
    MenuItem(menu.hasSubMenu ? {
      content: menu.textRes,
      builder: (): void => this.renderSubMenu(menu),
      symbolEndIcon: new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize($r('sys.float.Title_M')),
    } : {
      content: menu.textRes,
      labelInfo: menu.shortKey,
      builder: this.isPcMoveMenu(menu) ? (): void => this.buildMoveSubMenu() : undefined,
      symbolEndIcon: this.isPcMoveMenu(menu) ?
        new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize($r('sys.float.Title_M')) : undefined,
    })
      .height(MORE_MENU_ITEM_HEIGHT)
      .margin({
        top: isAddMarginBetweenItems ? $r('sys.float.padding_level1') : undefined,
        bottom: isLastItem || (this.actionMoreMenuList.length > 0 && isEndItem) ?
          $r('sys.float.padding_level2') : undefined,
        left: this.menuItemMargin(),
        right: this.menuItemMargin(),
      })
      .padding({
        left: this.menuItemPadding(),
        right: this.menuItemPadding(),
      })
      .contentFont(this.menuFontStyle())
      .key(`ActionBarButton_Text_${menu.componentKey}`)
      .enabled(!menu.isInvalid && (this.totalSelectedCount === -1 || this.totalSelectedCount !== 0)
        || this.isAlwaysEnable(menu))
      .onClick((): void => {
        this.onMenuClicked?.(menu);
      })
      .width('auto')
      .constraintSize({ minWidth:Constants.FORTH_MENU_ITEM_WIDTH_PC })
  }

  @Builder
  MenuItemBuilderNormal(menuGroup: RightClickMenuGroup, groupIndex: number, groupNumber: number) {
    MenuItemGroup() {
      ForEach(menuGroup.menuList, (menu: Action, index: number) => {
        // 只有每一个group最后的item才加 bottom间距，除了最后一个group
        this.MenuItemBuilderPC(menu, index > 0, index === menuGroup.menuList.length - 1 &&
          groupIndex !== groupNumber - 1, index === menuGroup.menuList.length - 1 &&
          groupIndex === groupNumber - 1);
      }, (item: Action) => `${item.componentKey}${item.actionID}`)
    }
    .width('auto')
    // 商务感规范 分割线上间距为4，但是第一个group默认上边距已有4 要排除
    .margin({
      top: groupIndex !== 0 ? $r('sys.float.padding_level2') : undefined,
    })
    .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })
  }

  @Builder
  moreMenuListPCBuilder() {
    ForEach(this.moreMenuListPC, ((menuGroup: RightClickMenuGroup, groupIndex: number): void => {
      this.MenuItemBuilderNormal(menuGroup, groupIndex, this.moreMenuListPC.length);
    }), (item: Action) => `${item.componentKey}${item.actionID}`)
  }

  private menuTopBottomPadding() {
    return DeviceInfo.isTv() ? Constants.TV_MENU_ITEM_START_PADDING : Constants.MENU_TOP_PADDING;
  }

  private getMenuWidth(): Length {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return 'auto';
    } else if (DeviceInfo.isTv()) {
      return TV_MORE_INFO_MENU_WIDTH;
    } else {
      return $r('app.float.more_menu_width');
    }
  }

  /**
   * 宫格、相册右上角更多菜单
   */
  @Builder
  MoreSettingMenu() {
    // todo Menu好像有问题，换成 Column后设置菜单可以正常显示 先用下面替换的Column
    // Menu() {
    //   this.buildActionMoreMenu();
    // }
    Column() {
      this.buildActionMoreMenu();
    }
    // .menuItemGroupDivider(DeviceInfo.isPc() ? undefined : {
    //   strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
    //   color: $r('sys.color.ohos_id_color_list_separator'),
    //   startMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
    //   endMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
    // })
    .padding({
      left: Constants.MENU_LEFT_PADDING,
      right: Constants.MENU_LEFT_PADDING,
      top: Constants.MENU_TOP_PADDING,
      bottom: Constants.MENU_TOP_PADDING,
    })
    .onAppear((): void => {
      ActionBarVar.isMoreMenuShow = true;
      this.isMoreMenuShow = true;
      if (this.timer) {
        clearTimeout(this.timer);
      }
      this.isShowTip = false;
      this.isHover = false;
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        FocusUtil.clearFocus(this.getUIContext()?.getFocusController());
      }
    })
    .onDisAppear((): void => {
      ActionBarVar.isMoreMenuShow = false;
      this.isMoreMenuShow = false;
    })
    .width(DeviceInfo.isPc() ? 'auto' : $r('app.float.more_menu_width'))
    // .radius($r('sys.float.corner_radius_level10'))
    .key('ActionBarButton_MoreSettingMenu')
    // .subMenuExpandingMode(this.subMenuExpandingMode)
  }

  @Builder
  renderSubMenu(menu: Action) {
    CustomRenderSubMenu({
      subMenuKey: menu.subMenuKey,
      subMenuExpandingMode: this.subMenuExpandingMode,
      albumInfo: this.albumInfo,
      onMenuClicked: (param: SubMenuParamType): void => this.onMenuClicked(menu, param),
    })
  }
  @Builder
  buildActionMoreMenu() {
    ForEach(this.actionMoreMenuList, (menu: Action, index: number): void => {
      MenuItemGroup() {
        MenuItem(menu.hasSubMenu ? {
          content: menu.textRes,
          builder: (): void => this.renderSubMenu(menu),
          symbolEndIcon: DeviceInfo.isPc() ?
          new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize($r('sys.float.Title_M')) : undefined,
        } :
          { content: menu.textRes, labelInfo: DeviceInfo.isPc() ? menu.shortKey : undefined }
        )
          .width($r('app.float.more_menu_width'))
          .height(MORE_MENU_ITEM_HEIGHT)
          .margin({
            top: index > 0 && DeviceInfo.isPc() ? $r('sys.float.padding_level1') : undefined,
            left: Constants.MENU_ITEM_START_MARGIN, right: Constants.MENU_ITEM_START_MARGIN,
          })
          .padding({ left: Constants.MENU_ITEM_START_PADDING, right: Constants.MENU_ITEM_START_PADDING })
          .contentFont({ weight: 'medium' })
          .key(`ActionBarButton_Text_${menu.componentKey}`)
          .onClick((): void => {
            this.onMenuClicked?.(menu);
          })
          // .width(DeviceInfo.isPc() && !menu.hasSubMenu ? 'auto' : undefined)
          .constraintSize({ minWidth: DeviceInfo.isPc() ? Constants.FORTH_MENU_ITEM_WIDTH_PC : undefined })
      }
    })
  }

  @Builder
  buildSymbolGlyph() {
    if (DeviceInfo.isPc() &&
      (this.action.actionID === Action.ACTION_MORE.actionID || this.action.actionID === Action.MULTISELECT.actionID ||
        this.action.actionID === Action.NEW.actionID)) {
      SymbolGlyph(this.res)
        .id(`More_Image_${this.action.componentKey}`)
        .draggable(false)
        .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') : $r('app.float.icon_size'))
        .fontColor(this.getSymbolGlyphColor())
        .opacity(!this.action.isInvalid ? 1 : this.isImmersive ?
          HALF_OPACITY : this.immersiveController && this.immersiveController.enable ?
          this.immersiveController.opacityDisabled : HALF_OPACITY)
        .symbolEffect(new ReplaceSymbolEffect(EffectScope.LAYER), this.getTriggerValue(this.action.actionID))
        .transition(this.getMoreTransitionEffect())
    } else {
      if (this.action?.actionID === VIDEO_SPLICING.actionID ||
        this.action?.actionID === VIDEO_SPLICING_INVALID.actionID) {
        // todo 临时解决上库，待资源上symbol后移除
        Image(this.res)
          .width($r('app.float.pc_actionbar_button_size'))
          .height($r('app.float.pc_actionbar_button_size'))
          .accessibilityText(this.action.textRes)
          .opacity(!this.action.isInvalid ? 1 : this.isImmersive ?
            HALF_OPACITY : this.immersiveController && this.immersiveController.enable ?
              this.immersiveController.opacityDisabled : HALF_OPACITY)
      } else {
        SymbolGlyph(this.res)
          .id(`More_Image_${this.action.componentKey}`)
          .accessibilityText(this.action.textRes)
          .draggable(false)
          .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_icon_inner_size') : $r('app.float.icon_size'))
          .fontColor([(this.immersiveController?.enable) ?
              this.action.isInvalid ? this.immersiveController.iconFillColorDisabled :
              this.immersiveController.iconFillColor : (this.colorMode === ActionBarColorMode.TRANSPARENT) ?
              Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor])
          .opacity(!this.action.isInvalid ? 1 : this.isImmersive ?
            HALF_OPACITY : this.immersiveController && this.immersiveController.enable ?
              this.immersiveController.opacityDisabled : HALF_OPACITY)
          .symbolEffect(new ReplaceSymbolEffect(EffectScope.LAYER), this.getTriggerValue(this.action.actionID))
      }

    }
  }

  private getSymbolGlyphColor(): Array<ResourceColor> {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return [this.action.fillColor];
    }
    return [(this.immersiveController?.enable) ?
      this.action.isInvalid ? this.immersiveController.iconFillColorDisabled :
      this.immersiveController.iconFillColor : (this.colorMode === ActionBarColorMode.TRANSPARENT) ?
      Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor];
  }

  private onLoadPage(name: string): void {
    Log.info(TAG, `NavigationConstants.LOAD_PAGE:${name}`);
    this.isAccessibilityManuallyHideTip = true;
  }

  private onTabChange(componentKey: string): void {
    Log.info(TAG, `onTagChange:${componentKey}`);
    if (componentKey !== Constants.COMPONENT_KEY_ALBUMS) {
      this.isAccessibilityManuallyHideTip = true;
    }
  }

  private getThirdSelectActionBarFontColor(): Array<ResourceColor> {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return [$r('sys.color.icon_primary')];
    }
    return this.action.actionID === Action.SELECTED.actionID ?
      [$r('app.color.white'), $r('app.color.black')] :
      [$r('app.color.selectPhotoBrowser_button_selected_color'),
        $r('app.color.selectPhotoBrowser_button_selected_color')];
  }

  @Builder
  ActionBarButtonBuilder(isInvalid?: boolean) {
    if (!this.isThirdSelectActionBar) {
      if (this.isAutoTint) {
        if (this.action.actionID !== Action.NONE.actionID) {
            this.buildSymbolGlyph();
        }
      } else {
        Stack() {
          SymbolGlyph(DeviceInfo.isPc() ?
            (this.action.actionID === Action.SELECTED.actionID ? $r('sys.symbol.checkmark_square_fill') :
            $r('sys.symbol.checkmark_square')) :
            (this.action.actionID === Action.SELECTED.actionID ? $r('sys.symbol.checkmark_circle_fill') :
            $r('sys.symbol.checkmark_circle')))
            .hitTestBehavior(HitTestMode.None)
            .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') :
            $r('app.float.selectPhotoBrowser_icon_size'))
            .renderingStrategy(DeviceInfo.isPc() ? SymbolRenderingStrategy.SINGLE :
            SymbolRenderingStrategy.MULTIPLE_COLOR)
            .fontColor(this.getThirdSelectActionBarFontColor())
        }
        .key('special_SymbolGlyph')
        .height(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') : $r('app.float.icon_size'))
        .width(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') : $r('app.float.icon_size'))
      }

    } else {
      if (this.isAutoTint) {
        if (this.action.actionID !== Action.NONE.actionID) {
          SymbolGlyph(this.res)
            .draggable(false)
            .fontSize(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') : $r('app.float.icon_size'))
            .fontColor([this.colorMode === ActionBarColorMode.TRANSPARENT ? Action
              .ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor])
        }
      } else {
        Stack() {
          SymbolGlyph(this.action.actionID === Action.SELECTED.actionID ? $r('sys.symbol.checkmark_circle_fill') :
          $r('sys.symbol.checkmark_circle'))
            .hitTestBehavior(HitTestMode.None)
            .fontSize(DeviceInfo.isTv() ?
            $r('app.float.tv_symbol_icon_size') : $r('app.float.selectPhotoBrowser_icon_size'))
            .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
            .fontColor(this.action.actionID === Action.SELECTED.actionID ?
              [$r('app.color.white'), $r('app.color.black')] :
              [$r('app.color.selectPhotoBrowser_button_selected_color'),
                $r('app.color.selectPhotoBrowser_button_selected_color')])
        }
        .height(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') : $r('app.float.icon_size'))
        .width(DeviceInfo.isTv() ? $r('app.float.tv_symbol_icon_size') : $r('app.float.icon_size'))
      }
    }

  }

  @Builder
  CreationButtonBuilder() {
    Stack() {
      Column() {
      } // 沉浸式下的按钮需要添加一个80%透明度的背板才能调出UX想要的效果
      .height($r('app.float.action_bar_button_height'))
      .width($r('app.float.action_bar_button_height'))
      .backgroundColor(this.immersiveController && this.immersiveController.enable ?
      this.immersiveController.columnBgColor :
      $r('app.color.transparent'))
      .borderRadius(DeviceInfo.isPc() ?
      $r('sys.float.corner_radius_level4') : $r('app.float.action_bar_button_height'))
      .visibility(DeviceInfo.isTv() ? Visibility.None : undefined)
      .bindPopup(this.isShowBindPopup, {
        builder: this.noticeShowPopupBuilder(),
        placement: Placement.Top,
        autoCancel: true,
        mask: false,
      })

      Column() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          this.ActionBarButtonBuilder();
        }
        .backgroundBlurStyle(this.isImmersive || this.immersiveController &&
        this.immersiveController.enable ? this.immersiveController.bgBlur : BlurStyle.NONE)
        .backgroundColor
        (this.isImmersive ? this.immersiveColor : this.immersiveController &&
        this.immersiveController.enable ? this.immersiveController.iconBgColor : this.bgColor)
        .height( $r('app.float.action_bar_button_height'))
        .width($r('app.float.action_bar_button_height'))
        .accessibilityText(this.getButtonText())
        .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_none'))
        .bindMenu(this.isShowMenu, this.CreationMenu,
          DeviceInfo.isPc() ? {
            showInSubWindow: false,
            onDisappear: () => {
              this.isShowMenu = false;
            }
          } : {
            placement: Placement.BottomRight,
            onDisappear: () => {
              this.isShowMenu = false;
            },
            offset: DeviceInfo.isTv() ? { y: 16 } : undefined
          })
        // onClick事件不能删，删掉“更多”按钮走焦走不上去
        .onClick((): void => {
          Log.info(TAG, 'MoreButton onClick')
          /* instrument ignore next */
          if (getScreen().screenIsLock()) {
            getScreen().screenUnlock((unlockResult: boolean) => {
              this.isShowMenu = unlockResult && this.hasMenuContent();
            });
          } else {
            this.isShowMenu = this.hasMenuContent();
          }
        })
      }
      .onClick((): void => {
      })
      .accessibilityLevel('no') // 外层Column和内层Button均有onClick事件，设置为no避免重复获焦
      .styleParams()
    }
    .backgroundColor($r('app.color.transparent'))
    .marginStyle()
  }
  @Builder
  MoreButtonBuilder() {
    Stack() {
      Column() {
      } // 沉浸式下的按钮需要添加一个80%透明度的背板才能调出UX想要的效果
      .height($r('app.float.action_bar_button_height'))
      .width($r('app.float.action_bar_button_height'))
      .backgroundColor(DeviceInfo.isPc() ? $r('app.color.transparent') :
        this.immersiveController && this.immersiveController.enable ? this.immersiveController.columnBgColor :
        $r('app.color.transparent'))
      .borderRadius(DeviceInfo.isPc() ?
      $r('sys.float.corner_radius_level4') : $r('app.float.action_bar_button_height'))
      .visibility(DeviceInfo.isTv() ? Visibility.None : undefined)
      .bindPopup(this.isShowBindPopup, {
        builder: this.noticeShowPopupBuilder(),
        placement: Placement.Top,
        autoCancel: true,
        mask: false,
      })

      Column() {
        Button({ type: DeviceInfo.isPc() ? ButtonType.Normal : ButtonType.Circle, stateEffect: true }) {
          this.ActionBarButtonBuilder();
        }
        .backgroundBlurStyle(this.isImmersive || DeviceInfo.isTv() ? BlurStyle.NONE : this.immersiveController &&
        this.immersiveController.enable ? this.immersiveController.bgBlur : BlurStyle.NONE)
        .backgroundColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_bg') :
          (this.isImmersive ? this.immersiveColor : this.immersiveController &&
          this.immersiveController.enable ? this.immersiveController.iconBgColor : this.bgColor))
        .height(DeviceInfo.isTv() ? $r('app.float.tv_icon_size') : $r('app.float.action_bar_button_height'))
        .borderColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_border_color') : undefined)
        .borderWidth(DeviceInfo.isTv() ? $r('app.float.tv_icon_border_width') : undefined)
        .width(DeviceInfo.isTv() ?
        $r('app.float.tv_action_bar_button_height') : $r('app.float.action_bar_button_height'))
        .accessibilityText(this.getButtonText())
        .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level10'))
        .bindMenu(this.isShowMenu, this.MoreMenu, {
            placement: Placement.Top,
            onDisappear: () => {
              this.isShowMenu = false;
            },
            offset: DeviceInfo.isTv() ? { y: 16 } : undefined
          })
        // onClick事件不能删，删掉“更多”按钮走焦走不上去
        .onClick((): void => {
          Log.info(TAG, 'MoreButton onClick')
          /* instrument ignore next */
          if (getScreen().screenIsLock()) {
            getScreen().screenUnlock((unlockResult: boolean) => {
              this.isShowMenu = unlockResult;
            });
          } else {
            this.isShowMenu = true;
          }
        })
      }
      .onClick((): void => {
      })
      .accessibilityLevel('no') // 外层Column和内层Button均有onClick事件，设置为no避免重复获焦
      .styleParams()
    }
    .backgroundColor($r('app.color.transparent'))
    .marginStyle()
  }

  @Builder
  noticeShowPopupBuilder() {
    MenuBarPopup({ popupStyle: this.tipPopup });
  }

  @Builder
  ActionMoreButtonBuilder() {
    Stack() {
      Column() {
      }
      .height(DeviceInfo.isTv() ?
      $r('app.float.tv_action_bar_button_height') : $r('app.float.action_bar_button_height'))
      .width(DeviceInfo.isTv() ? $r('app.float.tv_action_bar_button_height') : $r('app.float.action_bar_button_height'))
      .backgroundColor(DeviceInfo.isPc() ? $r('app.color.transparent') :
        this.immersiveController && this.immersiveController.enable ? this.immersiveController.columnBgColor :
        $r('app.color.transparent'))
      .borderRadius(DeviceInfo.isTv() ? $r('app.float.tv_action_bar_button_height') :
        (DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('app.float.action_bar_button_height')))
      .visibility(DeviceInfo.isTv() ? Visibility.None : undefined)

      Button({ type: DeviceInfo.isPc() ? ButtonType.Normal : ButtonType.Circle, stateEffect: true }) {
        this.ActionBarButtonBuilder();
      }
      .margin({ top: DeviceInfo.isTv() ? 3.5 : undefined, })
      .id(TAG + '_MoreButton')
      .height(DeviceInfo.isTv() ? $r('app.float.tv_icon_size') : $r('app.float.action_bar_button_height'))
      .width(DeviceInfo.isTv() ? $r('app.float.tv_icon_size') : $r('app.float.action_bar_button_height'))
      .accessibilityText(this.getButtonText())
      .backgroundBlurStyle(this.isImmersive || DeviceInfo.isTv() ? BlurStyle.NONE : this.immersiveController &&
      this.immersiveController.enable ? this.immersiveController.bgBlur : BlurStyle.NONE)
      .backgroundColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_bg') :
      this.getActionMoreButtonBackgroundColor())
      .borderColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_border_color') : undefined)
      .borderWidth(DeviceInfo.isTv() ? $r('app.float.tv_icon_border_width') : undefined)
      .bindMenu(this.isMoreMenuShow, this.MoreSettingMenu, {
          placement: Placement.BottomRight,
          onDisappear: () => {
            this.isMoreMenuShow = false;
          }
        })
      .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level10'))
      // onClick事件不能删，删掉“更多”按钮走焦走不上去
      .onClick((): void => {
        Log.info(TAG, 'ActionMoreButton onClick')
        /* instrument ignore next */
        this.isMoreMenuShow = true;
      })
      .styleParams()
    }
    .backgroundColor(Color.Transparent)
    .marginStyle()
  }

  @Builder
  OtherButtonBuilder() {
    Stack() {
      Column() {
      }
      .height(DeviceInfo.isTv() ?
      $r('app.float.tv_action_bar_button_height') : $r('app.float.action_bar_button_height'))
      .width(DeviceInfo.isTv() ? $r('app.float.tv_action_bar_button_height') : $r('app.float.action_bar_button_height'))
      .backgroundColor(DeviceInfo.isPc() ? $r('app.color.transparent') : this.immersiveController &&
      this.immersiveController.enable ? this.immersiveController.columnBgColor : $r('app.color.transparent'))
      .borderRadius(DeviceInfo.isTv() ? $r('app.float.tv_action_bar_button_height') :
        (DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('app.float.action_bar_button_height')))
      .visibility(DeviceInfo.isTv() ? Visibility.None : undefined)

      Column() {
        this.OtherButton();
      }
      .visibility(this.action?.isInvalid ? Visibility.None : Visibility.Visible)
      .styleParams()

      Column() {
        this.InvalidButton();
      }
      .visibility(this.action?.isInvalid ? Visibility.Visible : Visibility.None)
      .focusable(false)
      .accessibilityLevel('no')
      .invalidButtonStyleParams()
    }
    .key('special_stack')
    .height(DeviceInfo.isTv() ? $r('app.float.tv_action_bar_button_height') : $r('app.float.action_bar_button_height'))
    .backgroundColor($r('app.color.transparent'))
    .marginStyle()
  }

  @Builder
  ActionBarSelectButtonBuilder(isInvalid?: boolean) {
    Stack() {
      /* instrument ignore next */
      if (DeviceInfo.isTv()) {
        this.buildSymbolGlyph();
      } else {
        Text(this.action.textRes)
          .fontSize($r('sys.float.Body_M'))
          .fontColor((this.immersiveController?.enable) ?
            this.action.isInvalid ? this.immersiveController.iconFillColorDisabled :
            this.immersiveController.iconFillColor : (this.colorMode === ActionBarColorMode.TRANSPARENT) ?
            Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor)
          .minFontSize($r('sys.float.Caption_M'))
          .maxFontSize($r('sys.float.Body_M'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .maxFontScale(1.0)
          .wordBreak(WordBreak.BREAK_ALL)
      }
    }
    .constraintSize({
      maxWidth: this.windowLayoutWidth <= Constants.MULTISELECT_ACTION_WIN_SIZEO_TRUNCATION_WIDTH ?
      $r('app.float.select_actionbar_text_width_size') : undefined
    })
    .height(DeviceInfo.isTv() ? $r('app.float.tv_icon_size') : $r('app.float.icon_size'))
    .margin({
      left: DeviceInfo.isTv() ? 0 : $r('app.float.actionbar_text_icon_margin'),
      right: DeviceInfo.isTv() ? 0 : $r('app.float.actionbar_text_icon_margin'),
    })
  }

  @Builder
  OtherButton() {
    if (this.timeController ? this.timeController.isMultiSelectUseAnimation : false) {
      if (!DeviceInfo.isPc() &&
        (this.action.actionID === Action.MULTISELECT.actionID || this.action.actionID === Action.SELECT_ALL.actionID
          || this.action.actionID === Action.DESELECT_ALL.actionID)) {
        Button({ stateEffect: true }) {
          this.ActionBarSelectButtonBuilder();
        }
        .transition(this.getTransitionEffect())
        .visibility(this.getMultiSelectVisibility())
        .buildCommonStyles()
      } else {
        Button({ type: DeviceInfo.isPc() ? ButtonType.Normal : ButtonType.Circle, stateEffect: true }) {
          this.ActionBarButtonBuilder();
        }
        .transition(this.getTransitionEffect())
        .visibility(this.getMultiSelectVisibility())
        .width(this.action.componentKey !== undefined ? $r('app.float.action_bar_button_height') : 0)
        .buildCommonStyles()
      }
    } else if (!DeviceInfo.isPc() && !DeviceInfo.isTv() &&
      (this.action.actionID === Action.MULTISELECT.actionID || this.action.actionID === Action.SELECT_ALL.actionID
        || this.action.actionID === Action.DESELECT_ALL.actionID)) {
      Button({ stateEffect: true }) {
        this.ActionBarSelectButtonBuilder();
      }
      .buildCommonGestureStyles()
      .buildCommonStyles()
    } else {
      Button({ type: DeviceInfo.isPc() ? ButtonType.Normal : ButtonType.Circle, stateEffect: true }) {
        // 搜索一级界面的返回按钮
        this.ActionBarButtonBuilder();
      }
      .onClick((): void => {
        // 空白点击事件用来给返回按钮接收焦点
      })
      .width(DeviceInfo.isTv() ? $r('app.float.tv_action_bar_button_height') :
        (this.action.componentKey !== undefined ? $r('app.float.action_bar_button_height') : 0))
      .buildCommonGestureStyles()
      .buildCommonStyles()
    }
  }

  //区分大图场景的分享按钮和宫格场景的分享按钮，确保key值唯一
  private getShareButtonKey(): string {
    return this.isFromPhotoBrowser ? BUTTON_SHARE_PHOTO_BROWSER : BUTTON_SHARE;
  }

  @Styles
  buildCommonStyles(): void {
    .height(DeviceInfo.isTv() ? $r('app.float.tv_icon_size') :
      (this.action.componentKey !== undefined ? $r('app.float.action_bar_button_height') : 0))
    .key(`AccessibilityComponent${this.getKeyString()}` + this.action.componentKey)
    .accessibilityText(this.getButtonText())
    .enabled(!this.action?.isInvalid)
    .backgroundBlurStyle(this.isImmersive || DeviceInfo.isTv() ? BlurStyle.NONE : this.immersiveController &&
    this.immersiveController.enable ? this.immersiveController.bgBlur : BlurStyle.NONE)
    .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level10'))
    .onClick((): void => {
      this.onMenuClicked?.(this.action);
    })
    .onAppear(() => {
      /* instrument ignore next */
      if (DeviceInfo.isPc() && isEntered && BUTTON_ARR.includes(this.action.componentKey)) {
        focusControl.requestFocus(BUTTON_KEY_PREFIX_BROWSER + this.action.componentKey);
        isEntered = false;
      }
    })
    .onDisAppear((): void => {
      /* instrument ignore next */
      if (DeviceInfo.isPc() && isEntered && BUTTON_ARR.includes(this.action.componentKey)) {
        this.getUIContext().getFocusController().clearFocus();
      }
    })
    .onKeyPreIme((event: KeyEvent) => {
      // 详情按钮在enter或esc时，组件都会替换，需要重新申请获焦
      if (DeviceInfo.isPc() && (event.keyCode === KeyCode.KEYCODE_ENTER || event.keyCode === KeyCode.KEYCODE_ESCAPE) &&
        event.type === KeyType.Down && BUTTON_ARR.includes(this.action.componentKey)) {
        isEntered = true;
      }
      return false;
    })
    .stateStyles({
      pressed: {
        //选择模式下浏览大图，bar按下去黑色高亮
        .backgroundColor(this.isThirdSelectPhoto || this.isFromCollage || this.isFromImmersiveCompared ?
        $r('sys.color.ohos_id_color_click_effect_dark') : $r('sys.color.ohos_id_color_click_effect'))
      },
      normal: {
        .backgroundColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_bg') : this.showBgColor())
      }
    })
    .borderColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_border_color') : undefined)
    .borderWidth(DeviceInfo.isTv() ? $r('app.float.tv_icon_border_width') : undefined)
  }

  @Styles
  buildCommonGestureStyles(): void {
    .gestureModifier(this.longPressModifier)
  }

  @Builder
  InvalidButton() {
    if (DeviceInfo.isPhoneUx() && (this.action.actionID === Action.MULTISELECT_INV.actionID
      || this.action.actionID === Action.DESELECT_ALL_INVALID.actionID
      || this.action.actionID === Action.SELECT_ALL_INVALID.actionID)) {
      Column() {
        if (this.immersiveController?.isInImmersive) {
          Column() {
            this.ActionBarSelectButtonBuilder(true);
          }
          .accessibilityLevel('no')
        } else {
          Button({ stateEffect: true }) {
            this.ActionBarSelectButtonBuilder(true);
          }
          .transition(this.getTransitionEffect())
          .visibility(this.getMultiSelectVisibility())
          .accessibilityLevel('no')
          .buildCommonStyles()
        }
      }
      .accessibilityLevel('yes')
      .accessibilityText(this.getButtonText())
      .enabled(false)
      .height(DeviceInfo.isTv() ? $r('app.float.tv_icon_size') : (this.action.componentKey !== undefined ?
      $r('app.float.action_bar_button_height') : 0))
      .backgroundColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_bg') : this.getFiledColorForInvalid())
      .opacity(DeviceInfo.isTv() ? HALF_OPACITY_TV : undefined)
      .backgroundBlurStyle(this.isImmersive ? BlurStyle.NONE : this.immersiveController &&
      this.immersiveController.enable ? this.immersiveController.bgBlurDisabled : BlurStyle.NONE)
      .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level16'))
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_border_color') : undefined)
      .borderWidth(DeviceInfo.isTv() ? $r('app.float.tv_icon_border_width') : undefined)
    } else if (this.action.actionID === Action.SELECTED_INVALID.actionID ||
      this.action.actionID === Action.MATERIAL_SELECT_INVALID.actionID) {
      Button({ type: DeviceInfo.isPc() ? ButtonType.Normal : ButtonType.Circle, stateEffect: true }) {
        Stack() {
          SymbolGlyph(this.action.actionID === Action.SELECTED_INVALID.actionID ?
          $r('sys.symbol.checkmark_circle_fill') : $r('sys.symbol.checkmark_circle'))
            .hitTestBehavior(HitTestMode.None)
            .fontSize($r('app.float.selectPhotoBrowser_icon_size'))
            .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
            .fontColor(this.action.actionID === Action.SELECTED_INVALID.actionID ?
              [$r('app.color.white'), $r('app.color.black')] :
              [$r('app.color.selectPhotoBrowser_button_selected_color'),
                $r('app.color.selectPhotoBrowser_button_selected_color')])
        }
        .height($r('app.float.icon_size'))
        .width($r('app.float.icon_size'))
      }
      .width(this.action.componentKey !== undefined ? $r('app.float.action_bar_button_height') : 0)
      .buildCommonGestureStyles()
      .buildCommonStyles()
    } else {
      Column() {
        this.ActionBarButtonBuilder(true);
      }
      .enabled(false)
      .accessibilityLevel('yes')
      .accessibilityText(this.getButtonTextString())
      .height(DeviceInfo.isTv() ? $r('app.float.tv_icon_size') :
        (this.action.componentKey !== undefined ? $r('app.float.action_bar_button_height') : 0))
      .width(DeviceInfo.isTv() ? $r('app.float.tv_icon_size') :
        (this.action.componentKey !== undefined ? $r('app.float.action_bar_button_height') : 0))
      .backgroundColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_bg') : this.getFiledColorForInvalid())
      .opacity(DeviceInfo.isTv() ? HALF_OPACITY_TV : undefined)
      .backgroundBlurStyle(this.isImmersive || DeviceInfo.isTv() ? BlurStyle.NONE : this.immersiveController &&
      this.immersiveController.enable ? this.immersiveController.bgBlurDisabled : BlurStyle.NONE)
      .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level16'))
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderColor(DeviceInfo.isTv() ? $r('app.color.tv_icon_button_border_color') : undefined)
      .borderWidth(DeviceInfo.isTv() ? $r('app.float.tv_icon_border_width') : undefined)
      .accessibilityRole(AccessibilityRoleType.BUTTON)
    }
  }

  private getFiledColorForInvalid(): Resource | string {
    if (this.isGroupDayView) {
      return this.bgColor;
    }
    return (DeviceInfo.isPc() && !this.isHover) ? $r('app.color.transparent') :
      this.isImmersive ? this.immersiveColor : this.immersiveController && this.immersiveController.enable ?
      this.immersiveController.iconBgColorDisabled : this.bgColor;
  }

  @Styles
  private marginStyle(): void{
    .margin(i18n.isRTL(i18n.System.getSystemLanguage()) ? {
      left: this.isLeftIcon ? (DeviceInfo.isTv() ? $r('app.float.tv_icon_padding') : $r('sys.float.padding_level4')) :
        0,
      right: this.isLeftIcon ? 0 :
        (DeviceInfo.isTv() ? $r('app.float.tv_icon_padding') : $r('sys.float.padding_level4')),
    } : {
      left: this.isLeftIcon ? 0 :
        (DeviceInfo.isTv() ? $r('app.float.tv_icon_padding') : $r('sys.float.padding_level4')),
      right: this.isLeftIcon ? (DeviceInfo.isTv() ?
      $r('app.float.tv_icon_padding') : $r('sys.float.padding_level4')) :
        0,
    })
  }

  private handleKeyEvent(event: KeyEvent): void {
    Log.info(TAG, `actionBarButton onkeyEvnet ${this.isLast}`);
    if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_UP ||
      event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_DOWN ||
      (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT && this.action.componentKey ===
      Action.BACK.componentKey) ||
      (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT && this.isLast)
    ) {
      event.stopPropagation();
    }
    if (event.type === KeyType.Down && event.keyCode ===
    MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT && this.isLast) {
      focusControl.requestFocus('ActionBarButtonSearch');
    }
  }

  private getKeyString(): string {
    if (this.isShowSearchPage && this.isSearchPageFromCategory) {
      return '_Category';
    } else if (this.isFromRealTime) {
      return '_FromRealTime';
    } else if (this.isShowHiddenGridView) {
      return '_HiddenSecondary';
    } else if (this.isBurstPhotos) {
      return '_BurstBrowser';
    } else if (this.isFromPhotoBrowser) {
      return '_Browser';
    }
    return '';
  }

  @Styles
  private styleParams(): void {
    .focusable(this.checkActionBarFocusable())
    .tabIndex(this.isFromCollage ? 0 : IndexFocusOrder.ACTIONBAR_BUTTON)
    .key(this.getShareButtonKey() + this.action.componentKey)
    .onKeyEvent((event: KeyEvent) => {
      this.handleKeyEvent(event);
    })
    .onKeyPreIme((event: KeyEvent) => {
      if (this.action.componentKey === 'Back' && event.type === KeyType.Down &&
        event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
        focusControl.requestFocus('sideButton')
        return true;
      }
      return false;
    })
    .onHover((isHover: boolean, event: HoverEvent): void => {
      this.isHover = isHover;
      if (!event || !DeviceInfo.isPc()) {
        return;
      }
      if (event.stopPropagation === null || event.stopPropagation === undefined) {
        return;
      }
      event.stopPropagation();
      if (ActionBarVar.isMoreMenuShow) {
        return;
      }
      clearTimeout(this.timer);
      clearTimeout(this.firstTimer);
      if (isHover) {
        this.timer = setTimeout((): void => {
          this.isShowTip = true;
        }, this.isFirstUnHover ? 700 : 300);
        if (this.hasDisplayedCompareTip && this.isCompareTip) {
          this.isTipPermanentSet(false);
          AppStorage.setOrCreate<boolean>(Constants.IS_CLOSE_COMPARE_TIP, false);
        }
      } else {
        //是否处于提示后移开后的300ms中
        this.timer = setTimeout((): void => {
          this.isShowTip = false;
        }, this.isFirstUnHover ? 300 : 0);
        this.isFirstUnHover = false;
        this.firstTimer = setTimeout((): void => {
          this.isFirstUnHover = true;
        }, 300);
      }
    })
    .bindPopup(this.isShowTip && !this.action?.isInvalid, {
      builder: this.buttonTip,
      autoCancel: true,
      mask: false,
      enableArrow: false,
      //拼图对比模式下，需要背景框为黑色
      backgroundBlurStyle: this.isFromCollage || this.isFromImmersiveCompared ? BlurStyle.NONE :
      BlurStyle.COMPONENT_ULTRA_THICK,
      popupColor: this.isFromCollage || this.isFromImmersiveCompared ? $r('sys.color.ohos_id_color_background_dark') :
      Color.Transparent
    })
  }

  @Styles
  private invalidButtonStyleParams(): void {
    .key(`ActionBarButton_Invalid${this.action.componentKey}`)
    .onHover((isHover: boolean, event: HoverEvent): void => {
      this.isHover = isHover;
      if (!event || !DeviceInfo.isPc()) {
        return;
      }
      if (event.stopPropagation === null || event.stopPropagation === undefined) {
        return;
      }
      event.stopPropagation();
      if (ActionBarVar.isMoreMenuShow) {
        return;
      }
      clearTimeout(this.timer);
      clearTimeout(this.firstTimer);
      if (isHover) {
        this.timer = setTimeout((): void => {
          this.isShowTip = true;
        }, this.isFirstUnHover ? 700 : 300);
      } else {
        //是否处于提示后移开后的300ms中
        this.timer = setTimeout((): void => {
          this.isShowTip = false;
        }, this.isFirstUnHover ? 300 : 0);
        this.isFirstUnHover = false;
        this.firstTimer = setTimeout((): void => {
          this.isFirstUnHover = true;
        }, 300);
      }
    })
    .bindPopup(this.isShowTip && this.action?.isInvalid, {
      builder: this.buttonTip,
      autoCancel: true,
      mask: false,
      enableArrow: false,
      //拼图对比模式下，需要背景框为黑色
      backgroundBlurStyle: this.isFromCollage || this.isFromImmersiveCompared ? BlurStyle.NONE :
      BlurStyle.COMPONENT_ULTRA_THICK,
      popupColor: this.isFromCollage || this.isFromImmersiveCompared ? $r('sys.color.ohos_id_color_background_dark') :
      Color.Transparent
    })
    .onClick((): void => {
      Log.debug(TAG, 'onClick InvalidButton');
    })
  }

  @Builder
  delete() {
    DeleteDialog();
  }

  @Builder
  DeleteButtonBuilder() {
    Stack() {
      Column() {
      } // 沉浸式下的按钮需要添加一个80%透明度的背板才能调出UX想要的效果
      .height($r('app.float.action_bar_button_height'))
      .width($r('app.float.action_bar_button_height'))
      .backgroundColor(DeviceInfo.isPc() ? $r('app.color.transparent') :
        this.immersiveController && this.immersiveController.enable ? this.immersiveController.columnBgColor :
        $r('app.color.transparent'))
      .borderRadius(DeviceInfo.isPc() ?
      $r('sys.float.corner_radius_level4') : $r('app.float.action_bar_button_height'))

      Column() {
        Button({ type: DeviceInfo.isPc() ? ButtonType.Normal : ButtonType.Circle, stateEffect: true }) {
          this.ActionBarButtonBuilder();
        }
        .backgroundBlurStyle(this.isImmersive ? BlurStyle.NONE : this.immersiveController &&
        this.immersiveController.enable ? this.immersiveController.bgBlur : BlurStyle.NONE)
        .backgroundColor(this.isImmersive ? this.immersiveColor : this.immersiveController &&
        this.immersiveController.enable ? this.immersiveController.iconBgColor : this.bgColor)
        .height($r('app.float.action_bar_button_height'))
        .width($r('app.float.action_bar_button_height'))
        .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_none'))
        .onClick(() => {
          this.onMenuClicked?.(this.action)
        })
        .enabled(!this.action.isInvalid)
      }
      .focusable(true)
      .onClick((): void => {
      })
      .styleParams()
    }
    .backgroundColor($r('app.color.transparent'))
  }

  private showDeleteDialog(deleteMessage: Resource[], confirmCallback: Function, cancelCallback:
    Function, isAlbumDelete: boolean, isExpandPositionParams: PositionParams): void {
    Log.info(TAG, 'SHOW_DELETE_DIALOG');
    this.dialogMessage = deleteMessage[0];
    this.dialogContent = deleteMessage[1];
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.isAlbumDelete = isAlbumDelete;
    this.isShow = true;
  }

  build() {
    if (this.action.actionID === Action.MORE.actionID) {
      this.MoreButtonBuilder();
    } else if (this.action.actionID === CREATION.actionID) {
      this.CreationButtonBuilder();
    } else if (this.action.actionID === Action.ACTION_MORE.actionID) {
      this.ActionMoreButtonBuilder();
    } else if (this.action.actionID === Action.DELETE.actionID) {
      Column() {
        PopoverDialog({
          visible: this.isShow,
          popover: this.popoverOptions,
          targetBuilder: () => {
            this.DeleteButtonBuilder();
          },
        })
      }
      .marginStyle()
    } else {
      this.OtherButtonBuilder();
    }
  }

  private getMultiSelectVisibility(): Visibility {
    if (this.timeController ? this.timeController.isShowMultiSelect : false) {
      let visibility: Visibility = this.timeController.isShowMultiSelect ?
      Visibility.Visible : Visibility.Hidden;
      return this.action.actionID === Action.MULTISELECT.actionID ? visibility : Visibility.Visible;
    } else {
      return this.action.actionID === Action.MULTISELECT.actionID ? Visibility.Hidden : Visibility.Visible;
    }
  }

  private getTransitionEffect(): TransitionEffect {
    let isUseAnimation: boolean = this.timeController ? this.timeController.isMultiSelectUseAnimation : false;
    return TransitionEffect.asymmetric(this.action.actionID === Action.MULTISELECT.actionID && isUseAnimation ?
    TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: SHOW_MULTI_SELECT_DURATION_TIME }) :
    TransitionEffect.IDENTITY, this.action.actionID === Action.MULTISELECT.actionID && isUseAnimation ?
    TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: HIDDEN_MULTI_SELECT_DURATION_TIME }) :
    TransitionEffect.IDENTITY);
  }

  private getTriggerValue(actionId: number): number {
    if (actionId !== Action.FAVORITE.actionID && actionId !== Action.NOT_FAVORITE.actionID) {
      return -1;
    }
    return this.triggerValue;
  }

  private getMoreTransitionEffect(): TransitionEffect {
    return TransitionEffect.OPACITY.animation({ delay: 0, duration: 0 });
  }

  private isSelectAction(): boolean {
    return this.action.actionID === Action.MULTISELECT.actionID || this.action.actionID === Action.SELECT_ALL.actionID
      || this.action.actionID === Action.DESELECT_ALL.actionID;
  }

  private getLanguageMode(): void {
    this.isMirrorMode = UiUtil.isMirrorMode();
    Log.info(TAG, `isMirrorMode:${this.isMirrorMode}`);
  }

  private checkActionBarFocusable(): boolean {
    if (this.action.componentKey === 'removePortrait') {
      return !this.isShowPortraitPage && !this.isShowSearchPage;
    }
    if (this.action.componentKey === 'Back') {
      return !(this.isFromCategory && this.isFromShoot && this.isShowSearchPage && this.isSearchPageFromCategory);
    }
    if (!this.isShowSearchPage || this.actionMode === ActionBarMode.TOP_MODE
      || this.action.componentKey === 'Search') {
      return true;
    }
    if (this.isShowSearchPage && this.isFromRealTime) {
      return true;
    }
    return false
  }

  private updateRes() {
    this.iconRes = this.res as Resource;
    this.textRes = this.action.textRes;
  }

  private fontSizeScaleChanged() {
    this.longPressModifier =
      new LongPressGestureModifier(this.dialogController, this.fontSizeScale, this.updateResCallBack);
  }

  private clickMoreMenuReport(scanQRCode: boolean = false): void {
    let msg: Record<string, boolean> = {
      'scanQRCode_show': scanQRCode
    }
    ReportToBigDataUtil.report(BigDataConstants.CLICK_BROWSER_MORE_MENU, msg);
  }
}