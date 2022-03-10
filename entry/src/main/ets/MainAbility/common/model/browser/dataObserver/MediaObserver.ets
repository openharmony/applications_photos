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

import {MediaObserverCallback} from './MediaObserverCallback';
import {Logger} from '../../../utils/Logger.ets'
import {Constants} from '../../common/Constants'
import {MediaLibraryAccess} from '../../../access/MediaLibraryAccess'

export class MediaObserver {
    private logger: Logger = new Logger('MediaObserver');
    callbacks: MediaObserverCallback[] = [];

    static getInstance(): MediaObserver {
        if (AppStorage.Get(Constants.APP_KEY_MENU_MEDIA_OBSERVER) == null) {
            AppStorage.SetOrCreate(Constants.APP_KEY_MENU_MEDIA_OBSERVER, new MediaObserver());
        }
        return AppStorage.Get(Constants.APP_KEY_MENU_MEDIA_OBSERVER);
    }

    registerObserver(callback: MediaObserverCallback) {
        this.logger.info('registerObserver');
        if (callback == null) {
            this.logger.info('registerObserver with empty callback');
            return;
        }

        if (this.callbacks.indexOf(callback) < 0) {
            this.callbacks.push(callback);
        } else {
            this.logger.info('registerObserver already exist');
            return;
        }

        if (this.callbacks.length == 1) {
            this.logger.info('registerObserver register media');
            MediaLibraryAccess.getMediaLibrary().on('imageChange', () => {
                this.logger.info('registerObserver on image');
            })
            MediaLibraryAccess.getMediaLibrary().on('videoChange', () => {
                this.logger.info('registerObserver on video');
            })
            MediaLibraryAccess.getMediaLibrary().on('deviceChange', () => {
                this.logger.info('registerObserver on device');
                this.sendNotify('device');
            })
            MediaLibraryAccess.getMediaLibrary().on('albumChange', () => {
                this.logger.info('registerObserver on album');
                this.sendNotify('album');
            })
            MediaLibraryAccess.getMediaLibrary().on('remoteFileChange', () => {
                this.logger.info('registerObserver on remoteFile');
                this.sendNotify('remoteFile');
            })
        }
    }

    sendNotify(mediaType: string) {
        this.logger.info(`registerObserver sendNotify size: ${this.callbacks.length}`);
        for (let callback of this.callbacks) {
            callback.onChange(mediaType);
        }
    }

    unregisterObserver(callback: MediaObserverCallback) {
        this.logger.info('unregisterObserver');
        const pos = this.callbacks.indexOf(callback);
        if (pos >= 0) {
            this.callbacks.splice(pos, 1);
        }
    }
}