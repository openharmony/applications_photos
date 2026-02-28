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

#include <HmcBase.h>

#ifdef GNU_SOURCE
#undef GNU_SOURCE
#define GNU_SOURCE //  for vasprintf
#include <iconv.h>
#endif

#include <locale>
#include <codecvt>

const int MAX_BUFFER_SIZE = 2048;
const int DEFAULT_BUFFER_SIZE = 512;
const int BUFFER_SIZE_RATE = 2;
const int INVALID_FLAG = -1;

INT32 HmcStringFormatV(STRING &string, const CHAR *format, va_list arg)
{
    INT32 len = DEFAULT_BUFFER_SIZE;

    va_list copy;
    va_copy(copy, arg);

    while (len <= MAX_BUFFER_SIZE) {
        string.resize(len + 1, 0);
        int ret = vsprintf_s((char *)string.data(), len, format, arg);
        if (ret != INVALID_FLAG) {
            break;
        }
        len = BUFFER_SIZE_RATE * len;
    }
    return len;
}

INT32 HmcStringFormat(STRING &string, const CHAR *format, ...)
{
    va_list arg;
    va_start(arg, format);
    INT32 len = HmcStringFormatV(string, format, arg);
    va_end(arg);

    return len;
}

STRING HmcStringFormat(const CHAR *format, ...)
{
    va_list arg;
    va_start(arg, format);
    STRING string;
    HmcStringFormatV(string, format, arg);
    va_end(arg);
    return string;
}

INT32 HmcStringSerialize(const STRING &string, const STRING &filePath)
{
    HmcFile file;
    if (HMC_OK != file.Open(filePath, HmcFile::HMC_FILE_CREATE)) {
        return HMC_ERR;
    }

    INT32 length = (INT32)string.length();
    if (length != file.Write(string.c_str(), length)) {
        file.Close();
        return HMC_ERR;
    }

    file.Close();
    return HMC_OK;
}

INT32 HmcStringDeserialize(const STRING &filePath, STRING &string)
{
    // 打开文件
    HmcFile file;
    if (file.Open(filePath) != HMC_OK) {
        LOGW("Failed to open %s.", filePath.c_str());
        return HMC_ERR;
    }

    constexpr UINT32 buffSize = 10240;
    CHAR buff[buffSize];
    string.clear();
    INT32 readSize;
    while ((readSize = file.Read(buff, sizeof(buff))) > 0) {
        string.append(buff, readSize);
    }
    file.Close();
    return HMC_OK;
}

// 计算字符串的32位简单散列值
UINT32 HmcGetStringHashCode32(const STRING &string)
{
    const UINT32 HASH_INITIAL = 0x934187;
    UINT32 hash = HASH_INITIAL;
    UINT32 c;

    for (STRING::const_iterator iter = string.begin(); iter != string.end(); ++iter) {
        c = *iter;
        hash = ((hash << (c & 0x07)) + hash) ^ c;
    }

    return hash;
}

// 计算字符串的64位简单散列值
UINT64 HmcGetStringHashCode64(const STRING &string)
{
    const UINT64 HASH_INITIAL = 0x934187;
    UINT64 hash = HASH_INITIAL;
    UINT64 c;

    for (STRING::const_iterator iter = string.begin(); iter != string.end(); ++iter) {
        c = *iter;
        hash = ((hash << (c & 0x07)) + hash) ^ c;
    }

    return hash;
}

// 分割字符串，strtok风格
static STRING_VECTOR HmcSplitStringWithStrtokStyle(const STRING &string, const STRING &delims)
{
    CHAR *input = HmcStrDup(string.c_str());
    CHAR *slice = NULL;
    CHAR *context = NULL;
    STRING_VECTOR split;
    for (slice = strtok_r(input, delims.c_str(), &context); NULL != slice;
        slice = strtok_r(NULL, delims.c_str(), &context)) {
        split.emplace_back(slice);
    }

    free(input);
    return split;
}

// 分割字符串，Python风格
static STRING_VECTOR HmcSplitStringWithPythonStyle(const STRING &string, const STRING &delims)
{
    STRING::size_type pos = 0;
    STRING::size_type len = string.length();

    STRING_VECTOR split;
    BOOL endWithDelim = TRUE;

    while (pos < len) {
        STRING::size_type j = string.find(delims, pos);
        if (j == STRING::npos) {
            split.push_back(string.substr(pos, len - pos));
            endWithDelim = FALSE;
            break;
        }

        split.push_back(string.substr(pos, j - pos));
        pos = j + 1;
    }

    if (endWithDelim) {
        split.emplace_back("");
    }

    return split;
}

// 分割字符串
STRING_VECTOR HmcSplitString(const STRING &string, const STRING &delims, BOOL emptyAllowed)
{
    if (emptyAllowed) {
        return HmcSplitStringWithPythonStyle(string, delims);
    }

    return HmcSplitStringWithStrtokStyle(string, delims);
}

UINT64 HmcStringToUint64(const STRING &string)
{
    CHAR *end;
    return strtoull(string.c_str(), &end, 0);
}

BOOL HmcStringIsStartWith(const STRING &string, const STRING &prefix)
{
    return string.size() >= prefix.size() && 0 == string.compare(0, prefix.size(), prefix);
}

BOOL HmcStringIsEndWith(const STRING &string, const STRING &suffix)
{
    return string.size() >= suffix.size() && 0 == string.compare(string.size() - suffix.size(), suffix.size(), suffix);
}

STRING HmcStrToUpper(const STRING &string)
{
    STRING upper;
    for (auto c : string) {
        upper.push_back((CHAR)toupper(c));
    }
    return upper;
}

STRING HmcStrToLower(const STRING &string)
{
    STRING lower;
    for (auto c : string) {
        lower.push_back((CHAR)tolower(c));
    }
    return lower;
}

// 转换UTF8字符串到宽字符串（UTF16LE）
WSTRING HmcStringToWideString(const STRING &string)
{
    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> convert;
    return convert.from_bytes(string);
}

// 转换宽字符串到UTF8字符串
STRING HmcWideStringToString(const WSTRING &string)
{
    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> convert;
    return convert.to_bytes(string);
}

// 字符串复制
CHAR *HmcStrDup(const CHAR *string)
{
    return strdup(string);
}

STRING HmcUidToString(const HmcUid *uid)
{
    char uidStr[HMC_UID_STR_LEN] = {0};
    if (!uid || !HmcUidToString(uid, uidStr, HMC_UID_STR_LEN)) {
        return "";
    }

    return STRING(uidStr);
}

HmcUid HmcUidFromString(const STRING &string)
{
    HmcUid uid = HMC_UID_NULL;
    HmcUidFromString(string.c_str(), &uid);
    return uid;
}

std::u32string HmcUTF8ToUTF32(const STRING &string)
{
    using convert_typeX = std::codecvt_utf8<char32_t>;
    std::wstring_convert<convert_typeX, char32_t> converterX;
    return converterX.from_bytes(string);
}

STRING HmcUTF32ToUTF8(const std::u32string &string)
{
    using convert_typeX = std::codecvt_utf8<char32_t>;
    std::wstring_convert<convert_typeX, char32_t> converterX;
    return converterX.to_bytes(string);
}
