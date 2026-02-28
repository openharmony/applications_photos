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
// instrument ignore file

import { uiEffect } from '@kit.ArkGraphics2D';

export class Effects {
  public static darkBlender: uiEffect.VisualEffect =
    uiEffect.createEffect().backgroundColorBlender(uiEffect.createBrightnessBlender({
      cubicRate: -0.6933,
      quadraticRate: 1.2457,
      linearRate: -0.0824,
      degree: 0.1,
      saturation: 2,
      positiveCoefficient: [0.6, 0.7, 0.5],
      negativeCoefficient: [0.4, 1, 0.5],
      fraction: 0
    }));
  public static tipBlur: uiEffect.Filter = uiEffect.createFilter().blur(20);
}