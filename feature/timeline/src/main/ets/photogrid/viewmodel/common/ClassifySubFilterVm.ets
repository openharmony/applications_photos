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

import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import { IrregularType } from '../../statemanager/constants/GridDefine';
import { AbstractVm } from '../AbstractVm';

/**
 * 顶部排序选择器视图模型
 */
export class ClassifySubFilterVm extends AbstractVm {
  public albumInfo: AlbumInfo | undefined = undefined;

  public constructor() {
    super('ClassifySubFilterVm');
  }


  /**
   * 按照类型更新不规则高度区域高度
   *
   * @param newHeight 新高度
   */
  public updateClassifySubFilterHeight(newHeight: number) {
    this.gridStateManager.updateIrregularTypeHeight(IrregularType.Classify_SELECTOR, newHeight, this.tag);
  }

  public updatePortraitHeight() {
  }

  protected override doInit(param: number): void {
    super.doInit(param);

    this.albumObserverProxy.getAlbumInfo((_oldValue, newValue) => {
      this.albumInfo = newValue;
    });
  }
}