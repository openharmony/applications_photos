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
#include "HmcJpegDecoder.h"

#define HMC_IMAGE_DEFAUL_STRIDE(w) (w)

HmcJpegDecoder::HmcJpegDecoder()
{
    m_handle = HmcJpegInitDecompress();
}

HmcJpegDecoder::~HmcJpegDecoder()
{
    if (m_handle) {
        HmcJpegDestroy(m_handle);
    }
}

SHARED_PTR<Image> HmcJpegDecoder::Decode(const u_char *buffer, unsigned long size)
{
    if (!m_handle) {
        LOGE("Jpeg decoder handle is null");
        return nullptr;
    }

    LOGD("Jpeg decoder begin");
    int32_t width = 0;
    int32_t height = 0;
    int32_t subsamp = 0;
    int32_t colorSpace = 0;
    auto ret = HmcJpegDecompressHeader3(m_handle, buffer, size, &width, &height, &subsamp, &colorSpace);
    if (ret != 0) {
        LOGE("Jpeg decoder decompress header failed. %d : %s", HmcJpegGetErrorCode(m_handle), HmcJpegGetErrorStr(m_handle));
        return nullptr;
    }
    if (width <= 0 || height <= 0) {
        LOGE("Jpeg decoder failed. invalid width(%d) or height(%d)", width, height);
        return nullptr;
    }
    unsigned long outSize = (unsigned long)width * (unsigned long)height * 4;
    unsigned char *outBuffer = static_cast<unsigned char *>(malloc(outSize));
    if (outBuffer == nullptr) {
        LOGE("Jpeg decoder malloc buffer failed");
        return nullptr;
    }
    ret = HmcJpegDecompress2(m_handle, buffer, size, outBuffer, width, 0, height, m_pixelfmt, 0);
    if (ret != 0) {
        LOGE("Jpeg decoder decompress failed. %d : %s", HmcJpegGetErrorCode(m_handle), HmcJpegGetErrorStr(m_handle));
        return nullptr;
    }

    auto image = new (std::nothrow) Image();
    if (!image) {
        LOGE("Jpeg decoder failed, image is null");
        return nullptr;
    }
    image->width = (uint32_t)width;
    image->height = (uint32_t)height;
    image->stride = HMC_IMAGE_DEFAUL_STRIDE(image->width);
    image->imageBuffer = outBuffer;
    LOGD("Jpeg decoder finish w=%d,h=%d,fmt:%d,color=%d", width, height, m_pixelfmt, colorSpace);
    return SHARED_PTR<Image>(image);
}

std::shared_ptr<YUVDataInfo> HmcJpegDecoder::DecodeYUV(const u_char *buffer, unsigned long size)
{
    if (!m_handle) {
        LOGE("Jpeg decoder handle is null");
        return nullptr;
    }

    int32_t width = 0;
    int32_t height = 0;
    int32_t subsamp = 0;
    int32_t colorSpace = 0;
    if (HMC_OK != HmcJpegDecompressHeader3(m_handle, buffer, size, &width, &height, &subsamp, &colorSpace)) {
        LOGE("Jpeg decompress header failed. %d : %s", HmcJpegGetErrorCode(m_handle), HmcJpegGetErrorStr(m_handle));
        return nullptr;
    }

    if (width <= 0 || height <= 0) {
        LOGE("Jpeg decode failed. invalid width(%d) or height(%d)", width, height);
        return nullptr;
    }

    int padding = 1;
    auto outSize = HmcJpegBufSizeYUV2(width, padding, height, subsamp);
    auto outBuffer = (unsigned char *)malloc(outSize);
    if (outBuffer == nullptr) {
        LOGE("Jpeg decoder malloc buffer failed");
        return nullptr;
    }

    if (HMC_OK != HmcJpegDecompressToYUV2(m_handle, buffer, size, outBuffer, width, padding, height, 0)) {
        LOGE("Jpeg decompress failed. %d : %s", HmcJpegGetErrorCode(m_handle), HmcJpegGetErrorStr(m_handle));
        free(outBuffer);
        return nullptr;
    }

    std::shared_ptr<YUVDataInfo> yuvData(new YUVDataInfo(outBuffer, outSize), [](YUVDataInfo *p) {
        if (p) {
            if (p->yuvBuffer) {
                free(p->yuvBuffer);
            }
            delete p;
        }
    });

    return yuvData;
}