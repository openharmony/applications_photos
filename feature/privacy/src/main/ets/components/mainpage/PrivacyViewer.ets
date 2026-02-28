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
import lazy { emitter } from '@kit.BasicServicesKit';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { Privacy } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';

/* instrument ignore file */
const TAG: string = 'PrivacyViewer';

// export interface PrivacyAgreement {
//   type: Privacy,
//   tag?: StandardTagPaf,
// }

@Component
export default struct PrivacyViewer {
  @Prop isFullPage: boolean = false;
  // @Provide('Paf.WebViewController') controller: PafWebViewController = new PafWebViewController();
  // 浅层窗口背景颜色适配
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  // private agreement: PrivacyAgreement = { type: Privacy.PRIVACY_PROTOCOL };
  private url?: string = undefined;
  @State private sheetShowBackColor: string = Constants.SHEET_SHOW_BACK_COLOR_LIGHT;
  isSheetShow?: boolean = false;
  public isShowICPPage: boolean = false;
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  // @State src: PafPrivacyResource = new PafPrivacyResource();

  @Builder
  public static privacyPage() {
    PrivacyViewer();
  }

  handleOnBackPressed() {
    // if (this.agreement.type === Privacy.AI_RETOUCH_TERMS ||
    //   this.agreement.type === Privacy.AI_RETOUCH_PRIVACY_PROTOCOL) {
    //   let eventData: emitter.EventData = {};
    //   const eventId: string = Constants.OPEN_AI_RETOUCH_DIALOG_EVENT_ID;
    //   emitter.emit(eventId, eventData);
    // } else if (this.agreement.type === Privacy.CLOUD_ENHANCE_PRIVACY_PROTOCOL) {
    //   let eventData: emitter.EventData = {};
    //   const eventId: string = Constants.OPEN_CE_PROTOCOL_DIALOG_EVENT_ID;
    //   emitter.emit(eventId, eventData);
    // }
  }

  onBackPress(): boolean {
    global.exitUiExtSession();
    Log.info(TAG, 'PafPrivacyStatement navigationEvent back');
    return true;
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.onColorModeChange();
    // this.src.agrType = this.agreement.type;
  }

  build() {
    // PafPrivacyStatementV2({
    //   src: this.src,
    //   option:{
    //     navigationEvent:()=>{
    //       Log.info(TAG, 'privacyViewer onBackPress');
    //       this.onBackPress()
    //     },
    //     browserUrls:[getContext().resourceManager.getStringSync($r('app.string.externBrowserUrl'))]
    //   }
    //
    // })
  }

  private onColorModeChange() {
    Log.info(TAG, `currentMode is ${this.currentMode}`)
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.sheetShowBackColor = Constants.SHEET_SHOW_BACK_COLOR_LIGHT;
    } else {
      this.sheetShowBackColor = Constants.SHEET_SHOW_BACK_COLOR_DARK;
    }
  }
}