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

#ifndef HMCUIDADMIN_H
#define HMCUIDADMIN_H

#include "HmcBase.h"

class IHmcLane;
class IHmcAsset;
class HmcEffect;

class CHmcUid {
public:
    CHmcUid(HmcUid uid);
    ~CHmcUid(){};
    BOOL operator < (const CHmcUid &uid) const;
    HmcUid GetUid() const;

private:
    HmcUid m_uid;
};

class HmcUidAdmin {
    DECLARE_SINGLETON(HmcUidAdmin);

public:
    HmcUidAdmin();

public:
    IHmcLane *GetLane(HmcUid uid) const;
    VOID SetLane(HmcUid uid, IHmcLane *lane);

    IHmcAsset *GetAsset(HmcUid uid) const;
    VOID SetAsset(HmcUid uid, IHmcAsset *asset);
    VECTOR<IHmcAsset *> GetAllAsset() const;

    HmcEffect *GetEffect(HmcUid uid) const;
    VOID SetEffect(HmcUid uid, HmcEffect *effect);

    VOID Erase(HmcUid uid);

private:
    mutable HmcMutex m_locker;
    MAP<CHmcUid, IHmcLane *> m_laneAdmin;
    MAP<CHmcUid, IHmcAsset *> m_assetAdmin;
    MAP<CHmcUid, HmcEffect *> m_effectAdmin;
};

#endif // HMCUIDADMIN_H
