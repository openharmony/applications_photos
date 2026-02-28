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

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { IObserver, ObserverManager } from '@ohos/common/src/main/ets/default/utils/ObserverManager';
import lazy { TimelineDataSource } from '../../model/TimelineDataSource';
import lazy { YearMonthDataView } from '../../model/YearMonthDataView';
import lazy {
  YearMonthMediaDataSource
} from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaDataSource';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { PhotoDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImplAsync';
import lazy LightWeightMap from '@ohos.util.LightWeightMap';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { ImageUtil, TOTAL_READY_COUNT } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { FetchOptions } from '@ohos/common/src/main/ets/default/access/SendablePhotoAccessHelper';
import lazy {
  UserFileManagerAccess,
  YearMonthGroupInfo
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { TraceTaskType, TraceUtils } from './utils/TraceUtils';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { TimelineDataSourceManager } from '../../model/TimelineDataSourceManager';
import lazy { TimelineAccurateUpdater } from '@ohos/common/src/main/ets/default/model/TimelineAccurateUpdater';

const TAG: string = 'DataSourceManager';

/**
 * 数据源事件监听
 */
export interface DataSourceListener extends IObserver {
  /**
   * 数据更新回调
   *
   * @param count 数目
   */
  onDataUpdate?: (count: number) => void;

  /**
   * 数据加载完成回调
   */
  onDataLoadFinish?: (result: LoadingResult<MediaItem>) => void;

  /**
   * 日分组视图的分组更新前回调
   */
  onPreGroupInfoUpdate?: (groups: TimelineData[]) => void;

  /**
   * 日分组视图的分组更新后回调
   */
  onGroupInfoUpdate?: (groups: TimelineData[]) => void;

  /**
   * 动图拼接数据加载完成回调
   */
  onSpliceDataLoadFinish?: (result: LoadingResult<MediaItem>) => void;

  /**
   * 年月数据源数据加载完成回调
   */
  onYearMonthDataLoadFinish?: () => void;
}

/**
 * 监听数据源变化
 */
export interface ObserveDataSourceChanged {
  /**
   * 数据变化，更新图片组件转场动效属性
   *
   * @param isNeedTransition 是否支持转场动效
   */
  onDataSourceChanged?: (isNeedTransition: boolean) => void;
}

/**
 * 数据源初始化相关配置
 */
export class DataSourceConfig {
  /**
   * 是否支持头部信息，默认支持
   */
  isSupportHeadMsg: boolean = false;
}

/**
 * 数据源管理器
 */
export class DataSourceManager extends ObserverManager<DataSourceListener, DataSourceConfig> {
  // 数据源配置
  private datasourceConfig: DataSourceConfig;
  // 日视图数据源，对应之前
  protected _dayDataSource: AlbumDataSource;
  // 日分组视图数据源
  protected _groupDayDataSource: AlbumDataSource;
  // 已生成缩略图的图片和视频数量，顶部显示
  private readyImageCount: number = 0;
  private readyVideoCount: number = 0;
  //本地+云
  private bothImageCount: number = 0;
  private bothVideoCount: number = 0;
  // 图片和视频数量，顶部显示
  private imageCount: number = 0;
  private videoCount: number = 0;
  //白块数量
  private whiteBlocksImageCount: number = 0;
  private whiteBlocksVideoCount: number = 0;
  //未连接网络时，未同步缩略图的图片和视频数量
  private notReadyImageCount: number = 0;
  private notReadyVideoCount: number = 0;
  private yearGroupInfo: YearMonthGroupInfo[] = [];
  private yearMonthGroupInfo: YearMonthGroupInfo[] = [];
  // 年月日期数据内容
  private lastYearGroupInfoSize: number = 0;
  private lastYearMonthGroupInfoSize: number = 0;
  private yearMonthViewBroadCast: BroadCast = new BroadCast();
  // 图库是否处于前台
  private isActive: boolean = true;
  private isThumbnailReadyPersist: boolean = true;
  private firIndexDateTaken: number = 0;
  private readonly dataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.onDataLoadingFinished(result),
  };
  private readonly spliceDataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.onSpliceDataLoadingFinished(result),
  };

  private readonly sizeChangeListener: Function = (newState: number) => {
    LogUtils.info(this.tag, `updateCount ${newState}`);
    TraceUtils.startTrace(TraceTaskType.DATA_UPDATE);
    this.callbackObservers(observer => observer?.onDataUpdate?.(newState));
    TraceUtils.finishTrace(TraceTaskType.DATA_UPDATE);
  };

  private readonly groupChangeListener: Function = (newState: TimelineData[]) => {
    LogUtils.info(this.tag, `updateGroupData ${JSON.stringify(newState)}`);
    TraceUtils.startTrace(TraceTaskType.GROUP_INFO_UPDATE);
    this.callbackObservers(observer => observer?.onPreGroupInfoUpdate?.(newState));
    this.callbackObservers(observer => observer?.onGroupInfoUpdate?.(newState));
    TraceUtils.finishTrace(TraceTaskType.GROUP_INFO_UPDATE);
  };

  private readonly yearMonthDataLoadListener: Function = () => this.onYearMonthDataLoadFinish();

  public constructor(persistentId: number, dayDataSource?: AlbumDataSource, groupDayDataSource?: AlbumDataSource) {
    super(TAG);
    this._persistentId = persistentId;
    this._dayDataSource = dayDataSource ?? new AlbumDataSource({ context: getContext(),
      albumInfo: new AlbumInfo() });
    this._groupDayDataSource = groupDayDataSource ?? this._dayDataSource;
    this.datasourceConfig = new DataSourceConfig();
  }
  /**
   * 日视图数据源，对应之前 dataSource
   */
  public get dayDataSource(): AlbumDataSource {
    return this._dayDataSource;
  }

  /**
   * 去激活
   */
  public pause(): void {
    Log.info(this.tag, 'pause');
    this.isActive = false;
  }

  /**
   * 激活
   */
  public resume(): void {
    Log.info(this.tag, 'resume');
      this.isActive = true;
  }

  /**
   * 日分组视图数据源，对应之前 dataSourceProxy
   */
  public get groupDayDataSource(): AlbumDataSource {
    return this._groupDayDataSource;
  }

  public isEmpty(): boolean {
    return this._dayDataSource.isEmpty();
  }

  /**
   * 查询数据数量
   *
   * @returns 数据数量
   */
  public totalCount(): number {
    return this._dayDataSource.totalCount();
  }

  /**
   * 查询分组信息
   *
   * @returns 分组信息
   */
  public getGroups(): TimelineData[] {
    return this._dayDataSource.getGroupData();
  }

  /**
   * 查询是否所有缩略图生成完成
   *
   * @returns 是否所有缩略图生成完成
   */
  public isAllThumbnailReady(): boolean {
    if ((this.imageCount + this.videoCount) === (this.readyImageCount + this.readyVideoCount) &&
      this.imageCount !== 0 && this.videoCount !== 0) {
      return true;
    }
    return false;
  }

  /**
   * 获取年分组信息
   *
   * @returns 年分组信息
   */
  public getYearGroupInfo(): YearMonthGroupInfo[] {
    this.yearGroupInfo = AppStorage.get<YearMonthGroupInfo[]>('yearGroupInfo') ?? this.yearGroupInfo;
    return this.yearGroupInfo;
  }

  /**
   * 获取年分组信息
   *
   * @returns 年分组信息
   */
  public getYearMonthGroupInfo(): YearMonthGroupInfo[] {
    this.yearMonthGroupInfo = AppStorage.get<YearMonthGroupInfo[]>('yearMonthGroupInfo') ?? this.yearMonthGroupInfo;
    return this.yearMonthGroupInfo;
  }

  /**
   * 日视图和日分组视图更新滑窗状态
   * @param gridForm 宫格形态
   */
  public updateSlidingWindowState(gridForm: FormIndex) {
    if (gridForm === FormIndex.GROUP_DAY) {
      this.dayDataSource.enableDaySlidingWindow(false);
      this.groupDayDataSource.enableGroupSlidingWindow(true);
    } else if (gridForm === FormIndex.DAY) {
      this.dayDataSource.enableDaySlidingWindow(true);
      this.groupDayDataSource.enableGroupSlidingWindow(false);
    } else {
      this.dayDataSource.enableDaySlidingWindow(false);
      this.groupDayDataSource.enableGroupSlidingWindow(false);
    }
  }

  /**
   * 预加载后数据处理，年月数据初始化，云同步初始化在预加载之后
   *
   * @param initParams 配置信息
   */
  public doAfterPreload() {

  }

  protected override doInit(initParams: DataSourceConfig): void {
    super.doInit();
    this.datasourceConfig = initParams;
    this.initDataSourceManager();
    this.registerDataSourceCallback();
    if (!(this._dayDataSource instanceof TimelineDataSource)) {
      MediaObserver.getInstance().registerObserver(this._dayDataSource);
      MediaObserver.getInstance().register(MediaObserver.REGISTER_PHOTO_CHANGE,
        this._dayDataSource, `doInit_dayDataSource`);
      if (this._dayDataSource.getDataSourceMode()) {
        this._dayDataSource.notifyDirty();
      } else if (!this._dayDataSource.isInitData) {
        // 原来的initData在registerDataChangeListener中调用，由wrapper代理后需要显式调用
        this._dayDataSource.initData();
      }
    }
    this.dayDataSource.addListener(this.dataListener);
    this.dayDataSource.resume();
  }

  protected override doRelease(): void {
    super.doRelease();
    this.stopReadyProcess();
    this.unRegisterDataSourceCallback();
    if (!(this._dayDataSource instanceof TimelineDataSource)) {
      MediaObserver.getInstance().unregisterObserver(this._dayDataSource);
      MediaObserver.getInstance().unregister(MediaObserver.REGISTER_PHOTO_CHANGE,
        this._dayDataSource, `doRelease_dayDataSource`);
    }
    if (this.dayDataSource instanceof TimelineDataSource) {

    }
    this.dayDataSource.removeListener(this.spliceDataListener);
    this.yearMonthViewBroadCast.off(Constants.ON_LOADING_FINISHED, this.yearMonthDataLoadListener);
  }

  /**
   * 执行立即回调
   *
   * @param observer 观察者
   */
  protected doImmediatelyCallback?(observer: DataSourceListener): void {

  }

  private registerDataSourceCallback(): void {
    if (this.dayDataSource instanceof TimelineDataSource) {
      TimelineDataSourceManager.getInstance().getBroadCast().on(Constants.ON_GROUP_FINISHED,  this.groupChangeListener);
      TimelineDataSourceManager.getInstance().getBroadCast().on(Constants.ON_LOADING_FINISHED,  this.sizeChangeListener);
      return;
    }
    this.dayDataSource?.registerCallback('updateCount', this.sizeChangeListener);
    this.dayDataSource?.registerCallback('updateGroupData', this.groupChangeListener);
  }

  private unRegisterDataSourceCallback(): void {
    if (this.dayDataSource instanceof TimelineDataSource) {
      TimelineDataSourceManager.getInstance().getBroadCast().off(Constants.ON_GROUP_FINISHED,  this.groupChangeListener);
      TimelineDataSourceManager.getInstance().getBroadCast().off(Constants.ON_LOADING_FINISHED,  this.sizeChangeListener);
      return;
    }
    this.dayDataSource?.unregisterCallback('updateCount');
    this.dayDataSource?.unregisterCallback?.('updateGroupData');
  }

  private onSpliceDataLoadingFinished(result: LoadingResult<MediaItem>): void {
    let oldVersion: number = result.oldPageData.version;
    let newVersion: number = result.newPageData.version;
    if (newVersion > oldVersion) {
      this.callbackObservers(observer => observer?.onSpliceDataLoadFinish?.(result));
    }
  }

  private onDataLoadingFinished(result: LoadingResult<MediaItem>): void {
    TraceUtils.startTrace(TraceTaskType.DATA_LOAD_FINISH);
    // 数据加载完成回调
    this.callbackObservers(observer => observer?.onDataLoadFinish?.(result));
    TraceUtils.finishTrace(TraceTaskType.DATA_LOAD_FINISH);
  }

  private updateGroupInfo(infoVaryMap: LightWeightMap<string, number>, groupInfo: YearMonthGroupInfo[],
    isMonth: boolean): void {
    infoVaryMap.forEach((varyCount: number, key: string) => {
      const monthLength: number = 2;
      let dateString: string = key;
      if (isMonth && dateString.length > monthLength) {
        dateString = dateString.slice(0, dateString.length - monthLength) +
          `-${dateString.slice(dateString.length - monthLength)}`;
      }
      let timeStamp: number = new Date(dateString).getTime();
      let isDateExist: boolean = false;
      groupInfo.forEach(info => {
        if (info.startDate === timeStamp) {
          info.count += varyCount;
          info.count = info.count < 0 ? 0 : info.count;
          isDateExist = true;
        }
      });
      if (!isDateExist && varyCount > 0) {
        groupInfo.push({
          startDate: timeStamp, endDate: timeStamp,
          count: varyCount,
        });
      }
    });
  }

  /**
   * 获取年份信息
   * @param yearGroupInfo 年份时间戳
   * @returns 年份数组
   */
  private getYearArray(yearGroupInfo: YearMonthGroupInfo[]): number[] {
    let yearInfo: number[] = [];
    yearGroupInfo.forEach(info => {
      yearInfo.push(info.startDate);
    });
    return yearInfo;
  }

  private initDataSourceManager(): void {
    // 对日视图数据源的再封装，提供给日期分割视图使用

    this.restoreReadyStatus();
  }

  private async restoreReadyStatus(): Promise<void> {
    let thumbnailReadyFlag: boolean = await DataStoreUtil.getInstance().getData<boolean>(
      Constants.THUMBNAIL_READY_FLAG, this.readyImageCount + this.readyVideoCount < TOTAL_READY_COUNT);
    LogUtils.info(TAG,
      `restoreReadyStatus ${thumbnailReadyFlag}, ready: ${this.readyImageCount + this.readyVideoCount}`);
    ImageUtil.setThumbnailReadyFlag(thumbnailReadyFlag);
    this.isThumbnailReadyPersist = ImageUtil.thumbnailReadyFlag;
    this.dayDataSource?.setThumbnailReady(thumbnailReadyFlag);
    this.callbackObservers(observer => {});
    if (thumbnailReadyFlag) {
      this.startReadyProcess();
    } else {
      this.stopReadyProcess();
    }
  }

  public updateWifiStatus(isWifiConnected: boolean, isToggleOn: boolean): void {
    LogUtils.info(TAG, `updateWifiStatus wifi: ${isWifiConnected}, toggleOn: ${isToggleOn}`);
    if (!isWifiConnected && !isToggleOn) {
      this.stopReadyProcess();
    } else {
      this.startReadyProcess();
    }
  }

  public startReadyProcess(): void {
    LogUtils.debug(TAG, 'startReadyProcess');
    if ((this.imageCount + this.videoCount) === (this.readyImageCount + this.readyVideoCount) &&
      this.imageCount !== 0 && this.videoCount !== 0) {
      LogUtils.info(TAG, 'all thumbnail is ready, no need to start ready task');
      return;
    }
    if ( !this.isActive ) {
      return;
    }
    UserFileManagerAccess.getInstance().startCreateThumbnailTask();
  }

  public stopReadyProcess(): void {
    LogUtils.debug(TAG, 'stopReadyProcess');
    UserFileManagerAccess.getInstance().stopCreateThumbnailTask();
  }

  private onYearMonthDataLoadFinish(): void {
    LogUtils.info(this.tag, 'onYearMonthDataLoadFinish')
    this.callbackObservers(observer => observer?.onYearMonthDataLoadFinish?.());
  }

  /**
   * 关闭DataSource中的广播
   */
  public releaseBroadCast(): void {
    this.groupDayDataSource.releaseBroadCast();
    this.dayDataSource.releaseBroadCast();
  }
}