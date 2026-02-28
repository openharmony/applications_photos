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

#include "HmcImageFromFile.h"
#include "image/HmcImageInfo.h"
#include "image/decoder/HmcJpegDecoder.h"
#include "image/decoder/HmcOhosImageDecoder.h"

HmcImageFromFile::HmcImageFromFile(const STRING &filePath) : m_filePath(filePath) {}

HmcImageFromFile::HmcImageFromFile(const STRING &filePath, BOOL isSupportWaterMark) : m_filePath(filePath) {}

HmcImage *HmcImageCreateFromFile(const CHAR *filePath, BOOL isSupportWaterMark = false)
{
    return (HmcImageBase *)new HmcImageFromFile(filePath, isSupportWaterMark);
}

HmcImageBase *HmcImageFromFile::Clone()
{
    return new HmcImageFromFile(m_filePath);
}

static SHARED_PTR<Image> DecodeJpeg(const std::string &filePath)
{
    HmcFile file;
    if (file.Open(filePath, HmcFile::HMC_FILE_READ) != HMC_OK) {
        LOGE("Failed to open %s for read!", filePath.c_str());
        return nullptr;
    }

    INT64 sizeTemp = file.GetSize();
    if (sizeTemp < 0) {
        LOGE("invalid file size");
        return nullptr;
    }
    u_char mBuffer[HMC_IMAGE_FILE_BUFFER_SIZE] = { 0 };
    file.Seek(0);
    auto bufferLen = file.Read(mBuffer, HMC_IMAGE_FILE_BUFFER_SIZE);
    if (HmcImageInfo::GetFormatFromBuffer(mBuffer, bufferLen) != HmcImageInfo::ImageFormat::JPEG) {
        return nullptr;
    }

    VOID *buf = HmcMalloc(sizeTemp);
    if (buf == nullptr) {
        LOGE("malloc buf failed, file:%s ", filePath.c_str());
        return nullptr;
    }
    file.Seek(0);
    auto size = file.Read(buf, sizeTemp);
    if (size != sizeTemp) {
        LOGE("Read size != totalsize, file:%s, read=%d, total=%d.", filePath.c_str(), size, sizeTemp);
        HmcFree(buf);
        return nullptr;
    }

    HmcJpegDecoder decoder;
    auto image = decoder.Decode((u_char *)buf, size);
    HmcFree(buf);
    return image;
}

SHARED_PTR<Image> HmcImageFromFile::ConvertToImage()
{
    LOGI("convert file to image begin %s", m_filePath.c_str());
    
    INT64 fd = DataAbilityHelperOpen(m_filePath.c_str(), "r");
    auto image = HmcOhosImageDecoder::Decode(fd);
    ClearOpenedFds(m_filePath.c_str());
    LOGI("convert file to image end, fd = %d", fd);
    return image;
}

// 序列化
VOID *HmcImageFromFile::Serialize(UINT32 *size)
{
    // 先生成文件头
    STRING header = GenerateSerializationHeader();

    // 打开文件
    HmcFile file;
    if (HMC_OK != file.Open(m_filePath)) {
        LOGW("Failed to open %s for read!", m_filePath.c_str());
        return NULL;
    }

    // 计算需要的缓冲区大小
    auto headerSize = (UINT32)(header.length() + 1);
    auto fileSize = (UINT32)file.GetSize();
    if (fileSize < 0) {
        LOGW("Failed to get file size of %s.", m_filePath.c_str());
        return NULL;
    }
    auto bufferSize = headerSize + fileSize;

    // 分配缓冲区
    auto buffer = (CHAR *)HmcMalloc(bufferSize);
    if (!buffer) {
        LOGW("Failed to allocate buffer for %u bytes!", bufferSize);
        return NULL;
    }

    // 拷贝文件头字符串
    if (strcpy_s(buffer, bufferSize, header.c_str()) <= 0) {
        LOGE("strcpy_s error");
    }

    // 把文件内容读入缓冲区
    UINT32 leftSize(fileSize);
    UINT32 readSize(0);
    auto fileBuffer = buffer + headerSize;
    while (leftSize > 0) {
        INT32 ret = file.Read(fileBuffer + readSize, leftSize);
        if (ret <= 0) {
            // 读取出错了
            LOGW("Failed to read %s for %u bytes at position %u!", m_filePath.c_str(), leftSize, readSize);
            HmcFree(buffer);
            return NULL;
        }
        readSize += (UINT32)ret;
        leftSize -= (UINT32)ret;
    }

    // 完成序列化
    *size = bufferSize;
    LOGD("Succeed to serialize %s!", m_filePath.c_str());
    return buffer;
}

STRING HmcImageFromFile::GenerateSerializationHeader()
{
    auto dict = HmcDictCreate();
    HmcDictSetUid(dict, "clsid", &HMC_CLSID_IMAGE_FROM_FILE_SERIALIZED);
    HmcDictSetString(dict, "file_path", m_filePath.c_str());
    HmcDictSetInt64(dict, "file_size", HmcFile::GetSize(m_filePath));
    STRING header;
    auto headerStr = HmcDictSerialize(dict);
    if (headerStr != nullptr) {
        header = STRING(headerStr);
    }

    HmcFree(headerStr);
    HmcDictDestroy(dict);
    return header;
}
