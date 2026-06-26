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

#ifndef HMC_PREVIEW_ENGINE_H
#define HMC_PREVIEW_ENGINE_H

#include <mutex>
#include "Editor/Preview/HmcPreviewEngineItf.h"

constexpr float HMC_DEFAULT_CANVAS_WIDTH = 1280.0f;
constexpr float HMC_DEFAULT_CANVAS_HEIGHT = 720.0f;

namespace Hmc::Service::Preview {
class HmcPreviewEngine : public HmcPreviewEngineItf {
public:
    HmcPreviewEngine(HmcEventHandler *handler, std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine);
    virtual ~HmcPreviewEngine();

public:
    int32_t Startup() override; // 必须先调用SetPreviewWindow设置window
    void Shutdown() override;

    void SetPreviewWindow(void *window) override;

    void SetCanvasSize(const HmcSize &canvasSize) override;
    HmcSize GetCanvasSize() const override;

    void Play(uint64_t startTime, uint64_t endTime, uint32_t fps) override;
    void Pause() override;
    void Flush() override;
    void Flush(uint64_t time, bool exactMode = true) override;

    void GetPreviewPeriodRange(uint64_t &startTime, uint64_t &endTime) override;
    void SetPreviewPeriodRange(uint64_t startTime, uint64_t endTime) override;

    uint64_t GetCurrentTime() const override;

    HmcSurfaceTexture *CreateSurface() override;
        
    std::shared_ptr<HmcTaskManager> GetTaskMgr() override { return nullptr; };
    
    void FlushForce() override;

public:
    Json::Value Serialize() const override;
    bool Deserialize(const Json::Value &previewJson) override;

protected:
    void RenderGraphics(std::shared_ptr<VideoRenderInfo> &renderInfo);

private:
    void ResetRenderCanvasBgInfo();
    void SyncRenderCanvas();

protected:
    HmcEventHandler *m_eventHandler{ nullptr };

    std::shared_ptr<HmcRenderEngineItf> m_graphicsRender{ nullptr };

    void *m_previewWindow{ nullptr };

    HmcSize m_canvasSize{
        .width = HMC_DEFAULT_CANVAS_WIDTH,
        .height = HMC_DEFAULT_CANVAS_HEIGHT
    };
    HmcSize m_windowSize{
        .width = HMC_DEFAULT_CANVAS_WIDTH,
        .height = HMC_DEFAULT_CANVAS_HEIGHT
    };

    std::mutex m_renderCanvasMutex{};
    HmcRenderCanvas m_renderCanvas; // 符合渲染所需canvas结构的的canvas信息.

    std::atomic_bool m_graphicsFirstRenderSuccess{ false }; // 第一次画面渲染成功，表示素材已经正常导入变渲染完成.
    HmcRenderResultFunc m_renderResultCallback{ nullptr }; // 画面帧渲染完成的回调，由渲染引擎回调.
};
}
#endif // HMC_PREVIEW_ENGINE_H
