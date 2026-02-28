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

#ifndef MEDIACREATIVE_HMCMATERIALUIDCACHE_H
#define MEDIACREATIVE_HMCMATERIALUIDCACHE_H

#include "../Entity/HmcMaterialUid.h"

#include "HmcBase.h"
#include "MediaCreative.h"

#include "../Entity/HmcMaterialContent.h"
#include "../Entity/HmcMaterialColumn.h"
#include "../HmcMaterialRes.h"

#include <fstream>
#include <utility>
#include <iostream>
#include "../Cache/HmcCacheManager.hpp"

const int HMC_MATERIAL_UIDCACHE_CONTENT_TTL = 60 * 10; // 单位为秒, 10min
constexpr int HMC_MATERIAL_COLUMN_TTL = 60 * 10;       // 单位为秒, 10min

class HmcMaterialUidCache {
public:
    DECLARE_SINGLETON(HmcMaterialUidCache);

public:
    HmcMaterialUidCache();
    inline void AddUidCache(const STRING &uidStr, const HmcMaterialUid &materialUid)
    {
        m_uidCache.Add(uidStr, materialUid, HMC_MATERIAL_UID_TTL);
    }
    inline INT32 GetUidCache(const STRING &uidStr, HmcMaterialUid &materialUid)
    {
        return m_uidCache.Get(uidStr, materialUid);
    }

    inline void AddContentCache(const HmcMaterialContent &content)
    {
        m_contentCache.Add(content.contentId, content, HMC_MATERIAL_UIDCACHE_CONTENT_TTL);
    }

    inline INT32 GetContentCache(const STRING &contentId, HmcMaterialContent &content)
    {
        return m_contentCache.Get(contentId, content);
    }
    inline INT32 DelContentCache(const STRING &contentId)
    {
        return m_contentCache.Del(contentId);
    }

    inline void AddColumnCache(const HmcMaterialColumn &column)
    {
        m_columnCache.Add(column.columnId, column, HMC_MATERIAL_COLUMN_TTL);
    }

    inline INT32 GetColumnCache(const STRING &columnId, HmcMaterialColumn &column)
    {
        return m_columnCache.Get(columnId, column);
    }

    void AddContentCodeCache(const STRING &codeId, const STRING &contentId);
    void AddContentCodeCache(const HmcMaterialContent &content);

    void AddMaterialResourceCache(const STRING &contentId, const HmcMaterialRes &materialRes);
    INT32 GetMaterialResourceCache(const STRING &contentId, HmcMaterialRes &materialRes);

    HmcCacheManager<HmcMaterialUid> m_uidCache;
    HmcCacheManager<HmcMaterialContent> m_contentCache;
    HmcCacheManager<HmcMaterialColumn> m_columnCache;
    HmcCacheManager<STRING> m_contentCodeCache;
    HmcCacheManager<HmcMaterialRes> m_materialResCache;
};


#endif // MEDIACREATIVE_HMCMATERIALUIDCACHE_H
