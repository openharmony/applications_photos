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
import lazy { DisplayName } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { SubHeader } from '@kit.ArkUI';

const TAG: string = 'TipText';

/**
 * 灰色提示文字
 */
@Component
export struct TipText {
  private tip: DisplayName = '';

  build() {
    SubHeader({
      secondaryTitle: this.tip,
    }).margin({
      left: $r('app.float.grid_margin_bottom'),
      right: $r('app.float.grid_margin_bottom'),
    })
  }
}