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

import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { FormStateTypeUtils } from '../statemanager/GridFormFsm';
import lazy { GridShowFsm } from '../statemanager/GridShowFsm';
import lazy { AbstractVm } from './AbstractVm';

/**
 * 抽象带形态的视图模型
 */
export class AbstractFormVm extends AbstractVm {
  /**
   * 宫格形态
   */
  protected readonly gridForm: FormIndex;

  public constructor(gridForm: FormIndex, tag?: string) {
    super(tag);
    this.gridForm = gridForm;
  }

  /**
   * 获取滚动条
   *
   * @returns 滚动条
   */
  public getScroller(): Scroller {
    return this.scrollerStateManager.getScroller(this.gridForm);
  }

  /**
   * 判断是否处于当前形态
   *
   * @returns 是否处于当前形态
   */
  public isInCurrentForm(): boolean {
    return FormStateTypeUtils.isInFormState(this.stateProxy.formFsm.currentState, this.gridForm);
  }

  /**
   * 获取宫格显示状态机
   *
   * @returns 宫格显示状态机
   */
  protected get gridShowFsm(): GridShowFsm {
    return this.gridStateManager.getGridShowFsm(this.gridForm);
  }
}