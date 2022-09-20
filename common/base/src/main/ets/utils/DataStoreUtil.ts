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
import preferences from '@ohos.data.preferences'
import { logDebug, logInfo, logWarn, logError } from './LoggerUtils'
import createOrGet from './SingleInstanceUtils';

const TAG = "DataStoreUtil"

class DataStoreUtil {
    private preferences: preferences.Preferences = undefined;
    private static readonly PREFERENCES_KEY_MY_FORM_STORE = 'myFormStore'

    constructor() {
    }

    public async init(): Promise<void> {
        logDebug(TAG, 'init start!');
        if (this.preferences != undefined) {
            logInfo(TAG, `init preferences before`);
            return
        }
        try {
            let context = globalThis.applicationContext
            this.preferences = await preferences.getPreferences(context, DataStoreUtil.PREFERENCES_KEY_MY_FORM_STORE)
            logInfo(TAG, `init preferences ${preferences}`)
        } catch (err) {
            logError(TAG, `init err ${err}`);
        }
        logDebug(TAG, 'init end!');
    }

    public async getData(key: string, defValue) {
        logDebug(TAG, 'getData start!');
        if (this.preferences == undefined) {
            logWarn(TAG, `getData preferences is undefined`);
            return defValue;
        }
        let temValue = defValue;
        try {
            temValue = await this.preferences.get(key, defValue)
            logDebug(TAG, "The value of startup is " + temValue)
        } catch (err) {
            logError(TAG, `Get the value failed with err: ${err}`)
        }
        return temValue;
    }

    public async putData(key: string, value) {
        logDebug(TAG, 'putData start!');
        if (this.preferences == undefined) {
            logWarn(TAG, 'putData preferences is undefined');
            return
        }

        try {
            await this.preferences.put(key, value)
            logDebug(TAG, 'Put the value successfully.')
        } catch (err) {
            logError(TAG, `Put the value failed with err: ${err}`);
        }
    }

    public async delData(key: string) {
        logDebug(TAG, 'delData start!');
        if (this.preferences == undefined) {
            logWarn(TAG, `delData preferences is undefined`);
        }
        try {
            await this.preferences.delete(key)
            logDebug(TAG, "Delete the value successfully.");
        } catch (err) {
            logError(TAG, `Delete the value failed with err: ${err}`);
        }
    }

    public async flush() {
        logDebug(TAG, 'flush start!');
        if (this.preferences == undefined) {
            logWarn(TAG, `flush preferences is undefined`);
        }
        await this.preferences.flush();
    }

    public async hasData(key: string) {
        logDebug(TAG, `hasData start! preferences ${this.preferences}`);
        let ret = false;
        if (this.preferences == undefined) {
            logWarn(TAG, `hasData preferences is undefined`);
            return ret;
        }
        try {
            ret = await this.preferences.has(key)
            logDebug(TAG, "hasData the value successfully.");
        } catch (err) {
            ret = false
            logError(TAG, `hasData the value failed with err: ${err}`);
        }
        return ret;
    }
}

let dataStore = createOrGet(DataStoreUtil, TAG);

export default dataStore as DataStoreUtil;

