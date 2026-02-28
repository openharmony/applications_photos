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
#include "HmcMaterialJsonUtil.h"

INT32 HmcMaterialJsonUtil::HmcStringDeserializeMaterialPath(const STRING &filePath, STRING &string)
{
    return HmcStringDeserialize(filePath, string);
}

INT32 HmcMaterialJsonUtil::LoadJsonFromFile(const STRING &filePath, Json::Value &jsonValue)
{
    if (filePath.empty()) {
        LOGE("path or content is empty.");
        return HMC_ERR;
    }

    // 读取到json string
    STRING jsonDocument;
    if (HMC_OK != HmcStringDeserializeMaterialPath(filePath, jsonDocument)) {
        LOGW("cannot get json:%s!", filePath.c_str());
        return HMC_ERR;
    }

    return LoadJsonFromString(jsonDocument, jsonValue);
}

INT32 HmcMaterialJsonUtil::LoadJsonFromString(const STRING &contentStr, Json::Value &jsonValue)
{
    if (contentStr.empty()) {
        LOGE("path or content is empty.");
        return HMC_ERR;
    }
    std::istringstream iss;
    iss.str(contentStr);
    std::istream *streamPtr = &iss;
    Json::CharReaderBuilder builder;
    builder["collectComments"] = false;
    Json::String jsonError;
    if (!Json::parseFromStream(builder, *streamPtr, &jsonValue, &jsonError)) {
        LOGE("json parse failed: %s", jsonError.c_str());
        return HMC_ERR;
    }
    return HMC_OK;
}

INT32 HmcMaterialJsonUtil::LoadJsonFromNetString(const STRING &contentStr, Json::Value &jsonValue)
{
    if (contentStr.empty()) {
        LOGE("path or content is empty.");
        return HMC_ERR;
    }

    // 准备解析器，用唯一指针的目的是自动释放，且不需要共享
    Json::CharReaderBuilder builder;
    builder["collectComments"] = false;
    STRING jsonError;
    UNIQUE_PTR<Json::CharReader> const reader(builder.newCharReader());
    if (!reader->parse(contentStr.c_str(), (contentStr.c_str() + contentStr.length()), &jsonValue, &jsonError)) {
        LOGE("parse response body to json failed: %s", jsonError.c_str());
        return HMC_ERR;
    }

    return HMC_OK;
}

INT32 HmcMaterialJsonUtil::WriteJsonToFile(const STRING &filePath, const Json::Value &jsonValue)
{
    if (filePath.empty() || jsonValue.isNull()) {
        LOGE("path or json value is empty.");
        return HMC_ERR;
    }

    STRING jsonDocument = jsonValue.toStyledString();
    LOGD("json file path: %s", filePath.c_str());
    int ret = HmcStringSerialize(jsonDocument, filePath);
    if (HMC_OK != ret) {
        LOGE("Failed to save metadata file %s!", filePath.c_str());
    }

    return ret;
}

STRING HmcMaterialJsonUtil::ConvertJsonToStringUtf8(Json::Value &jsonValue)
{
    Json::StreamWriterBuilder builder;
    builder.settings_["indentation"] = "    "; // 4空格缩进
    builder.settings_["emitUTF8"] = true;      // 非UTF8编码填true
    return Json::writeString(builder, jsonValue);
}

const CHAR *HmcMaterialJsonUtil::HmcReadStringValue(const CHAR *string, const CHAR *name, CHAR *&value)
{
    if (string == nullptr || name == nullptr) {
        return nullptr;
    }

    auto p = strstr(string, name);
    if (!p) {
        return nullptr;
    }

    p += strlen(name);
    p = strchr(p, ':');
    if (!p) {
        return nullptr;
    }

    p = strchr(p + 1, '\"');
    if (!p) {
        return nullptr;
    }

    auto start = p + 1;
    auto end = strchr(start, '\"');
    if (!end) {
        return nullptr;
    }

    auto size = end - start;
    auto str = (CHAR *)HmcMalloc(size + 1);
    if (!str) {
        return nullptr;
    }

    if (memcpy_s(str, size + 1, start, size) != EOK) {
        LOGE("memcpy_s error");
    }
    str[size] = '\0';
    value = str;
    return end + 1;
}

const CHAR *HmcMaterialJsonUtil::HmcReadIntValue(const CHAR *string, const CHAR *name, INT32 &value)
{
    auto p = strstr(string, name);
    if (!p) {
        return nullptr;
    }

    p += strlen(name);
    p = strchr(p, ':');
    if (!p) {
        return nullptr;
    }

    CHAR *end = nullptr;
    const UINT32 num = 10;
    value = (INT32)strtol(p + 1, &end, num);
    return end;
}
