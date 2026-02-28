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
import lazy inputConsumer from '@ohos.multimodalInput.inputConsumer';
import lazy { Log } from '../../utils/Log';

const TAG: string = 'common_MultimodalInputManager';

export interface KeyOptions {
  preKeys: [],
  finalKey: number,
  isFinalKeyDown: boolean,
  finalKeyDownDuration: number,
}

export class MultimodalInputManager {
  public static readonly KEY_CODE_KEYBOARD_A = 2017;
  public static readonly KEY_CODE_KEYBOARD_C = 2019;
  public static readonly KEY_CODE_KEYBOARD_V = 2038;
  public static readonly KEY_CODE_KEYBOARD_Y = 2041;
  public static readonly KEY_CODE_KEYBOARD_Z = 2042;
  public static readonly KEY_CODE_KEYBOARD_UP = 2012;
  public static readonly KEY_CODE_KEYBOARD_DOWN = 2013;
  public static readonly KEY_CODE_KEYBOARD_LEFT = 2014;
  public static readonly KEY_CODE_KEYBOARD_RIGHT = 2015;
  public static readonly KEY_CODE_KEYBOARD_DELETE = 2071;
  public static readonly KEY_CODE_KEYBOARD_ESC = 2070;
  public static readonly KEY_CODE_KEYBOARD_ENTER = 2054;
  public static readonly KEY_CODE_KEYBOARD_F12 = 2101;
  public static readonly KEY_CODE_CTRL_LEFT = 2072;
  public static readonly KEY_CODE_CTRL_RIGHT = 2073;
  public static readonly KEY_CODE_P = 2032;
  public static readonly KEY_CODE_PAGE_UP = 2068;
  public static readonly KEY_CODE_PAGE_DOWN = 2069;
  public static readonly keyCodePlus = 2058;
  public static readonly keyCodeMinus = 2057;
  public static readonly keyCodeAltLeft = 2045;
  public static readonly keyCodeAltRight = 2046;
  public static readonly keyCodeMetaLeft = 2076;
  public static readonly KEY_CODE_SPACE = 2050;
  public static readonly KEY_CODE_KEYBOARD_TAB = 2049;
  // 小键盘加减
  public static readonly keyCodeNumPadAdd = 2116;
  public static readonly keyCodeNumPadSubtract = 2115;
  //win + N
  public leftKeyOptions: KeyOptions = {
    preKeys: [],
    finalKey: 2014,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
  };
  //win + I
  public rightKeyOptions: KeyOptions = {
    preKeys: [],
    finalKey: 2015,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
  };
  public escKeyOptions: KeyOptions = {
    preKeys: [],
    finalKey: 2070,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
  };
  public leftKeyCallback: Callback<KeyOptions> | undefined;
  public rightKeyCallback: Callback<KeyOptions> | undefined;
  public escKeyCallback: Callback<KeyOptions> | undefined;

  public async registerListener(callback: Function): Promise<void> {
    Log.debug(TAG, 'registerListener start');
    let leftKeyCallback = (data: inputConsumer.KeyOptions): void => {
      Log.debug(TAG, `notificationRegister data: ${JSON.stringify(data)}`);
      callback(0);
    };
    this.leftKeyCallback = this.leftKeyCallback;
    inputConsumer.on('key', this.leftKeyOptions, leftKeyCallback);

    let rightKeyCallback = (data: inputConsumer.KeyOptions): void => {
      Log.debug(TAG, `controlRegister data: ${JSON.stringify(data)}`);
      callback(1);
    };
    this.rightKeyCallback = rightKeyCallback;
    inputConsumer.on('key', this.rightKeyOptions, rightKeyCallback);

    let escKeyCallback = (data: inputConsumer.KeyOptions): void => {
      Log.debug(TAG, `escRegister data: ${JSON.stringify(data)}`);
      callback(2);
    };
    this.escKeyCallback = escKeyCallback;
    inputConsumer.on('key', this.escKeyOptions, escKeyCallback);
    Log.debug(TAG, 'registerListener end');
  }

  public async unregisterListener(): Promise<void> {
    Log.debug(TAG, 'unregisterListener start');
    inputConsumer.off('key', this.leftKeyOptions, this.leftKeyCallback);
    this.leftKeyCallback = undefined;
    inputConsumer.off('key', this.rightKeyOptions, this.rightKeyCallback);
    this.rightKeyCallback = undefined;
    inputConsumer.off('key', this.escKeyOptions, this.escKeyCallback);
    this.escKeyCallback = undefined;
    Log.debug(TAG, 'unregisterListener end');
  }
}

export const mMultimodalInputManager = new MultimodalInputManager();