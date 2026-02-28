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

import lazy { Callback } from '@kit.BasicServicesKit';
import lazy display from '@ohos.display';
import lazy { Log } from './Log';
import lazy { Constants } from '../model/common/Constants';

const TAG: string = 'common_FoldUtil';
/* GRL 设备 G态xxx */
// G态
const FOLD_STATE_EXPAND_WITH_SECOND_EXPAND: number = 11;
// 13 xxx (G态)
const FOLD_STATE_HALF_FOLDED_WITH_SECOND_EXPAND: number = 13;
// xxx(G态)
const FOLD_STATE_EXPAND_WITH_SECOND_HALF_FOLDED: number = 21;
// xxx (G态)
const FOLD_STATE_HALF_FOLDED_WITH_SECOND_HALF_FOLDED: number = 23;

export interface FoldData {
  curFoldStatus: number;
  preFoldStatus: number;
}

export class FoldUtil {
  private static sInstance: FoldUtil;
  private hasInit: boolean = false;
  private preFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  private curFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  private listeners: ((foldData: FoldData) => void)[] = [];
  private foldStatusCallback: Callback<display.FoldStatus> = (data: display.FoldStatus) => {
    Log.info(TAG, `foldStatusChange callback, data: ${JSON.stringify(data)}`)
    this.preFoldStatus = this.curFoldStatus;
    this.curFoldStatus = data;

    this.listeners.forEach(listener => {
      listener({ curFoldStatus: this.curFoldStatus, preFoldStatus: this.preFoldStatus });
    })
  };

  private constructor() {
    this.init();
  }

  public static getInstance(): FoldUtil {
    if (!FoldUtil.sInstance) {
      FoldUtil.sInstance = new FoldUtil();
    }
    if (!FoldUtil.sInstance.hasInit) {
      FoldUtil.sInstance.init();
    }
    return FoldUtil.sInstance;
  }

  private init(): void {
    try {
      this.preFoldStatus = display.getFoldStatus();
      this.curFoldStatus = display.getFoldStatus();
    } catch (e) {
      Log.error(TAG, 'init fold status error')
    }

    try {
      display.on('foldStatusChange', this.foldStatusCallback);
    } catch (e) {
      Log.error(TAG, 'register callback failed')
    }

    this.hasInit = true;
  }

  /* instrument ignore next */
  public destroy(): void {
    this.preFoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    this.curFoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;

    try {
      display.off('foldStatusChange', this.foldStatusCallback);
    } catch (e) {
      Log.error(TAG, 'unRegister callback failed')
    }
    this.listeners = [];
    this.hasInit = false;
  }

  /* instrument ignore next */
  public subscribe(listener: (foldData: FoldData) => void): void {
    listener({ curFoldStatus: this.curFoldStatus, preFoldStatus: this.preFoldStatus });
    this.listeners.push(listener);
  }

  /* instrument ignore next */
  public unSubscribe(listener: (foldData: FoldData) => void): void {
    for (let i = 0; i < this.listeners.length; i++) {
      if (listener === this.listeners[i]) {
        this.listeners.splice(i, 1);
      }
    }
  }

  public getCurFoldStatus(): number {
    return this.curFoldStatus;
  }

  public static isTriExpand(foldStatus: number): boolean {
    return foldStatus === FOLD_STATE_EXPAND_WITH_SECOND_EXPAND ||
      foldStatus === FOLD_STATE_HALF_FOLDED_WITH_SECOND_EXPAND ||
      foldStatus === FOLD_STATE_EXPAND_WITH_SECOND_HALF_FOLDED ||
      foldStatus === FOLD_STATE_HALF_FOLDED_WITH_SECOND_HALF_FOLDED;
  }

  public static isTriFullExpand(foldStatus: number): boolean {
    return foldStatus === FOLD_STATE_EXPAND_WITH_SECOND_EXPAND;
  }

  public static releaseAppKeyForGRL(): void {
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_KEEP_SEARCH);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_POSITION);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_SELECT_MODE);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_SELECT_FRAME);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_IS_SELECT_ALL);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_KEEP_CLASSIFIED);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_KEEP_SHOOTING);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_ENTRY);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_CATEGORY_GRID_INDEX);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_SHOOTING_MODE_GRID_INDEX);
    LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_PHOTO_GRID_SELECT_MODE, false);
    LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_PHOTO_GRID_SELECT_FRAME, false);
    AppStorage.delete(Constants.PHOTO_GRID_SELECT_MANAGER);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_HIDDEN_GRID_SELECT_MODE);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_HIDDEN_GRID_SELECT_FRAME);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PHOTO_GRID_VIEW_MODE);
    LocalStorage.getShared()?.setOrCreate(Constants.APP_KEY_GRL_HIDDEN_UNLOCK, false);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GRID_PORTRAIT_SELECT_MANAGER);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_ALBUM_SELECT_MODE);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_MORE_ENTRY);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_MORE_PORTRAIT_SELECT_MANAGER);
  }
}