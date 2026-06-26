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

extern "C" {}

#if HMC_ENABLE_FFMPEG_LOG
static VOID HmcFFmpegLogCallback(void *cls, int level, const char *format, va_list arg)
{
    // 转换日志级别
    HmcLogLevel logLevel;
    if (level <= AV_LOG_ERROR) {
        logLevel = HMC_LOG_ERROR;
    } else if (level <= AV_LOG_WARNING) {
        logLevel = HMC_LOG_WARNING;
    } else if (level <= AV_LOG_INFO) {
        logLevel = HMC_LOG_INFO;
    } else {
        logLevel = HMC_LOG_DEBUG;
    }

    // 获取日志标签
    STRING tagStr = "FFmpeg";
    auto className = (const CHAR ***)cls;
    if (className && *className && **className) {
        tagStr += HmcStringFormat("-%s", **className);
    }

    // 输出日志
    SINGLETON(HmcLogManager)->WriteLog(logLevel, tagStr.c_str(), NULL, 0, format, arg);
}

#endif


IMPLEMENT_SINGLETON(HmcLogManager)

HmcLogManager::HmcLogManager() : m_lock("HmcLogManager"), m_logLevel(HMC_LOG_DISABLED) {}


VOID HmcLogManager::Init()
{
    // 初始化FFmpeg日志
    InitFFmpegLog();

    // 初始化标准输出日志通道
    SINGLETON(HmcStdoutLogChannel)->Init();

    SINGLETON(HmcOhosHiLogChannel)->Init();
}

VOID HmcLogManager::InitFFmpegLog()
{
#if HMC_ENABLE_FFMPEG_LOG
    // 设置FFMPEG日志级别
    av_log_set_level(AV_LOG_DEBUG);

    // 设置FFMPEG日志回调
    av_log_set_callback(HmcFFmpegLogCallback);
#else
#endif
}

VOID HmcLogManager::WriteLog(HmcLogLevel level, const CHAR *tag, const CHAR *file, INT32 line, const CHAR *format,
    va_list arg)
{
    HMC_MUTEX_GUARD(m_lock);

    // 判断下日志级别是否满足，不满足就不用做后续的格式化等动作，有助于提升性能
    if (level > m_logLevel || m_logChannels.empty()) {
        return;
    }

    // 生成日志内容
    STRING content;
    if (HmcStringFormatV(content, format, arg) < 0) {
        return;
    }

    // 获取系统时间
    auto time = HmcGetSystemLocalTime();

    // 获取文件名，有可能是NULL
    auto fileName = GetFileName(file);

    // 发送日志到各个日志通道
    for (const auto &channel : m_logChannels) {
        channel->WriteLog(time, level, tag, fileName, line, content);
    }
}

VOID HmcLogManager::RegisterLogChannel(HmcLogChannel *logChannel)
{
    HMC_MUTEX_GUARD(m_lock);

    auto logLevel = logChannel->GetLogLevel();
    if (logLevel > m_logLevel) {
        // 更新最大日志级别
        m_logLevel = logLevel;
    }
    m_logChannels.push_back(logChannel);
}

VOID HmcLogManager::DeregisterLogChannel(HmcLogChannel *logChannel)
{
    HMC_MUTEX_GUARD(m_lock);
    m_logLevel = HMC_LOG_DISABLED;
    auto iter = m_logChannels.begin();
    while (iter != m_logChannels.end()) {
        if (*iter == logChannel) {
            iter = m_logChannels.erase(iter);
        } else {
            // 更新最大日志级别
            m_logLevel = HMC_MAX(m_logLevel, (*iter)->GetLogLevel());

            ++iter;
        }
    }
}

const CHAR *HmcLogManager::GetFileName(const CHAR *file)
{
    if (!file) {
        return NULL;
    }

    const CHAR *fileName = file;

    for (const CHAR *p = file; *p; p++) {
        if (('/' == *p) || ('\\' == *p)) {
            fileName = p + 1;
        }
    }

    return fileName;
}
