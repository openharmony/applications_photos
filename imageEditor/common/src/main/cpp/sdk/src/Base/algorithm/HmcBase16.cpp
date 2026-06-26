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

// 获取BASE16编码字符串
STRING HmcBase16Encode(const VOID *input, INT32 length, BOOL upperCase)
{
    UINT8 *bytes = (UINT8 *)input;
    const static CHAR upperCaseTable[] = "0123456789ABCDEF";
    const static CHAR lowerCaseTable[] = "0123456789abcdef";
    auto table = upperCase ? upperCaseTable : lowerCaseTable;
    INT32 i;
    STRING base16;
    base16.reserve(length * 2);

    for (i = 0; i < length; i++) {
        base16.append(1, table[(UCHAR)((bytes[i] >> 4) & 0x0F)]);
        base16.append(1, table[(UCHAR)(bytes[i] & 0x0F)]);
    }
    return base16;
}

// 获取BASE16解码数据
UINT8 *HmcBase16Decode(const STRING &base16, INT32 &length)
{
    const static INT32 table[128] = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                                     -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                                     -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                                     0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -1, -1, -1, -1, -1, -1, -1, 10,
                                     11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                                     -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 10,
                                     11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                                     -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};

    auto str_len = (UINT32)base16.length();
    if (str_len & 0x01) {
        // 长度应当是偶数
        length = 0;
        return NULL;
    }

    auto out = (UINT8 *)malloc(str_len / 2 + 1);
    if (!out) {
        length = 0;
        return NULL;
    }

    UINT32 i, j;
    INT32 oct1, oct2;

    for (i = j = 0; i < str_len; i += 2) {
        if (((UCHAR)base16[i] & 0x80) || ((UCHAR)base16[i + 1] & 0x80)) {
            // 碰到填充字符或者非法字符，解码结束
            break;
        }

        oct1 = table[(UCHAR)base16[i]];
        oct2 = table[(UCHAR)base16[i + 1]];

        if ((-1 == oct1) || (-1 == oct2)) {
            // 碰到填充字符或者非法字符，解码结束
            break;
        }

        out[j++] = (UINT8)(((UINT32)oct1 << 4) | (UINT32)oct2);
    }

    length = (INT32)j;
    return out;
}
