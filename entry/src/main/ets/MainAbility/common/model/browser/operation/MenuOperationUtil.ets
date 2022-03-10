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

import {Logger} from '../../../utils/Logger'
import {MenuOperationCallback} from './MenuOperationCallback'
import MediaLib from '@ohos.multimedia.mediaLibrary';

export class MenuOperationUtil {
    // logger
    static logger: Logger = new Logger('MenuOperationUtil');

    static requestFavorite(uris: string[], value: boolean, callback?: MenuOperationCallback): void {
        if (uris == null) {
            this.logger.error('setFavorite with empty uris');
            return;
        }
        this.logger.debug(`setFavorite size: ${uris.length} value: ${value}`);

        MediaLib.getMediaLibrary().requestFavorite(uris, value, (err, data) => {
            if (err) {
                this.logger.error(`requestFavorite error: ${JSON.stringify(err)}`);
                if (callback != null) {
                    callback.onError();
                }
                return;
            }

            this.logger.debug(`requestFavorite data: ${JSON.stringify(data)}`);
            if (callback != null) {
                callback.onCompleted();
            }
        });
    }

    static requestDelete(uris: string[], callback?: MenuOperationCallback): void {
        if (uris == null) {
            this.logger.error('requestDelete with empty uris');
            return;
        }
        this.logger.debug(`requestDelete size: ${uris.length}`);

        MediaLib.getMediaLibrary().commitDeletion(uris, (err, data) => {
            if (err) {
                this.logger.error(`requestDelete error: ${JSON.stringify(err)}`);
                if (callback != null) {
                    callback.onError();
                }
                return;
            }
            this.logger.debug(`requestDelete data: ${JSON.stringify(data)}`);
            if (callback != null) {
                callback.onCompleted();
            }
        });
    }
}