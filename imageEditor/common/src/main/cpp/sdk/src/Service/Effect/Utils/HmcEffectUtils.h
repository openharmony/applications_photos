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

#ifndef HMC_EFFECT_UTILS_H
#define HMC_EFFECT_UTILS_H

#include "HmcBase.h"
#include "HmcEngine.h"
#include "MediaCreative.h"

class HmcVisionAsset;

class HmcEffectUtils {
public:
    static VOID SetRenderParam(HmcRenderEffectPtr render, const STRING &key, INT32 value);
    static VOID SetRenderParam(HmcRenderEffectPtr render, const STRING &key, FLOAT value);
    static VOID SetRenderParam(HmcRenderEffectPtr render, const STRING &key, DOUBLE value);

    static bool IsUniqueEffect(HmcEffectType type);
    static bool IsSupportKeyFrame(HmcEffectType type);

    static HmcEffectType GetEffectType(HmcDict *dict);
    static STRING GetEffectMaterialCloudIdFromDict(HmcDict *dict);

    static HmcVisionAsset *GetVisionAsset(const HmcUid &assetUid);
};

#endif // HMC_EFFECT_UTILS_H
