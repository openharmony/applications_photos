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

#ifndef OH_HMC_EFFECT_CROP_BLUR_H
#define OH_HMC_EFFECT_CROP_BLUR_H

#include "HmcEffect.h"

class HmcEffectCropBlur : public HmcEffect {
public:
    HmcEffectCropBlur(HmcUid assetUid, HmcEventHandler *eventHandler);
    ~HmcEffectCropBlur() override;

public:
    BOOL Init() override;
    BOOL Init(HmcDict *dict) override;

    VOID SetEffectParameter(HmcDict *dict) override;
    VOID GetEffectParameter(HmcDict *dict) override;

    HmcEffect *Duplicate() override;

    Json::Value Serialize() override;
    BOOL Deserialize(const Json::Value &jsonData) override;

    VOID SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index = -1) override;
    VOID UpdateRenderInfo() override;
    
    HmcAssetCropPosition GetCropPosition();

private:
    static inline VOID ParseValue(const Json::Value &jsonData, const char *parameterName, FLOAT &destValue);
    static inline VOID ParseValue(HmcDict *dict, const char *parameterName, FLOAT &destValue);
    static inline VOID ParseValue(const Json::Value &jsonData, const char *parameterName,
        PropertyType<FLOAT> &destValue);
    static inline VOID ParseValue(HmcDict *dict, const char *parameterName, PropertyType<FLOAT> &destValue);

private:
    FLOAT m_topLeftX = 0;
    FLOAT m_topLeftY = 0;
    FLOAT m_bottomRightX = 0;
    FLOAT m_bottomRightY = 0;
    FLOAT m_opacity = 1.0;
};

#endif // OH_HMC_EFFECT_CROP_BLUR_H
