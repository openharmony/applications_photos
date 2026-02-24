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

#include "PictureUtil.h"
#include <sstream>
#include "log/HmcLog.h"
#include "ohos/jscaller/DataAbilityHelper.h"

constexpr const float MIN_SCALE = 0.001;
constexpr const int HMC_ERR = -1;
constexpr const int HMC_OK = 0;

void PictureUtil::CopyAllMetadata(OH_PictureNative *srcPicture, OH_PictureNative *destPicture)
{
    int allMetadataTypes[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
    // copy 所有的Image_MetadataType 需要通过该方式绕开上库限制
    for (int enumVal : allMetadataTypes) {
        CopyMetaData(srcPicture, destPicture, static_cast<Image_MetadataType>(enumVal));
    }
}

void PictureUtil::CopyMetaData(OH_PictureNative *srcPicture, OH_PictureNative *destPicture,
    std::initializer_list<Image_MetadataType> metadataTypes)
{
    for (auto type : metadataTypes) {
        CopyMetaData(srcPicture, destPicture, type);
    }
}

void PictureUtil::CopyMetaData(OH_PictureNative *srcPicture, OH_PictureNative *destPicture,
    Image_MetadataType metadataType)
{
    OH_PictureMetadata *xt = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMetadata(srcPicture, metadataType, &xt);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || xt == nullptr) {
        LOGE("CopyMetaData OH_PictureNative_GetMetadata %d fail! errorCode=%d", metadataType, errorCode);
        return;
    }
    OH_PictureMetadata *outxt = nullptr;
    errorCode = OH_PictureMetadata_Clone(xt, &outxt);
    OH_PictureMetadata_Release(xt);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || outxt == nullptr) {
        LOGE("CopyMetaData OH_PictureMetadata_Clone %d fail! errorCode=%d", metadataType, errorCode);
        return;
    }
    errorCode = OH_PictureNative_SetMetadata(destPicture, metadataType, outxt);
    OH_PictureMetadata_Release(outxt);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyMetaData OH_PictureNative_SetMetadata %d fail! errorCode=%d", metadataType, errorCode);
    }
    LOGI("PictureUtil CopyMetaData success metadataType = %d", metadataType);
}

STRING PictureUtil::getCurrentTimeString(const std::string& format) {
    using namespace std::chrono;
    auto now = system_clock::now();
    std::time_t t = system_clock::to_time_t(now);

    std::tm tm{};
#if defined(_WIN32) || defined(_WIN64)
    localtime_s(&tm, &t); // Windows
#else
    localtime_r(&t, &tm); // Linux / macOS
#endif

    std::ostringstream oss;
    oss << std::put_time(&tm, format.c_str());
    return oss.str();
}

void PictureUtil::DumpPicture(OH_PictureNative *picture, std::string key)
{
    if (picture == nullptr) {
        LOGE("PictureUtil DumpPicture failed");
        return;
    }
    key = getCurrentTimeString() + "_" + key;
    DumpPictureMain(picture, key + "-Main");
    DumpPictureGain(picture, key + "-Gain");
    DumpPictureHdrComposed(picture, key + "-HdrComposed");
    DumpAllAuxiliaryPicture(picture, key + "-Auxiliary");
}

void PictureUtil::DumpPictureMain(OH_PictureNative *picture, std::string key)
{
    OH_PixelmapNative *pixelmap;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(picture, &pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || pixelmap == nullptr) {
        LOGW("DumpPicture GetMainPixelmap fail! errorCode=%d, key=%s", errorCode, key.c_str());
        return;
    }
    PixelmapUtil::DumpOHPixelMap(pixelmap, key);
    OH_PixelmapNative_Release(pixelmap);
}

void PictureUtil::DumpPictureGain(OH_PictureNative *picture, std::string key)
{
    OH_PixelmapNative *pixelmap;
    Image_ErrorCode errorCode = OH_PictureNative_GetGainmapPixelmap(picture, &pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || pixelmap == nullptr) {
        LOGW("DumpPicture GetGainPixelmap fail! errorCode=%d, key=%s", errorCode, key.c_str());
        return;
    }
    PixelmapUtil::DumpOHPixelMap(pixelmap, key);
    OH_PixelmapNative_Release(pixelmap);
}

void PictureUtil::DumpPictureHdrComposed(OH_PictureNative *picture, std::string key)
{
    OH_PixelmapNative *pixelmap;
    Image_ErrorCode errorCode = OH_PictureNative_GetHdrComposedPixelmap(picture, &pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || pixelmap == nullptr) {
        LOGW("DumpPicture GetHdrComposedPixelmap fail! errorCode=%d, key=%s", errorCode, key.c_str());
        return;
    }
    PixelmapUtil::DumpOHPixelMap(pixelmap, key);
    OH_PixelmapNative_Release(pixelmap);
}

void PictureUtil::DumpAllAuxiliaryPicture(OH_PictureNative *picture, const STRING &key)
{
    for (int i = 1; i < static_cast<int>(AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_MAX); ++i) {
        DumpAuxiliaryPicture(picture, static_cast<Image_AuxiliaryPictureType>(i), key);
    }
}

void PictureUtil::DumpAuxiliaryPicture(OH_PictureNative *picture, Image_AuxiliaryPictureType type, const STRING &key)
{
    OH_AuxiliaryPictureNative *auxiliary = nullptr;
    Image_ErrorCode code = OH_PictureNative_GetAuxiliaryPicture(picture, type, &auxiliary);
    CHECK_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, "PictureUtil DumpAuxiliaryPicture failed, type = %d, code = %d",
        type, code);
    
    UNIQUE_PTR<OH_AuxiliaryPictureNative, decltype(&OH_AuxiliaryPictureNative_Release)>
        auxiliaryPtr(auxiliary, &OH_AuxiliaryPictureNative_Release);
    
    OH_AuxiliaryPictureInfo *info = nullptr;
    code = OH_AuxiliaryPictureNative_GetInfo(auxiliary, &info);
    CHECK_LOG(code == Image_ErrorCode::IMAGE_SUCCESS,
        "PictureUtil DumpAuxiliaryPicture GetInfo failed, type = %d, code = %d", type, code);
    UNIQUE_PTR<OH_AuxiliaryPictureInfo, decltype(&OH_AuxiliaryPictureInfo_Release)>
        infoPtr(info, &OH_AuxiliaryPictureInfo_Release);
    
    Image_Size size = {.width = 0, .height = 0};
    uint32_t rowStride = 0;
    OH_AuxiliaryPictureInfo_GetSize(info, &size);
    OH_AuxiliaryPictureInfo_GetRowStride(info, &rowStride);
    uint32_t len = size.height * rowStride;
    auto dataTmp = new (std::nothrow) uint8_t[len];
    CHECK_LOG(dataTmp != nullptr, "PictureUtil DumpAuxiliaryPicture malloc failed, type =%d, len = %d", type, len);
    UNIQUE_PTR<uint8_t[]> data(dataTmp);
    LOGI("PictureUtil DumpAuxiliaryPicture width = %d, height = %d, len = %d", size.width, size.height, len);
    size_t dataLen = len;
    code = OH_AuxiliaryPictureNative_ReadPixels(auxiliary, dataTmp, &dataLen);
    CHECK_LOG(code == Image_ErrorCode::IMAGE_SUCCESS,
        "PictureUtil DumpAuxiliaryPicture ReadPixels failed, type = %d, code = %d", type, code);
    
    std::string fileName = "/data/storage/el2/base/files/OnComposeDst__+" + key + "__w_" + std::to_string(size.width) +
        "_h_" + std::to_string(size.height) + "_stride_" + std::to_string(rowStride) + "_type_" +
        std::to_string(type) + ".dat";
    PixelmapUtil::DumpBuffer(dataTmp, dataLen, fileName);
}

PixelmapInfo PictureUtil::GetMainPixelmapInfo(OH_PictureNative *picture)
{
    OH_PixelmapNative *pixelmap;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(picture, &pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || pixelmap == nullptr) {
        LOGE("DumpPicture GetMainPixelmap fail! errorCode=%d", errorCode);
        return {};
    }
    PixelmapInfo info = PixelmapUtil::GetPixelmapInfo(pixelmap);
    OH_PixelmapNative_Release(pixelmap);
    return info;
}

UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter> PictureUtil::GetMainPixelmapUniquePtr(OH_PictureNative *picture)
{
    OH_PixelmapNative *pixelmap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(picture, &pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || pixelmap == nullptr) {
        LOGE("GetMainPixelmap fail! errorCode=%d", errorCode);
        return nullptr;
    }
    return UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter>(pixelmap);
}

void PictureUtil::UpdatePictureAuxiliaryByGainMap(OH_PictureNative *picture)
{
    OH_AuxiliaryPictureNative *auxiliaryGainMap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetAuxiliaryPicture(picture,
        Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, &auxiliaryGainMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || auxiliaryGainMap == nullptr) {
        LOGE("GetAuxiliaryPicture fail! errorCode=%d", errorCode);
        return;
    }
    OH_PixelmapNative *pxlGainMap = nullptr;
    errorCode = OH_PictureNative_GetGainmapPixelmap(picture, &pxlGainMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || pxlGainMap == nullptr) {
        LOGW("GetGainPixelmap fail! errorCode=%d", errorCode);
        OH_AuxiliaryPictureNative_Release(auxiliaryGainMap);
        return;
    }
    PixelmapInfo gainInfo = PixelmapUtil::GetPixelmapInfo(pxlGainMap);
    OH_PixelmapNative_Release(pxlGainMap);
    UpdatePictureAuxiliaryInfo(auxiliaryGainMap, gainInfo);
    OH_AuxiliaryPictureNative_Release(auxiliaryGainMap);
    LOGD("UpdatePictureAuxiliaryByGainMap end");
}

void PictureUtil::UpdatePictureAuxiliaryInfo(OH_AuxiliaryPictureNative *picture, PixelmapInfo pixelmapInfo)
{
    OH_AuxiliaryPictureInfo *info = nullptr;
    Image_ErrorCode errorCode = OH_AuxiliaryPictureInfo_Create(&info);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("GetAuxiliaryPictureSize PictureInfo_Create result: %d", errorCode);
        return;
    }
    errorCode = OH_AuxiliaryPictureNative_GetInfo(picture, &info);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("GetAuxiliaryPictureSize GetInfo result: %d", errorCode);
        OH_AuxiliaryPictureInfo_Release(info);
        return;
    }
    Image_Size size = {.width = pixelmapInfo.width, .height = pixelmapInfo.height};
    errorCode = OH_AuxiliaryPictureInfo_SetSize(info, &size);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGW("OH_AuxiliaryPictureInfo_SetSize fail: %d", errorCode);
    }
    errorCode = OH_AuxiliaryPictureInfo_SetPixelFormat(info, (PIXEL_FORMAT)pixelmapInfo.pixelFormat);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGW("OH_AuxiliaryPictureInfo_SetPixelFormat fail: %d", errorCode);
    }
    errorCode = OH_AuxiliaryPictureInfo_SetRowStride(info, pixelmapInfo.rowStride);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGW("OH_AuxiliaryPictureInfo_SetRowStride fail: %d", errorCode);
    }
    errorCode = OH_AuxiliaryPictureNative_SetInfo(picture, info);
     if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureNative_SetInfo fail: %d", errorCode);
    }
    OH_AuxiliaryPictureInfo_Release(info);
}

OH_AuxiliaryPictureNative* PictureUtil::CloneAuxiliaryPicture(OH_AuxiliaryPictureNative *auxiliary)
{
    OH_AuxiliaryPictureInfo *info = nullptr;
    if (OH_AuxiliaryPictureInfo_Create(&info) != IMAGE_SUCCESS) {
        LOGE("CloneAuxiliaryPicture OH_AuxiliaryPictureInfo_Create fail!");
        return nullptr;
    }
    if (OH_AuxiliaryPictureNative_GetInfo(auxiliary, &info) != IMAGE_SUCCESS) {
        OH_AuxiliaryPictureInfo_Release(info);
        LOGE("CloneAuxiliaryPicture OH_AuxiliaryPictureNative_GetInfo fail!");
        return nullptr;
    }
    Image_Size size = {.width = 0, .height = 0};
    uint32_t rowStride = 0;
    Image_AuxiliaryPictureType type;
    OH_AuxiliaryPictureInfo_GetSize(info, &size);
    OH_AuxiliaryPictureInfo_GetRowStride(info, &rowStride);
    OH_AuxiliaryPictureInfo_GetType(info, &type);

    size_t len = size.height * rowStride;
    uint8_t *auxiliaryData = new uint8_t[len];
    Image_ErrorCode errCode = OH_AuxiliaryPictureNative_ReadPixels(auxiliary, auxiliaryData, &len);
    if (errCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CloneAuxiliaryPicture OH_AuxiliaryPictureNative_ReadPixels fail! errorCode=%d", errCode);
        OH_AuxiliaryPictureInfo_Release(info);
        delete[] auxiliaryData;
        return nullptr;
    }
    OH_AuxiliaryPictureNative *dstAuxiliary = nullptr;
    errCode = OH_AuxiliaryPictureNative_Create(auxiliaryData, len, &size, type, &dstAuxiliary);
    if (errCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyPicture CreatePicture OH_AuxiliaryPictureNative_Create fail! errorCode=%d", errCode);
        delete[] auxiliaryData;
        OH_AuxiliaryPictureInfo_Release(info);
        return nullptr;
    }
    delete[] auxiliaryData;
    OH_AuxiliaryPictureInfo_Release(info);
    return dstAuxiliary;
}

OH_AuxiliaryPictureNative *PictureUtil::ScaleAuxiliaryPicture(OH_AuxiliaryPictureNative *auxiliaryPicture, float scale)
{
    if (std::abs(scale) < MIN_SCALE) {
        LOGW("skip scale.");
        return nullptr;
    }
    OH_PixelmapNative *pixelmap = CreatePixelMapWithAuxiliaryPicture(auxiliaryPicture);
    if (pixelmap == nullptr) {
        LOGE("create pixelmap from auxiliary picture failed.");
        return nullptr;
    }
    OH_PixelmapNative_Scale(pixelmap, scale, scale);

    uint32_t width, height, rowStride;
    int32_t pixelFormat;
    OH_Pixelmap_ImageInfo *pixelMapInfo = nullptr;
    OH_PixelmapImageInfo_Create(&pixelMapInfo);
    OH_PixelmapNative_GetImageInfo(pixelmap, pixelMapInfo);
    OH_PixelmapImageInfo_GetWidth(pixelMapInfo, &width);
    OH_PixelmapImageInfo_GetHeight(pixelMapInfo, &height);
    OH_PixelmapImageInfo_GetPixelFormat(pixelMapInfo, &pixelFormat);
    OH_PixelmapImageInfo_GetRowStride(pixelMapInfo, &rowStride);
    OH_PixelmapImageInfo_Release(pixelMapInfo);
    LOGE("ScaleAuxiliaryPicture width=%d height=%d rowStride=%d pixelFormat=%d", width, height, rowStride, pixelFormat);

    UINT8 *auxiliaryData = GetDataFromNativePixelMap(pixelmap, width, height);
    OH_PixelmapNative_Release(pixelmap);
    if (auxiliaryData == nullptr) {
        LOGE("create pixelmap from auxiliary picture failed.");
        return nullptr;
    }

    OH_AuxiliaryPictureNative *dstAuxiliary = nullptr;
    size_t len = rowStride * height;
    Image_AuxiliaryPictureType type;
    OH_AuxiliaryPictureNative_GetType(auxiliaryPicture, &type);
    Image_Size size = {.width = width, .height = height};
    Image_ErrorCode errorCode = OH_AuxiliaryPictureNative_Create(auxiliaryData, len, &size, type, &dstAuxiliary);
    delete[] auxiliaryData;
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("create auxiliary picture failed.");
        return nullptr;
    }
    return dstAuxiliary;
}

int PictureUtil::CloneAuxiliaryPicture(OH_PictureNative *srcPicture, OH_PictureNative *dstPicture,
                                       Image_AuxiliaryPictureType auxiliaryPictureType, float scale)
{
    OH_AuxiliaryPictureNative *auxiliaryPicture = nullptr;
    Image_ErrorCode errorCode =
        OH_PictureNative_GetAuxiliaryPicture(srcPicture, auxiliaryPictureType, &auxiliaryPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || auxiliaryPicture == nullptr) {
        LOGE("OH_PictureNative_GetAuxiliaryPicture fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    OH_AuxiliaryPictureNative *cloneAuxiliaryPicture = PictureUtil::CloneAuxiliaryPicture(auxiliaryPicture);
    OH_AuxiliaryPictureNative_Release(auxiliaryPicture);
    if (cloneAuxiliaryPicture == nullptr) {
        LOGE("OH_PictureNative_SetAuxiliaryPicture fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    OH_AuxiliaryPictureNative *sampleAuxiliaryPicture = ScaleAuxiliaryPicture(cloneAuxiliaryPicture, scale);
    OH_AuxiliaryPictureNative_Release(cloneAuxiliaryPicture);

    errorCode = OH_PictureNative_SetAuxiliaryPicture(dstPicture, auxiliaryPictureType, sampleAuxiliaryPicture);
    OH_AuxiliaryPictureNative_Release(sampleAuxiliaryPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PictureNative_SetAuxiliaryPicture fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    return HMC_OK;
}

int PictureUtil::CopyAuxiliaryPicture(OH_PictureNative *srcPicture, OH_PictureNative *dstPicture,
                                      Image_AuxiliaryPictureType auxiliaryPictureType)
{
    OH_AuxiliaryPictureNative *auxiliaryPicture = nullptr;
    Image_ErrorCode errorCode =
        OH_PictureNative_GetAuxiliaryPicture(srcPicture, auxiliaryPictureType, &auxiliaryPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || auxiliaryPicture == nullptr) {
        LOGE("OH_PictureNative_GetAuxiliaryPicture fail! errorCode=%d, auxiliaryPictureType=%d", errorCode,
             auxiliaryPictureType);
        return HMC_ERR;
    }
    errorCode = OH_PictureNative_SetAuxiliaryPicture(dstPicture, auxiliaryPictureType, auxiliaryPicture);
    OH_AuxiliaryPictureNative_Release(auxiliaryPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PictureNative_SetAuxiliaryPicture fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    return HMC_OK;
}

void PictureUtil::TryUpdateExifSize(OH_PictureNative *picture)
{
    LOGI("TryUpdateExifSize enter");
    OH_PictureMetadata *exifMetadata = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMetadata(picture, EXIF_METADATA, &exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || exifMetadata == nullptr) {
        LOGW("TryUpdateExifSize OH_PictureNative_GetMetadata not exists! code=%d", errorCode);
        return;
    }
    std::shared_ptr<OH_PictureMetadata> exifPtr(exifMetadata, OH_PictureMetadata_Release);
    PixelmapInfo info = GetMainPixelmapInfo(picture);
    if (info.width <= 0 || info.height <= 0) {
        LOGW("TryUpdateExifSize mainPixelmap size error. width=%d, height=%d", info.width, info.height);
        return;
    }

    // 图片宽高
    SetPictureMetadataProperty(exifPtr.get(), OHOS_IMAGE_PROPERTY_IMAGE_WIDTH, std::to_string(info.width));
    SetPictureMetadataProperty(exifPtr.get(), OHOS_IMAGE_PROPERTY_IMAGE_LENGTH, std::to_string(info.height));
    // 像素尺寸, OHOS_IMAGE_PROPERTY 中未定义常量
    SetPictureMetadataProperty(exifPtr.get(), "PixelXDimension", std::to_string(info.width));
    SetPictureMetadataProperty(exifPtr.get(), "PixelYDimension", std::to_string(info.height));
    OH_PictureNative_SetMetadata(picture, Image_MetadataType::EXIF_METADATA, exifPtr.get());
    LOGI("TryUpdateExifSize end, width=%d, height=%d", info.width, info.height);
}

void PictureUtil::DumpAuxiliaryPicture(OH_PictureNative *srcPicture,std::string key,
                                       Image_AuxiliaryPictureType type)
{
    OH_AuxiliaryPictureNative *auxiliaryPicture = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetAuxiliaryPicture(srcPicture, type, &auxiliaryPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGW("DumpPicture DumpAuxiliaryPicture fail! errorCode=%d, key=%s", errorCode, key.c_str());
        return;
    }
    UNIQUE_PTR<OH_AuxiliaryPictureNative, decltype(OH_AuxiliaryPictureNative_Release) *> auxiliaryPicturePtr(
        auxiliaryPicture, OH_AuxiliaryPictureNative_Release);
    OH_PixelmapNative *pixelmap = CreatePixelMapWithAuxiliaryPicture(auxiliaryPicturePtr.get());
    if (pixelmap == nullptr) {
        LOGW("DumpPicture DumpAuxiliaryPicture not found AuxiliaryPicture type = %d", type);
        return;
    }
    UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter> pixelmapPtr(pixelmap);
    PixelmapUtil::DumpOHPixelMap(pixelmapPtr.get(), key);
}

bool PictureUtil::IsHdr(OH_PictureNative *picture)
{
    LOGD("IsHdr enter");
    bool isHdr = false;
    // 获取合成图判断有耗时性能问题，可使用gainMap判断是否为HDR图,大部分情况下有gainMap即可合成
    OH_PixelmapNative *pixelMap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetGainmapPixelmap(picture, &pixelMap);
    if (errorCode == Image_ErrorCode::IMAGE_SUCCESS && pixelMap != nullptr) {
        OH_PixelmapNative_Release(pixelMap);
        isHdr = true;
    }
    LOGD("IsHdr end, result=%d", isHdr);
    return isHdr;
}

void PictureUtil::CopyPictureMetadata(OH_PictureNative *srcPicture, OH_PictureNative *outPicture)
{
    LOGD("CopyPictureMetadata enter");
    CopyMainNativeBuffer(srcPicture, outPicture);
    CopyGainNativeBuffer(srcPicture, outPicture);
    CopyAllMetadata(srcPicture, outPicture);
    LOGD("CopyPictureMetadata end");
}

void PictureUtil::CopyMainNativeBuffer(OH_PictureNative *srcPicture, OH_PictureNative *outPicture)
{
    OH_PixelmapNative *srcPixelmap;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(srcPicture, &srcPixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS  || srcPixelmap == nullptr) {
        LOGE("CopyMainNativeBuffer src GetMainPixelmap error: %d", errorCode);
        return;
    }
    std::shared_ptr<OH_PixelmapNative> srcPtr(srcPixelmap, OH_PixelmapNative_Release);
    OH_PixelmapNative *outPixelmap;
    errorCode = OH_PictureNative_GetMainPixelmap(outPicture, &outPixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS  || outPixelmap == nullptr) {
        LOGE("CopyMainNativeBuffer out GetMainPixelmap error: %d", errorCode);
        return;
    }
    std::shared_ptr<OH_PixelmapNative> outPtr(outPixelmap, OH_PixelmapNative_Release);
    CopyColorSpace(srcPtr.get(), outPtr.get());
    CopyNativeBuffer(srcPtr.get(), outPtr.get());
}

void PictureUtil::CopyGainNativeBuffer(OH_PictureNative *srcPicture, OH_PictureNative *outPicture)
{
    OH_PixelmapNative *srcPixelmap;
    Image_ErrorCode errorCode = OH_PictureNative_GetGainmapPixelmap(srcPicture, &srcPixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS  || srcPixelmap == nullptr) {
        LOGE("CopyGainNativeBuffer src GetGainmapPixelmap error: %d", errorCode);
        return;
    }
    std::shared_ptr<OH_PixelmapNative> srcPtr(srcPixelmap, OH_PixelmapNative_Release);
    OH_PixelmapNative *outPixelmap;
    errorCode = OH_PictureNative_GetGainmapPixelmap(outPicture, &outPixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS  || outPixelmap == nullptr) {
        LOGE("CopyGainNativeBuffer out GetGainmapPixelmap error: %d", errorCode);
        return;
    }
    std::shared_ptr<OH_PixelmapNative> outPtr(outPixelmap, OH_PixelmapNative_Release);
    CopyColorSpace(srcPtr.get(), outPtr.get());
    CopyNativeBuffer(srcPtr.get(), outPtr.get());
}

float PictureUtil::ScalePicture(OH_PictureNative *srcPicture, uint32_t maxSize)
{
    if (srcPicture == nullptr || maxSize <= 0) {
        LOGW("ScalePicture param error, maxSize=%d", maxSize);
        return 1.0;
    }
    OH_PixelmapNative *mainPixelmap;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(srcPicture, &mainPixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || mainPixelmap == nullptr) {
        LOGE("GetMainPixelmap fail! errorCode=%d", errorCode);
        return 1.0;
    }
    std::shared_ptr<OH_PixelmapNative> mainPtr(mainPixelmap, OH_PixelmapNative_Release);
    PixelmapInfo info = PixelmapUtil::GetPixelmapInfo(mainPtr.get());
    double scale = std::max(info.width, info.height) * 1.0 / maxSize;
    if (scale <= 1.0) {
        LOGI("ScalePicture no need scale, skip do it.");
        return 1.0;
    }
    LOGI("ScalePicture scale=%f", scale);
    double downSampleScale = 1.0 / scale;
    OH_PixelmapNative_Scale(mainPtr.get(), static_cast<float>(downSampleScale), static_cast<float>(downSampleScale));
    info = PixelmapUtil::GetPixelmapInfo(mainPtr.get());

    OH_PixelmapNative *gainPixelMap = nullptr;
    errorCode = OH_PictureNative_GetGainmapPixelmap(srcPicture, &gainPixelMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || gainPixelMap == nullptr) {
        LOGI("Get GainMap not exists. code=%d", errorCode);
        return scale;
    }
    std::shared_ptr<OH_PixelmapNative> gainPtr(gainPixelMap, OH_PixelmapNative_Release);
    PixelmapInfo gainInfo =  PixelmapUtil::GetPixelmapInfo(gainPtr.get());
    if (gainInfo.width > info.width || gainInfo.height > info.height) {
        LOGI("GainMap scale, gain width=%d, height=%d", gainInfo.width, gainInfo.height);
        OH_PixelmapNative_Scale(gainPtr.get(), static_cast<float>(downSampleScale),
                                static_cast<float>(downSampleScale));
    }

    // 更新metadata
    OH_PictureMetadata *metaData = nullptr;
    errorCode = OH_PictureNative_GetMetadata(srcPicture, EXIF_METADATA, &metaData);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || metaData == nullptr) {
        LOGE("GetMetadata not exists. code=%d", errorCode);
    } else {
        UpdateMetaData(srcPicture);
        OH_PictureMetadata_Release(metaData);
    }
    //下采样 UNREFOCUS_MAP
    PictureUtil::CloneAuxiliaryPicture(srcPicture, srcPicture, AUXILIARY_PICTURE_TYPE_UNREFOCUS_MAP, downSampleScale);
    LOGI("ScalePicture end.");
    return scale;
}

bool PictureUtil::UpdateMetaData(OH_PictureNative *picture)
{
    LOGD("UpdateMetaData enter");
    PixelmapInfo pxlInfo = GetMainPixelmapInfo(picture);
    // 更新gainMap信息
    PictureUtil::UpdatePictureAuxiliaryByGainMap(picture);
    
    OH_PictureMetadata *exifMetadata = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMetadata(picture, EXIF_METADATA, &exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || exifMetadata == nullptr) {
        LOGE("UpdateMetaData OH_PictureNative_GetMetadata fail! errorCode=%d", errorCode);
        return false;
    }
    
    OH_PictureMetadata *outExifMetadata = nullptr;
    errorCode = OH_PictureMetadata_Clone(exifMetadata, &outExifMetadata);
    OH_PictureMetadata_Release(exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || outExifMetadata == nullptr) {
        LOGE("UpdateMetaData PictureMetadata_Clone fail! errorCode=%d", errorCode);
        return false;
    }
    
    SetPictureMetadataProperty(outExifMetadata, OHOS_IMAGE_PROPERTY_IMAGE_LENGTH, std::to_string(pxlInfo.height));
    SetPictureMetadataProperty(outExifMetadata, OHOS_IMAGE_PROPERTY_IMAGE_WIDTH, std::to_string(pxlInfo.width));
    OH_PictureNative_SetMetadata(picture, Image_MetadataType::EXIF_METADATA, outExifMetadata);
    OH_PictureMetadata_Release(outExifMetadata);
    LOGD("UpdateMetaData end");
    return true;
}

OH_PictureNative *PictureUtil::CopyMainAsPicture(OH_PictureNative *&srcPicture)
{
    LOGI("CopyMainAsPicture enter");
    OH_PixelmapNative *mainSrc;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(srcPicture, &mainSrc);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || mainSrc == nullptr) {
        LOGE("CopyMainAsPicture src GetMainPixelmap fail! errorCode=%d", errorCode);
        return nullptr;
    }
    std::shared_ptr<OH_PixelmapNative> mainPtr(mainSrc, OH_PixelmapNative_Release);
    OH_PixelmapNative *mainDst = PixelmapUtil::CopyPixelmap(mainPtr);
    if (mainDst == nullptr) {
        LOGE("CopyMainAsPicture CopyPixelmap fail");
        return nullptr;
    }
    OH_PictureNative *dstPicture;
    errorCode = OH_PictureNative_CreatePicture(mainDst, &dstPicture);
    OH_PixelmapNative_Release(mainDst);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || dstPicture == nullptr) {
        LOGE("CopyMainAsPicture CreatePicture fail! errorCode=%d", errorCode);
        return nullptr;
    }
    LOGI("CopyMainAsPicture end");
    return dstPicture;
}

void PictureUtil::CopyAuxiliaryGainMap(OH_PictureNative *&srcPicture, OH_PictureNative *&dstPicture)
{
    LOGD("CopyAuxiliaryGainMap enter");
    OH_AuxiliaryPictureNative *gainPicture;
    Image_ErrorCode errorCode = OH_PictureNative_GetAuxiliaryPicture(
        srcPicture, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, &gainPicture);


    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || gainPicture == nullptr) {
        LOGW("CopyAuxiliaryGainMap GetAuxiliaryPicture fail: %d", errorCode);
        return;
    }
    errorCode = OH_PictureNative_SetAuxiliaryPicture(
        dstPicture, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, gainPicture);
    OH_AuxiliaryPictureNative_Release(gainPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyAuxiliaryGainMap SetAuxiliaryPicture fail: %d", errorCode);
    }
    LOGD("CopyAuxiliaryGainMap end");
}

OH_PictureNative *PictureUtil::CloneDmaPicture(OH_PictureNative *&srcPicture)
{
    HMC_TRACE_GUARD("CloneDmaPicture");
    FALSE_RETURN_V_MSG(srcPicture != nullptr, nullptr, "CloneDmaPicture fail, srcPicture is NULL.");
    LOGD("CloneDmaPicture enter");
    auto mainPtr = PictureUtil::GetMainPixelmapUniquePtr(srcPicture);
    FALSE_RETURN_V_MSG(mainPtr != nullptr, nullptr, "CloneDmaPicture fail, mainPtr is NULL.");
    OH_HiTrace_StartTrace("CloneDmaPixelmap");
    OH_PixelmapNative *dstMain = PixelmapUtil::CloneDmaPixelmap(mainPtr.get());
    OH_HiTrace_FinishTrace();
    FALSE_RETURN_V_MSG(dstMain != nullptr, nullptr, "CloneDmaPicture main CloneDmaPixelmap fail.");

    OH_PictureNative *dstPicture;
    Image_ErrorCode errorCode = OH_PictureNative_CreatePicture(dstMain, &dstPicture);
    OH_PixelmapNative_Release(dstMain);
    FALSE_RETURN_V_MSG(dstPicture != nullptr && errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
                       "CloneDmaPicture CreatePicture fail, code=%d", errorCode);

    TryCloneGainmap(srcPicture, dstPicture);

    PictureUtil::CopyAllMetadata(srcPicture, dstPicture);
    PictureUtil::CopyAuxiliaryPicture(srcPicture, dstPicture, AUXILIARY_PICTURE_TYPE_LINEAR_MAP);
    PictureUtil::CopyAuxiliaryPicture(srcPicture, dstPicture, AUXILIARY_PICTURE_TYPE_UNREFOCUS_MAP);
    LOGD("CloneDmaPicture end");
    return dstPicture;
}

PixelmapInfo PictureUtil::GetAuxiliaryPictureSize(std::shared_ptr<OH_AuxiliaryPictureNative> &gainMap)
{
    PixelmapInfo pxlInfo = {.width = 0, .height = 0};
    OH_AuxiliaryPictureInfo *info = nullptr;
    Image_ErrorCode errCode = OH_AuxiliaryPictureInfo_Create(&info);
    FALSE_RETURN_V_MSG(errCode == Image_ErrorCode::IMAGE_SUCCESS, pxlInfo,
                       "AuxiliaryPictureInfo_Create fail! errorCode=%d", errCode);

    errCode = OH_AuxiliaryPictureNative_GetInfo(gainMap.get(), &info);
    // GetInfo之后再创建智能指针，否则获取不到数据
    std::shared_ptr<OH_AuxiliaryPictureInfo> infoPtr(info, OH_AuxiliaryPictureInfo_Release);
    FALSE_RETURN_V_MSG(errCode == Image_ErrorCode::IMAGE_SUCCESS, pxlInfo,
                       "OH_AuxiliaryPictureNative_GetInfo fail! errorCode=%d", errCode);

    Image_Size gainSize = {.width = 0, .height = 0};
    errCode = OH_AuxiliaryPictureInfo_GetSize(infoPtr.get(), &gainSize);
    FALSE_RETURN_V_MSG(errCode == Image_ErrorCode::IMAGE_SUCCESS, pxlInfo,
                       "OH_AuxiliaryPictureInfo_GetSize fail! errorCode=%d", errCode);
    pxlInfo.width = gainSize.width;
    pxlInfo.height = gainSize.height;

    errCode = OH_AuxiliaryPictureInfo_GetRowStride(infoPtr.get(), &pxlInfo.rowStride);
    FALSE_RETURN_V_MSG(errCode == Image_ErrorCode::IMAGE_SUCCESS, pxlInfo,
                       "OH_AuxiliaryPictureInfo_GetRowStride fail! errorCode=%d", errCode);

    PIXEL_FORMAT pixelFormat;
    errCode = OH_AuxiliaryPictureInfo_GetPixelFormat(infoPtr.get(), &pixelFormat);
    FALSE_RETURN_V_MSG(errCode == Image_ErrorCode::IMAGE_SUCCESS, pxlInfo,
                       "OH_AuxiliaryPictureInfo_GetPixelFormat fail! errorCode=%d", errCode);
    pxlInfo.pixelFormat = pixelFormat;
    LOGI("GetAuxiliaryPictureSize width=%d, height=%d, rowStride=%d, pixelFormat=%d", pxlInfo.width, pxlInfo.height,
         pxlInfo.rowStride, pxlInfo.pixelFormat);
    return pxlInfo;
}

bool PictureUtil::TryCloneGainmap(OH_PictureNative *&srcPicture, OH_PictureNative *&dstPicture)
{
    HMC_TRACE_GUARD("TryCloneGainmap");
    OH_AuxiliaryPictureNative *gainMap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetAuxiliaryPicture(
        srcPicture, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, &gainMap);
    FALSE_RETURN_V_MSG(gainMap != nullptr && errorCode == Image_ErrorCode::IMAGE_SUCCESS, false,
                       "TryCloneGainmap GetAuxiliaryPicture fail! errorCode=%d", errorCode);
    std::shared_ptr<OH_AuxiliaryPictureNative> gainPtr(gainMap, OH_AuxiliaryPictureNative_Release);

    PixelmapInfo info = GetAuxiliaryPictureSize(gainPtr);
    FALSE_RETURN_V_MSG(info.width > 0 && info.height > 0, false, "TryCloneGainmap GetAuxiliaryPictureSize fail!");

    size_t len = info.height * info.rowStride;
    LOGI("TryToGetGainMap width: %d, height: %d, len: %d", info.width, info.height, len);
    std::shared_ptr<uint8_t[]> gainData = std::make_unique<uint8_t[]>(len);
    errorCode = OH_AuxiliaryPictureNative_ReadPixels(gainPtr.get(), gainData.get(), &len);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, false,
                       "TryCloneGainmap ReadPixels fail! errorCode=%d", errorCode);
    // 创建接口bug：如果要创建RGBA的gainMap只能传入BGRA的数据
    ConvertRGBA2BGRA(gainData.get(), info.width, info.height);

    OH_AuxiliaryPictureNative *dstGainMap = nullptr;
    Image_Size size{.width = info.width, .height = info.height};
    errorCode = OH_AuxiliaryPictureNative_Create(
        gainData.get(), len, &size, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, &dstGainMap);
    FALSE_RETURN_V_MSG(dstGainMap != nullptr && errorCode == Image_ErrorCode::IMAGE_SUCCESS, false,
                       "TryCloneGainmap PictureNative_Create fail! errorCode=%d", errorCode);

    errorCode = OH_PictureNative_SetAuxiliaryPicture(
        dstPicture, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, dstGainMap);
    OH_AuxiliaryPictureNative_Release(dstGainMap);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, false,
                       "TryCloneGainmap SetAuxiliaryPicture fail! errorCode=%d", errorCode);

    OH_PixelmapNative *srcPixelmap = nullptr;
    errorCode = OH_PictureNative_GetGainmapPixelmap(srcPicture, &srcPixelmap);
    std::shared_ptr<OH_PixelmapNative> srcPixelPtr(srcPixelmap, OH_PixelmapNative_Release);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS && srcPixelmap != nullptr, false,
                       "TryCloneGainmap src GetGainmapPixelmap fail! errorCode=%d", errorCode);

    OH_PixelmapNative *dstPixelmap = nullptr;
    errorCode = OH_PictureNative_GetGainmapPixelmap(dstPicture, &dstPixelmap);
    std::shared_ptr<OH_PixelmapNative> dstPixelPtr(dstPixelmap, OH_PixelmapNative_Release);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS && srcPixelmap != nullptr, false,
                       "TryCloneGainmap dst GetGainmapPixelmap fail! errorCode=%d", errorCode);

    CopyColorSpace(srcPixelPtr.get(), dstPixelPtr.get());
    CopyNativeBuffer(srcPixelPtr.get(), dstPixelPtr.get());
    return true;
}

bool PictureUtil::ReadMainPixelMapData(OH_PictureNative *srcPicture, uint8_t *data, size_t size)
{
    if (srcPicture == nullptr || data == nullptr) {
        LOGE("PictureUtil ReadMainPixelMapData failed");
        return false;
    }
    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode code = OH_PictureNative_GetMainPixelmap(srcPicture, &mainPixelMap);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, false,
        "PictureUtil ReadMainPixelMapData GetMainPixelmap failed, code = %d", code);
    
    std::shared_ptr<OH_PixelmapNative> mainPixelMapPtr(mainPixelMap, [](OH_PixelmapNative *mainPixelMap) {
        OH_PixelmapNative_Release(mainPixelMap);
    });
    
    code = OH_PixelmapNative_ReadPixels(mainPixelMap, data, &size);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, false,
        "PictureUtil ReadMainPixelMapData ReadPixels failed, code = %d", code);
    
    return true;
}

void PictureUtil::CloneAuxiliaryPicture(OH_PictureNative *srcPicture, OH_PictureNative *dstPicture,
    const VECTOR<int> &auxiliaryTypes)
{
    CHECK_LOG(srcPicture != nullptr && dstPicture != nullptr, "PictureUtil CloneAllAuxiliaryPicture failed");
    for (auto auxiliaryType : auxiliaryTypes) {
        int res = CopyAuxiliaryPicture(srcPicture, dstPicture,
            static_cast<Image_AuxiliaryPictureType>(auxiliaryType));
        if (res != HMC_OK) {
            LOGI("PictureUtil CloneAllAuxiliaryPicture failed type = %d", auxiliaryType);
            continue;
        }
        LOGI("PictureUtil CloneAllAuxiliaryPicture success type = %d", auxiliaryType);
    }
}

bool PictureUtil::GetPictureContainAuxiliaries(OH_PictureNative *srcPicture, uint32_t &size,
    SHARED_PTR<Image_AuxiliaryPictureType[]> &auxiliaryTypes)
{
    CHECK_AND_RETURN_RET_LOG(srcPicture != nullptr, false, "PictureUtil GetPictureContainAuxiliaries src is nullptr");

    if (size == 0) {
        LOGW("PictureUtil GetAuxiliaryPictureCount size = 0");
        return true;
    }
    auxiliaryTypes.reset(new Image_AuxiliaryPictureType[size], std::default_delete<Image_AuxiliaryPictureType[]>());
    
    return true;
}

bool PictureUtil::GetPictureContainMetadatas(OH_PictureNative *srcPicture, uint32_t &size,
    SHARED_PTR<Image_MetadataType[]> &metaDataTypes)
{
    CHECK_AND_RETURN_RET_LOG(srcPicture != nullptr, false, "PictureUtil GetPictureContainMetadatas src is nullptr");
    
    if (size == 0) {
        LOGW("PictureUtil GetPictureContainMetadatas size = 0");
        return true;
    }
    metaDataTypes.reset(new Image_MetadataType[size], std::default_delete<Image_MetadataType[]>());
    return true;
}

void PictureUtil::UpDateMetadata(OH_PictureNative *srcPicture, Image_MetadataType srcType, OH_PictureNative *dstPicture,
    Image_MetadataType dstType)
{
    CHECK_LOG(srcPicture != nullptr && dstPicture != nullptr, "PictureUtil UpDateMetadata failed");
    OH_PictureMetadata *srcMetadata = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMetadata(srcPicture, srcType, &srcMetadata);
    CHECK_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS,
        "PictureUtil UpDateMetadata src OH_PictureNative_GetMetadata failed code = %d", errorCode);
    std::shared_ptr<OH_PictureMetadata> srcMetadataPtr(srcMetadata, [](OH_PictureMetadata *metadata) {
        OH_PictureMetadata_Release(metadata);
    });
    
    OH_PictureMetadata *dstMetadata = nullptr;
    bool isCreate = false;
    errorCode = OH_PictureNative_GetMetadata(dstPicture, dstType, &dstMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        isCreate = true;
        errorCode = OH_PictureMetadata_Create(dstType, &dstMetadata);
    }
    CHECK_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS,
        "PictureUtil UpDateMetadata dst OH_PictureNative_GetMetadata failed code = %d", errorCode);
    std::shared_ptr<OH_PictureMetadata> dstMetadataPtr(dstMetadata, [](OH_PictureMetadata *metadata) {
        OH_PictureMetadata_Release(metadata);
    });
    
    if (isCreate) {
        errorCode = OH_PictureNative_SetMetadata(dstPicture, dstType, dstMetadata);
    }
    CHECK_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS,
        "PictureUtil UpDateMetadata dst SetMetadata failed code = %d", errorCode);
}

void PictureUtil::PrintPictureAuxiliaries(OH_PictureNative *srcPicture)
{
    uint32_t size = 0;
    SHARED_PTR<Image_AuxiliaryPictureType[]> auxiliaryTypes = nullptr;
    bool res = GetPictureContainAuxiliaries(srcPicture, size, auxiliaryTypes);
    CHECK_LOG(res == true, "PictureUtil PrintPictureAuxiliaries failed");
    for (int i = 0; i < size; ++i) {
        LOGI("PictureUtil PrintPictureAuxiliaries index = %d, type = %d", i, auxiliaryTypes[i]);
    }
}

void PictureUtil::PrintPictureMetadatas(OH_PictureNative *srcPicture)
{
    uint32_t size = 0;
    SHARED_PTR<Image_MetadataType[]> metaDataTypes = nullptr;
    bool res = GetPictureContainMetadatas(srcPicture, size, metaDataTypes);
    CHECK_LOG(res == true, "PictureUtil PrintPictureMetadatas failed");
    for (int i = 0; i < size; ++i) {
        LOGI("PictureUtil PrintPictureMetadatas index = %d, type = %d", i, metaDataTypes[i]);
    }
}

bool PictureUtil::GetAuxiliaryInfoByType(OH_PictureNative *picture, Image_AuxiliaryPictureType type,
    PixelmapInfo &info)
{
    OH_AuxiliaryPictureNative *auxiliaryPicture = nullptr;
    Image_ErrorCode code = OH_PictureNative_GetAuxiliaryPicture(picture, type, &auxiliaryPicture);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, false,
        "PictureUtil GetAuxiliaryInfoByType failed, type = %d, code = %d", type, code);
    UNIQUE_PTR<OH_AuxiliaryPictureNative, decltype(OH_AuxiliaryPictureNative_Release) *> auxiliaryPicturePtr(
        auxiliaryPicture, OH_AuxiliaryPictureNative_Release);
    
    OH_AuxiliaryPictureInfo *auxiliaryInfo = nullptr;
    code = OH_AuxiliaryPictureNative_GetInfo(auxiliaryPicture, &auxiliaryInfo);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, false,
        "PictureUtil GetAuxiliaryInfoByType getInfo, type = %d, code = %d", type, code);
    UNIQUE_PTR<OH_AuxiliaryPictureInfo, decltype(&OH_AuxiliaryPictureInfo_Release)>
        infoPtr(auxiliaryInfo, &OH_AuxiliaryPictureInfo_Release);

    Image_Size size = {.width = 0, .height = 0};
    uint32_t rowStride = 0;
    OH_AuxiliaryPictureInfo_GetSize(auxiliaryInfo, &size);
    OH_AuxiliaryPictureInfo_GetRowStride(auxiliaryInfo, &rowStride);
    info.width = size.width;
    info.height = size.height;
    info.rowStride = rowStride;
    return true;
}

void PictureUtil::PrintPictureInfo(OH_PictureNative *picture) {
    for (int i = 1; i < 15; ++i) {
        PixelmapInfo info;
        Image_AuxiliaryPictureType type = static_cast<Image_AuxiliaryPictureType>(i);
        bool res = PictureUtil::GetAuxiliaryInfoByType(picture, type, info);
        if (!res) {
            LOGI("GetAuxiliaryInfoByType failed");
            continue;
        }
        LOGI("picture info. type = %d, width = %d, height = %d, rowStride = %d",
             type, info.width, info.height, info.rowStride);
    }
}

OH_PictureNative *PictureUtil::ConvertSnapToMain(OH_PictureNative *picture) {
    OH_PictureNative *inPutPicture = nullptr;
    UINT32 srcAuxilarySize = 0;
    SHARED_PTR<Image_AuxiliaryPictureType[]> srcAuxiliaryTypes;
    UINT32 dstAuxilarySize = 0;
    SHARED_PTR<Image_AuxiliaryPictureType[]> dstAuxiliaryTypes;
    
    UINT32 srcMetaDataSize = 0;
    SHARED_PTR<Image_MetadataType[]> srcMetaDataTypes;
    UINT32 dstMetaDataSize = 0;
    SHARED_PTR<Image_MetadataType[]> dstMetaDataTypes;
    bool res = GetPictureContainAuxiliaries(picture, srcAuxilarySize, srcAuxiliaryTypes);
    CHECK_AND_RETURN_RET_LOG(res == true, nullptr, "ConvertSnapToMain src GetPictureContainAuxiliaries failed");
    res = GetPictureContainAuxiliaries(picture, dstAuxilarySize, dstAuxiliaryTypes);
    CHECK_AND_RETURN_RET_LOG(res == true, nullptr, "ConvertSnapToMain dst GetPictureContainAuxiliaries failed");
    res = GetPictureContainMetadatas(picture, srcMetaDataSize, srcMetaDataTypes);
    CHECK_AND_RETURN_RET_LOG(res == true, nullptr, "ConvertSnapToMain src GetPictureContainMetadatas failed");
    res = GetPictureContainMetadatas(picture, dstMetaDataSize, dstMetaDataTypes);
    CHECK_AND_RETURN_RET_LOG(res == true, nullptr, "ConvertSnapToMain dst GetPictureContainMetadatas failed");
    
    bool srcHasSnapGainMap = false;
    for (int i = 0; i < srcAuxilarySize; ++i) {
        if (srcAuxiliaryTypes[i] == static_cast<Image_AuxiliaryPictureType>(7)) {
            srcHasSnapGainMap = true;
        }
    }
    
    for (int i = 0; i < dstAuxilarySize; ++i) {
        if (srcAuxiliaryTypes[i] == static_cast<Image_AuxiliaryPictureType>(7)) {
            dstAuxiliaryTypes[i] = static_cast<Image_AuxiliaryPictureType>(7);
        }
        if (srcAuxiliaryTypes[i] == static_cast<Image_AuxiliaryPictureType>(1) && srcHasSnapGainMap) {
            dstAuxiliaryTypes[i] = static_cast<Image_AuxiliaryPictureType>(1);
            srcAuxiliaryTypes[i] = static_cast<Image_AuxiliaryPictureType>(7);
        }
    }

    Image_AuxiliaryPictureType *mainPixelMapKey= nullptr;
    Image_AuxiliaryPictureType mainPixelMap = static_cast<Image_AuxiliaryPictureType>(6);
    mainPixelMapKey = &mainPixelMap;
    
    CHECK_AND_RETURN_RET_LOG(res == true && inPutPicture != nullptr, nullptr,
        "ConvertSnapToMain DeepCopyPicture failed");
    return inPutPicture;
}