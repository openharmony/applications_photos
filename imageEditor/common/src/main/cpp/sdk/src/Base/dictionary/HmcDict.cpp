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

HmcDict *HmcDictCreate()
{
    return new HmcDictionary();
}

const char *HmcDictGetNextKey(const HmcDict *dict, const char *key)
{
    auto *dictionary = (HmcDictionary *)dict;
    if (!dictionary) {
        return NULL;
    }
    return dictionary->GetNextKey(key);
}

void HmcDictRemoveKey(const HmcDict *dict, const char *key)
{
    auto *dictionary = (HmcDictionary *)dict;
    if (dictionary) {
        dictionary->RemoveKey(key);
    }
}

int HmcDictSetInt32(const HmcDict *dict, const char *key, int value)
{
    auto *dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary) {
        return HMC_ERR_PARAM;
    }
    dictionary->SetInt32(key, value);
    return HMC_OK;
}

int HmcDictGetInt32(const HmcDict *dict, const char *key, int *value)
{
    auto *dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary || !value) {
        return HMC_ERR_PARAM;
    }

    INT32 int32Value;
    if (HMC_OK != dictionary->GetInt32(key, int32Value)) {
        return HMC_ERR_DICT_KEY;
    }

    *value = int32Value;
    return HMC_OK;
}


int HmcDictSetInt64(const HmcDict *dict, const char *key, int64_t value)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary) {
        return HMC_ERR_PARAM;
    }
    dictionary->SetInt64(key, value);
    return HMC_OK;
}

int HmcDictGetInt64(const HmcDict *dict, const char *key, int64_t *value)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary || !value) {
        return HMC_ERR_PARAM;
    }

    INT64 int64Value;
    if (HMC_OK != dictionary->GetInt64(key, int64Value)) {
        return HMC_ERR_DICT_KEY;
    }

    *value = int64Value;
    return HMC_OK;
}


int HmcDictSetString(const HmcDict *dict, const char *key, const char *value)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary) {
        return HMC_ERR_PARAM;
    }
    dictionary->SetString(key, value);
    return HMC_OK;
}

const char *HmcDictGetString(const HmcDict *dict, const char *key)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary) {
        return NULL;
    }

    return dictionary->GetString(key);
}


int HmcDictSetDouble(const HmcDict *dict, const char *key, double value)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary) {
        return HMC_ERR_PARAM;
    }
    dictionary->SetDouble(key, value);
    return HMC_OK;
}

int HmcDictGetDouble(const HmcDict *dict, const char *key, double *value)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary || !value) {
        return HMC_ERR_PARAM;
    }

    DOUBLE doubleValue;
    if (HMC_OK != dictionary->GetDouble(key, doubleValue)) {
        return HMC_ERR_DICT_KEY;
    }

    *value = doubleValue;
    return HMC_OK;
}

int HmcDictSetPointer(const HmcDict *dict, const char *key, void *value)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary) {
        return HMC_ERR_PARAM;
    }
    dictionary->SetPointer(key, value);
    return HMC_OK;
}

int HmcDictGetPointer(const HmcDict *dict, const char *key, void **value)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary || !value) {
        return HMC_ERR_PARAM;
    }

    VOID *pointerValue;
    if (HMC_OK != dictionary->GetPointer(key, pointerValue)) {
        return HMC_ERR_DICT_KEY;
    }

    *value = pointerValue;
    return HMC_OK;
}

// 设置UID类型的数据
int HmcDictSetUid(const HmcDict *dict, const char *key, const HmcUid *uid)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary || !uid) {
        return HMC_ERR_PARAM;
    }

    dictionary->SetUid(key, *uid);
    return HMC_OK;
}

// 获取UID类型的数据
int HmcDictGetUid(const HmcDict *dict, const char *key, HmcUid *uid)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!key || !dictionary || !uid) {
        return HMC_ERR_PARAM;
    }

    return dictionary->GetUid(key, uid);
}


HmcDict *HmcDictDuplicate(const HmcDict *dict)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!dictionary) {
        return NULL;
    }

    return new HmcDictionary(*dictionary);
}

char *HmcDictSerialize(const HmcDict *dict)
{
    auto dictionary = (HmcDictionary *)dict;
    if (!dictionary) {
        return NULL;
    }
    return HmcStrDup(dictionary->Serialize().c_str());
}

HmcDict *HmcDictDeserialize(const char *dictStr)
{
    if (!dictStr) {
        return NULL;
    }

    auto dictionary = new HmcDictionary();
    if (HMC_OK != dictionary->Deserialize(dictStr)) {
        delete dictionary;
        return NULL;
    }

    return dictionary;
}

void HmcDictDestroy(HmcDict *dict)
{
    auto dictionary = (HmcDictionary *)dict;
    if (dictionary) {
        delete dictionary;
    }
}
