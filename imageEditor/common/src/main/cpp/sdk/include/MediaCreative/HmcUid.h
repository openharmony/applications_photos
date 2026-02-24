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

#ifndef HMCUID_H
#define HMCUID_H

#ifdef __cplusplus
extern "C" {
#endif

// UID字节长度
#define HMC_UID_LEN 16

// UID字符串长度，包含结尾的'\0'
#define HMC_UID_STR_LEN (36 + 1)

// HmcUid类型定义
typedef struct HmcUid {
    unsigned char id[HMC_UID_LEN];
} HmcUid;

// 空UID定义
HMC_API extern const HmcUid HMC_UID_NULL;

/**
 * 生成一个UID
 * @param uid       待生成UID指针
 */
HMC_API void HmcUidGenerate(HmcUid *uid);

/**
 * 判断两个UID是否相等
 * @param uid1      第1个UID指针
 * @param uid2      第2个UID指针
 * @return          0代表不相等，其他值代表相等
 */
HMC_API int HmcUidIsEqual(const HmcUid *uid1, const HmcUid *uid2);

/**
 * 拷贝UID
 * @param dest      待拷贝UID指针
 * @param src       源UID指针
 */
HMC_API void HmcUidCopy(HmcUid *dest, const HmcUid *src);


/**
 * 判断UID是否是空UID
 * @param uid       UID指针
 * @return          0代表不是空UID，其他值代表是空UID
 */
HMC_API int HmcUidIsNull(const HmcUid *uid);

/**
 * 把UID对象转换为UID字符串
 * @param uid       待转换UID指针
 * @param string    字符串缓冲区
 * @param size      字符串缓冲区大小，不得小于HMC_UID_STR_LEN
 * @return          转换成功的情况下返回string地址，否则返回NULL
 */
HMC_API char *HmcUidToString(const HmcUid *uid, char *string, int size);

/**
 * 把UID字符串转换为UID对象
 * @param string    待转换UID字符串
 * @param uid       UID对象指针
 * @return          HMC_OK    转换成功<br>
 * HMC_ERR_PARAM 参数错误<br>
 */
HMC_API int HmcUidFromString(const char *string, HmcUid *uid);

#ifdef __cplusplus
}
#endif

#endif // HMCUID_H
