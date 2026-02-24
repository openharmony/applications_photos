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

#ifndef HMCCONFIG_H
#define HMCCONFIG_H

#ifdef __cplusplus
extern "C" {
#endif

/**
 * 设置32位整型类型的配置项
 * @param name      配置名称
 * @param value     配置值
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcConfigSetInt32(const char *name, int value);

/**
 * 设置64位整型类型的配置项
 * @param name      配置名称
 * @param value     配置值
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcConfigSetInt64(const char *name, int64_t value);

/**
 * 设置双精度浮点类型的配置项
 * @param name      配置名称
 * @param value     配置值
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcConfigSetDouble(const char *name, double value);

/**
 * 获取32位整型类型的配置项
 * @param name      配置名称
 * @param value     待获取数据指针
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcConfigGetInt32(const char *name, int *value);


/**
 * 获取64位整型类型的数据
 * @param dict      HmcConfig字典句柄
 * @param name      配置名称
 * @param value     待获取数据指针
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcConfigGetInt64(const char *name, int64_t *value);


/**
 * 获取双精度浮点类型的数据
 * @param name      配置名称
 * @param value     待获取数据指针
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcConfigGetDouble(const char *name, double *value);

/**
 * 删除某个配置项
 * @param name      配置名称
 */
HMC_API void HmcConfigRemove(const char *name);

#ifdef __cplusplus
}
#endif

#endif // HMCCONFIG_H
