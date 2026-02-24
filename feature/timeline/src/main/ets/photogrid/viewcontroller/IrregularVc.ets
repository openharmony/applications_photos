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

import lazy { SwitchType } from '../statemanager/common/SwitchStartInfo';
import lazy { PullDownState, ShowMode } from '../statemanager/constants/GridDefine';
import lazy { IrregularVm } from '../viewmodel/IrregularVm';
import lazy { AbstractVc, BaseAttributeUpdater } from './AbstractVc';
import lazy { ViewId, ViewZIndex } from './constants/ViewDefine';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';

/**
 * 不规则区域属性更新器
 */
export class IrregularViewAttributeUpdater extends BaseAttributeUpdater<ColumnAttribute> {
  protected initInstance(instance: ColumnAttribute): void {
    super.initInstance(instance);
    instance
      .id(ViewId.IRREGULAR_VIEW)
      .zIndex(ViewZIndex.IRREGULAR_VIEW)
      .hitTestBehavior(HitTestMode.Transparent)
      .justifyContent(FlexAlign.End)
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .alignRules({
        bottom: { anchor: ViewId.IRREGULAR_BOTTOM_GUIDELINE, align: VerticalAlign.Bottom },
        start: { anchor: ViewId.CONTAINER, align: HorizontalAlign.Start },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      });
  }
}

/**
 * 不规则区域视图控制器
 */
@Observed
export class IrregularVc extends AbstractVc<IrregularVm, IrregularViewAttributeUpdater> {
  /**
   * 是否显示消息头
   */
  @Track public isShowHeadMsg: boolean = false;

  /**
   * 是否显示云同步卡片
   */
  @Track public isShowCloudSyncCard: boolean = false;

  /**
   * 是否显示排序选择器
   */
  @Track public isShowSortSelector: boolean = false;

  public extraParams: ParamsWrapper = new ParamsWrapper();

  public constructor(attributeUpdater: IrregularViewAttributeUpdater = new IrregularViewAttributeUpdater(),
    tag: string = 'IrregularVc', showMode: ShowMode = ShowMode.VISIBLE) {
    super(attributeUpdater, tag, showMode );
  }

  protected override initStates(): void {
    super.initStates();
    // 初始化消息头是否可见
    this.isShowHeadMsg = this.gridObserverProxy.config.isSupportHeadMsg;

    // 初始化排序选择是否可见
    this.isShowSortSelector = this.albumObserverProxy.config.isSupportSortSelector;

    // 更新消息头可见性
    this.gridObserverProxy.getIsSwitching((_oldState, _newState, switchType?: SwitchType) => {
      this.updateShow(switchType, 'IsSwitchingChange');
    });

    //更新不规则item在宫格区域的左右padding
    let gridPaddingLeftAndRight: number = this.gridObserverProxy.getGridPaddingLeftAndRight();
    this.attributeUpdater.updatePadding({
      start: LengthMetrics.vp(gridPaddingLeftAndRight),
      end: LengthMetrics.vp(gridPaddingLeftAndRight),
    });

    this.extraParams = this.albumObserverProxy.config.extraParams;
  }

  private updateShow(switchType?: SwitchType, reason?: string): void {
    this.updateShowState(!this.gridObserverProxy.getIsSwitching() || (switchType === SwitchType.SWITCH_BUTTON &&
      this.gridObserverProxy.getHeadMsgPullDownState() === PullDownState.FULL), reason);
  }
}