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
#ifndef HMC_OHOS_IMAGE_DECODER_H
#define HMC_OHOS_IMAGE_DECODER_H

#include "HmcBase.h"
#include <multimedia/image_framework/image/image_source_native.h>
#include "image/HmcImageBase.h"
#include "image/file/HmcImageFromFile.h"

class HmcOhosImageDecoder {
public:
    static OH_PictureNative *DecodeToPicture(std::shared_ptr<OH_ImageSourceNative> &imageSourcePtr,
        std::shared_ptr<OH_DecodingOptionsForPicture> &optionsPtr, Image_Size &imageSize);
    static SHARED_PTR<Image> Decode(int64_t fd);
    static std::shared_ptr<OH_ImageSourceNative> getImageSourcePtr(int64_t fd);
    static SHARED_PTR<Image> CreateImageByPicture(OH_PictureNative *picture, Image_Size imageSize,
        bool isSupportWaterMark = false, bool isForExport = false);
    static std::function<void(Image *info)> ReleaseImageFunc();
    static VOID ParseAuxiLiaryPicture(OH_PictureNative *picture, Image *result, bool isSupportWaterMark);
    static bool ScalePictureIfNecessary(OH_PictureNative *picture, Image_Size imageSize, float *downSampleScale);
    static bool UpdateMetaData(OH_PictureNative *picture);
    static OH_PictureNative *DecodePictureByFd(int64_t fd, Image_Size maxDecodeSize);
    static OH_PictureNative *DecodeAndCalculateSize(int fd, Image_Size *previewSize, Image_Size *exportSize);
    static void CalculateDecodeSize(int fd, Image_Size *previewSize, Image_Size *exportSize);
    static Image_Size GetSimplerSizer(uint32_t width, uint32_t height, int maxSize);
    static Image_Size GetSimplerPreviewSizer(uint32_t width, uint32_t height);
    static void SetSourceMimeType(int fd);
};
#endif // HMC_OHOS_IMAGE_DECODER_H
