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
#ifndef HMC_JPEG_DECODER_H
#define HMC_JPEG_DECODER_H

#include "turbojpeg.h"
#include "HmcBase.h"
#include "MediaCreative/HmcImage.h"
#include "image/HmcImageBase.h"

struct YUVDataInfo {
    YUVDataInfo(unsigned char *buffer, unsigned long size) : yuvBuffer(buffer), yuvSize(size) {}
    unsigned char *yuvBuffer;
    unsigned long yuvSize;
};

class HmcJpegDecoder {
public:
    HmcJpegDecoder();

    ~HmcJpegDecoder();

    SHARED_PTR<Image> Decode(const u_char *buffer, unsigned long size);

    /* Tjpeg YUV解码
     * @param buffer 待解码原始数据
     * @param size  待解码数据长度
     * @return    YUVDataInfo解码后帧数据
     */
    std::shared_ptr<YUVDataInfo> DecodeYUV(const u_char *buffer, unsigned long size);

private:
    int32_t m_pixelfmt{ TJPF_RGBA };
    tjhandle m_handle{ nullptr };
};
#endif // HMC_JPEG_DECODER_H
