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

import lazy { AttributeStateManager } from "@ohos/common/src/main/ets/default/model/AttributeStateManager";
import lazy { AlbumInfo } from "@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo";
import lazy { ConfigObserverProxy } from "@ohos/common/src/main/ets/default/model/ConfigObserverProxy";
import lazy { ConfigStateManager } from "@ohos/common/src/main/ets/default/model/ConfigStateManager";
import lazy { StateChangeCallback } from "@ohos/common/src/main/ets/default/model/StateObserverManager";
import lazy { AlbumConfig, IAlbumConfig, IAlbumVariableConfig } from "./config/AlbumConfig";

/**
 * 相册信息类型
 */
export type AlbumInfoType = AlbumInfo | undefined;

/**
 * reload状态
 */
export enum ReloadStatusType {
  /**
   * 初始态
   */
  INIT_STATUS = 0,

  /**
   * 正在reload
   */
  RELOADING,

  /**
   * reload完成
   */
  RELOAD_FINISH,
}

/**
 * 相册观察者代理
 */
export class AlbumObserverProxy extends ConfigObserverProxy<AlbumStateManager, AlbumConfig> {
  public constructor(getProxyFunc: (persistentId: number) => AlbumStateManager) {
    super(getProxyFunc, 'AlbumObserverProxy');
  }

  /**
   * 获取相册信息
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getAlbumInfo(callback?: StateChangeCallback<AlbumInfoType>): AlbumInfoType {
    return this.getState<AlbumInfoType>(this.proxy.albumInfoAsm, callback);
  }

  /**
   * 获取reload状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getReloadStatus(callback?: StateChangeCallback<ReloadStatusType>): ReloadStatusType {
    return this.getState<ReloadStatusType>(this.proxy.reloadStatusAsm, callback);
  }
}



/**
 * 相册状态管理器
 */
export class AlbumStateManager extends ConfigStateManager<AlbumConfig, IAlbumConfig, IAlbumVariableConfig> {
  public override readonly config: AlbumConfig = new AlbumConfig();

  /**
   * 相册信息管理器
   */
  public readonly albumInfoAsm: AttributeStateManager<AlbumInfoType>;

  /**
   * reload状态管理器
   * @param persistentId
   */
  public readonly reloadStatusAsm: AttributeStateManager<ReloadStatusType>;

  public constructor(persistentId: number) {
    super(persistentId, 'AlbumStateManager');
    this.albumInfoAsm = new AttributeStateManager(persistentId, undefined, 'AlbumInfo');
    this.reloadStatusAsm = new AttributeStateManager(persistentId, ReloadStatusType.INIT_STATUS, 'ReloadStatus');
  }

  /**
   * 更新相册信息
   *
   * @param type 列数模板
   */
  public updateAlbumInfo(albumInfo: AlbumInfoType, reason?: string): void {
    return this.albumInfoAsm.updateState(albumInfo, reason);
  }

  /**
   * 更新宫格reload状态
   *
   * @param status reload状态
   */
  public updateReloadStatus(status: ReloadStatusType, reason?: string): void {
    return this.reloadStatusAsm.updateState(status, reason);
  }

  public override updateStateFromVariableConfig(config?: IAlbumVariableConfig, reason?: string): void {
    if (!!config?.albumInfo) {
      this.updateAlbumInfo(config?.albumInfo, reason);
    }
  }

  protected override updateStateFromInitConfig(config: AlbumConfig, reason?: string): void {
  }
}