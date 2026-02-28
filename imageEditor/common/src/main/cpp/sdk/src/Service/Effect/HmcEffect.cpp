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

#include "HmcEffect.h"
#include "HmcService.h"

HmcEffect::HmcEffect(const HmcUid &assetUid, HmcEventHandler *eventHandler)
    : m_assetUid(assetUid), m_eventHandler(eventHandler)
{
    HmcUidGenerate(&m_uid);
    SINGLETON(HmcUidAdmin)->SetEffect(m_uid, this);

    m_renderEffect = std::make_shared<HmcRenderEffect>();
    m_renderEffect->m_resource = std::make_shared<HmcMaterialRenderResource>();
}

HmcEffect::HmcEffect(const HmcEffect &effect)
{
    HmcUidGenerate(&m_uid);
    SINGLETON(HmcUidAdmin)->SetEffect(m_uid, this);
    m_assetUid = effect.m_assetUid;
    m_materialCloudId = effect.m_materialCloudId;
    m_serialCloudId = effect.m_serialCloudId;
    m_name = effect.m_name;
    m_type = effect.m_type;
    m_enable = effect.m_enable;
    m_startTime = effect.m_startTime;
    m_duration = effect.m_duration;
    m_eventHandler = effect.m_eventHandler;

    m_renderEffect = std::make_shared<HmcRenderEffect>();
    m_renderEffect->m_resource = std::make_shared<HmcMaterialRenderResource>();
}

HmcEffect &HmcEffect::operator = (const HmcEffect &effect)
{
    if (this == &effect) {
        return *this;
    }

    m_assetUid = effect.m_assetUid;
    m_materialCloudId = effect.m_materialCloudId;
    m_serialCloudId = effect.m_serialCloudId;
    m_name = effect.m_name;
    m_type = effect.m_type;
    m_enable = effect.m_enable;
    m_startTime = effect.m_startTime;
    m_duration = effect.m_duration;
    m_eventHandler = effect.m_eventHandler;

    return *this;
}

HmcEffect::~HmcEffect()
{
    SINGLETON(HmcUidAdmin)->Erase(m_uid);
}

HmcUid HmcEffect::GetUid() const
{
    return m_uid;
}

HmcEffectType HmcEffect::GetType() const
{
    return m_type;
}

STRING HmcEffect::GetMaterialCloudId() const
{
    return m_materialCloudId;
}

const STRING &HmcEffect::GetName() const
{
    return m_name;
}

void HmcEffect::SetName(const STRING &name)
{
    m_name = name;
}

BOOL HmcEffect::IsEnable() const
{
    return m_enable;
}

void HmcEffect::SetEnable(BOOL enable)
{
    m_enable = enable;
}

const HmcUid &HmcEffect::GetAssetUid() const
{
    return m_assetUid;
}

void HmcEffect::SetAssetUid(const HmcUid &assetUid)
{
    m_assetUid = assetUid;
}

Json::Value HmcEffect::Serialize()
{
    Json::Value json;
    if (!m_materialCloudId.empty()) {
        if (m_serialCloudId.empty()) {
            json[DICT_KEY_EFFECT_MATERIAL_CLOUD_ID] = m_materialCloudId;
            LOGW("FixEffectFilterType Serialize m_serialCloudId is empty!");
        } else {
            json[DICT_KEY_EFFECT_MATERIAL_CLOUD_ID] = m_serialCloudId;
        }
    }
    json[DICT_KEY_EFFECT_TYPE] = m_type;
    json[DICT_KEY_EFFECT_ENABLE] = m_enable;
    json[DICT_KEY_EFFECT_NAME] = m_name;
    json[DICT_KEY_EFFECT_START_TIME] = (Json::Value::Int64)m_startTime;
    json[DICT_KEY_EFFECT_DURATION] = (Json::Value::Int64)m_duration;

    STRING strAssetUid = HmcUidToString(&m_uid);
    json[DICT_KEY_EFFECT_UID] = strAssetUid;

    return json;
}

BOOL HmcEffect::Deserialize(const Json::Value &jsonData)
{
    m_materialCloudId = HmcMaterialUtil::GetMaterialCloudIdFromUid(jsonData, DICT_KEY_EFFECT_MATERIAL_UID,
        DICT_KEY_EFFECT_MATERIAL_CLOUD_ID);
    JsonValueUtil::ParseValueIfHas(jsonData, DICT_KEY_EFFECT_NAME, m_name);
    int effectType;
    if (JsonValueUtil::ParseValueIfHas(jsonData, DICT_KEY_EFFECT_TYPE, effectType)) {
        m_type = (HmcEffectType)effectType;
    }
    JsonValueUtil::ParseValueIfHas(jsonData, DICT_KEY_EFFECT_START_TIME, m_startTime);
    JsonValueUtil::ParseValueIfHas(jsonData, DICT_KEY_EFFECT_DURATION, m_duration);
    JsonValueUtil::ParseValueIfHas(jsonData, DICT_KEY_EFFECT_ENABLE, m_enable);

    return TRUE;
}

VOID HmcEffect::SetEffectParameter(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return;
    }

    INT64 value = 0;
    if (HmcDictGetInt64(dict, DICT_KEY_EFFECT_START_TIME, &value) == HMC_OK) {
        LOGI("set effect start time to: %lld", value);
        SetStartTime(value);
    }

    if (HmcDictGetInt64(dict, DICT_KEY_EFFECT_DURATION, &value) == HMC_OK) {
        LOGI("set effect duration to: %lld", value);
        SetDuration(value);
    }
}

VOID HmcEffect::GetEffectParameter(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return;
    }

    HmcDictSetString(dict, DICT_KEY_EFFECT_MATERIAL_CLOUD_ID, m_materialCloudId.c_str());
    HmcDictSetString(dict, DICT_KEY_EFFECT_NAME, m_name.c_str());
    HmcDictSetInt32(dict, DICT_KEY_EFFECT_TYPE, m_type);
    HmcDictSetInt32(dict, DICT_KEY_EFFECT_ENABLE, m_enable);
    HmcDictSetInt64(dict, DICT_KEY_EFFECT_START_TIME, m_startTime);
    HmcDictSetInt64(dict, DICT_KEY_EFFECT_DURATION, m_duration);
}

BOOL HmcEffect::Init()
{
    m_renderEffect->m_resControlTag = HmcRenderEffect::REUSE;
    CHAR uidStr[HMC_UID_STR_LEN] = { 0 };
    HmcUidToString(&m_uid, uidStr, sizeof(uidStr));
    m_renderEffect->m_name = uidStr;

    return TRUE;
}

BOOL HmcEffect::Init(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return FALSE;
    }

    auto name = HmcDictGetString(dict, DICT_KEY_EFFECT_NAME);
    if (name) {
        m_name = STRING(name);
    }

    SetEffectParameter(dict);

    m_renderEffect->m_resControlTag = HmcRenderEffect::REUSE;
    m_renderEffect->m_name = HmcUidToString(&m_uid);

    // 获取cloudid，提炼为一个接口，其他地方可能掉用
    return TRUE;
}

BOOL HmcEffect::AssignMaterialCloudId(HmcDict *dict)
{
    auto cloudId = HmcEffectUtils::GetEffectMaterialCloudIdFromDict(dict);
    if (cloudId.empty()) {
        LOGE("[%s]get cloud id failed, can not find material_id in dict", m_name.c_str());
        return FALSE;
    }
    if (cloudId.empty()) {
        return false;
    }
    m_materialCloudId = STRING(cloudId);
    return TRUE;
}

VOID HmcEffect::UpdateRenderInfo() {}

VOID HmcEffect::SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index)
{
    if (layer == nullptr) {
        LOGE("invalid parameter HmcRenderLayer");
        return;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(m_assetUid);
    if (asset == nullptr) {
        LOGE("get asset failed");
        return;
    }

    m_renderEffect->m_startTime = asset->GetStartTime() + m_startTime; // 相对时间转绝对时间

    if (m_duration == HmcDefault::EFFECT_DURATION_EQUAL_ASSET) {
        m_renderEffect->m_endTime = asset->GetEndTime() + 1;
    } else {
        m_renderEffect->m_endTime = m_renderEffect->m_startTime + m_duration - 1;
    }

    INT64 currentTime = layer->m_timeStamp;
    if (currentTime > m_renderEffect->m_endTime || currentTime < m_renderEffect->m_startTime) {
        return;
    }

    layer->AddEffect(m_renderEffect, index);
}

INT64 HmcEffect::GetStartTime() const
{
    return m_startTime;
}

VOID HmcEffect::SetStartTime(INT64 startTime)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(m_assetUid);
    if (asset != nullptr) {
        if (startTime < 0 || startTime >= asset->GetDurationTime()) {
            LOGE("set start time failed, start time is invalid: %lld", startTime);
            return;
        }
    }
    m_startTime = startTime;
}

INT64 HmcEffect::GetDuration() const
{
    return m_duration;
}

INT32 HmcEffect::SetDuration(INT64 duration)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(m_assetUid);
    if (asset == nullptr) {
        m_duration = duration;
        return HMC_OK;
    }

    INT64 maxDuration = asset->GetDurationTime();
    if (duration <= 0) {
        LOGE("set duration failed, duration is invalid: %lld", duration);
        return HMC_ERR_PARAM;
    } else if (duration > maxDuration) {
        LOGE("duration(%lld) is greater than duration(%lld) of asset", duration, maxDuration);
        return HMC_ERR_PARAM;
    } else {
        m_duration = duration;
    }

    return HMC_OK;
}

VOID HmcEffect::OnAssetDurationChange(INT64 duration)
{
    HMC_UNUSED(duration);
}