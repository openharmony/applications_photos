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

#ifndef HMCSIMPLESTRING_H
#define HMCSIMPLESTRING_H

#ifdef __cplusplus

class HmcSimpleString {
public:
    HmcSimpleString();

    explicit HmcSimpleString(const STRING &s);

    explicit HmcSimpleString(const CHAR *s);

    HmcSimpleString(const CHAR *s, UINT32 n);

    HmcSimpleString(HmcSimpleString &&s) noexcept;

    HmcSimpleString(const HmcSimpleString &s);

    ~HmcSimpleString();

    const CHAR *GetString() const;

    BOOL IsEmpty() const;

    UINT32 GetLength() const;

    CHAR &operator[](UINT32 n);

    HmcSimpleString &Assign(const CHAR *s);

    HmcSimpleString &Assign(const CHAR *s, UINT32 n);

    HmcSimpleString &Append(const CHAR *s);

    HmcSimpleString &Append(const CHAR *s, UINT32 n);

    HmcSimpleString &operator = (const STRING &s);

    HmcSimpleString &operator = (const CHAR *s);

    HmcSimpleString &operator = (const HmcSimpleString &s);

    HmcSimpleString &operator = (HmcSimpleString &&s) noexcept;

    HmcSimpleString &operator += (const HmcSimpleString &s);

    HmcSimpleString &operator += (const STRING &s);

    HmcSimpleString &operator += (const CHAR *s);

    HmcSimpleString &operator += (char c);

private:
    VOID Release();

private:
    CHAR *m_str;
};


#endif // __cplusplus

#endif // HMCSIMPLESTRING_H
