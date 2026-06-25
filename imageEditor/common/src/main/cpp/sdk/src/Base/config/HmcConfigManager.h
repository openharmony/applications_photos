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

#ifndef HMCCONFIGMANAGER_H
#define HMCCONFIGMANAGER_H

class HmcConfigManager {
    DECLARE_SINGLETON(HmcConfigManager);

public:
    HmcConfigManager();

    VOID Init();

    INT32 SetInt32(const char *name, INT32 value);

    INT32 SetInt64(const char *name, INT64 value);

    INT32 SetDouble(const char *name, double value);

    INT32 SetString(const char *name, const char *value);

    INT32 GetInt32(const char *name, INT32 *value);

    INT32 GetInt64(const char *name, INT64 *value);

    INT32 GetDouble(const char *name, double *value);

    const char *GetString(const char *name);

    VOID Remove(const char *name);

    VOID InitConfigPath(const STRING &path);

protected:
    STRING m_configPath;

    HmcMutex m_configLock;

    HmcDict *m_configDict;
};

#endif // HMCCONFIGMANAGER_H
