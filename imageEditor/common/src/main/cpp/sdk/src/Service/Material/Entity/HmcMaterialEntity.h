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

#ifndef MEDIACREATIVE_HMCMATERIALENTITY_H
#define MEDIACREATIVE_HMCMATERIALENTITY_H

#include <json/json.h>
#include "HmcBase.h"
#include "MediaCreative.h"

#include "../Utils/HmcMaterialJsonUtil.h"

class HmcMaterialEntity {
public:
    /* *
     * 序列化
     */
    virtual Json::Value SerializeToJson() = 0;

    /* *
     * 序列化字符串
     */
    virtual STRING SerializeToString()
    {
        Json::Value entityJson = SerializeToJson();
        return HmcMaterialJsonUtil::ConvertJsonToStringUtf8(entityJson);
    }

    /* *
     * 反序列化
     */
    virtual VOID DeserializeFromJson(const Json::Value &colJson) = 0;

    virtual bool IsExpired() const
    {
        return false;
    }

    HmcMaterialEntity() = default;
    virtual ~HmcMaterialEntity() = default;
};


#endif // MEDIACREATIVE_HMCMATERIALENTITY_H
