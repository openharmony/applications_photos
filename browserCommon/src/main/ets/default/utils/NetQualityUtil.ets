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
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { Queue } from '@kit.ArkTS';

const TAG: string = 'videoPlayerNetQuality';

export class NetQualityUtil {
  // private dataQueue?: Queue<netQuality.NetworkQos>;
  private collect: boolean = true;
  private static netQualityUtil?: NetQualityUtil;

  private constructor() {
    // this.dataQueue = new Queue<netQuality.NetworkQos>();
  }

  public static getInstance(): NetQualityUtil {
    if (!NetQualityUtil.netQualityUtil) {
      NetQualityUtil.netQualityUtil = new NetQualityUtil();
    }
    // if (!NetQualityUtil.netQualityUtil.dataQueue) {
    //   NetQualityUtil.netQualityUtil.dataQueue = new Queue<netQuality.NetworkQos>();
    // }
    return NetQualityUtil.netQualityUtil;
  }

  public setCollect(open: boolean): void {
    this.collect = open;
  }

  public netType(): number {
    // if (this.dataQueue && this.dataQueue.length > 0) {
    //   let qos: netQuality.NetworkQos = this.dataQueue.getFirst();
    //   return qos.pathType;
    // }
    return -1;
  }

  public netDownWidthAvg(): number {
    // Log.info(TAG, `netDownWidthAvg nums: ${this.dataQueue?.length}`);
    // if (this.dataQueue && this.dataQueue.length > 0) {
    //   let times: number = this.dataQueue.length;
    //   let total: number = 0;
    //   this.dataQueue.forEach((qos: netQuality.NetworkQos): void => {
    //     total += qos.linkDownBandwidth;
    //   });
    //   return Math.round(total / times);
    // }
    return 0;
  }

  public netDownRateAvg(): number {
    // Log.info(TAG, `netDownRateAvg nums: ${this.dataQueue?.length}`);
    // if (this.dataQueue && this.dataQueue.length > 0) {
    //   let times: number = this.dataQueue.length;
    //   let total: number = 0;
    //   this.dataQueue.forEach((qos: netQuality.NetworkQos): void => {
    //     total += qos.linkDownRate;
    //   });
    //   return Math.round(total / times);
    // }
    return 0;
  }

  public netRttMsAvg(): number {
    // Log.info(TAG, `netRttMsAvg nums: ${this.dataQueue?.length}`);
    // if (this.dataQueue && this.dataQueue.length > 0) {
    //   let times: number = this.dataQueue.length;
    //   let total: number = 0;
    //   this.dataQueue.forEach((qos: netQuality.NetworkQos): void => {
    //     total += qos.rttMs;
    //   });
    //   Log.debug(TAG, `netRttMsAvg total: ${total} times: ${times}`);
    //   return Math.round(total / times);
    // }
    return 0;
  }

  public clearQueue(): void {
    // Log.info(TAG, `clearQueue nums: ${this.dataQueue?.length}`);
    // this.dataQueue = undefined;
  }

  /* instrument ignore next */
  public registerNetQuality(): void {
    try {
      // netQuality.on('netQosChange', (list: netQuality.NetworkQos[]) => {
      //   list.forEach((qos: netQuality.NetworkQos): void => {
      //     // 回调信息处理
      //     Log.info(TAG, `dataQueue add pathType: ${qos.pathType}, linkDownBandwidth: ${
      //     qos.linkDownBandwidth}, linkDownRate: ${qos.linkDownRate}, rttMs: ${qos.rttMs}`);
      //     this.dataQueue?.add(qos);
      //   });
      // });
    } catch (err) {
      Log.error(TAG, `err: ${err}`);
    }
  }

  /* instrument ignore next */
  public unregisterNetQuality(): void {
    try {
      // netQuality.off('netQosChange');
    } catch (err) {
      Log.debug(TAG, `err: ${err}`);
    }
  }
}