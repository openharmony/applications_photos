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
#include "HmcEngine.h"
#include "HmcService.h"
#include "../HmcMaterialConstant.h"
#include "HmcMaterialColumn.h"

#include "../HmcMaterialUtil.h"
#include "../Cache/HmcMaterialUidCache.h"

constexpr const char *MATERIAL_COLUMN_UPDATE_TIME = "updateTime";
constexpr const char *MATERIAL_COLUMN_CODE = "code";
constexpr const char *MATERIAL_COLUMN_ATTRIBUTE = "attribute";
constexpr const char *MATERIAL_COLUMN_CONTENT_TYPE = "contentType";
constexpr const char *MATERIAL_COLUMN_PICLIST = "picList";
constexpr const char *MATERIAL_COLUMN_PICLIST_TYPE = "type";
constexpr const char *MATERIAL_CONTENT_PICLIST_ASPECT_RATIO = "aspectRatio";
constexpr const char *MATERIAL_COLUMN_PICLIST_URL = "url";
constexpr const char *MATERIAL_COLUMN_PICLIST_FORMAT = "format";
constexpr const char *MATERIAL_COLUMN_PICLIST_SELECTED_URL = "selectedUrl";
constexpr const char *MATERIAL_COLUMN_TYPE = "type";
constexpr const char *MATERIAL_COLUMN_ID = "contentId";
constexpr const char *MATERIAL_COLUMN_NAME = "contentName";
constexpr const char *JSON_FILE_SUFFIX = ".json";

HmcMaterialColumn::HmcMaterialColumn(HmcMaterialLibraryColumnType colType)
{
    HmcUidGenerate(&uid);
    Clear();
    columnType = colType;
}

HmcMaterialColumn::HmcMaterialColumn(const HmcMaterialColumn &other)
{
    CopyAllFromOther(other);
}

HmcMaterialColumn &HmcMaterialColumn::operator = (const HmcMaterialColumn &other)
{
    CopyAllFromOther(other);
    return *this;
}

VOID HmcMaterialColumn::CopyAllFromOther(const HmcMaterialColumn &other)
{
    Clear();
    CopyWithoutCacheTimeAndList(other);
    updateTime = other.updateTime;
    cacheTime = other.cacheTime;
    materialIdList.clear();
    materialIdList.insert(materialIdList.begin(), other.materialIdList.begin(), other.materialIdList.end());
    netMaterialList.clear();
    netMaterialList.insert(netMaterialList.begin(), other.netMaterialList.begin(), other.netMaterialList.end());
}

VOID HmcMaterialColumn::CopyWithoutCacheTimeAndList(const HmcMaterialColumn &other)
{
    uid = other.uid;
    contentType = other.contentType;
    state = other.state;
    attribute = other.attribute;
    type = other.type;
    columnType = other.columnType;
    columnId = other.columnId;
    columnName = other.columnName;
    code = other.code;
    tmpl = other.tmpl;
    picList.clear();
    picList.insert(picList.begin(), other.picList.begin(), other.picList.end());
}

Json::Value HmcMaterialColumn::SerializeToJson()
{
    Json::Value colJson;
    colJson["uid"] = HmcUidToString(&uid);
    colJson["contentType"] = contentType;
    colJson["state"] = (UINT32)state;
    colJson["attribute"] = attribute;
    colJson["type"] = (UINT32)type;
    colJson["columnType"] = (UINT32)columnType;
    colJson["columnId"] = columnId;
    colJson["columnName"] = columnName;
    colJson["code"] = code;
    colJson["tmpl"] = tmpl;
    Json::Value picListJson(Json::arrayValue);
    for (VECTOR<HmcPic>::iterator iter = picList.begin(); iter != picList.end(); iter++) {
        picListJson.append(iter->SerializeToJson());
    }
    colJson["picList"] = picListJson;

    Json::Value materialIdListJson(Json::arrayValue);
    for (VECTOR<HmcMaterialIdTypePair>::iterator iter = materialIdList.begin(); iter != materialIdList.end(); iter++) {
        Json::Value idTypePairJson(Json::objectValue);
        idTypePairJson["id"] = iter->id;
        idTypePairJson["type"] = (UINT32)iter->type;
        idTypePairJson["index"] = iter->index;
        materialIdListJson.append(idTypePairJson);
    }
    colJson["materialIdList"] = materialIdListJson;

    colJson["cacheTime"] = cacheTime;
    colJson[MATERIAL_COLUMN_UPDATE_TIME] = updateTime;
    colJson["version"] = version;
    return colJson;
}

VOID HmcMaterialColumn::DeserializeFromJson(const Json::Value &colJson)
{
    std::string uidStr;
    if (JsonValueUtil::ParseValueIfHas(colJson, "uid", uidStr)) {
        HmcUidFromString(uidStr.c_str(), &uid);
    }
    JsonValueUtil::ParseValueIfHas(colJson, "contentType", contentType);
    unsigned int innerState;
    if (JsonValueUtil::ParseValueIfHas(colJson, "state", innerState)) {
        state = (HmcMaterialState) innerState;
    }
    JsonValueUtil::ParseValueIfHas(colJson, "attribute", attribute);
    unsigned int innerType;
    if (JsonValueUtil::ParseValueIfHas(colJson, "type", innerType)) {
        type = (HmcMaterialLibraryType)innerType;
    }
    unsigned int innerColumnType;
    if (JsonValueUtil::ParseValueIfHas(colJson, "columnType", innerColumnType)) {
        columnType = (HmcMaterialLibraryColumnType)innerColumnType;
    }
    JsonValueUtil::ParseValueIfHas(colJson, "columnId", columnId);
    JsonValueUtil::ParseValueIfHas(colJson, "columnName", columnName);
    JsonValueUtil::ParseValueIfHas(colJson, "code", code);
    JsonValueUtil::ParseValueIfHas(colJson, "tmpl", tmpl);
    int size = (int)colJson["picList"].size();
    for (int idx = 0; idx < size; idx++) {
        HmcPic pic;
        pic.DeserializeFromJson(colJson["picList"][idx]);
        picList.push_back(pic);
    }

    size = (int)colJson["materialIdList"].size();
    for (int idx = 0; idx < size; idx++) {
        Json::Value colJsonIdx = colJson["materialIdList"][idx];
        HmcMaterialIdTypePair idTypePair;
        JsonValueUtil::ParseValueIfHas(colJsonIdx, "id", idTypePair.id);
        JsonValueUtil::ParseValueIfHas(colJsonIdx, "index", idTypePair.index);
        unsigned int libType;
        if (JsonValueUtil::ParseValueIfHas(colJsonIdx, "type", libType)) {
            idTypePair.type = (HmcMaterialLibraryType)libType;
        }
        materialIdList.push_back(idTypePair);
    }

    JsonValueUtil::ParseValueIfHas(colJson, "cacheTime", cacheTime);
    JsonValueUtil::ParseValueIfHas(colJson, MATERIAL_COLUMN_UPDATE_TIME, updateTime);
    JsonValueUtil::ParseValueIfHas(colJson, "version", version);
}

VOID HmcMaterialColumn::Clear()
{
    contentType = 0;
    state = MATERIAL_STATE_UNAVAILABLE;
    attribute = 0;
    type = MATERIAL_CONTENT_TYPE_NONE;
    columnType = HMC_MATERIAL_COLUMN_BUTTOM;
    columnId = "";
    columnName = "";
    code = "";
    tmpl = "";
    picList.clear();
    materialIdList.clear();
    netMaterialList.clear();
    cacheTime = HmcGetCurrTimeMillSec();
    updateTime = "";
    version = PROGRAM_VERSION;
}

INT32 HmcMaterialColumn::LoadColumnFromConfigFile()
{
    if (columnId.empty()) {
        LOGE("id is empty");
        return HMC_ERR;
    }
    STRING configFilePath = HmcMaterialUtil::GetColumnSettingDir() + FILE_SEPARATOR_STR + columnId + JSON_FILE_SUFFIX;
    Json::Value columnJson;
    if (HmcMaterialJsonUtil::LoadJsonFromFile(configFilePath, columnJson) != HMC_OK) {
        LOGE("get data from json failed, columnId:%s", columnId.c_str());
        return HMC_ERR;
    }
    DeserializeFromJson(columnJson);
    LOGD("Load column config from json ok, config path: %s", columnId.c_str());

    // 版本比对，按需要删除栏目文件
    if (CheckVersionValid() == false) {
        // 如果需要删除旧的栏目可以这里处理
    }
    return HMC_OK;
}

INT32 HmcMaterialColumn::LoadSubColumn(const STRING &columnId)
{
    HmcMaterialColumn column;
    column.columnId = columnId;
    if (column.LoadColumnFromConfigFile() != HMC_OK) {
        LOGW("load column from config failed, columnId: %s", columnId.c_str());
        return HMC_ERR;
    }
    SINGLETON(HmcMaterialUidCache)->AddColumnCache(column);
    HmcMaterialUid::LoadUid(column.uid);
    column.LoadSubMaterialLists();
    return HMC_OK;
}

void HmcMaterialColumn::LoadSubMaterialLists()
{
    auto idList = materialIdList;
    auto idListSize = idList.size();
    for (decltype(idListSize)loop = 0; loop < idListSize; loop++) {
        HmcMaterialLibraryType materialType = idList[loop].type;
        switch (materialType) {
            case MATERIAL_CONTENT_TYPE_COLUMN: {
                STRING columnId = idList[loop].id;
                HmcMaterialColumn::LoadSubColumn(columnId);
                break;
            }

            case MATERIAL_CONTENT_TYPE_NONE: {
                LOGI("column type invalid NONE");
                break;
            }

            default: {
                STRING contentId = idList[loop].id;
                // 素材, SDK重新加载时, 即认为APP重新启动, 此时所有下载都认为是被中断, 需要重新下载,
                // 因此状态为创建中或者更新中的均需要修改
                HmcMaterialContent::LoadContent(contentId);
                break;
            }
        }
    }
}

INT32 HmcMaterialColumn::GetColumnById(STRING columnId, HmcMaterialColumn &column)
{
    if (columnId.empty()) {
        LOGE("columnId(%s) is empty.", columnId.c_str());
        return HMC_ERR_MATERIAL_PARAM;
    }

    // cache 中查找
    if (SINGLETON(HmcMaterialUidCache)->GetColumnCache(columnId, column) == HMC_OK) {
        return HMC_OK;
    }
    LOGD("Can not find column from cache, going to find on disk.");

    // 本地存盘中查找
    if (LoadSubColumn(columnId) != HMC_OK) {
        LOGW("Can not find column on disk. columnId: %s", columnId.c_str());
        return HMC_ERR;
    }
    SINGLETON(HmcMaterialUidCache)->GetColumnCache(columnId, column);

    return HMC_OK;
}

bool HmcMaterialColumn::CheckVersionValid() const
{
    // 目前仅判断版本号是否为空
    if (version.empty()) {
        return false;
    }
    return true;
}

bool HmcMaterialIdTypePair::operator == (const HmcMaterialIdTypePair &other) const
{
    return (id == other.id);
}