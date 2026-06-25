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

import lazy { AlbumDefine } from '../AlbumDefine'
import lazy { Constants } from '../../common/Constants';
import type { FetchOptions } from '../../../access/UserFileManagerAccess';
import lazy { StringUtil } from '../../../utils/StringUtil';
import lazy systemParameter from '@ohos.systemparameter';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { YearMonthMediaItem } from './YearMonthMediaItem';

const KEY_MAX_MEDIA_QUERY_COUNT = 'const.sys.photos.yearMonth.maxMediaQueryCount';

const VAL_MAX_MEDIA_QUERY_COUNT_DEFAULT = '30000';

const KEY_ENABLE_SYNC_MEDIA_QUERY = 'const.sys.photos.yearMonth.enableSyncMediaQuery';

const VAL_ENABLE_SYNC_MEDIA_QUERY_DEFAULT = 'on';

const KEY_ENABLE_BACKGROUND_MEDIA_QUERY = 'const.sys.photos.yearMonth.enableBackgroundMediaQuery';

const VAL_ENABLE_BACKGROUND_MEDIA_QUERY_DEFAULT = 'on';

/**
 * 年月视图工具类
 */
export class YearMonthUtil {
  /**
   * 获取年月元数据的主线程/子线程查询边界值。指定数据量以内，若未命中缓存，采用主线程查询；超过指定数据量，若未命中缓存，采用子线程查询
   *
   * @returns 年月元数据的主线程/子线程查询边界值
   */
  public static getMaxMediaQueryCount(): number {
    return Number.parseInt(systemParameter.getSync(KEY_MAX_MEDIA_QUERY_COUNT, VAL_MAX_MEDIA_QUERY_COUNT_DEFAULT));
  }

  /**
   * 是否支持同步查询年月元数据
   *
   * @returns true表示支持
   */
  public static isEnableSyncMediaQuery(): boolean {
    let param: string = systemParameter.getSync(KEY_ENABLE_SYNC_MEDIA_QUERY,
      VAL_ENABLE_SYNC_MEDIA_QUERY_DEFAULT);
    return StringUtil.size(param) !== 0 && param === VAL_ENABLE_SYNC_MEDIA_QUERY_DEFAULT;
  }

  /**
   * 是否支持后台查询年月元数据
   *
   * @returns true表示支持
   */
  public static isEnableBackgroundMediaQuery(): boolean {
    let param: string = systemParameter.getSync(KEY_ENABLE_BACKGROUND_MEDIA_QUERY,
      VAL_ENABLE_BACKGROUND_MEDIA_QUERY_DEFAULT);
    return StringUtil.size(param) !== 0 && param === VAL_ENABLE_BACKGROUND_MEDIA_QUERY_DEFAULT;
  }

  /**
   * 查询年月元数据
   *
   * @param helper 查询辅助类
   * @param start 元数据查询起始
   * @param count 元数据查询个数
   * @param priority 元数据查询优先级
   * @param isThumbnailReady 缩略图是否生成
   * @returns 查询结果
   */
  // public static queryMediaItem(helper: SendablePhotoAccessHelper | sendablePhotoAccessHelper.PhotoAccessHelper,
  //   start: number, count: number, priority: number, isThumbnailReady: boolean): YearMonthMediaItem[] {
  //   if (!helper || start < 0 || count <= 0) {
  //     return [];
  //   }
  //
  //   let fetchOpt: FetchOptions = AlbumDefine.getFileFetchOptForYearAndMonth(start, count, isThumbnailReady);
  //   TraceControllerUtils.startTrace(`getSharedPhotoAssets-${priority}`);
  //   let assets: Array<SendableSharedPhotoAsset> | undefined = helper.getSharedPhotoAssets(fetchOpt);
  //   TraceControllerUtils.finishTrace(`getSharedPhotoAssets-${priority}`);
  //   if (!assets || assets.length === 0) {
  //     return [];
  //   }
  //
  //   let ret: YearMonthMediaItem[] = [];
  //   for (let index = 0; index < assets.length; index++) {
  //     let item: YearMonthMediaItem = new YearMonthMediaItem(assets[index].dateTaken,
  //       assets[index].fileId, assets[index].dateModifiedMs, assets[index].mediaType);
  //     ret.push(item);
  //   }
  //   return ret;
  // }

  /**
   * 计算年月视图View键值，计算公式为：年/月_单个宫格小图个数_单个宫格列数_宫格索引_占位标识
   *
   * @param currentView 当前视图
   * @param itemCountPerGroup 单个宫格小图个数
   * @param itemColumnPerGroup 单个宫格列数
   * @param viewIndex 宫格索引
   * @param fillPosition? 占位标识
   * @returns 年月视图View键值
   */
  public static generateYearMonthViewKey(currentView: string, itemCountPerGroup: number,
    itemColumnPerGroup: number, viewIndex: number, fillPosition?: number): string {
    return `${currentView}_${itemCountPerGroup}_${itemColumnPerGroup}_${viewIndex}_${fillPosition ?? 0}`;
  }

  /**
   * 判断是否为年视图
   *
   * @param currentView 当前视图
   * @returns 当前视图是否为年视图
   */
  public static isYearView(currentView: string): boolean {
    return currentView === Constants.YEAR;
  }

  /**
   * 判断是否为月视图
   *
   * @param currentView 当前视图
   * @returns 当前视图是否为月视图
   */
  public static isMonthView(currentView: string): boolean {
    return currentView === Constants.MONTH;
  }

  /**
   * 判断是否为年月视图
   *
   * @param currentView 当前视图
   * @returns 当前视图是否为年月视图
   */
  public static isYearMonthView(currentView: string): boolean {
    return YearMonthUtil.isYearView(currentView) || YearMonthUtil.isMonthView(currentView);
  }
}