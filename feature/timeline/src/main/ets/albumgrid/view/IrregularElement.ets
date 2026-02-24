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

import lazy { MediaDataSource } from "@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource";
import lazy { DayGridVm } from "../../photogrid/viewmodel/DayGridVm";
import lazy { Log } from '@ohos/tools/src/main/utils/Log';

/* instrument ignore file */
const TAG: string = 'IrregularElement';

export interface IrregularElementBuilder {
  builder: (params: Object | undefined, dataSource?: MediaDataSource | undefined) => void,
  builderParams: Object,
}

@Component
export struct IrregularElement {
  params?: Object;
  @BuilderParam builder: (params: Object | undefined) => void;
  public viewModel: DayGridVm = new DayGridVm();

  build() {
    Column() {
      this.builder(this.params);
    }
    .id('buildIrregularElement')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      const oldHeight: number = oldValue.height as number;
      const newHeight: number = newValue.height as number;
      let msg: string[] = [`dayView cloudSyncCard onAreaChange`];
      msg.push(`newHeight: ${newHeight}`, `oldHeight: ${oldHeight}`);
      Log.info(TAG, msg.join(', '));
      if (oldHeight != newHeight) {
        this.viewModel.updatePortraitSwiperHeight(newHeight, `portraitSwper`);
      }
    })
  }
}

