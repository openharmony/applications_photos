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

#ifndef OH_HVEPREVIEW2CROP_H
#define OH_HVEPREVIEW2CROP_H

#include "ohos/hve/animation/switchpage/HveSwitchPageAnimation.h"

/*
 * Description: 非裁剪页面（截取、调节、滤镜）切换到裁剪页面动画
 * Create: 2023/11/1
 */
class HvePreview2Crop final : public HveSwitchPageAnimation {
public:
    HvePreview2Crop(HveTimeline *timeline, const HmcUid &assetUid, UINT64 animMs);
    ~HvePreview2Crop();

    bool CheckAnimation() override;
    void PrepareAnimation() override;
    PreviewAssetAnimationArea PkgParams() override;
};

#endif // OH_HVEPREVIEW2CROP_H
