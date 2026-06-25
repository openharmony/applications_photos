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

import lazy { accessibility } from '@kit.AccessibilityKit';
import lazy { Log } from '../../../../../../../../../../../eSpace/ReceiveFiles/demo/demo/entry/src/main/ets/utils/Log';
import lazy { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'AccessibilityUtil';
const BUNDLE_NAME_PHOTOS: string = 'com.ohos.soundrecorder';

// 无障碍事件上报接口
export class AccessibilityUtil {
  /**
   * 主动聚焦
   * @param elementId： 要聚焦的组件id
   * @param delay： 延迟delay后发送无障碍播报事件，避免由于Arkui节点刷新绘制过慢，组件id不存在的情况
   */
  static sendFocusAccessibilityEvent(elementId: string, delay: number = 100): void {
    let eventInfo: accessibility.EventInfo = {
      type: 'requestFocusForAccessibility',
      bundleName: BUNDLE_NAME_PHOTOS,
      triggerAction: 'common',
      customId: elementId,
    };
    const timer: number = setTimeout(() => {
      accessibility.sendAccessibilityEvent(eventInfo).then(() => {
        Log.info(TAG, `Succeeded in send event, component id: ${elementId}`);
      }).catch((err: BusinessError) => {
        Log.error(TAG, `Failed to send event, errcode: ${err.code}, errMsg: ${err.message}`);
      }).finally(() => {
        clearTimeout(timer);
      });
    }, delay);
  }

  /**
   * 主动播报
   * @param content： 要播报的内容
   */
  static sendAnnounceAccessibilityEvent(content: string): void {
    let eventInfo: accessibility.EventInfo = {
      type: 'announceForAccessibility',
      bundleName: BUNDLE_NAME_PHOTOS,
      triggerAction: 'common',
      textAnnouncedForAccessibility: content,
    };
    accessibility.sendAccessibilityEvent(eventInfo).then(() => {
      Log.info(TAG, `Succeeded in send event`);
    }).catch((err: BusinessError) => {
      Log.error(TAG, `Failed to send event, errcode: ${err.code}, errMsg: ${err.message}`);
    });
  }

  /**
   * 系统是否开启触摸浏览模式
   */
  static isOpenTouchGuideSync(): boolean {
    let isOpenTouchGuideSync: boolean = accessibility.isOpenTouchGuideSync();
    Log.info(TAG, `check isOpenTouchGuideSync status: ${isOpenTouchGuideSync}`);
    return isOpenTouchGuideSync;
  }
}