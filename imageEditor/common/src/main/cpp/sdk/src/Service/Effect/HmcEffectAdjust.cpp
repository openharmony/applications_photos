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
#include "Material/Utils/HmcMaterialRenderResUtil.h"

/* 外部设置的颜色调节的参数和引擎支持的参数的对应关系表 */
static MAP<STRING, STRING> g_coloAdjustKeyMap = { { DICT_KEY_ADJUST_HUE, "HUE" },
                                                  { DICT_KEY_ADJUST_HUE_ENABLE, "COLOR_ADJUST_HUE" },
                                                  { DICT_KEY_ADJUST_SATURATION, "SATURATION" },
                                                  { DICT_KEY_ADJUST_SATURATION_ENABLE, "COLOR_ADJUST_SATURATION" },
                                                  { DICT_KEY_ADJUST_BRIGHTNESS, "BRIGHTNESS" },
                                                  { DICT_KEY_ADJUST_BRIGHTNESS_ENABLE, "COLOR_ADJUST_BRIGHTNESS" },
                                                  { DICT_KEY_ADJUST_CONTRAST, "CONTRAST" },
                                                  { DICT_KEY_ADJUST_CONTRAST_ENABLE, "COLOR_ADJUST_CONTRAST" },
                                                  { DICT_KEY_ADJUST_TEMPERATURE, "TEMPERATURE" },
                                                  { DICT_KEY_ADJUST_TEMPERATURE_ENABLE, "COLOR_ADJUST_TEMPERATURE" },
                                                  { DICT_KEY_ADJUST_SHARPNESS, "SHARPNESS" },
                                                  { DICT_KEY_ADJUST_SHARPNESS_ENABLE, "COLOR_ADJUST_SHARPNESS" },
                                                  { DICT_KEY_ADJUST_FADE, "FADE" },
                                                  { DICT_KEY_ADJUST_FADE_ENABLE, "COLOR_ADJUST_FADE" },
                                                  { DICT_KEY_ADJUST_EXPOSURE, "EXPOSURE" },
                                                  { DICT_KEY_ADJUST_EXPOSURE_ENABLE, "COLOR_ADJUST_EXPOSURE" },
                                                  { DICT_KEY_ADJUST_GRAIN, "GRAIN" },
                                                  { DICT_KEY_ADJUST_GRAIN_ENABLE, "COLOR_ADJUST_GRAIN" },
                                                  { DICT_KEY_ADJUST_HIGHLIGHT, "HIGHLIGHT" },
                                                  { DICT_KEY_ADJUST_HIGHLIGHT_ENABLE, "COLOR_ADJUST_HIGHLIGHT" },
                                                  { DICT_KEY_ADJUST_SHADOW, "SHADOW" },
                                                  { DICT_KEY_ADJUST_SHADOW_ENABLE, "COLOR_ADJUST_SHADOW" },
                                                  { DICT_KEY_ADJUST_VIGNETTE, "VIGNETTE" },
                                                  { DICT_KEY_ADJUST_VIGNETTE_ENABLE, "COLOR_ADJUST_VIGNETTE" },
                                                  { DICT_KEY_ADJUST_VIBRANCE, "VIBRANCE" },
                                                  { DICT_KEY_ADJUST_VIBRANCE_ENABLE, "COLOR_ADJUST_VIBRANCE" },
                                                  { DICT_KEY_ADJUST_BRIGHTZONE, "BRIGHTZONE" },
                                                  { DICT_KEY_ADJUST_BRIGHTZONE_ENABLE, "COLOR_ADJUST_BRIGHTZONE" },
                                                  { DICT_KEY_ADJUST_DARKZONE, "DARKZONE" },
                                                  { DICT_KEY_ADJUST_DARKZONE_ENABLE, "COLOR_ADJUST_DARKZONE" } };

HmcEffectAdjust::HmcEffectAdjust(HmcUid uid, HmcEventHandler *eventHandler) : HmcEffect(uid, eventHandler)
{
    m_type = HMC_EFFECT_ADJUST;
}

HmcEffectAdjust::HmcEffectAdjust(const HmcEffectAdjust &adjust) : HmcEffect(adjust)
{
    m_colorAdjust = adjust.m_colorAdjust;
    m_adjustParameter = adjust.m_adjustParameter;
}

HmcEffectAdjust &HmcEffectAdjust::operator = (const HmcEffectAdjust &adjust)
{
    if (this == &adjust) {
        return *this;
    }

    HmcEffect::operator = (adjust);
    m_colorAdjust = adjust.m_colorAdjust;
    m_adjustParameter = adjust.m_adjustParameter;

    return *this;
}

HmcEffect *HmcEffectAdjust::Duplicate()
{
    auto adjust = new (std::nothrow) HmcEffectAdjust(*this);
    if (adjust == nullptr) {
        LOGE("malloc memory for adjust failed");
        return nullptr;
    }

    if (adjust->Init() != TRUE) {
        LOGE("init adjust failed");
        delete adjust;
        adjust = nullptr;
        return nullptr;
    }

    adjust->UpdateRenderInfo();

    return adjust;
}

Json::Value HmcEffectAdjust::Serialize()
{
    Json::Value json = HmcEffect::Serialize();

    json[DICT_KEY_ADJUST_HUE] = m_adjustParameter.m_hueAdjust.value;
    json[DICT_KEY_ADJUST_SATURATION] = m_adjustParameter.m_saturation.value;
    json[DICT_KEY_ADJUST_BRIGHTNESS] = m_adjustParameter.m_brightness.value;
    json[DICT_KEY_ADJUST_CONTRAST] = m_adjustParameter.m_contrast.value;
    json[DICT_KEY_ADJUST_TEMPERATURE] = m_adjustParameter.m_temperature.value;
    json[DICT_KEY_ADJUST_SHARPNESS] = m_adjustParameter.m_sharpness.value;
    json[DICT_KEY_ADJUST_FADE] = m_adjustParameter.m_fade.value;
    json[DICT_KEY_ADJUST_EXPOSURE] = m_adjustParameter.m_exposure.value;
    json[DICT_KEY_ADJUST_GRAIN] = m_adjustParameter.m_grain.value;
    json[DICT_KEY_ADJUST_HIGHLIGHT] = m_adjustParameter.m_highlight.value;
    json[DICT_KEY_ADJUST_SHADOW] = m_adjustParameter.m_shadow.value;
    json[DICT_KEY_ADJUST_VIGNETTE] = m_adjustParameter.m_vignette.value;
    json[DICT_KEY_ADJUST_VIBRANCE] = m_adjustParameter.m_vibrance.value;
    json[DICT_KEY_ADJUST_BRIGHTZONE] = m_adjustParameter.m_brightzone.value;
    json[DICT_KEY_ADJUST_DARKZONE] = m_adjustParameter.m_darkzone.value;

    json[DICT_KEY_ADJUST_HUE_ENABLE] = m_adjustParameter.m_hueAdjust.enable;
    json[DICT_KEY_ADJUST_SATURATION_ENABLE] = m_adjustParameter.m_saturation.enable;
    json[DICT_KEY_ADJUST_BRIGHTNESS_ENABLE] = m_adjustParameter.m_brightness.enable;
    json[DICT_KEY_ADJUST_CONTRAST_ENABLE] = m_adjustParameter.m_contrast.enable;
    json[DICT_KEY_ADJUST_TEMPERATURE_ENABLE] = m_adjustParameter.m_temperature.enable;
    json[DICT_KEY_ADJUST_SHARPNESS_ENABLE] = m_adjustParameter.m_sharpness.enable;
    json[DICT_KEY_ADJUST_FADE_ENABLE] = m_adjustParameter.m_fade.enable;
    json[DICT_KEY_ADJUST_EXPOSURE_ENABLE] = m_adjustParameter.m_exposure.enable;
    json[DICT_KEY_ADJUST_GRAIN_ENABLE] = m_adjustParameter.m_grain.enable;
    json[DICT_KEY_ADJUST_HIGHLIGHT_ENABLE] = m_adjustParameter.m_highlight.enable;
    json[DICT_KEY_ADJUST_SHADOW_ENABLE] = m_adjustParameter.m_shadow.enable;
    json[DICT_KEY_ADJUST_VIGNETTE_ENABLE] = m_adjustParameter.m_vignette.enable;
    json[DICT_KEY_ADJUST_VIBRANCE_ENABLE] = m_adjustParameter.m_vibrance.enable;
    json[DICT_KEY_ADJUST_BRIGHTZONE_ENABLE] = m_adjustParameter.m_brightzone.enable;
    json[DICT_KEY_ADJUST_DARKZONE_ENABLE] = m_adjustParameter.m_darkzone.enable;

    return json;
}

BOOL HmcEffectAdjust::Deserialize(const Json::Value &jsonData)
{
    if (HmcEffect::Deserialize(jsonData) == FALSE) {
        LOGE("deserialize asset failed");
        return FALSE;
    }

    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_AUTO, m_adjustParameter.m_auto.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_HUE, m_adjustParameter.m_hueAdjust.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_SATURATION, m_adjustParameter.m_saturation.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_BRIGHTNESS, m_adjustParameter.m_brightness.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_CONTRAST, m_adjustParameter.m_contrast.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_TEMPERATURE, m_adjustParameter.m_temperature.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_SHARPNESS, m_adjustParameter.m_sharpness.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_FADE, m_adjustParameter.m_fade.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_EXPOSURE, m_adjustParameter.m_exposure.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_GRAIN, m_adjustParameter.m_grain.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_HIGHLIGHT, m_adjustParameter.m_highlight.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_SHADOW, m_adjustParameter.m_shadow.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_VIGNETTE, m_adjustParameter.m_vignette.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_VIBRANCE, m_adjustParameter.m_vibrance.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_BRIGHTZONE, m_adjustParameter.m_brightzone.value);
    ParseAdjustValue(jsonData, DICT_KEY_ADJUST_DARKZONE, m_adjustParameter.m_darkzone.value);

    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_AUTO_ENABLE, m_adjustParameter.m_auto.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_HUE_ENABLE, m_adjustParameter.m_hueAdjust.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_SATURATION_ENABLE, m_adjustParameter.m_saturation.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_BRIGHTNESS_ENABLE, m_adjustParameter.m_brightness.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_CONTRAST_ENABLE, m_adjustParameter.m_contrast.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_TEMPERATURE_ENABLE, m_adjustParameter.m_temperature.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_SHARPNESS_ENABLE, m_adjustParameter.m_sharpness.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_FADE_ENABLE, m_adjustParameter.m_fade.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_EXPOSURE_ENABLE, m_adjustParameter.m_exposure.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_GRAIN_ENABLE, m_adjustParameter.m_grain.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_HIGHLIGHT_ENABLE, m_adjustParameter.m_highlight.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_SHADOW_ENABLE, m_adjustParameter.m_shadow.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_VIGNETTE_ENABLE, m_adjustParameter.m_vignette.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_VIBRANCE_ENABLE, m_adjustParameter.m_vibrance.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_BRIGHTZONE_ENABLE, m_adjustParameter.m_brightzone.enable);
    ParseAdjustEnable(jsonData, DICT_KEY_ADJUST_DARKZONE_ENABLE, m_adjustParameter.m_darkzone.enable);

    if (Init() != TRUE) {
        LOGE("init adjust failed");
        return FALSE;
    }

    UpdateRenderInfo();

    return TRUE;
}

VOID HmcEffectAdjust::SetEffectParameter(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return;
    }

    ParseAdjustValue(dict, DICT_KEY_ADJUST_AUTO, m_adjustParameter.m_auto.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_AUTO_ENABLE, m_adjustParameter.m_auto.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_HUE, m_adjustParameter.m_hueAdjust.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_HUE_ENABLE, m_adjustParameter.m_hueAdjust.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_SATURATION, m_adjustParameter.m_saturation.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_SATURATION_ENABLE, m_adjustParameter.m_saturation.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_BRIGHTNESS, m_adjustParameter.m_brightness.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_BRIGHTNESS_ENABLE, m_adjustParameter.m_brightness.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_CONTRAST, m_adjustParameter.m_contrast.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_CONTRAST_ENABLE, m_adjustParameter.m_contrast.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_TEMPERATURE, m_adjustParameter.m_temperature.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_TEMPERATURE_ENABLE, m_adjustParameter.m_temperature.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_SHARPNESS, m_adjustParameter.m_sharpness.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_SHARPNESS_ENABLE, m_adjustParameter.m_sharpness.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_FADE, m_adjustParameter.m_fade.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_FADE_ENABLE, m_adjustParameter.m_fade.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_EXPOSURE, m_adjustParameter.m_exposure.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_EXPOSURE_ENABLE, m_adjustParameter.m_exposure.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_GRAIN, m_adjustParameter.m_grain.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_GRAIN_ENABLE, m_adjustParameter.m_grain.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_HIGHLIGHT, m_adjustParameter.m_highlight.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_HIGHLIGHT_ENABLE, m_adjustParameter.m_highlight.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_SHADOW, m_adjustParameter.m_shadow.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_SHADOW_ENABLE, m_adjustParameter.m_shadow.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_VIGNETTE, m_adjustParameter.m_vignette.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_VIGNETTE_ENABLE, m_adjustParameter.m_vignette.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_VIBRANCE, m_adjustParameter.m_vibrance.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_VIBRANCE_ENABLE, m_adjustParameter.m_vibrance.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_BRIGHTZONE, m_adjustParameter.m_brightzone.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_BRIGHTZONE_ENABLE, m_adjustParameter.m_brightzone.enable);

    ParseAdjustValue(dict, DICT_KEY_ADJUST_DARKZONE, m_adjustParameter.m_darkzone.value);
    ParseAdjustEnable(dict, DICT_KEY_ADJUST_DARKZONE_ENABLE, m_adjustParameter.m_darkzone.enable);

    UpdateRenderInfo();
}

VOID HmcEffectAdjust::GetEffectParameter(HmcDict *dict)
{
    HmcEffect::GetEffectParameter(dict);

    HmcDictSetInt32(dict, DICT_KEY_ADJUST_AUTO, m_adjustParameter.m_auto.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_HUE, m_adjustParameter.m_hueAdjust.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_SATURATION, m_adjustParameter.m_saturation.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_BRIGHTNESS, m_adjustParameter.m_brightness.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_CONTRAST, m_adjustParameter.m_contrast.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_TEMPERATURE, m_adjustParameter.m_temperature.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_SHARPNESS, m_adjustParameter.m_sharpness.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_FADE, m_adjustParameter.m_fade.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_EXPOSURE, m_adjustParameter.m_exposure.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_GRAIN, m_adjustParameter.m_grain.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_HIGHLIGHT, m_adjustParameter.m_highlight.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_SHADOW, m_adjustParameter.m_shadow.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_VIGNETTE, m_adjustParameter.m_vignette.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_VIBRANCE, m_adjustParameter.m_vibrance.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_BRIGHTZONE, m_adjustParameter.m_brightzone.value);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_DARKZONE, m_adjustParameter.m_darkzone.value);

    HmcDictSetInt32(dict, DICT_KEY_ADJUST_AUTO_ENABLE, m_adjustParameter.m_auto.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_HUE_ENABLE, m_adjustParameter.m_hueAdjust.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_SATURATION_ENABLE, m_adjustParameter.m_saturation.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_BRIGHTNESS_ENABLE, m_adjustParameter.m_brightness.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_CONTRAST_ENABLE, m_adjustParameter.m_contrast.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_TEMPERATURE_ENABLE, m_adjustParameter.m_temperature.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_SHARPNESS_ENABLE, m_adjustParameter.m_sharpness.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_FADE_ENABLE, m_adjustParameter.m_fade.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_EXPOSURE_ENABLE, m_adjustParameter.m_exposure.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_GRAIN_ENABLE, m_adjustParameter.m_grain.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_HIGHLIGHT_ENABLE, m_adjustParameter.m_highlight.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_SHADOW_ENABLE, m_adjustParameter.m_shadow.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_VIGNETTE_ENABLE, m_adjustParameter.m_vignette.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_VIBRANCE_ENABLE, m_adjustParameter.m_vibrance.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_BRIGHTZONE_ENABLE, m_adjustParameter.m_brightzone.enable);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_DARKZONE_ENABLE, m_adjustParameter.m_darkzone.enable);
}

BOOL HmcEffectAdjust::Init()
{
    if (!HmcEffect::Init()) {
        return FALSE;
    }

    // 解析颜色调节包资源对象
    m_renderEffect->m_resource.get()->m_effectType = "adjust";
    m_renderEffect->m_resource.get()->m_effectName = "ColorAdjust";

    return TRUE;
}

BOOL HmcEffectAdjust::Init(HmcDict *dict)
{
    if (!HmcEffect::Init(dict)) {
        return FALSE;
    }

    SetEffectParameter(dict);

    m_renderEffect->m_resource.get()->m_effectType = "adjust";
    m_renderEffect->m_resource.get()->m_effectName = "ColorAdjust";

    return TRUE;
}

// 判断是否不需要进行渲染
BOOL HmcEffectAdjust::IsNotNeedRender()
{
    // 如果全部调节项都设为默认值0，或者刨除关闭的调节项外，其他调节项均为默认值0，则为true，否则，则为false
    return (((m_adjustParameter.m_hueAdjust.value == 0) || (!m_adjustParameter.m_hueAdjust.enable)) &&
        ((m_adjustParameter.m_saturation.value == 0) || (!m_adjustParameter.m_saturation.enable)) &&
        ((m_adjustParameter.m_brightness.value == 0) || (!m_adjustParameter.m_brightness.enable)) &&
        ((m_adjustParameter.m_contrast.value == 0) || (!m_adjustParameter.m_contrast.enable)) &&
        ((m_adjustParameter.m_temperature.value == 0) || (!m_adjustParameter.m_temperature.enable)) &&
        ((m_adjustParameter.m_sharpness.value == 0) || (!m_adjustParameter.m_sharpness.enable)) &&
        ((m_adjustParameter.m_fade.value == 0) || (!m_adjustParameter.m_fade.enable)) &&
        ((m_adjustParameter.m_exposure.value == 0) || (!m_adjustParameter.m_exposure.enable)) &&
        ((m_adjustParameter.m_grain.value == 0) || (!m_adjustParameter.m_grain.enable)) &&
        ((m_adjustParameter.m_highlight.value == 0) || (!m_adjustParameter.m_highlight.enable)) &&
        ((m_adjustParameter.m_shadow.value == 0) || (!m_adjustParameter.m_shadow.enable)) &&
        ((m_adjustParameter.m_vignette.value == 0) || (!m_adjustParameter.m_vignette.enable)) &&
        ((m_adjustParameter.m_vibrance.value == 0) || (!m_adjustParameter.m_vibrance.enable)) &&
        ((m_adjustParameter.m_brightzone.value == 0) || (!m_adjustParameter.m_brightzone.enable)) &&
        ((m_adjustParameter.m_darkzone.value == 0) || (!m_adjustParameter.m_darkzone.enable)));
}

VOID HmcEffectAdjust::SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index)
{
    LOGI("SetRenderLayer is default effect: %d", IsNotNeedRender());
    UpdateRenderInfo();
    HmcEffect::SetRenderLayer(layer, index);
}

VOID HmcEffectAdjust::UpdateRenderInfo()
{
    UpdateAdjust();

    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_HUE], m_colorAdjust.GetHueAdjust());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_SATURATION], m_colorAdjust.GetSaturationInputLevel());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_BRIGHTNESS], m_colorAdjust.GetBrightness());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_CONTRAST], m_colorAdjust.GetContrast());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_TEMPERATURE], m_colorAdjust.GetTemperature());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_SHARPNESS], m_colorAdjust.GetSharpness());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_FADE], m_colorAdjust.GetFadeIntensity());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_EXPOSURE], m_colorAdjust.GetExposureIntensity());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_GRAIN], m_colorAdjust.GetGrainPower());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_HIGHLIGHT], m_colorAdjust.GetHighlightIntensity());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_SHADOW], m_colorAdjust.GetShadowsIntensity());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_VIGNETTE], m_colorAdjust.GetVignetteIntensity());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_VIBRANCE], m_colorAdjust.GetVibranceIntensity());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_BRIGHTZONE], m_colorAdjust.GetBrightzoneIntensity());
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_DARKZONE], m_colorAdjust.GetDarkzoneIntensity());

    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_HUE_ENABLE], m_adjustParameter.m_hueAdjust.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_SATURATION_ENABLE],
        m_adjustParameter.m_saturation.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_BRIGHTNESS_ENABLE],
        m_adjustParameter.m_brightness.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_CONTRAST_ENABLE], m_adjustParameter.m_contrast.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_TEMPERATURE_ENABLE],
        m_adjustParameter.m_temperature.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_SHARPNESS_ENABLE],
        m_adjustParameter.m_sharpness.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_FADE_ENABLE], m_adjustParameter.m_fade.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_EXPOSURE_ENABLE], m_adjustParameter.m_exposure.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_GRAIN_ENABLE], m_adjustParameter.m_grain.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_HIGHLIGHT_ENABLE],
        m_adjustParameter.m_highlight.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_SHADOW_ENABLE], m_adjustParameter.m_shadow.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_VIGNETTE_ENABLE], m_adjustParameter.m_vignette.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_VIBRANCE_ENABLE], m_adjustParameter.m_vibrance.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_BRIGHTZONE_ENABLE],
        m_adjustParameter.m_brightzone.enable);
    m_renderEffect->SetParam(g_coloAdjustKeyMap[DICT_KEY_ADJUST_DARKZONE_ENABLE], m_adjustParameter.m_darkzone.enable);
}

/*
 * 将UI设置的调节参数转换到引擎可的范围，UI支持的都是-100到100，或者0-100，而引擎支持的是下列：
 * "HUE"                    float: 色调(范围：-1~1，默认值：0).
 * "SATURATION"             float: 饱和度(范围：-1~1，默认值：0).
 * "BRIGHTNESS"             float: 亮度(范围：-1~1，默认值：0).
 * "CONTRAST"               float: 对比度(范围：-1~1，默认值：0).
 * "TEMPERATURE"            float: 色温(范围：-1~1，默认值：0).
 * "SHARPNESS"              float: 锐度(范围：0~1，默认值：0).
 * "FADE"                   float: 褪色(范围：0~1，默认值：0).
 * "EXPOSURE"               float: 曝光(范围：-1~1，默认值：0).
 * "GRAIN"                  float: 颗粒(范围：0~1，默认值：0).
 * "HIGHLIGHT"              float: 高光(范围：-1~1，默认值：0).
 * "SHADOW"                 float: 阴影(范围：-1~1，默认值：0).
 * "VIGNETTE"               float: 暗角(范围：-1~1，默认值：0).
 * "VIBRANCE"               float: 自然饱和度(范围：-1~1，默认值：0).
 * "BRIGHTZONE"             float: 亮部(范围：-0.5~0.5，默认值：0).
 * "DARKZONE"               float: 暗部(范围：-0.5~0.5，默认值：0).
 */
VOID HmcEffectAdjust::UpdateAdjust()
{
    constexpr FLOAT uiDistance2RenderDistanceRate =
        100.0f; // 颜色值除以该值，是为了将颜色值-100~0转换到-1~0或者将0~100转换到0~1.

    // 色调调节项
    // 与PC不同的是不需要做转换负值处理
    m_colorAdjust.SetHueAdjust(((FLOAT)m_adjustParameter.m_hueAdjust.value / uiDistance2RenderDistanceRate));
    /* 饱和度对外contrast取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetSaturationInputLevel((FLOAT)m_adjustParameter.m_saturation.value / uiDistance2RenderDistanceRate);
    /* 亮度对外contrast取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetBrightness((FLOAT)m_adjustParameter.m_brightness.value / uiDistance2RenderDistanceRate);
    /* 对比度对外contrast取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetContrast((FLOAT)m_adjustParameter.m_contrast.value / uiDistance2RenderDistanceRate);
    /* 色温对外temperature取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetTemperature((FLOAT)m_adjustParameter.m_temperature.value / uiDistance2RenderDistanceRate);
    /* 锐度对外Sharpness取值为0~100，默认值为0；分段映射到渲染支持的0~1，默认值为0 */
    m_colorAdjust.SetSharpness((FLOAT)(m_adjustParameter.m_sharpness.value) / uiDistance2RenderDistanceRate);
    /* 褪色对外Fade取值为0~100，默认值为0；分段映射到渲染支持的0~1，默认值为0 */
    m_colorAdjust.SetFadeIntensity((FLOAT)(m_adjustParameter.m_fade.value) / uiDistance2RenderDistanceRate);
    /* 曝光对外Exposure取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetExposureIntensity((FLOAT)(m_adjustParameter.m_exposure.value) / uiDistance2RenderDistanceRate);
    /* 颗粒对外Grain取值为0~100，默认值为0；分段映射到渲染支持的0~1，默认值为0 */
    m_colorAdjust.SetGrainPower((FLOAT)(m_adjustParameter.m_grain.value) / uiDistance2RenderDistanceRate);
    /* 高光对外Highlight取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetHighlightIntensity((FLOAT)m_adjustParameter.m_highlight.value / uiDistance2RenderDistanceRate);
    /* 阴影对外Shadow取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetShadowsIntensity((FLOAT)m_adjustParameter.m_shadow.value / uiDistance2RenderDistanceRate);
    /* 暗角对外Vignette取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetVignetteIntensity((FLOAT)m_adjustParameter.m_vignette.value / uiDistance2RenderDistanceRate);
    /* 自然饱和度对外Vibrance取值为-100~100，默认值为0；分段映射到渲染支持的-1~1，默认值为0 */
    m_colorAdjust.SetVibranceIntensity((FLOAT)m_adjustParameter.m_vibrance.value / uiDistance2RenderDistanceRate);
    /* 亮部对外Brightzone取值为-100~100，默认值为0；分段映射到渲染支持的-0.5~0.5，默认值为0 */
    m_colorAdjust.SetBrightzoneIntensity((FLOAT)m_adjustParameter.m_brightzone.value /
        (uiDistance2RenderDistanceRate * 2));
    /* 暗部对外Darkzone取值为-100~100，默认值为0；分段映射到渲染支持的-0.5~0.5，默认值为0 */
    m_colorAdjust.SetDarkzoneIntensity((FLOAT)m_adjustParameter.m_darkzone.value / (uiDistance2RenderDistanceRate * 2));
}

VOID HmcEffectAdjust::ParseAdjustValue(HmcDict *dict, const char *parameterName, INT32 &destValue)
{
    if (HmcDictGetInt32(dict, parameterName, &destValue) == HMC_OK) {
        LOGI("set adjust %s to %d", parameterName, destValue);
    }
}

VOID HmcEffectAdjust::ParseAdjustEnable(HmcDict *dict, const char *parameterName, BOOL &destEnable)
{
    INT32 value = 0;
    if (HmcDictGetInt32(dict, parameterName, &value) == HMC_OK) {
        LOGI("%s adjust %s", (value == TRUE ? "enable" : "disable"), parameterName);
        destEnable = static_cast<BOOL>(value);
    }
}

VOID HmcEffectAdjust::ParseAdjustValue(const Json::Value &jsonData, const char *parameterName, INT32 &destValue)
{
    if (JsonValueUtil::ParseValueIfHas(jsonData, parameterName, destValue)) {
        LOGI("set adjust %s to: %d", parameterName, destValue);
    }
}

VOID HmcEffectAdjust::ParseAdjustEnable(const Json::Value &jsonData, const char *parameterName, BOOL &destEnable)
{
    INT32 value = 0;
    if (JsonValueUtil::ParseValueIfHas(jsonData, parameterName, value)) {
        LOGI("%s adjust %s", (value == TRUE ? "enable" : "disable"), parameterName);
        destEnable = static_cast<BOOL>(value);
    }
}

VOID HmcEffectAdjust::SetHue(HmcDict *dict)
{
    ParseAdjustValue(dict, DICT_KEY_ADJUST_HUE, m_adjustParameter.m_hueAdjust.value);
}

INT32 HmcEffectAdjust::GetHue() const
{
    return m_adjustParameter.m_hueAdjust.value;
}

VOID HmcEffectAdjust::SetSaturation(INT32 saturation)
{
    m_adjustParameter.m_saturation.value = saturation;
}

INT32 HmcEffectAdjust::GetSaturation() const
{
    return m_adjustParameter.m_saturation.value;
}

VOID HmcEffectAdjust::SetBrightness(INT32 brightness)
{
    m_adjustParameter.m_brightness.value = brightness;
}

INT32 HmcEffectAdjust::GetBrightness() const
{
    return m_adjustParameter.m_brightness.value;
}

VOID HmcEffectAdjust::SetContrast(INT32 contrast)
{
    m_adjustParameter.m_contrast.value = contrast;
}

INT32 HmcEffectAdjust::GetContrast() const
{
    return m_adjustParameter.m_contrast.value;
}

VOID HmcEffectAdjust::SetTemperature(INT32 temperature)
{
    m_adjustParameter.m_temperature.value = temperature;
}

INT32 HmcEffectAdjust::GetTemperature() const
{
    return m_adjustParameter.m_temperature.value;
}

VOID HmcEffectAdjust::SetSharpness(INT32 sharpness)
{
    m_adjustParameter.m_sharpness.value = sharpness;
}

INT32 HmcEffectAdjust::GetSharpness() const
{
    return m_adjustParameter.m_sharpness.value;
}

VOID HmcEffectAdjust::SetFade(INT32 fade)
{
    m_adjustParameter.m_fade.value = fade;
}

INT32 HmcEffectAdjust::GetFade() const
{
    return m_adjustParameter.m_fade.value;
}

VOID HmcEffectAdjust::SetExposure(INT32 exposure)
{
    m_adjustParameter.m_exposure.value = exposure;
}

INT32 HmcEffectAdjust::GetExposure() const
{
    return m_adjustParameter.m_exposure.value;
}

VOID HmcEffectAdjust::SetGrain(INT32 grain)
{
    m_adjustParameter.m_grain.value = grain;
}

INT32 HmcEffectAdjust::GetGrain() const
{
    return m_adjustParameter.m_grain.value;
}

VOID HmcEffectAdjust::SetHighLight(INT32 light)
{
    m_adjustParameter.m_highlight.value = light;
}

INT32 HmcEffectAdjust::GetHighLight() const
{
    return m_adjustParameter.m_highlight.value;
}

VOID HmcEffectAdjust::SetShadow(INT32 shadow)
{
    m_adjustParameter.m_shadow.value = shadow;
}

INT32 HmcEffectAdjust::GetShadow() const
{
    return m_adjustParameter.m_shadow.value;
}

VOID HmcEffectAdjust::SetVignette(INT32 vignette)
{
    m_adjustParameter.m_vignette.value = vignette;
}

INT32 HmcEffectAdjust::GetVignette() const
{
    return m_adjustParameter.m_vignette.value;
}

VOID HmcEffectAdjust::SetVibrance(INT32 vibrance)
{
    m_adjustParameter.m_vibrance.value = vibrance;
}

INT32 HmcEffectAdjust::GetVibrance() const
{
    return m_adjustParameter.m_vibrance.value;
}

VOID HmcEffectAdjust::SetBrightzone(INT32 brightzone)
{
    m_adjustParameter.m_brightzone.value = brightzone;
}

INT32 HmcEffectAdjust::GetBrightzone() const
{
    return m_adjustParameter.m_brightzone.value;
}

VOID HmcEffectAdjust::SetDarkzone(INT32 darkzone)
{
    m_adjustParameter.m_darkzone.value = darkzone;
}

INT32 HmcEffectAdjust::GetDarkzone() const
{
    return m_adjustParameter.m_darkzone.value;
}

BOOL HmcEffectAdjust::LoadParam(HmcDict *dict, const STRING &key)
{
    if (dict == nullptr) {
        return FALSE;
    }

    auto value = 0;
    if (HmcDictGetInt32(dict, key.c_str(), &value) == HMC_OK) {
        return TRUE;
    }

    return FALSE;
}