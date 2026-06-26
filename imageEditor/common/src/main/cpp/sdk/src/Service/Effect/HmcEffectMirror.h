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

#ifndef HMC_EFFECT_MIRROR_H
#define HMC_EFFECT_MIRROR_H

#include "HmcEffect.h"

class HmcEffectMirror : public HmcEffect {
public:
    HmcEffectMirror(HmcUid assetUid, HmcEventHandler *eventHandler);
    ~HmcEffectMirror() override = default;

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

protected:
    HmcEffectMirror(const HmcEffectMirror &mirror);
    HmcEffectMirror &operator = (const HmcEffectMirror &mirror);

private:
    BOOL m_mirrorH{ FALSE };
    BOOL m_mirrorV{ FALSE };
};

#endif // HMC_EFFECT_MIRROR_H
