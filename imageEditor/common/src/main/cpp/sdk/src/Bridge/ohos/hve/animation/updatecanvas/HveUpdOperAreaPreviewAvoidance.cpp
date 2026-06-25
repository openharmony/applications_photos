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

#include "HveUpdOperAreaPreviewAvoidance.h" 

HveUpdOperPreviewAvoidance::HveUpdOperPreviewAvoidance(
    const std::tuple<HveTimeline *, HmcUid, HmcSize, HmcRectD, bool, AnimationType> &p) : HveUpdOperAreaAnimation(
        std::get<0>(p), std::get<1>(p), std::get<2>(p), std::get<3>(p), std::get<4>(p), std::get<5>(p)) {}

HveUpdOperPreviewAvoidance::~HveUpdOperPreviewAvoidance() {}

PreviewAssetAnimationArea HveUpdOperPreviewAvoidance::PkgParams()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);

    auto cropRect = m_timeline->GetCropRect();
    double wmOffset = 0.0;
    int watermarkType = hveAsset->GetWatermarkType();
    bool isShowWatermark = hveAsset->GetShowWatermarkValue();
    if (watermarkType != HMC_ASSET_NO_STICKER && isShowWatermark) {
        LOGI("HveCrop2Preview: Watermarks exist. watermarkType : %d", watermarkType);
        hveAsset->InitWatermarkCache(cropRect);
    }
    
    PreviewAssetAnimationArea animationVar = { 0.0F };
    animationVar.srcOffsetX = hveAsset->GetPreviewOffsetX();
    animationVar.srcOffsetY = hveAsset->GetPreviewOffsetY();
    animationVar.dstOffsetX = m_newCropRect.CenterX() - m_newCanvasSize.width / 2;
    animationVar.dstScale =
        hveAsset->CalcPreviewModeAssetScale(m_newCropRect, m_timeline->GetCropOperationArea()) * m_updateAssetScale;
    animationVar.dstOffsetY = m_newCanvasSize.height / 2 - m_newCropRect.CenterY() + wmOffset * animationVar.dstScale;
    animationVar.srcScale = hveAsset->GetPreviewScale();
    return animationVar;
}