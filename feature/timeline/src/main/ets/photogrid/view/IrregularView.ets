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
import lazy { IrregularVc } from '../viewcontroller/IrregularVc';
import lazy { IrregularVm } from '../viewmodel/IrregularVm';

const TAG: string = 'IrregularView';

/**
 * 宫格中不规则区域构建参数
 */
export interface IrregularViewBuildParams {
  /**
   * 实例ID
   */
  persistentId: number;

  viewModel?: IrregularVm;

  controller?: IrregularVc;
}

/**
 * 宫格中不规则区域视图构建器
 *
 * @param $$ 构建参数
 */
@Builder
export function irregularViewBuilder($$: IrregularViewBuildParams): void {
  IrregularView({
    persistentId: $$.persistentId,
    viewModel: $$.viewModel,
    controller: $$.controller,
  })
}

/**
 * 宫格中不规则区域视图
 */
@Component
export struct IrregularView {
  // 外部导入属性
  public persistentId: number = 0;
  public viewModel: IrregularVm = new IrregularVm();
  @State public controller: IrregularVc = new IrregularVc();
  // 自定义属性

  aboutToAppear(): void {
    LogUtils.info(TAG, 'aboutToAppear');
    this.viewModel.init(this.persistentId);
    this.controller.init(this.viewModel);
    LogUtils.info(TAG, 'aboutToAppear finish');
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear');
    this.controller.release();
    this.viewModel.release();
  }

  @Builder
  buildIrregularView() {
    Column() {
      // 消息头
    }
    .attributeModifier(this.controller.attributeUpdater)
  }

  build() {
    if (this.controller.isCanShow && this.controller.isShow) {
      this.buildIrregularView()
    }
  }
}