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

#include "HveAnimationBase.h"
#include "ohos/BackgroundTaskManager.h"

HveAnimationBase::HveAnimationBase(HveTimeline *timeline, const HmcUid &assetUid, AnimationType type)
    : m_timeline(timeline), m_assetUid(assetUid), m_animationType(type)
{}

HveAnimationBase::~HveAnimationBase() {}

void HveAnimationBase::Execute()
{
    if (!CheckParams()) {
        LOGD("HveAnimationBase::CheckParams false");
        return;
    }

    if (!CheckAnimation()) {
        LOGD("HveAnimationBase::CheckAnimation false");
        return;
    }

    PrepareAnimation();
    DoAnimation();
    AfterAnimation();
}

bool HveAnimationBase::CheckTimeline(HveTimeline *timeline, const HmcUid &assetUid)
{
    if (timeline == nullptr) {
        return false;
    }

    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (editor == nullptr || hveAsset == nullptr) {
        LOGE("[HveAnimationBase]editor or asset is null.");
        return false;
    }
    return true;
}

float HveAnimationBase::FrictionCurve(float progress)
{
      // 确保进度在有效范围内
    if (progress < 0.0) {
        progress = 0.0;
    } else if (progress > 1.0) {
        progress = 1.0;   
    }
       // Friction曲线公式: y = x^2 / (x^2 + (1-x)^2)
    return (progress * progress) / (progress * progress + (1.0 - progress) * (1.0 - progress));
}

void HveAnimationBase::ProcessCallback(HveTimeline *timeline, AnimationType animationType,
                                       std::function<void(const std::string &animationResult)> animationCb) {
    if (animationType != UPD_STICKER_WITH_SIZE && animationType != UPD_STICKER_NO_SIZE) {
        LOGW("Invalid animation type: %d", animationType);
        return;
    }
    if (animationCb == nullptr) {
        LOGE("Animation callback is null");
        return;
    }
    BACKGROUND_TASK_MGR->Submit(
        [animationType, animationCb]() {
            LOGI("Process animation callback end");
            Json::Value json;
            Json::FastWriter fastWriter;
            json["code"] = std::to_string(animationType);
            animationCb(fastWriter.write(json));
        },
        __FUNCTION__);
}