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
import {OperationImpl} from './OperationImpl'
import {Logger} from '../../../utils/Logger.ets'
import {MediaLibraryAccess} from '../../../access/MediaLibraryAccess.ets'
import {AlbumDefine} from '../AlbumDefine.ets'
import { BroadCastConstants } from '../../common/BroadCastConstants.ets';
import { BroadCastManager } from '../../common/BroadCastManager.ets'
import { UiUtil } from '../../../utils/UiUtil.ets'

export class AlbumOperationImpl extends OperationImpl {
    logger: Logger = new Logger('AlbumOperationImpl');
    name: Resource;

    constructor() {
        super()
    }

    async rename(oldName:any, newName:any) {
        try{
            let targetAlbum = await MediaLibraryAccess.getAlbums(AlbumDefine.getAlbumFetchOpt(newName));
            if (targetAlbum.length > 0) {
                UiUtil.showToast($r('app.string.name_already_use'));
                return;
            }

            let sourceAlbum = await MediaLibraryAccess.getAlbums(AlbumDefine.getAlbumFetchOpt(oldName));
            this.logger.debug(`result length:${sourceAlbum.length} old Album name:${sourceAlbum[0].albumName}`);

            sourceAlbum[0].albumName = newName;
            await sourceAlbum[0].commitModify();

            BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.ON_OPERATION_FINISHED,['rename']);
        } catch (err) {
            this.logger.error(`rename ex: ${err}`);
        }
    }
}