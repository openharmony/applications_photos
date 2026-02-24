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

#ifndef OH_HVECROP2PREVIEW_H
#define OH_HVECROP2PREVIEW_H

#include "ohos/hve/animation/switchpage/HveSwitchPageAnimation.h"
#include "ohos/util/HveTransformUtil.h"

/*
 * Description: 裁剪页面切换到非裁剪页面（截取、调节、滤镜）动画
 * Create: 2023/11/1
 */
class HveCrop2Preview final : public HveSwitchPageAnimation {
public:
    HveCrop2Preview(HveTimeline *timeline, const HmcUid &assetUid, UINT64 animMs);
    ~HveCrop2Preview();

    bool CheckAnimation() override;
    PreviewAssetAnimationArea PkgParams() override;
};

#endif // OH_HVECROP2PREVIEW_H
