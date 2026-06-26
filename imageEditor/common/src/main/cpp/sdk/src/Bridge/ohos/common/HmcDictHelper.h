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
#ifndef HMCDICTHELPER_H
#define HMCDICTHELPER_H

#include "HmcUidHelper.h"

class HmcDictItem {
public:
    HmcDictItem(HmcDict *dict, const char *key) : dict(dict), key(key) {}

    operator int()
    {
        int value = 0;
        HmcDictGetInt32(dict, key, &value);
        return value;
    }
    operator int64_t()
    {
        int64_t value = 0;
        HmcDictGetInt64(dict, key, &value);
        return value;
    }
    operator std::string()
    {
        const char *value = HmcDictGetString(dict, key);
        return value != nullptr ? value : "";
    }
    operator double()
    {
        double value = 0;
        HmcDictGetDouble(dict, key, &value);
        return value;
    }
    operator HmcUid()
    {
        HmcUid uid = HMC_UID_NULL;
        HmcDictGetUid(dict, key, &uid);
        return uid;
    }
    std::string AsUid()
    {
        HmcUid id = *this;
        char addr[HMC_UID_STR_LEN] = {0};
        HmcUidToString(&id, addr, HMC_UID_STR_LEN);
        return addr;
    }

    template <typename T> T *AsPointer()
    {
        T *value;
        HmcDictGetPointer(dict, key, static_cast<void **>(&value));
        return value;
    }

    void operator = (int value)
    {
        HmcDictSetInt32(dict, key, value);
    }

    void operator = (int64_t value)
    {
        HmcDictSetInt64(dict, key, value);
    }

    void operator = (double value)
    {
        HmcDictSetDouble(dict, key, value);
    }

    void operator = (const char *value)
    {
        HmcDictSetString(dict, key, value);
    }
    void operator = (HmcUid *id)
    {
        HmcDictSetUid(dict, key, id);
    }
    void operator = (std::string const & val)
    {
        HmcDictSetString(dict, key, val.c_str());
    }

protected:
    HmcDict *dict = nullptr;
    const char *key;
};

class HmcDictHelper {
public:
    HmcDictHelper() : destroyIt(true)
    {
        dict = HmcDictCreate();
    }
    explicit HmcDictHelper(HmcDict *dict) : dict(dict), destroyIt(false) {}
    ~HmcDictHelper()
    {
        if (destroyIt && dict != nullptr) {
            HmcDictDestroy(dict);
            dict = nullptr;
        }
    }
    HmcDict *Detach()
    {
        HmcDict *ret = dict;
        dict = nullptr;
        destroyIt = false;
        return ret;
    }
    HmcDictItem operator[](const char *key)
    {
        return { dict, key };
    }
    operator HmcDict *()
    {
        return dict;
    }

private:
    HmcDict *dict = nullptr;
    bool destroyIt = false;
};
#endif // HMCDICTHELPER_H
