/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { MenuContext } from '../view/browserOperation/MenuContext';
import { Log } from '../utils/Log';
import { Constants } from '../model/common/Constants';

const TAG: string = 'common_MenuOperationFactory';

export class MenuOperationFactory {
  private constructor() {
    Log.info(TAG, 'constructor');
  }

  public static getInstance(): MenuOperationFactory {
    if (AppStorage.Get(Constants.APP_KEY_MENU_OPERATION_FACTORY) == null) {
      AppStorage.setOrCreate(Constants.APP_KEY_MENU_OPERATION_FACTORY, new MenuOperationFactory());
    }
    return AppStorage.Get(Constants.APP_KEY_MENU_OPERATION_FACTORY);
  }

  public createMenuOperation<T extends MenuOperation>
  (operation: { new(menuContext: MenuContext): T }, menuContext: MenuContext): T {
    Log.info(TAG, `createMenuOperation: ${operation.name}`);
    return new operation(menuContext);
  }
}