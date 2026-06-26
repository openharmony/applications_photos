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
import lazy { MediaObserverNfyInfo } from '../model/browser/dataObserver/MediaObserverCallback';

import lazy { Log } from './Log';

const TAG: string = 'PickerEditorPhotoContext';

/**
 *  图库picker进出编辑上下文
 */
export class PickerEditorPhotoContext {
  private static DELAY: number = 2000;
  private static context: PickerEditorPhotoContext = new PickerEditorPhotoContext();
  private editorUriOnExit: string = '';
  private _isThird: boolean = false;
  private _isPickerWaitingEditExitBroadCast: boolean = false;
  private timer: number = -1;

  private constructor() {
  }

  /**
   * 获取上下文单例对象
   *
   * @returns 唯一实例
   */
  public static getInstance(): PickerEditorPhotoContext {
    return PickerEditorPhotoContext.context;
  }

  /**
   *  退出编辑后清空上下文
   */
  public clear(): void {
    this.editorUriOnExit = '';
    this._isThird = false;
    this._isPickerWaitingEditExitBroadCast = false;
    if (this.timer >= 0) {
      clearTimeout(this.timer);
      this.timer = -1;
    }
    Log.info(TAG, 'context clear');
  }

  /**
   * 设置退出编辑时的url
   *
   * @param editorUriOnExit
   * @returns PickerEditorPhotoContext
   */
  public setEditorUriOnExit(editorUriOnExit: string): PickerEditorPhotoContext {
    Log.info(TAG, `setEditorUriOnExit ${editorUriOnExit}`);
    this.editorUriOnExit = editorUriOnExit;
    return this;
  }

  /**
   * 获取退出编辑时的url
   *
   * @returns editorUriOnExit
   */
  public getEditorUriOnExit(): string {
    return this.editorUriOnExit;
  }

  /**
   * 设置是否为picker大图点击编辑
   *
   * @param isThird
   * @returns PickerEditorPhotoContext
   */
  public setIsThird(isThird: boolean): PickerEditorPhotoContext {
    Log.info(TAG, `setIsThird ${isThird}`);
    this._isThird = isThird;
    return this;
  }

  /**
   * 获取是否为picker大图点击编辑
   *
   * @returns isThird
   */
  public isThird(): boolean {
    return this._isThird;
  }

  /**
   * 设置picker大图页是否等待编辑完成事件广播
   *
   * @param isPickerWaitingEditExitBroadCast
   * @returns PickerEditorPhotoContext
   */
  public setIsPickerWaitingEditExitBroadCast(isPickerWaitingEditExitBroadCast: boolean): PickerEditorPhotoContext {
    Log.info(TAG, `setIsPickerWaitingEditExitBroadCast ${isPickerWaitingEditExitBroadCast}`);
    this._isPickerWaitingEditExitBroadCast = isPickerWaitingEditExitBroadCast;
    if (isPickerWaitingEditExitBroadCast && this.timer >= 0) {
      clearTimeout(this.timer);
      this.timer = -1;
    }
    return this;
  }

  /**
   * 延时设置picker大图页不等待编辑完成事件广播
   *
   * @returns PickerEditorPhotoContext
   */
  public setPickerNotWaitingEditExitBroadCastWithDelay(): PickerEditorPhotoContext {
    Log.info(TAG, 'setPickerNotWaitingEditExitBroadCastWithDelay');
    if (this.timer >= 0) {
      clearTimeout(this.timer);
      this.timer = -1;
    }
    this.timer = setTimeout(() => {
      this._isPickerWaitingEditExitBroadCast = false;
    }, PickerEditorPhotoContext.DELAY);
    return this;
  }

  /**
   * 获取picker大图页是否等待编辑完成事件广播
   *
   * @returns isPickerWaitingEditExitBroadCast
   */
  public isPickerWaitingEditExitBroadCast(): boolean {
    return this._isPickerWaitingEditExitBroadCast;
  }
}