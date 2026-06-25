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

#include <hilog/log.h>
#include "HmcBase.h"

IMPLEMENT_SINGLETON(HmcOhosHiLogChannel)

// 构造
HmcOhosHiLogChannel::HmcOhosHiLogChannel() : m_logLevel(HMC_LOG_DISABLED) {}

// 初始化
VOID HmcOhosHiLogChannel::Init()
{
    // 默认打开
    Open(HMC_LOG_DEBUG);
}

// 打开日志通道
INT32 HmcOhosHiLogChannel::Open(HmcLogLevel level)
{
    if (level <= HMC_LOG_DISABLED || level > HMC_LOG_DEBUG) {
        return HMC_ERR;
    }

    if (m_logLevel != HMC_LOG_DISABLED) {
        return HMC_ERR;
    }

    m_logLevel = level;
    SINGLETON(HmcLogManager)->RegisterLogChannel(this);
    return HMC_OK;
}

// 关闭日志通道
VOID HmcOhosHiLogChannel::Close()
{
    m_logLevel = HMC_LOG_DISABLED;
    SINGLETON(HmcLogManager)->DeregisterLogChannel(this);
}


// 日志输出接口
VOID HmcOhosHiLogChannel::WriteLog(const HMC_DATETIME &time, HmcLogLevel level, const CHAR *tag, const CHAR *file,
    INT32 line, const STRING &content)
{
    // 先判断日志级别
    if (level > m_logLevel) {
        return;
    }

    const CHAR *logLevelString[] = { "DISABLED", "ERROR", "WARNING", "INFO", "DEBUG" };

    OH_LOG_Print(LOG_APP, static_cast<LogLevel>(LOG_FATAL - level), LOG_DOMAIN, "HMC_LOG",
        "[%{public}s:%{public}d] %{public}s\n", file, line, content.c_str());
}

// 获取日志级别
HmcLogLevel HmcOhosHiLogChannel::GetLogLevel()
{
    return m_logLevel;
}