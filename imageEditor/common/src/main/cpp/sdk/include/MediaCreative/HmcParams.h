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

#ifndef NEWPHOTOS_HMC_XTSTYLE_PARAMS_H
#define NEWPHOTOS_HMC_XTSTYLE_PARAMS_H

#include "HmcBaseType.h"

constexpr DOUBLE G_EPSILON = 1e-6;

enum class EditEffectMode {
    NONE = 0,        // 基础效果
    APERTURE,        // 大光圈
    SNAP,            // 抓拍
    PAN,             // 摇拍
    APERTURE_SNAP,   // 大光圈和抓拍组合
    MAX_SIZE         // 最大数目，用于参数合理判断
};

// 大光圈参数 begin
struct Point {
    INT32 x;
    INT32 y;
};

typedef enum WideApertureRenderType {
    RENDER_BY_SAMPLE = 1,
    RENDER_BY_SOURCE = 2,
} WideApertureRenderType;

typedef enum BlurType {
    BLUR_TYPE_NORMAL = 0, // 普通虚化模式
    BLUR_TYPE_GAUSS = 1, // 高斯虚化模式
    BLUR_TYPE_CIRCLE = 2, // 圆形光斑
    BLUR_TYPE_PENTAGRAM = 3, // 五角星光斑虚化
    BLUR_TYPE_HEXAGON = 4, // 六边形光斑虚化
    BLUR_TYPE_HEART = 5, // 心形光斑虚化
    BLUR_TYPE_BUTTERFLY = 6, // 蝴蝶形光斑虚化
    BLUR_TYPE_SWIRL = 7, // 旋涡光斑虚化
    BLUR_TYPE_LEICA = 8,
    BLUR_TYPE_LARGE = 9, // 大散景光斑
    BLUR_TYPE_TINFOIL = 10, // 锡箔纸光斑
    BLUR_TYPE_DIAMONDS = 11,
    BLUR_TYPE_4_POINTSTARTS = 12,
    BLUR_TYPE_MONUTS = 13,
    BLUR_TYPE_MUSIC_NOTES = 14,
    BLUR_TYPE_DISCS = 15 // 鱼鳞光斑
} BlurType;

constexpr const char *WIDE_APERTURE_TYPE_KEY = "FILTER_WIDEAPERTURE_TYPE";
constexpr const char *WIDE_APERTURE_BLUR_TYPE_KEY = "FILTER_WIDEAPERTURE_BLURTYPE";
constexpr const char *WIDE_APERTURE_F_NUM_KEY = "FILTER_WIDEAPERTURE_FNUM";
constexpr const char *WIDE_APERTURE_POINT_KEY = "FILTER_POINT";
constexpr const char *WIDE_APERTURE_IS_ULTRA_PHOTO = "FILTER_ISULTRAPHOTO";
constexpr const char *WIDE_APERTURE_FILTER_NAME = "Wide_Aperture";
// 大光圈参数 end

// 个性风格参数 begin
struct XTStyleParams {
    int32_t styleType;                // 个性风格种类
    int32_t colorTemperature;         // 色温
    int32_t saturation;               // 饱和度
    int32_t lightShadow;              // 光影
    int32_t templateIndex;            // 模板index
    int32_t createMode;               // 创建模式。有色温、饱和度、光影、种类的参数，传0，大光圈+XXX传1
    XTStyleParams() : styleType(-1), colorTemperature(0), saturation(0), lightShadow(0), templateIndex(-1),
        createMode(0) {}

    XTStyleParams(int32_t styleType, int32_t colorTemperature, int32_t saturation, int32_t lightShadow,
        int32_t templateIndex, int32_t createMode)
        : styleType(styleType),
          colorTemperature(colorTemperature),
          saturation(saturation),
          lightShadow(lightShadow),
          templateIndex(templateIndex),
          createMode(createMode)
    {}

    XTStyleParams& operator=(const XTStyleParams &other)
    {
        if (this != &other) {
            styleType = other.styleType;
            colorTemperature = other.colorTemperature;
            saturation = other.saturation;
            lightShadow = other.lightShadow;
            templateIndex = other.templateIndex;
            createMode = other.createMode;
        }
        return *this;
    }

    XTStyleParams(const XTStyleParams &other)
    {
        styleType = other.styleType;
        colorTemperature = other.colorTemperature;
        saturation = other.saturation;
        lightShadow = other.lightShadow;
        templateIndex = other.templateIndex;
        createMode = other.createMode;
    }
    
    bool operator==(const XTStyleParams &other) const
    {
        return styleType == other.styleType && colorTemperature == other.colorTemperature &&
            saturation == other.saturation && lightShadow == other.lightShadow &&
            templateIndex == other.templateIndex;
    }

    STRING toString() const
    {
        return "[" + std::to_string(styleType) + "," + std::to_string(colorTemperature) + "," +
            std::to_string(saturation) + "," + std::to_string(lightShadow) + "," + std::to_string(templateIndex) + "," +
            std::to_string(createMode) + "]";
    }
};

constexpr INT32 XTSTYLE_MIN_COLOR_TEMPERATURE_VALUE = 0;
constexpr INT32 XTSTYLE_MAX_COLOR_TEMPERATURE_VALUE = 20;
constexpr INT32 XTSTYLE_MIN_SATURATION_VALUE = 0;
constexpr INT32 XTSTYLE_MAX_SATURATION_VALUE = 10;
constexpr INT32 XTSTYLE_MIN_LIGHT_SHADOW_VALUE = 0;
constexpr INT32 XTSTYLE_MAX_LIGHT_SHADOW_VALUE = 10;

constexpr INT32 XT_STYLE_TYPE_INDEX = 0;
constexpr INT32 XT_STYLE_COLOR_TEMPER_INDEX = 1;
constexpr INT32 XT_STYLE_SATURATION_INDEX = 2;
constexpr INT32 XT_STYLE_LIGHT_SHADOW_INDEX = 3;
constexpr INT32 XT_STYLE_CREATE_MODE_INDEX = 4;

constexpr int EXIF_LIGHT_SHADOW_INDEX = 1;
constexpr int EXIF_SATURATION_INDEX = 2;
constexpr int EXIF_COLOR_TEMPERATURE_INDEX = 3;

constexpr const char *XTSTYLE_FILTER_NAME = "XtStyle";
// 个性风格参数 end

// 一拍多得参数 begin
struct SportParams {
    INT32 sportType;                // 一拍多得种类, 0(close)、1(snapshot)、2(panning)
    DOUBLE value;                   // 强度值
    
    SportParams() : sportType(0), value(0.0) {}
    SportParams(INT32 type, DOUBLE value) : sportType(type), value(value) {}
    
    SportParams& operator=(const SportParams &other)
    {
        if (this != &other) {
            this->sportType = other.sportType;
            this->value = other.value;
        }
        return *this;
    }
    
    SportParams(const SportParams &other)
    {
        this->sportType = other.sportType;
        this->value = other.value;
    }
    
    bool operator==(const SportParams &other) const
    {
        return (this->sportType == other.sportType) && (fabs(this->value - other.value) < G_EPSILON);
    }
    
    STRING toString() const
    {
        return "[" + std::to_string(this->sportType) + ", " + std::to_string(this->value) + "]";
    }
};

using SportFunc = std::function<void(bool res)>;

constexpr const char *SPORT_FILTER_NAME = "Sport";
constexpr const char *ULTRA_ALGO_NAME = "UltraphotoImage";
constexpr const char *SPORT_CLOSE = "sport_close";
constexpr const char *SPORT_SNAP = "sport_snap";
constexpr const char *SPORT_PAN = "sport_pan";

enum class SportTag {
    SPORT_TAG_CLOSE,
    SPORT_TAG_SNAP,
    SPORT_TAG_PAN
};
// 一拍多得参数 end

#endif // NEWPHOTOS_HMC_XTSTYLE_PARAMS_H
