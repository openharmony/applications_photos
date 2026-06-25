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
import lazy {
  ActionBarColorMode,
  ActionBarMode
} from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy {
  ColumnSize,
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  ScreenWidth,
  WindowMode
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MenuBarPopup, PopupStyle } from './MenuBarPopup';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { LongPressHintsDialog } from '@ohos/common/src/main/ets/default/view/dialog/LongPressHintsDialog';
import lazy { common } from '@kit.AbilityKit';
import lazy { ValueType } from '@ohos.data.ValuesBucket';
import lazy { ToolBarButton } from './ToolBarButton';
import lazy { AppBarController } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { ToolBarButtonFavor } from './ToolBarButtonFavor';
import lazy { display, LengthMetrics, SymbolGlyphModifier, window } from '@kit.ArkUI';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { FontUtil } from '@ohos/common/src/main/ets/default/utils/FontUtil';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { util } from '@kit.ArkTS';
import lazy { systemParameterEnhance } from '@kit.BasicServicesKit';
import lazy { CREATION } from '@ohos/common/src/main/ets/default/view/actionbar/CreationAction';
import lazy { VIDEO_SPLICING } from '@ohos/common/src/main/ets/default/view/actionbar/VideoSplicingAction';

/* instrument ignore file  */
/**
 * 100%，作为动态计算菜单栏元素宽度的基数
 */
const PERCENT_100: number = 100;

/**
 * 用于读取屏幕规避区域的下边距
 */
const LEFT_BLANK_BOTTOM: number = 3;

/**
 * 菜单栏元素个数阈值
 */
const TOOL_MENU_LIST_LENGTH_THRESHOLD: number = 4;

const DEFAULT_COUNT: number = -1;

const TAG: string = 'ToolBar';

/**
 * 平板侧边栏宽度
 */
const sideBarWidth: number = 240;
const FOCUS_DELAY: number = 300;

class LongPressGestureModifier implements GestureModifier {
  dialogController?: CustomDialogController
  action?: Action;
  updateResCallBack?: Function = (action: Action): void => {
  };

  constructor(dialogController?: CustomDialogController,
    action?: Action, updateResCallBack: Function = (action: Action): void => {
    }) {
    this.dialogController = dialogController;
    this.action = action;
    this.updateResCallBack = updateResCallBack;
  }

  applyGesture(event: UIGestureEvent) {
    if (this.dialogController !== undefined) {
      event.addGesture(
        new LongPressGestureHandler({ duration: 500 })
          .onAction((event: GestureEvent) => {
            this.updateResCallBack?.(this.action);
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
 * 工具栏
 */
@Component
export struct ToolBar {
  @Consume isShowBar: boolean;
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  @StorageLink('isFullMode') @Watch('updateFullMode') private isFullMode: boolean = getScreen().isFullMode();
  @Consume toolMenuList: Action[];
  @Prop private moreMenuList: Action[] = [];
  @Prop private creationMenuList: Action[] = [];
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('navigationBarHeight') @Watch('navigationBarHeightChange') private navigationBarHeight: number = 0;
  @StorageLink('navigationBarBottomHeight') @Watch('navigationBarHeightChange')
  private navigationBarBottomHeight: number = 0;
  onMenuClicked: Function = (): void => {
  };
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  private isFromPhotoBrowser: boolean = false;
  private isVisibilityText: boolean = false;
  private GRID_ALPHA: number = 1;
  private actionBarColorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  @Prop totalSelectedCount: number = -1;
  tipPopup: PopupStyle = new PopupStyle();
  @State private appBarController: AppBarController = new AppBarController();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldExpandChange') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink('getFoldStatus') @Watch('onFoldExpandChange') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  public isFoldableAlbumMultiChoice: boolean = false;
  @State textRes: Resource = $r('app.string.common_place_holder', '');
  @State iconRes: Resource = $r('app.string.common_place_holder', '');
  // 获取系统字体
  @StorageProp('currentFontSizeScale') fontSizeScale: number = 1;
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: LongPressHintsDialog({ textRes: this.textRes, iconRes: this.iconRes }),
    customStyle: true,
  });
  public foldableScreenTabBarPadding: number = getScreen().getWinWidth() / 8;
  @StorageLink('isCloseCompareTip') isCompareTip: boolean =
    AppStorage.get<boolean>(Constants.IS_CLOSE_COMPARE_TIP) as boolean ?? false;
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  @State listCardWidth: number = 0;
  private windowColumns: number = getScreen().getScreenColumns();
  // 收藏动效相关 triggerValue=-1，没有动效
  private triggerValue: number = -1;
  private triggerValueLastTime: number = -1;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @State private movingPhotoMoreList: Action[] = [];
  @State private isShowMovingPhotoMoreMenu: boolean = false;
  @StorageLink('targetItem') targetItem: MediaItem = new MediaItem();
  @Prop private showMovingPhotoCloseEffect: boolean = false;
  @Prop private movingPhotoEffectMode?: number = 0;
  private symbolCheckMark: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.checkmark')).fontSize('24vp');
  @StorageProp('currentColorMode') private currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  private readonly onPopupChangedFunc: Function = (event: PopupStyle): void => this.onPopupChanged(event);
  @State private isShowBindPopup: boolean = false;
  @State noticePopup: boolean = false;
  private triggerValueFunc: Function = (): void => this.triggerValueF();
  private updateResCallBack = (action: Action): void => this.updateRes(action);

  private triggerValueF(): void {
    this.triggerValue++;
  }

  /* instrument ignore next */
  private onWinSizeChanged(): void {
    this.windowColumns = getScreen().getScreenColumns();
    this.updateListCardWidth();
  }

  /* instrument ignore next */
  private async updateListCardWidth(): Promise<void> {
    let variables = await import('@ohos/tools/src/main/variables/ActionBarVar');
    let isShowSideBar: boolean = variables.ActionBarVar.isShowSideBar;
    if (this.windowColumns === ColumnSize.COLUMN_FOUR) {
      if (this.toolMenuList.length >= TOOL_MENU_LIST_LENGTH_THRESHOLD) {
        this.listCardWidth = getScreen().getWinWidth();
      } else {
        this.listCardWidth = getScreen().getColumnsWidthToolBar(ColumnSize.COLUMN_FOUR, isShowSideBar);
        Log.info(TAG, `listCardWidth-COLUMN_FOUR:${this.listCardWidth}`);
      }
    } else if (this.windowColumns === ColumnSize.COLUMN_EIGHT) {
      //pad sideBar
      /* instrument ignore next */
      if (DeviceInfo.isTablet() && isShowSideBar) {
        let newColumnNum: number = this.getColumnsSizeBysidebarWidth();
        Log.info(TAG, `newColumnNum:${newColumnNum}`);
        this.listCardWidth = this.getListCardWidthSideBar(newColumnNum, isShowSideBar);
      } else {
        if (this.toolMenuList.length >= TOOL_MENU_LIST_LENGTH_THRESHOLD) {
          this.listCardWidth = getScreen().getColumnsWidthToolBar(ColumnSize.COLUMN_EIGHT, isShowSideBar);
        } else {
          this.listCardWidth = getScreen().getColumnsWidthToolBar(ColumnSize.COLUMN_SIX, isShowSideBar);
          Log.info(TAG, `listCardWidth-COLUMN_EIGHT:${this.listCardWidth}`);
        }
      }
    } else if (this.windowColumns === ColumnSize.COLUMN_TWELVE) {
      this.listCardWidth = getScreen().getColumnsWidthToolBar(ColumnSize.COLUMN_EIGHT, isShowSideBar);
    } else {
      Log.error(TAG, `screenColumns is: ${this.windowColumns}`);
    }
  }

  private updateSideMargin(): number {
    return getScreen().getMarginToolBar();
  }

  /* instrument ignore next */
  private getColumnsSizeBysidebarWidth(): number {
    let columnNum: number = 0;
    let newWidth: number = getScreen().getWinWidth() - sideBarWidth;
    if (newWidth < ScreenWidth.WIDTH_MEDIUM) {
      columnNum = ColumnSize.COLUMN_FOUR;
    } else if (newWidth >= ScreenWidth.WIDTH_MEDIUM && newWidth < ScreenWidth.WIDTH_LARGE) {
      columnNum = ColumnSize.COLUMN_EIGHT;
    } else if (newWidth >= ScreenWidth.WIDTH_LARGE && newWidth < ScreenWidth.WIDTH_XLARGE) {
      columnNum = ColumnSize.COLUMN_TWELVE;
    } else {
      columnNum = ColumnSize.COLUMN_TWELVE;
    }
    return columnNum;
  }

  /* instrument ignore next */
  private getListCardWidthSideBar(columnNum: number, isSideBar: boolean): number {
    let listCardWidthTmp: number = 0;
    if (columnNum === ColumnSize.COLUMN_FOUR) {
      if (this.toolMenuList.length >= TOOL_MENU_LIST_LENGTH_THRESHOLD) {
        listCardWidthTmp = getScreen().getWinWidth() - sideBarWidth;
      } else {
        listCardWidthTmp = getScreen().getColumnsWidthToolBarByColumns(ColumnSize.COLUMN_FOUR, columnNum, isSideBar);
      }
    } else if (columnNum === ColumnSize.COLUMN_EIGHT) {
      if (this.toolMenuList.length >= TOOL_MENU_LIST_LENGTH_THRESHOLD) {
        listCardWidthTmp = getScreen().getColumnsWidthToolBarByColumns(ColumnSize.COLUMN_EIGHT, columnNum, isSideBar);
      } else {
        listCardWidthTmp = getScreen().getColumnsWidthToolBarByColumns(ColumnSize.COLUMN_SIX, columnNum, isSideBar);
      }
    } else {
      listCardWidthTmp = getScreen().getWinWidth();
    }
    return listCardWidthTmp;
  }

  aboutToAppear(): void {
    this.updateAppBarPadding();
    this.actionBarProp = this.createActionBar();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.updateListCardWidth();
    this.triggerValueLastTime = this.triggerValue;
    this.appBroadCast.on(BroadCastConstants.UPDATE_TRIGGER_VALUE, this.triggerValueFunc);
    getContext()?.eventHub.on(BroadCastConstants.ACTION_POPUP_SHOW_EVENT, this.onPopupChangedFunc);
  }

  aboutToDisappear(): void {
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.appBroadCast.off(BroadCastConstants.UPDATE_TRIGGER_VALUE, this.triggerValueFunc);
    getContext()?.eventHub.off(BroadCastConstants.ACTION_POPUP_SHOW_EVENT, this.onPopupChangedFunc);
  }

  private onPopupChanged(event: PopupStyle): void {
    this.tipPopup = event;
  }

  updateFullMode(): void {
    this.updateAppBarPadding();
  }

  private navigationBarHeightChange(): void {
    this.updateAppBarPadding();
  }

  /**
   * 当xxx变化时触发：根据参数实时刷新toolbar两侧的padding
   */
  private onFoldExpandChange(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    this.updateAppBarPadding();
  }

  private updateAppBarPadding(): void {
    let horizontalPadding: number = (this.isFoldExpanded && (this.toolMenuList.length === 3 ||
    this.isFoldableAlbumMultiChoice) && getScreen().getWinMode() === WindowMode.FULLSCREEN) ?
    this.foldableScreenTabBarPadding : (DeviceInfo.isTablet() &&
        !(this.toolMenuList.length < TOOL_MENU_LIST_LENGTH_THRESHOLD)) ? this.updateSideMargin() :
      AppBarStyles.TOOLBAR_PADDING;
    this.appBarController.padding = {
      left: horizontalPadding,
      right: horizontalPadding,
      bottom: this.isFullMode && !this.isVerdeFoldable ?
      px2vp(this.navigationBarHeight) : px2vp(this.navigationBarBottomHeight),
    }
  }

  /* instrument ignore next */
  public async isTipPermanentSet(isTip: ValueType): Promise<void> {
    Log.debug(TAG, `isTipsPermanentSet ${isTip}`);
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    await dataStore.putData(Constants.IS_CLOSE_COMPARE_TIP, isTip);
    await dataStore.flush();
  }

  private getIconStatus(menu: Action): boolean {
    return menu.actionID === VIDEO_SPLICING.actionID;
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
    .padding($r('app.float.immersive_compared_tip_padding_top'))
  }

  @Builder
  MenuItemBuilder(menu: Action, index: number) {
    MenuItem({ content: menu.textRes })
      .margin({ left: Constants.MENU_ITEM_START_MARGIN, right: Constants.MENU_ITEM_START_MARGIN })
      .padding({ left: Constants.MENU_ITEM_START_PADDING, right: Constants.MENU_ITEM_START_PADDING })
      .contentFont({ weight: 'medium' })
      .key(`ToolBarPopupBuilderTextOf${menu.componentKey}`)
      .enabled(!menu.isInvalid && (this.totalSelectedCount === DEFAULT_COUNT || this.totalSelectedCount !== 0))
      .onClick((): void => {
        this.onMenuClicked?.(menu);
      })
  }

  @Builder
  CreationMenu() {
    Menu() {
      /* instrument ignore next */
      ForEach(this.creationMenuList, (menu: Action, index: number): void => {
        MenuItem({
          symbolStartIcon: !this.getIconStatus(menu) ? new SymbolGlyphModifier(menu.iconRes) : undefined,
          startIcon: this.getIconStatus(menu) ? menu.iconRes : undefined,
          content: menu.textRes
        })
          .margin({ left: Constants.MENU_ITEM_START_MARGIN, right: Constants.MENU_ITEM_START_MARGIN })
          .padding({ left: Constants.MENU_ITEM_START_PADDING, right: Constants.MENU_ITEM_START_PADDING })
          .contentFont({ weight: 'medium' })
          .key(`ToolBarPopupBuilderTextOf${menu.componentKey}`)
          .enabled(!menu.isInvalid && (this.totalSelectedCount === DEFAULT_COUNT || this.totalSelectedCount !== 0))
          .onClick((): void => {
            this.onMenuClicked?.(menu);
          })
      })
    }
    .padding({
      left: Constants.MENU_LEFT_PADDING,
      right: Constants.MENU_LEFT_PADDING,
      top: Constants.MENU_TOP_PADDING,
      bottom: Constants.MENU_TOP_PADDING,
    })
    .width($r('app.float.more_menu_width'))
    .radius($r('sys.float.corner_radius_level10'))
    .key('ToolBar_Menu')
  }
  @Builder
  MoreMenu() {
    Menu() {
      /* instrument ignore next */
      ForEach(this.moreMenuList, (menu: Action, index: number): void => {
        this.MenuItemBuilder(menu, index);
      })
    }
    .menuItemDivider({
      strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
      color: $r('sys.color.ohos_id_color_list_separator'),
      startMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
      endMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
    })
    .padding({
      left: Constants.MENU_LEFT_PADDING,
      right: Constants.MENU_LEFT_PADDING,
      top: Constants.MENU_TOP_PADDING,
      bottom: Constants.MENU_TOP_PADDING,
    })
    .width($r('app.float.more_menu_width'))
    .radius($r('sys.float.corner_radius_level10'))
    .key('ToolBar_Menu')
  }

  build() {
    Row() {
      Row() {
        ForEach(this.toolMenuList, (menu: Action, index?: number): void => {
          if (menu.actionID === Action.MORE.actionID) {
            Button({ type: ButtonType.Normal, stateEffect: false }) {
              Column() {
                Row() {
                  ToolBarButton({
                    res: menu.iconRes,
                    action: menu,
                    isAutoTint: menu.isAutoTint,
                    colorMode: this.actionBarProp.getColorMode(),
                  })
                }
                .bindPopup(this.tipPopup.isShow && !this.isHorizontal, {
                  builder: this.noticeShowPopupBuilder(),
                  placement: Placement.Top,
                  autoCancel: true,
                  targetSpace: $r('app.float.stroke_1'),
                  mask: false,
                })

                if (this.isVisibilityText || !this.isFromPhotoBrowser) {
                  Row() {
                    Text(menu.textRes)
                      .draggable(false)
                      .key(`ToolBar_Text${menu.componentKey}`)
                      .fontSize($r('sys.float.Caption_M'))
                      .maxFontScale(1.0)
                      .minFontScale(1.0)
                      .fontFamily($r('app.string.id_text_font_family_regular'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor('sys.color.font_primary')
                  }.margin({ top: $r('app.float.nav_title_padding') })
                }
              }
              .key(`ToolBarButton${menu.componentKey}`)
              .justifyContent(FlexAlign.Center)
              .width(this.toolMenuList.length < TOOL_MENU_LIST_LENGTH_THRESHOLD ?
                `${PERCENT_100 / this.toolMenuList.length}%` :
                (DeviceInfo.isTablet() ?
                $r('app.float.tablet_crop_action_hot_zone') : $r('app.float.crop_action_hot_zone')))
              .height(Constants.PERCENT_100)
              .bindMenu(this.MoreMenu, DeviceInfo.isPc() ? {} : { placement: Placement.BottomRight })
              .accessibilityRole(AccessibilityRoleType.BUTTON)
            }
            .backgroundColor($r('app.color.transparent'))
            .borderRadius($r('sys.float.corner_radius_level4'))
          } else if (menu.actionID === CREATION.actionID) {
            Button({ type: ButtonType.Normal, stateEffect: false }) {
              Column() {
                Row() {
                  ToolBarButton({
                    res: menu.iconRes,
                    action: menu,
                    isAutoTint: menu.isAutoTint,
                    colorMode: this.actionBarProp.getColorMode(),
                  })
                }
                .bindPopup(this.tipPopup.isShow && !this.isHorizontal, {
                  builder: this.noticeShowPopupBuilder(),
                  placement: Placement.Top,
                  autoCancel: true,
                  targetSpace: $r('app.float.stroke_1'),
                  mask: false,
                })

                if (this.isVisibilityText || !this.isFromPhotoBrowser) {
                  Row() {
                    Text(menu.textRes)
                      .draggable(false)
                      .key(`ToolBar_Text${menu.componentKey}`)
                      .fontSize($r('sys.float.Caption_M'))
                      .maxFontScale(1.0)
                      .minFontScale(1.0)
                      .fontFamily($r('app.string.id_text_font_family_regular'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor('sys.color.font_primary')
                  }.margin({ top: $r('app.float.nav_title_padding') })
                }
              }
              .key(`ToolBarButton${menu.componentKey}`)
              .justifyContent(FlexAlign.Center)
              .width(this.toolMenuList.length < TOOL_MENU_LIST_LENGTH_THRESHOLD ?
                `${PERCENT_100 / this.toolMenuList.length}%` :
                (DeviceInfo.isTablet() ?
                $r('app.float.tablet_crop_action_hot_zone') : $r('app.float.crop_action_hot_zone')))
              .height(Constants.PERCENT_100)
              .bindMenu(this.CreationMenu, { placement: Placement.Top })
              .accessibilityRole(AccessibilityRoleType.BUTTON)
            }
            .backgroundColor($r('app.color.transparent'))
            .borderRadius($r('sys.float.corner_radius_level4'))
          } else {
            Button({ type: ButtonType.Normal, stateEffect: false }) {
              Column() {
                Row() {
                  if (Action.FAVORITE.actionID === menu.actionID ||
                    Action.NOT_FAVORITE.actionID === menu.actionID) {
                    ToolBarButtonFavor({
                      action: menu,
                      colorMode: this.actionBarProp.getColorMode(),
                      triggerValue: this.getTriggerValue(),
                    })
                  } else {
                    ToolBarButton({
                      res: menu.iconRes,
                      action: menu,
                      isAutoTint: menu.isAutoTint,
                      colorMode: this.actionBarProp.getColorMode(),
                    })
                  }
                }

                if (this.isVisibilityText || !this.isFromPhotoBrowser) {
                  Row() {
                    Text(menu.textRes)
                      .fontSize($r('sys.float.Caption_M'))
                      .maxFontScale(1.0)
                      .minFontScale(1.0)
                      .fontFamily($r('app.string.id_text_font_family_regular'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor(menu.actionID === Action.FAVORITE.actionID ?
                      $r('sys.color.ohos_id_color_toolbar_text_actived') : $r('sys.color.ohos_id_color_text_primary'))
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(1)
                      .minFontSize($r('sys.float.Caption_S'))
                      .maxFontSize($r('sys.float.Caption_M'))
                  }
                  .margin({ top: $r('app.float.nav_title_padding') })
                }
              }
              .justifyContent(FlexAlign.Center)
              .width(this.toolMenuList.length < TOOL_MENU_LIST_LENGTH_THRESHOLD ?
                `${PERCENT_100 / this.toolMenuList.length}%` :
                (DeviceInfo.isTablet() ?
                $r('app.float.tablet_crop_action_hot_zone') : $r('app.float.crop_action_hot_zone')))
              .height(DeviceInfo.isTablet() ?
              $r('app.float.tablet_crop_action_hot_zone') : $r('app.float.crop_action_hot_zone'))
            }
            .key(`ToolBarButton${menu.componentKey}`)
            .accessibilityLevel('yes')
            .accessibilityText(this.getToolBarButtonText(menu))
            .accessibilityRole(AccessibilityRoleType.BUTTON)
            .gestureModifier(this.getLongPressGestureModifier(menu))
            .onClick((): void => {
              this.onMenuClicked?.(menu);
              if (AccessibilityUtil.isOpenTouchGuideSync()) {
                this.touchGuideFocus(menu);
              }
            })
            .backgroundColor($r('app.color.transparent'))
            .borderRadius($r('sys.float.corner_radius_level4'))
            .enabled(!menu?.isInvalid)
          }
        }, (menu: Action) => menu.actionID.toString())
      }
      .width(this.toolMenuList.length < TOOL_MENU_LIST_LENGTH_THRESHOLD ? this.listCardWidth : Constants.PERCENT_100)
      .justifyContent(this.toolMenuList.length < TOOL_MENU_LIST_LENGTH_THRESHOLD ?
      FlexAlign.Center : FlexAlign.SpaceBetween)
      .height(Constants.ToolBarHeight)
    }
    .margin({
      bottom: 0,
      // bottom: this.isFromPhotoBrowser ? this.leftBlank[LEFT_BLANK_BOTTOM] : 0,
    })
    .justifyContent(FlexAlign.Center)
    .width(Constants.PERCENT_100)
    .padding(this.appBarController.padding)
    .backgroundColor(Color.Transparent)
    .onAppear((): void => {
      Log.info(TAG, 'onAppear,success showing ToolBar');
    })
  }

  // popup构造器定义弹框内容
  @Builder
  noticeShowPopupBuilder() {
    MenuBarPopup({ popupStyle: this.tipPopup });
  }

  private getToolBarButtonText(menu: Action): Resource {
    if (menu.componentKey === 'soundFilled') {
      return $r('app.string.sound_off_filled');
    } else if (menu.componentKey === 'sound_off_filled') {
      return $r('app.string.sound_filled');
    } else {
      return menu.textRes;
    }
  }

  private createActionBar(): ActionBarProp {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setMode(ActionBarMode.DETAIL_MODE).setColorMode(this.actionBarColorMode)
      .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
    return actionBarProp;
  }

  private getTriggerValue(): number {
    if (this.triggerValue === this.triggerValueLastTime) {
      return -1;
    } else {
      this.triggerValueLastTime = this.triggerValue;
      return this.triggerValue;
    }
  }

  private getLongPressGestureModifier(action: Action): LongPressGestureModifier {
    // 大字体时才绑定长按手势
    if (!action || this.fontSizeScale < FontUtil.LARGE_FONT_SIZE) {
      return new LongPressGestureModifier();
    }
    return new LongPressGestureModifier(this.dialogController, action, this.updateResCallBack);
  }

  private updateRes(action: Action): void {
    if (action) {
      this.textRes = action.textRes;
      this.iconRes = action.iconRes;
    }
  }

  /**
   * 菜单无障碍场景获焦
   */
  private touchGuideFocus(menu: Action): void {
    switch (menu.actionID) {
      case Action.FAVORITE.actionID:
      case Action.NOT_FAVORITE.actionID:
        AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_FAVOR, FOCUS_DELAY);
        break;
      case Action.VIDEO_PAUSE.actionID: // 暂停
        AccessibilityUtil.sendFocusAccessibilityEvent(`ToolBarButton${Action.VIDEO_PLAY.componentKey}`, FOCUS_DELAY);
        break;
      case Action.VIDEO_PLAY.actionID: // 播放
        AccessibilityUtil.sendFocusAccessibilityEvent(`ToolBarButton${Action.VIDEO_PAUSE.componentKey}`, FOCUS_DELAY);
        break;
      case Action.SOUND_FILLED.actionID: // 暂停
        AccessibilityUtil.sendFocusAccessibilityEvent(`ToolBarButton${Action.SOUND_OFF_FILLED.componentKey}`,
          FOCUS_DELAY);
      case Action.SOUND_OFF_FILLED.actionID: // 播放
        AccessibilityUtil.sendFocusAccessibilityEvent(`ToolBarButton${Action.SOUND_FILLED.componentKey}`,
          FOCUS_DELAY);
        break;
      default:
        break;
    }
  }
}