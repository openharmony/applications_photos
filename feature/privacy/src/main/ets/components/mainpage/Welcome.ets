/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { Routers } from '@ohos/tools/src/main/global/pages/Routers';
import lazy systemParam from '@ohos.systemparameter';
import lazy I18n from '@ohos.i18n';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { AgreementConfig } from '../../about/AgreementConfig';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy PrivacyViewerFullScreen from './PrivacyViewerFullScreen';
import lazy { Privacy, Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { Navigate } from '../../nav/Navigate';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy data_preferences from '@ohos.data.preferences';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';

/* instrument ignore file */
const TAG = 'Welcome';

interface DeclareDemo {
  format: string | Resource;
}

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

@Entry
@Component
export struct Welcome {
  private navStack: NavPathStack = new NavPathStack();
  // 欢迎页外部套用
  private customNavPathStack: NavPathStack = new NavPathStack()
  // private pafSheetConfig: PafSheetConfig = new PafSheetConfig();
  @StorageProp('Paf.Language') @Watch('getDeclare') private _: string = I18n.System.getSystemLanguage();
  // @State declares: PafPermissionDeclare = {
  //   text: [],
  // };
  private isSheetShow: boolean = true;
  @Builder
  permissionPage() {
    PrivacyViewerFullScreen({
      // agreement: {
      //   type: DeviceInfo.isTv() ? Privacy.PRIVACY_PROTOCOL_TV :
      //     (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL)
      // },
      // pafSheetConfig: this.pafSheetConfig, // 栈信息传入
    })
  }
  aboutToAppear(): void {
    Log.info(TAG, 'click privacy_statement event aboutToAppear');
    // PafRouter.getPafRouter().registerDavDesOptions({
    //   navPageName: NavigationConstants.NAVIGATION_PRIVACY_VIEWER,
    //   pageTitle: '',
    //   customStyle: true,
    //   builder: this.permissionPage.bind(this),
    // })
    this.getDeclare();
    // this.pafSheetConfig
    //   .showClose(true) // 默认参数，全屏为false
    // Log.info(TAG, 'paf permission');

    Routers.escapeWelcomePageEnterUserGuide();

  }

  private getDeclare() {
    // this.declares.text = [
    //   new PafPermissionDeclareText().formatDeclare(DeviceInfo.isTv() ?
    //   $r('app.string.welcome_prompt1_tv') : $r('app.string.welcome_prompt1'), [
    //     new PafPermissionDeclareSpan($r('app.string.on_network')),
    //     new PafPermissionDeclareSpan((DeviceInfo.isTv() ?
    //     $r('app.string.pictures_and_videos_tv') : $r('app.string.pictures_and_videos'))),
    //   ]),
    //   new PafPermissionDeclareText().formatDeclare($r('app.string.welcome_prompt2'), [
    //     new PafPermissionDeclareSpan($r('app.string.privacy_statement'),
    //       PermissionSpanType.PRIVACY_HYPERLINK, () => {
    //         PafRouter.getPafRouter()
    //           .pushPath(true, NavigationConstants.NAVIGATION_PRIVACY_VIEWER, {
    //             type: DeviceInfo.isTv() ? Privacy.PRIVACY_PROTOCOL_TV :
    //               (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL)
    //           })
    //       }),
    //     new PafPermissionDeclareSpan(($r('app.string.gallery_right_access_statement')),
    //       PermissionSpanType.PERMISSION_DESC)
    //   ]),
    // ];
  }

  @Builder
  PageMap(name: string, param: object) {
    if (name === NavigationConstants.NAVIGATION_PRIVACY_VIEWER) {
      // PrivacyViewerFullScreen({
      //   agreement: { type: DeviceInfo.isTv() ? Privacy.PRIVACY_PROTOCOL_TV :
      //     (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL) },
      // })
    }
    if (name === NavigationConstants.NAVIGATION_PERMISSION_PAGE) {
      this.payloadBuilder();
    }
  }

  onBackPress(): boolean | void {
    cancel(TAG, 'onBackPress');
  }

  @Builder
  payloadBuilder() {
  }

  build() {
    // if (true) {
      // PafPermissionV2({
      //   appResource: {
      //     appImg: $r('app.media.img_gallery_icon'),
      //     appName: $r('app.string.app_name'),
      //     appDesc: $r('app.string.help_you_remind_memory_and_classify'),
      //   },
      //   declare: this.declares,
      //   permissionDlg: {
      //     title: $r('app.string.gallery_right_access_statement'),
      //     desc: $r('app.string.gallery_service_description'),
      //     items: [new PafPermissionItem($r('app.string.pictures_and_videos'), $r('app.string.photo_and_video_desc'))]
      //   },
      //   event: {
      //     onConfirm: () => {
      //       Log.info(TAG, 'PafPermission comfirm');
      //       confirm();
      //     },
      //     onCancel: () => {
      //       AgreementConfig.setAgreed(false);
      //       cancel(TAG, 'PafPermission cancel');
      //       Log.info(TAG, 'PafPermission cancel');
      //     },
      //   }
      // })
    }
  // }


}

let cancel = global.terminateSelf;

function confirm(): void {
  Log.info(TAG, 'confirm start');

  try {
    AgreementConfig.setAgreed(true);
    appBroadCast.emit(BroadCastConstants.COMMON_ABILITY_DATA_INIT, []);
    appBroadCast.emit(BroadCastConstants.COMMON_ABILITY_RESTORE_FA_CARD, []);
    systemParam.setSync('persist.multimedia.media_analysis_service.switch', '1');
  } catch (err) {
    Log.error(TAG, `set media_analysis_service.switch fail: ${err}`);
  }
  let isAccessUserGuide: boolean = true;
  if (!DeviceInfo.isPc() && !DeviceInfo.isTv()) {
    let isGuideTmp: boolean = Protocol.get<boolean>(Constants.USER_GUIDE, false);
    if (!isGuideTmp) {
      isGuideTmp = assert.asDefault(
        AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.getSync(Constants.USER_GUIDE,
          false), false, TAG);
      Protocol.set(Constants.USER_GUIDE, isGuideTmp);
      AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.putSync(Constants.USER_GUIDE, false);
      AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.flush();
    }
    isAccessUserGuide = assert.asDefault(isGuideTmp, false, TAG);
    Log.info(TAG, `Application processContentPath isAccessUserGuide === ${isAccessUserGuide}`);
  }
  if (!DeviceInfo.isPc() && !DeviceInfo.isTv() && !isAccessUserGuide) {
    Routers.escapeWelcomePageEnterUserGuide();
  } else {
    Routers.escapeWelcomePage();
  }
  Log.info(TAG, 'confirm done');
}