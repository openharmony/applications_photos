/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { TrashMediaDataItem } from './TrashMediaDataItem';
import createOrGet from '../utils/SingleInstanceUtils';

const TAG = "TrashMediaDataItemCache"

class TrashMediaDataItemCache {
    private trashMediaDataItemMap = new Map<string, TrashMediaDataItem>();

    hasKey(key: string): boolean {
        return this.trashMediaDataItemMap.has(key);
    }

    deleteKey(key: string): boolean {
        return this.trashMediaDataItemMap.delete(key);
    }

    set(key: string, value: TrashMediaDataItem): void {
        this.trashMediaDataItemMap.set(key, value);
    }

    get(key: string): TrashMediaDataItem {
        return this.trashMediaDataItemMap.get(key);
    }

    clearAll(): void {
        this.trashMediaDataItemMap.clear();
    }
}

let trashMediaDataItemCache = createOrGet(TrashMediaDataItemCache, TAG);

export default trashMediaDataItemCache as TrashMediaDataItemCache;