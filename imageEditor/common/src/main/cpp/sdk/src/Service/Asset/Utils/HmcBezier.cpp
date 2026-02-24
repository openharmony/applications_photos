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

#include "HmcBase.h"
#include "HmcBezier.h"

static FLOAT bezier_algorithm(FLOAT x, FLOAT begin, FLOAT ctrl1, FLOAT ctrl2, FLOAT end)
{
    constexpr FLOAT FULL = 1.0f;
    constexpr FLOAT THREE_TIMES = 3.0f;

    FLOAT x1 = FULL - x;
    FLOAT x1x1 = x1 * x1;
    FLOAT xx = x * x;
    FLOAT xs3 = (x - xx) * THREE_TIMES;
    FLOAT tmp_ = begin * x1x1 + ctrl1 * xs3;

    return tmp_ + x * (ctrl2 * xs3 + end * xx - tmp_);
}

HmcBezier::HmcBezier(const LIST<HmcBezierPoint> &pointList) : m_pointList(pointList) {}

HmcBezier::HmcBezier(const HmcBezier &val)
{
    m_pointList = val.m_pointList;
    m_fragmentList = val.m_fragmentList;
    m_originFragmentList = val.m_originFragmentList;
    m_trimIn = val.m_trimIn;
    m_trimOut = val.m_trimOut;
    m_duration = val.m_duration;
}

HmcBezier &HmcBezier::operator = (const HmcBezier &val)
{
    m_pointList = val.m_pointList;
    m_fragmentList = val.m_fragmentList;
    m_originFragmentList = val.m_originFragmentList;
    m_trimIn = val.m_trimIn;
    m_trimOut = val.m_trimOut;
    m_duration = val.m_duration;

    return *this;
}

VOID HmcBezier::Clear()
{
    m_pointList.clear();
    m_fragmentList.clear();
    m_originFragmentList.clear();
}

VOID HmcBezier::UpdatePointList(const LIST<HmcBezierPoint> &pointList)
{
    m_pointList.clear();
    m_pointList = pointList;
}

LIST<HmcBezierFragment> *HmcBezier::GetBezierFragmentList(bool isOrigin)
{
    if (isOrigin) {
        return &m_originFragmentList;
    } else {
        return &m_fragmentList;
    }
}

VOID HmcBezier::UpdateFragmentList(INT64 xSrc, INT64 xFragment, bool isOrigin)
{
    auto fragmentList = GetBezierFragmentList(isOrigin);
    fragmentList->clear();

    LIST<PAIR<HmcBezierPoint, HmcBezierPoint>> bezierPointPairList;
    for (auto it = m_pointList.begin(); it != m_pointList.end(); ++it) {
        auto next_it = std::next(it);
        if (next_it != m_pointList.end()) {
            bezierPointPairList.emplace_back(*it, *next_it);
        }
    }

    for (auto pointPair : bezierPointPairList) {
        auto frontPoint = pointPair.first;
        auto nextPoint = pointPair.second;

        if (nextPoint.m_y + frontPoint.m_y == 0 || xFragment == 0) {
            LOGE("zero error");
            continue;
        }

        auto fragmentSrc = (INT64)((FLOAT)xSrc * fabs(nextPoint.m_x - frontPoint.m_x));
        auto fragmentSpeedSrc = (INT64)((FLOAT)fragmentSrc / ((nextPoint.m_y + frontPoint.m_y) / 2));
        auto fragmentCount = (INT32)(fragmentSpeedSrc / xFragment);
        if (fragmentCount == 0) {
            LOGE("zero error");
            continue;
        }
        FLOAT fragmentXRise = fabs(nextPoint.m_x - frontPoint.m_x) / (FLOAT)fragmentCount;

        HmcBezierFragment fragment;
        fragment.m_beginX = frontPoint.m_x;
        fragment.m_endX = nextPoint.m_x;

        FLOAT y = 0.0f;
        for (INT32 i = 0; i < fragmentCount; ++i) {
            FLOAT thisX = (FLOAT)i / (FLOAT)fragmentCount;
            GetYByX(thisX, frontPoint.m_y, nextPoint.m_y, y);

            HmcBezierFragmentUnit fragmentUnit;
            fragmentUnit.m_x = frontPoint.m_x + ((FLOAT)i * fragmentXRise);
            fragmentUnit.m_yWithFragment = y * (FLOAT)xFragment;

            fragment.m_bezierUnitList.push_back(fragmentUnit);
        }
        fragmentList->push_back(fragment);
    }
}

BOOL HmcBezier::GetYByX(FLOAT x, FLOAT begin_y, FLOAT end_y, FLOAT &y)
{
    y = 0.0;

    HmcBezierPoint begin = { 0.0f, begin_y };
    HmcBezierPoint end = { 1.0f, end_y };
    HmcBezierPoint ctrl1, ctrl2;

    GetPointsByX(begin, end, ctrl1, ctrl2);
    y = bezier_algorithm(x, begin.m_y, ctrl1.m_y, ctrl2.m_y, end.m_y);

    return TRUE;
}

bool HmcBezier::GetPointsByX(const HmcBezierPoint &begin, const HmcBezierPoint &end, HmcBezierPoint &ctrl1,
    HmcBezierPoint &ctrl2)
{
    constexpr FLOAT HALF = 0.5f;

    ctrl1.m_x = (end.m_x + begin.m_x) * HALF;
    ctrl1.m_y = begin.m_y;
    ctrl2.m_x = (end.m_x + begin.m_x) * HALF;
    ctrl2.m_y = end.m_y;

    return TRUE;
}

