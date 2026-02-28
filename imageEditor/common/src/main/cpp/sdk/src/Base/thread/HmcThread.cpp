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

// 线程名字长度限制
constexpr INT32 HMC_THREAD_NAME_LIMIT = 15;

// 线程退出超时间隔，单位毫秒
constexpr INT32 HMC_THREAD_EXIT_TIMEOUT = 500;

HmcThread::HmcThread()
    : m_name(),
      m_entry(nullptr),
      m_userData(nullptr),
      m_thread(0),
      m_threadId(0),
      m_isStopping(FALSE),
      m_exitEvent("ThreadExitEvent", TRUE)
{}

HmcThread::~HmcThread() {}

// 创建一个线程对象，静态方法
HmcThread *HmcThread::Create(const STRING &name, HmcThreadMain *entry, VOID *userData)
{
    HmcThread *thread = new (HmcThread);

    if (HMC_OK != thread->Init(name, entry, userData)) {
        delete (thread);
        return NULL;
    }

    LOGI("Thread \"%s\" created.", name.c_str());
    return thread;
}


//  获取调用线程的ID，静态方法
INT32 HmcThread::GetSelfThreadId()
{
    INT32 threadId = gettid();
    return threadId;
}

//  获取线程的ID
INT32 HmcThread::GetThreadId()
{
    return m_threadId;
}

// 获取线程名称
STRING HmcThread::GetThreadName()
{
    return m_name;
}

// 获取线程循环体内判断是否应该退出的标志
BOOL HmcThread::IsStopping()
{
    return m_isStopping;
}

// 线程退出接口
VOID HmcThread::Exit()
{
    LOGI("Thread \"%s\"(%d) exited.", m_name.c_str(), m_threadId);

    m_exitEvent.SetSignaled();
}

// 请求线程停止
VOID HmcThread::RequestForStop()
{
    LOGI("Requesting thread \"%s\"(%d) to stop.", m_name.c_str(), m_threadId);

    m_isStopping = TRUE;
}

//  线程安全停止接口
VOID HmcThread::Join()
{
    LOGI("Waiting thread \"%s\"(%d) to stop.", m_name.c_str(), m_threadId);

    UINT64 start = HmcGetSystemUpTime();

    while (HMC_ERR_EAGAIN == m_exitEvent.Wait(HMC_THREAD_EXIT_TIMEOUT)) {
        LOGW("Have been waiting for thread \"%s\"(%d) to stop for %llu ms ...", m_name.c_str(), m_threadId,
            HmcGetSystemUpTime() - start);
    }

    LOGI("Thread \"%s\"(%d) has been stopped.", m_name.c_str(), m_threadId);
}

// 线程入口
VOID HmcThread::InitThreadName()
{
    STRING thread_name;
    // 对超出系统限制的名字长度做截取，否则设置会失败
    if (m_name.length() > HMC_THREAD_NAME_LIMIT) {
        thread_name.assign(m_name, 0, HMC_THREAD_NAME_LIMIT);
    } else {
        thread_name = m_name;
    }
    pthread_setname_np(pthread_self(), thread_name.c_str());
}

VOID *HmcThread::InternalThreadMain(VOID *thread)
{
    HmcThread *thread_self = (HmcThread *)thread;
    // 设置线程名字到系统
    thread_self->InitThreadName();

    // 初始化线程ID
    thread_self->m_threadId = HmcThread::GetSelfThreadId();
    LOGI("Thread \"%s\"(%d) start to run.", thread_self->m_name.c_str(), thread_self->m_threadId);

    // 应用层的线程入口
    thread_self->m_entry->ThreadMain(thread_self, thread_self->m_userData);

    // 如果线程执行体里面用RETURN返回则可能运行到这里
    thread_self->Exit();

    return NULL;
}

// 内部使用的初始化函数
INT32 HmcThread::Init(const STRING &name, HmcThreadMain *entry, VOID *userData)
{
    m_entry = entry;
    m_name = name;
    m_userData = userData;
    m_isStopping = FALSE;

    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    if (pthread_create(&m_thread, &attr, HmcThread::InternalThreadMain, this)) {
        m_exitEvent.SetSignaled();
        return HMC_ERR;
    }

    return HMC_OK;
}

// 停止并销毁线程对象
VOID HmcThread::Destroy(HmcThread *&thread)
{
    if (thread) {
        thread->RequestForStop();
        thread->Join();
        delete thread;
        thread = NULL;
    }
}
