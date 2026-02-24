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

#include "HmcEngine.h"

const int Y_LOCATION = 0;
const int U_LOCATION = 1;
const int UV_LOCATION = 1;
const int V_LOCATION = 2;
const int YUV_SIZE_2_2 = 2;
const int YUV_SIZE_4_1 = 4;
const int ROTATION_90 = 90;
const int ROTATION_270 = 270;
const int ROTATION_360 = 360;
#ifndef GL_TEXTURE_EXTERNAL_OES
#define GL_TEXTURE_EXTERNAL_OES 0x8D65

#endif

HmcRenderLayer::HmcRenderLayer() : m_timeStamp(0), m_sourceAsset(HMC_UID_NULL), m_sourceLane(HMC_UID_NULL) {}

void HmcRenderLayer::SetTimeStamp(INT64 timeStamp) { m_timeStamp = timeStamp; }

BOOL HmcRenderLayer::AddTexture(HmcRenderTexture *texture, STRING texName)
{
    m_textureList[texName] = std::make_shared<HmcRenderTexture>(*texture);
    return TRUE;
}

HmcRenderTexture *HmcRenderLayer::GetTexture(STRING texName)
{
    auto it = m_textureList.find(texName);
    if (it != m_textureList.end()) {
        return it->second.get();
    }
    return nullptr;
}

VOID HmcRenderLayer::AddEffect(HmcRenderEffectPtr &effect, INT32 idx)
{
    AddEffect(effect, idx, m_timeStamp);
}

VOID HmcRenderLayer::AddEffect(HmcRenderEffectPtr &effect, INT32 idx, INT32 timeStamp)
{
    // 添加的时候检测effect的效果是否全部都是默认值
    if (EffectFilter(effect.get())) {
        LOGI("AddEffect all default");
    }
    effect->m_timeStamp = timeStamp;

    size_t index = static_cast<size_t>(idx);
    if ((idx < 0) || (index >= m_effectList.size())) {
        m_effectList.push_back(effect);
    } else {
        auto ite = m_effectList.begin();
        std::advance(ite, idx);
        m_effectList.insert(ite, effect);
    }
}

HmcRenderLayer::~HmcRenderLayer() {}

BOOL HmcRenderLayer::EffectFilter(HmcRenderEffect *effect)
{
    bool needFilter = false;
    if (effect->m_resource->m_effectName == "ColorAdjust") {
        static const MAP<STRING, PAIR<DOUBLE, STRING>> checkParam = {
            { "BRIGHTNESS", { 0.0, "COLOR_ADJUST_BRIGHTNESS" } },
            { "CONTRAST", { 0.0, "COLOR_ADJUST_CONTRAST" } },
            { "EXPOSURE", { 0.0, "COLOR_ADJUST_EXPOSURE" } },
            { "FADE", { 0.0, "COLOR_ADJUST_FADE" } },
            { "GRAIN", { 0.0, "COLOR_ADJUST_GRAIN" } },
            { "HIGHLIGHT", { 0.0, "COLOR_ADJUST_HIGHLIGHT" } },
            { "HUE", { 0.0, "COLOR_ADJUST_HUE" } },
            { "SATURATION", { 0.0, "COLOR_ADJUST_SATURATION" } },
            { "SHADOW", { 0.0, "COLOR_ADJUST_SHADOW" } },
            { "SHARPNESS", { 0.0, "COLOR_ADJUST_SHARPNESS" } },
            { "TEMPERATURE", { 0.0, "COLOR_ADJUST_TEMPERATURE" } },
            { "VIGNETTE", { 0.0, "COLOR_ADJUST_VIGNETTE" } },
            { "VIBRANCE", { 0.0, "COLOR_ADJUST_VIBRANCE" } },
            { "DARKZONE", { 0.0, "COLOR_ADJUST_DARKZONE" } },
            { "BRIGHTZONE", { 0.0, "COLOR_ADJUST_BRIGHTZONE" } } };
        needFilter = true;
        for (const auto &param : checkParam) {
            DOUBLE v;
            if (effect->GetParam(param.first, v) && (islessgreater(v, param.second.first))) {
                needFilter = false;
            } else {
                effect->SetParam(param.second.second, 0);
            }
        }
    } else if (effect->m_resource->m_effectName == "mirror") {
        STRING checkParam[] = {"mirrorH", "mirrorV"};
        needFilter = true;
        for (const auto &key : checkParam) {
            INT32 v;
            if (effect->GetParam(key, v) && v != 0) {
                needFilter = false;
            }
        }
    }
    return needFilter;
}

VOID HmcRenderLayer::CopyHmcLayerInfo(std::shared_ptr<HmcRenderLayer> &srcLayer)
{
    if (srcLayer == nullptr) {
        LOGE("HmcRenderEffect::CopyHmcLayerInfo srcLayer is nullptr");
        return;
    }
    m_IsInPreviewMode = srcLayer->m_IsInPreviewMode;
    m_IsSwitchPage = srcLayer->m_IsSwitchPage;
    m_isDrawWaterMark = srcLayer->m_isDrawWaterMark;
    m_isDragImage = srcLayer->m_isDragImage;
    
    m_effectList.clear();
    for (auto &effectPtr : srcLayer->m_effectList) {
        if (effectPtr == nullptr) {
            continue;
        }
        HmcRenderEffectPtr effect = std::make_shared<HmcRenderEffect>();
        effect->CopyHmcEffect(effectPtr);
        m_effectList.push_back(effect);
    }
}
