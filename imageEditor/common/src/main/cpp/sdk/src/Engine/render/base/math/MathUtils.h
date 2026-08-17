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
#include <cmath>
#include <utility>

inline float HmcRadians(float degrees) { return degrees * 3.14159265358979323846f / 180.0f; }
inline float HmcDegrees(float radians) { return radians * 180.0f / 3.14159265358979323846f; }

template<typename T>
inline T HmcIdentity() { T m; return m; }

template<typename T>
inline T HmcTranspose(const T &m) {
    T r;
    for (int c = 0; c < 4; ++c) for (int rr = 0; rr < 4; ++rr) r[c][rr] = m[rr][c];
    return r;
}

template<>
inline Mat3x3 HmcTranspose(const Mat3x3 &m) {
    Mat3x3 r;
    for (int c = 0; c < 3; ++c) for (int rr = 0; rr < 3; ++rr) r[c][rr] = m[rr][c];
    return r;
}

template<>
inline Mat2x2 HmcTranspose(const Mat2x2 &m) {
    Mat2x2 r;
    for (int c = 0; c < 2; ++c) for (int rr = 0; rr < 2; ++rr) r[c][rr] = m[rr][c];
    return r;
}

template<typename T>
inline T HmcInverse(const T &m) { T r(1); return r; }

inline Mat4x4 HmcRotate(const Mat4x4 &m, float angle, const Vec3 &axis) {
    float c = std::cos(angle); float s = std::sin(angle);
    Vec3 a = axis;
    float len = std::sqrt(a.x*a.x+a.y*a.y+a.z*a.z);
    if (len > 0.0f) { a.x /= len; a.y /= len; a.z /= len; }
    Mat4x4 r;
    r[0]=Vec4(c+a.x*a.x*(1-c), a.x*a.y*(1-c)+a.z*s, a.x*a.z*(1-c)-a.y*s, 0);
    r[1]=Vec4(a.y*a.x*(1-c)-a.z*s, c+a.y*a.y*(1-c), a.y*a.z*(1-c)+a.x*s, 0);
    r[2]=Vec4(a.z*a.x*(1-c)+a.y*s, a.z*a.y*(1-c)-a.x*s, c+a.z*a.z*(1-c), 0);
    r[3]=Vec4(0,0,0,1);
    return m * r;
}

inline Mat4x4 HmcPerspective(float fovy, float aspect, float nearV, float farV) {
    float thf = std::tan(fovy / 2.0f);
    Mat4x4 r(0);
    r[0][0] = 1.0f/(aspect*thf); r[1][1] = 1.0f/thf;
    r[2][2] = -(farV+nearV)/(farV-nearV); r[2][3] = -(2.0f*farV*nearV)/(farV-nearV);
    r[3][2] = -1.0f;
    return r;
}

template<typename T>
inline const void *HmcValuePtr(const T &v) { return reinterpret_cast<const void *>(&v); }

class MathUtils {
public:
    constexpr const static DOUBLE PI = 3.14159265358979323846264338327f;

    template <class T> static T Radians(T degrees)
    {
        return HmcRadians(degrees);
    }

    template <class T> static T &&GetIdentity()
    {
        return std::move(HmcIdentity<T>());
    }

    template <class T> static VOID LoadIdentity(T &mat)
    {
        mat = HmcIdentity<T>();
    }

    template <class R, class TL, class TR> static VOID Multiply(R &result, const TL &left, const TR &right)
    {
        static_assert(std::is_same_v<R, decltype(std::declval<TL>() * std::declval<TR>())>,
            "MathUtils::Multiply(): Wrong R Type!");
        result = left * right;
    }

    template <class R, class T> static R Transposed(const T &in)
    {
        static_assert(std::is_same_v<R, decltype(HmcTranspose(in))>, "MathUtils::Transpose(): Wrong R Type!");
        return HmcTranspose(in);
    }

    template <class T> static VOID Inverse(T &result, const T &in)
    {
        result = HmcInverse(in);
    }

    template <class T> static T Inversed(const T &in)
    {
        return HmcInverse(in);
    }

    template <class T, class... Vs> static VOID Rotate(T &result, const T &src, FLOAT radians, const Vs &... v)
    {
        result = HmcRotate(src, radians, v...);
    }

    static Mat4x4 Perspective(FLOAT fov, FLOAT aspect, FLOAT nearV, FLOAT farV)
    {
        return HmcPerspective(fov, aspect, nearV, farV);
    }

    static Mat3x3 CalProj2D(const Mat4x4 &mvp);
    static Mat3x3 CalProj2DInv(const Mat4x4 &mvp);

    static BOOL IsPointInRect(const Vec2 &p, const Vec2 &rectP0, const Vec2 &rectP1, const Vec2 &rectP2,
        const Vec2 &rectP3);
    static BOOL IsSegmentsCross(const Vec2 &s0, const Vec2 &e0, const Vec2 &s1, const Vec2 &e1);
    static DOUBLE GetTriangleArea(const Vec2 &p0, const Vec2 &p1, const Vec2 &p2);
    static VOID GetSegmentsCrossPoints(const Vec2 &s0, const Vec2 &e0, const Vec2 &s1, const Vec2 &e1,
        VECTOR<Vec2> &result);
    static VECTOR<Vec2> GetTwoRectCrossAreaPoints(const Vec2 &a0, const Vec2 &a1, const Vec2 &a2, const Vec2 &a3,
        const Vec2 &b0, const Vec2 &b1, const Vec2 &b2, const Vec2 &b3);

    template <class T> static const VOID *NativePtr(const T &v)
    {
        return HmcValuePtr(v);
    }
    static VECTOR<FLOAT> CalVertexPos(FLOAT offsetX, FLOAT offsetY, FLOAT scaleX, FLOAT scaleY, FLOAT radioX,
                                      FLOAT radioY, FLOAT rotateX, FLOAT rotateY, FLOAT rotateZ, FLOAT textureSizeX,
                                      FLOAT textureSizeY, FLOAT viewportX, FLOAT viewportY, FLOAT refX, FLOAT refY,
                                      BOOL isHorizontalMirror);
};
#endif
