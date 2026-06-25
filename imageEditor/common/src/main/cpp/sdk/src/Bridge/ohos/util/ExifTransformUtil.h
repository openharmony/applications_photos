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
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef NEWPHOTOS_EXIFTRANSFORMUTIL_H
#define NEWPHOTOS_EXIFTRANSFORMUTIL_H

#include "ohos/hve/HveTimeline.h"

class ExifTransformUtil {
public:
    /**
     * 处理EXIF信息预览
     *
     * @param timeline HveTimeline
     * @param assetUid HmcUid
     * @param reEdit 是否保存过再次编辑
     * @param revert 是否保存前回退EXIF预览
     * @param isReset 是否重置redoUndo
     */
    static void ProcessExifOnExist(HveTimeline *timeline, HmcUid &assetUid, bool reEdit, bool revert,
        bool isReset = true);
    
    static STRING ProcessExifOnExistForPixelmap(HmcUid &assetUid, OH_PixelmapNative *pixelmap, STRING orientation = "");
    static STRING ProcessExifOnExistForPicture(HmcUid &assetUid, OH_PictureNative *picture, STRING orientation = "");
    
    static void DoMirrorOrRotate(OH_PixelmapNative *pixelmap, bool horizontal, bool vertical, float rotateValue);
};

#endif // NEWPHOTOS_EXIFTRANSFORMUTIL_H
