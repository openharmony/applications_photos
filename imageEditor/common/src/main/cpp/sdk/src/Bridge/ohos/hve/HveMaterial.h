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

#ifndef OH_MATERIAL_H
#define OH_MATERIAL_H
#include <string>
#include <functional>
#include <rawfile/raw_file_manager.h>
#include "HmcService.h"

using HveMaterialCallBack = std::function<void(int result, const std::string &msg)>;

class HveMaterial {
    DECLARE_SINGLETON(HveMaterial);

public:
    VOID InitEnv(std::string const & version);
    VOID ReleaseRsMrg();
    std::shared_ptr<NativeResourceManager> GetRsMgr();

private:
    std::shared_ptr<NativeResourceManager> InitRsMgr();
    std::shared_ptr<NativeResourceManager> m_mgr { nullptr };
    BOOL IsRawDir(NativeResourceManager *mgr, const STRING &rawPath);
    BOOL CopyLutDir(STRING hapFilesDir, std::shared_ptr<NativeResourceManager> mgr, BOOL overWrite = false);
    BOOL CopyRawFile(std::shared_ptr<NativeResourceManager> mgr, const STRING &rawPath, const STRING &targetPath,
        BOOL overWrite = false);
    BOOL NeedUpdateResource(const STRING &version);
    STRING GetResourcePath();
    STRING GetResourceVersionPath();
    INT32 WriteResourceVersionToFile(const STRING &version);
    INT32 ReadResourceVersionFromFile(STRING &version);
};

#endif // OH_MATERIAL_H
