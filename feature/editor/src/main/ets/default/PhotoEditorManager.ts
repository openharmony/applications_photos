/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { Constants, Log, MediaItem } from '@ohos/common';
import { PhotoEditCrop } from './crop/PhotoEditCrop';
import { PhotoEditBase } from './base/PhotoEditBase';
import { PhotoEditMode } from './base/PhotoEditType';
import { PixelMapWrapper } from './base/PixelMapWrapper';
import { ImageFilterStack } from './ImageFilterStack';
import { Loader } from './Loader';
import { Save } from './Save';
import image from '@ohos.multimedia.image';

const TAG: string = 'editor_PhotoEditorManager';

export class PhotoEditorManager {
  private currentMode: PhotoEditMode = PhotoEditMode.EDIT_MODE_MAIN;
  private origin: PixelMapWrapper = undefined;
  private item: MediaItem = undefined;
  private editors: Array<PhotoEditBase> = undefined;
  private historyManager: ImageFilterStack = undefined;
  private albumUri: string = '';

  private constructor() {
    this.historyManager = new ImageFilterStack();
    this.editors = [];
    this.editors[PhotoEditMode.EDIT_MODE_CROP] = new PhotoEditCrop();
  }

  static getInstance(): PhotoEditorManager {
    if (AppStorage.get(Constants.PHOTO_EDITOR_MANAGER) == null) {
      AppStorage.setOrCreate(Constants.PHOTO_EDITOR_MANAGER, new PhotoEditorManager());
    }
    return AppStorage.get(Constants.PHOTO_EDITOR_MANAGER);
  }

  initialize(item: MediaItem, albumUri: string, mode: PhotoEditMode, errCallback?: Function): void {
    Log.info(TAG, `initialize mode[${mode}], item[${item.uri}] albumUri = ${albumUri}`);
    this.item = item;
    this.albumUri = albumUri;
    Loader.loadPixelMapWrapper(item, true).then((pixelMap) => {
      if (pixelMap) {
        this.origin = pixelMap;
        (this.historyManager as ImageFilterStack).setOriginPixelMap(this.origin);
        this.switchMode(mode);
      } else {
        Log.error(TAG, 'initialize loadPixelMapWrapper failed');
        errCallback && errCallback();
      }
    });
  }

  clear(): void {
    Log.debug(TAG, 'clear');
    this.item = undefined;
    if (this.origin) {
      this.origin.release();
      this.origin = undefined;
    }
    this.historyManager.setOriginPixelMap(undefined);
    this.historyManager.releaseAll();
    if (this.editors[this.currentMode]) {
      this.editors[this.currentMode].clearCanvas();
    }
    this.currentMode = PhotoEditMode.EDIT_MODE_MAIN;
  }

  getPhotoEditBaseInstance(mode: PhotoEditMode): PhotoEditBase {
    return this.editors[mode];
  }

  getLastestPixelMap(): PixelMapWrapper {
    let position = this.historyManager.getPosition();
    Log.debug(TAG, `getLastestPixelMap position = ${position}`);
    if (position < 0) {
      return this.origin;
    } else {
      return this.historyManager.at(position).getCache();
    }
  }

  switchMode(mode: PhotoEditMode): PhotoEditMode {
    Log.info(TAG, `switchMode: currentMode[${this.currentMode}] mode[${mode}]`);
    if (this.currentMode == mode) {
      return mode;
    }

    // exit current edit mode
    if (this.editors[this.currentMode] != undefined) {
      const filter = this.editors[this.currentMode].exit();
      if (filter != undefined) {
        // save cache
        if (!filter.isCached()) {
          const prePixelMap = this.getLastestPixelMap();
          filter.setCache(filter.render(prePixelMap));
        }
        this.historyManager.push(filter);
      }
    }

    // entry next edit mode
    let input = this.getLastestPixelMap();
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
    if (this.isRedoValid() && this.editors[this.currentMode] != undefined) {
      let newPixel = this.historyManager.doRedo();
      this.editors[this.currentMode].entry(newPixel);
      return true;
    }

    return false;
  }

  undo(): boolean {
    if (this.isUndoValid() && this.editors[this.currentMode] != undefined) {
      let newPixel = this.historyManager.doUndo();
      this.editors[this.currentMode].entry(newPixel);
      return true;
    }

    return false;
  }

  save(isReplace: boolean, callback: Function): void {
    if (this.editors[this.currentMode] != undefined) {
      Log.info(TAG, `save enter isReplace = ${isReplace}`);
      AppStorage.setOrCreate('isReplace', isReplace);
      AppStorage.setOrCreate('isEditFunc', true);
      const filter = this.editors[this.currentMode].exit();
      if (filter != undefined) {
        this.historyManager.push(filter);
      }
      Save.save(this.item as MediaItem, this.albumUri, this.historyManager as ImageFilterStack, isReplace, callback);
    } else {
      Log.warn(TAG, `editor is undefined, currentMode = ${this.currentMode}`);
    }
  }
}