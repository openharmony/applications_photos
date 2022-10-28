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
import { logInfo } from '../utils/LoggerUtils'
import { MediaDataItem } from '../data/MediaDataItem'

const TAG = "ItemDataSource"

export abstract class ItemDataSource implements IDataSource {
    private listeners: DataChangeListener[] = [];

    abstract totalCount(): number

    abstract getData(index: number): any

    abstract isSelect(): boolean

    abstract getSelectedCount(): number

    abstract getSelectedItems(): any[]

    abstract getSelectedUris(): any[]

    abstract dataRemove(): void

    registerDataChangeListener(listener: DataChangeListener): void{
        logInfo(TAG, 'registerDataChangeListener');
        if (this.listeners.indexOf(listener) < 0) {
            this.listeners.push(listener);
            logInfo(TAG, `registerDataChangeListener, add listener, length: ${this.listeners.length}`);
        }
    }

    unregisterDataChangeListener(listener: DataChangeListener): void{
        logInfo(TAG, 'unregisterDataChangeListener');
        const pos = this.listeners.indexOf(listener);
        if (pos >= 0) {
            this.listeners.splice(pos, 1);
            logInfo(TAG, `registerDataChangeListener, remove listener, length: ${this.listeners.length}`);
        }
    }

    notifyDataChange(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDataChange(index)
        })
    }

    notifyDataReload(): void {
        this.listeners.forEach(listener => {
            listener.onDataReloaded()
        })
    }

    notifyDataDelete(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDataDelete(index)
        })
    }
}