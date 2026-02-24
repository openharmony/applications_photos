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
import lazy { CustomDialogView } from '@ohos/common/src/main/ets/default/view/dialog/CustomDialogView';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy SettingCard from './SettingCard';
import lazy common from '@ohos.app.ability.common';
import lazy { BusinessError } from '@ohos.base';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { settingsPageStatusReport } from '@ohos/common/src/main/ets/default/utils/StatisticReportUtil';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { SystemPropertiesManager } from '@ohos/common/src/main/ets/default/utils/SystemPropertiesManager';
import lazy { AccountVar } from '../access/NetworkConnectionAccess';
import lazy { Privacy } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Navigate } from '../nav/Navigate';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { initStatementsPage } from '../components/extendedService/StatementsCards';
import lazy { initServiceAgreementsCards } from '../components/extendedService/ServiceAgreementsCards';
import lazy { initExtendedServicePage, IsAgreeAiRetouchProtocol } from '../components/extendedService/ExtendedServicesPage';
import lazy { initPrivacyViewPage } from '../components/mainpage/PrivacyViewerFullScreen';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { AccountRepository } from '../about/consent/AccountRepository';
import lazy { PermissionPopup } from '../about/consent/PermissionPopup';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { display, LengthMetrics, promptAction, SymbolGlyphModifier } from '@kit.ArkUI';
import lazy { GallerySettingsActionBar } from './GallerySettingsActionBar';
import lazy { emitter } from '@kit.BasicServicesKit';
import lazy { sim } from '@kit.TelephonyKit';
import lazy { i18n } from '@kit.LocalizationKit';
import type { HighlightAnalyzedProcess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy {
  SlideShowInterval,
  SlideShowIntervalController
} from '@ohos/common/src/main/ets/default/model/common/SlideShowIntervalController';
import lazy AnalysisServiceToggle from '../components/extendedService/AnalysisServiceToggle';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';

/* instrument ignore file */
const TAG: string = 'common_Settings';
const NETWORK_STATUS_ON: string = 'on';
const NETWORK_STATUS_OFF: string = 'off';
const changeAiRetouchProtocolEventId: string = Constants.CHANGE_AI_RETOUCH_PROTOCOL_EVENT_ID;

const LARGE_SIZE_FONT: number = 1.75;
const STRONG_SIZE_FONT: number = 2;
const HEAVY_SIZE_FONT: number = 3.2;
const COMMON_DELAY: number = 500;
const ACCESSIBILITY_FOCUS_DELAY: number = 350;
const OPEN_CLOUD_SYNC_DELAY: number = 500;

/**
 * 配置项开关，通过以下命令开启，冷启动图库生效
 * hdc shell param set persist.photos.photos_rotate_type.enabled true
 */
const PERSIST_PHOTOS_ROTATE_TYPE: string = 'persist.photos.photos_rotate_type.enabled';

@Builder
export function GallerySettingsBasePageLoader() {
  GallerySettingsBasePage();
}

@Component
export struct GallerySettingsBasePage {
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @State networkButtonStatus: boolean = false;
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') networkAvailable: boolean = false;
  @Provide broadCast: BroadCast = new BroadCast();
  @State isToggleOn: boolean = false;
  @State isNetworkConnectionToggleOn: boolean = false;
  private isNetworkToggleEnable: boolean = false;
  private isNetworkManually: boolean = false;
  private isWatermarkToggleEnable: boolean = false;
  private isWatermarkManually: boolean = false;
  @State isWatermarkToggleOn: boolean = true;
  private isWatermarkEnable: boolean = true;
  private watermarkTitle: string = 'addWatermarkAfterEnhanceText';
  private slideShowIntervalTitle: string = 'slideShowIntervalText';
  @State isUnlimitedUseOfMobileNetworkToggleOn: boolean = false;
  private isToggleEnable: boolean = false;
  private isManually: boolean = false;
  @Provide headTitle: Resource | undefined = undefined;
  @Provide subTitle: Resource | undefined = undefined;
  @Provide confirmText: Resource | undefined = undefined;
  // 新增优化空间弹窗
  @Provide opStorageTitle: Resource | undefined = undefined;
  @Provide opStorageContent: Resource | undefined = undefined;
  @Provide opStorageConfirmText: Resource | undefined = undefined;
  @Provide noOpStorageContent: Resource | undefined = undefined;
  @Provide noOpStorageConfirmText: Resource | undefined = undefined;
  // 删除弹窗动效
  @Provide opLoadingTotalSize: number = 0;
  @Provide opLoadingCurrentSize: number = 0;
  // 账号登录信息
  @StorageLink('isLogIn') isLogIn: boolean = false;
  @StorageLink('userName') userName: string = '';
  @StorageLink('localAvatarUri') localAvatarUri: string = '';
  @Provide moreMenuList: Action[] = [];
  @Provide hidePopup: boolean = false;
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  @StorageLink('numFlag') numFlag: number = 1;
  @StorageLink('networkConnectionStatus') @Watch('updateIsNetworkConnectionToggleOn')
  public networkConnectionStatus: boolean = false;
  @StorageLink('unlimitedUseOfMobileNetwork') @Watch('watchUnlimitedNetworkStatus') localUnlimitedNetworkStatus:
    boolean = false;
  @StorageLink('spaceReleaseStatus') @Watch('watchSpaceReleaseStatus') localSpaceReleaseStatus: boolean = false;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onIsFoldExpandedChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  // 记录当前系统放大倍率模式
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') currentFontSizeScale: number = 1;
  @State private listPaddingTopAndBottom: Resource = DeviceInfo.isPc() ?
    $r('sys.float.padding_level5') : $r('sys.float.padding_level6');
  @State private buttonPaddingTopAndBottom: Resource = DeviceInfo.isPc() ?
    $r('sys.float.padding_level4') : $r('sys.float.padding_level5');
  @State private listPaddingBottomWithHover: Resource = $r('sys.float.padding_level6');
  @State itemWrap: FlexWrap = FlexWrap.NoWrap;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('digging_hole_camera_area') private diggingHoleCameraArea:
    DiggingHoleCameraArea = getScreen().getDiggingHoleCameraArea();
  @State private actionBarPaddingTop: number = 0;
  private readonly onAreaHeightChangedFunc: Function = (data: number): void => {
    if (!DeviceInfo.isPcOrTablet()) {
      this.actionBarPaddingTop = this.getUIContext()?.px2vp(data) ?? data;
    }
  };
  private borderRadiusRounded: Resource =
      DeviceInfo.isPc() ? $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10');
  private buttonBorderRadiusRounded: Resource =
      DeviceInfo.isPc() ? $r('sys.float.corner_radius_level6') : $r('sys.float.corner_radius_level8');
  private borderRadiusInner: Resource =
      DeviceInfo.isPc() ? $r('sys.float.corner_radius_level6') : $r('sys.float.corner_radius_level8');
  private PC_LIST_CARD_MARGIN_TOP: number = 16;
  private gallerySettingsListCardWidthReduceLength: number = 8;
  private scroller: Scroller = new Scroller();
  @Provide isAiRetouchProtocolFlag: boolean = false;
  private userInfo: PermissionPopup.UserInfo = {
    userId: '',
    accessToken: '',
  };
  // 适配浅层窗口
  // @State private pafSheetConfig: PafSheetConfig = new PafSheetConfig();
  @State private highlightAnalysisProgress: string = '0%';
  @State private highlightAnalysisSettingProgress: number = 0;
  private navStack: NavPathStack = new NavPathStack();
  private accessibilityEventNetworkFlag: boolean = false;
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  @State private updateAlign: VerticalAlign = VerticalAlign.Center;
  @State private processHeight: number = 0;
  private readonly onPageShowFunc: Function = (msg: string): void => this.onPageShowInner();
  private readonly onPageHideFunc: Function = (msg: string): void => this.onPageHideInner();
  @State private highlightAnalyzedTotalCount: number = 0;
  private isOptimizing: boolean = false;
  // 记录当前的页面深度
  private curPageStackDepth: number = 0;
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  @State isRTL: boolean = false;
  @State symbolCheck: SymbolGlyphModifier =
    new SymbolGlyphModifier($r('sys.symbol.checkmark'))
      .fontColor(this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ?
        [Color.Black] : [$r('sys.color.icon_primary')]);
  private symbolUncheck: SymbolGlyphModifier =
    new SymbolGlyphModifier($r('sys.symbol.checkmark')).fontColor([Color.Transparent]);
  @State isShowSlideShowMenu: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private onCeProtocolChange: Function = () => this.onCeProtocolChangeFunc();
  @State isCeProtocolEnable: boolean = false;
  @State autoAICloudEnhancePressed: boolean = false;
  @State slideShowIntervalPressed: boolean = false;
  @State slideShowInterval: number = 3;
  @State networkTitle: Resource =  $r('app.string.enable_gallery_network_connection');
  private scrollToComponentId?: string;
  private checkFunctions: (() => boolean)[] = [
    this.canShowSlideShowCard.bind(this),
  ];
  private isPageOnShow: boolean = false;
  private toggleStatus = true;
  private isShowOptimizeDialog = false;
  @State isShowPhotosRotateMenu: boolean = false;
  @State photosRotatePressed: boolean = false;
  private PhotosRotateTitle: string = 'PhotosRotateTitle';
  // 切换到前台时是否需要显示优化空间对话框,再次点击之前需要设置为true
  private isNeedShowOptimizeDialog = true;

  private async getAccountInfo(forceRefresh: boolean, cb?: Function): Promise<void> {
    // Log.info(TAG, 'getAccountInfo called');
    // AccountRepository.getInstance().setAccountContext(getContext(this));
    // try {
    //   await AccountRepository.getInstance().signIn(true);
    //   Log.info(TAG, 'getAccountInfo call signIn finish');
    //   this.userInfo.accessToken = await AccountRepository.getInstance().getAccessToken(forceRefresh);
    //   Log.info(TAG, 'getAccountInfo call getAccessToken finish');
    //   this.userInfo.userId = AccountRepository.getInstance().getAccount().userId;
    //   this.getSignedRes();
    //   cb?.();
    // } catch (err) {
    //   Log.error(TAG, `getAccountInfo failed: code: ${err?.code}, data: ${err?.data}, subCode: ${err?.subCode}`);
    // }
  }

  private onColorModeChange(): void {
    this.symbolCheck =
      new SymbolGlyphModifier($r('sys.symbol.checkmark'))
        .fontColor(this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ?
          [Color.Black] : [$r('sys.color.icon_primary')]);
  }

  private async getSignedRes(): Promise<void> {
    this.isAiRetouchProtocolFlag =
      await PermissionPopup.queryAgreementRecord(getContext(this), this.userInfo, Privacy.AI_RETOUCH_PRIVACY_PROTOCOL);
    Log.info(TAG, `getSignedRes res: ${this.isAiRetouchProtocolFlag}`);
  }

  /**
   * 获取时刻分析进度
   */
  private async getHighLightAnalysisProgress(): Promise<void> {
    if (Constants.IS_SHOW_HIGHLIGHT_ANALYSIS_PROGRESS) {
      let highlightAnalyzed: HighlightAnalyzedProcess =
        await UserFileManagerAccess.getInstance().getHighLightAnalysisData();
      this.highlightAnalysisProgress = highlightAnalyzed.highlightProcessPct;
      this.highlightAnalysisSettingProgress = highlightAnalyzed.highlightProcess;
      this.highlightAnalyzedTotalCount = highlightAnalyzed.totalCount;
      getContext().eventHub.emit(BroadCastConstants.HIGHLIGHT_PROGRESS_REFRESH, []);
    }
  }

  aboutToAppear(): void {
    this.getHighLightAnalysisProgress();
    this.currentFontSizeScaleChange();
    ReportToBigDataUtil.report(BigDataConstants.ENTER_SETTINGS_PAGE);
    AccountVar.isNeedSilentSignOnNetChange = true;
    this.updateIsToggleOn();
    this.updateIsNetworkConnectionToggleOn();
    this.initSlideShowInterval();
    // 浅层窗口相关
    // this.pafSheetConfig
    //   .showClose(true)
    //   .setPafSheetController(new PafSheetController())
    //   .setIsNavType(true)
    // 全局路由栈注册
    this.initRegister();
    this.updateFlagStatus();
    if (!DeviceInfo.isPc()) {
      if (this.isLogIn) {
        this.getAccountInfo(false, () => {
          // 获取AI编创隐私协议最新签署状态
          PermissionPopup.queryAgreementRecordCloud(getContext(this), this.userInfo,
            Privacy.AI_RETOUCH_PRIVACY_PROTOCOL);
        });
      }
      emitter.on(changeAiRetouchProtocolEventId, (data) => {
        this.isAiRetouchProtocolFlag = data.data?.agree ?? this.isAiRetouchProtocolFlag;
      });
    }

    this.curPageStackDepth = this.navStack.size();

    /* 用户关闭隐私协议后，会联动修改自动云增强的开关状态，需要更新界面 */
    this.appBroadCast.on(Constants.CHANGE_CE_PROTOCOL_EVENT_ID, this.onCeProtocolChange);
    this.getUIContext().getHostContext()?.eventHub.on(BroadCastConstants.ON_PAGE_SHOW, this.onPageShowFunc);
    this.getUIContext().getHostContext()?.eventHub.on(BroadCastConstants.ON_PAGE_HIDE, this.onPageHideFunc);
    this.onLanguageChange();

    this.scrollToComponentId = this.navigationPageInfos
      .getParamByName(NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS)[0] as string;

    Log.info(TAG, `Get scrollToId=${this.scrollToComponentId}`);
    this.isPageOnShow = true;
    
    // 初始化ActionBar的padding top，动态适配状态栏高度
    if (!DeviceInfo.isPcOrTablet()) {
      this.actionBarPaddingTop = this.getUIContext()?.px2vp(this.statusBarHeight) ?? this.statusBarHeight;
    } else {
      this.actionBarPaddingTop = 0;
    }
    getScreen().on(ScreenManager.ON_AREA_HEIGHT_CHANGED, this.onAreaHeightChangedFunc);
    Log.info(TAG, `action bar padding top: ${this.actionBarPaddingTop}`);
  }

  private initSlideShowInterval(): void {
    this.slideShowInterval = SlideShowIntervalController.getSlideShowIntervalSettings(getContext(this));
  }

  private canShowSlideShowCard(): boolean {
    Log.info(TAG, `canShowSlideShowCard: ` + DeviceInfo.isPhoneUx());
    return DeviceInfo.isPhoneUx();
  }

  private calulateAutoEnhanceIndex(): number {
    return this.checkFunctions.filter(func => func()).length;
  }

  private onPageShowInner(): void {
    this.getHighLightAnalysisProgress();
    this.isPageOnShow = true;
    this.isNeedShowOptimizeDialog = false;
  }

  private onPageHideInner(): void {
    this.isPageOnShow = false;
  }

  private initRegister() {
    initExtendedServicePage();
    initPrivacyViewPage();
    initStatementsPage();
    initServiceAgreementsCards();
  }

  aboutToDisappear(): void {
    Log.info(TAG, `GallerySettingsBasePage aboutToDisappear`)
    // 页面销毁的时候关闭弹框
    this.appBroadCast.emit(BroadCastConstants.SETTING_MULTIPLE_CLICKS, []);
    this.broadCast.emit(BroadCastConstants.CLOSE_NETWORK_CONNECTION_SWITCH_DIALOG, []);
    if (!DeviceInfo.isPc()) {
      emitter.off(changeAiRetouchProtocolEventId);
    }
    emitter.off(Constants.OPEN_CE_PROTOCOL_DIALOG_EVENT_ID);
    this.appBroadCast.off(Constants.CHANGE_CE_PROTOCOL_EVENT_ID, this.onCeProtocolChange);
    getContext().eventHub.emit(BroadCastConstants.HIGHLIGHT_PROGRESS_REFRESH, []);
    this.getUIContext().getHostContext()?.eventHub.off(BroadCastConstants.ON_PAGE_SHOW, this.onPageShowFunc);
    this.getUIContext().getHostContext()?.eventHub.off(BroadCastConstants.ON_PAGE_HIDE, this.onPageHideFunc);
    this.isPageOnShow = false;
    getScreen().off(ScreenManager.ON_AREA_HEIGHT_CHANGED, this.onAreaHeightChangedFunc);
  }

  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
  }

  private setItemWrap(wrap: boolean) {
    if (wrap) {
      this.itemWrap = FlexWrap.Wrap;
    } else {
      this.itemWrap = FlexWrap.NoWrap;
    }
  }

  private currentFontSizeScaleChange(): void {
    if (this.currentFontSizeScale === HEAVY_SIZE_FONT) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level12');
      this.buttonPaddingTopAndBottom = $r('sys.float.padding_level11');
      this.listPaddingBottomWithHover = $r('sys.float.padding_level10');
      this.setItemWrap(true);
    } else if (this.currentFontSizeScale === STRONG_SIZE_FONT) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level10');
      this.buttonPaddingTopAndBottom = $r('sys.float.padding_level9')
      this.listPaddingBottomWithHover = $r('sys.float.padding_level8');
      this.setItemWrap(true);
    } else if (this.currentFontSizeScale === LARGE_SIZE_FONT) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level8');
      this.buttonPaddingTopAndBottom = $r('sys.float.padding_level7')
      this.listPaddingBottomWithHover = $r('sys.float.padding_level6');
      this.setItemWrap(true);
    } else {
      this.listPaddingTopAndBottom = DeviceInfo.isPc() ?
        $r('sys.float.padding_level5') : $r('sys.float.padding_level6');
      this.buttonPaddingTopAndBottom = DeviceInfo.isPc() ?
        $r('sys.float.padding_level4') : $r('sys.float.padding_level5');
      this.listPaddingBottomWithHover = $r('sys.float.padding_level4');
      this.setItemWrap(false);
    }

    if (this.currentFontSizeScale >= LARGE_SIZE_FONT) {
      this.updateAlign = VerticalAlign.Top;
    } else {
      this.updateAlign = VerticalAlign.Center;
    }
    Log.info(TAG,
      `this.listPaddingTopAndBottom: ${getContext().resourceManager.getNumber(this.listPaddingTopAndBottom)}`);
  }

  updateIsToggleOn(): void {
    this.isManually = false;
  }

  onCeProtocolChangeFunc(): void {
  }

  updateIsNetworkConnectionToggleOn(): void {
    Log.info(TAG, `updateIsNetworkConnectionToggleOn networkConnectionStatus: ${this.networkConnectionStatus}`);
    this.isNetworkManually = false;
    this.broadCast.emit(BroadCastConstants.CLOSE_NETWORK_CONNECTION_SWITCH_DIALOG, []);
    this.isNetworkConnectionToggleOn = this.networkConnectionStatus;
  }

  watchUnlimitedNetworkStatus(): void {
    const isFromDS = AppStorage.get<boolean>('unlimitedStatusChangeIsFromDS');
    const status = this.localUnlimitedNetworkStatus;
    Log.info(TAG, `[Cloud Status] unlimited status watch start, isFromDS: ${isFromDS}, status: ${status}`);

    if (isFromDS) {
      AppStorage.setOrCreate<boolean>('unlimitedStatusChangeIsFromDS', false);
    }
  }

  watchSpaceReleaseStatus(): void {
    const isFromDS = AppStorage.get<boolean>('releaseStatusChangeIsFromDS');
    const status = this.localSpaceReleaseStatus;
    Log.info(TAG, `[Cloud Status] release status watch start, isFromDS: ${isFromDS}, status: ${status}`);

    if (isFromDS) {
      AppStorage.setOrCreate<boolean>('releaseStatusChangeIsFromDS', false);
    }
  }

  private onIsFoldExpandedChanged(): void {
    if (!DeviceInfo.isVerdeFoldable()) {
      return;
    }
    this.navigationPageInfos.pop();
    Log.info(TAG, 'navigationPageInfos pop');
  }

  private setSlideShowIntervalOption(interval: number): void {
    Log.info(TAG, 'setSlideShowIntervalOption, refresh');
    this.slideShowInterval = interval;
    SlideShowIntervalController.setSlideShowIntervalSettings(getContext(this), interval);
  }

  private showNetworkConnectionDialog(onNetworkConfirmCb?: Function): void {
    Log.info(TAG, '[CloudEnhance] showCloudEnhanceNetworkSwitchDialog');
    this.broadCast.emit(BroadCastConstants.SHOW_CLOUD_ENHANCE_NETWORK_SWITCH_DIALOG,
      [(): void => this.switchOnNetworkConnectionConfirmCallback(onNetworkConfirmCb),
        (): void => this.broadCast.emit(BroadCastConstants.CLOSE_CLOUD_ENHANCE_NETWORK_SWITCH_DIALOG, [])]);
  }

  private onExpandedServiceClick(): void {
    const isAgree: IsAgreeAiRetouchProtocol = {
      agree: this.isAiRetouchProtocolFlag,
    }
    NavigationBroadCastManager.getInstance()
      .targetName = NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS;
    // PafRouter.getPafRouter()
    //   .pushPath(true, NavigationConstants.NAVIGATION_DESTINATION_EXTENDED_SERVICES, isAgree);
  }

  @Builder
  buildSymbolIcon() {
    Row() {
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .draggable(false)
        .fontSize($r('app.float.ic_gallery_form_arrow'))
        .fontColor([$r('sys.color.icon_fourth')])
    }
    .align(Alignment.End)
  }

  @Builder
  buildArrowDownIcon() {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Stack() {
        SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
          .draggable(false)
          .fontSize($r('app.float.ic_gallery_spinner_arrow'))
          .fontColor([$r('sys.color.icon_primary')])
      }
      .align(Alignment.Center)
      .width(24)
      .height(24)
    } else {
      Row() {
        SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
          .draggable(false)
          .fontSize($r('app.float.ic_gallery_spinner_arrow'))
          .fontColor([$r('sys.color.icon_fourth')])
      }
      .align(Alignment.End)
    }
  }

  @Builder
  buildMenuSelectIcon() {
    Row() {
      SymbolGlyph($r('sys.symbol.checkmark'))
        .draggable(false)
        .fontColor(this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ?
          [Color.Black] : [$r('sys.color.icon_primary')])
    }
    .align(Alignment.End)
  }

  @Builder
  userBar() {
    Column() {
      if (!this.isLogIn) {
        Text('')
          .draggable(false)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize($r('sys.float.Body_L'))
          .constraintSize({ minHeight: $r('app.float.account_enable_cloud_text_height') })
          .maxFontScale(3.2)
          .margin({
            bottom: $r('app.float.account_login_text_margin_bottom'),
          })
          .width('100%')
          .key('LogInPrimaryText')

        Text($r('app.string.enable_hicloud_gallery'))
          .draggable(false)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_secondary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize($r('sys.float.Body_M'))
          .constraintSize({ minHeight: $r('app.float.account_enable_cloud_text_height') })
          .maxFontScale(3.2)
          .width('100%')
          .key('LogInSecondaryText')
      } else {
        Text(this.userName)
          .draggable(false)
          .textAlign(UiUtil.isMirrorMode() ? TextAlign.End : TextAlign.Start)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize($r('sys.float.Body_L'))
          .constraintSize({ minHeight: $r(Constants.PERCENT_100) })
          .maxFontScale(3.2)
          .width('100%')
          .key('AccountUserName')
      }
    }
    .margin({
      right: $r('sys.float.padding_level4'),
    })
    .flexGrow(1)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)

    this.buildSymbolIcon()
  }

  private onLanguageChange(): void {
    if (this.currentLanguage) {
      this.isRTL = i18n.isRTL(this.currentLanguage);
      Log.info(TAG, `LanguageChange : ${this.currentLanguage} , change isRTL : ${this.isRTL}`);
    }
  }

  @Builder
  OptimizeStorageBuilder() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Start,
    }) {
      Column() {
        Text($r('app.string.optimize_device_storage'))
          .draggable(false)
          .constraintSize({ minHeight: $r('app.float.account_name_height') })
          .maxFontScale(3.2)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .fontFamily('HarmonyHeiTi')
          .width('100%')
          .padding({
            top: DeviceInfo.isPc() ? 0 : Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
            bottom: DeviceInfo.isPc() ? 0 : Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
          })
          .margin({
            bottom: Constants.DOUBLE_TEXT_MID_PADDING,
          })

        Text() {
          Span($r('app.string.optimize_device_storage_detail_new'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_secondary'))
            .fontFamily('HarmonyHeiTi')
            .fontSize(14)
        }
        .maxFontScale(3.2)
        .draggable(false)
        .width('100%')
      }
      .margin({
        top: this.listPaddingTopAndBottom,
        bottom: this.listPaddingTopAndBottom,
        right: $r('sys.float.ohos_id_text_margin_horizontal'),
      })
      .flexGrow(1)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .layoutWeight(1)

      Stack() {
        Checkbox()
          .key(`OptimizeStrorage`)
          .accessibilityLevel('no')
          .margin(0)
          .hitTestBehavior(HitTestMode.None)
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .opacity(1)
          .border({ radius: $r('app.float.checkbox_border_radius') })
          .borderColor($r('sys.color.font_primary'))
          .height($r('app.float.picker_checkbox_height'))
          .width($r('app.float.picker_checkbox_width'))
      }
      .alignRules({
        right: { anchor: '__container__', align: HorizontalAlign.End },
        center: { anchor: '__container__', align: VerticalAlign.Center },
      })
      .margin(0)
      .height(Constants.DOUBLE_TEXT_CHECK_BOX_HEIGHT)
      .width(Constants.DOUBLE_TEXT_CHECK_BOX_HEIGHT)
      .id('row3')
      .onClick((): void => {
        this.isNeedShowOptimizeDialog = true;
        Log.info(TAG, `onClick OptimizeStrorage:isNeedShowOptimizeDialog=${this.isNeedShowOptimizeDialog}`);
      })
    }
  }

  @Builder
  buildOptimizeStorageColumn() {
    ListItem(){
      this.OptimizeStorageBuilder()
    }
    .padding({
      left: $r('app.float.extended_services_listcard_padding_left_and_right'),
      right: $r('app.float.extended_services_listcard_padding_left_and_right'),
    })
  }

  @Builder
  KeepLocalStorageBuilder() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Start,
    }) {
      Column() {
        Text($r('app.string.keep_original_storage'))
          .draggable(false)
          .constraintSize({ minHeight: $r('app.float.account_name_height') })
          .maxFontScale(3.2)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .fontFamily('HarmonyHeiTi')
          .width('100%')
          .margin({
            bottom: Constants.DOUBLE_TEXT_MID_PADDING,
          })

        Text($r('app.string.no_optimize_device_storage_detail'))
          .maxFontScale(3.2)
          .draggable(false)
          .width('100%')
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_secondary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize(14)
      }
      .margin({
        top: this.listPaddingTopAndBottom,
        bottom: this.listPaddingTopAndBottom,
        right: $r('sys.float.ohos_id_text_margin_horizontal'),
      })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .layoutWeight(1)

      Stack() {
        Checkbox()
          .key(`KeepLocalStorage`)
          .accessibilityLevel('no')
          .margin(0)
          .hitTestBehavior(HitTestMode.None)
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .opacity(1)
          .border({ radius: $r('app.float.checkbox_border_radius') })
          .borderColor($r('sys.color.font_primary'))
          .height($r('app.float.picker_checkbox_height'))
          .width($r('app.float.picker_checkbox_width'))
      }
      .alignRules({
        right: { anchor: '__container__', align: HorizontalAlign.End },
        center: { anchor: '__container__', align: VerticalAlign.Center },
      })
      .height(Constants.DOUBLE_TEXT_CHECK_BOX_HEIGHT)
      .width(Constants.DOUBLE_TEXT_CHECK_BOX_HEIGHT)
      .id('row3')
    }
  }

  @Builder
  buildKeepLocalStorageColumn() {
    ListItem(){
      this.KeepLocalStorageBuilder()
    }
    .padding({
      left: $r('app.float.extended_services_listcard_padding_left_and_right'),
      right: $r('app.float.extended_services_listcard_padding_left_and_right'),
    })
  }

  @Builder
  ImmediatelyOptimizeBuilder() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Start,
    }) {
      Column() {
        Text() {
          Span($r('app.string.optimize_storage_title'))
            .fontColor($r('sys.color.font_emphasize'))
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
        }
        .maxFontScale(3.2)
        .draggable(false)
        .constraintSize({ minHeight: $r('app.float.account_name_height') })
        .padding({
          top: DeviceInfo.isPc() ? 0 : Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
          bottom: DeviceInfo.isPc() ? 0 : Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
        })
        .margin({
          top: this.buttonPaddingTopAndBottom,
          bottom: this.buttonPaddingTopAndBottom,
        })
      }
      .margin({
        right: $r('sys.float.ohos_id_text_margin_horizontal'),
      })
      .flexGrow(1)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .onClick(async (): Promise<void> => {
        Log.info(TAG,
          `onClick pageStatus: ${this.isPageOnShow} toggleStatus :${this.toggleStatus} isShowOptimizeDialog :${this.isShowOptimizeDialog}`);
        if (!this.isPageOnShow || !this.toggleStatus || this.isShowOptimizeDialog) {
          return;
        }
      })
    }
    .padding({
      left: $r('app.float.immediately_release_listcard_padding_left'),
      right: $r('app.float.immediately_release_listcard_padding_left'),
    })
    .listItemStyle()
    .borderRadius(this.buttonBorderRadiusRounded)
  }

  @Builder
  buildImmediatelyOptimizeColumn() {
    ListItem(){
      this.ImmediatelyOptimizeBuilder()
    }
  }

  /**
   * 将byte大小转换为kB,MB,GB,小数点显示1位
   *
   * @param fileSize 文件大小
   * @returns 转换单位后的文件大小
   */
  private formatFileSize(fileSize: number): string {
    if (fileSize === 0) {
      return '0 kB';
    }
    const units = ['BYTE', 'kB', 'MB', 'GB'];
    const index = Math.floor(Math.log(fileSize) / Math.log(Constants.CONVERSION_UNIT));
    return `${(fileSize / Math.pow(Constants.CONVERSION_UNIT, index)).toFixed(1)} ${units[index]}`;
  }

  @Builder
  networkConnectionToggle() {
    Row() {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        Toggle({ type: ToggleType.Switch, isOn: $$this.isNetworkConnectionToggleOn })
          .key('NetworkConnectionToggle')
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .onTouch((): void => {
            this.isNetworkToggleEnable = true;
            this.isNetworkManually = true;
          })
          .onChange((isNetworkConnectionToggleOn: boolean) => {
            this.networkConnectionToggleOnChange(isNetworkConnectionToggleOn);
          })
          .margin({
            top: 0,
            bottom: 0,
          })
      } else {
        Toggle({ type: ToggleType.Switch, isOn: $$this.isNetworkConnectionToggleOn })
          .key('NetworkConnectionToggle')
          .hoverEffect(HoverEffect.None)
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .onTouch((): void => {
            this.isNetworkToggleEnable = true;
            this.isNetworkManually = true;
          })
          .onChange((isNetworkConnectionToggleOn: boolean) => {
            this.onNetworkToggleChange(isNetworkConnectionToggleOn);
          })
          .margin({
            top: 0,
            bottom: 0,
          })
      }
    }
    .align(Alignment.End)
  }

  private onNetworkToggleChange(isNetworkConnectionToggleOn: boolean): void {
    if (this.isOpenTouchGuide) {
      if (this.accessibilityEventNetworkFlag) {
        return;
      }
      this.networkToggleOnChangeInScreenReaderMode(isNetworkConnectionToggleOn);
    } else {
      this.networkConnectionToggleOnChange(isNetworkConnectionToggleOn);
    }
  }

  networkConnectionToggleOnChange(isNetworkConnectionToggleOn: boolean): void {
    Log.info(TAG, `this.isNetworkConnectionToggleOn: ${this.isNetworkConnectionToggleOn}`)
    if (this.isNetworkToggleEnable) {
      this.isNetworkToggleEnable = false;
      if (this.isNetworkManually) {
        this.isNetworkManually = false;
        this.emitNetworkSwitchCallback(isNetworkConnectionToggleOn);
      }
    }
    this.reportNetworkSwitchEvent(isNetworkConnectionToggleOn);
  }

  networkToggleOnChangeInScreenReaderMode(isNetworkConnectionToggleOn: boolean): void {
    Log.info(TAG, `network OnChange, screen reader mode, toggle status: ${this.isNetworkConnectionToggleOn}`)
    this.emitNetworkSwitchCallback(isNetworkConnectionToggleOn);
    this.reportNetworkSwitchEvent(isNetworkConnectionToggleOn);
  }

  private emitNetworkSwitchCallback(isNetworkConnectionToggleOn: boolean): void {
    if (isNetworkConnectionToggleOn) {
      this.switchOnNetworkConnectionConfirmCallback();
    } else {
      this.confirmText = $r('app.string.disable');
      this.headTitle = $r('app.string.close_network_link_title');
      this.subTitle = $r('app.string.close_network_dialog_content');
      this.broadCast.emit(BroadCastConstants.SHOW_NETWORK_CONNECTION_SWITCH_DIALOG,
        [(): void => this.cancelNetworkConnectionCallback(isNetworkConnectionToggleOn),
          (): void => this.ShutdownNetworkConnectionConfirmCallback()]);
    }
  }

  private reportNetworkSwitchEvent(isNetworkConnectionToggleOn: boolean): void {

    interface Msg {
      networkConnectionToggleStatus: boolean;
    }

    let msg: Msg = {
      networkConnectionToggleStatus: isNetworkConnectionToggleOn,
    };

    ReportToBigDataUtil.report(BigDataConstants.NETWORK_CONNECTION_TOGGLE_ID, msg);
    ReportToBigDataUtil.report(BigDataConstants.NETWORK_CONNECTION_SWITCH, {
      'status': `${isNetworkConnectionToggleOn ? 'open' : 'close'} in galleryNetworkToggle`
    });
  }

  private cancelNetworkConnectionCallback(status: boolean): void {
    Log.info(TAG, `cancle status: ${status}`)
    this.isNetworkToggleEnable = true;
    this.isNetworkConnectionToggleOn = !status;
    this.updateFlagStatus();
    this.broadCast.emit(BroadCastConstants.CLOSE_NETWORK_CONNECTION_SWITCH_DIALOG, []);
    if (this.isOpenTouchGuide) {
      AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_TOGGLE_NETWORK_CONN,
        ACCESSIBILITY_FOCUS_DELAY);
    }
  }

  private switchOnNetworkConnectionConfirmCallback(onNetworkConfirmCb?: Function): void {
  }

  private ShutdownNetworkConnectionConfirmCallback(): void {
  }

  @Builder
  unlimitedUseOfMobileNetworkToggle() {
    Row() {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        Toggle({ type: ToggleType.Switch, isOn: $$this.localUnlimitedNetworkStatus })
          .key('unlimitedUseOfMobileNetworkToggleToggle')
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .onChange((isToggleOn: boolean) => {
            this.unlimitedUseOfMobileNetworkToggleOnChange(isToggleOn);
          })
          .margin({
            top: 0,
            bottom: 0,
          })
      } else {
        Toggle({ type: ToggleType.Switch, isOn: $$this.localUnlimitedNetworkStatus })
          .key('unlimitedUseOfMobileNetworkToggleToggle')
          .hoverEffect(HoverEffect.None)
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .onChange((isToggleOn: boolean) => {
            this.unlimitedUseOfMobileNetworkToggleOnChange(isToggleOn);
          })
          .margin({
            top: 0,
            bottom: 0,
          })
      }
    }
    .align(Alignment.End)
  }

  unlimitedUseOfMobileNetworkToggleOnChange(isToggleOn: boolean): void {
    Log.info(TAG, `[Cloud Status] release toggle onChange start, isOn: ${isToggleOn}`);

    interface Msg {
      mobileNetworkToggleStatus: boolean;
    }

    let msg: Msg = {
      mobileNetworkToggleStatus: isToggleOn,
    }
    ReportToBigDataUtil.report(BigDataConstants.MOBILE_NETWORK_TOGGLE_ID, msg);
  }

  @Builder
  expandedServiceCardInBuilder() {
    Column() {
      Text($r('app.string.extended_services'))
        .draggable(false)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.JUSTIFY)
        .maxFontScale(3.2)
        .width('100%')
    }
    .justifyContent(FlexAlign.End)
    .alignItems(HorizontalAlign.Start)
    .margin({
      top: DeviceInfo.isPc() ? $r('sys.float.padding_level8') : $r('sys.float.padding_level16'),
      bottom: Constants.LEARN_HOW_TO_USE_DATA_BOTTOM_PADDING,
    })
    .padding({
      left: $r('app.float.pc_settings_auxiliary_text_margin'),
      right: $r('app.float.pc_settings_auxiliary_text_margin'),
    })
    .width(Constants.PERCENT_100)
  }

  @Builder
  extendedServiceListItem() {
    ListItem({}) {
      AnalysisServiceToggle({
        broadcast: this.broadCast,
        headTitle: $headTitle,
        subTitle: $subTitle,
        confirmText: $confirmText,
      });
    }
    .padding({
      left: $r('app.float.extended_services_listcard_padding_left_and_right'),
      right: $r('app.float.extended_services_listcard_padding_left_and_right'),
    })
  }

  @Builder
  BusinessCardBuilder() {
    Column() {
      Text($r('app.string.learn_how_to_use_your_data'))
        .draggable(false)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.JUSTIFY)
        .maxFontScale(3.2)
        .width('100%')
    }
    .justifyContent(FlexAlign.End)
    .alignItems(HorizontalAlign.Start)
    .margin({
      top: DeviceInfo.isPc() ? $r('sys.float.padding_level8') : $r('sys.float.padding_level16'),
      bottom: Constants.LEARN_HOW_TO_USE_DATA_BOTTOM_PADDING,
    })
    .padding({
      left: $r('app.float.pc_settings_auxiliary_text_margin'),
      right: $r('app.float.pc_settings_auxiliary_text_margin'),
    })
    .width(Constants.PERCENT_100)
  }

  // @Builder
  // buildPrivacyList(title: Resource, agreement: PrivacyAgreement) {
  //   ListItem({}) {
  //     SettingCard({ title: title });
  //   }
  //   .listItemStyle()
  //   .padding({
  //     left: $r('app.float.extended_services_listcard_padding_left_and_right'),
  //     right: $r('app.float.extended_services_listcard_padding_left_and_right'),
  //   })
  //   .borderRadius(this.borderRadiusInner)
  //   .onClick(Navigate.emitProtocol(this.navStack, agreement))
  //   // 修复扩展服务遮挡
  //   .constraintSize({ minHeight: Constants.LIST_HEIGHT_PC })
  //   .hoverEffect(HoverEffect.Highlight)
  // }

  @Styles
  listItemStyle() {
    .stateStyles({
      focused: {
        .borderWidth(2.5)
        .borderColor($r('sys.color.ohos_id_color_focused_outline'))
      },
      pressed: {
        .backgroundColor($r('sys.color.interactive_click'))
      },
      selected: {
        .backgroundColor($r('sys.color.comp_background_emphasize'))
      },
      normal: {
        .backgroundColor(undefined)
        .borderWidth(2.5)
        .borderColor(Color.Transparent)
      }
    })
  }

  @Builder
  SlideShowCardBuilder() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceBetween,
      wrap: this.itemWrap,
    }) {
      Column() {
        Text($r('app.string.slide_show_setting'))
          .draggable(false)
          .constraintSize({ minHeight: $r('app.float.account_name_height') })
          .maxFontScale(3.2)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .fontFamily('HarmonyHeiTi')
          .key(this.slideShowIntervalTitle)
          .padding({
            top: Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
            bottom: Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
          })
      }
      .margin({
        end: LengthMetrics.vp(16),
      })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      Row() {
        Text($r('app.plural.slide_show_setting_interval', this.slideShowInterval, this.slideShowInterval))
          .draggable(false)
          .textAlign(this.itemWrap === FlexWrap.Wrap ? TextAlign.Start : TextAlign.End)
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_secondary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize($r('sys.float.Body_M'))
          .constraintSize({ minHeight: $r('app.float.account_enable_cloud_text_height') })
          .maxFontScale(3.2)
          .key('SlideShowIntervalOption')
          .layoutWeight(this.itemWrap === FlexWrap.Wrap ? 1 : 0)
          .margin(DeviceInfo.isPc() ? undefined : { end: LengthMetrics.vp(8) })
        this.buildArrowDownIcon()
      }
      .justifyContent(FlexAlign.End)
      .hoverEffect(HoverEffect.Highlight)
      .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level10'))
      .backgroundColor(this.slideShowIntervalPressed ?
        $r('sys.color.ohos_id_color_click_effect') : Color.Transparent)
      .padding(DeviceInfo.isPc() ? {
        left: 8,
        right: 2,
        top: 2,
        bottom: 2,
      } : {
        left: 8,
        right: 8,
        top: 4,
        bottom: 4,
      })
      .margin({
        start: LengthMetrics.vp(this.itemWrap === FlexWrap.Wrap ? -8 : 0), // 2行显示时，为了和标题对齐
        top: LengthMetrics.vp(this.itemWrap === FlexWrap.Wrap ? -2 : 0) // 2行显示时，为了保持和标题文本的距离为2vp
      })
      .constraintSize({ minHeight: 28 })
      .bindMenu(this.isShowSlideShowMenu, this.buildSlideShowIntervalMenu, { showInSubWindow: !DeviceInfo.isPc() })
      .onTouch((event: TouchEvent) => {
        if (event.type === 0) {
          this.slideShowIntervalPressed = true;
        } else if (event.type === 1) {
          this.slideShowIntervalPressed = false;
        }
      })
    }
    .key(this.slideShowIntervalTitle)
  }

  @Builder
  buildSlideShowCardColumn() {
    ListItem(){
      this.SlideShowCardBuilder()
    }
    .accessibilityRole(AccessibilityRoleType.SELECT)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .onClick(() => {
      this.isShowSlideShowMenu = true;
    })
    .align(Alignment.Center)
    .constraintSize({ minHeight: 56 })
    .borderRadius(this.borderRadiusRounded)
    .margin({
      left: Constants.SHEET_CONFIG_LEFT_RIGHT_MARGIN,
      right: Constants.SHEET_CONFIG_LEFT_RIGHT_MARGIN,
      bottom: Constants.STATEMENT_CARDS_BOTTOM_PADDING,
    })
    .padding({
      left: $r('app.float.settings_listcard_padding_left_and_right'),
      right: $r('app.float.settings_listcard_padding_left_and_right'),
      top: this.listPaddingTopAndBottom,
      // 在显示为上下2行的时候，因为下拉框hover效果需要有4vp的空间，所以需要调整下部padding的值
      bottom: (this.itemWrap === FlexWrap.Wrap) ? this.listPaddingBottomWithHover : this.listPaddingTopAndBottom,
    })
  }

  @Builder
  buildSlideShowIntervalMenu() {
    Menu() {
      MenuItem({
        symbolEndIcon: this.slideShowInterval === SlideShowInterval.THREE ? this.symbolCheck : this.symbolUncheck,
        content: $r('app.plural.slide_show_setting_interval', SlideShowInterval.THREE, SlideShowInterval.THREE),
      })
        .margin(DeviceInfo.isPc() ? {
          bottom: 2,
        } : undefined)
        .onClick(() => this.setSlideShowIntervalOption(SlideShowInterval.THREE))

      MenuItem({
        symbolEndIcon: this.slideShowInterval === SlideShowInterval.FIVE ? this.symbolCheck : this.symbolUncheck,
        content: $r('app.plural.slide_show_setting_interval', SlideShowInterval.FIVE, SlideShowInterval.FIVE),
      })
        .margin(DeviceInfo.isPc() ? {
          bottom: 2,
        } : undefined)
        .onClick(() => this.setSlideShowIntervalOption(SlideShowInterval.FIVE))

      MenuItem({
        symbolEndIcon: this.slideShowInterval === SlideShowInterval.TEN ? this.symbolCheck : this.symbolUncheck,
        content: $r('app.plural.slide_show_setting_interval', SlideShowInterval.TEN, SlideShowInterval.TEN),
      })
        .margin(DeviceInfo.isPc() ? {
          bottom: 2,
        } : undefined)
        .onClick(() => this.setSlideShowIntervalOption(SlideShowInterval.TEN))

      MenuItem({
        symbolEndIcon: this.slideShowInterval === SlideShowInterval.FIFTEEN ? this.symbolCheck : this.symbolUncheck,
        content: $r('app.plural.slide_show_setting_interval', SlideShowInterval.FIFTEEN, SlideShowInterval.FIFTEEN),
      })
        .onClick(() => this.setSlideShowIntervalOption(SlideShowInterval.FIFTEEN))
    }
    .width(DeviceInfo.isPc() ? 224 : undefined)
    .menuItemDivider(DeviceInfo.isPc() ? undefined : {
      strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
      color: $r('sys.color.comp_divider'),
      startMargin: LengthMetrics.vp(Constants.MENU_ITEM_START_PADDING),
      endMargin: LengthMetrics.vp(Constants.MENU_ITEM_START_PADDING),
    })
    .onDisAppear(() => {
      Log.debug(TAG, `onDisappear`);
      // 需要置为false，否则无法重新弹出
      this.isShowSlideShowMenu = false;
    })
    .radius($r('sys.float.corner_radius_level10'))
    .borderRadius($r('sys.float.corner_radius_level10'))
    .key('SlideShowInterval_Menu')
  }

  /**
   * 浅层窗口不提供宽度，转为左右margin控制组件宽度
   */
  @Styles
  buildSheetShowMargin() {
    .margin({
      left: Constants.SHEET_CONFIG_LEFT_RIGHT_MARGIN,
      right: Constants.SHEET_CONFIG_LEFT_RIGHT_MARGIN,
    })
  }

  @Builder
  buildSettingPage() {
    Row() {
      Scroll(this.scroller) {
        Column() {
          List({ scroller: this.scroller }) {
            // 幻灯片播放间隔
            if (this.canShowSlideShowCard()) {
              this.buildSlideShowCardColumn()
            }
          }
          .alignListItem(ListItemAlign.Center)
          .scrollBar(BarState.Auto)
          .width('100%')
          .height('100%')
          .backToTop(true)

          // 弹框界面
          CustomDialogView({ broadCast: $broadCast, navigationPageInfos: this.navStack })
        }
        .width('100%')
        .height('100%')
      }
      .edgeEffect(EdgeEffect.Spring)
      .onAppear(() => {
        if (this.scrollToComponentId) {
          if (Constants.UI_COMP_KEY_AUTO_ENHANCE_ID !== this.scrollToComponentId) {
            return;
          }
          let srollIndex: number = this.calulateAutoEnhanceIndex();
          Log.info(TAG, `scroll to index=${srollIndex}`);

          this.scroller.scrollToIndex(srollIndex, true, ScrollAlign.CENTER);
          this.scrollToComponentId = undefined;
        }
      })
    }
  }

  private updateFlagStatus(): void {
    this.accessibilityEventNetworkFlag = true;
    const timer = setTimeout((): void => {
      this.accessibilityEventNetworkFlag = false;
      clearTimeout(timer);
    }, COMMON_DELAY);
  }

  @Builder
  buildSettingsActionBar() {
    GallerySettingsActionBar({
      title: $r('app.string.gallery_settings'),
      isNavDestinationPageActionBar: true,
    })
  }

  build() {
    NavDestination() {
      this.buildSettingPage()
    }
    .title(this.buildSettingsActionBar)
    .onBackPressed((): boolean => {
      Log.info(TAG, 'GallerySettingsBasePage onBackPressed');
      this.navigationPageInfos.pop();
      return true;
    })
    .padding({
      top: this.actionBarPaddingTop,
    })
  }
}
