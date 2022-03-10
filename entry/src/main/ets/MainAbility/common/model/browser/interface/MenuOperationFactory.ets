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

import {MenuOperation} from '../operation/MenuOperation'
import {MenuContext} from '../operation/MenuContext.ets'
import {Logger} from '../../../utils/Logger.ets'
import {Constants} from '../../common/Constants.ets'

export class MenuOperationFactory {
    private logger: Logger = new Logger('MenuOperationFactory');

    private constructor() {
        this.logger.info('constructor');
    }

    public static getInstance(): MenuOperationFactory {
        if (AppStorage.Get(Constants.APP_KEY_MENU_OPERATION_FACTORY) == null) {
            AppStorage.SetOrCreate(Constants.APP_KEY_MENU_OPERATION_FACTORY, new MenuOperationFactory());
        }
        return AppStorage.Get(Constants.APP_KEY_MENU_OPERATION_FACTORY);
    }

    public createMenuOperation<T extends MenuOperation>
        (operation: { new(menuContext: MenuContext): T }, menuContext: MenuContext): T {
        this.logger.info(`createMenuOperation: ${operation.name}`);
        return new operation(menuContext);
    }
}