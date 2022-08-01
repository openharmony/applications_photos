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
import wantConstant from '@ohos.ability.wantConstant'
import { Logger } from '../common/utils/Logger'
import { ScreenManager } from '../common/model/common/ScreenManager'
import { PixelMapManager } from '../common/model/common/PixelMapManager'
import { StatusBarColorController } from '../common/model/common/StatusBarColorController'
import { MediaLibraryAccess } from '../common/access/MediaLibraryAccess'
import { TimelineDataSourceManager } from '../feature/timeline/model/TimelineDataSourceManager'
import { Constants } from '../common/model/common/Constants'
import { MediaDataSource } from '../common/model/browser/photo/MediaDataSource'
import { BroadCastManager } from '../common/model/common/BroadCastManager';
import { TraceControllerUtils } from '../common/utils/TraceControllerUtils';
import { BroadCastConstants } from '../common/model/common/BroadCastConstants'
import router from '@system.router'

const appLogger: Logger = new Logger('app');
let isFromCard = false;
let isFromCamera = false;
let appBroadCast = BroadCastManager.getInstance().getBroadCast();

export default class MainAbility extends Ability {
    private static readonly RETRY_MAX_TIMES = 100;
    private static readonly ACTION_URI_SINGLE_SELECT = 'singleselect';
    private static readonly ACTION_URI_MULTIPLE_SELECT = 'multipleselect';
    private static readonly ACTION_URI_PHOTO_DETAIL = 'photodetail';

    onCreate(want, launchParam) {
        appLogger.info('Application onCreate');
        TraceControllerUtils.startTrace('onCreate');
        // Ability is creating, initialize resources for this ability
        globalThis.photosAbilityContext = this.context;
        let action = want.parameters;
        if (action != null && action != undefined && action.uri == MainAbility.ACTION_URI_PHOTO_DETAIL) {
            isFromCamera = true;
            AppStorage.SetOrCreate(Constants.ENTRY_FROM_HAP, Constants.ENTRY_FROM_CAMERA);
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

        let requestPermissionList: Array<string> = [
            "ohos.permission.READ_MEDIA",
            "ohos.permission.WRITE_MEDIA",
            "ohos.permission.MEDIA_LOCATION",
            "ohos.permission.DISTRIBUTED_DATASYNC"
        ];
        TraceControllerUtils.startTrace('requestPermissionsFromUser');
        globalThis.photosAbilityContext.requestPermissionsFromUser(requestPermissionList).then(function (data) {
            appLogger.info(`requestPermissionsFromUser data:  ${JSON.stringify(data)}`)
            let result = 0
            for (let i = 0; i < data.authResults.length; i++) {
                result += data.authResults[i]
            }
            if (result >= 0) {
                // Improve cold startup performance. Initialize the timeline in advance
                AppStorage.SetOrCreate(Constants.PERMISSION_STATUS, true);
                TraceControllerUtils.finishTrace('requestPermissionsFromUser');
                MediaLibraryAccess.getInstance().onCreate(globalThis.photosAbilityContext)
                if (!isFromCard && !isFromCamera) {
                    TraceControllerUtils.finishTrace('onCreate');
                    TimelineDataSourceManager.getInstance();
                } else {
                    TraceControllerUtils.finishTrace('onCreate');
                }
            } else {
                AppStorage.SetOrCreate(Constants.PERMISSION_STATUS, false);
            }
        }, (err) => {
            appLogger.error(`Failed to requestPermissionsFromUser, ${err.code}`);
        });

        appBroadCast.on(BroadCastConstants.THIRD_ROUTE_PAGE, this.thirdRouterPage.bind(this));
        appLogger.info('Application onCreate end');
    }

    onNewWant(want) {
        TraceControllerUtils.startTrace('onNewWant');
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
        TraceControllerUtils.finishTrace('onNewWant');
    }

    onDestroy() {
        // Ability is creating, release resources for this ability
        appLogger.info('Application onDestroy');
        let pixelMapManager: PixelMapManager = PixelMapManager.getInstance();
        pixelMapManager.release();
        let statusBarColorController: StatusBarColorController = StatusBarColorController.getInstance();
        statusBarColorController.release();
        AppStorage.Delete(Constants.ENTRY_FROM_HAP);
        MediaLibraryAccess.getInstance().onDestroy();
    }

    onWindowStageCreate(windowStage) {
        TraceControllerUtils.startTrace('onWindowStageCreate');
        // Main window is created, set main page for this ability
        appLogger.info('Application onWindowStageCreate');
        globalThis.photosWindowStage = windowStage;
        ScreenManager.getInstance().on(ScreenManager.ON_LEFT_BLANK_CHANGED, data => {
            appLogger.info(`onleftBlankChanged: ${data}`);
            AppStorage.SetOrCreate(Constants.LEFT_BLANK, data);
        });
        ScreenManager.getInstance().on(ScreenManager.ON_SPLIT_MODE_CHANGED, mode => {
            appLogger.info(`onSplitModeChanged: ${JSON.stringify(mode)}`);
            AppStorage.SetOrCreate(Constants.IS_SPLIT_MODE, mode);
        });
        TraceControllerUtils.startTrace('getMainWindow');
        windowStage.getMainWindow().then((win) => {
            AppStorage.SetOrCreate(Constants.MAIN_WINDOW, win);
            TraceControllerUtils.finishTrace('getMainWindow');
            TraceControllerUtils.startTrace('initializationSize');
            ScreenManager.getInstance().initializationSize(win).then(() => {
                TraceControllerUtils.finishTrace('initializationSize');
                if (isFromCard) {
                    MediaLibraryAccess.getInstance().getPublicDirectory().then(() => {
                        let dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
                        dataSource.setAlbumId(AppStorage.Get(Constants.FROM_ALBUM_ID));
                        dataSource.initialize();
                        let times = 0;
                        //该场景是卡片跳转到大图指定图片，需要等大图数据获取完成再跳转，否则组件无法跳转。
                        let intervalId = setInterval(() => {
                            appLogger.info(`setInterval go`);
                            if (dataSource.getRawData(0) || times >= MainAbility.RETRY_MAX_TIMES) {
                                AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, dataSource);
                                windowStage.setUIContent(this.context, 'feature/browser/view/PhotoBrowser', null);
                                ScreenManager.getInstance().initWindowMode();
                                clearInterval(intervalId);
                            }
                            times++;
                        }, 50)
                    });
                } else {
                    windowStage.setUIContent(this.context, 'product/pad/view/index', null);
                    ScreenManager.getInstance().initWindowMode();
                }
                TraceControllerUtils.finishTrace('onWindowStageCreate');
            }).catch(() => {
                appLogger.error(`get device screen info failed.`);
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
        TraceControllerUtils.startTrace('thirdRouterPage');
        let entryFrom = AppStorage.Get(Constants.ENTRY_FROM_HAP);
        let permission = AppStorage.Get(Constants.PERMISSION_STATUS);
        appLogger.info(`thirdRouterPage entryFromHap: ${entryFrom} permission: ${permission}`);
        if (entryFrom == Constants.ENTRY_FROM_NONE || !permission) {
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
            let dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
            dataSource.setAlbumId(AppStorage.Get(Constants.FROM_ALBUM_ID));
            dataSource.initialize();
            let times = 0;
            //该场景是卡片跳转到大图指定图片，需要等大图数据获取完成再跳转，否则组件无法跳转。
            let intervalId = setInterval(() => {
                if (dataSource.getRawData(0) || times >= MainAbility.RETRY_MAX_TIMES) {
                    AppStorage.SetOrCreate(Constants.APP_KEY_PHOTO_BROWSER, dataSource);
                    let options = {
                        uri: 'feature/browser/view/PhotoBrowser',
                        params: {
                            pageFrom: Constants.ENTRY_FROM.CARD,
                            albumId: AppStorage.Get(Constants.FROM_ALBUM_ID),
                            position: AppStorage.Get(Constants.FROM_CURRENT_INDEX)
                        }
                    };
                    router.replace(options);
                    clearInterval(intervalId);
                }
                times++;
            }, 50)
        } else if (entryFrom == Constants.ENTRY_FROM_FORM_ABILITY_NONE) {
            let options = {
                uri: 'product/phone/view/index'
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
        }, 50);
        TraceControllerUtils.finishTrace('thirdRouterPage');
    }
}