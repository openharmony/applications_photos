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

#ifndef HMCSTDOUTLOGCHANNEL_H
#define HMCSTDOUTLOGCHANNEL_H

class HmcStdoutLogChannel : public HmcLogChannel {
    DECLARE_SINGLETON(HmcStdoutLogChannel);

public:
    HmcStdoutLogChannel();

    /* *
     * 初始化
     */
    VOID Init();

    /* *
     * 打开日志通道
     * @param level     日志级别
     * @return          HMC_OK 成功<br> 其他值 失败错误码
     */
    INT32 Open(HmcLogLevel level);

    /* *
     * 关闭日志通道
     */
    VOID Close();

    /* *
     * 日志输出接口
     * @param time      当前时间
     * @param level     日志级别
     * @param tag       模块标签
     * @param file      文件名，注意对于第三方模块回调写的日志可能传NULL
     * @param line      行号
     * @param content   日志内容
     */
    VOID WriteLog(const HMC_DATETIME &time, HmcLogLevel level, const CHAR *tag, const CHAR *file, INT32 line,
        const STRING &content) final;
    /* *
     * 获取日志级别
     * @return          日志级别
     */
    HmcLogLevel GetLogLevel() final;

private:
    // 根据是否支持ANSI色彩返回对应的日志级别字符串
    const CHAR *GetLogLevelString(HmcLogLevel level);

private:
    HmcLogLevel m_logLevel;
    const CHAR *m_logLevelString[5];
    const CHAR *m_logLevelStringWithAnsiColor[5];
    BOOL m_ansiColorEnabled;
};


/**
 * 打开标准输出日志
 * @param level     日志级别
 * @return          HMC_OK 成功<br> 其他值 失败错误码
 */
HMC_C_API INT32 HmcOpenStdoutLog(INT32 level);

/**
 * 关闭标准输出日志
 */
HMC_C_API VOID HmcCloseStdoutLog();

#endif // HMCSTDOUTLOGCHANNEL_H
