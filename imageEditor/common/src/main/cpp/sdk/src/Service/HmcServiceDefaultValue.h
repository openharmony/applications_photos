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
#ifndef HMCSERVICEDEFAULTVALUE_H
#define HMCSERVICEDEFAULTVALUE_H

#include "HmcBase.h"

namespace HmcDefault {
constexpr const INT64 EFFECT_DURATION_EQUAL_ASSET = -1;                      // 特效默认时长
constexpr const char *EFFECT_ADJUST_DEFAULT_NAME = "color adjust";           // 颜色调节的默认名称
constexpr const char *EFFECT_TRANSFORM_DEFAULT_NAME = "transform";           // transform的默认名称.
constexpr const char *EFFECT_MIRROR_DEFAULT_NAME = "mirror";                 // 镜像的默认名称.
constexpr const char *EFFECT_CROP_TRANSFORM_DEFAULT_NAME = "crop transform"; // crop transform的默认名称.

constexpr FLOAT LIGHT_INTENSITY_DEFAULT = 0.7f;    // float: 默认光场强度.
constexpr FLOAT LIGHT_BG_INTENSITY_DEFAULT = 0.3f; // float: 默认背景光强度.
};

#endif // HMCSERVICEDEFAULTVALUE_H
