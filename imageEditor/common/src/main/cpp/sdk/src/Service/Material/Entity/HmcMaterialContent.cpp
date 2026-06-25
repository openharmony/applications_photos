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
#include "HmcMaterialContent.h"
#include "../Cache/HmcMaterialUidCache.h"
#include "HmcMaterialUid.h"

const char *g_materialContentType = "type";
const char *g_materialContentId = "contentId";
const char *g_materialContentName = "contentName";

const char *g_materialContentMinsdkver = "minSDKVer";
const char *g_materialContentDuration = "duration";
const char *g_materialContentChecksum = "checksum";
const char *g_materialContentUpdatetime = "updateTime";
const char *g_materialContentCategoryid = "categoryId";
const char *g_materialContentCategoryname = "categoryName";
const char *g_materialContentPreviewUrl = "previewUrl";
const char *g_materialContentSegments = "segments";
const char *g_lightMaterialIntensityKey = "intensity";
const char *g_materialContentLightBgIntensityKey = "bgIntensity";
const char *g_materialContentLightPositionXKey = "positionX";
const char *g_materialContentLightPositionYKey = "positionY";
const char *g_materialContentSubType = "subType";
const char *g_materialContentDescription = "description";
const char *g_materialContentArtistName = "artistName";
const char *g_materialContentIsEncrypted = "isEncrypted";
const char *g_materialContentDownloadCount = "downloadCount";

const char *g_materialContentCode = "code";
const char *g_materialColumnParams = "params";
const char *g_materialColumnParamsKey = "key";
const char *g_materialColumnParamsValue = "value";
const char *g_materialContentPiclist = "picList";
const char *g_materialContentPiclistType = "type";
const char *g_materialContentPiclistFormat = "format";
const char *g_materialColumnPiclistAspectRatio = "aspectRatio";
const char *g_materialContentPiclistUrl = "url";
const char *g_materialContentPiclistSelectedUrl = "selectedUrl";
const char *g_materialContentCreatedTime = "createdTime";

// 云侧返回的时长单位为秒，SDK的时长单位为毫秒
constexpr int HMC_MATERIAL_CONTENT_DURATION_MS_PER_SECOND = 1000;
// 素材下载到本地之后默认目录
const char *g_materialDefaultUserId = "1234";
constexpr const char *JSON_FILE_SUFFIX = ".json";

static const float POSITION_X_DEFAULT_VALUE = 0.7f;
static const float POSITION_Y_DEFAULT_VALUE = 0.3f;

Json::Value HmcPic::SerializeToJson()
{
    Json::Value picJson(Json::objectValue);
    picJson[g_materialContentPiclistFormat] = format;
    picJson[g_materialContentPiclistType] = type;
    picJson[g_materialColumnPiclistAspectRatio] = aspectRatio;
    picJson[g_materialContentPiclistUrl] = url;
    if (!selectedUrl.empty()) {
        picJson[g_materialContentPiclistSelectedUrl] = selectedUrl;
    }
    if (!selectedPath.empty()) {
        picJson["selectedPath"] = selectedPath;
    }
    picJson["path"] = path;
    picJson["state"] = (UINT32)state;

    return picJson;
}

VOID HmcPic::DeserializeFromJson(const Json::Value &picJson)
{
    JsonValueUtil::ParseValueIfHas(picJson, g_materialContentPiclistFormat, format);
    JsonValueUtil::ParseValueIfHas(picJson, g_materialContentPiclistType, type);
    JsonValueUtil::ParseValueIfHas(picJson, g_materialColumnPiclistAspectRatio, aspectRatio);
    JsonValueUtil::ParseValueIfHas(picJson, g_materialContentPiclistSelectedUrl, selectedUrl);
    JsonValueUtil::ParseValueIfHas(picJson, "selectedPath", selectedPath);
    JsonValueUtil::ParseValueIfHas(picJson, "url", url);
    JsonValueUtil::ParseValueIfHas(picJson, "path", path);

    if (url.empty() || path.empty()) {
        state = MATERIAL_STATE_UNAVAILABLE;
    } else {
        state = MATERIAL_STATE_AVAILABLE;
    }
}

HmcMaterialContent::HmcMaterialContent()
{
    HmcUidGenerate(&uid);
    Clear();
}

HmcMaterialContent::HmcMaterialContent(const HmcMaterialContent &other)
{
    CopyFromOther(other);
}

void HmcMaterialContent::CopyFromOther(const HmcMaterialContent &other)
{
    CopyWithoutUid(other);

    uid = other.uid;
    columnUid = other.columnUid;
    musicContentType = other.musicContentType;
    artistName = other.artistName;
    isEncrypted = other.isEncrypted;
}

HmcMaterialContent &HmcMaterialContent::operator = (const HmcMaterialContent &other)
{
    CopyFromOther(other);
    return *this;
}

Json::Value HmcMaterialContent::SerializeToJson()
{
    Json::Value contentJson(Json::objectValue);
    contentJson["uid"] = HmcUidToString(&uid);
    contentJson["columnUid"] = HmcUidToString(&columnUid);
    contentJson["columnType"] = (UINT32)columnType;
    contentJson["type"] = (UINT32)type;
    contentJson["state"] = (UINT32)state;
    contentJson["duration"] = duration;
    contentJson["downloadCnt"] = downloadCnt;
    contentJson["code"] = code;
    contentJson["contentId"] = contentId;
    contentJson["contentName"] = contentName;
    if (!previewUrl.empty()) {
        contentJson["previewUrl"] = previewUrl;
    }
    contentJson[g_materialContentSegments] = segments;
    contentJson[g_lightMaterialIntensityKey] = intensity;
    contentJson[g_materialContentLightBgIntensityKey] = bgIntensity;
    contentJson[g_materialContentLightPositionXKey] = positionX;
    contentJson[g_materialContentLightPositionYKey] = positionY;
    contentJson[g_materialContentSubType] = subType;
    if (!previewFilePath.empty()) {
        contentJson["previewFilePath"] = previewFilePath;
    }
    contentJson["description"] = description;
    contentJson["checksum"] = checksum;
    contentJson["updateTime"] = updateTime;
    contentJson["minSDKVer"] = minSDKVer;
    contentJson["categoryId"] = categoryId;
    contentJson["categoryName"] = categoryName;
    contentJson["downloadFilePath"] = downloadFilePath;
    contentJson["contentType"] = musicContentType;
    contentJson[g_materialContentArtistName] = artistName;
    contentJson[g_materialContentIsEncrypted] = isEncrypted;
    contentJson["picList"] = GetSerializedPicJson();
    contentJson["params"] = GetParamsJson();
    contentJson["cacheTime"] = cacheTime;
    contentJson[g_materialContentCreatedTime] = createdTime;
    contentJson["version"] = version;
    return contentJson;
}

Json::Value HmcMaterialContent::GetSerializedPicJson()
{
    Json::Value picListJson(Json::arrayValue);
    for (auto iter = picList.begin(); iter != picList.end(); iter++) {
        picListJson.append(iter->SerializeToJson());
    }
    return picListJson;
}

Json::Value HmcMaterialContent::GetParamsJson()
{
    Json::Value paramsJson(Json::arrayValue);
    for (VECTOR<HmcParam>::iterator iter = params.begin(); iter != params.end(); iter++) {
        paramsJson.append(iter->SerializeToJson());
    }
    return paramsJson;
}

void HmcMaterialContent::DeserializeFromJson(const Json::Value &contentJson)
{
    JsonValueUtil::ParseValueIfHas(contentJson, "contentType", musicContentType);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentArtistName, artistName);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentIsEncrypted, isEncrypted);
    JsonValueUtil::ParseFloatIfHas(contentJson, g_lightMaterialIntensityKey, intensity);
    JsonValueUtil::ParseFloatIfHas(contentJson, g_materialContentLightBgIntensityKey, bgIntensity);
    JsonValueUtil::ParseFloatIfHas(contentJson, g_materialContentLightPositionXKey, positionX);
    JsonValueUtil::ParseFloatIfHas(contentJson, g_materialContentLightPositionYKey, positionY);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentSubType, subType);
    int size = (int)contentJson["picList"].size();
    for (int idx = 0; idx < size; idx++) {
        HmcPic pic;
        pic.DeserializeFromJson(contentJson["picList"][idx]);
        picList.push_back(pic);
    }
    size = (int)contentJson["params"].size();
    for (int idx = 0; idx < size; idx++) {
        HmcParam para;
        para.DeserializeFromJson(contentJson["params"][idx]);
        params.push_back(para);
    }
    JsonValueUtil::ParseValueIfHas(contentJson, "cacheTime", cacheTime);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentCreatedTime, createdTime);
    JsonValueUtil::ParseValueIfHas(contentJson, "version", version);
    DeserializeNormal(contentJson);
}

VOID HmcMaterialContent::DeserializeNormal(const Json::Value &contentJson)
{
    std::string uidStr;
    if (JsonValueUtil::ParseValueIfHas(contentJson, "uid", uidStr)) {
        HmcUidFromString(uidStr.c_str(), &uid);
    }
    std::string columnUidStr;
    if (JsonValueUtil::ParseValueIfHas(contentJson, "columnUid", columnUidStr)) {
        HmcUidFromString(columnUidStr.c_str(), &columnUid);
    }
    unsigned int innerType;
    if (JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentType, innerType)) {
        type = (HmcMaterialLibraryType)innerType;
    }
    unsigned int innerColumnType;
    if (JsonValueUtil::ParseValueIfHas(contentJson, "columnType", innerColumnType)) {
        columnType = (HmcMaterialLibraryColumnType)innerColumnType;
    }
    unsigned int innerState;
    if (JsonValueUtil::ParseValueIfHas(contentJson, "state", innerState)) {
        state = (HmcMaterialState)innerState;
    }
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentDuration, duration);
    JsonValueUtil::ParseValueIfHas(contentJson, "downloadCnt", downloadCnt);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentSegments, segments);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentCode, code);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentId, contentId);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentName, contentName);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentPreviewUrl, previewUrl);
    JsonValueUtil::ParseValueIfHas(contentJson, "previewFilePath", previewFilePath);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentDescription, description);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentChecksum, checksum);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentUpdatetime, updateTime);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentMinsdkver, minSDKVer);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentCategoryid, categoryId);
    JsonValueUtil::ParseValueIfHas(contentJson, g_materialContentCategoryname, categoryName);
    JsonValueUtil::ParseValueIfHas(contentJson, "downloadFilePath", downloadFilePath);
    bool stateModified = false;
    if (state == MATERIAL_STATE_CREATING) {
        state = MATERIAL_STATE_UNAVAILABLE;
        stateModified = true;
    } else if (state == MATERIAL_STATE_UPDATING) {
        state = MATERIAL_STATE_NEED_UPDATE;
        stateModified = true;
    }

    if (stateModified) {
        SaveContentToConfigFile();
        LOGD("state has been modified, save to config file.");
    }
}

VOID HmcMaterialContent::CopyWithoutUid(const HmcMaterialContent &rh)
{
    type = rh.type;
    columnType = rh.columnType;
    state = rh.state;
    duration = rh.duration;
    downloadCnt = rh.downloadCnt;
    code = rh.code;
    contentId = rh.contentId;
    contentName = rh.contentName;
    previewUrl = rh.previewUrl;
    segments = rh.segments;
    intensity = rh.intensity;
    bgIntensity = rh.bgIntensity;
    positionX = rh.positionX;
    positionY = rh.positionY;
    createdTime = rh.createdTime;
    subType = rh.subType;
    previewFilePath = rh.previewFilePath;
    description = rh.description;
    checksum = rh.checksum;
    updateTime = rh.updateTime;
    minSDKVer = rh.minSDKVer;
    categoryId = rh.categoryId;
    categoryName = rh.categoryName;
    downloadUrl = rh.downloadUrl;
    downloadFilePath = rh.downloadFilePath;

    picList.clear();
    picList.insert(picList.begin(), rh.picList.begin(), rh.picList.end());
    params.clear();
    params.insert(params.begin(), rh.params.begin(), rh.params.end());
    cacheTime = rh.cacheTime;
}

VOID HmcMaterialContent::Clear()
{
    type = MATERIAL_CONTENT_TYPE_NONE;
    columnType = HMC_MATERIAL_COLUMN_BUTTOM;
    state = MATERIAL_STATE_UNAVAILABLE;
    columnUid = HMC_UID_NULL;
    isEncrypted = FALSE;
    duration = 0;
    downloadCnt = 0;
    segments = 0;
    intensity = 1.0f;
    bgIntensity = 1.0f;
    positionX = POSITION_X_DEFAULT_VALUE;
    positionY = POSITION_Y_DEFAULT_VALUE;
    subType = 0;
    code = "";
    contentId = "";
    contentName = "";
    previewUrl = "";
    previewFilePath = "";
    description = "";
    checksum = "";
    updateTime = "";
    minSDKVer = "";
    categoryId = "";
    categoryName = "";
    downloadUrl = "";
    downloadFilePath = "";
    picList.clear();
    params.clear();
    cacheTime = HmcGetCurrTimeMillSec();
    createdTime = HmcGetCurrTimeMillSec();
    version = PROGRAM_VERSION;
}

VOID HmcMaterialContent::SaveContentToConfigFile()
{
    STRING configFilePath = HmcMaterialUtil::GetContentSettingDir() + FILE_SEPARATOR_STR + contentId + JSON_FILE_SUFFIX;
    HmcStringSerialize(SerializeToString(), configFilePath);
    LOGD("Saved config file, config path: %s", configFilePath.c_str());
}

INT32 HmcMaterialContent::GetContentById(STRING contentId, HmcMaterialContent &content)
{
    if (contentId.empty()) {
        LOGE("contentId(%s) is empty.", contentId.c_str());
        return HMC_ERR_MATERIAL_PARAM;
    }

    // cache 中查找
    if (SINGLETON(HmcMaterialUidCache)->GetContentCache(contentId, content) == HMC_OK) {
        return HMC_OK;
    }

    LOGD("Can not find content from cache, going to find on disk.");
    // 本地存盘中查找
    if (LoadContent(contentId) != HMC_OK) {
        LOGW("Can not find content on disk. contentId: %s", contentId.c_str());
        return HMC_ERR;
    }

    // 存盘加载成功之后，继续从缓存获取，获取失败才叫异常
    if (SINGLETON(HmcMaterialUidCache)->GetContentCache(contentId, content) != HMC_OK) {
        LOGW("Get content failed after loading from disk");
        return HMC_ERR;
    }
    return HMC_OK;
}

INT32 HmcMaterialContent::GetContentFromCacheByCode(const STRING &code, HmcMaterialContent *content)
{
    if (code.empty()) {
        LOGE("code is empty.");
        return HMC_ERR_MATERIAL_PARAM;
    }

    STRING contentId;
    if (SINGLETON(HmcMaterialUidCache)->m_contentCodeCache.Get(code, contentId) != HMC_OK) {
        LOGE("content code(%s) does not exist in cache.", code.c_str());
        return HMC_ERR;
    }

    return GetContentById(contentId, *content);
}

INT32 HmcMaterialContent::LoadContentFromConfigFile(const STRING &contentId, HmcMaterialContent *content)
{
    if (contentId.empty()) {
        LOGE("id is empty");
        return HMC_ERR;
    }

    STRING configFilePath = HmcMaterialUtil::GetContentSettingDir() + FILE_SEPARATOR_STR + contentId + JSON_FILE_SUFFIX;
    Json::Value contentJson;
    if (HmcMaterialJsonUtil::LoadJsonFromFile(configFilePath, contentJson) != HMC_OK) {
        LOGW("get data from json failed, contentId:%s", contentId.c_str());
        LOGW("try to load material content from builtin material lib");
        configFilePath =
            HmcMaterialUtil::GetBuiltinContentSettingDir() + FILE_SEPARATOR_STR + contentId + JSON_FILE_SUFFIX;
        if (HmcMaterialJsonUtil::LoadJsonFromFile(configFilePath, contentJson) != HMC_OK) {
            LOGE("get data from builtin material json failed, contentId:%s", contentId.c_str());
            return HMC_ERR;
        }
    }

    content->contentId = contentId;
    content->DeserializeFromJson(contentJson);
    LOGD("Load content config from json, config path: %s", contentId.c_str());
    return HMC_OK;
}

INT32 HmcMaterialContent::LoadContent(const STRING &contentId)
{
    HmcMaterialContent content;
    if (HmcMaterialContent::LoadContentFromConfigFile(contentId, &content) != HMC_OK) {
        LOGW("load content from config failed, contentId: %s", contentId.c_str());
        return HMC_ERR;
    }

    SINGLETON(HmcMaterialUidCache)->AddContentCache(content);
    HmcMaterialUid::LoadUid(content.uid);
    SINGLETON(HmcMaterialUidCache)->AddContentCodeCache(content);

    return HMC_OK;
}

VOID HmcMaterialContent::DeleteContent() const
{
    SINGLETON(HmcMaterialUidCache)->DelContentCache(contentId);

    // 同步磁盘
    DeleteDiskFile();
}

VOID HmcMaterialContent::DeleteDiskFile() const
{
    // 删除海报目录
    STRING realPicDir = HmcMaterialUtil::GetMaterialLibraryPicDir() + FILE_SEPARATOR_STR + contentId;
    INT32 ret = HmcRemoveDirTree(realPicDir);
    LOGD("DELETE pic path ret:%d %s", ret, realPicDir.c_str());

    // 删除download目录
    STRING downContentDir = HmcMaterialUtil::GetMaterialLibraryDir() + FILE_SEPARATOR_STR + g_materialDefaultUserId +
        FILE_SEPARATOR_STR + contentId;
    ret = HmcRemoveDirTree(downContentDir);
    LOGD("DELETE down path ret:%d %s", ret, downContentDir.c_str());

    // 删除setting目录下的content文件
    STRING settingPath = HmcMaterialUtil::GetContentSettingDir() + FILE_SEPARATOR_STR + contentId + JSON_FILE_SUFFIX;
    ret = HmcFile::Remove(settingPath);
    LOGD("DELETE setting name path ret:%d %s", ret, settingPath.c_str());
}

void HmcMaterialContent::DeleteInvalidContent(const STRING &contentId)
{
    // 删除版本不对的content文件
    SINGLETON(HmcMaterialUidCache)->DelContentCache(contentId);
    // 同步磁盘
    // 删除setting目录下的content文件
    INT32 ret;
    STRING settingPath = HmcMaterialUtil::GetContentSettingDir() + FILE_SEPARATOR_STR + contentId + JSON_FILE_SUFFIX;
    ret = HmcFile::Remove(settingPath);
    LOGD("DELETE setting name path ret:%d %s", ret, settingPath.c_str());
}

bool HmcMaterialContent::IsExpired() const
{
    UINT64 currTime = HmcGetCurrTimeMillSec();
    LOGD("content:%s currTime: %llu, cacheTime: %llu.", contentId.c_str(), currTime, cacheTime);
    if (currTime - cacheTime > HMC_MATERIAL_CACHE_EXPIRE_TIME) {
        return true;
    }
    return false;
}