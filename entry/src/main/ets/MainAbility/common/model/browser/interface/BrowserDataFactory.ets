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

import { TimelineDataImpl } from '../photo/TimelineDataImpl.ets';
import { PhotoDataImpl } from '../photo/PhotoDataImpl.ets';
import { AlbumDataImpl } from '../album/AlbumDataImpl.ets';
import { DistributedDataImpl } from '../album/DistributedDataImpl.ets'

export class BrowserDataFactory {
    static readonly TYPE_ALBUM = 'album';
    static readonly TYPE_ALBUM_SET = 'album_set';
    static readonly TYPE_GROUP = 'group';
    static readonly TYPE_DISTRIBUTED = 'distributed';

    static getFeature(type: string, param? : any) {
        if (type == BrowserDataFactory.TYPE_ALBUM_SET) {
            return new AlbumDataImpl(param);
        }else if (type == BrowserDataFactory.TYPE_ALBUM) {
            return new PhotoDataImpl();
        }else if (type == BrowserDataFactory.TYPE_GROUP) {
            return new TimelineDataImpl();
        }else if (type == BrowserDataFactory.TYPE_DISTRIBUTED) {
            return new DistributedDataImpl();
        }
    }
}