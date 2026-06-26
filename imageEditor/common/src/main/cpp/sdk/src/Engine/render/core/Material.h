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

#ifndef MATERIAL_H
#define MATERIAL_H

#include <string>
#include <map>
#include "render/base/RenderBase.h"
#include "render/base/math/RenderVector.h"
#include "render/base/math/RenderMatrix.h"

class Material {
public:
    class ElementType {
    public:
        enum Value {
            INT_VALUE,
            FLOAT_VALUE,
            VEC2_VALUE,
            VEC3_VALUE,
            VEC4_VALUE,
            MAT2_VALUE,
            MAT3_VALUE,
            MAT4_VALUE,
            TEXTURE_VALUE,
            INVALID_VALUE
        };

        template <class T> static constexpr Value Of()
        {
            return ElementTypeDescriptor<T>::elementType;
        }

    private:
        ElementType(){};

        ~ElementType(){};

        template <class T> struct ElementTypeDescriptor;
    };

    template <class T> void Set(std::string key, T value);

    template <class T> T Get(std::string key);

    void SetTexture(std::string key, int texId)
    {
        intMap[key] = texId;
        typeMap_[key] = ElementType::TEXTURE_VALUE;
    }

    int GetTexture(std::string key);

    ElementType::Value GetType(std::string key) const
    {
        return typeMap_.at(key);
    }

    const std::map<std::string, ElementType::Value> &GetElementTypes() const
    {
        return typeMap_;
    }

private:
    std::map<std::string, ElementType::Value> typeMap_;
    std::map<std::string, int> intMap;
    std::map<std::string, float> floatMap;
    std::map<std::string, Vec2> vec2Map;
    std::map<std::string, Vec3> vec3Map;
    std::map<std::string, Vec4> vec4Map;
    std::map<std::string, Mat2x2> mat2Map;
    std::map<std::string, Mat3x3> mat3Map;
    std::map<std::string, Mat4x4> mat4Map;
};

#endif // MATERIAL_H
