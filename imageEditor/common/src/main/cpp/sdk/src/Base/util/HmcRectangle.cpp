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

namespace {
const float HMC_MATH_PI = static_cast<float>(3.1415926);
}

HmcRectangle::HmcRectangle(HmcPosition center, FLOAT width, FLOAT height, FLOAT rotation)
    : m_center(center), m_rotation(rotation), m_width(width), m_height(height)
{
    SetApex();
}

VOID HmcRectangle::Reset(HmcPosition center, FLOAT width, FLOAT height, FLOAT rotation)
{
    this->m_center = center;
    this->m_width = width;
    this->m_height = height;

    this->m_rotation = rotation;

    SetApex();
}

DOUBLE HmcRectangle::CalcArea()
{
    HmcTriangle triangle1(m_leftTop, m_leftBottom, m_rightTop);
    HmcTriangle triangle2(m_leftBottom, m_rightTop, m_rightBottom);

    return (triangle1.CalcArea() + triangle2.CalcArea());
}

/* 判断坐标点是否在矩形内 */
BOOL HmcRectangle::IsMatchRect(HmcPosition point)
{
    // 计算该点和矩形4个顶点连接组成的4个三角形面积
    HmcTriangle triangle1(point, m_leftTop, m_leftBottom);
    HmcTriangle triangle2(point, m_leftTop, m_rightTop);
    HmcTriangle triangle3(point, m_rightTop, m_rightBottom);
    HmcTriangle triangle4(point, m_leftBottom, m_rightBottom);

    DOUBLE sumArea = triangle1.CalcArea() + triangle2.CalcArea() + triangle3.CalcArea() + triangle4.CalcArea();
    DOUBLE rectArea = CalcArea();

    BOOL result = abs(rectArea - sumArea) < rectArea / 1000;

    return result;
}

VOID HmcRectangle::SetApex()
{
    float left = m_center.x - m_width / 2;
    float right = m_center.x + m_width / 2;
    float bottom = m_center.y - m_height / 2;
    float top = m_center.y + m_height / 2;

    m_leftTop.x = left;
    m_leftTop.y = top;

    m_leftBottom.x = left;
    m_leftBottom.y = bottom;

    m_rightTop.x = right;
    m_rightTop.y = top;

    m_rightBottom.x = right;
    m_rightBottom.y = bottom;
    Rotate(m_leftTop);
    Rotate(m_leftBottom);
    Rotate(m_rightTop);
    Rotate(m_rightBottom);
}

VOID HmcRectangle::Rotate(HmcPosition &point) const
{
    float dot = m_rotation * HMC_MATH_PI / 180;

    float x = (point.x - m_center.x) * cos(dot) - (point.y - m_center.y) * sin(dot) + m_center.x;
    float y = (point.y - m_center.y) * cos(dot) + (point.x - m_center.x) * sin(dot) + m_center.y;
    point.x = x;
    point.y = y;
}

HmcRectanglePosition HmcRectangle::GetRectanglePosition() const
{
    HmcRectanglePosition position = { m_center, m_leftTop, m_leftBottom, m_rightTop, m_rightBottom };

    return position;
}
