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
#include "HmcService.h"
#include "HmcEffectUtils.h"
#include "MediaCreative/HmcEditorEffect.h"

VOID HmcEffectUtils::SetRenderParam(HmcRenderEffectPtr render, const STRING &key, INT32 value)
{
    if (render == nullptr) {
        LOGE("set effect render parameter failed, render is null");
    } else {
        render->SetParam(key, value);
    }
}

VOID HmcEffectUtils::SetRenderParam(HmcRenderEffectPtr render, const STRING &key, FLOAT value)
{
    if (render == nullptr) {
        LOGE("set effect render parameter failed, render is null");
    } else {
        render->SetParam(key, (DOUBLE)value);
    }
}

VOID HmcEffectUtils::SetRenderParam(HmcRenderEffectPtr render, const STRING &key, DOUBLE value)
{
    if (render == nullptr) {
        LOGE("set effect render parameter failed, render is null");
    } else {
        render->SetParam(key, value);
    }
}

bool HmcEffectUtils::IsUniqueEffect(HmcEffectType type)
{
    return (type == HMC_EFFECT_ADJUST || type == HMC_EFFECT_TRANSFORM ||
            type == HMC_EFFECT_COMPOSE);
}

bool HmcEffectUtils::IsSupportKeyFrame(HmcEffectType type)
{
    return (type == HMC_EFFECT_ADJUST);
}

HmcEffectType HmcEffectUtils::GetEffectType(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("invalid parameter: dict is nullptr");
        return HMC_EFFECT_NONE;
    }

    INT32 typeVale = 0;
    if (HmcDictGetInt32(dict, DICT_KEY_EFFECT_TYPE, &typeVale) != HMC_OK) {
        LOGE("get effect type from dict failed");
        return HMC_EFFECT_NONE;
    }
    return static_cast<HmcEffectType>(typeVale);
}

STRING HmcEffectUtils::GetEffectMaterialCloudIdFromDict(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("invalid parameter: dict is nullptr");
        return {};
    }
    auto cloudId = HmcDictGetString(dict, DICT_KEY_EFFECT_MATERIAL_CLOUD_ID);
    if (!cloudId) {
        LOGW("get effect cloud Id failed");
        return {}; // 没有cloudid，返回异常
    }
    return STRING(cloudId);
}

HmcVisionAsset *HmcEffectUtils::GetVisionAsset(const HmcUid &assetUid)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("invalid asset uid");
        return nullptr;
    }

    return dynamic_cast<HmcVisionAsset *>(asset);
}