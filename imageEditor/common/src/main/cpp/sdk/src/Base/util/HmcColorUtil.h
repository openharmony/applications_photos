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

#ifndef SDK_WRAPPER_ETS_HMC_COLOR_UTIL_H
#define SDK_WRAPPER_ETS_HMC_COLOR_UTIL_H

#include "HmcBase.h"

/**
 * @brief 处理颜色的工具类,
 */
class HmcColorUtil {
public:
    /* *
     * @brief 将R,G,B按照RGB的顺序组装成RGB颜色
     *
     * @param red R通道，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param green G通道，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param blue B通道，取值范围：0~255，一般用0X00~0XFF来表示.
     *
     * @return RGB颜色值, 一般用0X000000~0XFFFFFF来表示.
     */
    inline static UINT32 BuildRGB(UINT32 red, UINT32 green, UINT32 blue)
    {
        return (red << 16) | (green << 8) | blue;
    }

    /* *
     * @brief 将R,G,B,A按照ARGB的顺序组装成ARGB颜色
     *
     * @param alpha A通道(透明度)，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param red R通道，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param green G通道，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param blue B通道，取值范围：0~255，一般用0X00~0XFF来表示.
     *
     * @return ARGB颜色值, 一般用0X00000000~0XFFFFFFFF来表示.
     */
    inline static UINT32 BuildARGB(UINT32 alpha, UINT32 red, UINT32 green, UINT32 blue)
    {
        return (alpha << 24) | (red << 16) | (green << 8) | blue;
    }
    /* *
     * @brief 将R,G,B,A按照RGBA的顺序组装成RGBA颜色
     *
     * @param alpha A通道(透明度)，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param red R通道，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param green G通道，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param blue B通道，取值范围：0~255，一般用0X00~0XFF来表示.
     *
     * @return RGBA颜色值, 一般用0X00000000~0XFFFFFFFF来表示.
     */
    inline static UINT32 BuildRGBA(UINT32 alpha, UINT32 red, UINT32 green, UINT32 blue)
    {
        return (red << 24) | (green << 16) | (blue << 8) | alpha;
    }
    /* *
     * @brief BuildRGB的逆向操作，将RGB颜色反向解析成R,G,B三个通道的值
     *
     * @param input  RGBColor RGB颜色值, 一般用0X000000~0XFFFFFF来表示.
     * @param output red R通道，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param output green G通道，取值范围：0~255，一般用0X00~0XFF来表示.
     * @param output blue B通道，取值范围：0~255，一般用0X00~0XFF来表示.
     */
    inline static VOID ParseRGB(UINT32 RGBColor, UINT32 &red, UINT32 &green, UINT32 &blue)
    {
        red = (RGBColor & 0xFF0000) >> 16;
        green = (RGBColor & 0xFF00) >> 8;
        blue = RGBColor & 0xFF;
    }
    /* *
     * @brief 将0~1之间的alpha值线性映射到0~255[0X00~0XFF]之间
     *
     * @param input  alpha 0~1直接的alpha值.
     *
     * @return 0~255[0X00~0XFF]之间的alpha值
     */
    inline static UINT32 PercentToNumForAlpha(FLOAT alpha)
    {
        return (UINT32)(0xFF * alpha);
    }
    /* *
     * @brief PercentToNumForAlpha的反向操作，将0~255[0X00~0XFF]之间的alpha值线性映射到0~1.
     *
     * @param input  0~255[0X00~0XFF]之间的alpha值.
     *
     * @return alpha 0~1直接的alpha值.
     */
    inline static FLOAT NumToPercentForColor(UINT32 color)
    {
        return static_cast<FLOAT>(color & 0xFF) / 255.0f;
    }
};


#endif // SDK_WRAPPER_ETS_HMC_COLOR_UTIL_H
