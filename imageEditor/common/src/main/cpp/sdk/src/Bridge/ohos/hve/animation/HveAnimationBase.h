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

#ifndef OH_HVEANIMATIONBASE_H
#define OH_HVEANIMATIONBASE_H

#include "ohos/hve/HveTimeline.h"
#include "ohos/hve/HveAssetOper.h"

constexpr double SWITCH_PAGE_ANIMATION_TIME = 200; // 单位毫秒
constexpr double SWITCH_SEAL_ANIMATION_TIME = 250; // 单位毫秒
constexpr double XT_STYLE_ANIMATION_TIME = 200; // 单位毫秒
constexpr UINT64 DEFAULT_ANIMATION_TIME = 400;// 单位毫秒

typedef enum AnimationType {
    ONLY_UPDATE_OPERATION_AREA,
    UPD_OPER_AREA_CROP_TO_PREV,
    UPD_OPER_AREA_PREV_TO_CROP,
    UPD_OPER_AREA_PREV_TO_PREV,
    ONLY_SWITCH_CROP_TO_PREV,
    ONLY_SWITCH_PREV_TO_CROP,
    UPD_STICKER_WITH_SIZE,
    UPD_STICKER_NO_SIZE,
    WATERMARK_ANIMATION_TRANSITION,
    OPEN_XTSTYLE_PALETTE,
    CLOSE_XTSTYLE_PALETTE,
    PREVIEW_TO_APERTURE,
    MODEL_BOX_EDGE_OPEN,
    MODEL_BOX_EDGE_CLOSE,
} AnimationType;

typedef struct PreviewAssetAnimationArea {
    float srcOffsetX;
    float srcOffsetY;
    float dstOffsetX;
    float dstOffsetY;
    float srcScale;
    float dstScale;
    HmcAssetCropPosition position;
} PreviewAssetAnimationArea;

/*
 * Description: 动画基类
 * Create: 2023/11/1
 */
class HveAnimationBase {
public:
    HveAnimationBase(HveTimeline *timeline, const HmcUid &assetUid, AnimationType type);

    virtual ~HveAnimationBase();
    
    void SetProgressFunc(std::function<float(float)> func)
    {
        m_progressFunc = func;
    }
    
    virtual void Execute() final;

    virtual bool CheckParams()
    {
        return true;
    }

    virtual bool CheckAnimation()
    {
        return true;
    }

    virtual void PrepareAnimation() {}

    virtual void DoAnimation() {}

    virtual void AfterAnimation() {}

    virtual PreviewAssetAnimationArea PkgParams()
    {
        PreviewAssetAnimationArea animationVar = { 0.0F };
        return animationVar;
    }

    inline HveTimeline *GetHveTimeline()
    {
        return m_timeline;
    }

    inline HmcUid GetHmcUid()
    {
        return m_assetUid;
    }

    inline AnimationType GetAnimationType() const
    {
        return m_animationType;
    }

    inline std::function<void(const std::string& animationResult)> GetAnimationCb() const
    {
        return m_animationCB;
    }

    inline void SetAnimationCb(std::function<void(const std::string& animationResult)> cb)
    {
        m_animationCB = cb;
    }

    static bool CheckTimeline(HveTimeline *timeline, const HmcUid &assetUid);
    // Friction曲线函数
    static float FrictionCurve(float progress);
protected:
    static void ProcessCallback(HveTimeline* timeline, AnimationType animationType,
                                std::function<void(const std::string& animationResult)> animationCb);
    HveTimeline *m_timeline{ nullptr };
    HmcUid m_assetUid{ HMC_UID_NULL };
    AnimationType m_animationType;
    std::function<void(const std::string& animationResult)> m_animationCB = nullptr;
    std::function<float(float)> m_progressFunc = nullptr;
};
#endif // OH_HVEANIMATIONBASE_H
