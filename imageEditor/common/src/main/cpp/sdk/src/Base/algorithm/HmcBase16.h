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

#ifndef HMCBASE16_H
#define HMCBASE16_H

#ifdef __cplusplus

/**
 * 获取BASE16编码字符串
 * @param input         待编码数据
 * @param length        待编码数据长度
 * @param upperCase     是否大写
 * @return              BASE16编码字符串
 */
STRING HmcBase16Encode(const VOID *input, INT32 length, BOOL upperCase = TRUE);

/**
 * 获取BASE16解码数据
 * @param base16    待解码BASE16字符串
 * @param length    解码数据长度
 * @return          解码数据指针，NULL表示解码失败
 * @note            1.对于非法字符，算法会做截断<br>
 * 2.对于'\\r'、'\\n'、'\\t'、' '，算法会跳过<br>
 * 3.返回的解码数据指针需要应用层通过free()接口释放内存
 */
UINT8 *HmcBase16Decode(const STRING &base16, INT32 &length);

#endif // __cplusplus

#endif // HMCBASE16_H
