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
const CONTEXT_MENU_DISABLE_TIME_OUT = 250;

export class GridScrollMsg {
  protected _isScrolling: boolean;
  public isScrollerBarTouch: boolean = false;
  public isDragging: boolean = false;
  public isShowPreview: boolean = false;
  public isContextMenuDisabled: boolean = false;
  public isContextMenuDisabledResetAble: boolean = true;
  public isContextMenuDisabledTimer: number = -1;

  constructor(_isScrolling: boolean) {
    this._isScrolling = _isScrolling;
  }

  get isScrolling() {
    return this._isScrolling;
  }

  set isScrolling(_isScrolling: boolean) {
    this._isScrolling = _isScrolling;
    this.isContextMenuDisabled = true;
    if (!_isScrolling) {
      if (this.isContextMenuDisabledTimer != -1) {
        clearTimeout(this.isContextMenuDisabledTimer);
        this.isContextMenuDisabledTimer = -1;
      }
      this.isContextMenuDisabledTimer =
        setTimeout((): void => this.resetIsContextMenuDisabled(), CONTEXT_MENU_DISABLE_TIME_OUT)
    }
  }

  public resetIsContextMenuDisabled() {
    if (this.isContextMenuDisabledResetAble) {
      this.isContextMenuDisabled = false;
      this.isContextMenuDisabledTimer = -1;
    }
  }
}