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
#ifndef OH_HMC_SAMPLE_SIZER_H
#define OH_HMC_SAMPLE_SIZER_H

#include "log/HmcLog.h"
class HmcSimplerSizer {
public:
    const static int MAX_IMAGE_SIZE = 8192;
    const static int MIN_PREVIEW_SIZE = 2048;
    const int MIN_IMAGE_SIZE = 2;
    
    int width_ = 0;
    int height_ = 0;
    int sampleSize_ = 1;
    const int maxSize_;

    HmcSimplerSizer(int width, int height, int maxSize = 2048): maxSize_(maxSize)
    {
        width_ = width;
        height_ = height;
        if (width > maxSize_ || height > maxSize_) {
            int size = width > height ? width : height;
            while (size / sampleSize_ > maxSize_) {
                if ((size / (sampleSize_ * MIN_IMAGE_SIZE)) < MIN_PREVIEW_SIZE) {
                    break;
                }
                sampleSize_ *= MIN_IMAGE_SIZE;
            }
        }
        LOGI("HmcSimplerSizer sample Size = %d, width = %d, height = %d",
            sampleSize_, width_ / sampleSize_, height_ / sampleSize_);
    }
    
    int GetSampleWidth()
    {
        return width_ / sampleSize_ > MIN_IMAGE_SIZE ? width_ / sampleSize_ : MIN_IMAGE_SIZE;
    }
    
    int GetSampleHeight()
    {
        return height_ / sampleSize_ > MIN_IMAGE_SIZE ? height_ / sampleSize_ : MIN_IMAGE_SIZE;
    }
};
#endif
