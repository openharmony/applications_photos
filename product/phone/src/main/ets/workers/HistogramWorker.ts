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

import { Constants, Log } from '@ohos/common';
import type { ErrorEvent, MessageEvents } from '@ohos.worker';
import worker from '@ohos.worker';

const TAG = 'HistogramWorker';
const workerPort = worker.workerPort;


/**
 * 直方图像素统计，RGBA每四个值为一组进行统计
 */
workerPort.onmessage = function (e: MessageEvents): void {
  let buffer: ArrayBuffer = e.data;
  let pixelArray: Uint8Array = new Uint8Array(buffer);
  Log.info(TAG, `start process, pixelArray length ${pixelArray.length}`);

  let result: Uint32Array = new Uint32Array(Constants.PIXEL_NUMBER * Constants.RGB_CHANNELS);

  for (let i = Constants.NUMBER_0, len = pixelArray.length; i < len; i += Constants.RGBA_CHANNELS) {
    result[pixelArray[i]]++;
    result[pixelArray[i + Constants.NUMBER_1] + Constants.HISTOGRAM_CONSTANT_256]++;
    result[pixelArray[i + Constants.NUMBER_2] + Constants.HISTOGRAM_CONSTANT_512]++;
  }

  // 平滑处理，smoothParam越大，平滑度越高
  let smoothResult: Uint32Array = new Uint32Array(Constants.PIXEL_NUMBER * Constants.RGB_CHANNELS);
  let smoothParam = Constants.WORKER_SMOOTH_PARAM;
  if (smoothParam === 0) {
    smoothResult = result;
  } else {
    for (let channelIndex = Constants.NUMBER_0; channelIndex < Constants.RGB_CHANNELS; channelIndex++) {
      let channelStartIndex = channelIndex * Constants.PIXEL_NUMBER;
      let channelEndIndex = (channelIndex + Constants.NUMBER_1) * Constants.PIXEL_NUMBER;
      let start = channelStartIndex + smoothParam / Constants.NUMBER_2;
      let end = channelEndIndex - smoothParam / Constants.NUMBER_2;
      for (let index = channelStartIndex; index < start; index++) {
        smoothResult[index] = result[index];
      }
      for (let index = start; index < end; index++) {
        let sum: number = Constants.NUMBER_0;
        // 在[index-smoothParam/2, index+smoothParam/2]范围内取均值
        for (let offset = Constants.NUMBER_0 - smoothParam / Constants.NUMBER_2; offset < smoothParam / Constants.NUMBER_2; offset++) {
          sum += result[index + offset];
        }
        sum /= smoothParam;
        smoothResult[index] = Math.ceil(sum);
      }
      for (let index = end; index < channelEndIndex; index++) {
        smoothResult[index] = result[index];
      }
    }
  }
  let message = smoothResult.buffer;
  Log.info(TAG, 'worker process finished, back to main thread');
  workerPort.postMessage(message, [message]);
};

workerPort.onerror = function (err: ErrorEvent): void {
  Log.error(TAG, 'workerPort onerror ' + JSON.stringify(err));
};