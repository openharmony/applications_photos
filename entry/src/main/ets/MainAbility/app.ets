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

import {Logger} from './common/utils/Logger'
import {ScreenManager} from './common/model/common/ScreenManager'
import {PixelMapManager} from './common/model/common/PixelMapManager'
import {StatusBarColorController} from './common/model/common/StatusBarColorController';
import {MediaLibraryAccess} from './common/access/MediaLibraryAccess'
import {TimelineDataSourceManager} from './feature/timeline/model/TimelineDataSourceManager';

const appLogger: Logger = new Logger('app');

export default {
    onCreate() {
        appLogger.info('Application onCreate');
        Environment.EnvProp('languageCode', 'default');
        MediaLibraryAccess.onCreate();
        // Improve cold startup performance. Initialize the timeline in advance
        TimelineDataSourceManager.getInstance();

        ScreenManager.getInstance().on(ScreenManager.ON_LEFT_BLANK_CHANGED, data => {
            appLogger.info(`onleftBlankChanged: ${data}`);
            AppStorage.SetOrCreate('leftBlank', data);
        });
        ScreenManager.getInstance().on(ScreenManager.ON_SPLIT_MODE_CHANGED, mode => {
            appLogger.info(`onSplitModeChanged: ${JSON.stringify(mode)}`);
            AppStorage.SetOrCreate('isSplitMode', mode);
        });
        MediaLibraryAccess.getPublicDirectory();
        appLogger.info('Application onCreate finish');
    },

    onDestroy() {
        appLogger.info('Application onDestroy');
        let pixelMapManager: PixelMapManager = PixelMapManager.getInstance();
        pixelMapManager.release();
        let statusBarColorController: StatusBarColorController = StatusBarColorController.getInstance();
        statusBarColorController.release();
        AppStorage.Delete('entryFromHap');
        MediaLibraryAccess.onDestroy();
    },
}
