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

/**
 * 组件生命周期监听接口，当前只加了部分，可以按需增加，需要同步修改 ComponentLifecycleRegistry 及 LifecycleRegistry
 */
export interface ComponentLifecycleObserver {
  /**
   * 销毁
   */
  aboutToDisappear?(): void;

  /**
   * 显示
   */
  onPageShow?(): void;

  /**
   * 隐藏
   */
  onPageHide?(): void;

  /**
   * 界面构建完成
   */
  onDidBuild?(): void;
}

/**
 * 组件生命周期观察者管理类，负责接受注册及派发事件
 */
export class ComponentLifecycleRegistry {
  private readonly observers: ComponentLifecycleObserver[] = [];

  /**
   * 注册
   *
   * @param observer 观察者
   */
  public register(observer: ComponentLifecycleObserver): void {
    if (!observer || this.observers.indexOf(observer) !== -1) {
      return;
    }
    this.observers.push(observer);
  }

  /**
   * 取消注册
   *
   * @param observer 观察者
   */
  public unregister(observer: ComponentLifecycleObserver): void {
    if (!observer) {
      return;
    }
    let index: number = this.observers.indexOf(observer);
    if (index === -1) {
      return;
    }
    this.observers.splice(index, 1);
  }

  /**
   * 回调
   */
  public aboutToDisappear(): void {
    this.observers.forEach((value: ComponentLifecycleObserver, index: number) => value.aboutToDisappear?.());
    this.observers.splice(0, this.observers.length);
  }

  /**
   * 回调
   */
  public onPageShow(): void {
    this.observers.forEach((value: ComponentLifecycleObserver, index: number) => value.onPageShow?.());
  }

  /**
   * 回调
   */
  public onPageHide(): void {
    this.observers.forEach((value: ComponentLifecycleObserver, index: number) => value?.onPageHide?.());
  }
}

/**
 * 将该组件放到需要监听的组件内，派发父组件的事件，由父组件提供registry对象，比如：
 * @Component
 * export struct TargetComponent {
 *    private readonly registry: ComponentLifecycleRegistry = new ComponentLifecycleRegistry();
 *    aboutToAppear(): void {
 *      // 子组件利用 this.registry 注册TargetComponent的生命周期监听
 *    }
 *    build{
 *      LifecycleRegistry({registry: this.registry})
 *    }
 * }
 */
@Component
export struct LifecycleRegistry {
  /**
   * 注册管理，一般父组件创建传进来
   */
  public registry: ComponentLifecycleRegistry = new ComponentLifecycleRegistry();

  /**
   * 消失
   */
  aboutToDisappear(): void {
    this.registry?.aboutToDisappear();
  }

  /**
   * 显示
   */
  public onPageShow(): void {
    this.registry?.onPageShow();
  }

  /**
   * 显示
   */
  public onPageHide(): void {
    this.registry?.onPageHide();
  }

  /* instrument ignore file */
  build() {
  }
}