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
import { afterEach, beforeEach, describe, expect, it, MockKit } from '@ohos/hypium';
import DatabaseHelper from '@ohos/dataprovider/src/main/ets/database/DatabaseUpdateHelper';
import ohosDataRdb from '@ohos.data.relationalStore';
import { common } from '@kit.AbilityKit';

const TAG: string = `DatabaseProxyUtils `;

export default function DatabaseUpdateHelperUT() {

  describe('DatabaseUpdateHelperUT', () => {
    let databaseHelper: DatabaseHelper;
    let mocker: MockKit

    beforeEach(() => {
      databaseHelper = DatabaseHelper.getInstance()
      mocker = new MockKit()
    })

    afterEach(() => {
      mocker.clearAll();
    });

    it('doOnFirstGetDb_case1', 0, () => {
      const run = (rdbStore?: ohosDataRdb.RdbStore): void => Reflect.get(databaseHelper, 'doOnFirstGetDb')
      ?.call(databaseHelper, rdbStore)
      run({} as ohosDataRdb.RdbStore);
      expect(run !== null).assertTrue()
    });

    it('loadDataBaseVersion_case1', 0, () => {
      const run = (): void => Reflect.get(databaseHelper, 'loadDataBaseVersion')
      ?.call(databaseHelper)
      run();
      expect(run !== null).assertTrue()
    });

    it('notifyAll_case1', 0, () => {
      Reflect.set(databaseHelper, 'waitInitOverResolves', [() => {
      }]);
      const run = (): void => Reflect.get(databaseHelper, 'notifyAll')
      ?.call(databaseHelper)
      run();
      expect(run !== null).assertTrue()
    });

    it('storeDataBaseVersion_case1', 0, () => {
      const run = (databaseVersion: number): void => Reflect.get(databaseHelper, 'storeDataBaseVersion')
      ?.call(databaseHelper, databaseVersion)
      run(1);
      expect(run !== null).assertTrue()
    });

    it('initOrUpdateRdbStoreMatch_case1', 0, () => {
      const run = (databaseVersion: number): void => Reflect.get(databaseHelper, 'initOrUpdateRdbStoreMatch')
      ?.call(databaseHelper, databaseVersion)
      run(1);
      expect(run !== null).assertTrue()
    });

    it('isNeedInitDB_case1', 0, () => {
      const run = (databaseVersion: number): void => Reflect.get(databaseHelper, 'isNeedInitDB')
      ?.call(databaseHelper, databaseVersion)
      run(1);
      expect(run !== null).assertTrue()
    });

    it('onInitDataBase_case1', 0, () => {
      const run = (): void => Reflect.get(databaseHelper, 'onInitDataBase')
      ?.call(databaseHelper)
      run();
      expect(run !== null).assertTrue()
    });

    it('createBasicTables_case1', 0, () => {
      const run = (rdbStore?: ohosDataRdb.RdbStore): void => Reflect.get(databaseHelper, 'createBasicTables')
      ?.call(databaseHelper, rdbStore)
      run({} as ohosDataRdb.RdbStore);
      expect(run !== null).assertTrue()
    });

    it('createBasicTables_case2', 0, () => {
      Reflect.set(databaseHelper, 'rdbStore', {} as ohosDataRdb.RdbStore);
      const run = (rdbStore?: ohosDataRdb.RdbStore): void => Reflect.get(databaseHelper, 'createBasicTables')
      ?.call(databaseHelper, rdbStore)
      run({} as ohosDataRdb.RdbStore);
      expect(run !== null).assertTrue()
    });

    it('initRdbStore_case1', 0, () => {
      Reflect.set(databaseHelper, 'rdbStore', {} as ohosDataRdb.RdbStore);
      const run = (rdbStore?: ohosDataRdb.RdbStore): void => Reflect.get(databaseHelper, 'initRdbStore')
      ?.call(databaseHelper, rdbStore)
      run({} as ohosDataRdb.RdbStore);
      expect(run !== null).assertTrue()
    });
  })
}
