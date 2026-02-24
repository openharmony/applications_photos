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

import lazy { SelectPicker as SortSelect, } from '@ohos/common/src/main/ets/default/view/albumGridSort';
import lazy { AlbumGridSortHelper } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { SortSelectorVc } from '../../viewcontroller/common/SortSelectorVc';
import lazy { SortSelectorVm } from '../../viewmodel/common/SortSelectorVm';
import lazy { BaseBuildParams } from '../ViewLoader';

const TAG: string = 'SortSelectorView';

/**
 * 相册排序选择区域视图构建器
 *
 * @param $$ 构建参数
 */
@Builder
export function buildSortSelectorView($$: BaseBuildParams) {
  SortSelectorView({
    persistentId: $$.persistentId,
  })
}

@Component
export struct SortSelectorView {
  // 外部导入属性
  public persistentId: number = 0;
  @State public controller: SortSelectorVc = new SortSelectorVc();
  public viewModel: SortSelectorVm = new SortSelectorVm();

  aboutToAppear(): void {
    LogUtils.info(TAG, 'aboutToAppear');
    this.viewModel.init(this.persistentId);
    this.controller.init(this.viewModel);
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear.');
    this.controller.release();
    this.viewModel?.release();
  }

  @Builder
  buildView(): void {
    Flex({ alignItems: ItemAlign.End }) {
      Column() {
        SortSelect({
          selected: this.controller.selectSortRule,
          sortType: this.controller.selectSortRuleSortType,
          albumKey: this.controller.albumInfoKey,
          albumUri: this.controller.albumInfoUri,
          onSelect: (selected, sortType): void => this.viewModel.onSelectSortRuleChange(selected, sortType),
          disabled: this.controller.isSelectMode,
        })
      }
      .attributeModifier(this.controller.attributeUpdater)
    }
    .height('100%')
  }

  build() {
    if (this.controller.isCanShow && this.controller.isShow) {
      this.buildView();
    }
  }
}