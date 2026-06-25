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


#ifndef HMCMUTEX_H
#define HMCMUTEX_H

// 请应用层使用此宏定义操作互斥锁
#define HMC_MUTEX_LOCK(m) (m).Lock()
#define HMC_MUTEX_TRY_LOCK(m) (m).TryLock()
#define HMC_MUTEX_UNLOCK(m) (m).Unlock()

// 锁对象的类定义，支持递归调用
class HMC_API HmcMutex {
public:
    /* *
     * 互斥锁构造
     * @param name      互斥锁名称，请使用有意义的名称，建议使用更加紧凑的大驼峰风格，例如"UserDataMutex"
     */
    explicit HmcMutex(const STRING &name = "AnonymousMutex");

    virtual ~HmcMutex();

public:
    VOID Lock();

    INT32 TryLock();

    VOID Unlock();

private:
    pthread_mutex_t m_mutex;

    // 锁对象名字
    STRING m_name;
};

#endif // HMCMUTEX_H
