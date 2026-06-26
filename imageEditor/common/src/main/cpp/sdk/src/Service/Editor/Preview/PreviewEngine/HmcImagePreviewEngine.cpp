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

#include "HmcImagePreviewEngine.h"

namespace Hmc::Service::Preview {
HmcImagePreviewEngine::HmcImagePreviewEngine(HmcEventHandler *handler,
    std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine)
    : HmcPreviewEngine(handler, graphicsRenderEngine)
{
    LOGI("[preview] create image preview engine.");
    m_taskMgr = std::make_shared<HmcTaskManager>("HmcImagePreviewEngine", HmcTaskManagerTimeOpt::CONCURRENT);
}

HmcImagePreviewEngine::~HmcImagePreviewEngine()
{
    LOGI("[preview] destroy image preview engine.");
}

void HmcImagePreviewEngine::Shutdown()
{
    LOGI("[preview] shutdown image preview engine.");

    m_taskMgr->Wait();

    HmcPreviewEngine::Shutdown();

    LOGI("[preview] shutdown image preview engine finish.");
}

void HmcImagePreviewEngine::Flush()
{
    Flush(0);
}

void HmcImagePreviewEngine::Flush(uint64_t time, bool exactMode)
{
    LOGI("[preview] image preview engine flush pts: %d.", time);

    if (time != 0) {
        LOGW("[preview] image preview engine not support flush pts!=0, so flush pts==0.");
    }

    m_needFlush.store(true);

    // 调用者快速Flush时，将多个Flush任务合并，只取最后一个flush任务;
    if (!m_flushWorkerRunning.load()) {
        StartFlushWorker();
    }
}

void HmcImagePreviewEngine::StartFlushWorker()
{
    m_flushWorkerRunning.store(true);
        
    LOGI("HmcImagePreviewEngine::StartFlushWorker");

    auto weakThis = weak_from_this();
    m_taskMgr->Submit([weakThis]() {
        auto strong = weakThis.lock();
        if (strong == nullptr) {
            LOGI("HmcImagePreviewEngine::StartFlushWorker strong is nullptr.");
		    return;
        }
        // 为了防止task频繁切换导致资源浪费，此处使用while循环，当前一个flush任务还未结束，后一个flush又来时，将两个flush合并成一个task.
        while (strong->m_needFlush.exchange(false)) {
            strong->FlushProc();
        }

        strong->m_flushWorkerRunning.store(false);

        // 如果while循环结束后，m_FlushWorkerRunning置为false前，新来一个flush任务，会导致不启动flushworker,进而导致
        // 该flush任务被丢弃,所以在m_FlushWorkerRunning置为false后，再检查一遍是否有flush任务，如果有，就立即执行.
        if (strong->m_needFlush.exchange(false)) {
            strong->FlushProc();
        }
    },
        __FUNCTION__);
}

void HmcImagePreviewEngine::FlushProc()
{
    auto graphicsRenderInfo = m_eventHandler->OnPackGraphicsRenderInfo(0);
    if (graphicsRenderInfo == nullptr) {
        LOGE("[preview] image preview engine flush failed, pack graphics render info failed.");
        m_renderResultCallback(HMC_ERR);
    } else {
        HmcPreviewEngine::RenderGraphics(graphicsRenderInfo);
    }
}
}