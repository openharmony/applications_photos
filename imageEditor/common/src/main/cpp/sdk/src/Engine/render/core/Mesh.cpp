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

#include "HmcEngine.h"

template <> struct Mesh::AttribType::AttribTypeDescriptor<float> {
    static constexpr Value elementType = FLOAT_VALUE;
};
template <> struct Mesh::AttribType::AttribTypeDescriptor<Vec2> {
    static constexpr Value elementType = VEC2_VALUE;
};
template <> struct Mesh::AttribType::AttribTypeDescriptor<Vec3> {
    static constexpr Value elementType = VEC3_VALUE;
};
template <> struct Mesh::AttribType::AttribTypeDescriptor<Vec4> {
    static constexpr Value elementType = VEC4_VALUE;
};

template <> void Mesh::Set(std::string key, int index, float value)
{
    attribArrays_.at(key).GetData()[index] = value;
}

template <> void Mesh::Set(std::string key, int index, Vec2 value)
{
    auto &data = attribArrays_.at(key).GetData();
    index *= VEC2_SIZE;
    data[index] = value.x;
    data[index + VEC_OFFSET_Y] = value.y;
}

template <> void Mesh::Set(std::string key, int index, Vec3 value)
{
    auto &data = attribArrays_.at(key).GetData();
    index *= VEC3_SIZE;
    data[index] = value.x;
    data[index + VEC_OFFSET_Y] = value.y;
    data[index + VEC_OFFSET_Z] = value.z;
}

template <> void Mesh::Set(std::string key, int index, Vec4 value)
{
    auto &data = attribArrays_.at(key).GetData();
    index *= VEC4_SIZE;
    data[index] = value.x;
    data[index + VEC_OFFSET_Y] = value.y;
    data[index + VEC_OFFSET_Z] = value.z;
    data[index + VEC_OFFSET_W] = value.w;
}
