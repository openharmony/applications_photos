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
//
// HmcDefaultValue.h
//

#ifndef HMC_DEFAULT_VALUE_H
#define HMC_DEFAULT_VALUE_H

typedef struct AssetPropertyValue {
    float speed;
} AssetPropertyValue;

typedef struct TransformPropertyValue {
    float positionX;
    float positionY;
    float scaleX;
    float scaleY;
    float opacity;
    float rotation;
    int mirrorVertical;
    int mirrorHorizontal;
} TransformPropertyValue;

/* 颜色调节 */
typedef struct AdjustPropertyValue {
    int hue;
    int saturation;
    int brightness;
    int contrast;
    int temperature;
    int sharpness;
    int fade;
    int exposure;
    int grain;
    int highlight;
    int shadow;
    int vignette;
    int vibrance;
    int brightzone;
    int darkzone;
} AdjustPropertyValue;

/* 裁剪比例 */
typedef struct CropPercentPropertyValue {
    float leftPercent;
    float rightPercent;
    float topPercent;
    float bottomPercent;
} CropPercentPropertyValue;

/* 蒙版 */
typedef struct MaskPropertyValue {
    int maskType;
    float centerX;
    float centerY;
    float rotation;
    float radius;
    float diff;
    float invert;
    float scaleX;
    float scaleY;
    float sizePercent;
} MaskPropertyValue;

/* 滤镜 */
typedef struct FilterPropertyValue {
    float strength;
} FilterPropertyValue;

/* 色度抠图 */
typedef struct ChromaPropertyValue {
    int color;
    float strength;
    float minThreshold;
    float shadow;
} ChromaPropertyValue;

/* 音频相关 */
typedef struct AudioPropertyValue {
    double dbLeft;
    double dbRight;
    unsigned int fadeInDurationMs;  // 渐入持续时间
    unsigned int fadeOutDurationMs; // 渐出持续时间
    HmcAudioSoundType soundType;    // 变音类型
} AudioPropertyValue;

typedef struct PropertyValue {
    AssetPropertyValue assetValue;
    TransformPropertyValue transformValue;
    AdjustPropertyValue adjustValue;
    CropPercentPropertyValue cropValue;
    MaskPropertyValue maskValue;
    FilterPropertyValue filterValue;
    ChromaPropertyValue chromaValue;
    AudioPropertyValue audioValue;
} PropertyValue;

/**
 * 获取全属性默认值
 * @return                    出参：返回PropertyValue对象
 */
HMC_API PropertyValue HmcDefaultValueGetAllData();

#endif /* HMC_DEFAULT_VALUE_H */
