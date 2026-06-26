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

#ifndef HMC_MATERIAL_RESOURCE_VALUE_H
#define HMC_MATERIAL_RESOURCE_VALUE_H

#include "render/base/RenderBase.h"

// 增加一种类型：
// 1、增加ValueType，Value中增加对应成员和其构造函数；注意不要修改现有ValueType顺序
// 2、增加对应的HmcRenderValue构造
// 3、Copy 和 Release 中实现
// 4、.cpp 中 TypeTraits 和 Get() 特化
// 5、 如果需要在lua中访问，请完善CreateUserdata
class HmcRenderValue {
public:
    enum ValueType {
        TYPE_NIL,
        TYPE_INT,
        TYPE_DOUBLE,
        TYPE_BOOL,
        TYPE_STRING,
        TYPE_OBJ,
        TYPE_PTR
    };

    template <typename T> struct TypeTraits {
        static ValueType type;
    };

    union Value {
        explicit Value(DOUBLE v) : mDouble(v) {}
        explicit Value(bool v) : mBool(v) {}
        explicit Value(INT32 v) : mInt(v) {}
        explicit Value(const STRING &v) : mString(v)
        {
            new (&mString) std::string(v);
        }
        explicit Value(VOID *v) : mPtr(v) {}
        Value() {}
        ~Value() {} // 当保存需要析构类型时，需要外部主动调用对应析构
        DOUBLE mDouble;
        bool mBool;
        INT32 mInt;
        STRING mString;
        VOID* mObj;
        VOID* mPtr;
    };

    HmcRenderValue() : type(TYPE_NIL) {}
    HmcRenderValue(DOUBLE v) : type(TYPE_DOUBLE), value(v) {}
    HmcRenderValue(bool v) : type(TYPE_BOOL), value(v) {}
    HmcRenderValue(INT32 v) : type(TYPE_INT), value(v) {}
    HmcRenderValue(const STRING &v) : type(TYPE_STRING), value(v) {}
    HmcRenderValue(VOID* v) : type(TYPE_PTR), value(v) {}
    ~HmcRenderValue()
    {
        Release();
    }

    HmcRenderValue(const HmcRenderValue &other)
    {
        Copy(other);
    }

    HmcRenderValue &operator = (const HmcRenderValue &other)
    {
        if (this != &other) {
            Release();
            Copy(other);
        }
        return *this;
    }

    ValueType GetType() const
    {
        return type;
    }

    template <typename T> ValueType GetValueType() const
    {
        return TypeTraits<T>::type;
    }

    template <typename T> T Get() const;

private:
    VOID Release()
    {
        switch (type) {
            case TYPE_STRING:
                value.mString.~basic_string();
                break;
            default:
                break;
        }
    }

    VOID Copy(const HmcRenderValue &other)
    {
        type = other.type;
        switch (type) {
            case TYPE_DOUBLE:
                value.mDouble = other.value.mDouble;
                break;
            case TYPE_INT:
                value.mInt = other.value.mInt;
                break;
            case TYPE_BOOL:
                value.mBool = other.value.mBool;
                break;
            case TYPE_PTR:
                value.mPtr = other.value.mPtr;
                break;
            case TYPE_STRING:
                new (&value.mString) std::string(other.value.mString);
                break;
            default:
                break;
        }
    }

    ValueType type;
    Value value;
};

#endif // !HMC_MATERIAL_RESOURCE_VALUE_H
