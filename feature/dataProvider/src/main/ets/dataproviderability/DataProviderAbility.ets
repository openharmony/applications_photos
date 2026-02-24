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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy Extension from '@ohos.application.DataShareExtensionAbility';
import lazy { ValuesBucket } from '@ohos.data.ValuesBucket';
import lazy { AsyncCallback } from '@ohos.base';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy DatabaseOperationHelper from '../database/DatabaseOperationHelper';

const TAG: string = 'DataProviderAbility';

/**
 * 图库自有数据库DataProviderAbility
 */
export default class DataProviderAbility extends Extension {
  onCreate(want: Want, callback: Function) {
    Log.info(TAG, 'onCreate enter');
    try {
      DatabaseOperationHelper.with().tryInitDatabase();
      AppStorage.setOrCreate('dataProviderContext', this.context);
      callback();
    } catch (err) {
      Log.error(TAG, `err=${err?.message}`);
    }
    Log.info(TAG, '[onCreate] leave');
  }

  insert(uri: string, value: ValuesBucket, callback: AsyncCallback<number>) {
    Log.info(TAG, 'insert');
    DatabaseOperationHelper.with().doInsert(uri, value, callback);
  }

  batchInsert(uri: string, value: ValuesBucket[], callback: AsyncCallback<number>) {
    Log.info(TAG, 'batchInsert');
    DatabaseOperationHelper.with().doBatchInsert(uri, value, callback);
  }

  update(uri: string, predicates: dataSharePredicates.DataSharePredicates, value: ValuesBucket,
    callback: AsyncCallback<number>) {
    Log.info(TAG, 'update');
    DatabaseOperationHelper.with().doUpdate(uri, predicates, value, callback);
  }

  query(uri: string, predicates: dataSharePredicates.DataSharePredicates, columns: Array<string>,
    callback: AsyncCallback<Object>) {
    Log.info(TAG, 'query');
    DatabaseOperationHelper.with().doQuery(uri, columns, predicates, callback);
  }

  delete(uri: string, predicates: dataSharePredicates.DataSharePredicates, callback: AsyncCallback<number>) {
    Log.info(TAG, 'delete');
    DatabaseOperationHelper.with().doDelete(uri, predicates, callback);
  }
}
