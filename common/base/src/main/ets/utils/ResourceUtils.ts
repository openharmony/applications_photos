// @ts-nocheck
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
import resourceManager from '@ohos.resourceManager';
import { Log } from '../utils/Log';

const TAG = "ResourceUtils"

export async function getResourceString(resource: Resource): Promise<string> {
    try {
        Log.debug(TAG, `getResourceString: ${JSON.stringify(resource)}`);
        let mgr: resourceManager.ResourceManager = await resourceManager.getResourceManager(globalThis.appContext);
        if (mgr != null || mgr != undefined) {
            return await mgr.getString(resource.id);
        } else {
            Log.warn(TAG, `getResourceManager instance is none`);
            return null;
        }
    } catch (error) {
        Log.error(TAG, `getResourceString error: ${error}`);
        return null;
    }
}