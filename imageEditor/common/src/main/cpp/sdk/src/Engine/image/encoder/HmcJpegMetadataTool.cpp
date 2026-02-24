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

#include "HmcJpegMetadataTool.h"
#include "MediaCreative/HmcError.h"
#include "log/HmcLog.h"
#include <bits/alltypes.h>

HmcJpegMetadataTool::HmcJpegMetadataTool()
{
    m_hexFlag[WIDTH] = 0x100;
    m_hexFlag[HEIGHT] = 0x101;
    m_hexFlag[ORIENTATION] = 0x112;
}

HmcJpegMetadataTool::~HmcJpegMetadataTool()
{
    m_metadata.clear();
}

int HmcJpegMetadataTool::Init(const u_char *buffer, size_t len)
{
    size_t appLen = 0;
    const u_char *app1 = FindApp1(buffer, len, appLen);
    if (!app1) {
        LOGI("The image has no metadata info");
        return HMC_ERR;
    }
    if (SetMetadata(app1, appLen) != HMC_OK) {
        LOGE("%s set meta data error", m_logTitle.c_str());
    }
    m_containsAPP1 = true;
    LOGD("get matadata success.");
    ParseMatadata();
    return HMC_OK;
}

std::vector<u_int8_t> &HmcJpegMetadataTool::GetMetadata()
{
    return m_metadata;
}

int HmcJpegMetadataTool::SetMetadata(const u_char *app1, size_t app1Len)
{
    LOGD("Jpeg metadata app1 len: %02x", app1Len);
    for (size_t i = 0; i < app1Len; i++) {
        m_metadata.push_back(*(app1 + i));
    }
    return HMC_OK;
}

int HmcJpegMetadataTool::BuildMetadata(u_short width, u_short height)
{
    ModifyShortProperty(WIDTH, width);
    ModifyShortProperty(HEIGHT, height);
    ModifyShortProperty(ORIENTATION, 0);

    return HMC_OK;
}

int HmcJpegMetadataTool::ModifyShortProperty(PropertyKey key, u_short value)
{
    auto flag = m_hexFlag.find(key);
    if (flag == m_hexFlag.end()) {
        return HMC_ERR;
    }
    auto tagOffset = m_deList.find(flag->second);
    if (tagOffset == m_deList.end()) {
        LOGI("Metadata modify short can't find PropertyKey[%d]", key);
        return HMC_ERR;
    }
    HmcImageExifTag *tag = (HmcImageExifTag *)&m_metadata[tagOffset->second];
    tag->data = ByteSwap(value);

    return HMC_OK;
}

int HmcJpegMetadataTool::ParseMatadata()
{
    size_t app1Len = m_metadata.size();
    HmcImageExifApp1Head *head = (HmcImageExifApp1Head *)&m_metadata[0];

    u_short deNum = ByteSwap(head->deNum);
    LOGD("JPG App1 de count: %04x", deNum);
    // parse DE
    size_t offset = sizeof(HmcImageExifApp1Head);
    HmcImageExifTag *de;
    for (int i = 0; i < deNum && offset + sizeof(HmcImageExifTag) <= app1Len; i++) {
        de = (HmcImageExifTag *)&m_metadata[offset];
        m_deList[ByteSwap(de->flag)] = offset;
        offset += sizeof(HmcImageExifTag);
    }

    // 这里解析 IFD1 offset
    if (offset + sizeof(u_int) < app1Len) {
        u_int nextOffset = ByteSwap(*((u_int *)&m_metadata[offset]));
        if (nextOffset != 0 && nextOffset + sizeof(u_int) < app1Len) { // del fd1
            u_int32_t realIfd1Position = nextOffset + HMC_JPEG_EXIF_LENGTH_OFFSET;
            m_metadata.erase(m_metadata.begin() + realIfd1Position, m_metadata.end());
            // IFD1 offset 置 0
            for (size_t i = 0; i < sizeof(u_int); i++) {
                m_metadata[offset + i] = 0;
            }
            u_short newApp1Length = (u_short)(m_metadata.size() - HMC_JPEG_BLOCK_LENGTH_OFFSET);
            head->length = ByteSwap(newApp1Length);
            LOGI("The jpg has IFD1, app1 length after deletion is %04x -> %04x", newApp1Length, head->length);
        } else {
            LOGI("IFD1 offset is not include app1 length[%04x].", app1Len);
        }
    } else {
        LOGE("IFD1 offset[%04x] out of range.", app1Len);
    }
    return HMC_OK;
}

// 查找并获取jpeg中metadata的APP1数据
const u_char *HmcJpegMetadataTool::FindApp1(const u_char *buffer, size_t len, size_t &app1Len)
{
    u_char jpgFlag[] = { 0xFF, 0xD8 };
    if (len < sizeof(jpgFlag) || memcmp(jpgFlag, buffer, sizeof(jpgFlag)) != 0) {
        return nullptr;
    }
    buffer += sizeof(jpgFlag);
    len -= sizeof(jpgFlag);
    if (len < sizeof(HmcImageExifApp1Head)) {
        LOGI("%s buffer len is not enough(%lld)", m_logTitle.c_str(), len);
        return nullptr;
    }

    while (len >= HMC_JPEG_BLOCK_LENGTH_OFFSET + sizeof(u_short)) {
        if (buffer[0] != HMC_JPEG_BLOCK_MAKER) {
            len--;
            buffer++;
            continue;
        }
        u_short blockLength =
            __bswap16(*(reinterpret_cast<u_short *>(const_cast<u_char *>(buffer + HMC_JPEG_BLOCK_LENGTH_OFFSET))));
        if (len < HMC_JPEG_BLOCK_LENGTH_OFFSET + sizeof(u_short) + blockLength) {
            return nullptr;
        }
        if (buffer[1] == HMC_JPEG_BLOCK_APP1_FLAG) {
            break;
        }
        len -= HMC_JPEG_BLOCK_LENGTH_OFFSET + blockLength;
        buffer += HMC_JPEG_BLOCK_LENGTH_OFFSET + blockLength;
    }

    HmcImageExifApp1Head *head = reinterpret_cast<HmcImageExifApp1Head *>(const_cast<u_char *>(buffer));
    if (__bswap16(head->flag) != 0xFFE1) {
        LOGI("%s buffer first is not app1", m_logTitle.c_str(), len);
        return nullptr;
    }

    u_char bigOrderFlag[] = { 0x4D, 0x4D };
    u_char litterOrderFlag[] = { 0x49, 0x49 };
    if (!memcmp(head->order, bigOrderFlag, sizeof(bigOrderFlag))) {
        m_isBigEndian = true;
    } else if (!memcmp(head->order, litterOrderFlag, sizeof(litterOrderFlag))) {
        m_isBigEndian = false;
    } else {
        return nullptr;
    }

    app1Len = __bswap16(head->length) + sizeof(head->flag);
    if (app1Len > len) {
        LOGE("%s app1 len(%d) is not enough(%lld)", m_logTitle.c_str(), app1Len, len);
        app1Len = 0;
        return nullptr;
    }

    return buffer;
}

bool HmcJpegMetadataTool::GetHaveApp1()
{
    return m_containsAPP1;
}

u_short HmcJpegMetadataTool::ByteSwap(u_short inputNum)
{
    if (m_isBigEndian) {
        return __bswap16(inputNum);
    } else {
        return inputNum;
    }
}

u_int HmcJpegMetadataTool::ByteSwap(u_int inputNum)
{
    if (m_isBigEndian) {
        return __bswap32(inputNum);
    } else {
        return inputNum;
    }
}