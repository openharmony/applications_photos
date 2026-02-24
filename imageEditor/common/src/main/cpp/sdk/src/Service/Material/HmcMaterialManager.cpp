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
#include "HmcService.h"
#include "HmcMaterialConstant.h"
#include "Cache/HmcMaterialUidCache.h"

#include "HmcMaterialUtil.h"
#include "HmcMaterialManager.h"

const int MATERIAL_MANAGER_MAX_THREAD = 5;

// 素材下载到本地之后默认目录
constexpr const char *MATERIAL_MANAGER_USER_ID = "1234";

IMPLEMENT_SINGLETON(HmcMaterialManager)

HmcMaterialManager::HmcMaterialManager()
{
    HmcMaterialUtil::ConfigEnvironment();
    InitMaterialList();
}

VOID HmcMaterialManager::InitMaterialList()
{
    // load Document/Material/Library/Setting/CodeIdMap.json 到 contentCodeCache
    LoadCodeIdMap();
}

INT32 HmcMaterialManager::GetMaterialByUid(const HmcUid *uid, HmcMaterialLibraryType *materialType, VOID **material,
    bool *isRootColumn)
{
    if (uid == nullptr || materialType == nullptr || material == nullptr || isRootColumn == nullptr) {
        LOGE("uid, materialType, or material or isRootColumn is nullptr");
        return HMC_ERR;
    }

    *isRootColumn = false;

    // 查找uid
    STRING uidString = HmcUidToString(uid);
    HmcMaterialUid materialUid;
    if (HmcMaterialUid::GetMaterialUidByUid(*uid, materialUid) != HMC_OK) {
        LOGE("Can not find this uid(%s).", uidString.c_str());
        return HMC_ERR;
    }

    *materialType = materialUid.type;
    LOGD("materialUid.type: %d", (int)materialUid.type);
    if (materialUid.type == MATERIAL_CONTENT_TYPE_COLUMN) {
        HmcMaterialColumn *column = new (std::nothrow) HmcMaterialColumn;
        if (column == nullptr) {
            LOGE("alloc for column failed.");
            return HMC_ERR_MATERIAL_INNER;
        }
        if (HmcMaterialColumn::GetColumnById(materialUid.materialId, *column) != HMC_OK) {
            LOGE("get column failed.");
            delete column;
            return HMC_ERR;
        }
        *material = column;
        return HMC_OK;
    } else if (materialUid.type != MATERIAL_CONTENT_TYPE_NONE) {
        HmcMaterialContent *content = new (std::nothrow) HmcMaterialContent;
        if (content == nullptr) {
            LOGE("alloc for content failed.");
            return HMC_ERR_MATERIAL_INNER;
        }
        if (HmcMaterialContent::GetContentById(materialUid.materialId, *content) != HMC_OK) {
            LOGE("get content failed.");
            delete content;
            return HMC_ERR;
        }
        *material = content;
        return HMC_OK;
    }

    return HMC_ERR;
}

INT32 HmcMaterialManager::GetMaterialContentByUid(const HmcUid &uid, HmcMaterialContent &findContent)
{
    HmcMaterialContent *content = nullptr;
    HmcMaterialLibraryType materialType;
    bool isRootColumn = false;
    INT32 ret = GetMaterialByUid(&uid, &materialType, (VOID **)&content, &isRootColumn);
    if (ret != HMC_OK) {
        LOGE("cant's find uid in net material library.");
        return ret;
    }
    if (materialType == MATERIAL_CONTENT_TYPE_COLUMN || materialType == MATERIAL_CONTENT_TYPE_NONE) {
        LOGE("type(%d) is MATERIAL_CONTENT_TYPE_COLUMN or MATERIAL_CONTENT_TYPE_NONE not a content", (int)materialType);
        HmcMaterialUtil::FreeMaterial(materialType, (VOID **)&content);
        return HMC_ERR_MATERIAL_PARAM;
    }
    findContent = *content;
    HmcMaterialUtil::FreeMaterial(materialType, (VOID **)&content);
    return HMC_OK;
}

INT32 HmcMaterialManager::GetValidMaterialByUid(const HmcUid &uid, HmcMaterialContent &findContent)
{
    INT32 ret = GetMaterialContentByUid(uid, findContent);
    if (ret != HMC_OK) {
        LOGW("can not find valid material content");
        return ret;
    }
    if (findContent.state == MATERIAL_STATE_UNAVAILABLE) {
        LOGE("this content is unavailable.");
        return HMC_ERR_MATERIAL_UNAVAILABLE;
    } else if (findContent.state == MATERIAL_STATE_CREATING || findContent.state == MATERIAL_STATE_UPDATING) {
        LOGE("this content is creating or updating.");
        return HMC_ERR_MATERIAL_CREATING_UPDATING;
    }
    return HMC_OK;
}

INT32 HmcMaterialManager::GetMaterialContentPath(const HmcUid &uid, STRING &filePath, HmcMaterialContent *contentResult)
{
    HmcMaterialContent findContent;
    INT32 ret = GetValidMaterialByUid(uid, findContent);
    if (ret != HMC_OK) {
        return ret;
    }
    filePath = findContent.downloadFilePath; // 配置文件存储的为相对路径
    if (contentResult != nullptr) {
        *contentResult = findContent;
    }
    return HMC_OK;
}

INT32 HmcMaterialManager::GetMaterialPath(const HmcUid &uid, STRING &filePath)
{
    INT32 ret = GetMaterialContentPath(uid, filePath, nullptr);
    if (ret != HMC_OK) {
        LOGE("find uid in net material library failed.");
        return ret;
    }
    filePath = HmcMaterialUtil::GetMaterialRootDir().append(filePath);
    return HMC_OK;
}

INT32 HmcMaterialManager::GetMaterialContentName(const STRING &cloudId, STRING &name)
{
    HmcMaterialContent findContent;
    INT32 ret = HmcMaterialContent::GetContentById(cloudId, findContent);
    if (ret != HMC_OK) {
        return ret;
    }
    name = findContent.contentName;
    LOGD("contentName is :%s.", name.c_str());
    return HMC_OK;
}

INT32 HmcMaterialManager::LoadCodeIdMap()
{
    STRING filePath = HmcMaterialUtil::GetCodeIdMapSettingPath();
    Json::Value jsonRoot;
    if (HmcMaterialJsonUtil::LoadJsonFromFile(filePath, jsonRoot) != HMC_OK) {
        LOGE("get data from json failed");
        return HMC_ERR;
    }

    if (jsonRoot.isNull() || !jsonRoot.isArray()) {
        return HMC_ERR;
    }
    for (UINT32 i = 0; i < jsonRoot.size(); ++i) {
        auto &setting = jsonRoot[i];
        if (setting.isNull() || setting["codeid"].isNull() || !setting["codeid"].isString() || setting["id"].isNull() ||
            !setting["id"].isString()) {
            continue;
        }
        STRING codeId = setting["codeid"].asString();
        STRING id = setting["id"].asString();
        SINGLETON(HmcMaterialUidCache)->AddContentCodeCache(codeId, id);
    }
    return HMC_OK;
}

INT32 HmcMaterialManager::GetMaterialRenderResource(const STRING &cloudId, HmcMaterialRenderResource *renderResource,
    bool isEncrypted)
{
    if (renderResource == nullptr) {
        LOGE("renderResource is nullptr.");
        return HMC_ERR;
    }
    HmcMaterialContent findContent;
    int ret = HmcMaterialContent::GetContentById(cloudId, findContent);
    if (ret != HMC_OK) {
        return ret;
    }
    HmcMaterialRes materialRes;
    if (SINGLETON(HmcMaterialUidCache)->GetMaterialResourceCache(findContent.contentId, materialRes) == HMC_OK) {
        LOGD("get render res from cache.");
        *renderResource = *materialRes.renderResPtr;
        return HMC_OK;
    }
    STRING relativePath = findContent.downloadFilePath; // 配置文件存储的为相对路径
    STRING fullPath = HmcMaterialUtil::GetMaterialRootDir() + relativePath;
    if (!HmcFile::IsFileExist(fullPath)) {
        fullPath = HmcMaterialUtil::GetBuiltinMaterialRootDir() + relativePath;
    }

    ret = HmcMaterialRenderResUtil::GetRenderResource(fullPath, renderResource, isEncrypted);
    if (ret == HMC_OK) {
        LOGD("get render res from local disk.");
        materialRes.renderResPtr = std::make_shared<HmcMaterialRenderResource>(*renderResource);
        SINGLETON(HmcMaterialUidCache)->AddMaterialResourceCache(findContent.contentId, materialRes);
    }
    LOGD("get render res, ret: %d", ret);
    return ret;
}
