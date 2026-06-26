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

#ifndef HMC_MATERIAL_CONSTANT_H
#define HMC_MATERIAL_CONSTANT_H

constexpr const char *HMC_MATERIAL_KEY_MATERIAL_ID = "material_id";
constexpr const char *HMC_MATERIAL_KEY_DOWNLOAD_URL = "download_url";
constexpr const char *HMC_MATERIAL_KEY_ID_LIST = "id_list"; // codeid 和 contentid映射 表
constexpr const char *HMC_MATERIAL_KEY_ID_LIST_CNT = "id_list_cnt";
constexpr const char *HMC_MATERIAL_KEY_COLUMN_LIST_CNT = "column_list_cnt";
constexpr const char *HMC_MATERIAL_KEY_CONTENT_LIST_CNT = "content_list_cnt";
constexpr const char *HMC_MATERIAL_KEY_COLUMN_GET_RESURSIVE = "column_get_recursive";
constexpr const char *HMC_MATERIAL_KEY_CONTENT_TYPE = "content_type";
constexpr const char *HMC_MATERIAL_KEY_DOWNLOAD_FILEPATH = "file_path";
constexpr const char *HMC_MATERIAL_KEY_INNER_CONTENT = "inner_content";

constexpr const char *MATERIAL_CONFIG_JSON_FILE_NAME = "config.json";
constexpr const char *MATERIAL_CONFIG_FIELD_SCRIPT = "scriptPath";
constexpr const char *MATERIAL_CONFIG_FIELD_SHADER_PASS = "shaderPassConfigs";
constexpr const char *MATERIAL_CONFIG_FIELD_SHADER_VERTEX = "vertexShaderPath";
constexpr const char *MATERIAL_CONFIG_FIELD_SHADER_FRAGMENT = "fragmentShaderPath";


const int HMC_MATERIAL_CACHE_EXPIRE_TIME = 1 * 60 * 60 * 1000; // 单位毫秒,1小时

#endif // !HMC_MATERIAL_CONSTANT_H
