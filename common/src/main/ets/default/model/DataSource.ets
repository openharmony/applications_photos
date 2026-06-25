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
import lazy { Log } from '../utils/Log';
import lazy { MediaObserverCallback, MediaObserverNfyInfo } from './browser/dataObserver/MediaObserverCallback';
import lazy { PageData } from './PageData';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';

const TAG: string = 'DataSource';

/**
 * 变更类型
 */
export enum ChangeType {
  /**
   * 数据变化
   */
  DATA = 'DATA',
  /**
   * 滑窗变化
   */
  WINDOW = 'WINDOW'
}

/**
 * 信息
 */
export interface ChangeInfo {
  /**
   * 变化类型
   */
  readonly changeType: ChangeType;
}

/**
 * 数据加载状态机
 */
export enum LoadingState {
  /**
   * 待加载
   */
  WAIT_TO_LOAD = 'WAIT_TO_LOAD',
  /**
   * 加载中，但是仍有新的数据变更
   */
  LOADING_HAS_PENDING = 'LOADING_HAS_PENDING',
  /**
   * 数据加载中
   */
  LOADING = 'LOADING',
  /**
   * 空闲
   */
  IDLE = 'IDLE'
}

/**
 * 数据加载信息
 */
export interface LoadingInfo {
  /**
   * 数据加载起点
   */
  readonly start: number;

  /**
   * 数据加载量
   */
  readonly count: number;
}

export const NO_NEED: LoadingInfo = { start: -1, count: -1, };

/**
 * 数据加载任务
 */
export abstract class LoadingTask<T> {
  /**
   * 加载信息
   */
  public readonly info: LoadingInfo;
  /**
   * 数据源
   */
  public readonly source: DataSource<T>;
  /**
   * 当前滑窗数据
   */
  public readonly pageData: PageData<T>;
  /**
   * 任务加载的数据版本号
   */
  protected loadVersion: number = 0;

  /**
   * 构造函数
   * @param info 加载信息
   * @param source 数据源
   * @param pageData 当前滑窗数据
   */
  public constructor(info: LoadingInfo, source: DataSource<T>, pageData: PageData<T>) {
    this.info = info;
    this.source = source;
    this.pageData = pageData;
    this.loadVersion = this.source?.getLatestVersion() ?? 0;
  }

  /**
   * 开始加载
   * @returns promise
   */
  public abstract start(): Promise<LoadingResult<T>>;
}

/**
 * 数据加载结果
 */
export interface LoadingResult<T> {
  /**
   * 加载信息
   */
  readonly info: LoadingInfo;

  /**
   * 旧滑窗数据
   */
  readonly oldPageData: PageData<T>;

  /**
   * 新滑窗数据
   */
  readonly newPageData: PageData<T>;
}

/**
 * 加载监听
 */
export interface DataListener<T> {
  /**
   * 回调
   */
  /* instrument ignore next */
  onLoadingFinished?: (result: LoadingResult<T>) => void;
}

/**
 * 加载事件派发器
 */
export class DataEventDispatcher<T> implements DataListener<T> {
  private static readonly TAG: string = 'DataEventDispatcher';
  private readonly listeners: DataListener<T>[] = [];

  /**
   * 回调
   */
  public onLoadingFinished(result: LoadingResult<T>): void {
    for (let listener of this.listeners) {
      try {
        listener.onLoadingFinished?.(result);
      } catch (e) {
        Log.warn(DataEventDispatcher.TAG, `onLoadingFinished dispatch failed err: ${(e as Error)?.message}`);
      }
    }
  }

  /**
   * 添加
   * @param listener 监听
   */
  public add(listener: DataListener<T>): void {
    if (!listener || this.listeners.indexOf(listener) !== -1) {
      return;
    }
    this.listeners.push(listener);
  }

  /**
   * 移除
   * @param listener 监听
   */
  public remove(listener: DataListener<T>): void {
    if (!listener) {
      return;
    }
    let index = this.listeners.indexOf(listener);
    if (index === -1) {
      return;
    }
    this.listeners.splice(index, 1);
  }
}

/**
 * 数据源
 */
export abstract class DataSource<T> implements MediaObserverCallback {
  /**
   * 数据加载超时时长，如果超过该时长，即认为查询失败
   */
  public static readonly DATA_LOAD_TIMEOUT_MS = 3 * 60 * 1000;
  /**
   * 最小数据加载间隔，防止过快的数据查询
   */
  public static readonly MIN_LOAD_INTERVAL = 100;
  /**
   * 默认窗口大小
   */
  public static readonly DEFAULT_WIN_SIZE = 500;
  /**
   * 首批数据大小
   */
  public static readonly DEFAULT_INIT_SIZE = 120;
  /**
   * 滑窗移动超过该值时才真正触发数据刷新
   */
  public static readonly DEFAULT_SLIDE_STEP = 100;
  /**
   * 是否激活态，一般退后台后进入非激活态
   */
  public isActive: boolean = true;
  /**
   * 最新数据版本
   */
  public latestVersion: number = 0;
  /**
   * 监听
   */
  public listeners: DataChangeListener[] = [];
  /**
   * 窗口起点（包含起点）
   */
  public activeStart: number = 0;
  /**
   * 窗口终点（不包含终点）
   */
  public activeEnd: number = DataSource.DEFAULT_INIT_SIZE;
  /**
   * 滑窗大小
   */
  public windowSize: number = DataSource.DEFAULT_WIN_SIZE;
  /**
   * 滑窗数据
   */
  protected pageData: PageData<T> = new PageData();
  /**
   * 滑窗更新步长
   */
  protected stepSize: number = DataSource.DEFAULT_SLIDE_STEP;
  /**
   * 事件派发器
   */
  protected dispatcher: DataEventDispatcher<T> = new DataEventDispatcher<T>();
  /**
   * 加载状态
   */
  protected state: LoadingState = LoadingState.IDLE;
  /**
   * 日志tag
   */
  protected tag: string = TAG;
  /**
   * 进入加载态时间，用于兜底保护，防止因加载失败卡在加载态
   */
  protected lastLoadingStartTime: number = -1;
  protected initCount: number | undefined = undefined;

  public constructor() {
    this.latestVersion = this.pageData.version + 1;
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
    if (!this.isActive) {
      this.isActive = true;
      this.load(this.buildPendingChangeInfo());
    }
  }

  /**
   * 设置状态
   * @param state 状态
   */
  protected setState(state: LoadingState): void {
    Log.info(this.tag, `LoadingState: ${this.state} -> ${state}`);
    this.state = state;
    switch (state) {
      case LoadingState.LOADING:
        this.lastLoadingStartTime = Date.now();
        break;
      case LoadingState.IDLE:
      case LoadingState.WAIT_TO_LOAD:
        // idle/wait是长期停留态，loading/pending常规场景下是暂态，回到停留态时重置
        this.lastLoadingStartTime = -1;
        break;
      default:
        break;
    }
  }

  /**
   * 通知重新加载数据
   */
  public notifyDirty(changeInfo: ChangeInfo = { changeType: ChangeType.DATA }): void {
    let isLoading: boolean = this.state === LoadingState.LOADING || this.state === LoadingState.LOADING_HAS_PENDING;
    let isTimeout: boolean = this.lastLoadingStartTime > 0 &&
      (Date.now() - this.lastLoadingStartTime > DataSource.DATA_LOAD_TIMEOUT_MS);
    if (isLoading && isTimeout) {
      Log.warn(this.tag, `load data timeout last: ${this.lastLoadingStartTime}, reset to idle`);
      this.setState(LoadingState.IDLE);
    }

    let msg: string[] = [];
    msg.push(`notifyDirty active: ${this.isActive}`);
    msg.push(`state: ${this.state}`);
    msg.push(`type: ${changeInfo?.changeType}`);
    if (changeInfo?.changeType === ChangeType.DATA) {
      // 数据变更场景，刷新版本号
      this.latestVersion = PageData.nextVersion();
      msg.push(`ver: ${this.latestVersion}`);
    }
    Log.info(this.tag, `notifyDirty, msg:${msg.join(', ')}`);
    switch (this.state) {
      case LoadingState.LOADING:
        Log.info(this.tag, 'notifyDirty, setState.');
        this.setState(LoadingState.LOADING_HAS_PENDING);
        break;
      case LoadingState.IDLE:
        Log.info(this.tag, 'notifyDirty, load data');
        this.setState(LoadingState.WAIT_TO_LOAD);
        this.load(changeInfo);
        break;
      default:
        Log.info(this.tag, 'notifyDirty, skip notify.');
        break;
    }
  }

  /**
   * 通知数据加载完成
   * @param result 加载结果
   */
  protected notifyDataLoaded(result: LoadingResult<T>): void {
    let msg: string[] = [];
    msg.push(`notifyLoadingFinished isActive: ${this.isActive}`);
    Log.info(this.tag, msg.join(', '));
    this.pageData = result?.newPageData ?? new PageData();
    if (result.oldPageData !== result.newPageData) {
      this.dispatchUpdates(result);
    } else {
      Log.warn(this.tag, 'no need to dispatchUpdates');
    }

    switch (this.state) {
      case LoadingState.LOADING_HAS_PENDING:
        // 加载完毕，如果有挂起的更新，先清除pending态，转换到wait态，再尝试加载
        this.setState(LoadingState.WAIT_TO_LOAD);
        this.load(this.buildPendingChangeInfo()); // 可能转换到Loading
        break;
      case LoadingState.LOADING:
        // 无挂起的更新，清除dirty状态，完成加载，转换到idle态
        this.setState(LoadingState.IDLE);
        break;
      default:
        break;
    }
  }

  /**
   * 派发加载结果
   * @param result 结果
   */
  protected dispatchUpdates(result: LoadingResult<T>): void {
    this.dispatcher.onLoadingFinished(result);
  }

  /**
   * 数据总量
   * @returns 总量
   */
  public totalCount(): number {
    return this.pageData.size;
  }

  /**
   * 添加
   * @param listener 监听
   */
  public addListener(listener: DataListener<T>): void {
    this.dispatcher.add(listener);
  }

  /**
   * 移除
   * @param listener 监听
   */
  public removeListener(listener: DataListener<T>): void {
    this.dispatcher.remove(listener);
  }

  /**
   * 获取数据
   * @param index 下标
   * @returns 数据
   */
  public getPageData(index: number): T | undefined {
    return this.pageData.getData(index);
  }

  public getLatestVersion(): number {
    return this.latestVersion;
  }

  protected isValidDataIndex(index: number): boolean {
    return Number.isFinite(index) && index !== null && index !== undefined && index >= 0 && index < this.pageData.size;
  }

  /**
   * 更新滑窗
   * @param index 下标
   */
  /* instrument ignore next */
  public updateSlidingWindow(index: number): void {
    if (!this.isValidDataIndex(index)) {
      Log.warn(this.tag, `updateSlidingWindow invalid data index: ${index}, total: ${this.pageData.size}`);
      return;
    }
    let windowCenter = Math.round((this.activeStart + this.activeEnd) / 2);
    if (Math.abs(index - windowCenter) < this.stepSize) {
      // 数据相较窗口中心的偏移值不超过一个步长时，不触发滑窗更新
      return;
    }

    // 滑窗已经对齐数据集起点/终点时不再滑动
    if (index < windowCenter && this.activeStart === 0) {
      return;
    }
    if (index > windowCenter && this.activeEnd >= this.pageData.size) {
      return;
    }

    let winStart: number = this.activeStart;
    let winEnd: number = this.activeEnd;
    if (this.windowSize >= this.pageData.size) {
      // 窗口比总量大的场景，窗口移到[0, winSize]
      winStart = 0;
      winEnd = this.windowSize;
    } else {
      // 窗口比总量小的场景，以index为中心，计算新的窗口位置，起点取值范围为[0, size - winSize]
      winStart = Math.max(0, index - Math.round(this.windowSize / 2));
      winStart = Math.min(winStart, this.pageData.size - this.windowSize);
      winEnd = winStart + this.windowSize;
    }

    // 调整滑窗，触发查询
    TraceControllerUtils.startTrace('updateSlidingWindow');
    this.onSlidingWindowChanged(winStart, winEnd);
    Log.info(this.tag, `updateSlidingWindow (${this.activeStart},${this.activeEnd}) -> (${winStart},${winEnd})`);
    this.activeStart = winStart;
    this.activeEnd = winEnd;
    this.notifyDirty({ changeType: ChangeType.WINDOW });
    TraceControllerUtils.finishTrace('updateSlidingWindow');
  }

  protected onSlidingWindowChanged(winStart: number, winEnd: number): void {
  }

  /**
   * 在LOADING/非激活态可能拦截一些数据通知，这个场景下在当前加载任务完成时触发数据加载，按需把这些挂起的通知封装到ChangeInfo里
   * @returns 变化信息
   */
  protected buildPendingChangeInfo(): ChangeInfo {
    return { changeType: ChangeType.DATA };
  }

  /**
   * 构造数据加载信息，包含起点、数量等，对比当前的窗口起止与已有的滑窗数据，确定数据加载范围
   * @returns 加载信息
   */
  /* instrument ignore next */
  protected buildLoadingInfo(changeInfo: ChangeInfo): LoadingInfo {
    // 数据层变更场景整个窗口内的要重新查询
    let msg: string[] = [`buildLoadingInfo as: ${this.activeStart}, ae: ${this.activeEnd}`];
    msg.push(`before: ${this.pageData.placeholdersBefore}, length: ${this.pageData.data.length}`);
    Log.info(this.tag, msg.join(', '));
    if (this.latestVersion > this.pageData.version) {
      return { start: this.activeStart, count: this.activeEnd - this.activeStart, };
    }

    // 新窗口与当前滑窗数据无交集场景
    if ((this.activeStart >= this.pageData.placeholdersBefore + this.pageData.data.length) ||
      this.activeEnd <= this.pageData.placeholdersBefore) {
      return { start: this.activeStart, count: this.activeEnd - this.activeStart, };
    }

    // 当前滑窗数据已经覆盖新窗口场景
    if (this.activeStart >= this.pageData.placeholdersBefore &&
      this.activeStart < this.pageData.placeholdersBefore + this.pageData.data.length &&
      this.activeEnd <= this.pageData.placeholdersBefore + this.pageData.data.length) {
      return NO_NEED;
    }

    // 新窗口比当前滑窗数据范围大场景，且覆盖当前数据场景
    if (this.activeStart < this.pageData.placeholdersBefore &&
      this.activeEnd > this.pageData.placeholdersBefore + this.pageData.data.length) {
      return { start: this.activeStart, count: this.activeEnd - this.activeStart, };
    }

    // 两者单边相交场景
    let start: number = this.activeStart < this.pageData.placeholdersBefore ? this.activeStart :
      this.pageData.placeholdersBefore + this.pageData.data.length - 1;
    let end: number = this.activeStart < this.pageData.placeholdersBefore ?
    this.pageData.placeholdersBefore : this.activeEnd;
    return { start: start, count: end - start, };
  }

  /**
   * 构建加载任务
   * @param info 加载信息
   * @returns 任务
   */
  protected abstract buildLoadingTask(info: LoadingInfo): LoadingTask<T> | undefined;

  /**
   * 加载数据，
   * @param info
   * @returns
   */
  protected async load(changeInfo: ChangeInfo): Promise<void> {
    if (!this.isActive || !(this.state === LoadingState.WAIT_TO_LOAD)) {
      Log.info(this.tag, `skip load data, isActive:${this.isActive}, state:${this.state}`);
      return;
    }

    this.setState(LoadingState.LOADING);
    let loadingInfo: LoadingInfo = this.buildLoadingInfo(changeInfo);
    let loadingTask: LoadingTask<T> | undefined = this.buildLoadingTask(loadingInfo);
    if (!loadingTask) {
      // 不需要加载的场景，直接派发，驱动状态机到下一个状态
      this.notifyDataLoaded({ info: loadingInfo, oldPageData: this.pageData, newPageData: this.pageData, });
    } else {
      loadingTask?.start()
        .then((result: LoadingResult<T>) => {
          this.notifyDataLoaded(result);
        })
        .catch((err: Error) => {
          Log.error(this.tag, `load failed ${err?.message}`);
          this.setState(LoadingState.WAIT_TO_LOAD);
          this.load(changeInfo);
        });
    }
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    let before: number = this.listeners.length;
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
    Log.info(this.tag, `add listener ${before} -> ${this.listeners.length}`);
  }

  /* instrument ignore next */
  public unregisterDataChangeListener(listener: DataChangeListener): void {
    let before: number = this.listeners.length;
    let pos: number = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
    Log.info(this.tag, `remove listener ${before} -> ${this.listeners.length}`);
  }

  public notifyDatasetChanged(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    });
  }

  public onDataReloaded(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  public onDataAdd(layoutIndex: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(layoutIndex);
    });
  }

  public onDataDelete(layoutIndex: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(layoutIndex);
    });
  }

  public onDataChange(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    });
  }

  public onChange(mediaType: string): void {
    this.notifyDirty();
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    this.notifyDirty();
  }
}