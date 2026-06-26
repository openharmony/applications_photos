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

import lazy { TreeMap } from '@kit.ArkTS';
import lazy { TimelineData } from './browser/photo/TimelineData';
import lazy { Log } from '../utils/Log';
import lazy { MediaObserverNfyInfo, MediaObserverNfyType } from './browser/dataObserver/MediaObserverCallback';
import lazy { ImageUtil } from '../utils/ImageUtil';

const TAG: string = 'AccurateGroupInfo';

const DIRTY_FLAG: number = 0x1000;
const LOADING_FLAG: number = 0x2000;

enum AccurateDataQueryState {
  SYNC_STATE = 0x1, // 同步态
  SYNC_LOADING_STATE = LOADING_FLAG | 0x2, // 同步加载，增量处理
  LOADING_TO_DIRTY_STATE = DIRTY_FLAG | LOADING_FLAG | 0x4, // 加载（增量加载/全量加载）过程中收到dirty
  DIRTY_STATE = DIRTY_FLAG | 0x8, // 标脏
  DIRTY_LOADING_STATE = DIRTY_FLAG | LOADING_FLAG | 0x10, // 标脏之后加载，全量查询
}

enum AccurateDataQueryEvent {
  NOTIFY_DATA_DIRTY_EVENT = 1, // 标脏事件
  LOAD_EVENT, // 加载事件
  LOAD_DONE_EVENT, // 加载完毕
}

export interface AccurateGroupHandleInfo {
  readonly totalCount: number;
  readonly newGroups: TimelineData[] | undefined;
}

export class AccurateGroupQueryInfo {
  private state: AccurateDataQueryState = AccurateDataQueryState.DIRTY_STATE;
  private newGroups: TreeMap<string, TimelineData> | undefined = undefined;
  private totalCount: number = 0;

  /**
   * 数据改变通知
   *
   * @param nfyInfo 通知内容
   * @param groups 当前groups信息
   */
  public onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo, groups: TimelineData[]): void {
    Log.info(TAG, 'onMediaLibDataNfy start');
    if (!nfyInfo || !groups) {
      this.setGroupDataDirty('onMediaLibDataNfy input para error');
      return;
    }
    if (this.isDirtyState()) {
      this.setGroupDataDirty('onMediaLibDataNfy group is already dirty');
      return;
    }
    // 添加和删除场景进行精细化处理
    let isNeedHandleAdd: boolean =
      (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD_ASTC && ImageUtil.isThumbnailReady()) ||
        (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD && !ImageUtil.isThumbnailReady());
    if (isNeedHandleAdd || nfyInfo.type === MediaObserverNfyType.PHOTO_REMOVE) {
      Log.debug(TAG, `checkUpdateNewGroup type: ${nfyInfo.type}`);
      this.updateNewGroup(nfyInfo, groups);
    } else {
      this.setGroupDataDirty(`onMediaLibDataNfy type: ${nfyInfo.type}`);
    }
    Log.info(TAG, 'onMediaLibDataNfy end');
  }

  /**
   * 数据开始load
   *
   */
  public loadData(): void {
    Log.info(TAG, 'loadData enter');
    this.sendStateEvent(AccurateDataQueryEvent.LOAD_EVENT, 'loadData');
  }

  /**
   * 数据加载完毕
   *
   * @param groups 当前groups信息
   */
  public notifyLoadDataDone(groups: TimelineData[]): void {
    Log.info(TAG, `notifyLoadDataDone enter group length:${groups?.length}`);
    let preState = this.state;
    this.sendStateEvent(AccurateDataQueryEvent.LOAD_DONE_EVENT, 'notifyLoadDataDone');

    // 更新newGroups：1、SYNC_LOADING_STATE->SYNC_STATE 不需要更新，其它场景需要；2、newGroups无值时
    if (groups &&
      (!(preState == AccurateDataQueryState.SYNC_LOADING_STATE && this.state === AccurateDataQueryState.SYNC_STATE) ||
        this.newGroups === undefined)) {
      Log.info(TAG, 'notifyLoadDataDone initNewGroups');
      this.initNewGroups(groups);
    }
  }

  // dirty状态
  public isDirtyState(): boolean {
    return (this.state & DIRTY_FLAG) === DIRTY_FLAG;
  }

  // group图片总量
  public getTotalFromGroup(): number {
    return this.totalCount;
  }

  // 用于Task异步执行
  public getGroupHandleInfo(): AccurateGroupHandleInfo {
    return {
      newGroups: this.getNewGroups(),
      totalCount: this.totalCount,
    };
  }

  // 从数据库查询进行全量更新
  private isRefreshDataAll(): boolean {
    return this.isDirtyState() || this.newGroups === undefined;
  }

  private clearCount(): void {
    this.totalCount = 0;
  }

  private increaseCount(increaseNum: number): void {
    this.totalCount += increaseNum;
  }

  // 获取newGroups
  private getNewGroups(): TimelineData[] | undefined {
    if (this.isRefreshDataAll()) {
      Log.info(TAG, 'getNewGroups return undefined');
      return undefined;
    }

    this.clearCount();
    let result: TimelineData[] = [];
    this.newGroups?.forEach((value, key) => {
      if (value && value.count > 0) {
        this.increaseCount(value.count);
        result.push(value);
      } else {
        if (!value || value.count < 0) {
          this.setGroupDataDirty('getNewGroups abnormal info');
        }
        Log.info(TAG,
          `getNewGroups key: ${key} group startDate: ${value?.startDate}, group count: ${value?.count}`);
      }
    });
    Log.info(TAG, `getNewGroups length: (${result.length}, ${this.newGroups?.length}), total(${this.totalCount})`);
    return result;
  }

  private updateNewGroup(nfyInfo: MediaObserverNfyInfo, groups: TimelineData[]): void {
    // 遍历this.newGroups做更新，根据asset元数据 和 startDate、endDate 转换为day信息，再更新count
    let assets = nfyInfo.sharedPhotoAssets;
    Log.debug(TAG, `updateNewGroup nfyInfo: ${nfyInfo.info()}, newGroups.length: ${this.newGroups?.length}`);
    if (!assets || assets.length < 1) {
      this.setGroupDataDirty('updateNewGroup no assets info.');
      return;
    }

    if (this.newGroups === undefined) {
      this.initNewGroups(groups);
    }
    if (this.state === AccurateDataQueryState.DIRTY_STATE) {
      Log.info(TAG, 'updateNewGroup isGroupDataDirty return');
      return;
    }

    for (let asset of assets) {
      if (!asset || !asset.dateDay ||
        (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD && !ImageUtil.isThumbnailReady() &&
          (asset.hidden || asset.dateTrashedMs > 0))) {
        this.setGroupDataDirty(`updateNewGroup invalid asset(${asset}, ${asset?.dateDay})` +
          `, hidden: ${asset?.hidden}, trash:${asset?.dateTrashedMs}`);
        continue;
      }
      this.updateGroup(asset.dateDay, asset.dateTaken, nfyInfo.type === MediaObserverNfyType.PHOTO_ADD_ASTC ||
        nfyInfo.type === MediaObserverNfyType.PHOTO_ADD);
    }
  }

  private updateGroup(key: string, dateTaken: number, isAdd: boolean): void {
    let group = this.newGroups?.get(key);
    if (group) {
      if (isAdd) {
        if (dateTaken > group.startDate) {
          Log.info(TAG, `updateGroup key:${key}, update date new(${dateTaken}) old(${group.startDate})`);
          group.startDate = dateTaken;
          group.endDate = dateTaken;
        }
      } else {
        if (dateTaken >= group.startDate) {
          Log.info(TAG, `updateGroup delete, key:${key}, dateTaken: delete(${dateTaken}), group(${group.startDate})`);
        }
      }

      group.count = Math.max((group.count + (isAdd ? 1 : -1)), 0);
      Log.info(TAG, `updateGroup key:${key}, count:${group.count}, isAdd:${isAdd}`);
    } else {
      this.newGroups?.set(key, new TimelineData(dateTaken, dateTaken, isAdd ? 1 : 0, key));
      Log.info(TAG, `updateGroup add new group key:${key}, isAdd:${isAdd}`);
    }
  }

  private initNewGroups(groups: TimelineData[]): void {
    this.newGroups = new TreeMap((firstValue: string, secondValue: string) => firstValue > secondValue);
    this.clearCount();
    for (let group of groups) {
      if (!group || !group.dateDay) {
        this.setGroupDataDirty('initNewGroups no dateDay info');
        return;
      }
      let value = this.newGroups.get(group.dateDay);
      if (value) {
        this.setGroupDataDirty('initNewGroups duplicate dateDay');
        Log.error(TAG,
          `initNewGroups duplicate dateDay: ${group.dateDay}, date: group(${group.startDate}) map(${value.startDate})`);
        return;
      }
      this.increaseCount(group.count);
      this.newGroups.set(group.dateDay, group);
    }
    Log.info(TAG,
      `initNewGroups length: ${this.newGroups?.length}, array length: ${groups?.length}, total: ${this.totalCount}`);
  }

  public setGroupDataDirty(reason: string): void {
    Log.info(TAG, `setGroupDataDirty reason:${reason}`);
    this.sendStateEvent(AccurateDataQueryEvent.NOTIFY_DATA_DIRTY_EVENT, 'setGroupDataDirty');
  }

  private sendStateEvent(event: AccurateDataQueryEvent, info: string): AccurateDataQueryState {
    let preState = this.state;
    switch (this.state) {
      case AccurateDataQueryState.SYNC_STATE:
        this.handleSyncState(event);
        break;
      case AccurateDataQueryState.SYNC_LOADING_STATE:
        this.handleSyncLoadingState(event);
        break;
      case AccurateDataQueryState.LOADING_TO_DIRTY_STATE:
        this.handleLoadingDirtyState(event);
        break;
      case AccurateDataQueryState.DIRTY_STATE:
        this.handleDirtyState(event);
        break;
      case AccurateDataQueryState.DIRTY_LOADING_STATE:
        this.handleDirtyLoadingState(event);
    }
    Log.info(TAG,
      `state change: ${AccurateDataQueryState[preState]} -> ${AccurateDataQueryState[this.state]}, event: ${AccurateDataQueryEvent[event]}, info:${info}`);
    return this.state;
  }

  private handleSyncState(event: AccurateDataQueryEvent): AccurateDataQueryState {
    switch (event) {
      case AccurateDataQueryEvent.NOTIFY_DATA_DIRTY_EVENT:
        this.state = AccurateDataQueryState.DIRTY_STATE;
        break;
      case AccurateDataQueryEvent.LOAD_EVENT:
        this.state = AccurateDataQueryState.SYNC_LOADING_STATE;
        break;
      default:
        Log.info(TAG, `handleSyncState event: ${AccurateDataQueryEvent[event]}`);
    }

    return this.state;
  }

  private handleSyncLoadingState(event: AccurateDataQueryEvent): AccurateDataQueryState {
    switch (event) {
      case AccurateDataQueryEvent.NOTIFY_DATA_DIRTY_EVENT:
        this.state = AccurateDataQueryState.LOADING_TO_DIRTY_STATE;
        break;
      case AccurateDataQueryEvent.LOAD_DONE_EVENT:
        this.state = AccurateDataQueryState.SYNC_STATE;
        break;
      default:
        Log.info(TAG, `handleSyncLoadingState event: ${AccurateDataQueryEvent[event]}`);
    }

    return this.state;
  }

  private handleLoadingDirtyState(event: AccurateDataQueryEvent): AccurateDataQueryState {
    switch (event) {
      case AccurateDataQueryEvent.LOAD_DONE_EVENT:
        this.state = AccurateDataQueryState.DIRTY_STATE;
        break;
      default:
        Log.info(TAG, `handleLoadingDirtyState event: ${AccurateDataQueryEvent[event]}`);
    }

    return this.state;
  }

  private handleDirtyState(event: AccurateDataQueryEvent): AccurateDataQueryState {
    switch (event) {
      case AccurateDataQueryEvent.LOAD_EVENT:
        this.state = AccurateDataQueryState.DIRTY_LOADING_STATE;
        break;
      default:
        Log.info(TAG, `handleDirtyState event: ${AccurateDataQueryEvent[event]}`);
    }

    return this.state;
  }

  private handleDirtyLoadingState(event: AccurateDataQueryEvent): AccurateDataQueryState {
    switch (event) {
      case AccurateDataQueryEvent.NOTIFY_DATA_DIRTY_EVENT:
        this.state = AccurateDataQueryState.LOADING_TO_DIRTY_STATE;
        break;
      case AccurateDataQueryEvent.LOAD_DONE_EVENT:
        this.state = AccurateDataQueryState.SYNC_STATE;
        break;
      default:
        Log.info(TAG, `handleDirtyLoadingState event: ${AccurateDataQueryEvent[event]}`);
    }
    return this.state;
  }
}