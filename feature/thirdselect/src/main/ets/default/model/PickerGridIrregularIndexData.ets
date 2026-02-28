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
import lazy { Log } from '@ohos/tools/src/main/utils/Log';

const TAG: string = 'third_select_irregular_index';


/**
 * Grid渲染时管理其irregularIndex数据
 */
export class PickerGridIrregularIndexData {
  private isShowSafeDialog: boolean = false;
  private isShowGridStartOffset: boolean = false;
  private isShowGridEndOffset: boolean = false;
  private isShowFooter: boolean = false;
  private countGridItem: number = 0;

  public showSafeDialog(isShow: boolean): void {
    this.isShowSafeDialog = isShow;
  }

  public showGridStartOffset(isShow: boolean): void {
    this.isShowGridStartOffset = isShow;
  }

  public showGridEndOffset(isShow: boolean, countGridItem: number = 0): void {
    this.isShowGridEndOffset = isShow;
    this.countGridItem = countGridItem;
  }

  public showFooter(isShow: boolean, countGridItem: number = 0): void {
    this.isShowFooter = isShow;
    this.countGridItem = countGridItem;
  }

  public getIrregularIndexes(): number[] {
    let irregularIndexesHead: number[] = [];
    let irregularIndexesTail: number[] = [];
    if (this.isShowGridStartOffset) {
      irregularIndexesHead.push(0);
    }
    if (this.isShowSafeDialog) {
      irregularIndexesHead.push(irregularIndexesHead.length);
    }
    if (this.isShowGridEndOffset) {
      irregularIndexesTail.push(irregularIndexesHead.length + this.countGridItem);
    }
    if (this.isShowFooter) {
      irregularIndexesTail.push(
        irregularIndexesHead.length + irregularIndexesTail.length + this.countGridItem);
    }
    Log.info(TAG, `irregularIndexes: ${irregularIndexesHead}; ${irregularIndexesTail}`);
    return irregularIndexesHead.concat(irregularIndexesTail);
  }
}