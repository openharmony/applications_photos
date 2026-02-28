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


HmcSimpleString::HmcSimpleString() : m_str(NULL)
{
    Assign("");
}

HmcSimpleString::HmcSimpleString(const STRING &s) : m_str(NULL)
{
    Assign(s.c_str());
}

HmcSimpleString::HmcSimpleString(const CHAR *s) : m_str(NULL)
{
    Assign(s);
}

HmcSimpleString::HmcSimpleString(const CHAR *s, UINT32 n) : m_str(NULL)
{
    Assign(s, n);
}

HmcSimpleString::HmcSimpleString(HmcSimpleString &&s) noexcept
{
    m_str = s.m_str;
    s.m_str = NULL;
}

HmcSimpleString::HmcSimpleString(const HmcSimpleString &s)
{
    m_str = HmcStrDup(s.m_str);
}

HmcSimpleString::~HmcSimpleString()
{
    Release();
}

const CHAR *HmcSimpleString::GetString() const
{
    return m_str;
}

BOOL HmcSimpleString::IsEmpty() const
{
    return GetLength() == 0;
}

UINT32 HmcSimpleString::GetLength() const
{
    if (!m_str) {
        return 0;
    }

    return strlen(m_str);
}

CHAR &HmcSimpleString::operator[](UINT32 n)
{
    return m_str[n];
}

HmcSimpleString &HmcSimpleString::operator = (const STRING &s)
{
    return Assign(s.c_str());
}

HmcSimpleString &HmcSimpleString::operator = (const CHAR *s)
{
    return Assign(s);
}

HmcSimpleString &HmcSimpleString::operator = (const HmcSimpleString &s)
{
    return Assign(s.m_str);
}

HmcSimpleString &HmcSimpleString::operator = (HmcSimpleString &&s) noexcept
{
    Release();

    m_str = s.m_str;
    s.m_str = NULL;
    return *this;
}

HmcSimpleString &HmcSimpleString::operator += (const HmcSimpleString &s)
{
    return Append(s.m_str);
}

HmcSimpleString &HmcSimpleString::operator += (const STRING &s)
{
    return Append(s.c_str(), s.length());
}

HmcSimpleString &HmcSimpleString::operator += (const CHAR *s)
{
    return Append(s);
}

HmcSimpleString &HmcSimpleString::operator += (CHAR c)
{
    return Append(&c, 1);
}

HmcSimpleString &HmcSimpleString::Assign(const CHAR *s)
{
    Release();
    m_str = nullptr;

    if (s) {
        m_str = HmcStrDup(s);
    }

    return *this;
}

HmcSimpleString &HmcSimpleString::Assign(const CHAR *s, UINT32 n)
{
    Release();

    if (s) {
        m_str = (CHAR *)HmcMalloc(n + 1);
        if (m_str) {
            if (memcpy_s(m_str, n, s, n)) {
            };
            m_str[n] = '\0';
        }
    }

    return *this;
}

HmcSimpleString &HmcSimpleString::Append(const CHAR *s)
{
    return Append(s, strlen(s));
}

HmcSimpleString &HmcSimpleString::Append(const CHAR *s, UINT32 n)
{
    auto m = strlen(m_str);
    auto str = (CHAR *)HmcMalloc(m + n + 1);
    if (str) {
        if (memcpy_s(str, m, m_str, m)) {
        };
        if (memcpy_s(str + m, n, s, n)) {
        };
        str[m + n] = '\0';
        Release();
        m_str = str;
    }
    return *this;
}

VOID HmcSimpleString::Release()
{
    if (m_str) {
        for (auto s = m_str; *s; s++) {
            *s = '\0';
        }
        HmcFree(m_str);
        m_str = NULL;
    }
}
