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

#ifndef HMCTHREAD_H
#define HMCTHREAD_H

#include "./HmcThreadMain.h"

class HMC_API HmcThread {
private:
    HmcThread();
    virtual ~HmcThread();

public:
    /* *
     * 创建一个线程对象，静态方法
     * @param name      线程名称，请使用有意义的名称，建议使用更加紧凑的大驼峰风格，例如"RtspServer"
     * @param entry     线程入口对象，由使用者实现
     * @param userData  用户自定义数据，会带入到ThreadMain接口
     * @return          线程对象，NULL表示创建失败
     * @note            线程名称尽量不要超过15个有效字符，否则可能会在某些操作系统下被截断
     */
    static HmcThread *Create(const STRING &name, HmcThreadMain *entry, VOID *userData = NULL);

    /* *
     * 停止并销毁线程对象
     * @param thread 待销毁线程，返回后置空
     */
    static VOID Destroy(HmcThread *&thread);

    /* *
     * 获取调用线程的PID
     * @return 调用线程的PID
     */
    static INT32 GetSelfThreadId();

    /* *
     * 获取线程的ID
     * @return 线程的ID
     */
    INT32 GetThreadId();

    /* *
     * 获取线程名称
     * @return 线程的名称
     */
    STRING GetThreadName();

    /* *
     * 获取线程循环体内判断是否应该退出的标志
     * @return  是否应该退出的标志
     * @note    此函数仅供线程内调用
     */
    BOOL IsStopping();

    /* *
     * 线程主动退出
     * @note    此函数仅供线程内调用
     */
    VOID Exit();

    /* *
     * 请求线程停止
     */
    VOID RequestForStop();

    /* *
     * 等待线程安全停止，同步阻塞
     */
    VOID Join();

private:
    // 内部使用的线程入口
    static VOID *InternalThreadMain(VOID *thread);

    // 内部使用的初始化函数
    INT32 Init(const STRING &name, HmcThreadMain *entry, VOID *userData);

    // 初始化线程名称
    VOID InitThreadName();

private:
    // 线程名称
    STRING m_name;

    // 线程入口
    HmcThreadMain *m_entry;

    // 用户数据
    VOID *m_userData;

    // 线程对象
    pthread_t m_thread;

    // 线程ID
    INT32 m_threadId;

    // 是否应该退出的标志
    ATOMIC_BOOL m_isStopping;

    // 线程退出事件，同时作为线程已退出标志
    HmcEvent m_exitEvent;
};

#endif // HMCTHREAD_H
