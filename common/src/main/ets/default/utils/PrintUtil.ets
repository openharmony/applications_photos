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

import lazy print from '@ohos.print';
import lazy fileShare from '@ohos.fileshare';
import lazy wantConstant from '@ohos.app.ability.wantConstant';
import type common from '@ohos.app.ability.common';
import type { BusinessError } from '@ohos.base';
import lazy { BigDataConstants, ReportToBigDataUtil } from './ReportToBigDataUtil';
import lazy { UiUtil } from './UiUtil';
import type { MediaItem } from '../model/browser/photo/MediaItem';
import type { SelectManager } from '../model/browser/SelectManager';
import lazy { Log } from './Log';
import lazy prompt from '@system.prompt';
import lazy { TraceControllerUtils } from './TraceControllerUtils';
import { global } from '@ohos/tools/src/main/global/Contexts';

/* instrument ignore file */
const TAG: string = 'PrintUtil';
const PRINT_BUNDLE_NAME: string = 'com.ohos.spooler';

const suffixList: Array<string> = ['.png', '.gif', '.jpeg', '.jpg', '.jpe', '.bm', '.bmp', '.webp', '.wpng', '.srw', '.rw2', '.pef', '.orf', '.nrw', '.nef', '.ico', '.cr2', '.arw'];

export interface PrintDFXOption {
  printTriggerPlace: string,
  printTriggerType: number
}

export class PrintUtil {
  // Print max number
  static readonly PRINT_MAX_NUMBER: number = 100;

  /**
   * 打印公共逻辑
   *
   * @param selectedItems 媒体项
   * @param dfxOption 打点配置项
   * @returns
   */
  private static async printProcess(selectedItems: MediaItem[], dfxOption: PrintDFXOption): Promise<void> {
    const errCallback = (err: BusinessError): void => {
      if (err) {
        Log.info(TAG, 'preview authorization err:' + err);
        throw Error(err.message);
      }
    };
    try {
      selectedItems.forEach((item: MediaItem): void => {
        // 打印需要解析图片进行预览，如果只传uri就预览不了，需要授权
        fileShare.grantUriPermission(item.uri, PRINT_BUNDLE_NAME, wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION |
        wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION, errCallback);
      });
      Log.info(TAG, JSON.stringify(selectedItems));
      const uriList: Array<string> = selectedItems.map((item: MediaItem): string => item.uri);
      Log.info(TAG, JSON.stringify(uriList));
      //打印打点
      PrintUtil.printDFXHandler(selectedItems, dfxOption);
      let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
      if (!context) {
        context = global.uiAbilityContext();
      }
      TraceControllerUtils.startTrace('PrintTask');
      const printTask = await print.print(uriList, context);
      TraceControllerUtils.finishTrace('PrintTask');
      printTask.on('succeed', (): void => {
        //成功打点
        PrintUtil.printDFXHandler(selectedItems, dfxOption);
        Log.info(TAG, 'call print success');
      });
      printTask.on('fail', (): void => {
        //失败打点
        PrintUtil.printDFXHandler(selectedItems, dfxOption);
        Log.info(TAG, 'call print fail');
      });
      // 函数返回值再排查一下
    } catch (err) {
      //失败打点
      PrintUtil.printDFXHandler(selectedItems, dfxOption);
      Log.error(TAG, err);
    }
  }

  /**
   * 打印DFX公共逻辑
   *
   * @param selectedItems 媒体项
   * @param dfxOption 打点配置项
   */
  private static printDFXHandler(selectedItems: Array<SelectManager | MediaItem>, dfxOption: PrintDFXOption): void {
    if (!dfxOption) {
      return;
    }
    // 判断打印打点必须的参数
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_PRINT_ID, {
      // 打印触发位置（大图、宫格多选）
      'PRINT_TRIGGER_PLACE': dfxOption.printTriggerPlace ? dfxOption.printTriggerPlace : '',
      // 打印触发方式（0:菜单、1:快捷键）
      'PRINT_TRIGGER_TYPE': dfxOption.printTriggerType ? dfxOption.printTriggerType : 0,
      // 打印图片的数量
      'PRINT_NUMBER': selectedItems.length
    });
  }

  /**
   * 多张打印
   *
   * @param selectedItems 媒体项
   * @param dfxOption 打点配置项
   * @returns
   */
  static async multiplePrint(selectedItems: MediaItem[], dfxOption: PrintDFXOption): Promise<void> {
    if (!selectedItems.length) {
      return;
    }
    // 最大数量判断
    if (selectedItems.length > PrintUtil.PRINT_MAX_NUMBER) {
      const str = await UiUtil.getResourceString($r('app.string.number_of_print_exceeds_the_limit_tips'));
      const message = str.replace('%d', '100');
      prompt.showToast({
        message: message,
        duration: UiUtil.TOAST_DURATION
      });
      Log.info(TAG, 'Exceeded the print upper limit');
      return;
    }
    if (!PrintUtil.suffix(...selectedItems)) {
      Log.info(TAG, 'Image specification is incorrect');
      return;
    }
    await PrintUtil.printProcess(selectedItems, dfxOption);
  }

  /**
   * 单张打印
   *
   * @param selectedItem 媒体项
   * @param dfxOption 打点配置项
   * @returns
   */
  static async singlePrint(selectedItem: MediaItem, dfxOption: PrintDFXOption): Promise<void> {
    TraceControllerUtils.startTrace('PrintProcess');
    await PrintUtil.printProcess([selectedItem], dfxOption);
    TraceControllerUtils.finishTrace('PrintProcess');
  }

  /**
   * 图片格式判断
   *
   * @param selectedItems 媒体项
   * @returns
   */
  static suffix(...selectedItems: MediaItem[]): boolean {
    return selectedItems.every((photoItem: MediaItem): boolean => {
      Log.info(TAG, `${photoItem.uri}`);
      return suffixList.some((item: string) => photoItem?. uri.endsWith(item) || photoItem?.uri.endsWith(item.toUpperCase()));
    });
  }
}