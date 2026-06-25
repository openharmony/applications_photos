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

#ifndef HMCRENDERLAYER_H
#define HMCRENDERLAYER_H

#include "render/core/HmcRenderEffect.h"
#include "render/graphic/HmcRenderTexture.h"

class HmcRenderTexture;
class HmcRenderEffect;

class HmcRenderLayer {
public:
    explicit HmcRenderLayer();
    HmcRenderLayer(const HmcRenderLayer &layer) = default;
    HmcRenderLayer &operator = (const HmcRenderLayer &) = default;
    ~HmcRenderLayer();
    // 设置当前的时间戳
    VOID SetTimeStamp(INT64 timeStamp);

    // 向当前layer中添加纹理
    BOOL AddTexture(HmcRenderTexture *texture, STRING texName = MAIN_TEX);
    HmcRenderTexture *GetTexture(STRING texName = MAIN_TEX);

    // 向当前layer中添加特效，idx表示插入位置（前插），如果当前layer中存在纹理，则特效为纹理之上的效果，如果不存在纹理，特效为全屏效果
    VOID AddEffect(HmcRenderEffectPtr &effect, INT32 idx = -1);

    VOID AddEffect(HmcRenderEffectPtr &effect, INT32 idx, INT32 timeStamp);

    // 过滤默认值的特效
    BOOL EffectFilter(HmcRenderEffect *effect);

    // 时间戳
    INT64 m_timeStamp = 0;

    // 当前layer的纹理列表, 当前只有一个纹理，定义成list是扩展考虑
    MAP<STRING, HmcRenderTexturePtr> m_textureList;

    // 当前layer的特效列表，
    LIST<HmcRenderEffectPtr> m_effectList;
    
    // 当前是否在PreviewMode
    bool m_IsInPreviewMode = true;
    // 当前是否在做切换页面动效
    bool m_IsSwitchPage = false;
    // 当前是否要渲染水印
    bool m_isDrawWaterMark = false;
    // 当前是否在拖动图片
    bool m_isDragImage = false;

    HmcUid m_sourceAsset;
    HmcUid m_sourceLane;
    
    VOID CopyHmcLayerInfo(std::shared_ptr<HmcRenderLayer> &srcLayer);
};

using HmcRenderLayerPtr = SHARED_PTR<HmcRenderLayer>;

#endif // HMCRENDERLAYER_H
