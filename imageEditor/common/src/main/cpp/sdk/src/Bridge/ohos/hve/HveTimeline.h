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
#ifndef OH_HVETIMELINE_H
#define OH_HVETIMELINE_H

#include <string>
#include "HmcService.h"
#include "../../../../include/MediaCreative.h"
#include "../common/NapiCallback.h"
#include "HveAsset.h"
#include "ohos/interface/ArrayBuffer.hpp"

constexpr int ONE_FRAME_TIME = 40;

typedef std::function<void(const std::string &, const std::string &, int64_t pts, ArrayBuffer const &, int, int)>
    HmcThumbCallbackFunc;
typedef std::function<void(const std::string &, const std::string &, const std::string &, int64_t pts,
    napi_value pixelmapNapi, int, int)>
    HmcFilterThumbCallbackFunc;
typedef std::function<void(napi_value pixelmapNapi, std::string jsonStr)> HmcXTStyleThumbCallbackFunc;

struct CreateTimelineParam {
    std::string projectId;
    int mediaType;
    bool isHdrShownOpen;
    std::string editData;
    bool isHideWatermarkResource;
    bool isAiWatermarkEnabled;
};

class HveTimeline {
public:
    HveTimeline(int id, HmcUid projectUid, int mediaType, std::function<void(std::string const & jsonPos)> sdkCallback,
        std::function<void(std::string const & jsonPos)> createResult, std::string const & editData);

    ~HveTimeline();

    HmcEditor *GetEditor()
    {
        return m_hmcEditor.get();
    }

    std::function<void(std::string const & jsonPos)> getCommonCallback()
    {
        return commonCallback;
    }

    HmcThumbCallbackFunc getThumbnailCallback() const
    {
        return thumbnailCallback;
    }

    HmcFilterThumbCallbackFunc getFilterThumbnailCallback() const
    {
        return filterThumbnailCallback;
    }

    int GetHveTimelineId()
    {
        return timelineId;
    }

    HveAsset *GetHveAsset(const HmcUid &assetUid)
    {
        return m_assets.find(assetUid) != m_assets.end() ? m_assets[assetUid] : nullptr;
    }
    HveAsset *GetHveAsset()
    {
        return m_assets.size() == 1 ? m_assets.begin()->second : nullptr;
    }

    HmcUid AppendLane(HmcLaneType type);
    Json::Value getVideoLanes();

    void AppendAsset(HmcUid assetUid, HmcAssetType type);
    void ClearAssets();
    void RemoveAsset(HmcUid assetUid)
    {
        if (m_assets.find(assetUid) != m_assets.end()) {
            delete m_assets[assetUid];
            m_assets.erase(assetUid);
        }
    }

    void PositionCalculation(HmcUid *assetUid, int index, Json::Value &temp, auto asset);

    Json::Value getAssets();
    
    Json::Value GetAssetFromUid(HmcUid *assetUid, int count);

    void SetWatermarkInfo(Json::Value &temp, auto asset);
    
    bool SetApertureVal(Json::Value &temp, auto asset, HmcUid assetUid);
    
    void SetThumbnailCallback(HmcThumbCallbackFunc cb)
    {
        thumbnailCallback = cb;
    }

    void SetFilterThumbnailCallback(HmcFilterThumbCallbackFunc cb)
    {
        filterThumbnailCallback = cb;
    }

    Json::Value modify(Json::Value changedAttr);
    bool Remove();
    Json::Value SerializeBridgeData();
    void DeserializeBridgeData(Json::Value data);
    void SyncDataFromServiceOnly();
    void SyncDataFromService();
    void SyncCropDataFromService(const HmcUid &mainAssetUid);
    void Reset();

    void SetConfigChangeCallback(std::function<void(bool)> callback);
    void CalConfigChangeCallback();
    void Notify();

    void SetCropRect(const HmcRectD &rect);
    void SetCropRectDefault(const HmcRectD &rect);
    HmcRectD GetCropRect() const
    {
        return m_cropRect;
    }

    HmcRectD GetDefaultCropRect() const
    {
        return m_cropRectDefault;
    }

    void SetCropRectSize(const HmcRectD &rect)
    {
        cropRectWidth = rect.Width();
        cropRectHeight = rect.Height();
    }

    void SetCropOperationArea(const HmcRectD &rect)
    {
        m_cropOperationArea = rect;
    }
    HmcRectD GetCropOperationArea() const
    {
        return m_cropOperationArea;
    }
    
    void SetReverseCropRect(const HmcRectD &rect)
    {
        m_reverseCropRect = rect;
    }
    
    HmcRectD GetReverseCropRect() const
    {
        return m_reverseCropRect;
    }

    void SetCropLimitation(const HmcRectD &rect)
    {
        cropLimitation = rect;
    }

    HmcRectD GetCropLimitation() const
    {
        return cropLimitation;
    }

    void Scale(double ratio)
    {
        cropLimitation.Scale(ratio, cropLimitation.CenterX(), cropLimitation.CenterY());
    }

    void SwitchPreviewMode();
    void SetAudioAssetUid(HmcUid audioAsset)
    {
        m_audioAsset = audioAsset;
    }
    HmcUid GetAudioAssetUid()
    {
        return m_audioAsset;
    }
    void UpdateCompileParameter(bool isSave);

    void HandleRealTimeThumbnail(HveTimeline *timeline, HmcEditor *editor, HmcDict *eventMsg);
    void HandleFilterThumbnail(HveTimeline *timeline, HmcEditor *editor, HmcDict *eventMsg);
    inline void Close()
    {
        m_isClosed = true;
    }
    inline bool IsClosed() const
    {
        return m_isClosed;
    }
    
    void SetXTStyleThumbnailCallback(HmcXTStyleThumbCallbackFunc cb);
    HmcXTStyleThumbCallbackFunc GetXTStyleThumbnailCallback();
    void HandleXTStyleThumbnail(HveTimeline *timeline, HmcEditor *editor, HmcDict *eventMsg);

protected:
    // 这个是剪辑的接口，不是HveTimeline的接口
    void Init(int id, HmcUid projectUid, int mediaType, std::function<void(std::string const &jsonPos)> createResult,
              std::string const &editData);
    int timelineId = 0;
    std::shared_ptr<HmcEditor> m_hmcEditor = nullptr;

    std::function<void(std::string const & jsonPos)> commonCallback = nullptr;
    HmcThumbCallbackFunc thumbnailCallback = nullptr;
    HmcFilterThumbCallbackFunc filterThumbnailCallback = nullptr;
    std::map<CHmcUid, HveAsset *> m_assets;
    std::vector<HmcUid> m_lanes;
    std::function<void(bool)> m_configChangeCallback{ nullptr };
    OnAssetChange m_assetChangeCb{ nullptr };
    bool isDefaultConfig = true;

    HmcRectD m_cropRect;
    HmcRectD m_cropRectDefault;
    HmcRectD m_cropOperationArea;

    // 反向裁剪返回给UI的裁剪框坐标
    HmcRectD m_reverseCropRect = {0, 0, 0, 0};

    // 固定比例裁剪的限制坐标
    HmcRectD cropLimitation;

    // 保存最新的裁剪框宽高，解决90度旋转时裁剪框更新滞后导致IsDefaultConfig()状态刷新错误
    double cropRectWidth{ 0 };
    double cropRectHeight{ 0 };

    HmcUid m_audioAsset = HMC_UID_NULL;
    bool m_isClosed = false;

    bool m_loadFromEditData{ false };
    
    HmcXTStyleThumbCallbackFunc xtStyleThumbnailCallback = nullptr;
};

#endif // OH_HVETIMELINE_H
