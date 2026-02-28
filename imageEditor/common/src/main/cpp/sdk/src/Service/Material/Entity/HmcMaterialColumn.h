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

#ifndef HMC_MATERIAL_COLUMN_H
#define HMC_MATERIAL_COLUMN_H

#include "./HmcMaterialContent.h"
#include "HmcMaterialEntity.h"

#ifdef __cplusplus

using HmcMaterialNetParam = struct HmcMaterialNetParam {
    INT32 offset;
    INT32 count;
    HmcMaterialLibraryColumnType columnType;
    STRING materialId;
    HmcUid columnUid;
};

using HmcMaterialIdTypePair = struct HmcMaterialIdTypePair {
    STRING id = "";
    HmcMaterialLibraryType type = MATERIAL_CONTENT_TYPE_NONE;
    INT32 index = -1; // 记录请求的索引。。todo map

    bool operator == (const HmcMaterialIdTypePair &other) const;
};

using HmcMaterialStateEvent = enum {
    MATERIAL_STATE_EVENT_GET = 0,         // 查询事件
    MATERIAL_STATE_EVENT_START_DOWNLOAD,  // 开始下载
    MATERIAL_STATE_EVENT_FINISH_DOWNLOAD, // 下载完成
    MATERIAL_STATE_EVENT_NOTIFY_UPDATE,   // 通知更新
    MATERIAL_STATE_EVENT_FINISH_PARSING,  // 解析完成
};

constexpr int MATERIAL_COLUMN_ONE_PAGE_ENTRY_NUM = 50; // 默认一级栏目获取子栏目时候的，请求数量

class HmcMaterialColumn;
class HmcMaterialContent;
using HmcMaterialUpdateParam = struct HmcMaterialUpdateParam {
    INT32 offset;
    INT32 count;
    INT32 idListCnt;
    INT32 columnListCnt = 0;
    INT32 contentListCnt = 0;
    INT32 ret;
    INT32 hasNextPage;
    HmcDict *dict = nullptr;
    HmcMaterialLibraryColumnType columnType;
    HmcUid materialUid;
    HmcMaterialIdTypePair *idList = nullptr;
    HmcMaterialColumn *columnList = nullptr;
    HmcMaterialContent *contentList = nullptr;
    INT32 fromNet;
};

class HmcMaterialColumn : public HmcMaterialEntity {
public:
    HmcUid uid;      // SDK全局唯一标识
    int contentType; // 栏目下素材的类型，网络素材库为云侧返回的类型，本地或项目素材无用
    int attribute;   // 栏目属性
    HmcMaterialState state;      // 栏目的状态，包括未创建、创建中、可用、不可用、待更新
    HmcMaterialLibraryType type; // 栏目的类型枚举值，固定为101
    HmcMaterialLibraryColumnType columnType; // 具体的栏目类型
    STRING description;                      // 描述
    STRING columnId;        // 栏目ID，网络素材库为云侧返回的ID，本地或者项目素材的则取UID
    STRING columnName;      // 栏目名称
    STRING code;            // code
    STRING tmpl;            // 模板样式编号（预留）
    VECTOR<HmcPic> picList; // 海报，网络素材库为云侧返回的内容，本地则为空
    VECTOR<HmcMaterialIdTypePair> materialIdList;  // 该栏目下素材或者子栏目的ID列表
    UINT64 cacheTime;                              // 数据缓存时间
    STRING updateTime;                             // 更新时间
    STRING version;                                // 缓存版本
    VECTOR<HmcMaterialIdTypePair> netMaterialList; // 该栏目下素材或者子栏目的云侧列表

    explicit HmcMaterialColumn(HmcMaterialLibraryColumnType colType = HMC_MATERIAL_COLUMN_BUTTOM);
    HmcMaterialColumn(const HmcMaterialColumn &other);
    HmcMaterialColumn &operator = (const HmcMaterialColumn &other);
    ~HmcMaterialColumn() override = default;

    inline bool operator == (const HmcMaterialColumn &rh) const
    {
        return (columnId == rh.columnId);
    }
    
    static INT32 GetColumnById(STRING columnId, HmcMaterialColumn &column);
    static INT32 LoadSubColumn(const STRING &columnId);

    virtual void LoadSubMaterialLists();
    Json::Value SerializeToJson() override;
    VOID DeserializeFromJson(const Json::Value &colJson) override;

    // copy除contentList、columnList以外的字段
    VOID CopyWithoutCacheTimeAndList(const HmcMaterialColumn &other);
    VOID Clear();

    INT32 LoadColumnFromConfigFile();
    VOID CopyAllFromOther(const HmcMaterialColumn &other);

private:
    bool CheckVersionValid() const;
};

#endif // __cplusplus

#endif // HMC_MATERIAL_COLUMN_H
