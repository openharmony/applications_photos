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
import lazy { GridTitleBarMaskVc } from '../viewcontroller/GridTitleBarMaskVc';
import lazy { DefaultVm } from '../viewmodel/DefaultVm';

const TAG: string = 'GridTitleBarMaskView';

/**
 * 宫格标题栏构造参数
 */
export interface TitleBarMaskViewBuildParams {
  /**
   * 实例ID
   */
  persistentId: number;

  /**
   * 视图控制器
   */
  controller?: GridTitleBarMaskVc;
}

/**
 * 宫格标题栏蒙层视图构建器
 *
 * @param $$ 构建参数
 */
@Builder
export function titleBarMaskViewBuilder($$: TitleBarMaskViewBuildParams): void {
  GridTitleBarMaskView({
    persistentId: $$.persistentId,
    controller: $$.controller,
  })
}

/**
 * 宫格标题栏蒙层视图
 */
@Component
export struct GridTitleBarMaskView {
  public persistentId: number = 0;
  @State public controller: GridTitleBarMaskVc = new GridTitleBarMaskVc();
  private viewModel: DefaultVm = new DefaultVm('GridTitleBarMaskVm');

  aboutToAppear(): void {
    LogUtils.info(TAG, 'aboutToAppear');
    this.viewModel.init(this.persistentId);
    this.controller.init(this.viewModel);
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear');
    this.controller.release();
    this.viewModel.release();
  }

  build() {
    Column() {
      Column() {
      }
      .attributeModifier(this.controller.maskUpdater)
    }
    .attributeModifier(this.controller.attributeUpdater)
  }
}