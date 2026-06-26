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

import lazy { Log } from '../../utils/Log';

const TAG: string = 'common_TabbarShowController';

const INVALID_INDEX: number = -1;

/**
 * 显隐监听
 */
export interface IsShowListener {
  onIsShowTabbarChange?: (isShowTabbar: boolean) => void;
}

/**
 * 显隐事件派发器
 */
export class IsShowEventDispatcher {
  private readonly listeners: IsShowListener[] = [];

  public onIsShowTabbarChange(isShowTabbar: boolean): void {
    for (let listener of this.listeners) {
      listener.onIsShowTabbarChange?.(isShowTabbar);
    }
  }

  public add(listener: IsShowListener): void {
    if (!listener || this.listeners.indexOf(listener) !== INVALID_INDEX) {
      return;
    }
    this.listeners.push(listener);
  }

  public remove(listener: IsShowListener): void {
    if (!listener) {
      return;
    }
    let index = this.listeners.indexOf(listener);
    if (index === INVALID_INDEX) {
      return;
    }
    this.listeners.splice(index, 1);
  }
}

export class TabbarShowController {
  public isShowTabbar: boolean = true;
  public static instance: TabbarShowController | undefined = undefined;
  protected dispatcher: IsShowEventDispatcher = new IsShowEventDispatcher();

  private constructor() {
    Log.info(TAG, 'constructor');
  }

  public static getInstance(): TabbarShowController {
    if (!TabbarShowController.instance) {
      TabbarShowController.instance = new TabbarShowController();
    }
    return TabbarShowController.instance;
  }

  public getIsShowTabbar(): boolean {
    return this.isShowTabbar;
  }

  public setIsShowTabbar(isShowTabbar: boolean): void {
    this.isShowTabbar = isShowTabbar;
    this.dispatcher.onIsShowTabbarChange(this.isShowTabbar);
  }

  public addListener(listener: IsShowListener): void {
    this.dispatcher.add(listener);
  }

  public removeListener(listener: IsShowListener): void {
    this.dispatcher.remove(listener);
  }
}