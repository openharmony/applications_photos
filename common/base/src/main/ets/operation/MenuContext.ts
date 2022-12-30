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
import { ItemDataSource } from '../vm/ItemDataSource';
import { MediaDataItem } from '../data/MediaDataItem'
import { Broadcast } from '../utils/Broadcast'
import { SimpleAlbumDataItem } from '../data/SimpleAlbumDataItem';

export class MenuContext {
    items: any[] = [];
    dataSource: ItemDataSource;

    albumInfo: SimpleAlbumDataItem;

    broadCast: Broadcast;
    onOperationStart: Function;
    onOperationEnd: Function;

    jumpSourceToMain: number;
    deviceId: string;

    albumId: string;
    deletePageFromType: number;       // 0. photoBrowser  1. photoGridPage

    withDeletePageFromType(deletePageFromType: number): MenuContext {
        this.deletePageFromType = deletePageFromType;
        return this;
    }

    withItems(items: MediaDataItem[]): MenuContext {
        this.items = items;
        return this;
    }

    withAlbumId(albumId: string): MenuContext {
        this.albumId = albumId;
        return this;
    }

    withDataSource(dataSource): MenuContext{
        this.dataSource = dataSource;
        return this;
    }

    withOperationStartCallback(onOperationStart: Function): MenuContext {
        this.onOperationStart = onOperationStart;
        return this;
    }

    withOperationEndCallback(onOperationEnd: Function): MenuContext {
        this.onOperationEnd = onOperationEnd;
        return this;
    }

    withBroadCast(param: Broadcast): MenuContext {
        this.broadCast = param;
        return this;
    }

    withJumpSourceToMain(jumpSourceToMain: number): MenuContext {
        this.jumpSourceToMain = jumpSourceToMain;
        return this;
    }

    withRemoteDevice(deviceId) {
        this.deviceId = deviceId;
        return this;
    }

    withAlbumInfo(albumInfo: SimpleAlbumDataItem) {
        this.albumInfo = albumInfo;
        return this;
    }
}