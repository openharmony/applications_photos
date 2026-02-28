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
#include "HmcJpegEncoder.h"

HmcJpegEncoder::HmcJpegEncoder(int32_t width, int32_t height, int32_t quality)
    : m_width(width), m_height(height), m_quality(quality)
{
    m_handle = tjInitCompress();
}

HmcJpegEncoder::HmcJpegEncoder()
{
    m_handle = tjInitCompress();
}

HmcJpegEncoder::~HmcJpegEncoder()
{
    if (m_handle) {
        tjDestroy(m_handle);
    }
}

void HmcJpegEncoder::SetEncodePixelFormat(int32_t pixelfmt)
{
    m_pixelfmt = pixelfmt;
}

int32_t HmcJpegEncoder::Encode(const unsigned char *buffer, unsigned char **jpegBuffer, unsigned long *jpegSize)
{
    if (!m_handle) {
        LOGE("Jpeg encoder handle is null!");
        return HMC_ERR;
    }
    LOGD("Jpeg encoder begin w=%d,h=%d,fmt:%d,q=%d", m_width, m_height, m_pixelfmt, m_quality);
    auto ret =
        tjCompress2(m_handle, buffer, m_width, 0, m_height, m_pixelfmt, jpegBuffer, jpegSize, m_subsamp, m_quality, 0);
    if (ret != 0) {
        LOGE("Jpeg encoder failed! %d : %s", tjGetErrorCode(m_handle), tjGetErrorStr2(m_handle));
        return HMC_ERR;
    }
    LOGD("Jpeg encoder finish size=%llu", *jpegSize);
    return HMC_OK;
}


int32_t HmcJpegEncoder::EncodeYUV(const unsigned char *buffer, int width, int height, int quality,
    unsigned char **jpegBuffer, unsigned long *jpegSize)
{
    if (!m_handle) {
        LOGE("Jpeg encoder handle is null!");
        return HMC_ERR;
    }

    auto t0 = HmcGetSystemUpTime();
    int padding = 1;
    int flags = 0;
    if (HMC_OK !=
        tjCompressFromYUV(m_handle, buffer, width, padding, height, TJSAMP_420, jpegBuffer, jpegSize, quality, flags)) {
        LOGE("Jpeg encoder failed! %d : %s", tjGetErrorCode(m_handle), tjGetErrorStr2(m_handle));
        return HMC_ERR;
    }

    LOGD("Jpeg encoder finish size=%llu cost %lld", *jpegSize, HmcGetSystemUpTime() - t0);
    return HMC_OK;
}

void HmcJpegEncoder::FreeBuffer(unsigned char *buffer)
{
    if (buffer) {
        tjFree(buffer);
    }
}