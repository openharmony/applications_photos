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

import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { AlbumGridSortHelper, SortRuleString } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { ShowMode } from '../../statemanager/constants/GridDefine';
import lazy { AbstractVc, BaseAttributeUpdater } from '../AbstractVc';
import lazy { curves } from '@kit.ArkUI';
import lazy { SortSelectorVm } from '../../viewmodel/common/SortSelectorVm';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { FormStateTypeUtils } from '../../statemanager/GridFormFsm';
import lazy { OperateStateTypeUtils } from '../../statemanager/GridOperateFsm';
import lazy { FormIndex } from '../../statemanager/constants/GridDefine';
import lazy { ReloadStatusType } from '../../statemanager/AlbumStateManager';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';

/**
 * 顶部排序选择器属性更新器
 */
export class SortSelectorAttributeUpdater extends BaseAttributeUpdater<ColumnAttribute> {
  protected override initInstance(instance: ColumnAttribute): void {
    super.initInstance(instance);
    instance.constraintSize({
      minHeight: Constants.ALBUM_GRID_SORT_SELECT_HEIGHT,
    })
      .justifyContent(FlexAlign.Center);
  }
}

/**
 * 顶部排序选择视图控制器
 */
@Observed
export class SortSelectorVc extends AbstractVc<SortSelectorVm, SortSelectorAttributeUpdater, ColumnAttribute> {
  @Track public selectSortRule: string = '';
  @Track public selectSortRuleSortType: string = '';
  @Track public override isShow: boolean = true; // 此场景，默认显示
  private albumInfo : AlbumInfo | undefined = undefined;
  @Track public albumInfoUri: string | undefined = undefined;
  @Track public albumInfoKey: string | undefined = undefined;
  private callbackAfterDataReload?: Function;

  public constructor() {
    super(new SortSelectorAttributeUpdater(), 'SortSelectorVc', ShowMode.ON_TREE);
  }

  protected override initStates(): void {
    this.albumObserverProxy.getReloadStatus((_oldStatus, newStatus) => {
      LogUtils.info(this.tag, `getReloadStatus ${_oldStatus} -> ${newStatus}`);
      if (_oldStatus === ReloadStatusType.RELOADING && newStatus === ReloadStatusType.RELOAD_FINISH) {
        this.callbackAfterDataReload?.();
        this.callbackAfterDataReload = undefined;
      }
    });

    this.albumObserverProxy.getAlbumInfo((_oldValue, newValue) => {
      this.albumInfo = newValue;
      this.albumInfoKey = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo);
      this.albumInfoUri = this.albumInfo?.uri;
    });


    const sortInfo = this.gridObserverProxy.getGridSortState((oldState, newState) => {
      LogUtils.info(this.tag, `update grid sort from ${oldState} to ${newState}`);
      this.updateGridSortParams(newState);
    });
    this.updateGridSortParams(sortInfo, true);

    this.getFormState((_oldState, newState) => {
      // 分组视图不支持切换排序
      if (FormStateTypeUtils.isInGroupDayState(newState)) {
        this.updateShowState(false, 'FormChangeToGroupDay');
      } else if (FormStateTypeUtils.isInDayState(newState)) {
        this.updateShowInDayForm();
      }
    });
    this.getOperateState((_oldState, newState) => {
      // 分组视图不支持切换排序
      if (OperateStateTypeUtils.isInNotDataState(newState)) {
        this.updateShowState(false, 'InNotDataState');
      } else if (OperateStateTypeUtils.isInNotDataState(_oldState)) {
        this.updateShowInDayForm();
      }
    });
  }

  protected override updateShowState(isShow: boolean, reason?: string): void {
    super.updateShowState(isShow, reason);
    this.viewModel?.updateSortSelectorHeight(isShow ? Constants.ALBUM_GRID_SORT_SELECT_HEIGHT : 0);
  }

  /**
   * 是否允许选择排序菜单
   * @returns
   */
  private isAlbumGridSortAble(withSelectMode = true): boolean {
    let withSelectModeSortAble = withSelectMode ? !this.isSelectMode : true;
    return AlbumGridSortHelper.getInstance().isOpenGridSort && withSelectModeSortAble;
  }

  /**
   * 更新宫格排序菜单以及布局
   * @param sortRuleInfo 排序字段和升降序
   * @param isInit 是否是初始化，初始化不需要触发动效
   */
  private updateGridSortParams(sortRuleInfo: SortRuleString, isInit: boolean = false): void {
    const changeSortFunc: Function = () => {
      this.selectSortRule = sortRuleInfo.rule;
      this.selectSortRuleSortType = sortRuleInfo.type;
      this.updateShowInDayForm();
    }
    if (isInit) {
      changeSortFunc();
      return;
    }
    this.callbackAfterDataReload = () => {
      this.withSortRuleAnimate(sortRuleInfo.rule, (Boolean(sortRuleInfo.rule) != Boolean(this.selectSortRule)),
        changeSortFunc);
    }
  }

  private updateShowInDayForm(): void {
    if (this.getCurrentForm() !== FormIndex.DAY) {
      return;
    }
    this.updateShowState(this.selectSortRule.length > 0 && this.isAlbumGridSortAble(false), 'FormChangeToDay');
  }

  /**
   * 排序菜单显隐动效
   * @param selected 目标排序规则
   * @param useAnimate 是否启用动效
   * @param onAnimateFinish 动效执行结束回调
   */
  private withSortRuleAnimate(selected: string, useAnimate: boolean, onAnimateFinish: Function) {
    if (!useAnimate) {
      onAnimateFinish();
      this.attributeUpdater.updateOpacity(selected ? 1 : 0);
      return;
    }
    if (selected) {
      animateTo({
        curve: curves.interpolatingSpring(0, 1, Constants.ALBUM_GRID_SORT_CURVE_STIFFNESS,
          Constants.ALBUM_GRID_SORT_CURVE_DAMPING),
      },
        () => {
          onAnimateFinish();
        });
      animateTo({
        delay: Constants.ALBUM_GRID_SORT_SELECT_DURATION,
        duration: Constants.ALBUM_GRID_SORT_SELECT_DURATION,
        curve: Curve.Sharp,
      },
        () => {
          this.attributeUpdater.updateOpacity(1);
        });

    } else {
      animateTo({
        curve: curves.interpolatingSpring(0, 1, Constants.ALBUM_GRID_SORT_CURVE_STIFFNESS,
          Constants.ALBUM_GRID_SORT_CURVE_DAMPING),
      }, () => {
        onAnimateFinish();
      })
      animateTo({
        duration: Constants.ALBUM_GRID_SORT_SELECT_HIDE_DURATION,
        curve: Curve.Sharp,
      }, () => {
        this.attributeUpdater.updateOpacity(0);
      })
    }
  }
}