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

#ifndef OH_HMC_DELAY_STAT_H
#define OH_HMC_DELAY_STAT_H

#include <chrono>
#include "HmcBaseType.h"

#define HMC_DELAY_STAT() HmcDelayStat delay(__FUNCTION__)

class HmcDelayStat {
public:
    explicit HmcDelayStat(const std::string &func) : m_func(func)
    {
        m_start = std::chrono::steady_clock::now();
    }

    ~HmcDelayStat()
    {
        m_end = std::chrono::steady_clock::now();
        std::chrono::duration<double, std::milli> diff = m_end - m_start;
        LOGE("HmcDelayStat--%s cost(ms)=%lf start(ms)=%lld", m_func.c_str(), diff.count(), GetStartTimeMS());
    }

    // 返回当前time毫秒
    long GetCurrentTimeMS()
    {
        return std::chrono::time_point_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now())
            .time_since_epoch()
            .count();
    }

    // 返回起始time毫秒
    long GetStartTimeMS()
    {
        return std::chrono::time_point_cast<std::chrono::milliseconds>(m_start).time_since_epoch().count();
    }

    // 打点起始time
    void StatStartTime()
    {
        m_start = std::chrono::steady_clock::now();
    }

    // 打点结束time
    void StatEndTime()
    {
        m_end = std::chrono::steady_clock::now();
    }

    // 返回起始time到目前耗时毫秒
    long CalcElapsedTime()
    {
        return (std::chrono::time_point_cast<std::chrono::milliseconds>(m_end) -
            std::chrono::time_point_cast<std::chrono::milliseconds>(m_start))
            .count();
    }

private:
    std::chrono::time_point<std::chrono::steady_clock> m_start;
    std::chrono::time_point<std::chrono::steady_clock> m_end;

    std::string m_func;
};

#endif // oh_HmcDelayStat_H
