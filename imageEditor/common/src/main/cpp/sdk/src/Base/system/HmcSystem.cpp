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

#include <HmcBase.h>

UINT64 HmcGetSystemUpTime()
{
    return HmcOhosGetSystemUpTime();
}

// 获取系统/应用内存信息
INT32 HmcGetSystemMemoryInfo(UINT32 *sysTotal, UINT32 *sysFree, UINT32 *appResident, UINT32 *appVirtual)
{
    return HmcOhosGetSystemMemoryInfo(sysTotal, sysFree, appResident, appVirtual);
}


// 获取系统内存分页大小
UINT32 HmcGetSystemPageSize()
{
    static UINT32 page_size = 0;

    if (page_size) {
        return page_size;
    }

    page_size = (UINT32)sysconf(_SC_PAGE_SIZE);

    return page_size;
}

// 获取系统本地时间
HMC_DATETIME HmcGetSystemLocalTime()
{
    HMC_DATETIME datetime;

    struct timeval tv {};
    gettimeofday(&tv, nullptr);

    struct tm localTime {};
    localtime_r(&tv.tv_sec, &localTime);

    constexpr INT32 YEAR_START = 1900;
    datetime.year = YEAR_START + localTime.tm_year;
    datetime.month = localTime.tm_mon + 1;
    datetime.day = localTime.tm_mday;
    datetime.hour = localTime.tm_hour;
    datetime.minute = localTime.tm_min;
    datetime.second = localTime.tm_sec;
    datetime.milliSecond = (decltype(datetime.milliSecond))US2MS(tv.tv_usec);

    return datetime;
}

UINT64 HmcGetCurrTimeMillSec()
{
    UINT64 millisec = 0;
    struct timeval tv {};
    gettimeofday(&tv, nullptr);
    millisec = S2MS(tv.tv_sec) + US2MS(tv.tv_usec);

    return millisec;
}

// 睡眠一定时间
VOID HmcSleep(UINT32 time)
{
    if (time >= THOUSAND) {
        sleep(time / THOUSAND);
    }
    usleep((time % THOUSAND) * THOUSAND);
}

// 申请内存
VOID *HmcMalloc(UINT32 size)
{
    return malloc(size);
}

// 释放内存
VOID HmcFree(VOID *ptr)
{
    if (ptr) {
        free(ptr);
    }
}

// 安全内存清零
VOID HmcMemZero(VOID *ptr, UINT32 size)
{
    auto end = (char *)ptr + size;
    for (auto v = (volatile char *)ptr; v < end; v++) {
        *v = 0;
    }
}

// 获取进程ID
INT32 HmcGetProcessId()
{
    return (INT32)getpid();
}

// 获取当前的UTC时间戳
INT64 HmcGetCurrEpocTimestamp()
{
    return time(NULL);
}

STRING HmcGetSystemVersionName()
{
    return "Unknown";
}
