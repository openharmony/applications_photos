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

#include <bits/alltypes.h>
#include <mutex>
#include "HmcPreviewEngine.h"
#include "HmcVideoPreviewEngine.h"

namespace Hmc::Service::Preview {
constexpr INT32 AUDIO_VOLUME_MAX = 100;
constexpr INT32 AUDIO_DEFAULT_SAMPLING_FREQ = 44100;
constexpr INT32 AUDIO_DEFAULT_CHANNEL_NUM = 2;
constexpr INT32 AUDIO_DEFAULT_BITS_PER_SAMPLE = 16;
constexpr INT32 AUDIO_DEFAULT_FRAME_LENGTH = 1024;

HmcVideoPreviewEngine::HmcVideoPreviewEngine(HmcEventHandler *handler,
    std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine)
    : HmcPreviewEngine(handler, graphicsRenderEngine)
{
    m_taskMgr = std::make_shared<HmcTaskManager>("HmcVideoPreviewEngine", HmcTaskManagerTimeOpt::SEQUENTIAL);
}

HmcVideoPreviewEngine::~HmcVideoPreviewEngine()
{
    Stop();
}

int32_t HmcVideoPreviewEngine::Startup()
{
    std::lock_guard lockGuard(m_operateMutex);

    auto result = HmcPreviewEngine::Startup();
    if (result != HMC_OK) {
        return result;
    }

    return HMC_OK;
}

void HmcVideoPreviewEngine::Shutdown()
{
    std::lock_guard lockGuard(m_operateMutex);
    if (m_state == PreviewEngineState::PLAYING) {
        Stop();
    }
    m_taskMgr->Wait();
    HmcPreviewEngine::Shutdown();
}

void HmcVideoPreviewEngine::Play(uint64_t startTime, uint64_t endTime, uint32_t fps)
{
    LOGI("[preview] video preview engine play from %d ~ %d, fps: %d.", startTime, endTime, fps);
    std::lock_guard lockGuard(m_operateMutex);
    if (m_state != PreviewEngineState::IDLE) {
        Stop();
    }

    m_state = PreviewEngineState::PLAYING;

    auto weakThis = weak_from_this();
    m_taskMgr->Submit([weakThis, startTime, endTime, fps] {
        auto strong = weakThis.lock();
        if (strong == nullptr) {
            LOGI("HmcVideoPreviewEngine::Play strong is nullptr.");
            return;
        }
        strong->PlayProc(startTime, endTime, fps);
        strong->m_state = PreviewEngineState::IDLE;
    },
        __FUNCTION__);
}
void HmcVideoPreviewEngine::Pause()
{
    LOGI("[preview] pause video preview engine.");

    std::lock_guard lockGuard(m_operateMutex);
    PauseInner();

    LOGI("[preview] pause video preview engine finish.");
}
void HmcVideoPreviewEngine::Flush()
{
    std::lock_guard lockGuard(m_operateMutex);
    FlushInner(m_currentTimePos, true);
}

void HmcVideoPreviewEngine::Flush(uint64_t time, bool exactMode)
{
    std::lock_guard lockGuard(m_operateMutex);
    FlushInner(time, exactMode);
}

void HmcVideoPreviewEngine::FlushForce()
{
    std::lock_guard lockGuard(m_operateMutex);
    FlushInner(m_currentTimePos, true, true);
}

void HmcVideoPreviewEngine::FlushInner(uint64_t time, bool exactMode, bool force)
{
    uint64_t pts = std::max(time, m_previewStartTime);
    pts = std::min(pts, m_previewEndTime);

    m_currentTimePos = pts;

    PushFlushPts({ pts, exactMode });

    if (m_state == PreviewEngineState::PLAYING) {
        PauseInner();
    }

    // 当前状态为flush状态，则不再提交flush任务.
    if (m_state.load() != PreviewEngineState::FLUSHING || force) {
        StartFlushWorker(force);
    } else {
        LOGD("Is Flushing!");
    }
}

void HmcVideoPreviewEngine::PauseInner()
{
    if (m_state == PreviewEngineState::PLAYING) {
        m_state = PreviewEngineState::PAUSING;
        m_taskMgr->Wait();
        m_state = PreviewEngineState::IDLE;

        FlushInner(m_currentTimePos, true);
        m_taskMgr->Wait();
    }
}

void HmcVideoPreviewEngine::GetPreviewPeriodRange(uint64_t &startTime, uint64_t &endTime)
{
    startTime = m_previewStartTime;
    endTime = m_previewEndTime;
}

void HmcVideoPreviewEngine::SetPreviewPeriodRange(uint64_t startTime, uint64_t endTime)
{
    LOGI("[preview] set video preview period from (%d ~ %d) to (%d ~ %d).", m_previewStartTime, m_previewEndTime,
        startTime, endTime);
    m_previewStartTime = startTime;
    m_previewEndTime = endTime;
}

uint64_t HmcVideoPreviewEngine::GetCurrentTime() const
{
    return m_currentTimePos;
}

void HmcVideoPreviewEngine::RenderGraphics(uint64_t pts, bool exactMode)
{
    auto graphicsRenderInfo = m_eventHandler->OnPackGraphicsRenderInfo(pts, exactMode);
    if (graphicsRenderInfo == nullptr) {
        LOGE("[preview] render video(pts: %d) failed because of packing graphics render info failed.", pts);
    } else {
        HmcPreviewEngine::RenderGraphics(graphicsRenderInfo);
    }
}

void HmcVideoPreviewEngine::RenderAudio(uint64_t pts, uint32_t duration) {}

void HmcVideoPreviewEngine::RenderFrame(uint64_t pts, uint32_t duration)
{
    auto weakThis = weak_from_this();
    HmcTaskHandle reportTimePosTask = m_taskMgr->SubmitH([weakThis, pts] {
        auto strong = weakThis.lock();
        if (strong == nullptr) {
            LOGI("HmcVideoPreviewEngine::RenderFrame1 strong is nullptr.");
            return;
        }
        strong->ReportTimePos(pts);
    });

    HmcTaskHandle renderGraphicsTask = m_taskMgr->SubmitH([weakThis, pts] {
        auto strong = weakThis.lock();
        if (strong == nullptr) {
            LOGI("HmcVideoPreviewEngine::RenderFrame2 strong is nullptr.");
            return;
        }
        strong->RenderGraphics(pts, true);
    });

    HmcTaskHandle renderAudioTask = m_taskMgr->SubmitH([weakThis, pts, duration] {
        auto strong = weakThis.lock();
        if (strong == nullptr) {
            LOGI("HmcVideoPreviewEngine::RenderFrame3 strong is nullptr.");
            return;
        }
        strong->RenderAudio(pts, duration);
    });

    std::vector<HmcTaskHandle> waitList;
    waitList.push_back(std::move(renderGraphicsTask));
    waitList.push_back(std::move(renderAudioTask));
    waitList.push_back(std::move(reportTimePosTask));

    m_taskMgr->Wait(waitList);
}

Json::Value HmcVideoPreviewEngine::Serialize() const
{
    Json::Value previewJson = HmcPreviewEngine::Serialize();
    previewJson[PROJECT_KEY_PREVIEW_PERIOD_START] = m_previewStartTime;
    previewJson[PROJECT_KEY_PREVIEW_PERIOD_END] = m_previewEndTime;

    return previewJson;
}

bool HmcVideoPreviewEngine::Deserialize(const Json::Value &previewJson)
{
    LOGI("[preview] deserialize info :%s", previewJson.toStyledString().c_str());
    HmcPreviewEngine::Deserialize(previewJson);

    JsonValueUtil::ParseValueIfHas(previewJson, PROJECT_KEY_PREVIEW_PERIOD_START, m_previewStartTime);
    JsonValueUtil::ParseValueIfHas(previewJson, PROJECT_KEY_PREVIEW_PERIOD_END, m_previewEndTime);

    return true;
}

void HmcVideoPreviewEngine::PlayProc(uint64_t startTime, uint64_t endTime, uint32_t fps)
{
    InitAudioRender();
    if (fps == 0) {
        return;
    }

    uint64_t framePeriod = static_cast<uint64_t>(lround(1000 / fps));
    uint64_t pts = startTime;
    uint64_t startPlayTimestamp = HmcGetSystemUpTime();
    uint64_t firstPts = startTime;
    while (m_state == PreviewEngineState::PLAYING && pts <= endTime) {
        m_currentTimePos = pts;
        uint64_t period = std::min(framePeriod, endTime - pts);
        RenderFrame(pts, period);

        if (period == 0) {
            break;
        } else {
            pts += period;
        }

        auto ptsDiff = pts - firstPts;

        auto currentTime = HmcGetSystemUpTime();
        auto elapsed = currentTime - startPlayTimestamp;

        if (ptsDiff > elapsed) {
            uint64_t waitTime = ptsDiff - elapsed;
            ffrt::this_task::sleep_for(std::chrono::milliseconds(waitTime));
        }
    }

    UnInitAudioRender(); // 如果不pause，OpenSLES异步回调会一直在后台轮转占用CPU.
}

void HmcVideoPreviewEngine::Stop()
{
    m_state = PreviewEngineState::STOPPING;

    m_taskMgr->Wait();

    m_state = PreviewEngineState::IDLE;
}

void HmcVideoPreviewEngine::PushFlushPts(const FlushInfo &flushInfo)
{
    std::lock_guard<std::mutex> guard(m_flushListMutex);
    m_flushList.clear();
    m_flushList.push_back(flushInfo);
}

bool HmcVideoPreviewEngine::PickFlushPts(FlushInfo &flushInfo)
{
    std::lock_guard<std::mutex> guard(m_flushListMutex);

    if (m_flushList.empty()) {
        return false;
    }

    flushInfo = m_flushList.back();
    m_flushList.pop_back();

    return true;
}

void HmcVideoPreviewEngine::StartFlushWorker(bool force)
{
    m_state.store(PreviewEngineState::FLUSHING);

    auto weakThis = weak_from_this();
    m_taskMgr->Submit([weakThis, force]() {
        auto strong = weakThis.lock();
        if (strong == nullptr) {
            LOGI("HmcVideoPreviewEngine::StartFlushWorker strong is nullptr.");
            return;
        }
        // 为了防止task频繁切换导致资源浪费，此处使用while循环，当前一个flush任务还未结束，后一个flush又来时，将两个flush合并成一个task.
        FlushInfo info;
        bool renderForce = force;
        while (strong->PickFlushPts(info)) {
            strong->RenderGraphics(info.pts, info.exactMode);
            strong->ReportTimePos(info.pts);
            renderForce = false;
        }

        strong->m_state.store(PreviewEngineState::IDLE);

        // 如果while循环结束后，m_FlushWorkerRunning置为false前，新来一个flush任务，会导致不启动flushworker,进而导致
        // 该flush任务被丢弃,所以在m_FlushWorkerRunning置为false后，再检查一遍是否有flush任务，如果有，就立即执行.
        if (strong->PickFlushPts(info)) {
            strong->RenderGraphics(info.pts, info.exactMode);
            strong->ReportTimePos(info.pts);
            renderForce = false;
        }
        
        // 强制执行Draw渲染。目前只涉及到个性风格滤镜调色盘抬手时，最后一次任务渲染
        if (renderForce) {
            strong->RenderGraphics(info.pts, info.exactMode);
        }

        strong->m_eventHandler->OnSeekEnd();
    },
        __FUNCTION__);
}

void HmcVideoPreviewEngine::ReportTimePos(uint64_t pts) {}

void HmcVideoPreviewEngine::InitAudioRender() {}

void HmcVideoPreviewEngine::UnInitAudioRender() {}
}