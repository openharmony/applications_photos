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

import { StringUtil } from '../../utils/StringUtil';
import { Log } from '../../utils/Log';
import { Constants } from './Constants'
import { ImageUtil } from '../../utils/ImageUtil';
import userFileManager from '@ohos.filemanagement.userFileManager';
import image from '@ohos.multimedia.image';
import { BrowserDataFactory } from '../../interface/BrowserDataFactory';
import { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import { WorkerThreadPool } from './WorkerThreadPool';
import { MessageEvents } from '@ohos.worker';

const TAG = 'HistogramManager';

/**
 * PREPARING: 直方图数据准备中
 * READY: 直方图数据准备完毕，可以开始绘制
 */
export enum HistogramStatus {
  PREPARING,
  READY,
  LOADING_FINISHED
}

/**
 * 直方图工具类
 *
 * 步骤：
 * 1、使用前必须初始化三个属性: context, width, height
 * 2、startDraw() 开始执行绘制
 * 3、使用完毕，需要执行clear()清空绘制内容
 *
 */
export class HistogramManager {
  private static histogramManagerInstance: HistogramManager;
  private width: number;
  private height: number;
  private context: CanvasRenderingContext2D = undefined;
  private pixelArray: Uint32Array;
  private startTime: number;
  private endTime: number;

  private constructor() {
  }

  public static getInstance(): HistogramManager {
    if (!this.histogramManagerInstance) {
      Log.info(TAG, 'instance create');
      this.histogramManagerInstance = new HistogramManager();
    }
    return this.histogramManagerInstance;
  }

  public getContext(): CanvasRenderingContext2D {
    return this.context;
  }

  public setContext(ctx: CanvasRenderingContext2D): HistogramManager {
    this.context = ctx;
    this.context.globalCompositeOperation = 'lighter'
    this.context.lineWidth = Constants.HISTOGRAM_LINE_WIDTH;
    return this;
  }

  public clear(): void {
    Log.info(TAG, 'clear context and pixel array');
    this.context && this.context.clearRect(0, 0, this.width, this.height);
    this.pixelArray = undefined;
    this.startTime = 0;
    this.endTime = 0;
  }

  public setWidth(width: number): HistogramManager {
    this.width = width;
    return this;
  }

  public getWidth(): number {
    return this.width;
  }

  public setHeight(height: number): HistogramManager {
    this.height = height;
    return this;
  }

  /**
   * 图像解码，读取pixel map存入ArrayBuffer
   * @param mediaItem
   */
  public async extractPixels(uri: string): Promise<ArrayBuffer> {
    TraceControllerUtils.startTrace('extractPixels');
    this.startTime = Date.now();
    Log.info(TAG, 'extract pixels, start time: ' + this.startTime);
    let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
    let fileAsset: userFileManager.FileAsset = await dataImpl.getDataByUri(uri);
    if (!fileAsset) {
      Log.error(TAG, 'get file asset failed.');
      return null;
    }
    let size: image.Size = {
      width: fileAsset.get(userFileManager.ImageVideoKey.WIDTH.toString()) as number,
      height: fileAsset.get(userFileManager.ImageVideoKey.HEIGHT.toString()) as number
    }
    // 修改size到option采样尺寸
    ImageUtil.getScreenNailSize(size);
    let pixelMap: PixelMap = await fileAsset.getThumbnail(size);
    if (!pixelMap) {
      Log.error(TAG, 'get pixel map failed');
      return null;
    }
    Log.debug(TAG, 'create pixel map success');
    let pixelBuffer: ArrayBuffer;
    await pixelMap.getImageInfo().then((imageInfo) => {
      Log.info(TAG, `image info get from pixelmap: ${JSON.stringify(imageInfo)}`);
      pixelBuffer = new ArrayBuffer(imageInfo.size.height * imageInfo.size.width * Constants.RGBA_CHANNELS);
    });
    Log.debug(TAG, 'read pixels to arraybuffer start');
    await pixelMap.readPixelsToBuffer(pixelBuffer);
    Log.debug(TAG, 'read pixels to arraybuffer end');
    pixelMap.release();
    TraceControllerUtils.finishTrace('extractPixels');
    return pixelBuffer;
  }

  /**
   * 直方图数据准备，利用worker执行耗时操作
   * @param itemId
   * @param mediaType
   */
  async dataPrepare(uri: string): Promise<void> {
    Log.info(TAG, 'photo detail, histogram start processing');
    let pixelBuffer = await this.extractPixels(uri);
    TraceControllerUtils.startTrace('dataPrepare');
    let resultArray = new Uint32Array(Constants.PIXEL_NUMBER * Constants.RGB_CHANNELS);
    let counter = WorkerThreadPool.CAPACITY;

    // 定义worker主线程回调函数
    let mainThreadCallback = function (e: MessageEvents, name: string): void {
      Log.info(TAG, 'histogram main thread onMessage, received from ' + name);
      let arrayBuffer: ArrayBuffer = e.data;
      let channelArray = new Uint32Array(arrayBuffer);
      // 三通道计算结果累加
      resultArray = resultArray.map(function (value, index): number {
        return value + channelArray[index];
      })
      Log.info(TAG, `multiworker ${name} array byteLength ${resultArray.byteLength}`);
      counter--;
      if (counter == Constants.NUMBER_0) {
        TraceControllerUtils.finishTrace('dataPrepare');
        Log.info(TAG, `histogram workers data process finished`);
        // 重置status，防止被上次任务回调干扰
        AppStorage.setOrCreate<number>(Constants.HISTOGRAM_READY_STATUS_KEY, HistogramStatus.PREPARING);
        // arrayBuffer直接传入，会丢失类型，需要转为string
        Log.info(TAG, 'serialize the pixel array for histogram draw, pixel array length: ' + resultArray.length);
        AppStorage.setOrCreate<string>(Constants.HISTOGRAM_ARRAY_BUFFER_KEY,
          StringUtil.arraybufferSerialize(resultArray.buffer));
        AppStorage.setOrCreate<number>(Constants.HISTOGRAM_READY_STATUS_KEY, HistogramStatus.READY);
      }
    }

    let workerPath = '/ets/workers/HistogramWorker.ts';
    WorkerThreadPool.getInstance().run(workerPath, pixelBuffer, Constants.RGBA_CHANNELS, mainThreadCallback);
  }

  /**
   * 直方图绘制
   */
  public startDraw(): void {
    Log.info(TAG, 'data prepare finished, start draw histogram');
    TraceControllerUtils.startTrace('startDraw');
    this.initializePixelArray();
    const startIndex = 0;
    this.drawSingleHistogram(this.pixelArray.slice(startIndex, Constants.HISTOGRAM_CONSTANT_256),
      Constants.HISTOGRAM_RED_FILL_COLOR);
    this.drawSingleHistogram(this.pixelArray.slice(Constants.HISTOGRAM_CONSTANT_256,
      Constants.HISTOGRAM_CONSTANT_512), Constants.HISTOGRAM_GREEN_FILL_COLOR);
    this.drawSingleHistogram(this.pixelArray.slice(Constants.HISTOGRAM_CONSTANT_512),
      Constants.HISTOGRAM_BLUE_FILL_COLOR);
    this.internalStroke();
    this.endTime = Date.now();
    TraceControllerUtils.finishTrace('startDraw');
    Log.info(TAG, 'histogram time cost: ' + (this.endTime - this.startTime) + 'ms');
  }

  /**
   * 接收worker返回的数据
   */
  private initializePixelArray(): void {
    Log.info(TAG, 'get pixel array by deserialize');
    let serializedBuffer = AppStorage.get<string>(Constants.HISTOGRAM_ARRAY_BUFFER_KEY);
    if (!serializedBuffer) {
      Log.error(TAG, 'initializePixelArray: serializedBuffer is undefined');
      return;
    }
    // 反序列化
    let arrayBuffer: ArrayBuffer = StringUtil.arraybufferDeserialize(serializedBuffer);
    this.pixelArray = new Uint32Array(arrayBuffer);
    Log.info(TAG, 'pixel array length: ' + this.pixelArray.length);
  }

  /**
   * 单通道直方图绘制
   * @param array
   * @param color
   */
  private drawSingleHistogram(array: Uint32Array, color: string): void {
    let width = this.width;
    let height = this.height;
    const startAxis: number = 0;
    let peakPoint: number = Math.max(...array);
    if (peakPoint === 0) {
      Log.warn(TAG, 'peakPoint is zero');
      return;
    }
    let xStep = width / Constants.PIXEL_NUMBER;
    let yStep = height / peakPoint;
    let region = new Path2D();
    // 移动到起始位置
    region.moveTo(start_axis, height);
    let last = 0;
    for (let pixelValue = 0; pixelValue < array.length; pixelValue++) {
      let v1 = pixelValue * xStep;
      let v2 = yStep * array[pixelValue];
      let value = height - v2;
      region.lineTo(v1, value);
      last = v1;
    }
    region.lineTo(last, height);
    region.lineTo(width, height);
    region.lineTo(start_axis, height); // 回到原点，形成闭包
    region.closePath();

    // 线条颜色
    this.context.strokeStyle = Constants.HISTOGRAM_REGION_STROKE_COLOR;
    this.context.stroke(region);

    // 闭包填充颜色
    this.context.fillStyle = color;
    this.context.fill(region, 'nonzero');
  }

  /**
   * 边框和内部描边
   */
  private internalStroke(): void {
    // 恢复叠加模式到初始值，避免叠加导致边框和线条被填充色掩盖
    this.context.globalCompositeOperation = 'source-over';
    // 绘制边框
    this.context.strokeStyle = Constants.HISTOGRAM_INTERNAL_STROKE_COLOR;
    this.context.lineWidth = Constants.HISTOGRAM_STROKE_WIDTH;
    let rectStartX: number = 0;
    let rectStartY: number = 0;
    this.context.strokeRect(rectStartX, rectStartY, this.width, this.height);

    // 竖直两个线条
    this.context.beginPath();
    this.context.strokeStyle = Constants.HISTOGRAM_INTERNAL_STROKE_COLOR;
    // stroke线条实际宽度被边缘裁切一半，线条宽度要除以2与其保持一致
    this.context.lineWidth = Constants.HISTOGRAM_STROKE_WIDTH / Constants.NUMBER_2;
    let lineStartY: number = 0;
    this.context.moveTo(this.width / Constants.HISTOGRAM_DIVIDER_REGION_NUM, lineStartY);
    this.context.lineTo(this.width / Constants.HISTOGRAM_DIVIDER_REGION_NUM, this.height);
    this.context.stroke();

    this.context.beginPath();
    this.context.strokeStyle = Constants.HISTOGRAM_INTERNAL_STROKE_COLOR;
    this.context.moveTo(this.width * Constants.HISTOGRAM_DIVIDE_LINE_NUM /
    Constants.HISTOGRAM_DIVIDER_REGION_NUM, lineStartY);
    this.context.lineTo(this.width * Constants.HISTOGRAM_DIVIDE_LINE_NUM /
    Constants.HISTOGRAM_DIVIDER_REGION_NUM, this.height);
    this.context.stroke();
  }
}