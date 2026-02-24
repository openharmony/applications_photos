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

#ifndef HMC_EFFECT_ADJUST_H
#define HMC_EFFECT_ADJUST_H

#include "render/core/RenderColorAdjust.h"
#include "../Editor/HmcEventHandler.h"
#include "HmcEffect.h"

using AdjustItem = struct AdjustItem {
    INT32 value = 0;
    BOOL enable = TRUE;
};

using AdjustParameter = class AdjustParameter {
public:
    AdjustItem m_auto{ 0, FALSE };
    AdjustItem m_hueAdjust{ 0, TRUE };
    AdjustItem m_saturation{ 0, TRUE };
    AdjustItem m_brightness{ 0, TRUE };
    AdjustItem m_contrast{ 0, TRUE };
    AdjustItem m_temperature{ 0, TRUE };
    AdjustItem m_sharpness{ 0, TRUE };
    AdjustItem m_fade{ 0, TRUE };
    AdjustItem m_exposure{ 0, TRUE };
    AdjustItem m_grain{ 0, TRUE };
    AdjustItem m_highlight{ 0, TRUE };
    AdjustItem m_shadow{ 0, TRUE };
    AdjustItem m_vignette{ 0, TRUE };
    AdjustItem m_vibrance{ 0, TRUE };
    AdjustItem m_brightzone{ 0, TRUE };
    AdjustItem m_darkzone{ 0, TRUE };
};

class HmcEffectAdjust : public HmcEffect {
public:
    HmcEffectAdjust(HmcUid uid, HmcEventHandler *eventHandler);
    ~HmcEffectAdjust() override = default;

public:
    Json::Value Serialize() override;
    BOOL Deserialize(const Json::Value &jsonData) override;

    VOID SetEffectParameter(HmcDict *dict) override;
    VOID GetEffectParameter(HmcDict *dict) override;

    HmcEffect *Duplicate() override;

    BOOL Init() override;
    BOOL Init(HmcDict *dict) override;

    BOOL IsNotNeedRender();
    VOID UpdateRenderInfo() override;
    VOID SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index = -1) override;

    VOID SetHue(HmcDict *dict);
    INT32 GetHue() const;

    VOID SetSaturation(INT32 saturation);
    INT32 GetSaturation() const;

    VOID SetBrightness(INT32 brightness);
    INT32 GetBrightness() const;

    VOID SetContrast(INT32 contrast);
    INT32 GetContrast() const;

    VOID SetTemperature(INT32 temperature);
    INT32 GetTemperature() const;

    VOID SetSharpness(INT32 sharpness);
    INT32 GetSharpness() const;

    VOID SetFade(INT32 fade);
    INT32 GetFade() const;

    VOID SetExposure(INT32 exposure);
    INT32 GetExposure() const;

    VOID SetGrain(INT32 grain);
    INT32 GetGrain() const;

    VOID SetHighLight(INT32 light);
    INT32 GetHighLight() const;

    VOID SetShadow(INT32 shadow);
    INT32 GetShadow() const;

    VOID SetVignette(INT32 vignette);
    INT32 GetVignette() const;

    VOID SetVibrance(INT32 vibrance);
    INT32 GetVibrance() const;

    VOID SetBrightzone(INT32 brightzone);
    INT32 GetBrightzone() const;

    VOID SetDarkzone(INT32 darkzone);
    INT32 GetDarkzone() const;

protected:
    HmcEffectAdjust(const HmcEffectAdjust &adjust);
    HmcEffectAdjust &operator = (const HmcEffectAdjust &adjust);

private:
    VOID UpdateAdjust();
    static inline VOID ParseAdjustValue(HmcDict *dict, const char *parameterName, INT32 &destValue);
    static inline VOID ParseAdjustValue(const Json::Value &jsonData, const char *parameterName, INT32 &destValue);

    static inline VOID ParseAdjustEnable(HmcDict *dict, const char *parameterName, BOOL &destEnable);
    static inline VOID ParseAdjustEnable(const Json::Value &jsonData, const char *parameterName, BOOL &destEnable);

    static BOOL LoadParam(HmcDict *dict, const STRING &key);

private:
    RenderColorAdjust m_colorAdjust;
    AdjustParameter m_adjustParameter;
};

#endif // HMC_EFFECT_ADJUST_H
