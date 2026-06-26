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

#ifndef HMCSYSTEM_H
#define HMCSYSTEM_H

// 系统时间定义
typedef struct HMC_DATETIME {
    INT32 year{ 0 };        // 年，例如2012
    INT32 month{ 0 };       // 月，1~12
    INT32 day{ 0 };         // 日，1~31
    INT32 hour{ 0 };        // 小时，0~23
    INT32 minute{ 0 };      // 分钟，0~59
    INT32 second{ 0 };      // 秒，0~59
    INT32 milliSecond{ 0 }; // 毫秒，0~999
} HMC_DATETIME;

/**
 * 获取系统启动时长
 * @return 系统启动时长，单位毫秒
 */
HMC_C_API UINT64 HmcGetSystemUpTime();

/**
 * 获取系统分页大小，单位字节
 */
HMC_C_API UINT32 HmcGetSystemPageSize();

/**
 * 获取系统/应用内存信息
 * @param sysTotal      输出内核总可用内存，略小于物理内存，单位MB，可以为NULL
 * @param sysFree       输出内核当前空闲内存，单位MB，可以为NULL
 * @param appResident   输出应用驻留物理内存，单位MB，可以为NULL
 * @param appVirtual    输出应用虚拟内存，单位MB，可以为NULL
 * @return              HMC_OK 成功<br> 其他值 失败错误码
 */
HMC_C_API INT32 HmcGetSystemMemoryInfo(UINT32 *sysTotal, UINT32 *sysFree, UINT32 *appResident, UINT32 *appVirtual);

/**
 * 获取系统本地时间
 */
HMC_C_API HMC_DATETIME HmcGetSystemLocalTime();

/**
 * 获取当前时间的毫秒数
 */
HMC_C_API UINT64 HmcGetCurrTimeMillSec();

/**
 * 获取当前的UTC时间戳
 * @return      自格林威治时间1970/1/1 00:00:00以来的秒数
 */
HMC_C_API INT64 HmcGetCurrEpocTimestamp();

/**
 * 睡眠一定时间
 * @param time          睡眠时间，单位毫秒
 */
HMC_C_API VOID HmcSleep(UINT32 time);

/**
 * 获取进程ID
 * @return              进程ID
 */
HMC_C_API INT32 HmcGetProcessId();

/**
 * 申请内存
 * @param size          申请长度
 * @note                自定义内存申请
 * 里面分配的内存在NONE-MFC的DLL代码里面释放会崩溃
 */
HMC_C_API VOID *HmcMalloc(UINT32 size);

/**
 * 释放内存
 * @param ptr           待释放指针
 */
HMC_C_API VOID HmcFree(VOID *ptr);

/**
 * 安全内存清零
 * @param ptr           待清零指针
 * @param size          长度
 */
HMC_C_API VOID HmcMemZero(VOID *ptr, UINT32 size);

/**
 * 获取系统版本名称
 * @return              系统版本名称
 */
HMC_API STRING HmcGetSystemVersionName();

#endif // HMCSYSTEM_H
