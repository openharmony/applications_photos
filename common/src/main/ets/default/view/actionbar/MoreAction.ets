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

import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionButtonProp, applyPcStyles, DefaultActionButtonProp } from './ActionButton';
import lazy { AppBarElementBuilder } from './AppBar';
import lazy { ActionViewModel, MenuConstants, MenuHelper, ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { Log } from '../../utils/Log';
import lazy { Constants } from '../../model/common/Constants';
import lazy { ActionWrapper } from '../../interface/ActionWrapper';
import lazy { SubMenuBuilderParam } from './ActionButton';
import lazy { LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';
import lazy { AppBarStyles } from './AppBarStyles';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { VIDEO_SPLICING } from './VideoSplicingAction';
import { ConfigurationConstant } from '@kit.AbilityKit';

export const MORE_MENU_ITEM_HEIGHT: Length |
undefined = DeviceInfo.isPc() ? Constants.MENU_ITEM_HEIGHT_PC : (DeviceInfo.isTv() ? '71vp' : undefined);

/* instrument ignore file */
const TAG = 'MoreAction';

/**
 * 按钮属性，手机平板等场景使用
 */
@Observed
export class MoreActionProp extends DefaultActionButtonProp {
  public action = Action.MORE;
  public icon = Action.MORE.iconRes;
  public text: string | Resource = Action.MORE.textRes;
  public key = 'ActionButton_' + Action.MORE.componentKey;

  public transitionEffect: TransitionEffect = TransitionEffect.IDENTITY;
  /**
   * 更多菜单里选项的builder
   */
  public builders: (AppBarElementBuilder | undefined)[] = [];
  /**
   * 菜单点击工具类
   */
  public menuHelper: MenuHelper | undefined = undefined;
  public isShowIcon: boolean | undefined = undefined;

  public refreshMenu(): void {
    this.builders = this.builders.slice();
  }

  public menuItemGroupDivider: DividerStyleOptions | undefined = {
    strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
    // color: $r('sys.color.ohos_id_color_list_separator'),
    color:'#00FFFFFF',
    startMargin: LengthMetrics.vp(Constants.MENU_DIVIDER_START_MARGIN - Constants.MENU_ITEM_START_MARGIN),
    endMargin: LengthMetrics.vp(Constants.MENU_DIVIDER_END_MARGIN - Constants.MENU_ITEM_START_MARGIN),
  }
  public menuItemDivider: DividerStyleOptions | undefined = undefined
}

export function getIconStatus(prop: ActionButtonProp): boolean {
  return prop.action?.actionID === VIDEO_SPLICING.actionID;
}

export function isDarkMode(themeColorMode: ConfigurationConstant.ColorMode): boolean {
  return themeColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
}
/**
 * 按钮属性，PC场景使用
 */
@Observed
export class MoreActionPropPc extends MoreActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 更多菜单项Builder
 * @param obj 属性
 */
@Builder
export function moreActionBuilder(obj: Object | undefined) {
  MoreActionButton({ prop: obj as MoreActionProp })
}

/**
 * 工具栏场景更多菜单项Builder
 * @param obj 属性
 */
@Builder
export function moreToolBuilder(obj: Object | undefined) {
  MoreToolButton({ prop: obj as MoreActionProp })
}

/**
 * 沉浸式更多菜单项Builder
 * @param obj 属性
 */
@Builder
export function immersiveMoreActionBuilder(obj: Object | undefined) {
  ImmersiveMoreButton({ prop: obj as MoreActionProp })
}

/**
 * 当前组件暂不支持继承，待组件支持继承后再整改为继承ActionButton
 */
@Component
export struct MoreActionButton {
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  @State @Watch('onPropChanged') public prop: MoreActionProp = new MoreActionProp();
  @State public overrideProp: MoreActionProp | undefined = undefined;
  @State public disableMenu: boolean = false;
  @State public disableClick: boolean = false;
  @State private propList: ActionButtonProp[] = [];
  @StorageProp('currentColorMode') private themeColorMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;

  aboutToAppear(): void {
    this.onPropChanged();
  }

  onPropChanged(): void {
    let newProps: ActionButtonProp[] = MoreActionRegister.buildProps(this.prop.builders);
    if (MoreActionRegister.isMenuChanged(this.propList, newProps)) {
      MoreActionRegister.printMenu(this.propList, newProps);
      this.propList = newProps;
    }
  }

  @Builder
  subMenuBuilder(prop: ActionButtonProp) {
    prop.customSubMenuBuilder?.builder({ param: prop.customSubMenuBuilderParam } as SubMenuBuilderParam);
  }

  @Builder
  MenuItemBuilder(prop: ActionButtonProp) {
    MenuItem(prop.hasSubMenu ? {
      symbolStartIcon: this.prop.isShowIcon && !getIconStatus(prop) ? new SymbolGlyphModifier(prop.icon) : undefined,
      startIcon: this.prop.isShowIcon && getIconStatus(prop) ?
          isDarkMode(this.themeColorMode) ? $r('app.media.video_splicing_dark') : prop.icon : undefined,
      content: prop.text ?? '',
      builder: this.subMenuBuilder(prop)
    } : {
      symbolStartIcon: this.prop.isShowIcon && !getIconStatus(prop) ? new SymbolGlyphModifier(prop.icon) : undefined,
      startIcon: this.prop.isShowIcon && getIconStatus(prop) ?
          isDarkMode(this.themeColorMode) ? $r('app.media.video_splicing_dark') : prop.icon : undefined,
      content: prop.text ?? ''
    })
      .width($r('app.float.more_menu_width'))
      .height(MORE_MENU_ITEM_HEIGHT)
      .contentFont({ weight: 'medium' })
      .key('ActionBarButton_Text_' + prop.key ?? new Date().getTime().toString())
      .enabled(prop.isEnabled)
      .onClick((event: ClickEvent): void => {
        this.prop.menuHelper?.onMenuClicked(prop.action);
      })
  }
  @Builder
  moreMenu() {
    Menu() {
      ForEach(this.propList, (prop: ActionButtonProp): void => {
          MenuItemGroup() {
          this.MenuItemBuilder(prop)
        }
      }, (prop: ActionButtonProp) => `MoreMenuItemGroup_${prop.key}`)
      //todo 需要一个空的MenuItem不然单个菜单偶现不展示
        MenuItem()
    }
    .menuItemGroupDivider(this.prop.menuItemGroupDivider)
    .width($r('app.float.more_menu_width'))
    .radius($r('sys.float.corner_radius_level10'))
    .borderRadius($r('sys.float.corner_radius_level10'))
    .key('MoreAction_Menu')
    // .subMenuExpandingMode(SubMenuExpandingMode.EMBEDDED_EXPAND)
  }

  build() {
    Button(this.overrideProp ? this.overrideProp.options : this.prop.options) {
      SymbolGlyph(this.prop.icon)
        .draggable(false)
        .fontSize($r('app.float.icon_size'))
        .fontColor([this.prop.fillColor])
        .key(this.prop.key)
    }
    .transition(this.overrideProp ? this.overrideProp.transitionEffect : this.prop.transitionEffect)
    .width(this.overrideProp ? this.overrideProp.width : $r('app.float.action_bar_button_height'))
    .height(this.overrideProp ? this.overrideProp.height : $r('app.float.action_bar_button_height'))
    .enabled(this.overrideProp ? this.overrideProp.isEnabled : this.prop.isEnabled)
    .backgroundColor(this.overrideProp ? this.overrideProp.backgroundColor : this.prop.backgroundColor)
    .backgroundBlurStyle(this.prop.backgroundBlurStyle, {}, {disableSystemAdaptation: true})
    .borderRadius(this.prop.borderRadius)
    .onClick(this.disableClick ? undefined : (event: ClickEvent) => this.prop.onClick?.(event))
    .bindMenu(this.disableMenu ? undefined : this.moreMenu, { placement: Placement.Top })
    .accessibilityText(this.rsc.toString(this.prop.text))
    .key(this.prop.action.componentKey)
  }
}

@Component
export struct MoreToolButton {
  @State @Watch('onPropChanged') public prop: MoreActionProp = new MoreActionProp();
  @State private overrideProp: MoreActionProp = new MoreActionProp();
  @State private propList: ActionButtonProp[] = [];
  private cancelKey: string = 'ActionButton_' + Action.CANCEL.componentKey;
  @StorageProp('currentColorMode') private themeColorMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;

  onPropChanged(): void {
    let newProps: ActionButtonProp[] = MoreActionRegister.buildProps(this.prop.builders);
    if (MoreActionRegister.isMenuChanged(this.propList, newProps)) {
      MoreActionRegister.printMenu(this.propList, newProps);
      this.propList = newProps;
    }
  }

  aboutToAppear(): void {
    // 工具栏场景，禁用启用状态只需要控制外部的套壳Button，内部的Button不需要设置禁用启用状态
    this.overrideProp.options = { type: ButtonType.Normal, stateEffect: false };
    this.overrideProp.isEnabled = true;
    this.overrideProp.backgroundColor = $r('app.color.transparent');
    this.overrideProp.width = $r('app.float.icon_size');
    this.overrideProp.height = $r('app.float.icon_size');
    this.overrideProp.borderRadius = 0;
    this.onPropChanged();
  }

  @Builder
  MenuItemBuilder(prop: ActionButtonProp) {
    MenuItem({
      symbolStartIcon: this.prop.isShowIcon && !getIconStatus(prop) ? new SymbolGlyphModifier(prop.icon) : undefined,
      startIcon: this.prop.isShowIcon && getIconStatus(prop) ?
          isDarkMode(this.themeColorMode) ? $r('app.media.video_splicing_dark') : prop.icon : undefined,
      content: prop.text ?? '',
    })
      .height(MORE_MENU_ITEM_HEIGHT)
      .contentFont({ weight: 'medium' })
      .key('ActionBarButton_Text_' + prop.key ?? new Date().getTime().toString())
      .enabled(prop.isEnabled)
      .onClick((event: ClickEvent): void => {
        this.prop.menuHelper?.onMenuClicked(prop.action);
      })
  }

  @Builder
  moreMenu() {
    Menu() {
      ForEach(this.propList, (prop: ActionButtonProp): void => {
        MenuItemGroup() {
          this.MenuItemBuilder(prop)
        }
      })
    }
    .menuItemGroupDivider(this.prop.menuItemGroupDivider)
    .width($r('app.float.more_menu_width'))
    .radius($r('sys.float.corner_radius_level10'))
    .borderRadius($r('sys.float.corner_radius_level10'))
    .key('MoreAction_Menu')
  }

  build() {
    Button({ type: ButtonType.Normal, stateEffect: false }) {
      Column() {
        MoreActionButton({
          prop: this.prop,
          overrideProp: this.overrideProp,
          disableMenu: true,
          disableClick: true,
        })

        Text(this.prop.text)
          .fontSize($r('sys.float.Caption_M'))
          .draggable(false)
          .key(`ToolBar_Text_${this.prop.key}`)
          .maxFontScale(1.0)
          .minFontScale(1.0)
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .margin({ top: $r('app.float.action_button_title_margin') })
      }
      .width($r('app.float.crop_action_hot_zone'))
      .height($r('app.float.crop_action_hot_zone'))
      .justifyContent(this.prop.justifyContent)
    }
    .key(`ToolBarButton_${this.prop.key}`)
    .accessibilityLevel('yes')
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .backgroundColor($r('app.color.transparent'))
    .borderRadius($r('sys.float.corner_radius_level4'))
    .enabled(this.prop.isEnabled)
    .bindMenu(this.moreMenu, { placement: Placement.Top })
    .accessibilityText(this.prop.text as Resource)
    .accessibilityNextFocusId(this.prop.key === Action.MORE.componentKey ? this.cancelKey : undefined)
  }
}

/**
 * 组件
 */
@Component
export struct ImmersiveMoreButton {
  @State @Watch('onPropChanged') public prop: MoreActionProp = new MoreActionProp();
  @State private dummyProp: MoreActionProp = new MoreActionProp();

  aboutToAppear(): void {
    this.onPropChanged();
  }

  private onPropChanged(): void {
    // 必须在保持内部Button不禁用的状态下，才能达到UX设计效果
    Log.info(TAG, 'ImmersiveButton onPropChanged');
    this.dummyProp.options = this.prop.options;
    this.dummyProp.icon = this.prop.icon;
    this.dummyProp.backgroundColor = this.prop.backgroundColor;
    this.dummyProp.backgroundBlurStyle = this.prop.backgroundBlurStyle;
    this.dummyProp.fillColor = AppBarStyles.BUTTON_FILL_COLOR_IMMERSIVE;
    this.dummyProp.fontColor = this.prop.fontColor;
  }

  build() {
    if (this.prop.isEnabled) {
      MoreActionButton({ prop: this.prop })
    } else {
      MoreActionButton({ prop: this.dummyProp }).enabled(false)
    }
  }
}

/**
 * 更多Action注册类
 */
export class MoreActionRegister extends ActionRegister {
  private readonly registers: ActionRegister[];

  public constructor(registers: ActionRegister[]) {
    super();
    this.registers = registers;
  }

  public getActions(): Action[] {
    return [Action.MORE];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new MoreActionViewModel();
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new MoreActionPropPc() : new MoreActionProp();
  }

  public buildView(action: Action, params: ParamsWrapper): AppBarElementBuilder | undefined {
    if (!params) {
      return undefined;
    }

    // 更多菜单里的按钮不需要再往通用appbar里塞，只需要注册到MenuHelper即可，将KEY_APP_BAR_CONTROLLER参数置空
    let skipViewParams: ParamsWrapper = new ParamsWrapper();
    params.params.forEach((value: Object, key: string) => {
      if (key === MenuConstants.KEY_APP_BAR_CONTROLLER) {
        return;
      }
      skipViewParams.set(key, value);
    });

    let builders: (AppBarElementBuilder | undefined)[] = [];
    let collector: Map<string, ActionWrapper> | undefined =
      params.get<Map<string, ActionWrapper>>(MenuConstants.KEY_ACTION_COLLECTOR);
    this.registers?.forEach((register: ActionRegister) => {
      let actions: Action[] = register.getActions();
      if (!actions) {
        return;
      }
      for (let action of actions) {
        register.register(skipViewParams);
        let builder: AppBarElementBuilder | undefined = register.buildView(action, skipViewParams);
        let prop: ActionButtonProp | undefined = collector?.get(action.componentKey)?.controller as ActionButtonProp;
        if (builder && prop) {
          builder.builderParams = prop;
        }
        builders.push(builder);
      }
    });

    let prop: MoreActionProp =
      (collector?.get(action.componentKey)?.controller ?? this.buildViewProp(action, params)) as MoreActionProp;
    if (!params?.get<MenuHelper>(MenuConstants.KEY_IS_MORE_MENU_HIDING)) {
      prop.builders = builders;
    }
    prop.menuHelper = params?.get<MenuHelper>(MenuConstants.KEY_MENU_HELPER);
    return {
      builder: params?.get<((prop: Object | undefined) => void)>(MenuConstants.KEY_CUSTOM_MORE_ACTION_BUILDER) ??
        moreActionBuilder,
      builderParams: prop,
      key: prop.key ?? new Date().getTime().toString(),
    };
  }

  public static buildProps(builders: (AppBarElementBuilder | undefined)[]): ActionButtonProp[] {
    let newProps: ActionButtonProp[] = [];
    for (let builder of builders) {
      if (!(builder?.builderParams instanceof ActionButtonProp)) {
        continue;
      }
      let prop: ActionButtonProp = builder.builderParams;
      if (!prop.isHidden) {
        newProps.push(prop);
      }
    }
    return newProps;
  }

  public static isMenuChanged(oldPropList: ActionButtonProp[], newPropList: ActionButtonProp[]): boolean {
    if (newPropList.length !== oldPropList.length) {
      return true;
    }
    for (let i: number = 0; i < newPropList.length; i++) {
      let newProp: ActionButtonProp = newPropList[i];
      let oldProp: ActionButtonProp = oldPropList[i];
      if (newProp !== oldProp) {
        return true;
      }
    }
    return false;
  }

  public static printMenu(oldPropList: ActionButtonProp[], newPropList: ActionButtonProp[]): void {
    let oldProp: string[] = oldPropList.map((prop: ActionButtonProp) => `${prop.action?.componentKey}`);
    let newProp: string[] = newPropList.map((prop: ActionButtonProp) => `${prop.action?.componentKey}`);
    Log.info(TAG, `menu (${oldProp.join(', ')})->(${newProp.join(', ')})`);
  }
}

/**
 * VM层
 */
export class MoreActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    // 更多按钮不需要响应点击
  }
}