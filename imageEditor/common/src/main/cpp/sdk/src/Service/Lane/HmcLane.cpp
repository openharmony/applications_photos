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
#include "ohos/common/HmcUidHelper.h"
static int g_four = 4;
static const uint32_t PIXEL_FORMAT_RGBA8888 = 3;

HmcLane::HmcLane(HmcEventHandler *eventHandler, HmcLaneType type) : m_type(type), m_eventHandler(eventHandler)
{
    HmcUidGenerate(&m_laneUid);
    SINGLETON(HmcUidAdmin)->SetLane(m_laneUid, this);
}

HmcLane::~HmcLane()
{
    for (const auto &uid : m_assetList) {
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(uid);
        if (asset != nullptr) {
            delete asset;
            asset = nullptr;
        }
    }
    m_assetList.clear();

    SINGLETON(HmcUidAdmin)->Erase(m_laneUid);
}

Json::Value HmcLane::Serialize() const
{
    Json::Value json;
    json[DICT_KEY_LANE_TYPE] = m_type;
    json[DICT_KEY_LANE_DURATION] = m_duration;

    INT32 size = 0;
    Json::Value assetList;
    for (const auto &i : m_assetList) {
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(i);
        if (asset == nullptr) {
            continue;
        }

        Json::Value jsonAsset = asset->Serialize();
        assetList.append(jsonAsset);
        size++;
    }
    json[DICT_KEY_LANE_ASSET_SIZE] = size;
    json[DICT_KEY_LANE_ASSET] = assetList;

    char laneUid[HMC_UID_STR_LEN] = {0};
    HmcUidToString(&m_laneUid, laneUid, HMC_UID_STR_LEN);
    json[DICT_KEY_LANE_UID] = laneUid;

    return json;
}

bool HmcLane::Deserialize(const Json::Value &lane)
{
    int laneType;
    if (JsonValueUtil::ParseValueIfHas(lane, DICT_KEY_LANE_TYPE, laneType)) {
        m_type = (HmcLaneType)laneType;
    }
    JsonValueUtil::ParseValueIfHas(lane, DICT_KEY_LANE_DURATION, m_duration);

    SINGLETON(HmcUidAdmin)->SetLane(m_laneUid, this);

    Json::Value assets = lane[DICT_KEY_LANE_ASSET];
    for (const auto &asset : assets) {
        IHmcAsset *assetItem = CreateAsset(asset);
        if (assetItem) {
            assetItem->SetLaneUid(m_laneUid);
            m_assetList.emplace_back(assetItem->GetUid());
        }
    }

    std::sort(m_assetList.begin(), m_assetList.end(), CompareAssetList);

    return TRUE;
}

HmcUid HmcLane::CreateAsset(const HmcDict *dict)
{
    HMC_TRACE_GUARD("CreateAsset");
    if (dict == nullptr) {
        LOGE("dict null");
        return HMC_UID_NULL;
    }

    IHmcAsset *asset = CreateAssetEntity();
    if (!asset) {
        LOGE(" create asset entity failed");
        return HMC_UID_NULL;
    }

    if (asset->Init(dict) != TRUE) {
        LOGE("asset init failed");
        delete asset;
        return HMC_UID_NULL;
    }

    INT32 error = SetAssetSource(dict, asset);
    if (error != HMC_OK) {
        LOGE(" set asset property failed: %d", error);
        delete asset;
        return HMC_UID_NULL;
    }

    INT64 startTime = 0;
    HmcDictGetInt64(dict, DICT_KEY_ASSET_PROPERTY_START, &startTime);
    startTime = HMC_MAX(startTime, 0);
    startTime = HmcTimeUtil::NormalizeTime(startTime);
    error = InsertAsset(asset->GetUid(), startTime);
    if (error != HMC_OK) {
        STRING assetInfo;
        UINT32 seq = 0;
        for (const auto &uid : m_assetList) {
            auto existAsset = SINGLETON(HmcUidAdmin)->GetAsset(uid);
            if (existAsset != nullptr) {
                assetInfo += HmcStringFormat("[%d]%ld-%ld ", seq, existAsset->GetStartTime(), existAsset->GetEndTime());
                ++seq;
            }
        }
        LOGE("insert asset fail, new asset:%ld-%ld, exist asset:%s.", startTime, asset->GetEndTime(),
            assetInfo.c_str());
        delete asset;
        return HMC_UID_NULL;
    }

    asset->SetStartTime(startTime);

    // 设置其它属性
    asset->SetAssetParamValue(dict);

    // 更新连续泳道中的新增asset后面的asset的时间信息
    UpdateLane();

    return asset->GetUid();
}

void HmcLane::DestroyAsset(const HmcUid &assetUid)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    for (auto iter = m_assetList.begin(); iter != m_assetList.end(); iter++) {
        if (HmcUidIsEqual(&(*iter), &assetUid)) {
            m_assetList.erase(iter);
            break;
        }
    }

    delete asset;

    UpdateLane();
}

int32_t HmcLane::InsertAsset(const HmcUid &assetUid, uint64_t startTime)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("insert asset to lane failed, get asset object by assetUid failed");
        return HMC_ERR_PARAM;
    }

    return InsertAsset(asset, startTime);
}

void HmcLane::RemoveAsset(const HmcUid &assetUid)
{
    for (auto iter = m_assetList.begin(); iter != m_assetList.end(); iter++) {
        if (HmcUidIsEqual(&assetUid, &(*iter))) {
            m_assetList.erase(iter);
            break;
        }
    }

    UpdateLane();
}

void HmcLane::ClearAsset()
{
    for (const auto &assetUid : m_assetList) {
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
        if (asset != nullptr) {
            delete asset;
        }
    }

    m_assetList.clear();

    UpdateLane();
}

bool HmcLane::MoveAsset(const HmcUid &assetUid, uint64_t startTime)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("move asset in lane failed, get asset object by assetUid failed");
        return FALSE;
    }

    return MoveAsset(asset, startTime);
}

HmcUid HmcLane::GetAsset(uint64_t timestamp) const
{
    for (const auto &assetUid : m_assetList) {
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
        if (asset != nullptr && asset->IsDrawable(timestamp)) {
            return assetUid;
        }
    }

    return HMC_UID_NULL;
}

void HmcLane::GetAssetList(VECTOR<HmcUid> &assetList) const
{
    assetList.clear();
    for (const HmcUid &assetUid : m_assetList) {
        assetList.push_back(assetUid);
    }
}

IHmcAsset *HmcLane::CreateAssetEntity()
{
    return new (std::nothrow) HmcImageAsset(m_laneUid, m_eventHandler);
}

bool HmcLane::CompareAssetList(const HmcUid &first, HmcUid &second)
{
    IHmcAsset *entity1 = SINGLETON(HmcUidAdmin)->GetAsset(first);
    IHmcAsset *entity2 = SINGLETON(HmcUidAdmin)->GetAsset(second);
    if (entity1 == nullptr || entity2 == nullptr) {
        return FALSE;
    }

    return (entity1->GetStartTime() < entity2->GetStartTime());
}

int32_t HmcLane::ReplaceSource(const HmcDict *dict, const std::string &path)
{
    if (m_assetList.empty() || !m_visible) {
        return HMC_ERR;
    }

    int32_t result = HMC_OK;
    for (const auto &i : m_assetList) {
        auto asset = SINGLETON(HmcUidAdmin)->GetAsset(i);
        if (asset != nullptr) {
            return asset->ReplaceSource(path);
        }
    }
    return HMC_OK;
}

int32_t HmcLane::SetAssetSource(const HmcDict *dict, IHmcAsset *asset)
{
    if (dict == nullptr || asset == nullptr) {
        LOGE("dict or asset null");
        return HMC_ERR;
    }

    auto path = HmcDictGetString(dict, DICT_KEY_ASSET_PROPERTY_PATH);
    void* pixelBuffer;
    HmcDictGetPointer(dict, DICT_KEY_THUMBNAIL_LCD_PIXELMAP, &pixelBuffer);
    if (pixelBuffer != nullptr) {
        LOGI("SetAssetSource by pixelBuffer");
        OH_PixelmapNative *pixelmap = (OH_PixelmapNative *) pixelBuffer;
        OH_Pixelmap_ImageInfo *imageInfo = nullptr;
        OH_PixelmapImageInfo_Create(&imageInfo);
        auto image = new (std::nothrow) Image();
        OH_PixelmapNative_GetImageInfo(pixelmap, imageInfo);
        OH_PixelmapImageInfo_GetWidth(imageInfo, &image->width);
        OH_PixelmapImageInfo_GetHeight(imageInfo, &image->height);
        OH_PixelmapImageInfo_GetRowStride(imageInfo, &image->stride);
        image->stride = image->stride / g_four;
        image->nativePixelmap = pixelmap;
        OH_PixelmapImageInfo_Release(imageInfo);
        SHARED_PTR<Image> composeImage = SHARED_PTR<Image>(image);
        return asset->SetSource(composeImage);
    }
    
    if (path != nullptr && path != "") {
        INT32 isMediaSource = 0;
        INT32 isSupportWaterMark = 0;
        HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_IS_MEDIA_SOURCE, &isMediaSource);
        HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_IS_SUPPORT_WATERMARK, &isSupportWaterMark);
        std::string editData = HmcDictGetString(dict, DICT_KEY_ASSET_PROPERTY_EDIT_DATA);
        asset->SetExportWidthAndHeight(editData, isMediaSource);
        LOGI("SetAssetSource by path");
        return asset->SetSource(STRING(path), FALSE, isSupportWaterMark == 1);
    }
}

int32_t HmcLane::PackGraphicsRenderInfo(uint64_t timestamp, std::shared_ptr<VideoRenderInfo> &renderInfo,
    bool exactMode)
{
    if (m_assetList.empty() || !m_visible) {
        return HMC_OK;
    }

    int32_t result = HMC_OK;
    for (const auto &i : m_assetList) {
        auto asset = SINGLETON(HmcUidAdmin)->GetAsset(i);
        if (asset == nullptr || !asset->IsDrawable(timestamp)) {
            continue;
        }

        result = asset->PackGraphicsRenderInfo(timestamp, renderInfo, exactMode);
        if (result != HMC_OK) {
            LOGE("Draw to SetRenderLayer failed, result = %d", result);
            return result;
        }
    }
    return result;
}

constexpr int32_t PREFETCH_FORWARD_TIME = 5000; // 单位ms

void HmcLane::OnAssetDurationChange(const HmcUid &assetUid)
{
    HMC_UNUSED(assetUid);

    UpdateLane();
}

void HmcLane::UpdateLane()
{
    uint64_t currentDuration = 0;

    if (!m_assetList.empty()) {
        INT64 endTime = 0;
        auto it = m_assetList.rbegin();
        auto asset = SINGLETON(HmcUidAdmin)->GetAsset(*it);
        if (asset != nullptr) {
            currentDuration = static_cast<uint64_t>(asset->GetEndTime() + 1);
        }
    }

    if (currentDuration != m_duration) {
        m_duration = currentDuration;
        m_eventHandler->OnEventNotify(HMC::EVENT_DURATION_CHANGE, nullptr, nullptr);
    }
}


bool HmcLane::IsEmpty(uint64_t startTime, uint64_t endTime) const
{
    for (const auto &uid : m_assetList) {
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(uid);
        if (asset == nullptr) {
            continue;
        }

        uint64_t assetStartTime = static_cast<uint64_t>(asset->GetStartTime());
        uint64_t assetEndTime = static_cast<uint64_t>(asset->GetEndTime());
        if ((assetStartTime >= startTime && assetStartTime <= endTime) ||
            (assetEndTime >= startTime && assetEndTime <= endTime) ||
            (assetStartTime <= startTime && assetEndTime >= endTime)) {
            return false;
        }
    }
    return true;
}

IHmcAsset *HmcLane::CreateAsset(const Json::Value &asset)
{
    IHmcAsset *assetObj = CreateAssetEntity();
    if (assetObj == nullptr) {
        LOGE("create asset entity failed");
        return nullptr;
    }

    if (assetObj->Deserialize(asset) != TRUE) {
        LOGE("deserialize asset by json failed");
        delete assetObj;
        return nullptr;
    }

    STRING path = assetObj->GetPath();
    if (!path.empty() && assetObj->SetSource(path, TRUE) != HMC_OK) {
        LOGE("set source to asset failed");
        delete assetObj;
        return nullptr;
    }

    return assetObj;
}

int32_t HmcLane::InsertAsset(IHmcAsset *asset, uint64_t startTime)
{
    auto duration = asset->GetDurationTime();
    if (!IsEmpty(startTime, duration)) {
        LOGE("lane space[%d ~ %d] is not empty, insert asset failed!", startTime, duration);
        return HMC_ERR;
    }

    auto insertLocation = std::find_if(m_assetList.begin(), m_assetList.end(), [startTime](const HmcUid &uid) {
        auto ass = SINGLETON(HmcUidAdmin)->GetAsset(uid);
        return (ass != nullptr && ass->GetStartTime() >= startTime);
    });
    if (insertLocation == m_assetList.end()) {
        m_assetList.emplace_back(asset->GetUid());
    } else {
        m_assetList.insert(insertLocation, asset->GetUid());
    }

    asset->SetLaneUid(m_laneUid);
    asset->SetStartTime(startTime);

    UpdateLane();

    return HMC_OK;
}

bool HmcLane::MoveAsset(IHmcAsset *asset, uint64_t startTime)
{
    // 如果素材在本泳道先删除这个素材，更新时间后，再插入复制后的素材
    uint64_t oldStartTime = static_cast<uint64_t>(asset->GetStartTime());

    RemoveAsset(asset->GetUid());

    if (!InsertAsset(asset, startTime)) {
        LOGE("move asset failed: insert asset to new time failed.");
        if (!InsertAsset(asset, oldStartTime)) {
            LOGE("insert asset to old time failed");
        }
        return FALSE;
    }

    UpdateLane();

    return TRUE;
}