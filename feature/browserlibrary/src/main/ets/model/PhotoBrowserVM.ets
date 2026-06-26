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

import lazy { IStateChangeListener } from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/IPhotoBrowserState';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy {
  BaseAttributeUpdater
} from '@ohos/browsercommon/src/main/ets/default/viewModel/base/BaseAttributeUpdater';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BasePhotoBrowserController } from './BasePhotoBrowserController';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';


const TAG = 'PhotoBrowserVM';

@Observed
export class PhotoBrowserVM implements IStateChangeListener {
  @Track public stateMachine: PhotoBrowserStateMachine;
  @Track public isPullingUp: boolean = false;
  @Track public bgViewVisible: Visibility = Visibility.Visible;
  public barVisible: Visibility = Visibility.Visible;

  @Track public bgViewColumnModifier: BaseAttributeUpdater<ColumnAttribute> | undefined = undefined;
  public barModifier: BaseAttributeUpdater<ColumnAttribute> | undefined = undefined;
  protected browserController: BasePhotoBrowserController | undefined;

  private onViewCurrentIndexChange: Function | undefined = () => {
  };
  public setThumbnailViewShow: Function = (isThumbnailViewShow: boolean) => () => {};

  constructor(stateMachine: PhotoBrowserStateMachine) {
    this.stateMachine = stateMachine;
  }

  public onCreate(browserController: BasePhotoBrowserController, onViewCurrentIndexChange?: () => void): void {
    this.browserController = browserController;
    this.stateMachine.registerStateChangeListener(this);
    this.bgViewColumnModifier = new BaseAttributeUpdater();
    this.barModifier = new BaseAttributeUpdater();

    if (onViewCurrentIndexChange) {
      this.onViewCurrentIndexChange = onViewCurrentIndexChange;
    }
  }

  public onDestroy(): void {
    this.stateMachine.unregisterStateChangeListener(this);
    this.onViewCurrentIndexChange = undefined;
  }

  public onCurrentIndexChange(currentIndex: number): void {
    this.setTargetIndex(currentIndex);
    if (this.onViewCurrentIndexChange) {
      this.onViewCurrentIndexChange();
    }
    BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.CLOUD_ENHANCE_ACTIONS_ON_PHOTO_CHANGED);
    this.browserController?.isSupportImageEditorReport();
  }

  getPhotoByIndex(index: number): MediaItem | undefined {
    return (this.browserController?.dataSource?.getRawData(index).data);
  }

  public onTargetIndexChange(targetIndex: number): void {
    Log.info(TAG, `onTargetIndexChanged  :${targetIndex}`);
    let targetItem: MediaItem | undefined = this.getPhotoByIndex(targetIndex) ?? undefined;
    if (targetItem) {
      let currentItem: MediaItem | undefined = AppStorage.get<MediaItem>('targetItem');
      AppStorage.setOrCreate<MediaItem>('targetItem', targetItem);
      if (currentItem) {
        if (this.browserController?.browserAnimController.isTransitionEnable) {
          return;
        }
        setTimeout((): void => {
          this.browserController?.browserAnimController.updatePlaceHolder(targetItem?.uniqueId ?? '', true);
        }, BrowserConstants.SET_WHITE_THUMBNAIL_PLACEHOLDER_DELAY);
      }
    }
  }

  public saveTargetItem(targetIndex: number): void {
    Log.info(TAG, `saveTargetItem  :${targetIndex}`);
    let targetItem: MediaItem | undefined = this.getPhotoByIndex(targetIndex) ?? undefined;
    if (targetItem) {
      AppStorage.setOrCreate<MediaItem>('targetItem', targetItem);
    }
  }

  onTargetIndexAboutToChange(targetIndex: number): void {
    Log.info(TAG, `onTargetIndexAboutToChange: ${targetIndex}`);
    let targetItem: MediaItem | undefined = this.getPhotoByIndex(targetIndex) ?? undefined;
    if (targetItem === undefined || this.browserController?.browserAnimController.isTransitionEnable) {
      return;
    }
    this.browserController?.browserAnimController.updatePlaceHolder(targetItem.uniqueId ?? '', false);
  }

  public onPropertiesStateChange(isPropertiesShow: boolean): void {
    this.isPullingUp = this.stateMachine.isPropertiesShow();
  }

  public onDeleteStart(): void {
  }

  public onStable(): void {
  }

  public setPropertiesState(isPropertiesShow: boolean): void {
    this.stateMachine.setPropertiesState(isPropertiesShow);
  }

  public getCurrentIndex(): number {
    return this.stateMachine.getCurrentIndex();
  }

  public setCurrentIndex(currentIndex: number): void {
    this.stateMachine.setCurrentIndex(currentIndex);
  }

  public getTargetIndex(): number {
    return this.stateMachine.getTargetIndex();
  }

  public setTargetIndex(targetIndex: number): void {
    this.stateMachine.setTargetIndex(targetIndex);
  }

  public onEnterStartAnim(): void {
    Log.info(TAG, `PhotoBrowserController: enterOnStartFun`)
  }

  public onEnterEndAnim(): void {
    this.setThumbnailViewShow(false);
  }

  public onExitStartAnim(): void {
    Log.info(TAG, `PhotoBrowserController: exitOnStartFun`)
    if (this.browserController?.browserAnimController.isTransitionEnable) {
      return;
    }
    this.playExitAnimation();
  }

  public onThumbnailViewShow(): void {
    this.setThumbnailViewShow(true);
  }

  private playExitAnimation(): void {
    Log.info(TAG, `playExitAnimation,${this.browserController?.uiContext}`);
    this.browserController?.uiContext?.animateToImmediately({
      curve: BrowserConstants.CLOSE_PHOTO_CURVE,
    }, () => {
      this.bgViewColumnModifier?.updateVisibility(this.bgViewVisible);
      this.barModifier?.updateVisibility(this.barVisible);
    })
  }

  public processEnterAnimationStartEvent(): void {
    if (this.browserController?.browserAnimController.isTransitionEnable) {
      this.stateMachine.processEnterAnimationStartEvent();
    }
  }

  public processEnterAnimationEndEvent(): void {
    if (this.browserController?.browserAnimController.isTransitionEnable) {
      this.stateMachine.processEnterAnimationEndEvent();
    }
  }
}