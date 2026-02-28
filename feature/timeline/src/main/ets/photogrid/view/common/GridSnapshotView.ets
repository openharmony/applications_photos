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
import lazy { FormIndex } from '../../statemanager/constants/GridDefine';
import lazy { GridSnapshotVc } from '../../viewcontroller/GridSnapshotVc';
import lazy { GridSnapshotVm } from '../../viewmodel/GridSnapshotVm';

const TAG: string = 'GridSnapshotView';

/**
 * 宫格截图页面
 */
@Component
export struct GridSnapshotView {
  // 外部导入属性
  public persistentId: number = 0;
  public viewModel: GridSnapshotVm = new GridSnapshotVm(FormIndex.INVALID);
  @State public controller: GridSnapshotVc = new GridSnapshotVc(FormIndex.INVALID);

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

  build() {
    if (this.controller.snapShotImage) {
      Image(this.controller.snapShotImage)
        .attributeModifier(this.controller.attributeUpdater)
        .onComplete((event) => {
          if (event?.loadingStatus === 1) { // 1标识解码成功
            this.viewModel.notifyAnimationPrepareComplete();
          }
        })
    }
  }
}