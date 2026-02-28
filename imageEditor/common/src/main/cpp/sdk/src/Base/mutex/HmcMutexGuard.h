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

#ifndef HMCMUTEXGUARD_H
#define HMCMUTEXGUARD_H

// 门卫自动锁
#define HMC_MUTEX_GUARD(m) HmcMutexGuard _##m(&(m))

// 门卫自动锁对象的类定义
class HMC_API HmcMutexGuard {
public:
    explicit HmcMutexGuard(HmcMutex *lock);

    virtual ~HmcMutexGuard();

private:
    // 默认构造被禁止
    HmcMutexGuard() : m_lock(NULL) {}

    // 赋值操作被禁止
    VOID operator = (const HmcMutexGuard &) {}

private:
    HmcMutex *m_lock;
};

#endif // HMCMUTEXGUARD_H
