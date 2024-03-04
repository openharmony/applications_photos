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
import type { MediaObserverCallback } from './MediaObserverCallback';
import { Log } from '../../../utils/Log';
import { Constants } from '../../common/Constants';
import type { ChangeData, UserFileManager } from '../../../access/UserFileManagerAccess';
import { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';

const TAG: string = 'common_MediaObserver';

export class MediaObserver {
  callbacks: Set<MediaObserverCallback> = new Set<MediaObserverCallback>();
  private freezeFlag: boolean = false;

  static getInstance(): MediaObserver {
    if (AppStorage.get(Constants.APP_KEY_MENU_USER_FILE_MANAGER_OBSERVER) == null) {
      AppStorage.setOrCreate(Constants.APP_KEY_MENU_USER_FILE_MANAGER_OBSERVER, new MediaObserver());
    }
    return AppStorage.get(Constants.APP_KEY_MENU_USER_FILE_MANAGER_OBSERVER);
  }

  registerObserver(callback: MediaObserverCallback) {
    Log.info(TAG, 'registerObserver');
    if (!callback) {
      Log.warn(TAG, 'registerObserver with empty callback');
      return;
    }

    if (this.callbacks.has(callback)) {
      Log.warn(TAG, 'registerObserver already exist');
      return;
    }
    this.callbacks.add(callback);
  }

  unregisterObserver(callback: MediaObserverCallback) {
    Log.info(TAG, 'unregisterObserver');
    if (!callback) {
      Log.warn(TAG, 'unregisterObserver with empty callback');
      return;
    }

    if (this.callbacks.has(callback)) {
      this.callbacks.delete(callback);
    } else {
      Log.warn(TAG, 'unregisterObserver not exist');
    }
  }

  freezeNotify(): void {
    this.freezeFlag = true;
  }

  unfreezeNotify(): void {
    this.freezeFlag = false;
  }

  forceNotify(): void {
    this.sendNotify('image');
  }

  sendNotify(mediaType: string) {
    Log.info(TAG, `sendNotify size: ${this.callbacks.size}`);
    if (this.freezeFlag) {
      return;
    }
    for (let callback of this.callbacks) {
      callback.onChange(mediaType);
    }
  }

  registerForAllPhotos() {
    Log.info(TAG, 'registerForAllPhotos');
    let userFileManager: UserFileManager = UserFileManagerAccess.getInstance().getMediaLibrary();
    if (userFileManager) {
      userFileManager.on(UserFileManagerAccess.REGISTER_TYPE_ALL_PHOTOS, true, (changeData: ChangeData) => {
        Log.info(TAG, `userFileManager.on for REGISTER_TYPE_ALL_PHOTOS, ${JSON.stringify(changeData)}`);
        this.sendNotify('image');
      });
    } else {
      Log.error(TAG, 'register is null!');
    }
  }

  unregisterForAllPhotos() {
    Log.info(TAG, 'unregisterForAllPhotos');
    let userFileManager: UserFileManager = UserFileManagerAccess.getInstance().getMediaLibrary();
    if (userFileManager) {
      userFileManager.off(UserFileManagerAccess.REGISTER_TYPE_ALL_PHOTOS);
    } else {
      Log.error(TAG, 'unregister is null!');
    }
  }

  registerForAllAlbums() {
    Log.info(TAG, 'registerForAllAlbums');
    let userFileManager: UserFileManager = UserFileManagerAccess.getInstance().getMediaLibrary();
    if (userFileManager) {
      userFileManager.on(UserFileManagerAccess.REGISTER_TYPE_ALL_ALBUMS, true, (changeData: ChangeData) => {
        Log.info(TAG, `userFileManager.on for REGISTER_TYPE_ALL_ALBUMS, ${JSON.stringify(changeData)}`);
        this.sendNotify('image');
      });
    } else {
      Log.error(TAG, 'register is null!');
    }
  }

  unregisterForAllAlbums() {
    Log.info(TAG, 'unregisterForAllAlbums');
    let userFileManager: UserFileManager = UserFileManagerAccess.getInstance().getMediaLibrary();
    if (userFileManager) {
      userFileManager.off(UserFileManagerAccess.REGISTER_TYPE_ALL_ALBUMS);
    } else {
      Log.error(TAG, 'unregister is null!');
    }
  }

  registerForAlbum(albumUri: string) {
    Log.info(TAG, 'registerForAllAlbums');
    let userFileManager: UserFileManager = UserFileManagerAccess.getInstance().getMediaLibrary();
    if (userFileManager) {
      userFileManager.on(albumUri, false, (changeData: ChangeData) => {
        Log.info(TAG, 'userFileManager.on for REGISTER_TYPE_ALL_ALBUMS');
        this.sendNotify('album');
      });
    } else {
      Log.error(TAG, 'register is null!');
    }
  }

  unregisterForAlbum(albumUri: string) {
    Log.info(TAG, 'unregisterForAllAlbums');
    let userFileManager: UserFileManager = UserFileManagerAccess.getInstance().getMediaLibrary();
    if (userFileManager) {
      userFileManager.off(albumUri);
    } else {
      Log.error(TAG, 'unregister is null!');
    }
  }
}