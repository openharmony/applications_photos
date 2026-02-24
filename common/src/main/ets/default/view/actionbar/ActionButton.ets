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

/* instrument ignore file */

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { LongPressHintsDialog } from '../../view/dialog/LongPressHintsDialog';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { Action } from '../browserOperation/Action';
import lazy { AppBarStyles } from './AppBarStyles';
import lazy { IndexFocusOrder } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { AccessibilityUtil } from '../../utils/AccessibilityUtil';
import lazy { VIDEO_SPLICING, VIDEO_SPLICING_INVALID } from './VideoSplicingAction';

const LONG_PRESS_DURATION: number = 500;
const CARE_MODE_THRESHOLD: number = 1.75;
const TAG: string = 'ActionButton';

export interface SubMenuBuilderParam {
  param?: object; // 对应customSubMenuBuilderParam
}

/**
 * 按钮属性
 */
@Observed
export class ActionButtonProp {
  /**
   * photo Menu下拉子菜单自定义builder
   */
  public customSubMenuBuilder: WrappedBuilder<[SubMenuBuilderParam]> | undefined;
  public customSubMenuBuilderParam?: object;
  /**
   * 是否有子菜单
   */
  public hasSubMenu: boolean = false;
  /**
   * 设置Menu子菜单展开样式
   */
  public subMenuExpandingMode: SubMenuExpandingMode | undefined = undefined;
  /**
   * 获取相册信息func
   */
  public getAlbumInfoFunc: Function | undefined = undefined;
  /**
   * action
   */
  public action: Action | undefined = Action.NONE;
  /**
   * 选项
   */
  public options: ButtonOptions = DEFAULT_BUTTON_OPTIONS;
  /**
   * 图标
   */
  public icon: Resource | undefined = undefined;
  /**
   * 文字
   */
  public text: string | Resource = '';
  /**
   * MenuItem 的 labelInfo
   */
  public labelInfo: string | Resource = '';
  /**
   * PC MenuItem 的 symbolStartIcon
   */
  public customMenuItemBuilder: WrappedBuilder<[ActionButtonProp]> | undefined = undefined;
  /**
   * MenuItem 的 symbolStartIcon
   */
  public symbolStartIcon: SymbolGlyphModifier | undefined = undefined;
  /**
   * MenuItem 的 symbolEndIcon
   */
  public symbolEndIcon: SymbolGlyphModifier | undefined = undefined;
  /**
   * 是否启用
   */
  public isEnabled: boolean = true;
  /**
   * 是否隐藏
   */
  public isHidden: boolean = false;
  /**
   * 背景颜色
   */
  public backgroundColor: ResourceColor = AppBarStyles.BUTTON_BG_COLOR;
  /**
   * 模糊风格
   */
  public backgroundBlurStyle: BlurStyle = BlurStyle.NONE;
  /**
   * 圆角
   */
  public borderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0;
  /**
   * 图标填充颜色
   */
  public fillColor: ResourceColor = AppBarStyles.BUTTON_FILL_COLOR;
  /**
   * 文字填充颜色
   */
  public fontColor: ResourceColor = this.fillColor;
  /**
   * 边缘抗锯齿
   */
  public edgeAntialiasing: number = DeviceInfo.isHym() ? 0.45 : 0;
  /**
   * 整个控件的高度
   */
  public width: Length = $r('app.float.action_bar_button_height');
  /**
   * 整个控件的高度
   */
  public height: Length = $r('app.float.action_bar_button_height');
  /**
   * 唯一id key值
   */
  public key: string = '';
  /**
   * 点击处理
   */
  public onClick: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 控制popup
   */
  public isShowPopup: boolean = false;
  /**
   * 是否允许获焦
   */
  public focusable: boolean = false;
  /**
   * 通过tab走焦的层级
   */
  public tabIndex: number = IndexFocusOrder.ACTIONBAR_BUTTON;
  /**
   * 组件动画
   */
  public transitionEffect: TransitionEffect = TransitionEffect.IDENTITY;
  /**
   * popup组件(这里初始值为ark的默认值)
   */
  public popupOptions: CustomPopupOptions = {
    builder: undefined,
    placement: Placement.Bottom,
    autoCancel: true,
    mask: false,
    enableArrow: true,
    popupColor: Color.Transparent,
    backgroundBlurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
  };
  /**
   * 自定义popup样式builder
   */
  public customPopupBuilder: WrappedBuilder<[]> | undefined = undefined;
  /**
   * Flex布局权重
   */
  public layoutWeight: number = 0;
  /**
   * 子菜单点击处理func
   */
  public subMenuClick: Function | undefined;
  /**
   * 键盘事件监听func
   */
  public onKeyEvent: ((event: KeyEvent, prop: ActionButtonProp) => void) | undefined;
  /**
   * X号在右边时，为18vp
   */
  public iconSize: Resource = $r('app.float.icon_size');
  /**
   * 图标和文本整体垂直居中
   */
  public justifyContent: FlexAlign  = FlexAlign.Center;

  public setLabelInfo(labelInfo: string): void {
    this.labelInfo = labelInfo;
  }
}

/**
 * 默认属性，用于手机、平板等设备
 */
export const DEFAULT_BUTTON_OPTIONS: ButtonOptions = {
  type: ButtonType.Circle,
  stateEffect: true,
};

/**
 * PC设备按钮选项
 */
export const PC_BUTTON_OPTIONS: ButtonOptions = {
  type: ButtonType.Normal,
  stateEffect: true,
};

@Observed
export class DefaultActionButtonProp extends ActionButtonProp {
  public options = DEFAULT_BUTTON_OPTIONS;
  public borderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = $r('sys.float.corner_radius_level10');
}

/**
 * 设置为pc的样式
 * @param prop 属性
 */
export function applyPcStyles(prop: ActionButtonProp): void {
  if (!prop || !DeviceInfo.isPc()) {
    return;
  }
  prop.options = PC_BUTTON_OPTIONS;
  prop.backgroundColor = $r('app.color.transparent');
  prop.borderRadius = $r('sys.float.corner_radius_level4');
  // pc的popup风格
  prop.popupOptions.placement = Placement.Bottom;
  prop.popupOptions.enableArrow = false;
}

/**
 * 长按手势属性刷新
 */
export class LongPressGestureModifier implements GestureModifier {
  fontSizeScale?: number = 1;
  dialogController?: CustomDialogController | undefined
  updateResCallBack?: Function = (): void => {
  };

  constructor(dialogController?: CustomDialogController | undefined, fontSizeScale?: number) {
    this.dialogController = dialogController;
    this.fontSizeScale = fontSizeScale;
  }

  // 手势应用
  applyGesture(event: UIGestureEvent) {
    // 大字体模式下才需要绑定长按事件
    if (this.fontSizeScale && this.fontSizeScale >= CARE_MODE_THRESHOLD) {
      event.addGesture(
        new LongPressGestureHandler({ duration: LONG_PRESS_DURATION })
          .onAction((event: GestureEvent) => {
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
 * Button构造方法
 * @param prop
 */
@Builder
export function actionBuilder(prop: Object | undefined) {
  ActionButton({ prop: prop as ActionButtonProp })
}

/**
 * 适配Pc的Button构造方法
 * @param prop
 */
@Builder
export function pcActionBuilder(prop: Object | undefined) {
  PcActionButton({ prop: prop as ActionButtonProp })
}

/**
 * Button构造方法
 * @param prop
 */
@Builder
export function immersiveActionBuilder(prop: Object | undefined) {
  ImmersiveButton({ prop: prop as ActionButtonProp })
}

/**
 * Button构造方法
 * @param prop
 */
@Builder
export function toolbarActionBuilder(prop: Object | undefined) {
  ToolBarButton({ prop: prop as ActionButtonProp })
}

/**
 * ActionButton组件
 */
@Component
export struct ActionButton {
  @State public prop: ActionButtonProp = new ActionButtonProp();
  @State public overrideProp: ActionButtonProp | undefined = undefined;
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  // 获取系统字体
  @StorageProp('currentFontSizeScale') @Watch('fontSizeScaleChanged') fontSizeScale: number = 1;
  private dialogController: CustomDialogController | undefined = new CustomDialogController({
    builder: LongPressHintsDialog({ textRes: this.prop.text, iconRes: this.prop.icon }),
    customStyle: true,
  });
  @State longPressModifier: LongPressGestureModifier = new LongPressGestureModifier(this.dialogController, this.fontSizeScale);

  private getButtonText(): string {
    if (this.prop.action?.actionID === Action.SEARCH_VALID.actionID) {
      return this.rsc.toString($r('app.string.search'));
    }
    return this.rsc.toString(this.prop.text);
  }

  private fontSizeScaleChanged(): void {
    this.longPressModifier =
      new LongPressGestureModifier(this.dialogController, this.fontSizeScale);
  }

  @Builder
  buildPopup() {
    if (this.prop.customPopupBuilder) {
      this.prop.customPopupBuilder.builder();
    } else {
      Row() {
        Text(this.prop.text)
          .fontSize($r('sys.float.Body_M'))
      }
      .borderRadius($r('sys.float.corner_radius_level4'))
      .padding({
        top: $r('sys.float.padding_level4'),
        bottom: $r('sys.float.padding_level4'),
        left: $r('sys.float.padding_level4'),
        right: $r('sys.float.padding_level4'),
      })
    }
  }

  build() {
    Column() {
      Button(this.overrideProp ? this.overrideProp.options : this.prop.options) {
        if (this.prop.action?.actionID === Action.FULL_RATIO.actionID ||
          this.prop.action?.actionID === VIDEO_SPLICING.actionID) {
          // todo 临时解决上库，待资源上symbol后移除
          Image(this.prop.icon)
            .fillColor(this.prop.fillColor)
            .width($r('app.float.pc_actionbar_button_size'))
            .height($r('app.float.pc_actionbar_button_size'))
        } else {
          SymbolGlyph(this.prop.icon)
            .draggable(false)
            .fontSize(this.prop.iconSize)
            .fontColor([this.prop.fillColor])
        }
      }
      .transition(this.overrideProp ? this.overrideProp.transitionEffect : this.prop.transitionEffect)
      .key(this.prop.key)
      .width(this.overrideProp ? this.overrideProp.width : this.prop.width)
      .height(this.overrideProp ? this.overrideProp.height : this.prop.height)
      .enabled(this.overrideProp ? this.overrideProp.isEnabled : this.prop.isEnabled)
      .backgroundColor(this.overrideProp ? this.overrideProp.backgroundColor : this.prop.backgroundColor)
      .backgroundBlurStyle(this.prop.backgroundBlurStyle, {}, {disableSystemAdaptation: true})
      .borderRadius(this.prop.borderRadius)
      .onClick((event: ClickEvent) => {
        if (DeviceInfo.isPc()) {
          this.prop.isShowPopup = false;
        }
        this.prop.onClick?.(event);
      })
      .onClick((event: ClickEvent) => this.prop.onClick?.(event))
      .accessibilityText(this.getButtonText())
      .bindPopup(this.overrideProp ? this.overrideProp.isShowPopup : this.prop.isShowPopup, {
        builder: this.buildPopup(),
        placement: this.prop.popupOptions?.placement,
        autoCancel: this.prop.popupOptions?.autoCancel,
        mask: this.prop.popupOptions?.mask,
        enableArrow: this.prop.popupOptions?.enableArrow,
        popupColor: this.prop.popupOptions?.popupColor,
        backgroundBlurStyle: this.prop.popupOptions?.backgroundBlurStyle,
        onStateChange: (event) => {
          this.prop.popupOptions.onStateChange?.(event);
        }
      })
      .focusable(this.prop.focusable)
      .tabIndex(this.prop.tabIndex)
      .onKeyEvent((event: KeyEvent) => {
        this.prop.onKeyEvent?.(event, this.prop);
      })
      .buildCommonGestureStyles()
    }
    .layoutWeight(this.prop.layoutWeight)
    .alignItems(HorizontalAlign.Start)
  }

  @Styles
  buildCommonGestureStyles(): void {
    .gestureModifier(this.longPressModifier)
  }
}

/**
 * 适配pc的ActionButton
 */
@Component
export struct PcActionButton {
  @State public prop: ActionButtonProp = new ActionButtonProp();

  build() {
    Column() {
      ActionButton({ prop: this.prop })
    }
    .onHover((isHover: boolean) => {
      this.prop.isShowPopup = isHover;
    })
  }
}

/**
 * 沉浸态按钮样式
 */
@Component
export struct ImmersiveButton {
  @State @Watch('onPropChanged') public prop: ActionButtonProp = new ActionButtonProp();
  @State private dummyProp: ActionButtonProp = new ActionButtonProp();

  aboutToAppear(): void {
    this.onPropChanged();
  }

  private onPropChanged(): void {
    // 必须在保持内部Button不禁用的状态下，才能达到UX设计效果
    Log.info(TAG, 'ImmersiveButton onPropChanged');
    this.dummyProp.options = this.prop.options;
    this.dummyProp.icon = this.prop.icon;
    this.dummyProp.action = this.prop.action;
    this.dummyProp.backgroundColor = this.prop.backgroundColor;
    this.dummyProp.backgroundBlurStyle = this.prop.backgroundBlurStyle;
    this.dummyProp.fillColor = AppBarStyles.BUTTON_FILL_COLOR_IMMERSIVE;
    this.dummyProp.fontColor = this.prop.fontColor;
  }

  build() {
    if (this.prop.isEnabled) {
      ActionButton({ prop: this.prop })
    } else {
      ActionButton({ prop: this.dummyProp }).enabled(false)
    }
  }
}

/**
 * 工具栏按钮样式，需要额外显示文字，且需要调整按钮高度
 */
@Component
export struct ToolBarButton {
  @State public prop: ActionButtonProp = new ActionButtonProp();
  @State private overrideProp: ActionButtonProp = new ActionButtonProp();

  aboutToAppear(): void {
    // 工具栏场景，禁用启用状态只需要控制外部的套壳Button，内部的Button不需要设置禁用启用状态
    this.overrideProp.options = { type: ButtonType.Normal, stateEffect: false };
    this.overrideProp.width = $r('app.float.icon_size');
    this.overrideProp.height = $r('app.float.icon_size');
    this.overrideProp.backgroundColor = $r('app.color.transparent');
    this.overrideProp.isEnabled = true;
  }

  @Builder
  buildPopup() {
    this.prop.customPopupBuilder?.builder();
  }

  build() {
    Button({ type: ButtonType.Normal, stateEffect: false }) {
      Column() {
        ActionButton({ prop: this.prop, overrideProp: this.overrideProp })
          .accessibilityLevel('no-hide-descendants')

        Text(this.prop.text)
          .draggable(false)
          .key(`ToolBar_Text_${this.prop.key}`)
          .fontSize($r('sys.float.Caption_M'))
          .maxFontScale(1.0)
          .minFontScale(1.0)
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .margin({ top: $r('app.float.action_button_title_margin') })
          .enabled(this.prop.isEnabled)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .minFontSize($r('sys.float.Caption_S'))
          .maxFontSize($r('sys.float.Caption_M'))
          .wordBreak(WordBreak.BREAK_ALL)
      }
      .width({minWidth: $r('app.float.crop_action_hot_zone')})
      .height($r('app.float.crop_action_hot_zone'))
      .justifyContent(this.prop.justifyContent)
    }
    .key(`ToolBarButton_${this.prop.key}`)
    .accessibilityLevel('yes')
    .accessibilityText(this.prop.text as Resource)
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .backgroundColor($r('app.color.transparent'))
    .borderRadius($r('sys.float.corner_radius_level4'))
    .enabled(this.prop.isEnabled)
    .onClick((event: ClickEvent) => {
      this.prop.isShowPopup = false;
      this.prop.onClick?.(event);
    })
    .bindPopup(this.prop.isShowPopup, {
      builder: this.buildPopup(),
      placement: this.prop.popupOptions?.placement,
      autoCancel: this.prop.popupOptions?.autoCancel,
      mask: this.prop.popupOptions?.mask,
      onStateChange: (event) => {
        this.prop.popupOptions.onStateChange?.(event);
      }
    })
  }
}