/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { HistogramManager, HistogramStatus } from '../model/common/HistogramManager';
import { Log } from '../utils/Log';
import { Constants } from '../model/common/Constants';
import { WorkerThreadPool } from '../model/common/WorkerThreadPool';
import { TraceControllerUtils } from '../utils/TraceControllerUtils';

const TAG = 'Histogram'

@Component
export struct Histogram {
  @StorageLink('HistogramReadyStatus') @Watch('statusReady') status: number = HistogramStatus.PREPARING;
  @Consume @Watch('adjustLayout') listCardWidth: number;
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);

  aboutToAppear() {
    Log.info(TAG, 'histogram aboutToAppear');
    TraceControllerUtils.startTrace('HistogramAboutToAppear');
  }

  aboutToDisappear() {
    Log.info(TAG, 'histogram aboutToDisappear, ready status reset');
    AppStorage.setOrCreate<number>(Constants.HISTOGRAM_READY_STATUS_KEY, HistogramStatus.PREPARING);
    HistogramManager.getInstance().clear();
    WorkerThreadPool.getInstance().stop();
  }

  /**
   * 适配pc屏幕大小变化，以及phone横竖屏
   */
  adjustLayout() {
    Log.info(TAG, 'histogram adjustLayout');
    HistogramManager.getInstance()
      .setWidth(this.listCardWidth - Constants.COLUMN_PADDING * Constants.NUMBER_2)
      .startDraw();
  }

  /**
   * worker统计完毕后，触发页面更新，开始绘制
   */
  statusReady() {
    if (this.status !== HistogramStatus.READY) {
      Log.info(TAG, 'status changed, but not ready');
      return;
    }
    Log.info(TAG, 'statusReady, start draw histogram');
    HistogramManager.getInstance()
      .setWidth(this.listCardWidth - Constants.COLUMN_PADDING * Constants.NUMBER_2)
      .setHeight(Constants.HISTOGRAM_HEIGHT)
      .setContext(this.context)
      .startDraw();
    this.status = HistogramStatus.LOADING_FINISHED;
    TraceControllerUtils.finishTrace('HistogramAboutToAppear');
  }

  build() {
    Canvas(this.context)
      .width(this.listCardWidth - Constants.COLUMN_PADDING * Constants.NUMBER_2)
      .height(Constants.HISTOGRAM_HEIGHT)
      .backgroundColor($r('app.color.histogram_background_light'))
      .onReady(() => {
        // 手机横竖屏时偶现直方图不显示，重新绘制放在onReady中可以解决
        if (this.status === HistogramStatus.LOADING_FINISHED) {
          Log.info(TAG, 'histogram adjustLayout');
          HistogramManager.getInstance()
            .setWidth(this.listCardWidth - Constants.COLUMN_PADDING * Constants.NUMBER_2)
            .startDraw();
        }
      })
  }
}