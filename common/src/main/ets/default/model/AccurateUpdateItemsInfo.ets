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
/* instrument ignore file*/
import lazy { Log } from '../utils/Log';
import lazy { MediaItem } from './browser/photo/MediaItem';

const TAG: string = 'AccurateUpdateItemsInfo';

/**
 * 回填模式
 */
export enum BackFillMode {
  /**
   * 替换模式
   */
  REPLACE,

  /**
   * 前方补位
   */
  FILL_HEAD,

  /**
   * 后方补位
   */
  FILL_TAIL,
}

/**
 * 用于保存精准更新数据
 */
export class AccurateUpdateItemsInfo {
  public isItemsDataDirty: boolean = false; // 更新和copy场景皆使用
  public start: number = 0; // 滑窗起点
  public newItems: (MediaItem | undefined)[] | undefined = undefined; // 更新和copy场景皆使用
  public handledCount: number = 0; // 已处理数量，标脏或copy后重置
  private readonly isCopied: boolean; // 是否复制出来的场景
  private originalInfo: AccurateUpdateItemsInfo | undefined = undefined; // 对应原始信息
  private queryFileIds: number[] | undefined = undefined; // 需要替换的FileId
  private appendHeadCount: number = 0; // 前方补位数量，标脏或补位后重置
  private deleteCount: number = 0; // 列表中删除元素数量，标脏或copy后重置

  constructor(isCopied: boolean = false) {
    this.isCopied = isCopied;
  }

  public hasQueryItems(): boolean {
    return !this.queryFileIds;
  }

  public hasDeleteItems(): boolean {
    return this.deleteCount > 0;
  }

  public getDeleteCount(): number {
    return this.deleteCount;
  }

  public updateDelete(delta: number = 1): void {
    this.deleteCount += delta;
  }

  public hasAppendHeadItems(): boolean {
    return this.appendHeadCount > 0;
  }

  public getAppendHeadCount(): number {
    return this.appendHeadCount;
  }

  public updateAppendHead(delta: number = 1): void {
    this.appendHeadCount += delta;
  }

  public isCanAccurateUpdate(): boolean {
    return !this.isItemsDataDirty && this.newItems !== undefined;
  }

  public getQueryFileIds(): number[] | undefined {
    return this.queryFileIds;
  }

  public getAppendTailCount(): number {
    Log.info(TAG, 'getAppendTailCount: (Delect: AppendHead: Replace) = ' +
      `(${this.deleteCount}: ${this.appendHeadCount}: ${this.queryFileIds?.length})`);
    return this.deleteCount - this.appendHeadCount - (this.queryFileIds?.length ?? 0);
  }

  public copy(): AccurateUpdateItemsInfo {
    let copyNewItemsInfo: AccurateUpdateItemsInfo = new AccurateUpdateItemsInfo(true);
    copyNewItemsInfo.isItemsDataDirty = this.isItemsDataDirty;
    copyNewItemsInfo.queryFileIds = [];
    if (this.newItems !== undefined) {
      copyNewItemsInfo.start = this.start;
      copyNewItemsInfo.newItems = this.newItems.slice();
      copyNewItemsInfo.originalInfo = this;
      for (let item of this.newItems) {
        if (item && item.isFromNtf && item.fileData) {
          copyNewItemsInfo.queryFileIds.push(item.fileData.fileId);
        }
      }
      copyNewItemsInfo.appendHeadCount = this.appendHeadCount;
      copyNewItemsInfo.deleteCount = this.deleteCount;
    }
    this.deleteCount = 0;
    this.handledCount = 0;
    return copyNewItemsInfo;
  }

  public backFillOriginal(queryItems: MediaItem[], backFillMode: BackFillMode): boolean {
    if (!this.backFillNewItems(queryItems, backFillMode)) {
      return false;
    }
    if (this.originalInfo && !this.originalInfo.isItemsDataDirty && this.originalInfo.newItems !== undefined) {
      if (!this.originalInfo.backFillNewItems(queryItems, backFillMode)) {
        this.originalInfo.setItemsDataDirty(`backFill original failed. mode ${BackFillMode[backFillMode]}`);
      }
    }
    return true;
  }

  public setItemsDataDirty(reason: string): void {
    if (this.originalInfo) {
      this.originalInfo.setItemsDataDirty(reason);
    } else {
      this.isItemsDataDirty = true;
      this.reset();
      Log.info(TAG, `setItemsDataDirty: ${reason}`);
    }
  }

  public clearNewItems(reason: string): void {
    this.isItemsDataDirty = false;
    this.reset();
    Log.info(TAG, `clearNewItems: ${reason}`);
  }

  private reset(clearNewItems: boolean = true): void {
    if (clearNewItems) {
      this.newItems = undefined;
    }
    this.queryFileIds = undefined;
    this.appendHeadCount = 0;
    this.deleteCount = 0;
    this.handledCount = 0;
  }

  private backFillNewItems(queryItems: MediaItem[], backFillMode: BackFillMode): boolean {
    switch (backFillMode) {
      case BackFillMode.REPLACE:
        return this.replaceNewItems(queryItems);
      case BackFillMode.FILL_HEAD:
        return this.fillHeadNewItems(queryItems);
      case BackFillMode.FILL_TAIL:
        return this.fillTailNewItems(queryItems);
    }
  }

  private replaceNewItems(queryItems: MediaItem[]): boolean {
    if (this.newItems === undefined) {
      return false;
    }
    if (this.isCopied && queryItems.length !== (this.queryFileIds?.length ?? -1)) {
      return false;
    }
    let queryIndex: number = 0;
    let itemIndex: number = 0;
    for (; queryIndex < queryItems.length; queryIndex++) {
      let queryItem: MediaItem = queryItems[queryIndex];
      if (!queryItem) {
        continue;
      }
      let findPosition: boolean = false;
      for (; itemIndex < this.newItems.length; itemIndex++) {
        let item = this.newItems[itemIndex];
        if (!item) {
          continue;
        }
        if (queryItem.uri === item.uri) {
          findPosition = true;
          break;
        } else if (queryItem.getDateTaken() > item.getDateTaken()) {
          // 此时说明未找到替换点
          break;
        }
      }
      if (findPosition) {
        // 使用queryItem替换原列表中数据
        Log.info(TAG, `backFillNewItems findPosition: ${itemIndex}`);
        this.newItems.splice(itemIndex, 1, queryItem);
      } else {
        return false;
      }
    }
    return true;
  }

  private fillHeadNewItems(queryItems: MediaItem[]): boolean {
    if (this.newItems === undefined) {
      return false;
    }
    if (queryItems.length !== this.appendHeadCount) {
      return false;
    }
    this.newItems.splice(0, 0, ...queryItems);
    if (!this.isCopied) {
      this.appendHeadCount = 0;
    }
    return true;
  }

  private fillTailNewItems(queryItems: MediaItem[]): boolean {
    if (this.newItems === undefined) {
      return false;
    }
    if (this.isCopied && queryItems.length !== this.getDeleteCount()) {
      return false;
    }
    this.newItems.splice(this.newItems.length - 1, 0, ...queryItems);
    return true;
  }
}