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

import type { MenuOperation } from '../view/browserOperation/MenuOperation';
import type { MenuContext } from '../view/browserOperation/MenuContext';
import lazy { Log } from '../utils/Log';
import lazy { CtxWrap } from './CtxWrap';

const TAG: string = 'MenuOperationFactory';

export class MenuOperationFactory<M extends MenuContext = MenuContext> {
  private constructor() {
    Log.info(TAG, 'constructor');
  }

  public static getInstance(): MenuOperationFactory {
    if (!MenuOperationFactory.instance) {
      MenuOperationFactory.instance = new MenuOperationFactory();
    }
    return MenuOperationFactory.instance;
  }

  public static instance: MenuOperationFactory | undefined = undefined;

  public createMenuOperation<T extends MenuOperation>(operation: CtxWrap<M, T>, menuContext: M): T {
    Log.info(TAG, `createMenuOperation: ${operation.name}`);
    return new operation(menuContext);
  }
}