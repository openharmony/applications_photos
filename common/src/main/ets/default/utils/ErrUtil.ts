/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */
import { Log } from './Log';

const TAG: string = 'ErrUtil';

export function tryFunc(getValue: Function, ...args): any {
  if (typeof getValue !== 'function') {
    Log.e(TAG, typeof getValue, 'is not a func ', ...args);
    return;
  }
  let res;
  try {
    res = getValue(...args);
  } catch (error) {
    Log.e(TAG, {
      function: getValue.name,
      args: args,
      error,
      errMsg: String(error)
    });
  }
  return res;
}

export async function tryFuncAsync(getValue: Function, ...args): Promise<any> {
  if (typeof getValue !== 'function') {
    Log.e(TAG, 'not a func ', ...args);
    return;
  }
  let res;
  try {
    res = await getValue(...args);
  } catch (error) {
    Log.e(TAG, {
      function: getValue.name,
      args: args,
      error,
      errMsg: String(error)
    });
  }
  return res;
}