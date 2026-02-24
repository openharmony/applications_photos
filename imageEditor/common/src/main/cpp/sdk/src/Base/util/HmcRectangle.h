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

#ifndef HMCRECTANGLE_H
#define HMCRECTANGLE_H

#include "util/HmcTriangle.h"
#ifdef __cplusplus
extern "C" {
#endif

typedef struct HmcRectanglePosition {
    HmcPosition center;
    HmcPosition leftTop;
    HmcPosition leftBottom;
    HmcPosition rightTop;
    HmcPosition rightBottom;
} HmcRectanglePosition;

class HmcRectangle {
public:
    HmcRectangle(HmcPosition center, FLOAT width, FLOAT height, FLOAT rotation);
    ~HmcRectangle() = default;

    VOID Reset(HmcPosition center, FLOAT width, FLOAT height, FLOAT rotation);

    DOUBLE CalcArea();

    /* 判断坐标点是否在矩形内 */
    BOOL IsMatchRect(HmcPosition point);

    HmcRectanglePosition GetRectanglePosition() const;

private:
    // 通过中心点、宽、高计算矩形的顶点坐标
    VOID SetApex();

    VOID Rotate(HmcPosition &point) const;

private:
    HmcPosition m_leftBottom;
    HmcPosition m_leftTop;
    HmcPosition m_rightBottom;
    HmcPosition m_rightTop;

    HmcPosition m_center; // 矩形中心点

    FLOAT m_rotation;
    FLOAT m_width;
    FLOAT m_height;
};
#ifdef __cplusplus
}
#endif

#endif // HMCRECTANGLE_H
