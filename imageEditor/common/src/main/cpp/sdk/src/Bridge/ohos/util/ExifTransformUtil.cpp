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
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "ExifTransformUtil.h"
#include "ohos/undoredo/HveFastTransform.h"
#include "string/HmcString.h"

void ExifTransformUtil::ProcessExifOnExist(HveTimeline *timeline, HmcUid &assetUid, bool reEdit, bool revert,
    bool isReset)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGW("ProcessExifOnExist IHmcAsset get error, return null, assetUid: %s", HmcUidToString(&assetUid).c_str());
        return;
    }
    const STRING orientationValue = asset->GetOrientation();
    LOGI("ProcessExifOnExist get EXIF Orientation value: %s, reEdit: %d, revert: %d, isReset: %d",
         orientationValue.c_str(), reEdit, revert, isReset);
    if (orientationValue != "") {
        HveFastTransform transformer(timeline, assetUid, reEdit, revert, isReset);
        if (revert) {
            transformer.RevertOrientation(orientationValue);
        } else {
            transformer.ProcessOrientation(orientationValue);
        }
    }
}

STRING ExifTransformUtil::ProcessExifOnExistForPixelmap(HmcUid &assetUid, OH_PixelmapNative *pixelmap,
    STRING orientation)
{
    LOGI("ProcessExifOnExistForPixelmap pixelMap begin");
    STRING orientationValue = "";
    if (orientation == "") {
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
        if (asset == nullptr) {
            LOGW("ProcessExifOnExistForPixelmap IHmcAsset get error, return null, assetUid: %s",
                 HmcUidToString(&assetUid).c_str());
            return "";
        }
        orientationValue = asset->GetOrientation();
    } else {
        orientationValue = orientation;
    }
    LOGI("ProcessExifOnExistForPixelmap get EXIF Orientation value: %s", orientationValue.c_str());
    
    if (orientationValue == "" || orientationValue == "Top-left") {
        return "";
    }
    
    bool horizontal = false;
    bool vertical = false;
    float rotateValue = 0.0;
    
    if (orientationValue == "Right-top") {
        rotateValue = -EXIF_ROTATE_90;
    }
    if (orientationValue == "Left-bottom") {
        rotateValue = EXIF_ROTATE_90;
    }
    if (orientationValue == "Bottom-right") {
        rotateValue = EXIF_ROTATE_180;
    }
    if (orientationValue == "Top-right") {
        horizontal = true;
    }
    if (orientationValue == "Bottom-left") {
        vertical = true;
    }
    if (orientationValue == "Left-top") {
        rotateValue = -EXIF_ROTATE_90;
        horizontal = true;
    }
    if (orientationValue == "Right-bottom") {
        rotateValue = EXIF_ROTATE_90;
        vertical = true;
    }
    DoMirrorOrRotate(pixelmap, horizontal, vertical, rotateValue);
    return orientationValue;
}

void ExifTransformUtil::DoMirrorOrRotate(OH_PixelmapNative *pixelmap, bool horizontal, bool vertical, float rotateValue)
{
    if (std::fabs(rotateValue) > EPSILON) {
        OH_PixelmapNative_Rotate(pixelmap, rotateValue);
    }
    if (horizontal || vertical) {
        OH_PixelmapNative_Flip(pixelmap, horizontal, vertical);
    }
}

STRING ExifTransformUtil::ProcessExifOnExistForPicture(HmcUid &assetUid, OH_PictureNative *picture, STRING orientation)
{
    STRING orientationValue = "";
    if(picture == nullptr) {
        LOGE("ProcessExifOnExistForPicture picture is NULL.");
        return orientationValue;
    }
    if (orientation == "") {
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
        if (asset == nullptr) {
            LOGW("ProcessExifOnExistForPicture IHmcAsset get error, return null, assetUid: %s",
                 HmcUidToString(&assetUid).c_str());
            return "";
        }
        orientationValue = asset->GetOrientation();
    } else {
        orientationValue = orientation;
    }
    LOGI("ProcessExifOnExistForPicture get EXIF Orientation value: %s", orientationValue.c_str());
    
    if (orientationValue == "" || orientationValue == "Top-left") {
        return "";
    }
    OH_PixelmapNative *mainPixelmap;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(picture, &mainPixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || mainPixelmap == nullptr) {
        LOGE("GetMainPixelmap fail! errorCode=%d", errorCode);
        return orientationValue;
    }
    ProcessExifOnExistForPixelmap(assetUid, mainPixelmap, orientationValue);
    OH_PixelmapNative_Release(mainPixelmap);
    OH_PixelmapNative *gainMap;
    errorCode = OH_PictureNative_GetGainmapPixelmap(picture, &gainMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || gainMap == nullptr) {
        LOGI("GainMapPixelmap not exist! code=%d", errorCode);
        return orientationValue;
    }
    ProcessExifOnExistForPixelmap(assetUid, gainMap, orientationValue);
    OH_PixelmapNative_Release(gainMap);
    PictureUtil::UpdateMetaData(picture);
    return orientationValue;
}