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

#ifndef HMCDICT_H
#define HMCDICT_H
#include "HmcBaseType.h"
#include "MediaCreative/HmcUid.h"
#include <cstdint>
#ifdef __cplusplus
extern "C" {
#endif

// HmcDict类型定义
typedef void HmcDict;

/**
 * 创建一个空的HmcDict字典
 * @return          HmcDict字典句柄，必须用HmcDictDestroy接口释放
 */
HMC_API HmcDict *HmcDictCreate();

/**
 * 获取下一个关键字，用于迭代遍历
 * @param dict      HmcDict字典句柄
 * @param key       当前关键字，首次传入NULL
 * @return          下一个关键字，不用释放，NULL表示结束
 * @note            返回的关键字并非原始字符串，而是统一转成小写的
 */
HMC_API const char *HmcDictGetNextKey(const HmcDict *dict, const char *key);

/**
 * 删除某个关键字
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 */
HMC_API void HmcDictRemoveKey(const HmcDict *dict, const char *key);

/**
 * 设置32位整型类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待写入数据
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcDictSetInt32(const HmcDict *dict, const char *key, int value);

/**
 * 获取32位整型类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待获取数据指针
 * @return          HMC_OK          代表成功<br>
 * HMC_ERR_PARAM       代表参数错误<br>
 * HMC_ERR_DICT_KEY    代表无此关键字对应数据
 */
HMC_API int HmcDictGetInt32(const HmcDict *dict, const char *key, int *value);


/**
 * 设置64位整型类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待写入数据
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcDictSetInt64(const HmcDict *dict, const char *key, int64_t value);

/**
 * 获取64位整型类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待获取数据指针
 * @return          HMC_OK          代表成功<br>
 * HMC_ERR_PARAM       代表参数错误<br>
 * HMC_ERR_DICT_KEY    代表无此关键字对应数据
 */
HMC_API int HmcDictGetInt64(const HmcDict *dict, const char *key, int64_t *value);


/**
 * 设置字符串类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待写入字符串
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcDictSetString(const HmcDict *dict, const char *key, const char *value);

/**
 * 获取字符串类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待获取字符串指针的地址
 * @return          字符串，NULL表示获取失败，临时对象，请勿释放或者长期使用
 */
HMC_API const char *HmcDictGetString(const HmcDict *dict, const char *key);

/**
 * 设置双精度浮点类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待写入数据
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcDictSetDouble(const HmcDict *dict, const char *key, double value);

/**
 * 获取双精度浮点类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待获取数据指针
 * @return          HMC_OK          代表成功<br>
 * HMC_ERR_PARAM       代表参数错误<br>
 * HMC_ERR_DICT_KEY    代表无此关键字对应数据
 */
HMC_API int HmcDictGetDouble(const HmcDict *dict, const char *key, double *value);


/**
 * 设置指针类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待写入数据
 * @return          HMC_OK代表成功<br>其他值表示错误码
 */
HMC_API int HmcDictSetPointer(const HmcDict *dict, const char *key, void *value);

/**
 * 获取指针类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param value     待获取指针地址
 * @return          HMC_OK          代表成功<br>
 * HMC_ERR_PARAM       代表参数错误<br>
 * HMC_ERR_DICT_KEY    代表无此关键字对应数据
 */
HMC_API int HmcDictGetPointer(const HmcDict *dict, const char *key, void **value);


/**
 * 设置UID类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param uid       待写入UID
 * @return          HMC_OK    转换成功<br>
 * HMC_ERR_PARAM 参数错误<br>
 */
HMC_API int HmcDictSetUid(const HmcDict *dict, const char *key, const HmcUid *uid);

/**
 * 获取UID类型的数据
 * @param dict      HmcDict字典句柄
 * @param key       关键字，忽略大小写
 * @param uid       待获取UID地址
 * @return          HMC_OK    转换成功<br>
 * HMC_ERR_PARAM 参数错误<br>
 */
HMC_API int HmcDictGetUid(const HmcDict *dict, const char *key, HmcUid *uid);

/**
 * 复制HmcDict字典
 * @param dict      待复制HmcDict字典句柄
 * @return          已复制HmcDict字典句柄，必须用HmcDictDestroy接口释放
 */
HMC_API HmcDict *HmcDictDuplicate(const HmcDict *dict);

/**
 * 序列化
 * @param dict      HmcDict字典句柄
 * @return          已序列化文本，必须用HmcFree接口释放<br>
 * NULL表示序列化失败
 * @warning         1.如果key里面包含':'字符会导致反序列化失败<br>
 * 2.如果key/value里面包含'\r'/'\n'会导致反序列化失败<br>
 * 3.跨进程的情况下指针类型的序列化/反序列化是没有意义的
 */
HMC_API char *HmcDictSerialize(const HmcDict *dict);

/**
 * 反序列化
 * @param dictStr   已序列化HmcDict字典文本
 * @return          HmcDict字典句柄，必须用HmcDictDestroy接口释放<br>
 * NULL表示反序列化失败
 */
HMC_API HmcDict *HmcDictDeserialize(const char *dictStr);


/**
 * 销毁HmcDict字典，释放内存
 * @param dict      待销毁HmcDict字典句柄
 */
HMC_API void HmcDictDestroy(HmcDict *dict);

#ifdef __cplusplus
}
#endif

#endif // HMCDICT_H
