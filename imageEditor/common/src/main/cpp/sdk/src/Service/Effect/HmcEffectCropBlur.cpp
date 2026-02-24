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
#include "HmcEffectCropBlur.h"


const char *g_dictKeyCropBlurTopLeftX = "topLeftX";
const char *g_dictKeyCropBlurTopLeftY = "topLeftY";
const char *g_dictKeyCropBlurBottomRightX = "bottomRightX";
const char *g_dictKeyCropBlurBottomRightY = "bottomRightY";
const char *g_dictKeyCropBlurBottomOpacity = "opacity";

HmcEffectCropBlur::HmcEffectCropBlur(HmcUid assetUid, HmcEventHandler *eventHandler) : HmcEffect(assetUid, eventHandler)
{
    m_type = HMC_EFFECT_CROP_BLUR;
}

HmcEffectCropBlur::~HmcEffectCropBlur() {}

BOOL HmcEffectCropBlur::Init()
{
    if (!HmcEffect::Init()) {
        return FALSE;
    }
    m_renderEffect->m_resource.get()->m_effectType = "cropBlur";
    m_renderEffect->m_resource.get()->m_effectName = "cropBlur";

    UpdateRenderInfo();
    return TRUE;
}

BOOL HmcEffectCropBlur::Init(HmcDict *dict)
{
    if (!HmcEffect::Init(dict)) {
        return FALSE;
    }
    m_renderEffect->m_resource.get()->m_effectType = "cropBlur";
    m_renderEffect->m_resource.get()->m_effectName = "cropBlur";
    SetEffectParameter(dict);
    return TRUE;
}

VOID HmcEffectCropBlur::SetEffectParameter(HmcDict *dict)
{
    if (dict == nullptr) {
        return;
    }
    HmcEffect::SetEffectParameter(dict);
    ParseValue(dict, DICT_KEY_CROP_LEFTTOP_X, m_topLeftX);
    ParseValue(dict, DICT_KEY_CROP_LEFTTOP_Y, m_topLeftY);
    ParseValue(dict, DICT_KEY_CROP_RIGHTBOTTOM_X, m_bottomRightX);
    ParseValue(dict, DICT_KEY_CROP_RIGHTBOTTOM_Y, m_bottomRightY);
    ParseValue(dict, DICT_KEY_CROP_BLUR_OPACITY, m_opacity);

    UpdateRenderInfo();
}

VOID HmcEffectCropBlur::GetEffectParameter(HmcDict *dict)
{
    if (dict == nullptr) {
        return;
    }

    HmcEffect::GetEffectParameter(dict);

    HmcDictSetDouble(dict, DICT_KEY_CROP_LEFTTOP_X, (double)m_topLeftX);
    HmcDictSetDouble(dict, DICT_KEY_CROP_LEFTTOP_Y, (double)m_topLeftY);
    HmcDictSetDouble(dict, DICT_KEY_CROP_RIGHTBOTTOM_X, (double)m_bottomRightX);
    HmcDictSetDouble(dict, DICT_KEY_CROP_RIGHTBOTTOM_Y, (double)m_bottomRightY);
    HmcDictSetDouble(dict, DICT_KEY_CROP_BLUR_OPACITY, (double)m_opacity);
}

HmcEffect *HmcEffectCropBlur::Duplicate()
{
    auto effect = new (std::nothrow) HmcEffectCropBlur(*this);
    if (effect == nullptr) {
        LOGE("create light effect failed");
        return nullptr;
    }

    if (effect->Init() != TRUE) {
        LOGE("init HmcEffectCropBlur failed");
        delete effect;
        return nullptr;
    }

    return effect;
}

Json::Value HmcEffectCropBlur::Serialize()
{
    Json::Value json = HmcEffect::Serialize();

    json[DICT_KEY_CROP_LEFTTOP_X] = m_topLeftX;
    json[DICT_KEY_CROP_LEFTTOP_Y] = m_topLeftY;

    json[DICT_KEY_CROP_RIGHTBOTTOM_X] = m_bottomRightX;
    json[DICT_KEY_CROP_RIGHTBOTTOM_Y] = m_bottomRightY;
    json[DICT_KEY_CROP_BLUR_OPACITY] = m_opacity;

    return json;
}

BOOL HmcEffectCropBlur::Deserialize(const Json::Value &jsonData)
{
    if (HmcEffect::Deserialize(jsonData) == FALSE) {
        LOGE("deserialize effect failed");
        return FALSE;
    }

    ParseValue(jsonData, DICT_KEY_CROP_LEFTTOP_X, m_topLeftX);
    ParseValue(jsonData, DICT_KEY_CROP_LEFTTOP_Y, m_topLeftY);

    ParseValue(jsonData, DICT_KEY_CROP_RIGHTBOTTOM_X, m_bottomRightX);
    ParseValue(jsonData, DICT_KEY_CROP_RIGHTBOTTOM_Y, m_bottomRightY);
    ParseValue(jsonData, DICT_KEY_CROP_BLUR_OPACITY, m_opacity);

    return TRUE;
}

VOID HmcEffectCropBlur::SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index)
{
    HmcEffect::SetRenderLayer(layer, index);
}

VOID HmcEffectCropBlur::UpdateRenderInfo()
{
    m_renderEffect->SetParam(g_dictKeyCropBlurTopLeftX, (double)m_topLeftX);
    m_renderEffect->SetParam(g_dictKeyCropBlurTopLeftY, (double)m_topLeftY);
    m_renderEffect->SetParam(g_dictKeyCropBlurBottomRightX, (double)m_bottomRightX);
    m_renderEffect->SetParam(g_dictKeyCropBlurBottomRightY, (double)m_bottomRightY);
    m_renderEffect->SetParam(g_dictKeyCropBlurBottomOpacity, (double)m_opacity);
}

VOID HmcEffectCropBlur::ParseValue(HmcDict *dict, const char *parameterName, FLOAT &destValue)
{
    double value = 0.0;
    if (HmcDictGetDouble(dict, parameterName, &value) == HMC_OK) {
        destValue = (FLOAT)value;
        LOGI("set HmcEffectCropBlur value %s to: %.2f", parameterName, destValue);
    }
}

VOID HmcEffectCropBlur::ParseValue(const Json::Value &jsonData, const char *parameterName, FLOAT &destValue)
{
    if (JsonValueUtil::ParseFloatIfHas(jsonData, parameterName, destValue)) {
        destValue = jsonData[parameterName].asFloat();
        LOGI("set HmcEffectCropBlur value %s to: %.2f", parameterName, destValue);
    }
}

VOID HmcEffectCropBlur::ParseValue(const Json::Value &jsonData, const char *parameterName,
    PropertyType<FLOAT> &destValue)
{
    int innerValue;
    if (JsonValueUtil::ParseValueIfHas(jsonData, parameterName, innerValue)) {
        destValue.SetValue(innerValue);
        LOGI("set HmcEffectCropBlur value %s to: %d", parameterName, destValue.GetValue());
    }
}

VOID HmcEffectCropBlur::ParseValue(HmcDict *dict, const char *parameterName, PropertyType<FLOAT> &destValue)
{
    double value = 0.0;
    if (HmcDictGetDouble(dict, parameterName, &value) == HMC_OK) {
        destValue.SetValue((FLOAT)value);
        LOGI("set HmcEffectCropBlur value %s to: %.2f", parameterName, destValue.GetValue());
    }
}

HmcAssetCropPosition HmcEffectCropBlur::GetCropPosition()
{
    HmcAssetCropPosition cropPosition = {
        .leftTop = { m_topLeftX, m_topLeftY },
        .leftBottom = { m_topLeftX, m_bottomRightY },
        .rightTop = { m_bottomRightX, m_topLeftY },
        .rightBottom = { m_bottomRightX, m_bottomRightY }
    };
    return cropPosition;
}