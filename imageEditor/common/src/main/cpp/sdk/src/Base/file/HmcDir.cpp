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
#include "ohos/jscaller/DataAbilityHelper.h"
#include "system/ohos/HmcOhos.h"

BOOL HmcIsDirExist(const STRING &dir)
{
    struct stat stBuf;
    if ((0 != stat(dir.c_str(), &stBuf)) || !S_ISDIR(stBuf.st_mode)) {
        return FALSE;
    }

    return TRUE;
}


INT32 HmcMakeDir(const STRING &dir)
{
    mode_t oldUmask = umask(0);
    mkdir(dir.c_str(), S_IRWXU | S_IRWXG | S_IXOTH);
    umask(oldUmask);
    if (!HmcIsDirExist(dir)) {
        return HMC_ERR;
    }

    return HMC_OK;
}


INT32 HmcMakeDirTree(const STRING &dir)
{
    // 跳过路径中可能存在的根目录
    STRING::size_type nSplitterPos = dir.find_first_of("/\\") + 1;

    // 处理最内层目录之前的多级目录
    while (STRING::npos != (nSplitterPos = dir.find_first_of("/\\", nSplitterPos))) {
        // 截取当前级别的目录路径
        STRING tmpPath = dir.substr(0, nSplitterPos);
        ++nSplitterPos;
        HmcMakeDir(tmpPath);
    }

    // 创建最内层目录
    HmcMakeDir(dir);

    // 检查目标目录是否存在
    if (!HmcIsDirExist(dir)) {
        return HMC_ERR;
    }

    return HMC_OK;
}


INT32 HmcRemoveDir(const STRING &dir)
{
    if (rmdir(dir.c_str())) {
        return -abs(errno);
    }

    return HMC_OK;
}

INT32 HmcRemoveDirTree(const STRING &dir_path)
{
    DIR *dir_info = NULL;
    DIR *dir_temp = NULL;
    dir_info = opendir(dir_path.c_str());
    char dir_name[PATH_MAX];
    char absolutePath[PATH_MAX];
    if (strcpy_s(dir_name, sizeof(dir_name), dir_path.c_str()) != EOK) {
    }
    if (strcat_s(dir_name, sizeof(dir_name), "/%s") != EOK) {
    }

    if (!dir_info) {
        LOGW("Failed to open directory %s, errno %d.", dir_path.c_str(), errno);
        return HMC_ERR;
    }
    struct dirent *dirEntry;
    while ((dirEntry = readdir(dir_info))) {
        if (strcmp(dirEntry->d_name, ".") != 0 && strcmp(dirEntry->d_name, "..") != 0) {
            // 需要获取文件的完整路径
            if (sprintf_s(absolutePath, sizeof(absolutePath), dir_name, dirEntry->d_name) < 0) {
            }
            dir_temp = opendir(absolutePath);
            // 遍历文件夹，需要先删除子目录的全部文件，再删除父目录
            if (dir_temp != NULL) {
                closedir(dir_temp);
                dir_temp = NULL;
                HmcRemoveDirTree(absolutePath);
            } else if (remove(absolutePath)) {
                LOGW("Failed to delete file %s, errno %d.", absolutePath, errno);
                closedir(dir_info);
                return HMC_ERR;
            }
        }
    }
    rmdir(dir_path.c_str());
    closedir(dir_info);
    dirEntry = NULL;
    return HMC_OK;
}

INT32 HmcGetDirContents(const STRING &dir, STRING_LIST &entries)
{
    // Clear container first
    entries.clear();
    DIR *dir_info = opendir(dir.c_str());

    if (!dir_info) {
        return HMC_ERR;
    }

    // 打开目录成功
    struct dirent *entry;
    while ((entry = readdir(dir_info))) {
        // 忽略这两个特殊项目
        if (strcmp(entry->d_name, "..") && strcmp(entry->d_name, ".")) {
            entries.push_back(entry->d_name);
        }
    }

    // 使用完毕，关闭目录指针。
    closedir(dir_info);

    return HMC_OK;
}

INT64 HmcGetDirLastModifiedTimestamp(const STRING &dir)
{
    struct stat st = {};
    if (stat(dir.c_str(), &st)) {
        return -1;
    }
    return st.st_mtime;
}

INT32 HmcGetCanonicalizedPath(const STRING &filePath, STRING &canonicalized)
{
    if (filePath.empty()) {
        canonicalized = "";
        return HMC_OK;
    }

    if (IsDataAbilityUri(filePath.c_str())) {
        canonicalized = filePath;
        LOGD("HmcGetCanonicalizedPath with data ability uri, canonicalized=%s", canonicalized.c_str());
        return HMC_OK;
    }
    if (IsRawFilePath(filePath.c_str())) {
        canonicalized = filePath.substr(strlen("rawfile/"));
        LOGD("HmcGetCanonicalizedPath with rawfile, canonicalized=%s", canonicalized.c_str());
        return HMC_OK;
    }
    CHAR path[PATH_MAX] = { 0 };
    if (realpath(filePath.c_str(), path)) {
        canonicalized = path;
        return HMC_OK;
    }

    // 2021-03-09
    // 文件不存在，但路径应该是存在的，尝试分离出路径，之后再合并
    auto pos = filePath.find_last_of("/\\");
    if (pos == STRING::npos) {
        canonicalized = "";
        return HMC_OK;
    }

    STRING dirName(filePath, 0, pos);
    STRING baseName(filePath, pos);
    if (realpath(dirName.c_str(), path)) {
        canonicalized = path + baseName;
        return HMC_OK;
    }

    return HMC_ERR;
}

INT32 HmcGetCanonicalizedPath(INT32 fd, STRING &canonicalized)
{
    canonicalized.reserve(PATH_MAX);
    auto procFilePath = HmcStringFormat("/proc/%d/fd/%d", HmcGetProcessId(), fd);
    auto length = readlink(procFilePath.c_str(), (CHAR *)canonicalized.data(), canonicalized.capacity());
    if (length < 0) {
        return HMC_ERR;
    }
    // readlink并不添加结尾的'\0'结束符，实际字符串长度用length确定
    canonicalized.resize(length);
    return HMC_OK;
}

STRING HmcGetPathWithSystemSeparator(STRING filePath)
{
    replace(filePath.begin(), filePath.end(), '/', FILE_SEPARATOR_CHAR);
    replace(filePath.begin(), filePath.end(), '\\', FILE_SEPARATOR_CHAR);

    return filePath;
}

STRING HmcGetAppPath() { return HmcOhosGetHapFilesDir(); }
