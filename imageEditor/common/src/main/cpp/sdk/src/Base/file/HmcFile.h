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

#ifndef HMCFILE_H
#define HMCFILE_H

#include <rawfile/raw_dir.h>
#include <rawfile/raw_file.h>
#include <rawfile/raw_file_manager.h>

class HmcFile {
public:
    typedef enum {
        HMC_FILE_READ,  // 只读
        HMC_FILE_WRITE, // 只写，如果文件不存在则打开失败
        HMC_FILE_CREATE // 创建文件，如果文件已经存在则覆盖，长度截断为0
    } Mode;

public:
    HmcFile();

    virtual ~HmcFile();

public:
    INT32 Open(const STRING &filePath, Mode mode = HMC_FILE_READ);
    
    INT32 RawFileOpen(const STRING& filePath);

    INT32 Read(VOID *buffer, UINT32 size);

    INT32 Write(const VOID *buffer, UINT32 size);

    INT32 Sync();

    INT32 Seek(INT64 offset);

    INT32 Tell(INT64 &offset);

    INT32 Truncate(INT64 size);

    INT64 GetSize();

    VOID ClearFdMaps();

    VOID ClearFd();

    VOID Close();

    INT32 FileNo();

public:
    static BOOL IsFileExist(const STRING &filePath);

    static INT32 Remove(const STRING &filePath);

    static INT64 GetSize(const STRING &filePath);

private:
    INT32 m_fd;
    STRING m_filePath;
    RawFileDescriptor m_descriptor;
    std::shared_ptr<RawFile> m_rawFile{ nullptr };
};

#endif // HMCFILE_H
