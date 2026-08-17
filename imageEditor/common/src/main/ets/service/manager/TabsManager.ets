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

import { TabType } from '../../feature/basic/model/menu/data/TabType'
import { TabName } from '../../service/model/Enum'

const TAG = 'TabsManager';

export const TAB_ADJUST: TabType =
  new TabType($r('app.string.tabs_adjust_imageEdit'), TabName.TabAdjust, $r('sys.symbol.slider_horizontal_2'));

export const TAB_TEXT: TabType =
  new TabType($r('app.string.tabs_text_imageEdit'), TabName.TabTextEdit, $r('app.media.textEdit_text'), false);

export const TAB_MOSAIC: TabType =
  new TabType($r('app.string.tabs_text_mosicac'), TabName.TabMosaic, $r('sys.symbol.mosaic'));

const TABS_SORTS: TabType[] = [
  TAB_ADJUST,
  TAB_TEXT,
  TAB_MOSAIC,
];

type CloseTabCallback = (tab: TabType) => void;

@Observed
export class TabsManager {
  public static instance?: TabsManager;
  public tabs: TabType[];
  private rankMap: Map<TabType, number>;
  private callbacks: Map<TabType, CloseTabCallback[]> = new Map();

  public static getInstance() {
    if (!TabsManager.instance) {
      TabsManager.instance = new TabsManager();
    }
    return TabsManager.instance;
  }

  constructor() {
    this.rankMap = new Map(TABS_SORTS.map((tab, rank) => [tab, rank]));
    this.tabs = [
      TAB_ADJUST, TAB_TEXT, TAB_MOSAIC
    ];
  }

  static clear() {
    TabsManager.instance = undefined;
  }

  public size() {
    return this.tabs.length;
  }

  register(tab: TabType, cb: CloseTabCallback) {
    if (this.callbacks.has(tab)) {
      this.callbacks.get(tab)!.push(cb);
    } else {
      this.callbacks.set(tab, [cb]);
    }
  }

  cancel(tab: TabType, cb: CloseTabCallback) {
    const cbs = this.callbacks.get(tab) || [];
    const newCbs = cbs.filter(i => i !== cb);
    this.callbacks.set(tab, newCbs);
  }

  close(tab: TabType) {
    if (!this.tabs.includes(tab)) {
      return;
    }
    this.tabs = this.tabs.filter(i => i !== tab);
    if (this.callbacks.has(tab)) {
      this.callbacks.get(tab)!.forEach(cb => cb(tab));
    }
  }

  enable(tab: TabType) {
    const rank = this.rankMap.get(tab);
    if (rank === undefined) {
      return;
    }
    if(this.tabs.includes(tab)) {
      return;
    }
    const insertIndex = this.tabs.findIndex(i => (this.rankMap.get(i) || 0) > rank);
    if (insertIndex == -1) {
      this.tabs.push(tab);
    } else {
      this.tabs.splice(insertIndex, 0, tab);
    }
    this.tabs = [...this.tabs];
  }
}
