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

#ifndef OH_HVEUPDOPERAREAANIMATION_H
#define OH_HVEUPDOPERAREAANIMATION_H

#include "ohos/hve/animation/HveAnimationBase.h"
#include <cstdint>

/*
 * Description: 裁剪可操作区域变更 + 一级菜单切换动画
 * Create: 2023/11/2
 */
class HveUpdOperAreaAnimation : public HveAnimationBase {
public:
    HveUpdOperAreaAnimation(HveTimeline *timeline, const HmcUid &assetUid, HmcSize newCanvasSize,
        const HmcRectD &oldCropOperationArea, bool isDeviceVertical, AnimationType type);

    ~HveUpdOperAreaAnimation();

    void DoAnimation() override;
    
    void UpdateAnimationTime(UINT64 animMs);

    bool CheckParams() override;

    virtual void AfterAnimation() final;

    inline HmcAssetArea GetOldAssetArea() const
    {
        return m_oldAssetArea;
    }

    inline HmcRectD GetNewCropRect() const
    {
        return m_newCropRect;
    }

    inline HmcSize GetNewCanvasSize() const
    {
        return m_newCanvasSize;
    }

    inline HmcSize GetOldCanvasSize() const
    {
        return m_oldCanvasSize;
    }

    inline double GetUpdateAssetScale()
    {
        return m_updateAssetScale;
    }
    
    static void ProcessStart(HmcEditor *editor, const HmcUid assetUid, UpdateCanvasRect canvasAndCropRect,
        AnimationType type);
    static void Processing(HveTimeline *timeline, const HmcUid assetUid, PreviewAssetAnimationArea animationVar,
        float progress);
    static void ProcessEnd(HveTimeline *timeline, const HmcUid assetUid, UpdateCanvasRect pkgCanvasAndCropRect,
        PreviewAssetAnimationArea animationVar, HmcAssetArea oldAssetArea, double updateAssetScale, AnimationType type);
    static void UpdateCropAsset(HveTimeline *timeline, const HmcUid assetUid, UpdateCanvasRect canvasAndCropRect,
        HmcAssetArea oldAssetArea, double updateAssetScale);
    static void UpdatePreviewAsset(HveTimeline *timeline, const HmcUid assetUid, UpdateCanvasRect PkgCanvasAndCropRect,
        PreviewAssetAnimationArea animationVar, double updateAssetScale, AnimationType type);
    static void UpdateAdjustVignette(HveTimeline *timeline, const HmcUid assetUid, AnimationType type);

private:
    void InitAnimation();

    inline UpdateCanvasRect PackCanvasAndCropRect()
    {
        UpdateCanvasRect canvasAndCrop;
        canvasAndCrop.oldCanvasSize = m_oldCanvasSize;
        canvasAndCrop.newCanvasSize = m_newCanvasSize;
        canvasAndCrop.oldCropRect = m_oldCropRect;
        canvasAndCrop.newCropRect = m_newCropRect;
        return canvasAndCrop;
    }

protected:
    HmcSize m_oldCanvasSize{ 0.0F };
    HmcSize m_newCanvasSize{ 0.0F };
    HmcRectD m_oldCropRect = { 0, 0, 0, 0 };
    HmcRectD m_newCropRect = { 0, 0, 0, 0 };
    HmcRectD m_oldCropOperationArea = { 0, 0, 0, 0 };
    HmcAssetArea m_oldAssetArea{ 0.0F };
    double m_updateAssetScale = 1.0;
    bool m_isDeviceVertical = true;
    UINT64 m_animMs = DEFAULT_ANIMATION_TIME;
};

#endif // OH_HVEUPDOPERAREAANIMATION_H
