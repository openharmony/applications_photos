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
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Privacy } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { emitter } from '@kit.BasicServicesKit';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { HashMap } from '@kit.ArkTS';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';

/* instrument ignore file */
const TAG: string = 'PrivacyViewerFullScreen';

@Builder
export function PrivacyViewerFullScreenLoader() {
  PrivacyViewerFullScreen();
}

// interface PrivacyAgreement {
//   type: Privacy,
//   tag?: StandardTagPaf,
// }

@Component
export default struct PrivacyViewerFullScreen {
  private static readonly eventMap: HashMap<Privacy, string> = PrivacyViewerFullScreen.initEventMap();
  /**
   *在NavDestination中能够拿到传来的NavPathInfo和当前所处的NavPathStack
   */
  private navStack?: NavPathStack;
  @Prop isFullPage: boolean = false;
  // Bar高度数值
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  // @Provide('Paf.WebViewController') controller: PafWebViewController = new PafWebViewController();
  // private agreement: PrivacyAgreement =
  //   { type: DeviceInfo.isTv() ? Privacy.PRIVACY_PROTOCOL_TV :
  //     (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL) };
  private url?: string = undefined;
  // private pafSheetConfig: PafSheetConfig = new PafSheetConfig();
  // 浅层窗口背景颜色适配
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @State private sheetShowBackColor: string = Constants.SHEET_SHOW_BACK_COLOR_LIGHT;
  // @State src: PafPrivacyResource = new PafPrivacyResource();
  public isShowICPPage: boolean = false;
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  private navigationBroadCast: BroadCast = NavigationBroadCastManager.getInstance().getBroadCast();

  private static initEventMap(): HashMap<Privacy, string> {
    let map: HashMap<Privacy, string> = new HashMap<Privacy, string>();
    map.set(Privacy.AI_RETOUCH_TERMS, Constants.OPEN_AI_RETOUCH_DIALOG_EVENT_ID);
    map.set(Privacy.AI_RETOUCH_PRIVACY_PROTOCOL, Constants.OPEN_AI_RETOUCH_DIALOG_EVENT_ID);
    map.set(Privacy.CLOUD_ENHANCE_PRIVACY_PROTOCOL, Constants.OPEN_CE_PROTOCOL_DIALOG_EVENT_ID);
    map.set(Privacy.AI_WALLPAPER_PRIVACY_PROTOCOL, Constants.OPEN_AI_WALLPAPER_DIALOG_EVENT_ID);
    map.set(Privacy.AI_WALLPAPER_TERMS, Constants.OPEN_AI_WALLPAPER_DIALOG_EVENT_ID);
    return map;
  }

  private onColorModeChange() {
    Log.info(TAG, `currentMode is ${this.currentMode}`)
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.sheetShowBackColor = Constants.SHEET_SHOW_BACK_COLOR_LIGHT;
    } else {
      this.sheetShowBackColor = Constants.SHEET_SHOW_BACK_COLOR_DARK;
    }
  }

  handleOnBackPressed() {
    // Log.info(TAG, `handleOnBackPressed: type = ${this.agreement.type}`);
    // const eventId: string = PrivacyViewerFullScreen.eventMap.get(this.agreement.type);
    // if (eventId === undefined) {
    //   Log.error(TAG, 'handleOnBackPressed: Invalid type.');
    //   return;
    // }
    // // 读取数据
    // const isShowFromSettingPrivacyList: boolean =
    //   AppStorage.get<boolean>(Constants.IS_SHOW_FROM_SETTING_PRIVACY_LIST) ?? false;
    // if (isShowFromSettingPrivacyList) {
    //   Log.debug(TAG, 'handleOnBackPressed isShowFromSettingPrivacyList: true');
    //   return;
    // }
    //
    // let eventData: emitter.EventData = {};
    // emitter.emit(eventId, eventData);
  }

  public onBackPress(): boolean {
    this.handleOnBackPressed();
    this.navStack?.pop();
    Log.info(TAG, 'PafPrivacyStatement navigationEvent back');
    return true;
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    // this.pafSheetConfig.showClose(true);
    this.onColorModeChange();
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
  }

  @Builder
  backIconBuilder(pageInfos?: NavPathStack) {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      SymbolGlyph($r('sys.symbol.chevron_backward'))
        .draggable(false)
        .fontColor([$r('sys.color.icon_primary')])
        .fontSize($r('app.float.icon_size'))
    }
    .accessibilityText($r('app.string.action_back'))
    .height($r('app.float.action_bar_button_height'))
    .width($r('app.float.action_bar_button_height'))
    .borderRadius($r('sys.float.corner_radius_level4'))
    .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
    .onClick((): void => {
      pageInfos?.pop();
    })
    .margin({
      left: Constants.SHEET_CONFIG_LEFT_RIGHT_MARGIN,
      right: $r('app.float.extended_services_listcard_padding_left_and_right'),
    })
  }

  getForceDarkAccess(): boolean {
    const forceDarkAccess = this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    Log.info(TAG, `To page PafPrivacyStatementV2 forceDarkAccess is: ${forceDarkAccess}`);
    return forceDarkAccess;
  }
  build() {
    NavDestination() {
        // PafPrivacyStatementV2({
        //   src: this.src,
        //   option: {
        //     browserUrls: [], // browserUrls优先级高，如果设置了，会直接覆盖setDefaultExternBrowserUrls设置的全部默认值
        //     isSheetShow: true,
        //     isNav:false,
        //     forceDarkAccess: this.getForceDarkAccess(),
        //     navigationEvent: () => {
        //       Log.info(TAG, 'privacyViewFullScreen onBackPress');
        //       this.onBackPress();
        //       if(DeviceInfo.isPc()) {
        //         this.navigationBroadCast.emit('onShowDialog', []);
        //       }
        //     }
        //   },
        // })
      }
      .hideTitleBar(true)
      .backgroundColor(this.sheetShowBackColor)
      .onReady((ctx: NavDestinationContext): void => {
        if (!ctx.pathStack) {
          return;
        }
        this.navStack = ctx.pathStack;
        try {
          // let agreement: PrivacyAgreement | undefined = ctx.pathStack
          //   .getParamByName(NavigationConstants.NAVIGATION_PRIVACY_VIEWER)?.[0] as PrivacyAgreement | undefined;
          // Log.info(TAG, `PrivacyViewerFullScreen PrivacyAgreement: ${agreement?.type}: ${this.agreement?.tag}`);

          // if (agreement?.type) {
            // this.agreement.type = agreement.type;
            // this.agreement.tag = agreement.tag ?? StandardTagPaf.DEFAULT;
            // this.src.agrType = agreement.type;
            // this.src.contentTag = agreement.tag ?? StandardTagPaf.DEFAULT;
          // } else {
          //   // Log.error(TAG, `testTag onReady catch exception, PrivacyAgreement is ${Boolean(agreement)}`);
          // }
        } catch (err) {
          Log.error(TAG, `testTag onReady catch exception: ${err}`);
        }
        // Log.info(TAG, `PrivacyViewerFullScreen PrivacyAgreement: ${this.agreement?.type}: ${this.url}`);
      })
      .onBackPressed((): boolean => {
        this.onBackPress();
        return true;
      })
    .padding({
      top: DeviceInfo.isPc() ? Constants.PRIVACY_VIEW_FULLSCREEN_TOP_PC : this.isFullPage ?
      Constants.PRIVACY_VIEW_FULLSCREEN_TOP : Constants.PRIVACY_VIEW_NOT_FULLSCREEN_TOP,
      bottom: Constants.PRIVACY_VIEW_FULLSCREEN_BOTTOM
    })

  }

  @Builder
  public static privacyPage() {
    PrivacyViewerFullScreen();
  }
}

/**
 * paf全局路由栈注册
 */
export function initPrivacyViewPage() {
  // PafRouter.getPafRouter().registerDavDesOptions({
  //   navPageName: NavigationConstants.NAVIGATION_PRIVACY_VIEWER,
  //   pageTitle: '',
  //   customStyle: true,
  //   builder: PrivacyViewerFullScreen.privacyPage,
  // })
}