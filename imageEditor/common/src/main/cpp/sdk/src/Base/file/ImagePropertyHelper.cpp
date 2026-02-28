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

#include "ImagePropertyHelper.h"
#include "log/HmcLog.h"
#include <multimedia/image_framework/image/image_source_native.h>

STRING ImagePropertyHelper::GetImageProperty(const STRING path, const STRING propertyKey)
{
    LOGI("GetImageProperty propertyKey: %s", propertyKey.c_str());
    OH_ImageSourceNative *imageSource = nullptr;
    Image_ErrorCode errorCode =
        OH_ImageSourceNative_CreateFromUri(const_cast<char *>(path.c_str()), path.size(), &imageSource);
    LOGI("GetImageProperty ImageSourceNative result code: %d", errorCode);
    STRING value = "";
    if (Image_ErrorCode::IMAGE_SUCCESS == errorCode) {
        value = ImagePropertyHelper::GetImageProperty(imageSource, propertyKey);
    }
    OH_ImageSourceNative_Release(imageSource);
    return value;
}

STRING ImagePropertyHelper::GetImageProperty(const INT32 fd, const STRING propertyKey)
{
    LOGI("GetImageProperty propertyKey: %s, fd: %d", propertyKey.c_str(), fd);
    if (fd == -1) {
        LOGW("GetImageProperty fd param error.");
        return "";
    }
    OH_ImageSourceNative *imageSource = nullptr;
    Image_ErrorCode errorCode = OH_ImageSourceNative_CreateFromFd(fd, &imageSource);
    LOGD("GetImageProperty ImageSourceNative result code: %d", errorCode);
    STRING value = "";
    if (Image_ErrorCode::IMAGE_SUCCESS == errorCode) {
        value = ImagePropertyHelper::GetImageProperty(imageSource, propertyKey);
    }
    OH_ImageSourceNative_Release(imageSource);
    return value;
}

STRING ImagePropertyHelper::GetImageProperty(const OH_ImageSourceNative *imageSource, const STRING propertyKey)
{
    Image_String value = {.data = nullptr, .size = 0};
    Image_String key = {const_cast<char *>(propertyKey.c_str()), size_t(propertyKey.size())};
    Image_ErrorCode ret_code =
        OH_ImageSourceNative_GetImageProperty(const_cast<OH_ImageSourceNative *>(imageSource), &key, &value);
    LOGD("GetImageProperty result code: %d", ret_code);
    if (ret_code == Image_ErrorCode::IMAGE_SUCCESS) {
        std::string oriValue = std::string(value.data, value.size);
        LOGI("GetImageProperty result: %s", oriValue.c_str());
        free(value.data);
        value.data = nullptr;
        return oriValue;
    }
    return "";
}

VECTOR<STRING> ImagePropertyHelper::GetImageProperties(const INT32 fd, VECTOR<STRING> keys)
{
    if (keys.size() <= 0) {
        return {};
    }
    OH_ImageSourceNative *imageSource = nullptr;
    if (fd == -1 ||
        OH_ImageSourceNative_CreateFromFd(fd, &imageSource) != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGW("GetImageProperty fd param error.");
        return {};
    }
    
    VECTOR<STRING> result;
    for (auto it = keys.begin(); it != keys.end(); it++) {
        auto keyStr  = *it;
        result.push_back(ImagePropertyHelper::GetImageProperty(imageSource, keyStr));
    }
    OH_ImageSourceNative_Release(imageSource);
    return result;
}
