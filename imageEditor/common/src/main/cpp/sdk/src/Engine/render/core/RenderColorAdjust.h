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

#ifndef RENDERCOLORADJUST_H
#define RENDERCOLORADJUST_H

typedef enum ColorAdjustType {
    COLOR_ADJUST_HUE = 0x00000001,
    COLOR_ADJUST_SATURATION = 0x00000002,
    COLOR_ADJUST_BRIGHTNESS = 0x00000004,
    COLOR_ADJUST_CONTRAST = 0x00000008,
    COLOR_ADJUST_TEMPERATURE = 0x00000010,
    COLOR_ADJUST_SHARPNESS = 0x00000020,
    COLOR_ADJUST_FADE = 0x00000040,
    COLOR_ADJUST_EXPOSURE = 0x00000080,
    COLOR_ADJUST_GRAIN = 0x00000100,
    COLOR_ADJUST_HIGHLIGHT = 0x00000200,
    COLOR_ADJUST_SHADOW = 0x00000400,
    COLOR_ADJUST_VIGNETTE = 0x00000800,
    COLOR_ADJUST_VIBRANCE = 0x00001000,
    COLOR_ADJUST_BRIGHTZONE = 0x00002000,
    COLOR_ADJUST_DARKZONE = 0x00004000,

    COLOR_ADJUST_ALL = 0x00000fff,
} ColorAdjustType;

class RenderColorAdjust {
public:
    VOID EnableAdjust(UINT32 enableAdjust)
    {
        g_enabledAdjust |= enableAdjust;
    }

    VOID DisableAdjust(UINT32 disableAdjust)
    {
        g_enabledAdjust &= (~disableAdjust);
    }

    BOOL isValid()
    {
        return g_enabledAdjust != 0;
    }

    BOOL isAdjustValid(UINT32 adjust)
    {
        return (g_enabledAdjust & adjust) != 0;
    }

public:
    float GetHueAdjust() const
    {
        return m_hueAdjust;
    }

    void SetHueAdjust(float mHueAdjust)
    {
        m_hueAdjust = mHueAdjust;
    }

    float GetSaturationInputLevel() const
    {
        return m_saturationInputLevel;
    }

    void SetSaturationInputLevel(float mSaturationInputLevel)
    {
        m_saturationInputLevel = mSaturationInputLevel;
    }

    float GetBrightness() const
    {
        return m_brightness;
    }

    void SetBrightness(float mBrightness)
    {
        m_brightness = mBrightness;
    }

    float GetContrast() const
    {
        return m_contrast;
    }

    void SetContrast(float mContrast)
    {
        m_contrast = mContrast;
    }

    float GetTemperature() const
    {
        return m_temperature;
    }

    void SetTemperature(float mTemperature)
    {
        m_temperature = mTemperature;
    }

    float GetSharpness() const
    {
        return m_sharpness;
    }

    void SetSharpness(float mSharpness)
    {
        m_sharpness = mSharpness;
    }

    float GetFadeIntensity() const
    {
        return m_fadeIntensity;
    }

    void SetFadeIntensity(float mFadeIntensity)
    {
        m_fadeIntensity = mFadeIntensity;
    }

    float GetExposureIntensity() const
    {
        return m_exposureIntensity;
    }

    void SetExposureIntensity(float mExposureIntensity)
    {
        m_exposureIntensity = mExposureIntensity;
    }

    float GetGrainPower() const
    {
        return m_GrainPower;
    }

    void SetGrainPower(float mGrainPower)
    {
        m_GrainPower = mGrainPower;
    }

    float GetHighlightIntensity() const
    {
        return m_highlightIntensity;
    }

    void SetHighlightIntensity(float mHighlightIntensity)
    {
        m_highlightIntensity = mHighlightIntensity;
    }

    float GetShadowsIntensity() const
    {
        return m_shadowsIntensity;
    }

    void SetShadowsIntensity(float mShadowsIntensity)
    {
        m_shadowsIntensity = mShadowsIntensity;
    }

    float GetVignetteIntensity() const
    {
        return m_vignetteIntensity;
    }

    void SetVignetteIntensity(float mVignetteIntensity)
    {
        m_vignetteIntensity = mVignetteIntensity;
    }

    float GetVibranceIntensity() const
    {
        return m_vibranceIntensity;
    }

    void SetVibranceIntensity(float mVibranceIntensity)
    {
        m_vibranceIntensity = mVibranceIntensity;
    }

    float GetBrightzoneIntensity() const
    {
        return m_brightzoneIntensity;
    }

    void SetBrightzoneIntensity(float mBrightzoneIntensity)
    {
        m_brightzoneIntensity = mBrightzoneIntensity;
    }

    float GetDarkzoneIntensity() const
    {
        return m_darkzoneIntensity;
    }

    void SetDarkzoneIntensity(float mDarkzoneIntensity)
    {
        m_darkzoneIntensity = mDarkzoneIntensity;
    }

private:
    UINT32 g_enabledAdjust = 0; // bitmap

    float m_hueAdjust = 0; // 色相

    float m_saturationInputLevel = 0.0f; // 饱和度

    float m_brightness = 0; // 亮度

    float m_contrast = 0.0f; // 对比度

    float m_temperature = 0.0f; // 色温

    float m_sharpness = 0; // 锐度

    float m_fadeIntensity = 0; // 褪色

    float m_exposureIntensity = 0; // 曝光

    float m_GrainPower = 0; // 颗粒

    float m_highlightIntensity = 0; // 高光

    float m_shadowsIntensity = 0; // 阴影

    float m_vignetteIntensity = 0; // 暗角

    float m_vibranceIntensity = 0; // 自然饱和度

    float m_brightzoneIntensity = 0; // 亮部

    float m_darkzoneIntensity = 0; // 暗部
};

#endif // RENDERCOLORADJUST_H
