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

import deviceInfo from '@ohos.deviceInfo';
import window from '@ohos.window';
import Ability from '@ohos.application.Ability';
import wantConstant from '@ohos.ability.wantConstant';
import { Log } from '../../../../../common/base/src/main/ets/utils/Log';
import screenManager from '../../../../../common/base/src/main/ets/manager/ScreenManager';
import { Constants } from '../common/model/common/Constants';
import broadcastManager from '../../../../../common/base/src/main/ets/manager/BroadcastManager';
import { startTrace, finishTrace } from '../../../../../common/base/src/main/ets/utils/TraceControllerUtils';
import { BroadcastConstants } from '../../../../../common/base/src/main/ets/constants/BroadcastConstants';
import mediaModel from '@ohos/base/src/main/ets/model/MediaModel';
import router from '@system.router';
import { GroupItemDataSource } from '../../../../../common/base/src/main/ets/vm/GroupItemDataSource';
import atManager from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';

let isFromCard = false;
let appBroadcast = broadcastManager.getBroadcast();
var pagePath: string = deviceInfo.deviceType == 'phone' || deviceInfo.deviceType == 'default' ? 'product/phone/view/index' : 'product/pad/view/index';

export default class MainAbility extends Ability {
    private TAG: string = 'MainAbility';
    private static readonly RETRY_MAX_TIMES = 100;
    private static readonly ACTION_URI_SINGLE_SELECT = 'singleselect';
    private static readonly ACTION_URI_MULTIPLE_SELECT = 'multipleselect';
    private static readonly ACTION_URI_PHOTO_DETAIL = 'photodetail';
    private browserDataSource : GroupItemDataSource = new GroupItemDataSource();

    onCreate(want, launchParam) {
        Log.info(this.TAG, 'Application onCreate');
        startTrace('onCreate');
        // Ability is creating, initialize resources for this ability
        globalThis.appContext = this.context;
        mediaModel.onCreate(this.context);
        let action = want.parameters;
        if (action != null && action != undefined && action.uri == MainAbility.ACTION_URI_PHOTO_DETAIL) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_CAMERA);
            this.browserDataSource.reloadGroupItemData(false).then(()=> {
                if (this.browserDataSource.groupDataItem.length == 0) {
                    this.onDestroy();
                }
            })
        } else if (action != null && action != undefined && action.uri == MainAbility.ACTION_URI_SINGLE_SELECT) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_SINGLE_SELECT);
        } else if (action != null && action != undefined && action.uri == MainAbility.ACTION_URI_MULTIPLE_SELECT) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_MULTIPLE_SELECT);
        } else if (action != null && action != undefined && action.uri == Constants.ACTION_URI_FORM_ABILITY) {
            isFromCard = true;
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_FORM_ABILITY);
            AppStorage.SetOrCreate(Constants.FROM_ALBUM_ID, action.albumId);
            AppStorage.SetOrCreate(Constants.FROM_CURRENT_INDEX, action.currentIndex);
        } else if (action != null && action != undefined && action.uri == Constants.ACTION_URI_FORM_ABILITY_NONE) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_FORM_ABILITY_NONE);
        } else if (action != null && action != undefined && action['formId'] != null) {
            AppStorage.SetOrCreate(Constants.FA_SETTING_FROM_ID, action['formId']);
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_FORM_FORM_EDITOR);
        } else if (want.action == wantConstant.Action.ACTION_VIEW_DATA) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_VIEW_DATA);
            AppStorage.SetOrCreate(Constants.VIEW_DATA_URI, want.uri);
            action && AppStorage.SetOrCreate(Constants.VIEW_DATA_POS, action.index);
        } else {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_NONE);
        }
        bundleManager.getApplicationInfo(Constants.BUNDLE_NAME, 0, (error, appInfo) => {
           if (error) {
                Log.error(this.TAG, `getApplicationInfo error: ${error}`);
                return;
            }
           let requestPermissionList: Array<string> = [
               "ohos.permission.READ_MEDIA",
               "ohos.permission.WRITE_MEDIA",
               "ohos.permission.MEDIA_LOCATION",
               "ohos.permission.DISTRIBUTED_DATASYNC"
           ];
           for (let permission of requestPermissionList) {
               atManager.createAtManager().checkAccessToken(appInfo.accessTokenId, permission).then((status) => {
                   if (status == atManager.GrantStatus.PERMISSION_DENIED) {
                       Log.error(this.TAG, `Failed to checkAccessToken permission = ${permission}`);
                   }
               })
           }
       })
        finishTrace('onCreate');
        appBroadcast.on(BroadcastConstants.THIRD_ROUTE_PAGE, this.thirdRouterPage.bind(this));
        Log.info(this.TAG, 'Application onCreate end');
    }

    onNewWant(want) {
        startTrace('onNewWant');
        let action = want.parameters;
        if (action != null && action != undefined && action.uri == MainAbility.ACTION_URI_PHOTO_DETAIL) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_CAMERA);
        } else if (action != null && action != undefined && action.uri == MainAbility.ACTION_URI_SINGLE_SELECT) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_SINGLE_SELECT);
        } else if (action != null && action != undefined && action.uri == MainAbility.ACTION_URI_MULTIPLE_SELECT) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_MULTIPLE_SELECT);
        } else if (action != null && action != undefined && action.uri == Constants.ACTION_URI_FORM_ABILITY) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_FORM_ABILITY);
            AppStorage.SetOrCreate(Constants.FROM_ALBUM_ID, action.albumId);
            AppStorage.SetOrCreate(Constants.FROM_CURRENT_INDEX, action.currentIndex);
        } else if (action != null && action != undefined && action.uri == Constants.ACTION_URI_FORM_ABILITY_NONE) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_FORM_ABILITY_NONE);
        } else if (action != null && action != undefined && action['formId'] != null) {
            AppStorage.SetOrCreate(Constants.FA_SETTING_FROM_ID, action['formId']);
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_FORM_FORM_EDITOR);
        } else if (want.action == wantConstant.Action.ACTION_VIEW_DATA) {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_VIEW_DATA);
            AppStorage.SetOrCreate(Constants.VIEW_DATA_URI, want.uri);
            action && AppStorage.SetOrCreate(Constants.VIEW_DATA_POS, action.index);
        } else {
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_NONE);
        }
        finishTrace('onNewWant');
    }

    onDestroy() {
        // Ability is creating, release resources for this ability
        Log.info(this.TAG, 'Application onDestroy');
        AppStorage.Delete(Constants.ENTRY_FROM_HAP);
    }

    onWindowStageCreate(windowStage) {
        startTrace('onWindowStageCreate');
        // Main window is created, set main page for this ability
        Log.info(this.TAG, 'Application onWindowStageCreate');
        globalThis.photosWindowStage = windowStage;
        startTrace('getMainWindow');
        windowStage.getMainWindow().then((win: window.Window) => {
            AppStorage.SetOrCreate(Constants.MAIN_WINDOW, win);
            finishTrace('getMainWindow');
            startTrace('initializationSize');
            screenManager.initializationSize(win).then(() => {
                finishTrace('initializationSize');
                if (isFromCard) {
                    windowStage.setUIContent(this.context, 'feature/browser/view/PhotoBrowser', null);
                } else {
                    windowStage.setUIContent(this.context, pagePath, null);
                }
                finishTrace('onWindowStageCreate');
            }).catch(() => {
                Log.error(this.TAG, `get device screen info failed.`);
            });
        });
    }

    onWindowStageDestroy() {
    }

    onForeground() {
    }

    onBackground() {
    }

    thirdRouterPage() {
        let entryFrom = AppStorage.Get(Constants.ENTRY_FROM_HAP);
        Log.info(this.TAG, `thirdRouterPage entryFromHap: ${entryFrom}`);
        if (entryFrom == Constants.ENTRY_FROM_NONE) {
            return;
        }
        if (entryFrom == Constants.ENTRY_FROM_CAMERA) {
            let options = {
                uri: 'feature/browser/view/PhotoBrowser',
                params: {
                    pageFrom: Constants.ENTRY_FROM.CAMERA
                }
            };
            router.replace(options);
        } else if (entryFrom == Constants.ENTRY_FROM_SINGLE_SELECT) {
            let options = {
                uri: 'feature/thirdSelect/view/ThirdSelectAlbumSetPage',
                params: {
                    isMultiPick: false,
                }
            };
            router.replace(options);
        } else if (entryFrom == Constants.ENTRY_FROM_MULTIPLE_SELECT) {
            let options = {
                uri: 'feature/thirdSelect/view/ThirdSelectAlbumSetPage',
                params: {
                    isMultiPick: true,
                }
            };
            router.replace(options);
        } else if (entryFrom == Constants.ENTRY_FROM_FORM_ABILITY) {
            let options = {
                uri: 'feature/browser/view/PhotoBrowser',
            };
            router.replace(options);
        } else if (entryFrom == Constants.ENTRY_FROM_FORM_ABILITY_NONE) {
            let options = {
                uri: pagePath
            }
            router.replace(options);
        } else if (entryFrom == Constants.ENTRY_FROM_FORM_FORM_EDITOR) {
            let options = {
                uri: 'feature/formEditor/view/FormEditorPage'
            }
            router.replace(options);
        } else if (entryFrom == Constants.ENTRY_FROM_VIEW_DATA) {
            let options = {
                uri: 'feature/browser/view/PhotoBrowser',
                params: {
                    pageFrom: Constants.ENTRY_FROM.VIEW_DATA,
                    viewData: AppStorage.Get(Constants.VIEW_DATA_URI),
                    position: AppStorage.Get(Constants.VIEW_DATA_POS),
                }
            };
            router.replace(options);
        }

        //router.clear()需要等页面跳转完成后调用，如果不延时调用会发生崩溃。
        setTimeout(() => {
            router.clear();
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, 0)
        }, 10);
    }
}