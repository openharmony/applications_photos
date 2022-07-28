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

import { MediaItem } from '../../common/model/browser/photo/MediaItem'
import { ImageFilterStack } from './ImageFilterStack'
import { Logger } from './utils/Logger'
import image from '@ohos.multimedia.image'
import fileIO from '@ohos.fileio'
import { MediaLibraryAccess } from '../../common/access/MediaLibraryAccess'
import { BrowserDataFactory } from '../../common/interface/BrowserDataFactory'
import { DateUtil } from './utils/DateUtil'
import { Loader } from './Loader'

export class Save {
    private static logger: Logger = new Logger('Save');
    private static readonly QUALITY_100: number = 100;

    constructor() {
    }

    public static async save(item: MediaItem, optStack: ImageFilterStack, isReplace: Boolean,
                             callback: Function): Promise<void> {
        this.logger.info(`${JSON.stringify(item)} ${isReplace}`);
        try {
            let wrapper = await Loader.loadPixelMapWrapper(item);
            wrapper = optStack.apply(wrapper);
            this.logger.debug('Edit and restore operation execution end.');

            let fileAsset = await this.createFileAsset(item.id, isReplace);
            this.logger.info(`create fileAsset succeed: [${fileAsset}]`);
            let fd = await MediaLibraryAccess.getInstance().openAsset('RW', fileAsset);
            if (fd < 0) {
                this.logger.error('open asset failed.');
                return;
            }

            let options = {
                format: 'image/jpeg',
                quality: Save.QUALITY_100
            };
            let packer = image.createImagePacker();
            let pixelMap = wrapper.pixelMap as image.PixelMap;
            let buffer = await packer.packing(pixelMap, options);
            this.logger.info('Format pixelMap data to jpg data end.');

            await fileIO.write(fd, buffer);
            this.logger.info('write jpg file end.');
            let newId = fileAsset.id;
            await MediaLibraryAccess.getInstance().closeAsset(fd, fileAsset);
            wrapper && wrapper.release();
            await packer.release();
            callback && callback(newId);
        } catch (e) {
            this.logger.error(`save catch error: ${JSON.stringify(e)}`);
            callback && callback(-1);
        }
        ;
    }

    private static async createFileAsset(id: number, isReplace: Boolean) {
        let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
        let fileAsset = await dataImpl.getDataById(id);

        if (!fileAsset) {
            this.logger.error('get file error');
            return null;
        }
        let title = DateUtil.nameByDate(isReplace, fileAsset.displayName);
        if (null == title) {
            this.logger.error(`create picture name failed.`);
            return null;
        }
        let displayName = title + '.jpg';
        this.logger.debug(`file displayname = ${displayName}, file path = ${fileAsset.relativePath}`);
        let favorite = false;
        if (isReplace) {
            favorite = await fileAsset.isFavorite();
            await MediaLibraryAccess.getInstance().trashAsset(true, fileAsset);
            this.logger.debug(`trash picture file id ${id} end.`);
        }
        fileAsset = await MediaLibraryAccess.getInstance().createAsset(
            fileAsset.mediaType, displayName, fileAsset.relativePath);
        if (favorite) {
            await fileAsset.favorite(favorite);
        }
        return fileAsset;
    }
}