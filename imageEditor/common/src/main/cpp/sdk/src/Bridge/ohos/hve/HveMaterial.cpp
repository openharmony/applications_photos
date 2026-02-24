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

#include "HveMaterial.h"
#include "../common/NapiCallback.h"
#include "HmcService.h"
#include "MediaCreative/HmcError.h"
#include "file/HmcDir.h"
#include "file/HmcFile.h"
#include "string/HmcString.h"
#include "HmcBase.h"
#include "system/ohos/HmcOhos.h"
#include <string>
#include <rawfile/raw_dir.h>
#include <rawfile/raw_file.h>
#include <rawfile/raw_file_manager.h>
#include "../BackgroundTaskManager.h"

static const VECTOR<STRING> FILTER_LUT_PATH = {
    "ImageResource/ImageMaterial/Library/1234/659992922300612608/images",
    "ImageResource/ImageMaterial/Library/1234/659992926939512832/images",
    "ImageResource/ImageMaterial/Library/1234/659992930705997824/images",
    "ImageResource/ImageMaterial/Library/1234/659992937031008256/images",
    "ImageResource/ImageMaterial/Library/1234/659992941225312256/images",
    "ImageResource/ImageMaterial/Library/1234/659992945386061824/images",
    "ImageResource/ImageMaterial/Library/1234/659992956668739584/images",
    "ImageResource/ImageMaterial/Library/1234/659992965954928640/images",
    "ImageResource/ImageMaterial/Library/1234/659992970560274432/images",
    "ImageResource/ImageMaterial/Library/1234/659992980005847040/images",
};

IMPLEMENT_SINGLETON(HveMaterial);

static STRING ToString(const char *str)
{
    STRING r = (str == nullptr) ? "" : str;
    return r;
}

static STRING ToString(const char *str, int len)
{
    STRING r = (str == nullptr || len == 0) ? "" : STRING{ str, (size_t)len };
    return r;
}

static STRING ToString(const unsigned char *str)
{
    return ToString((const char *)str);
}

std::shared_ptr<NativeResourceManager> HveMaterial::InitRsMgr()
{
    napi_value context = static_cast<napi_value>(HmcOhosGetModuleContext());
    if (context == nullptr) {
        LOGE("GetApplicationContext failed");
        return nullptr;
    }

    napi_value global, resMgr;
    napi_status status = napi_get_named_property(g_napiEnv, context, "resourceManager", &resMgr);
    if (status != napi_ok) {
        LOGE("napi_get_named_property resourceManager failed, status=%d", status);
        return nullptr;
    }
    auto mgr = OH_ResourceManager_InitNativeResourceManager(g_napiEnv, resMgr);
    if (mgr == nullptr) {
        LOGE("OH_ResourceManager_InitNativeResourceManager failed");
        return nullptr;
    }
    m_mgr = std::shared_ptr<NativeResourceManager>(mgr, [](NativeResourceManager* mgr) {
        if (mgr != nullptr) {
            OH_ResourceManager_ReleaseNativeResourceManager(mgr);
        }
    });
    
    return m_mgr;
}

std::shared_ptr<NativeResourceManager> HveMaterial::GetRsMgr()
{
    return m_mgr;
}

BOOL HveMaterial::IsRawDir(NativeResourceManager *mgr, const STRING &rawPath)
{
    auto rawFile = OH_ResourceManager_OpenRawFile(mgr, rawPath.c_str());
    if (rawFile != nullptr) {
        OH_ResourceManager_CloseRawFile(rawFile);
        return FALSE;
    }

    return TRUE;
}

BOOL HveMaterial::CopyLutDir(STRING hapFilesDir, std::shared_ptr<NativeResourceManager> mgr, BOOL overWrite)
{
    for (const auto &subName : FILTER_LUT_PATH) {
        STRING subSrcRawFilePath = subName + FILE_SEPARATOR_STR + "filter.jpg";
        STRING subTargetHapFileDir = hapFilesDir + "/" + subName;
        STRING subTargetHapFilePath = hapFilesDir + "/" + subSrcRawFilePath;
        if (!HmcIsDirExist(subTargetHapFileDir)) {
            HmcMakeDirTree(subTargetHapFileDir);
        }
        if (CopyRawFile(mgr, subSrcRawFilePath, subTargetHapFilePath, overWrite)) {
            LOGD("CopyRawFile (%s) to (%s) ", subSrcRawFilePath.c_str(), subTargetHapFilePath.c_str());
        }
    }
    return TRUE;
}

BOOL HveMaterial::CopyRawFile(std::shared_ptr<NativeResourceManager> mgr, const STRING &rawPath,
    const STRING &targetPath, BOOL overWrite)
{
    if (HmcFile::IsFileExist(targetPath) && !overWrite) {
        LOGI("CopyRawFile IsFileExist and no need overWrite");
        return TRUE;
    }

    auto srcFile = OH_ResourceManager_OpenRawFile(mgr.get(), rawPath.c_str());
    if (srcFile == nullptr) {
        LOGE("OH_ResourceManager_OpenRawFile(%s) failed", rawPath.c_str());
        return FALSE;
    }

    HmcFile dstFile;
    if (dstFile.Open(targetPath, HmcFile::HMC_FILE_CREATE) != HMC_OK) {
        LOGE("HmcFile open %s failed", targetPath.c_str());
        OH_ResourceManager_CloseRawFile(srcFile);
        return FALSE;
    }

    BOOL result = FALSE;
    int srcFileSize = OH_ResourceManager_GetRawFileSize(srcFile);
    int realReadBytes = 0;
    unsigned char *buffer = nullptr;

    do {
        std::unique_ptr<unsigned char[]> buffer = std::make_unique<unsigned char[]>(srcFileSize);
        if (buffer == nullptr) {
            LOGE("alloc mem for read rawfile(%s) failed, file size: %d", rawPath.c_str(), srcFileSize);
            break;
        }

        realReadBytes = OH_ResourceManager_ReadRawFile(srcFile, buffer.get(), srcFileSize);
        if (srcFileSize != realReadBytes) {
            LOGE("OH_ResourceManager_ReadRawFile(%s) failed, file size: %d, real read: %d", rawPath.c_str(),
                srcFileSize, realReadBytes);
            break;
        }

        if (dstFile.Write(buffer.get(), realReadBytes) != realReadBytes) {
            LOGE("HmcFile write %s failed, realBytes: %d", targetPath.c_str(), realReadBytes);
            break;
        }
        result = TRUE;
    } while (false);

    OH_ResourceManager_CloseRawFile(srcFile);
    dstFile.Close();

    return result;
}

STRING HveMaterial::GetResourcePath()
{
    return HmcOhosGetHapFilesDir() + "/ImageResource";
}

STRING HveMaterial::GetResourceVersionPath()
{
    return HmcOhosGetHapFilesDir() + "/ImageResource" + "/version";
}

INT32 HveMaterial::WriteResourceVersionToFile(const STRING &version)
{
    HmcFile versionFile;
    STRING resourceVersionFilePath = GetResourceVersionPath();
    INT32 result = versionFile.Open(resourceVersionFilePath, HmcFile::HMC_FILE_CREATE);
    if (result != HMC_OK) {
        LOGE("create version file failed with error: %d", result);
        return result;
    }

    INT32 ret = versionFile.Write(version.c_str(), version.length());
    if (ret == HMC_ERR || static_cast<unsigned>(ret) != version.length()) {
        LOGE("write version to file failed");
        result = HMC_ERR_FILE;
    }
    versionFile.Close();

    return result;
}

INT32 HveMaterial::ReadResourceVersionFromFile(STRING &version)
{
    HmcFile versionFile;
    STRING resourceVersionFilePath = GetResourceVersionPath();
    INT32 result = versionFile.Open(resourceVersionFilePath, HmcFile::HMC_FILE_READ);
    if (result != HMC_OK) {
        LOGE("open version file failed with error: %d", result);
        return result;
    }

    constexpr size_t versionMaxLen = 100; // 版本号最大不超过100个字符.
    UINT8 buffer[versionMaxLen + 1] = { 0 };

    INT32 len = versionFile.Read(buffer, versionMaxLen);
    if (len < 0) {
        LOGE("read version from file failed");
        versionFile.Close();
        return HMC_ERR_FILE;
    }

    version = STRING(reinterpret_cast<char *>(buffer));
    versionFile.Close();

    return HMC_OK;
}

BOOL HveMaterial::NeedUpdateResource(const STRING &version)
{
    STRING resourceVersionFilePath = GetResourceVersionPath();
    if (!HmcFile::IsFileExist(resourceVersionFilePath)) {
        LOGI("material version file is not exist");
        return TRUE;
    }

    STRING storageVersion;
    INT32 result = ReadResourceVersionFromFile(storageVersion);
    if (result != HMC_OK) { // 无法从文件读取版本号，可能文件损坏等，所以需要默认认为需要升级资源文件.
        LOGE("read material version from file failed with error: %d", result);
        return TRUE;
    }

    return version == storageVersion ? FALSE : TRUE;
}

VOID HveMaterial::InitEnv(std::string const & version)
{
    std::ostringstream ss;
    ss << g_mainThreadId;
    LOGI("InitEnv begin g_mainThreadId = , %s", ss.str().c_str());
    HmcBaseInit(); //  改造到单独的全局初始化模块中
    // 初始化素材路径
    HmcMaterialRenderResUtil::UtilInit();
    std::shared_ptr<NativeResourceManager> mgr = InitRsMgr();
    if (mgr == nullptr) {
        LOGE("InitRsMgr failed");
        return;
    }

    STRING dstPath = GetResourcePath();
    BOOL update = NeedUpdateResource(version);
    if (update) {
        HmcRemoveDirTree(dstPath);
    }

    STRING hapFilesDir = HmcOhosGetHapFilesDir();
    BACKGROUND_TASK_MGR->Submit([&, dstPath, mgr, update, hapFilesDir]() {
        LOGD("copy image editor raw file begin");
        CopyLutDir(hapFilesDir, mgr, update); // lut需要copy到沙箱解码
        LOGD("copy image editor raw file end");
    },
        __FUNCTION__);

    if (update) {
        (VOID)WriteResourceVersionToFile(version);
    }

    LOGD("InitEnv end");
}
