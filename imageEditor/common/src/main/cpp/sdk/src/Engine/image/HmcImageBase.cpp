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
#include "HmcImageBase.h"

// 反序列化接口的默认实现，什么也不做
INT32 HmcImageBase::Deserialize(HmcDict *, const VOID *, UINT32)
{
    LOGW("%s should not be called!", __FUNCTION__);
    return HMC_ERR;
}

VOID HmcImageDestroy(HmcImage *image)
{
    LOGD("image be destroy!");
    if (image != nullptr) {
        delete (HmcImageBase *) image;
    }
    LOGD("image be destroy success!");
}

VOID *HmcImageSerialize(const HmcImage *image, UINT32 *size)
{
    auto imageBase = (HmcImageBase *)image;
    if (!imageBase || !size) {
        return NULL;
    }

    return imageBase->Serialize(size);
}

HmcImage *HmcImageDeserialize(const VOID *data, UINT32 size)
{
    // 先查找下序列化数据头字符串结束符的位置，避免访问越界
    auto startOfHeader = (const CHAR *)data;
    auto endOfHeader = (const CHAR *)memchr(startOfHeader, '\0', size);
    if (!endOfHeader) {
        LOGW("Missing dict in serialized image!");
        return NULL;
    }

    // 反序列化数据头
    auto dict = HmcDictDeserialize(startOfHeader);
    if (!dict) {
        LOGW("Failed to deserialize image header!");
        return NULL;
    }

    // 获得序列化类ID
    HmcUid clsid;
    if (HMC_OK != HmcDictGetUid(dict, "clsid", &clsid)) {
        HmcDictDestroy(dict);
        LOGW("Failed to get clsid from deserialize image header!");
        return NULL;
    }

    // 计算数据体位置和长度
    auto content = endOfHeader + 1;
    auto contentSize = (UINT32)(startOfHeader + size - endOfHeader);

    // 根据序列化类ID反序列化
    if (HmcUidIsEqual(&clsid, &HMC_CLSID_IMAGE_FROM_FILE_SERIALIZED)) {
        // 从文件序列化的
        auto image = new HmcImageFromFileSerialized();
        if (image == nullptr) { return NULL; }
        if (HMC_OK != image->Deserialize(dict, content, contentSize)) {
            delete image;
            HmcDictDestroy(dict);
            LOGW("Failed to deserialize from file!");
            return NULL;
        }
        LOGD("Succeed to deserialize image!");
        HmcDictDestroy(dict);
        return (HmcImageBase *)image;
    }

    LOGW("Unsupported clsid from deserialize image header!");
    HmcDictDestroy(dict);
    return NULL;
}

// 复制HmcImage对象
HmcImage *HmcImageDuplicate(const HmcImage *image)
{
    auto imageBase = (HmcImageBase *)image;
    if (!imageBase) {
        return NULL;
    }

    return imageBase->Clone();
}

int HmcImageIsGpuTexture(HmcImage *image)
{
    HmcImageBase *imageBase = (HmcImageBase *)image;
    if (!imageBase) {
        return 0;
    }

    return (int)(imageBase->IsGpuTexture());
}

HmcImage *HmcImageTransferFromGpu(HmcImage *image)
{
    HmcImageBase *imageBase = (HmcImageBase *)image;
    if (!imageBase) {
        return NULL;
    }

    return imageBase->TransferFromGpu();
}
