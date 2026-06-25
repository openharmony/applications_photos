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
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import DatabaseProxy, { getTableByUri } from '@ohos/dataprovider/src/main/ets/database/DatabaseProxy';
import DatabaseHelper from '@ohos/dataprovider/src/main/ets/database/DatabaseUpdateHelper';
import { dataSharePredicates, relationalStore, ValuesBucket } from '@kit.ArkData';
import ohosDataRdb from '@ohos.data.relationalStore';
import { AsyncCallback } from '@kit.BasicServicesKit';

const TAG: string = `DatabaseProxyUtils `;

export default function DatabaseProxyUT() {

  describe('DatabaseProxyUtilsUT', () => {
    let databaseProxy: DatabaseProxy;
    let mocker: MockKit

    beforeEach(() => {
      databaseProxy = DatabaseProxy.getInstance()
      mocker = new MockKit()
    })

    afterEach(() => {
      mocker.clearAll();
    });

    it('insert_wrong_rdb_case1', 0, () => {
      let bucket: ValuesBucket = {
        test: 'true',
      };
      databaseProxy.insert('test?test', bucket, () => {
      });
      databaseProxy.batchInsert('test?test', [bucket], () => {
      });
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      databaseProxy.query('', updatePredicates, [], () => {
      });
      databaseProxy.update('test?test', updatePredicates, bucket, () => {
      });
      const res = databaseProxy.delete('test?test', updatePredicates, () => {
      });
      expect(res !== null).assertTrue()
    });

    it('batchInsert_wrong_rdb_case1', 0, () => {
      let bucket: ValuesBucket = {
        test: 'true',
      };
      const res = databaseProxy.batchInsert('test?test', [bucket], () => {
      });
      expect(res !== null).assertTrue()
    });

    it('query_wrong_rdb_case1', 0, () => {
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      const res = databaseProxy.query('', updatePredicates, [], () => {
      });
      expect(res !== null).assertTrue()
    });

    it('update_wrong_rdb_case1', 0, () => {
      let bucket: ValuesBucket = {
        test: 'true',
      };
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      const res = databaseProxy.update('test?test', updatePredicates, bucket, () => {
      });
      expect(res !== null).assertTrue()
    });

    it('delete_wrong_rdb_case1', 0, () => {
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      const res = databaseProxy.delete('test?test', updatePredicates, () => {
      });
      expect(res !== null).assertTrue()
    });
    it('init_case1', 0, () => {
      let testRdb: ohosDataRdb.RdbStore = {
        insert(table: string, values: ValuesBucket, callback: AsyncCallback<number>): void {
          callback(null, 1);
          return;
        },
        batchInsert(table: string, values: Array<ValuesBucket>, callback: AsyncCallback<number>): void {
          callback(null, 1);
          return;
        },
        query(
          table: string,
          predicates: dataSharePredicates.DataSharePredicates,
          columns: Array<string>,
          callback: AsyncCallback<relationalStore.ResultSet>
        ): void {
          callback(null, undefined);
          return;
        },
        update(
          table: string,
          values: ValuesBucket,
          predicates: dataSharePredicates.DataSharePredicates,
          callback: AsyncCallback<number>
        ): void {
          callback(null, 1);
          return;
        },
        delete(table: string, predicates: dataSharePredicates.DataSharePredicates,
          callback: AsyncCallback<number>): void {
          callback(null, 1);
          return;
        }
      } as ohosDataRdb.RdbStore;
      when(mocker.mockFunc(DatabaseHelper.getInstance(),
        DatabaseHelper.getInstance().getDb))(ArgumentMatchers.any).afterReturn(testRdb);
      const res = databaseProxy.init();
      expect(res !== null).assertTrue()
    });

    it('insert_case1', 0, () => {
      let bucket: ValuesBucket = {
        test: 'true',
      };
      const res = databaseProxy.insert('test?test', bucket, () => {
      });
      expect(res !== null).assertTrue()
    });

    it('batchInsert_case1', 0, () => {
      let bucket: ValuesBucket = {
        test: 'true',
      };
      const res = databaseProxy.batchInsert('test?test', [bucket], () => {
      });
      expect(res !== null).assertTrue()
    });

    it('query_case1', 0, () => {
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      const res = databaseProxy.query('', updatePredicates, [], () => {
      });
      expect(res !== null).assertTrue()
    });

    it('update_case1', 0, () => {
      let bucket: ValuesBucket = {
        test: 'true',
      };
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      const res = databaseProxy.update('test?test', updatePredicates, bucket, () => {
      });
      expect(res !== null).assertTrue()
    });

    it('delete_case1', 0, () => {
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      const res = databaseProxy.delete('test?test', updatePredicates, () => {
      });
      expect(res !== null).assertTrue()
    });

    it('getTableByUri_case1', 0, () => {
      const res = getTableByUri('1/facard');
      expect(res !== null).assertTrue()
    });

    it('getTableByUri_case2', 0, () => {
      const res = getTableByUri('1/reminders');
      expect(res !== null).assertTrue()
    });

    it('getTableByUri_case3', 0, () => {
      const res = getTableByUri('1/image_proxy_data');
      expect(res !== null).assertTrue()
    });

    it('getTableByUri_case4', 0, () => {
      const res = getTableByUri('');
      expect(res !== null).assertTrue()
    });

    it('getTableByUri_case5', 0, () => {
      const res = getTableByUri('datashare:///hmos_photodata');
      expect(res !== null).assertTrue()
    });

    it('getTableByUri_case6', 0, () => {
      const res = getTableByUri('1?');
      expect(res !== null).assertTrue()
    });
  })
}
