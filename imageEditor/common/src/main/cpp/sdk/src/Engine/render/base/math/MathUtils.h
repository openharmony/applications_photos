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

#ifndef GLESMATH_H
#define GLESMATH_H

#include "render/base/RenderBase.h"
#include "RenderVector.h"
#include "RenderMatrix.h"
#include <glm/trigonometric.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <utility>

class MathUtils {
public:
    constexpr const static DOUBLE PI = 3.14159265358979323846264338327f;

    template <class T> static T Radians(T degrees)
    {
        return glm::radians(degrees);
    }

    template <class T> static T &&GetIdentity()
    {
        return glm::identity<T>();
    }

    template <class T> static VOID LoadIdentity(T &mat)
    {
        mat = glm::identity<T>();
    }

    template <class R, class TL, class TR> static VOID Multiply(R &result, const TL &left, const TR &right)
    {
        static_assert(std::is_same_v<R, decltype(std::declval<TL>() * std::declval<TR>())>,
            "MathUtils::Multiply(): Wrong R Type!");
        result = left * right;
    }

    template <class R, class T> static R Transposed(const T &in)
    {
        static_assert(std::is_same_v<R, decltype(glm::transpose(in))>, "MathUtils::Transpose(): Wrong R Type!");
        return glm::transpose(in);
    }

    template <class T> static VOID Inverse(T &result, const T &in)
    {
        result = glm::inverse(in);
    }

    template <class T> static T Inversed(const T &in)
    {
        return glm::inverse(in);
    }

    template <class T, class... Vs> static VOID Rotate(T &result, const T &src, FLOAT radians, const Vs &... v)
    {
        result = glm::rotate(src, radians, v...);
    }

    static Mat4x4 Perspective(FLOAT fov, FLOAT aspect, FLOAT nearV, FLOAT farV)
    {
        return glm::perspective(fov, aspect, nearV, farV);
    }

    static Mat3x3 CalProj2D(const Mat4x4 &mvp);
    static Mat3x3 CalProj2DInv(const Mat4x4 &mvp);

    // rect的顶点需要按照逆时针顺序输入
    static BOOL IsPointInRect(const Vec2 &p, const Vec2 &rectP0, const Vec2 &rectP1, const Vec2 &rectP2,
        const Vec2 &rectP3);
    static BOOL IsSegmentsCross(const Vec2 &s0, const Vec2 &e0, const Vec2 &s1, const Vec2 &e1);
    static DOUBLE GetTriangleArea(const Vec2 &p0, const Vec2 &p1, const Vec2 &p2);
    // 如果两个线段共线且重合，会返回重合部分的两个端点
    static VOID GetSegmentsCrossPoints(const Vec2 &s0, const Vec2 &e0, const Vec2 &s1, const Vec2 &e1,
        VECTOR<Vec2> &result);
    // 获取两个矩形相交区域的所有顶点， 每个rect的顶点需要按照逆时针顺序输入, 结果中可能存在重复元素
    static VECTOR<Vec2> GetTwoRectCrossAreaPoints(const Vec2 &a0, const Vec2 &a1, const Vec2 &a2, const Vec2 &a3,
        const Vec2 &b0, const Vec2 &b1, const Vec2 &b2, const Vec2 &b3);

    template <class T> static const VOID *NativePtr(const T &v)
    {
        return reinterpret_cast<const VOID *>(glm::value_ptr(v));
    }
    static VECTOR<FLOAT> CalVertexPos(FLOAT offsetX, FLOAT offsetY, FLOAT scaleX, FLOAT scaleY, FLOAT radioX,
                                      FLOAT radioY, FLOAT rotateX, FLOAT rotateY, FLOAT rotateZ, FLOAT textureSizeX,
                                      FLOAT textureSizeY, FLOAT viewportX, FLOAT viewportY, FLOAT refX, FLOAT refY,
                                      BOOL isHorizontalMirror);
};
#endif
