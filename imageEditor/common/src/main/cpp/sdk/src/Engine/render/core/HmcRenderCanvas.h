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

#ifndef HMCRENDERCANVAS_H
#define HMCRENDERCANVAS_H

#include "render/base/RenderBase.h"
#include "HmcRenderColor.h"
#include "render/graphic/HmcRenderTexture.h"

class HmcRenderCanvas {
public:
    HmcRenderCanvas();
    ~HmcRenderCanvas();
    INT32 x_ = 0;
    INT32 y_ = 0;
    INT32 width_ = 0;
    INT32 height_ = 0;
    INT32 canvasWidth_ = 0;
    INT32 canvasHeight_ = 0;

    HmcRenderColor bgColor_;
    HmcRenderColor borderColor_;
    HmcRenderTexturePtr bgTexture_;
};

#endif // HMCRENDERCANVAS_H
