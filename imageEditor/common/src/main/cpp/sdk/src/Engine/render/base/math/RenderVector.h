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

#ifndef RENDERVECTOR_H
#define RENDERVECTOR_H

#include <type_traits>

struct Vec2 {
    float x, y;
    Vec2() : x(0), y(0) {}
    Vec2(float x, float y) : x(x), y(y) {}
    Vec2(float v) : x(v), y(v) {}
    template<typename A, typename B, typename = std::enable_if_t<std::is_arithmetic_v<A> && std::is_arithmetic_v<B>>>
    Vec2(A x, B y) : x(static_cast<float>(x)), y(static_cast<float>(y)) {}
    template<typename A, typename = std::enable_if_t<std::is_arithmetic_v<A>>>
    Vec2(A v) : x(static_cast<float>(v)), y(static_cast<float>(v)) {}
    Vec2 operator-() const { return Vec2(-x, -y); }
    Vec2 operator+(const Vec2 &v) const { return Vec2(x + v.x, y + v.y); }
    Vec2 operator-(const Vec2 &v) const { return Vec2(x - v.x, y - v.y); }
    Vec2 operator*(const Vec2 &v) const { return Vec2(x * v.x, y * v.y); }
    Vec2 operator/(const Vec2 &v) const { return Vec2(x / v.x, y / v.y); }
    Vec2 operator*(float s) const { return Vec2(x * s, y * s); }
    Vec2 operator/(float s) const { return Vec2(x / s, y / s); }
    Vec2 &operator+=(const Vec2 &v) { x += v.x; y += v.y; return *this; }
    Vec2 &operator-=(const Vec2 &v) { x -= v.x; y -= v.y; return *this; }
    Vec2 &operator*=(float s) { x *= s; y *= s; return *this; }
    Vec2 &operator/=(float s) { x /= s; y /= s; return *this; }
    bool operator<=(const Vec2 &v) const { return x <= v.x && y <= v.y; }
    bool operator<(const Vec2 &v) const { return x < v.x && y < v.y; }
    bool operator>=(const Vec2 &v) const { return x >= v.x && y >= v.y; }
    bool operator>(const Vec2 &v) const { return x > v.x && y > v.y; }
    bool operator==(const Vec2 &v) const { return x == v.x && y == v.y; }
    bool operator!=(const Vec2 &v) const { return x != v.x || y != v.y; }
    float &operator[](int i) { return (&x)[i]; }
    const float &operator[](int i) const { return (&x)[i]; }
};

struct Vec3 {
    float x, y, z;
    Vec3() : x(0), y(0), z(0) {}
    Vec3(float x, float y, float z) : x(x), y(y), z(z) {}
    Vec3(float v) : x(v), y(v), z(v) {}
    template<typename A, typename B, typename C, typename = std::enable_if_t<std::is_arithmetic_v<A> && std::is_arithmetic_v<B> && std::is_arithmetic_v<C>>>
    Vec3(A x, B y, C z) : x(static_cast<float>(x)), y(static_cast<float>(y)), z(static_cast<float>(z)) {}
    template<typename A, typename = std::enable_if_t<std::is_arithmetic_v<A>>>
    Vec3(A v) : x(static_cast<float>(v)), y(static_cast<float>(v)), z(static_cast<float>(v)) {}
    Vec3(const Vec2 &v, float z) : x(v.x), y(v.y), z(z) {}
    Vec3 operator-() const { return Vec3(-x, -y, -z); }
    Vec3 operator+(const Vec3 &v) const { return Vec3(x + v.x, y + v.y, z + v.z); }
    Vec3 operator-(const Vec3 &v) const { return Vec3(x - v.x, y - v.y, z - v.z); }
    Vec3 operator*(const Vec3 &v) const { return Vec3(x * v.x, y * v.y, z * v.z); }
    Vec3 operator/(const Vec3 &v) const { return Vec3(x / v.x, y / v.y, z / v.z); }
    Vec3 operator*(float s) const { return Vec3(x * s, y * s, z * s); }
    Vec3 operator/(float s) const { return Vec3(x / s, y / s, z / s); }
    Vec3 &operator+=(const Vec3 &v) { x += v.x; y += v.y; z += v.z; return *this; }
    Vec3 &operator-=(const Vec3 &v) { x -= v.x; y -= v.y; z -= v.z; return *this; }
    bool operator==(const Vec3 &v) const { return x == v.x && y == v.y && z == v.z; }
    bool operator!=(const Vec3 &v) const { return x != v.x || y != v.y || z != v.z; }
    float &operator[](int i) { return (&x)[i]; }
    const float &operator[](int i) const { return (&x)[i]; }
};

struct Vec4 {
    float x, y, z, w;
    Vec4() : x(0), y(0), z(0), w(1) {}
    Vec4(float x, float y, float z, float w) : x(x), y(y), z(z), w(w) {}
    Vec4(float v) : x(v), y(v), z(v), w(v) {}
    template<typename A, typename B, typename C, typename D, typename = std::enable_if_t<std::is_arithmetic_v<A> && std::is_arithmetic_v<B> && std::is_arithmetic_v<C> && std::is_arithmetic_v<D>>>
    Vec4(A x, B y, C z, D w) : x(static_cast<float>(x)), y(static_cast<float>(y)), z(static_cast<float>(z)), w(static_cast<float>(w)) {}
    template<typename A, typename = std::enable_if_t<std::is_arithmetic_v<A>>>
    Vec4(A v) : x(static_cast<float>(v)), y(static_cast<float>(v)), z(static_cast<float>(v)), w(static_cast<float>(v)) {}
    Vec4 operator-() const { return Vec4(-x, -y, -z, -w); }
    Vec4 operator+(const Vec4 &v) const { return Vec4(x + v.x, y + v.y, z + v.z, w + v.w); }
    Vec4 operator-(const Vec4 &v) const { return Vec4(x - v.x, y - v.y, z - v.z, w - v.w); }
    Vec4 operator*(const Vec4 &v) const { return Vec4(x * v.x, y * v.y, z * v.z, w * v.w); }
    Vec4 operator/(const Vec4 &v) const { return Vec4(x / v.x, y / v.y, z / v.z, w / v.w); }
    Vec4 operator*(float s) const { return Vec4(x * s, y * s, z * s, w * s); }
    Vec4 operator/(float s) const { return Vec4(x / s, y / s, z / s, w / s); }
    Vec4 &operator+=(const Vec4 &v) { x += v.x; y += v.y; z += v.z; w += v.w; return *this; }
    bool operator==(const Vec4 &v) const { return x == v.x && y == v.y && z == v.z && w == v.w; }
    bool operator!=(const Vec4 &v) const { return x != v.x || y != v.y || z != v.z || w != v.w; }
    float &operator[](int i) { return (&x)[i]; }
    const float &operator[](int i) const { return (&x)[i]; }
};

using ivec2 = Vec2;
using ivec3 = Vec3;
using ivec4 = Vec4;

#endif // RENDERVECTOR_H
