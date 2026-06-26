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

IMPLEMENT_SINGLETON(HmcRandomGenerator)

HmcRandomGenerator::HmcRandomGenerator()
{
    m_provider = open("/dev/urandom", O_RDONLY, 0);
    m_strongProvider = open("/dev/random", O_RDONLY, 0);
    if (m_provider < 0 || m_strongProvider < 0) {
        LOGE("HmcRandomGenerator init failed!");
        exit(-1);
    }
    LOGI("HmcRandomGenerator init succeed, urandom fd: %d, random fd: %d", m_provider, m_strongProvider);
}

VOID HmcRandomGenerator::GetBytes(VOID *buffer, UINT32 size)
{
    if (buffer != nullptr && read(m_provider, buffer, size) < 0) {
        LOGE("Failed to read from /dev/urandom!");
    }
}

VOID HmcRandomGenerator::GetBytesStrong(VOID *buffer, UINT32 size)
{
    if (buffer != nullptr && read(m_strongProvider, buffer, size) < 0) {
        LOGE("Failed to read from /dev/random!");
    }
}
