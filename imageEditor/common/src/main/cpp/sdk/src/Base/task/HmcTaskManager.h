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

#ifndef HMC_TASK_MANAGER
#define HMC_TASK_MANAGER

#include <atomic>
#include "../../include/ffrt/ffrt.h"

using HmcTaskHandle = ffrt::task_handle;

enum class HmcTaskManagerTimeOpt {
    CONCURRENT,
    SEQUENTIAL
};

class HmcTaskManager : public std::enable_shared_from_this<HmcTaskManager> {
public:
    HmcTaskManager(std::string name, HmcTaskManagerTimeOpt opt);
    ~HmcTaskManager();

public:
    void Submit(const std::function<void()>& func, std::string funcName = "");
    HmcTaskHandle SubmitH(const std::function<void()>& func, std::string funcName = "");

    void Wait(std::vector<HmcTaskHandle> &taskHandles);
    void Wait();
    
    uint32_t GetTaskCnt() const;

private:
    void Init();
    void RunTask(const std::function<void()>& func, const std::string& funcName);

private:
    std::string m_name;

    ffrt::mutex m_taskCntLock;
    ffrt::condition_variable m_taskCv;
    std::atomic<uint32_t> m_taskCnt{ 0 };

    HmcTaskManagerTimeOpt m_timeOpt{ HmcTaskManagerTimeOpt::SEQUENTIAL };
    std::shared_ptr<ffrt::queue> m_taskQueue{ nullptr };
};

#endif // HMC_TASK_MANAGER
