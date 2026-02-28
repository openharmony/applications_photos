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
import lazy { ActionButtonProp } from '../view/actionbar/ActionButton';
import lazy { ParamsWrapper } from '../view/actionbar/Menu';
import lazy { MultimodalInputManager } from '../model/common/MultimodalInputManager';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { common } from '@kit.AbilityKit';

const TAG: string = 'AppBarFocusController';

/**
 * appbar区域焦点管理器
 *
 * @since 2025-07-20
 */
export class AppBarFocusController {
  public static readonly KEY_UI_CONTEXT: string = 'KEY_UI_CONTEXT';

  /**
   * UI上下文
   */
  protected uiContext: UIContext | undefined;

  /**
   * 初始化参数
   */
  protected initParams: ParamsWrapper | undefined = undefined;
  private tag: string = TAG;
  private firstActionKey: string | undefined;
  private lastActionKey: string | undefined;

  // 外部业务请求切换焦点到ActionBar区域的业务回调
  private readonly onRequestActionBarFocus: () => void = () => {
    if (!this.firstActionKey) {
      Log.info(this.tag, 'onRequestActionBarFocus -> firstActionKey is undefined');
      return;
    }
    let focusResult: boolean = focusControl.requestFocus(this.firstActionKey);
    Log.info(this.tag, `onRequestActionBarFocus -> key:${this.firstActionKey}, focusResult:${focusResult}`);
  };

  /**
   * 构造器
   *
   * @param tag 日志tag
   */
  constructor(tag?: string) {
    if (tag !== undefined) {
      this.tag = tag;
    }
  }

  /**
   * 初始化函数
   *
   * @param params 初始化入参
   */
  public init(params: ParamsWrapper): void {
    Log.info(this.tag, 'AppBarFocusController init start');
    this.initParams = params;
    this.uiContext = this.initParams?.get<UIContext>(AppBarFocusController.KEY_UI_CONTEXT);
    this.registerEventHubCallbacks();
  }

  /**
   * 资源释放函数
   */
  public release(): void {
    this.unRegisterEventHubCallbacks();
  }

  /**
   * 更新Actionbar首尾Action信息
   *
   * @param props action列表
   */
  public refreshActionOrder(props: (ActionButtonProp | undefined)[]): void {
    let firstEnableProp: ActionButtonProp | undefined;
    let lastEnableProp: ActionButtonProp | undefined;
    for (let prop of props) {
      if (!prop) {
        continue;
      }
      prop.focusable = false;
      prop.onKeyEvent = undefined;
      if (!prop.isEnabled) {
        continue;
      }
      prop.focusable = true;
      prop.onKeyEvent = this.onActionBarKeyEvent;
      if (!firstEnableProp) {
        firstEnableProp = prop;
      }
      lastEnableProp = prop;
    }
    if (firstEnableProp) {
      this.firstActionKey = firstEnableProp.key;
    }
    if (lastEnableProp) {
      this.lastActionKey = lastEnableProp?.key;
    }
    Log.info(this.tag, `refreshActionOrder firstAction:${this.firstActionKey}, lastAction:${this.lastActionKey}`);
  }

  /**
   * 注册eventHub事件回调
   */
  protected registerEventHubCallbacks() {
    if (!this.uiContext) {
      Log.info(this.tag, 'registerEventHubCallbacks -> uiContext is invalid');
      return;
    }
    let eventHub: common.EventHub | undefined = this.uiContext.getHostContext()?.eventHub;
    if (!eventHub) {
      Log.info(this.tag, 'registerEventHubCallbacks -> eventHub is invalid');
      return;
    }
    eventHub.on(BroadCastConstants.REQUEST_ACTIONBAR_FOCUS, this.onRequestActionBarFocus);
  }

  /**
   * 反注册eventHub事件回调
   */
  protected unRegisterEventHubCallbacks() {
    if (!this.uiContext) {
      Log.info(this.tag, 'unRegisterEventHubCallbacks -> uiContext is invalid');
      return;
    }
    let eventHub: common.EventHub | undefined = this.uiContext.getHostContext()?.eventHub;
    if (!eventHub) {
      Log.info(this.tag, 'unRegisterEventHubCallbacks -> eventHub is invalid');
      return;
    }
    eventHub.off(BroadCastConstants.REQUEST_ACTIONBAR_FOCUS, this.onRequestActionBarFocus);
  }

  // ActionBar区域方向键走焦业务回调
  private readonly onActionBarKeyEvent: (event: KeyEvent, prop: ActionButtonProp) => void =
    (event: KeyEvent, prop: ActionButtonProp) => {
      if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_UP ||
        event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_DOWN ||
        (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT && this.isFirstAction(prop)) ||
        (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT && this.isLastAction(prop))) {
        event.stopPropagation();
        if (event.type === KeyType.Down && event.keyCode ===
        MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT) {
          focusControl.requestFocus('ActionBarButtonSearch');
        }
        if (event.type === KeyType.Down && event.keyCode ===
        MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT) {
          focusControl.requestFocus('sideButton');
        }
      }
    };

  private isFirstAction(prop: ActionButtonProp): boolean {
    if (!this.firstActionKey) {
      return false;
    }
    return this.firstActionKey === prop?.key;
  }

  private isLastAction(prop: ActionButtonProp): boolean {
    if (!this.lastActionKey) {
      return false;
    }
    return this.lastActionKey === prop?.key;
  }
}