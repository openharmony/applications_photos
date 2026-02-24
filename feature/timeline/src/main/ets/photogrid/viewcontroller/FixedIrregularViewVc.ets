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
import lazy { PullDownState } from '../statemanager/constants/GridDefine';
import lazy { AbstractVc, BaseAttributeUpdater } from './AbstractVc';
import lazy { ViewId, ViewZIndex } from './constants/ViewDefine';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { FixedIrregularViewVm } from '../viewmodel/FixedIrregularViewVm';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { OperateStateTypeUtils, OperateStateType } from '../statemanager/GridOperateFsm';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy {
  isOrientationHorizontal,
  updateAlbumPageGridPaddingLeftAndRight
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';

const EPSILON = 1;
const BASE = 1;

/**
 * 固定不规则区域视图属性更新器
 */
export class FixedIrregularViewAttributeUpdater extends BaseAttributeUpdater<ColumnAttribute> {
  protected initInstance(instance: ColumnAttribute): void {
    super.initInstance(instance);
    instance
      .id(ViewId.FIXED_IRREGULAR_VIEW)
      .zIndex(ViewZIndex.FIXED_IRREGULAR_VIEW)
      .hitTestBehavior(HitTestMode.Transparent)
      .justifyContent(FlexAlign.End)
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .alignRules({
        top: { anchor: ViewId.TITLE_BAR, align: VerticalAlign.Bottom },
        start: { anchor: ViewId.CONTAINER, align: HorizontalAlign.Start },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      })
  }
}

/**
 * 固定不规则区域视图控制器
 */
@Observed
export class FixedIrregularViewVc extends AbstractVc<FixedIrregularViewVm, FixedIrregularViewAttributeUpdater> {
  // 是否显示回收站消息头
  @Track public isShowTrashMessage: boolean = false;
  @Track public isShowSdCard: boolean = this.gridObserverProxy.getSdCardState();
  @Track public cardName: string = this.gridObserverProxy.getCardName();
  @Track public cardShowTitle: string | Resource = '';
  @Track public cardShowSubTitle: string | Resource = '';
  @Track public isHorizontal: boolean = isOrientationHorizontal();
  @Track public textPaddingLeftAndRight: number = updateAlbumPageGridPaddingLeftAndRight();

  public trashMessageOpacity: number = 1;
  public lastScrollOffset: number = 0;
  private isShowTextState: boolean = true;

  public constructor() {
    super(new FixedIrregularViewAttributeUpdater(), 'FixedIrregularViewVc');
  }

  public onWinSizeChanged(): void {
    this.textPaddingLeftAndRight = updateAlbumPageGridPaddingLeftAndRight();
  }

  protected override initStates(): void {
    super.initStates();
    // 初始化回收站消息头
    this.isShowTrashMessage = this.albumObserverProxy.config.isSupportTrashMsg;

    this.isShowSdCard = this.gridObserverProxy.getSdCardState((_oldState, isShowSdCard: boolean) => {
      this.isShowSdCard = isShowSdCard;
      this.cardName = this.gridObserverProxy.getCardName();
      this.cardShowTitle = this.cardName ? $r('app.string.viewing_storage_devices',
        this.cardName) : $r('app.string.viewing_storage_devices_more');
      this.cardShowSubTitle = this.cardName ? $r('app.string.jump_to_file_management_tips',
        this.cardName) : $r('app.string.viewing_storage_devices_more_sub');
      if (!isShowSdCard) {
        this.viewModel?.updateMsgHeight();
      }
      this.updateShow();
    });
    // 更新消息头可见性
    this.gridObserverProxy.getIsSwitching((_oldState, _newState, switchType?: SwitchType) => {
      this.updateShow(switchType, 'IsSwitchingChange');
    });
    this.getOperateState((_oldState, newState) => {
      this.updateShowState(!OperateStateTypeUtils.isInNotDataState(newState), 'OperateStateChange');
    });
    if (DeviceInfo.isPhoneUx() && this.isShowTrashMessage) {
      this.viewModel?.gridObserverProxy.getScrollOffset(FormIndex.DAY, (_oldState, _newState) => {
        this.updateTrashMessageState(_newState);
      })
    }
    //更新不规则item在宫格区域的左右padding
    let gridPaddingLeftAndRight: number = this.gridObserverProxy.getGridPaddingLeftAndRight();
    this.attributeUpdater.updatePadding({
      start: LengthMetrics.vp(gridPaddingLeftAndRight),
      end: LengthMetrics.vp(gridPaddingLeftAndRight),
    });
  }

  private updateTrashMessageState(scrollOffset: number) {

    if (OperateStateTypeUtils.isInNotDataState(this.viewModel?.getOperateState() as OperateStateType)) {
      this.handleTrashMessage(0);
      return;
    }
    if (this.isShowTextState && scrollOffset >= BASE + EPSILON) {
      this.isShowTextState = false;
      this.handleTrashMessage(0);
    } else if (!this.isShowTextState && scrollOffset <= BASE - EPSILON){
      this.isShowTextState = true;
      this.handleTrashMessage(1);
    }
  }

  private updateShow(switchType?: SwitchType, reason?: string): void {
    // 此变量为是否需要展示固定不规则区域视图，如回收站、u盘插入等场景,后续可扩充;
    let isNeedShow: boolean = this.isShowTrashMessage || this.isShowSdCard;
    if (!isNeedShow) {
      this.updateShowState(false, reason);
      return;
    }
    this.updateShowState(!this.gridObserverProxy.getIsSwitching() || (switchType === SwitchType.SWITCH_BUTTON &&
    this.isShowTrashMessage && this.gridObserverProxy.getHeadMsgPullDownState() === PullDownState.FULL), reason);
  }

  public handleTrashMessage(opacity: number) {
    if (this.trashMessageOpacity === opacity) {
      return;
    }
    this.trashMessageOpacity = opacity;
    if (opacity === 1) {
      this.updateShowState(true);
    }
    animateToImmediately({
      curve: Curve.Linear,
      duration: 100,
      onFinish: () => {
        if (opacity === 0) {
          this.updateShowState(false);
        }
      }
    }, (): void => {
      this.attributeUpdater.updateOpacity(opacity);
    });
  }
}