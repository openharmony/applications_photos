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

#include "HveCrop2Preview.h"
#include "MediaCreative/HmcEditorAsset.h"

HveCrop2Preview::HveCrop2Preview(HveTimeline *timeline, const HmcUid &assetUid, UINT64 animMs)
    : HveSwitchPageAnimation(timeline, assetUid, ONLY_SWITCH_CROP_TO_PREV, animMs)
{}

HveCrop2Preview::~HveCrop2Preview() {}

bool HveCrop2Preview::CheckAnimation()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    return !hveAsset->GetInPreviewMode();
}

PreviewAssetAnimationArea HveCrop2Preview::PkgParams()
{
    auto editor = m_timeline->GetEditor();
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    float canvasWidth;
    float canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    auto cropRect = m_timeline->GetCropRect();

    double wmOffset = 0.0;
    int watermarkType = hveAsset->GetWatermarkType();
    bool isShowWatermark = hveAsset->GetShowWatermarkValue();
    if (watermarkType != HMC_ASSET_NO_STICKER && isShowWatermark) {
        LOGI("HveCrop2Preview: Watermarks exist. watermarkType : %d", watermarkType);
        hveAsset->InitWatermarkCache(cropRect);
    }
    LOGI("HveCrop2Preview: canvasHeight : %f  CenterY: %f  wmOffset: %f", canvasHeight, cropRect.CenterY(), wmOffset);
    LOGI("HveCrop2Preview: cropRect left: %f  top: %f  right: %f bottom: %f", cropRect.left, cropRect.top,
         cropRect.right, cropRect.bottom);

    PreviewAssetAnimationArea animationVar = { 0.0F };
    animationVar.dstScale = hveAsset->CalcPreviewModeAssetScale(cropRect, m_timeline->GetCropOperationArea());
    animationVar.dstOffsetX = cropRect.CenterX() - canvasWidth * HALF;
    animationVar.dstOffsetY = canvasHeight * HALF - cropRect.CenterY() + wmOffset * animationVar.dstScale;
    animationVar.srcOffsetX = hveAsset->GetPreviewOffsetX();
    animationVar.srcOffsetY = hveAsset->GetPreviewOffsetY();
    animationVar.srcScale = 1.0F;
    animationVar.dstScale = hveAsset->CalcPreviewModeAssetScale(cropRect, m_timeline->GetCropOperationArea());
    
    LOGI("HveCrop2Preview: srcOffsetX : %f  dstOffsetX: %f", animationVar.srcOffsetX, animationVar.dstOffsetX);
    LOGI("HveCrop2Preview: srcOffsetY : %f  dstOffsetY: %f", animationVar.srcOffsetY, animationVar.dstOffsetY);
    return animationVar;
}