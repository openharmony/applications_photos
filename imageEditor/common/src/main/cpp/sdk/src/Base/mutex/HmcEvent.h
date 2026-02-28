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

#ifndef HMCEVENT_H
#define HMCEVENT_H

// 事件等待对象的类定义
class HMC_API HmcEvent {
public:
    /* *
     * 事件对象构造函数
     * @param name          事件名称，请使用有意义的名称，建议使用更加紧凑的大驼峰风格，例如"ExitEvent"
     * @param manualReset   手动复位
     * @param initialState  初始状态
     */
    explicit HmcEvent(const STRING &name = "AnonymousEvent", BOOL manualReset = FALSE, BOOL initialState = FALSE);

    /* *
     * 析构函数
     */
    virtual ~HmcEvent();

public:
    /* *
     * 设置为已触发状态
     */
    VOID SetSignaled();

    /* *
     * 设置为未触发状态
     */
    VOID SetUnsignaled();

    /* *
     * 等待事件触发
     * @param timeout   超时时间，单位毫秒，可以用HMC_DONT_WAIT/HMC_WAIT_FOREVER
     * @return          HMC_OK       事件触发<br>
     * HMC_ERR_EAGAIN   等待超时
     */
    INT32 Wait(UINT32 timeout);

private:
    // 内部使用
    INT32 WaitPeriod(INT32 timeout);

private:
    // 信号量对象名字
    STRING m_name;

    pthread_mutex_t m_mutex;
    pthread_cond_t m_cond;
    BOOL m_manualReset{ FALSE };
    BOOL m_signaled{ FALSE };
};

#endif // HMCEVENT_H
