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

#ifndef PIXEL_MAP_FRAME_H
#define PIXEL_MAP_FRAME_H

#include "image/HmcImageBase.h"
#ifdef __cplusplus

class PixelmapFrame : public HmcImageBase {
public:
    explicit PixelmapFrame(SHARED_PTR<Image> m_imagePtr);

    ~PixelmapFrame() override = default;

    HmcImageBase *Clone() final;

    VOID *Serialize(UINT32 *size) final;

    SHARED_PTR<Image> ConvertToImage() final;

private:
    SHARED_PTR<Image> image_;
};

#endif // __cplusplus

#endif // PIXEL_MAP_FRAME_H
