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
import MediaLib from '@ohos.multimedia.mediaLibrary';
import mediaModel from '@ohos/base/src/main/ets/model/MediaModel';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { ItemDataSource } from '@ohos/base/src/main/ets/vm/ItemDataSource';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import type { MenuOperationCallback } from '@ohos/base/src/main/ets/operation/MenuOperationCallback';
import type { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { getFetchOptions } from '@ohos/base/src/main/ets/helper/MediaDataHelper';
import { getFetchOptionsByAlbumItem } from '@ohos/base/src/main/ets/helper/MediaDataHelper';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';

const TAG = "AlbumSetRenameMenuOperation"

export class AlbumSetRenameMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private onOperationEnd: Function;
    private item: AlbumDataItem;

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    doAction(): void {
        if (this.menuContext == null) {
            Log.warn(TAG, 'menuContext is null, return');
            return;
        }
        let dataSource: ItemDataSource = this.menuContext.dataSource;
        let count: number;
        let items: any[];
        if (dataSource == null) {
            count = this.menuContext.items.length;
            items = this.menuContext.items;
        } else {
            count = dataSource.getSelectedCount();
            items = dataSource.getSelectedItems();
        }
        if (count != 1) {
            Log.warn(TAG, 'count is invalid');
            return;
        }

        this.item = items[0] as AlbumDataItem;

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);

        Log.info(TAG, `The name of clicked album is ${this.item.displayName}`);

        this.menuContext.broadCast.emit(BroadcastConstants.SHOW_RENAME_PHOTO_DIALOG,
            [this.item.displayName, this.confirmCallback, this.cancelCallback]);
    }

    private async confirmCallback(newName: string) {
        Log.info(TAG, `AlbumSet rename confirm and the new name is: ${newName}`);

        this.onOperationEnd = this.menuContext.onOperationEnd;
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        this.rename(newName);
    }

    private async checkAlbumExit(simpleAlbumDataItem: SimpleAlbumDataItem): Promise<boolean> {
        let fetchOptions: MediaLib.MediaFetchOptions = await getFetchOptionsByAlbumItem(simpleAlbumDataItem);
        return await mediaModel.getAlbumCount(fetchOptions) > 0;
    }

    private async rename(name) {
        try {
            let relativePath = await mediaModel.getPublicDirectory(MediaLib.DirectoryType.DIR_CAMERA) + name + "/";
            let simpleAlbumDataItem: SimpleAlbumDataItem = new SimpleAlbumDataItem("", name, relativePath, "", "");
            if (name != undefined && name != null) {
                let isExit = await this.checkAlbumExit(simpleAlbumDataItem);
                if (isExit) {
                    getResourceString($r('app.string.name_already_use')).then((message: string): void => {
                        showToast(message)
                    })
                    Log.warn(TAG, "album is miss")
                    this.onError();
                    return;
                }
            }
            let fetchOption: MediaLib.MediaFetchOptions = await  getFetchOptions(this.item.selectType, this.item.id, "")
            let albums: MediaLib.Album[] = await mediaModel.getAlbums(fetchOption)
            albums[0].albumName = name
            await albums[0].commitModify()
            this.onCompleted();
        } catch (error) {
            Log.error(TAG, `AlbumSet rename failed: ${error}`);
            this.onError();
        }
    }

    private cancelCallback(): void {
        Log.info(TAG, 'AlbumSet rename cancel');
    }

    onCompleted(): void{
        Log.info(TAG, 'Rename data succeed!');
        this.onOperationEnd && this.onOperationEnd();
    }

    onError(): void{
        Log.error(TAG, 'Rename data failed!');
        this.onOperationEnd && this.onOperationEnd();
    }
}