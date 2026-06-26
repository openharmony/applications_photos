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
import lazy relationalStore from '@ohos.data.relationalStore';
import lazy { Log } from './Log';
import lazy { BusinessError } from '@ohos.base';

const TAG: string = 'common_RdbHelper';

export class RdbHelper {
  private static databaseReqs: Map<string, Promise<relationalStore.RdbStore | undefined>> = new Map();

  public static async getRdb(context: Context | undefined,
    config: relationalStore.StoreConfig): Promise<relationalStore.RdbStore | undefined> {
    if (!context || !config) {
      Log.error(TAG, 'invalid input');
      return undefined;
    }

    if (RdbHelper.databaseReqs.has(config.name)) {
      Log.info(TAG, `req cache hit: ${config.name}`);
      return RdbHelper.databaseReqs.get(config.name);
    }

    let req: Promise<relationalStore.RdbStore | undefined> = RdbHelper.getRdbInner(context, config);
    RdbHelper.databaseReqs.set(config.name, req);
    return req;
  }

  private static async getRdbInner(context: Context,
    config: relationalStore.StoreConfig): Promise<relationalStore.RdbStore | undefined> {
    try {
      let store: relationalStore.RdbStore | undefined = await relationalStore.getRdbStore(context, config);
      Log.info(TAG, `finished to getRdbStore ${config.name}`);
      return store;
    } catch (e) {
      Log.error(TAG, `failed to getRdbStore ${config.name}, ${(e as BusinessError)?.code}`);
      return undefined;
    } finally {
      RdbHelper.databaseReqs.delete(config.name);
    }
  }
}