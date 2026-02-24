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

#ifndef HMCSINGLETON_H
#define HMCSINGLETON_H

#ifdef __cplusplus

///  单体使用方法:
///  1、声明的时候使用DECLARE_SINGLETON宏定义声明单体，例如
///    例        class HmcLogManager
///    例        {
///    例            DECLARE_SINGLETON(HmcLogManager);
///    例            ... ...
///    例        }
///
///  2、单体类实现的时候在cpp文件里增加一行：
///    例        IMPLEMENT_SINGLETON(HmcLogManager)
///
///  3、使用单体类的时候使用SINGLETON宏定义
///    例        SINGLETON(HmcLogManager)->WriteLog();
///
///  4、允许自行实现单体类的构造函数，但析构和拷贝构造被禁止
///    例        virtual ~T() = delete;

// 单体声明
#define DECLARE_SINGLETON(T)      \
private:                          \
    virtual ~T() = delete;        \
                                  \
private:                          \
    static T *m_instance;         \
    static std::once_flag m_once; \
                                  \
public:                           \
    static T *GetInstance()

// 单体实现
#define IMPLEMENT_SINGLETON(T)                              \
    T *T::m_instance = NULL;                                \
    std::once_flag T::m_once;                               \
    T *T::GetInstance()                                     \
    {                                                       \
        std::call_once(m_once, [] { m_instance = new T; }); \
        return m_instance;                                  \
    }

// 单体取用
#define SINGLETON(T) T::GetInstance()

#endif // __cplusplus

#endif // HMCSINGLETON_H
