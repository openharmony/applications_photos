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

#ifndef HMC_VIDEO_PREVIEW_ENGINE_H
#define HMC_VIDEO_PREVIEW_ENGINE_H

#include "Editor/Preview/PreviewEngine/HmcPreviewEngine.h"

namespace Hmc::Service::Preview {
enum class PreviewEngineState {
    IDLE = 0,
    PLAYING,
    PAUSING,
    FLUSHING,
    STOPPING
};

struct FlushInfo {
    uint64_t pts = 0;
    bool exactMode = true;
};

class HmcVideoPreviewEngine : public HmcPreviewEngine, public std::enable_shared_from_this<HmcVideoPreviewEngine> {
public:
    HmcVideoPreviewEngine(HmcEventHandler *handler, std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine);
    ~HmcVideoPreviewEngine() override;

public:
    int32_t Startup() override; // 必须先调用SetPreviewWindow设置window
    void Shutdown() override;

    void Play(uint64_t startTime, uint64_t endTime, uint32_t fps) override;
    void Pause() override;
    void Flush() override;
    void Flush(uint64_t time, bool exactMode = true) override;

    void GetPreviewPeriodRange(uint64_t &startTime, uint64_t &endTime) override;
    void SetPreviewPeriodRange(uint64_t startTime, uint64_t endTime) override;

    uint64_t GetCurrentTime() const override;
        
    std::shared_ptr<HmcTaskManager> GetTaskMgr() override { return m_taskMgr; }
    
    void FlushForce() override;

public:
    Json::Value Serialize() const override;
    bool Deserialize(const Json::Value &previewJson) override;

private:
    void PlayProc(uint64_t startTime, uint64_t endTime, uint32_t fps);
    void InitAudioRender();
    void UnInitAudioRender();
    void RenderFrame(uint64_t pts, uint32_t duration);
    void RenderGraphics(uint64_t pts, bool exactMode);
    void RenderAudio(uint64_t pts, uint32_t duration);
    void StartFlushWorker(bool force);
    void Stop();
    void FlushInner(uint64_t time, bool exactMode, bool force = false);
    void PauseInner();
    void PushFlushPts(const FlushInfo &flushInfo);
    bool PickFlushPts(FlushInfo &flushInfo);
    void ReportTimePos(uint64_t pos);

private:
    std::shared_ptr<HmcTaskManager> m_taskMgr{ nullptr };

    ffrt::mutex m_operateMutex;

    uint64_t m_previewStartTime{ 0 };
    uint64_t m_previewEndTime{ 0 };

    uint64_t m_currentTimePos{ 0 };

    uint64_t m_lastReportTimePos{ 0 };

    std::atomic<PreviewEngineState> m_state{ PreviewEngineState::IDLE };

    std::mutex m_flushListMutex;
    std::list<FlushInfo> m_flushList;
};
}
#endif // HMC_VIDEO_PREVIEW_ENGINE_H
