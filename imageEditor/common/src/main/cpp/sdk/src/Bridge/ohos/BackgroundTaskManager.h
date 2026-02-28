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

#ifndef OH_BACKGROUNDTASKMANAGER_H
#define OH_BACKGROUNDTASKMANAGER_H


#include "task/HmcTaskManager.h"
#define BACKGROUND_TASK_MGR BackgroundTaskManager::GetInstance()

class BackgroundTaskManager {
public:
    static BackgroundTaskManager *GetInstance();

public:
    inline void Submit(const std::function<void()> &func, std::string funcName)
    {
        m_taskMgr->Submit(func, funcName);
    }

    inline void Wait(std::vector<HmcTaskHandle> &taskHandles)
    {
        m_taskMgr->Wait(taskHandles);
    }

    inline void Wait()
    {
        m_taskMgr->Wait();
    }

private:
    BackgroundTaskManager()
    {
        m_taskMgr = std::make_shared<HmcTaskManager>("BackgroundTaskManager", HmcTaskManagerTimeOpt::SEQUENTIAL);
    }

    ~BackgroundTaskManager() = default;

    std::shared_ptr<HmcTaskManager> m_taskMgr = nullptr;
    static BackgroundTaskManager *m_instance;
};


#endif // OH_BACKGROUNDTASKMANAGER_H
