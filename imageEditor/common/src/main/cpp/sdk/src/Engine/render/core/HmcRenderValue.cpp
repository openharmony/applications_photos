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

#include "render/core/HmcRenderValue.h"

template <> HmcRenderValue::ValueType HmcRenderValue::TypeTraits<DOUBLE>::type = TYPE_DOUBLE;
template <> HmcRenderValue::ValueType HmcRenderValue::TypeTraits<INT32>::type = TYPE_INT;
template <> HmcRenderValue::ValueType HmcRenderValue::TypeTraits<bool>::type = TYPE_BOOL;
template <> HmcRenderValue::ValueType HmcRenderValue::TypeTraits<STRING>::type = TYPE_STRING;
template <> HmcRenderValue::ValueType HmcRenderValue::TypeTraits<VOID*>::type = TYPE_PTR;

template <> DOUBLE HmcRenderValue::Get<DOUBLE>() const
{
    RENDER_ASSERT(type == GetValueType<DOUBLE>());
    return value.mDouble;
}

template <> STRING HmcRenderValue::Get<STRING>() const
{
    RENDER_ASSERT(type == GetValueType<STRING>());
    return value.mString;
}

template <> bool HmcRenderValue::Get<bool>() const
{
    RENDER_ASSERT(type == GetValueType<bool>());
    return value.mBool;
}

template <> INT32 HmcRenderValue::Get<INT32>() const
{
    RENDER_ASSERT(type == GetValueType<INT32>());
    return value.mInt;
}

template <> VOID* HmcRenderValue::Get<VOID*>() const
{
    return value.mPtr;
}

