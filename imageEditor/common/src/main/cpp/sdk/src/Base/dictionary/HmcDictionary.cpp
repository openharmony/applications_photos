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

VOID HmcDictionary::SetInt32(const STRING &key, INT32 value)
{
    m_map[HmcStrToLower(key)] = value;
}

VOID HmcDictionary::SetInt64(const STRING &key, INT64 value)
{
    m_map[HmcStrToLower(key)] = value;
}

VOID HmcDictionary::SetDouble(const STRING &key, DOUBLE value)
{
    m_map[HmcStrToLower(key)] = value;
}

VOID HmcDictionary::SetString(const STRING &key, const STRING &value)
{
    m_map[HmcStrToLower(key)] = value;
}


VOID HmcDictionary::SetPointer(const STRING &key, VOID *value)
{
    m_map[HmcStrToLower(key)] = value;
}

VOID HmcDictionary::SetUid(const STRING &key, HmcUid uid)
{
    m_map[HmcStrToLower(key)] = uid;
}

INT32 HmcDictionary::GetInt32(const STRING &key, INT32 &value)
{
    auto i = m_map.find(HmcStrToLower(key));
    if (i == m_map.end()) {
        return HMC_ERR_DICT_KEY;
    }
    if (i->second.GetType() != HmcDictionaryValue::TYPE_INT32) {
        return HMC_ERR_DICT_VALUE;
    }
    value = i->second.GetInt32();
    return HMC_OK;
}

INT32 HmcDictionary::GetInt64(const STRING &key, INT64 &value)
{
    auto i = m_map.find(HmcStrToLower(key));
    if (i == m_map.end()) {
        return HMC_ERR_DICT_KEY;
    }
    if (i->second.GetType() != HmcDictionaryValue::TYPE_INT64) {
        return HMC_ERR_DICT_VALUE;
    }
    value = i->second.GetInt64();
    return HMC_OK;
}

INT32 HmcDictionary::GetDouble(const STRING &key, DOUBLE &value)
{
    auto i = m_map.find(HmcStrToLower(key));
    if (i == m_map.end()) {
        return HMC_ERR_DICT_KEY;
    }
    if (i->second.GetType() != HmcDictionaryValue::TYPE_DOUBLE) {
        return HMC_ERR_DICT_VALUE;
    }
    value = i->second.GetDouble();
    return HMC_OK;
}

const CHAR *HmcDictionary::GetString(const STRING &key)
{
    auto i = m_map.find(HmcStrToLower(key));
    if (i == m_map.end() || i->second.GetType() != HmcDictionaryValue::TYPE_STRING) {
        return NULL;
    }

    return i->second.GetString().c_str();
}

INT32 HmcDictionary::GetPointer(const STRING &key, VOID *&value)
{
    auto i = m_map.find(HmcStrToLower(key));
    if (i == m_map.end()) {
        return HMC_ERR_DICT_KEY;
    }
    if (i->second.GetType() != HmcDictionaryValue::TYPE_POINTER) {
        return HMC_ERR_DICT_VALUE;
    }
    value = i->second.GetPointer();
    return HMC_OK;
}

INT32 HmcDictionary::GetUid(const STRING &key, HmcUid *value)
{
    auto i = m_map.find(HmcStrToLower(key));
    if (i == m_map.end()) {
        return HMC_ERR_DICT_KEY;
    }
    if (i->second.GetType() != HmcDictionaryValue::TYPE_UID) {
        return HMC_ERR_DICT_VALUE;
    }
    i->second.GetUid(value);
    return HMC_OK;
}

STRING HmcDictionary::Serialize()
{
    STRING serialized;

    for (const auto &i : m_map) {
        switch (i.second.GetType()) {
            case HmcDictionaryValue::TYPE_INT32:
                serialized += HmcStringFormat("%s:int32:%d" CRLF, i.first.c_str(), i.second.GetInt32());
                break;
            case HmcDictionaryValue::TYPE_INT64:
                serialized += HmcStringFormat("%s:int64:%d" CRLF, i.first.c_str(), i.second.GetInt64());
                break;
            case HmcDictionaryValue::TYPE_DOUBLE:
                serialized += HmcStringFormat("%s:double:%lf" CRLF, i.first.c_str(), i.second.GetDouble());
                break;
            case HmcDictionaryValue::TYPE_STRING:
                serialized += HmcStringFormat("%s:string:%s" CRLF, i.first.c_str(), i.second.GetString().c_str());
                break;
            case HmcDictionaryValue::TYPE_POINTER:
                serialized += HmcStringFormat("%s:pointer:0x%llx" CRLF, i.first.c_str(), (UINT64)i.second.GetPointer());
                break;
            case HmcDictionaryValue::TYPE_UID:
                HmcUid uid;
                i.second.GetUid(&uid);

                CHAR uidStr[HMC_UID_STR_LEN] = {0};
                serialized +=
                    HmcStringFormat("%s:uid:%s" CRLF, i.first.c_str(), HmcUidToString(&uid, uidStr, sizeof(uidStr)));
                break;
        }
    }
    return serialized;
}

INT32 HmcDictionary::Deserialize(const STRING &serialized)
{
    auto lines = HmcSplitString(serialized, CRLF);
    for (const auto &line : lines) {
        auto firstColon = line.find_first_of(':');
        if (firstColon == STRING::npos) {
            LOGW("Bad serialized line \"%s\".", line.c_str());
            return HMC_ERR;
        }
        auto secondColon = line.find_first_of(':', firstColon + 1);
        if (secondColon == STRING::npos) {
            LOGW("Bad serialized line \"%s\".", line.c_str());
            return HMC_ERR;
        }
        STRING key(line, 0, firstColon);
        STRING type(line, firstColon + 1, secondColon - firstColon - 1);
        STRING value(line, secondColon + 1);
        if (type == "int32") {
            m_map[key] = atoi(value.c_str());
        } else if (type == "int64") {
            m_map[key] = (INT64)atoll(value.c_str());
        } else if (type == "double") {
            m_map[key] = atof(value.c_str());
        } else if (type == "string") {
            m_map[key] = value;
        } else if (type == "pointer") {
            m_map[key] = (VOID *)strtoul(value.c_str(), NULL, 0);
        } else if (type == "uid") {
            HmcUid uid;
            if (HMC_OK != HmcUidFromString(value.c_str(), &uid)) {
                LOGW("Bad serialized line \"%s\".", line.c_str());
                return HMC_ERR;
            }
            m_map[key] = uid;
        } else {
            LOGW("Bad serialized line \"%s\".", line.c_str());
            return HMC_ERR;
        }
    }
    return HMC_OK;
}

// 获取下一个关键字，用于迭代遍历
const CHAR *HmcDictionary::GetNextKey(const CHAR *key)
{
    if (m_map.empty()) {
        // 容器是空的
        return NULL;
    }

    if (!key) {
        // 获取首个关键字
        return m_map.begin()->first.c_str();
    }

    auto iterator = m_map.find(key);
    if (iterator == m_map.end()) {
        // 没找到提供的关键字
        return NULL;
    }

    // 迭代器向后移动
    iterator++;

    if (iterator == m_map.end()) {
        // 结束了
        return NULL;
    }
    return iterator->first.c_str();
}

VOID HmcDictionary::RemoveKey(const CHAR *key)
{
    m_map.erase(HmcStrToLower(key));
}
