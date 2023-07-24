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
import preferences from '@ohos.data.preferences';
import { Log } from '../utils/Log';
import createOrGet from './SingleInstanceUtils';

const TAG = "DataStoreUtil"

class DataStoreUtil {
    private preferences: preferences.Preferences = undefined;
    private static readonly PREFERENCES_KEY_MY_FORM_STORE = 'myFormStore';
    private static readonly FROM_DATA_STORE_UTIL = 'form_data_store_util';

    constructor() {
    }

    public async init(): Promise<void> {
        Log.debug(TAG, 'init start!');
        if (this.preferences != undefined) {
            Log.info(TAG, `init preferences before`);
            return;
        }
        try {
            let context = globalThis.applicationContext;
            this.preferences = await preferences.getPreferences(context, DataStoreUtil.PREFERENCES_KEY_MY_FORM_STORE);
            Log.info(TAG, `init preferences ${preferences}`);
        } catch (err) {
            Log.error(TAG, `init err ${err}`);
        }
        Log.debug(TAG, 'init end!');
    }

    public async getData(key: string, defValue) {
        Log.debug(TAG, 'getData start!');
        if (this.preferences == undefined) {
            Log.warn(TAG, `getData preferences is undefined`);
            return defValue;
        }
        let temValue = defValue;
        try {
            temValue = await this.preferences.get(key, defValue);
            Log.debug(TAG, "The value of startup is " + temValue);
        } catch (err) {
            Log.error(TAG, `Get the value failed with err: ${err}`);
        }
        return temValue;
    }

    public async putData(key: string, value) {
        Log.debug(TAG, 'putData start!');
        if (this.preferences == undefined) {
            Log.warn(TAG, 'putData preferences is undefined');
            await this.init();
        }

        try {
            await this.preferences.put(key, value);
            Log.debug(TAG, 'Put the value successfully.');
        } catch (err) {
            Log.error(TAG, `Put the value failed with err: ${err}`);
        }
    }

    public async delData(key: string) {
        Log.debug(TAG, 'delData start!');
        if (this.preferences == undefined) {
            Log.warn(TAG, `delData preferences is undefined`);
        }
        try {
            await this.preferences.delete(key);
            Log.debug(TAG, "Delete the value successfully.");
        } catch (err) {
            Log.error(TAG, `Delete the value failed with err: ${err}`);
        }
    }

    public async flush() {
        Log.debug(TAG, 'flush start!');
        if (this.preferences == undefined) {
            Log.warn(TAG, `flush preferences is undefined`);
        }
        await this.preferences.flush();
    }

    public async hasData(key: string) {
        Log.debug(TAG, `hasData start! preferences ${this.preferences}`);
        let ret = false;
        if (this.preferences == undefined) {
            Log.warn(TAG, `hasData preferences is undefined`);
            return ret;
        }
        try {
            ret = await this.preferences.has(key);
            Log.debug(TAG, "hasData the value successfully.");
        } catch (err) {
            ret = false;
            Log.error(TAG, `hasData the value failed with err: ${err}`);
        }
        return ret;
    }

}

let dataStore = createOrGet(DataStoreUtil, TAG);

export default dataStore as DataStoreUtil;

