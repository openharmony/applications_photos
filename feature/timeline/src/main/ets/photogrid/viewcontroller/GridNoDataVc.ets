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

import lazy { AlbumInfoType } from '../statemanager/AlbumStateManager';
import lazy { OperateStateTypeUtils } from '../statemanager/GridOperateFsm';
import lazy { SwitchMode } from '../statemanager/constants/SwitchDefine';
import lazy { DefaultVm } from '../viewmodel/DefaultVm';
import lazy { BaseAttributeUpdater, AbstractVc } from './AbstractVc';
import lazy { ViewId, ViewZIndex } from './constants/ViewDefine';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';

/**
 * 宫格无数据视图属性更新器
 */
export class NoDataAttributeUpdater extends BaseAttributeUpdater<CommonAttribute> {
  protected override initInstance(instance: CommonAttribute): void {
    super.initInstance(instance);
    instance
      .id(ViewId.NO_DATA)
      .zIndex(ViewZIndex.NO_DATA)
      .alignRules({
        top: { anchor: ViewId.CONTAINER, align: VerticalAlign.Top },
        bottom: { anchor: ViewId.CONTAINER, align: VerticalAlign.Bottom },
        start: { anchor: ViewId.CONTAINER, align: HorizontalAlign.Start },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      });
  }
}

/**
 * 宫格无数据视图控制器
 */
@Observed
export class GridNoDataVc extends AbstractVc<DefaultVm, NoDataAttributeUpdater, CommonAttribute> {
  @Track public albumInfo: AlbumInfoType;
  @Track public isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();

  public constructor() {
    super(new NoDataAttributeUpdater(), 'GridNoDataVc');
  }

  protected override initStates(): void {
    super.initStates();
    this.getOperateState((_oldState, newState) => {
      LogUtils.info("GridNoDataVc","getOperateState: " + newState);
      this.updateShowState(OperateStateTypeUtils.isInNotDataState(newState), 'OperateStateChange');
    });
    this.switchObserverProxy.getSwitchMode((oldState, _newState) => {
      this.isVerdeFoldable = _newState === SwitchMode.HIDE;
    });
    this.albumInfo = this.albumObserverProxy.getAlbumInfo();
  }
}