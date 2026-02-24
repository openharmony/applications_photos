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
import lazy { SelectionActionRegister } from '../view/actionbar/SelectionAction';
import lazy { ActionRegister } from '../view/actionbar/ActionRegister';
import lazy { Action } from '../view/browserOperation/Action';
import lazy { AppBarController, AppBarElementBuilder } from '../view/actionbar/AppBar';
import lazy { ActionButtonProp } from '../view/actionbar/ActionButton';
import lazy { MoreActionProp } from '../view/actionbar/MoreAction';
import lazy { MoreGroupActionProp } from '../view/actionbar/MoreGroupAction';
import lazy { AppBarStyles } from '../view/actionbar/AppBarStyles';
import lazy { PhotoAsset } from '../../default/access/UserFileManagerAccess';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';

const TAG: string = 'ActionUtils';

/* instrument ignore file */
/**
 * 菜单项注册工具类
 */
export class ActionUtils {
  /**
   * 通用菜单项处理
   */
  private static readonly registers: ActionRegister[] = [
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
    ActionUtils.registers.forEach((value: ActionRegister, index: number) => {
      value.register(params)
    });
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
   * 获取所有在ActionBar栏显示按钮的ActionProps列表(不包括More内的Action)
   *
   * @param controller 控制器
   * @returns 所有显示按钮的ActionProps列表
   */
  public static getPropsWithoutMore(controller: AppBarController): (ActionButtonProp | undefined)[] {
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
    }
    return props.filter((value: ActionButtonProp | undefined) => value !== undefined);
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
        if (prop instanceof MoreGroupActionProp) {
          props.push(...ActionUtils.getPropFromDoubleBuilders(prop.builders));
        }
        if (prop instanceof MoreActionProp) {
          props.push(...ActionUtils.getPropFromBuilders(prop.builders));
        }
      }
    }
    return props.filter((value: ActionButtonProp | undefined) => value !== undefined);
  }

  private static getPropFromBuilders(builders: (AppBarElementBuilder | undefined)[]): ActionButtonProp[] {
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
   * Pc的 Action.MORE 是双层结构 需要两个循环来取pops
   */
  private static getPropFromDoubleBuilders(builders: (AppBarElementBuilder | undefined)[][]): ActionButtonProp[] {
    let props: ActionButtonProp[] = [];
    for (let arr of builders) {
      for (let builder of arr) {
        if (!(builder?.builderParams instanceof ActionButtonProp)) {
          continue;
        }
        let prop = builder.builderParams as ActionButtonProp;
        props.push(prop);
      }
    }
    return props;
  }

  /**
   * 设置为沉浸式样式
   * @param controller 控制器
   */
  public static setImmersiveStyle(controller: AppBarController, isImmersive: boolean): void {
    if (!controller) {
      return;
    }
    let props = ActionUtils.getProps(controller);
    for (let prop of props) {
      if (!prop) {
        continue;
      }
      prop.backgroundBlurStyle = BlurStyle.NONE;
      prop.backgroundColor = isImmersive ? $r('app.color.icon_bg_color_immersive') : AppBarStyles.BUTTON_BG_COLOR;
      prop.fillColor = isImmersive ? '#FFFFFF' : AppBarStyles.BUTTON_FILL_COLOR;
      prop.fontColor = prop.fillColor;
    }
    controller.backgroundBlurStyle = isImmersive ? BlurStyle.NONE : BlurStyle.COMPONENT_THICK;
  }

  /**
   * 设置为沉浸式样式 隐藏相册
   * @param controller 控制器
   */
  public static setHiddenAlbumImmersiveStyle(controller: AppBarController, isImmersive: boolean,
    hasUnFavoriteStatus: boolean): void {
    if (!controller) {
      return;
    }
    let props = ActionUtils.getProps(controller);
    for (let prop of props) {
      if (!prop) {
        continue;
      }
      prop.backgroundBlurStyle = isImmersive ? BlurStyle.COMPONENT_ULTRA_THIN : BlurStyle.NONE;
      prop.backgroundColor = isImmersive ? $r('app.color.icon_bg_color_immersive') : AppBarStyles.BUTTON_BG_COLOR;
      if (prop.action === Action.FAVORITE) {
        prop.fillColor = isImmersive ? $r('app.color.icon_fill_color_immersive') :
          hasUnFavoriteStatus ? AppBarStyles.BUTTON_FILL_COLOR : AppBarStyles.FAVORITE_BUTTON_FILL_COLOR;
        prop.fontColor = isImmersive ? $r('app.color.icon_fill_color_immersive') : AppBarStyles.BUTTON_FILL_COLOR;
      } else {
        prop.fillColor = isImmersive ? $r('app.color.icon_fill_color_immersive') : AppBarStyles.BUTTON_FILL_COLOR;
        prop.fontColor = prop.fillColor;
      }
    }
    controller.backgroundBlurStyle = isImmersive ? BlurStyle.NONE : BlurStyle.COMPONENT_THICK;
  }

  /**
   * 设置为模糊式样式 隐藏相册
   * @param controller 控制器
   */
  public static setHiddenAlbumBackgroundStyle(controller: AppBarController, isImmersive: boolean,
    hasUnFavoriteStatus: boolean, isSupportBlur: boolean): void {
    if (!controller) {
      return;
    }
    let props = ActionUtils.getProps(controller);
    for (let prop of props) {
      if (!prop) {
        continue;
      }
      prop.backgroundBlurStyle = BlurStyle.NONE;
      prop.backgroundColor = isImmersive ? $r('app.color.icon_bg_color_immersive') : AppBarStyles.BUTTON_BG_COLOR;
      if (prop.action === Action.FAVORITE) {
        prop.fillColor = isImmersive ? $r('app.color.icon_fill_color_immersive') :
          hasUnFavoriteStatus ? AppBarStyles.BUTTON_FILL_COLOR : AppBarStyles.FAVORITE_BUTTON_FILL_COLOR;
        prop.fontColor = isImmersive ? $r('app.color.icon_fill_color_immersive') : AppBarStyles.BUTTON_FILL_COLOR;
      } else {
        prop.fillColor = isImmersive ? $r('app.color.icon_fill_color_immersive') : AppBarStyles.BUTTON_FILL_COLOR;
        prop.fontColor = prop.fillColor;
      }
    }
    controller.backgroundBlurStyle = isImmersive ? BlurStyle.NONE : BlurStyle.COMPONENT_THICK;
    controller.backgroundColor = isImmersive || isSupportBlur ? $r('app.color.transparent') :
      $r('app.color.start_ability_background_color');
  }
}

export interface HistoryOperation {
  action: number;
  photoUri: string[];
  photoAsset: PhotoAsset[];
  dataCount: number;
};

export interface HistoryOperationGroup extends HistoryOperation {
  photoAssetGroup?: PhotoAsset[][];
  uriGroup?: string[][];
};
