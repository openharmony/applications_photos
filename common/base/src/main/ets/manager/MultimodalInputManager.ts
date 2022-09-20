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
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { logDebug } from '../utils/LoggerUtils';

const TAG = "MultimodalInputManager"

export class MultimodalInputManager {

    //win + N
    leftKeyOptions: any = {
        'preKeys': [],
        'finalKey': 2014,
        'isFinalKeyDown': true,
        'finalKeyDownDuration': 0
    };

    //win + I
    rightKeyOptions: any = {
        'preKeys': [],
        'finalKey': 2015,
        'isFinalKeyDown': true,
        'finalKeyDownDuration': 0
    };
    escKeyOptions: any = {
        'preKeys': [],
        'finalKey': 2070,
        'isFinalKeyDown': true,
        'finalKeyDownDuration': 0
    };

    async registerListener(callback) {
        logDebug(TAG, `registerListener start`);
        inputConsumer.on('key', this.leftKeyOptions, (data) => {
            logDebug(TAG, `notificationRegister data: ${JSON.stringify(data)}`);
            callback(0);
        });
        inputConsumer.on('key', this.rightKeyOptions, (data) => {
            logDebug(TAG, `controlRegister data: ${JSON.stringify(data)}`);
            callback(1);
        });
        inputConsumer.on('key', this.escKeyOptions, (data) => {
            logDebug(TAG, `escRegister data: ${JSON.stringify(data)}`);
            callback(2);
        });
        logDebug(TAG, `registerListener end`);
    }

    async unregisterListener() {
        logDebug(TAG, `unregisterListener start`);
        inputConsumer.off('key', this.leftKeyOptions, (data) => {
            logDebug(TAG, `notificationUnregister data: ${JSON.stringify(data)}`);
        });
        inputConsumer.off('key', this.rightKeyOptions, (data) => {
            logDebug(TAG, `controlUnregister data: ${JSON.stringify(data)}`);
        });
        inputConsumer.off('key', this.escKeyOptions, (data) => {
            logDebug(TAG, `escUnregister data: ${JSON.stringify(data)}`);
        });
        logDebug(TAG, `unregisterListener end`);
    }
}

let mMultimodalInputManager = new MultimodalInputManager();

export default mMultimodalInputManager as MultimodalInputManager;