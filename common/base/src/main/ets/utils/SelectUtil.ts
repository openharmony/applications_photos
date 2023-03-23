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
//@ts-ignore
import fileShare from '@ohos.fileshare';
import wantConstant from '@ohos.app.ability.wantConstant';
import { Log } from './Log';

const TAG = "SelectUtil"
export class SelectUtil {
    static readonly THIRD_URI_READ_PERMISSIONS: string = "r";

    static getUriArray(selectedPhotos: Set<string>): Array<string> {
        let uriArray = new Array<string>();
        if (selectedPhotos == undefined) {
            return uriArray;
        }
        selectedPhotos.forEach((uri) => {
            uriArray.push(uri);
        })
        return uriArray;
    }

    private static async grantPermissionForUri(uri: string, bundleName: string): Promise<void> {
        Log.debug(TAG, `start uri grant. bundleName: ${bundleName}`);
        // @ts-ignore
        await fileShare.grantUriPermission(uri, bundleName, wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION);
    }

    static async grantPermissionForUris(uris: Array<string>, bundleName: string): Promise<void> {
        Log.info(TAG, `start uris grant. bundleName: ${bundleName}`);
        let promises: Array<Promise<void>> = [];
        for (let uri of uris) {
            try {
                promises.push(SelectUtil.grantPermissionForUri(uri, bundleName));
            } catch(err) {
                Log.error(TAG, `grant permission error: ${JSON.stringify(err)}`);
            }
        }
        await Promise.all(promises);
    }
}