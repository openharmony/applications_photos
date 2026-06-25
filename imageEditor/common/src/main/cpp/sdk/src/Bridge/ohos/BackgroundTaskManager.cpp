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

#include "BackgroundTaskManager.h"
#include "HmcBase.h"
static std::once_flag g_backgroundTaskMgrInitFlag;
BackgroundTaskManager *BackgroundTaskManager::m_instance = nullptr;

BackgroundTaskManager *BackgroundTaskManager::GetInstance()
{
    std::call_once(g_backgroundTaskMgrInitFlag, [] { m_instance = new BackgroundTaskManager(); });
    return m_instance;
}
