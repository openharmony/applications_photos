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
#ifndef HMCPROJECTENTITY_H
#define HMCPROJECTENTITY_H

#ifdef __cplusplus

#include <json/json.h>
#include "../Material/HmcMaterialUtil.h"

class HmcProjectEntity {
public:
    DECLARE_SINGLETON(HmcProjectEntity);
    HmcProjectEntity();

public:
    void InitEntity();
    std::string GetEditData(const Json::Value &laneData = Json::Value::nullRef,
        const Json::Value &timeLine = Json::Value::nullRef);

    std::string GetVersion();
    void SetVersion(const std::string &version);

    void SetProjectJson(Json::Value &json);
    Json::Value GetLaneJson() const;
    Json::Value GetPreviewJson() const;

    int SetUserData(const HmcUid &objUid, HmcDict *dict);
    int GetUserData(const HmcUid &objUid, HmcDict **dict);
    void UserDataDeserialize(Json::Value jsonRoot);
    Json::Value UserDataSerialize();

    void HmcProjectEntityClear();

    static bool HasWatermarkEffect(const std::string &data, std::function<void(std::string const &jsonPos)> cb);
    static DOUBLE GetCropRotation(const std::string &data);
    
    static STRING HasXTStyleEffect(const std::string &data);

    static bool IsSystemEditData(const std::string &data);
    static bool IsThirdEditData(const std::string &data);
    void ApplyEditData(const std::string &data);
    std::string UpdateJsonStringValue(Json::Value &v, const std::string &key, const std::string &keyValue);

    static bool CheckHMCEditorDataSignature(const Json::Value &jsonEditData);
    static bool CheckImageEffectEditorDataSignature(const Json::Value &jsonEditData);
    static bool CheckSystemEditorDataSignature(const Json::Value &jsonEditData);
    static bool CheckThirdEditorDataSignature(const Json::Value &jsonEditData);
    
private:
    static VOID ParseXTStyleDenormalizeValue(const Json::Value &jsonData, const char *parameterName, INT32 &destValue,
                                             INT32 minValue, INT32 maxValue);

private:
    STRING m_version; // 草稿版本

    HmcDict *m_userData{ nullptr }; // 用户自定义数据

    BOOL m_isInitTotally{ FALSE }; // 草稿是否完全初始化

    Json::Value m_projectJson;
    Json::Value m_initialEditdataJson;
    Json::Value m_editDataJson;
};

#endif // __cplusplus

#endif // HMCPROJECTENTITY_H
