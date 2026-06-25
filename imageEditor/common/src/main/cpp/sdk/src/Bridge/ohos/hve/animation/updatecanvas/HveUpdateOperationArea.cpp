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

#include "HveUpdateOperationArea.h"
#include "ohos/BackgroundTaskManager.h"

HveUpdateOperationArea::HveUpdateOperationArea(HveTimeline *timeline, const HmcUid &assetUid, HmcSize newCanvasSize,
    const HmcRectD &oldCropOperationArea, bool isDeviceVertical, AnimationType type)
    : HveUpdOperAreaAnimation(timeline, assetUid, newCanvasSize, oldCropOperationArea, isDeviceVertical, type)
{}

HveUpdateOperationArea::~HveUpdateOperationArea() {}

void HveUpdateOperationArea::DoAnimation()
{
    auto editor = m_timeline->GetEditor();
    auto hveAsset = m_timeline->GetHveAsset(m_assetUid);
    auto cropOperationArea = m_timeline->GetCropOperationArea();
    auto timeline = GetHveTimeline();
    auto assetUid = GetHmcUid();
    auto newCropRect = GetNewCropRect();
    auto newCanvasSize = GetNewCanvasSize();
    auto oldCanvasSize = GetOldCanvasSize();

    HmcEditorSetAutoFlush(editor, false);

    // 更新画布大小
    HmcEditorSetCanvasSize(editor, m_newCanvasSize.width, m_newCanvasSize.height);

    // 更新素材大小和偏移坐标
    UpdateCanvasRect updCanvasCropRect = { oldCanvasSize, newCanvasSize, m_oldCropRect, newCropRect };
    HveUpdOperAreaAnimation::UpdateCropAsset(timeline, assetUid, updCanvasCropRect, m_oldAssetArea,
        static_cast<float>(m_updateAssetScale));
    if (hveAsset->GetInPreviewMode()) {
        HveAssetOper::UpdatePreviewModeAsset(m_timeline, m_assetUid, m_oldCropRect, m_newCropRect,
            m_oldCropOperationArea, oldCanvasSize, static_cast<float>(m_updateAssetScale));
    } else {
        HmcAssetPoint previewPos = HveAssetOper::CalPreviewAssetPos(timeline, assetUid, m_oldCropRect, m_newCropRect,
            oldCanvasSize, static_cast<float>(m_updateAssetScale));
        hveAsset->SetPreviewOffsetX(previewPos.x);
        hveAsset->SetPreviewOffsetY(previewPos.y);
    }

    HmcEditorSetAutoFlush(editor, true);

    HveAssetOper::UpdateCropLimitation(m_timeline, m_oldCropRect, m_newCropRect, m_timeline->GetCropLimitation(),
        m_updateAssetScale);

    // 更新HveAsset中保存的原始素材大小和偏移坐标
    BACKGROUND_TASK_MGR->Submit([timeline, assetUid, newCanvasSize, oldCanvasSize, cropOperationArea]() {
        HveAssetOper::UpdateAssetDefaultArea(timeline, assetUid, cropOperationArea, newCanvasSize, oldCanvasSize);
    },
        __FUNCTION__);
}