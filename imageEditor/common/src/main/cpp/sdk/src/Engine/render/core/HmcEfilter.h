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

#ifndef HMC_EFILTER_H
#define HMC_EFILTER_H

#include "render/base/RenderBase.h"
#include <multimedia/image_effect/image_effect_filter.h>

class HmcEFilter {
public:
    HmcEFilter(std::string name, std::string type);
    ~HmcEFilter();
    void SetValue(void *value, const char *key, ImageEffect_DataType type);
    OH_EffectFilter *GetEFilter();
    void StartCache();
    void CancelCache();
    bool HasStartCache();
    // Filters attached via OH_ImageEffect_AddFilterByFilter are owned by ImageEffect; do not OH_EffectFilter_Release.
    void AbandonFilterOwnership();
private:
    bool EnsureCreated();
    OH_EffectFilter *efilter_;
    std::string name_ = "";
    std::string type_ = "";
    bool hasStartCache_ = false;
};
using HmcEFilterPtr = std::shared_ptr<HmcEFilter>;

#endif // HMC_EFILTER_H
