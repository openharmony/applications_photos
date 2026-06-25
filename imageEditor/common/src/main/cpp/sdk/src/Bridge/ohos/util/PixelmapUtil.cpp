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

#include "PixelmapUtil.h"
#include <multimedia/image_framework/image/image_packer_native.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include "log/HmcLog.h"
 
#include "log/HmcLog.h"
#include "../Base/HmcBaseType.h"
#include "ohos/jscaller/DataAbilityHelper.h"
#include "util/HmcColorUtil.h"
#include "util/HmcRegion.h"
#include "PictureUtil.h"

constexpr uint32_t PIXEL_BYTES_FOUR = 4;

PixelmapInfo PixelmapUtil::GetPixelmapInfo(OH_PixelmapNative *mainPixelmap)
{
    PixelmapInfo info = {};
    OH_Pixelmap_ImageInfo *pixelMapInfo = nullptr;
    OH_PixelmapImageInfo_Create(&pixelMapInfo);
    OH_PixelmapNative_GetImageInfo(mainPixelmap, pixelMapInfo);
    OH_PixelmapImageInfo_GetWidth(pixelMapInfo, &info.width);
    OH_PixelmapImageInfo_GetHeight(pixelMapInfo, &info.height);
    OH_PixelmapImageInfo_GetPixelFormat(pixelMapInfo, &info.pixelFormat);
    OH_PixelmapImageInfo_GetRowStride(pixelMapInfo, &info.rowStride);
    OH_PixelmapImageInfo_Release(pixelMapInfo);
    LOGI("GetPixelMapInfo width=%d, height=%d, pixelFormat=%d, rowStride=%d",
        info.width, info.height, info.pixelFormat, info.rowStride);
    return info;
}

void PixelmapUtil::DumpBuffer(uint8_t *data, size_t size, const std::string& filename)
{
    if (data == nullptr) {
        LOGE("Input data addr is null");
        return;
    }
 
    std::ofstream rawDataFile(filename.c_str(), std::ofstream::binary);
    if (!rawDataFile.good()) {
        LOGE("DumpBuffer open failed: (%s) %s", filename.c_str(), std::strerror(errno));
        rawDataFile.close();
        return;
    }
    rawDataFile.write(reinterpret_cast<const char *>(data), size);
    rawDataFile.close();
    LOGI("DumpBuffer file: %s", filename.c_str());
}

void PixelmapUtil::DumpOHPixelMap(OH_PixelmapNative *in, std::string key)
{
    LOGI("DumpOHPixelMap enter");
    uint32_t width;
    uint32_t height;
    int32_t pixelFormat;
    uint32_t rowSize;
    OH_Pixelmap_ImageInfo *pixelMapInfo = nullptr;
    OH_PixelmapImageInfo_Create(&pixelMapInfo);
    OH_PixelmapNative_GetImageInfo(in, pixelMapInfo);
    OH_PixelmapImageInfo_GetWidth(pixelMapInfo, &width);
    OH_PixelmapImageInfo_GetHeight(pixelMapInfo, &height);
    OH_PixelmapImageInfo_GetPixelFormat(pixelMapInfo, &pixelFormat);
    OH_PixelmapImageInfo_GetRowStride(pixelMapInfo, &rowSize);
    OH_PixelmapImageInfo_Release(pixelMapInfo);
    size_t readDataLen = height * rowSize;
    auto *data = new uint8_t[readDataLen];
    OH_PixelmapNative_ReadPixels(in, data, &readDataLen);
 
    LOGI("DumpOHPixelMap width: %d, height: %d, rowStride: %d, pixelFormat: %d, readDataLen: %ld",
        width, height, rowSize, pixelFormat, readDataLen);
    std::string fileName = "/data/storage/el2/base/files/OnComposeDst__+" + key + "__" + std::to_string(width) +
        "_h_" +std::to_string(height) + "_stride_" + std::to_string(rowSize) + "_format_" +
        std::to_string(pixelFormat) + ".dat";
    PixelmapUtil::DumpBuffer(data, readDataLen, fileName);
    delete[] data;
    LOGI("DumpOHPixelMap end");
}

UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter> PixelmapUtil::MakeAlpha(OH_PixelmapNative *in,
                                                                                HmcRegion region)
{
    if (in == nullptr) {
        return nullptr;
    }
    auto pixelMapInfo = GetPixelmapInfo(in);
    if (pixelMapInfo.pixelFormat != PIXEL_FORMAT_RGBA_8888) {
        return nullptr;
    }
    if (region.y >= pixelMapInfo.height) {
        return nullptr;
    }
    if (region.x >= pixelMapInfo.width) {
        return nullptr;
    }
    if (region.y + region.height >= pixelMapInfo.height) {
        return nullptr;
    }
    if (region.x + region.width >= pixelMapInfo.width) {
        return nullptr;
    }
    uint32_t rowStride = pixelMapInfo.rowStride;
    uint32_t start = region.y * rowStride;
    size_t readDataLen = pixelMapInfo.height * rowStride;
    UNIQUE_PTR<uint8_t[]> dataPtr = std::make_unique<uint8_t[]>(readDataLen);
    if (OH_PixelmapNative_ReadPixels(in, dataPtr.get(), &readDataLen) != Image_ErrorCode::IMAGE_SUCCESS) {
        return nullptr;
    }
    for (int i = 0; i < region.height; i++) {
        std::fill_n(dataPtr.get() + start + i * rowStride +
                    region.x * PIXEL_BYTES_FOUR, region.width * PIXEL_BYTES_FOUR, 0);
    }
    OH_PixelmapNative *mainPixelMapCopy = CreatePixelMapNativeWithInfo(dataPtr.get(),
                                                                       pixelMapInfo.width, pixelMapInfo.height,
                                                                       PIXEL_FORMAT_RGBA_8888, PIXEL_FORMAT_RGBA_8888);
    return UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter>(mainPixelMapCopy);
}

OH_PixelmapNative *PixelmapUtil::CopyPixelmap(std::shared_ptr<OH_PixelmapNative> &src)
{
    PixelmapInfo pxlInfo = PixelmapUtil::GetPixelmapInfo(src.get());
    size_t bufSize = pxlInfo.rowStride * pxlInfo.height;
    std::unique_ptr<uint8_t[]> mainData = std::make_unique<uint8_t[]>(bufSize);

    Image_ErrorCode errorCode = OH_PixelmapNative_ReadPixels(src.get(), mainData.get(), &bufSize);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyPixelmap ReadPixels fail! errorCode=%d", errorCode);
        return nullptr;
    }

    OH_PixelmapNative *mainDst = CreatePixelMapNativeWithInfo(mainData.get(), pxlInfo.width, pxlInfo.height,
                                                              pxlInfo.pixelFormat, pxlInfo.pixelFormat);
    LOGI("CopyPixelmap end, result=%d", mainDst != nullptr);
    return mainDst;
}

std::shared_ptr<OH_Pixelmap_InitializationOptions> PixelmapUtil::CreatePixelmapOptions(PixelmapInfo &info,
                                                                                       int32_t &srcPixelFormat)
{
    OH_Pixelmap_InitializationOptions *options = nullptr;
    Image_ErrorCode errorCode = OH_PixelmapInitializationOptions_Create(&options);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
                       "OH_PixelmapInitializationOptions_Create fail! errorCode=%d", errorCode);

    std::shared_ptr<OH_Pixelmap_InitializationOptions> optionsPtr(options, OH_PixelmapInitializationOptions_Release);

    errorCode = OH_PixelmapInitializationOptions_SetWidth(optionsPtr.get(), info.width);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
                       "OH_PixelmapInitializationOptions_SetWidth fail! errorCode=%d", errorCode);

    errorCode = OH_PixelmapInitializationOptions_SetHeight(optionsPtr.get(), info.height);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
                       "OH_PixelmapInitializationOptions_SetHeight fail! errorCode=%d", errorCode);

    errorCode = OH_PixelmapInitializationOptions_SetPixelFormat(optionsPtr.get(), info.pixelFormat);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
                       "OH_PixelmapInitializationOptions_SetPixelFormat fail! errorCode=%d", errorCode);

    errorCode = OH_PixelmapInitializationOptions_SetSrcPixelFormat(optionsPtr.get(), srcPixelFormat);
    FALSE_RETURN_V_MSG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
                       "OH_PixelmapInitializationOptions_SetSrcPixelFormat fail! errorCode=%d", errorCode);

    return optionsPtr;
}

OH_PixelmapNative *PixelmapUtil::CloneDmaPixelmap(OH_PixelmapNative *srcPixelmap)
{
    FALSE_RETURN_V_MSG(srcPixelmap != nullptr, nullptr, "CloneDmaPixelmap srcPixelmap is NULL.");

    PixelmapInfo info = GetPixelmapInfo(srcPixelmap);
    std::shared_ptr<OH_Pixelmap_InitializationOptions> options = CreatePixelmapOptions(info, info.pixelFormat);
    FALSE_RETURN_V_MSG(options != nullptr, nullptr, "CloneDmaPixelmap failed, because CreatePixelmapOptions error");

    size_t len = info.height * info.rowStride;
    std::shared_ptr<uint8_t[]> mainData = std::make_unique<uint8_t[]>(len);
    FALSE_RETURN_V_MSG(mainData != nullptr, nullptr, "CloneDmaPixelmap failed, because mainData is nullptr");

    Image_ErrorCode code = OH_PixelmapNative_ReadPixels(srcPixelmap, mainData.get(), &len);
    FALSE_RETURN_V_MSG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
                       "CloneDmaPixelmap failed, because read pixel error code = %d", code);
    
    OH_PixelmapNative *dstPixelmap;
    code = OH_PixelmapNative_CreatePixelmapUsingAllocator(mainData.get(), len, options.get(), IMAGE_ALLOCATOR_MODE_DMA,
                                                   &dstPixelmap);
    FALSE_RETURN_V_MSG(code == Image_ErrorCode::IMAGE_SUCCESS && dstPixelmap != nullptr, nullptr,
                       "OH_PixelmapNative_CreatePixelmapUsingAllocator failed, error code = %d", code);
    CopyColorSpace(srcPixelmap, dstPixelmap);
    CopyNativeBuffer(srcPixelmap, dstPixelmap);
    return dstPixelmap;
}