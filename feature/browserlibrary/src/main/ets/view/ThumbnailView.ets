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

import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { BasePhotoBrowserController } from '../model/BasePhotoBrowserController';
import {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import { completed } from '@ohos/tools/src/main/interface/ArkUI';
import { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import { image } from '@kit.ImageKit';
import { ThumbnailVM } from '../model/ThumbnailVM';
import { ImageDecodeUtils } from '@ohos/common/src/main/ets/default/model/browser/photo/ImageDecodeUtils';
import { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { ThumbnailVMFactory } from '../model/ThumbnailVMFactory';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

export const SCROLL_ANIMATION_DURATION: number = 100;

const TAG: string = 'browser_ThumbnailView';

@Component
export struct ThumbnailView {
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  /**
   * 大图组件控制器
   */
  @Consume browserController: BasePhotoBrowserController;
  @Link thumbnailShow: boolean;
  /**
   * 标记当前是否正在执行一镜到底动效
   */
  @Link isRunningAnimation: boolean;
  @LocalStorageLink('fastPixmap') fastPixmap: image.PixelMap | undefined = undefined;
  @State viewModel: ThumbnailVM = ThumbnailVMFactory.getThumbnailVM(this.stateMachine, this.browserController.pageFrom);
  @State dynamicRange: DynamicRangeMode = DynamicRangeMode.HIGH;
  /* instrument ignore next  */
  @State bright: number = 1.0;
  /* instrument ignore next  */
  @State beginBright: number = 0.0;
  /* instrument ignore next  */
  @State endBright: number = 1.0;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  public setThumbnailShowFunc: Function = (thumbnailShow: boolean): void => {
    this.thumbnailShow = thumbnailShow;
  }

  public setIsRunningAnimationFunc: (isRunningAnimation: boolean) => void = (isRunningAnimation: boolean) => {
    Log.info(TAG, `onRunningAnimationChanged ${isRunningAnimation}`);
    this.isRunningAnimation = isRunningAnimation;
  }

  aboutToAppear() {
    Log.info(TAG, `aboutToAppear`);
    this.viewModel.onCreate(this.browserController);
    this.viewModel.uiContext = this.getUIContext();
    this.viewModel.setIsRunningAnimationFunc = this.setIsRunningAnimationFunc;
    this.viewModel.setThumbnailShowFunc = this.setThumbnailShowFunc;
  }

  aboutToDisappear() {
    Log.info(TAG, `aboutToDisappear`);
    this.viewModel.onDestroy();
  }

  build() {
    Stack() {
      this.buildThumbImage();
    }
    // TODO:PC独立窗口上了之后删除
    .margin({
      top: DeviceInfo.isPc() ? Constants.WindowDecorHeight + BrowserConstants.DIVIDER_WIDTH : 0,
      bottom: DeviceInfo.isPc() ? Constants.PC_PREVIEW_STACK_HEIGHT + BrowserConstants.DIVIDER_WIDTH: 0
    })
  }

  private getThumbImage(): image.PixelMap | string | undefined {
    let imageInfo = this.fastPixmap?.getImageInfoSync();
    Log.info(TAG, `[enterLibrary] fastPixmap width:${imageInfo?.size?.width} height:${
    imageInfo?.size?.height}`);
    if (!imageInfo?.size?.width || !imageInfo?.size?.height) {
      Log.info(TAG, '[enterLibrary] fastPixmap size undefind, not support fast thumbnail');
    } else {
      Log.info(TAG, 'getThumbImage return fastPixmap');
      return this.fastPixmap;
    }
    if (this.viewModel.item === undefined) {
      Log.info(TAG, 'getThumbImage return empty');
      return '';
    }
    let width = this.viewModel.item.width ?? 1;
    let height = this.viewModel.item.height ?? 1;
    if (width / height > 3 || height / width > 3) {
      return this.getLCDImage();
    }

    let p = ImageUtil.getThumbnailAstcUri(this.viewModel.item?.uri, this.viewModel.item?.path,
      this.viewModel.item?.getDateModified?.());
    Log.info(TAG, `getThumbImage uri:${p}`);
    return p;
  }

  private getLCDImage(): image.PixelMap | string | undefined {
    let imageInfo = this.fastPixmap?.getImageInfoSync();
    Log.info(TAG, `[enterLibrary] getLCDImage fastPixmap width:${imageInfo?.size?.width} height:${
    imageInfo?.size?.height}`);
    if (!imageInfo?.size?.width || !imageInfo?.size?.height) {
      Log.info(TAG, '[enterLibrary] getLCDImage fastPixmap size undefind, not support fast thumbnail');
    } else {
      Log.info(TAG, 'getLCDImage return fastPixmap');
      return this.fastPixmap;
    }
    if (!this.viewModel.item) {
      /* instrument ignore next  */
      Log.error(TAG, `getLCDImage Invalid item=${this.viewModel.item}`);
      /* instrument ignore next  */
      return '';
    }
    if (ImageUtil.isExitTransparentChannelImgMimeType(this.viewModel.item)) {
      /* instrument ignore next  */
      Log.info(TAG ,`${this.viewModel.item.uri} transparent channel image ,place holder is astc`);
      return `${this.viewModel.item.uri}?timestampApp=${this.viewModel.item.getDateModified?.()}&oper=astc&path=${
        this.viewModel.item.path}`;
    }

    return this.getLCDUri(this.viewModel.item?.uri, this.viewModel.item?.path,
      this.viewModel.item?.getDateModified?.());
  }

  private getLCDUri(sourceUri: string | undefined, path: string | undefined, modifiedDate: number | undefined) {
    return `${sourceUri}?timestampApp=${
    modifiedDate}&oper=thumbnail&width=-1&height=-1&decodeDynamicRange=${image.DecodingDynamicRange.SDR}&path=${path}`;
  }

  private lcdDynamicRangeMode(): DynamicRangeMode {
    return this.dynamicRange;
  }

  private lcdComplete(): void {

  }

  @Builder
  buildPlayButton() {
    if (this.viewModel.isShowVideoButton()) {
      Image($r('app.media.ic_camera_parabar_story_play'))
        .width($r('app.float.icon_video_size'))
        .height($r('app.float.icon_video_size'))
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .key('VideoPlayButton')
        .attributeModifier(this.viewModel.playButtonModifier)
    }
  }

  @Builder
  buildASTC() {
    Image(this.getThumbImage())
      .onComplete((event?: completed): void => {
        Log.info(TAG, `buildASTC onComplete loadingStatus = ${event?.loadingStatus}`);
        if (event?.loadingStatus === 1 && !this.viewModel.isThumbnailComplete) {
          this.viewModel.isThumbnailComplete = true;
          this.stateMachine.processInitialAnimationEvent();
          this.viewModel.onPhotoitemAppear();
          Log.info(TAG, `buildThumbnailImage event = ${event?.componentHeight} ${event?.componentWidth}
              ${event?.loadingStatus}`);
        }
      })
      .onError((event: ImageError): void => {
        Log.error(TAG, `load error, ${this.browserController.getCurrentIndex()} ${event.message
        } ${this.viewModel.item?.uri}`);
        this.viewModel.isThumbnailComplete = true;
        this.viewModel.onPhotoitemAppear();
      })
      .attributeModifier(this.viewModel.astcImageModifier)
      .width(Constants.PERCENT_100)
      .height(Constants.PERCENT_100)
      .objectFit(ImageFit.Contain)
      .onAppear(() => {
        Log.info(TAG, 'buildASTC onAppear');
      })
  }

  @Builder
  buildLCD() {
    // TODO 目前此段代码会导致进大图时概率崩溃，暂时删除不影响其他功能
    // Image(this.getLCDImage())
    //   .onComplete((event?: completed): void => {
    //     Log.info(TAG, `buildLCD onComplete loadingStatus = ${event?.loadingStatus}`);
    //     if (event?.loadingStatus === 1 && this.viewModel.imageLCDOpacity !== 1) {
    //       Log.info(TAG, `LCD complete ${this.viewModel.item?.uri}`)
    //       animateTo({
    //         duration: 200,
    //         curve: Curve.Linear,
    //         onFinish:  () => {
    //         }
    //       }, () => {
    //         this.viewModel.imageLCDOpacity = 1;
    //       })
    //     }
    //   })
    //   .alt(this.getThumbImage())
    //   .onError((event: ImageError): void => {
    //     Log.error(TAG, `load error, ${this.browserController.getCurrentIndex()} ${event.message
    //     } ${this.viewModel.item?.uri}`);
    //   })
    //   .width(Constants.PERCENT_100)
    //   .height(Constants.PERCENT_100)
    //   .opacity(this.viewModel.imageLCDOpacity)
    //   .dynamicRangeMode(DeviceInfo.isTv() ? undefined : this.lcdDynamicRangeMode())
    //   .objectFit(ImageFit.Contain)
  }

  @Builder
  buildThumbImage() {
    if (!this.viewModel.isTransitionEnable) {
      Stack() {
        Column() {
          Stack() {
            this.buildASTC();
            //this.buildLCD();
            this.buildPlayButton();
          }
          .attributeModifier(this.viewModel.thumbImageModifier)
          .clip(true)
        }
        .attributeModifier(this.viewModel.thumbImageColumnModifier)
        .justifyContent(FlexAlign.Center)
        .clip(true)
        .enabled(false)
      }
      .onAttach(() => {
        this.viewModel.thumbImageColumnModifier?.updateVisibility(Visibility.Hidden);
        this.viewModel.onPhotoitemAppear();
      })
      .width(Constants.PERCENT_100)
      .height(Constants.PERCENT_100)
    }
  }



}
