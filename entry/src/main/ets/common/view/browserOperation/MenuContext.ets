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

import {MediaItem} from '../../model/browser/photo/MediaItem'
import {SelectManager} from '../../model/browser/SelectManager'
import {BroadCast} from '../../utils/BroadCast'
import {AlbumSetDataSource} from '../../model/browser/album/AlbumSetDataSource'
import {AlbumInfo} from '../../model/browser/album/AlbumInfo';

export class MenuContext {
    mediaItem: MediaItem;
    albumId: string;
    selectManager: SelectManager;
    onOperationStart: Function;
    onOperationEnd: Function;
    broadCast: BroadCast
    jumpSourceToMain: number;
    albumSetDataSource: AlbumSetDataSource;
    deviceId: string;
    albumInfo: AlbumInfo

    withMediaItem(mediaItem: MediaItem): MenuContext {
        this.mediaItem = mediaItem;
        return this;
    }

    withAlbumId(albumId: string): MenuContext {
        this.albumId = albumId;
        return this;
    }

    withSelectManager(selectManager: SelectManager): MenuContext {
        this.selectManager = selectManager;
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

    withBroadCast(param: BroadCast): MenuContext {
        this.broadCast = param;
        return this;
    }

    withJumpSourceToMain(jumpSourceToMain: number): MenuContext {
        this.jumpSourceToMain = jumpSourceToMain;
        return this;
    }

    withAlbumSetDataSource(albumSetDataSource: AlbumSetDataSource): MenuContext {
        this.albumSetDataSource = albumSetDataSource;
        return this;
    }

    withRemoteDevice(deviceId) {
        this.deviceId = deviceId;
        return this;
    }

    withAlbumInfo(albumInfo) {
        this.albumInfo = albumInfo;
        return this;
    }
}