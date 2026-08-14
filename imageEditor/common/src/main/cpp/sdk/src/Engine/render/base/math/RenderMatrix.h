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

#ifndef RENDERMATRIX_H
#define RENDERMATRIX_H

#include "RenderVector.h"

struct Mat2x2 {
    Vec2 columns[2];
    Mat2x2() { columns[0] = Vec2(1, 0); columns[1] = Vec2(0, 1); }
    Mat2x2(float v) { columns[0] = Vec2(v, 0); columns[1] = Vec2(0, v); }
    Mat2x2(float x0, float y0, float x1, float y1) { columns[0] = Vec2(x0, y0); columns[1] = Vec2(x1, y1); }
    Mat2x2(const Vec2 &c0, const Vec2 &c1) { columns[0] = c0; columns[1] = c1; }
    Vec2 &operator[](int i) { return columns[i]; }
    const Vec2 &operator[](int i) const { return columns[i]; }
    Mat2x2 operator*(const Mat2x2 &m) const {
        Mat2x2 r;
        for (int c = 0; c < 2; ++c) for (int rr = 0; rr < 2; ++rr)
            r[c][rr] = columns[0][rr] * m[c][0] + columns[1][rr] * m[c][1];
        return r;
    }
    Vec2 operator*(const Vec2 &v) const {
        return Vec2(columns[0][0]*v.x+columns[1][0]*v.y, columns[0][1]*v.x+columns[1][1]*v.y);
    }
};

struct Mat3x3 {
    Vec3 columns[3];
    Mat3x3() { columns[0]=Vec3(1,0,0); columns[1]=Vec3(0,1,0); columns[2]=Vec3(0,0,1); }
    Mat3x3(float v) { columns[0]=Vec3(v,0,0); columns[1]=Vec3(0,v,0); columns[2]=Vec3(0,0,v); }
    Mat3x3(const Vec3 &c0, const Vec3 &c1, const Vec3 &c2) { columns[0]=c0; columns[1]=c1; columns[2]=c2; }
    Mat3x3(float x0,float y0,float z0,float x1,float y1,float z1,float x2,float y2,float z2) {
        columns[0]=Vec3(x0,y0,z0); columns[1]=Vec3(x1,y1,z1); columns[2]=Vec3(x2,y2,z2);
    }
    Vec3 &operator[](int i) { return columns[i]; }
    const Vec3 &operator[](int i) const { return columns[i]; }
    Mat3x3 operator*(const Mat3x3 &m) const {
        Mat3x3 r;
        for (int c = 0; c < 3; ++c) for (int rr = 0; rr < 3; ++rr)
            r[c][rr] = columns[0][rr]*m[c][0]+columns[1][rr]*m[c][1]+columns[2][rr]*m[c][2];
        return r;
    }
    Vec3 operator*(const Vec3 &v) const {
        return Vec3(
            columns[0][0]*v.x+columns[1][0]*v.y+columns[2][0]*v.z,
            columns[0][1]*v.x+columns[1][1]*v.y+columns[2][1]*v.z,
            columns[0][2]*v.x+columns[1][2]*v.y+columns[2][2]*v.z);
    }
};

struct Mat4x4 {
    Vec4 columns[4];
    Mat4x4() { columns[0]=Vec4(1,0,0,0); columns[1]=Vec4(0,1,0,0); columns[2]=Vec4(0,0,1,0); columns[3]=Vec4(0,0,0,1); }
    Mat4x4(float v) { columns[0]=Vec4(v,0,0,0); columns[1]=Vec4(0,v,0,0); columns[2]=Vec4(0,0,v,0); columns[3]=Vec4(0,0,0,v); }
    Vec4 &operator[](int i) { return columns[i]; }
    const Vec4 &operator[](int i) const { return columns[i]; }
    Mat4x4 operator*(const Mat4x4 &m) const {
        Mat4x4 r;
        for (int c = 0; c < 4; ++c) for (int rr = 0; rr < 4; ++rr)
            r[c][rr] = columns[0][rr]*m[c][0]+columns[1][rr]*m[c][1]+columns[2][rr]*m[c][2]+columns[3][rr]*m[c][3];
        return r;
    }
    Vec4 operator*(const Vec4 &v) const {
        return Vec4(
            columns[0][0]*v.x+columns[1][0]*v.y+columns[2][0]*v.z+columns[3][0]*v.w,
            columns[0][1]*v.x+columns[1][1]*v.y+columns[2][1]*v.z+columns[3][1]*v.w,
            columns[0][2]*v.x+columns[1][2]*v.y+columns[2][2]*v.z+columns[3][2]*v.w,
            columns[0][3]*v.x+columns[1][3]*v.y+columns[2][3]*v.z+columns[3][3]*v.w);
    }
};

using mat2x2 = Mat2x2;
using mat3x3 = Mat3x3;
using mat4x4 = Mat4x4;

#endif // RENDERMATRIX_H
