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

#include "HmcEffectCompose.h"
#include "MediaCreative.h"
#include "HmcService.h"
HmcEffectCompose::HmcEffectCompose(HmcUid assetUid, HmcEventHandler *eventHandler) : HmcEffect(assetUid, eventHandler)
{
    m_type = HMC_EFFECT_COMPOSE;
}

HmcEffect *HmcEffectCompose::Duplicate()
{
    auto effect = new (std::nothrow) HmcEffectCompose(*this);
    if (effect == nullptr) {
        LOGE("create compose effect failed");
        return nullptr;
    }

    if (effect->Init() != TRUE) {
        LOGE("init compose effect failed");
        delete effect;
        return nullptr;
    }

    return effect;
}

Json::Value HmcEffectCompose::Serialize()
{
    Json::Value json = HmcEffect::Serialize();
    return json;
}

BOOL HmcEffectCompose::Deserialize(const Json::Value &jsonData)
{
    BOOL ret = FALSE;
    ret = HmcEffect::Deserialize(jsonData);
    if (ret != TRUE) {
        LOGE("deserialize filter effect failed");
        return FALSE;
    }

    UpdateRenderInfo();

    return Init();
}

VOID HmcEffectCompose::SetEffectParameter(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return;
    }

    HmcDictGetPointer(dict, "dst_bmp", &pixelBuffer);
    HmcDictGetInt32(dict, "dst_rect_left", &x);
    HmcDictGetInt32(dict, "dst_rect_top", &y);
    HmcDictGetInt32(dict, "dst_rect_width", &width);
    HmcDictGetInt32(dict, "dst_rect_height", &height);

    HmcDictGetDouble(dict, "dst_scale_x", &scaleX);
    HmcDictGetDouble(dict, "dst_scale_y", &scaleY);

    UpdateRenderInfo();
}

VOID HmcEffectCompose::GetEffectParameter(HmcDict *dict)
{
    HmcEffect::GetEffectParameter(dict);
}

BOOL HmcEffectCompose::Init(HmcDict *dict)
{
    if (!HmcEffect::Init(dict)) {
        LOGE("init compose failed");
        return FALSE;
    }

    m_renderEffect->m_resource.get()->m_effectType = "compose";
    m_renderEffect->m_resource.get()->m_effectName = "compose";

    SetEffectParameter(dict);

    return TRUE;
}

BOOL HmcEffectCompose::Init()
{
    if (HmcEffect::Init() != TRUE) {
        LOGE("hmc effect init failed");
        return FALSE;
    }

    m_renderEffect->m_resource.get()->m_effectType = "compose";
    m_renderEffect->m_resource.get()->m_effectName = "compose";

    return TRUE;
}

VOID HmcEffectCompose::SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index)
{
    UpdateRenderInfo();

    HmcEffect::SetRenderLayer(layer, index);
}

VOID HmcEffectCompose::UpdateRenderInfo()
{
    m_renderEffect->SetParam("dst_bmp", pixelBuffer);
    m_renderEffect->SetParam("dst_rect_left", x);
    m_renderEffect->SetParam("dst_rect_top", y);
    m_renderEffect->SetParam("dst_rect_width", width);
    m_renderEffect->SetParam("dst_rect_height", height);
    m_renderEffect->SetParam("dst_scale_x", scaleX);
    m_renderEffect->SetParam("dst_scale_y", scaleY);
}