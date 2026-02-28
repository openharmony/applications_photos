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
#ifndef HMC_JPEG_ENCODER_H
#define HMC_JPEG_ENCODER_H

#include "HmcBase.h"
#include "turbojpeg.h"

class HmcJpegEncoder {
public:
    HmcJpegEncoder(int32_t width, int32_t height, int32_t quality);

    HmcJpegEncoder();

    ~HmcJpegEncoder();

    void SetEncodePixelFormat(int32_t pixelfmt);
    int32_t Encode(const unsigned char *buffer, unsigned char **jpegBuffer, unsigned long *jpegSize);

    int32_t EncodeYUV(const unsigned char *buffer, int width, int height, int quality, unsigned char **jpegBuffer,
        unsigned long *jpegSize);

    static void FreeBuffer(unsigned char *buffer);

private:
    int32_t m_width = 0;
    int32_t m_height = 0;
    int32_t m_quality = 50;
    int32_t m_pixelfmt{ TJPF_BGRA };
    int32_t m_subsamp{ TJSAMP_422 };
    tjhandle m_handle{ nullptr };
};
#endif // HMC_JPEG_ENCODER_H
