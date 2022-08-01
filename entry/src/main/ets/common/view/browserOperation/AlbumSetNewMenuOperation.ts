// @ts-nocheck
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

import {Logger} from '../../utils/Logger'
import {BroadCastConstants} from '../../model/common/BroadCastConstants';
import {MenuOperationCallback} from './MenuOperationCallback'
import {MenuOperation} from './MenuOperation'
import {MenuContext} from './MenuContext'
import {JumpSourceToMain} from '../../model/browser/photo/JumpSourceToMain'
import {AlbumInfo} from '../../model/browser/album/AlbumInfo';
import router from '@system.router';
import resmgr from '@ohos.resourceManager';
import {UiUtil} from '../../utils/UiUtil'
import { AlbumDefine } from '../../model/browser/AlbumDefine'
import {BrowserDataFactory} from '../../interface/BrowserDataFactory'

export class AlbumSetNewMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('AlbumSetNewMenuOperation');
    private defaultAlbumName: string;
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
            let resourceManager: resmgr.ResourceManager = await resmgr.getResourceManager(context);
            let result = await resourceManager.getString(a.id);
            this.defaultAlbumName = result;
            this.logger.info(`The display name is ${this.defaultAlbumName}`);
            let newAlbumDisplayName
                = this.getNewAlbumDefaultName(this.defaultAlbumName);
            this.logger.info(`The display name of new album is ${newAlbumDisplayName}`);

            this.confirmCallback = this.confirmCallback.bind(this);
            this.cancelCallback = this.cancelCallback.bind(this);

            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
                [newAlbumDisplayName, this.confirmCallback, this.cancelCallback]);
        } catch(e) {
            this.logger.error(`The display name e ${e}`);
        }
    }

    private async confirmCallback(displayName: string) {
        this.logger.info(`AlbumSet new album confirm and the new name is: ${displayName}`);
        let newAlbumInfo = new AlbumInfo('', '', displayName, displayName, 0, '', AlbumDefine.genAlbumRelativePath(displayName))

        if (null != displayName && undefined != displayName) {
            let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
            let targetAlbum = await dataImpl.getDataByName(displayName, {relativePath:  AlbumDefine.genAlbumRelativePath('', true)})
            if (targetAlbum) {
                UiUtil.showToast($r('app.string.name_already_use'));
                return;
            }
        }
        this.onOperationEnd = this.menuContext.onOperationEnd;
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        if (this.menuContext.jumpSourceToMain == JumpSourceToMain.ALBUM) {
            this.logger.info('go back to photo grid');
            this.menuContext.broadCast.emit(BroadCastConstants.MEDIA_OPERATION,
                [newAlbumInfo, this.onCompleted.bind(this)]);
        } else {
            router.push({
                uri: 'feature/albumSelect/view/AlbumSelect/AlbumSelect',
                params: {
                    albumInfo: JSON.stringify(newAlbumInfo),
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

    private getNewAlbumDefaultName(prefixName : string) : string {
        let numbers = [];
        for (let i = 0; i < this.menuContext.albumSetDataSource.totalCount(); i++) {
            let res = this.menuContext.albumSetDataSource.getData(i).name.match(new RegExp(`^${prefixName}[1-9][0-9]*$`));
            if (res != null) {
                let number = res[0].match(new RegExp(`[1-9][0-9]*`));
                numbers.push(parseInt(number[0]));
            }
        }

        this.logger.debug(`${JSON.stringify(numbers)}`);

        if (numbers.length <= 0) {
            return `${prefixName}1`;
        } else if (numbers.length == 1) {
            if (numbers[0] - 1 > 0) {
                return `${prefixName}1`;
            } else {
                return `${prefixName}${numbers[0] + 1}`;
            }
        }

        numbers.sort(function(a, b) { return a - b; });

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