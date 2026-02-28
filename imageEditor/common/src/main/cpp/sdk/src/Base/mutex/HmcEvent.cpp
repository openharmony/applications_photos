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
#include "HmcEvent.h"

HmcEvent::HmcEvent(const STRING &name, BOOL manualReset, BOOL initialState)
    : m_name(name), m_manualReset(manualReset), m_signaled(initialState)
{
    pthread_mutex_init(&m_mutex, NULL);
    pthread_cond_init(&m_cond, NULL);
    pthread_mutex_lock(&m_mutex);

    if (initialState) {
        pthread_cond_signal(&m_cond);
    }
    pthread_mutex_unlock(&m_mutex);
}

HmcEvent::~HmcEvent()
{
    pthread_mutex_destroy(&m_mutex);
    pthread_cond_destroy(&m_cond);
}

VOID HmcEvent::SetSignaled()
{
    pthread_mutex_lock(&m_mutex);
    m_signaled = TRUE;
    pthread_cond_signal(&m_cond);
    pthread_mutex_unlock(&m_mutex);
}

VOID HmcEvent::SetUnsignaled()
{
    pthread_mutex_lock(&m_mutex);
    m_signaled = FALSE;
    pthread_mutex_unlock(&m_mutex);
}

INT32 HmcEvent::WaitPeriod(int timeout)
{
    struct timespec target;
    // Get the current time.
    clock_gettime(CLOCK_REALTIME, &target);

    UINT64 timeoutNanoSeconds = (UINT64)(MS2NS(timeout)) + (UINT64)(target.tv_nsec);
    UINT64 timeoutSeconds = (UINT64)(NS2S(timeoutNanoSeconds));
    timeoutNanoSeconds -= S2NS(timeoutSeconds);
    target.tv_sec += (decltype(target.tv_sec))timeoutSeconds;
    target.tv_nsec = (decltype(target.tv_nsec))timeoutNanoSeconds;

    if (pthread_cond_timedwait(&m_cond, &m_mutex, &target)) {
        // 超时
        return HMC_ERR_EAGAIN;
    }

    return HMC_OK;
}

INT32 HmcEvent::Wait(UINT32 timeout)
{
    pthread_mutex_lock(&m_mutex);

    if (!m_signaled) {
        switch (timeout) {
            case HMC_DONT_WAIT:
                pthread_mutex_unlock(&m_mutex);
                return HMC_ERR_EAGAIN;

            case HMC_WAIT_FOREVER:
                pthread_cond_wait(&m_cond, &m_mutex);
                break;

            default:
                INT32 ret = WaitPeriod(timeout);
                if (HMC_OK != ret) {
                    pthread_mutex_unlock(&m_mutex);
                    return HMC_ERR_EAGAIN;
                }
                break;
        }
    }

    if (m_signaled && !m_manualReset) {
        // 自动复位
        m_signaled = FALSE;
    }

    if (m_signaled && m_manualReset) {
        // 唤醒下一个等待者
        pthread_cond_signal(&m_cond);
    }
    pthread_mutex_unlock(&m_mutex);
    return HMC_OK;
}
