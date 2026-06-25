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
#ifndef MESH_H
#define MESH_H

#include "render/base/RenderBase.h"
#include <GLES3/gl3.h>

// vec取值偏移量
const int VEC_OFFSET_X = 0;
const int VEC_OFFSET_Y = 1;
const int VEC_OFFSET_Z = 2;
const int VEC_OFFSET_W = 3;
// vec的大小
const int VEC2_SIZE = 2;
const int VEC3_SIZE = 3;
const int VEC4_SIZE = 4;

class Mesh {
public:
    class AttribType {
    public:
        enum Value {
            FLOAT_VALUE,
            VEC2_VALUE,
            VEC3_VALUE,
            VEC4_VALUE
        };

        static int GetTypeLen(Value value)
        {
            switch (value) {
                case Value::FLOAT_VALUE:
                    return 1;
                case Value::VEC2_VALUE:
                    return 2;
                case Value::VEC3_VALUE:
                    return 3;
                case Value::VEC4_VALUE:
                    return 4;
            }
            return 0;
        }

        template <class T> static constexpr Value Of()
        {
            return AttribTypeDescriptor<T>::elementType;
        }

    private:
        AttribType(){};

        ~AttribType(){};

        template <class T> struct AttribTypeDescriptor {};
    };

    class Primitive {
    public:
        enum class Value {
            TRIANGLES,
            TRIANGLE_STRIP,
            TRIANGLE_FAN
        };

        static Value FromString(std::string string)
        {
            if (string == "triangles") {
                return Value::TRIANGLES;
            } else if (string == "triangle_strip") {
                return Value::TRIANGLE_STRIP;
            } else if (string == "triangle_fan") {
                return Value::TRIANGLE_FAN;
            } else {
                throw std::logic_error("Unsupproted primitive: " + string);
            }
        }

        static int GetGlPrimitive(Value value)
        {
            switch (value) {
                case Value::TRIANGLES:
                    return GL_TRIANGLES;
                case Value::TRIANGLE_STRIP:
                    return GL_TRIANGLE_STRIP;
                case Value::TRIANGLE_FAN:
                    return GL_TRIANGLE_FAN;
            }
            return 0;
        }

    private:
        Primitive(){};

        ~Primitive(){};
    };

    class AttribArray {
    public:
        AttribArray(AttribType::Value type, std::vector<float> data) : type_(type), data_(std::move(data)) {}

        ~AttribArray(){};

        AttribType::Value GetType() const
        {
            return type_;
        }

        const std::vector<float> &GetData() const
        {
            return data_;
        }

        std::vector<float> &GetData()
        {
            return data_;
        }

        AttribType::Value type_;
        std::vector<float> data_;

    private:
    };

    int GetVertexCount() const
    {
        return vertexCount_;
    }

    void SetVertexCount(int vertexCount)
    {
        vertexCount_ = vertexCount;
    }

    Primitive::Value GetPrimitive() const
    {
        return primitive_;
    }

    void SetPrimitive(Primitive::Value primitive)
    {
        primitive_ = primitive;
    }

    const std::map<std::string, AttribArray> &GetAttribArrays() const
    {
        return attribArrays_;
    }

    void SetArray(std::string key, AttribType::Value type, std::vector<float> data)
    {
        attribArrays_.emplace(key, AttribArray(type, std::move(data)));
    }

    template <class T> void Set(std::string key, int index, T value);

private:
    int vertexCount_ = 0;
    Primitive::Value primitive_ = Primitive::Value::TRIANGLES;
    std::map<std::string, AttribArray> attribArrays_;
};
// #endif
#endif // MESH_H
