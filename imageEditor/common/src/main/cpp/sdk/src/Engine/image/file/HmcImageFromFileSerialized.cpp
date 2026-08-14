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
#include "HmcEngine.h"

// HmcImageFromFileSerialized的类ID
// 悄悄地告诉你，是用md5("HmcImageFromFileSerialized")方式生成，不专业但能用
const HmcUid HMC_CLSID_IMAGE_FROM_FILE_SERIALIZED = { 0x10, 0x2c, 0x10, 0xea, 0x87, 0x2f, 0xa2, 0x74,
                                                      0xa3, 0x20, 0x30, 0x75, 0x35, 0x61, 0x89, 0x11 };

HmcImageFromFileSerialized::HmcImageFromFileSerialized() : m_header(NULL), m_fileData(NULL), m_fileSize(0) {}

HmcImageFromFileSerialized::~HmcImageFromFileSerialized()
{
    if (m_header) {
        HmcDictDestroy(m_header);
    }

    if (m_fileData) {
        HmcFree(m_fileData);
    }
}

VOID *HmcImageFromFileSerialized::Serialize(UINT32 *size)
{
    if (!m_header || !m_fileData || !m_fileSize) {
        return NULL;
    }

    // 先生成文件头
    STRING header = GenerateSerializationHeader();

    // 计算需要的缓冲区大小
    auto headerSize = (UINT32)(header.length() + 1);
    auto bufferSize = headerSize + m_fileSize;

    // 分配缓冲区
    auto buffer = (CHAR *)HmcMalloc(bufferSize);
    if (!buffer) {
        LOGW("Failed to allocate buffer for %u bytes!", bufferSize);
        return NULL;
    }

    // 拷贝文件头字符串
    strncpy(buffer, header.c_str(), bufferSize);
    buffer[bufferSize - 1] = '\0';

    // 把文件内容拷贝到缓冲区
    memcpy(buffer + headerSize, m_fileData, m_fileSize);

    // 完成序列化
    *size = bufferSize;
    LOGD("Succeed to serialize!");
    return buffer;
}

STRING HmcImageFromFileSerialized::GenerateSerializationHeader()
{
    auto headerStr = HmcDictSerialize(m_header);
    if (!headerStr) {
        return {};
    }
    STRING header(headerStr);
    HmcFree(headerStr);
    return header;
}

INT32 HmcImageFromFileSerialized::Deserialize(HmcDict *dict, const VOID *data, UINT32 size)
{
    m_header = HmcDictDuplicate(dict);
    if (!m_header) {
        return HMC_ERR;
    }

    m_fileData = HmcMalloc(size);
    if (!m_fileData) {
        return HMC_ERR;
    }

    memcpy(m_fileData, data, size);

    m_fileSize = size;
    return HMC_OK;
}

HmcImageBase *HmcImageFromFileSerialized::Clone()
{
    auto image = new HmcImageFromFileSerialized();
    if (HMC_OK != image->Deserialize(m_header, m_fileData, m_fileSize)) {
        delete image;
        return NULL;
    }
    return image;
}
