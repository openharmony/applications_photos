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
import lazy {
  IStateChangeListener
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/IPhotoBrowserState';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { AttributeUpdater } from '@kit.ArkUI';
import lazy { BasePhotoBrowserController } from './BasePhotoBrowserController';
import lazy { PhotoBrowserStableState }
  from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStableState';

export class SubScreenSwiperVM implements IStateChangeListener {
  private stateMachine: PhotoBrowserStateMachine;
  /**
   * SwiperView单属性刷新控制器
   */
  public swiperModifier: SwiperModifier = new SwiperModifier();

  public textModifier: TextModifier = new TextModifier();

  public columnModifier: ColumnModifier = new ColumnModifier();

  private browserController: BasePhotoBrowserController | undefined;

  private onViewCurrentIndexChange: () => void = () => {};

  constructor(stateMachine: PhotoBrowserStateMachine) {
    this.stateMachine = stateMachine;
  }

  public onCreate(browserController: BasePhotoBrowserController, onCurrentIndexChange: () => void): void {
    this.browserController = browserController;
    this.onViewCurrentIndexChange = onCurrentIndexChange;
    this.stateMachine.registerStateChangeListener(this, true);
  }

  public onDestroy(): void {
    this.stateMachine.unregisterStateChangeListener(this);
  }

  public onCurrentIndexChange(currentIndex: number): void {
    // this.textModifier.updateConstructorParams(`${this.getCurrentIndex() + 1}/${this.browserController?.dataSource?.realTotalCount()}`);
    this.columnModifier.attribute?.zIndex(this.getCurrentIndex());
    this.swiperModifier.attribute?.index(this.getCurrentIndex());
    this.onViewCurrentIndexChange();
  }

  public onTargetIndexChange(targetIndex: number): void {
  }

  public onPropertiesStateChange(isShowProperties: boolean): void {
  }

  public getCurrentIndex(): number {
    return this.stateMachine.getCurrentIndex();
  }

  public isPropertiesShow(): boolean {
    return this.stateMachine.isPropertiesShow();
  }

  public setCurrentIndex(currentIndex: number): void {
    this.stateMachine.setCurrentIndex(currentIndex);
  }

  public onDeleteStart(): void {
    this.stateMachine.setCurrentState(PhotoBrowserStableState.getInstance());
  }

  public onStable(): void {
  }

  public isOnSwiperAnimation(): boolean {
    return this.stateMachine.isOnSwiperAnimation();
  }

  public setPropertiesState(isShowProperties: boolean): void {
    this.stateMachine.setPropertiesState(isShowProperties);
  }

  public processDeleteStartEvent(): void {
    this.stateMachine.processDeleteStartEvent();
  }

  public processDeleteEndEvent(): void {
    this.stateMachine.processDeleteEndEvent();
  }

  public processSwiperAnimationStartEvent(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void {
    this.stateMachine.processSwiperAnimationStartEvent(index, targetIndex, extraInfo);
  }

  public processSwiperAnimationEndEvent(index: number, extraInfo: SwiperAnimationEvent): void {
    this.stateMachine.processSwiperAnimationEndEvent(index, extraInfo);
  }
}

class SwiperModifier extends AttributeUpdater<SwiperAttribute> {
  applyNormalAttribute(instance: SwiperAttribute) {
  }
}

class TextModifier extends AttributeUpdater<TextAttribute, TextInterface> {
  applyNormalAttribute(instance: TextAttribute) {
  }
}

class ColumnModifier extends AttributeUpdater<ColumnAttribute> {
  initializeModifier(instance: ColumnAttribute): void {
    instance;
  }
}