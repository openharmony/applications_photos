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

#ifndef OH_HVESWITCHPAGEANIMATION_H
#define OH_HVESWITCHPAGEANIMATION_H

#include "ohos/hve/animation/HveAnimationBase.h"

/*
 * Description: 一级菜单切换动画基类
 * Create: 2023/11/1
 */
class HveSwitchPageAnimation : public HveAnimationBase {
public:
    HveSwitchPageAnimation(HveTimeline *timeline, const HmcUid &assetUid, AnimationType type, UINT64 animMs);
    ~HveSwitchPageAnimation();

    void DoAnimation() override;

    bool CheckParams();
    
    static bool IsWatermarkAnimation(AnimationType animationType);
    
    static bool IsXtStyleAnimation(AnimationType animationType);
    
    static bool IsOpacityUpAnimation(AnimationType animationType);
    
    static bool IsAlwaysShowWatermarkAnimation(AnimationType animationType);

    virtual void AfterAnimation() final;

    static void ProcessStart(HveTimeline *timeline, const HmcUid assetUid, const HmcRectD &cropRect, HmcSize canvasSize,
                             AnimationType type);
    static void Processing(HveTimeline *timeline, const HmcUid assetUid, PreviewAssetAnimationArea animationVar,
        AnimationType type, float progress);
    static void ProcessEnd(HveTimeline *timeline, const HmcUid assetUid, PreviewAssetAnimationArea animationVar,
        const HmcRectD &cropRect, AnimationType type);
    
    static void setIsShowWaterChangeAnimation(bool value);

protected:
    UINT64 m_animMs = 0;
    static constexpr FLOAT HALF = 0.5f;
    static bool isShowWaterChangeAnimation; // 是否展示内嵌水印和外接水印之间的动画
};

#endif // OH_HVESWITCHPAGEANIMATION_H
