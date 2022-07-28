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

import { MediaObserverCallback } from './MediaObserverCallback';
import { Logger } from '../../../utils/Logger'
import { Constants } from '../../common/Constants'
import { MediaLibraryAccess } from '../../../access/MediaLibraryAccess'

export class MediaObserver {
    private logger: Logger = new Logger('MediaObserver');
    callbacks: MediaObserverCallback[] = [];
    private static readonly OBSERVER_IMAGE_CHANGE: string = 'imageChange'
    private static readonly OBSERVER_VIDEO_CHANGE: string = 'videoChange'
    private static readonly OBSERVER_DEVICE_CHANGE: string = 'deviceChange'
    private static readonly OBSERVER_ALBUM_CHANGE: string = 'albumChange'
    private static readonly OBSERVER_REMOTE_FILE_CHANGE: string = 'remoteFileChange'

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
            MediaLibraryAccess.getInstance().getMediaLibrary().on(MediaObserver.OBSERVER_IMAGE_CHANGE, () => {
                this.logger.info('registerObserver on image');
                this.sendNotify(Constants.MEDIA_TYPE_IMAGE);
            })
            MediaLibraryAccess.getInstance().getMediaLibrary().on(MediaObserver.OBSERVER_VIDEO_CHANGE, () => {
                this.logger.info('registerObserver on video');
                this.sendNotify(Constants.MEDIA_TYPE_VIDEO);
            })
            MediaLibraryAccess.getInstance().getMediaLibrary().on(MediaObserver.OBSERVER_DEVICE_CHANGE, () => {
                this.logger.info('registerObserver on device');
                this.sendNotify(Constants.MEDIA_TYPE_DEVICE);
            })
            MediaLibraryAccess.getInstance().getMediaLibrary().on(MediaObserver.OBSERVER_ALBUM_CHANGE, () => {
                this.logger.info('registerObserver on album');
                this.sendNotify(Constants.MEDIA_TYPE_ALBUM);
            })
            MediaLibraryAccess.getInstance().getMediaLibrary().on(MediaObserver.OBSERVER_REMOTE_FILE_CHANGE, () => {
                this.logger.info('registerObserver on remoteFile');
                this.sendNotify(Constants.MEDIA_TYPE_REMOTE);
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