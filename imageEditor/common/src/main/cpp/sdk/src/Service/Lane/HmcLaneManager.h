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
#ifndef HMCLANEMANAGER_H
#define HMCLANEMANAGER_H

#include <shared_mutex>

struct SetSpeedInfo {
    INT64 startTime{ 0 };
    INT64 oldEndTime{ 0 };
    INT64 oldDuration{ 0 };
    INT64 oldTrimIn{ 0 };
    INT64 oldTrimOut{ 0 };
    INT64 newDuration{ 0 };
    INT64 newEndTime{ 0 };
    INT64 newTrimIn{ 0 };
    INT64 newTrimOut{ 0 };
};

class HmcLaneManager {
public:
    HmcLaneManager(HmcEventHandler *eventHandler);
    virtual ~HmcLaneManager();

public:
    int32_t PackGraphicsRenderInfo(uint64_t timestamp, std::shared_ptr<VideoRenderInfo> &renderInfo,
        bool exactMode = true);

    INT32 GetLaneCount(HmcLaneType type);
    VOID GetLaneArr(HmcLaneType type, HmcUid *laneUid, INT32 *count);
    VOID GetLaneList(HmcLaneType type, VECTOR<HmcUid> &laneList);
    VOID GetLaneList(VECTOR<HmcUid> &laneList);

    HmcUid CreateLaneEntity(HmcLaneType type);
    HmcUid CreateLane(HmcLaneType type);
    HmcUid CreateLane(HmcLaneType type, UINT32 index);

    INT32 AppendLane(const HmcUid &laneUid);
    INT32 InsertLane(const HmcUid &laneUid, unsigned int index);
    VOID RemoveLane(const HmcUid &laneUid);

    INT32 GetLaneIndex(const HmcUid &laneUid, unsigned int &index);

    BOOL DestroyLane(HmcUid laneUid);
    BOOL MoveAsset(HmcUid assetUid, HmcUid laneUid, INT64 moveTime);

    BOOL MoveEffect(HmcUid effectUid, HmcUid assetUid, INT64 moveTime);

    INT64 GetDuration();
    INT64 GetSize();
    INT64 GetDuration(HmcLaneType type);

    Json::Value SerializeData();
    INT32 DeserializeData(const Json::Value &general);

    HmcUid GetAvailableLane(HmcLaneType type, INT64 startTime, INT64 endTime);
    HmcUid GetCurrentVIAsset(INT64 timestamp);

    HmcUid GetPreLaneUid();
    HmcUid GetPreAssetUid();

    BOOL SetAssetSpeed(IHmcLane *lane, IHmcAsset *asset, FLOAT speed);

protected:
    HmcUid CreateLane(HmcLaneType type, const Json::Value &lane);
    VOID SetAssetSpeedParam(IHmcAsset *asset, INT64 newTrimIn, INT64 newTrimOut, FLOAT speed, INT64 newDuration);

private:
    mutable std::shared_timed_mutex m_mutex;

    HmcEventHandler *m_eventHandler{ nullptr };
    MAP<HmcLaneType, LIST<HmcUid>> m_laneList;
};

#endif
