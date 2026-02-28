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

import lazy { ParamsWrapper } from '../view/actionbar/Menu';
import lazy { CompareActionRegister } from '../view/actionbar/CompareAction';
import lazy { CollageActionRegister } from '../view/actionbar/CollageAction';
import lazy { SelectionActionRegister } from '../view/actionbar/SelectionAction';
import lazy { ActionRegister } from '../view/actionbar/ActionRegister';
import lazy { Action } from '../view/browserOperation/Action';
import lazy { AppBarController, AppBarElementBuilder } from '../view/actionbar/AppBar';
import lazy { ActionButtonProp } from '../view/actionbar/ActionButton';
import lazy { MoreActionProp } from '../view/actionbar/MoreAction';

/* instrument ignore file */
/**
 * 菜单项注册工具类
 */
export class ActionUtils {
  /**
   * 通用菜单项处理
   */
  private static readonly registers: ActionRegister[] = [
    new CollageActionRegister(),
    new CompareActionRegister(),
    new SelectionActionRegister()
  ];

  /**
   * 注册
   *
   * @param params 参数
   */
  public static register(params: ParamsWrapper): void {
    if (!params) {
      return;
    }
    ActionUtils.registers.forEach((value: ActionRegister, index: number) => value.register(params));
  }

  /**
   * 获取按钮的Prop
   * @param controller 控制器
   * @param action action
   * @returns prop
   */
  public static getProp(controller: AppBarController, action: Action): ActionButtonProp | undefined {
    if (!controller || !controller.builders || !action) {
      return undefined;
    }

    let props: (ActionButtonProp | undefined)[] = ActionUtils.getProps(controller);
    for (let prop of props) {
      if (prop?.action === action) {
        return prop;
      }
    }
    return undefined;
  }

  /**
   * 获取AppBar中所有的prop
   * @param controller 控制器
   * @returns 所有Action的prop
   */
  public static getProps(controller: AppBarController): (ActionButtonProp | undefined)[] {
    if (!controller || !controller.builders) {
      return [];
    }
    let props: (ActionButtonProp | undefined)[] = [];
    for (let builder of controller.builders) {
      if (!(builder?.builderParams instanceof ActionButtonProp)) {
        continue;
      }
      let prop = builder.builderParams as ActionButtonProp;
      props.push(prop);

      if (prop?.action === Action.MORE) {
        props.push(...ActionUtils.getPropFromBuilders((prop as MoreActionProp)?.builders ?? []));
      }
    }
    return props.filter((value: ActionButtonProp | undefined) => value !== undefined);
  }

  private static getPropFromBuilders(builders: (AppBarElementBuilder | undefined)[]): (ActionButtonProp | undefined)[] {
    if (!builders) {
      return [];
    }
    let props: ActionButtonProp[] = [];
    for (let builder of builders) {
      if (!(builder?.builderParams instanceof ActionButtonProp)) {
        continue;
      }
      let prop = builder.builderParams as ActionButtonProp;
      props.push(prop);
    }
    return props;
  }

  /**
   * 设置为沉浸式样式
   * @param controller 控制器
   */
  public static setImmersiveStyle(controller: AppBarController): void {
    if (!controller) {
      return;
    }
    let props = ActionUtils.getProps(controller);
    for (let prop of props) {
      if (!prop) {
        continue;
      }
      prop.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THIN;
      prop.backgroundColor = $r('app.color.icon_bg_color_immersive');
      prop.fillColor = '#FFFFFF';
    }
    controller.backgroundBlurStyle = BlurStyle.NONE;
  }
}