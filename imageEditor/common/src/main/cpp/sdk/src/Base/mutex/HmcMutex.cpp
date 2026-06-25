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

#include "HmcBase.h"

HmcMutex::HmcMutex(const STRING &name)
{
    m_name = name;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_setpshared(&attr, FALSE);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&m_mutex, &attr);
    pthread_mutexattr_destroy(&attr);
}

HmcMutex::~HmcMutex()
{
    pthread_mutex_destroy(&m_mutex);
}

VOID HmcMutex::Lock()
{
    pthread_mutex_lock(&m_mutex);
}


INT32 HmcMutex::TryLock()
{
    if (!pthread_mutex_trylock(&m_mutex)) {
        return HMC_OK;
    }

    return HMC_ERR;
}


VOID HmcMutex::Unlock(VOID)
{
    pthread_mutex_unlock(&m_mutex);
}
