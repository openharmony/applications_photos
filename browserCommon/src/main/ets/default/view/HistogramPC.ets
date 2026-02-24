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
import lazy { HistogramManager, HistogramStatus } from '@ohos/common/src/main/ets/default/model/common/HistogramManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';

const TAG = 'HistogramPC';

/**
 * 直方图绘制组件
 */
@Component
export struct HistogramPC {
  @StorageLink('HistogramReadyStatus') @Watch('statusReady') status: number = HistogramStatus.PREPARING;
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  // 上下文
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private histogramManager: HistogramManager = new HistogramManager();
  @Link item: MediaItem;
  @Consume @Watch('onCurrentIndexChange') currentIndex: number;
  @LocalStorageLink('pcHistogramNextItem') @Watch('onChangeItem') histogramNextItem: MediaItem = new MediaItem();
  isDataPrepare: Boolean = false;
  lastUniqueId: string = '';
  // image组件完成渲染后的宽高
  @LocalStorageLink('pcImageCompleteWidth') imageCompleteWidth: number | undefined = 0;
  @LocalStorageLink('pcImageCompleteHeight') imageCompleteHeight: number | undefined = 0;

  /**
   * 滑动、删除、隐藏等动作前先准备数据
   */
  onChangeItem(): void {
    this.histogramManager.clear();
    this.isDataPrepare = true;
    Log.info(TAG, `Histogram.onChangeItem ${this.histogramNextItem.uri}, check ${this.item.uri}`);
    this.histogramManager.dataPrepare(this.histogramNextItem, this.imageCompleteWidth, this.imageCompleteHeight);
  }

  /**
   * 直方图刷新回调,刷新当前图片直方图
   */
  onCurrentIndexChange(): void {
    let listCardWidth: number =
      Constants.SPLIT_LIST_CARD_WIDTH - Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    let width = listCardWidth - Constants.COLUMN_PADDING * 2;
    Log.info(TAG, `Histogram.statusReady, start draw histogram getWinMode: ${getScreen()
      .getWinMode()}, Width: ${width}, Height ${Constants.HISTOGRAM_HEIGHT}`);
    this.histogramManager
      .setWidth(width)
      .setHeight(Constants.HISTOGRAM_HEIGHT)
      .startDraw();
  }

  aboutToAppear() {
    TraceControllerUtils.startTrace('HistogramAboutToAppear');
    this.histogramManager.setCallback((): void => this.statusReady());
    this.histogramManager.setContext(this.context);
    this.lastUniqueId = this.item?.uniqueId;
  }

  aboutToDisappear() {
    Log.info(TAG, 'histogram aboutToDisappear, ready status reset');
    AppStorage.setOrCreate<number>(Constants.HISTOGRAM_READY_STATUS_KEY, HistogramStatus.PREPARING);
    this.histogramManager.clear();
  }

  /**
   * TaskPool统计完毕后，触发页面更新，开始绘制
   */
  statusReady(): void {
    let listCardWidth: number =
      Constants.SPLIT_LIST_CARD_WIDTH - Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    let width = listCardWidth - Constants.COLUMN_PADDING * 2;
    Log.info(TAG, `Histogram.statusReady, start draw histogram getWinMode: ${getScreen()
      .getWinMode()}, Width: ${width}, Height ${Constants.HISTOGRAM_HEIGHT}`);
    this.histogramManager
      .setWidth(width)
      .setHeight(Constants.HISTOGRAM_HEIGHT)
      .startDraw();
    TraceControllerUtils.finishTrace('HistogramAboutToAppear');
  }

  build() {
    Canvas(this.context)
      .width(Constants.SPLIT_LIST_CARD_WIDTH - Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN -
        Constants.COLUMN_PADDING * 2)
      .height(Constants.HISTOGRAM_HEIGHT)
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .onReady((): void => {
        this.histogramManager.setDrawFinished(false);
        // 直方图刷新回调,上画当前图片，刷新直方图
        this.histogramManager.dataPrepare(this.item, this.imageCompleteWidth, this.imageCompleteHeight);
      })
  }
}