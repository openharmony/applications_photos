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
#include "HmcTriangle.h"
#include <cmath>


HmcTriangle::HmcTriangle(HmcPosition a, HmcPosition b, HmcPosition c) : m_a(a), m_b(b), m_c(c) {}

HmcTriangle::~HmcTriangle() {}

DOUBLE HmcTriangle::CalcArea()
{
    // 先求边长，在求面积
    DOUBLE x = GetDistance(m_a, m_b);
    DOUBLE y = GetDistance(m_b, m_c);
    DOUBLE z = GetDistance(m_a, m_c);

    DOUBLE p = (x + y + z) / 2;

    // 海伦公式
    return sqrt((p * (p - x) * (p - y) * (p - z)));
}

DOUBLE HmcTriangle::GetDistance(HmcPosition b, HmcPosition a)
{
    return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
}
