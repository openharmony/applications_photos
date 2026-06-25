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

import lazy { Log } from '../../utils/Log';
import lazy { Constants } from './Constants';
import lazy { ImageUtil } from '../../utils/ImageUtil';
import type image from '@ohos.multimedia.image';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy taskpool from '@ohos.taskpool';
import type { MediaItem } from '../browser/photo/MediaItem';
import type { PhotoAsset } from '../../access/PhotoAccessHelperAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';

/* instrument ignore file */
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

// taskpool执行的任务
function histogramStatisticTask(arrayBuffer: ArrayBuffer): ArrayBuffer {
  'use concurrent';
  let pixelArray: Uint8Array = new Uint8Array(arrayBuffer);
  const CHANNEL_NUMBER: number = 3;
  let result: Uint32Array = new Uint32Array(Constants.PIXEL_NUMBER * CHANNEL_NUMBER);

  const RGBA_LENGTH: number = 4;
  for (let i = 0, len = pixelArray.length; i < len; i += RGBA_LENGTH) {
    result[pixelArray[i]]++;
    result[pixelArray[i + 1] + Constants.HISTOGRAM_CONSTANT_256]++;
    result[pixelArray[i + 2] + Constants.HISTOGRAM_CONSTANT_512]++;
  }

  // 平滑处理，SMOOTH越大，平滑度越高
  const RGB_LENGTH = 3;
  let smoothResult: Uint32Array = new Uint32Array(Constants.PIXEL_NUMBER * CHANNEL_NUMBER);
  const SMOOTH = 4;
  const HALF_SMOOTH = SMOOTH / 2;
  for (let channelIndex = 0; channelIndex < RGB_LENGTH; channelIndex++) {
    let channelStartIndex = channelIndex * Constants.PIXEL_NUMBER;
    let channelEndIndex = (channelIndex + 1) * Constants.PIXEL_NUMBER;
    let start = channelStartIndex + HALF_SMOOTH;
    let end = channelEndIndex - HALF_SMOOTH;
    for (let index = channelStartIndex; index < start; index++) {
      smoothResult[index] = result[index];
    }
    for (let index = start; index < end; index++) {
      let sum: number = 0;
      // 在[index-smoothParam/2, index+smoothParam/2]范围内取均值
      for (let offset = -HALF_SMOOTH; offset < HALF_SMOOTH; offset++) {
        sum += result[index + offset];
      }
      sum /= SMOOTH;
      smoothResult[index] = Math.ceil(sum);
    }
    for (let index = end; index < channelEndIndex; index++) {
      smoothResult[index] = result[index];
    }
  }
  return smoothResult.buffer as ArrayBuffer;
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
  private width: number = 0;
  private height: number = 0;
  private context: CanvasRenderingContext2D | null = null;
  private pixelArray: Uint32Array = new Uint32Array(Constants.PIXEL_NUMBER * Constants.RGB_CHANNELS);
  private startTime: number = 0;
  private endTime: number = 0;
  private drawFinished: boolean = false;
  private taskArray: taskpool.Task[] = [];
  public callback: Function = (): void => {
  };

  public getContext(): CanvasRenderingContext2D | null {
    return this.context;
  }

  public setContext(ctx: CanvasRenderingContext2D): HistogramManager {
    this.context = ctx;
    this.context.lineWidth = Constants.HISTOGRAM_LINE_WIDTH;
    return this;
  }

  public clear(): void {
    Log.info(TAG, 'clear context and pixel array');
    this.clearTaskPool();
    this.context?.clearRect(0, 0, this.width, this.height);
    this.pixelArray = new Uint32Array(Constants.PIXEL_NUMBER * Constants.RGB_CHANNELS);
    this.startTime = 0;
    this.endTime = 0;
    this.drawFinished = false;
  }

  public setWidth(width: number): HistogramManager {
    this.width = width;
    return this;
  }

  public getWidth(): number {
    return this.width;
  }

  public setDrawFinished(drawFinished: boolean): void {
    this.drawFinished = drawFinished;
  }

  public getStatus(): boolean {
    return this.drawFinished;
  }

  public setHeight(height: number): HistogramManager {
    this.height = height;
    return this;
  }

  /**
   * 图像解码，读取pixel map存入ArrayBuffer
   * @param mediaItem
   */
  public async extractPixels(item: MediaItem, imageCompleteWidth?: number, imageCompleteHeight?: number):
    Promise<ArrayBuffer | undefined> {
    TraceControllerUtils.startTrace('extractPixels');
    this.startTime = Date.now();
    Log.info(TAG, `extract pixels, start time: ${this.startTime}` + item?.uri);
    let fileAsset: PhotoAsset = item.data as PhotoAsset;
    if (!fileAsset) {
      Log.error(TAG, 'get file asset failed.');
      return undefined;
    }
    let size: image.Size = {
      width: fileAsset.get(photoAccessHelper.PhotoKeys.WIDTH.toString()) as number,
      height: fileAsset.get(photoAccessHelper.PhotoKeys.HEIGHT.toString()) as number,
    };
    // 修改size到option采样尺寸
    ImageUtil.getScreenNailSize(size);
    let pixelMap: image.PixelMap = await fileAsset.getThumbnail(size);
    if (!pixelMap) {
      Log.error(TAG, 'get pixel map failed');
      return undefined;
    }
    Log.info(TAG, 'create pixel map success');
    let pixelBuffer: ArrayBuffer | undefined = undefined;
    await pixelMap.getImageInfo().then((imageInfo: image.ImageInfo) => {
      Log.info(TAG, `image info get from pixelmap: ${JSON.stringify(imageInfo)}`);
      pixelBuffer =
        new ArrayBuffer(imageInfo.size.height * imageInfo.size.width * Constants.RGBA_CHANNELS) as ArrayBuffer;
    });
    Log.debug(TAG, 'read pixels to arraybuffer start');
    await pixelMap.readPixelsToBuffer(pixelBuffer);
    Log.debug(TAG, 'read pixels to arraybuffer end');
    pixelMap.release();
    TraceControllerUtils.finishTrace('extractPixels');
    return pixelBuffer;
  }

  public setCallback(callback: Function): void {
    this.callback = callback;
  }

  /**
   * 直方图数据准备，利用TaskPool执行耗时操作
   * @param itemId
   * @param mediaType
   */
  public async dataPrepare(item: MediaItem, imageCompleteWidth?: number, imageCompleteHeight?: number): Promise<void> {
    if (!item) {
      Log.error(TAG, 'data is empty!');
      return;
    }
    Log.info(TAG, 'photo detail, histogram start processing');
    let pixelBuffer = await this.extractPixels(item, imageCompleteWidth, imageCompleteHeight);
    if (!pixelBuffer) {
      return;
    }

    // TaskPool容量，建议设置为3个 注：TaskPool扩容一般是2个为单位，默认开启1个，数量大概率是奇数 1->3->5->7
    const TASK_POOL_CAPACITY: number = 3;

    // RGBA通道数
    const RGBA_LENGTH: number = 4;

    // 以RGBA为一组，pixelBuffer所能分的组数
    const groupCount = pixelBuffer.byteLength / RGBA_LENGTH;

    // 一个task需要处理的byte个数，可能不被整除
    const byteLengthOfTask = Math.floor(groupCount / TASK_POOL_CAPACITY) * RGBA_LENGTH;

    this.clearTaskPool();
    // task数组
    let taskVector: Promise<Function>[] = [];
    for (let i = 0; i < TASK_POOL_CAPACITY; i++) {
      let dataSlice = (i === TASK_POOL_CAPACITY - 1) ? pixelBuffer.slice(i * byteLengthOfTask) : pixelBuffer.slice(
        i * byteLengthOfTask, (i + 1) * byteLengthOfTask);
      Log.info(TAG, `dataSlice_${i} length ${dataSlice.byteLength}`);
      // 往task数组里放异步任务
      let task = new taskpool.Task(histogramStatisticTask, dataSlice);
      this.taskArray.push(task);
      taskVector.push(taskpool.execute(task) as Promise<Function>);
    }

    // promise执行，汇总结果
    Promise.all<Promise<Function>>(taskVector).then((values: Object[]): void | Promise<void> => {
      for (let i = 0; i < values.length; i++) {
        let channelArray = new Uint32Array(values[i] as ArrayBufferLike);
        this.pixelArray = this.pixelArray.map((value: number, index: number): number => {
          return value + channelArray[index];
        });
      }
      Log.info(TAG, 'histogram taskpool data process finished');
      this.callback();
    }).catch((err: Error) => {
      Log.info(TAG, `histogram taskpool data process failed ${err}`);
    });
  }

  private clearTaskPool(): void {
    this.taskArray.forEach((task: taskpool.Task): void => {
      try {
        taskpool.cancel(task);
      } catch (e) {
        Log.info(TAG, `histogram taskpool: cancel error code: ${e.code}, info: ${e.message}`);
      }
    })
    this.taskArray.splice(0, this.taskArray.length);
  }

  /**
   * 直方图绘制
   */
  public startDraw(): void {
    Log.info(TAG, 'data prepare finished, start draw histogram');
    TraceControllerUtils.startTrace('startDraw');
    const startIndex = 0;
    if (this.context) {
      this.context.globalCompositeOperation = 'lighter';
    }
    if (this.pixelArray) {
      this.drawSingleHistogram(this.pixelArray.slice(startIndex,
        Constants.HISTOGRAM_CONSTANT_256), Constants.HISTOGRAM_RED_FILL_COLOR);
      this.drawSingleHistogram(this.pixelArray.slice(Constants.HISTOGRAM_CONSTANT_256,
        Constants.HISTOGRAM_CONSTANT_512), Constants.HISTOGRAM_GREEN_FILL_COLOR);
      this.drawSingleHistogram(this.pixelArray.slice(Constants.HISTOGRAM_CONSTANT_512),
        Constants.HISTOGRAM_BLUE_FILL_COLOR);
    } else {
      Log.error(TAG, 'draw histogram error: pixel array is null.');
    }
    this.internalStroke();
    this.endTime = Date.now();
    this.drawFinished = true;
    TraceControllerUtils.finishTrace('startDraw');
    Log.info(TAG, 'histogram time cost: ' + (this.endTime - this.startTime) + 'ms');
  }

  /**
   * 单通道直方图绘制
   * @param array
   * @param color
   */
  private drawSingleHistogram(array: Uint32Array, color: string): void {
    let width = this.width;
    let height = this.height;
    const START_AXIS: number = 0;
    let peakPoint: number = Math.max(...array);
    if (peakPoint === 0) {
      Log.warn(TAG, 'peakPoint is zero');
      return;
    }
    let xStep = width / Constants.PIXEL_NUMBER;
    let yStep = height / peakPoint;
    let region = new Path2D();
    // 移动到起始位置
    region.moveTo(START_AXIS, height);
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
    region.lineTo(START_AXIS, height); // 回到原点，形成闭包
    region.closePath();

    if (!this.context) {
      return;
    }

    // 线条颜色
    this.context.strokeStyle = Constants.HISTOGRAM_REGION_STROKE_COLOR;
    this.context.stroke(region);

    // 闭包填充颜色
    this.context.fillStyle = color;
    this.context.fill(region, 'nonzero');
    Log.info(TAG, 'draw Single Histogram done');
  }

  /**
   * 边框和内部描边
   */
  private internalStroke(): void {
    if (!this.context) {
      return;
    }
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
    this.context.lineWidth = Constants.HISTOGRAM_STROKE_WIDTH / 2;
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