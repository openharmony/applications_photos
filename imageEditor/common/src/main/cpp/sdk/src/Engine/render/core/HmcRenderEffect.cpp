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

#include "HmcRenderEffect.h"

const int CHROM_DEPTH = 1;
const int TRANSFORM_DEPTH = 2;

HmcRenderEffect::HmcRenderEffect()
{
    m_outTex = MAIN_TEX;
    m_inTex.emplace_back();
}

HmcRenderEffect::HmcRenderEffect(const HmcRenderEffect *other)
{
    if (other != nullptr) {
        this->m_name = other->m_name;
        this->m_startTime = other->m_startTime;
        this->m_endTime = other->m_endTime;
        this->m_timeStamp = other->m_timeStamp;
        this->m_resource = other->m_resource;
        this->m_resControlTag = other->m_resControlTag;
        this->m_effectParam = other->m_effectParam;

        this->m_inTex = other->m_inTex;
        this->m_outTex = other->m_outTex;
    }
}

void HmcRenderEffect::SetOutTex(const STRING &tex)
{
    m_outTex = tex;
}
void HmcRenderEffect::AddTexture(const STRING &key, const STRING &luaKey)
{
    m_inTex.push_back(TexInInfo(key, luaKey));
}
void HmcRenderEffect::SetParam(const STRING &key, INT32 value)
{
    LOGI("HmcRenderEffect SetParam:%s %d", key.c_str(), value);
    m_effectParam.insert_or_assign(key, HmcRenderValue(value));
}
void HmcRenderEffect::SetParam(const STRING &key, DOUBLE value)
{
    LOGI("HmcRenderEffect SetParam:%s %lf", key.c_str(), value);
    m_effectParam.insert_or_assign(key, HmcRenderValue(value));
}
void HmcRenderEffect::SetParam(const STRING &key, const STRING &value)
{
    m_effectParam.insert_or_assign(key, HmcRenderValue(value));
}
void HmcRenderEffect::SetParam(const STRING &key, VOID* value)
{
    m_effectParam.insert_or_assign(key, HmcRenderValue(value));
}
BOOL HmcRenderEffect::GetParam(const STRING &key, INT32 &value)
{
    auto ite = m_effectParam.find(key);
    if (ite != m_effectParam.end()) {
        value = ite->second.Get<INT32>();
        return TRUE;
    }
    return FALSE;
}
BOOL HmcRenderEffect::GetParam(const STRING &key, DOUBLE &value)
{
    auto ite = m_effectParam.find(key);
    if (ite != m_effectParam.end()) {
        value = ite->second.Get<DOUBLE>();
        return TRUE;
    }
    return FALSE;
}
BOOL HmcRenderEffect::GetParam(const STRING &key, STRING &value)
{
    auto ite = m_effectParam.find(key);
    if (ite != m_effectParam.end()) {
        value = ite->second.Get<STRING>();
        return TRUE;
    }
    return FALSE;
}

int HmcRenderEffect::GetDepth() const
{
    if (m_resource->m_effectType == STRING("chromakey")) {
        return CHROM_DEPTH;
    } else if (m_resource->m_effectType == STRING("transform")) {
        return TRANSFORM_DEPTH;
    }

    return 0;
}

VOID HmcRenderEffect::CopyHmcEffect(std::shared_ptr<HmcRenderEffect> &srcHmcEffect)
{
    if (srcHmcEffect == nullptr) {
        LOGE("HmcRenderEffect::CopyHmcEffect srcHmcEffect is null");
        return ;
    }
    m_outTex = srcHmcEffect->m_outTex;
    m_name = srcHmcEffect->m_name;
    m_resControlTag = srcHmcEffect->m_resControlTag;
    this->m_startTime = srcHmcEffect->m_startTime;
    this->m_endTime = srcHmcEffect->m_endTime;
    this->m_timeStamp = srcHmcEffect->m_timeStamp;
    this->m_resource = srcHmcEffect->m_resource;
    
    m_inTex.clear();
    for (auto texItem  : srcHmcEffect->m_inTex) {
        AddTexture(texItem.key);
    }
    m_effectParam.clear();
    for (auto paramItem : srcHmcEffect ->m_effectParam) {
        m_effectParam.insert_or_assign(paramItem.first, HmcRenderValue(paramItem.second));
    }
}
