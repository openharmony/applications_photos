/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import mediaQuery from '@ohos.mediaquery';
import { Constants } from '../model/common/Constants';
import { ScreenManager } from '../model/common/ScreenManager';
import { Log } from './Log';

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

  getValue(currentBreakPoint: string): T {
    switch (currentBreakPoint) {
      case Constants.BREAKPOINT_XS:
        return this.options.xs;
      case Constants.BREAKPOINT_SM:
        return this.options.sm;
      case Constants.BREAKPOINT_MD:
        return this.options.md;
      case Constants.BREAKPOINT_LG:
        return this.options.lg;
      default:
        return undefined;
    }
  }
}

type Breakpoint = {
  name: string
  size: number
  mediaQueryListener?: mediaQuery.MediaQueryListener
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

  public register(): void {
    this.breakpoints.forEach((breakpoint: Breakpoint, index) => {
      let breakpointsSql;
      if (index === this.breakpoints.length - 1) {
        breakpointsSql = '(' + breakpoint.size + 'vp<=width' + ')';
      } else {
        breakpointsSql = '(' + breakpoint.size + 'vp<=width<' + this.breakpoints[index + 1].size + 'vp)';
      }
      breakpoint.mediaQueryListener = mediaQuery.matchMediaSync(breakpointsSql);
      breakpoint.mediaQueryListener.on('change', (mediaQueryResult) => {
        if (mediaQueryResult.matches) {
          this.updateCurrentBreakpoint(breakpoint.name);
        }
      })
    })
  }

  public unregister(): void {
    this.breakpoints.forEach((breakpoint: Breakpoint) => {
      breakpoint.mediaQueryListener.off('change');
    })
  }

  public registerOrientationChange(): void {
    mediaQuery.matchMediaSync('(orientation: landscape)')
      .on('change', (mediaQueryResult) => {
        if (mediaQueryResult.matches) {
          ScreenManager.getInstance().onRotationAngleChanged(true);
        }
      })

    mediaQuery.matchMediaSync('(orientation: portrait)')
      .on('change', (mediaQueryResult) => {
        if (mediaQueryResult.matches) {
          ScreenManager.getInstance().onRotationAngleChanged(false);
        }
      })
  }

  public unregisterOrientationChange(): void {
    mediaQuery.matchMediaSync('(orientation: landscape)').off('change');
    mediaQuery.matchMediaSync('(orientation: portrait)').off('change');
  }

  private updateCurrentBreakpoint(breakpoint: string): void {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint;
      AppStorage.setOrCreate<string>(this.breakpointStorageKey, this.currentBreakpoint);
      Log.debug(TAG, 'on current breakpoint: ' + this.currentBreakpoint);
    }
  }
}