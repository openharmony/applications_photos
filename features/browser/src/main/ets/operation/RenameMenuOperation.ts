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
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import type { MenuOperationCallback } from '@ohos/base/src/main/ets/operation/MenuOperationCallback';
import type { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import mediaModel from '@ohos/base/src/main/ets/model/MediaModel';
import { getFetchOptionsByItem } from '@ohos/base/src/main/ets/helper/MediaDataHelper';
import { SimpleAlbumDataItem } from '@ohos/base/src/main/ets/data/SimpleAlbumDataItem';
import { Constants } from '../constants/Constants';
import { getResourceString } from '@ohos/base/src/main/ets/utils/ResourceUtils';
import { showToast } from '@ohos/base/src/main/ets/utils/UiUtil';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';

const TAG = "RenameMenuOperation"

export class RenameMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    doAction(): void {
        if (this.menuContext == null) {
            Log.warn(TAG, 'menuContext is null, return');
            return;
        }
        let mediaItem = this.menuContext.items[0];
        if (mediaItem == null) {
            Log.warn(TAG, 'mediaItem is null, return');
            return;
        }

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);
        let fileName = '';
        if (mediaItem.title) {
            fileName = mediaItem.title;
        } else {
            let index = mediaItem.displayName.lastIndexOf('.');
            fileName = mediaItem.displayName.substr(0, index);
        }

        this.menuContext.broadCast.emit(BroadcastConstants.SHOW_RENAME_PHOTO_DIALOG,
            [fileName, this.confirmCallback, this.cancelCallback]);
    }

    onCompleted(): void {
        Log.info(TAG, 'Rename data succeed!');
    }

    onError(): void {
        Log.error(TAG, 'Rename data failed!');
    }

    private async confirmCallback(title: string) {
        Log.info(TAG, `Rename confirm new name: ${title}`);
        let mediaItem = (this.menuContext.items[0] as MediaDataItem);
        if (mediaItem == null) {
            Log.warn(TAG, 'mediaItem is null, return');
            return;
        }

        let hasSameName = await this.hasSameNameAsset(mediaItem, title);
        if (hasSameName) {
            Log.info(TAG, 'show find same file dialog');
            getResourceString($r('app.string.name_already_use')).then((message: string) => {
                showToast(message);
            })
            return;
        }
        try {
            let result = await this.rename(mediaItem, title);
            Log.info(TAG, `Rename confirm result: ${result}`);
            this.menuContext.broadCast.emit(Constants.RENAME, [result]);
        } catch (err) {
            Log.error(TAG, `Rename error: ${err}`);
            getResourceString($r('app.string.rename_failed')).then((message: string) => {
                showToast(message);
            })
        }

    }

    private async rename(item: MediaDataItem, name: string) {
        Log.info(TAG, 'renameSinglePhoto start');
        item.setName(name);
        return [item.title, item.displayName];
    }

    private async hasSameNameAsset(item: MediaDataItem, name: string) {
       Log.debug(TAG, 'hasSameNameAsset start');
        let fileAsset = await item.loadFileAsset();
        let displayName = fileAsset.displayName;
        let index = displayName.lastIndexOf('.');
        displayName = name + displayName.slice(index);

        let simpleAlbumDataItem = new SimpleAlbumDataItem("", displayName, fileAsset.relativePath, "", "");
        let fetchOption = await getFetchOptionsByItem(simpleAlbumDataItem);
        let counts = (await mediaModel.getAllCommonMediaItem(fetchOption, true)).counts;

        if (counts == 0) {
            Log.warn(TAG, 'hasSameNameAsset is false');
            return false;
        }

       Log.debug(TAG, 'hasSameNameAsset true');
        return true;
    }

    private cancelCallback(): void {
        Log.info(TAG, 'Rename cancel');
    }
}