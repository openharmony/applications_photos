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
#include <dirent.h>
#include "HmcMaterialUtil.h"
#include "Entity/HmcMaterialEntity.h"
#include "Entity/HmcMaterialColumn.h"
#include "Entity/HmcMaterialContent.h"
#include <HmcService.h>

const char *g_encryptPrefix = "_decrypt";

STRING HmcMaterialUtil::GetMaterialRootDir()
{
    return HmcMaterialRenderResUtil::GetResourceRootPath() + FILE_SEPARATOR_STR + "ImageMaterial";
}

STRING HmcMaterialUtil::GetBuiltinMaterialRootDir()
{
    return HmcMaterialRenderResUtil::GetResourceRootPath() + FILE_SEPARATOR_STR + "ImageMaterial";
}

VOID HmcMaterialUtil::ConfigEnvironment()
{
    HmcMakeDirTree(GetMaterialRootDir());
    HmcMakeDirTree(GetMaterialLibraryDir());
    HmcMakeDirTree(GetMaterialLibrarySettingDir());
    HmcMakeDirTree(GetMaterialLibraryPicDir());
    HmcMakeDirTree(GetMaterialLibraryPreviewDir());
    HmcMakeDirTree(GetColumnSettingDir());
    HmcMakeDirTree(GetContentSettingDir());
    HmcMakeDirTree(GetUidSettingDir());
}

VOID HmcMaterialUtil::FreeMaterial(HmcMaterialLibraryType materialType, VOID **material)
{
    if (material == NULL || *material == NULL) {
        return;
    }
    if (materialType == MATERIAL_CONTENT_TYPE_COLUMN) {
        HmcMaterialColumn *column = (HmcMaterialColumn *)*material;
        delete column;
    } else {
        HmcMaterialContent *content = (HmcMaterialContent *)*material;
        delete content;
    }
    *material = NULL;
}

VOID HmcMaterialUtil::FreeLibraryPic(HmcMaterialPic &materialPic)
{
    if (materialPic.type) {
        delete[] materialPic.type;
        materialPic.type = nullptr;
    }
    if (materialPic.url) {
        delete[] materialPic.url;
        materialPic.url = NULL;
    }
    if (materialPic.path) {
        delete[] materialPic.path;
        materialPic.path = NULL;
    }
    if (materialPic.selectedUrl) {
        delete[] materialPic.selectedUrl;
        materialPic.selectedUrl = NULL;
    }
    if (materialPic.selectedPath) {
        delete[] materialPic.selectedPath;
        materialPic.selectedPath = NULL;
    }
    if (materialPic.aspectRatio) {
        delete[] materialPic.aspectRatio;
        materialPic.aspectRatio = NULL;
    }
    if (materialPic.image) {
        HmcImageDestroy(materialPic.image);
        materialPic.image = NULL;
    }
    if (materialPic.selectedImage) {
        HmcImageDestroy(materialPic.selectedImage);
        materialPic.selectedImage = NULL;
    }
}

STRING HmcMaterialUtil::GetPathWithoutRoot(const STRING &path)
{
    if (path.empty()) {
        return path;
    }

    STRING pathTmp(path);
    size_t pos = pathTmp.find(HmcMaterialUtil::GetMaterialRootDir());
    if (pos != STRING::npos) {
        pathTmp = pathTmp.substr(pos + HmcMaterialUtil::GetMaterialRootDir().size());
    }

    return pathTmp;
}

STRING HmcMaterialUtil::GetPathWithoutRootForEveryOne(const STRING &path)
{
    if (path.empty()) {
        return path;
    }

    STRING pathTmp(path);
    STRING str = STRING("Document") + FILE_SEPARATOR_STR + STRING("ImageMaterial");
    size_t pos = pathTmp.rfind(str); // 反向查找，找到最后一个Document\\Material
    if (pos != STRING::npos) {
        pathTmp = pathTmp.substr(pos + str.size());
    }

    return pathTmp;
}

INT32 HmcMaterialUtil::CompareVersion(STRING &v1, STRING &v2)
{
    if (v1 == v2) {
        return 0;
    }
    STRING_VECTOR version1 = HmcSplitString(v1, ".");
    STRING_VECTOR version2 = HmcSplitString(v2, ".");

    INT32 len = HMC_MIN((INT32)version1.size(), (INT32)version2.size());
    for (INT32 idx = 0; idx < len; idx++) {
        if (version1[idx] == version2[idx]) {
            continue;
        }
        return (std::stoi(version1[idx]) > std::stoi(version2[idx]) ? 1 : -1);
    }

    // 到此，认为在len长度内都是相等的，后面只需根据长度来判定即可
    return (version1.size() > version2.size() ? 1 : -1);
}

VOID HmcMaterialUtil::InitLibraryColumn(HmcMaterialLibraryColumn &column)
{
    memset(column.name, 0, sizeof(column.name));
    column.uid = HMC_UID_NULL;
    column.columnType = HMC_MATERIAL_COLUMN_BUTTOM;
    column.dict = nullptr;
    column.subColumnList = nullptr;
    column.subColumnCnt = 0;
    column.contentList = nullptr;
    column.contentCnt = 0;
    column.realContentCnt = 0;
}

VOID HmcMaterialUtil::FreeLibrarySubColumnList(HmcMaterialLibraryColumn *column)
{
    if (column == nullptr) {
        return;
    }
    if (column->dict != nullptr) {
        HmcDictDestroy(column->dict);
        column->dict = nullptr;
    }
    if (column->subColumnCnt > 0) {
        for (int i = 0; i < column->subColumnCnt; i++) {
            FreeLibrarySubColumnList(&column->subColumnList[i]);
        }
        delete[] column->subColumnList;
    }
    column->subColumnList = NULL;

    if (column->contentCnt > 0) {
        FreeLibraryContentList(column->contentList, column->contentCnt);
        delete[] column->contentList;
    }
    column->contentList = NULL;
}

VOID HmcMaterialUtil::FreeLibraryContentList(HmcMaterialLibraryContent *contentList, int cnt)
{
    if (contentList == NULL) {
        return;
    }

    int idx = 0;
    for (idx = 0; idx < cnt; idx++) {
        HmcMaterialLibraryContent &content = contentList[idx];
        FreeLibraryContent(content);
    }
}

VOID HmcMaterialUtil::HmcGetFilePathNameAndExt(const STRING &fileName, STRING &filePath, STRING &fileNameWithoutExt,
    STRING &fileExt)
{
    if (fileName.empty()) {
        filePath = "";
        fileNameWithoutExt = "";
        fileExt = "";
        return;
    }

    size_t separatorPos = fileName.find_last_of(FILE_SEPARATOR_CHAR);
    if (separatorPos != STRING::npos) {
        filePath = fileName.substr(0, separatorPos);
        fileNameWithoutExt = fileName.substr(separatorPos + 1);
    } else {
        filePath = "";
        fileNameWithoutExt = fileName;
    }

    size_t dotPos = fileNameWithoutExt.find_last_of('.');
    if (dotPos != STRING::npos) {
        fileExt = fileNameWithoutExt.substr(dotPos + 1);
        fileNameWithoutExt = fileNameWithoutExt.substr(0, dotPos);
    } else {
        fileExt = "";
    }
}

STRING HmcMaterialUtil::GetFileNameFromUrl(const STRING &url)
{
    STRING_VECTOR strList = HmcSplitString(url, "/");
    int vectorSize = (int)strList.size();
    STRING fileName;
    if (vectorSize >= 1) {
        fileName = strList[strList.size() - 1];
        int pos = (int)fileName.find_first_of("?");
        if (pos != -1) {
            fileName = fileName.substr(0, pos).c_str();
        }
    } else if (vectorSize == 0) {
        LOGI("url un correct xxxx");
        fileName = url;
    }

    return fileName;
}

STRING HmcMaterialUtil::GetMaterialDownFileNameFromUrl(const STRING &downloadUrl, STRING &encryptName)
{
    // 网络URL均是以 / 分隔
    STRING_VECTOR strList = HmcSplitString(downloadUrl, "/");
    STRING fileName = strList[strList.size() - 1];
    STRING fileNameWithoutExt;
    STRING fileExt;
    STRING urlFilePath;
    HmcMaterialUtil::HmcGetFilePathNameAndExt(fileName, urlFilePath, fileNameWithoutExt, fileExt);
    encryptName = fileNameWithoutExt + g_encryptPrefix + "." + fileExt;
    return fileName;
}

void HmcMaterialUtil::CopyFileTo(const STRING &srcPath, const STRING &dstPath)
{
    STRING tmpSrcPath = srcPath;
    STRING tmpDstPath = dstPath;
    // 文件不存在，但路径应该是存在的，尝试分离出路径，之后再合并
    auto pos = dstPath.find_last_of("/\\");
    if (pos == STRING::npos) {
        LOGI("cannot find dir:%s", dstPath.c_str());
        return;
    }

    STRING dirPath(dstPath, 0, pos);
    if (!HmcIsDirExist(dirPath)) {
        LOGI("make dir:%s", dirPath.c_str());
        HmcMakeDirTree(dirPath);
    }
    std::ifstream srcIStream(tmpSrcPath, std::ios::binary);
    std::ofstream desOStream(tmpDstPath, std::ios::binary);
    if (srcIStream.bad() || desOStream.bad()) {
        LOGE("invalid stream:%s %s", srcPath.c_str(), dstPath.c_str());
        return;
    }
    desOStream << srcIStream.rdbuf();
}

INT32 HmcMaterialUtil::CopyAllFiles(const STRING &srcPath, const STRING &dstPath)
{
    STRING srcPathStr = srcPath;
    STRING destPathStr = dstPath;
    DIR *dir = nullptr;
    dir = opendir(srcPathStr.c_str());
    if (dir == nullptr) {
        LOGW("err opendir (%s). srcPathStr:%s", strerror(errno), srcPathStr.c_str());
        return HMC_ERR;
    }
    struct dirent *ent = nullptr;
    while ((ent = readdir(dir)) != nullptr) {
        if (ent->d_name == STRING(".") || ent->d_name == STRING("..")) {
            continue;
        }
        STRING copySrc = srcPathStr + "/" + ent->d_name;
        STRING copyDest = destPathStr + "/" + ent->d_name;
        struct stat st;
        stat(copySrc.c_str(), &st);
        if (!S_ISDIR(st.st_mode)) {
            CopyFileTo(copySrc, copyDest);
        } else {
            CopyAllFiles(copySrc, copyDest);
        }
    }
    closedir(dir);
    return HMC_OK;
}

void HmcMaterialUtil::FreeLibraryContent(HmcMaterialLibraryContent &content)
{
    if (content.cloudId != nullptr) {
        delete[] content.cloudId;
        content.cloudId = nullptr;
    }
    if (content.name != nullptr) {
        delete[] content.name;
        content.name = nullptr;
    }
    if (content.description != nullptr) {
        delete[] content.description;
        content.description = nullptr;
    }
    if (content.previewUrl != nullptr) {
        delete[] content.previewUrl;
        content.previewUrl = nullptr;
    }
    if (content.previewPath != nullptr) {
        delete[] content.previewPath;
        content.previewPath = nullptr;
    }
    for (int loop = 0; loop < content.picCnt; loop++) {
        HmcMaterialUtil::FreeLibraryPic(content.picList[loop]);
    }
    if (content.picList != nullptr) {
        delete[] content.picList;
        content.picList = nullptr;
    }

    if (content.dict != nullptr) {
        HmcDictDestroy(content.dict);
        content.dict = nullptr;
    }
}

INT32 HmcMaterialUtil::DownAndCheckMaterial(HmcMaterialContent *content, const HmcSimpleString &secretKey)
{
    return HMC_OK;
}

char *HmcMaterialUtil::DupCString(const STRING &string)
{
    size_t len = string.size() > 0 ? (string.size() + 1) : 4; // 可能会有中文，最少按照4个字节处理
    char *dupStr = new (std::nothrow) char[len];
    if (dupStr != nullptr) {
        memset(dupStr, 0, len);
        memcpy(dupStr, string.c_str(), string.size());
    }
    return dupStr;
}

HmcMaterialTransitionSubType HmcMaterialUtil::GetTransitionType(const STRING &materialCloudId)
{
    HmcMaterialTransitionSubType transitionSubType = HMC_MATERIAL_TRANSITION_TEXTURE_TYPE_DOUBLE;
    if (materialCloudId.empty()) {
        LOGE("material uid is null");
        return transitionSubType;
    }
    auto renderResPtr = std::make_shared<HmcMaterialRenderResource>();
    INT32 result = SINGLETON(HmcMaterialManager)->GetMaterialRenderResource(materialCloudId, renderResPtr.get());
    if (result != HMC_OK) {
        LOGE("get material render resource failed with error: %d", result);
        return transitionSubType;
    }
    if (renderResPtr->m_effectType == "transitionNormal") {
        transitionSubType = HMC_MATERIAL_TRANSITION_TEXTURE_TYPE_SINGLE; // 单纹理
    }
    return transitionSubType;
}

STRING HmcMaterialUtil::GetMaterialContentId(HmcUid &materialUid)
{
    if (HmcUidIsNull(&materialUid)) {
        LOGW("null material uid while getting content id");
        return {};
    }
    STRING uidBuffStr = HmcUidToString(&materialUid);
    STRING configFilePath = HmcMaterialUtil::GetUidSettingDir() + FILE_SEPARATOR_STR + uidBuffStr + ".json";

    Json::Value rootJson;
    if (HmcMaterialJsonUtil::LoadJsonFromFile(configFilePath, rootJson) != HMC_OK) {
        return {};
    }

    auto contentId = HmcMaterialJsonUtil::GetString("materialId", rootJson, "");
    return contentId;
}

STRING HmcMaterialUtil::GetMaterialCloudIdFromUid(const Json::Value &jsonData, const STRING &uidKey,
    const STRING &cloudKey)
{
    // 先尝试获取cloudId
    STRING materialCloudId = HmcMaterialJsonUtil::GetString(cloudKey, jsonData, "");
    // 再尝试从uid转换
    STRING materialId = HmcMaterialJsonUtil::GetString(uidKey, jsonData, "");
    if (!materialId.empty()) {
        // 兼容老草稿，如果有uid，通过uid转为cloudid
        HmcUid materialUidFromJson = HMC_UID_NULL;
        (VOID)HmcUidFromString(materialId.c_str(), &materialUidFromJson);
        materialCloudId = HmcMaterialUtil::GetMaterialContentId(materialUidFromJson);
    }
    return materialCloudId;
}

void HmcMaterialUtil::DestroyOutDateList(const HmcMaterialOutDateList &materialOutDateList)
{
    int cnt = materialOutDateList.count;
    for (int iter = 0; iter < cnt; iter++) {
        HmcMaterialItem *item = &materialOutDateList.outDateList[iter];
        if (item && item->cloudId != nullptr) {
            HmcFree(item->cloudId);
        }
    }
    delete[] materialOutDateList.outDateList;
}