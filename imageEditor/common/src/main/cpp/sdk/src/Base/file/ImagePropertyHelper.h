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

#ifndef NEWPHOTOS_IMAGEPROPERTYHELPER_H
#define NEWPHOTOS_IMAGEPROPERTYHELPER_H

#include "HmcBaseType.h"
#include <multimedia/image_framework/image/image_source_native.h>

/**
 * 图片EXIF信息获取
 */
class ImagePropertyHelper {
public:
    // 通过路径查图像EXIF信息
    static STRING GetImageProperty(const STRING path, const STRING property);
    // 通过FD查图像EXIF信息
    static STRING GetImageProperty(const INT32 fd, const STRING property);
    
    // 通过FD查图像EXIF信息
    static VECTOR<STRING> GetImageProperties(const INT32 fd, VECTOR<STRING> keys);

private:
    static STRING GetImageProperty(const OH_ImageSourceNative *imageSource, const STRING property);
};

#endif // NEWPHOTOS_IMAGEPROPERTYHELPER_H
