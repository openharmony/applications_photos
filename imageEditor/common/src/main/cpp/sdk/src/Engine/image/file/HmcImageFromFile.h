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

#ifndef HMCIMAGEFROMFILE_H
#define HMCIMAGEFROMFILE_H

#include "image/HmcImageBase.h"
#ifdef __cplusplus

class HmcImageFromFile : public HmcImageBase {
public:
    explicit HmcImageFromFile(const STRING &filePath);
    explicit HmcImageFromFile(const STRING &filePath, BOOL isSupportWaterMark);

    ~HmcImageFromFile() override = default;

    /* *
     * 克隆接口
     * @return              已克隆对象
     */
    HmcImageBase *Clone() final;

    // 序列化
    VOID *Serialize(UINT32 *size) final;

    SHARED_PTR<Image> ConvertToImage() final;

private:
    STRING GenerateSerializationHeader();

private:
    STRING m_filePath;
};

#endif // __cplusplus

#endif // HMCIMAGEFROMFILE_H
