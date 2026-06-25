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

import { EffectToggleButton } from '@ohos/browsercommon/src/main/ets/default/view/EffectToggleButton';
import {
  Action,
} from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import {
  DiggingHoleCameraArea,
  getScreen,
  ScreenManager,
  updateAlbumPageGridPaddingLeftAndRight
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import { window } from '@kit.ArkUI';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy {
  ViewStateChangeListener
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/IPhotoBrowserState';
import lazy { ShotForMoreContext } from '@ohos/browsercommon/src/main/ets/default/utils/EffectPhotoContext';

/* instrument ignore file */

const TAG: string = 'EffectToggleComponent';

const DEFAULT_BUTTON: Map<number, Action[]> = new Map([
// 不支持一拍多得
  [Constants.MULTIPLE_GAINS_CLOSE_ALL_EFFECT, []],
  // 001 虚拟光圈、关闭虚拟光圈
  [Constants.MULTIPLE_GAINS_VIRTUAL_APERTURE, [Action.VIRTUAL_APERTURE, Action.CLOSE_VIRTUAL_APERTURE]],
  // 010 闪拍效果、关闭闪拍效果
  [Constants.MULTIPLE_GAINS_FLASH_CAPTURE, [Action.FLASH_CAPTURE, Action.CLOSE_FLASH_CAPTURE]],
  // 011 虚拟光圈、关闭虚拟光圈、闪拍效果、关闭闪拍效果
  [Constants.MULTIPLE_GAINS_FLASH_CAPTURE_AND_VIRTUAL_APERTURE,
    [Action.FLASH_CAPTURE, Action.CLOSE_FLASH_CAPTURE, Action.VIRTUAL_APERTURE, Action.CLOSE_VIRTUAL_APERTURE]],
  // 100 摇拍（不显示）
  [Constants.MULTIPLE_GAINS_PAN, []],
  // 101 摇拍（不显示）、虚拟光圈、关闭虚拟光圈、闪拍效果、关闭闪拍效果
  [Constants.MULTIPLE_GAINS_PAN_VIRTUAL_APERTURE, [Action.VIRTUAL_APERTURE, Action.CLOSE_VIRTUAL_APERTURE]],
  // 110 摇拍（不显示）、闪拍效果、关闭闪拍效果
  [Constants.MULTIPLE_GAINS_PAN_AND_FLASH_CAPTURE, [Action.FLASH_CAPTURE, Action.CLOSE_FLASH_CAPTURE]],
  // 111 摇拍（不显示）、虚拟光圈、关闭虚拟光圈、闪拍效果、关闭闪拍效果
  [Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT, [ Action.FLASH_CAPTURE, Action.CLOSE_FLASH_CAPTURE,
    Action.VIRTUAL_APERTURE, Action.CLOSE_VIRTUAL_APERTURE]],
]);

// 一拍多得勾选
const DEFAULT_BUTTON_CHECK_MAP: Map<number, Action[]> = new Map([
// 关闭摇拍、关闭虚拟光圈
  [Constants.MULTIPLE_GAINS_CLOSE_ALL_EFFECT, [Action.CLOSE_FLASH_CAPTURE, Action.CLOSE_VIRTUAL_APERTURE]],
  // 虚化效果、关闭闪拍效果
  [Constants.MULTIPLE_GAINS_VIRTUAL_APERTURE, [Action.VIRTUAL_APERTURE, Action.CLOSE_FLASH_CAPTURE]],
  // 关闭虚化、闪拍效果
  [Constants.MULTIPLE_GAINS_FLASH_CAPTURE, [Action.FLASH_CAPTURE, Action.CLOSE_VIRTUAL_APERTURE]],
  // 虚化效果、闪拍效果
  [Constants.MULTIPLE_GAINS_FLASH_CAPTURE_AND_VIRTUAL_APERTURE, [Action.VIRTUAL_APERTURE, Action.FLASH_CAPTURE]],
  // 关闭虚化、关闭抓拍
  [Constants.MULTIPLE_GAINS_PAN, [Action.CLOSE_VIRTUAL_APERTURE, Action.CLOSE_FLASH_CAPTURE]],
  // 虚化效果、关闭闪拍效果、关闭摇拍
  [Constants.MULTIPLE_GAINS_PAN_VIRTUAL_APERTURE, [Action.VIRTUAL_APERTURE, Action.CLOSE_FLASH_CAPTURE]],
  // 闪拍效果、关闭虚化
  [Constants.MULTIPLE_GAINS_PAN_AND_FLASH_CAPTURE, [Action.FLASH_CAPTURE, Action.CLOSE_VIRTUAL_APERTURE]],
  // 虚化效果、闪拍效果
  [Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT, [Action.FLASH_CAPTURE, Action.VIRTUAL_APERTURE]],
]);
const OPEN_BUTTON: number[] = [Action.FLASH_CAPTURE.actionID, Action.VIRTUAL_APERTURE.actionID];
const CLOSE_BUTTON: number[] = [Action.CLOSE_FLASH_CAPTURE.actionID, Action.CLOSE_VIRTUAL_APERTURE.actionID];
/**
 * 一拍多得特效切换视图
 */

@Component
export struct EffectToggleComponent {
  private isDeviceSupport: boolean = DeviceInfo.isSupportUltraPhoto();
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  private dataSource?: PhotoDataSource;
  @State private buttonPaddingLeft: number = updateAlbumPageGridPaddingLeftAndRight();
  private winSizeChangeFunc: Function = (size: window.Size): void => this.winSizeChange(size);
  @State item: MediaItem | undefined = undefined;
  @State effectToggleButtonList: Action[] = [];
  @State showEffectToggleButton: boolean = false;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State checkList: Action[] = [];
  @State overlayAction: Action | undefined = undefined;
  @Prop isEffectSwitching: boolean = false;
  @State checkPan: boolean = false;
  @State isShowPanButton: boolean = false;
  @State isCloud: boolean = false;
  private needReportBrowser: boolean = false;
  onMenuClicked: Function = (): void => {
  };

  private onCurrentIndexChange = () => {
    Log.info(TAG, `[effectToggleView appear] EffectToggleView onCurrentIndex`);
  }

  private onTargetIndexChange = () => {
    this.showEffectToggleButton = false;
    this.needReportBrowser = true;
    Log.info(TAG, `[effectToggleView appear] EffectToggleView TargetIndexChange`);
  }

  private viewStateChangeListener: ViewStateChangeListener =
    new ViewStateChangeListener(this.onCurrentIndexChange, this.onTargetIndexChange);

  aboutToAppear(): void {
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.winSizeChangeFunc);
    this.stateMachine.registerStateChangeListener(this.viewStateChangeListener);
    this.needReportBrowser = true;
  }

  aboutToDisappear(): void {
    Log.info(TAG, `[effectToggleComponent appear] aboutTo disappear`);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.winSizeChangeFunc);
    this.stateMachine.unregisterStateChangeListener(this.viewStateChangeListener);
  }

  private async updateCurrentMenu(): Promise<void>  {
    const currItem: MediaItem = this.dataSource?.getRawData(this.stateMachine?.getTargetIndex()).data ?? new MediaItem();
    const uri: string = currItem?.uri ?? '';
    this.isCloud = currItem?.getPosition() === photoAccessHelper.PositionType.CLOUD;
    Log.info(TAG, `updateMenu uri: ${uri} currentindex ${this.stateMachine.getTargetIndex()} cloud ${this.isCloud}`);
    let fetchOptions: string[] = ['deferred_effect_status', 'supported_deferred_effects'];
    let effectToggleButtonList: Action[] = [];
    let isShowPanButton: boolean = false;
    let checkPan: boolean = false;
    let showEffectToggleButton: boolean = false;
    let checkList: Action[] = [];
    if (!this.isDeviceSupport) {
      Log.info(TAG, `isDeviceSupport ${this.isDeviceSupport}`);
      this.updateLocalState(showEffectToggleButton, effectToggleButtonList, checkList, isShowPanButton, checkPan);
      return;
    }
    try {
      let item: photoAccessHelper.PhotoAsset | undefined;
      item = await UserFileManagerAccess.getInstance().getFileAssetByUri(uri, fetchOptions);
      if (!item) {
        Log.error(TAG, `getFileAssetByUri error`);
        this.updateLocalState(showEffectToggleButton, effectToggleButtonList, checkList, isShowPanButton, checkPan);
        return;
      }
      let mediaItem: MediaItem = new MediaItem(item);
      let deferredEffectStatus: number | undefined = mediaItem.data?.get('deferred_effect_status') as number;
      Log.info(TAG, `uri: ${uri}, deferred_effect_status before: ${deferredEffectStatus}`);
      if (deferredEffectStatus === undefined) {
        deferredEffectStatus = -1;
      }
      if (this.checkMovingPhotoEffectEnable(deferredEffectStatus)) {
        deferredEffectStatus = deferredEffectStatus % Constants.MULTIPLE_GAINS_MOVING_PHOTO_EFFECT_ENABLE;
      }
      const supportedDeferredEffects: number = mediaItem.data?.get('supported_deferred_effects') as number ?? 0;
      ShotForMoreContext.getInstance().setSupportEffect(supportedDeferredEffects);
      const needUpdate: boolean = deferredEffectStatus >= Constants.MULTIPLE_GAINS_CLOSE_ALL_EFFECT &&
        deferredEffectStatus <= Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT;
      if (needUpdate) {
        // 当前默认先全部显示按钮
        showEffectToggleButton = supportedDeferredEffects > Constants.MULTIPLE_GAINS_CLOSE_ALL_EFFECT &&
          supportedDeferredEffects <= Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT &&
          supportedDeferredEffects !== Constants.MULTIPLE_GAINS_PAN;
        effectToggleButtonList = DEFAULT_BUTTON.get(supportedDeferredEffects) ?? [];
        checkList = DEFAULT_BUTTON_CHECK_MAP.get(deferredEffectStatus) ?? [];
        isShowPanButton = supportedDeferredEffects >= Constants.MULTIPLE_GAINS_PAN &&
          supportedDeferredEffects <= Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT;
        checkPan = deferredEffectStatus >= Constants.MULTIPLE_GAINS_PAN &&
          deferredEffectStatus <= Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT;
        if (this.needReportBrowser) {
          this.reportBrowser(mediaItem, deferredEffectStatus);
        }
      } else {
        Log.error(TAG, `getFileAssetByUri undefined`);
      }
      Log.info(TAG, `uri: ${uri}, deferred_effect_status: ${deferredEffectStatus},
      supported_deferred_effects: ${supportedDeferredEffects}`);
    } catch(error) {
      Log.error(TAG, `getFileAssetByUri error ${error}`);
    }
    this.updateLocalState(showEffectToggleButton, effectToggleButtonList, checkList, isShowPanButton, checkPan);
  }

  private checkMovingPhotoEffectEnable(deferredEffectStatus: number): boolean {
    if (Math.ceil(deferredEffectStatus / Constants.MULTIPLE_GAINS_MOVING_PHOTO_EFFECT_ENABLE) === 1) {
      return true;
    } else {
      return false;
    }
  }

  private reportBrowser(item: MediaItem, deferred_effect_status: number) {
    if (!item) {
      Log.error(TAG, `reportBrowser error item is null`);
      return;
    }
    const virtualApertureList: number[] = [
      Constants.MULTIPLE_GAINS_VIRTUAL_APERTURE,
      Constants.MULTIPLE_GAINS_FLASH_CAPTURE_AND_VIRTUAL_APERTURE,
      Constants.MULTIPLE_GAINS_PAN_VIRTUAL_APERTURE,
      Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT,
    ];
    const snapShotList: number[] = [
      Constants.MULTIPLE_GAINS_FLASH_CAPTURE,
      Constants.MULTIPLE_GAINS_FLASH_CAPTURE_AND_VIRTUAL_APERTURE,
      Constants.MULTIPLE_GAINS_PAN_AND_FLASH_CAPTURE,
      Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT,
    ];
    const panList: number[] = [
      Constants.MULTIPLE_GAINS_PAN,
      Constants.MULTIPLE_GAINS_PAN_VIRTUAL_APERTURE,
      Constants.MULTIPLE_GAINS_PAN_AND_FLASH_CAPTURE,
      Constants.MULTIPLE_GAINS_OPEN_ALL_EFFECT,
    ];
    ShotForMoreContext.getInstance()
      .setUrl(item.uri)
      .setVirtualAperture(virtualApertureList.includes(deferred_effect_status))
      .setSnapShot(snapShotList.includes(deferred_effect_status))
      .setPan(panList.includes(deferred_effect_status));
    ShotForMoreContext.getInstance().reportBrowser();
    Log.info(TAG, `reportBrowser success ${item.uri}`);
    this.needReportBrowser = false;
  }

  private updateLocalState(showEffectToggleButton: boolean, effectToggleButtonList: Action[], checkList: Action[],
    isShowPanButton: boolean, checkPan: boolean) {
    this.effectToggleButtonList = effectToggleButtonList;
    this.isShowPanButton = isShowPanButton;
    this.checkPan = checkPan;
    this.checkList = checkList;
    this.overlayAction = this.getOverlayButton(effectToggleButtonList, checkList);
    this.showEffectToggleButton = showEffectToggleButton;
    Log.info(TAG, `[updateEffectToggle] showEffectToggleButton: ${showEffectToggleButton}, isShowPanButton: ${isShowPanButton}, checkPan ${checkPan}`);
  }

  private winSizeChange(size: window.Size): void {
    Log.info(TAG, 'winSizeChange');
    this.updateTitlePaddingLeft();
  }

  private getOverlayButton(effectToggleButtonList: Action[] , checkList: Action[]): Action {
    const checkIdList: number[] = checkList.map((action: Action) => {
      return action.actionID;
    });
    // 取交集
    let list: Action[] = effectToggleButtonList.filter((action: Action)  => {
      return checkIdList.includes(action.actionID);
    });
    let openList: Action[] = list.filter((action: Action) => {
      return OPEN_BUTTON.includes(action.actionID);
    })

    let closeList: Action[] = list.filter((action: Action) => {
      return CLOSE_BUTTON.includes(action.actionID);
    })

    // 超过两个特效勾选，则显示为叠加效果
    if (openList.length >= 2) {
      return Action.OVERLAY_EFFECT;
    }

    // 超过两个关闭特效勾选，则显示为关闭效果
    if (closeList.length >= 2) {
      return Action.CLOSE_EFFECT;
    }

    // 有勾选项，优先显示勾选的按钮
    if (openList.length > 0){
      return openList[0];
    }

    if (closeList.length > 0) {
      return closeList[0];
    }

    return Action.CLOSE_EFFECT;
  }

  private updateTitlePaddingLeft(): void {
    let buttonPaddingLeft: number = updateAlbumPageGridPaddingLeftAndRight();
    this.buttonPaddingLeft = buttonPaddingLeft;
  }

  private getPadding() {
    Log.info(TAG, `titlePaddingLeft: ${this.buttonPaddingLeft}`);
    return this.buttonPaddingLeft;
  }

  build() {
    Row({space: 8}) {
      if (this.showEffectToggleButton && this.isDeviceSupport) {
        EffectToggleButton({
          menu: this.overlayAction,
          isLoading: this.isEffectSwitching,
          isCloud: this.isCloud,
          effectToggleButtonList: this.effectToggleButtonList,
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          checkList: this.checkList,
          enabledButton: true,
        });
      }
    }
    .width('100%')
    .padding({
      bottom: this.diggingHoleCameraArea.bottom,
      left: this.diggingHoleCameraArea.left + this.getPadding(),
      right: this.diggingHoleCameraArea.right + this.getPadding(),
    })
  }
}