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

import { Constants } from '../../common/model/common/Constants';
import { PhotoEditCrop } from './crop/PhotoEditCrop';
import { PhotoEditBase } from './base/PhotoEditBase';
import { PhotoEditMode } from './base/PhotoEditType';
import { PixelMapWrapper } from './base/PixelMapWrapper';
import { ImageFilterStack } from './ImageFilterStack';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { Loader } from './Loader';
import { Save } from './Save';
import { Log } from '@ohos/base/src/main/ets/utils/Log';

export class PhotoEditorManager {
    private TAG: string = 'PhotoEditorManager';
    private currentMode: PhotoEditMode = PhotoEditMode.EDIT_MODE_MAIN;
    private origin: PixelMapWrapper = undefined;
    private item: MediaDataItem = undefined;
    private editors: Array<PhotoEditBase> = undefined;
    private historyManager: ImageFilterStack = undefined;
    isSaving: boolean = false;

    private constructor() {
        this.historyManager = new ImageFilterStack();
        this.editors = [];
        this.editors[PhotoEditMode.EDIT_MODE_CROP] = new PhotoEditCrop();
    }

    static getInstance(): PhotoEditorManager {
        if (AppStorage.Get(Constants.PHOTO_EDITOR_MANAGER) == null) {
            AppStorage.SetOrCreate(Constants.PHOTO_EDITOR_MANAGER, new PhotoEditorManager());
        }
        return AppStorage.Get(Constants.PHOTO_EDITOR_MANAGER);
    }

    initialize(item: MediaDataItem, mode: PhotoEditMode, errCallback?: any) {
        Log.info(this.TAG, `initialize mode[${mode}]`);
        this.item = item;
        Loader.loadPixelMapWrapper(item, true).then((pixelMap) => {
            if (pixelMap) {
                this.origin = pixelMap;
                this.historyManager.setOriginPixelMap(this.origin);
                this.switchMode(mode);
            } else {
                Log.error(this.TAG, 'initialize loadPixelMapWrapper failed');
                errCallback && errCallback();
            }
        })
    }

    clear() {
        Log.debug(this.TAG, 'clear');
        this.editors[this.currentMode] && this.editors[this.currentMode].exit();
        this.item = undefined;
        this.origin && this.origin.release();
        this.origin = undefined;
        this.historyManager.setOriginPixelMap(undefined);
        this.historyManager.releaseAll();
        this.currentMode = PhotoEditMode.EDIT_MODE_MAIN;
    }

    getPhotoEditBaseInstance(mode: PhotoEditMode): PhotoEditBase {
        return this.editors[mode];
    }

    getLastPixelMap(): PixelMapWrapper {
        let position = this.historyManager.getPosition();
        Log.debug(this.TAG, `getLastPixelMap position = ${position}`);
        if (position < 0) {
            return this.origin;
        } else {
            return this.historyManager.at(position).getCache();
        }
    }

    switchMode(mode: PhotoEditMode): PhotoEditMode {
        Log.info(this.TAG, `switchMode: currentMode[${this.currentMode}] mode[${mode}]`);
        if (this.currentMode == mode) {
            return mode;
        }

        // exit current edit mode
        if (this.editors[this.currentMode] != undefined) {
            const filter = this.editors[this.currentMode].exit();
            if (filter != undefined) {
                // save cache
                if (!filter.isCached()) {
                    const prePixelMap = this.getLastPixelMap();
                    filter.setCache(filter.render(prePixelMap));
                }
                this.historyManager.push(filter);
            }
        }

        // entry next edit mode
        let input = this.getLastPixelMap();
        if (input && this.editors[mode] != undefined) {
            this.editors[mode].entry(input);
            // update current edit mode
            this.currentMode = mode;
        }
        return this.currentMode;
    }

    isRedoValid(): boolean {
        return this.historyManager.isRedoValid();
    }

    isUndoValid(): boolean {
        return this.historyManager.isUndoValid();
    }

    redo(): boolean {
        if (this.isRedoValid()) {
            let newPixel = this.historyManager.doRedo();
            this.editors[this.currentMode].entry(newPixel);
            return true;
        }

        return false;
    }

    undo(): boolean {
        if (this.isUndoValid()) {
            let newPixel = this.historyManager.doUndo();
            this.editors[this.currentMode].entry(newPixel);
            return true;
        }

        return false;
    }

    async save(isReplace: boolean): Promise<number> {
        Log.info(this.TAG, `save enter isReplace = ${isReplace}`);
        this.isSaving = true;
        const filter = this.editors[this.currentMode].exit();
        if (filter != undefined) {
            this.historyManager.push(filter);
        }
        return await Save.save(this.item, this.historyManager, isReplace);;
    }
}