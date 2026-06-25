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

/* instrument ignore file */

import lazy { FACardLoadingDialog } from '@ohos/common/src/main/ets/default/view/dialog/FACardLoadingDialog'
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { FaCardAlbumUtils } from '@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService';

const TAG: string = 'FaCardAlbumSelectTipView';

// 选择相册，第一张超5秒仍未插入，返回并toast报错
const LOADING_MAX_TIME: number = 5000;
// 选择相册，第一张超500ms未完成，展示loading弹窗
const LOADING_MIN_TIME: number = 500;

@Component
export struct FaCardAlbumSelectTipView {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  // 使用prop会出现监听不到值改变的情况
  @Link @Watch('onStartInsertAlbum') private startInsertAlbum: boolean;
  @Prop private formId: string;
  // 超时未完成数据插入，toast提示
  private toastTimeNO = 0;
  // 超时未完成数据插入，显示loading弹窗
  private loadingTimeNO = 0;
  private loadingDialogController?: CustomDialogController;
  private isShowToast: boolean = false;
  private callbackAfterInsertFirstAsset = (formId: string, playbackInterval: number) => {
    this.afterInsertFirstAssetFunc(formId, playbackInterval);
  }

  build() {
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear startInsertAlbum is ${this.startInsertAlbum}, formId is ${this.formId}`);
    this.loadingDialogController = new CustomDialogController({
      builder: FACardLoadingDialog(),
      customStyle: false,
      autoCancel: false,
    });
    this.appBroadCast.on(BroadCastConstants.FA_INSERT_FIRST_ASSET, this.callbackAfterInsertFirstAsset);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.appBroadCast.off(BroadCastConstants.FA_INSERT_FIRST_ASSET, this.callbackAfterInsertFirstAsset);
    this.loadingDialogController?.close();
    this.loadingDialogController = undefined;
  }

  private onStartInsertAlbum() {
    Log.info(TAG, `startInsertAlbum is ${this.startInsertAlbum}, formId is ${this.formId}`);
    if (this.startInsertAlbum) {
      this.isShowToast = false;
      Log.info(TAG, `onStartInsertAlbum execute, formId is ${this.formId}`);
      // 在触发点击后开始计时器，放在task中可能会被阻塞，不触发
      this.loadingTimeNO = setTimeout(() => {
        Log.info(TAG, `onStartInsertAlbum set loadingTimeNO, formId is ${this.formId}`);
        this.loadingDialogController?.open();
      }, LOADING_MIN_TIME);
      this.toastTimeNO = setTimeout(() => {
        this.isShowToast = true;
        Log.info(TAG, `onStartInsertAlbum set toastTimeNO, formId is ${this.formId}`);
        this.loadingDialogController?.close();
        UiUtil.showToast($r('app.string.cloud_enhance_addimage_network_error'));
      }, LOADING_MAX_TIME);
    }
  }

  private afterInsertFirstAssetFunc(formId: string, playbackInterval: number): void {
    Log.info(TAG, `startInsertAlbum is ${this.startInsertAlbum}, formId is ${this.formId}, func formId is ${formId}}`);
    if (formId === this.formId) {
      clearTimeout(this.loadingTimeNO);
      clearTimeout(this.toastTimeNO);
      this.loadingDialogController?.close();
      FaCardAlbumUtils.updateScheduler(formId, playbackInterval, this.isShowToast);
    }
  }
}

