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

// UID临时字符串长度，包含结尾的'\0'，不包含连接符‘-’
#define HMC_UID_LEN_NO_CONNECT (32 + 1)

// UID字符串长度，包含结尾的'\0'
#define HMC_UID_STR_LEN    (36 + 1)

const HmcUid HMC_UID_NULL = { 0 };


static UINT8 HmcGetHexVal(const CHAR ch)
{
    if (ch >= '0' && ch <= '9') {
        return ch - '0';
    }

    if (ch >= 'a' && ch <= 'f') {
        return ch - 'a' + 0xa;
    }

    if (ch >= 'A' && ch <= 'F') {
        return ch - 'A' + 0xA;
    }

    return 0;
}

int HmcUidIsEqual(const HmcUid *uid1, const HmcUid *uid2)
{
    return !memcmp(uid1->id, uid2->id, HMC_UID_LEN);
}

void HmcUidCopy(HmcUid *dest, const HmcUid *src)
{
    memcpy(dest->id, src->id, sizeof(dest->id));
}

int HmcUidIsNull(const HmcUid *uid)
{
    return HmcUidIsEqual(uid, &HMC_UID_NULL);
}

void HmcUidGenerate(HmcUid *uid)
{
    if (!uid) {
        LOGE("Generate uid failed, uid is null!");
        return;
    }
    auto size = sizeof(uid->id);
    if (size != HMC_UID_LEN) {
        LOGE("Generate uid failed, size[%zu] is invalid!", size);
        return;
    }

    static std::atomic_ullong currentId = 1;
    auto generateId = currentId.fetch_add(1, std::memory_order_relaxed);
    if (generateId >= UINT64_MAX) {
        currentId = 1;
    }

    char bufferChar[HMC_UID_LEN_NO_CONNECT] = {0};
    auto result = snprintf(bufferChar, HMC_UID_LEN_NO_CONNECT, "%016llx", generateId);
    if (result <= 0) {
        LOGE("Generate uid failed, sprintf_s result is %d!", result);
        return;
    }

    int j = 0;
    int high_num = 4;
    for (int i = 0; i < size; i++) {
        unsigned char high = HmcGetHexVal(bufferChar[j++]);
        unsigned char low = HmcGetHexVal(bufferChar[j++]);
        uid->id[i] = (high << high_num) | low;
    }
}

char *HmcUidToString(const HmcUid *uid, char *string, int size)
{
    if (!uid || !string || size < HMC_UID_STR_LEN) {
        return NULL;
    }

    UINT32 j = 0;
    for (INT32 i = 0; i < HMC_UID_LEN; i++) {
        if ((i == 4) || (i == 6) || (i == 8) || (i == 10)) {
            string[j++] = '-';
        }

        j += (UINT32)snprintf(string + j, size - j, "%02x", uid->id[i]);
    }
    return string;
}

int HmcUidFromString(const char *string, HmcUid *uid)
{
    if (!string || !uid) {
        return HMC_ERR_PARAM;
    }

    UINT32 j = 0;
    for (INT32 i = 0; i < HMC_UID_LEN; i++) {
        if ((i == 4) || (i == 6) || (i == 8) || (i == 10)) {
            if (string[j] != '-') {
                return HMC_ERR_PARAM;
            }

            // 跳过'-'
            j++;
        }

        UINT8 high = HmcGetHexVal(string[j++]);
        UINT8 low = HmcGetHexVal(string[j++]);
        uid->id[i] = (high << 4) | low;
    }

    return HMC_OK;
}
