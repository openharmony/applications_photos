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
#include <js_native_api.h>
#include <js_native_api_types.h>
#include "../../../Bridge/ohos/common/NapiCommon.h"

extern napi_env g_napiEnv;

// 获取系统启动时长
UINT64 HmcOhosGetSystemUpTime()
{
    // https://stackoverflow.com/questions/4943733/is-clock-monotonic-process-or-thread-specific
    // The only difference between CLOCK_REALTIME and CLOCK_MONOTONIC is that the latter
    // can not be set. These clocks are ticking even when your process is not running.
    // In Linux, surprisingly, CLOCK_MONOTONIC seems to be still affected by NTP adjustments,
    // so that it could go backwards. Hence they added another clock CLOCK_MONOTONIC_RAW
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC_RAW, &t);

    UINT64 upTime = S2MS(t.tv_sec) + NS2MS(t.tv_nsec);
    return upTime;
}

// 获取应用名称
STRING HmcOhosGetAppName()
{
    // 缓存
    static STRING appName;
    if (!appName.empty()) {
        return appName;
    }

    STRING cmdLine;
    if (HMC_OK != HmcStringDeserialize("/proc/self/cmdline", cmdLine)) {
        return std::string();
    }

    // 可能存在冒号，要剔除，例如 com.sohu.inputmethod.sogou:push_service
    appName.assign(cmdLine, 0, cmdLine.find_first_of(':'));
    return appName;
}

// 获取系统/应用内存信息
INT32 HmcOhosGetSystemMemoryInfo(UINT32 *sysTotal, UINT32 *sysFree, UINT32 *appResident, UINT32 *appVirtual)
{
    if (sysTotal || sysFree) {
        struct sysinfo si;

        if (sysinfo(&si) < 0) {
            return HMC_ERR;
        }

        if (sysTotal) {
            UINT64 totalBytes = si.totalram * si.mem_unit;
            // 转换成兆字节
            *sysTotal = totalBytes >> 20;
        }

        if (sysFree) {
            UINT64 freeBytes = si.freeram * si.mem_unit;
            *sysFree = freeBytes >> 20;
        }
    }

    if (!appResident && !appVirtual) {
        return HMC_OK;
    }

    ///proc/[pid]/statm
    // Provides information about memory usage, measured in pages.
    //     The columns are:
    //
    // size       (1) total program size (same as VmSize in /proc/[pid]/status)
    // resident   (2) resident set size  (same as VmRSS in /proc/[pid]/status)
    // share      (3) shared pages (i.e., backed by a file)
    // text       (4) text (code)
    // lib        (5) library (unused in Linux 2.6)
    // data       (6) data + stack
    // dt         (7) dirty pages (unused in Linux 2.6)
    STRING statm;
    HmcStringDeserialize("/proc/self/statm", statm);

    auto split = HmcSplitString(statm, " ");
    if (split.size() <= 2) {
        return HMC_ERR;
    }

    if (appVirtual) {
        UINT64 virtualBytes = HmcStringToUint64(split[0]) * HmcGetSystemPageSize();
        *appVirtual = virtualBytes >> 20;
    }

    if (appResident) {
        UINT64 residentBytes = HmcStringToUint64(split[1]) * HmcGetSystemPageSize();
        *appResident = residentBytes >> 20;
    }

    return HMC_OK;
}

UINT32 HmcOhosGetBackTraceWithContext(VOID **stack, UINT32 size, ucontext_t *ctx)
{
    UINT32 count = 0;

#if defined __arm__

    if (size >= 2) {
        // Set PC at 0
        *(stack++) = (VOID *)ctx->uc_mcontext.arm_pc;

        // Set LR as 2nd stack
        *(stack++) = (VOID *)ctx->uc_mcontext.arm_lr;
        count = 2;
    }

#elif defined __aarch64__
    // X29 as Frame Pointer
#else
    // #error Fix me!
#endif

    return count;
}

// 获取指令地址相关符号信息
INT32 HmcOhosGetSymbolInfo(const void *pc, CHAR *info, UINT32 infoSize)
{
    // dladdr() returns 0 on error, and nonzero on success.
    Dl_info dlinfo;
    if (!dladdr(pc, &dlinfo)) {
        return HMC_ERR;
    }

    UINT32 i = (UINT32)snprintf(info, infoSize, "0x%08lx", (ULONG)(uintptr_t)pc);

    if (dlinfo.dli_fname && dlinfo.dli_fbase) {
        i += (UINT32)snprintf(info + i, infoSize, " %s+0x%lx", dlinfo.dli_fname,
            (LONG)(uintptr_t)pc - (LONG)(uintptr_t)dlinfo.dli_fbase);
    }

    if (dlinfo.dli_sname && dlinfo.dli_saddr) {
        int len = snprintf(info + i, infoSize, " (%s+0x%lx)", dlinfo.dli_sname,
            (LONG)(uintptr_t)pc - (LONG)(uintptr_t)dlinfo.dli_saddr);
        if (len <= 0) {
            LOGE("sprintf_s error");
        }
    }

    return HMC_OK;
}

STRING HmcOhosGetCpuName()
{
    static STRING s_cpuName;

    if (!s_cpuName.empty()) {
        return s_cpuName;
    }

    STRING cpuinfo;
    if (HMC_OK != HmcStringDeserialize("/proc/cpuinfo", cpuinfo)) {
        return STRING();
    }

    STRING::size_type pos = cpuinfo.find("\nHardware");
    if (STRING::npos == pos) {
        // model name      : Intel(R) Atom(TM) CPU Z2580  @ 2.00GHz
        pos = cpuinfo.find("\nmodel name");
        if (STRING::npos == pos) {
            // Processor       : AArch64 Processor rev 0 (aarch64)
            pos = cpuinfo.find("Processor ");
            if (STRING::npos == pos) {
                return STRING();
            }
        }
    }

    // Skip space and ':'
    STRING::size_type start = cpuinfo.find_first_not_of(": \t", pos + 11);
    STRING::size_type end = cpuinfo.find_first_of("\r\n", start);

    s_cpuName.assign(cpuinfo, start, end - start);
    return s_cpuName;
}

// 获取内部存储路径
STRING HmcOhosGetInternalStorageDir(STRING type)
{
    // 这里写的是一个沙盒化虚拟路径，实际存储路径可能是“/data/app/el2/100/base/com.ohos.videoeditor/“
    if (type.empty()) {
        return HmcOhosGetHapFilesDir();
    } else {
        return HmcOhosGetHapFilesDir() + "/" + type;
    }
}

VOID *HmcOhosGetApplicationContext()
{
    if (g_napiEnv == nullptr) {
        LOGE("HmcOhosGetApplicationContext, g_napiEnv is nullptr");
        return nullptr;
    }
    
    napi_value global, stageContext;
    napi_status status = napi_get_global(g_napiEnv, &global);
    if (status != napi_ok) {
        LOGE("HmcOhosGetApplicationContext napi_get_global failed, status=%d", status);
        return nullptr;
    }

    napi_value globalThis;
    status = napi_get_named_property(g_napiEnv, global, "globalThis", &globalThis);
    if (status != napi_ok) {
        LOGE("HmcOhosGetApplicationContext napi_get_named_property globalThis failed, status=%d", status);
        return nullptr;
    }

    status = napi_get_named_property(g_napiEnv, globalThis, "editor_stageContext", &stageContext);
    if (status != napi_ok) {
        LOGE("HmcOhosGetApplicationContext napi_get_named_property stageContext failed, status=%d", status);
        return nullptr;
    }

    return stageContext;
}

VOID *HmcOhosGetModuleContext()
{
    if (g_napiEnv == nullptr) {
        LOGE("HmcOhosGetModuleContext, g_napiEnv is nullptr");
        return nullptr;
    }
    napi_value global, moduleContext;
    napi_status status = napi_get_global(g_napiEnv, &global);
    if (status != napi_ok) {
        LOGE("HmcOhosGetModuleContext napi_get_global failed, status=%d", status);
        return nullptr;
    }

    napi_value globalThis;
    status = napi_get_named_property(g_napiEnv, global, "globalThis", &globalThis);
    if (status != napi_ok) {
        LOGE(" HmcOhosGetModuleContext napi_get_named_property globalThis failed, status=%d", status);
        return nullptr;
    }

    status = napi_get_named_property(g_napiEnv, globalThis, "editor_moduleContext", &moduleContext);
    if (status != napi_ok) {
        LOGE("HmcOhosGetModuleContext napi_get_named_property moduleContext failed, status=%d", status);
        return nullptr;
    }

    return moduleContext;
}

STRING sCurrentHapFilesDir;
// 获取hap的文件路径
STRING HmcOhosGetHapFilesDir()
{
    if (!sCurrentHapFilesDir.empty()) {
        return sCurrentHapFilesDir;
    }
    STRING dir = "/data/storage/el2/base/haps/entry/files";

    napi_value context = static_cast<napi_value>(HmcOhosGetApplicationContext());
    if (context == nullptr) {
        LOGE("HmcOhosGetApplicationContext get application context failed");
        return dir;
    }

    napi_value hapFilesDir;
    napi_status status = napi_get_named_property(g_napiEnv, context, "filesDir", &hapFilesDir);
    if (status != napi_ok) {
        LOGE("napi_get_named_property filesDir failed, status=%d", status);
        return dir;
    }

    auto res = unwrap_string_from_js(g_napiEnv, hapFilesDir);

    sCurrentHapFilesDir = (res.empty() ? dir : res);
    sCurrentHapFilesDir += "/editor"; // 编辑业务的文件存放在独立的目录，防止与调用方应用文件重复
    LOGD("HmcOhosGetHapFilesDir dir=%s", sCurrentHapFilesDir.c_str());
    return sCurrentHapFilesDir;
}
