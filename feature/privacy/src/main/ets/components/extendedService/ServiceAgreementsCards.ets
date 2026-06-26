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

import lazy { Privacy } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { Navigate } from '../../nav/Navigate';
import lazy { AiEditorCommonUtil } from '@ohos/common/src/main/ets/default/utils/AiEditorCommonUtil';
import lazy SettingCard from '../../setting/SettingCard';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { LengthMetrics } from '@kit.ArkUI';

/* instrument ignore file */
const TAG: string = 'ServiceAgreementsCards';

@Builder
export function ServiceAgreementsPageLoader() {
  ServiceAgreementsCards();
}

@Component
export struct ServiceAgreementsCards {
  @StorageLink('statusBarHeight') private statusBarHeight: number = 0;
  // 是否处于垂直状态
  @StorageLink('isHorizontal') private isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink('digging_hole_camera_area') private diggingHoleCameraArea:
    DiggingHoleCameraArea = getScreen().getDiggingHoleCameraArea();
  @StorageProp(Constants.IS_SUPPORT_CLOUD_ENHANCE) isSupportCloudEnhance: boolean = false;
  @Consume('navigationPageInfos') private navigationPageInfos: NavPathStack;
  private windowColumns: number = getScreen().getScreenColumns();
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  private gallerySettingsListCardWidthReduceLength: number = 8;
  private borderRadiusRounded: Resource =
      DeviceInfo.isPc() ? $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10');
  private borderRadiusInner: Resource =
      DeviceInfo.isPc() ? $r('sys.float.corner_radius_level6') : $r('sys.float.corner_radius_level8');
  private scroller: Scroller = new Scroller();
  private navPath: NavPathStack = new NavPathStack();
  // 浅层窗口背景颜色适配
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @State private sheetShowBackColor: string = Constants.SHEET_SHOW_BACK_COLOR_LIGHT;

  /**
   * 浅层窗口背景颜色业务自适应
   */
  private onColorModeChange() {
    Log.info(TAG, `currentMode is ${this.currentMode}`)
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.sheetShowBackColor = Constants.SHEET_SHOW_BACK_COLOR_LIGHT;
    } else {
      this.sheetShowBackColor = Constants.SHEET_SHOW_BACK_COLOR_DARK;
    }
  }

  /**
   * 适配窗口大小变化
   */
  private onWinSizeChanged(): void {
    this.windowColumns = getScreen().getScreenColumns();
  }

  aboutToAppear(): void {
    Log.info(TAG, `ServiceAgreementsCards aboutToAppear`)
    this.onColorModeChange();
    AppStorage.setOrCreate<boolean>(Constants.IS_SHOW_FROM_SETTING_PRIVACY_LIST, true);
  }

  aboutToDisappear(): void {
    Log.info(TAG, `ServiceAgreementsCards aboutToDisappear`)
    // 删除缓存数据
    AppStorage.delete(Constants.IS_SHOW_FROM_SETTING_PRIVACY_LIST);
  }

  @Builder
  listItem() {
  }

  // @Builder
  // buildPrivacyList(title: Resource, agreement: PrivacyAgreement) {
  //   ListItem() {
  //     SettingCard({ title: title });
  //   }
  //   .accessibilityLevel('yes')
  //   .listItemStyle()
  //   .padding({
  //     left: $r('app.float.extended_services_listcard_padding_left_and_right'),
  //     right: $r('app.float.extended_services_listcard_padding_left_and_right'),
  //   })
  //   .borderRadius(this.borderRadiusInner)
  //   .onClick(Navigate.emitProtocol(this.navPath, agreement))
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
  backIconBuilder(pageInfos?: NavPathStack) {
    Button({ type: ButtonType.Normal, stateEffect: true }) {
      SymbolGlyph($r('sys.symbol.chevron_backward'))
        .draggable(false)
        .fontColor([$r('sys.color.icon_primary')])
        .fontSize($r('app.float.icon_size'))
    }
    .accessibilityText($r('app.string.action_back'))
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
  buildNavTitle() {
    // 方案一：自己实现标题栏
    Row() {
      this.backIconBuilder(this.navPath)

      Text(UiUtil.getResourceStringSync($r('app.string.service_agreements_and_rules')))
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
  buildServiceAgreementsCards() {
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
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
      .draggable(false)
    }
    .onReady((ctx: NavDestinationContext) => {
      try {
        if (ctx.pathStack.size() >= 0) {
          this.navPath = ctx.pathStack;
          Log.info(TAG, `pathInfos size: ${this.navPath?.size()}`);
        }
      } catch (e) {
        Log.info(TAG, `testTag onReady catch exception: ${JSON.stringify(e)}`)
      }
    })
    .title(UiUtil.getResourceStringSync($r('app.string.service_agreements_and_rules')), {
      paddingEnd: LengthMetrics.vp(Constants.ACTION_BUTTON_WIDTH + Constants.COLUMN_PADDING_RIGHT)
    })
    .backgroundColor(this.sheetShowBackColor)
    .padding({
      top: Constants.SHEET_CONFIG_TOP_PADDING,
    })
    .hideTitleBar(DeviceInfo.isPc())
  }

  build() {
    this.buildServiceAgreementsCards();
  }

  @Builder
  public static ServiceAgreementsPage() {
    ServiceAgreementsCards({});
  }
}

/**
 * paf全局路由栈注册
 */
export function initServiceAgreementsCards() {
  // PafRouter.getPafRouter().registerDavDesOptions({
  //   navPageName: NavigationConstants.NAVIGATION_DESTINATION_SERVICE_AGREEMENTS_CARDS,
  //   pageTitle: '',
  //   customStyle: true,
  //   builder: ServiceAgreementsCards.ServiceAgreementsPage,
  // })
}