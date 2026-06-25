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

import lazy mediaQuery from '@ohos.mediaquery';
import lazy { Constants } from '../model/common/Constants';
import lazy { getScreen, WindowMode } from '../model/common/ScreenManager';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { Log } from './Log';

const TAG: string = 'common_BreakPointSystem';

declare interface BreakPointTypeOption<T> {
  xs?: T
  sm?: T
  md?: T
  lg?: T
  xl?: T
  xxl?: T
}

export class BreakPointType<T> {
  options: BreakPointTypeOption<T>;

  constructor(option: BreakPointTypeOption<T>) {
    this.options = option;
  }

  public getValue(currentBreakPoint: string): T | undefined {
    switch (currentBreakPoint) {
      case Constants.BREAKPOINT_XS:
        return this.options.xs as T;
      case Constants.BREAKPOINT_SM:
        return this.options.sm as T;
      case Constants.BREAKPOINT_MD:
        return this.options.md as T;
      case Constants.BREAKPOINT_LG:
        return this.options.lg as T;
      default:
        /* instrument ignore next */
        return undefined;
    }
  }
}

interface Breakpoint {
  name: string;
  size: number;
  mediaQueryListener?: mediaQuery.MediaQueryListener;
}

export class BreakpointSystem {
  private currentBreakpoint: string = Constants.BREAKPOINT_MD;
  private breakpointStorageKey: string = 'currentBreakpoint';
  private breakpoints: Breakpoint[] = [
    { name: Constants.BREAKPOINT_XS, size: Constants.BREAKPOINT_XS_MIN_SIZE },
    { name: Constants.BREAKPOINT_SM, size: Constants.BREAKPOINT_SM_MIN_SIZE },
    { name: Constants.BREAKPOINT_MD, size: Constants.BREAKPOINT_MD_MIN_SIZE },
    { name: Constants.BREAKPOINT_LG, size: Constants.BREAKPOINT_LG_MIN_SIZE }
  ];
  private portraitListener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync('(orientation: portrait)');
  private landscapeListener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync('(orientation: landscape)');

  public register(initialBreakpoint?: string): void {
    if (initialBreakpoint) {
      this.currentBreakpoint = initialBreakpoint;
    }
    this.breakpoints.forEach((breakpoint: Breakpoint, index): void => {
      let breakpointsSql: string;
      if (index === this.breakpoints.length - 1) {
        breakpointsSql = `(${breakpoint.size}` + 'vp<=width' + ')';
      } else {
        breakpointsSql = '(' + breakpoint.size + `vp<=width<${this.breakpoints[index + 1].size}` + 'vp)';
      }
      breakpoint.mediaQueryListener = mediaQuery.matchMediaSync(breakpointsSql);
      breakpoint.mediaQueryListener.on('change', (mediaQueryResult): void => {
        if (mediaQueryResult.matches) {
          this.updateCurrentBreakpoint(breakpoint.name);
        }
      });
    });
  }

  /* instrument ignore next */
  public unregister(): void {
    this.breakpoints.forEach((breakpoint: Breakpoint) => {
      (breakpoint.mediaQueryListener as mediaQuery.MediaQueryListener).off('change');
    });
  }

  public registerOrientationChange(): void {
    Log.info(TAG, 'registerOrientationChange');
    this.landscapeListener.on('change', (mediaQueryResult): void => {
      Log.info(TAG, `current orientation is landscape ${JSON.stringify(mediaQueryResult)}`);
      if (AppStorage.get<boolean>('windowPcmodeSwitchStatus')) {
        return;
      }
      /* instrument ignore if */
      if (mediaQueryResult.matches) {
        /* instrument ignore if */
        if (WindowMode.FULLSCREEN !== getScreen().getWinMode() && !DeviceInfo.isPc()) {
          getScreen().onRotationAngleChanged(false);
        } else {
          getScreen().onRotationAngleChanged(true);
        }
      }
    });

    this.portraitListener.on('change', (mediaQueryResult): void => {
      Log.info(TAG, `current orientation is portrait${JSON.stringify(mediaQueryResult)}`);
      if (AppStorage.get<boolean>('windowPcmodeSwitchStatus')) {
        return;
      }
      // PC暂不涉及横竖屏切换，如果后续有场景可以改此处
      if (mediaQueryResult.matches && !DeviceInfo.isPc()) {
        Log.debug(TAG, `onRotationAngleChanged`);
        getScreen().onRotationAngleChanged(false);
      }
    });
  }

  /* instrument ignore next */
  public unregisterOrientationChange(): void {
    this.landscapeListener.off('change');
    this.portraitListener.off('change');
  }

  private updateCurrentBreakpoint(breakpoint: string): void {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint;
      AppStorage.setOrCreate<string>(this.breakpointStorageKey, this.currentBreakpoint);
      Log.debug(TAG, `on current breakpoint: ${this.currentBreakpoint}`);
    }
  }
}