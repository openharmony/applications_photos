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

#include <atomic>
#include <utility>
#include "../../include/ffrt/ffrt.h"
#include "HmcBase.h"
#include "HmcTaskManager.h"

HmcTaskManager::HmcTaskManager(std::string name, HmcTaskManagerTimeOpt opt) : m_name(std::move(name)), m_timeOpt(opt)
{
    Init();
}

HmcTaskManager::~HmcTaskManager()
{
    Wait();
}

void HmcTaskManager::Init()
{
    if (m_timeOpt == HmcTaskManagerTimeOpt::SEQUENTIAL) {
        m_taskQueue = std::make_shared<ffrt::queue>(m_name.c_str(), ffrt::queue_attr().qos(ffrt_qos_user_initiated));
    }
}

void HmcTaskManager::Submit(const std::function<void()>& func, std::string funcName)
{
    if (!funcName.empty()) {
        LOGI("ffrt task %s submit", funcName.c_str());
    }
    m_taskCnt++;
    auto weakThis = weak_from_this();
    if (m_timeOpt == HmcTaskManagerTimeOpt::SEQUENTIAL && m_taskQueue) {
        m_taskQueue->submit([weakThis, func, funcName]() {
            auto taskManager = weakThis.lock();
            if (taskManager == nullptr) {
                LOGI("Task manager is nullptr, task queue submit run task failed.");
                return;
            }
            taskManager->RunTask(func, funcName);
        });
    } else {
        ffrt::submit([weakThis, func, funcName]() {
            auto taskManager = weakThis.lock();
            if (taskManager == nullptr) {
                LOGI("Task manager is nullptr, ffrt submit run task failed.");
                return;
            }
            taskManager->RunTask(func, funcName);
        });
    }
}

HmcTaskHandle HmcTaskManager::SubmitH(const std::function<void()>& func, std::string funcName)
{
    if (!funcName.empty()) {
        LOGI("ffrt task %s submit", funcName.c_str());
    }
    m_taskCnt++;
    auto weakThis = weak_from_this();
    if (m_timeOpt == HmcTaskManagerTimeOpt::SEQUENTIAL && m_taskQueue) {
        return m_taskQueue->submit_h([weakThis, func, funcName]() {
            auto taskManager = weakThis.lock();
            if (taskManager == nullptr) {
                LOGI("Task manager is nullptr, task queue submit_h run task failed.");
                return;
            }
            taskManager->RunTask(func, funcName);
        });
    } else {
        return ffrt::submit_h([weakThis, func, funcName]() {
            auto taskManager = weakThis.lock();
            if (taskManager == nullptr) {
                LOGI("Task manager is nullptr, ffrt submit_h run task failed.");
                return;
            }
            taskManager->RunTask(func, funcName);
        });
    }
}

void HmcTaskManager::Wait(std::vector<HmcTaskHandle> &taskHandles)
{
    if (m_timeOpt == HmcTaskManagerTimeOpt::SEQUENTIAL && m_taskQueue) {
        for (HmcTaskHandle &taskHandle : taskHandles) {
            m_taskQueue->wait(taskHandle);
        }
    } else {
        std::vector<ffrt::dependence> deps;
        deps.insert(deps.end(), taskHandles.begin(), taskHandles.end());
        ffrt::wait(deps);
    }
}

void HmcTaskManager::RunTask(const std::function<void()>& func, const std::string& funcName)
{
    if (!funcName.empty()) {
        LOGI("ffrt task %s begin to run", funcName.c_str());
    }
    func();
    if (!funcName.empty()) {
        LOGI("ffrt task %s run end", funcName.c_str());
    }

    m_taskCnt--;

    m_taskCv.notify_all();
}

void HmcTaskManager::Wait()
{
    LOGI("%s: wait begin", m_name.c_str());
    if (m_timeOpt == HmcTaskManagerTimeOpt::SEQUENTIAL && m_taskQueue) {
        auto handle = m_taskQueue->submit_h([&] {
            LOGI("%s: wait all task finish", m_name.c_str());
        });
        m_taskQueue->wait(handle);
    } else {
        ffrt::task_handle taskHandle = ffrt::submit_h([&] {
            std::unique_lock lk(m_taskCntLock);
            if (m_taskCnt > 0) {
                m_taskCv.wait(lk, [&] { return m_taskCnt == 0; });
            }
        });
        ffrt::wait({ taskHandle });
    }
    LOGI("%s: wait end", m_name.c_str());
}

uint32_t HmcTaskManager::GetTaskCnt() const
{
    return m_taskCnt.load();
}