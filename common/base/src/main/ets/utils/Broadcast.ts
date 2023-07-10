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

export class Broadcast {
    private callBackArray: Map<string, Function[]> = new Map();

    constructor() {
    }

    public on(event: string, callback: Function): void {
        let cbs = this.callBackArray.get(event);
        if (!cbs) {
            cbs = new Array<Function>();
            this.callBackArray.set(event, cbs);
        }
        cbs.push(callback);
    }

    public off(event: string, callback: Function): void {
        if (event == null) {
            this.callBackArray = new Map();
            return;
        }
        if (callback == null) {
            this.callBackArray.delete(event);
            return;
        }

        const cbs = this.callBackArray.get(event);
        if (!cbs) {
            return;
        }
        let length = cbs.length;
        for (let i = 0; i < length; i++) {
            let cb = cbs[i];
            if (cb === callback) {
                cbs.splice(i, 1);
                break;
            }
        }
    }

    public emit(event: string, args: unknown[]): void {
        let cbs = this.callBackArray.get(event);
        if (!cbs) {
            return;
        }
        let l = cbs.length;
        for (let i = 0; i < l; i++) {
            try {
                cbs[i].apply(this, args);
            } catch (e) {
                new Error(e);
            }
        }
    }

    public release(): void {
        this.callBackArray.clear();
    }
}