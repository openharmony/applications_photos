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
#include "HmcService.h"
#include <cstring>

IMPLEMENT_SINGLETON(HmcUidAdmin)

CHmcUid::CHmcUid(HmcUid uid) : m_uid(uid) {}

BOOL CHmcUid::operator < (const CHmcUid &uid) const
{
    if (memcmp(m_uid.id, uid.m_uid.id, sizeof(m_uid.id)) < 0) {
        return TRUE;
    }
    return FALSE;
}

HmcUid CHmcUid::GetUid() const
{
    return m_uid;
}


HmcUidAdmin::HmcUidAdmin() : m_locker("HmcUidLocker") {}

IHmcLane *HmcUidAdmin::GetLane(HmcUid uid) const
{
    HMC_MUTEX_LOCK(m_locker);
    IHmcLane *lane = nullptr;
    auto iter = m_laneAdmin.find(uid);
    if (iter != m_laneAdmin.end()) {
        lane = iter->second;
    }
    HMC_MUTEX_UNLOCK(m_locker);
    return lane;
}

IHmcAsset *HmcUidAdmin::GetAsset(HmcUid uid) const
{
    HMC_MUTEX_LOCK(m_locker);
    IHmcAsset *asset = nullptr;
    auto iter = m_assetAdmin.find(uid);
    if (iter != m_assetAdmin.end()) {
        asset = iter->second;
    }
    HMC_MUTEX_UNLOCK(m_locker);
    return asset;
}

VOID HmcUidAdmin::SetLane(HmcUid uid, IHmcLane *lane)
{
    HMC_MUTEX_LOCK(m_locker);
    m_laneAdmin[uid] = lane;
    HMC_MUTEX_UNLOCK(m_locker);
}

VOID HmcUidAdmin::SetAsset(HmcUid uid, IHmcAsset *asset)
{
    HMC_MUTEX_LOCK(m_locker);
    m_assetAdmin[uid] = asset;
    HMC_MUTEX_UNLOCK(m_locker);
}

VECTOR<IHmcAsset *> HmcUidAdmin::GetAllAsset() const
{
    VECTOR<IHmcAsset *> assetList;

    HMC_MUTEX_LOCK(m_locker);
    for (const auto &assetItem : m_assetAdmin) {
        if (assetItem.second != nullptr) {
            assetList.push_back(assetItem.second);
        }
    }
    HMC_MUTEX_UNLOCK(m_locker);

    return assetList;
}

HmcEffect *HmcUidAdmin::GetEffect(HmcUid uid) const
{
    HMC_MUTEX_LOCK(m_locker);
    HmcEffect *effect = nullptr;
    auto iter = m_effectAdmin.find(uid);
    if (iter != m_effectAdmin.end()) {
        effect = iter->second;
    }
    HMC_MUTEX_UNLOCK(m_locker);
    return effect;
}

VOID HmcUidAdmin::SetEffect(HmcUid uid, HmcEffect *effect)
{
    HMC_MUTEX_LOCK(m_locker);
    m_effectAdmin[uid] = effect;
    HMC_MUTEX_UNLOCK(m_locker);
}

VOID HmcUidAdmin::Erase(HmcUid uid)
{
    HMC_MUTEX_LOCK(m_locker);
    if (m_assetAdmin.find(uid) != m_assetAdmin.end()) {
        m_assetAdmin.erase(uid);
    }

    if (m_laneAdmin.find(uid) != m_laneAdmin.end()) {
        m_laneAdmin.erase(uid);
    }

    if (m_effectAdmin.find(uid) != m_effectAdmin.end()) {
        m_effectAdmin.erase(uid);
    }
    HMC_MUTEX_UNLOCK(m_locker);
}