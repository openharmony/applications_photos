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

#include "Animation.h"
#include <native_vsync/native_vsync.h>

const int FRAME_DURATION = 1000;
const int VSYNC_STR_LENGTH = 3;

UINT64 startTimeMs = -1;
UINT64 dstTimeMs = -1;
int g_frameTime = 0;
bool g_startFlag = true;
std::function<void(float, bool)> animCallback;
ffrt::mutex mutex;
ffrt::task_handle g_handle = nullptr;
bool g_needBreakAnimation = false;
OH_NativeVSync* g_vsync = nullptr;
void CancelAnimation()
{
    {
        std::unique_lock<ffrt::mutex> lock{ mutex };
        startTimeMs = 0;
        dstTimeMs = 0;
        g_startFlag = true;
    }
}

void FinishAnimationInner()
{
    CancelAnimation();
    std::unique_lock<ffrt::mutex> lock{ mutex };
    if (animCallback != nullptr) {
        animCallback(1, false);
        animCallback = nullptr;
    }
}

void RequestFrame(void)
{
    OH_NativeVSync_RequestFrame(g_vsync, [](long long timestamp, void* data) {
        std::unique_lock<ffrt::mutex> lock{ mutex };
        if (dstTimeMs - startTimeMs <= 0) {
            OH_NativeVSync_Destroy(g_vsync);
            animCallback = nullptr;
            g_vsync = nullptr;
            return;
        }
        unsigned long long int curTimeMs = HmcGetCurrTimeMillSec();
        float progress = (curTimeMs - startTimeMs) / (float)(dstTimeMs - startTimeMs);

        if (progress >= 1) {
            progress = 1;
            animCallback(progress, false);
            OH_NativeVSync_Destroy(g_vsync);
            animCallback = nullptr;
            g_vsync = nullptr;
            return;
        } else {
            animCallback(progress, g_startFlag);
            if (g_startFlag) {
                g_startFlag = false;
            }
            RequestFrame();
        }
    }, nullptr);
}

void postAnimation(std::function<void(float, bool)> callback, UINT64 animMs, int refreshRate)
{
    if (animMs <= 0) {
        CancelAnimation();
        callback(1, false);
        return;
    }
    {
        std::unique_lock<ffrt::mutex> lock{ mutex };
        animCallback = callback;
        startTimeMs = HmcGetCurrTimeMillSec();
        g_startFlag = true;
        dstTimeMs = HmcGetCurrTimeMillSec() + animMs;
        g_needBreakAnimation = false;
        g_frameTime = FRAME_DURATION / refreshRate;
        if (!g_vsync) {
            g_vsync = OH_NativeVSync_Create("HMC", VSYNC_STR_LENGTH);
        }
    }
    RequestFrame();
}