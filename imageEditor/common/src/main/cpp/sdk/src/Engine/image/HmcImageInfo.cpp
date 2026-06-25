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
#include "HmcImageInfo.h"
#include <endian.h>
#include <multimedia/image_framework/image/image_packer_native.h>
#include <multimedia/image_framework/image/image_source_native.h>

constexpr uint32_t WEBP_HEADER_LEN = 12;
constexpr uint32_t WEBP_FLAG_OFFSET = 8;

constexpr uint32_t GIF_HEADER_LEN = 6;

HmcImageInfo::HmcImageInfo(const std::string &fileName)
{
    mFileName = fileName;
}

HmcImageInfo::~HmcImageInfo()
{
    mFile.Close();
}

bool HmcImageInfo::Init()
{
    if (!DetectFormat()) {
        return false;
    }
    return true;
}
HmcImageInfo::ImageFormat HmcImageInfo::GetFormat() const
{
    return mFormat;
}

uint32_t HmcImageInfo::GetWidth() const
{
    return mWidth;
}

uint32_t HmcImageInfo::GetHeight() const
{
    return mHeight;
}
HmcImageInfo::ImageFormat HmcImageInfo::GetFormatFromBuffer(u_char *buffer, size_t size)
{
    u_char jpgFlag[] = { 0xFF, 0xD8 };
    if (size >= sizeof(jpgFlag) && !memcmp(jpgFlag, buffer, sizeof(jpgFlag))) {
        return JPEG;
    }
    u_char bmpFlag[] = { 0x42, 0x4d };
    if (!memcmp(bmpFlag, buffer, sizeof(bmpFlag))) {
        return BMP;
    }

    u_char pngFlag[] = { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A };
    if (size >= sizeof(pngFlag) && !memcmp(pngFlag, buffer, sizeof(pngFlag))) {
        return PNG;
    }

    u_char riffFlag[] = { 0x52, 0x49, 0x46, 0x46 };
    u_char webpFlag[] = { 0x57, 0x45, 0x42, 0x50 };
    if (size >= WEBP_HEADER_LEN && !memcmp(riffFlag, buffer, sizeof(riffFlag)) &&
        !memcmp(webpFlag, buffer + WEBP_FLAG_OFFSET, sizeof(webpFlag))) {
        return WEBP;
    }

    u_char gif87Flag[] = { 0x47, 0x49, 0x46, 0x38, 0x37, 0x61 };
    u_char gif89Flag[] = { 0x47, 0x49, 0x46, 0x38, 0x39, 0x61 };
    if (size >= GIF_HEADER_LEN &&
        (!memcmp(gif87Flag, buffer, sizeof(gif87Flag)) || !memcmp(gif89Flag, buffer, sizeof(gif89Flag)))) {
        return GIF;
    }

    u_char icoSig[] = { 00, 00, 01, 00 };
    u_char curSig[] = { 00, 00, 02, 00 };
    if ((size >= sizeof(icoSig) && !memcmp(icoSig, buffer, sizeof(icoSig))) ||
        (size >= sizeof(curSig) && !memcmp(curSig, buffer, sizeof(curSig)))) {
        return ICO;
    }
    return UNKNOWN;
}

bool HmcImageInfo::DetectFormat()
{
    if (mFile.Open(mFileName, HmcFile::HMC_FILE_READ) != HMC_OK) {
        LOGE("Failed to open file %s!", mFileName.c_str());
        return false;
    }

    mFile.Seek(0);
    mBufferLen = mFile.Read(mBuffer, HMC_IMAGE_FILE_BUFFER_SIZE);
    if (mBufferLen <= 0) {
        LOGE("Failed to read file %s!", mFileName.c_str());
        return false;
    }
    int64_t fd = mFile.FileNo();

    OH_ImageSourceNative *imageSource = nullptr;
    Image_ErrorCode errorCode = OH_ImageSourceNative_CreateFromFd(static_cast<int32_t>(fd), &imageSource);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_ImageSourceNative_CreateFromFd fail! errorCode=%d", errorCode);
        return false;
    }
    std::shared_ptr<OH_ImageSourceNative> imageSourcePtr(imageSource,
        [](OH_ImageSourceNative *imageSource) { OH_ImageSourceNative_Release(imageSource); });

    OH_ImageSource_Info *imageInfo = nullptr;
    errorCode = OH_ImageSourceInfo_Create(&imageInfo);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_ImageSourceInfo_Create fail! errorCode=%d", errorCode);
        return false;
    }
    errorCode = OH_ImageSourceNative_GetImageInfo(imageSource, 0, imageInfo);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_ImageSourceNative_GetImageInfo fail! errorCode=%d", errorCode);
        OH_ImageSourceInfo_Release(imageInfo);
        return false;
    }
    OH_ImageSourceInfo_GetWidth(imageInfo, &mWidth);
    OH_ImageSourceInfo_GetHeight(imageInfo, &mHeight);
    OH_ImageSourceInfo_Release(imageInfo);
    LOGI("HmcImageInfo::DetectFormat imageInfo width=%d, height=%d", mWidth, mHeight);

    mFormat = GetFormatFromBuffer(mBuffer, mBufferLen);
    LOGI("detect file %s format %d", mFileName.c_str(), mFormat);
    return true;
}
