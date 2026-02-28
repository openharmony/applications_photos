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

import lazy { AttributeStateManager } from '@ohos/common/src/main/ets/default/model/AttributeStateManager';
import lazy { AbstractInitialAble } from '@ohos/common/src/main/ets/default/utils/AbstractInitialAble';
import lazy { IdGenerator } from '@ohos/common/src/main/ets/default/utils/IdGenerator';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { DataSourceListener, DataSourceManager } from '../model/DataSourceManager';
import lazy { IDisplayConfig } from './config/DisplayConfig';
import lazy { IGridConfig } from './config/GridConfig';
import lazy { IPinchConfig } from './config/PinchConfig';
import lazy { IScrollerConfig } from './config/ScrollerConfig';
import lazy { ISelectConfig } from './config/SelectConfig';
import lazy { ISwitchConfig } from './config/SwitchConfig';
import lazy { ITitleBarConfig } from './config/TitleBarConfig';
import lazy { IToolbarConfig } from './config/ToolbarConfig';
import lazy { DisplayStateManager } from './DisplayStateManager';
import lazy { GridFormFsm } from './GridFormFsm';
import lazy { GridOperateFsm } from './GridOperateFsm';
import lazy { GridPreloadFsm } from './GridPreloadFsm';
import lazy { GridStateManager } from './GridStateManager';
import lazy { PinchStateManager } from './PinchStateManager';
import lazy { ScrollerStateManager } from './ScrollerStateManager';
import lazy { SelectStateManager } from './SelectStateManager';
import lazy { SwitchStateManager } from './SwitchStateManager';
import lazy { TitleBarStateManager } from './TitleBarStateManager';
import lazy { ToolbarStateManager } from './ToolbarStateManager';
import lazy { TimelineSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { GroupInfo } from './common/GroupInfo';
import lazy { FormIndex } from './constants/GridDefine';
import lazy { IStateChangeObserver } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { AlbumStateManager } from './AlbumStateManager';
import lazy { IAlbumConfig } from './config/AlbumConfig';
import lazy { bindSheetLoaderParams } from '../../albumgrid/view/albumCover/AlbumCoverSelectLoaderParams';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';

/**
 * 初始化配置
 */
export interface InitConfig {
  /**
   * 宫格配置
   */
  gridConfig?: IGridConfig;

  /**
   * 切换配置
   */
  switchConfig?: ISwitchConfig;

  /**
   * 捏合配置
   */
  pinchConfig?: IPinchConfig;

  /**
   * 工具栏配置
   */
  toolbarConfig?: IToolbarConfig;

  /**
   * 标题栏配置
   */
  titleBarConfig?: ITitleBarConfig;

  /**
   * 多选配置
   */
  selectConfig?: ISelectConfig;

  /**
   * 屏幕配置
   */
  displayConfig?: IDisplayConfig;

  /**
   * 滚动条配置
   */
  scrollerConfig?: IScrollerConfig;

  /**
   * 相册配置
   */
  albumConfig?: IAlbumConfig;

  /**
   * 宫格数据源管理器
   */
  dataSourceManager?: DataSourceManager;

  /**
   * 宫格数据源管理器，异步方式
   */
  asyncDataSourceManager?: Promise<DataSourceManager>

  /**
   * bindSheet配置
   */
  bindSheetConfig?: bindSheetLoaderParams;
}

/**
 * 宫格状态代理
 */
export class GridStateProxy extends AbstractInitialAble<InitConfig> {
  /**
   * 宫格状态代理列表
   */
  private static readonly INSTANCES: Map<number, GridStateProxy> = new Map();
  /**
   * ID生成器
   */
  private static readonly ID_GENERATOR: IdGenerator = new IdGenerator();

  /**
   * 生成新ID
   *
   * @returns 新ID
   */
  public static getNewProxyId(): number {
    return GridStateProxy.ID_GENERATOR.generatorId();
  }

  /**
   * 获取对应的实例
   *
   * @param persistentId 实例化ID
   * @returns 对应的状态机代理
   */
  public static getInstance(persistentId: number): GridStateProxy {
    let instance: GridStateProxy | undefined = GridStateProxy.INSTANCES.get(persistentId);
    if (!!instance) {
      return instance;
    }
    instance = new GridStateProxy(persistentId);
    GridStateProxy.INSTANCES.set(persistentId, instance);
    return instance;
  }

  /**
   * 检查是否存在对应的实例
   *
   * @param persistentId 实例化ID
   *
   * @returns 是否存在对应实例
   */
  public static checkInstance(persistentId: number): boolean {
    let instance: GridStateProxy | undefined = GridStateProxy.INSTANCES.get(persistentId);
    return !!instance;
  }

  /**
   * 释放对应的实例
   *
   * @param persistentId 实例化ID
   */
  public static releaseInstance(persistentId: number): void {
    if (GridStateProxy.INSTANCES.has(persistentId)) {
      let instance: GridStateProxy | undefined = GridStateProxy.INSTANCES.get(persistentId);
      if (instance && GridStateProxy.INSTANCES.delete(persistentId)) {
        instance.release();
      }
    }
  }

  /**
   * 宫格操作状态机
   */
  public readonly waitDataSourceManagerAsm: AttributeStateManager<boolean>;
  /**
   * 宫格操作状态机
   */
  public readonly operateFsm: GridOperateFsm;
  /**
   * 宫格形态状态机
   */
  public readonly formFsm: GridFormFsm;
  /**
   * 宫格预览状态机
   */
  public readonly preloadFsm: GridPreloadFsm;
  /**
   * 屏幕显示状态管理器
   */
  public readonly displayStateManager: DisplayStateManager;
  /**
   * 宫格状态管理器
   */
  public readonly gridStateManager: GridStateManager;
  /**
   * 切换状态管理器
   */
  public readonly switchStateManager: SwitchStateManager;
  /**
   * 捏合状态管理器
   */
  public readonly pinchStateManager: PinchStateManager;
  /**
   * 工具栏状态管理器
   */
  public readonly toolbarStateManager: ToolbarStateManager;
  /**
   * 标题栏状态管理器
   */
  public readonly titleBarStateManager: TitleBarStateManager;
  /**
   * 多选状态管理器
   */
  public readonly selectStateManager: SelectStateManager;
  /**
   * 滚动条状态管理器
   */
  public readonly scrollerStateManager: ScrollerStateManager;
  /**
   * 相册状态管理器
   */
  public readonly albumStateManager: AlbumStateManager;
  /**
   * 大图浏览态动效状态管理器（是否动效中）
   */
  public readonly browserAnimAsm: AttributeStateManager<boolean>;
  public timeController: TimeController | undefined;
  public immersiveController: ImmersiveController | undefined;
  /**
   * 分组信息
   */
  public readonly groupInfo: GroupInfo = new GroupInfo();
  /**
   * 宫格数据源管理器
   */
  private _dataSourceManager?: DataSourceManager;
  private readonly dataSourceListener: DataSourceListener = {
    onPreGroupInfoUpdate: (): void => this.updateGroupInfo(),
  };
  private readonly imageHeightListener: IStateChangeObserver<number> = {
    onStateChange: (): void => this.updateGroupInfo(),
  };
  private readonly columnsListener: IStateChangeObserver<number> = {
    onStateChange: (): void => this.updateGroupInfo(),
  };

  private constructor(persistentId: number) {
    super('GridStateProxy');
    this._persistentId = persistentId;

    // 是否在等待数据源状态
    this.waitDataSourceManagerAsm = new AttributeStateManager(persistentId, false, 'WaitDataSourceManager');

    // 状态机
    this.formFsm = new GridFormFsm(persistentId);
    this.operateFsm = new GridOperateFsm(persistentId);
    this.preloadFsm = new GridPreloadFsm(persistentId);

    // 状态管理器
    this.displayStateManager = new DisplayStateManager(persistentId);
    this.gridStateManager = new GridStateManager(persistentId, this.formFsm, this.displayStateManager);
    this.switchStateManager = new SwitchStateManager(persistentId, this.formFsm);
    this.pinchStateManager = new PinchStateManager(persistentId, this.formFsm);
    this.toolbarStateManager = new ToolbarStateManager(persistentId);
    this.titleBarStateManager = new TitleBarStateManager(persistentId);
    this.selectStateManager = new SelectStateManager(persistentId, this.operateFsm);
    this.scrollerStateManager = new ScrollerStateManager(persistentId, this.formFsm);
    this.albumStateManager = new AlbumStateManager(persistentId);

    // 其他暂未分类状态
    this.browserAnimAsm = new AttributeStateManager(persistentId, false, 'BrowserAnim');
  }

  /**
   * 初始化子组件状态管理者
   *
   * @param timeController 时间标签管理者
   * @param immersiveController 沉浸态管理者
   */
  public initSubComponentState(timeController?: TimeController, immersiveController?: ImmersiveController) {
    this.timeController = timeController;
    this.immersiveController = immersiveController;
  }

  /**
   * 宫格数据源管理器
   *
   * @returns 宫格数据源管理器
   */
  public get dataSourceManager(): DataSourceManager {
    if (this._dataSourceManager === undefined) {
      this._dataSourceManager = new DataSourceManager(this.persistentId, undefined, undefined);
    }
    return this._dataSourceManager;
  }

  /**
   * 获取宫格数据源DataSourceManager
   *
   * @returns 宫格数据源
   */
  public getDataSourceManager(): DataSourceManager | undefined {
    return this._dataSourceManager;
  }

  public get selectManager(): TimelineSelectManager {
    return this.selectStateManager.selectManager;
  }

  protected override doInit(initParams: InitConfig): void {
    // 状态管理器
    this.displayStateManager.init(initParams.displayConfig);
    this.gridStateManager.init(initParams.gridConfig);
    this.switchStateManager.init(initParams.switchConfig);
    this.pinchStateManager.init(initParams.pinchConfig);
    this.toolbarStateManager.init(initParams.toolbarConfig);
    this.titleBarStateManager.init(initParams.titleBarConfig);
    this.selectStateManager.init(initParams.selectConfig);
    this.scrollerStateManager.init(initParams.scrollerConfig);
    this.albumStateManager.init(initParams.albumConfig);

    this._dataSourceManager?.releaseBroadCast();
    this._dataSourceManager?.release();
    // 数据源
    if (!!initParams.asyncDataSourceManager) {
      this.asyncInitDataSourceManager(initParams.asyncDataSourceManager);
    } else {
      if (!!initParams.dataSourceManager) {
        this._dataSourceManager = initParams.dataSourceManager;
      }
      this.initDataSourceManager();
    }
  }

  protected override doRelease(): void {
    // 状态管理器
    this.gridStateManager.release();
    this.switchStateManager.release();
    this.pinchStateManager.release();
    this.toolbarStateManager.release();
    this.titleBarStateManager.release();
    this.selectStateManager.release();
    this.scrollerStateManager.release();
    this.displayStateManager.release();
    this.albumStateManager.release();

    // 数据源
    this.dataSourceManager.release();
    this.releaseGroupInfoObservers();
  }

  private asyncInitDataSourceManager(getDataSourceManager: Promise<DataSourceManager>): void {
    this.waitDataSourceManagerAsm.updateState(true, this.tag);
    try {
      getDataSourceManager
        .then((dataSourceManager: DataSourceManager) => {
          this._dataSourceManager = dataSourceManager;
          this.initDataSourceManager();
          this.waitDataSourceManagerAsm.updateState(false, this.tag);
        })
        .catch(() => LogUtils.error(this.tag, 'asyncInitDataSourceManager failed.'));
    } catch (error) {
      LogUtils.error(this.tag, 'asyncInitDataSourceManager error.');
    }
  }

  private initDataSourceManager(): void {
    this.dataSourceManager.init({
      isSupportHeadMsg: this.gridStateManager.config.isSupportHeadMsg,
    });
    this.initGroupInfoObservers();
  }

  private initGroupInfoObservers(): void {
    if (!this.gridStateManager.config.isSupportGroupDay) {
      return;
    }
    this.dataSourceManager.registerObserver(this.dataSourceListener);
    this.gridStateManager.getImageHeightManager(FormIndex.GROUP_DAY).registerObserver(this.imageHeightListener);
    this.gridStateManager.getColumnManager(FormIndex.GROUP_DAY).registerObserver(this.columnsListener);
  }

  private releaseGroupInfoObservers(): void {
    if (!this.gridStateManager.config.isSupportGroupDay) {
      return;
    }
    this.dataSourceManager.unRegisterObserver(this.dataSourceListener);
    this.gridStateManager.getImageHeightManager(FormIndex.GROUP_DAY).unRegisterObserver(this.imageHeightListener);
    this.gridStateManager.getColumnManager(FormIndex.GROUP_DAY).unRegisterObserver(this.columnsListener);
  }

  private updateGroupInfo(): void {
    const gutter: number = this.gridStateManager.getImageGutterManager(FormIndex.GROUP_DAY).currentState;
    this.groupInfo.refresh(this.dataSourceManager.getGroups(),
      this.gridStateManager.groupTitleHeightAsm.currentState + gutter,
      this.gridStateManager.getImageHeightManager(FormIndex.GROUP_DAY).currentState + gutter,
      this.gridStateManager.getColumnManager(FormIndex.GROUP_DAY).currentState);
    this.gridStateManager.getGridHeightManager(FormIndex.GROUP_DAY).updateState(this.groupInfo.totalHeight, this.tag);
  }
}