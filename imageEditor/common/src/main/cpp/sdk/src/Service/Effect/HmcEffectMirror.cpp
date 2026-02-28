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

#include "MediaCreative.h"
#include "HmcService.h"
#include "HmcEffectMirror.h"
#include "Utils/HmcEffectUtils.h"

constexpr const char *DICT_KEY_TRANSFORM_MIRROR_H = "mirrorH";
constexpr const char *DICT_KEY_TRANSFORM_MIRROR_V = "mirrorV";

/* 外部设置的镜像参数和引擎支持的参数的对应关系表 */
static MAP<STRING, STRING> g_mirrorKeyMap = { { DICT_KEY_TRANSFORM_MIRROR_H, "mirrorH" },
                                              { DICT_KEY_TRANSFORM_MIRROR_V, "mirrorV" } };

HmcEffectMirror::HmcEffectMirror(HmcUid assetUid, HmcEventHandler *eventHandler) : HmcEffect(assetUid, eventHandler)
{
    m_type = HMC_EFFECT_MIRROR;
}

HmcEffectMirror::HmcEffectMirror(const HmcEffectMirror &mirror) : HmcEffect(mirror)
{
    m_renderEffect->m_effectParam = mirror.m_renderEffect->m_effectParam;
    m_mirrorH = mirror.m_mirrorH;
    m_mirrorV = mirror.m_mirrorV;
}

HmcEffectMirror &HmcEffectMirror::operator = (const HmcEffectMirror &mirror)
{
    if (this == &mirror) {
        return *this;
    }

    HmcEffect::operator = (mirror);
    m_renderEffect->m_effectParam = mirror.m_renderEffect->m_effectParam;
    m_mirrorH = mirror.m_mirrorH;
    m_mirrorV = mirror.m_mirrorV;

    return *this;
}

HmcEffect *HmcEffectMirror::Duplicate()
{
    auto mirror = new (std::nothrow) HmcEffectMirror(*this);
    if (mirror == nullptr) {
        LOGE("malloc memory for mirror failed");
        return nullptr;
    }

    if (mirror->Init() != TRUE) {
        LOGE("init filter effect failed");
        delete mirror;
        return nullptr;
    }

    mirror->UpdateRenderInfo();

    return mirror;
}

BOOL HmcEffectMirror::Init(HmcDict *dict)
{
    if (!HmcEffect::Init(dict)) {
        return FALSE;
    }

    SetEffectParameter(dict);

    return Init();
}

Json::Value HmcEffectMirror::Serialize()
{
    Json::Value json = HmcEffect::Serialize();

    json[PROJECT_KEY_TRANSFORM_MIRROR_H] = m_mirrorH;
    json[PROJECT_KEY_TRANSFORM_MIRROR_V] = m_mirrorV;

    return json;
}

BOOL HmcEffectMirror::Deserialize(const Json::Value &jsonData)
{
    if (HmcEffect::Deserialize(jsonData) == FALSE) {
        LOGE("deserialize effect failed");
        return FALSE;
    }

    if (JsonValueUtil::ParseValueIfHas(jsonData, PROJECT_KEY_TRANSFORM_MIRROR_H, m_mirrorH)) {
        LOGI("set horizontal mirror : %d", m_mirrorH);
    }

    if (JsonValueUtil::ParseValueIfHas(jsonData, PROJECT_KEY_TRANSFORM_MIRROR_V, m_mirrorV)) {
        LOGI("set vertical mirror : %d", m_mirrorV);
    }

    if (Init() != TRUE) {
        LOGE("init mirror failed");
        return FALSE;
    }

    UpdateRenderInfo();

    return TRUE;
}

VOID HmcEffectMirror::SetEffectParameter(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return;
    }

    HmcEffect::SetEffectParameter(dict);

    char *dictStr = HmcDictSerialize(dict);
    LOGD("mirror dict: %s", dictStr);
    HmcFree(dictStr);

    auto mirrorH = static_cast<INT32>(m_mirrorH);
    auto mirrorV = static_cast<INT32>(m_mirrorV);
    if (HmcDictGetInt32(dict, DICT_KEY_TRANSFORM_MIRROR_H, &mirrorH) == HMC_OK) {
        LOGI("set horizontal mirror to: %d", mirrorH);
    }

    if (HmcDictGetInt32(dict, DICT_KEY_TRANSFORM_MIRROR_V, &mirrorV) == HMC_OK) {
        LOGI("set vertical mirror to: %d", mirrorV);
    }

    UpdateRenderInfo();
}

VOID HmcEffectMirror::GetEffectParameter(HmcDict *dict)
{
    HmcEffect::GetEffectParameter(dict);

    HmcDictSetInt32(dict, DICT_KEY_TRANSFORM_MIRROR_H, m_mirrorH);
    HmcDictSetInt32(dict, DICT_KEY_TRANSFORM_MIRROR_V, m_mirrorV);
}

BOOL HmcEffectMirror::Init()
{
    if (HmcEffect::Init() != TRUE) {
        LOGE("hmc effect init failed");
        return FALSE;
    }

    m_renderEffect->m_resource.get()->m_effectType = "mirror";
    m_renderEffect->m_resource.get()->m_effectName = "mirror";

    return TRUE;
}

VOID HmcEffectMirror::UpdateRenderInfo()
{
    auto mirrorH = static_cast<INT32>(m_mirrorH);
    auto mirrorV = static_cast<INT32>(m_mirrorV);
    m_renderEffect->SetParam(g_mirrorKeyMap[DICT_KEY_TRANSFORM_MIRROR_H], mirrorH);
    m_renderEffect->SetParam(g_mirrorKeyMap[DICT_KEY_TRANSFORM_MIRROR_V], mirrorV);
}

VOID HmcEffectMirror::SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index)
{
    if (layer == nullptr) {
        LOGE("invalid parameter HmcRenderLayer");
        return;
    }

    HmcUid assetUid = GetAssetUid(); // 获取镜像效果所属asset
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("SetRenderLayer, asset is invalid");
        return;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("SetRenderLayer, asset is not an vision asset entity");
        return;
    }

    auto assetTmp = dynamic_cast<HmcVisionAsset *>(asset);
    if (assetTmp == nullptr) {
        return;
    }

    m_mirrorH = assetTmp->GetMirrorHorizontal();
    m_mirrorV = assetTmp->GetMirrorVertical();

    UpdateRenderInfo();

    layer->AddEffect(m_renderEffect, index);
}
