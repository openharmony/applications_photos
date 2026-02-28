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
#include "HmcService.h"
#include "MediaCreative.h"

IMPLEMENT_SINGLETON(HmcProjectEntity)

const STRING FAILED = "FAILED";
const STRING SUCCESS = "SUCCESS";

HmcProjectEntity::HmcProjectEntity()
{
    InitEntity();
}

void HmcProjectEntity::HmcProjectEntityClear()
{
    LOGD("HmcProjectEntityClear input ");
    if (!m_projectJson.isNull()) {
        m_projectJson.clear();
    }
    if (!m_editDataJson.isNull()) {
        m_editDataJson.clear();
    }
}

VOID HmcProjectEntity::InitEntity() {}

std::string HmcProjectEntity::GetEditData(const Json::Value &laneData, const Json::Value &timeLine)
{
    Json::Value value;

    // 保存包名版本号
    value[PROJECT_KEY_EDITOR_SIGNATURE_KEY] = PROJECT_KEY_EDITOR_SIGNATURE_VALUE;

    // 保存 lanemanager 和 preview 数据
    if (!m_projectJson[PROJECT_KEY_LANE_MODULE_KEY].isNull()) {
        value[PROJECT_KEY_LANE_MODULE_KEY] = m_projectJson[PROJECT_KEY_LANE_MODULE_KEY];
    }
    if (!m_projectJson[PROJECT_KEY_TIME_LINE_KEY].isNull()) {
        value[PROJECT_KEY_TIME_LINE_KEY] = m_projectJson[PROJECT_KEY_TIME_LINE_KEY];
    }

    if (&laneData != &Json::Value::nullSingleton()) {
        value[PROJECT_KEY_LANE_MODULE_KEY] = laneData;
    }

    if (&timeLine != &Json::Value::nullSingleton()) {
        value[PROJECT_KEY_TIME_LINE_KEY] = timeLine;
    }

    m_projectJson = value;
    m_editDataJson = value;

    return Json::FastWriter().write(m_editDataJson);
}

VOID HmcProjectEntity::SetVersion(const STRING &version)
{
    m_version = version;
}

STRING HmcProjectEntity::GetVersion()
{
    return m_version;
}

int HmcProjectEntity::SetUserData(const HmcUid &objUid, HmcDict *dict)
{
    HmcDict *dictDmp = HmcDictDuplicate(dict);
    m_userData = dictDmp;
    return HMC_OK;
}

int HmcProjectEntity::GetUserData(const HmcUid &objUid, HmcDict **poutDict)
{
    HmcDict *dictTmp = nullptr;
    dictTmp = m_userData;

    if (dictTmp) {
        *poutDict = HmcDictDuplicate(dictTmp);
    } else {
        *poutDict = HmcDictCreate();
    }

    return HMC_OK;
}

void HmcProjectEntity::UserDataDeserialize(Json::Value jsonRoot)
{
    HmcUid uid = HMC_UID_NULL;
    Json::Value userdataList = jsonRoot[PROJECT_KEY_USERDATA];
    m_userData = HmcDictDeserialize(userdataList[PROJECT_KEY_USERDATA_DICT].asString().c_str());
}

Json::Value HmcProjectEntity::UserDataSerialize()
{
    Json::Value userdataValue;
    auto userDataStr = HmcDictSerialize(m_userData);
    if (userDataStr) {
        userdataValue[PROJECT_KEY_USERDATA_DICT] = userDataStr;
    }
    return userdataValue;
}

static VOID UpdateValue(Json::Value &v, const std::string &key, const std::string &keyValue)
{
    std::string strOld;
    if (!JsonValueUtil::ParseValueIfHas(v, key, strOld)) {
        return;
    }
    if (key == DICT_KEY_ASSET_PROPERTY_PATH) {
        LOGD("UpdateValue %s from %s to %s", key.c_str(), strOld.c_str(), keyValue.c_str());
        if (strOld != keyValue) {
            v[key] = keyValue;
        }
    }
}

std::string HmcProjectEntity::UpdateJsonStringValue(Json::Value &v, const std::string &key, const std::string &keyValue)
{
    Json::Value::Members mem = v.getMemberNames();
    // 深度递归搜索
    for (auto &it : mem) {
        Json::ValueType type = v[it].type();
        if (type == Json::objectValue) {
            UpdateJsonStringValue(v[it], key, keyValue);
        } else if (type == Json::arrayValue) {
            for (auto &i : v[it]) {
                UpdateJsonStringValue(i, key, keyValue);
            }
        } else if (type == Json::stringValue) {
            UpdateValue(v, key, keyValue);
        }
    }
    return v.toStyledString();
}

VOID HmcProjectEntity::SetProjectJson(Json::Value &json)
{
    m_projectJson = json;
    m_editDataJson = json;
}

Json::Value HmcProjectEntity::GetLaneJson() const
{
    Json::Value laneJson;
    if (m_editDataJson.isMember(PROJECT_KEY_LANE_MODULE_KEY) &&
        m_editDataJson[PROJECT_KEY_LANE_MODULE_KEY].isObject()) {
        laneJson = m_editDataJson[PROJECT_KEY_LANE_MODULE_KEY];
    }

    return laneJson;
}

Json::Value HmcProjectEntity::GetPreviewJson() const
{
    Json::Value timeLineJson;
    if (m_editDataJson.isMember(PROJECT_KEY_TIME_LINE_KEY) && m_editDataJson[PROJECT_KEY_TIME_LINE_KEY].isObject()) {
        timeLineJson = m_editDataJson[PROJECT_KEY_TIME_LINE_KEY];
    }

    return timeLineJson;
}

bool HmcProjectEntity::CheckHMCEditorDataSignature(const Json::Value &jsonEditData)
{
    if (!jsonEditData.isMember(PROJECT_KEY_EDITOR_SIGNATURE_KEY) ||
        !jsonEditData[PROJECT_KEY_EDITOR_SIGNATURE_KEY].isString()) {
        LOGE("can not find valid signature filed(%s).", PROJECT_KEY_EDITOR_SIGNATURE_KEY);
        return false;
    }

    std::string editorSignature = jsonEditData[PROJECT_KEY_EDITOR_SIGNATURE_KEY].asString();
    if (editorSignature != PROJECT_KEY_EDITOR_SIGNATURE_VALUE) {
        LOGE("editor signature is invalid, only support %s, but real signature is: %s",
            PROJECT_KEY_EDITOR_SIGNATURE_VALUE, editorSignature.c_str());
        return false;
    }

    return true;
}

bool HmcProjectEntity::CheckImageEffectEditorDataSignature(const Json::Value &jsonEditData)
{
    // 这里先帮美颜改一下
    if (!jsonEditData.isMember("imageEffect") ||
        (!jsonEditData["imageEffect"].isArray() && !jsonEditData["imageEffect"].isObject())) {
        LOGE("can not find valid signature filed(%s).", PROJECT_KEY_EDITOR_SIGNATURE_KEY);
        return false;
    }
    return true;
}

bool HmcProjectEntity::CheckSystemEditorDataSignature(const Json::Value &jsonEditData)
{
    // 检查旧编辑接口数据
    if (!jsonEditData.isMember("system") || !jsonEditData["system"].isObject()) {
        LOGE("can not find valid signature filed(%s).", PROJECT_KEY_EDITOR_SIGNATURE_KEY);
        return false;
    }
    return true;
}

bool HmcProjectEntity::CheckThirdEditorDataSignature(const Json::Value &jsonEditData)
{
    // 检查旧编辑接口数据
    if (!jsonEditData.isMember("third") || !jsonEditData["third"].isObject()) {
        LOGE("can not find valid signature filed(%s).", PROJECT_KEY_EDITOR_SIGNATURE_KEY);
        return false;
    }
    return true;
}

bool HmcProjectEntity::IsSystemEditData(const std::string &data)
{
    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(data, jsonEditData);
    if (!parseResult) {
        LOGE("check edit data failed, data is not valid json format.");
        return false;
    }
    if (jsonEditData.isMember("system") && jsonEditData["system"].isObject()) {
        return true;
    }
    return false;
}

bool HmcProjectEntity::IsThirdEditData(const std::string &data)
{
    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(data, jsonEditData);
    if (!parseResult) {
        LOGE("check edit data failed, data is not valid json format.");
        return false;
    }
    if (jsonEditData.isMember("third") && jsonEditData["third"].isObject()) {
        return true;
    }
    return false;
}

bool HmcProjectEntity::HasWatermarkEffect(const std::string &data, std::function<void(std::string const &jsonPos)> cb)
{
    size_t maxLineLength = 2000;
    size_t pos = 0;
    size_t len = data.length();
    while (pos < len) {
        size_t end = std::min(pos + maxLineLength, len);
        std::string line = data.substr(pos, end - pos);
        LOGI("HmcProjectEntity::HasWatermarkEffect. data:%s", line.c_str());
        pos = end;
    }
    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(data, jsonEditData);
    if (!parseResult) {
        LOGE("check edit data failed, data is not valid json format.");
        return false;
    }
    if (!jsonEditData.isMember("imageEffect")) {
        LOGE("can not find imageEffect tag.");
        return false;
    }
    Json::Value imageEffect = jsonEditData["imageEffect"];
    Json::Value jsonFilters = imageEffect["filters"];
    for (const auto &filter : jsonFilters) {
        std::string filterName = filter["name"].asString();
        Json::Value values = filter["values"];
        if (cb == nullptr) {
            return true;
        }
        Json::Value result;
        result["stickerType"] = filterName;
        Json::FastWriter fastWrite;
        cb(fastWrite.write(result));
        LOGI("HmcProjectEntity::HasWatermarkEffect.  result:%s", fastWrite.write(result).c_str());
        return true;
    }
    return false;
}

DOUBLE HmcProjectEntity::GetCropRotation(const std::string &data)
{
    LOGI("HmcProjectEntity::GetCropRotation.  data:%s", data.c_str());
    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(data, jsonEditData);
    if (!parseResult) {
        LOGE("check edit data failed, data is not valid json format.");
        return 0;
    }
    if (!jsonEditData.isMember("imageEffect")) {
        LOGE("can not find imageEffect tag.");
        return 0;
    }
    Json::Value imageEffect = jsonEditData["imageEffect"];
    Json::Value jsonFilters = imageEffect["filters"];
    double cropRotation = 0;
    for (const auto &filter : jsonFilters) {
        if (!JsonValueUtil::IsString(filter, "name")
            || filter["name"].asString().compare("HMCEFilter") != 0) {
            continue;
        }
        if (!JsonValueUtil::IsMemberAndNotNull(filter, "values")) {
            continue;
        }
        Json::Value jsonValues = filter["values"];
        JsonValueUtil::ParseValueIfHas(jsonValues, PROJECT_KEY_TRANSFORM_ROTATION_Z, cropRotation);
        break;
    }
    return cropRotation;
}

void HmcProjectEntity::ApplyEditData(const std::string &data)
{
    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(data, jsonEditData);
    if (!parseResult) {
        LOGE("parse data failed, please make sure that edit-data is valid json format.");
        return;
    }

    if (!CheckHMCEditorDataSignature(jsonEditData)) {
        LOGE("signature of edit-data is invalid.");
        return;
    }

    m_editDataJson = jsonEditData;
}

/**
 * 检测当前图片，是否是个性风格照片
 * @param data
 * @return
 */
STRING HmcProjectEntity::HasXTStyleEffect(const std::string &data)
{
    LOGI("HmcProjectEntity::HasXTStyleEffect. data:%s", data.c_str());
    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(data, jsonEditData);
    Json::Value result;
    Json::FastWriter fastWrite;
    if (!parseResult) {
        LOGE("HmcProjectEntity::HasXTStyleEffect check edit data failed, data is not valid json format.");
        result["errorCode"] = FAILED;
        return fastWrite.write(result);
    }
    if (!jsonEditData.isMember("imageEffect")) {
        LOGE("HmcProjectEntity::HasXTStyleEffect can not find imageEffect tag.");
        result["errorCode"] = FAILED;
        return fastWrite.write(result);
    }
    
    Json::Value imageEffect = jsonEditData["imageEffect"];
    Json::Value jsonFilters = imageEffect["filters"];

    for (const auto &filter : jsonFilters) {
        if (XTSTYLE_FILTER_NAME != filter["name"].asString()) {
            continue;
        }

        Json::Value values = filter["values"];
        INT32 type = -1;
        INT32 colorTemperature = 0;
        INT32 saturation = 0;
        INT32 lightShadow = 0;
        INT32 createMode = 0;
        
        JsonValueUtil::ParseValueIfHas(values, PROJECT_KEY_XTSTYLE_TYPE, type);
        ParseXTStyleDenormalizeValue(values, PROJECT_KEY_XTSTYLE_COLOR_TEMPERATURE, colorTemperature,
            XTSTYLE_MIN_COLOR_TEMPERATURE_VALUE, XTSTYLE_MAX_COLOR_TEMPERATURE_VALUE);
        ParseXTStyleDenormalizeValue(values, PROJECT_KEY_XTSTYLE_SATURATION, saturation,
            XTSTYLE_MIN_SATURATION_VALUE, XTSTYLE_MAX_SATURATION_VALUE);
        ParseXTStyleDenormalizeValue(values, PROJECT_KEY_XTSTYLE_LIGHT_AND_SHADOW, lightShadow,
            XTSTYLE_MIN_LIGHT_SHADOW_VALUE, XTSTYLE_MAX_LIGHT_SHADOW_VALUE);
        JsonValueUtil::ParseValueIfHas(values, PROJECT_KEY_XTSTYLE_CREATE_MODE, createMode);
        
        result["errorCode"] = SUCCESS;
        result[PROJECT_KEY_XTSTYLE_TYPE] = type;
        result[PROJECT_KEY_XTSTYLE_COLOR_TEMPERATURE] = colorTemperature;
        result[PROJECT_KEY_XTSTYLE_SATURATION] = saturation;
        result[PROJECT_KEY_XTSTYLE_LIGHT_AND_SHADOW] = lightShadow;
        result[PROJECT_KEY_XTSTYLE_CREATE_MODE] = createMode;
        
        LOGI("HmcProjectEntity::HasXTStyleEffect.  result:%s", fastWrite.write(result).c_str());
        return fastWrite.write(result);
    }
    result["errorCode"] = FAILED;
    return fastWrite.write(result);
}

VOID HmcProjectEntity::ParseXTStyleDenormalizeValue(const Json::Value &jsonData, const char *parameterName,
    INT32 &destValue, INT32 minValue, INT32 maxValue)
{
    float normalizeValue = 0.0f;
    if (JsonValueUtil::ParseFloatIfHas(jsonData, parameterName, normalizeValue)) {
        normalizeValue = jsonData[parameterName].asFloat();
        destValue = normalizeValue * (maxValue - minValue) + minValue;
        LOGI("HasXTStyleEffect set HasXTStyleEffect value %s to: %d", parameterName, destValue);
    }
}