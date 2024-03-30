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

import Ability from '@ohos.app.ability.UIAbility';
import wantConstant from '@ohos.ability.wantConstant';
import data_preferences from '@ohos.data.preferences';
import {
  AlbumDefine,
  BigDataConstants,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  Log,
  MediaDataSource,
  MediaObserver,
  ReportToBigDataUtil,
  ScreenManager,
  StatusBarColorController,
  UserFileManagerAccess
} from '@ohos/common';
import { TimelineDataSourceManager } from '@ohos/timeline';
import router from '@ohos.router';
import deviceInfo from '@ohos.deviceInfo';
import type Want from '@ohos.app.ability.Want';
import type window from '@ohos.window';
import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import common from '@ohos.app.ability.common';
import { SmartPickerUtils } from '@ohos/thirdselect/src/main/ets/default/utils/SmartPickerUtils';

const TAG: string = 'MainAbility';
let isFromCard = false;
let isFromCamera = false;
let mCallerBundleName: string = '';
let mMaxSelectCount: number = 0;
let mFilterMediaType: string = AlbumDefine.FILTER_MEDIA_TYPE_ALL;
let appBroadCast = BroadCastManager.getInstance().getBroadCast();
let isShowMenuFromThirdView: boolean;
let cameraAble: boolean = true;
let editAble: boolean = true;

export default class MainAbility extends Ability {
  private formCurrentUri: string = '';
  private formAlbumUri: string = '';
  private preselectedUris: Array<string> = [];
  private isOnDestroy: boolean = false;
  private localStorage: LocalStorage = new LocalStorage();

  onCreate(want: Want, param: AbilityConstant.LaunchParam): void {
    AppStorage.setOrCreate('photosAbilityContext', this.context);
    AppStorage.setOrCreate('formContext', this.context);
    this.isOnDestroy = false;
    this.initPhotosPref();

    this.parseWantParameter(false, want);

    UserFileManagerAccess.getInstance().onCreate(AppStorage.get<common.UIAbilityContext>('photosAbilityContext'));
    MediaObserver.getInstance().registerForAllPhotos();
    MediaObserver.getInstance().registerForAllAlbums();
    if (!isFromCard && !isFromCamera) {
      TimelineDataSourceManager.getInstance();
    }

    appBroadCast.on(BroadCastConstants.THIRD_ROUTE_PAGE, this.thirdRouterPage.bind(this));

    // Init system album information
    UserFileManagerAccess.getInstance().prepareSystemAlbums();
    Log.info(TAG, 'Application onCreate end');
  }

  onNewWant(want: Want): void {
    if (this.isOnDestroy) {
      Log.error(TAG, 'Application is already on isOnDestroy, do nothing in onNewWant');
      return;
    }
    this.parseWantParameter(true, want);
    this.thirdRouterPage();
    Log.info(TAG, 'Application onNewWant end');
  }

  parseWantParameter(isOnNewWant: boolean, want: Want): void {
    Log.info(TAG, `Application isOnNewWant=${isOnNewWant}, want=${JSON.stringify(want)}`);
    AppStorage.setOrCreate('placeholderIndex', -1);
    this.formCurrentUri = '';
    this.formAlbumUri = '';
    let wantParam: { [key: string]: Object } = want.parameters;
    let wantParamUri: string = wantParam?.uri as string;
    if (wantParamUri === Constants.WANT_PARAM_URI_DETAIL) {
      isFromCamera = true;
      if (isOnNewWant) {
        AppStorage.setOrCreate('entryFromHapCamera', Constants.ENTRY_FROM_CAMERA);
        AppStorage.get<window.WindowStage>('photosWindowStage').loadContent('pages/PhotoBrowser', (err, data) => {
          if (err.code) {
            Log.error(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
            return;
          }
          Log.info(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
      } else {
        AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_CAMERA);
      }
    } else if (wantParamUri === Constants.WANT_PARAM_URI_SELECT_SINGLE) {
      mCallerBundleName = wantParam[Constants.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string;

      // Max select count must be 1 in single select mode
      mMaxSelectCount = Constants.NUMBER_1;
      mFilterMediaType = wantParam?.filterMediaType as string;
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_SINGLE_SELECT);
      cameraAble = (wantParam?.isPhotoTakingSupported as boolean) ?? true;
      editAble = (wantParam?.isEditSupported as boolean) ?? true;
      SmartPickerUtils.initIfNeeded(this.context, want, this.localStorage);
    } else if (wantParamUri === Constants.WANT_PARAM_URI_SELECT_MULTIPLE) {
      mCallerBundleName = wantParam[Constants.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string;
      mMaxSelectCount = wantParam?.maxSelectCount as number;
      mFilterMediaType = wantParam?.filterMediaType as string;
      this.preselectedUris = wantParam?.preselectedUris as Array<string>;
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_MULTIPLE_SELECT);
      cameraAble = (wantParam?.isPhotoTakingSupported as boolean) ?? true;
      editAble = (wantParam?.isEditSupported as boolean) ?? true;
      SmartPickerUtils.initIfNeeded(this.context, want, this.localStorage);
    } else if (wantParamUri === Constants.WANT_PARAM_URI_FORM) {
      isFromCard = true;
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_FORM_ABILITY);
      AppStorage.setOrCreate('form_albumUri', wantParam?.albumUri);
      AppStorage.setOrCreate('form_currentUri', wantParam?.currentUri);
      AppStorage.setOrCreate('form_currentIndex', wantParam?.currentIndex);
      AppStorage.setOrCreate('form_displayName', wantParam?.displayName);
      this.formAlbumUri = wantParam?.albumUri as string;
      this.formCurrentUri = wantParam?.currentUri as string;
    } else if (wantParam?.formId) {
      AppStorage.setOrCreate('FASetting_FormId', wantParam.formId);
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_FORM_FORM_EDITOR);
    } else if (want.action === wantConstant.Action.ACTION_VIEW_DATA) {
      isShowMenuFromThirdView = wantParam.isShowMenu as boolean;
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_VIEW_DATA);
      if (want.uri) {
        AppStorage.setOrCreate('viewDataUri', want.uri);
      } else {
        AppStorage.setOrCreate('viewDataUri', wantParamUri);
      }
      if (wantParam?.albumUri) {
        AppStorage.setOrCreate('viewDataAlbumUri', wantParam.albumUri);
      } else {
        AppStorage.setOrCreate('viewDataAlbumUri', '');
      }
      if (wantParam?.viewIndex) {
        AppStorage.setOrCreate('viewDataIndex', wantParam.viewIndex);
      } else {
        AppStorage.setOrCreate('viewDataIndex', '');
      }
    } else if (wantParamUri === Constants.WANT_PARAM_URI_FORM_NONE) {
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_FORM_DEFAULT_ABILITY);
    } else {
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE);
    }
  }

  onDestroy(): void | Promise<void> {
    // Ability is creating, release resources for this ability
    Log.info(TAG, 'Application onDestroy');
    this.isOnDestroy = true;
    let statusBarColorController: StatusBarColorController = StatusBarColorController.getInstance();
    statusBarColorController.release();
    AppStorage.delete('entryFromHap');
    MediaObserver.getInstance().unregisterForAllPhotos();
    MediaObserver.getInstance().unregisterForAllAlbums();
    UserFileManagerAccess.getInstance().onDestroy();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Log.info(TAG, 'Application onWindowStageCreate');
    AppStorage.setOrCreate('photosWindowStage', windowStage);
    AppStorage.setOrCreate('deviceType',
    deviceInfo.deviceType == 'phone' || deviceInfo.deviceType == 'default' ? Constants.DEFAULT_DEVICE_TYPE : Constants.PAD_DEVICE_TYPE);
    ScreenManager.getInstance().on(ScreenManager.ON_LEFT_BLANK_CHANGED, data => {
      Log.info(TAG, `onleftBlankChanged: ${data}`);
      AppStorage.setOrCreate('leftBlank', data);
    });
    ScreenManager.getInstance().on(ScreenManager.ON_SPLIT_MODE_CHANGED, mode => {
      Log.info(TAG, `onSplitModeChanged: ${JSON.stringify(mode)}`);
      ReportToBigDataUtil.report(BigDataConstants.SPLIT_SCREEN_ID, null);
      AppStorage.setOrCreate('isSplitMode', mode);
    });
    Log.info(TAG, 'Application onCreate finish');
    windowStage.getMainWindow().then((win) => {
      AppStorage.setOrCreate('mainWindow', win);
      ScreenManager.getInstance().getAvoidArea();
      ScreenManager.getInstance().initializationSize(win).then(() => {
        ScreenManager.getInstance().initWindowMode();
        // @ts-ignore
        windowStage.setUIContent(this.context, 'pages/index', null);
      }).catch(() => {
        Log.error(TAG, `get device screen info failed.`);
      });
      windowStage.disableWindowDecor();
    });
  }

  onWindowStageDestroy(): void {
    ScreenManager.getInstance().destroyWindowMode();
  }

  onForeground(): void {
  }

  onBackground(): void {
  }

  async thirdRouterPage() {
    let entryFrom = AppStorage.Get('entryFromHap');
    Log.info(TAG, `thirdRouterPage entryFromHap: ${entryFrom}`);
    if (entryFrom == Constants.ENTRY_FROM_NONE) {
      return;
    }
    if (entryFrom == Constants.ENTRY_FROM_CAMERA) {
      let options = {
        url: 'pages/PhotoBrowser',
        params: {
          pageFrom: Constants.ENTRY_FROM.CAMERA
        }
      };
      router.replaceUrl(options);

    } else if (entryFrom == Constants.ENTRY_FROM_SINGLE_SELECT) {
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_ID, {
        'selectType': Constants.ENTRY_FROM_SINGLE_SELECT,
        'filterMediaType': mFilterMediaType,
        'maxSelectCount': mMaxSelectCount
      });
      let options = {
        url: 'pages/ThirdSelectPhotoGridPage',
        params: {
          bundleName: mCallerBundleName,
          isMultiPick: false,
          filterMediaType: mFilterMediaType,
          isFirstEnter: true,
          maxSelectCount: mMaxSelectCount,
          uri: '',
          cameraAble: cameraAble,
          editAble: editAble
        }
      };
      router.replaceUrl(options);
    } else if (entryFrom == Constants.ENTRY_FROM_MULTIPLE_SELECT) {
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_ID, {
        'selectType': Constants.ENTRY_FROM_MULTIPLE_SELECT,
        'filterMediaType': mFilterMediaType,
        'maxSelectCount': mMaxSelectCount
      });
      let options = {
        url: 'pages/ThirdSelectPhotoGridPage',
        params: {
          bundleName: mCallerBundleName,
          isMultiPick: true,
          filterMediaType: mFilterMediaType,
          isFirstEnter: true,
          maxSelectCount: mMaxSelectCount,
          preselectedUris: this.preselectedUris,
          uri: '',
          cameraAble: cameraAble,
          editAble: editAble,
        }
      };
      router.replaceUrl(options);
    } else if (entryFrom == Constants.ENTRY_FROM_FORM_ABILITY) {
      if (this.formCurrentUri.length > 0 && this.formAlbumUri.length > 0) {
        let options = {
          url: 'pages/PhotoBrowser',
          params: {
            pageFrom: Constants.ENTRY_FROM.CARD,
            albumUri: this.formAlbumUri,
            uri: this.formCurrentUri
          }
        };
        router.replaceUrl(options);
        let dataSource: MediaDataSource =
          new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
        dataSource.setAlbumUri(this.formAlbumUri);
        dataSource.initialize();
        AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, dataSource);
      } else {
        let dataSource: MediaDataSource =
          new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
        dataSource.setAlbumUri(this.formAlbumUri);
        dataSource.initialize();
        let times: number = 0;
        const COUNT_NUM: number = 100;
        const DELAY_TIME: number = 50;
        let intervalId = setInterval(() => {
          if (dataSource.getRawData(0) || times >= COUNT_NUM) {
            AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, dataSource);
            let options = {
              url: 'pages/PhotoBrowser',
              params: {
                pageFrom: Constants.ENTRY_FROM.CARD,
                albumId: AppStorage.get('form_albumUri'),
                uri: AppStorage.get('form_currentUri'),
                index: AppStorage.get('form_currentIndex')
              }
            };
            router.replaceUrl(options);
            clearInterval(intervalId);
          }
          times++;
        }, DELAY_TIME);
      }
    } else if (entryFrom == Constants.ENTRY_FROM_FORM_DEFAULT_ABILITY) {
      let options = {
        url: 'pages/DefaultPhotoPage'
      }
      router.replaceUrl(options);
    } else if (entryFrom == Constants.ENTRY_FROM_FORM_FORM_EDITOR) {
      let options = {
        url: 'pages/FormEditorPage'
      }
      router.replaceUrl(options);
    } else if (entryFrom == Constants.ENTRY_FROM_VIEW_DATA) {
      let options = {
        url: 'pages/PhotoBrowser',
        params: {
          pageFrom: Constants.ENTRY_FROM.VIEW_DATA,
          viewData: AppStorage.Get('viewDataUri'),
          viewDataAlbum: AppStorage.Get('viewDataAlbumUri'),
          viewDataIndex: AppStorage.Get('viewDataIndex'),
          isShowMenuFromThirdView: isShowMenuFromThirdView
        }
      };
      router.replaceUrl(options);
    }
    AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE)
  }

  private initPhotosPref(): void {
    Log.info(TAG, 'Application initPhotosPref start');
    data_preferences.getPreferences(AppStorage.get<common.UIAbilityContext>('photosAbilityContext'), Constants.PHOTOS_STORE_KEY)
      .then((pref: data_preferences.Preferences) => {
        pref.get(Constants.IS_FIRST_TIME_DELETE, true).then((data: boolean) => {
          AppStorage.setOrCreate<boolean>(Constants.IS_FIRST_TIME_DELETE, data);
        }).catch((err) => {
          Log.error(TAG, `Failed to get whether first time delete, err: ${err}`);
        });
        AppStorage.setOrCreate<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY, pref)
      })
      .catch((err) => {
        Log.error(TAG, 'Failed to get preferences.');
      });
  }
}