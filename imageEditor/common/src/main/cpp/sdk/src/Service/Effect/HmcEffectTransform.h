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

#ifndef HMC_EFFECT_TRANSFORM_H
#define HMC_EFFECT_TRANSFORM_H

#include "HmcEffect.h"

class HmcEffectTransform : public HmcEffect {
public:
    HmcEffectTransform(HmcUid assetUid, HmcEventHandler *eventHandler);
    ~HmcEffectTransform() override;

public:
    HmcEffect *Duplicate() override;

    BOOL Init() override;
    BOOL Init(HmcDict *dict) override;

    Json::Value Serialize() override;
    BOOL Deserialize(const Json::Value &jsonData) override;

    VOID SetEffectParameter(HmcDict *dict) override;
    VOID GetEffectParameter(HmcDict *dict) override;

    VOID UpdateRenderInfo() override;
    VOID SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index = -1) override;

    VOID UpdateTransformInfo();

public:
    HmcAssetCropPosition GetCropPosition() const;

protected:
    HmcEffectTransform(const HmcEffectTransform &transform);
    HmcEffectTransform &operator = (const HmcEffectTransform &transform);

private:
    static inline VOID ParseTransformValue(HmcDict *dict, const char *parameterName, INT32 &destValue);
    static inline VOID ParseTransformValue(const Json::Value &jsonData, const char *parameterName, INT32 &destValue);
    static inline VOID ParseTransformValue(HmcDict *dict, const char *parameterName, FLOAT &destValue);
    static inline VOID ParseTransformValue(const Json::Value &jsonData, const char *parameterName, FLOAT &destValue);
    static inline VOID ParseTransformValue(HmcDict *dict, const char *parameterName, PropertyType<INT32> &destValue);
    static inline VOID ParseTransformValue(const Json::Value &jsonData, const char *parameterName,
        PropertyType<INT32> &destValue);
    static inline VOID ParseTransformValue(HmcDict *dict, const char *parameterName, PropertyType<FLOAT> &destValue);
    static inline VOID ParseTransformValue(const Json::Value &jsonData, const char *parameterName,
        PropertyType<FLOAT> &destValue);

private:
    VisionTransformInfo m_TransformParameter;

    HmcAssetCropPosition cropPosition = {
        .leftTop = { 0, 1 },
        .leftBottom = { 0, 0 },
        .rightTop = { 1, 1 },
        .rightBottom = { 1, 0 }
    };
    FLOAT cropOffsetX = 0.0;
    FLOAT cropOffsetY = 0.0;
    FLOAT cropScaleX = 1.0;
    FLOAT cropScaleY = 1.0;
    FLOAT cropRotate = 0.0;
    FLOAT cropEnable = 1.0;

    FLOAT viewPortX = 900;
    FLOAT viewPortY = 504;
};

#endif // HMC_EFFECT_TRANSFORM_H
