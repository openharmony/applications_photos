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
#include "HmcBase.h"

HmcDictionaryValue::HmcDictionaryValue()
    : m_type(TYPE_INT32), m_int32(0), m_int64(0), m_double(0.0), m_pointer(NULL), m_uid(HMC_UID_NULL)
{}


HmcDictionaryValue::HmcDictionaryValue(INT32 value)
    : m_type(TYPE_INT32), m_int32(value), m_int64(0), m_double(0.0), m_pointer(NULL), m_uid(HMC_UID_NULL)
{}

HmcDictionaryValue::HmcDictionaryValue(INT64 value)
    : m_type(TYPE_INT64), m_int32(0), m_int64(value), m_double(0.0), m_pointer(NULL), m_uid(HMC_UID_NULL)
{}

HmcDictionaryValue::HmcDictionaryValue(DOUBLE value)
    : m_type(TYPE_DOUBLE), m_int32(0), m_int64(0), m_double(value), m_pointer(NULL), m_uid(HMC_UID_NULL)
{}

HmcDictionaryValue::HmcDictionaryValue(const STRING &value)
    : m_type(TYPE_STRING), m_int32(0), m_int64(0), m_double(0.0), m_string(value), m_pointer(NULL), m_uid(HMC_UID_NULL)
{}

HmcDictionaryValue::HmcDictionaryValue(VOID *value)
    : m_type(TYPE_POINTER), m_int32(0), m_int64(0), m_double(0.0), m_pointer(value), m_uid(HMC_UID_NULL)
{}

HmcDictionaryValue::HmcDictionaryValue(const HmcUid &uid)
    : m_type(TYPE_UID), m_int32(0), m_int64(0), m_double(0.0), m_pointer(NULL), m_uid(uid)
{}

HmcDictionaryValue::HmcDictionaryValueType HmcDictionaryValue::GetType() const
{
    return m_type;
};

INT32 HmcDictionaryValue::GetInt32() const
{
    return m_int32;
};

INT64 HmcDictionaryValue::GetInt64() const
{
    return m_int64;
}

DOUBLE HmcDictionaryValue::GetDouble() const
{
    return m_double;
}

const STRING &HmcDictionaryValue::GetString() const
{
    return m_string;
}

VOID *HmcDictionaryValue::GetPointer() const
{
    return m_pointer;
}

VOID HmcDictionaryValue::GetUid(HmcUid *uid) const
{
    HmcUidCopy(uid, &m_uid);
}
