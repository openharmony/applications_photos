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

#ifndef HMCDICTIONARY_H
#define HMCDICTIONARY_H

#ifdef __cplusplus

class HmcDictionary {
public:
    HmcDictionary() = default;

    virtual ~HmcDictionary() = default;

    VOID SetInt32(const STRING &key, INT32 value);

    VOID SetInt64(const STRING &key, INT64 value);

    VOID SetDouble(const STRING &key, DOUBLE value);

    VOID SetString(const STRING &key, const STRING &value);

    VOID SetPointer(const STRING &key, VOID *value);

    VOID SetUid(const STRING &key, HmcUid uid);

    INT32 GetInt32(const STRING &key, INT32 &value);

    INT32 GetInt64(const STRING &key, INT64 &value);

    INT32 GetDouble(const STRING &key, DOUBLE &value);

    const CHAR *GetString(const STRING &key);

    INT32 GetPointer(const STRING &key, VOID *&value);

    INT32 GetUid(const STRING &key, HmcUid *value);

    STRING Serialize();

    INT32 Deserialize(const STRING &serialized);

    const CHAR *GetNextKey(const CHAR *key);

    VOID RemoveKey(const CHAR *key);

private:
    MAP<STRING, HmcDictionaryValue> m_map;
};

#endif // __cplusplus
#endif // HMCDICTIONARY_H
