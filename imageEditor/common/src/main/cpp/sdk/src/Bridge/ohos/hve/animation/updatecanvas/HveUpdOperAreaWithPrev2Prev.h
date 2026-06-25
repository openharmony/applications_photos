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

#ifndef OH_HVEUPDOPERAREAWITHPREV2PREV_H
#define OH_HVEUPDOPERAREAWITHPREV2PREV_H

#include "ohos/hve/animation/updatecanvas/HveUpdOperAreaAnimation.h"

/*
 * Description: 预览页面切换到预览页面 + 裁剪可操作区域变更
 * Create: 2023/11/2
 */
class HveUpdOperAreaWithPrev2Prev final : public HveUpdOperAreaAnimation {
public:
    HveUpdOperAreaWithPrev2Prev(HveTimeline *timeline, const HmcUid &assetUid, HmcSize newCanvasSize,
        const HmcRectD &oldCropOperationArea, bool isDeviceVertical, AnimationType type);
    ~HveUpdOperAreaWithPrev2Prev();

    PreviewAssetAnimationArea PkgParams() override;
};

#endif // OH_HVEUPDOPERAREAWITHPREV2PREV_H
