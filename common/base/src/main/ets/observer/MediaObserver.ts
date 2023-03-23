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

import createOrGet from '../utils/SingleInstanceUtils';
import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import mediaModel from '../model/MediaModel';
import type { MediaObserverCallback } from '../interface/MediaObserverCallback';

const TAG = "MediaObserver"

class MediaObserver {
    callbacks: MediaObserverCallback[] = [];
    private static readonly OBSERVER_IMAGE_CHANGE: string = 'imageChange';
    private static readonly OBSERVER_VIDEO_CHANGE: string = 'videoChange';
    private static readonly OBSERVER_DEVICE_CHANGE: string = 'deviceChange';
    private static readonly OBSERVER_ALBUM_CHANGE: string = 'albumChange';
    private static readonly OBSERVER_REMOTE_FILE_CHANGE: string = 'remoteFileChange';

    registerObserver(callback: MediaObserverCallback) {
        Log.info(TAG, 'registerObserver');
        if (callback == null) {
            Log.warn(TAG, 'registerObserver with empty callback');
            return;
        }

        if (this.callbacks.indexOf(callback) < 0) {
            this.callbacks.push(callback);
        } else {
            Log.info(TAG, 'registerObserver already exist');
            return;
        }

        if (this.callbacks.length == 1) {
            Log.info(TAG, 'registerObserver register media');
              try {
                mediaModel.getMediaLibrary().on('imageChange', () => {
                    Log.info(TAG, 'registerObserver on image');
                    this.sendNotify(MediaConstants.MEDIA_TYPE_IMAGE);
                })
                mediaModel.getMediaLibrary().on('videoChange', () => {
                    Log.info(TAG, 'registerObserver on video');
                    this.sendNotify(MediaConstants.MEDIA_TYPE_VIDEO);
                })
                mediaModel.getMediaLibrary().on('deviceChange', () => {
                    Log.info(TAG, 'registerObserver on device');
                    this.sendNotify(MediaConstants.MEDIA_TYPE_DEVICE);
                })
                mediaModel.getMediaLibrary().on('albumChange', () => {
                    Log.info(TAG, 'registerObserver on album');
                    this.sendNotify(MediaConstants.MEDIA_TYPE_ALBUM);
                })
                mediaModel.getMediaLibrary().on('remoteFileChange', () => {
                    Log.info(TAG, 'registerObserver on remoteFile');
                    this.sendNotify(MediaConstants.MEDIA_TYPE_REMOTE);
                })
            } catch (err) {
                Log.error(TAG, `registerObserver faild, err: ${JSON.stringify(err)}`);
            }
        }
    }

    sendNotify(mediaType: string) {
        Log.info(TAG, `registerObserver sendNotify size: ${this.callbacks.length}`);
        for (let callback of this.callbacks) {
            callback.onChange(mediaType);
        }
    }

    unregisterObserver(callback: MediaObserverCallback) {
        Log.info(TAG, 'unregisterObserver');
        const pos = this.callbacks.indexOf(callback);
        if (pos >= 0) {
            this.callbacks.splice(pos, 1);
        }
    }
}

let mediaObserver = createOrGet(MediaObserver, TAG);

export default mediaObserver as MediaObserver;