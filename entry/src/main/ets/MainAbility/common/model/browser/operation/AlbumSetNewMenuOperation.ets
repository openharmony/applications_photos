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

import {Logger} from "../../../utils/Logger.ets"
import {BroadCastConstants} from '../../common/BroadCastConstants.ets';
import {MenuOperationCallback} from './MenuOperationCallback'
import {MenuOperation} from './MenuOperation'
import {MenuContext} from './MenuContext'
import {JumpSourceToMain} from '../../browser/photo/JumpSourceToMain.ets'
import router from '@system.router';
import resmgr from '@ohos.resourceManager';
import {UiUtil} from '../../../utils/UiUtil.ets'

export class AlbumSetNewMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('AlbumSetNewMenuOperation');
    private defaultAlbumName: string;
    private newAlbumDisplayName: string;
    private onOperationEnd: Function;

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    async doAction(): Promise<void> {
        if (this.menuContext == null) {
            this.logger.error('menuContext is null, return');
            return;
        }

        let a = $r('app.string.album_new_album');
        this.logger.info(`The display name from resource ${JSON.stringify(a)}`);
        this.defaultAlbumName = '';
        try {
            let context = globalThis.photosAbilityContext;
            let resourceManager = await resmgr.getResourceManager(context);
            let result = await resourceManager.getString(a.id);
            this.defaultAlbumName = result;
            this.logger.info(`The display name is ${this.defaultAlbumName}`);
            this.newAlbumDisplayName
                = this.menuContext.albumSetDataSource.getNewAlbumDefaultName(this.defaultAlbumName);
            this.logger.info(`The display name of new album is ${this.newAlbumDisplayName}`);

            this.confirmCallback = this.confirmCallback.bind(this);
            this.cancelCallback = this.cancelCallback.bind(this);

            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
                [this.newAlbumDisplayName, this.confirmCallback, this.cancelCallback]);
        } catch(e) {
            this.logger.info(`The display name e ${e}`);
        }
    }

    private confirmCallback(displayName: string): void {
        this.logger.info(`AlbumSet new album confirm and the new name is: ${displayName}`);
        if (null != displayName && undefined != displayName) {
            if (this.menuContext.albumSetDataSource.isRepeatedName(displayName)) {
                UiUtil.showToast($r('app.string.name_already_use'));
                return;
            }
            this.newAlbumDisplayName = displayName;
        }
        this.onOperationEnd = this.menuContext.onOperationEnd;
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        if (this.menuContext.jumpSourceToMain == JumpSourceToMain.ALBUM) {
            this.logger.info('go back to photo grid');
            this.menuContext.broadCast.emit(BroadCastConstants.MEDIA_OPERATION,
                [this.newAlbumDisplayName, this.onCompleted.bind(this)]);
        } else {
            router.push({
                uri: 'feature/browser/view/album/AlbumSelect',
                params: {
                    albumName: this.newAlbumDisplayName,
                    isNewAlbum: true
                }
            });
            this.onCompleted();
        }
    }

    private cancelCallback(): void {
        this.logger.info('AlbumSet new album cancel');
    }

    onCompleted(): void {
        this.logger.info('new album data succeed!');
        this.onOperationEnd && this.onOperationEnd();
    }

    onError(): void {
        this.logger.error('new album data failed!');
        this.onOperationEnd && this.onOperationEnd();
    }
}