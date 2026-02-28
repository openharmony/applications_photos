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

import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionViewModel, MenuConstants, MenuHelper, ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles, LongPressGestureModifier } from './ActionButton';
import lazy { getScreen, } from '../../model/common/ScreenManager';
import lazy { Constants } from '../../model/common/Constants';
import lazy { LongPressHintsDialog } from '../../view/dialog/LongPressHintsDialog';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { common } from '@kit.AbilityKit';
import lazy { AccessibilityUtil } from '../../utils/AccessibilityUtil';

/**
 * 多选/全选/取消全选
 */
export const COMPONENT_KEY_MULTISELECT: string = 'MultiSelect';

/**
 * 选择/取消选择
 */
export const COMPONENT_KEY_SELECTED: string = 'Selected';

export const ACTION_KEY_MULTISELECT: string = 'ActionButton_' + COMPONENT_KEY_MULTISELECT;

/**
 * 多选
 */
export const MULTISELECT: Action = new Action({
  id: Action.uuid,
  componentKey: COMPONENT_KEY_MULTISELECT,
});

/**
 * 单选
 */
export const SELECTED: Action = new Action({
  id: Action.uuid,
  componentKey: COMPONENT_KEY_SELECTED,
});

const TAG: string = 'common_MultiSelect';
const LONG_PRESS_DURATION: number = 500;
const CARE_MODE_THRESHOLD: number = 1.75;

/**
 * 多选按钮
 */
@Observed
export class SelectionActionProp extends DefaultActionButtonProp {
  public action = MULTISELECT;
  public icon = Action.SELECT_ALL.iconRes;
  public text = $r('app.string.multiselect');
  public key = ACTION_KEY_MULTISELECT;
  public fillColor = $r('sys.color.font_primary');
}

/**
 * 多选按钮，PC场景使用
 */
@Observed
export class SelectionActionPropPc extends SelectionActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 全选/取消全选 菜单项处理注册类
 */
export class SelectionActionRegister extends ActionRegister {
  public getActions(): Action[] {
    return [Action.SELECT_ALL, Action.DESELECT_ALL];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    /* instrument ignore if*/
    if (!action || !params) {
      return undefined;
    }
    let menuHelper: MenuHelper = params.get<MenuHelper>(MenuConstants.KEY_MENU_HELPER);
    let manager: SelectManager = params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER);
    /* instrument ignore if*/
    if (!menuHelper || !manager) {
      return;
    }

    switch (action) {
      case Action.SELECT_ALL:
        const selectVM: ActionViewModel = {
          doAction: (menuContext?: MenuContext): void => {
            manager.selectAll(true);
          }
        }
        return selectVM;
      case Action.DESELECT_ALL:
        const deSelectVM: ActionViewModel = {
          doAction: (menuContext?: MenuContext): void => {
            manager.deSelectAll();
          }
        }
        return deSelectVM;
      default:
        return undefined;
    }
  }
}

@Builder
export function selectionBuilder(obj: Object | undefined) {
  Selection({ prop: obj as SelectionActionProp })
}

/**
 * 文字形式 多选/全选/取消全选
 */
@Component
export struct Selection {
  @State public prop: SelectionActionProp = new SelectionActionProp();
  @StorageProp('currentFontSizeScale') @Watch('fontSizeScaleChanged') private fontSizeScale: number = 1;
  private dialogController: CustomDialogController | undefined = new CustomDialogController({
    builder: LongPressHintsDialog({ textRes: this.prop.text, iconRes: this.prop.icon }),
    customStyle: true,
  });
  @State longPressModifier: LongPressGestureModifier =
    new LongPressGestureModifier(this.dialogController, this.fontSizeScale);

  private fontSizeScaleChanged(): void {
    this.longPressModifier = new LongPressGestureModifier(this.dialogController, this.fontSizeScale);
  }

  private sendAccessibilityFocus() {
    if (!AccessibilityUtil.isOpenTouchGuideSync()) {
      return;
    }
    if (this.prop.key === Action.DESELECT_ALL.componentKey) {
      AccessibilityUtil.sendAnnounceAccessibilityResource(Action.SELECT_ALL.textRes);
    } else if (this.prop.key === Action.SELECT_ALL.componentKey){
      AccessibilityUtil.sendAnnounceAccessibilityResource(Action.DESELECT_ALL.textRes);
    } else if (this.prop.key === Action.MULTISELECT.componentKey) {
      AccessibilityUtil.sendFocusAccessibilityEvent(Action.SELECT_ALL.componentKey);
    }
  }
  
  build() {
    Stack() {
      Button({ stateEffect: true }) {
        Text(this.prop.text)
          .transition(this.prop.transitionEffect)
          .fontSize($r('sys.float.Body_M'))
          .fontColor(this.prop.fontColor)
          .minFontSize($r('sys.float.Caption_M'))
          .maxFontSize($r('sys.float.Body_M'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .maxFontScale(1.0)
          .wordBreak(WordBreak.BREAK_ALL)
          .margin({
            left: $r('app.float.actionbar_text_icon_margin'),
            right: $r('app.float.actionbar_text_icon_margin'),
          })
          .constraintSize({
            maxWidth: getScreen().getWinLayoutWidth() <= Constants.MULTISELECT_ACTION_WIN_SIZEO_TRUNCATION_WIDTH ?
            $r('app.float.select_actionbar_text_width_size') : undefined
          })
      }
      .visibility(this.prop.isHidden ? Visibility.Hidden : Visibility.Visible)
      .height(this.prop.height)
      .accessibilityText(this.prop.text)
      .enabled(this.prop.isEnabled)
      .borderRadius($r('sys.float.corner_radius_level10'))
      .backgroundBlurStyle(this.prop.backgroundBlurStyle, {}, {disableSystemAdaptation: true})
      .stateStyles({
        pressed: {
          .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
        },
        normal: {
          .backgroundColor(this.prop.backgroundColor)
        }
      })
      .onClick((event: ClickEvent) => {
        this.sendAccessibilityFocus();
        this.prop.onClick?.(event);
      })
      .key(this.prop.key)
      .buildCommonGestureStyles()
    }
    .height(this.prop.height)
  }

  // 定义组件的样式方法
  @Styles
  buildCommonGestureStyles(): void {
    .gestureModifier(this.longPressModifier)
  }

}

/**
 * 全选/取消全选 菜单项处理注册类
 */
export class MultiSelectActionRegister extends ActionRegister {
  public static readonly KEY_CUSTOM_MULTISELECT_BUILDER: string = 'KEY_CUSTOM_MULTISELECT_BUILDER';
  public static readonly KEY_MULTISELECT_VIEW_MODEL: string = 'KEY_MULTISELECT_VIEW_MODEL';
  private readonly viewModel: ActionViewModel | undefined;

  public constructor(viewModel: ActionViewModel | undefined) {
    super();
    this.viewModel = viewModel;
  }

  public getActions(): Action[] {
    return [MULTISELECT];
  }

  public buildActionBuilder(action: Action, params: ParamsWrapper): (params: Object | undefined) => void {
    let builder: (prop: Object | undefined) => void =
      params?.get<(prop: Object | undefined) => void>(MultiSelectActionRegister.KEY_CUSTOM_MULTISELECT_BUILDER);
    return builder ?? super.buildActionBuilder(action, params);
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new SelectionActionPropPc() : new SelectionActionProp();
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return this.viewModel;
  }
}

/**
 * 选择/取消选择
 */
export class SelectActionRegister extends ActionRegister {
  public static readonly KEY_CUSTOM_SELECTED_BUILDER: string = 'KEY_CUSTOM_SELECTED_BUILDER';
  private readonly viewModel: ActionViewModel | undefined;

  public constructor(viewModel: ActionViewModel | undefined) {
    super();
    this.viewModel = viewModel;
  }

  public getActions(): Action[] {
    return [SELECTED];
  }

  public buildActionBuilder(action: Action, params: ParamsWrapper): (params: Object | undefined) => void {
    let builder: (prop: Object | undefined) => void =
      params?.get<(prop: Object | undefined) => void>(SelectActionRegister.KEY_CUSTOM_SELECTED_BUILDER);
    return builder ?? super.buildActionBuilder(action, params);
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new SelectionActionPropPc() : new SelectionActionProp();
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return this.viewModel;
  }
}

