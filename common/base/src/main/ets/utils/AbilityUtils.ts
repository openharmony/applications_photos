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
import Want from "@ohos.application.Want";
import { Log } from '../utils/Log';

const TAG = "AbilityUtils"

export async function startAbility(want: Want): Promise<void> {
    try {
        await globalThis.appContext.startAbility(want);
        Log.debug(TAG, 'raul startAbility complete');
    } catch (error) {
        Log.error(TAG, `raul startAbility failed, error: ${JSON.stringify(error)}`);
    }
}

export async function terminateSelf(): Promise<void> {
    await globalThis.appContext.terminateSelf();
}

export async function terminateSelfWithResult(parameter): Promise<void> {
    await globalThis.appContext.terminateSelfWithResult(parameter);
}