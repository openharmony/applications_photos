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
#include "HmcConfigManager.h"

IMPLEMENT_SINGLETON(HmcConfigManager)

HmcConfigManager::HmcConfigManager() : m_configDict(NULL) {}

INT32 HmcConfigManager::SetInt32(const char *name, INT32 value)
{
    HMC_MUTEX_GUARD(m_configLock);
    return HmcDictSetInt32(m_configDict, name, value);
}

INT32 HmcConfigManager::SetInt64(const char *name, INT64 value)
{
    HMC_MUTEX_GUARD(m_configLock);
    return HmcDictSetInt64(m_configDict, name, value);
}

INT32 HmcConfigManager::SetDouble(const char *name, double value)
{
    HMC_MUTEX_GUARD(m_configLock);
    return HmcDictSetDouble(m_configDict, name, value);
}

INT32 HmcConfigManager::SetString(const char *name, const char *value)
{
    HMC_MUTEX_GUARD(m_configLock);
    return HmcDictSetString(m_configDict, name, value);
}

INT32 HmcConfigManager::GetInt32(const char *name, int *value)
{
    HMC_MUTEX_GUARD(m_configLock);
    return HmcDictGetInt32(m_configDict, name, value);
}

INT32 HmcConfigManager::GetInt64(const char *name, INT64 *value)
{
    HMC_MUTEX_GUARD(m_configLock);
    return HmcDictGetInt64(m_configDict, name, value);
}

INT32 HmcConfigManager::GetDouble(const char *name, double *value)
{
    HMC_MUTEX_GUARD(m_configLock);
    return HmcDictGetDouble(m_configDict, name, value);
}

const char *HmcConfigManager::GetString(const char *name)
{
    HMC_MUTEX_GUARD(m_configLock);
    return HmcDictGetString(m_configDict, name);
}

VOID HmcConfigManager::Remove(const char *name)
{
    HMC_MUTEX_GUARD(m_configLock);
    HmcDictRemoveKey(m_configDict, name);
}

VOID HmcConfigManager::Init()
{
    // 初始化配置保存路径
    STRING path = HmcOhosGetInternalStorageDir("config");

    HmcMakeDirTree(path);

    HmcGetCanonicalizedPath(path + "/config.dict", m_configPath);

    STRING dict;
    if (HmcFile::IsFileExist(m_configPath) && HMC_OK == HmcStringDeserialize(m_configPath, dict)) {
        m_configDict = HmcDictDeserialize(dict.c_str());
    }

    if (!m_configDict) {
        m_configDict = HmcDictCreate();
    }
}
