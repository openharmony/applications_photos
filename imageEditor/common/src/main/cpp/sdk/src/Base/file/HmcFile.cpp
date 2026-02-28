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
#include "ohos/jscaller/DataAbilityHelper.h"
#include "ohos/hve/HveMaterial.h"

#define OS_OPEN open
#define OS_READ read
#define OS_WRITE write
#define OS_CLOSE close

HmcFile::HmcFile() : m_fd(HMC_INVALID_FD) {}

HmcFile::~HmcFile()
{
    Close();
}

INT32 HmcFile::Open(const STRING &filePath, Mode mode)
{
    // 转换打开参数
    INT32 flag;
    const char *openFileMode;
    switch (mode) {
        case HMC_FILE_READ:
            flag = O_RDONLY;
            openFileMode = "r";
            break;
        case HMC_FILE_WRITE:
            flag = O_WRONLY;
            openFileMode = "w";
            break;
        case HMC_FILE_CREATE:
            flag = O_WRONLY | O_CREAT | O_TRUNC;
            openFileMode = "w";
            break;
        default:
            return HMC_ERR;
    }

    mode_t old_umask = umask(0);

    STRING canonicalized;
    if (HMC_OK != HmcGetCanonicalizedPath(filePath, canonicalized)) {
        LOGW("Failed to get canonical file path for %s (%s).", filePath.c_str(), strerror(errno));
        return HMC_ERR;
    }
    LOGI("HmcFile open path = %s", canonicalized.c_str());
    if (IsDataAbilityUri(canonicalized.c_str())) {
        LOGI("HmcFile open IsDataAbilityUri");
        m_fd = DataAbilityHelperOpen(canonicalized.c_str(), openFileMode);
    } else if (IsRawFilePath(filePath.c_str())) {
        LOGI("HmcFile open IsRawFilePath");
        m_fd = RawFileOpen(canonicalized.c_str());
    } else {
        LOGI("HmcFile normal open");
        m_fd = open(canonicalized.c_str(), flag, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    }
    LOGI("HmcFile open file id = %d", m_fd);
    umask(old_umask);

    if (HMC_INVALID_FD == m_fd) {
        LOGW("Failed to open file %s, error %d (%s).", filePath.c_str(), errno, strerror(errno));
        return HMC_ERR;
    }

    m_filePath = filePath;
    return HMC_OK;
}

INT32 HmcFile::RawFileOpen(const STRING& filePath)
{
    std::shared_ptr<NativeResourceManager> rsMgr = SINGLETON(HveMaterial)->GetRsMgr();
    if (rsMgr == nullptr) {
        LOGE("GetRsMgr failed");
        return HMC_INVALID_FD;
    }
    auto rawFile =  OH_ResourceManager_OpenRawFile(rsMgr.get(), filePath.c_str());
    if (rawFile == nullptr) {
        LOGE("OH_ResourceManager_OpenRawFile failed");
        return HMC_INVALID_FD;
    }
    m_rawFile = std::shared_ptr<RawFile>(rawFile, [](RawFile *file) {
        if (file != nullptr) {
            OH_ResourceManager_CloseRawFile(file);
        }
    });
    if (!OH_ResourceManager_GetRawFileDescriptor(m_rawFile.get(), m_descriptor)) {
        LOGE("OH_ResourceManager_GetRawFileDescriptor failed");
        return HMC_INVALID_FD;
    }
    return m_descriptor.fd;
}

INT32 HmcFile::Read(VOID *buffer, UINT32 size)
{
    if (IsRawFilePath(m_filePath.c_str())) {
        return OH_ResourceManager_ReadRawFile(m_rawFile.get(), buffer, size);
    }
    // 检查文件对象已经打开
    if (HMC_INVALID_FD == m_fd) {
        return HMC_ERR;
    }

    INT32 len = (INT32)OS_READ(m_fd, buffer, size);
    return len;
}

INT32 HmcFile::Write(const VOID *buffer, UINT32 size)
{
    // 检查文件对象已经打开
    if (HMC_INVALID_FD == m_fd) {
        return HMC_ERR;
    }

    INT32 writeSize = 0;
    while (writeSize < (INT32)size) {
        auto len = (INT32)OS_WRITE(m_fd, buffer, size);
        if (len < 0) {
            return HMC_ERR;
        }
        writeSize += len;
    }
    return writeSize;
}


INT32 HmcFile::Sync()
{
    // 检查文件对象已经打开
    if (HMC_INVALID_FD == m_fd) {
        return HMC_ERR;
    }

    return fsync(m_fd);
}

INT32 HmcFile::Seek(INT64 offset)
{
    if (IsRawFilePath(m_filePath.c_str())) {
        return OH_ResourceManager_SeekRawFile(m_rawFile.get(), offset, SEEK_SET);
    }
    // 检查文件对象已经打开
    if (HMC_INVALID_FD == m_fd) {
        return HMC_ERR;
    }

    INT32 from = SEEK_SET;

    if (offset < 0) {
        offset = 0;
        from = SEEK_END;
    }

    // 执行定位操作
    if (lseek(m_fd, (off_t)offset, from) < 0) {
        return HMC_ERR;
    }

    return HMC_OK;
}

INT32 HmcFile::Tell(INT64 &offset)
{
    // 检查文件对象已经打开
    if (HMC_INVALID_FD == m_fd) {
        return HMC_ERR;
    }

    // 执行定位查询操作
    INT64 ret = lseek(m_fd, 0, SEEK_CUR);
    if (ret < 0) {
        return HMC_ERR;
    }

    offset = ret;
    return HMC_OK;
}

INT32 HmcFile::Truncate(INT64 size)
{
    // 检查文件对象已经打开
    if (HMC_INVALID_FD == m_fd) {
        return HMC_ERR;
    }

    // 执行截断操作
    if (ftruncate(m_fd, (off_t)size) < 0) {
        return HMC_ERR;
    }

    return HMC_OK;
}

INT64 HmcFile::GetSize()
{
    if (IsRawFilePath(m_filePath.c_str())) {
        return OH_ResourceManager_GetRawFileSize(m_rawFile.get());
    }
    // 检查文件对象已经打开
    if (HMC_INVALID_FD == m_fd) {
        LOGE("invalid fd.");
        return -1;
    }

    struct stat st;
    int err = fstat(m_fd, &st);
    if (err) {
        LOGE("Failed to stat file, error %d (%s).", errno, strerror(errno));
        return -1;
    }
    return (INT64)st.st_size;
}

// 获取指定文件的大小，静态方法
INT64 HmcFile::GetSize(const STRING &strFilePath)
{
    struct stat st;
    int result;
    if (IsDataAbilityUri(strFilePath.c_str())) {
        int64_t fd = DataAbilityHelperOpen(strFilePath.c_str(), "r");
        result = fstat(fd, &st);
    } else {
        result = stat(strFilePath.c_str(), &st);
    }

    if (result != 0) {
        return -1;
    }

    return (INT64)st.st_size;
}

VOID HmcFile::ClearFdMaps()
{
    STRING canonicalized;
    if (HMC_OK != HmcGetCanonicalizedPath(m_filePath, canonicalized)) {
        LOGE("Failed to get canonical file path for %s (%s).", m_filePath.c_str(), strerror(errno));
        return;
    }
    if (IsDataAbilityUri(canonicalized.c_str())) {
        ClearOpenedFds(canonicalized.c_str());
    }
}

VOID HmcFile::ClearFd()
{
    if (HMC_INVALID_FD != m_fd) {
        ClearFdMaps();
        m_fd = HMC_INVALID_FD;
        m_filePath.clear();
    }
    LOGI("HmcFile ClearFd, m_fd = %d", m_fd);
}

VOID HmcFile::Close()
{
    if (HMC_INVALID_FD != m_fd && m_filePath.find("fd://") != 0) { // 外部传入的fd构造的HmcFile，在关闭时不应该close(fd)
        ClearFdMaps();
        LOGI("HmcFile Close, m_fd = %d", m_fd);
        OS_CLOSE(m_fd);
        m_fd = HMC_INVALID_FD;
        m_filePath.clear();
    }
    LOGI("HmcFile Close end");
}

INT32 HmcFile::FileNo()
{
    return m_fd;
}

BOOL HmcFile::IsFileExist(const STRING &filePath)
{
    struct stat st;
    int result;
    if (IsDataAbilityUri(filePath.c_str())) {
        int64_t fd = DataAbilityHelperOpen(filePath.c_str(), "r");
        result = fstat(fd, &st);
    } else {
        result = stat(filePath.c_str(), &st);
    }
    if (result != 0) {
        return FALSE;
    }
    return TRUE;
}

INT32 HmcFile::Remove(const STRING &filePath)
{
    if (remove(filePath.c_str())) {
        return HMC_ERR;
    }

    return HMC_OK;
}

