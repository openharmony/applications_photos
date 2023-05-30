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

import router from '@system.router';
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '../utils/Log';
import { getResourceString } from '../utils/ResourceUtils';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import type { MenuOperationCallback } from './MenuOperationCallback';
import type { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { JumpSourceToMain } from '../data/JumpSourceToMain';
import { SimpleAlbumDataItem } from '../data/SimpleAlbumDataItem';
import { getFetchOptionsByAlbumItem } from '../helper/MediaDataHelper';
import { showToast } from '../utils/UiUtil';
import mediaModel from '../model/MediaModel';
import { AlbumDataItem } from '../data/AlbumDataItem';
import { LazyItem } from '../vm/ItemDataSource';
import { MediaConstants } from '../constants/MediaConstants';

const TAG = "AlbumSetNewMenuOperation"

export class AlbumSetNewMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private onOperationEnd: Function;

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    doAction() {
        if (this.menuContext == null) {
            Log.warn(TAG, 'menuContext is null, return');
            return;
        }
        getResourceString($r('app.string.album_new_album')).then((name: string) => {
            Log.info(TAG, `The display name is ${name}`);
            this.getNewAlbumDisplayName(name).then((newAlbumDisplayName: string) => {
                Log.info(TAG, `The display name of new album is ${newAlbumDisplayName}`);

                this.confirmCallback = this.confirmCallback.bind(this);
                this.cancelCallback = this.cancelCallback.bind(this);

                this.menuContext.broadCast.emit(BroadcastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
                    [newAlbumDisplayName, this.confirmCallback, this.cancelCallback]);
            })
        })
    }

    private async getNewAlbumDisplayName(name: string): Promise<string> {
        let relativeRoot = await mediaModel.getPublicDirectory(MediaLib.DirectoryType.DIR_CAMERA);
        return await this.getNewAlbumDefaultName(relativeRoot, name);
    }

    private async confirmCallback(displayName: string) {
        Log.info(TAG, `AlbumSet new album confirm and the new name is: ${displayName}`);
        let relativePath = await mediaModel.getPublicDirectory(MediaLib.DirectoryType.DIR_CAMERA) + displayName + "/";
        let simpleAlbumDataItem: SimpleAlbumDataItem = new SimpleAlbumDataItem("", displayName, relativePath, "", "");
        if (displayName != undefined && displayName != null) {
            let isExit = await this.checkAlbumExit(simpleAlbumDataItem);
            if (isExit) {
                getResourceString($r('app.string.name_already_use')).then((message: string) => {
                    showToast(message);
                })
                return;
            }
        }
        this.onOperationEnd = this.menuContext.onOperationEnd;
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        if (this.menuContext.jumpSourceToMain == JumpSourceToMain.ALBUM) {
            Log.info(TAG, 'go back to photo grid');
            this.menuContext.broadCast.emit(BroadcastConstants.MEDIA_OPERATION, [simpleAlbumDataItem, this.onCompleted.bind(this)]);
        } else {
            router.push({
                uri: 'feature/albumSelect/view/AlbumSelect',
                params: {
                    albumInfo: JSON.stringify(simpleAlbumDataItem),
                    isNewAlbum: true
                }
            });
            this.onCompleted();
        }
    }

    private async checkAlbumExit(simpleAlbumDataItem: SimpleAlbumDataItem): Promise<boolean> {
        let fetchOptions: MediaLib.MediaFetchOptions = await getFetchOptionsByAlbumItem(simpleAlbumDataItem);
        return await mediaModel.getAlbumCount(fetchOptions) > 0;
    }

    private cancelCallback(): void {
        Log.info(TAG, 'AlbumSet new album cancel');
    }

    onCompleted(): void {
        Log.info(TAG, 'new album data succeed!');
        this.onOperationEnd && this.onOperationEnd();
    }

    onError(): void {
        Log.error(TAG, 'new album data failed!');
        this.onOperationEnd && this.onOperationEnd();
    }

    private matchAlbumDefaultName(albumInfo: string, numbers: Array<number>, root: string, prefixName: string) {
        let res = albumInfo.match(new RegExp(`^${root}${prefixName}[1-9][0-9]*${"/"}$`));
        if (res != null) {
            let number = res[0].match(new RegExp(`[1-9][0-9]*`));
            numbers.push(parseInt(number[0]));
        }
    }

    private async getNewAlbumDefaultName(root: string, prefixName: string): Promise<string> {
        let numbers = [];
        for (let i = 0; i < this.menuContext.dataSource.totalCount(); i++) {
            let item = (this.menuContext.dataSource.getData(i) as LazyItem<AlbumDataItem>).get();
            if (MediaConstants.ALBUM_ID_RECYCLE == item.id) {
                continue;
            }
            this.matchAlbumDefaultName(await item.getRelativePath(), numbers, root, prefixName);
        }
        if (this.menuContext.albumInfo) {
            this.matchAlbumDefaultName(this.menuContext.albumInfo.relativePath, numbers, root, prefixName);
        }
        Log.debug(TAG, `${JSON.stringify(numbers)}`);

        if (numbers.length <= 0) {
            return `${prefixName}1`;
        } else if (numbers.length == 1) {
            if (numbers[0] - 1 > 0) {
                return `${prefixName}1`;
            } else {
                return `${prefixName}${numbers[0] + 1}`;
            }
        }

        numbers.sort(function (a, b) {
            return a - b;
        });

        if (numbers[0] - 1 > 0) {
            return `${prefixName}1`;
        }

        for (let i = 1; i < numbers.length; i++) {
            let res = numbers[i - 1] + 1;
            if (res < numbers[i]) {
                return `${prefixName}${res}`;
            }
        }
        return `${prefixName}${numbers[numbers.length - 1] + 1}`;
    }
}