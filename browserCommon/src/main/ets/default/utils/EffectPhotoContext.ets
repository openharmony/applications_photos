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

import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';

/* instrument ignore file */
const TAG = 'EffectPhotoContext';

const CLOSE_AUTO_PLAY_ACTION_ID = [
  Action.FLASH_CAPTURE.actionID,
  Action.CLOSE_FLASH_CAPTURE.actionID,
  Action.VIRTUAL_APERTURE.actionID,
  Action.CLOSE_VIRTUAL_APERTURE.actionID,
]

/**
 *  XXX照片上下文
 */
export class EffectPhotoContext {
  private uri: string = '';
  private static context: EffectPhotoContext | undefined = undefined;
  private imageUpdateCallback: Function = () => {};
  private effectClick: number | undefined = undefined;
  private isSwitching: boolean = false;

  private constructor() {
  }

  public static getInstance(): EffectPhotoContext {
    if (EffectPhotoContext.context) {
      return EffectPhotoContext.context;
    }

    EffectPhotoContext.context = AppStorage.get<EffectPhotoContext>('EffectPhotoContext');
    if (EffectPhotoContext.context) {
      return EffectPhotoContext.context;
    }

    EffectPhotoContext.context = new EffectPhotoContext();
    AppStorage.setOrCreate('EffectPhotoContext', EffectPhotoContext.context);
    return EffectPhotoContext.context;
  }

  public setIsSwitching(isSwitching: boolean) {
    Log.info(TAG, `setIsSwitching ${this.isSwitching}, url: ${this.uri}`);
    this.isSwitching = isSwitching;
  }

  public getIsSwitching(): boolean {
    return this.isSwitching;
  }

  public setUri(uri: string): EffectPhotoContext {
    Log.info(TAG, `setUri: ${uri}`);
    this.uri = uri;
    return this;
  }

  public getUri(): string {
    Log.info(TAG, `getUri: ${this.uri}`);
    return this.uri;
  }


  /**
   * 设置静图特效切换完毕更新回调
   * @param imageUpdateCallback
   */
  public setImageUpdateCallback(imageUpdateCallback: Function) {
    this.imageUpdateCallback = imageUpdateCallback;
  }

  /**
   *  媒体库通知处理
   * @param changeType 通知类型
   * @param uris 通知的url
   */
  public libraryNotify(changeType: number, uris: string[]): void {
    Log.info(TAG, `libraryNotify libraryNotify libraryNotify start`);
    if (changeType !== photoAccessHelper.NotifyType.NOTIFY_UPDATE) {
      return;
    }
    if (!uris || !uris.length) {
      Log.info(TAG, `libraryNotify current uris is null`);
      return;
    }
    const idx: number = uris.indexOf(this.uri);
    if (idx === -1) {
      Log.info(TAG, `libraryNotify current uri is undefined`);
      return;
    }
    Log.info(TAG, `libraryNotify imageUpdateCallback`);
    this.imageUpdateCallback();
    // 切换刷新后 清空状态
    this.setImageUpdateCallback(() => {});
  }

  public setEffectClick(actionID: number) {
    this.effectClick = actionID;
  }

  public getEffectClick(): number | undefined {
    return this.effectClick;
  }

  public clearContext() {
    Log.info(TAG, `clearContext`);
    this.effectClick = undefined;
  }

  /**
   * 特效切换关闭自动播放
   * @returns
   */
  public isCloseAutoPlay(): boolean {
    if (!this.effectClick) {
      return false;
    }
    return CLOSE_AUTO_PLAY_ACTION_ID.includes(this.effectClick);
  }
}

/**
 *  XXX打点
 */
export class ShotForMoreContext {
  private static context: ShotForMoreContext | undefined = undefined;
  //XXX图片浏览
  private photoType: number = -1;      // 0表示图片 1表示动图
  private virtualAperture: boolean = false;
  private snapShot: boolean = false;
  private pan: boolean = false;
  //XXX效果设置
  private url: string = '';
  private switchClickEffect: string = '';
  private supportEffect: number = -1;
  private switchStartTime: number = 0;
  private switchEndTime: number = 0;
  private result: boolean = false;

  private constructor() {
  }

  public static getInstance(): ShotForMoreContext {
    if (ShotForMoreContext.context) {
      return ShotForMoreContext.context;
    }

    ShotForMoreContext.context = AppStorage.get<ShotForMoreContext>('ShotForMoreContext');
    if (ShotForMoreContext.context) {
      return ShotForMoreContext.context;
    }

    ShotForMoreContext.context = new ShotForMoreContext();
    AppStorage.setOrCreate('ShotForMoreContext', ShotForMoreContext.context);
    return ShotForMoreContext.context;
  }

  public reportBrowser(): void {
    const msg: Record<string, number | string | boolean> = {
      'URL': ReportToBigDataUtil.urlAnonymize(this.url),
      'PHOTO_TYPE': this.photoType,
      'VIRTUAL_APERTURE': this.virtualAperture,
      'SNAPSHOT': this.snapShot,
      'PAN': this.pan,
    }
    ReportToBigDataUtil.report(BigDataConstants.SHOT_FOR_MORE_PHOTO_BROWSER, msg);
  }

  public reportSwitch(): void {
    const msg: Record<string, number | string | boolean> = {
      'URL': ReportToBigDataUtil.urlAnonymize(this.url),
      'PHOTO_TYPE': this.photoType,
      'CLICK_EFFECT': this.switchClickEffect,
      'SUPPORT_EFFECT': this.supportEffect,
      'SWITCH_COST': this.calculateCost(),
      'SWITCH_RESULT': this.result,
    }
    ReportToBigDataUtil.report(BigDataConstants.SHOT_FOR_MORE_PHOTO_SWITCH_COST, msg);
  }

  public setPhotoType(photoType: number): ShotForMoreContext {
    Log.info(TAG, `setPhotoType: ${photoType}`);
    this.photoType = photoType;
    return this;
  }

  public setVirtualAperture(virtualAperture: boolean): ShotForMoreContext {
    Log.info(TAG, `setBrowserVirtualAperture: ${virtualAperture}`);
    this.virtualAperture = virtualAperture;
    return this;
  }

  public setSnapShot(snapShot: boolean): ShotForMoreContext {
    Log.info(TAG, `setBrowserSnapshotEffect: ${snapShot}`);
    this.snapShot = snapShot;
    return this;
  }

  public setPan(pan: boolean): ShotForMoreContext {
    Log.info(TAG, `setPan: ${pan}`);
    this.pan = pan;
    return this;
  }

  public setUrl(url: string): ShotForMoreContext {
    Log.info(TAG, `setSwitchUri: ${url}`);
    this.url = url;
    return this;
  }

  public setSwitchClickEffect(switchClickEffect: string): ShotForMoreContext {
    this.switchClickEffect = switchClickEffect;
    return this;
  }
  public setSupportEffect(supportEffect: number): ShotForMoreContext {
    this.supportEffect = supportEffect;
    return this;
  }

  public setSwitchStartTime(): ShotForMoreContext {
    this.switchStartTime = Date.now();
    return this;
  }

  public setSwitchEndTime(): ShotForMoreContext {
    this.switchEndTime = Date.now();
    return this;
  }

  public setResult(success: boolean): ShotForMoreContext {
    this.result = success;
    return this;
  }

  public calculateCost(): number {
    return this.switchEndTime - this.switchStartTime;
  }

  public clear(): void {
    this.photoType = -1;
    this.virtualAperture = false;
    this.snapShot = false;
    this.pan = false;
    this.url = '';
    this.switchClickEffect = '';
    this.supportEffect = 0;
    this.switchStartTime = 0;
    this.switchEndTime = 0;
  }
}