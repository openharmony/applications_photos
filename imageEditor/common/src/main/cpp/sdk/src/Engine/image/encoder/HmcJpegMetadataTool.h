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
#ifndef HMCJPEGMETADATA_H
#define HMCJPEGMETADATA_H

#include "HmcBase.h"
#include <bits/alltypes.h>
#include <string>

const u_int32_t HMC_IMAGE_EXIF_MAKER_LEN = 6;
const u_int32_t HMC_IMAGE_EXIF_ORDER_LEN = 2;

const u_char HMC_JPEG_BLOCK_MAKER = 0xFF;
const u_char HMC_JPEG_BLOCK_APP1_FLAG = 0xE1;
const u_int32_t HMC_JPEG_BLOCK_LENGTH_OFFSET = 2;
const u_int32_t HMC_JPEG_EXIF_LENGTH_OFFSET = 10;

using HmcImageExifApp1Head = struct {
    u_short flag;
    u_short length;
    u_char exifMaker[HMC_IMAGE_EXIF_MAKER_LEN];
    u_char order[HMC_IMAGE_EXIF_ORDER_LEN];
    u_short version;
    u_int ifdOffset;
    u_short deNum;
} __attribute__((packed));

using HmcImageExifTag = struct {
    u_int16_t flag;
    u_int16_t type;
    u_int len;
    u_int data;
} __attribute__((packed));

class HmcJpegMetadataTool {
public:
    HmcJpegMetadataTool();
    ~HmcJpegMetadataTool();

    int Init(const u_char *buffer, size_t len);
    int BuildMetadata(u_short width, u_short height);

    bool GetHaveApp1();
    std::vector<u_int8_t> &GetMetadata();

private:
    using PropertyKey = enum {
        WIDTH,
        HEIGHT,
        ORIENTATION,
    };
    int SetMetadata(const u_char *app1, size_t len);
    int ParseMatadata();
    const u_char *FindApp1(const u_char *buffer, size_t len, size_t &appLen);
    int ModifyShortProperty(PropertyKey key, u_short value);
    u_short ByteSwap(u_short inputNum);
    u_int ByteSwap(u_int inputNum);

private:
    bool m_containsAPP1{ false };
    bool m_isBigEndian{ true };
    std::vector<u_int8_t> m_metadata;
    HASH_MAP<u_short, size_t> m_deList;
    // 一些标记符
    HASH_MAP<PropertyKey, u_short> m_hexFlag;
    STRING m_logTitle{ "HmcJpegMetadataTool" };
};

#endif