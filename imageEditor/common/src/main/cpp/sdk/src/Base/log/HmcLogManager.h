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

#ifndef HMCLOGMANAGER_H
#define HMCLOGMANAGER_H

class HmcLogManager {
    DECLARE_SINGLETON(HmcLogManager);

public:
    HmcLogManager();

    VOID Init();

    VOID WriteLog(HmcLogLevel level, const CHAR *tag, const CHAR *file, INT32 line, const CHAR *format, va_list arg);

    VOID RegisterLogChannel(HmcLogChannel *logChannel);

    VOID DeregisterLogChannel(HmcLogChannel *logChannel);

private:
    // 初始化FFmpeg日志系统
    VOID InitFFmpegLog();

    static const CHAR *GetFileName(const CHAR *file);

private:
    HmcMutex m_lock;
    HmcLogLevel m_logLevel;
    LIST<HmcLogChannel *> m_logChannels;
};

#endif // HMCLOGMANAGER_H
