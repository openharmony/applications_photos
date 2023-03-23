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

import image from '@ohos.multimedia.image';
import fileIO from '@ohos.fileio';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import mediaModel from '@ohos/base/src/main/ets/model/MediaModel';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { ImageFilterStack } from './ImageFilterStack';
import { DateUtil } from './utils/DateUtil';
import { Loader } from './Loader';
import { PhotoEditorManager } from './PhotoEditorManager';

const TAG = "Save"

export class Save {
    private static readonly QUALITY_100: number = 100;

    constructor() {
    }

    public static async save(item: MediaDataItem, optStack: ImageFilterStack, isReplace: Boolean): Promise<number> {
        Log.info(TAG, `${JSON.stringify(item)} ${isReplace}`);
        try {
            let wrapper = await Loader.loadPixelMapWrapper(item);
            wrapper = optStack.apply(wrapper);
            Log.debug(TAG, 'Edit and restore operation execution end.');

            let options = {
                format: 'image/jpeg',
                quality: Save.QUALITY_100
            };
            let packer = image.createImagePacker();
            let pixelMap = wrapper.pixelMap as image.PixelMap;
            let buffer = await packer.packing(pixelMap, options);
            Log.info(TAG, 'Format pixelMap data to jpg data end.');

            let fileAsset = await this.createFileAsset(item, isReplace);
            Log.info(TAG, `create fileAsset succeed`);
            let fd = await mediaModel.openAsset('RW', fileAsset);
            if (fd < 0) {
                Log.warn(TAG, 'open asset failed.');
                return -1;
            }
            await fileIO.write(fd, buffer);
            PhotoEditorManager.getInstance().isSaving = false;
            Log.info(TAG, 'write jpg file end.');
            let newId = fileAsset.id;
            await mediaModel.closeAsset(fd, fileAsset);

            await packer.release();
            wrapper && wrapper.release();
            Log.info(TAG, `end`);
            return newId
        } catch (e) {
            Log.error(TAG, `save catch error: ${JSON.stringify(e)}`);
            return -1
        }
    }

    private static async createFileAsset(item: MediaDataItem, isReplace: Boolean) {
        let fileAsset =await item.loadFileAsset();

        if (!fileAsset) {
            Log.warn(TAG, 'get file error');
            return null;
        }
        let title = DateUtil.nameByDate(isReplace, fileAsset.displayName);
        if (null == title) {
            Log.warn(TAG, `create picture name failed.`);
            return null;
        }
        let displayName = title + '.jpg';
        Log.debug(TAG, `file displayname = ${displayName}, file path = ${fileAsset.relativePath}`);
        let favorite = false;
        if (isReplace) {
            favorite = await fileAsset.isFavorite();
            await item.onDelete();
            Log.debug(TAG, `trash picture file id ${item.id} end.`);
        }
        fileAsset = await mediaModel.createOne(fileAsset.mediaType, displayName, fileAsset.relativePath);
        if (favorite) {
            await fileAsset.favorite(favorite);
        }
        return fileAsset;
    }
}