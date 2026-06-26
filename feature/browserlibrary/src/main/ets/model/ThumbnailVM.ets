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

import { IStateChangeListener } from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/IPhotoBrowserState';
import {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import {
  BaseAttributeUpdater
} from '@ohos/browsercommon/src/main/ets/default/viewModel/base/BaseAttributeUpdater';
import {
  InitAttributeUpdater
} from '@ohos/browsercommon/src/main/ets/default/viewModel/base/InitAttributeUpdater';
import { BasePhotoBrowserController } from './BasePhotoBrowserController';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import {
  BrowserAnimController,
  BrowserAnimParams } from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import { PhotoItemImageModifier } from '@ohos/browsercommon/src/main/ets/default/utils/CustomModifier';
import { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import { performanceMonitor } from '@kit.ArkUI';
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

const TAG = 'ThumbnailVM';

export abstract class ThumbnailVM implements IStateChangeListener {
  @Track public stateMachine: PhotoBrowserStateMachine;
  // 小图外层column动效
  @Track public thumbImageColumnModifier: BaseAttributeUpdater<ColumnAttribute> | undefined = undefined;
  @Track public astcImageModifier: PhotoItemImageModifier = new PhotoItemImageModifier();
  // 小图自身动效
  @Track public thumbImageModifier: BaseAttributeUpdater<StackAttribute> | undefined = undefined;
  // 播放按钮动效
  @Track public playButtonModifier: InitAttributeUpdater<ImageAttribute> | undefined = undefined;
  @Track public browserAnimController: BrowserAnimController = new BrowserAnimController();
  @Track public isTransitionEnable: boolean = true;
  // 缩略图是否已加载完成
  public isThumbnailComplete: boolean = false;

  @Track public item: MediaItem | undefined = undefined;
  @Track public imageLCDOpacity: number = 0.3;
  public uiContext: UIContext | undefined = undefined;
  protected browserController: BasePhotoBrowserController | undefined;
  private enterAnimId: number = 0;

  constructor(stateMachine: PhotoBrowserStateMachine) {
    this.stateMachine = stateMachine;
  }

  onCurrentIndexChange(currentIndex: number): void {

  }

  onTargetIndexChange(targetIndex: number): void {
    let item: MediaItem | undefined = this.browserController?.dataSource.getData(targetIndex)?.item;
    if (item === undefined) {
      Log.warn(TAG, `playEnterAnimSync item undefined`);
      this.item = undefined;
    }
    // 切换图片就要把图片已完成置为false
    this.isThumbnailComplete = false;
    this.item = item;
  }

  onPropertiesStateChange(isShowProperties: boolean): void {

  }

  onDeleteStart(): void {

  }

  onStable(): void {

  }

  onGestureStateChange?(isEnd: boolean): void {

  }

  onEnterStartAnim(): void {
  }

  onEnterEndAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    performanceMonitor.end(this.browserAnimController.getEnterAnimTraceName());
    this.setIsRunningAnimationFunc(false);
    this.browserController?.browserAnimController.enterOnfinish();
    this.hideEnterAnimating();
    this.playExitAnimSync();
  }

  onExitStartAnim(): void {
  }

  onExitEndAnim?(): void {

  }

  onBackEndAnim?(): void {

  }

  onPhotoitemAppear(): void {
    Log.info(TAG, `onPhotoitemAppear ${this.stateMachine.getTargetIndex()}`);
    if (this.isThumbnailComplete) {
      this.stateMachine.processPhotoitemAppearEvent();
    }
  }

  onSwiperAnimEnd?(): void {

  }

  initialAnim?(): void {

  }

  public setThumbnailShowFunc: Function = (thumbnailShow: boolean): void => {
  }

  public setIsRunningAnimationFunc: Function = (setIsRunningAnimationFunc: boolean): void => {
  }

  public onCreate(browserController: BasePhotoBrowserController): void {
    this.browserController = browserController;
    this.browserAnimController = this.browserController.browserAnimController;
    this.isTransitionEnable = this.browserAnimController?.isTransitionEnable;
    this.enterAnimId = this.browserAnimController.enterAnimId;
    this.createAttributeModifier();
    this.setCurrentMediaItem();
    this.stateMachine.registerStateChangeListener(this, true);
  }



  public setCurrentMediaItem(): void {
    let item: MediaItem | undefined = this.browserController?.dataSource
      .getSimpleData(this.stateMachine.getTargetIndex())?.item;
    if (item === undefined) {
      Log.warn(TAG, `playEnterAnimSync item undefined`);
      this.item = undefined;
    }
    this.item = item;
  }

  public playEnterAnimSync(): void {
    if (this.browserController === undefined || this.item === undefined) {
      return;
    }
    const startParams = this.browserController.browserAnimController?.
    getBrowserToGridAnimationParams(this.stateMachine.getTargetIndex(), this.item.uri, true);
    this.playImageAnimationAsync(startParams, this.stateMachine.getTargetIndex(), (index: number) => { },
      () => { }, false, 0);
    this.thumbImageColumnModifier?.updateVisibility(Visibility.Visible);
    const endParams = this.browserAnimController?.getGridToBrowserAnimationParams();
    Log.info(TAG, `start to play anim`)
    performanceMonitor.begin(this.browserAnimController.getEnterAnimTraceName(),
      performanceMonitor?.ActionType.LAST_UP);
    this.playImageAnimationAsync(endParams, this.stateMachine.getTargetIndex(), (index: number) => {
      // 播放完动画进入下一状态
      if (this.stateMachine.getTargetIndex() === index &&
        this.browserAnimController.enterAnimId === this.enterAnimId) {
        this.stateMachine?.processEnterAnimationEndEvent();
      }
      Log.info(TAG,
        `playEnterAnimationSync currentState = ${this.stateMachine?.getCurrentState()?.stateName} ${
        this.stateMachine?.getTargetIndex()}`);
    }, () => {
      this.browserController?.onEnterAnimating();
    }, true);
  }

  public playExitAnimSync(): void {
  }



  /**
   * 触发进出大图的动效
   */
  public playImageAnimationAsync(params: BrowserAnimParams, index: number, onFinish: (index: number) => void,
    onAnim: () => void, gridToImage: boolean, duration: number = 1000): void {
    // 动效时长传入0，不走animateto逻辑
    if (duration === 0) {
      this.setImageAnimation(params, gridToImage, duration);
      return;
    }
    TraceControllerUtils.startTrace(`buildthumbimage`);
    this.browserController?.uiContext?.animateToImmediately({
      curve: gridToImage ? params.curveStart : params.curveEnd,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        onFinish(index);
      },
    }, () => {
      TraceControllerUtils.finishTrace(`buildthumbimage`);
      onAnim();
      this.setImageAnimation(params, gridToImage, duration);
    })
  }

  /**
   * 设置一镜到底动画参数
   */
  public setImageAnimation(params: BrowserAnimParams, gridToImage: boolean, duration: number): void {
    Log.info(TAG, `setImageAnimation reason: ${gridToImage} targetWidth: ${params.targetWidth} targetHeight: ${
    params.targetHeight} targetTranslate: ${params.targetTranslate?.x} targetThumbnailOpacity: ${
    params.targetThumbnailOpacity} targetPhotoOpacity: ${params.targetPhotoOpacity} targetAspectRatio: ${
    params.targetAspectRatio} targetRadius: ${params.targetRadius} borderWidth: ${params.targetBorderWidth} targetScale: ${
    params.targetScale?.x} duration: ${duration}`)
    this.thumbImageColumnModifier?.updateWidth(params.targetThumbnailWidth ?? BrowserConstants.targetWidth);
    this.thumbImageColumnModifier?.updateHeight(params.targetThumbnailHeight ?? BrowserConstants.targetHeight);
    this.thumbImageColumnModifier?.attribute?.translate(params.targetThumbnailTranslate ??
    BrowserConstants.targetTranslate);
    this.thumbImageModifier?.updateBorderRadius(params.targetRadius ?? BrowserConstants.targetRadius);
    this.thumbImageModifier?.updateBorderWidth(params.targetBorderWidth ??
    BrowserConstants.targetBorderWidth);
    this.playButtonModifier?.updateOpacity(params.targetPlayButtonOpacity ?? BrowserConstants.targetPhotoOpacity);
  }

  public createAttributeModifier(): void {
    if (this.thumbImageColumnModifier === undefined) {
      this.thumbImageColumnModifier = new BaseAttributeUpdater();
    }
    if (this.thumbImageModifier === undefined) {
      this.thumbImageModifier = new BaseAttributeUpdater();
    }
    if (this.playButtonModifier === undefined) {
      this.playButtonModifier = new InitAttributeUpdater({
        opacity: 0
      })
    }
  }

  public hideEnterAnimating(): void {
    Log.info(TAG, `hideEnterAnimating`);
    this.thumbImageColumnModifier?.updateVisibility(Visibility.None);
  }


  public onDestroy(): void {
    this.stateMachine.unregisterStateChangeListener(this);
  }

  public isShowVideoButton(): boolean {
    if (DeviceInfo.isTv()) {
      Log.debug(TAG, `[thumbnailBtn] tv not show playbutton`);
      return false;
    }
    if (this.item === undefined) {
      Log.error(TAG, `[thumbnailBtn] mediaItem not exist, not show video button`);
      return false;
    }
    if (this.item.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      Log.debug(TAG, `[thumbnailBtn] not video, not show video button`);
      return false;
    }
    return true;
  }

}