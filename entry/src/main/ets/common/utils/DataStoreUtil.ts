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
import { Logger } from './Logger'
import { Constants } from '../model/common/Constants'
import data_preferences from '@ohos.data.preferences'

export class DataStoreUtil {
    private logger: Logger = new Logger('DataStoreUtil');
    private context: any = undefined;
    private preferences: any = undefined;
    private static readonly PREFERENCES_KEY_MY_FORM_STORE = 'myFormStore'

    private constructor(context) {
        this.logger.info('new DataStoreUtil');
        this.context = context;
    }

    public static getInstance(context: any): DataStoreUtil {
        if (AppStorage.Get(Constants.FROM_DATA_STORE_UTIL) == null) {
            AppStorage.SetOrCreate(Constants.FROM_DATA_STORE_UTIL, new DataStoreUtil(context));
        }
        return AppStorage.Get(Constants.FROM_DATA_STORE_UTIL);
    }

    public async init(): Promise<void> {
        this.logger.debug('init start!');
        if (this.preferences) {
            this.logger.debug('init already!');
            return;
        }
        await data_preferences.getPreferences(this.context, DataStoreUtil.PREFERENCES_KEY_MY_FORM_STORE)
            .then((preferences) => {
                this.logger.info(`init preferences ${preferences}`);
                this.preferences = preferences;
            })
            .catch((err) => {
                this.logger.error(`init err ${err}`);
            })
        this.logger.debug('init end!');
        return;
    }

    public async getData(key: string, defValue) {
        this.logger.debug('getData start!');
        if (this.preferences == undefined) {
            this.logger.error(`getData preferences is undefined`);
            return defValue;
        }
        let temValue = defValue;
        await this.preferences.get(key, defValue).then((value) => {
            this.logger.debug("The value of startup is " + value)
            temValue = value;
        }).catch((err) => {
            this.logger.error(`Get the value failed with err: ${err}`)
        })
        return temValue;
    }

    public async putData(key: string, value) {
        this.logger.debug('putData start!');
        if (this.preferences == undefined) {
            this.logger.error('putData preferences is undefined');
            return
        }

        await this.preferences.put(key, value).then(() => {
            this.logger.debug('Put the value successfully.');
        }).catch((err) => {
            this.logger.error(`Put the value failed with err: ${err}`);
        })
    }

    public async delData(key: string) {
        this.logger.debug('delData start!');
        if (this.preferences == undefined) {
            this.logger.error(`delData preferences is undefined`);
        }
        await this.preferences.delete(key).then(() => {
            this.logger.debug("Delete the value successfully.");
        }).catch((err) => {
            this.logger.error(`Delete the value failed with err: ${err}`);
        })
    }

    public async flush() {
        this.logger.debug('flush start!');
        await this.preferences.flush();
    }

    public async hasData(key: string) {
        this.logger.debug(`hasData start! preferences ${this.preferences}`);
        let ret = false;
        if (this.preferences == undefined) {
            this.logger.error(`hasData preferences is undefined`);
            return ret;
        }

        await this.preferences.has(key).then((value) => {
            this.logger.debug("hasData the value successfully.");
            ret = value;
        }).catch((err) => {
            this.logger.error(`hasData the value failed with err: ${err}`);
            ret = false;
        })
        return ret;
    }

    public async removeCache() {
        this.logger.debug('removeCache start!');
        await data_preferences.removePreferencesFromCache(this.context, DataStoreUtil.PREFERENCES_KEY_MY_FORM_STORE)
            .then(() => {
                this.preferences = undefined;
                console.info("removeCache successfully.")
            })
            .catch((err) => {
                console.error("removeCache failed with err: " + err)
            })
    }
}
