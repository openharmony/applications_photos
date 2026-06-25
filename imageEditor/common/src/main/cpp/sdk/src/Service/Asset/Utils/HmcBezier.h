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
#ifndef HMCBEZIER_H
#define HMCBEZIER_H

#include "HmcBase.h"

using HmcBezierPoint = struct HmcBezierPoint {
    HmcBezierPoint(FLOAT x, FLOAT y) : m_x(x), m_y(y) {}
    HmcBezierPoint() {}
    FLOAT m_x = 0.0;
    FLOAT m_y = 0.0;
};

using HmcBezierFragmentUnit = struct HmcBezierFragmentUnit {
    FLOAT m_x;

    FLOAT m_yWithFragment;
};

using HmcBezierFragment = struct HmcBezierFragment {
    FLOAT m_beginX;
    FLOAT m_endX;

    LIST<HmcBezierFragmentUnit> m_bezierUnitList;
};

// 三阶贝塞尔曲线_要求List按m_x从小到大排序
class HmcBezier {
public:
    explicit HmcBezier(const LIST<HmcBezierPoint> &pointList);
    HmcBezier(const HmcBezier &val);
    HmcBezier &operator = (const HmcBezier &val);
    virtual ~HmcBezier() = default;

public:
    inline LIST<HmcBezierPoint> GetPointList()
    {
        return m_pointList;
    }

public:
    VOID Clear();
    VOID UpdatePointList(const LIST<HmcBezierPoint> &pointList);
    VOID UpdateFragmentList(INT64 xSrc, INT64 xFragment, bool isOrigin);

    static BOOL GetYByX(FLOAT x, FLOAT begin_y, FLOAT end_y, FLOAT &y);

private:
    static bool GetPointsByX(const HmcBezierPoint &begin, const HmcBezierPoint &end, HmcBezierPoint &ctrl1,
        HmcBezierPoint &ctrl2);
    LIST<HmcBezierFragment> *GetBezierFragmentList(bool isOrigin);

private:
    LIST<HmcBezierPoint> m_pointList;
    LIST<HmcBezierFragment> m_fragmentList;
    LIST<HmcBezierFragment> m_originFragmentList;
    INT64 m_trimIn = 0;
    INT64 m_trimOut = 0;
    INT64 m_duration = 0;
};

#endif // HMCBEZIER_H
