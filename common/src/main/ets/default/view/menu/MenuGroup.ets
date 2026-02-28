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

import lazy { Action } from '../browserOperation/Action';
import lazy { Log } from '../../utils/Log';

/* instrument ignore file */
const TAG: string = 'MenuGroup';

/**
 * 单个menuGroup管理
 */
@Observed
export class RightClickMenuGroup {
  private static uuid: number = 0;

  /**
   * 唯一id
   */
  public readonly id: number;

  /**
   * 组件键值
   */
  public key: string = 'menu_group';

  /**
   * Group所有Action数组
   */
  @Track public menuList: Action[] = [];

  /**
   * Group所有判断条件数组
   */
  private boolList: boolean[] = [];

  /**
   * Group所有Action数组
   */
  private actionList: Action[] = [];

  constructor(actionList?: Action[], boolList?: boolean[]) {
    RightClickMenuGroup.uuid++;
    this.id = RightClickMenuGroup.uuid;
    this.key = `${this.key}_${this.id}`;
    if (actionList && boolList) {
      this.actionList = actionList;
      this.boolList = boolList;
      this.getGroup();
    }
  }

  /**
   * 获取最新的MenuGroup
   */
  public getGroup(): void {
    this.menuList = [];
    if (this.actionList.length !== this.boolList.length) {
      Log.error(TAG, `setActionItemShow list lenght non-consistent`);
      return;
    }
    for (let index = 0; index < this.actionList.length; index++) {
      const action: Action = this.actionList[index];
      const bool = this.boolList[index];
      if (bool) {
        this.menuList.push(action);
      }
    }
  }

  /**
   * 判断条件列表是否相同
   * @param newList
   * @returns
   */
  public compareBoolList(newList: boolean[]): boolean {
    if (newList.length !== this.boolList.length) {
      return false;
    }
    for (let index = 0; index < newList.length; index++) {
      const newBool = newList[index];
      const oldBool = this.boolList[index];
      if (newBool !== oldBool) {
        return false;
      }
    }
    return true;
  }

  /**
   * 修改groupList 如果判断条件相同则不做处理
   * @param newList
   */
  public changeGroupList(newList: boolean[]): void {
    if (newList.length === 0) {
      this.menuList = [];
      return;
    }
    const flag = this.compareBoolList(newList);
    Log.info(TAG, `changeGroupList flag: ${flag}, newList: ${newList}`);
    if (!flag) {
      this.boolList = newList;
      this.getGroup();
    }
  }
}