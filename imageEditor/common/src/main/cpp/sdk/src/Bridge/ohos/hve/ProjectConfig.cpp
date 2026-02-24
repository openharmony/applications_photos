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

#include "ProjectConfig.h"

#include "log/HmcLog.h"

std::once_flag ProjectConfig::m_once;

ProjectConfig &ProjectConfig::Instance()
{
    static ProjectConfig prjConfig;
    std::call_once(m_once, [] {
        prjConfig.Init();
    });
    return prjConfig;
}

void ProjectConfig::Init()
{
    m_handleFuncs["UltraPhoto"] = [this](const STRING &value)->bool { return SetUltraPhoto(value); };
    m_handleFuncs["EditEffectMode"] = [this](const STRING &value)->bool { return SetEditEffectMode(value); };
    m_handleFuncs["HdrShownOpen"] = [this](const STRING &value)->bool { return SetHdrShownOpen(value); };
    m_handleFuncs["HideWatermarkResource"] =
        [this](const STRING &value)->bool { return SetHideWatermarkResource(value); };
    m_handleFuncs["ImageQuality"] = [this](const STRING &value)->bool { return SetImageQuality(value); };
    m_handleFuncs["MimeType"] = [this](const STRING &value)->bool { return SetMimeType(value); };
    m_handleFuncs["AiWatermarkEnabled"] =
        [this](const STRING &value)->bool { return SetIsAiWatermarkEnabled(value); };
    m_handleFuncs["ReEdit"] = [this](const STRING &value)->bool {return SetReEdit(value); };
    m_handleFuncs["SupportUltraPhoto"] = [this](const STRING &value)->bool { return SetSupportUltraPhoto(value); };
    m_handleFuncs["FromMovingAndIsUltraPhoto"] =
        [this](const STRING &value)->bool { return SetFromMovingAndIsUltraPhoto(value); };
    m_handleFuncs["ExportFromBrowser"] = [this](const STRING &value)->bool { return SetExportFromBrowser(value); };
    m_handleFuncs["DecodeScale"] = [this](const STRING &value)->bool { return SetDecodeScale(value); };
}

bool ProjectConfig::SetValueByKey(const STRING &key, const STRING &value)
{
    LOGI("ProjectConfig SetValueByKey key = %s, value = %s", key.c_str(), value.c_str());
    std::lock_guard<std::mutex> lock(m_mutex);
    auto it = m_handleFuncs.find(key);
    if (it != m_handleFuncs.end()) {
        return it->second(value);
    }
    return false;
}

bool ProjectConfig::SetHdrShownOpen(const STRING &isHdrShownOpen)
{
    return ParseAndSetBoolValue(isHdrShownOpen, m_isHdrShownOpen);
}

bool ProjectConfig::IsHdrShownOpen() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_isHdrShownOpen;
}

bool ProjectConfig::SetImageQuality(const STRING &imageQuality)
{
    return ParseAndSetIntValue(imageQuality, m_imageQuality);
}

int ProjectConfig::GetImageQuality() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_imageQuality;
}

bool ProjectConfig::SetHideWatermarkResource(const STRING &hideWatermarkResource)
{
    return ParseAndSetBoolValue(hideWatermarkResource, m_isHideWatermarkResource);
}

bool ProjectConfig::IsHideWatermarkResource() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_isHideWatermarkResource;
}

bool ProjectConfig::SetEditEffectMode(const STRING &mode)
{
    int effectMode = 0;
    bool res = ParseAndSetIntValue(mode, effectMode);
    CHECK_AND_RETURN_RET_LOG(res == true, false, "ProjectConfig SetEditEffectMode failed");
    CHECK_AND_RETURN_RET_LOG(effectMode >= 0 && effectMode < static_cast<int>(EditEffectMode::MAX_SIZE), false,
        "ProjectConfig SetEditEffectMode value illegal, value = %d", effectMode);
    m_editEffectMode = static_cast<EditEffectMode>(effectMode);
    return true;
}

EditEffectMode ProjectConfig::GetEditEffectMode() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_editEffectMode;
}

bool ProjectConfig::SetUltraPhoto(const STRING &isUltraPhoto)
{
    return ParseAndSetBoolValue(isUltraPhoto, m_isUltraPhoto);
}

bool ProjectConfig::SetSupportUltraPhoto(const STRING &isUltraPhoto)
{
    return ParseAndSetBoolValue(isUltraPhoto, m_isSupportUltraPhoto);
}

bool ProjectConfig::IsUltraPhoto() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_isUltraPhoto;
}

bool ProjectConfig::IsSupportUltraPhoto() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_isSupportUltraPhoto;
}

bool ProjectConfig::SetReEdit(const STRING &isEdit)
{
    return ParseAndSetBoolValue(isEdit, m_isEdit);
}

bool ProjectConfig::IsEdit() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_isEdit;
}

void ProjectConfig::DeInit()
{
    std::lock_guard<std::mutex> lock(m_mutex);
    m_isHdrShownOpen = true;
    m_imageQuality = QUALITY_DEFAULT;
    m_isHideWatermarkResource = false;
    m_isAiWatermarkEnabled = false;
    m_editEffectMode = EditEffectMode::NONE;
    m_isUltraPhoto = false;
    m_isSupportUltraPhoto = false;
    m_isEdit = false;
    m_mimeType = "";
    m_isFromMovingAndIsUltraPhoto = false;
    m_isExportFromBrowser = false;
    m_decodeScale = 1.0;
}

bool ProjectConfig::isNumber(const STRING& str) {
    if (str.empty()) {
        return false;
    }
    for (char c : str) {
        if (!std::isdigit(c)) {
            return false;
        }
    }
    return true;
}

bool ProjectConfig::ParseAndSetBoolValue(const STRING &srcValue, bool &dstValue)
{
    if ("1" == srcValue) {
        dstValue = true;
    } else if ("0" == srcValue) {
        dstValue = false;
    } else {
        LOGE("ProjectConfig ParseAndSetBoolValue failed, value = %s", srcValue.c_str());
        return false;
    }
    return true;
}

bool ProjectConfig::ParseAndSetIntValue(const STRING &srcValue, int &dstValue)
{
    if (!isNumber(srcValue)) {
        LOGE("ProjectConfig ParseAndSetIntValue failed, mode = %s", srcValue.c_str());
        return false;
    }
    try {
        dstValue = std::stoi(srcValue);
    } catch (const std::exception& e) {
        LOGE("ProjectConfig ParseAndSetIntValue failed, %s", e.what());
        return false;
    }
    return true;
}

bool ProjectConfig::ParseAndSetFloatValue(const STRING &srcValue, float &dstValue)
{
    try {
        dstValue = std::stof(srcValue);
    } catch (const std::exception& e) {
        LOGE("ProjectConfig ParseAndSetFloatValue failed, %s", e.what());
        return false;
    }
    return true;
}

bool ProjectConfig::SetMimeType(const STRING &mimeType)
{
    m_mimeType = mimeType;
    return true;
}

STRING ProjectConfig::GetMimeType() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_mimeType;
}

bool ProjectConfig::SetIsAiWatermarkEnabled(const STRING &isAiWatermarkEnabled)
{
    return ParseAndSetBoolValue(isAiWatermarkEnabled, m_isAiWatermarkEnabled);
}

bool ProjectConfig::IsAiWatermarkEnabled() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_isAiWatermarkEnabled;
}

bool ProjectConfig::SetFromMovingAndIsUltraPhoto(const STRING &isUltraPhoto)
{
    return ParseAndSetBoolValue(isUltraPhoto, m_isFromMovingAndIsUltraPhoto);
}

bool ProjectConfig::IsFromMovingAndIsUltraPhoto() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_isFromMovingAndIsUltraPhoto;
}

bool ProjectConfig::IsExportFromBrowser() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_isExportFromBrowser;
}
 
bool ProjectConfig::SetExportFromBrowser(const STRING &exportMode)
{
    return ParseAndSetBoolValue(exportMode, m_isExportFromBrowser);
}

FLOAT ProjectConfig::GetDecodeScale() const
{
    std::lock_guard<std::mutex> lock(m_mutex);
    return m_decodeScale;
}

bool ProjectConfig::SetDecodeScale(const STRING &scale)
{
    return ParseAndSetFloatValue(scale, m_decodeScale);
}