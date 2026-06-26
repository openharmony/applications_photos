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
import image from '@ohos.multimedia.image';
import { HiLog } from './HiLog';


const TAG = `ResourceCleaner`;

export default class ResourceCleaner {
  // 存储需要重置的全局变量初始值
  private static appStorages = new Map<string, object | null>();
  // 存储需要关闭的弹窗引用
  private static dialogControllers: Set<CustomDialogController> = new Set<CustomDialogController>();
  // 存储需要取消注册的接口函数
  private static callbacks: Set<() => void> = new Set<() => void>();
  // 存储需要释放的PixelMap资源
  private static pixelMaps: Set<image.PixelMap> = new Set<image.PixelMap>();

  // 注册appStorage变量（记录初始值）
  static registerAppStorage(key: string, initialValue: object): void {
    if (!key) {
      HiLog.e(TAG, `invalid key passed to registerAppStorage.`);
      return;
    }
    ResourceCleaner.appStorages.set(key, ResourceCleaner.deepCopy(initialValue));
  }

  // 注册需要关闭的弹窗
  static registerDialogController(dialogController: CustomDialogController): void {
    if (!dialogController) {
      HiLog.e(TAG, `attempted to register null dialogController.`);
      return;
    }
    ResourceCleaner.dialogControllers.add(dialogController);
  }

  // 注册需要取消的接口
  static registerCallback(unregisterFunc: () => void): void {
    if (typeof unregisterFunc !== 'function') {
      HiLog.e(TAG, `invalid unregister function provided`);
      return;
    }
    ResourceCleaner.callbacks.add(unregisterFunc);
  }

  // 注册需要释放的PixelMap
  static registerPixelMap(pixelMap: image.PixelMap): void {
    if (!pixelMap) {
      HiLog.e(TAG, `attempted to register null pixelMap`);
      return;
    }
    ResourceCleaner.pixelMaps.add(pixelMap);
  }

  // 统一释放所有资源
  static releaseAll(): void {
    try {
      ResourceCleaner.resetAppStorage();
      ResourceCleaner.closeDialogs();
      ResourceCleaner.unregisterCallbacks();
      ResourceCleaner.releasePixelMaps();
    } catch (e) {
      HiLog.e(TAG, `releaseAll causes exception, error: ${e}`);
    } finally {
      ResourceCleaner.clearRegistry(); // 确保无论如何都清空注册表
    }
  }

  // 深拷贝
  private static deepCopy<T>(obj: T): T | null {
    try {
      return JSON.parse(JSON.stringify(obj)) as T;
    } catch (error) {
      HiLog.e(TAG, 'JSON parse causes error.');
      return null;
    }
  }

  // 重置全局存储
  private static resetAppStorage(): void {
    ResourceCleaner.appStorages.forEach((initValue, key) => {
      try {
        AppStorage.setOrCreate(key, initValue);
      } catch (e) {
        HiLog.e(TAG, `appStorage reset causes exception, error: ${e}`);
      }
    });
    HiLog.i(TAG, `resourceCleaner resetAppStorage done`);
  }

  // 关闭所有弹窗
  private static closeDialogs(): void {
    for (let dialogController of ResourceCleaner.dialogControllers) {
      try {
        dialogController?.close();
      } catch (e) {
        HiLog.e(TAG, `dialogController.close causes exception, error: ${e}`);
      }
    }
    HiLog.i(TAG, `resourceCleaner closeDialogs done`);
  }

  // 释放图像资源
  private static releasePixelMaps(): void {
    for (let pixelMap of ResourceCleaner.pixelMaps) {
      try {
        pixelMap?.release();
      } catch (e) {
        HiLog.e(TAG, `pixelMaps.close causes exception, error: ${e}`);
      }
    }
    HiLog.i(TAG, `resourceCleaner releasePixelMaps done`);
  }

  // 取消接口注册
  private static unregisterCallbacks(): void {
    for (let callback of ResourceCleaner.callbacks) {
      try {
        callback();
      } catch (e) {
        HiLog.e(TAG, `callback.close causes exception, error: ${e}`);
      }
    }
    HiLog.i(TAG, `resourceCleaner unregisterCallbacks done`);
  }

  // 清空本类缓存信息。
  private static clearRegistry(): void {
    ResourceCleaner.appStorages.clear();
    ResourceCleaner.dialogControllers.clear();
    ResourceCleaner.callbacks.clear();
    ResourceCleaner.pixelMaps.clear();
  }
}