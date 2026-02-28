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
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Constants } from '../../model/common/Constants';
import lazy { ActionWrapper } from '../../interface/ActionWrapper';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { AppBarElementBuilder } from './AppBar';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionViewModel, MenuConstants, MenuHelper, ParamsWrapper } from './Menu';
import lazy { ActionButtonProp, applyPcStyles, DefaultActionButtonProp } from './ActionButton';
import lazy { MultimodalInputManager } from '../../model/common/MultimodalInputManager';

const TAG = 'MoreGroupAction';

/**
 * 更多按钮Action(分组结构) 属性
 */
@Observed
export class MoreGroupActionProp extends DefaultActionButtonProp {
  public action = Action.MORE;
  public icon = Action.MORE.iconRes;
  public text: string | Resource = Action.MORE.textRes;
  public key = 'ActionButton_' + Action.MORE.componentKey;
  // 更多菜单里选项的builder
  public builders: (AppBarElementBuilder | undefined)[][] = [];
  // 菜单点击工具类
  public menuHelper: MenuHelper | undefined = undefined;
  public isShowMenu: boolean = false;

  /**
   * 刷新Menu
   */
  public refreshMenu(): void {
    this.builders = this.builders.slice();
  }
}

/**
 * 更多按钮Action(分组结构) 属性 PC场景使用
 */
@Observed
export class MoreGroupActionPropPc extends MoreGroupActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 更多按钮Action(分组结构) Builder
 * @param obj 属性
 */
@Builder
export function moreGroupActionBuilder(obj: Object | undefined) {
  MoreGroupActionButton({ prop: obj as MoreGroupActionProp })
}

@Component
export struct MoreMenuItem {
  @State public prop: ActionButtonProp = new ActionButtonProp();
  public onClickFunc: (event: ClickEvent) => void = () => {
  };

  @Builder
  CustomMenuItemBuilder() {
    if (this.prop.customMenuItemBuilder) {
      this.prop.customMenuItemBuilder.builder(this.prop);
    }
  }

  build() {
    MenuItem({
      content: this.prop.text ?? '',
      labelInfo: this.prop.labelInfo ?? '',
      builder: this.CustomMenuItemBuilder(),
      symbolStartIcon: this.prop.symbolStartIcon,
      symbolEndIcon: this.prop.symbolEndIcon,
    })
      .width('auto')
      .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })
      .height(Constants.MENU_ITEM_HEIGHT_PC)
      .contentFont({ weight: 'medium' })
      .key('ActionBarButton_Text_' + this.prop.key ?? new Date().getTime().toString())
      .enabled(this.prop.isEnabled)
      .onClick((event: ClickEvent): void => {
        this.onClickFunc(event);
      })
  }
}

/**
 * 更多按钮Action(分组结构)
 */
@Component
export struct MoreGroupActionButton {
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  @State @Watch('onPropChanged') public prop: MoreGroupActionProp = new MoreGroupActionProp();
  @State private propList: ActionButtonProp[][] = [];

  aboutToAppear(): void {
    this.onPropChanged();
  }

  onPropChanged(): void {
    let newProps: ActionButtonProp[][] = MoreGroupActionRegister.buildProps(this.prop.builders);
    if (MoreGroupActionRegister.isMenuChanged(this.propList, newProps)) {
      MoreGroupActionRegister.printMenu(this.propList, newProps);
      this.propList = newProps.filter(item => item.length > 0);
    }
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
      .padding({
        top: 12,
        bottom: 12,
        left: 16,
        right: 16,
      })
    }
  }

  @Builder
  moreMenu() {
    Menu() {
      ForEach(this.propList, (props: ActionButtonProp[], groupIndex: number): void => {
        MenuItemGroup() {
          ForEach(props, (prop: ActionButtonProp, index: number): void => {
            MoreMenuItem({
              prop: prop,
              onClickFunc: (event: ClickEvent) => {
                // 没有子菜单的MenuItem点击时把menu关闭
                if (!prop.hasSubMenu) {
                  this.prop.isShowMenu = false;
                }
                this.prop.menuHelper?.onMenuClicked(prop.action);
              },
            })
              .margin({
                top: index > 0 ? $r('sys.float.padding_level1') : undefined,
                bottom: index === props.length - 1 &&
                  groupIndex !== this.propList.length - 1 ?
                $r('sys.float.padding_level2') : undefined,
              });
          })
        }
        .margin({ top: groupIndex !== 0 ? $r('sys.float.padding_level2') : undefined })
        .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })
      })
    }
    .width($r('app.float.more_menu_width'))
    .radius($r('sys.float.corner_radius_level10'))
    .borderRadius($r('sys.float.corner_radius_level10'))
    .key('MoreGroupAction_Menu')
  }

  build() {
    Column() {
      Button(this.prop.options) {
        SymbolGlyph(this.prop.icon)
          .draggable(false)
          .fontSize($r('app.float.icon_size'))
          .fontColor([this.prop.fillColor])
          .key(this.prop.key)
      }
      .width(this.prop.width)
      .height(this.prop.height)
      .enabled(this.prop.isEnabled)
      .backgroundColor(this.prop.backgroundColor)
      .backgroundBlurStyle(this.prop.backgroundBlurStyle)
      .borderRadius(this.prop.borderRadius)
      .onClick((event: ClickEvent) => {
        this.prop.isShowMenu = true;
        this.prop.onClick?.(event);
      })
      .bindMenu(this.prop.isShowMenu, this.moreMenu,
        DeviceInfo.isPc() ? {
          showInSubWindow: false,
          onDisappear: () => {
            this.prop.isShowMenu = false;
          },
        } : {
          onDisappear: () => {
            this.prop.isShowMenu = false;
          },
        })
      .accessibilityText(this.rsc.toString(this.prop.text))
    }
    .focusable(this.prop.focusable)
    .tabIndex(this.prop.tabIndex)
    .onKeyEvent((event: KeyEvent) => {
      this.prop.onKeyEvent?.(event, this.prop);
    })
    .onHover((isHover: boolean) => {
      this.prop.isShowPopup = isHover;
    })
    .bindPopup(!this.prop.isShowMenu && this.prop.isShowPopup, {
      builder: this.buildPopup(),
      placement: this.prop.popupOptions?.placement,
      autoCancel: this.prop.popupOptions?.autoCancel,
      mask: this.prop.popupOptions?.mask,
      enableArrow: this.prop.popupOptions?.enableArrow,
      popupColor: this.prop.popupOptions?.popupColor,
      backgroundBlurStyle: this.prop.popupOptions?.backgroundBlurStyle,
      onWillDismiss: this.prop.popupOptions?.onWillDismiss,
      onStateChange: (event) => {
        this.prop.popupOptions.onStateChange?.(event);
      }
    })
  }
}

/**
 * 更多按钮Action(分组结构) 注册类
 */
export class MoreGroupActionRegister extends ActionRegister {
  public readonly registers: ActionRegister[][];

  public constructor(registers: ActionRegister[][]) {
    super();
    this.registers = registers;
  }

  public getActions(): Action[] {
    return [Action.MORE];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new MoreGroupActionViewModel();
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new MoreGroupActionPropPc() : new MoreGroupActionProp();
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

    let builders: (AppBarElementBuilder | undefined)[][] = [];
    let collector: Map<string, ActionWrapper> | undefined =
      params.get<Map<string, ActionWrapper>>(MenuConstants.KEY_ACTION_COLLECTOR);
    this.registers.forEach((arr: ActionRegister[]) => {
      const subBuilders: (AppBarElementBuilder | undefined)[] = [];
      arr.forEach((register: ActionRegister) => {
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
          subBuilders.push(builder);
        }
      });
      builders.push(subBuilders);
    })

    let prop: MoreGroupActionProp =
      (collector?.get(action.componentKey)?.controller ?? this.buildViewProp(action, params)) as MoreGroupActionProp;
    prop.builders = builders;
    prop.menuHelper = params?.get<MenuHelper>(MenuConstants.KEY_MENU_HELPER);
    return {
      builder: moreGroupActionBuilder,
      builderParams: prop,
      key: prop.key ?? new Date().getTime().toString(),
    };
  }

  public static buildProps(builders: (AppBarElementBuilder | undefined)[][]): ActionButtonProp[][] {
    let newProps: ActionButtonProp[][] = [];
    builders.forEach((arr: (AppBarElementBuilder | undefined)[]) => {
      const props: ActionButtonProp[] = [];
      for (let builder of arr) {
        if (!(builder?.builderParams instanceof ActionButtonProp)) {
          continue;
        }
        let prop: ActionButtonProp = builder.builderParams;
        if (!prop.isHidden) {
          props.push(prop);
        }
      }
      newProps.push(props);
    })
    return newProps;
  }

  /**
   * 校验双层菜单是否有变化
   */
  public static isMenuChanged(oldPropList: ActionButtonProp[][], newPropList: ActionButtonProp[][]): boolean {
    if (newPropList.length !== oldPropList.length) {
      return true;
    }
    for (let i: number = 0; i < newPropList.length; i++) {
      let newSubPropList: ActionButtonProp[] = newPropList[i];
      let oldSubPropList: ActionButtonProp[] = oldPropList[i];
      if (oldSubPropList.length !== newSubPropList.length) {
        return true;
      }
      for (let l: number = 0; l < newSubPropList.length; l++) {
        let newProp: ActionButtonProp = newSubPropList[l];
        let oldProp: ActionButtonProp = oldSubPropList[l];
        if (newProp !== oldProp) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * 日志打印
   */
  public static printMenu(oldPropList: ActionButtonProp[][], newPropList: ActionButtonProp[][]): void {
    let oldProp: string[] = oldPropList.flat().map((prop: ActionButtonProp) => `${prop.action?.componentKey}`);
    let newProp: string[] = newPropList.flat().map((prop: ActionButtonProp) => `${prop.action?.componentKey}`);
    Log.info(TAG, `menu (${oldProp.join(', ')})->(${newProp.join(', ')})`);
  }
}

/**
 * VM层
 */
export class MoreGroupActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    // 更多按钮不需要响应点击
  }
}