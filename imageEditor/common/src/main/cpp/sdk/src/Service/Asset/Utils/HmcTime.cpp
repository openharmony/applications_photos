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
#include "HmcTime.h"
#include "../../Editor/HmcUidAdmin.h"
#include <algorithm>

HmcTime::HmcTime(INT64 time)
{
    m_time = NormalizeTime(time);
}

HmcTime::HmcTime(const HmcTime &time)
{
    this->m_time = time.GetTime();
}

HmcTime &HmcTime::operator = (const HmcTime &time)
{
    this->m_time = time.GetTime();

    return *this;
}

VOID HmcTime::SetTime(INT64 time)
{
    INT64 timeNormalized = NormalizeTime(time);
    if (timeNormalized == m_time) {
        return;
    }

    m_time = timeNormalized;

    HMC_MUTEX_GUARD(m_HandlerMutex);
    for (const auto &handlerFuncInfo : m_notifyHandlerList) {
        handlerFuncInfo.second(m_time);
    }
}

INT64 HmcTime::GetTime() const
{
    return m_time;
}

VOID HmcTime::RegNotifyHandler(const CHmcUid &watcher, const OnHmcTimeChange &handler)
{
    HMC_MUTEX_GUARD(m_HandlerMutex);
    m_notifyHandlerList[watcher] = handler;
}

VOID HmcTime::UnRegNotifyHandler(const CHmcUid &watcher)
{
    HMC_MUTEX_GUARD(m_HandlerMutex);

    auto iter = m_notifyHandlerList.find(watcher);
    if (iter != m_notifyHandlerList.end()) {
        m_notifyHandlerList.erase(iter);
    }
}

int64_t HmcTime::NormalizeTime(int64_t timeStamp)
{
    // 取消40ms对齐，因涉及修改较多，暂在此处直接返回原值；待一轮测试无问题后再全部修改
    return timeStamp;
}
