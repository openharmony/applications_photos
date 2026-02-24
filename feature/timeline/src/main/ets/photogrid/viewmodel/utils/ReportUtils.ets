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

import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { FormIndex } from '../../statemanager/constants/GridDefine';

/**
 * 操作类型
 */
export enum OptionType {
  /**
   * 按钮操作
   */
  BUTTON,

  /**
   * 页面操作
   */
  VIEW,

  /**
   * 捏合操作
   */
  PINCH
}


/**
 * 打点上报
 */
export class ReportUtils {
  private constructor() {
  }

  /**
   * 上报年月日形态切换
   *
   * @param preview 当前页面
   * @param targetView 目标页面
   * @param optionType 切换方式
   */
  public static reportFormChange(preview: FormIndex, targetView: FormIndex, optionType: OptionType): void {
    ReportToBigDataUtil.report(BigDataConstants.TIMELINE_CHANGE, {
      'preView': preview,
      'targetView': targetView,
      'optionType': optionType
    });
  }
}