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

#include "PixelmapFrame.h"

PixelmapFrame::PixelmapFrame(SHARED_PTR<Image> image) : image_(image) {}

VOID *PixelmapFrame::Serialize(UINT32 *size)
{
    return NULL;
}

HmcImageBase *PixelmapFrame::Clone()
{
    return reinterpret_cast<HmcImageBase *>(new PixelmapFrame(image_));
}

SHARED_PTR<Image> PixelmapFrame::ConvertToImage()
{
    LOGI("convert PixelmapFrame to image");
    return image_;
}