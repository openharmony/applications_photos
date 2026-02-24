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

#ifndef HMCLOCALFILELOGCHANNEL_H
#define HMCLOCALFILELOGCHANNEL_H

class HmcLocalFileLogChannel : public HmcLogChannel, public HmcThreadMain {
    DECLARE_SINGLETON(HmcLocalFileLogChannel);

public:
    HmcLocalFileLogChannel();

    /* *
     * 初始化
     */
    VOID Init();

    /* *
     * 打开日志通道
     * @param path      路径，NULL代表使用默认路径
     * @param level     日志级别
     * @return          HMC_OK 成功<br> 其他值 失败错误码
     */
    INT32 Open(const CHAR *path, HmcLogLevel level);

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

    /* *
     * 线程入口
     * @param selfThread    线程对象
     * @param userData      自定义数据
     */
    VOID ThreadMain(HmcThread *selfThread, VOID *userData) final;

private:
    /* *
     * 获取默认日志保存路径
     * @return              默认日志保存路径
     */
    static STRING GetDefaultLogPath();

    /* *
     * 创建新日志文件
     * @return              日志文件对象
     */
    HmcFile *CreateNewLogFile();

    /* *
     * 删除过期的日志
     */
    VOID RemoveOutdatedLog();

    /* *
     * 写入日志文件
     */
    VOID WriteToLogFile(HmcFile *logFile);

private:
    // 日志级别
    HmcLogLevel m_logLevel;

    // 日志文件保存路径
    STRING m_logPath;

    // 日志文件序号，每次切换日志文件就加一
    UINT32 m_logSequence;

    // 日志线程
    HmcThread *m_thread;

    // 日志线程唤醒事件
    HmcEvent m_wakeupEvent;

    // 互斥锁
    HmcMutex m_lock;

    // 日志缓冲区
    STRING m_logCache;
};

/**
 * 打开文件日志
 * @param path      路径，NULL代表使用默认路径
 * @param level     日志级别
 * @return          HMC_OK 成功<br> 其他值 失败错误码
 */
HMC_C_API INT32 HmcOpenLocalFileLog(const CHAR *path, INT32 level);

/**
 * 关闭文件日志
 */
HMC_C_API VOID HmcCloseLocalFileLog();

#endif // HMCLOCALFILELOGCHANNEL_H
