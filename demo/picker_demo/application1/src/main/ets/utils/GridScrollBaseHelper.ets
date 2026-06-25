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

import lazy { GridScrollLogTracker } from './GridScrollLogTracker';
import lazy { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import lazy { Region } from './Region';
import lazy { StringUtil } from '../utils/StringUtil';
import lazy systemParameter from '@ohos.systemparameter';

/**
 * 控制是否开启滑动调试开关
 */
const SCROLL_DEBUG_ENABLE: string = 'const.sys.photos.scroll.debug.enable';

const ENABLE: string = 'on';

const DISABLE: string = 'off';

/**
 * 宫格滑动信息
 */
export class GridScrollInfo {
}

/**
 * 规则宫格布局的滑动信息
 */
export class RegularGridScrollInfo extends GridScrollInfo {
  /**
   * 每个宫格的高度
   */
  public imageGridItemHeight: number = 0;
  /**
   * 每行的宫格数
   */
  public gridRowCount: number = 0;
  /**
   * Grid顶部非图片组件高度
   */
  public actionAndRefreshHeight?: number = 0;
}

/**
 * 宫格页信息
 */
export class GridPageInfo {
  /**
   * 宫格页场景（如时间轴, ...）
   */
  public gridScene: string = '';
}

/**
 * 规则宫格布局的滑动信息
 */
export class YearMonthGridScrollInfo extends GridScrollInfo {
  /**
   *底部栏高度
   */
  public bottomBarHeight: number = 0;
  /**
   * 状态栏高度
   */
  public statusBarHeight: number = 0;
  /**
   * 区分年月视图使用标识
   */
  public scrollFlag: string = '';
  /**
   * 年月视图的列数
   */
  public columns: number = 0;
}

/**
 * 宫格辅助类基类（包括滑动、滚动场景）
 */
export class GridScrollBaseHelper {
  /**
   * 数据源
   */
  protected dataSource?: MediaDataSource;
  /**
   * 滑动组件控制器
   */
  protected scroller?: Scroller;
  /**
   * 滑动过程日志维测类
   */
  protected logTracker?: GridScrollLogTracker;
  /**
   * 宫格页信息
   */
  protected gridPageInfo?: GridPageInfo;

  constructor() {
    let param: string = systemParameter.getSync(SCROLL_DEBUG_ENABLE, DISABLE);
    let isScrollDebugEnabled: boolean = StringUtil.size(param) !== 0 && param === ENABLE;
    if (isScrollDebugEnabled) {
      this.logTracker = new GridScrollLogTracker();
    }
  }

  /**
   * 初始化
   *
   * @param scroller 滑动组件控制器
   * @param dataSource 数据源
   */
  public init(scroller: Scroller, dataSource: MediaDataSource): void {
    this.scroller = scroller;
    this.dataSource = dataSource;
  }

  /**
   * 设置宫格页信息
   *
   * @param gridPageInfo 宫格页信息
   */
  public setGridPageInfo(gridPageInfo: GridPageInfo): void {
    this.gridPageInfo = gridPageInfo;
  }

  /**
   * 记录滑动信息
   *
   * @param scrollInfo 滑动信息
   */
  public recordScrollInfo(scrollInfo: GridScrollInfo): void {
  }

  /**
   * 处理滑动开始事件
   */
  public handleScrollStart(): void {
  }

  /**
   * 处理滑动结束事件
   */
  public handleScrollStop(): void {
  }

  /**
   * 处理滑动坐标变化事件
   *
   * @param start 起点
   * @param end 终点
   */
  public handleScrollIndex(start: number, end: number): void {
  }

  /**
   * 处理每帧滑动起始事件
   *
   * @param offset 输入坐标偏移量
   * @param source 滑动事件来源
   * @returns 实际坐标偏移量
   */
  public handleWillScroll(offset: number, source: ScrollSource): number {
    return offset;
  }

  /**
   * 处理每帧滑动坐标回调事件
   *
   * @param offset 每帧最终滑动坐标
   */
  public handleScroll(offset: number): void {
  }

  /**
   * 设置窗口宽高
   *
   * @param width 宽度
   * @param height 高度
   */
  public setWinSize(width: number, height: number) {
  }

  /**
   * 打印区间集信息
   *
   * @param tag 日志TAG
   * @param regionsName 区间集名称
   * @param regions 区间集
   */
  public printRegionsInfo(tag: string, regionsName: string, regions: Region[]): void {
    if (regions.length === 0) {
      return;
    }

    let regionInfo: string = `regionsName:${regionsName}, len:${regions.length}`;
    for (let region of regions) {
      if (region !== null && region.isValid()) {
        regionInfo += `, ${region.toString()}`;
      }
    }
    this.logTracker?.info(tag, `${regionInfo}`);
  }
}