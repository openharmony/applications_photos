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

#ifndef HMCBASE_TYPE_H
#define HMCBASE_TYPE_H

///////////////////////////////////////////////////////////////////////////////
// Part-1 依赖的系统头文件
///////////////////////////////////////////////////////////////////////////////
#include <math.h>
#include <errno.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <pthread.h>
#include <semaphore.h>
#include <libgen.h>
#include <dlfcn.h>
#include <signal.h>
#include <memory>
#include <limits>
#include <locale>
#include <atomic>
#include <string>
#include <list>
#include <queue>
#include <deque>
#include <set>
#include <map>
#include <vector>
#include <mutex>
#include <unordered_map>
#include <iterator>
#include <algorithm>
#include <thread>
#include <istream>
#include <ostream>
#include <fstream>

///////////////////////////////////////////////////////////////////////////////
// Part-2 依赖的安全函数库的头文件
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Part-3 公共类型定义
///////////////////////////////////////////////////////////////////////////////

#define CHAR char
#define UCHAR unsigned char
#define SHORT short
#define USHORT unsigned short
#define LONG long
#define ULONG unsigned long
#define FLOAT float
#define DOUBLE double
#define INT8 signed char
#define UINT8 unsigned char
#define INT16 signed short int
#define UINT16 unsigned short int
#define INT32 signed int
#define UINT32 unsigned int

#ifdef __LP64__
#define INT64 long int
#define UINT64 unsigned long int
#else
#define INT64 long long int
#define UINT64 unsigned long long int
#endif

#define VOID void

#define SIZE_T size_t
#define SOCKET INT32

#define STRING std::string
#define STRING_LIST std::list<std::string>
#define STRING_VECTOR std::vector<std::string>

#define WSTRING std::wstring
#define WSTRING_LIST std::list<std::wstring>
#define WSTRING_VECTOR std::vector<std::wstring>

#define PAIR std::pair
#define SET std::set
#define LIST std::list
#define MAP std::map
#define VECTOR std::vector
#define ATOMIC_BOOL std::atomic_bool
#define ATOMIC_INT32 std::atomic_int32_t
#define ATOMIC_UINT32 std::atomic_uint32_t
#define ATOMIC_INT64 std::atomic_llong
#define ATOMIC_UINT64 std::atomic_ullong
#define UNIQUE_PTR std::unique_ptr
#define HASH_MAP std::unordered_map
#define MULITMAP std::multimap
#define SHARED_PTR std::shared_ptr
#define WEAK_PTR std::weak_ptr
#define DEQUE std::deque
#define LOCKGUARD std::lock_guard<std::mutex>

#ifdef NULL
#undef NULL
#endif

#ifdef __cplusplus
#define NULL nullptr
#else
#define NULL (0)
#endif

typedef int BOOL;
#define TRUE 1
#define FALSE 0


#ifndef IN
#define IN
#endif

#ifndef OUT
#define OUT
#endif

#ifndef INOUT
#define INOUT
#endif

///////////////////////////////////////////////////////////////////////////////
// Part-4 公共宏定义
///////////////////////////////////////////////////////////////////////////////
#ifndef HMC_API
#define HMC_API __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
#define HMC_C_API extern "C" HMC_API
#else
#define HMC_C_API HMC_API
#endif

// 调试开关，CMAKE会在RELEASE情况下自动定义NDEBUG宏，但不会在DEBUG情况下自动生成DEBUG宏
// NDEBUG宏控制了assert的行为，而不是DEBUG宏
#undef DEBUG
#ifndef NDEBUG
#define DEBUG
#endif

// 回车换行
#define CRLF "\r\n"
// 空字符串
#define EMPTY_STR ""


// 空字符串
#define EMPTY_STR ""

// 空格
#define SPACE_STR " "

#define FILE_SEPARATOR_STR "/"
#define FILE_SEPARATOR_CHAR '/'


// 等待超时相关定义，用于Socket/Semaphore/Event等
#define HMC_DONT_WAIT 0

constexpr UINT32 HMC_WAIT_FOREVER = ~0U;


#define HMC_MIN(a, b) (((a) > (b)) ? (b) : (a))
#define HMC_MAX(a, b) (((a) > (b)) ? (a) : (b))

#define HMC_UNUSED(x) (void)(x)
#define HMC_FLOAT_EPSINON (0.00001)

// 时间转换相关宏定义
#ifdef __cplusplus
constexpr UINT64 THOUSAND = 1000;
#else
#define THOUSAND 1000ULL
#endif

#define S2MS(s) ((UINT64)(s)*THOUSAND)
#define S2US(s) ((UINT64)(s)*THOUSAND * THOUSAND)
#define S2NS(s) ((UINT64)(s)*THOUSAND * THOUSAND * THOUSAND)

#define MS2S(ms) ((UINT64)(ms) / THOUSAND)
#define MS2US(ms) ((UINT64)(ms)*THOUSAND)
#define MS2NS(ms) ((UINT64)(ms)*THOUSAND * THOUSAND)

#define US2S(us) ((UINT64)(us) / THOUSAND / THOUSAND)
#define US2MS(us) ((UINT64)(us) / THOUSAND)
#define US2NS(us) ((UINT64)(us)*THOUSAND)

#define NS2S(ns) ((UINT64)(ns) / THOUSAND / THOUSAND / THOUSAND)
#define NS2MS(ns) ((UINT64)(ns) / THOUSAND / THOUSAND)
#define NS2US(ns) ((UINT64)(ns) / THOUSAND)

// 非法Socket/文件句柄定义
#ifdef __cplusplus
constexpr INT32 HMC_INVALID_FD = -1;
#else
#define HMC_INVALID_FD (INT32)(-1)
#endif

// 非法文件大小定义
#ifdef __cplusplus
constexpr INT64 HMC_INVALID_FILE_SIZE = -1;
#else
#define HMC_INVALID_FILE_SIZE (INT64)(-1)
#endif

// 向上/向下对齐，align必须是2的幂次
#define HMC_ALIGN_UP(x, align) (((x) + (align)-1) & ~((align)-1))
#define HMC_ALIGN_DOWN(x, align)    (x) & -(align))


// 旋转角度相关宏定义
#ifdef __cplusplus
constexpr INT32 HMC_ROTATE_90_DEGREE = 90;
constexpr INT32 HMC_ROTATE_180_DEGREE = 180;
constexpr INT32 HMC_ROTATE_270_DEGREE = 270;
constexpr INT32 HMC_ROTATE_360_DEGREE = 360;
#else #define HMC_ROTATE_90_DEGREE 90
#define HMC_ROTATE_180_DEGREE 180
#define HMC_ROTATE_270_DEGREE 270
#define HMC_ROTATE_360_DEGREE 360
#endif

#define CHECK_AND_RETURN_RET_LOG(cond, ret, fmt, ...)                                                                  \
    do {                                                                                                               \
        if (!(cond)) {                                                                                                 \
            LOGE(fmt, ##__VA_ARGS__);                                                                                  \
            return ret;                                                                                                \
        }                                                                                                              \
    } while (0)

#define CHECK_LOG(cond, fmt, ...)                                                                                      \
    do {                                                                                                               \
        if (!(cond)) {                                                                                                 \
            LOGE(fmt, ##__VA_ARGS__);                                                                                  \
            return;                                                                                                    \
        }                                                                                                              \
    } while (0)

#define CHECK_AND_RETURN_RET_LOG_WITH_FUNCTION(cond, ret, function, fmt, ...)                                         \
    do {                                                                                                               \
        if (!(cond)) {                                                                                                 \
            LOGE(fmt, ##__VA_ARGS__);                                                                                  \
            function;                                                                                                  \
            return ret;                                                                                                \
        }                                                                                                              \
    } while (0)

#define CHECK_LOG_WITH_FUNCTION(cond, function, fmt, ...)                                                             \
    do {                                                                                                               \
        if (!(cond)) {                                                                                                 \
            LOGE(fmt, ##__VA_ARGS__);                                                                                  \
            function;                                                                                                  \
            return;                                                                                                    \
        }                                                                                                              \
    } while (0)

#define Trace_Start() OH_HiTrace_StartTrace(__func__)
#define Trace_Finish() OH_HiTrace_FinishTrace()

#endif // HMCBASE_TYPE_H
