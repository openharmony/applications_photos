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

import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { HistogramManager, HistogramStatus } from '@ohos/common/src/main/ets/default/model/common/HistogramManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { getScreen, WindowMode } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy window from '@ohos.window';
/* instrument ignore file  */
import lazy {
  ViewStateChangeListener
} from '../viewModel/statemachine/IPhotoBrowserState';
import lazy {
  PhotoBrowserStateMachine
} from '../viewModel/statemachine/PhotoBrowserStateMachine';

const TAG = 'Histogram';

/**
 * 直方图绘制组件
 */
@Component
export struct Histogram {
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @StorageLink('HistogramReadyStatus') @Watch('statusReady') status: number = HistogramStatus.PREPARING;
  @Consume listCardWidth: number;
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private histogramManager: HistogramManager = new HistogramManager();
  @Link item: MediaItem;
  // 当前index
  @Consume @Watch('onChangeItem') histogramNextItem: MediaItem;
  @Consume mPosition: number;
  @StorageLink('windowStatus') windowStatus: number | undefined = undefined;
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  public histogramWidth: number = 272;
  public isCanvasReady: boolean = false;
  public isDataPrepare: Boolean = false;
  public lastUniqueId: string = '';
  // image组件完成渲染后的宽高
  private imageCompleteWidth: number | undefined = 0;
  private imageCompleteHeight: number | undefined = 0;
  private onCurrentIndexChanged = () => {
    this.onCurrentIndexChange();
  }

  private onTargetIndexChange = () => {

  }

  private viewStateChangeListener: ViewStateChangeListener =
    new ViewStateChangeListener(this.onCurrentIndexChanged, this.onTargetIndexChange);

  /**
   * 直方图刷新回调,刷新下一张图片直方图
   */
  /* instrument ignore next */
  onChangeItem(): void {
    if (this.histogramNextItem.uri === this.item.uri && !this.histogramManager.getStatus()) {
      this.isDataPrepare = true;
      Log.info(TAG, `Histogram.onChangeItem ${this.histogramNextItem.uri}, check ${this.item.uri}`);
      this.histogramManager.dataPrepare(this.item, this.imageCompleteWidth, this.imageCompleteHeight);
    }
  }

  /**
   * 直方图刷新回调,刷新当前图片直方图，在快滑的情况下,对onChangeItem进行补充
   */
  /* instrument ignore next */
  onCurrentIndexChange(): void {
    if (this.stateMachine.getCurrentIndex() === this.mPosition &&
      !this.isDataPrepare && !this.histogramManager.getStatus()) {
      Log.info(TAG, `Histogram.onCurrentIndexChange item.uri ${
      this.item.uri}, currentIndex: ${this.stateMachine.getCurrentIndex()} ,mPosition: ${this.mPosition}`);
      this.histogramManager.dataPrepare(this.item, this.imageCompleteWidth, this.imageCompleteHeight);
    }
  }

  aboutToAppear() {
    Log.info(TAG, 'histogram aboutToAppear');
    TraceControllerUtils.startTrace('HistogramAboutToAppear');
    this.histogramManager.setCallback((): void => this.statusReady());
    this.histogramManager.setContext(this.context);
    this.lastUniqueId = this.item?.uniqueId;
    this.stateMachine.registerStateChangeListener(this.viewStateChangeListener);
    TraceControllerUtils.finishTrace('HistogramAboutToAppear');
  }

  aboutToDisappear() {
    Log.info(TAG, 'histogram aboutToDisappear, ready status reset');
    AppStorage.setOrCreate<number>(Constants.HISTOGRAM_READY_STATUS_KEY, HistogramStatus.PREPARING);
    this.histogramManager.setCallback((): void => {
    });
    this.stateMachine.unregisterStateChangeListener(this.viewStateChangeListener);
    this.histogramManager.clear();
  }

  /**
   * TaskPool统计完毕后，触发页面更新，开始绘制
   */
  statusReady(): void {
    TraceControllerUtils.startTrace('HistogramStatusReady');
    let width = getScreen().getWinMode() === WindowMode.UNDEFINED &&
      this.windowStatus !== window.WindowStatusType.FLOATING && DeviceInfo.isTablet() ?
      Constants.SPLIT_LIST_CARD_WIDTH - Constants.COLUMN_PADDING * 2 :
      this.listCardWidth - Constants.COLUMN_PADDING * 2;
    Log.info(TAG, `Histogram.statusReady, start draw histogram uri: ${this.item?.uri}`);
    Log.info(TAG, `Histogram.statusReady, start draw histogram isTablet: ${DeviceInfo.isTablet()}, Width: ${width}, Height ${Constants.HISTOGRAM_HEIGHT}`);
    this.histogramManager
      .setWidth(width)
      .setHeight(Constants.HISTOGRAM_HEIGHT)
      .startDraw();
    TraceControllerUtils.finishTrace('HistogramStatusReady');
  }

  build() {
    Canvas(this.context)
      .key('histogram')
      .width(getScreen().getWinMode() === WindowMode.UNDEFINED &&
          this.windowStatus !== window.WindowStatusType.FLOATING && DeviceInfo.isTablet() ?
          Constants.SPLIT_LIST_CARD_WIDTH - Constants.COLUMN_PADDING * 2 :
          this.listCardWidth - Constants.COLUMN_PADDING * 2)
      .height(Constants.HISTOGRAM_HEIGHT)
      .backgroundColor(this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
        'rgba(255,255,255,0.03)' :
        'rgba(0,0,0,0.03)')
      .onReady((): void => {
        this.isCanvasReady = true;
        this.histogramManager.setDrawFinished(false);
        Log.info(TAG, `Histogram.build item.uri ${this.item.uri}, targetIndex: ${
        this.stateMachine.getTargetIndex()} ,mPosition: ${this.mPosition}`);
        if (this.stateMachine.getTargetIndex() === this.mPosition) {
          // targetIndex会在onAnimationStart的时候就更新，而currentIndex在onChange的时候才更新。
          // 如果用户左右切换后快速点击详情，currentIndex可能还未更新，会导致此处直方图更新对象错误
          // 直方图刷新回调,上画当前图片，刷新直方图
          this.histogramManager.dataPrepare(this.item, this.imageCompleteWidth, this.imageCompleteHeight);
        }
      })
  }
}