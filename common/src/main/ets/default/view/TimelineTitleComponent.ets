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

import lazy { TimelineData } from '../model/browser/photo/TimelineData';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { DateUtil } from '../utils/DateUtil';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { Log } from '../utils/Log';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { getScreen, ScreenManager, updateAlbumPageGridPaddingLeftAndRight } from '../model/common/ScreenManager';
import lazy { AppBarStyles } from '../view/actionbar/AppBarStyles';
import lazy { ConfigurationChangeListener, EnvironmentHelper } from '../utils/EnvironmentHelper';
import lazy { Configuration } from '@ohos.app.ability.Configuration';
import lazy { UiUtil } from '../utils/UiUtil';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';

const TAG: string = 'common_TimelineTitleComponent';

const ADDR_REQUEST_DELAY: number = 100;

/**
 * 默认字体缩放比
 */
const DEFAULT_FONT_SCALE: number = 1.0;

// Group Title
// TimelineTitleComponent
@Component
export struct TimelineTitleComponent {
  @State groupData: TimelineData = new TimelineData();
  @Prop isSelectedMode: boolean = false;
  mediaItem: MediaItem = new MediaItem();
  @State viewAddr: string = '';
  @State hasAddr: boolean = false;
  @Prop isNeedResetSubLocalityAddress: boolean = false;
  @Prop index: number = 0;
  @State isSelected: boolean = false;
  @Consume broadCast: BroadCast;
  @Prop mRefreshKey: string = '';
  mPosition: number | undefined = 0;
  @State private titlePadding: number = updateAlbumPageGridPaddingLeftAndRight(true);
  addresses = '';
  @StorageLink('current_time') @Watch('changeTitleTime') currentTime: number = 0;
  @State titleTime?: Resource = undefined;
  @Prop titleOffset: number = 0;
  timeTitleHeight: number = 0;
  @Prop timeTitleWidth: number = 0;
  private isFromBroadcast: boolean = false;
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  private onSelectUpdateFun = (toSelected: boolean): void => this.onSelectUpdate(toSelected);
  private addrRequestTimer: number = -1;
  private addressMarginTop: number = 2;
  private addressPaddingBottom: number = 6;
  private addressPaddingTop: number = 19;
  private showAddr: boolean = true;

  private readonly cfgListener: ConfigurationChangeListener = {
    onConfigurationUpdated: (oldConfig: Configuration | undefined,
      newConfig: Configuration) => this.onConfigurationUpdated(oldConfig, newConfig),
  } as ConfigurationChangeListener;

  private onConfigurationUpdated(oldConfig: Configuration | undefined, newConfig: Configuration): void {
    if (oldConfig?.language !== newConfig.language) {
      Log.info(TAG, 'onConfigurationUpdated');
      this.changeTitleTime();
      // 切换语言后需要清空缓存的地址信息并重新请求地址
      this.mediaItem?.resetSubLocalityAddress();
      UserFileManagerAccess.getInstance().clearAddressCache();
      this.mediaItem?.getSubLocalityStatic().then(str => this.updateAddress(str));
    }
  }

  private getTitleTime(): void {
    let timestamp: number = this.groupData.startDate;
    if (this.groupData.dateDay) {
      let currentTimestamp: number = DateUtil.parseDateDayString(this.groupData.dateDay);
      if (currentTimestamp !== -1) {
        timestamp = currentTimestamp;
      }
    }
    this.titleTime = DateUtil.getGroupDataLocalizedDate(timestamp);
    let startDate: string = DateUtil.format(new Date(this.groupData.startDate), 'yyyyMMdd');
    if (startDate !== this.groupData.dateDay) {
      Log.error(TAG, `getTitleTime dateDay:${this.groupData.dateDay} startDate:${startDate}` +
        ` ${this.groupData.startDate} timestamp:${timestamp} count:${this.groupData.count}`);
    }
  }

  changeTitleTime(): void {
    this.getTitleTime();
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear:${this.showAddr}`);
    this.getTitleTime();
    if (this.showAddr) {
      this.initialViewAddr();
    }
    this.broadCast.on(this.groupData.getDateKey().toString() + BroadCastConstants.REFRESH_SELECT_DATA_TITLE,
      this.onSelectUpdateFun);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    getScreen().on(ScreenManager.ON_ORIENTATION_CHANGED, this.onWinSizeChangedCallBack);
    EnvironmentHelper.getInstance(getContext())?.addListener(this.cfgListener);
  }

  aboutToDisappear(): void {
    this.broadCast.off(this.groupData.getDateKey().toString() + BroadCastConstants.REFRESH_SELECT_DATA_TITLE,
        this.onSelectUpdateFun);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    getScreen().off(ScreenManager.ON_ORIENTATION_CHANGED, this.onWinSizeChangedCallBack);
    clearTimeout(this.addrRequestTimer);
    EnvironmentHelper.getInstance(getContext())?.removeListener(this.cfgListener);
  }

  initialViewAddr(): void {
    if (!this.mediaItem) {
      Log.info(TAG, `initialViewAddr`);
      this.viewAddr = '';
      this.hasAddr = false;
    }
    let currentAddress: string = this.mediaItem?.getAddress();
    Log.info(TAG, `initialViewAddr:${this.groupData?.dateDay} ${currentAddress?.length} ${this.syncStatus}`);
    this.addrRequestTimer = setTimeout((): void => {
      if (this.isNeedResetSubLocalityAddress) {
        this.mediaItem?.resetSubLocalityAddress();
      }
      this.mediaItem?.getSubLocalityStatic().then(str => this.updateAddress(str));
    }, ADDR_REQUEST_DELAY);
  }

  private execAddressAnimate(address: string): void {
    animateToImmediately({
      duration: 100,
      curve: Curve.Friction,
      onFinish: (): void => {
        Log.info(TAG, `updateAddress finish`);
      }
    }, () => {
      Log.info(TAG, `updateAddress start`);
      this.viewAddr = address;
    })
  }

  updateAddress(address: string): void {
    let isEffectiveAddress: boolean = !!address && address?.length > 0;
    // 值不相等时再更新状态变量
    if (this.hasAddr != isEffectiveAddress) {
      this.hasAddr = isEffectiveAddress;
    }
    let currentAddress: string = this.mediaItem?.getAddress();
    Log.info(TAG, `updateAddress:${this.groupData?.dateDay} ${currentAddress?.length} ${isEffectiveAddress}`);
    if (address?.length > 0) {
      this.mediaItem?.setAddress(address);
      currentAddress = address;
    }
    if (this.groupData?.dateDay && this.viewAddr != address) {
      this.execAddressAnimate(address);
    } else {
      this.viewAddr = currentAddress;
    }
  }

  build() {
    if (!this.hasAddr) {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.End,
      }) {
        // 不带地址信息
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Start,
          justifyContent: DeviceInfo.isPc() ? FlexAlign.Center : FlexAlign.End,
        }) {
          Text(this.titleTime)
            .draggable(false)
            .fontSize(DeviceInfo.isPc() ? $r('sys.float.Subtitle_M') : $r('sys.float.Subtitle_L'))
            .fontFamily($r('app.string.id_text_font_family_medium'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontWeight(DeviceInfo.isPc() ? FontWeight.Medium : FontWeight.Bold)
            .lineHeight(DeviceInfo.isPc() ? 24 : 21)
            .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
            .minFontScale(DEFAULT_FONT_SCALE)
            .key(`TimeLineTitleOfGroup${this.mPosition}`)
        }
        .height('100%')
        .layoutWeight(1)

      }
      .margin(this.getTitleTimeMargin())
      .padding(DeviceInfo.isPc() ? {} :
        { bottom: $r('sys.float.padding_level12'), top: $r('sys.float.padding_level12') })
      .width(DeviceInfo.isPc() ? this.timeTitleWidth : undefined)
      .offset({ x: UiUtil.isMirrorMode() ? -this.titleOffset : 0 })
      .height(this.timeTitleHeight);
    } else {
      Flex({ direction: FlexDirection.Row ,
        justifyContent: DeviceInfo.isPc() ? FlexAlign.Center : FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center})  {
        // 带地址信息
        Column() {
          Text(this.titleTime)
            .draggable(false)
            .fontSize(DeviceInfo.isPc() ? $r('sys.float.Subtitle_M') : $r('sys.float.Subtitle_L'))
            .fontFamily($r('app.string.id_text_font_family_medium'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontWeight(DeviceInfo.isPc() ? FontWeight.Medium : FontWeight.Bold)
            .key(`TimeLineTitleOfGroup${this.mPosition}`)
            .textAlign(TextAlign.Start)
            .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
            .minFontScale(DEFAULT_FONT_SCALE)
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis }) // 启用省略号
            .maxLines(AppBarStyles.MAX_LINES);  // 设置最大行数

          Text(this.viewAddr)
            .draggable(false)
            .key(this.viewAddr)
            .fontSize($r('sys.float.Body_M'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.icon_secondary'))
            .fontWeight(FontWeight.Regular)
            .key(`TimeLineTitleAddrOfGroup${this.mPosition}`)
            .textAlign(TextAlign.Start)
            .margin({ top: this.addressMarginTop })
            .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
            .minFontScale(DEFAULT_FONT_SCALE)
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis }) // 启用省略号
            .maxLines(AppBarStyles.MAX_LINES);  // 设置最大行数
        }
        .margin({right:8})
        .alignItems(HorizontalAlign.Start)
      }
      .width(DeviceInfo.isPc() ? this.timeTitleWidth : '100%')
      .padding(this.getTitleAndAddressPadding())
      .height(this.timeTitleHeight);
    }
  }

  private getCheckBoxMargin(): Margin {
    if (UiUtil.isMirrorMode()) {
      return {
        left: this.titlePadding,
      };
    } else {
      return {
        right: this.titlePadding,
      };
    }
  }

  private getTitleAndAddressPadding(): Padding {
    if (UiUtil.isMirrorMode()) {
      return DeviceInfo.isPc() ? {} : {
        bottom: this.addressPaddingBottom,
        top: this.addressPaddingTop,
        right: this.titlePadding,
      };
    } else {
      return DeviceInfo.isPc() ? {} : {
        bottom: this.addressPaddingBottom,
        top: this.addressPaddingTop,
        left: this.titlePadding,
      };
    }
  }

  private getTitleTimeMargin(): Margin {
    if (UiUtil.isMirrorMode()) {
      return {
        right: DeviceInfo.isPc() ? $r('app.float.pc_timeline_title_padding_start') : this.titlePadding,
      };
    } else {
      return {
        left: DeviceInfo.isPc() ? $r('app.float.pc_timeline_title_padding_start') : this.titlePadding,
      };
    }
	}

  /**
   * 窗口大小变化回调
   */
  /* instrument ignore next */
  private onWinSizeChanged(): void {
    this.titlePadding = updateAlbumPageGridPaddingLeftAndRight(true);
  }

  /**
   * 分组全选装填变更回调
   */
  private onSelectUpdate(toSelect: boolean): void {
    if (this.isSelected !== toSelect) {
      this.isFromBroadcast = true;
    }
    this.isSelected = toSelect;
  }
}