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
import lazy { ActionWrapper } from '../../interface/ActionWrapper';
import lazy { Action } from '../browserOperation/Action';
import lazy { actionBuilder, ActionButtonProp } from './ActionButton';
import lazy { AppBarController, AppBarElementBuilder } from './AppBar';
import lazy { ActionModel, ActionViewModel, MenuConstants, MenuHelper, ParamsWrapper } from './Menu';
import lazy { AppBarStyles } from './AppBarStyles';

/**
 * 菜单项注册处理
 */
export abstract class ActionRegister {
  public static readonly ACTION_BAR_CONTROLLER: string = 'com.ohos.photos.action_register.action_bar_controller';
  public static readonly TOOL_BAR_CONTROLLER: string = 'com.ohos.photos.action_register.tool_bar_controller';

  /**
   * 注册
   *
   * @param params 参数
   */
  public register(params: ParamsWrapper): void {
    /* instrument ignore if*/
    if (!params) {
      return;
    }
    let menuHelper: MenuHelper = params.get<MenuHelper>(MenuConstants.KEY_MENU_HELPER);
    /* instrument ignore if*/
    if (!menuHelper) {
      return;
    }
    let actions: Action[] = this.getActions();
    /* instrument ignore if*/
    if (!actions) {
      return;
    }
    for (let action of actions) {
      let collector: Map<string, ActionWrapper> | undefined =
        params.get<Map<string, ActionWrapper>>(MenuConstants.KEY_ACTION_COLLECTOR);
      let wrap: ActionWrapper = collector?.get(action.componentKey) ?? {
        viewModel: this.buildViewModel(action, params),
        model: this.buildModel(action, params),
      };
      collector?.set(action.componentKey, wrap);
      menuHelper.register(action, wrap);
      let controller: AppBarController = params.get<AppBarController>(MenuConstants.KEY_APP_BAR_CONTROLLER);
      let builder: AppBarElementBuilder | undefined = this.buildView(action, params);
      if (builder && builder.builderParams instanceof ActionButtonProp) {
        builder.builderParams = wrap.controller ?? builder.builderParams;
        wrap.controller = builder.builderParams;
        let prop = builder.builderParams as ActionButtonProp;
        prop.onClick = prop.onClick ?? ((event: ClickEvent) => menuHelper.onMenuClicked(action));
        prop.transitionEffect = TransitionEffect.OPACITY.animation({duration: AppBarStyles.MULTISELECT_ANIMATION_DURATION, curve: Curve.Sharp});
      }

      if (controller && builder) {
        controller.builders?.push(builder);
      }
    }
  }

  /**
   * 获取支持的Action
   * @returns
   */
  public abstract getActions(): Action[];

  /**
   * 构造VM层
   * @param action action
   * @param params 参数
   * @returns VM层实现
   */
  protected abstract buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined;

  /**
   * 构造M层
   * @param action action
   * @param params 参数
   * @returns M层
   */
  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    return undefined;
  }

  /**
   * 构造View层
   * @param action action
   * @param params 参数
   * @returns V层
   */
  public buildView(action: Action, params: ParamsWrapper): AppBarElementBuilder | undefined {
    let prop: ActionButtonProp = this.buildViewProp(action, params);

    return {
      builder: this.buildActionBuilder(action, params),
      builderParams: prop,
      key: prop?.key ?? new Date().getTime().toString(),
    };
  }

  /**
   * 构造View层属性
   * @param action action
   * @param params 参数
   * @returns V层属性
   */
  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new ActionButtonProp();
  }

  /**
   * 构造View层Builder
   * @param action action
   * @param params 参数
   * @returns V层Builder
   */
  public buildActionBuilder(action: Action, params: ParamsWrapper): (params: Object | undefined) => void {
    return params?.get<((prop: Object |
    undefined) => void)>(MenuConstants.KEY_CUSTOM_ACTION_BUILDER) ?? actionBuilder;
  }
}