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
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy common from '@ohos.app.ability.common';
import lazy settings from '@ohos.settings';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

/* instrument ignore file */
const TAG: string = 'AnalysisServiceToggle';
const COMMON_DELAY: number = 500;

/**
 * AnalysisServiceToggle
 */
@Component
export default struct AnalysisServiceToggle {
  // 广播
  @Link private broadcast: BroadCast;
  @State private isMediaAnalysisServiceOn: boolean = false;
  private isManually: boolean = false;
  @Link private headTitle: Resource | undefined;
  @Link private subTitle: Resource | string;
  @Link private confirmText: Resource | undefined;
  private accessibilityEventFlag: boolean = false;
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  private closeMediaAnalysisServiceSwitchFunc: Function = ():
    void => this.closeMediaAnalysisServiceSwitch();
  // 记录当前系统放大倍率模式
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') currentFontSizeScale: number = 1;
  @State private listPaddingTopAndBottom: Resource = DeviceInfo.isPc() ?
  $r('sys.float.padding_level5') : $r('sys.float.padding_level6');

  private currentFontSizeScaleChange(): void {
    if (this.currentFontSizeScale === Constants.FONT_SCALE_HEAVY_SIZE) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level12');
    } else if (this.currentFontSizeScale === Constants.FONT_SCALE_STRONG_SIZE) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level10');
    } else if (this.currentFontSizeScale === Constants.FONT_SCALE_LARGE_SIZE) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level8');
    } else {
      this.listPaddingTopAndBottom = DeviceInfo.isPc() ?
      $r('sys.float.padding_level5') : $r('sys.float.padding_level6');
    }
  }

  aboutToAppear(): void {
    Log.info(TAG, 'AnalysisServiceToggle');
    this.currentFontSizeScaleChange();
    this.initMediaAnalysisTogle();
    this.updateFlagStatus();
    getContext()?.eventHub.on(BroadCastConstants.CLOSE_MEDIA_ANALYSIS_SERVICE,
      this.closeMediaAnalysisServiceSwitchFunc);
  }

  aboutToDisappear(): void {
    getContext()?.eventHub.off(BroadCastConstants.CLOSE_MEDIA_ANALYSIS_SERVICE,
      this.closeMediaAnalysisServiceSwitchFunc);
  }

  private closeMediaAnalysisServiceSwitch(): void {
    // 更新媒体智慧分析服务开关状态
    this.initMediaAnalysisTogle();
  }

  private initMediaAnalysisTogle(): void {
    let context: common.UIAbilityContext = global.uiAbilityContext();
    let value = settings.getValueSync(context, 'analysis_service_switch_on', '0');
    Log.info(TAG, `get VISIONT_SWITCH.value=${value}`);
    this.isMediaAnalysisServiceOn = value === '1';
    Log.info(TAG, `get VISIONT_SWITCH.switch=${this.isMediaAnalysisServiceOn}`);
  }

  private setMediaParameter(value: string): void {
    Log.info(TAG, `get media_analysis_service.switch=${value}`);
    let context: common.UIAbilityContext = global.uiAbilityContext();
    try {
      let ret = settings.setValueSync(context, 'analysis_service_switch_on', value);
      Log.info(TAG, `set VISIONT_SWITCH.ret=${ret}`);
    } catch (error) {
      Log.error(TAG,
        `settings setValueSync error msg: ${error?.msg}, code: ${error?.code}`);
    }
  }

  private cancelAnalysisServiceSwtich(status: boolean): void {
    this.isMediaAnalysisServiceOn = !status;
    this.updateFlagStatus();
    this.broadcast.emit(BroadCastConstants.CLOSE_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG, []);
  }

  private isMediaAnalysisServiceChange(isToggleOn: boolean): void {
    Log.info(TAG, `toggle status is =${isToggleOn}`);
    if (!isToggleOn) {
      this.confirmText = $r('app.string.end_of_service');
      this.headTitle = $r('app.string.end_of_service');
      this.subTitle = $r('app.string.end_of_media_analysis_service_note');
      this.broadcast.emit(BroadCastConstants.SHOW_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG,
        [(): void => this.cancelAnalysisServiceSwtich(isToggleOn), (): void => this.setMediaParameter('0')]);
    } else {
      this.confirmText = $r('app.string.dialog_consent');
      this.headTitle = $r('app.string.media_analysis_service');
      this.subTitle = $r('app.string.start_of_media_analysis_service_note');
      this.broadcast.emit(BroadCastConstants.SHOW_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG,
        [(): void => this.cancelAnalysisServiceSwtich(isToggleOn), (): void => this.setMediaParameter('1')]);
    }
  }

  @Builder
  switchMediaToggle() {
    Row() {
      Toggle({ type: ToggleType.Switch, isOn: $$this.isMediaAnalysisServiceOn })
        .key('switchMediaToggle')
        .hoverEffect(HoverEffect.None)
        .selectedColor($r('sys.color.comp_background_emphasize'))
        .onTouch((event: TouchEvent): void => {
          this.isManually = true;
        })
        .onChange((isToggleOn: boolean) => {
          Log.info(TAG, `, isManually: ${this.isManually}, isOn: ${isToggleOn}, accessibilityEventFlag: ${
          this.accessibilityEventFlag}`);
          if (this.isOpenTouchGuide) {
            if (this.accessibilityEventFlag) {
              return;
            }
          } else {
            // 未完成之前禁止再次点击
            if (!this.isManually) {
              return;
            }
            this.isManually = false;
          }

          this.isMediaAnalysisServiceChange(isToggleOn);
        })
        .margin({
          top: 0,
          bottom: 0,
        })
    }
    .align(Alignment.End)
  }

  @Builder
  analysisServiceListCard() {
    Column() {
      Text($r('app.string.media_intelligence_analysis'))
        .draggable(false)
        .constraintSize({ minHeight: $r('app.float.account_name_height') })
        .maxFontScale(3.2)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_primary'))
        .fontFamily('HarmonyHeiTi')
        .width('100%')
        .key('AccountUserName')
        .padding({
          top: DeviceInfo.isPc() ? 0 : Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
          bottom: DeviceInfo.isPc() ? 0 : Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
        })
    }
    .margin({
      top: this.listPaddingTopAndBottom,
      bottom: this.listPaddingTopAndBottom,
      right: $r('sys.float.ohos_id_text_margin_horizontal'),
    })
    .flexGrow(1)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Start,
    }) {
      this.analysisServiceListCard();

      Row() {
        this.switchMediaToggle();
      }
    }
    .key('ExpandedServiceCard')
  }

  private updateFlagStatus(): void {
    this.accessibilityEventFlag = true;
    const timer = setTimeout((): void => {
      this.accessibilityEventFlag = false;
      clearTimeout(timer);
    }, COMMON_DELAY);
  }
}