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
#include "Material.h"

template <> struct Material::ElementType::ElementTypeDescriptor<INT32> {
    static constexpr Value elementType = INT_VALUE;
};
template <> struct Material::ElementType::ElementTypeDescriptor<FLOAT> {
    static constexpr Value elementType = FLOAT_VALUE;
};
template <> struct Material::ElementType::ElementTypeDescriptor<Vec2> {
    static constexpr Value elementType = VEC2_VALUE;
};
template <> struct Material::ElementType::ElementTypeDescriptor<Vec3> {
    static constexpr Value elementType = VEC3_VALUE;
};
template <> struct Material::ElementType::ElementTypeDescriptor<Vec4> {
    static constexpr Value elementType = VEC4_VALUE;
};
template <> struct Material::ElementType::ElementTypeDescriptor<Mat2x2> {
    static constexpr Value elementType = MAT2_VALUE;
};
template <> struct Material::ElementType::ElementTypeDescriptor<Mat3x3> {
    static constexpr Value elementType = MAT3_VALUE;
};
template <> struct Material::ElementType::ElementTypeDescriptor<Mat4x4> {
    static constexpr Value elementType = MAT4_VALUE;
};

template <> void Material::Set(std::string key, INT32 value)
{
    intMap[key] = value;
    typeMap_[key] = Material::ElementType::INT_VALUE;
}

template <> void Material::Set(std::string key, FLOAT value)
{
    floatMap[key] = value;
    typeMap_[key] = Material::ElementType::FLOAT_VALUE;
}

template <> void Material::Set(std::string key, Vec2 value)
{
    vec2Map[key] = value;
    typeMap_[key] = Material::ElementType::VEC2_VALUE;
}

template <> void Material::Set(std::string key, Vec3 value)
{
    vec3Map[key] = value;
    typeMap_[key] = Material::ElementType::VEC3_VALUE;
}

template <> void Material::Set(std::string key, Vec4 value)
{
    vec4Map[key] = value;
    typeMap_[key] = Material::ElementType::VEC4_VALUE;
}

template <> void Material::Set(std::string key, Mat2x2 value)
{
    mat2Map[key] = value;
    typeMap_[key] = Material::ElementType::MAT2_VALUE;
}

template <> void Material::Set(std::string key, Mat3x3 value)
{
    mat3Map[key] = value;
    typeMap_[key] = Material::ElementType::MAT3_VALUE;
}

template <> void Material::Set(std::string key, Mat4x4 value)
{
    mat4Map[key] = value;
    typeMap_[key] = Material::ElementType::MAT4_VALUE;
}

template <> int Material::Get(std::string key)
{
    return intMap.at(key);
}

template <> float Material::Get(std::string key)
{
    return floatMap.at(key);
}

template <> Vec2 Material::Get(std::string key)
{
    return vec2Map.at(key);
}

template <> Vec3 Material::Get(std::string key)
{
    return vec3Map.at(key);
}

template <> Vec4 Material::Get(std::string key)
{
    return vec4Map.at(key);
}

template <> Mat2x2 Material::Get(std::string key)
{
    return mat2Map.at(key);
}

template <> Mat3x3 Material::Get(std::string key)
{
    return mat3Map.at(key);
}

template <> Mat4x4 Material::Get(std::string key)
{
    return mat4Map.at(key);
}

int Material::GetTexture(std::string key)
{
    return Get<int>(key);
}
