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
import lazy { dataSharePredicates, DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy DBHelper from '../DBHelper';
import lazy { JSON } from '@kit.ArkTS';

const TAG: string = 'BaseFaCardService';

export default class BaseFaCardService {
  protected context: Context;
  protected uri: string;

  constructor(context: Context, uri: string) {
    Log.info(TAG, `uri: ${uri}`);

    this.context = context;
    this.uri = uri;
  }

  private buildUri(uri: string, query: string = ''): string {
    return uri + `?${query}`;
  }

  async deleteByFormId(formId: string): Promise<number | undefined> {
    if (!this.context) {
      Log.info(TAG, `deleteByFormId context undefined`);
      return undefined;
    }

    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('form_id', formId);
    Log.info(TAG, 'deleteByFormId  ' + formId + `  prediates: ${JSON.stringify(predicates)}` + predicates);
    try {
      const deleteNO =
        await DBHelper.getInstance(this.context).doDelete(this.buildUri(this.uri, formId), predicates, this.context);
      return deleteNO;
    } catch (error) {
      Log.error(TAG, `deleteByFormId error ${error}`);
      return undefined;
    }
  }

  async mInsert(value: ValuesBucket): Promise<number | undefined> {
    if (!this.context) {
      Log.info(TAG, `mInsert context undefined`);
      return;
    }

    Log.info(TAG, `mInsert value from : ${this.uri + JSON.stringify(value)}`);
    try {
      const insertNO = await DBHelper.getInstance(this.context)
        .doInsert(this.buildUri(this.uri, value?.form_id as string), value, this.context);
      Log.info(TAG, `mInsert NO : ${insertNO}`);
      return insertNO;
    } catch (error) {
      Log.error(TAG, `mInsert error ${error}`);
      return undefined;
    }
  }

  async mBatchInsert(values: ValuesBucket[]): Promise<number | undefined> {
    if (!this.context) {
      Log.info(TAG, `mBatchInsert context undefined`);
      return;
    }

    Log.info(TAG, `mBatchInsert value from : ${this.uri + JSON.stringify(values)}`);
    try {
      const insertNO = await DBHelper.getInstance(this.context).doBatchInsert(this.uri, values, this.context);
      return insertNO;
    } catch (error) {
      Log.error(TAG, `mBatchInsert error ${error}`);
      return undefined;
    }
  }

  async mQuery(predicates: dataSharePredicates.DataSharePredicates, columns: Array<string>):
    Promise<DataShareResultSet | undefined> {
    if (!this.context) {
      Log.info(TAG, `mQuery context undefined`);
      return;
    }
    Log.info(TAG, `mQuery columns from : ${this.uri + JSON.stringify(columns)}`);
    try {
      const queryResult = await DBHelper.getInstance(this.context).doQuery(this.uri,
        predicates, columns, this.context);
      return queryResult;
    } catch (error) {
      Log.error(TAG, `mQuery error ${error}`);
      return undefined;
    }
  }

  async mUpdate(predicates: dataSharePredicates.DataSharePredicates, value: ValuesBucket): Promise<number | undefined> {
    if (!this.context) {
      Log.info(TAG, `mUpdate context undefined`);
      return;
    }
    Log.info(TAG, `mUpdate value from : ${this.uri + JSON.stringify(value)}`);
    try {
      const updateNO = await DBHelper.getInstance(this.context).doUpdate(
        this.uri,
        predicates,
        value,
        this.context
      );
      return updateNO;
    } catch (error) {
      Log.error(TAG, `mUpdate error ${error}`);
      return undefined;
    }
  }
}