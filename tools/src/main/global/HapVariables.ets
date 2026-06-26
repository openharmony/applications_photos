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
/* instrument ignore file */
export namespace WindowVariables {
  // window three button width, don't change it!
  export const titleButtonAvoidWidth: number = 108;

  //三窗背板由28变为40
  export const threeButtonAvoidWidth: number = 144;

  export let isWindowPcModeSwitchStatus: boolean = true;
}

export namespace SideBarVariables {
  export let isSideBarDeselected: boolean = false;

  export let isDeferCreatingNewAlbum: boolean = false;
}

export namespace GridColumnsManager {
  export const DEFAULT_GRID_MAGNITUDE: number = 2;

  export enum ColumnsTemplateType {
    AutoFill,
    AutoStretch,
  }

  export enum GridMagnitudeOperation {
    ZOOMIN,
    ZOOMOUT,
  }

  export let gridMagnitude: number = DEFAULT_GRID_MAGNITUDE;

  export function calcRowCount(
    contentWidth: number, contentPadding: number, gridItemWidth: number, columnsGap: number): number {
    let preciseRowCount: number =
      (contentWidth - contentPadding + columnsGap) / (gridItemWidth + columnsGap);
    let newGridRowCount: number;
    if (Math.floor(preciseRowCount) < 1) {
      newGridRowCount = 1;
      return newGridRowCount;
    } else {
      newGridRowCount = Math.floor(preciseRowCount);
    }
    return newGridRowCount;
  }

  export function calcColumnsGap(
    contentWidth: number, contentPadding: number, gridItemWidth: number, gridRowCount: number): number {
    return (contentWidth - contentPadding - gridRowCount * gridItemWidth) / (gridRowCount - 1);
  }

  export function updateColumnsTemplate(type: ColumnsTemplateType, gridItemWidth: number): string {
    if (type === ColumnsTemplateType.AutoFill) {
      return 'repeat(auto-fill,'.concat(gridItemWidth?.toString(), ')');
    }
    return 'repeat(auto-stretch,'.concat(gridItemWidth.toString(), ')');
  }
}
