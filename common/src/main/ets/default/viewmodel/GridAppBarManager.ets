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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { ActionUtils } from '..//utils/ActionUtils';
import lazy { Action } from '../view/browserOperation/Action';
import lazy { ComponentLifecycleRegistry } from '../view/ComponentLifecycle';
import lazy { AppBarStyles } from '../view/actionbar/AppBarStyles';
import lazy { ActionRegister } from '../view/actionbar/ActionRegister';
import lazy { ActionButtonProp } from '../view/actionbar/ActionButton';
import lazy { CommAppBarStyler } from '../view/actionbar/CommAppBarStyler';
import lazy { MenuConstants, MenuHelper, ParamsWrapper } from '../view/actionbar/Menu';
import lazy { AppBarController, AppBarElementBuilder, AppBarStyler } from '../view/actionbar/AppBar';
import lazy { firstLevelTitleBuilder, FirstLevelTitleProp, } from '../view/actionbar/FirstLevelTitle';
import lazy { ActionWrapper } from '../interface/ActionWrapper';
import lazy { getScreen, ScreenManager } from '../model/common/ScreenManager';
import lazy { NavigationBroadCastManager } from '../model/common/NavigationBroadCastManager';

/**
 * actionBarManager 管理类基础接口
 */
export interface AppBarManager {
  actionBarController: AppBarController,
  toolbarController?: AppBarController,
  init: (params: ParamsWrapper) => void,
  release: () => void,

  /**
   * 初始化 (init之后 updateLayout之前)
   */
  extraInit?: () => void,

  /**
   * AppBar 注册元素(action/title)
   * 具体注册哪些元素 由product层 子类实现
   */
  registerAppBar: () => void,

  /**
   * AppBar 更新已注册元素(action/title)的 prop(使能 显隐)
   * 具体更新哪些元素 由product层 子类实现
   */
  updateAppBar?: () => void,
}

const TAG: string = 'GridAppBarManager';

/**
 * actionBar 管理类 负责主流程和公共事件处理 子类对接具体业务
 */
export class GridAppBarManager implements AppBarManager {
  public static readonly KEY_INSTANCE_ID: string = 'KEY_INSTANCE_ID';
  public static readonly KEY_CONTEXT: string = 'KEY_CONTEXT';
  public static readonly KEY_UI_CONTEXT: string = 'KEY_UI_CONTEXT';
  public static readonly KEY_NAV_PATH_STACK: string = 'KEY_NAV_PATH_STACK';
  public static readonly KEY_BROADCAST: string = 'KEY_BROADCAST';
  public static readonly KEY_LIFECYCLE: string = 'KEY_LIFECYCLE';
  public static readonly KEY_BROWSER_CONTROLLER: string = 'KEY_BROWSER_CONTROLLER';
  public static readonly BUILDER_KEY_TITLE: string = 'Grid_Title';
  public static readonly KEY_IS_USE_DOUBLE_CLICK: string = 'KEY_IS_USE_DOUBLE_CLICK';
  /**
   * View层Controller，对外提供
   */
  @Track public actionBarController: AppBarController = new AppBarController();
  /**
   * 样式控制器
   */
  protected actionBarStyler: AppBarStyler | undefined;
  /**
   * 菜单点击处理分发（Action形式）
   */
  protected readonly menuHelper: MenuHelper = new MenuHelper();
  /**
   * 用于放非Action类的builder，不需要每次都创建
   */
  protected readonly elements: Map<string, AppBarElementBuilder> = new Map();
  /**
   * 用于放actions，不需要每次都创建M/V/VM
   */
  protected readonly actions: Map<string, ActionWrapper> = new Map();
  /**
   * 初始化参数
   */
  protected initParams: ParamsWrapper | undefined = undefined;
  protected instanceId: number = 0;
  protected context: Context | undefined;
  protected uiContext: UIContext | undefined;
  protected broadCast: BroadCast | undefined;
  private lifecycle: ComponentLifecycleRegistry | undefined;
  /**
   * 屏幕形态改变
   */
  protected readonly onLayoutChangedFunc = () => {
    Log.info(TAG, 'onLayoutChangedFunc');
    this.updateLayout();
  };

  /**
   * AppBar onAreaChange 回调
   */
  private readonly onAppBarAreaChangedFunc = (oldValue: Area, newValue: Area) => {
    this.onAppBarAreaChange(oldValue, newValue)
  };

  /**
   * 初始化
   */
  public init(params: ParamsWrapper): void {
    Log.info(TAG, 'init');
    this.initParams = params;
    this.instanceId = params.get<number>(GridAppBarManager.KEY_INSTANCE_ID) ?? 0;
    this.context = params.get<Context>(GridAppBarManager.KEY_CONTEXT);
    this.uiContext = params.get<UIContext>(GridAppBarManager.KEY_UI_CONTEXT);
    this.broadCast = params.get<BroadCast>(GridAppBarManager.KEY_BROADCAST);
    this.lifecycle = params.get<ComponentLifecycleRegistry>(GridAppBarManager.KEY_LIFECYCLE);

    // 顶部ActionBar与底部ToolBar各自控制（放入的元素/形态/位置等）
    this.actionBarStyler =
      this.actionBarStyler ?? new CommAppBarStyler(getContext(), this.actionBarController, getScreen());
    this.actionBarStyler?.register?.();

    this.actionBarController.key = 'titleBar';
    this.actionBarController.zIndex = 500;
    this.actionBarController.onAreaChange = this.onAppBarAreaChangedFunc;
    this.actionBarController.alignRules = {
      top: { anchor: '__container__', align: VerticalAlign.Top },
      left: { anchor: '__container__', align: HorizontalAlign.Start },
    };
    this.actionBarController.isUseDoubleClick = params.get<boolean>(GridAppBarManager.KEY_IS_USE_DOUBLE_CLICK);
    this.extraInit();
    this.updateLayout();
  }

  /**
   * 初始化 (init之后 updateLayout之前) 子类实现
   */
  public extraInit(): void {
    Log.info(TAG, 'extraInit');
    // 标题
    let titleProp: FirstLevelTitleProp = new FirstLevelTitleProp();
    titleProp.content = $r('app.string.tab_timeline');
    titleProp.maxLines = 1;
    titleProp.fontSize = AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
    let titleBuilder: AppBarElementBuilder = {
      builder: firstLevelTitleBuilder,
      builderParams: titleProp,
      key: GridAppBarManager.BUILDER_KEY_TITLE,
    };
    this.elements.set(GridAppBarManager.BUILDER_KEY_TITLE, titleBuilder);
    // 方向
    getScreen().on(ScreenManager.ON_ORIENTATION_CHANGED, this.onLayoutChangedFunc);
    // 高度改变
    getScreen().on(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, this.onLayoutChangedFunc);
  }

  /**
   * 卸载
   */
  public release(): void {
    Log.info(TAG, 'release');
    this.actionBarStyler?.unregister?.();
    for (let wrapper of this.actions.values()) {
      wrapper.model?.release?.();
      wrapper.viewModel?.release?.();
    }
    getScreen().off(ScreenManager.ON_ORIENTATION_CHANGED, this.onLayoutChangedFunc);
    getScreen().off(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, this.onLayoutChangedFunc);
  }

  /**
   * 公共参数
   */
  protected buildCommonParams(): ParamsWrapper {
    let params: ParamsWrapper = new ParamsWrapper()
      .set(ActionRegister.ACTION_BAR_CONTROLLER, this.actionBarController)
      .set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.actionBarController)
      .set(MenuConstants.KEY_MENU_HELPER, this.menuHelper)
      .set(MenuConstants.KEY_NAV_PATH_STACK, this.initParams?.get<NavPathStack>(GridAppBarManager.KEY_NAV_PATH_STACK))
      .set(MenuConstants.KEY_ACTION_COLLECTOR, this.actions)
      .set(MenuConstants.KEY_BROADCAST, this.broadCast)
      .set(MenuConstants.KEY_LIFECYCLE_REGISTRY, this.lifecycle)
      .set(MenuConstants.KEY_NAVIGATION_BROADCAST, NavigationBroadCastManager.getInstance().getBroadCast());
    return params;
  }

  /**
   * 更新actionBar
   */
  protected updateLayout(): void {
    Log.info(TAG, 'updateLayout');
    // 先清空actionBar 再重新布局
    this.actionBarController.builders = [];
    this.registerAppBar();
    this.updateAppBar();
  }

  /**
   * actionBar 注册 action
   * 具体注册哪些 action 由product子类实现
   */
  public registerAppBar(): void {
  }

  /**
   * 更新已注册action 状态(使能 显隐)
   * 具体操作哪些action 由product子类实现
   */
  public updateAppBar(): void {
  }

  /**
   * AppBar onAreaChange 触发函数
   * 根据最新宽度改变视图 由product子类实现
   */
  public onAppBarAreaChange(oldValue: Area, newValue: Area): void {
  };

  /**
   * 获取已注册 action 的 prop
   */
  protected getProp(action: Action): ActionButtonProp | undefined {
    let props: (ActionButtonProp | undefined)[] = ActionUtils.getProps(this.actionBarController);
    let prop: ActionButtonProp | undefined;
    for (let prop of props) {
      if (prop?.action === action) {
        return prop;
      }
    }
    return prop;
  }

  /**
   * 设置 action 的 isEnabled
   */
  protected setActionEnabled(action: Action, enabled: boolean) {
    let prop: ActionButtonProp | undefined = this.getProp(action);
    if (prop) {
      prop.isEnabled = enabled;
    }
  }

  /**
   * 设置 action 的 isHidden
   */
  protected setActionHidden(action: Action, isHidden: boolean) {
    let prop: ActionButtonProp | undefined = this.getProp(action);
    if (prop && prop.isHidden !== isHidden) {
      prop.isHidden = isHidden;
    }
  }
}
