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

import type window from '@ohos.window';
import type common from '@ohos.app.ability.common';
import type { ability, UIExtensionContentSession, Want } from '@kit.AbilityKit';
import type { UIContext } from '@kit.ArkUI';
import lazy { Log } from '../utils/Log';
/* instrument ignore file  */
const TAG = 'GlobalContext';

/**
 * 获取全局的对象信息，用于代替GlobalThis，因为GlobalThis没有属性引用
 *
 * 适合存一些比较大的全局单例对象或者使用方不感知变化的值
 * 使用方需要感知变化的值放在AppStorage或LocalStorage中
 * 全局单例变量放在 ./Variables.ts
 *
 * @author
 * @since 2024/4/27
 */
export namespace global {
  /**
   * 外部拉起主应用的参数
   */
  export let want: Want;

  //初始化globalContext, 此函数只能在CommonAbility被调用一次
  export function setCtx(ctx: common.UIAbilityContext): void {
    getInstance().uiAbilityContext = ctx;
  }

  //初始化大图组件browserUiAbilityContext, 此函数只能在PhotoBrowserController init被调用一次
  export function setBrowserAbilityCtx(ctx: common.UIAbilityContext): void {
    getInstance().browserUiAbilityContext = ctx;
  }

  //picker禁止使用该接口,初始化globalContext, 此函数只能在CommonAbility被调用一次
  export function setUiExtensionCtx(ctx: common.UIExtensionContext): void {
    getInstance().uiExtensionContext = ctx;
  }

  //初始化globalContext, 此函数只能在CommonAbility被调用一次
  export function setAbilityStageCtx(ctx: common.AbilityStageContext): void {
    getInstance().abilityStageContext = ctx;
  }

  //初始化globalContext, 此函数只能在CommonAbility被调用一次
  export function setWindow(windowStage: window.WindowStage, win: window.Window): void {
    getInstance().setWindow(windowStage, win);
  }

  // MainAbility上下文，在外部通过 UIExtensionAbility 或者 ServiceExtension 等非直接拉起MainAbility的场景，该属性为undefined
  export function uiAbilityContext(): common.UIAbilityContext {
    return getInstance().uiAbilityContext;
  }

  //picker禁止使用,MainAbility上下文,在外部通过UIExtensionAbility或者ServiceExtension等非直接拉起MainAbility的场景,该属性为undefined
  export function uiExtensionContext(): common.UIExtensionContext {
    return getInstance().uiExtensionContext;
  }

  // MainAbility上下文，在外部通过 UIExtensionAbility 或者 ServiceExtension 等非直接拉起MainAbility的场景，该属性为undefined
  export function abilityStageContext(): common.AbilityStageContext {
    return getInstance().abilityStageContext;
  }

  // browserUiAbilityContext上下文，使用前需初始化
  export function browserUiAbilityContext(): common.UIAbilityContext {
    return getInstance().browserUiAbilityContext;
  }

  // 应用主窗口
  export function mainWindow(): window.Window {
    try {
      if (!getInstance().mainWindow) {
        Log.error(TAG, getInstance().mainWindow?.toString() + getInstance()?.windowStage?.getMainWindow()?.toString());
      }
      return getInstance().mainWindow;
    } catch (err) {
      Log.error(TAG, `Failed to mainWindow : error = ${err}`);
    }
  }

  export function windowStage(): window.WindowStage {
    if (!getInstance()?.windowStage) {
      Log.error(TAG, getInstance().mainWindow?.toString() + getInstance()?.toString());
    }
    return getInstance().windowStage;
  }

  export function UIContext(): UIContext {
    return mainWindow().getUIContext();
  }

  /**
   * UIExtAbility的session对象，用于和拉起方进行通信
   */
  export function uiExtSession(): UIExtensionContentSession {
    return getInstance().uiExtensionContentSession;
  }

  export function setUiExtSession(session: UIExtensionContentSession): void {
    getInstance().uiExtensionContentSession = session;
  }

  /**
   * 退出UIExt
   */
  export function exitUiExtSession(): void {
    if (!getInstance().uiExtensionContentSession) {
      Log.warn(TAG, 'no UiExtSession');
      return;
    }
    Log.warn(TAG, 'exitUiExtSession');
    getInstance().uiExtensionContentSession.sendData({
      'action': 'exit',
    });
  }

  /**
   * 退出app
   * 必须入参维测信息
   */
  export function terminateSelf(tag: string, exitMsg: string): void {
    Log.warn(tag, `terminateSelf: ${exitMsg}`);
    uiAbilityContext().terminateSelf();
  }

  /**
   * picker禁止使用,退出app
   * @param tag
   * @param exitMsg
   * @param result
   */
  export function terminateSelfWithResult(tag: string, exitMsg: string, result: ability.AbilityResult): void {
    Log.warn(tag, `terminateSelfWithResult: ${exitMsg}`);
    uiAbilityContext().terminateSelfWithResult(result);
  }
}

/**
 * 仅导出自定义用例而不导出类的示例
 *
 * 为保护代码结构, GlobalContext类禁止export 不可以被外部访问,
 * 这是限制代码的用法规范开发人员只能使用指定的一种方法. 以增加代码的健壮性, 一致性
 */
class GlobalContext {
  public static instance: GlobalContext = new GlobalContext();

  // MainAbility上下文，在外部通过 UIExtensionAbility 或者 ServiceExtension 等非直接拉起MainAbility的场景，该属性为undefined
  public uiAbilityContext?: common.UIAbilityContext;

  // MainAbility上下文，在外部通过 UIExtensionAbility 或者 ServiceExtension 等非直接拉起MainAbility的场景，该属性为undefined
  public abilityStageContext?: common.AbilityStageContext;

  // 大图组件PhotoBrowser上下文，使用前需初始化
  public browserUiAbilityContext?: common.UIAbilityContext;

  // 应用主窗口
  public mainWindow: window.Window;

  public windowStage: window.WindowStage;

  // Application上下文
  public applicationContext: common.ApplicationContext;

  // UIExtAbility上下文，在外部通过UIExtensionAbility拉起主题时，该属性才有值
  public uiExtensionContext?: common.UIExtensionContext;

  // UIExtAbility的session对象，用于和拉起方进行通信
  public uiExtensionContentSession?: UIExtensionContentSession;

  public constructor(ctx?: common.UIAbilityContext) {
    this.uiAbilityContext = ctx;
  }

  public setWindow(windowStage: window.WindowStage, win: window.Window): void {
    this.mainWindow = win;
    this.windowStage = windowStage;
  }
}

function getInstance(): GlobalContext {
  if (!Boolean(GlobalContext.instance)) {
    Log.fatal(TAG, 'uiAbilityContext not initiated');
  }
  return GlobalContext.instance;
}