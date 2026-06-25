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
#include "HmcMaterialContent.h"
#include "HmcMaterialUid.h"
#include "../HmcMaterialUtil.h"
#include "../Cache/HmcMaterialUidCache.h"
#include "../HmcMaterialManager.h"

constexpr const char *JSON_FILE_SUFFIX = ".json";

VOID HmcMaterialUid::SaveUidToConfigFile()
{
    STRING uidBuffStr = HmcUidToString(&uid);
    STRING configFilePath = HmcMaterialUtil::GetUidSettingDir() + FILE_SEPARATOR_STR + uidBuffStr + JSON_FILE_SUFFIX;

    HmcStringSerialize(SerializeToString(), configFilePath);
    SINGLETON(HmcMaterialUidCache)->AddUidCache(uidBuffStr, *this);
}

INT32 HmcMaterialUid::LoadUidFromConfigFile()
{
    STRING uidBuffStr = HmcUidToString(&uid);
    STRING configFilePath = HmcMaterialUtil::GetUidSettingDir() + FILE_SEPARATOR_STR + uidBuffStr + JSON_FILE_SUFFIX;
    Json::Value uidJson;
    if (HmcMaterialJsonUtil::LoadJsonFromFile(configFilePath, uidJson) != HMC_OK) {
        LOGE("get data from json failed, uid:%s", uidBuffStr.c_str());
        return HMC_ERR;
    }
    DeserializeFromJson(uidJson);
    SINGLETON(HmcMaterialUidCache)->AddUidCache(uidBuffStr, *this);
    return HMC_OK;
}

Json::Value HmcMaterialUid::SerializeToJson()
{
    Json::Value colJson;
    colJson["uid"] = HmcUidToString(&uid);
    colJson["parentUid"] = HmcUidToString(&parentUid);
    colJson["materialId"] = materialId;
    colJson["type"] = (INT32)type;
    colJson["columnType"] = (INT32)columnType;

    return colJson;
}

VOID HmcMaterialUid::DeserializeFromJson(const Json::Value &colJson)
{
    std::string uidStr;
    if (JsonValueUtil::ParseValueIfHas(colJson, "uid", uidStr)) {
        HmcUidFromString(uidStr.c_str(), &uid);
    }
    std::string parentUidStr;
    if (JsonValueUtil::ParseValueIfHas(colJson, "parentUid", parentUidStr)) {
        HmcUidFromString(parentUidStr.c_str(), &parentUid);
    }
    JsonValueUtil::ParseValueIfHas(colJson, "materialId", materialId);
    int innerType;
    if (JsonValueUtil::ParseValueIfHas(colJson, "type", innerType)) {
        type = (HmcMaterialLibraryType)innerType;
    }
    int innerColumnType;
    if (JsonValueUtil::ParseValueIfHas(colJson, "columnType", innerColumnType)) {
        columnType = (HmcMaterialLibraryColumnType)innerColumnType;
    }
}

INT32 HmcMaterialUid::LoadUid(const HmcUid &uid)
{
    HmcMaterialUid materialUid;
    HmcUidCopy(&materialUid.uid, &uid);
    return materialUid.LoadUidFromConfigFile();
}

INT32 HmcMaterialUid::GetMaterialUidByUid(const HmcUid &uid, HmcMaterialUid &materialUid)
{
    // 查找cache
    STRING uidBuffStr = HmcUidToString(&uid);
    if (SINGLETON(HmcMaterialUidCache)->GetUidCache(uidBuffStr, materialUid) == HMC_OK) {
        return HMC_OK;
    }
    // cache 没有, 继续查找本地存盘
    if (HmcMaterialUid::LoadUid(uid) != HMC_OK) {
        LOGW("load uid from disk failed. uid: %s", uidBuffStr.c_str());
        return HMC_ERR;
    }
    SINGLETON(HmcMaterialUidCache)->GetUidCache(uidBuffStr, materialUid);
    return HMC_OK;
}
