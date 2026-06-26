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

#include "render/base/RenderBase.h"
#include "HmcEngine.h"
#include "HmcEfilter.h"

const std::string START_CACHE_CONFIG = "START_CACHE";
const std::string CANCEL_CACHE_CONFIG = "CANCEL_CACHE";

HmcEFilter::HmcEFilter(std::string name, std::string type)
{
    name_ = name;
    type_ = type;
    efilter_ = OH_EffectFilter_Create(name.c_str());
}

HmcEFilter::~HmcEFilter()
{
    if (efilter_ != nullptr) {
        LOGE("HmcEFilter::~HmcEFilter()");
        OH_EffectFilter_Release(efilter_);
        efilter_ = nullptr;
    }
}

void HmcEFilter::AbandonFilterOwnership()
{
    efilter_ = nullptr;
}

bool HmcEFilter::EnsureCreated()
{
    if (efilter_ != nullptr) {
        return true;
    }
    if (name_.empty()) {
        LOGE("EnsureCreated failed, name_ is empty");
        return false;
    }
    efilter_ = OH_EffectFilter_Create(name_.c_str());
    if (efilter_ == nullptr) {
        LOGE("EnsureCreated failed, OH_EffectFilter_Create returned null. name=%s type=%s",
            name_.c_str(), type_.c_str());
        return false;
    }
    return true;
}

static ImageEffect_Any GetTestAny(void *value, ImageEffect_DataType type)
{
    ImageEffect_Any ohAny {};
    ImageEffect_DataValue dataValue {};
    if (value == nullptr) {
        LOGE("SetValue failed, value is null");
        ohAny.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_PTR;
        ohAny.dataValue.ptrValue = nullptr;
        return ohAny;
    }

    switch (type) {
        case ImageEffect_DataType::EFFECT_DATA_TYPE_INT32:
            dataValue.int32Value = *(int32_t *)(value);
            break;
        case ImageEffect_DataType::EFFECT_DATA_TYPE_DOUBLE:
            dataValue.doubleValue = *(double *)(value);
            break;
        case ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT:
            dataValue.floatValue = *(float *)(value);
            break;
        case ImageEffect_DataType::EFFECT_DATA_TYPE_LONG:
            dataValue.longValue = *(long *)(value);
            break;
        case ImageEffect_DataType::EFFECT_DATA_TYPE_PTR:
            dataValue.ptrValue = value;
            break;
        default:
            LOGE("Set Value Failed, type = %d", type);
            ohAny.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_PTR;
            ohAny.dataValue.ptrValue = nullptr;
            return ohAny;
    }
    ohAny.dataValue = dataValue;
    ohAny.dataType = type;
    return ohAny;
}

OH_EffectFilter *HmcEFilter::GetEFilter()
{
    (void)EnsureCreated();
    return efilter_;
}

void HmcEFilter::SetValue(void *value, const char *key, ImageEffect_DataType type)
{
    if (!EnsureCreated()) {
        LOGE("Set Value Failed efilter_ == nullptr, key=%s", key == nullptr ? "null" : key);
        return;
    }
    if (value == nullptr || key == nullptr) {
        LOGE("Set Value Failed invalid args. value=%{public}d key=%{public}d", value != nullptr, key != nullptr);
        return;
    }
    ImageEffect_Any ohAny = GetTestAny(value, type);
    OH_EffectFilter_SetValue(efilter_, key, &ohAny);
}

void HmcEFilter::StartCache()
{
    int temp = 0;
    LOGI("StartCache cache");
    SetValue(&temp, START_CACHE_CONFIG.c_str(), ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
    hasStartCache_ = true;
}
void HmcEFilter::CancelCache()
{
    int temp = 0;
    LOGI("CancelCache cache");
    SetValue(&temp, CANCEL_CACHE_CONFIG.c_str(), ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
    hasStartCache_ = false;
}
    
bool HmcEFilter::HasStartCache()
{
    return hasStartCache_;
}