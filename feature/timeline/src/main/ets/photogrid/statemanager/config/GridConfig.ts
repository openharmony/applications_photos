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

import lazy { AbstractConfig } from '@ohos/common/src/main/ets/default/model/AbstractConfig';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy {
  DEFAULT_CACHE_COUNT,
  DEFAULT_COLUMN,
  DEFAULT_GRID_MAGNITUDE,
  DEFAULT_GUTTER,
  GROUP_TITLE_HEIGHT,
  DEFAULT_PADDING,
  MAX_GRID_MAGNITUDE,
  MIN_GRID_MAGNITUDE
} from '../constants/GridDefine';

/**
 * 宫格可变配置
 */
export interface IGridVariableConfig {
  /**
   * 是否支持关联tabbar沉浸式动效
   */
  isSupportTabbarAnimation?: boolean;

  /**
   * 是否根据宽高自动调整宫格列数
   */
  isAutoAdjustColumns?: boolean;

  /**
   * 宫格一行列数（年/月/日/日分组）
   */
  gridColumns?: number[];

  /**
   * 宫格分组头高度
   */
  groupTitleHeight?: number;

  /**
   * 图片列间距
   */
  imageColumnGutters?: number[];
}

/**
 * 宫格初始化配置
 */
export interface IGridConfig extends IGridVariableConfig {
  /**
   * 是否支持日分组视图
   */
  isSupportGroupDay?: boolean;

  /**
   * 是否支持日分组地点标题
   */
  isSupportLocationTitle?: boolean;

  /**
   * 是否支持预加载
   */
  isSupportPreload?: boolean;

  /**
   * 是否支持头部信息
   */
  isSupportHeadMsg?: boolean;

  /**
   * 是否支持除消息头外的其他不规则区域
   */
  isSupportOtherIrregular?: boolean;

  /**
   * 是否支持默认在多选态（PC场景默认在多选态，工具栏默认显示）
   */
  isSupportDefaultSelect?: boolean;

  /**
   * 是否最后日视图为日分组形态
   */
  isLastFormIsDayGroup?: boolean;

  /**
   * 是否支持标题时间显示
   */
  isSupportShowTimeInTitle?: boolean;

  /**
   * 图片行间距
   */
  imageGutters?: number[];

  /**
   * 宫格左右内距
   */
  gridPaddingLeftAndRight?: number;

  /**
   * 宫格缓存数量
   */
  cachedCounts?: number[];

  /**
   * 是否显示云同步卡片
   */
  hasCloudCard?: boolean;

  /**
   * 是否显示相机权限卡片
   */
  isShowCameraCard?: boolean;

  /**
   * 默认宫格挡位
   */
  defaultGridLevel?: number;

  /**
   * 最大捏合挡位
   */
  maxGridLevel?: number;

  /**
   * 最小捏合挡位
   */
  minGridLevel?: number;

  /**
   * 日视图列数差
   */
  dayColumnsGap?: number;

  /**
   * 是否支持宫格空白处右键菜单
   */
  isSupportGridRightClickMenu?: boolean;

  /*
   * [不可变更]日视图、日分组视图是否支持错峰加载
   */
  isSupportStaggerLoading?: boolean;

  /**
   * 是否支持极简
   */
  isSupportMinimal?: boolean;

  /*
   * 滚动条是否显示的数据量限制
   */
  scrollbarEnableCounts?: number;
}

/**
 * 宫格配置
 */
export class GridConfig extends AbstractConfig<IGridConfig> implements IGridConfig {
  /**
   * [不可变更]日视图、日分组视图是否支持错峰加载
   */
  private _isSupportStaggerLoading: boolean = true;

  /**
   * [不可变更]是否支持日分组视图
   */
  private _isSupportGroupDay: boolean = false;

  /**
   * [不可变更]是否支持日分组地点标题（默认支持）
   */
  private _isSupportLocationTitle: boolean = true;

  /**
   * [不可变更]是否支持预加载（性能场景）
   */
  private _isSupportPreload: boolean = false;

  /**
   * [不可变更]是否支持信息头
   */
  private _isSupportHeadMsg: boolean = false;

  /**
   * [不可变更]是否支持除消息头外的其他不规则区域
   */
  private _isSupportOtherIrregular: boolean = false;

  /**
   * [不可变更]是否最后日视图为日分组形态
   */
  private _isLastFormIsDayGroup: boolean = false;

  /**
   * [不可变更]图片行间距
   */
  private _imageGutters: number[] = DEFAULT_GUTTER;

  /**
   * [不可变更]宫格左右内距
   */
  private _gridPaddingLeftAndRight: number = DEFAULT_PADDING;

  /**
   * [不可变更]是否支持极简
   */
  private _isSupportMinimal: boolean = false;

  /**
   * 图片列间距
   */
  private _imageColumnGutters: number[] = DEFAULT_GUTTER;

  /**
   * 宫格缓存数量
   */
  private _cachedCounts: number[] = DEFAULT_CACHE_COUNT;

  /**
   * [可变更]是否根据宽高自动调整宫格列数
   */
  private _isAutoAdjustColumns: boolean = false;

  /**
   * [可变更]宫格列数（年/月/日/日分组）
   */
  private _gridColumns: number[] = DEFAULT_COLUMN;

  /**
   * 日视图-分组视图的列数差，默认0
   */
  private _dayColumnsGap: number = 0;

  /**
   * 宫格分组头高度
   */
  private _groupTitleHeight: number = GROUP_TITLE_HEIGHT;
  /**
   * 是否支持显示云同步卡片
   */
  private _isSupportCloudCard: boolean = false;

  /**
   * 是否显示相机权限卡片
   */
  private _isShowCameraCard: boolean = false;

  /**
   * 是否支持显示标题时间
   */
  private _isSupportShowTimeInTitle: boolean = false;

  /**
   * 是否关联tabbar沉浸式动效，默认不支持
   */
  private _isSupportTabbarAnimation: boolean = false;

  private _maxGridLevel: number = MAX_GRID_MAGNITUDE;

  private _minGridLevel: number = MIN_GRID_MAGNITUDE;

  private _defaultGridLevel: number = DEFAULT_GRID_MAGNITUDE;

  private _isFullRatio: boolean = false;

  /**
   * 滚动条是否显示的数据量限制默认值
   */
  private _scrollbarEnableCounts: number = Constants.PHOTOS_CNT_FOR_HIDE_SCROLL_BAR;

  public get isSupportStaggerLoading(): boolean {
    return this._isSupportStaggerLoading;
  }

  public get isSupportGroupDay(): boolean {
    return this._isSupportGroupDay;
  }

  public get isSupportLocationTitle(): boolean {
    return this._isSupportLocationTitle;
  }

  public get isSupportPreload(): boolean {
    return this._isSupportPreload;
  }

  public get isSupportHeadMsg(): boolean {
    return this._isSupportHeadMsg;
  }

  public get isSupportOtherIrregular(): boolean {
    return this._isSupportOtherIrregular;
  }

  public get isLastFormIsDayGroup(): boolean {
    return this._isLastFormIsDayGroup;
  }

  public get imageGutters(): number[] {
    return this._imageGutters;
  }

  public get gridPaddingLeftAndRight(): number {
    return this._gridPaddingLeftAndRight;
  }

  public get scrollbarEnableCounts(): number {
    return this._scrollbarEnableCounts;
  }

  public get imageColumnGutters(): number[] {
    return this._imageColumnGutters;
  }

  public get cachedCounts(): number[] {
    return this._cachedCounts;
  }

  public get isAutoAdjustColumns(): boolean {
    return this._isAutoAdjustColumns;
  }

  public get gridColumns(): number[] {
    return this._gridColumns;
  }

  public get dayColumnsGap(): number {
    return this._dayColumnsGap;
  }

  public get groupTitleHeight(): number {
    return this._groupTitleHeight;
  }

  public get isCloudCardSupported(): boolean {
    return this._isSupportCloudCard;
  }

  public get isShowCameraCard(): boolean {
    return this._isShowCameraCard;
  }

  public get isSupportShowTimeInTitle(): boolean {
    return this._isSupportShowTimeInTitle;
  }

  public get isSupportTabbarAnimation(): boolean {
    return this._isSupportTabbarAnimation;
  }

  public get maxGridLevel(): number {
    return this._maxGridLevel;
  }

  public get minGridLevel(): number {
    return this._minGridLevel;
  }

  public get defaultGridLevel(): number {
    return this._defaultGridLevel;
  }

  public get isSupportMinimal(): boolean {
    return this._isSupportMinimal;
  }

  protected override doInit(gridPrams?: IGridConfig): void {
    this.readonlyInit(gridPrams);
    this.variableInit(gridPrams);
  }

  /**
   * 不可变配置项初始化
   * @param gridPrams 配置项参数
   */
  private readonlyInit(gridPrams?: IGridConfig): void {
    this._isSupportStaggerLoading = this.getValue(gridPrams?.isSupportStaggerLoading, this._isSupportStaggerLoading);
    this._isSupportGroupDay = this.getValue(gridPrams?.isSupportGroupDay, this._isSupportGroupDay);
    this._isSupportLocationTitle = this.getValue(gridPrams?.isSupportLocationTitle, this._isSupportLocationTitle);
    this._isSupportPreload = this.getValue(gridPrams?.isSupportPreload, this._isSupportPreload);
    this._isSupportHeadMsg = this.getValue(gridPrams?.isSupportHeadMsg, this._isSupportHeadMsg);
    this._isSupportOtherIrregular = this.getValue(gridPrams?.isSupportOtherIrregular, this._isSupportOtherIrregular);
    this._isLastFormIsDayGroup = this.getValue(gridPrams?.isLastFormIsDayGroup, this._isLastFormIsDayGroup);
    this._isSupportShowTimeInTitle = this.getValue(gridPrams?.isSupportShowTimeInTitle, this._isSupportShowTimeInTitle);
    this._isSupportTabbarAnimation = this.getValue(gridPrams?.isSupportTabbarAnimation, this._isSupportTabbarAnimation);
    this._imageGutters = this.getValue(gridPrams?.imageGutters, this._imageGutters);
    this._cachedCounts = this.getValue(gridPrams?.cachedCounts, this._cachedCounts);
    this._gridPaddingLeftAndRight = this.getValue(gridPrams?.gridPaddingLeftAndRight, this._gridPaddingLeftAndRight);
    this._isSupportMinimal = this.getValue(gridPrams?.isSupportMinimal, this._isSupportMinimal);
    this._scrollbarEnableCounts = this.getValue(gridPrams?.scrollbarEnableCounts, this._scrollbarEnableCounts);
  }

  /**
   * 可变配置项初始化
   * @param gridPrams 配置项参数
   */
  private variableInit(gridPrams?: IGridConfig): void {
    this._isAutoAdjustColumns = this.getValue(gridPrams?.isAutoAdjustColumns, this._isAutoAdjustColumns);
    this._gridColumns = this.getValue(gridPrams?.gridColumns, this._gridColumns);
    this._dayColumnsGap = this.getValue(gridPrams?.dayColumnsGap, this._dayColumnsGap);
    this._groupTitleHeight = this.getValue(gridPrams?.groupTitleHeight, this._groupTitleHeight);
    this._isSupportCloudCard = this.getValue(gridPrams?.hasCloudCard, this._isSupportCloudCard);
    this._maxGridLevel = this.getValue(gridPrams?.maxGridLevel, this._maxGridLevel);
    this._minGridLevel = this.getValue(gridPrams?.minGridLevel, this._minGridLevel);
    this._defaultGridLevel = this.getValue(gridPrams?.defaultGridLevel, this._defaultGridLevel);
    this._imageColumnGutters = this.getValue(gridPrams?.imageColumnGutters, this._imageColumnGutters);
    this._isShowCameraCard = this.getValue(gridPrams?.isShowCameraCard, this._isShowCameraCard);
  }
}