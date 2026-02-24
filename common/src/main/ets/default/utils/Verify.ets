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

import type { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { UiUtil } from './UiUtil';
import lazy { Constants } from '../model/common/Constants';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';
import type { Router } from '@ohos.arkui.UIContext';
import lazy prompt from '@system.prompt';
import type { BroadCast } from './BroadCast';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { WindowUtil } from './WindowUtil';
import lazy window from '@ohos.window';
import lazy { Log } from '../utils/Log';

interface ImageVerification {
  reason: string;
}

interface EnterInfo {
  count: number;
}

/* instrument ignore file */
const TAG: string = 'common_Verify';

export class Verify {
  constructor(broadCast: BroadCast) {
    this.broadCast = broadCast;
  };

  private broadCast: BroadCast;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  public photoVerification(fileAssetList: MediaItem[]): void {
    this.handleEnterImmersiveComparedPage(fileAssetList);
  }

  public async handleEnterImmersiveComparedPage(fileAssetList: MediaItem[]): Promise<void> {
    Log.info(TAG, `handleEnterImmersiveComparedPage ${fileAssetList.length}`);
    if (fileAssetList.length) {
      const standard = Constants.DEFAULT_COMPARE_IMAGE_RATIO;
      const number = fileAssetList.length > Constants.DEFAULT_MAX_COMPARE_COUNT ||
        fileAssetList.length < Constants.DEFAULT_MIN_COMPARE_COUNT;
      const suffix = fileAssetList.some((photoItem: MediaItem) => {
        return !Constants.suffixList.some((item: string) => photoItem.uri.endsWith(item) ||
        photoItem.uri.endsWith(item.toUpperCase()));
      });
      if (number) {
        await this.doNumberFn();
        return;
      }
      if (suffix) {
        await this.doSuffixFn();
        return;
      }
      let msg: EnterInfo = {
        count: fileAssetList.length,
      };
      ReportToBigDataUtil.report(BigDataConstants.ENTER_COMPARE_ID, msg);
      if (!DeviceInfo.isPc() && !(DeviceInfo.isTablet() || DeviceInfo.isFoldable())) {
        WindowUtil.setOrientation(window.Orientation.UNSPECIFIED);
      }
      setTimeout((): void => {
        this.appBroadCast.emit(BroadCastConstants.ENTER_IMMERSIVE_COMPARED_PAGE, [fileAssetList, false]);
      }, Constants.ENTER_TO_COMPARE_PAGE_TIME);
    }
  }

  public async doNumberFn(): Promise<void> {
    const str = await UiUtil.getResourceString($r('app.string.number_of_compared_exceeds_the_limit_tips'));
    const message = str.replace('%1$d', String(Constants.DEFAULT_MIN_COMPARE_COUNT))
      .replace('%2$d', String(Constants.DEFAULT_MAX_COMPARE_COUNT));
    this.checkPointing('The compare function only supports 2-20 pictures');
    prompt.showToast({
      message: message,
      duration: UiUtil.TOAST_DURATION,
    });
  }

  public async doSuffixFn(): Promise<void> {
    const str = await UiUtil.getResourceString($r('app.string.image_format_compare_is_not_supported'));
    this.checkPointing('The image format does not support compare');
    prompt.showToast({
      message: str,
      duration: UiUtil.TOAST_DURATION,
    });
  }

  public async doProportionFn(): Promise<void> {
    const str = await UiUtil.getResourceString($r('app.string.size_of_compared_exceeds_the_limit_tips'));
    this.checkPointing('Some images size too large and cannot be compared');
    prompt.showToast({
      message: str,
      duration: UiUtil.TOAST_DURATION,
    });
  }

  public async checkPointing(str: string): Promise<void> {
    let msg: ImageVerification = {
      reason: str,
    };
    ReportToBigDataUtil.report(BigDataConstants.ENTER_COMPARE_FAIL, msg);
  }
}