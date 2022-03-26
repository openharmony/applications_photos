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
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';

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

    onDestroy() {
        // Ability is creating, release resources for this ability
    }

    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        windowStage.setUIContent(this.context, 'product/phone/view/index', null);
        windowStage.getMainWindow().then((win) => {
            AppStorage.SetOrCreate('mainWindow', win);
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