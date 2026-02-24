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
import lazy { Log } from './Log';
import lazy { Action } from '../view/browserOperation/Action';

const TAG: string = 'ArrayUtil';

/**
 * 过滤undefined手指信息
 */
export function isFilterListEmpty(fingerList: FingerInfo[]): FingerInfo[] {
  fingerList = fingerList.filter((item: FingerInfo) => item != undefined);
  if (fingerList.length === 0) {
    Log.error(TAG, 'all elements are undefined');
  }
  return fingerList;
}

/**
 * 判断sublist是否是parentList的子集
 */
export function isSublist(parentList: Action[], sublist: Action[]): boolean {
  return sublist.every((item) => {
    return parentList.includes(item);
  })
}