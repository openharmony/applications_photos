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

IMPLEMENT_SINGLETON(HmcStdoutLogChannel)

// ANSI (ISO 6429) 颜色码定义
// 1. Control codes
#define COLOR_RESET "\033[m"
#define COLOR_NORMAL "\033[0m"
#define COLOR_BRIGHT "\033[1m"
#define COLOR_DIM "\033[2m"
#define COLOR_UNDERLINE "\033[4m"
#define COLOR_NO_UNDERLINE "\033[24m"
#define COLOR_BLINK "\033[5m"
#define COLOR_NO_BLINK "\033[25m"
#define COLOR_REVERSE "\033[7m"
#define COLOR_NO_REVERSE "\033[27m"

// 2. Foreground colors
#define COLOR_FG_BLACK "\033[30m"
#define COLOR_FG_RED "\033[31m"
#define COLOR_FG_GREEN "\033[32m"
#define COLOR_FG_YELLOW "\033[33m"
#define COLOR_FG_BLUE "\033[34m"
#define COLOR_FG_MAGENTA "\033[35m"
#define COLOR_FG_CYAN "\033[36m"
#define COLOR_FG_WHITE "\033[37m"

// 3. Background colors
#define COLOR_BG_BLACK "\033[40m"
#define COLOR_BG_RED "\033[41m"
#define COLOR_BG_GREEN "\033[42m"
#define COLOR_BG_YELLOW "\033[43m"
#define COLOR_BG_BLUE "\033[44m"
#define COLOR_BG_MAGENTA "\033[45m"
#define COLOR_BG_CYAN "\033[46m"
#define COLOR_BG_WHITE "\033[47m"

// 构造
HmcStdoutLogChannel::HmcStdoutLogChannel()
    : m_logLevel(HMC_LOG_DISABLED),
      m_logLevelString{ "DISABLED", "ERROR", "WARNING", "INFO", "DEBUG" },
      m_logLevelStringWithAnsiColor{ COLOR_FG_WHITE "DISABLED" COLOR_RESET, COLOR_FG_RED "ERROR" COLOR_RESET,
    COLOR_FG_MAGENTA "WARNING" COLOR_RESET, COLOR_FG_CYAN "INFO" COLOR_RESET, COLOR_FG_YELLOW "DEBUG" COLOR_RESET },
      m_ansiColorEnabled(FALSE)
{
    // Linux终端输出支持ANSI色彩
    m_ansiColorEnabled = TRUE;
}

// 初始化
VOID HmcStdoutLogChannel::Init()
{
    // Linux下默认打开
    Open(HMC_LOG_DEBUG);
}

// 打开日志通道
INT32 HmcStdoutLogChannel::Open(HmcLogLevel level)
{
    if (level <= HMC_LOG_DISABLED || level > HMC_LOG_DEBUG) {
        LOGW("Bad log level %d while opening stdout log!", level);
        return HMC_ERR;
    }

    if (m_logLevel != HMC_LOG_DISABLED) {
        LOGW("Don't open stdout log twice!");
        return HMC_ERR;
    }

    m_logLevel = level;
    SINGLETON(HmcLogManager)->RegisterLogChannel(this);
    return HMC_OK;
}

// 关闭日志通道
VOID HmcStdoutLogChannel::Close()
{
    m_logLevel = HMC_LOG_DISABLED;
    SINGLETON(HmcLogManager)->DeregisterLogChannel(this);
}


// 日志输出接口
VOID HmcStdoutLogChannel::WriteLog(const HMC_DATETIME &time, HmcLogLevel level, const CHAR *tag, const CHAR *file,
    INT32 line, const STRING &content)
{
    // 先判断日志级别
    if (level > m_logLevel) {
        return;
    }

    if (file) {
        // 有文件名信息
        fprintf(stdout, "[%04d-%02d-%02d %02d:%02d:%02d.%03d|%s|%s|%s:%d|%d] %s\n", time.year, time.month, time.day,
            time.hour, time.minute, time.second, time.milliSecond, GetLogLevelString(level), tag ? tag : "NULL", file,
            line, HmcThread::GetSelfThreadId(), content.c_str());
    } else {
        // 没有文件名信息
        fprintf(stdout, "[%04d-%02d-%02d %02d:%02d:%02d.%03d|%s|%s|%d] %s\n", time.year, time.month, time.day,
            time.hour, time.minute, time.second, time.milliSecond, GetLogLevelString(level), tag ? tag : "NULL",
            HmcThread::GetSelfThreadId(), content.c_str());
    }

    // 刷新输出缓冲区
    fflush(stdout);
}

// 获取日志级别
HmcLogLevel HmcStdoutLogChannel::GetLogLevel()
{
    return m_logLevel;
}

// 根据是否支持ANSI色彩返回对应的日志级别字符串
const CHAR *HmcStdoutLogChannel::GetLogLevelString(HmcLogLevel level)
{
    if (level > HMC_LOG_DEBUG) {
        return "UNKNOWN";
    }

    if (m_ansiColorEnabled) {
        return m_logLevelStringWithAnsiColor[level];
    }

    return m_logLevelString[level];
}

// 打开标准输出日志
INT32 HmcOpenStdoutLog(HmcLogLevel level)
{
    return SINGLETON(HmcStdoutLogChannel)->Open(level);
}

// 关闭标准输出日志
VOID HmcCloseStdoutLog()
{
    SINGLETON(HmcStdoutLogChannel)->Close();
}
