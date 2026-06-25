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
#ifndef OH_HMC_RECTD_H
#define OH_HMC_RECTD_H
#include <cmath>
class HmcRectD {
public:
    double left;
    double top;
    double right;
    double bottom;

    HmcRectD()
    {
        left = 0.0;
        top = 0.0;
        right = 0.0;
        bottom = 0.0;
    }

    HmcRectD(double l, double t, double r, double b) : left(l), top(t), right(r), bottom(b) {}

    double Width() const
    {
        return right - left;
    }

    double Height() const
    {
        return bottom - top;
    }

    double CenterX() const
    {
        return left + Width() / 2;
    }

    double CenterY() const
    {
        return top + Height() / 2;
    }

    HmcRectD *Scale(double ratio, double originPointX, double originPointY)
    {
        left = originPointX + (left - originPointX) * ratio;
        top = originPointY + (top - originPointY) * ratio;
        right = originPointX + (right - originPointX) * ratio;
        bottom = originPointY + (bottom - originPointY) * ratio;
        return this;
    }

    HmcRectD *Translate(double offsetX, double offsetY)
    {
        left = left + offsetX;
        top = top + offsetY;
        right = right + offsetX;
        bottom = bottom + offsetY;
        return this;
    }

    bool IsSameRect(const HmcRectD &cropRect) const
    {
        if (fabs(left - cropRect.left) > 0.01 || fabs(top - cropRect.top) > 0.01 ||
            fabs(right - cropRect.right) > 0.01 || fabs(bottom - cropRect.bottom) > 0.01) {
            return false;
        }
        return true;
    }
};
#endif
