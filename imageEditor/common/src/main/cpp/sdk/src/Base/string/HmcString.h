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

#ifndef HMCSTRING_H
#define HMCSTRING_H

#include "HmcBaseType.h"

/**
 * 格式化字符串
 * @param string        输出格式化字符串
 * @param format        格式
 * @param ...           其他参数
 * @return              格式化字符串长度
 */
INT32 HmcStringFormat(STRING &string, const CHAR *format, ...);

/**
 * 格式化字符串
 * @param format        格式
 * @param ...           其他参数
 * @return              格式化字符串
 */
STRING HmcStringFormat(const CHAR *format, ...);

/**
 * 格式化字符串
 * @param string        输出格式化字符串
 * @param format        格式
 * @param arg           其他参数
 * @return              格式化字符串长度
 */
INT32 HmcStringFormatV(STRING &string, const CHAR *format, va_list arg);

/**
 * 序列化字符串到文件
 * @param string       字符串
 * @param filePath     文件路径
 * @return HMC_OK 成功<br> 其他值 失败错误码
 */
INT32 HmcStringSerialize(const STRING &string, const STRING &filePath);

/**
 * 反序列化字符串
 * @param filePath     文件路径
 * @param string       字符串
 * @return HMC_OK 成功<br> 其他值 失败错误码
 * @note   本接口并不判断文件大小合法性
 */
INT32 HmcStringDeserialize(const STRING &filePath, STRING &string);

/**
 * 计算字符串的32位简单散列值
 * @param string        字符串
 * @return              散列值
 * @warning             不可以用于安全领域
 */
HMC_API UINT32 HmcGetStringHashCode32(const STRING &string);

/**
 * 计算字符串的64位简单散列值
 * @param string        字符串
 * @return              散列值
 * @warning             不可以用于安全领域
 */
UINT64 HmcGetStringHashCode64(const STRING &string);

/**
 * 分割字符串
 * @param string        待分割字符串
 * @param delims         分隔符集合
 * @param emptyAllowed  是否允许空值，允许的话输出类似Python风格的带空值的结果
 * @return              已分割字符串
 */
STRING_VECTOR HmcSplitString(const STRING &string, const STRING &delims, BOOL emptyAllowed = FALSE);

/**
 * 转换字符串到数字
 * @param string        待转换字符串，自动识别进制
 * @return              转换数字
 */
UINT64 HmcStringToUint64(const STRING &string);


/**
 * 判断字符串是否以某前缀开始
 * @param string           待判断字符串
 * @param prefix           前缀
 * @return                 判断结果
 * @note                   大小写敏感
 */
BOOL HmcStringIsStartWith(const STRING &string, const STRING &prefix);

/**
 * 判断字符串是否以某后缀结束
 * @param string            待判断字符串
 * @param suffix            后缀
 * @return                  判断结果
 * @note                   大小写敏感
 */
BOOL HmcStringIsEndWith(const STRING &string, const STRING &suffix);


/**
 * 字符串转大写
 * @param string            待转换字符串
 * @return                  转换好的字符串
 */
STRING HmcStrToUpper(const STRING &string);

/**
 * 字符串转小写
 * @param string            待转换字符串
 * @return                  转换好的字符串
 */
STRING HmcStrToLower(const STRING &string);

/**
 * 把UID对象转换为UID字符串
 * @param uid       待转换UID指针
 * @return          转换成功的情况下返回string，否则返回空串
 */
HMC_API STRING HmcUidToString(const HmcUid *uid);

/**
 * 把UID字符串转换为UID对象
 * @param string    待转换UID字符串
 * @return          UID对象<br>转换失败的情况下返回HMC_UID_NULL
 */
HMC_API HmcUid HmcUidFromString(const STRING &string);

/**
 * UTF-8字符串转为UTF-32字符串
 * @param string        待转换字符串
 * @return              转换后的字符串
 */
std::u32string HmcUTF8ToUTF32(const STRING &string);

/**
 * UTF-32字符串转为UTF-8字符串
 * @param string        待转换字符串
 * @return              转换后的字符串
 */
STRING HmcUTF32ToUTF8(const std::u32string &string);

/**
 * 字符串复制
 * @param string            待复制字符串
 * @return                  复制字符串
 */
HMC_C_API CHAR *HmcStrDup(const CHAR *string);


#endif // HMCSTRING_H
