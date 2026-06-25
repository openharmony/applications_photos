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

#ifndef HMC_ASSET_UTILS_H
#define HMC_ASSET_UTILS_H

#include "HmcBase.h"
#include "HmcEngine.h"
#include "MediaCreative.h"

class IHmcAsset;
struct HmcCanvasSize;

class HmcAssetUtils {
public:
    static BOOL IsVisionAsset(HmcAssetType type);
};

#endif // HMC_ASSET_UTILS_H
