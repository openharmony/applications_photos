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

#include "HveUpdOperAreaAnimation.h"

HveUpdOperAreaAnimation::HveUpdOperAreaAnimation(HveTimeline *timeline, const HmcUid &assetUid, HmcSize newCanvasSize,
    const HmcRectD &oldCropOperationArea, bool isDeviceVertical, AnimationType type)
    : HveAnimationBase(timeline, assetUid, type),
      m_newCanvasSize(newCanvasSize),
      m_oldCropOperationArea(oldCropOperationArea),
      m_isDeviceVertical(isDeviceVertical)
{
    InitAnimation();
}

HveUpdOperAreaAnimation::~HveUpdOperAreaAnimation() {}

void HveUpdOperAreaAnimation::InitAnimation()
{
    auto editor = m_timeline->GetEditor();
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    // 1. 获取画布变更之前素材大小、偏移坐标和画布宽高
    HmcSize size;
    HmcAssetGetSize(editor, m_assetUid, HMC_SIZE_RENDER, &size);
    LOGD("InitAnimation size width = %f, size height = %f", size.width, size.height);
    float posX;
    float posY;
    HmcAssetGetPositionByCenter(editor, m_assetUid, &posX, &posY);
    m_oldAssetArea = { size.width, size.height, posX, posY };

    HmcEditorGetCanvasSize(editor, &m_oldCanvasSize.width, &m_oldCanvasSize.height);

    // 2.计算在新的可操作区域中裁剪框坐标
    m_oldCropRect = m_timeline->GetCropRect();
    auto cropOperationArea = m_timeline->GetCropOperationArea();
    HveAssetOper::GetCenterInsideRectUnderRatio(m_oldCropRect.Width() / m_oldCropRect.Height(), cropOperationArea,
        &m_newCropRect);
    LOGI("UpdateAsset %f %f %f %f", m_newCropRect.left,m_newCropRect.right, m_newCropRect.top, m_newCropRect.bottom);
    // 3.计算画布变更后素材的缩放比
    double cropWidthScale = m_newCropRect.Width() / m_oldCropRect.Width();
    double cropHeightScale = m_newCropRect.Height() / m_oldCropRect.Height();
    m_updateAssetScale = HMC_MIN(cropWidthScale, cropHeightScale);
    LOGD("UpdateAsset scale=%lf", m_updateAssetScale);
}

void HveUpdOperAreaAnimation::DoAnimation()
{
    auto timeline = GetHveTimeline();
    auto assetUid = GetHmcUid();
    auto cropScale = GetUpdateAssetScale();
    auto assetArea = GetOldAssetArea();
    auto animationType = GetAnimationType();
    UpdateCanvasRect canvasAndCropVar = PackCanvasAndCropRect();
    PreviewAssetAnimationArea animationVar = PkgParams();
    
    auto hveAsset = timeline->GetHveAsset(assetUid);
    int refreshRate = hveAsset->GetRefreshRate();
    auto progressFunc = m_progressFunc;
    postAnimation(
        [timeline, assetUid, canvasAndCropVar, animationVar, cropScale, assetArea, animationType,
         progressFunc](float progress, bool startFlag) {
            if (!HveAnimationBase::CheckTimeline(timeline, assetUid)) {
                return;
            }

            auto editor = timeline->GetEditor();
            HmcEditorSetAutoFlush(editor, false);
            if (startFlag) {
                HveUpdOperAreaAnimation::ProcessStart(editor, assetUid, canvasAndCropVar, animationType);
            }
            if (progressFunc != nullptr) {
                progress = progressFunc(progress);
            }
            if (fabs(progress - 1.0) < DOUBLE_PRECISION) {
                HveUpdOperAreaAnimation::ProcessEnd(timeline, assetUid, canvasAndCropVar, animationVar, assetArea,
                    cropScale, animationType);
            } else {
                HveUpdOperAreaAnimation::Processing(timeline, assetUid, animationVar, progress);
            }
            HmcEditorSetAutoFlush(editor, true);
        },
        m_animMs, refreshRate);
}

void HveUpdOperAreaAnimation::ProcessStart(HmcEditor *editor, const HmcUid assetUid, UpdateCanvasRect canvasAndCropRect,
    AnimationType type)
{
    if (type == UPD_OPER_AREA_CROP_TO_PREV || type == UPD_OPER_AREA_PREV_TO_PREV) {
        float left = canvasAndCropRect.oldCropRect.left / canvasAndCropRect.oldCanvasSize.width;
        float top = 1 - canvasAndCropRect.oldCropRect.top / canvasAndCropRect.oldCanvasSize.height;
        float right = canvasAndCropRect.oldCropRect.right / canvasAndCropRect.oldCanvasSize.width;
        float bottom = 1 - canvasAndCropRect.oldCropRect.bottom / canvasAndCropRect.oldCanvasSize.height;
        HmcAssetCropPosition cropPosition = { { left, top }, { left, bottom }, { right, top }, { right, bottom } };
        HmcAssetCropTransformSetCrop(editor, assetUid, &cropPosition);
    }
}

void HveUpdOperAreaAnimation::Processing(HveTimeline *timeline, const HmcUid assetUid,
    PreviewAssetAnimationArea animationVar, float progress)
{
    auto hveAsset = timeline->GetHveAsset(assetUid);

    auto newPreviewScale = animationVar.srcScale + (animationVar.dstScale - animationVar.srcScale) * progress;
    auto newPreviewOffsetX = animationVar.srcOffsetX + (animationVar.dstOffsetX - animationVar.srcOffsetX) * progress;
    auto newPreviewOffsetY = animationVar.srcOffsetY + (animationVar.dstOffsetY - animationVar.srcOffsetY) * progress;
    HmcAssetCropTransformSetPosition(timeline->GetEditor(), assetUid, newPreviewOffsetX, newPreviewOffsetY,
        newPreviewScale, newPreviewScale, 0);

    hveAsset->SetPreviewScale(newPreviewScale);
    hveAsset->SetPreviewOffsetX(newPreviewOffsetX);
    hveAsset->SetPreviewOffsetY(newPreviewOffsetY);
}

void HveUpdOperAreaAnimation::ProcessEnd(HveTimeline *timeline, const HmcUid assetUid,
    UpdateCanvasRect canvasAndCropRect, PreviewAssetAnimationArea animationVar, HmcAssetArea oldAssetArea,
    double updateAssetScale, AnimationType type)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset != nullptr) {
        hveAsset->SetIsSwitchPage(false);
    }
    // 更新画布大小
    HmcEditorSetCanvasSize(editor, canvasAndCropRect.newCanvasSize.width, canvasAndCropRect.newCanvasSize.height);

    // 根据裁剪框缩放比例，计算新的素材大小和偏移坐标
    HveUpdOperAreaAnimation::UpdateCropAsset(timeline, assetUid, canvasAndCropRect, oldAssetArea, updateAssetScale);
    HveUpdOperAreaAnimation::UpdatePreviewAsset(timeline, assetUid, canvasAndCropRect, animationVar, updateAssetScale,
        type);
    HveUpdOperAreaAnimation::UpdateAdjustVignette(timeline, assetUid, type);

    HveAssetOper::UpdateCropLimitation(timeline, canvasAndCropRect.oldCropRect, canvasAndCropRect.newCropRect,
        timeline->GetCropLimitation(), updateAssetScale);

    // 更新HveAsset中保存的原始素材大小和偏移坐标
    auto cropOperationAreaIn = timeline->GetCropOperationArea();
    HveAssetOper::UpdateAssetDefaultArea(timeline, assetUid, cropOperationAreaIn, canvasAndCropRect.newCanvasSize,
        canvasAndCropRect.oldCanvasSize);
}

void HveUpdOperAreaAnimation::UpdateAdjustVignette(HveTimeline *timeline, const HmcUid assetUid, AnimationType type)
{
    if (type == UPD_OPER_AREA_CROP_TO_PREV) {
        // 动画结束开启暗角
        auto hveAsset = timeline->GetHveAsset(assetUid);
        hveAsset->SetAdjustVignetteEnable(true);
    }
}

void HveUpdOperAreaAnimation::UpdatePreviewAsset(HveTimeline *timeline, const HmcUid assetUid,
    UpdateCanvasRect canvasAndCropRect, PreviewAssetAnimationArea animationVar, double updateAssetScale,
    AnimationType type)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);

    float left = canvasAndCropRect.newCropRect.left / canvasAndCropRect.newCanvasSize.width;
    float top = 1 - canvasAndCropRect.newCropRect.top / canvasAndCropRect.newCanvasSize.height;
    float right = canvasAndCropRect.newCropRect.right / canvasAndCropRect.newCanvasSize.width;
    float bottom = 1 - canvasAndCropRect.newCropRect.bottom / canvasAndCropRect.newCanvasSize.height;
    HmcAssetCropPosition cropPosition = {{left, top}, {left, bottom}, {right, top}, {right, bottom}};
    HmcAssetCropTransformSetCrop(editor, assetUid, &cropPosition);
    HmcAssetCropTransformSetPosition(editor, assetUid, animationVar.dstOffsetX, animationVar.dstOffsetY,
                                     animationVar.dstScale / updateAssetScale, animationVar.dstScale / updateAssetScale,
                                     0);
    hveAsset->SetPreviewScale(animationVar.dstScale / updateAssetScale);
    hveAsset->SetPreviewOffsetX(animationVar.dstOffsetX);
    hveAsset->SetPreviewOffsetY(animationVar.dstOffsetY);
}

void HveUpdOperAreaAnimation::UpdateCropAsset(HveTimeline *timeline, const HmcUid assetUid,
    UpdateCanvasRect canvasAndCropRect, HmcAssetArea oldAssetArea, double updateAssetScale)
{
    auto editor = timeline->GetEditor();
    HmcSize size;
    size.width = oldAssetArea.width * updateAssetScale;
    size.height = oldAssetArea.height * updateAssetScale;

    int isHorizontalMirror = 0;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    HmcAssetPoint assetPosition = HveAssetOper::CalAssetPositionByCanvas(canvasAndCropRect,
        HmcAssetPoint{ oldAssetArea.posX, oldAssetArea.posY }, updateAssetScale, isHorizontalMirror);
    LOGD("UpdateCropModeAsset width:%f, height:%f, posX:%f, posY:%f", size.width, size.height, assetPosition.x,
        assetPosition.y);
    HmcAssetSetPositionByCenter(editor, assetUid, assetPosition.x, assetPosition.y);
    HmcAssetSetSize(editor, assetUid, size);

    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset != nullptr) {
        hveAsset->SetAssetSizeAndPosXY(size.width, size.height, assetPosition.x, assetPosition.y, false);
    }
}

void HveUpdOperAreaAnimation::AfterAnimation()
{
    // 更新裁剪框坐标
    m_timeline->SetCropRect(m_newCropRect);
    LOGD("UpdateAsset newCropRect=%lf,%lf,%lf,%lf", m_newCropRect.left, m_newCropRect.top, m_newCropRect.right,
        m_newCropRect.bottom);
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    hveAsset->SetDeviceVertical(m_isDeviceVertical);

    if (m_animationType == UPD_OPER_AREA_PREV_TO_CROP) {
        hveAsset->SetInPreviewMode(false);
    } else if (m_animationType == UPD_OPER_AREA_CROP_TO_PREV || m_animationType == UPD_OPER_AREA_PREV_TO_PREV) {
        hveAsset->SetInPreviewMode(true);
    }
}

bool HveUpdOperAreaAnimation::CheckParams()
{
    return HveAnimationBase::CheckTimeline(m_timeline, m_assetUid);
}

void HveUpdOperAreaAnimation::UpdateAnimationTime(UINT64 animMs)
{
    m_animMs = animMs;
}