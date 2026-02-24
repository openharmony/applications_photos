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
import settings from '@ohos.settings';
import {
  App,
  Asset,
  BaseEditor,
  ButtonBubble,
  CropAttr,
  DEVICE_FOLD_STATUS,
  DeviceUtil,
  EDITOR_STATUS_BAR_HEIGHT_KEY,
  EditorMsg,
  EditorParams,
  Event,
  HiLog,
  SCREEN_ORIENTATION_PORTRAIT,
  ScreenManager,
  TopBarModel,
  UiUtil,
  UndoRedoInfo,
  Constants,
  AccessibilityManager,
  MosaicAttr
} from '@oh-image-editor/editor-common';
import { ExportProgressDialog } from '../common/dialog/ExportProgressDialog';
import { SAVE_PROGRESS_KEY } from '../common/PhoneConst';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { Trace } from '@oh-image-editor/editor-common/src/main/ets/common/util/Trace';
import { AiTabName, EditorType, TabName } from '@oh-image-editor/editor-common/src/main/ets/service/model/Enum';
import { AlertDialog, TipsDialog } from '@ohos.arkui.advanced.Dialog';
import { ScreenClass } from '@oh-image-editor/editor-common/src/main/ets/service/App';
import {
  FIRST_FRAME_STATUS,
  TOP_BAR_HEIGHT,
  WIN_WIDTH_KEY,
  WINDOW_STATUS_KEY,
  FONT_SIZE_SCALE_S,
  DIALOG_ICON_KEY,
  DIALOG_NAME_KEY,
  FONT_SIZE_SCALE_KEY,
  ONE_DAY_MS,
  IS_PEN_KIT_CLICKED,
  PEN_KIT_POP_TIME,
  PEN_KIT_POP_COUNT
} from '@oh-image-editor/editor-common/src/main/ets/common/const';
import { preferencesGet, preferencesPut } from '@oh-image-editor/editor-common/src/main/ets/common/util/GlobalThisUtil';
import { common } from '@kit.AbilityKit';
import { EditorStatus } from '@oh-image-editor/editor-common/src/main/ets/service/EditorSDK';
import { LengthMetrics, LengthUnit, window } from '@kit.ArkUI';
import { ToolbarDialog } from '@oh-image-editor/editor-common/src/main/ets/service/model/dialog/ToolbarDialog';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import {
  TextAreaManager
} from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/viewModel/TabTextAreaManager';
import {
  UndoRedoManager
} from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/viewModel/TabUndoRedoManager';
import { ComposeIndex } from '@oh-image-editor/editor-common/src/main/ets/common/util/ComposeUtil';
import { util } from "@kit.ArkTS";
import sdk from '@oh-image-editor/editor-common/src/main/ets/service/native';

@Extend(Row)
function root() {
  .height(56)
  .width('100%')
}

@Extend(Image)
function img() {
  .width('24')
  .height('24')
  .fillColor('#FFFFFF')
  .draggable(false)
  .opacity(0.9)
}

@Extend(SymbolGlyph)
function backStyle() {
  .draggable(false)
  .fontSize($r('app.float.icon_size'))
  .fontColor(['#FFFFFF'])
  .opacity(0.9)
}

@Extend(SymbolGlyph)
function symStyle() {
  .fontSize($r('app.float.icon_size'))
  .fontColor(['#FFFFFF'])
  .draggable(false)
}

@Extend(Column)
function button(isBack: boolean, isHover?: boolean) {
  .width(40)
  .height(40)
  .borderRadius($r('sys.float.corner_radius_level10'))
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center)
  .backgroundColor(isHover ? $r('sys.color.ohos_id_color_hover_dark') : 'transparent')
}

@Extend(Button)
function buttonBg() {
  .stateStyles({
    pressed: {
      .backgroundColor($r('sys.color.ohos_id_color_click_effect_dark'))
    },
    normal: {
      .backgroundColor($r('sys.color.ohos_id_color_button_normal_dark'))
    }
  })
}

//instrument ignore next
@Extend(Column)
function longPressGesture(icon: Resource, name: Resource, toolbarDialog: CustomDialogController | undefined,
  fontSizeScale: number) {
  .gesture(
    LongPressGesture({ fingers: 1, duration: 500 })
      .onAction(() => {
        if (fontSizeScale < FONT_SIZE_SCALE_S) {
          return;
        }
        AppStorage.setOrCreate(DIALOG_ICON_KEY, icon);
        AppStorage.setOrCreate(DIALOG_NAME_KEY, name);
        toolbarDialog?.open();
      })
      .onActionEnd(() => {
        if (fontSizeScale < FONT_SIZE_SCALE_S) {
          return;
        }
        toolbarDialog?.close();
      })
      .onActionCancel(() => {
        if (fontSizeScale < FONT_SIZE_SCALE_S) {
          return;
        }
        toolbarDialog?.close();
      })
  )
  .accessibilityDescription(
    fontSizeScale < FONT_SIZE_SCALE_S
      ? UiUtil.getResourceString($r('app.string.accessibility_event_click_action'))
      : ''
  )
}

@Extend(Text)
function editText() {
  .fontFamily('HarmonyHeiTi')
  .fontWeight(FontWeight.Bold)
  .fontSize($r('sys.float.Title_S'))
  .lineHeight(27)
  .fontColor('#DBFFFFFF')
  .maxFontScale(1)
  .margin({ start: LengthMetrics.vp(8) })
  .accessibilityLevel('no')
}

const TAG = 'TopToolbar';
const FOCUS_COMMON_DELAY: number = 500;
let timeFn: number | undefined = undefined;

@Component
export struct TopToolbar {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State mosaicAttr: MosaicAttr = App.getInstance().myEditor().asset.mosaic();
  @State @Watch('refreshBarWidth') screenClass: ScreenClass = App.getInstance().screenClass;
  @State undoRedoInfo: UndoRedoInfo = App.getInstance().undoRedoInfo;
  @State isShowPenKitPop: boolean = false;
  @State isFirstTimeUseRecover: boolean = false;
  params: EditorParams | undefined = undefined // 工程初始化参数
  @Link status: EditorStatus
  @Link clickBackState: boolean;
  @Link textCanClickStyle: boolean;
  @Link isShowInPopup: boolean;
  @Link keyboardHeight: number;
  @Link textInputAreaHide: boolean;
  @Prop @Watch('onFirstFrameStateChange') firstFrameLoaded: boolean;
  public onMessageCallback: Function = Event;
  @StorageProp(EDITOR_STATUS_BAR_HEIGHT_KEY) @Watch('refreshDialogs') statusBarHeight: number = 0
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('refreshDialogs') isScreenPortrait: boolean =
    ScreenManager.getInstance()
      .isScreenPortrait();
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('refreshOrientByFoldChange') isFold: boolean = ScreenManager.getInstance()
    .isDeviceFold()
  @StorageProp(WINDOW_STATUS_KEY) @Watch('refreshOrientByWinChange') isSmallWindowMode: boolean =
    ScreenManager.getInstance()
      .getSmallWindowMode();
  @StorageProp(FIRST_FRAME_STATUS) isFirstFrameStatue: boolean = ScreenManager.getInstance().getIsFirstFrame();
  private isDialogCenter: boolean = false;
  @StorageProp(FONT_SIZE_SCALE_KEY) fontSizeScale: number = 0;
  private revertSureDialogOpenFlag: boolean = false;
  private revertSureDialog: CustomDialogController | undefined = undefined;
  private aiMoveRevertSureDialogOpenFlag: boolean = false;
  private aiMoveRevertSureDialog: CustomDialogController | undefined = undefined;
  private changeFestivalSealDialog: CustomDialogController | undefined = undefined;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private aiMoveDialogCallbackFunc: Function = (cb: Function): void => this.aiMoveDialogCallback(cb);
  private exportProgressDialog: CustomDialogController = new CustomDialogController({
    builder: ExportProgressDialog({
      closeClick: () => {
        this.topBarModel.closeClick();
      },
    }),
    customStyle: false,
    cancel: () => {
      this.topBarModel.closeClick();
    },
    autoCancel: false,
    alignment: DialogAlignment.Center,
  });
  private exportProgressDialogOpenFlag: boolean = false;
  private isButtonClick: boolean = false;
  private timeFn: number = -1;
  private toolbarDialog?: CustomDialogController;
  private topBarModel: TopBarModel = new TopBarModel(this.editor, () => {
    if (this.exportProgressDialog) {
      this.exportProgressDialogOpenFlag = true;
      Trace.begin('EditorProgressDialog');
      this.exportProgressDialog.open();
    }
  }, () => {
    if (this.exportProgressDialog) {
      this.exportProgressDialogOpenFlag = false;
      Trace.end('EditorProgressDialog');
      this.exportProgressDialog.close();
    }
  }, (msg: EditorMsg): boolean => {
    return this.onMessageCallback(msg);
  }, (progress: number) => {
    AppStorage.setOrCreate(SAVE_PROGRESS_KEY, progress)
  })
  @State backPopup: ButtonBubble = new ButtonBubble('button_bubble_back', false, false, false);
  @State redoPopup: ButtonBubble = new ButtonBubble('button_bubble_redo', false, false, false);
  @State undoPopup: ButtonBubble = new ButtonBubble('button_bubble_undo', false, false, false);
  @State recoverPopup: ButtonBubble = new ButtonBubble('revert_imageEdit', false, false, false);
  @State savePopup: ButtonBubble = new ButtonBubble('button_bubble_save', false, false, false);
  @State stylusPopup: ButtonBubble = new ButtonBubble('button_bubble_stylus', false, false, false);
  @State changeOriPopup: ButtonBubble = new ButtonBubble('button_bubble_changeOri', false, false, false);
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshBarWidth') winWidth: number = ScreenManager.getInstance().width;
  @State textPaddingLeftAndRight: number =
    ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
  @State textPaddingLeft: number = this.screenClass.avoidLeft +
    (this.isScreenPortrait ? this.textPaddingLeftAndRight : 0);
  textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  @Link textCanUndo: boolean;
  @Link textCanRedo: boolean;
  // 是否还在长按或者拖动调色盘点阵, 为true时禁止点击保存按钮
  // 防止保存完退出编辑时清理undo执行栈与执行XXX滤镜效果抢锁导致appFreeze
  @StorageLink('isNonTapGesture') isNonTapGesture: boolean = false;
  private onPressEscFunc: Function = (): void => this.pressEsc();
  private onPressSaveOverrideFunc: Function = (): void => this.pressSave(true);
  private onPressSaveAsFunc: Function = (): void => this.pressSave(false);
  private onPressUndoFunc: Function = (): void => this.pressUndo();
  private onPressRedoFunc: Function = (): void => this.pressRedo();
  private aiComposeDialog?: CustomDialogController;

  aboutToAppear() {
    this.asset.isUnfoldPortrait = this.isScreenPortrait;
    this.buildDialog(false);
    // 从动图直接进入涂鸦和AI修图编辑时，不触发第一次涂鸦pop提示
    if (!this.params?.entryType || this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_DEFAULT) {
      this.handleIsShowPenKitPop();
      this.getRecoverInfo();
    }
    App.getInstance().setAiMoveDialogCallback(this.aiMoveDialogCallbackFunc);
    this.appBroadCast.on(BroadCastConstants.CLOSE_PROGRESS_DIALOG, this.topBarModel?.closeProgressDialog);
    App.getInstance().myEditor().closeDialog = (isVerdeFolded: boolean) => {
      if (isVerdeFolded) {
        HiLog.i(TAG, `onFoldChanged isVerdeFolded: ${isVerdeFolded}`);
        this.revertSureDialogOpenFlag = false;
        this.revertSureDialog?.close();
        this.exportProgressDialogOpenFlag = false;
        this.exportProgressDialog?.close();
        this.toolbarDialog?.close();
      }
    }
    AccessibilityManager.getInstance().sendFocusAccessibilityEvent(Constants.TOP_TOOL_BAR_BACK, FOCUS_COMMON_DELAY)

    this.appBroadCast.on('checkBeforeSwitchStylus', this.checkBeforeSwitchStylus);
    this.appBroadCast.on(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_ESC, this.onPressEscFunc);
    this.appBroadCast.on(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_SAVE_OVERRIDE, this.onPressSaveOverrideFunc);
    this.appBroadCast.on(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_SAVE_AS, this.onPressSaveAsFunc);
    this.appBroadCast.on(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_UNDO, this.onPressUndoFunc);
    this.appBroadCast.on(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_REDO, this.onPressRedoFunc);
  }

  private aiMoveDialogCallback(cb: Function) {
    this.buildAIMoveRevertSureDialog(cb);
    this.aiMoveRevertSureDialog?.open();
    this.aiMoveRevertSureDialogOpenFlag = true;
  }

  onFirstFrameStateChange(): void {
    // 进入方式为非默认时，第一帧加载完成后，直接跳入界面
    if (this.firstFrameLoaded === true && this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_STYLUS) {
      this.editor.switchStylusMode();
    }
  }

  refreshBarWidth() {
    this.textPaddingLeftAndRight = ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
    this.textPaddingLeft = this.screenClass.avoidLeft + (this.isScreenPortrait ? this.textPaddingLeftAndRight : 0);
  }

  getContextInfo(): common.UIAbilityContext {
    let hspModuleContext = LocalStorage.getShared()?.get<Context>('photoLibraryContext') as common.UIAbilityContext;
    if (hspModuleContext) {
      HiLog.i(TAG, 'getContextInfo by hsp');
    }
    let abilityContext = LocalStorage.getShared()?.get<Context>('photosAbilityContext') as common.UIAbilityContext;
    return hspModuleContext ? hspModuleContext : abilityContext;
  }

  public async handleIsShowPenKitPop(): Promise<void> {
    let contextInfo: common.UIAbilityContext = this.getContextInfo();
    /**
     * @param isPenKitClicked 是否点击涂鸦按钮
     * @param penKitPopTime 涂鸦提示弹框展示时间
     * @param penKitPopCount 涂鸦提示弹框展示次数
     */
    let isPenKitClicked = await preferencesGet(IS_PEN_KIT_CLICKED, contextInfo, 'editorStore');
    let penKitPopTime = await preferencesGet(PEN_KIT_POP_TIME, contextInfo, 'editorStore');
    let penKitPopCount = await preferencesGet(PEN_KIT_POP_COUNT, contextInfo, 'editorStore');
    HiLog.i(TAG, `handleIsShowPenKitPop isPenKitClicked: ${isPenKitClicked} penKitPopTime: ${new Date(
      Number(penKitPopTime))} penKitPopCount: ${penKitPopCount}`);

    if (!penKitPopCount) {
      HiLog.i(TAG, 'handleIsShowPenKitPop firstTime');
      penKitPopCount = 0;
    }

    if (isPenKitClicked || (penKitPopCount === 3)) {
      HiLog.i(TAG, 'handleIsShowPenKitPop user clicked or popup three times.');
      this.isShowPenKitPop = false;
      return;
    }
    let curTime = new Date().getTime();
    HiLog.i(TAG, `handleIsShowPenKitPop curTime: ${new Date()}`);
    if (penKitPopCount === 0) {
      this.isShowPenKitPop = true;
      await preferencesPut(PEN_KIT_POP_TIME, curTime.toString(), contextInfo, 'editorStore');
      await preferencesPut(PEN_KIT_POP_COUNT, 1, contextInfo, 'editorStore');
      return;
    }
    // 用户未点击涂鸦按钮 && 距离第一次提示超过3天
    // instrument ignore if
    if (penKitPopCount === 1 && (curTime - Number(penKitPopTime) > 3 * ONE_DAY_MS)) {
      this.isShowPenKitPop = true;
      await preferencesPut(PEN_KIT_POP_TIME, curTime.toString(), contextInfo, 'editorStore');
      await preferencesPut(PEN_KIT_POP_COUNT, 2, contextInfo, 'editorStore');
      return;
    }
    // 用户未点击涂鸦按钮 && 距离第二次提示超过7天
    // instrument ignore if
    if (penKitPopCount === 2 && (curTime - Number(penKitPopTime) > 7 * ONE_DAY_MS)) {
      this.isShowPenKitPop = true;
      await preferencesPut(PEN_KIT_POP_TIME, curTime.toString(), contextInfo, 'editorStore');
      await preferencesPut(PEN_KIT_POP_COUNT, 3, contextInfo, 'editorStore');
      return;
    }
    this.isShowPenKitPop = false;
    return;
  }

  public async getRecoverInfo(): Promise<void> {
    let contextInfo: common.UIAbilityContext = this.getContextInfo();
    const resRecover = await preferencesGet('isFirstTimeUseRecover', contextInfo, 'editorStore');
    if (resRecover === '' || resRecover === 'true') {
      this.isFirstTimeUseRecover = true;
    }
  }

  public async writeRecoverInfo(): Promise<void> {
    let contextInfo: common.UIAbilityContext = this.getContextInfo();
    await preferencesPut('isFirstTimeUseRecover', 'false', contextInfo, 'editorStore');
    this.isFirstTimeUseRecover = false;
  }

  refreshDialogs() {
    this.buildDialog(true);
  }

  refreshOrientByFoldChange() {
    HiLog.i(TAG, `refreshOrientByFoldChange  isFold:${this.isFold}, isSmallWindowMode:${this.isSmallWindowMode}`);
    if (this.revertSureDialogOpenFlag && this.revertSureDialog) {
      this.revertSureDialog.close()
    }
    this.isDialogCenter = true;
    this.buildDialog(true);
    if (!this.isFold) {
      ScreenManager.getInstance().getSmallWindowMode()
      ScreenManager.getInstance().onRotationChanged(this.asset.isUnfoldPortrait)
    }
  }

  refreshOrientByWinChange() {
    HiLog.i(TAG, `refreshOrientByWinChange  isFold:${this.isFold}, isSmallWindowMode:${this.isSmallWindowMode}`);
    ScreenManager.getInstance().onRotationChanged(this.isSmallWindowMode ? true : this.asset.isUnfoldPortrait)
  }

  buildDialog(refreshDialog: boolean) {
    if (this.exportProgressDialogOpenFlag && this.exportProgressDialog && refreshDialog) {
      this.exportProgressDialog.close();
    }
    this.buildExportAndRevert(refreshDialog);
    this.buildToolbarDialog();
  }

  buildToolbarDialog(): void {
    this.toolbarDialog = new CustomDialogController({
      builder: ToolbarDialog(),
      customStyle: true,
      autoCancel: false,
      alignment: DialogAlignment.Center,
    })
  }

  buildToolbarDialogLocal(isImage: boolean): CustomDialogController {
    return new CustomDialogController({
      builder: ToolbarDialog({ isImage: isImage }),
      customStyle: true,
      autoCancel: true,
      alignment: DialogAlignment.Center,
    })
  }
  buildExportAndRevert(refreshDialog: boolean) {
    let isWinOrSplitMode = ScreenManager.getInstance().isWindowMode() || ScreenManager.getInstance().isSplitMode();
    let isFollow =
      !this.isDialogCenter && !isWinOrSplitMode && ((DeviceUtil.isFoldable() && !this.isFold) || DeviceUtil.isPad());
    let hspModuleContext = LocalStorage.getShared()?.get<Context>('photoLibraryContext') as common.UIAbilityContext;
    // instrument ignore if
    if (hspModuleContext) {
      HiLog.i(TAG, 'getPenKitInfo by hsp');
    }
    let topHeight = TOP_BAR_HEIGHT + (hspModuleContext ? App.getInstance().screenClass.avoidTop : 0);
    if (this.exportProgressDialogOpenFlag && refreshDialog) {
      this.exportProgressDialog.open();
    }
    //增加复原确认弹窗
    if (this.revertSureDialogOpenFlag && this.revertSureDialog && refreshDialog) {
      this.revertSureDialog.close();
    }

    this.buildRevertDialog(isFollow, topHeight, refreshDialog);
  }

  buildAIMoveRevertSureDialog(cb: Function) {
    this.aiMoveRevertSureDialog = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: $r('app.string.ai_move_toast_title'),
        content: $r('app.string.ai_move_toast_content'),
        primaryButton: {
          value: $r('app.string.subtitle_delete_cancel_imageEdit'),
          action: () => {
            this.aiMoveRevertSureDialogOpenFlag = false;
          },
        },
        secondaryButton: {
          value: $r('app.string.exit_imageEdit'),
          fontColor: $r('sys.color.warning'),
          action: () => {
            this.aiMoveRevertSureDialogOpenFlag = false;
            HiLog.i(TAG, 'sure button clicked');
            setTimeout((): void => {
              cb();
            }, 200);
          },
        },
      }),
      cancel: () => {
        this.aiMoveRevertSureDialogOpenFlag = false;
      },
      customStyle: false,
      autoCancel: false,
    });
  }

  buildRevertDialog(isFollow: boolean, topHeight: number, refreshDialog: boolean) {
    this.revertSureDialog = new CustomDialogController({
      builder: AlertDialog({
        content: $r('app.string.revert_original_state_imageEdit'),
        primaryButton: {
          value: $r('app.string.subtitle_delete_cancel_imageEdit'),
          action: () => {
            this.revertSureDialogOpenFlag = false;
          },
        },
        secondaryButton: {
          value: $r('app.string.revert_imageEdit'),
          action: () => {
            setTimeout((): void => {
              this.editor.isSaveVideoDialog = true;
              // 开始复原后 保持当前屏幕旋转状态，待复原结束恢复横竖屏旋转
              this.topBarModel.setOrientationMode(window.Orientation.LOCKED);
              // 等待弹框消失动画完成后再开始退出动画
              this.revertSureDialogOpenFlag = false;
              Trace.begin('ImageEditorSaveOperation');
              this.revert();
              this.autoBack(true);
            }, 200);
          },
          role: ButtonRole.ERROR,
        },
      }),
      cancel: () => {
        this.revertSureDialogOpenFlag = false;
      },
      customStyle: false,
      autoCancel: false,
      alignment: isFollow ? DialogAlignment.TopEnd : DialogAlignment.Center,
      offset: {
        dy: isFollow ? topHeight : 0,
        dx: isFollow ? -px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_max_padding_start'))) : 0,
      }
    });

    if (this.revertSureDialogOpenFlag && refreshDialog) {
      this.revertSureDialog.open();
    }
  }

  // ai修图时，状态判断
  aiImageProcessStatusCheck(): boolean {
    // 非ai修图页面
    if (App.getInstance().getType() !== EditorType.AI) {
      return true;
    }
    return true;
  }

  aboutToDisappear() {
    HiLog.i(TAG, 'exportProgressDialog.close');
    this.exportProgressDialog?.close();
    this.revertSureDialog?.close();
    this.aiMoveRevertSureDialog?.close();
    this.isShowInPopup = false;
    this.topBarModel?.reportEditorSaveBigData();
    this.topBarModel?.progressDialogClose();
    this.aiComposeDialog?.close();
    this.changeFestivalSealDialog?.close();
    this.appBroadCast.off(BroadCastConstants.CLOSE_PROGRESS_DIALOG, this.topBarModel?.closeProgressDialog);
    this.appBroadCast.off('checkBeforeSwitchStylus', this.checkBeforeSwitchStylus);
    this.appBroadCast.off(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_ESC, this.onPressEscFunc);
    this.appBroadCast.off(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_SAVE_OVERRIDE, this.onPressSaveOverrideFunc);
    this.appBroadCast.off(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_SAVE_AS, this.onPressSaveAsFunc);
    this.appBroadCast.off(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_UNDO, this.onPressUndoFunc);
    this.appBroadCast.off(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_REDO, this.onPressRedoFunc);
  }

  build() {
    Column() {
      Stack() {
        this.topButtons();
      }
      .padding({
        top: this.screenClass.avoidTop,
        right: this.screenClass.avoidRight,
      })
      .height(TOP_BAR_HEIGHT + this.screenClass.avoidTop)
    }
    .width('100%')
    .id('top_toolbar')
  }

  onSaveItemClick(isOverride: boolean): void {
    App.getInstance().saveProject((): Promise<void> => this.topBarModel.onSaveClick(isOverride));
  }

  displayUndoRedo() {
    if (App.getInstance().getType() === EditorType.AI) {
      return this.undoRedoInfo.isShowUnRedoButton;
    }
    if (this.editor.tabIndex === TabName.TabTextEdit) {
      return (this.textCanUndo || this.textCanRedo) && !this.isShowInPopup;
    }
    if (this.editor.tabIndex === TabName.TabMosaic) {
      return (this.mosaicAttr.canUndo || this.mosaicAttr.canRedo) && !this.isShowInPopup;
    }
    return this.undoRedoInfo.isShowUnRedoButton && this.editor.tabIndex !== TabName.TabAperture;
  }

  canUndo() {
    if (App.getInstance().getType() === EditorType.AI) {
      return this.undoRedoInfo.canUndo;
    }
    if (this.editor.tabIndex === TabName.TabMosaic) {
      return this.mosaicAttr.canUndo;
    }
    if (this.editor.tabIndex === TabName.TabTextEdit){
      return this.textCanUndo;
    }
    return this.undoRedoInfo.canUndo;
  }

  canRedo() {
    if (App.getInstance().getType() === EditorType.AI) {
      return this.undoRedoInfo.canRedo;
    }
    if (this.editor.tabIndex === TabName.TabMosaic) {
      return this.mosaicAttr.canRedo;
    }
    if (this.editor.tabIndex === TabName.TabTextEdit){
      return this.textCanRedo;
    }
    return this.undoRedoInfo.canRedo;
  }

  private isBackButtonEnable(): boolean {
    return !this.asset.isTouching;
  }

  private backButtonClick() {
    HiLog.i(TAG, 'titlebar_back button clicked');
    if (this.isNonTapGesture) {
      HiLog.i(TAG, 'titlebar_back button clicked when when LongPressGesture or panGesture');
      return;
    }
    if (this.editor.interrupt) {
      this.editor.setCropReactInterrupt(this.editor.tabIndex === TabName.TabCrop);
    }
    this.clickBackState = !this.clickBackState;
  }

  private saveButtonEnable(): boolean {
    return this.textAreaManager.getTextAreaList().length !== 0 || this.editor.textEditModified
      || this.editor.editModified || this.editor.stylusModified || this.editor.mosaicModified;
  }

  private undoButtonClick() {
    if (this.editor.tabIndex === TabName.TabMosaic && App.getInstance().getType() !== EditorType.AI) {
      this.mosaicAttr.undo();
      return;
    }
    if (this.editor.tabIndex === TabName.TabTextEdit && App.getInstance().getType() !== EditorType.AI) {
      if (this.textCanUndo) {
        let operate = this.undoRedoManager.getUndoList()[this.undoRedoManager.getUndoList().length - 1];
        HiLog.i(TAG, 'current operate operateType: %{public}i', operate?.operateType);
        if (operate !== undefined) {
          this.textAreaManager.undo();
        }
      }
      this.textCanUndo = this.undoRedoManager.canUndo();
      this.textCanRedo = this.undoRedoManager.canRedo();

      if (this.textAreaManager.getEditingTextArea()) {
        this.textCanClickStyle = true;
      } else {
        this.textCanClickStyle = false;
      }
      return;
    }
    // ai修图-undo
    let canChangeOtherBottom: boolean = this.aiImageProcessStatusCheck();
    if (!canChangeOtherBottom || this.cropsAttr.isRotateAndMirrorStatus || this.asset.isAnimating) {
      return;
    }
    App.getInstance().undo();
    this.editor.asset.overSizePrompt();
    if (this.editor.isEdit) {
      this.editor.isShowRevert = !this.editor.isEdited();
    }
  }

  private redoButtonClick() {
    if (this.editor.tabIndex === TabName.TabMosaic && App.getInstance().getType() !== EditorType.AI) {
      this.mosaicAttr.redo();
      return;
    }

    if (this.editor.tabIndex === TabName.TabTextEdit && App.getInstance().getType() !== EditorType.AI) {
      if (this.textCanRedo) {
        HiLog.i(TAG, 'in textTab redo');
        let operate = this.undoRedoManager.getRedoList()[this.undoRedoManager.getRedoList().length - 1];
        HiLog.i(TAG, 'current operate operateType: %{public}i', operate?.operateType);
        if (operate !== undefined) {
          this.textAreaManager.redo();
        }

        this.textCanUndo = this.undoRedoManager.canUndo();
        this.textCanRedo = this.undoRedoManager.canRedo();

        if (this.textAreaManager.getEditingTextArea()) {
          this.textCanClickStyle = true;
        } else {
          this.textCanClickStyle = false;
        }
        return;
      }
    }

    // ai修图时候-redo
    let canChangeOtherBottom: boolean = this.aiImageProcessStatusCheck();
    if (!canChangeOtherBottom || this.cropsAttr.isRotateAndMirrorStatus || this.asset.isAnimating) {
      return;
    }
    App.getInstance().redo();
    this.editor.asset.overSizePrompt();
    if (this.editor.isEdit) {
      this.editor.isShowRevert = !this.editor.isEdited();
    }
  }

  private pressEsc() {
    if (this.editor.stylusMode) {
      return;
    }
    if (!this.isBackButtonEnable()) {
      return;
    }
    HiLog.i(TAG, `press esc, back button click`);
    this.backButtonClick();
  }

  private pressSave(isOverride: boolean) {
    if (this.editor.stylusMode) {
      return;
    }
    if (!this.saveButtonEnable()) {
      return;
    }
    if (!this.aiImageProcessStatusCheck()) {
      return;
    }
    HiLog.i(TAG, `press save, isOverride:${isOverride}`);
    this.saveClickFunction(isOverride);
  }

  private pressUndo() {
    if (this.editor.stylusMode) {
      return;
    }
    if (!this.displayUndoRedo()) {
      return;
    }
    if (!this.canUndo()) {
      return;
    }
    HiLog.i(TAG, `press undo, undo button click`);
    this.undoButtonClick();
  }

  private pressRedo() {
    if (this.editor.stylusMode) {
      return;
    }
    if (!this.displayUndoRedo()) {
      return;
    }
    if (!this.canRedo()) {
      return;
    }
    HiLog.i(TAG, `press redo, redo button click`);
    this.redoButtonClick();
  }

  @Builder
  topButtons() {
    Row() {
      Row() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Column() {
            SymbolGlyph($r('sys.symbol.chevron_backward')).backStyle()
          }
          .button(true, this.backPopup.isHover)
          .id('petalClip_topToolBar_back')
          .accessibilityLevel('yes')
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .accessibilityText(UiUtil.getResourceString($r('app.string.action_back')))
          .enabled(this.isBackButtonEnable())
          .onClick((): void => {
            this.backButtonClick();
          })
        }
        .onHover((isHover: boolean, event: HoverEvent): void => {
          event.stopPropagation();
          this.backPopup.isHover = isHover;
        })
        .buttonBg()
        .id("imageEditor_topToolBar_back")
        .onAppear(() => {
          try {
            //返回键获得默认焦点
            this.getUIContext().getFocusController().requestFocus('imageEditor_topToolBar_back')
          } catch (err) {
            HiLog.e(TAG, `requestFocus error code : ${err.code}`);
          }
        })

        Text($r('app.string.edit_imageEdit'))
          .editText()
          .id('petalClip_topToolBar_edit')
          .accessibilityLevel('yes')
          .accessibilityRole(AccessibilityRoleType.TEXT)
          .accessibilityText(UiUtil.getResourceString($r('app.string.edit_imageEdit')))
      }

      Row() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Column() {
            SymbolGlyph($r('sys.symbol.undo')).symStyle()
          }
          .button(false, this.undoPopup.isHover)
          .id('petalClip_topToolBar_undo')
          .enabled(this.canUndo())
          .accessibilityLevel('yes')
          .accessibilityText(this.canUndo() ? UiUtil.getResourceString($r('app.string.undo_visible')) +
          UiUtil.getResourceString($r('app.string.button_imageEdit')) :
          UiUtil.getResourceString($r('app.string.undo_invisible')))
          .opacity(this.canUndo() ? 1 : 0.5)
          .visibility(this.displayUndoRedo() ? Visibility.Visible : Visibility.None)
          .onClick((): void => {
            this.undoButtonClick();
          })
          .accessibilityDescription(this.canUndo() ? '' : ' ')
        }
        .onHover((isHover: boolean, event: HoverEvent): void => {
          event.stopPropagation();
          this.undoPopup.isHover = isHover;
        })
        .margin({ end: LengthMetrics.vp(8) })
        .buttonBg()

        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Column() {
            SymbolGlyph($r('sys.symbol.redo')).symStyle()
          }
          .button(false, this.redoPopup.isHover)
          .id('petalClip_topToolBar_redo')
          .accessibilityLevel('yes')
          .enabled(this.canRedo())
          .accessibilityText(this.canRedo() ?
            UiUtil.getResourceString($r('app.string.redo_visible')) +
            UiUtil.getResourceString($r('app.string.button_imageEdit')) :
          UiUtil.getResourceString($r('app.string.redo_invisible')))
          .opacity(this.canRedo() ? 1 : 0.5)
          .visibility(this.displayUndoRedo() ? Visibility.Visible : Visibility.None)
          .onClick((): void => {
            this.redoButtonClick();
          })
          .accessibilityDescription(this.canRedo() ? '' : ' ')
        }
        .onHover((isHover: boolean, event: HoverEvent): void => {
          event.stopPropagation();
          this.redoPopup.isHover = isHover;
        })
        .margin({ end: LengthMetrics.vp(8) })
        .buttonBg()

        if (DeviceUtil.isFoldLandScape() && !this.isFold && !this.isSmallWindowMode) {
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Column() {
              SymbolGlyph(this.asset.isUnfoldPortrait ? $r('sys.symbol.layout_left_right') :
              $r('sys.symbol.layout_up_down')).symStyle()
            }
            .accessibilityLevel('yes')
            .accessibilityRole(AccessibilityRoleType.BUTTON)
            .accessibilityText(this.asset.isUnfoldPortrait ? UiUtil.getResourceString($r('app.string.edit_lr')) :
            UiUtil.getResourceString($r('app.string.edit_ud')))
            .onHover((isHover: boolean, event: HoverEvent): void => {
              event.stopPropagation();
              this.changeOriPopup.isHover = isHover;
            })
            .button(false, this.changeOriPopup.isHover)
            .id('videoEditor_topToolBar_changeOri')
            .onClick((): void => {
              clearTimeout(this.timeFn);
              ScreenManager.getInstance().setLayoutSwitching(true);
              this.timeFn = setTimeout((): void => {
                ScreenManager.getInstance().setLayoutSwitching(false);
                HiLog.i(TAG, 'LayoutSwitching End');
              }, 100);
              this.asset.isUnfoldPortrait = !this.asset.isUnfoldPortrait;
              ScreenManager.getInstance().onRotationChanged(this.asset.isUnfoldPortrait);
            })
          }
          .margin({ end: LengthMetrics.vp(8) })
          .buttonBg()
        }


        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Column() {
            SymbolGlyph($r('sys.symbol.save')).symStyle()
          }
          .button(false, this.savePopup.isHover)
          .id('petalClip_topToolBar_save')
          .enabled(this.saveButtonEnable())
          .accessibilityLevel('yes')
          .accessibilityText(this.saveButtonEnable() ? UiUtil.getResourceString($r('app.string.button_bubble_save')) +
          UiUtil.getResourceString($r('app.string.button_imageEdit')) :
          UiUtil.getResourceString($r('app.string.save_invisible')))
          .opacity(this.saveButtonEnable() ? 1 : 0.5)
          .onClick((): void => {
            // ai修图时候-保存
            if (!this.aiImageProcessStatusCheck()) {
              return;
            }
            HiLog.i(TAG, 'save button clicked');
          })
          .longPressGesture($r('app.media.save'), $r('app.string.button_bubble_save'), this.toolbarDialog,
            this.fontSizeScale)
          .visibility(this.editor.isShowRevert && !this.editor.isEditNoData &&
            this.textAreaManager.getTextAreaList().length === 0 && !this.editor.mosaicModified ?
          Visibility.None : Visibility.Visible)
          .hitTestBehavior(this.isNonTapGesture ? HitTestMode.None : HitTestMode.Default)
          .bindMenu(this.saveMenuBuilder)
          .accessibilityDescription(this.saveButtonEnable() ? '' : ' ')
        }
        .onHover((isHover: boolean, event: HoverEvent): void => {
          event.stopPropagation();
          this.savePopup.isHover = isHover;
        })
        .buttonBg()

        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Column() {
            SymbolGlyph($r('sys.symbol.arrow_counterclockwise')).symStyle()
          }
          .button(false, this.recoverPopup.isHover)
          .id('petalClip_topToolBar_topTool_recover')
          .accessibilityLevel('yes')
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .accessibilityText(UiUtil.getResourceString($r('app.string.revert_imageEdit')))
          .onClick((): void => {
            this.isFirstTimeUseRecover = false;
            // ai修图时候-恢复
            const canChangeOtherBottom: boolean = this.aiImageProcessStatusCheck();
            if (!canChangeOtherBottom) {
              return;
            }
            this.isDialogCenter = false;
            this.buildDialog(false);
            this.revertSureDialog?.open();
            this.revertSureDialogOpenFlag = true;
          })
          .longPressGesture($r('sys.symbol.arrow_counterclockwise'), $r('app.string.revert_imageEdit'),
            this.buildToolbarDialogLocal(false),this.fontSizeScale)
          .bindPopup(this.editor.isShowRevert && this.isFirstTimeUseRecover &&
            !this.editor.isEditNoData, {
            builder: this.firstTimeUseRecoverBuilder,
            mask: false,
            autoCancel: true,
            backgroundBlurStyle: BlurStyle.NONE,
            popupColor: $r('sys.color.ohos_id_color_dialog_bg_dark'),
            onStateChange: (e) => {
              HiLog.i(TAG, `recover button isVisible: ${e.isVisible}`);
              if (!e.isVisible) {
                this.writeRecoverInfo();
              }
            }
          })
          .visibility(this.editor.isShowRevert &&
            !this.editor.isEditNoData && this.textAreaManager.getTextAreaList().length === 0 &&
            !this.editor.mosaicModified ? Visibility.Visible :
          Visibility.None)
        }
        .onHover((isHover: boolean, event: HoverEvent): void => {
          event.stopPropagation();
          this.recoverPopup.isHover = isHover;
        })
        .buttonBg()
      }
      .enabled(this.isFirstFrameStatue && !this.asset.isTouching)
      .opacity(this.isFirstFrameStatue ? 1 : 0.4)
    }
    .visibility(this.editor.immersiveMode ? Visibility.Hidden : Visibility.Visible)
    .id('petalClip_topToolBar_topToolBar')
    .root()
    .padding({ left: this.textPaddingLeft, right: this.textPaddingLeftAndRight })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .enabled(!this.editor.isSaveVideoDialog)
  }

  // instrument ignore next
  @Builder
  firstTimeUsePenKitBuilder() {
    Row() {
      Text($r('app.string.first_time_use_penkit'))
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.ohos_id_color_text_primary_dark'))
        .lineHeight(19)
    }.padding({
      left: 16,
      top: 13,
      right: 16,
      bottom: 13,
    })
  }

  // instrument ignore next
  @Builder
  firstTimeUseRecoverBuilder() {
    Row() {
      Text($r('app.string.click_restore_origin_tips'))
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.ohos_id_color_text_primary_dark'))
        .lineHeight(19)
    }.padding({
      left: 16,
      top: 13,
      right: 16,
      bottom: 13,
    })
  }

  //点击一键还原时，调此接口进行还原,	回退编辑
  public async revert(): Promise<void> {
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
    try {
      HiLog.i(TAG, `restores start`);
      // if (this.editor.mediaAsset) {
      //   const changeRequest: photoAccessHelper.MediaAssetChangeRequest =
      //     new photoAccessHelper.MediaAssetChangeRequest(this.editor.mediaAsset);
      //   await phAccessHelper.applyChanges(changeRequest);
      //   phAccessHelper.release();
      // }
      await this.editor.mediaAsset?.revertToOriginal();
      this.appBroadCast?.emit(BroadCastConstants.PHOTO_EDIT_REVERT_TO_ORIGIN, [this.editor.mediaUri]);
      HiLog.i(TAG, `restores end`);
    } catch (err) {
      phAccessHelper.release();
      HiLog.i(TAG, `err: ${err}`);
      return;
    }
  }

  autoBack(revert: boolean): void {
    clearTimeout(timeFn);
    this.editor.isStopScrolling = true;
    timeFn = setTimeout((): void => {
      this.editor.isStopScrolling = false;
    }, 50);
    if (revert) {
      LocalStorage.getShared()?.setOrCreate<number |
      undefined>('exitRatio', this.editor.asset.crops().getExitRatio());
    }
    let msg: EditorMsg = new EditorMsg(EditorMsg.MSG_ID_ON_EXIT, this.editor.mediaUri);
    if (this.onMessageCallback(msg)) {
      this.editor.isPageBackLoading = true;
      App.getInstance().myEditor().cancel();
      App.getInstance().myEditor().close((code: number) => {
        HiLog.i(TAG, `project closed(${code}` + '), reason=autoBack');
      });
    }
  }

  checkBeforeSwitchStylus = async () => {
    let reportNum: number = this.textAreaManager.getTextAreaList().length;
    if (reportNum !== 0) {
      this.textAreaManager.flush('');
      this.textInputAreaHide = false;
      this.textCanClickStyle = false;
      this.isShowInPopup = false;
      this.textCanUndo = false;
      this.textCanRedo = false;

      HiLog.i(TAG, 'TopToolbar composeBeforeEnter');
      this.asset.textEdit().composeBeforeEnter(ComposeIndex.STYLUS, this.asset.textEdit().textRect, reportNum, () => {
        this.editor.textEditModified = true;
        this.switchToStylusPage(reportNum);
        // 合成时隐藏XXXtab
        this.appBroadCast.emit('hideXTStyleAperture');
      });
    } else if (this.editor.tabIndex === TabName.TabMosaic) {
      this.asset.mosaic().beforeEnterStylus().then(() => {
        this.switchToStylusPage();
      });
    } else {
      this.switchToStylusPage();
    }
  }

  async switchToStylusPage(reportNum?: number) {
    // ai修图时候-涂鸦
    let canChangeOtherBottom: boolean = this.aiImageProcessStatusCheck();
    if (!canChangeOtherBottom) {
      return;
    }
    HiLog.i(TAG, 'stylus button clicked');
    if (this.isButtonClick) {
      HiLog.w(TAG, 'stylus button doubleClick');
      return;
    }
    this.isButtonClick = true;
    setTimeout((): void => {
      this.isButtonClick = false;
    }, 800);
    this.isShowPenKitPop = false;
    App.getInstance().switchStylusMode(reportNum);
    let contextInfo: common.UIAbilityContext = this.getContextInfo();
    await preferencesPut(IS_PEN_KIT_CLICKED, true, contextInfo, 'editorStore');
  }

  async checkAiComposeDialog() {
    let hasAiModified : boolean = sdk.aiEditorContextIsAiLableNeeded();
    let aiConfiguredSettingName = 'ai_compose_flag_configured_2'; // 修改设置项名称就可以实现重新弹窗
    let configured = settings.getValueSync(getContext(this), aiConfiguredSettingName, 'false') === 'true';
    HiLog.i(TAG, `checkAiComposeDialog, hasAiModified = ${hasAiModified} configured = ${configured}`);
    if (!hasAiModified || configured) {
      return;
    }
    try {
      let isSuccess: boolean = settings.setValueSync(getContext(this), aiConfiguredSettingName, 'true');
      HiLog.i(TAG, `set ai_compose_flag_configured, isSuccess: ${isSuccess}`);
    } catch (err) {
      HiLog.e(TAG, `set ai_compose_flag_configured, error, message: ${err?.message }, code: ${err?.code}`);
    }
    return new Promise<void>(resolve => {});
  }

  /**
   * 保存菜单项点击事件
   *
   * @param isOverride 是否覆盖原图
   * @returns 事件
   */
  private async saveClickFunction(isOverride: boolean) {
    try {
      await this.checkAiComposeDialog();
    } catch (err) {
      HiLog.e(TAG, `checkAiComposeDialog, error, message: ${err?.message }, code: ${err?.code}`);
    }
    this.topBarModel.setSaveStartTime(Date.now());
    let reportNum: number = this.textAreaManager.getTextAreaList().length;
    if (reportNum !== 0 && this.editor.tabIndex === TabName.TabTextEdit) {
      this.editor.getExportRect((width: number, height: number) => {
        this.editor.imageSourceWidth = width;
        this.editor.imageSourceHeight = height;
        this.asset.textEdit().save(ComposeIndex.DEFAULT, this.asset.textEdit().textRect,
          reportNum, () => {
            this.onSaveItemClick(isOverride);
          });
      });
    } else if (this.editor.tabIndex === TabName.TabMosaic) {
      this.editor.getExportRect((width: number, height: number) => {
        this.editor.imageSourceWidth = width;
        this.editor.imageSourceHeight = height;
        this.asset.mosaic().save(ComposeIndex.DEFAULT).then(() => {
          this.onSaveItemClick(isOverride);
        });
      });
    } else {
      this.onSaveItemClick(isOverride);
    }
  }

  getFestivalSealContent() {
    return $r('app.string.unsupport_national_seal_edit');
  }

  buildChangeFestivalSealDialog(cb: Function) {
    this.changeFestivalSealDialog = new CustomDialogController({
      builder: AlertDialog({
        content: this.getFestivalSealContent(),
        primaryButton: {
          value: $r('app.string.subtitle_delete_cancel_imageEdit'),
          action: () => {
            this.changeFestivalSealDialog?.close();
          },
        },
        secondaryButton: {
          value: $r('app.string.yes'),
          role: ButtonRole.ERROR,
          action: () => {
            HiLog.i(TAG, 'sure button clicked');
            this.changeFestivalSealDialog?.close();
            cb();
          },
        },
      }),
      cancel: () => {
        this.changeFestivalSealDialog?.close();
      },
      customStyle: false,
      autoCancel: false,
    });
    this.changeFestivalSealDialog.open();
  }

  handleSaveClick(isOverride: boolean) {
    this.saveClickFunction(isOverride);
  }

  @Builder
  saveMenuBuilder() {
    Menu() {
      MenuItem({ content: $r('app.string.editor_overwrite_the_original_image') })
        .onClick((): void => {
          this.handleSaveClick(true);
        })
      MenuItem({ content: $r('app.string.editor_save_as') })
        .onClick((): void => {
          this.handleSaveClick(false);
        })
    }
    .onAppear(() => {
      if (this.textAreaManager.getTextAreaList().length !== 0) {
        this.textAreaManager.flush('');
        this.textCanClickStyle = false;
        this.isShowInPopup = false;
      }
    })
    .saveMenuStyle()
  }
}

@Extend(Menu)
function saveMenuStyle() {
  .menuItemDivider({
    color: $r('sys.color.ohos_id_color_list_separator'),
    strokeWidth: { value: 1, unit: LengthUnit.PX },
  })
  .width(224)
}