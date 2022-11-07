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
import { MediaDataItem } from './MediaDataItem';
import createOrGet from '../utils/SingleInstanceUtils';

const TAG = "MediaDataItemCache"

class MediaDataItemCache {
    private mediaDataItemMap = new Map<string, MediaDataItem>();

    hasKey(key: string): boolean {
        return this.mediaDataItemMap.has(key);
    }

    deleteKey(key: string): boolean {
        return this.mediaDataItemMap.delete(key);
    }

    set(key: string, value: MediaDataItem): void {
        this.mediaDataItemMap.set(key, value);
    }

    get(key: string): MediaDataItem {
        return this.mediaDataItemMap.get(key);
    }

    clearAll(): void {
        this.mediaDataItemMap.clear();
    }
}

let mediaDataItemCache = createOrGet(MediaDataItemCache, TAG);

export default mediaDataItemCache as MediaDataItemCache;