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
/* instrument ignore file*/
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PhotoAsset, UserFileManagerAccess } from '../../../ets/default/access/UserFileManagerAccess';
import lazy { UiUtil } from './UiUtil';
import lazy { Log } from './Log';
import lazy { DeviceInfo } from '../../../ets/default/utils/DeviceInfo';

const TAG: string = 'ShareUrlUtil';
const RUN_TASK_START_TIP = '开始下载其中的云端项目';
const RUN_TASK_END_TIP = '下载完成';

interface checkedUrlObjType {
  isRemoteResource: boolean,
  url: string,
}

class ShareUrlUtil {
  private static instance: ShareUrlUtil | undefined = undefined;
  private DOWNLOAD_ORIGIN_PHOTO_TIME_OUT: number = 3000;
  private DOWNLOAD_ORIGIN_PHOTO_CHECK_INTERVAL: number = 200;
  private checkIsDownloadedTimer: number = -1;
  private lastUrls: string[] = [];

  constructor() {
    if (ShareUrlUtil.instance instanceof ShareUrlUtil) {
      return ShareUrlUtil.instance;
    }
    ShareUrlUtil.instance = this;
  }

  private tasks: string[] = [];

  public async downLoadOriginUrlIfNeeded(inputUrls: string | string[], isFromDrag = false,
    assets: (PhotoAsset | undefined)[], isNeedCheck: boolean = true) {
    this.cancelRunTask();
    let urls = ([] as string[]).concat(inputUrls);
    if (this.arraysEqual(this.lastUrls, urls)) {
      Log.info(TAG, 'downLoad the same originUrl');
      return;
    }
    this.lastUrls = urls;
    let startTime = new Date().getTime();
    let checkedUrlItems: checkedUrlObjType[] =
      await Promise.all(urls.map((url, index): Promise<checkedUrlObjType> => new Promise(async (resolve) => {
        let isRemoteResource: boolean = false;
        let asset = assets[index];
        if (asset) {
          try {
            const filePosition =
              asset?.get(photoAccessHelper.PhotoKeys.POSITION.toString()) as photoAccessHelper.PositionType;
            isRemoteResource = filePosition === UserFileManagerAccess.FILE_LOCATION_CLOUD;
          } catch (error) {
            Log.error(TAG, `get is remote resource error: ${error}, code: ${error?.code}`);
          }
        } else {
          isRemoteResource = false;
        }
        resolve({ isRemoteResource, url });
      })));
    Log.info(TAG, `check urls isRemoteResource duration:${new Date().getTime() - startTime}`);
    this.tasks = checkedUrlItems.filter(checkedUrlItem => checkedUrlItem.isRemoteResource)
      .map(checkedUrlItem => checkedUrlItem.url);
    Log.info(TAG, `download task: inputLength,${urls.length}, need download length,${this.tasks.length}`);
    if (this.tasks[0]) {
      this.runTask(isNeedCheck);
    }
  }

  /**
   * 判断前后是否复制同一份数据
   * @param arr1 字符串数组1
   * @param arr2 字符串数组2
   * @return 返回布尔值，表示两个数组是否相等
   */
  private arraysEqual(arr1: string[], arr2: string[]): boolean {
    return arr1.length === arr2.length && arr1.every((item, index) => item === arr2[index]);
  }

  private cancelRunTask(): void {
    if (this.tasks[0]) {
      this.tasks = [];
      this.onRunTaskEnd();
    }
  }

  private runTask(isNeedCheck: boolean = true): void {
    this.onRunTaskStart(isNeedCheck);
    let oneByOneRun = () => {
      let url = this.tasks.shift();
      if (url) {
        this.downloadOriginPhoto(url, isNeedCheck).then(() => {
          oneByOneRun();
        });
      } else {
        this.onRunTaskEnd(isNeedCheck);
      }
    }
    oneByOneRun();
  }

  private showToast(message: string) {
    const uiContext: UIContext = LocalStorage.getShared().get('uiContext') as UIContext;
    let toast = uiContext.getPromptAction();
    toast.showToast({
      message: message,
      duration: UiUtil.TOAST_DURATION,
      bottom: UiUtil.TOAST_BOTTOM,
    });
  }

  private onRunTaskStart(isNeedCheck: boolean = true): void {
    if (DeviceInfo.isPc()) {
      UiUtil.showToast($r('app.string.social_gallery_downloading_toast'));
    } else {
      if (isNeedCheck) {
        this.showToast(RUN_TASK_START_TIP);
      }
    }
    Log.info(TAG, 'on run task start');
  }

  private onRunTaskEnd(isNeedCheck: boolean = true): void {
    Log.info(TAG, 'on run task end');
    if (this.checkIsDownloadedTimer > 0) {
      clearTimeout(this.checkIsDownloadedTimer);
      this.checkIsDownloadedTimer = -1;
    }
    if (DeviceInfo.isPc()) {
      UiUtil.showToast($r('app.string.copy_success'));
    } else {
      if (isNeedCheck) {
        this.showToast(RUN_TASK_END_TIP);
      }
    }
  }

  private downloadOriginPhoto(url: string, isNeedCheck: boolean = true): Promise<void> {
    return new Promise(async (resolve, reject) => {
      resolve();
      if (isNeedCheck) {
        this.checkIsDownloaded(Date.now(), resolve, url);
      }
    })
  }

  private checkIsDownloaded(startTime: number, resolve: (value: void | PromiseLike<void>) => void, url: string) {
    this.checkIsDownloadedTimer = setTimeout(async () => {
      if (Date.now() - startTime > this.DOWNLOAD_ORIGIN_PHOTO_TIME_OUT) {
        Log.info(TAG, 'download success by time out');
        resolve();
        return;
      }
      let isRemoteResource: boolean = false;
      if (!isRemoteResource) {
        Log.info(TAG, 'download success by check');
        resolve();
      } else {
        this.checkIsDownloaded(startTime, resolve, url);
      }
    }, this.DOWNLOAD_ORIGIN_PHOTO_CHECK_INTERVAL);
  }
}

export default new ShareUrlUtil();