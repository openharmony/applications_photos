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
#include "MediaCreative/HmcUid.h"

#include <shared_mutex>

HmcLaneManager::HmcLaneManager(HmcEventHandler *eventHandler) : m_eventHandler(eventHandler)
{
    LOGD(" before create HmcTimeline");
    m_laneList[HMC_LANE_AUDIO] = {};
    m_laneList[HMC_LANE_VISION] = {};
    m_laneList[HMC_LANE_NONE] = {};
}

HmcLaneManager::~HmcLaneManager()
{
    std::lock_guard<std::shared_timed_mutex> lock_guard(m_mutex);
    for (auto &laneList : m_laneList) {
        for (const auto &uid : (laneList.second)) {
            IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(uid);
            if (lane != nullptr) {
                delete lane;
            }
        }
    }
    m_laneList.clear();
}

int32_t HmcLaneManager::PackGraphicsRenderInfo(uint64_t timestamp, std::shared_ptr<VideoRenderInfo> &renderInfo,
    bool exactMode)
{
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);

    for (const auto &uid : m_laneList[HMC_LANE_VISION]) {
        IHmcLane *laneItf = SINGLETON(HmcUidAdmin)->GetLane(uid);
        auto lane = dynamic_cast<HmcLane *>(laneItf);
        if (lane != nullptr) {
            INT32 result = lane->PackGraphicsRenderInfo(timestamp, renderInfo, exactMode);
            if (result != HMC_OK) {
                return result;
            }
        }
    }

    return HMC_OK;
}

INT32 HmcLaneManager::GetLaneCount(HmcLaneType type)
{
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    int size = 0;
    for (const auto &uid : m_laneList[type]) {
        IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(uid);
        if (lane != nullptr) {
            size++;
        }
    }
    return size;
}

VOID HmcLaneManager::GetLaneArr(HmcLaneType type, HmcUid *laneUid, INT32 *count)
{
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    int size = 0;
    for (const auto &uid : m_laneList[type]) {
        if (size >= *count) {
            break;
        }
        IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(uid);
        if (lane != nullptr) {
            laneUid[size] = uid;
            size++;
        }
    }
    *count = size;
}

VOID HmcLaneManager::GetLaneList(HmcLaneType type, VECTOR<HmcUid> &laneList)
{
    laneList.clear();
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    for (const auto &uid : m_laneList[type]) {
        laneList.push_back(uid);
    }
}

VOID HmcLaneManager::GetLaneList(VECTOR<HmcUid> &laneList)
{
    laneList.clear();
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    for (int laneType = 0; laneType <= HmcLaneType::HMC_LANE_NONE; laneType++) {
        for (const auto &uid : m_laneList[(HmcLaneType)laneType]) {
            laneList.push_back(uid);
        }
    }
}

HmcUid HmcLaneManager::CreateLaneEntity(HmcLaneType type)
{
    IHmcLane *lane = new (std::nothrow) HmcLane(m_eventHandler, type);

    return (lane == nullptr) ? HMC_UID_NULL : lane->GetLaneUid();
}

HmcUid HmcLaneManager::CreateLane(HmcLaneType type)
{
    HmcUid uid = CreateLaneEntity(type);

    std::lock_guard<std::shared_timed_mutex> lock_guard(m_mutex);
    m_laneList[type].push_back(uid);

    return uid;
}

HmcUid HmcLaneManager::CreateLane(HmcLaneType type, UINT32 index)
{
    std::lock_guard<std::shared_timed_mutex> lock_guard(m_mutex);

    auto laneListSize = m_laneList[type].size();
    if (index > laneListSize) {
        return HMC_UID_NULL;
    }

    HmcUid uid = CreateLaneEntity(type);

    auto &laneList = m_laneList[type];
    UINT32 count = 0;
    auto it = laneList.begin();

    while (it != laneList.end() && count < index) {
        ++count;
        ++it;
    }

    laneList.insert(it, uid);

    return uid;
}

VOID HmcLaneManager::SetAssetSpeedParam(IHmcAsset *asset, INT64 newTrimIn, INT64 newTrimOut, FLOAT speed,
    INT64 newDuration)
{
    if (asset != nullptr) {
        asset->SetTrimIn(newTrimIn);
        asset->SetTrimOut(newTrimOut);
        asset->SetSpeed(speed);
        asset->SetDuration(newDuration);
    }
}

BOOL HmcLaneManager::DestroyLane(HmcUid laneUid)
{
    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        return FALSE;
    }

    std::lock_guard<std::shared_timed_mutex> lock_guard(m_mutex);

    HmcLaneType type = lane->GetType();
    for (auto it = m_laneList[type].begin(); it != m_laneList[type].end(); it++) {
        HmcUid uid = *it;
        if (HmcUidIsEqual(&laneUid, &uid)) {
            m_laneList[type].erase(it++);
            break;
        }
    }

    delete lane;

    return TRUE;
}

INT32 HmcLaneManager::AppendLane(const HmcUid &laneUid)
{
    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("invalid lane uid");
        return HMC_ERR_PARAM;
    }

    {
        std::lock_guard<std::shared_timed_mutex> lock_guard(m_mutex);
        m_laneList[lane->GetType()].push_back(laneUid);
    }

    return HMC_OK;
}

INT32 HmcLaneManager::InsertLane(const HmcUid &laneUid, unsigned int index)
{
    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("invalid lane uid");
        return HMC_ERR_PARAM;
    }

    HmcLaneType laneType = lane->GetType();

    {
        std::lock_guard<std::shared_timed_mutex> lock_guard(m_mutex);

        auto laneListSize = m_laneList[laneType].size();
        if (index > laneListSize) {
            m_laneList[laneType].push_back(laneUid);
        } else {
            auto it = m_laneList[laneType].begin();
            std::advance(it, index);
            m_laneList[laneType].insert(it, laneUid);
        }
    }

    return HMC_OK;
}

VOID HmcLaneManager::RemoveLane(const HmcUid &laneUid)
{
    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("invalid lane uid");
        return;
    }

    HmcLaneType type = lane->GetType();

    std::lock_guard<std::shared_timed_mutex> lock_guard(m_mutex);

    auto it = std::find_if(m_laneList[type].begin(), m_laneList[type].end(),
        [laneUid](const HmcUid &uid) { return HmcUidIsEqual(&uid, &laneUid) == TRUE; });
    if (it != m_laneList[type].end()) {
        m_laneList[type].erase(it);
    }
}

INT32 HmcLaneManager::GetLaneIndex(const HmcUid &laneUid, unsigned int &index)
{
    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("invalid lane uid");
        return HMC_ERR_PARAM;
    }

    HmcLaneType type = lane->GetType();

    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    unsigned int indexTemp = 0;
    for (const auto &uid : m_laneList[type]) {
        if (!HmcUidIsEqual(&uid, &laneUid)) {
            indexTemp++;
        } else {
            index = indexTemp;
            return HMC_OK;
        }
    }

    return HMC_ERR;
}

BOOL HmcLaneManager::MoveEffect(HmcUid effectUid, HmcUid assetUid, INT64 moveTime)
{
    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        return FALSE;
    }

    HmcUid srcAssetUid = effect->GetAssetUid();
    IHmcAsset *srcAsset = SINGLETON(HmcUidAdmin)->GetAsset(srcAssetUid);
    IHmcAsset *dstAsset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (srcAsset == nullptr || dstAsset == nullptr) {
        return FALSE;
    }

    BOOL result = FALSE;

    do {
        /* 同素材内移动effect */
        if (HmcUidIsEqual(&srcAssetUid, &assetUid)) {
            result = ((HmcVisionAsset *)srcAsset)->MoveEffect(effect, moveTime);
            break;
        }
        /* 跨素材移动effect, 暂时不支持 */
    } while (false);

    return result;
}

BOOL HmcLaneManager::MoveAsset(HmcUid assetUid, HmcUid laneUid, INT64 moveTime)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        return FALSE;
    }

    HmcUid srcLaneUid = asset->GetLaneUid();
    IHmcLane *srcLane = SINGLETON(HmcUidAdmin)->GetLane(srcLaneUid);
    IHmcLane *dstLane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (dstLane == nullptr || srcLane == nullptr) {
        return FALSE;
    }

    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);

    /* 同轨道内移动asset */
    if (HmcUidIsEqual(&srcLaneUid, &laneUid)) {
        return srcLane->MoveAsset(asset->GetUid(), moveTime);
    }

    /* 跨轨道移动asset */
    if (dstLane->InsertAsset(asset->GetUid(), moveTime) == FALSE) {
        LOGE("insert asset to target lane failed");
        return FALSE;
    }

    if (!HmcUidIsNull(&srcLaneUid)) {
        srcLane->RemoveAsset(assetUid);
    }

    asset->SetLaneUid(laneUid);

    return TRUE;
}

INT64 HmcLaneManager::GetDuration()
{
    INT64 tempDuration = 0;
    INT64 tmp = 0;

    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);

    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION, HMC_LANE_AUDIO };
    for (auto i : vc) {
        for (const auto &uid : m_laneList[i]) {
            IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(uid);
            if (lane != nullptr) {
                tmp = static_cast<INT64>(lane->GetDuration());
                tempDuration = HMC_MAX(tmp, tempDuration);
            }
        }
    }

    return tempDuration;
}

INT64 HmcLaneManager::GetSize()
{
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);

    INT64 size = 0;
    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION, HMC_LANE_AUDIO };
    MAP<STRING, INT64> infoList;
    for (auto i : vc) {
        for (const auto &laneUid : m_laneList[i]) {
            IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
            VECTOR<HmcUid> assetList;
            lane->GetAssetList(assetList);

            for (const auto &assetUid : assetList) {
                IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
                if (asset == nullptr) {
                    continue;
                }
                asset->GetFileSize(infoList);
            }
        }
    }

    for (const auto &info : infoList) {
        size += info.second;
    }
    infoList.clear();
    return size;
}

INT64 HmcLaneManager::GetDuration(HmcLaneType type)
{
    INT64 tempDuration = 0;
    INT64 tmp = 0;

    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    for (const auto &uid : m_laneList[type]) {
        IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(uid);
        if (lane != nullptr) {
            tmp = static_cast<INT64>(lane->GetDuration());
            tempDuration = HMC_MAX(tmp, tempDuration);
        }
    }

    return tempDuration;
}

Json::Value HmcLaneManager::SerializeData()
{
    Json::Value json;
    Json::Value laneArray;
    int size = 0;
    IHmcLane *lane = nullptr;

    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION, HMC_LANE_AUDIO };
    for (auto i : vc) {
        for (const auto &uid : m_laneList[i]) {
            lane = SINGLETON(HmcUidAdmin)->GetLane(uid);
            IHmcDraft *draft = dynamic_cast<IHmcDraft *>(lane);
            if (draft != nullptr) {
                Json::Value jsonLane = draft->Serialize();
                laneArray.append(jsonLane);
                size++;
            }
        }
    }

    json[DICT_KEY_LANE_SIZE] = size;
    json[DICT_KEY_LANE] = laneArray;

    return json;
}

INT32 HmcLaneManager::DeserializeData(const Json::Value &general)
{
    if (general.isNull()) {
        return HMC_ERR;
    }

    Json::Value lanes = general[DICT_KEY_LANE];
    for (const auto &lane : lanes) {
        int type;
        if (!JsonValueUtil::ParseValueIfHas(lane, DICT_KEY_LANE_TYPE, type)) {
            continue;
        }
        CreateLane(HmcLaneType(type), lane);
    }

    m_eventHandler->OnEventNotify(HMC::EVENT_DURATION_CHANGE, nullptr, nullptr);

    return HMC_OK;
}

HmcUid HmcLaneManager::CreateLane(HmcLaneType type, const Json::Value &lane)
{
    HmcUid uid = CreateLaneEntity(type);
    IHmcLane *laneItem = SINGLETON(HmcUidAdmin)->GetLane(uid);
    IHmcDraft *draft = dynamic_cast<IHmcDraft *>(laneItem);
    if (draft != nullptr) {
        draft->Deserialize(lane);
        m_mutex.lock_shared();
        m_laneList[type].push_back(laneItem->GetLaneUid());
        m_mutex.unlock_shared();
    }

    return uid;
}

HmcUid HmcLaneManager::GetAvailableLane(HmcLaneType type, INT64 startTime, INT64 endTime)
{
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    HmcUid availableLaneUid = HMC_UID_NULL;
    for (const auto &uid : m_laneList[type]) {
        IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(uid);
        if (lane != nullptr && lane->IsEmpty(startTime, endTime)) {
            availableLaneUid = uid;
            break;
        }
    }

    return availableLaneUid;
}

HmcUid HmcLaneManager::GetCurrentVIAsset(INT64 timestamp)
{
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    HmcUid assetUid = HMC_UID_NULL;
    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION };
    for (auto i : vc) {
        for (const auto &uid : m_laneList[i]) {
            IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(uid);
            if (lane != nullptr) {
                HmcUid assetUidTemp = lane->GetAsset(timestamp);
                IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUidTemp);
                if (asset != nullptr) {
                    HmcAssetType type = asset->GetType();
                    if (type == HMC_ASSET_IMAGE) {
                        assetUid = asset->GetUid();
                        break;
                    }
                }
            }
        }
    }

    return assetUid;
}


HmcUid HmcLaneManager::GetPreLaneUid()
{
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    HmcUid laneUid = HMC_UID_NULL;
    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION };
    for (auto i : vc) {
        if (m_laneList[i].size() == 1) {
            laneUid = m_laneList[i].front();
        }
    }
    return laneUid;
}

HmcUid HmcLaneManager::GetPreAssetUid()
{
    std::shared_lock<std::shared_timed_mutex> lock_guard(m_mutex);
    HmcUid laneUid = HMC_UID_NULL;
    HmcUid assetUid = HMC_UID_NULL;
    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION };
    for (auto i : vc) {
        if (m_laneList[HMC_LANE_VISION].size() == 1) {
            laneUid = m_laneList[i].front();
            IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
            if (lane != nullptr) {
                HmcUid assetUidTemp = lane->GetAsset(0);
                IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUidTemp);
                if (asset != nullptr) {
                    HmcAssetType type = asset->GetType();
                    if (type == HMC_ASSET_IMAGE) {
                        assetUid = asset->GetUid();
                    }
                }
            }
        }
    }

    return assetUid;
}

VOID SetAssetSpeedUpdateFade(IHmcAsset *asset)
{
    if (asset == nullptr) {
        return;
    }
}

BOOL HmcLaneManager::SetAssetSpeed(IHmcLane *lane, IHmcAsset *asset, FLOAT speed)
{
    if (asset == nullptr || lane == nullptr) {
        LOGE("asset or lane null.");
        return FALSE;
    }

    if (speed == asset->GetSpeed()) {
        return TRUE;
    }

    SetSpeedInfo setSpeedInfo;
    setSpeedInfo.startTime = asset->GetStartTime();
    setSpeedInfo.oldEndTime = asset->GetEndTime();
    setSpeedInfo.oldDuration = asset->GetDurationTime();
    setSpeedInfo.oldTrimOut = asset->GetTrimOut();
    setSpeedInfo.newDuration = (setSpeedInfo.oldDuration * asset->GetSpeed()) / speed;
    setSpeedInfo.newEndTime = setSpeedInfo.startTime + setSpeedInfo.newDuration - 1;
    //  trimIn与trimOut不应该跟随speed改变而变化
    setSpeedInfo.newTrimIn = (setSpeedInfo.oldTrimIn * asset->GetSpeed()) / speed;
    setSpeedInfo.newTrimOut = (setSpeedInfo.oldTrimOut * asset->GetSpeed()) / speed;

    SetAssetSpeedParam(asset, setSpeedInfo.newTrimIn, setSpeedInfo.newTrimOut, speed, setSpeedInfo.newDuration);

    SetAssetSpeedUpdateFade(asset);

    HmcUid assetUid = asset->GetUid();
    LOGE("set speed success, asset:%s, newTrimIn:%lld, newTrimOut:%lld, speed:%f, newDuration:%lld.",
        HmcUidToString(&assetUid).c_str(), setSpeedInfo.newTrimIn, setSpeedInfo.newTrimOut, speed,
        setSpeedInfo.newDuration);

    return TRUE;
}