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
import {
  App,
  ButtonBubble,
  ColumnSize,
  CropAttr,
  EditorMsg,
  Event,
  FIRST_FRAME_STATUS,
  HiLog,
  MediaType,
  BaseEditor,
  ScreenManager,
  TabName,
  TabType,
  TopBarModel,
  UndoRedoInfo,
  UiUtil
} from '@oh-image-editor/editor-common'
import { ExportProgressDialog } from '../common/dialog/ExportProgressDialog'
import { ButtonPopup } from '../common/ButtonPopup'
import { Service } from '@oh-image-editor/editor-common/src/main/ets/common/util/Service'
import pointer from '@ohos.multimodalInput.pointer';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

import { MenuAttr } from '@oh-image-editor/editor-common/src/main/ets/service/model/menu/MenuAttr'
import { AlertDialog } from '@ohos.arkui.advanced.Dialog'
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { ButtonOptions } from '@ohos/common/src/main/ets/default/utils/ButtonOptionUtil'
import { SegmentButton, SegmentButtonItemTuple, SegmentButtonOptions } from '@ohos.arkui.advanced.SegmentButton'
import { preferencesPut, preferencesGet } from '@oh-image-editor/editor-common/src/main/ets/common/util/GlobalThisUtil'
import { AiTabName, EditorType } from '@oh-image-editor/editor-common/src/main/ets/service/model/Enum'
import { common } from '@kit.AbilityKit'
import { LengthMetrics, LengthUnit } from '@kit.ArkUI'
import {
  ONE_DAY_MS,
  IS_PEN_KIT_CLICKED,
  PEN_KIT_POP_TIME,
  PEN_KIT_POP_COUNT
} from '@oh-image-editor/editor-common/src/main/ets/common/const';
import { Trace } from '@oh-image-editor/editor-common/src/main/ets/common/util/Trace';
import Bundles, { BUNDLE_NAMES } from '@ohos/tools/src/main/utils/Bundle';

@Extend(Image)
function img() {
  .width('24')
  .height('24')
  .fillColor('#FFFFFF')
  .opacity(0.9)
  .draggable(false)
}

@Extend(Image)
function iconStyle() {
  .size({ width: 24, height: 24 })
  .fillColor('#FFFFFF')
  .opacity(0.9)
}

@Extend(SymbolGlyph)
function symIconStyle() {
  .fontSize(24)
  .fontColor(['#FFFFFF'])
  .opacity(0.9)
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

@Extend(Button)
function btnStyle(isHover: boolean, isPress: boolean) {
  .align(Alignment.Center)
  .width(40)
  .height(40)
  .margin({ left: 8 })
  .borderRadius($r('sys.float.corner_radius_level4'))
  .backgroundColor(isHover ? (isPress ? 'rgba(255,255,255,0.1)' : 'rgba(255,255,255,0.05)') : 'rgba(0,0,0,0)')
}

const TAG = 'TopNavBar';
let timeFn: number | undefined = undefined;

@Component
export struct TopNavBar {
  @State cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State isImmersiveEnabled: boolean | undefined = LocalStorage.getShared()?.get<boolean>('isImmersiveEnabled');
  @StorageLink('isFullMode') isFullMode: boolean = ScreenManager.getInstance().getMainWindow()?.getWindowProperties?.()
    .isFullScreen;
  @State undoRedoInfo: UndoRedoInfo = App.getInstance().undoRedoInfo;
  public onMessageCallback: Function = Event;
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State selectedTab: number = 0;
  @StorageProp(FIRST_FRAME_STATUS) isFirstFrameStatue: boolean = ScreenManager.getInstance().getIsFirstFrame();
  @State currentIndex: number = TabName.TabCrop;
  @State editTextWidth: number = 0;
  @State customPopup: boolean = false;
  @Link clickBackState: boolean;
  @State saveProgress: number = 0;
  @State backPopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_back'), false, false, false);
  @State rotatePopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_rotate'), false, false, false);
  @State redoPopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_redo'), false, false, false);
  @State undoPopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_undo'), false, false, false);
  @State recoverPopup: ButtonBubble = new ButtonBubble($r('app.string.revert_imageEdit'), false, false, false);
  @State savePopup: ButtonBubble = new ButtonBubble($r('app.string.button_bubble_save'), false, false, false);
  @State cropAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State popupText: Resource | undefined = undefined;
  @State pressTabIndex: number = -1;
  @State stylusPopup: ButtonBubble = new ButtonBubble('button_bubble_stylus', false, false, false);
  private isCamera = Bundles.getInfo().name === BUNDLE_NAMES['camera'];
  private isButtonClick: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private timer: number = -1;
  private exportProgressDialog: CustomDialogController = new CustomDialogController({
    builder: ExportProgressDialog({
      progress: this.saveProgress,
      closeClick: () => {
        this.model.closeClick();
      },
    }),
    customStyle: false,
    cancel: () => {
      this.model.closeClick();
    },
    autoCancel: false,
    alignment: DialogAlignment.Center,
  });
  private model: TopBarModel = new TopBarModel(this.editor, () => {
    Trace.begin('EditorProgressDialog');
    this.exportProgressDialog?.open();
  }, () => {
    Trace.end('EditorProgressDialog');
    this.exportProgressDialog?.close();
  }, (msg: EditorMsg): boolean => {
    return this.onMessageCallback(msg);
  }, (progress: number) => {
    this.saveProgress = progress;
  })
  private revertSureDialogOpenFlag: boolean = false;
  private revertSureDialog: CustomDialogController | undefined = undefined;
  private handleSaveFunc: Function = (): void => this.save(true);
  private handleSaveAsFunc: Function = (): void => this.save(false);
  private handleRedoFunc: Function = (): void => this.redo();
  private handleUndoFunc: Function = (): void => this.undo();

  aboutToAppear() {
    this.buildDialog(false);
    this.appBroadCast.on(BroadCastConstants.SAVE_IMAGE, this.handleSaveFunc);
    this.appBroadCast.on(BroadCastConstants.SAVE_AS_IMAGE, this.handleSaveAsFunc);
    this.appBroadCast.on(BroadCastConstants.EDIT_REDO, this.handleRedoFunc);
    this.appBroadCast.on(BroadCastConstants.EDIT_UNDO, this.handleUndoFunc);
    this.appBroadCast.on(BroadCastConstants.CLOSE_PROGRESS_DIALOG, this.model?.closeProgressDialog);
    this.handleIsShowPenKitPop();
  }

  aboutToDisappear() {
    this.model?.reportEditorSaveBigData();
    this.appBroadCast.off(BroadCastConstants.SAVE_IMAGE, this.handleSaveFunc);
    this.appBroadCast.off(BroadCastConstants.SAVE_AS_IMAGE, this.handleSaveAsFunc);
    this.appBroadCast.off(BroadCastConstants.EDIT_REDO, this.handleRedoFunc);
    this.appBroadCast.off(BroadCastConstants.EDIT_UNDO, this.handleUndoFunc);
    this.appBroadCast.off(BroadCastConstants.CLOSE_PROGRESS_DIALOG, this.model?.closeProgressDialog);
    this.exportProgressDialog?.close();
  }

  buildDialog(refreshDialog: boolean) {
    const cancelButton: ButtonOptions = {
      defaultFocus: false,
      value: $r('app.string.subtitle_delete_cancel_imageEdit'),
      action: () => {
        this.revertSureDialogOpenFlag = false;
      },
    };
    const confirmButton: ButtonOptions = {
      defaultFocus: true,
      value: $r('app.string.revert_imageEdit'),
      action: () => {
        setTimeout((): void => {
          // 等待弹框消失动画完成后再开始退出动画
          this.revertSureDialogOpenFlag = false;
          Trace.begin('ImageEditorSaveOperation');
          this.revert();
          this.autoBack(true);
        }, 200);
      },
      role: ButtonRole.ERROR,
    };
    this.revertSureDialog = new CustomDialogController({
      builder: AlertDialog({
        content: $r('app.string.revert_original_state_imageEdit'),
        primaryButton: cancelButton,
        secondaryButton: confirmButton,
      }),
      cancel: () => {
        this.revertSureDialogOpenFlag = false;
      },
      customStyle: false,
      autoCancel: false,
      alignment: DialogAlignment.Center,
    });
  }

  @Styles
  disableStyle() {
    .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary_disable'))
  }

  @Styles
  buttonNormalStyle() {
    .backgroundColor('rgba(0,0,0,0)')
    .borderRadius($r('sys.float.corner_radius_level4'))
  }

  @Styles
  buttonFocusStyle() {
    .backgroundColor('rgba(0,0,0,0)')
    .border({
      radius: 8,
      color: '#5291FF',
      width: 2,
    })
  }

  @Styles
  buttonSelectStyle() {
    .backgroundColor('rgba(255,255,255,0.1)')
    .border({
      radius: 8,
    })
  }

  @Styles
  buttonDisableStyle() {
    .backgroundColor('rgba(0,0,0,0)')
  }

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
    this.popupText = $r('app.string.first_time_use_penkit');
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
      this.stylusPopup.isShow = false;
      return;

    }
    let curTime = new Date().getTime();
    HiLog.i(TAG, `handleIsShowPenKitPop curTime: ${new Date()}`);
    if (penKitPopCount === 0) {
      this.stylusPopup.isShow = true;
      await preferencesPut(PEN_KIT_POP_TIME, curTime.toString(), contextInfo, 'editorStore');
      await preferencesPut(PEN_KIT_POP_COUNT, 1, contextInfo, 'editorStore');
      return;
    }
    // 用户未点击涂鸦按钮 && 距离第一次提示超过3天
    if (penKitPopCount === 1 && (curTime - Number(penKitPopTime) > 3 * ONE_DAY_MS)) {
      this.stylusPopup.isShow = true;
      await preferencesPut(PEN_KIT_POP_TIME, curTime.toString(), contextInfo, 'editorStore');
      await preferencesPut(PEN_KIT_POP_COUNT, 2, contextInfo, 'editorStore');
      return;
    }
    // 用户未点击涂鸦按钮 && 距离第二次提示超过7天
    if (penKitPopCount === 2 && (curTime - Number(penKitPopTime) > 7 * ONE_DAY_MS)) {
      this.stylusPopup.isShow = true;
      await preferencesPut(PEN_KIT_POP_TIME, curTime.toString(), contextInfo, 'editorStore');
      await preferencesPut(PEN_KIT_POP_COUNT, 3, contextInfo, 'editorStore');
      return;
    }
    this.stylusPopup.isShow = false;
    return;
  }

  // ai修图时，状态判断
  aiImageProcessStatusCheck(): boolean {
    // 非ai修图页面
    if (App.getInstance().getType() !== EditorType.AI) {
      return true;
    }
    return true;
  }

  @Builder
  popupBuilder() {
    ButtonPopup({
      popupText: this.popupText,
    })
  }

  @Builder
  BackBtnZoom() {
    Row() {
      Stack() {
        Button({ type: ButtonType.Normal }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontSize($r('app.float.ic_size_default'))
            .draggable(false)
            .fontColor(['#FFFFFF'])
        }
        .btnStyle(this.backPopup.isHover, this.backPopup.isPress)
        .bindPopup(this.backPopup.isShow, {
          builder: this.popupBuilder(),
          enableArrow: false,
          placement: Placement.Bottom,
          targetSpace: 8,
          mask: false,
          autoCancel: false,
          backgroundBlurStyle: BlurStyle.NONE,
        })
      }
      .id('petalClip_topToolBar_back')
      .onClick((): void => {
        if (this.editor.interrupt) {
          this.editor.setCropReactInterrupt();
        }
        this.clickBackState = !this.clickBackState;
      })
      .onMouse((event: MouseEvent) => {
        if (event.action === MouseAction.Press) {
          this.backPopup.isPress = true;
        }
        if (event.action === MouseAction.Release) {
          this.backPopup.isPress = false;
        }
      })
      .onHover((isHover: boolean, event: HoverEvent): void => {
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.backPopup.isHover = isHover;
        if (isHover) {
          if (this.stylusPopup.isShow) {
            this.stylusPopup.isShow = false;
          }
          this.popupText = $r('app.string.button_bubble_back');
          this.timer = setTimeout((): void => {
            this.backPopup.isShow = isHover;
          }, this.editor.hoverTime)
        } else {
          this.backPopup.isShow = isHover!;
          clearTimeout(this.timer);
        }
      })

      Text($r('app.string.edit_imageEdit'))
        .fontSize(20)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .lineHeight(27)
        .margin({ left: 8 })
        .minFontScale(1)
        .maxFontScale(1)
        .onAreaChange((_: Area, newValue: Area) => {
          this.editTextWidth = newValue.width as number;
        })
    }
    .width(48 + this.editTextWidth)
  }

  @Builder
  CommonBtnZoom() {
    Row() {
      this.redoUndoBtnBar();

      Stack() {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.stylus')).img()
        }
        .id('petalClip_topToolBar_stylus')
        .btnStyle(this.stylusPopup.isHover, this.stylusPopup.isPress)
        .bindPopup(this.stylusPopup.isShow, {
          builder: this.popupBuilder(),
          enableArrow: false,
          placement: Placement.Bottom,
          targetSpace: 8,
          mask: false,
          autoCancel: true,
          backgroundBlurStyle: BlurStyle.NONE,
          onStateChange: (e) => {
            HiLog.i(TAG, `stylus button isVisible: ${e.isVisible}`);
            if (!e.isVisible) {
              this.stylusPopup.isShow = false;
            }
          }
        })
      }
      .onClick(async (): Promise<void> => {
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
        this.stylusPopup.isShow = false;
        App.getInstance().switchStylusMode();
        setTimeout((): void => {
          this.isButtonClick = false;
        }, 800);

        let contextInfo: common.UIAbilityContext = this.getContextInfo();
        await preferencesPut(IS_PEN_KIT_CLICKED, true, contextInfo, 'editorStore');
      })
      .onMouse((event: MouseEvent) => {
        if (event.action === MouseAction.Press) {
          this.stylusPopup.isPress = true;
        }
        if (event.action === MouseAction.Release) {
          this.stylusPopup.isPress = false;
        }
      })
      .onHover((isHover: boolean, event: HoverEvent): void => {
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.stylusPopup.isHover = isHover;
        if (isHover) {
          this.popupText = $r('app.string.button_bubble_stylus');
          this.timer = setTimeout((): void => {
            this.stylusPopup.isShow = isHover;
          }, this.editor.hoverTime)
        } else {
          this.stylusPopup.isShow = isHover!;
          clearTimeout(this.timer);
        }
      })

      Stack() {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.topTool_recover')).img()
        }
        .id('petalClip_topToolBar_topTool_recover')
        .bindPopup(this.recoverPopup.isShow, {
          builder: this.popupBuilder(),
          enableArrow: false,
          placement: Placement.Bottom,
          targetSpace: 8,
          mask: false,
          autoCancel: false,
          backgroundBlurStyle: BlurStyle.NONE,
        })
        .btnStyle(this.recoverPopup.isHover, true)
      }
      .onClick((): void => {
        HiLog.i(TAG, 'revert button clicked');
        this.revertSureDialog?.open();
        this.revertSureDialogOpenFlag = true;
      })
      .onMouse((event: MouseEvent) => {
        if (event.action === MouseAction.Press) {
          this.recoverPopup.isPress = true;
        }
        if (event.action === MouseAction.Release) {
          this.recoverPopup.isPress = false;
        }
      })
      .onHover((isHover: boolean, event: HoverEvent): void => {
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.recoverPopup.isHover = isHover;
        if (isHover) {
          if (this.stylusPopup.isShow) {
            this.stylusPopup.isShow = false;
          }
          this.popupText = $r('app.string.revert_imageEdit');
          this.timer = setTimeout((): void => {
            this.recoverPopup.isShow = isHover;
          }, this.editor.hoverTime)
        } else {
          this.recoverPopup.isShow = isHover!;
          clearTimeout(this.timer);
        }
      })
      .margin({ right: 12 })
      .visibility(this.editor.isShowRevert && !this.editor.isEditNoData ? Visibility.Visible : Visibility.None)

      Stack() {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.save')).img()
            .opacity(this.editor.editModified || this.editor.stylusModified ? 1 : this.editor.isOpenInit ? 0.4 : 0)
        }
        .id('petalClip_topToolBar_save')
        .bindPopup(this.savePopup.isShow, {
          builder: this.popupBuilder(),
          enableArrow: false,
          placement: Placement.Bottom,
          targetSpace: 8,
          mask: false,
          autoCancel: false,
          backgroundBlurStyle: BlurStyle.NONE,
        })
        .accessibilityLevel('yes')
        .accessibilityText(this.editor.editModified ? UiUtil.getResourceString($r('app.string.button_bubble_save')) :
        UiUtil.getResourceString($r('app.string.save_invisible')))
        .enabled(this.editor.editModified || this.editor.stylusModified)
        .btnStyle(this.savePopup.isHover && this.editor.editModified, this.savePopup.isPress)
      }
      .bindMenu(this.saveMenuBuilder, {
        showInSubWindow: false,
      })
      .onClick((): void => {
        HiLog.i(TAG, 'save button clicked');
      })
      .onMouse((event: MouseEvent) => {
        if (event.action === MouseAction.Press) {
          this.savePopup.isPress = true;
        }
        if (event.action === MouseAction.Release) {
          this.savePopup.isPress = false;
        }
      })
      .onHover((isHover: boolean, event: HoverEvent): void => {
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.savePopup.isHover = isHover;
        if (isHover) {
          if (this.stylusPopup.isShow) {
            this.stylusPopup.isShow = false;
          }
          this.popupText = $r('app.string.button_bubble_save');
          this.timer = setTimeout((): void => {
            this.savePopup.isShow = isHover;
          }, this.editor.hoverTime)
        } else {
          this.savePopup.isShow = isHover!;
          clearTimeout(this.timer);
        }
      })
      .margin({ right: 12 })
      .visibility(this.editor.isShowRevert && !this.editor.isEditNoData ? Visibility.None : Visibility.Visible)

      Blank().width(1)
    }
    .size({ height: 48 })
    .enabled(this.isFirstFrameStatue)
    .opacity(this.isFirstFrameStatue ? 1 : 0.4)
  }

  @Builder
  redoUndoBtnBar() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Stack() {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.undo')).img()
            .opacity(this.undoRedoInfo.canUndo ? 1 : 0.4)
        }
        .bindPopup(this.undoPopup.isShow, {
          builder: this.popupBuilder(),
          enableArrow: false,
          placement: Placement.Bottom,
          targetSpace: 8,
          mask: false,
          autoCancel: false,
          backgroundBlurStyle: BlurStyle.NONE,
        })
        .enabled(this.undoRedoInfo.canUndo)
        .btnStyle(this.undoPopup.isHover && this.undoRedoInfo.canUndo, this.undoPopup.isPress)
      }
      .id('petalClip_topToolBar_undo')
      .accessibilityLevel('yes')
      .accessibilityText(this.undoRedoInfo.canUndo ? UiUtil.getResourceString($r('app.string.undo_visible')) :
      UiUtil.getResourceString($r('app.string.undo_invisible')))
      .onClick((): void => {
        this.undo();
      })
      .onMouse((event: MouseEvent) => {
        if (!this.undoRedoInfo.canUndo) {
          return;
        }
        if (event.action === MouseAction.Press) {
          this.undoPopup.isPress = true;
        }
        if (event.action === MouseAction.Release) {
          this.undoPopup.isPress = false;
        }
      })
      .onHover((isHover: boolean, event: HoverEvent): void => {
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.undoPopup.isHover = isHover;
        if (isHover) {
          this.undoPopup.isPress = false;
          this.popupText = $r('app.string.button_bubble_undo');
          this.timer = setTimeout((): void => {
            this.undoPopup.isShow = isHover;
          }, this.editor.hoverTime)
        } else {
          this.undoPopup.isShow = isHover!;
          clearTimeout(this.timer);
        }
      })


      Stack() {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.redo')).img()
            .opacity(this.undoRedoInfo.canRedo ? 1 : 0.4)
        }
        .bindPopup(this.redoPopup.isShow, {
          builder: this.popupBuilder(),
          enableArrow: false,
          placement: Placement.Bottom,
          targetSpace: 8,
          mask: false,
          autoCancel: false,
          backgroundBlurStyle: BlurStyle.NONE,
        })
        .enabled(this.undoRedoInfo.canRedo)
        .btnStyle(this.redoPopup.isHover && this.undoRedoInfo.canRedo, this.redoPopup.isPress)
      }
      .id('petalClip_topToolBar_redo')
      .accessibilityLevel('yes')
      .accessibilityText(this.undoRedoInfo.canRedo ? UiUtil.getResourceString($r('app.string.redo_visible')) :
      UiUtil.getResourceString($r('app.string.redo_invisible')))
      .onClick((): void => {
        this.redo();
      })
      .onMouse((event: MouseEvent) => {
        if (!this.undoRedoInfo.canRedo) {
          return;
        }
        if (event.action === MouseAction.Press) {
          this.redoPopup.isPress = true;
        }
        if (event.action === MouseAction.Release) {
          this.redoPopup.isPress = false;
        }
      })
      .onHover((isHover: boolean, event: HoverEvent): void => {
        if (event.stopPropagation === null || event.stopPropagation === undefined) {
          return;
        }
        event.stopPropagation();
        this.redoPopup.isHover = isHover;
        if (isHover) {
          this.redoPopup.isPress = false;
          this.popupText = $r('app.string.button_bubble_redo');
          this.timer = setTimeout((): void => {
            this.redoPopup.isShow = isHover;
          }, this.editor.hoverTime)
        } else {
          this.redoPopup.isShow = isHover!;
          clearTimeout(this.timer);
        }
      })
    }
    .visibility(this.undoRedoInfo.isShowUnRedoButton ? Visibility.Visible : Visibility.None)
    .width(88)
  }

  build() {
    Stack() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        this.BackBtnZoom();
        Blank()
        this.CommonBtnZoom()
      }
    }
    .onHover((isHover: boolean, event: HoverEvent): void => {
      event.stopPropagation();
      isHover && Service.changeMouseShape(pointer.PointerStyle.DEFAULT);
    })
    .size({ width: '100%', height: 72 })
    .padding(this.isImmersiveEnabled && this.isFullMode ? { start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) }
      : { start: LengthMetrics.vp(16), end: LengthMetrics.vp(168) })
    .backgroundColor('#343434')
    .key(TAG + 'Stack')
  }

  // 底部街区轨道组件渐隐渐显动画
  bottomHeightChange(flag: boolean): void {
    animateTo({
      duration: 400, // 动画时长
      delay: 100,
      curve: Curve.Friction, // 动画曲线
    }, () => {
      this.editor.bottomHeight = flag ? 100 : 0
    })
  }

  private undo(): void {
    if (this.editor.stylusMode) {
      return;
    }
    App.getInstance().undo();
    if (this.editor.isEdit && this.editor.isSystemEditData) {
      this.editor.isShowRevert = !this.editor.editModified;
    }
  }

  private save(isOverride: boolean): void {
    if (this.editor.stylusMode) {
      return;
    }
    if (!this.editor.editModified && !this.editor.stylusModified) {
      return;
    }
    this.model.setSaveStartTime(Date.now());
    this.model.onSaveClick(isOverride);
  }

  private redo(): void {
    if (this.editor.stylusMode) {
      return;
    }
    App.getInstance().redo();
    if (this.editor.isEdit && this.editor.isSystemEditData) {
      this.editor.isShowRevert = !this.editor.editModified;
    }
  }

  //点击一键还原时，调此接口进行还原,	回退编辑
  public async revert(): Promise<void> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchAlbumResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
      //获取photoAsset
      let predicate = new dataSharePredicates.DataSharePredicates();
      predicate.equalTo('uri', this.editor.mediaUri);

      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicate,
      };
      if (!this.isCamera) {
        fetchAlbumResult =
          await phAccessHelper.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE)
        let photoAlbum = await fetchAlbumResult.getFirstObject();
        fetchResult = await photoAlbum.getAssets(fetchOptions);
        HiLog.i(TAG, `fetchCount: ${fetchResult.getCount()}`);
        if (!fetchResult.getCount()) {
          fetchResult.close();
          fetchResult = await phAccessHelper.getAssets(fetchOptions);
        }
      } else {
        fetchResult = await phAccessHelper.getAssets(fetchOptions);
      }
      let photoAsset = await fetchResult.getFirstObject();
      await photoAsset.revertToOriginal();
    } catch (err) {
      HiLog.i(TAG, `err: ${err}`);
      return;
    } finally {
      fetchResult?.close();
      if (!this.isCamera) {
        fetchAlbumResult?.close();
      }
      HiLog.i(TAG, `fetchAlbumResult and fetchResult is close.`);
      phAccessHelper?.release();
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
    let msg = new EditorMsg(EditorMsg.MSG_ID_ON_EXIT, this.editor.mediaUri);
    if (this.onMessageCallback(msg)) {
      this.editor.isPageBackLoading = true;
      this.editor.cancel();
      this.editor.close((code: number) => {
        HiLog.i(TAG, `project closed(${code}` + '), reason=autoBack');
      });
    }
  }

  /**
   * 保存菜单项点击事件
   *
   * @param isOverride 是否覆盖原图
   * @returns 事件
   */
  private saveClickFunction(isOverride: boolean): Callback<ClickEvent> {
    return () => {
      this.save(isOverride)
    }
  }

  @Builder
  saveMenuBuilder() {
    Menu() {
      MenuItem({ content: $r('app.string.editor_overwrite_the_original_image') })
        .onClick(this.saveClickFunction(true))
      MenuItem({ content: $r('app.string.editor_save_as') }).onClick(this.saveClickFunction(false))
    }
    .saveMenuStyle()
    .visibility(this.editor.editModified || this.editor.stylusModified ? Visibility.Visible : Visibility.None)
    .onAppear((): void => {
      clearTimeout(this.timer);
      this.savePopup.isShow = false;
    })
  }
}

@Extend(Menu)
function saveMenuStyle() {
  .menuItemDivider({
    color: $r('sys.color.ohos_id_color_list_separator'),
    strokeWidth: { value: 1, unit: LengthUnit.PX },
  })
}