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

#ifndef NEWPHOTOS_HVEUPDOPERAREAPREVIEWAVOIDANCE_H
#define NEWPHOTOS_HVEUPDOPERAREAPREVIEWAVOIDANCE_H

#include "ohos/hve/animation/updatecanvas/HveUpdOperAreaAnimation.h"

/*
 * Description: Preview area move aside when modal box pops up
 * Create: 2025-8-6
 */
class HveUpdOperPreviewAvoidance final : public HveUpdOperAreaAnimation {
public:
    explicit HveUpdOperPreviewAvoidance(
        const std::tuple<HveTimeline *, HmcUid, HmcSize, HmcRectD, bool, AnimationType> &params);
    ~HveUpdOperPreviewAvoidance();

    PreviewAssetAnimationArea PkgParams() override;
};

#endif //NEWPHOTOS_HVEUPDOPERAREAPREVIEWAVOIDANCE_H
