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

import { Constants } from '../model/browser/photo/Constants';
import { Log } from '../utils/Log';
import { UiUtil } from '../utils/UiUtil';

const TAG = 'BrowserController';

@Observed
export class BrowserController {
  public geometryTransitionEnable: boolean = false;
  public isAnimating: boolean = false;
  public isBrowserShow: boolean = false;
  public browserParam?: Object;
  public browserBackFunc: Function = (): void => {};
  public isSelectBrowserShow: boolean = false;
  public selectBrowserParam?: Object;
  public pageFrom: string = '';

  constructor(isGeometryEnable: boolean) {
    this.geometryTransitionEnable = isGeometryEnable;
  }

  showBrowserWithNoAnimation(param: Object) {
    this.isBrowserShow = true;
    this.browserParam = param;
  }

  showSelectBrowserWithNoAnimation(param: Object) {
    this.isSelectBrowserShow = true;
    this.selectBrowserParam = param;
  }

  showBrowser(geometryIndex: number, geometryString: string, name: string, param: Object) {
    Log.debug(TAG, 'call show browser');
    animateTo({
      curve: Constants.PHOTO_TRANSITION_CURVE,
      duration: Constants.SHARE_TRANSITION_DURATION,
      onFinish: () => {
        this.finishAnimation();
      }
    }, () => {
      UiUtil.resetGeometryTransitionParams();
      UiUtil.updateGeometryTapInfo(geometryIndex, geometryString);
      this.isBrowserShow = true;
      this.pageFrom = name;
      this.browserParam = param;
      this.isAnimating = true;
    });
  }

  hideBrowser(): void {
    Log.debug(TAG, 'call hide browser');
    animateTo({
      curve: Constants.SPRING_MOTION_CURVE, // 大图进出阻尼曲线参数
      onFinish: () => {
        AppStorage.setOrCreate<string>('geometryTransitionBrowserId', '');
        UiUtil.resetGeometryTransitionParams();
        this.finishAnimation();
      }
    }, () => {
      this.isBrowserShow = false;
      this.browserParam;
      this.isAnimating = true;
      AppStorage.setOrCreate<number>('placeholderIndex', -1);
      Log.info(TAG, `placeholderIndex ${AppStorage.get<number>('placeholderIndex')}`);
    });
  }

  showSelectBrowser(geometryIndex: number, geometryString: string, name: string, param: Object) {
    Log.debug(TAG, 'call show select browser');
    animateTo({
      curve: Constants.PHOTO_TRANSITION_CURVE,
      duration: Constants.SHARE_TRANSITION_DURATION,
      onFinish: () => {
        this.finishAnimation();
      }
    }, () => {
      UiUtil.resetGeometryTransitionParams();
      UiUtil.updateGeometryTapInfo(geometryIndex, geometryString);
      this.isSelectBrowserShow = true;
      this.pageFrom = name;
      this.selectBrowserParam = param;
      this.isAnimating = true;
    });
  }

  hideSelectBrowser(): void {
    Log.debug(TAG, 'call hide select browser');
    animateTo({
      curve: Constants.SPRING_MOTION_CURVE, // 大图进出阻尼曲线参数
      onFinish: () => {
        AppStorage.setOrCreate<string>('geometryTransitionBrowserId', '');
        UiUtil.resetGeometryTransitionParams();
        this.finishAnimation();
      }
    }, () => {
      this.isSelectBrowserShow = false;
      this.selectBrowserParam;
      this.isAnimating = true;
      AppStorage.setOrCreate<number>('placeholderIndex', -1);
    });
  }

  finishAnimation() {
    this.isAnimating = false;
  }
}