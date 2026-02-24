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

#include <utility>
#include "HmcService.h"
#include "HmcDefaultValueManager.h"


IMPLEMENT_SINGLETON(HmcDefaultValueManager)

const float HMC_DEFAULT_VALUE_NORMAL = 1.0f;
const float HMC_DEFAULT_VALUE_HALF = 0.5f;
constexpr INT32 HMC_CHROMA_COLOR_DEFAULT_VALUE = 0X00FF00;

AssetPropertyValue HmcDefaultValueManager::GetAssetPropData()
{
    AssetPropertyValue value;
    value.speed = HMC_DEFAULT_VALUE_NORMAL;

    return value;
}

TransformPropertyValue HmcDefaultValueManager::GetTransformPropData()
{
    TransformPropertyValue value;
    value.positionX = 0.0f;
    value.positionY = 0.0f;
    value.scaleX = HMC_DEFAULT_VALUE_NORMAL;
    value.scaleY = HMC_DEFAULT_VALUE_NORMAL;
    value.opacity = HMC_DEFAULT_VALUE_NORMAL;
    value.rotation = 0.0f;
    value.mirrorHorizontal = 0;
    value.mirrorVertical = 0;

    return value;
}

AdjustPropertyValue HmcDefaultValueManager::GetAdjustPropData()
{
    AdjustPropertyValue value;
    value.hue = 0;
    value.saturation = 0;
    value.brightness = 0;
    value.contrast = 0;
    value.temperature = 0;
    value.sharpness = 0;
    value.fade = 0;
    value.exposure = 0;
    value.grain = 0;
    value.highlight = 0;
    value.shadow = 0;
    value.vignette = 0;

    return value;
}

CropPercentPropertyValue HmcDefaultValueManager::GetCropPercentPropData()
{
    CropPercentPropertyValue value;
    value.leftPercent = 0.0f;
    value.rightPercent = 0.0f;
    value.topPercent = 0.0f;
    value.bottomPercent = 0.0f;

    return value;
}

FilterPropertyValue HmcDefaultValueManager::GetFilterPropData()
{
    FilterPropertyValue value;
    value.strength = HMC_DEFAULT_VALUE_NORMAL;

    return value;
}

ChromaPropertyValue HmcDefaultValueManager::GetChromaPropData()
{
    ChromaPropertyValue value;
    value.color = HMC_CHROMA_COLOR_DEFAULT_VALUE;
    value.strength = 0.0f;
    value.minThreshold = 0.0f;
    value.shadow = 0.0f;

    return value;
}

AudioPropertyValue HmcDefaultValueManager::GetAudioPropData()
{
    AudioPropertyValue value;
    value.dbLeft = 0.0;
    value.dbRight = 0.0;
    value.fadeInDurationMs = 0;
    value.fadeOutDurationMs = 0;
    value.soundType = HMC_AUDIO_TYPE_NORMAL;

    return value;
}

PropertyValue HmcDefaultValueManager::GetAllPropData()
{
    PropertyValue value;
    value.assetValue = GetAssetPropData();
    value.transformValue = GetTransformPropData();
    value.adjustValue = GetAdjustPropData();
    value.cropValue = GetCropPercentPropData();
    value.filterValue = GetFilterPropData();
    value.chromaValue = GetChromaPropData();
    value.audioValue = GetAudioPropData();

    return value;
}
