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
#ifndef HMC_IMAGE_INFO_H
#define HMC_IMAGE_INFO_H

#include <string>
#include <sys/types.h>
#include "HmcBase.h"
#include "file/HmcFile.h"

constexpr uint32_t HMC_IMAGE_FILE_BUFFER_SIZE = 32;

class HmcImageInfo {
    using FuncDetectSize = bool (HmcImageInfo::*)();

public:
    using ImageFormat = enum {
        UNKNOWN = 0,
        JPEG,
        BMP,
        PNG,
        WEBP,
        GIF,
        ICO,
        HEIC,
        DNG,
        SVG,
        HEIF
    };

public:
    explicit HmcImageInfo(const std::string &fileName);

    virtual ~HmcImageInfo();

    bool Init();

    ImageFormat GetFormat() const;

    uint32_t GetWidth() const;

    uint32_t GetHeight() const;

    static ImageFormat GetFormatFromBuffer(u_char *buffer, size_t size);

private:
    bool DetectFormat();

private:
    std::string mFileName;
    HmcFile mFile;
    ImageFormat mFormat{ UNKNOWN };
    uint32_t mWidth{ 0 };
    uint32_t mHeight{ 0 };
    u_char mBuffer[HMC_IMAGE_FILE_BUFFER_SIZE] = {0};
    int64_t mBufferLen{ 0 };
};

#endif // HMC_IMAGE_INFO_H
