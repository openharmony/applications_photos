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

import lazy { DeviceInfo } from '../utils/DeviceInfo';

/**
 * 业务：ActionBar
 */
export namespace ActionBarVar {
  export let isMoreMenuShow: boolean = false;

  export let isShowSideBar: boolean = true;

  export let sideBarWidth: number = 0;

  export let isFirstUnHover: boolean = true;

  /* instrument ignore next */
  export const updatePlaceholderStatus = (): boolean => {
    if (!DeviceInfo.isPcOrTablet()) {
      return false;
    }
    return !ActionBarVar.isShowSideBar;
  };

  export let pcActionBarHeight: number = 0;
}

@Observed
export class SideBarVarClass {
  public static sideBarVarClass: SideBarVarClass = new SideBarVarClass();

  public static getInstance(): SideBarVarClass {
    if (SideBarVarClass.sideBarVarClass) {
      return SideBarVarClass.sideBarVarClass;
    }
    SideBarVarClass.sideBarVarClass = new SideBarVarClass();
    return SideBarVarClass.sideBarVarClass;
  }

  public sideBarWidth: number = 0;
  public isShowSideBar: boolean = true;
}

export interface SideBarStatusListener {
  onStatusChanged: (status: boolean) => void;
}

export class SideBarViewModel {
  public static readonly STORAGE_KEY: string = 'com.ohos.photos.side_bar.view_model';
  private listeners: SideBarStatusListener[] = [];
  private isShowSideBar: boolean = DeviceInfo.isPhoneUx() && !DeviceInfo.isGRLFoldExpanded() ? false : true;

  public register(listener: SideBarStatusListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  public unregister(listener: SideBarStatusListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  public get status(): boolean {
    return this.isShowSideBar;
  }

  public set status(isShowSideBar: boolean) {
    this.isShowSideBar = isShowSideBar;
    this.listeners.forEach(listener => {
      listener.onStatusChanged(this.isShowSideBar);
    });
  }
}