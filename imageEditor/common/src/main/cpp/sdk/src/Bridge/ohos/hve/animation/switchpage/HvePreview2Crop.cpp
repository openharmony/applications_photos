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

#include "HvePreview2Crop.h"

HvePreview2Crop::HvePreview2Crop(HveTimeline *timeline, const HmcUid &assetUid, UINT64 animMs)
    : HveSwitchPageAnimation(timeline, assetUid, ONLY_SWITCH_PREV_TO_CROP, animMs)
{}

HvePreview2Crop::~HvePreview2Crop() {}

bool HvePreview2Crop::CheckAnimation()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    return hveAsset->GetInPreviewMode();
}

void HvePreview2Crop::PrepareAnimation()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    hveAsset->SetAdjustVignetteEnable(false);
}

PreviewAssetAnimationArea HvePreview2Crop::PkgParams()
{
    auto editor = m_timeline->GetEditor();
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    auto cropRect = m_timeline->GetCropRect();

    PreviewAssetAnimationArea animationVar = { 0.0F };
    animationVar.srcOffsetX = hveAsset->GetPreviewOffsetX();
    animationVar.srcOffsetY = hveAsset->GetPreviewOffsetY();
    animationVar.dstOffsetX = cropRect.CenterX() - canvasWidth / 2;
    animationVar.dstOffsetY = canvasHeight / 2 - cropRect.CenterY();
    animationVar.srcScale = hveAsset->GetPreviewScale();
    animationVar.dstScale = 1.0F;
    return animationVar;
}