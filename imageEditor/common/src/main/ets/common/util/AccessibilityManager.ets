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

import { HiLog } from './HiLog';
import accessibility from '@ohos.accessibility';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'AccessibilityManager';
const BUNDLE_NAME_PHOTOS: string = 'com.ohos.soundrecorder';

/*
 * Description: 辅助功能，无障碍模式管理
 *
 * since: 2024-10-10
 */
export class AccessibilityManager {
  private static instance: AccessibilityManager;
  // 是否启用了辅助功能
  private isOpenAccessibility: boolean = false;
  // 是否开启了触摸浏览模式
  private isOpenTouchGuide: boolean = false;
  // 是否拉起键盘
  private isKeyboard: boolean = false;

  public static getInstance(): AccessibilityManager {
    if (!AccessibilityManager.instance) {
      AccessibilityManager.instance = new AccessibilityManager();
    }
    return AccessibilityManager.instance;
  }

  private onAccessibilityStateChangeListener: (state: boolean) => void =
    (state: boolean) => this.accessibilityStateChange(state);
  private onTouchGuideStateChangeListener: (state: boolean) => void =
    (state: boolean) => this.touchGuideStateChange(state);

  public isKeyboardStateChange(state: boolean): void {
    HiLog.i(TAG, 'isKeyboardStateChange state: %{public}s', state);
    this.isKeyboard = state;
    this.updateAccessibilityMode();
  }

  private accessibilityStateChange(state: boolean): void {
    HiLog.i(TAG, 'accessibilityStateChange state: %{public}s', state);
    this.isOpenAccessibility = state;
    this.updateAccessibilityMode();
  }

  private touchGuideStateChange(state: boolean): void {
    HiLog.i(TAG, 'touchGuideStateChange state: %{public}s', state);
    this.isOpenTouchGuide = state;
    this.updateAccessibilityMode();
  }

  private updateAccessibilityMode(): void {
    AppStorage.setOrCreate('isAccessibilityMode',
      (this.isOpenAccessibility && this.isOpenTouchGuide) || this.isKeyboard);
  }

  /**
   * 获取无障碍模式状态
   *
   */
  public getIsAccessibilityMode(): boolean {
    return this.isOpenAccessibility && this.isOpenTouchGuide;
  }

  /**
   * 注册无障碍模式变化监听
   *
   */
  public initAccessibilityModeListener(): void {
    try {
      this.isOpenAccessibility = accessibility.isOpenAccessibilitySync();
      this.isOpenTouchGuide = accessibility.isOpenTouchGuideSync();
      this.updateAccessibilityMode();
      accessibility.on('accessibilityStateChange', this.onAccessibilityStateChangeListener);
      accessibility.on('touchGuideStateChange', this.onTouchGuideStateChangeListener);
    } catch (err) {
      HiLog.e(TAG, 'initAccessibilityModeListener error');
    }
  }

  /**
   * 主动聚焦
   * @param elementId： 要聚焦的组件id
   * @param delay： 延迟delay后发送无障碍播报事件，避免由于Arkui节点刷新绘制过慢，组件id不存在的情况
   */
  public sendFocusAccessibilityEvent(elementId: string, delay: number = 100): void {
    let eventInfo: accessibility.EventInfo = {
      type: 'requestFocusForAccessibility',
      bundleName: BUNDLE_NAME_PHOTOS,
      triggerAction: 'common',
      customId: elementId,
    };
    const timer: number = setTimeout((): void => {
      accessibility.sendAccessibilityEvent(eventInfo).then(() => {
        HiLog.i(TAG, `Succeeded in send event, component id: ${elementId}`);
      }).catch((err: BusinessError) => {
        HiLog.e(TAG, `Failed to send event, errcode: ${err.code}, errMsg: ${err.message}`);
      }).finally(() => {
        clearTimeout(timer);
      });
    }, delay);
  }

  /**
   * 主动播报
   * @param content： 要播报的内容
   */
  public sendAnnounceAccessibilityEvent(content: string): void {
    let eventInfo: accessibility.EventInfo = {
      type: 'announceForAccessibility',
      bundleName: BUNDLE_NAME_PHOTOS,
      triggerAction: 'common',
      textAnnouncedForAccessibility: content,
    };
    accessibility.sendAccessibilityEvent(eventInfo).then(() => {
      HiLog.i(TAG, 'Succeeded in send event');
    }).catch((err: BusinessError) => {
      HiLog.e(TAG, `Failed to send event, errcode: ${err.code}, errMsg: ${err.message}`);
    });
  }

  /**
   * 注销无障碍模式变化监听
   *
   */
  public unregisterAccessibilityModeListener(): void {
    try {
      accessibility.off('accessibilityStateChange', this.onAccessibilityStateChangeListener);
      accessibility.off('touchGuideStateChange', this.onTouchGuideStateChangeListener);
    } catch (err) {
      HiLog.e(TAG, 'unregisterAccessibilityModeListener error');
    }
  }
}