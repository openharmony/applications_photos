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

#ifndef HMC_IMAGE_PREVIEW_ENGINE_H
#define HMC_IMAGE_PREVIEW_ENGINE_H

#include "Editor/Preview/PreviewEngine/HmcPreviewEngine.h"

namespace Hmc::Service::Preview {
class HmcImagePreviewEngine : public HmcPreviewEngine, public std::enable_shared_from_this<HmcImagePreviewEngine> {
public:
    HmcImagePreviewEngine(HmcEventHandler *handler, std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine);
    ~HmcImagePreviewEngine() override;

public:
    void Shutdown() override;

    void Flush() override;
    void Flush(uint64_t time, bool exactMode = true) override;

private:
    void StartFlushWorker();
    void FlushProc();

private:
    std::shared_ptr<HmcTaskManager> m_taskMgr{ nullptr };

    std::atomic<bool> m_needFlush{ false };
    std::atomic<bool> m_flushWorkerRunning{ false };
};
}
#endif // HMC_IMAGE_PREVIEW_ENGINE_H
