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

#ifndef NEWPHOTOS_PIXELMAPUTIL_H
#define NEWPHOTOS_PIXELMAPUTIL_H

#include <string>
#include "HmcBaseType.h"
#include "ohos/util/PictureDeleter.h"
#include "util/HmcRegion.h"

struct PixelmapInfo {
    uint32_t width = 0;
    uint32_t height = 0;
    int32_t pixelFormat = 0;
    uint32_t rowStride = 0;
    
    bool operator==(const PixelmapInfo &other) const
    {
        return this->width == other.width &&
            this->height == other.height &&
            this->pixelFormat == other.pixelFormat &&
            this->rowStride == other.rowStride;
    }

    Image_Size ToImageSize()
    {
        return {.width = width, .height = height};
    }
    
    STRING toString() const
    {
        return "[width:" + std::to_string(this->width) + ", height:" + std::to_string(this->height) +
            ", format:" + std::to_string(this->pixelFormat) + ", rowStride:" + std::to_string(this->rowStride) + "]";
    }
};

class PixelmapUtil {
public:
    static PixelmapInfo GetPixelmapInfo(OH_PixelmapNative *mainPixelmap);
    static void DumpBuffer(uint8_t *data, size_t size, const std::string& filename);
    static void DumpOHPixelMap(OH_PixelmapNative *in, std::string key);
    static UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter> MakeAlpha(OH_PixelmapNative *in,
                                                                             HmcRegion region);
    static OH_PixelmapNative *CopyPixelmap(std::shared_ptr<OH_PixelmapNative> &src);
    static std::shared_ptr<OH_Pixelmap_InitializationOptions> CreatePixelmapOptions(PixelmapInfo &info,
                                                                                    int32_t &srcPixelFormat);
    static OH_PixelmapNative *CloneDmaPixelmap(OH_PixelmapNative *srcPixelmap);
};
#endif //NEWPHOTOS_PIXELMAPUTIL_H
