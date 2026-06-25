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

import lazy { Log } from '../../utils/Log';
import type { Action } from '../browserOperation/Action';
import type { MenuContext } from '../browserOperation/MenuContext';
import lazy { BigDataConstants, ReportToBigDataUtil, PhotoInfo } from '../../../../../../../common/src/main/ets/default/utils/ReportToBigDataUtil';

const TAG: string = 'MenuHelper';

/**
 * 用于通用MenuContext参数key
 */
export class MenuConstants {
  /**
   * 上下文
   */
  public static readonly KEY_CONTEXT: string = 'KEY_CONTEXT';
  /**
   * 上下文
   */
  public static readonly KEY_ALBUM_INFO: string = 'albumInfo';
  /**
   * 获取当前上下文的方法
   */
  public static readonly KEY_GET_ALBUM_INFO_FUNC: string = 'getAlbumInfoFunc';
  /**
   * 生命周期管理者
   */
  public static readonly KEY_LIFECYCLE_REGISTRY: string = 'KEY_LIFECYCLE_REGISTRY';
  /**
   * 菜单项工具类
   */
  public static readonly KEY_MENU_HELPER: string = 'KEY_MENU_HELPER';
  /**
   * menuHelper.onMenuClicked 点击业务参数
   */
  public static readonly KEY_MENU_HELPER_CLICK_PARAM: string = 'KEY_MENU_HELPER_CLICK_PARAM';
  /**
   * AppBar控制器
   */
  public static readonly KEY_APP_BAR_CONTROLLER: string = 'KEY_APP_BAR_CONTROLLER';
  /**
   * 菜单项按钮自定义builder
   */
  public static readonly KEY_CUSTOM_ACTION_BUILDER: string = 'KEY_CUSTOM_ACTION_BUILDER';
  /**
   * 更多按钮自定义builder
   */
  public static readonly KEY_CUSTOM_MORE_ACTION_BUILDER: string = 'KEY_CUSTOM_MORE_ACTION_BUILDER';
  /**
   * 导航栈
   */
  public static readonly KEY_NAV_PATH_STACK: string = 'KEY_NAV_PATH_STACK';
  /**
   * 是否pc右键点击非选中元素
   */
  public static readonly KEY_IS_FROM_SINGLE_CLICK: string = 'KEY_IS_FROM_SINGLE_CLICK';
  /**
   * 当前图片
   */
  public static readonly KEY_CURRENT_PHOTO: string = 'KEY_CURRENT_PHOTO';
  /**
   * 选择管理
   */
  public static readonly KEY_SELECTION_MANAGER: string = 'KEY_SELECTION_MANAGER';
  /**
   * 已选的解析结果
   */
  public static readonly KEY_SELECTION_PARSE_RESULT: string = 'KEY_SELECTION_PARSE_RESULT';
  /**
   * 广播器
   */
  public static readonly KEY_BROADCAST: string = 'KEY_BROADCAST';
  /**
   * 当前页面 照片页0、相册页1、时刻页2
   */
  public static readonly KEY_CURRENT_TAB_PAGE: string = 'KEY_CURRENT_TAB_PAGE';
  /**
   * navigation广播器
   */
  public static readonly KEY_NAVIGATION_BROADCAST: string = 'KEY_NAVIGATION_BROADCAST';
  /**
   * 主角星球点击切换
   */
  public static readonly KEY_PORTRAIT_ALBUM_DISPLAY_CHANGE: string = 'KEY_PORTRAIT_ALBUM_DISPLAY_CHANGE';
  /**
   * 主角星球编辑
   */
  public static readonly KEY_PORTRAIT_ALBUM_EDIT: string = 'KEY_PORTRAIT_ALBUM_EDIT';
  /**
   * 注册的Action相关信息搜集器
   */
  public static readonly KEY_ACTION_COLLECTOR: string = 'KEY_ACTION_COLLECTOR';

  public static readonly SUB_MENU_CLICKED: string = 'SUB_MENU_CLICKED';
  /**
   * album uri
   */
  public static readonly KEY_ALBUM_URI: string = 'KEY_ALBUM_FROM';
  /**
   * 更多菜单弹窗是否正在消失
   */
  public static readonly KEY_IS_MORE_MENU_HIDING: string = 'KEY_IS_MORE_MENU_HIDING';
  /**
   * from page
   */
  public static readonly KEY_PAGE_FROM_HIGHLIGHT: string = 'KEY_PAGE_FROM_HIGHLIGHT';
  /**
   * from page
   */
  public static readonly KEY_PHOTO_ALBUM: string = 'KEY_PHOTO_ALBUM';

  public static readonly KEY_ACTION: string = 'KEY_ACTION';

  public static readonly KEY_MEDIA_ITEM: string = 'KEY_MEDIA_ITEM';
  /**
   * bindSheet 状态量
   */
  public static readonly IS_BIND_SHEET_SHOW: string = 'IS_BIND_SHEET_SHOW';

  /**
   *  是否分组视图
   */
  public static readonly KEY_IS_GROUP_GRID: string = 'isGroupGrid';

  /**
   * 宫格排序管理
   */
  public static readonly KEY_SORT_HELPER: string = 'KeySortHelper';

  /**
   * 跳转来源
   */
  public static readonly KEY_JUMP_SOURCE_TO_MAIN: string = 'KEY_JUMP_SOURCE_TO_MAIN';

  /**
   * 大图场景
   */
  public static readonly KEY_BROWSER_CONTROLLER: string = 'KEY_BROWSER_CONTROLLER';

  /**
   * 新宫格长按菜单场景
   */
  public static readonly KEY_LONG_PRESS_MEDIA: string = 'KEY_LONG_PRESS_MEDIA';

  /**
   * 视频播放器controller
   */
  public static readonly KEY_VIDEO_PLAY_CONTROLLER: string = 'KEY_VIDEO_PLAY_CONTROLLER';

  /**
   * 新架构右键菜单场景
   */
  public static readonly KEY_RIGHT_CLICK_MENU: string = 'KEY_RIGHT_CLICK_MENU';

  /**
   * dataSource 数据源
   */
  public static readonly DATA_SOURCE: string = 'dataSource';

  /**
   * currentIndex 当前索引
   */
  public static readonly CURRENT_INDEX: string = 'currentIndex';

  /**
   * isThirdScene,第三方场景，例如：相机场景
   */
  public static readonly KEY_IS_THIRD_SCENE: string = 'KEY_IS_THIRD_SCENE';

  /**
   * 宮格组件dataSource 数据源
   */
  public static readonly KEY_DATASOURCE: string = 'KEY_DATASOURCE';

  /**
   * 获取Toolbar操作是否正在执行
   */
  public static readonly KEY_GET_IS_DOING_ACTION: string = 'KEY_GET_IS_DOING_ACTION';

  /**
   * 设置Toolbar操作是否正在执行
   */
  public static readonly KEY_SET_IS_DOING_ACTION: string = 'KEY_SET_IS_DOING_ACTION';
}

/**
 * 参数包装类
 */
export class ParamsWrapper {
  /**
   * 参数
   */
  public readonly params: Map<string, Object> = new Map();

  /**
   * 构造函数
   * @param other 复制参数
   */
  public constructor(other?: ParamsWrapper) {
    if (other) {
      for (let key of other.params.keys()) {
        this.set(key, other.params.get(key));
      }
    }
  }

  /**
   * 获取
   *
   * @param key 键
   * @returns 值
   */
  public get<T>(key: string): T {
    const res = this.params.get(key) as T | undefined;
    if (res || (typeof res === 'number' && res === 0)) {
      return res;
    }
    // ets ts
    return undefined as T;
  }

  /**
   * 设置参数，value传空场景清除key
   *
   * @param key 键
   * @param value 值
   * @returns 创建者模式，方便链式调用
   */
  public set(key: string, value: Object | undefined): ParamsWrapper {
    if (!key) {
      return this;
    }
    if (value === null || value === undefined) {
      this.params.delete(key);
    } else {
      this.params.set(key, value);
    }
    return this;
  }

  public getParamsInfo(): string {
    let jsonObject: Record<string, Object> = {};
    this.params.forEach((value, key) => {
      if (key !== undefined && value !== undefined) {
        jsonObject[key] = value;
      }
    });
    let info: string = JSON.stringify(jsonObject);
    return info;
  }
}

/**
 * ViewModel层，负责处理输入
 */
export interface ActionViewModel {
  /**
   * 点击处理
   * @param menuContext 上下文参数
   */
  doAction: (menuContext?: MenuContext) => void;

  /**
   * 释放资源
   */
  release?: () => void;
}

/**
 * Model层，负责构造参数及上下文
 */
export interface ActionModel {
  /**
   * 封装参数
   * @returns 参数上下文
   */
  produce: () => MenuContext | undefined;

  /**
   * 释放资源
   */
  release?: () => void;
}

/**
 * 菜单工具类，负责注册action处理者
 */
export class MenuHelper {
  public readonly actionWrappers: Map<number, ActionWrapper> = new Map();
  /**
   * 菜单操作监听派发器
   */
  protected dispatcher: ActionEventDispatcher = new ActionEventDispatcher();

  /**
   * 注册
   *
   * @param action 菜单
   * @param wrap VM层 M层
   */
  public register(
    action: Action,
    wrap: ActionWrapper,
  ): void {
    if (!action || !wrap) {
      return;
    }
    let existing: ActionWrapper | undefined = this.actionWrappers.get(action.actionID);
    if (existing) {
      Log.warn(TAG, `replacing action view model: ${action}`);
    }
    this.actionWrappers.set(action.actionID, wrap);
  }

  /**
   * 取消注册
   *
   * @param action 菜单
   * @param viewModel VM层
   */
  public unregister(action: Action): void {
    if (!action) {
      return;
    }
    Log.warn(TAG, 'MenuHelper unregister');
    this.actionWrappers.delete(action.actionID);
  }

  /**
   * 菜单项点击处理
   *
   * @param action 菜单项
   * @param params 额外参数
   */
  public onMenuClicked(action: Action | undefined, params?: ParamsWrapper): void {
    if (!action) {
      return;
    }
    Log.info(TAG, `onMenuClicked: ${action?.componentKey}`);
    let wrapper: ActionWrapper | undefined = this.actionWrappers.get(action.actionID);
    if (!wrapper) {
      Log.warn(TAG, `onMenuClicked: no valid wrapper ${action?.componentKey}`);
      return;
    }
    let menuContext: MenuContext | undefined = wrapper.model?.produce();
    let logMsg: string[] = ['onMenuClicked menuContext end'];
    logMsg.push(`menuContext: ${menuContext}`);
    logMsg.push(`params: ${params}`);
    logMsg.push(`originalAlbumUri: ${menuContext?.originalAlbumUri}`);
    Log.info(TAG,logMsg.join(','));
    if (menuContext) {
      if (params) {
        params.params.forEach((value: Object, key: string) => menuContext?.set(key, value));
      }
    }
    this.dispatcher.onActionEvent(action, params);
    wrapper.viewModel?.doAction(menuContext);
  }

  public getDispatcher(): ActionEventDispatcher {
    return this.dispatcher;
  }
}

export interface OperationListener {
  onOperationStart?: () => void;
  onOperationEnd?: (result?: Object) => void;
}

/**
 * 菜单操作监听
 */
export interface ActionListener {
  /**
   * 菜单操作监听回调
   */
  /* instrument ignore next */
  onActionEvent?: (action: Action | undefined, params?: ParamsWrapper) => void;
}

class ActionEventDispatcher implements ActionListener {
  private readonly listeners: ActionListener[] = [];

  /**
   * 回调
   */
  public onActionEvent(action: Action | undefined, params?: ParamsWrapper): void {
    for (let listener of this.listeners) {
      try {
        listener.onActionEvent?.(action, params);
      } catch (e) {
        Log.warn(TAG, `onActionEvent dispatch failed err: ${(e as Error)?.message}`);
      }
    }
  }

  /**
   * 添加菜单操作监听
   * @param listener 监听
   */
  public add(listener: ActionListener): void {
    if (!listener || this.listeners.indexOf(listener) !== -1) {
      return;
    }
    this.listeners.push(listener);
  }

  /**
   * 移除菜单操作监听
   * @param listener 监听
   */
  public remove(listener: ActionListener): void {
    if (!listener) {
      return;
    }
    let index = this.listeners.indexOf(listener);
    if (index === -1) {
      return;
    }
    this.listeners.splice(index, 1);
  }
}
