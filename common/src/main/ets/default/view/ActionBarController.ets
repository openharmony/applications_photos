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

import lazy { Action, SubMenuParamType } from './browserOperation/Action';
import lazy { RightClickMenuGroup } from './menu/MenuController';

const TAG = 'ActionBarController';

@Observed
export class ActionBarController {
  private handleClickFunc: Function | undefined;
  public isAllSelected: boolean;
  public isEmpty: boolean;
  public moreMenuList: Action[];
  public moreMenuListPC: RightClickMenuGroup[] = [];
  public creationMenuList: Action[];
  public totalSelectedCount: number;
  public albumsShow: boolean;
  public title: string;
  public actionMoreMenuList: Action[] = [];
  public isPhotoGridViewRefreshed: boolean = false;

  constructor() {
    this.handleClickFunc = undefined;
    this.isAllSelected = false;
    this.isEmpty = false;
    this.moreMenuList = [];
    this.creationMenuList = [];
    this.totalSelectedCount = 0;
    this.albumsShow = false;
    this.title = '';
    this.actionMoreMenuList = [];
    this.moreMenuListPC = [];
  }

  registerHandleClickFunc(handleClickFunc: Function): void {
    this.handleClickFunc = handleClickFunc;
  }

  release(): void {
    if (this.isPhotoGridViewRefreshed) {
      this.isPhotoGridViewRefreshed = false;
      return;
    }
    this.handleClickFunc = undefined;
  }

  handleClick(action: Action, param?: SubMenuParamType): void {
    this.handleClickFunc?.(action, param);
  }
}