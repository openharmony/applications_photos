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
#ifndef MEDIACREATIVE_RENDERTHREAD_H
#define MEDIACREATIVE_RENDERTHREAD_H

#include <thread>
#include <type_traits>

#include "RenderWorkerItf.h"
#include "log/HmcLog.h"
#include "render/base/queue/RenderQueueItf.h"
#include "render/base/queue/RenderFifoQueue.h"
#include "render/base/task/RenderTaskItf.h"

template <typename QUEUE = RenderFifoQueue<RenderTaskPtr<void>>>
class RenderThread : public RenderWorkerItf<typename QUEUE::DataType> {
public:
    typedef typename QUEUE::DataType LocalTaskType;
    static_assert(std::is_base_of<RenderQueueItf<LocalTaskType>, QUEUE>::value,
        "QUEUE shoud be derived from RenderQueueItf");

    explicit RenderThread(
        size_t, std::function<void()> idleTsk = []() {});
    virtual ~RenderThread();
    virtual void AddTask(const LocalTaskType &, bool overwrite = false) override;
    virtual void Start() override;
    virtual void Stop() override;

protected:
    virtual void Run() override;

    QUEUE *m_localMsgQueue = nullptr;
    volatile bool m_isWorking = false;
    volatile bool m_isStopped = true;

    std::mutex cvMutex;
    std::condition_variable cvFull;
    std::condition_variable cvEmpty;
    std::function<void()> idleTask;

    std::thread *t{ nullptr };
    size_t qSize;
};

template <typename QUEUE>
RenderThread<QUEUE>::RenderThread(size_t queueSize, std::function<void()> idleTsk) : qSize(queueSize), idleTask(idleTsk)
{
    m_localMsgQueue = new QUEUE();
}

template <typename QUEUE> RenderThread<QUEUE>::~RenderThread()
{
    Stop();
    t->join();
    delete t;
    delete m_localMsgQueue;
}

template <typename QUEUE> void RenderThread<QUEUE>::AddTask(const LocalTaskType &task, bool overwrite)
{
    std::unique_lock<std::mutex> lk(cvMutex);
    cvFull.wait(lk, [this]() { return (m_localMsgQueue->GetSize() < this->qSize) || (!m_isWorking); });
    if (m_isWorking) {
        if (overwrite) {
            m_localMsgQueue->Remove([&task](LocalTaskType &t) { return GetTag(task) == GetTag(t); });
        }
        m_localMsgQueue->Push(task);
        lk.unlock();
        cvEmpty.notify_one();
    }
}

template <typename QUEUE> void RenderThread<QUEUE>::Start()
{
    if (m_isStopped) {
        m_isWorking = true;
        t = new std::thread([this]() {
            this->m_isStopped = false;
            this->Run();
            this->m_isStopped = true;
        });
        while (m_isStopped) {
            std::this_thread::sleep_for(std::chrono::microseconds(1000));
        }
    }
}

template <typename QUEUE> void RenderThread<QUEUE>::Stop()
{
    m_isWorking = false;
    cvEmpty.notify_all();
    while (!m_isStopped) {
        std::this_thread::sleep_for(std::chrono::microseconds(1000));
    }
}

template <typename QUEUE> void RenderThread<QUEUE>::Run()
{
    while (m_isWorking) {
        std::unique_lock<std::mutex> lk(cvMutex);
        bool cvRet = cvEmpty.wait_for(lk, std::chrono::milliseconds(2500),
            [this]() { return (m_localMsgQueue->GetSize() > 0) || (!m_isWorking); });
        if (cvRet) {
            LocalTaskType task;
            bool ret = m_localMsgQueue->Pop(task);
            lk.unlock();
            cvFull.notify_one();
            if (ret) {
                task->Run();
            }
        } else {
            lk.unlock();
            idleTask();
        }
    }
};


#endif // MEDIACREATIVE_RENDERTHREAD_H
