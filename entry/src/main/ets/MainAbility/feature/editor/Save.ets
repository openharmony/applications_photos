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

import {MediaItem} from '../../common/model/browser/photo/MediaItem'
import {ImageFilterStack} from './ImageFilterStack'
import {Logger} from './utils/Logger'
import image from '@ohos.multimedia.image'
import fileIO from '@ohos.fileio';
import {MediaLibraryAccess} from '../../common/access/MediaLibraryAccess'
import {DateUtil} from './utils/DateUtil'
import {Loader} from './Loader'

export class Save {
    private static logger: Logger = new Logger('Save');

    constructor() {
    }

    public static async save(item: MediaItem, optStack: ImageFilterStack, isReplace: Boolean,
                             callback: Function): Promise<void> {
        this.logger.debug(`${JSON.stringify(item)} ${isReplace}`);
        let wrapper = await Loader.loadPixelMapWrapper(item);
        wrapper = optStack.apply(wrapper);
        this.logger.debug('Edit and restore operation execution ends.');

        let fileAsset = await this.createFileAsset(item.id, isReplace);
        this.logger.debug(`fileAsset = ${fileAsset}`);
        let fd = await MediaLibraryAccess.openAsset('RW', fileAsset);
        if (fd < 0) {
            this.logger.error('open asset failed.');
            return;
        }

        let options = {
            format: ["image/jpeg"],
            quality: 100
        };
        let packer = image.createImagePacker();
        let buffer = await packer.packingFromPixelMap(wrapper.pixelMap, options);
        this.logger.debug('Format pixel map data to jpg data end.');

        await fileIO.write(fd, buffer);
        await MediaLibraryAccess.closeAsset(fd, fileAsset);
        callback && callback();
    }

    private static async createFileAsset(id: number, isReplace: Boolean) {
        let fetchOpt = {
            selections: 'file_id =?',
            selectionArgs: [`${id}`],
        }
        let result = await MediaLibraryAccess.getFirstObject(fetchOpt);
        if (!result) {
            this.logger.error('get file error');
            return null;
        }
        let fileAsset = result.obj;
        let title = DateUtil.nameByDate(isReplace, fileAsset.displayName);
        if (null == title) {
            this.logger.error(`create picture name failed.`);
            return null;
        }
        let displayName = title + '.jpg';
        this.logger.debug(`file displayname = ${displayName}, file path = ${fileAsset.relativePath}`);
        let relativePath = this.getSavePath(fileAsset.mediaType, fileAsset.albumName);
        if (isReplace) {
            await MediaLibraryAccess.trashAsset(true, fileAsset);
            this.logger.debug(`trash picture file id ${id} end.`);
        }
        fileAsset = await MediaLibraryAccess.createAsset(fileAsset.mediaType, displayName, relativePath);
        return fileAsset;
    }

    private static getSavePath(mediaType: string, albumName: string): string {
        let path = '';
        let publicPath = '';
        if (mediaType == MediaLibraryAccess.MEDIA_TYPE_IMAGE) {
            publicPath = `${MediaLibraryAccess.PUBLIC_PATH_IMAGE}`
        } else {
            publicPath = `${MediaLibraryAccess.PUBLIC_PATH_VIDEO}`
        }
        if (albumName != '') {
            path = `${publicPath}${albumName}/`
        }
        this.logger.debug(`getSavePath path: ${path}`);
        return path;
    }
}