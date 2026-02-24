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

#include "HveUpdOperAreaWithPrev2Crop.h"

HveUpdOperAreaWithPrev2Crop::HveUpdOperAreaWithPrev2Crop(HveTimeline *timeline, const HmcUid &assetUid,
    HmcSize newCanvasSize, const HmcRectD &oldCropOperationArea, bool isDeviceVertical, AnimationType type)
    : HveUpdOperAreaAnimation(timeline, assetUid, newCanvasSize, oldCropOperationArea, isDeviceVertical, type)
{}

HveUpdOperAreaWithPrev2Crop::~HveUpdOperAreaWithPrev2Crop() {}

bool HveUpdOperAreaWithPrev2Crop::CheckAnimation()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    return hveAsset->GetInPreviewMode();
}

void HveUpdOperAreaWithPrev2Crop::PrepareAnimation()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    hveAsset->SetAdjustVignetteEnable(false);
}

PreviewAssetAnimationArea HveUpdOperAreaWithPrev2Crop::PkgParams()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);

    PreviewAssetAnimationArea animationVar = { 0.0F };
    animationVar.srcOffsetX = hveAsset->GetPreviewOffsetX();
    animationVar.srcOffsetY = hveAsset->GetPreviewOffsetY();
    animationVar.dstOffsetX = m_newCropRect.CenterX() - m_newCanvasSize.width / 2;
    animationVar.dstOffsetY = m_newCanvasSize.height / 2 - m_newCropRect.CenterY();
    animationVar.srcScale = hveAsset->GetPreviewScale();
    animationVar.dstScale = 1.0F * m_updateAssetScale;
    return animationVar;
}
