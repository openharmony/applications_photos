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
#include "HmcMaterialUidCache.h"

IMPLEMENT_SINGLETON(HmcMaterialUidCache)

const int HMC_MATERIAL_CACHE_CONTENT_MAX_NUM = 1000;
const int HMC_MATERIAL_CACHE_COLUMN_MAX_NUM = 1000;
const int HMC_MATERIAL_RENDER_RES_CAPACITY = 30;
const int HMC_MATERIAL_CACHE_UID_MAX_NUM = 1000;
const int HMC_MATERIAL_CONTENT_CODE_CAPACITY = 5000;

constexpr int HMC_MATERIAL_RENDER_RES_TTL = 30 * 60;          // 单位为秒, 30min
constexpr int64_t HMC_MATERIAL_CONTENT_CODE_TTL = 0xefffffff; // 不过期

HmcMaterialUidCache::HmcMaterialUidCache()
    : m_uidCache("MaterialMgrUid", HMC_MATERIAL_CACHE_UID_MAX_NUM, true),
      m_contentCache("MaterialMgrContent", HMC_MATERIAL_CACHE_CONTENT_MAX_NUM, true),
      m_columnCache("MaterialMgrColumn", HMC_MATERIAL_CACHE_COLUMN_MAX_NUM, true),
      m_contentCodeCache("ContentCode", HMC_MATERIAL_CONTENT_CODE_CAPACITY, false),
      m_materialResCache("MaterialMgrMaterialRes", HMC_MATERIAL_RENDER_RES_CAPACITY, true)
{}

void HmcMaterialUidCache::AddContentCodeCache(const STRING &codeId, const STRING &contentId)
{
    m_contentCodeCache.Add(codeId, contentId, HMC_MATERIAL_CONTENT_CODE_TTL);
}

void HmcMaterialUidCache::AddContentCodeCache(const HmcMaterialContent &content)
{
    m_contentCodeCache.Add(content.code, content.contentId, HMC_MATERIAL_CONTENT_CODE_TTL);
}

void HmcMaterialUidCache::AddMaterialResourceCache(const STRING &contentId, const HmcMaterialRes &materialRes)
{
    m_materialResCache.Add(contentId, materialRes, HMC_MATERIAL_RENDER_RES_TTL);
}

INT32 HmcMaterialUidCache::GetMaterialResourceCache(const STRING &contentId, HmcMaterialRes &materialRes)
{
    return m_materialResCache.Get(contentId, materialRes);
}