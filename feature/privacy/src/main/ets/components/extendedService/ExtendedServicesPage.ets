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
import lazy { ExtendedServicesActionBar } from './ExtendedServicesActionBar';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { ColumnsWidth } from '@ohos/common/src/main/ets/default/model/common/ColumnsWidth';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy AnalysisServiceToggle from './AnalysisServiceToggle';
import lazy { Navigate } from '../../nav/Navigate';
import lazy { CustomDialogView } from '@ohos/common/src/main/ets/default/view/dialog/CustomDialogView';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';

/* instrument ignore file */
const TAG: string = 'ExtendedServices';
const DIVIDER_MARGIN: number = 12;

@Builder
export function ExtendedServicesPageLoader() {
  ExtendedServicesPage();
}

export interface IsAgreeAiRetouchProtocol {
  agree: boolean;
}

@Component
export struct ExtendedServicesPage {
  @StorageLink('statusBarHeight') private statusBarHeight: number = 0;
  // 是否处于垂直状态
  @StorageLink('isHorizontal') private isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink('digging_hole_camera_area') private diggingHoleCameraArea:
    DiggingHoleCameraArea = getScreen().getDiggingHoleCameraArea();
  @StorageProp(Constants.IS_SUPPORT_CLOUD_ENHANCE) isSupportCloudEnhance: boolean = false;
  @Provide private broadcast: BroadCast = new BroadCast();
  @Consume('navigationPageInfos') private navigationPageInfos: NavPathStack;
  @Provide({ allowOverride: 'headTitle' }) public headTitle: Resource | undefined = undefined;
  @Provide({ allowOverride: 'subTitle' }) subTitle: Resource | string = '';
  @Provide({ allowOverride: 'confirmText' }) public confirmText: Resource | undefined = undefined;
  // 账号登录信息
  @StorageLink('isLogIn') isLogIn: boolean = false;
  private borderRadiusRounded: Resource =
    DeviceInfo.isPc() ? $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10');
  private borderRadiusInner: Resource =
    DeviceInfo.isPc() ? $r('sys.float.corner_radius_level6') : $r('sys.float.corner_radius_level8');
  private scroller: Scroller = new Scroller();
  private navPath?: NavPathStack;
  // 浅层窗口背景颜色适配
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @State private sheetShowBackColor: string = Constants.SHEET_SHOW_BACK_COLOR_LIGHT;

  private onColorModeChange() {
    Log.info(TAG, `currentMode is ${this.currentMode}`)
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.sheetShowBackColor = Constants.SHEET_SHOW_BACK_COLOR_LIGHT;
    } else {
      this.sheetShowBackColor = Constants.SHEET_SHOW_BACK_COLOR_DARK;
    }
  }

  aboutToAppear(): void {
    this.onColorModeChange();
  }

  aboutToDisappear(): void {
  }

  @Builder
  listItem() {
    ListItem({}) {
      AnalysisServiceToggle({
        broadcast: $broadcast,
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
  extendServiceList() {
    List() {
      ListItemGroup({ style: ListItemGroupStyle.CARD }) {
        this.listItem();
      }
      .divider({
        strokeWidth: '1px',
        startMargin: $r('sys.float.padding_level4'),
        endMargin: $r('sys.float.padding_level4'),
        color: $r('sys.color.ohos_id_color_list_separator'),
      })
      .borderRadius(this.borderRadiusRounded)
      .margin({
        top: $r('app.float.account_listcard_margin_top'),
        left: Constants.SHEET_CONFIG_LEFT_RIGHT_MARGIN,
        right: Constants.SHEET_CONFIG_LEFT_RIGHT_MARGIN,
      })
      .backgroundColor($r('sys.color.comp_background_list_card'))
    }
    .height('100%')
  }

  @Builder
  buildNavTitle() {
    // 实现标题栏
    Row() {
      this.backIconBuilder(this.navPath);
      Text(UiUtil.getResourceStringSync($r('app.string.extended_services')))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .maxFontScale(1.0)
        .minFontScale(1.0)
    }
    .width(Constants.PERCENT_100)
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .margin({
      top: Constants.SHEET_CONFIG_TOP_PADDING,
      bottom: $r('app.float.account_listcard_margin_top'),
    })
  }

  @Builder
  backIconBuilder(pageInfos?: NavPathStack) {
    Button({ type: ButtonType.Normal, stateEffect: true }) {
      SymbolGlyph($r('sys.symbol.chevron_backward'))
        .draggable(false)
        .fontColor([$r('sys.color.icon_primary')])
        .fontSize($r('app.float.icon_size'))
    }
    .height($r('app.float.action_bar_button_height'))
    .width($r('app.float.action_bar_button_height'))
    .borderRadius($r('sys.float.corner_radius_level4'))
    .backgroundColor(Color.Transparent)
    .onClick((): void => {
      pageInfos?.pop();
    })
    .margin({
      left: Constants.SHEET_CONFIG_LEFT_RIGHT_MARGIN,
      right: $r('app.float.extended_services_listcard_padding_left_and_right'),
    })
  }

  @Builder
  buildExtendPage() {
    NavDestination() {
      Column() {
        /* instrument ignore next */
        if (DeviceInfo.isPc()) {
          this.buildNavTitle();
        }
        Scroll(this.scroller) {
          this.extendServiceList();
        }
        .edgeEffect(EdgeEffect.Spring)

        CustomDialogView({ broadCast: $broadcast, navigationPageInfos: this.navPath, })
      }
      .width('100%')
      .height('100%')
      .draggable(false)
    }
    .backgroundColor(this.sheetShowBackColor)
    .padding({
      top: Constants.SHEET_CONFIG_TOP_PADDING,
    })
    .onReady((ctx: NavDestinationContext) => {
      try {
        if (ctx.pathStack.size() >= 0) {
          this.navPath = ctx.pathStack;
          Log.info(TAG, `pathInfos size: ${this.navPath?.size()}`);
        }
      } catch (e) {
        Log.info(TAG, `testTag onReady catch exception: ${JSON.stringify(e)}`)
      }
      let agreement: IsAgreeAiRetouchProtocol | undefined = ctx.pathStack.getParamByName(
        NavigationConstants.NAVIGATION_DESTINATION_EXTENDED_SERVICES)?.[0] as IsAgreeAiRetouchProtocol | undefined;
      Log.info(TAG, `ExtendedServicesPage IsAgreeAiRetouchProtocol: ${agreement?.agree}`);
    })
    .title(UiUtil.getResourceStringSync($r('app.string.extended_services')))
    .hideTitleBar(DeviceInfo.isPc())
  }

  build() {
    this.buildExtendPage();
  }

  @Builder
  public static extendedPage() {
    ExtendedServicesPage({});
  }
}

export function initExtendedServicePage() {
  // PafRouter.getPafRouter().registerDavDesOptions({
  //   navPageName: NavigationConstants.NAVIGATION_DESTINATION_EXTENDED_SERVICES,
  //   pageTitle: '',
  //   customStyle: true,
  //   builder: ExtendedServicesPage.extendedPage,
  // })
}