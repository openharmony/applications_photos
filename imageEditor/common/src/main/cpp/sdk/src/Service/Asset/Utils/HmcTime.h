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

#ifndef HMC_TIME_H
#define HMC_TIME_H

#include <functional>

#include "HmcBase.h"

using OnHmcTimeChange = std::function<void(INT64 timeStamp)>;

class CHmcUid;

class HmcTime {
public:
    explicit HmcTime(INT64 time);
    HmcTime(const HmcTime &time);
    HmcTime &operator = (const HmcTime &time);
    virtual ~HmcTime() = default;

    VOID SetTime(INT64 time);
    INT64 GetTime() const;

    VOID RegNotifyHandler(const CHmcUid &watcher,
        const OnHmcTimeChange &handler); // 注册时间变更时的观察者，当时间变更时将逐一通知
    VOID UnRegNotifyHandler(const CHmcUid &watcher); // 取消注册时间变更时的观察者

    static int64_t NormalizeTime(int64_t timeStamp);

private:
    INT64 m_time;
    MAP<CHmcUid, OnHmcTimeChange> m_notifyHandlerList;
    HmcMutex m_HandlerMutex;
};


#endif // HMC_TIME_H
