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
#ifndef HMCUIDHELPER_H
#define HMCUIDHELPER_H

#include <string>
#include "../../../../include/MediaCreative.h"

class HmcUidHelper {
public:
    explicit HmcUidHelper(HmcUid const & hmcid) : fromString(false), hmcId(hmcid) {}
    explicit HmcUidHelper(std::string const & str) : fromString(true), id(str) {}
    operator const char *()
    {
        if (!fromString && id.size() == 0) {
            char strUid[HMC_UID_STR_LEN] = { 0 };
            HmcUidToString(&hmcId, strUid, HMC_UID_STR_LEN);
            id = strUid;
        }
        return id.c_str();
    }

    operator std::string()
    {
        return static_cast<const char *>(*this);
    }

    operator HmcUid &()
    {
        if (fromString) {
            HmcUidFromString(id.c_str(), &hmcId);
        }
        return hmcId;
    }

protected:
    bool fromString;
    std::string id;
    HmcUid hmcId = HMC_UID_NULL;
};
#endif // HMCUIDHELPER_H
