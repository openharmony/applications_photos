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

#ifndef HMCLOG_H
#define HMCLOG_H

#include "HmcBaseType.h"
#include <hitrace/trace.h>
#ifdef __cplusplus
extern "C" {
#endif

// 应用层可以在包含HmcBase.h之前定义自己的HMC_LOG_TAG
#ifndef HMC_LOG_TAG
#define HMC_LOG_TAG "HW_IMAGE_EDITOR_LOG"
#endif

// 日志级别定义
typedef enum {
    HMC_LOG_DISABLED, // 日志系统关闭
    HMC_LOG_ERROR,    // 错误级别，影响业务的严重错误
    HMC_LOG_WARNING,  // 告警级别，不影响业务的一般错误
    HMC_LOG_INFO,     // 信息级别，记录运行过程
    HMC_LOG_DEBUG     // 调试级别，仅供开发人员调试用
} HmcLogLevel;

// 日志初始化接口
HMC_API void HmcLogInit();

// 日志接口
HMC_API void HmcLog(HmcLogLevel level, const char *tag, const char *file, int line, const char *format, ...);
VOID PrintBacktrace();

#define LOGE(fmt, arg...) HmcLog(HMC_LOG_ERROR, HMC_LOG_TAG, __FILE_NAME__, __LINE__, fmt, ##arg)
#define LOGW(fmt, arg...) HmcLog(HMC_LOG_WARNING, HMC_LOG_TAG, __FILE_NAME__, __LINE__, fmt, ##arg)
#define LOGI(fmt, arg...) HmcLog(HMC_LOG_INFO, HMC_LOG_TAG, __FILE_NAME__, __LINE__, fmt, ##arg)
#define LOGD(fmt, arg...) HmcLog(HMC_LOG_DEBUG, HMC_LOG_TAG, __FILE_NAME__, __LINE__, fmt, ##arg)

#ifndef HMC_TRACE_H
#define HMC_TRACE_H

#define HMC_TRACE_GUARD(m, ...) HmcTraceGuard _##m_name(m, ##__VA_ARGS__)
class HmcTraceGuard {
public:
    HmcTraceGuard(const char *m_name) { OH_HiTrace_StartTrace(m_name); }
    ~HmcTraceGuard() { OH_HiTrace_FinishTrace(); }
};
#endif

#ifndef FALSE_RETURN_V
#define FALSE_RETURN_V(exec, ret)                                       \
    do {                                                                \
        if (!(exec)) {                                                  \
            LOGE("FALSE_RETURN_V " #exec);                              \
            return ret;                                                 \
        }                                                               \
    } while (0)
#endif

#ifndef FALSE_RETURN_V_NOLOG
#define FALSE_RETURN_V_NOLOG(exec, ret)                                 \
    do {                                                                \
        if (!(exec)) {                                                  \
            return ret;                                                 \
        }                                                               \
    } while (0)
#endif

#ifndef FALSE_RETURN_MSG_IMPL
#define FALSE_RETURN_MSG_IMPL(loglevel, exec, fmt, args...)             \
    do {                                                                \
        if (!(exec)) {                                                  \
            loglevel(fmt, ##args);                                      \
            return;                                                     \
        }                                                               \
    } while (0)
#endif

#ifndef FALSE_RETURN_V_MSG_IMPL
#define FALSE_RETURN_V_MSG_IMPL(loglevel, exec, ret, fmt, args...)      \
    do {                                                                \
        if (!(exec)) {                                                  \
            loglevel(fmt, ##args);                                      \
            return ret;                                                 \
        }                                                               \
    } while (0)
#endif

#ifndef FALSE_RETURN_MSG
#define FALSE_RETURN_MSG(exec, fmt, args...) FALSE_RETURN_MSG_IMPL(LOGE, exec, fmt, ##args)
#endif

#ifndef FALSE_RETURN_V_MSG
#define FALSE_RETURN_V_MSG(exec, ret, fmt, args...) FALSE_RETURN_V_MSG_IMPL(LOGE, exec, ret, fmt, ##args)
#endif

#ifndef FALSE_LOG
#define FALSE_LOG(exec)                                     \
    do {                                                    \
        if (!(exec)) {                                      \
            LOGE("FALSE_LOG: " #exec);                      \
        }                                                   \
    } while (0)
#endif

#ifndef FAKE_POINTER
#define POINTER_MASK 0x00FFFFFF
#define FAKE_POINTER(addr) (POINTER_MASK & reinterpret_cast<uintptr_t>(addr))
#endif

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // HMCLOG_H
