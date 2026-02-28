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
import lazy { DeviceInfo } from '../../../../utils/DeviceInfo';
import lazy { Log } from '../../../../utils/Log';

export enum GridLink {
  IN_PHOTO_GRID,
  OUT_PHOTO_GRID,
  PHOTO_GRID_ACTIONBAR,
  IN_PHOTO_GRID_ACTION_BAR,
  OUT_PHOTO_GRID_ACTIONBAR,
  ALBUM,
  ALBUM_ACTIONBAR,
  IN_ALBUM_ACTIONBAR,
  OUT_ALBUM_ACTIONBAR,
  IN_SIDEBAR,
  OUT_SIDEBAR,
  IN_TAB_BAR,
  OUT_TAB_BAR,
  OUT_SIDEBAR_BOUNDARY_LINE,
  ALBUM_TO_PHOTO_GRID,
  ALBUM_TO_PHOTO_GRID_SCALE,
  PHOTO_GRID_TO_ALBUM,
  PHOTO_GRID_TO_ALBUM_SCALE,
  SIDEBAR_VIEW,
}

export function getDelayConst(key: number): number {
  let constMap: Map<number, number> = new Map([
    [GridLink.IN_PHOTO_GRID, 100],
    [GridLink.OUT_SIDEBAR, 0],
    [GridLink.ALBUM_ACTIONBAR, 100],
    [GridLink.OUT_ALBUM_ACTIONBAR, 50],
    [GridLink.OUT_SIDEBAR_BOUNDARY_LINE, 250],
    [GridLink.PHOTO_GRID_ACTIONBAR, DeviceInfo.isPc() ? 100 : 250],
  ]);
  const dConst: number = constMap.get(key) ?? Number.NaN;
  if (!Number.isFinite(dConst)) {
    Log.fatal('getDelayConst', GridLink[key], 'did not specified.');
  }
  return dConst;
}

export function getDurationConst(key: number): number {
  let constMap: Map<number, number> = new Map([
    [GridLink.ALBUM, 200],
    [GridLink.OUT_PHOTO_GRID, 150],
    [GridLink.IN_PHOTO_GRID, 200],
    [GridLink.ALBUM_ACTIONBAR, 250],
    [GridLink.IN_ALBUM_ACTIONBAR, 150],
    [GridLink.OUT_ALBUM_ACTIONBAR, 200],
    [GridLink.IN_SIDEBAR, 150],
    [GridLink.OUT_SIDEBAR, 200],
    [GridLink.OUT_SIDEBAR_BOUNDARY_LINE, 150],
    [GridLink.IN_TAB_BAR, 250],
    [GridLink.OUT_TAB_BAR, 175],
    [GridLink.IN_PHOTO_GRID_ACTION_BAR, DeviceInfo.isPc() ? 150 : 250],
    [GridLink.OUT_PHOTO_GRID_ACTIONBAR, DeviceInfo.isPc() ? 200 : 175],
    [GridLink.ALBUM_TO_PHOTO_GRID, DeviceInfo.isPc() ? 400 : 300],
    [GridLink.ALBUM_TO_PHOTO_GRID_SCALE, DeviceInfo.isPc() ? 400 : 500],
    [GridLink.PHOTO_GRID_TO_ALBUM, DeviceInfo.isPc() ? 400 : 300],
    [GridLink.PHOTO_GRID_TO_ALBUM_SCALE, DeviceInfo.isPc() ? 400 : 350],
    [GridLink.SIDEBAR_VIEW, 200],
  ]);
  const dConst: number = constMap.get(key) ?? Number.NaN;
  if (!Number.isFinite(dConst)) {
    Log.fatal('getDurationConst', GridLink[key], 'did not specified.');
  }
  return dConst;
}