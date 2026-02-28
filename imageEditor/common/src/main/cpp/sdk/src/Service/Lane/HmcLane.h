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

#ifndef HMC_LANE_IMPL_H
#define HMC_LANE_IMPL_H

#include "../../../interface/IHmcLane.h"
#include "./IHmcLaneEventHandler.h"
#include "../Project/IHmcDraft.h"
#include "Asset/HmcAsset.h"

class HmcLane : public IHmcLane, public IHmcLaneEventHandler, public IHmcDraft {
public:
    HmcLane(HmcEventHandler *eventHandler, HmcLaneType type);
    virtual ~HmcLane();

public:
    inline HmcUid GetLaneUid() const override
    {
        return m_laneUid;
    };

    inline HmcLaneType GetType() const override
    {
        return m_type;
    };

    inline uint64_t GetDuration() const override
    {
        return m_duration;
    };

    Json::Value Serialize() const override;
    bool Deserialize(const Json::Value &lane) override;

    HmcUid CreateAsset(const HmcDict *dict) override;
    void DestroyAsset(const HmcUid &assetUid) override;

    int32_t InsertAsset(const HmcUid &assetUid, uint64_t startTime) override;
    void RemoveAsset(const HmcUid &assetUid) override;

    void ClearAsset() override;

    bool MoveAsset(const HmcUid &assetUid, uint64_t startTime) override;

    HmcUid GetAsset(uint64_t timestamp) const override;
    void GetAssetList(std::vector<HmcUid> &assetList) const override;

    bool IsEmpty(uint64_t startTime, uint64_t endTime) const override;

    inline bool IsMute() const override
    {
        return m_mute;
    }
    inline void SetMute(bool mute) override
    {
        m_mute = mute;
    }

    inline bool IsVisible() const override
    {
        return m_visible;
    }
    inline void SetVisible(bool visible) override
    {
        m_visible = visible;
    }

    void OnAssetDurationChange(const HmcUid &assetUid) override;

    int32_t PackGraphicsRenderInfo(uint64_t timestamp, std::shared_ptr<VideoRenderInfo> &renderInfo,
        bool exactMode = true);

private:
    IHmcAsset *CreateAssetEntity();

    IHmcAsset *CreateAsset(const Json::Value &asset);

    int32_t InsertAsset(IHmcAsset *asset, uint64_t startTime);
    bool MoveAsset(IHmcAsset *asset, uint64_t startTime);

    void UpdateLane(); // 更新泳道的持续时间
    
    int32_t ReplaceSource(const HmcDict *dict, const std::string &path);

    static int32_t SetAssetSource(const HmcDict *dict, IHmcAsset *asset);
    static bool CompareAssetList(const HmcUid &first, HmcUid &second);

private:
    HmcLaneType m_type{ HMC_LANE_NONE }; // 轨道类型
    uint64_t m_duration{ 0 };            // 时间线上的起始时间
    HmcUid m_laneUid{ HMC_UID_NULL };    // 轨道唯一指定UID

    HmcEventHandler *m_eventHandler{ nullptr }; // 回调函数指针

    std::vector<HmcUid> m_assetList; // asset列表

    bool m_visible{ TRUE }; // 轨道是否可见
    bool m_mute{ FALSE };   // 静音标志
};
#endif
