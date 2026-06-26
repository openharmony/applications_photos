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

#ifndef HMCLOGCHANNEL_H
#define HMCLOGCHANNEL_H

class HmcLogChannel {
public:
    HmcLogChannel() = default;

    /* *
     * 日志输出接口
     * @param time      当前时间
     * @param level     日志级别
     * @param tag       模块标签
     * @param file      文件名，注意对于第三方模块回调写的日志可能传NULL
     * @param line      行号
     * @param content   日志内容
     */
    virtual VOID WriteLog(const HMC_DATETIME &time, HmcLogLevel level, const CHAR *tag, const CHAR *file, INT32 line,
        const STRING &content) = 0;

    /* *
     * 获取日志级别
     * @return          日志级别
     */
    virtual HmcLogLevel GetLogLevel() = 0;
};

#endif // HMCLOGCHANNEL_H
