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
import lazy { Log } from '../../utils/Log';
import type { MenuContext } from './MenuContext';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { ProcessMenuOperation } from './ProcessMenuOperation';

/* instrument ignore file */
const TAG: string = 'LockMenuOperation';


export class LockMenuOperation extends ProcessMenuOperation {
  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.operationType = 'LOCK_MENU';
    this.traceOperationType = 'LOCK_MENU';
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.info(TAG, 'menuContext is null, return');
      return;
    }
    Log.info(TAG, 'menuContext is join');

    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_LOCK_DIALOG, []);

  }
}