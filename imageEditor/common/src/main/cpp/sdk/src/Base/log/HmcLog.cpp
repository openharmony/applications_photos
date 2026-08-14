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
#include <stdarg.h>
#include <hilog/log.h>
#include <execinfo.h>
#include <cstdlib>
#include <cstdio>
#include <sstream>

static std::map<HmcLogLevel, LogLevel> g_hmcLogLevelMap{
    { HMC_LOG_DEBUG, LOG_DEBUG },
    { HMC_LOG_INFO, LOG_INFO },
    { HMC_LOG_WARNING, LOG_WARN },
    { HMC_LOG_ERROR, LOG_ERROR },
};

static std::map<std::string, UINT32> g_hmcLogEnableMap{};

static bool HmcLogIsLoggable(const CHAR *tag, LogLevel hilogLevel)
{
    auto it = g_hmcLogEnableMap.find(tag);
    if (it != g_hmcLogEnableMap.end()) {
        UINT32 enable = it->second;
        return enable & (1 << hilogLevel);
    }
    return OH_LOG_IsLoggable(LOG_DOMAIN, tag, hilogLevel);
}

static void HmcLogInitTag(const CHAR *tag)
{
    UINT32 enable = 0;
    for (auto &item : g_hmcLogLevelMap) {
        if (OH_LOG_IsLoggable(LOG_DOMAIN, tag, item.second)) {
            enable |= (1 << item.second);
        }
    }
    g_hmcLogEnableMap[tag] = enable;
}

VOID HmcLogInit()
{
    HmcLogInitTag("HW_IMAGE_EDITOR_LOG");
}

VOID PrintBacktrace() {
    static constexpr int8_t stackDepth = 10;
    void* array[stackDepth];
    size_t size;
    char** strings;
    size_t i;

    size = backtrace(array, stackDepth);
    strings = backtrace_symbols(array, size);

    if (strings == nullptr) {
        LOGE("Failed to obtain stack trace symbols");
        return;
    }

    std::ostringstream oss;
    oss << "Obtained " << size << " stack frames.\n";
    for (i = 0; i < size; i++) {
        oss << "[" << i << "] " << (strings[i] != nullptr ? strings[i] : "] <null>") << "\n";
    }
    LOGI("%s", oss.str().c_str());
    free(strings);
}


VOID HmcLog(HmcLogLevel level, const CHAR *tag, const CHAR *fileName, INT32 line, const CHAR *format, ...)
{
    if (level == HMC_LOG_DISABLED) {
        return;
    }
    auto it = g_hmcLogLevelMap.find(level);
    LogLevel hilogLevel = (it != g_hmcLogLevelMap.end()) ? it->second : LOG_INFO;
    // 判断日志级别是否需要打印
    if (!HmcLogIsLoggable(tag, hilogLevel)) {
        return;
    }

    // 获取文件名，有可能是NULL
    if (fileName == nullptr) {
        fileName = "<unknown>";
    }

    const int maxlength = 2048;
    char content[maxlength];

    va_list arg;
    va_start(arg, format);
    int count = vsnprintf(content, maxlength - 1, format, arg);
    va_end(arg);

    if (count == -1) {
        // error
        OH_LOG_Print(LOG_APP, hilogLevel, LOG_DOMAIN, tag, "[%{public}s:%{public}d] <illegal log format>\n", fileName,
            line);
        return;
    }

    OH_LOG_Print(LOG_APP, hilogLevel, LOG_DOMAIN, tag, "[%{public}s:%{public}d] %{public}s\n", fileName, line, content);
}
