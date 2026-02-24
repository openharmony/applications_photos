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

#include "HveSwitchPageAnimation.h"

bool HveSwitchPageAnimation::isShowWaterChangeAnimation = true;

HveSwitchPageAnimation::HveSwitchPageAnimation(HveTimeline *timeline, const HmcUid &assetUid, AnimationType type,
    UINT64 animMs)
    : HveAnimationBase(timeline, assetUid, type), m_animMs(animMs)
{}

HveSwitchPageAnimation::~HveSwitchPageAnimation() {}

void HveSwitchPageAnimation::DoAnimation()
{
    auto timeline = GetHveTimeline();
    auto assetUid = GetHmcUid();
    auto animationType = GetAnimationType();
    PreviewAssetAnimationArea animationVar = PkgParams();

    HmcSize canvasSize;
    HmcEditorGetCanvasSize(timeline->GetEditor(), &canvasSize.width, &canvasSize.height);
    auto cropRect = timeline->GetCropRect();
    
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        return;
    }
    int refreshRate = hveAsset->GetRefreshRate();

    std::function<void(const std::string& animationResult)> cb = GetAnimationCb();
    postAnimation(
        [timeline, assetUid, animationVar, cropRect, canvasSize, animationType, cb](float progress, bool startFlag) {
            if (!HveAnimationBase::CheckTimeline(timeline, assetUid)) {
                return;
            }

            auto editor = timeline->GetEditor();
            HmcEditorSetAutoFlush(editor, false);
            if (startFlag) {
                HveSwitchPageAnimation::ProcessStart(timeline, assetUid, cropRect, canvasSize, animationType);
            } else if(progress < DOUBLE_PRECISION) {
                HveSwitchPageAnimation::ProcessStart(timeline, assetUid, cropRect, canvasSize, animationType);
            }
            if (fabs(progress - 1.0) < DOUBLE_PRECISION) {
                HveSwitchPageAnimation::ProcessEnd(timeline, assetUid, animationVar, cropRect, animationType);
                HveAnimationBase::ProcessCallback(timeline, animationType, cb);
            } else {
                HveSwitchPageAnimation::Processing(timeline, assetUid, animationVar, animationType, progress);
            }

            HmcEditorSetAutoFlush(editor, true);
        },
        m_animMs, refreshRate);
}

void HveSwitchPageAnimation::AfterAnimation()
{
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);

    if (m_animationType == ONLY_SWITCH_CROP_TO_PREV || IsWatermarkAnimation(m_animationType) ||
        IsXtStyleAnimation(m_animationType)) {
        hveAsset->SetInPreviewMode(true);
    } else {
        hveAsset->SetInPreviewMode(false);
    }
}

void HveSwitchPageAnimation::ProcessStart(HveTimeline *timeline, const HmcUid assetUid,
                                          const HmcRectD &cropRect, HmcSize canvasSize, AnimationType type)
{
    if (type == ONLY_SWITCH_CROP_TO_PREV || IsWatermarkAnimation(type)) {
        float left = cropRect.left / canvasSize.width;
        float top = 1 - cropRect.top / canvasSize.height;
        float right = cropRect.right / canvasSize.width;
        float bottom = 1 - cropRect.bottom / canvasSize.height;
        HmcAssetCropPosition cropPosition = {{left, top}, {left, bottom}, {right, top}, {right, bottom}};
        LOGI("ProcessStart position is %f %f %f %f %d", cropRect.left, cropRect.top, cropRect.right, cropRect.bottom,
             type);
        HmcAssetCropTransformSetCrop(timeline->GetEditor(), assetUid, &cropPosition);
    }
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("hveAsset is nullptr.");
        return;
    }
    WatermarkParam watermarkParam = {.watermarkType = hveAsset->GetWatermarkType(),
                                     .watermarkOpacity = IsOpacityUpAnimation(type) ? 0.0 : 1.0,
                                     .exportW = hveAsset->GetExportW(),
                                     .exportH = hveAsset->GetExportH(),
                                     .isAlwaysShow = IsAlwaysShowWatermarkAnimation(type) ? 1 : 0};
    LOGI("ProcessStart type=%d, isAlwaysShow = %d watermarkOpacity= %f", type, watermarkParam.isAlwaysShow,
         watermarkParam.watermarkOpacity);
    HmcAssetSetWatermark(assetUid, watermarkParam);
    hveAsset->SetIsSwitchPage(true);
}

void HveSwitchPageAnimation::Processing(HveTimeline *timeline, const HmcUid assetUid,
    PreviewAssetAnimationArea animationVar, AnimationType type, float progress)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);

    float watermarkOpacity = IsOpacityUpAnimation(type) ? progress : 1.0 - progress;
    WatermarkParam watermarkParam = {.watermarkType = hveAsset->GetWatermarkType(),
                                     .watermarkOpacity = watermarkOpacity,
                                     .exportW = hveAsset->GetExportW(),
                                     .exportH = hveAsset->GetExportH(),
                                     .isAlwaysShow = IsAlwaysShowWatermarkAnimation(type) ? 1 : 0};
    LOGI("Processing type=%d, isAlwaysShow = %d  watermarkOpacity= %f progress = %f", type, watermarkParam.isAlwaysShow,
         watermarkParam.watermarkOpacity, progress);
    HmcAssetSetWatermark(assetUid, watermarkParam);   
    
    float newPreviewScale = animationVar.srcScale + (animationVar.dstScale - animationVar.srcScale) * progress;
    float newPreviewOffsetX = animationVar.srcOffsetX + (animationVar.dstOffsetX - animationVar.srcOffsetX) * progress;
    float newPreviewOffsetY = animationVar.srcOffsetY + (animationVar.dstOffsetY - animationVar.srcOffsetY) * progress;

    HmcAssetCropTransformSetPosition(editor, assetUid, newPreviewOffsetX, newPreviewOffsetY, newPreviewScale,
        newPreviewScale, 0);
    hveAsset->SetPreviewScale(newPreviewScale);
    hveAsset->SetPreviewOffsetX(newPreviewOffsetX);
    hveAsset->SetPreviewOffsetY(newPreviewOffsetY);
}

void HveSwitchPageAnimation::ProcessEnd(HveTimeline *timeline, const HmcUid assetUid,
    PreviewAssetAnimationArea animationVar, const HmcRectD &cropRect, AnimationType type)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);

    WatermarkParam watermarkParam = {.watermarkType = hveAsset->GetWatermarkType(),
                                     .watermarkOpacity = IsOpacityUpAnimation(type) ? 1.0 : 0.0,
                                     .exportW = hveAsset->GetExportW(),
                                     .exportH = hveAsset->GetExportH(),
                                     .isAlwaysShow = 0};
    HmcAssetSetWatermark(assetUid, watermarkParam);

    hveAsset->SetIsSwitchPage(false);
    hveAsset->SetPreviewScale(animationVar.dstScale);
    hveAsset->SetPreviewOffsetX(animationVar.dstOffsetX);
    hveAsset->SetPreviewOffsetY(animationVar.dstOffsetY);
    HmcAssetCropTransformSetPosition(editor, assetUid, animationVar.dstOffsetX, animationVar.dstOffsetY,
                                     animationVar.dstScale, animationVar.dstScale, 0);
    
    if (type == ONLY_SWITCH_CROP_TO_PREV || IsWatermarkAnimation(type)) {
        // 动画结束开启暗角
        hveAsset->SetAdjustVignetteEnable(true);
    }
}

bool HveSwitchPageAnimation::CheckParams()
{
    if (!HveAnimationBase::CheckTimeline(m_timeline, m_assetUid)) {
        return false;
    }

    if (m_animationType == ONLY_SWITCH_CROP_TO_PREV || m_animationType == ONLY_SWITCH_PREV_TO_CROP ||
        IsWatermarkAnimation(m_animationType)) {
        return true;
    }
    
    if (IsXtStyleAnimation(m_animationType)) {
        return true;
    }
    
    LOGE("[SwitchPageAnimation] Invalid type.");
    return false;
}

bool HveSwitchPageAnimation::IsWatermarkAnimation(AnimationType animationType)
{
    if (animationType == UPD_STICKER_WITH_SIZE || animationType == UPD_STICKER_NO_SIZE) {
        return true;
    }
    return false;
}

bool HveSwitchPageAnimation::IsOpacityUpAnimation(AnimationType animationType)
{
    if (IsWatermarkAnimation(animationType) || animationType == ONLY_SWITCH_CROP_TO_PREV) {
        return true;
    }
    return false;
}

bool HveSwitchPageAnimation::IsAlwaysShowWatermarkAnimation(AnimationType animationType)
{
    if (isShowWaterChangeAnimation && (IsWatermarkAnimation(animationType) ||
        animationType == ONLY_SWITCH_PREV_TO_CROP)) {
        return true;
    }
    return false;
}

bool HveSwitchPageAnimation::IsXtStyleAnimation(AnimationType type)
{
    return type == OPEN_XTSTYLE_PALETTE || type == CLOSE_XTSTYLE_PALETTE;
}

void HveSwitchPageAnimation::setIsShowWaterChangeAnimation(bool value)
{
    isShowWaterChangeAnimation = value;
}