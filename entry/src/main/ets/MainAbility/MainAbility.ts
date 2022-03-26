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

import Ability from '@ohos.application.Ability'
import bundle from '@ohos.bundle';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import {Logger} from '../common/utils/Logger'
import {ScreenManager} from '../common/model/common/ScreenManager'
import {PixelMapManager} from '../common/model/common/PixelMapManager'
import {StatusBarColorController} from '../common/model/common/StatusBarColorController';
import {MediaLibraryAccess} from '../common/access/MediaLibraryAccess'
import {TimelineDataSourceManager} from '../feature/timeline/model/TimelineDataSourceManager';

const appLogger: Logger = new Logger('app');

export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        // Ability is creating, initialize resources for this ability
        globalThis.photosAbilityContext = this.context;
        let action = want.parameters;
        if (action != null && action != undefined && action.uri == 'photodetail') {
            AppStorage.SetOrCreate('entryFromHap', 1);
        } else if (action != null && action != undefined && action.uri == 'singleselect') {
            AppStorage.SetOrCreate('entryFromHap', 2);
        } else if (action != null && action != undefined && action.uri == 'multipleselect') {
            AppStorage.SetOrCreate('entryFromHap', 3);
        }  else {
            AppStorage.SetOrCreate('entryFromHap', 0);
        }

        let requestPermissionList: Array<string> = [
            "ohos.permission.READ_MEDIA",
            "ohos.permission.WRITE_MEDIA",
            "ohos.permission.MEDIA_LOCATION"
        ];
        bundle.getApplicationInfo('com.ohos.photos', 0, 100).then((appInfo) => {
            let accessTokenId = appInfo.accessTokenId
            let promiseStatus: Array<Promise<number>> = []
            let requestList: Array<string> = []
            let accessCtrl = abilityAccessCtrl.createAtManager()
            for (let i=0; i<requestPermissionList.length; i++) {
                promiseStatus.push(accessCtrl.verifyAccessToken(accessTokenId, requestPermissionList[i]))
            }
            Promise.all(promiseStatus).then((status) => {
                for (let i=0; i<status.length; i++) {
                    if (status[i] == abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
                        requestList.push(requestPermissionList[i])
                    }
                }
                if (requestList.length != 0) {
                    globalThis.photosAbilityContext.requestPermissionsFromUser(requestList).then(function (data) {
                        let result = 0
                        for (let i = 0; i < data.authResults.length; i++) {
                            result += data.authResults[i]
                        }
                        if (result >= -1) {
                            AppStorage.SetOrCreate('permissionStatus', true);
                        } else {
                            AppStorage.SetOrCreate('permissionStatus', false);
                        }
                    }, (err) => {
                        AppStorage.SetOrCreate('permissionStatus', false);
                    });
                } else {
                    AppStorage.SetOrCreate('permissionStatus', true);
                }
            })
        })
    }

    onNewWant(want) {
        let action = want.parameters;
        if (action != null && action != undefined && action.uri == 'photodetail') {
            AppStorage.SetOrCreate('entryFromHap', 1);
        } else if (action != null && action != undefined && action.uri == 'singleselect') {
            AppStorage.SetOrCreate('entryFromHap', 2);
        } else if (action != null && action != undefined && action.uri == 'multipleselect') {
            AppStorage.SetOrCreate('entryFromHap', 3);
        }  else {
            AppStorage.SetOrCreate('entryFromHap', 0);
        }
    }

    onDestroy() {
        // Ability is creating, release resources for this ability
        appLogger.info('Application onDestroy');
        let pixelMapManager: PixelMapManager = PixelMapManager.getInstance();
        pixelMapManager.release();
        let statusBarColorController: StatusBarColorController = StatusBarColorController.getInstance();
        statusBarColorController.release();
        AppStorage.Delete('entryFromHap');
        MediaLibraryAccess.onDestroy();
    }

    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        appLogger.info('Application onCreate');
;
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

        windowStage.getMainWindow().then((win) => {
            AppStorage.SetOrCreate('mainWindow', win);
            ScreenManager.getInstance().getAvoidArea();
            windowStage.setUIContent(this.context, 'product/phone/view/index', null);
        });
        globalThis.photosWindowStage = windowStage;
    }

    onWindowStageDestroy() {
    }

    onForeground() {
    }

    onBackground() {
    }
}