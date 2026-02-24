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

#ifndef HMCDICTIONARYVALUE_H
#define HMCDICTIONARYVALUE_H

#ifdef __cplusplus

class HmcDictionaryValue {
public:
    enum HmcDictionaryValueType {
        TYPE_INT32,
        TYPE_INT64,
        TYPE_DOUBLE,
        TYPE_STRING,
        TYPE_POINTER,
        TYPE_UID
    };

public:
    HmcDictionaryValue();

    virtual ~HmcDictionaryValue() = default;

    HmcDictionaryValue(INT32 value);

    HmcDictionaryValue(INT64 value);

    HmcDictionaryValue(DOUBLE value);

    HmcDictionaryValue(const STRING &value);

    HmcDictionaryValue(VOID *value);

    HmcDictionaryValue(const HmcUid &uid);

    HmcDictionaryValueType GetType() const;

    INT32 GetInt32() const;

    INT64 GetInt64() const;

    DOUBLE GetDouble() const;

    const STRING &GetString() const;

    VOID *GetPointer() const;

    VOID GetUid(HmcUid *uid) const;

private:
    HmcDictionaryValueType m_type;
    INT32 m_int32;
    INT64 m_int64;
    DOUBLE m_double;
    STRING m_string;
    VOID *m_pointer;
    HmcUid m_uid;
};

#endif // __cplusplus
#endif // HMCDICTIONARYVALUE_H
