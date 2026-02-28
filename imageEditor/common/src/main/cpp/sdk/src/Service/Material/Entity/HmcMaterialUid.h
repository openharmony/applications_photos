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

#ifndef HMC_MATERIAL_UID_H
#define HMC_MATERIAL_UID_H

#include <json/json.h>
#include "HmcBase.h"
#include "HmcMaterialEntity.h"

const int HMC_MATERIAL_UID_TTL = 60 * 10; // 单位为秒, 10min

class HmcMaterialUid : public HmcMaterialEntity {
public:
    HmcUid uid;                              // UID，SDK的素材唯一标识
    HmcUid parentUid;                        // 父UID，无父UID的则为HMC_UID_NULL
    STRING materialId;                       // 云侧素材的唯一标识，栏目及素材
    HmcMaterialLibraryType type;             // 素材的类型
    HmcMaterialLibraryColumnType columnType; // 素材所在栏目的类型

    VOID SaveUidToConfigFile();
    INT32 LoadUidFromConfigFile();

    Json::Value SerializeToJson() override;
    VOID DeserializeFromJson(const Json::Value &colJson) override;

    static INT32 LoadUid(const HmcUid &uid);
    static INT32 GetMaterialUidByUid(const HmcUid &uid, HmcMaterialUid &materialUid);

private:
};

#endif // !HMC_MATERIAL_UID
