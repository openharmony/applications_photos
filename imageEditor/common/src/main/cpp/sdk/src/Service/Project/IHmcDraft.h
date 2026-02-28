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
#ifndef HMC_DRAFT_INTERFACE_H
#define HMC_DRAFT_INTERFACE_H

#include "HmcBaseType.h"
#include "MediaCreative.h"

/**
 * @brief 轨道编辑操作的接口，包括查询时长，获取轨道上的剪辑，序列化反序列化等针对某个轨道的操作。
 */
class IHmcDraft {
public:
    /* *
     * @brief 将数据序列化成JSON，可用于保存编辑草稿.
     * @return Json::Value 序列化后的JSON
     */
    virtual Json::Value Serialize() const = 0;

    /* *
     * @brief 将Serialize后的JSON数据，反序列化到编辑对象中，用于恢复数据，可用于恢复编辑草稿.
     * @return bool true: 反序列化成功， false: 失败
     */
    virtual bool Deserialize(const Json::Value &lane) = 0;
};

#endif
