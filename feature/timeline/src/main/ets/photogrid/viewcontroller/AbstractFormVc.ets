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

import lazy { FormIndex, ShowMode } from '../statemanager/constants/GridDefine';
import lazy { FormStateTypeUtils } from '../statemanager/GridFormFsm';
import lazy { GridShowStateTypeUtils } from '../statemanager/GridShowFsm';
import lazy { AbstractFormVm } from '../viewmodel/AbstractFormVm';
import lazy { BaseAttributeUpdater, AbstractVc } from './AbstractVc';

/**
 * 抽象带形态的视图控制器
 */
@Observed
export abstract class AbstractFormVc<V extends AbstractFormVm,
  U extends BaseAttributeUpdater<T>, T extends CommonAttribute = CommonAttribute> extends AbstractVc<V, U, T> {
  /**
   * 宫格形态
   */
  protected readonly gridForm: FormIndex;

  public constructor(gridForm: FormIndex, attributeUpdater: U, tag?: string, showMode?: ShowMode) {
    super(attributeUpdater, tag, showMode);
    this.gridForm = gridForm;
  }

  protected override initStates(): void {
    super.initStates();
    this.initShowState();
  }

  /**
   * 注册显隐监听，有特殊情况时可定制修改
   */
  protected initShowState(): void {
    this.gridObserverProxy.getGridShowState(this.gridForm, (_oldState, newState) => {
      this.updateShowState(GridShowStateTypeUtils.isShowState(newState), 'GirdShowStateChange');
    });
  }

  /**
   * 判断是否处于当前形态
   *
   * @returns 是否处于当前形态
   */
  protected isInCurrentForm(): boolean {
    return FormStateTypeUtils.isInFormState(this.getFormState(), this.gridForm);
  }
}