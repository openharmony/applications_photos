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
#ifndef HMCOHOS_H
#define HMCOHOS_H

HMC_API STRING HmcOhosGetCpuName();

HMC_API STRING HmcOhosGetSystemUid();

// 获取系统版本信息
HMC_API STRING HmcOhosGetSystemVersion();

/**
 * 获取系统启动时长
 * @return 系统启动时长，单位毫秒
 */
HMC_C_API UINT64 HmcOhosGetSystemUpTime();

/**
 * 获取应用名称（包名）
 * @return 应用名称（包名）
 */
HMC_API STRING HmcOhosGetAppName();


/**
 * 获取系统/应用内存信息
 * @param osTotal       输出内核总可用内存，略小于物理内存，单位MB，可以为NULL
 * @param osFree        输出内核当前空闲内存，单位MB，可以为NULL
 * @param appResident   输出应用驻留物理内存，单位MB，可以为NULL
 * @param appVirtual    输出应用虚拟内存，单位MB，可以为NULL
 * @return              HMC_OK 成功<br> 其他值 失败错误码
 */
HMC_C_API INT32 HmcOhosGetSystemMemoryInfo(UINT32 *sysTotal, UINT32 *sysFree, UINT32 *appResident, UINT32 *appVirtual);

// 获取调用栈信息
HMC_API UINT32 HmcOhosGetBackTraceWithContext(VOID **stack, UINT32 size, ucontext_t *ctx);

// 获取指令地址相关符号信息
HMC_API INT32 HmcOhosGetSymbolInfo(const void *pc, CHAR *info, UINT32 infoSize);

/**
 * 获取APP的context
 * @return          返回APP的StageContext，调用者将返回值强转成napi_value即可使用
 */
HMC_API VOID *HmcOhosGetApplicationContext();

/**
 * 获取raw file的context
 * @return          返回raw file的context，调用者将返回值强转成napi_value即可使用
 */
HMC_API VOID *HmcOhosGetModuleContext();

/**
 * 获取内部存储路径
 * @param type      类型，例如"cache"，"files"，
 * @return          内部存储路径，例如"/data/user/0/com.xxx.xxx/cache"<br>
 * 获取不到的情况下，返回空
 * @note            1. 这个路径每个登陆用户都不一样的<br>
 * 2. 卸载后会自动删除
 */
HMC_API STRING HmcOhosGetInternalStorageDir(STRING type);

/**
 * 获取hap的文件路径
 * @return          内部存储路径，例如"/data/app/el2/100/base/com.xxx.xxx.petalclip/haps/entry/files"
 */
HMC_API STRING HmcOhosGetHapFilesDir();

#endif // HMCOHOS_H
