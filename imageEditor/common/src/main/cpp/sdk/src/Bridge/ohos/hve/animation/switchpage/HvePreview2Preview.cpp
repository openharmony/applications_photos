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

#include "HvePreview2Preview.h"
#include "log/HmcLog.h"

HvePreview2Preview::HvePreview2Preview(HveTimeline *timeline, const HmcUid &assetUid, AnimationType type, UINT64 animMs)
    : HveSwitchPageAnimation(timeline, assetUid, type, animMs) {}

HvePreview2Preview::~HvePreview2Preview() {}

bool HvePreview2Preview::CheckAnimation()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    return hveAsset->GetInPreviewMode();
}

void HvePreview2Preview::PrepareAnimation()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    if (hveAsset->CanDrawWatermark()) {
        return;
    }
    hveAsset->SetAdjustVignetteEnable(false);
}

PreviewAssetAnimationArea HvePreview2Preview::PkgParams()
{
    auto editor = m_timeline->GetEditor();
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    float canvasWidth;
    float canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    auto cropRect = m_timeline->GetCropRect();

    hveAsset->InitWatermarkCache(cropRect);

    PreviewAssetAnimationArea animationVar = {0.0F};
    animationVar.srcOffsetX = hveAsset->GetPreviewOffsetX();
    animationVar.srcOffsetY = hveAsset->GetPreviewOffsetY();
    animationVar.srcScale = hveAsset->GetPreviewScale();
    if (m_animationType == UPD_STICKER_NO_SIZE) {
        LOGI("HvePreview2Preview: crop size do not change. animationType : %d", m_animationType);
        animationVar.dstOffsetX = animationVar.srcOffsetX;
        animationVar.dstOffsetY = animationVar.srcOffsetY;
        animationVar.dstScale = animationVar.srcScale;
        return animationVar;
    }

    animationVar.dstScale = hveAsset->CalcPreviewModeAssetScale(cropRect, m_timeline->GetCropOperationArea());
    animationVar.dstOffsetX = cropRect.CenterX() - canvasWidth * HALF;
    animationVar.dstOffsetY = canvasHeight * HALF - cropRect.CenterY();

    LOGI("HvePreview2Preview: srcOffsetX=%f, srcOffsetY=%f, srcScale=%f", animationVar.srcOffsetX,
         animationVar.srcOffsetY, animationVar.srcScale);
    LOGI("HvePreview2Preview: dstOffsetX=%f, dstOffsetY=%f, dstScale=%f", animationVar.dstOffsetX,
         animationVar.dstOffsetY, animationVar.dstScale);

    return animationVar;
}