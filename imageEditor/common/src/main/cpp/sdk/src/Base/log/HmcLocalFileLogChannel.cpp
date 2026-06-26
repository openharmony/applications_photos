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
#include "HmcLocalFileLogChannel.h"


// 单个日志文件大小，超过这个大小就会切换文件
constexpr static UINT32 HMC_FILE_LOG_SIZE = (1U << 22);

// 唤醒刷新线程的缓冲区大小门限
constexpr static UINT32 HMC_FILE_LOG_WAKEUP_CACHE_SIZE = (1U << 20);

// 保留日志文件个数，超过这个个数最旧的文件会被自动删除
constexpr static UINT32 HMC_FILE_LOG_NUM = 100;

// 默认刷新线程的睡眠时间，单位毫秒
constexpr static UINT32 HMC_FILE_LOG_SLEEP_TIME = 500;


IMPLEMENT_SINGLETON(HmcLocalFileLogChannel)

HmcLocalFileLogChannel::HmcLocalFileLogChannel()
    : m_logLevel(HMC_LOG_DISABLED),
      m_logSequence(0),
      m_thread(NULL),
      m_wakeupEvent("HmcLocalFileLogWakeupEvent"),
      m_lock("HmcLocalFileLogLock")
{
    // 为日志缓冲区预留足够空间，避免内存碎片
    m_logCache.reserve(HMC_FILE_LOG_SIZE);
}

// 初始化
VOID HmcLocalFileLogChannel::Init()
{
#ifdef DEBUG
    // 调试版本里默认位置打开日志
    Open(NULL, HMC_LOG_DEBUG);
#endif
}

// 打开日志通道
INT32 HmcLocalFileLogChannel::Open(const CHAR *path, HmcLogLevel level)
{
    // 检查日志级别是否合法
    if (level <= HMC_LOG_DISABLED || level > HMC_LOG_DEBUG) {
        LOGW("Bad log level %d while opening local file log!", level);
        return HMC_ERR;
    }

    // 检查是否重复打开
    if (m_logLevel != HMC_LOG_DISABLED) {
        LOGW("Don't open local file log twice!");
        return HMC_ERR;
    }

    // 获取日志保存路径
    if (path) {
        m_logPath = path;
        LOGD("Log path is set to %s.", path);
    } else {
        m_logPath = GetDefaultLogPath();
        LOGD("Log path is set to default <%s>.", m_logPath.c_str());
    }

    // 创建目录，已存在的话直接返回HMC_OK
    if (HMC_OK != HmcMakeDirTree(m_logPath)) {
        LOGW("Failed to create directory %s!", m_logPath.c_str());
        return HMC_ERR;
    }

    // 到这一步已经可以确定打开日志通道成功了，需要更新日志级别，表示日志通道已打开，而且必须在线程创建之前更新
    m_logLevel = level;

    // 创建日志线程
    m_thread = HmcThread::Create("HmcLocalFileLogThread", this);

    // 注册日志通道
    SINGLETON(HmcLogManager)->RegisterLogChannel(this);
    return HMC_OK;
}

// 关闭日志通道
VOID HmcLocalFileLogChannel::Close()
{
    // 先停止日志线程
    if (m_thread) {
        m_thread->RequestForStop();
        m_wakeupEvent.SetSignaled();
        HmcThread::Destroy(m_thread);
    }

    m_logLevel = HMC_LOG_DISABLED;
    SINGLETON(HmcLogManager)->DeregisterLogChannel(this);
}


// 日志输出接口
VOID HmcLocalFileLogChannel::WriteLog(const HMC_DATETIME &time, HmcLogLevel level, const CHAR *tag, const CHAR *file,
    INT32 line, const STRING &content)
{
    const CHAR *logLevelString[] = {"DISABLED", "ERROR", "WARNING", "INFO", "DEBUG"};

    // 先判断日志级别
    if (level > m_logLevel) {
        return;
    }

    // 与刷盘线程之间的互斥锁
    HMC_MUTEX_GUARD(m_lock);

    if (m_logCache.size() >= HMC_FILE_LOG_SIZE) {
        // 由于权限问题文件一直没创建成功，这种情况下缓冲区不能无限扩张
        return;
    }

    if (file) {
        // 有文件名信息
        m_logCache += HmcStringFormat("[%04d-%02d-%02d %02d:%02d:%02d.%03d|%s|%s|%s:%d|%d] %s\n", time.year, time.month,
            time.day, time.hour, time.minute, time.second, time.milliSecond, logLevelString[level], tag ? tag : "NULL",
            file, line, HmcThread::GetSelfThreadId(), content.c_str());
    } else {
        // 没有文件名信息
        m_logCache += HmcStringFormat("[%04d-%02d-%02d %02d:%02d:%02d.%03d|%s|%s|%d] %s\n", time.year, time.month,
            time.day, time.hour, time.minute, time.second, time.milliSecond, logLevelString[level], tag ? tag : "NULL",
            HmcThread::GetSelfThreadId(), content.c_str());
    }

    // 如果缓冲区数据长度已经达到门限，就强制唤醒刷盘线程
    if (m_logCache.size() >= HMC_FILE_LOG_WAKEUP_CACHE_SIZE) {
        m_wakeupEvent.SetSignaled();
    }
}

// 获取日志级别
HmcLogLevel HmcLocalFileLogChannel::GetLogLevel()
{
    return m_logLevel;
}

STRING HmcLocalFileLogChannel::GetDefaultLogPath()
{
    return HmcOhosGetInternalStorageDir("log");
}

VOID HmcLocalFileLogChannel::ThreadMain(HmcThread *selfThread, void *)
{
    HmcFile *logFile = NULL;

    while (!selfThread->IsStopping()) {
        if (!logFile) {
            // 尝试创建新日志文件
            logFile = CreateNewLogFile();
            if (logFile) {
                // 新日志文件创建成功后，删除最老的日志
                RemoveOutdatedLog();
            }
        }

        if (logFile) {
            // 写入日志文件
            WriteToLogFile(logFile);

            // 检查日志文件是否已经达到限制
            if (logFile->GetSize() > HMC_FILE_LOG_SIZE) {
                // 文件已写满，关闭当前文件文件
                logFile->Sync();
                logFile->Close();
                delete logFile;
                logFile = NULL;
            }
        }

        // 等待唤醒事件到来或者超时
        m_wakeupEvent.Wait(HMC_FILE_LOG_SLEEP_TIME);
    }

    if (logFile) {
        // 一次性写入剩余日志
        HMC_MUTEX_LOCK(m_lock);
        if (!m_logCache.empty()) {
            logFile->Write(m_logCache.data(), static_cast<int>(m_logCache.length()));
            m_logCache.clear();
        }
        HMC_MUTEX_UNLOCK(m_lock);

        logFile->Sync();
        logFile->Close();
        delete logFile;
    }
}

HmcFile *HmcLocalFileLogChannel::CreateNewLogFile()
{
    // 获取当前时间
    auto now = HmcGetSystemLocalTime();

    // 构造日志文件名
    STRING logFileName;
    HmcStringFormat(logFileName, "%04d%02d%02d_%02d%02d%02d_%d_%u.log", now.year, now.month, now.day, now.hour,
        now.minute, now.second, HmcGetProcessId(), m_logSequence);

    // 创建日志路径，防止运行时被删除
    HmcMakeDirTree(m_logPath);

    // 构造日志完整路径
    STRING logFilePath = m_logPath + "/" + logFileName;

    // 尝试创建日志文件
    auto logFile = new HmcFile;
    if (HMC_OK != logFile->Open(logFilePath, HmcFile::HMC_FILE_CREATE)) {
        delete logFile;
        return NULL;
    }

    // 日志文件创建成功，序号加一
    m_logSequence++;

    LOGD("Log file %s created.", logFileName.c_str());
    return logFile;
}

VOID HmcLocalFileLogChannel::RemoveOutdatedLog()
{
    // 获取日志路径下文件列表
    STRING_LIST fileList;
    HmcGetDirContents(m_logPath, fileList);

    // 按文件名反向排序，实际上就是按时间排序
    fileList.sort();
    fileList.reverse();

    INT32 keep = HMC_FILE_LOG_NUM;

    for (const auto &f : fileList) {
        if (!HmcStringIsEndWith(f, ".log")) {
            // 忽略非日志文件
            continue;
        }

        if (keep > 0) {
            // 跳过需要保留的个数
            keep--;
            continue;
        }

        // 删除过时文件
        LOGD("Removing %s.", f.c_str());
        HmcFile::Remove(m_logPath + "/" + f);
    }
}

VOID HmcLocalFileLogChannel::WriteToLogFile(HmcFile *logFile)
{
    // 获取需要写入的日志内容，仅在这部分加锁，避免写入磁盘的过程影响其他线程打日志
    STRING logToWrite;
    HMC_MUTEX_LOCK(m_lock);
    if (m_logCache.empty()) {
        // 日志缓冲区是空的
        HMC_MUTEX_UNLOCK(m_lock);
        return;
    }

    // 计算剩余日志空间配额
    auto quota = (UINT32)(HMC_FILE_LOG_SIZE - logFile->GetSize());
    if (m_logCache.size() > quota) {
        // 配额不足，仅写入到最后一条日志
        auto length = m_logCache.find('\n', quota) + 1;
        logToWrite.assign(m_logCache, 0, length);
        m_logCache.erase(0, length);
    } else {
        // 配额充足，写入全部缓冲区内容
        m_logCache.swap(logToWrite);
    }
    HMC_MUTEX_UNLOCK(m_lock);

    // 写入日志文件
    logFile->Write(logToWrite.data(), static_cast<int>(logToWrite.length()));
}

// 打开文件日志
INT32 HmcOpenLocalFileLog(const CHAR *path, HmcLogLevel level)
{
    return SINGLETON(HmcLocalFileLogChannel)->Open(path, level);
}

// 关闭文件日志
VOID HmcCloseLocalFileLog()
{
    SINGLETON(HmcLocalFileLogChannel)->Close();
}
