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
#include "HveTimeline.h"
#include "Editor/HmcEditorImp.h"
#include "MediaCreative/HmcDict.h"
#include "MediaCreative/HmcEditor.h"
#include "MediaCreative/HmcUid.h"
#include "Project.h"
#include "../common/HmcDictHelper.h"
#include "log/HmcLog.h"
#include "ohos/common/HmcUidHelper.h"
#include "ohos/interface/ArrayBuffer.hpp"
#include "HmcService.h"
#include "../interface/IHmcLane.h"
#include "ohos/BackgroundTaskManager.h"
#include "../util/HveBridgeUtil.h"
#include "HveAssetOper.h"

#define JCMD(cmd, _json_) _json_["_cmd"] = #cmd
#define JONE(type, name) \
    JCMD(name, tojs);    \
    tojs[#name] = (type)params[#name]

constexpr char *SERIALIZE_ASSET_KEY = "asset";
constexpr char *SERIALIZE_CROP_RECT_LEFT = "crop_rect_left";
constexpr char *SERIALIZE_CROP_RECT_RIGHT = "crop_rect_right";
constexpr char *SERIALIZE_CROP_RECT_TOP = "crop_rect_top";
constexpr char *SERIALIZE_CROP_RECT_BOTTOM = "crop_rect_bottom";
constexpr char *SERIALIZE_CROP_OPR_AREA_LEFT = "crop_opr_area_left";
constexpr char *SERIALIZE_CROP_OPR_AREA_RIGHT = "crop_opr_area_right";
constexpr char *SERIALIZE_CROP_OPR_AREA_TOP = "crop_opr_area_top";
constexpr char *SERIALIZE_CROP_OPR_AREA_BOTTOM = "crop_opr_area_bottom";
constexpr char *SERIALIZE_CROP_LIMITATION_RECT_LEFT = "crop_limitation_rect_left";
constexpr char *SERIALIZE_CROP_LIMITATION_RECT_RIGHT = "crop_limitation_rect_right";
constexpr char *SERIALIZE_CROP_LIMITATION_RECT_TOP = "crop_limitation_rect_top";
constexpr char *SERIALIZE_CROP_LIMITATION_RECT_BOTTOM = "crop_limitation_rect_bottom";
constexpr int RGBA_SIZE = 4;

static std::map<std::string, std::function<void(HmcEditor *, Json::Value &, Json::Value &)>> timeline_attr_excuter = {
    { "play",
      [](HmcEditor *editor, Json::Value &value, Json::Value &ret) {
        HmcEditorPlay(editor, value["startTime"].asInt64(), value["endTime"].asInt64());
        ret["playing"] = true;
    } },
    { "pause",
      [](HmcEditor *editor, Json::Value &value, Json::Value &ret) {
        HmcEditorPause(editor);
        ret["pause"] = true;
    } },
    { "seekto",
      [](HmcEditor *editor, Json::Value &value, Json::Value &ret) {
        HmcEditorSeekTo(editor, value["timestamp"].asInt64(), value["isExactMode"].asInt64());
        ret["playPos"] = value;
    } }
};

VOID HveTimeline::HandleRealTimeThumbnail(HveTimeline *timeline, HmcEditor *editor, HmcDict *eventMsg)
{
    HmcDictHelper params(eventMsg);
    std::string laneId = params[DICT_KEY_THUMBNAIL_LANE_ID].AsUid();
    std::string assetId = params[DICT_KEY_THUMBNAIL_ASSET_ID].AsUid();
    int64_t timestamp = params[DICT_KEY_THUMBNAIL_TIMESTAMP];

    // thumbnail这里不销毁，HmcEditorImp中回调结束后，会销毁eventMsg，销毁eventMsg的时候，会销毁掉thumbnail对象，所以这里不能重复释放.
    auto thumbnail = params["thumbnail"].AsPointer<HmcImage>();

    LOGD("[NotifyCallback] HMC_EVENT_THUMBNAIL_UPDATE, timestamp: %lld", timestamp);

    return;
}

VOID HveTimeline::HandleFilterThumbnail(HveTimeline *timeline, HmcEditor *editor, HmcDict *eventMsg)
{
    HmcDictHelper params(eventMsg);
    std::string laneId = params[DICT_KEY_THUMBNAIL_LANE_ID].AsUid();
    std::string assetId = params[DICT_KEY_THUMBNAIL_ASSET_ID].AsUid();
    std::string filterId = params[DICT_KEY_THUMBNAIL_FILTER_ID];
    int64_t timestamp = params[DICT_KEY_THUMBNAIL_TIMESTAMP];
    HmcImage *thumbnail = params[DICT_KEY_THUMBNAIL_FILTER_RESULT].AsPointer<HmcImage>();

    HmcImageBase *imageBase = (HmcImageBase *)thumbnail;
    if (!imageBase) {
        return;
    }
    SHARED_PTR<Image> rgbaThumbnail = imageBase->ConvertToImage();
    if (rgbaThumbnail == nullptr) {
        LOGE("Convert thumbnail to pixel buffer failed");
        return;
    }
    HmcPixelMapInfo *info = nullptr;
    auto filterThumbnailCallback = timeline->getFilterThumbnailCallback();
    if (filterThumbnailCallback == nullptr) {
        LOGW("getFilterThumbnailCallback is null, Destroy thumbnail");
    } else {
        info = ConvertPixelmapNativeToNapi(rgbaThumbnail->nativePixelmap, rgbaThumbnail->width, rgbaThumbnail->height);
        rgbaThumbnail->nativePixelmap = nullptr;
        filterThumbnailCallback(laneId, assetId, filterId.c_str(), timestamp, info->pixelmapNapi, rgbaThumbnail->width,
            rgbaThumbnail->height);
        delete info;
    }
    LOGD("RequestFilterThumbnail callback to UI timestamp=%ld, filterId=%s, width=%d, height=%d", timestamp,
        filterId.c_str(), rgbaThumbnail->width, rgbaThumbnail->height);
}

static void EventJudge(HmcEventId eventId, auto timeline, HmcEditor *editor, HmcDict *eventMsg)
{
    HmcDictHelper params(eventMsg);
    Json::Value tojs;
    switch (eventId) {
        case HMC_EVENT_THUMBNAIL_UPDATE:
            timeline->HandleRealTimeThumbnail(timeline, editor, eventMsg);
            break;
        case HMC_EVENT_FILTER_THUMBNAIL_UPDATE:
            timeline->HandleFilterThumbnail(timeline, editor, eventMsg);
            break;
        case HMC_EVENT_XTStyle_THUMBNAIL_UPDATE:
            timeline->HandleXTStyleThumbnail(timeline, editor, eventMsg);
            break;
        case HMC_EVENT_PLAY_STATE_CHANGE:
            JONE(int, playState);
            break;
        case HMC_EVENT_DURATION_CHANGE:
            JONE(int64_t, duration);
            break;
        case HMC_EVENT_PLAY_POS_CHANGE:
            JONE(int64_t, playPos);
            break;
        case HMC_EVENT_EXPORT_PROGRESS_CHANGE:
            JONE(int, exportProgress);
            break;
        case HMC_EVENT_IMPORT_RESULT_NOTIFY:
            JONE(int, importResult);
            break;
        case HMC_EVENT_EXPORT_RESULT_NOTIFY:
            JONE(int, exportResult);
            break;
        default:
            break;
    }

    if (!tojs.empty()) {
        auto callback = timeline->getCommonCallback();
        Json::FastWriter fastWriter;
        if (nullptr != callback) {
            callback(fastWriter.write(tojs));
        }
    }
}

static void NotifyCallback(HmcEditor *editor, HmcEventId eventId, HmcDict *eventMsg, void *userData)
{
    auto timeline = (HveTimeline *)userData;
    if (timeline == nullptr) {
        LOGE("NotifyCallback callback timeline is null!");
        return;
    }

    EventJudge(eventId, timeline, editor, eventMsg);
}

HveTimeline::HveTimeline(int id, HmcUid projectUid, int mediaType,
    std::function<void(std::string const & jsonPos)> sdkCallback,
    std::function<void(std::string const & jsonPos)> createResult, std::string const & editData)
    : timelineId(id), commonCallback(sdkCallback)
{
    m_isClosed = false;
    m_cropRect = HmcRectD(0, 0, 0, 0);
    m_cropOperationArea = HmcRectD(0, 0, 0, 0);
    cropLimitation = HmcRectD(0, 0, 0, 0);
    xtStyleThumbnailCallback = nullptr;
    Init(id, projectUid, mediaType, createResult, editData);
}

HveTimeline::~HveTimeline()
{
    thumbnailCallback = nullptr;
    filterThumbnailCallback = nullptr;
    xtStyleThumbnailCallback = nullptr;
    for (const auto &asset : m_assets) {
        delete asset.second;
    }

    m_lanes.clear();
    m_assets.clear();
}

void HveTimeline::Init(int id, HmcUid projectUid, int mediaType,
    std::function<void(std::string const & jsonPos)> createResult, std::string const & editData)
{
    LOGD("CPP consustrct Timeline");

    m_assetChangeCb = [&]() { Notify(); };
    // 创建Editor
    HmcEditMediaType type =
        mediaType == 0 ? HmcEditMediaType::HMC_EDIT_MEDIA_TYPE_VIDEO : HmcEditMediaType::HMC_EDIT_MEDIA_TYPE_IMAGE;
    m_hmcEditor = HmcEditorOpen(projectUid, type, NotifyCallback, this, editData);
    HmcEditorSetAutoFlush(GetEditor(), false); // 等剪辑数据准备好后，再刷新
    // 如果是草稿打开，需要反序列化bridge数据，再刷新，新工程此处不需刷新，在创建剪辑接口时，会自动刷新
    // 使用线程，
    LOGD("CPP start initialze in Thread");
    BACKGROUND_TASK_MGR->Submit([this, createResult] {
        LOGD("CPP Thread callback");
        Json::Value json;
        Json::FastWriter fastWriter;
        JCMD(timeline_create_completed, json);
        json["id"] = timelineId;
        json["projectId"] = (const char *)HmcUidHelper(HmcEditorGetProjectId(GetEditor()));
        json["duration"] = HmcEditorGetDuration(GetEditor());
        json["result"] = HMC_OK;
        if (createResult != nullptr) {
            createResult(fastWriter.write(json));
        }
    },
        __FUNCTION__);
}

HmcUid HveTimeline::AppendLane(HmcLaneType type)
{
    HmcUid laneId = HmcLaneCreate(GetEditor(), type);
    if (!HmcUidIsNull(&laneId)) {
        m_lanes.push_back(laneId);
    }
    return laneId;
}

Json::Value HveTimeline::getVideoLanes()
{
    // 返回Lane简要信息
    Json::Value ret;
    for (const auto &laneUid : m_lanes) {
        IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
        if ((lane == nullptr) || (lane->GetType() != HMC_LANE_VISION)) {
            continue;
        }

        Json::Value temp;
        temp["tid"] = timelineId;
        temp["uid"] = (std::string)HmcUidHelper(laneUid);
        temp["mute"] = HmcLaneIsMute(GetEditor(), laneUid);
        ret.append(temp);
    }
    return ret;
}

Json::Value HveTimeline::modify(Json::Value changedAttr)
{
    Json::Value ret;
    Json::Value::Members members = changedAttr.getMemberNames();
    for (auto iter = members.begin(); iter != members.end(); iter++) {
        if (timeline_attr_excuter.find(*iter) == timeline_attr_excuter.end()) {
            continue;
        }
        Json::Value temp;
        Json::Reader reader;
        if (!reader.parse(changedAttr[*iter].asString(), temp)) {
            continue;
        }
        timeline_attr_excuter[*iter](GetEditor(), temp, ret);
    }
    return ret;
}

void HveTimeline::PositionCalculation(HmcUid *assetUid, int index, Json::Value &temp, auto asset)
{
    float rotationX = 0.0f;
    HmcAssetGetRotation(GetEditor(), assetUid[index], &rotationX, HMC_AXIS_X);
    float rotationY = 0.0f;
    HmcAssetGetRotation(GetEditor(), assetUid[index], &rotationY, HMC_AXIS_Y);
    float rotationZ = 0.0f;
    HmcAssetGetRotation(GetEditor(), assetUid[index], &rotationZ, HMC_AXIS_Z);

    temp["rotationX"] = rotationX;
    temp["rotationY"] = rotationY;
    temp["extraRotation"] = rotationZ - asset->GetBaseRotation();
    temp["cropRectLeft"] = m_cropRect.left;
    temp["cropRectTop"] = m_cropRect.top;
    temp["cropRectRight"] = m_cropRect.right;
    temp["cropRectBottom"] = m_cropRect.bottom;
}

Json::Value HveTimeline::GetAssetFromUid(HmcUid *assetUid, int count)
{
    Json::Value ret;
    for (int i = 0; i < count; i++) {
        HmcSize originalSize;
        HmcAssetGetSize(GetEditor(), assetUid[i], HMC_SIZE_ORIGINAL, &originalSize);
        int64_t originalDuration = HmcAssetGetFileDuration(GetEditor(), assetUid[i]);
        double fps = 0.0f;
        HmcAssetGetVideoFps(GetEditor(), assetUid[i], &fps);
        int32_t bitRate;
        HmcAssetGetVideoBitRate(GetEditor(), assetUid[i], &bitRate);
        char path[PATH_MAX] = {0};
        HmcGetAssetResource(GetEditor(), assetUid[i], path, PATH_MAX);
        int isMute = 0;
        HmcAssetIsMute(GetEditor(), assetUid[i], &isMute);
        int mirror = 0;
        HmcAssetGetMirror(GetEditor(), assetUid[i], HMC_ASSET_MIRROR_HORIZONTAL, &mirror);
        auto asset = GetHveAsset(assetUid[i]);
        if (asset == nullptr) {
            LOGE("get bridge asset fail");
            continue;
        }
        Json::Value temp;
        temp["uid"] = (std::string)HmcUidHelper(assetUid[0]);
        temp["originalWidth"] = originalSize.width;
        temp["originalHeight"] = originalSize.height;
        temp["originalDuration"] = originalDuration;
        temp["originalFps"] = fps;
        temp["originalBitRate"] = bitRate;
        temp["clipRatio"] = asset->GetRatio();
        temp["chooseRatio"] = asset->GetChooseRatio();
        temp["isAssetPosChange"] = asset->IsAssetPosChange(DEVIATION);
        temp["speed"] = 1.0f;
        temp["masterTape"] = asset->GetVideoInnerAudioVolume();
        temp["trimIn"] = asset->GetTrimIn();
        temp["trimOut"] = asset->GetTrimOut();
        temp["isMute"] = isMute;
        temp["mirror"] = mirror;
        temp["path"] = std::string(path);
        temp["startTime"] = HmcAssetGetStartTime(GetEditor(), assetUid[i]);
        temp["endTime"] = HmcAssetGetEndTime(GetEditor(), assetUid[i]);
        PositionCalculation(assetUid, i, temp, asset);
        temp["adjust"] = asset->GetAdjustInfo();
        temp["isPreviewMode"] = asset->GetInPreviewMode();
        SetWatermarkInfo(temp, asset);
        ret.append(temp);
    }
    return ret;
}

void HveTimeline::SetWatermarkInfo(Json::Value &temp, auto asset)
{
    temp["watermarkType"] = asset->GetWatermarkType();
    temp["isContainShotParm"] = asset->GetContainShotParmFlag();
    temp["isContainShotDate"] = asset->GetContainShotDateFlag();
    temp["filterShotSign"] = asset->GetFilterShotSign();
    temp["isContainColorParam"] = asset->GetContainXtStyleFlag();
    temp["isContainLocationParam"] = asset->GetContainShotLocationFlag();
    temp["locationParam"] = asset->GetFilterShotLocation();
    temp["customText"] = asset->GetFilterUserInput();
    temp["festivalParam"] = asset->GetFilterTemplate();
    temp["frameBackground"] = asset->GetFilterBackgroundType();
    temp["frameColor"] = asset->GetFilterBackgroundColor();
    temp["frameTextStr"] = asset->GetFilterCustomText();
    LOGI("SetWatermarkInfo. isContainLocationParam is %d, locationParam is %s, customText is %s", 
         asset->GetContainShotLocationFlag(), asset->GetFilterShotLocation().c_str(),
         asset->GetFilterUserInput().c_str());
}

bool HveTimeline::SetApertureVal(Json::Value &temp, auto asset, HmcUid assetUid)
{

    if (asset == nullptr) {
        LOGW("asset is nullptr");
        return false;
    }
    IHmcAsset *iHmcAsset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (iHmcAsset == nullptr) {
        LOGE("get asset object failed, please check your asset id");
        return false;
    }
    DOUBLE positionX = 0.0;
    DOUBLE positionY = 0.0;
    INT32 fNum = -1;
    asset->GetWideApertureParam(positionX, positionY, fNum);
    if (fNum < 0) {
        LOGI("get fNum from camera");
    }
    if (fNum < 0) {
        LOGW("fNum lower than 0");
        return false;
    }
    FLOAT downSampleScale = ((HmcImageAsset *)iHmcAsset)->GetDownSampleScale();
    if (downSampleScale <= 0) {
        downSampleScale = 1;
    }
    Json::Value apertureVal;
    positionX = positionX * 1.0 / downSampleScale;
    positionY = positionY * 1.0 / downSampleScale;
    apertureVal["positionX"] = positionX;
    apertureVal["positionY"] = positionY;
    apertureVal["fNum"] = fNum;
    temp["apertureVal"] = apertureVal;
    LOGI("SetApertureVal positionX is %f, positionY is %f, fNum is %d", positionX, positionY, fNum);
    return true;
}

Json::Value HveTimeline::getAssets()
{
    Json::Value ret;
    if (m_lanes.empty()) {
        LOGE("HveTimeline getAssets failed, because lanes is empty");
        return ret;
    }
    HmcUid laneUid = m_lanes.at(0);
    int count = HmcLaneGetAssetCount(GetEditor(), laneUid);
    if (count == 0) {
        return ret;
    }

    HmcUid *assetUid = new HmcUid[count];
    HmcLaneGetAssetArr(GetEditor(), laneUid, assetUid, &count);
    ret = GetAssetFromUid(assetUid, count);

    delete[] assetUid;
    return ret;
}

Json::Value HveTimeline::SerializeBridgeData()
{
    Json::Value assetInfo;
    auto it = std::find_if(m_assets.begin(), m_assets.end(), [](const auto &asset) { return asset.second != nullptr; });
    if (it != m_assets.end()) {
        assetInfo = it->second->Serialize();
    }
    Json::Value result;

    result[SERIALIZE_ASSET_KEY] = assetInfo;
    result[SERIALIZE_CROP_RECT_LEFT] = m_cropRect.left;
    result[SERIALIZE_CROP_RECT_RIGHT] = m_cropRect.right;
    result[SERIALIZE_CROP_RECT_TOP] = m_cropRect.top;
    result[SERIALIZE_CROP_RECT_BOTTOM] = m_cropRect.bottom;
    result[SERIALIZE_CROP_OPR_AREA_LEFT] = m_cropOperationArea.left;
    result[SERIALIZE_CROP_OPR_AREA_RIGHT] = m_cropOperationArea.right;
    result[SERIALIZE_CROP_OPR_AREA_TOP] = m_cropOperationArea.top;
    result[SERIALIZE_CROP_OPR_AREA_BOTTOM] = m_cropOperationArea.bottom;
    result[SERIALIZE_CROP_LIMITATION_RECT_LEFT] = cropLimitation.left;
    result[SERIALIZE_CROP_LIMITATION_RECT_RIGHT] = cropLimitation.right;
    result[SERIALIZE_CROP_LIMITATION_RECT_TOP] = cropLimitation.top;
    result[SERIALIZE_CROP_LIMITATION_RECT_BOTTOM] = cropLimitation.bottom;

    return result;
}

void HveTimeline::DeserializeBridgeData(Json::Value data)
{
    if (data.isMember(SERIALIZE_ASSET_KEY)) {
        if (data[SERIALIZE_ASSET_KEY].type() != Json::objectValue) {
            LOGE("Incorrect JSON character string");
            return;
        }

        Json::Value assetInfo = data[SERIALIZE_ASSET_KEY];

        auto it =
            std::find_if(m_assets.begin(), m_assets.end(), [](const auto &asset) { return asset.second != nullptr; });
        if (it != m_assets.end()) {
            it->second->Deserialize(assetInfo);
        }
    }

    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_RECT_LEFT, m_cropRect.left);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_RECT_RIGHT, m_cropRect.right);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_RECT_TOP, m_cropRect.top);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_RECT_BOTTOM, m_cropRect.bottom);

    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_OPR_AREA_LEFT, m_cropOperationArea.left);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_OPR_AREA_RIGHT, m_cropOperationArea.right);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_OPR_AREA_TOP, m_cropOperationArea.top);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_OPR_AREA_BOTTOM, m_cropOperationArea.bottom);

    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_LIMITATION_RECT_LEFT, cropLimitation.left);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_LIMITATION_RECT_RIGHT, cropLimitation.right);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_LIMITATION_RECT_TOP, cropLimitation.top);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_LIMITATION_RECT_BOTTOM, cropLimitation.bottom);

    m_cropRectDefault = m_cropRect;
}

void HveTimeline::SyncDataFromServiceOnly()
{
    for (const auto &item : m_assets) {
        if (item.second->GetType() != HMC_ASSET_IMAGE) {
            continue;
        }
        item.second->SyncDataFromService();
    }
}

void HveTimeline::SyncDataFromService()
{
    int count = HmcLaneGetCount(GetEditor(), HMC_LANE_VISION);
    if (count == 0) {
        return;
    }
    auto laneUid = new HmcUid[count];
    HmcLaneGetArr(GetEditor(), HMC_LANE_VISION, laneUid, &count);

    for (int i = 0; i < count; i++) {
        m_lanes.emplace_back(laneUid[i]);

        auto lane = IHmcLane::QueryLaneObj(laneUid[i]);
        if (lane == nullptr) {
            continue;
        }

        std::vector<HmcUid> assetUidList;
        lane->GetAssetList(assetUidList);
        m_assets.clear();
        for (const auto &assetUid : assetUidList) {
            auto type = HmcAssetGetType(GetEditor(), assetUid);
            auto asset = new (std::nothrow) HveAsset(GetEditor(), assetUid, type, m_assetChangeCb);
            m_assets.insert(std::pair<HmcUid, HveAsset *>(assetUid, asset));
            asset->SyncDataFromService();
        }
    }

    delete[] laneUid;
}

void HveTimeline::SyncCropDataFromService(const HmcUid &mainAssetUid)
{
    HmcUid effectUid = HMC_UID_NULL;
    int result = HmcEffectGetEffects(GetEditor(), mainAssetUid, HMC_EFFECT_TRANSFORM, &effectUid, 1);
    if (result != HMC_OK) {
        LOGE("get transform effect failed with result: %d", result);
        return;
    }

    HmcDictHelper dictHelper;
    result = HmcEffectGetProperty(GetEditor(), effectUid, dictHelper);
    if (result != HMC_OK) {
        LOGE("get transform effect property failed with result: %d", result);
        return;
    }

    double leftBottomX = 0.0;
    double leftBottomY = 0.0;
    double rightTopX = 1.0;
    double rightTopY = 1.0;

    leftBottomX = dictHelper[PROJECT_KEY_TRANSFORM_CROP_LB_X];
    leftBottomY = dictHelper[PROJECT_KEY_TRANSFORM_CROP_LB_Y];
    rightTopX = dictHelper[PROJECT_KEY_TRANSFORM_CROP_RT_X];
    rightTopY = dictHelper[PROJECT_KEY_TRANSFORM_CROP_RT_Y];

    float canvasWidth, canvasHeight;
    result = HmcEditorGetCanvasSize(GetEditor(), &canvasWidth, &canvasHeight);
    if (result != HMC_OK) {
        LOGE("HmcEditorGetCanvasSize failed with error: %d", result);
        return;
    }

    m_cropRect.left = canvasWidth * leftBottomX;
    m_cropRect.right = canvasWidth * rightTopX;

    m_cropRect.top = canvasHeight * (1 - rightTopY);
    m_cropRect.bottom = canvasHeight * (1 - leftBottomY);

    m_cropRectDefault = m_cropRect;

    SetCropRectSize(m_cropRect);
}

void HveTimeline::Reset()
{
    if (m_assets.empty()) {
        LOGW("asset list is empty, not need to reset.");
        return;
    }

    HveAsset* mainAsset = m_assets.begin()->second;
    if (mainAsset == nullptr) {
        LOGE("main asset is invalid.");
        return;
    }

    HmcEditorSetAutoFlush(GetEditor(), false);

    mainAsset->Reset();
    isDefaultConfig = true;

    HmcSize originalSize;
    HmcAssetGetSize(GetEditor(), mainAsset->GetAssetUid(), HMC_SIZE_ORIGINAL, &originalSize);
    float assetRatio = originalSize.width / originalSize.height;

    HmcRectD cropRect(0, 0, 0, 0);
    HveBridgeUtil::GetCenterInsideRectUnderRatio(assetRatio, m_cropOperationArea, &cropRect);
    LOGD("SetCropRectInner Init cropRect=%lf,%lf,%lf,%lf", cropRect.left, cropRect.top, cropRect.right,
        cropRect.bottom);
    SetCropRect(cropRect);
    SetCropLimitation(cropRect);
    SetCropRectDefault(cropRect);

    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(GetEditor(), &canvasWidth, &canvasHeight);

    double posX = cropRect.CenterX() - canvasWidth / 2;
    double posY = canvasHeight / 2 - cropRect.CenterY();
    double width = cropRect.Width();
    double height = cropRect.Height();

    HmcAssetSetPositionByCenter(GetEditor(), mainAsset->GetAssetUid(), posX, posY);
    HmcSize size;
    size.width = width;
    size.height = height;
    HmcAssetSetSize(GetEditor(), mainAsset->GetAssetUid(), size);

    mainAsset->SetAssetInitSize(width, height);
    mainAsset->SetAssetInitPosXY(posX, posY);

    if (mainAsset->GetInPreviewMode()) {
        mainAsset->UpdatePreviewMode(cropRect, GetCropOperationArea());
    } else {
        mainAsset->UpdateCropMode();
    }

    HmcEditorSetAutoFlush(GetEditor(), true);
}

void HveTimeline::AppendAsset(HmcUid assetUid, HmcAssetType type)
{
    auto asset = new (std::nothrow) HveAsset(GetEditor(), assetUid, type, m_assetChangeCb);
    m_assets.insert(std::pair<HmcUid, HveAsset *>(assetUid, asset));
}

void HveTimeline::ClearAssets()
{
    m_assets.clear();
}

void HveTimeline::SetConfigChangeCallback(std::function<void(bool)> callback)
{
    m_configChangeCallback = callback;
}

void HveTimeline::CalConfigChangeCallback()
{
    Notify();
}

void HveTimeline::Notify()
{
    if (m_configChangeCallback == nullptr) {
        LOGD("config change call back is null.");
        return;
    }

    bool defaultConfig = ((fabsf(m_cropRectDefault.Width() - cropRectWidth) < 0.01) &&
        (fabsf(m_cropRectDefault.Height() - cropRectHeight) < 0.01));
    if (defaultConfig) {
        defaultConfig = std::all_of(m_assets.begin(), m_assets.end(),
            [&](const auto &item) { return (item.second == nullptr || item.second->IsDefaultConfig()); });
    }

    // 素材是否默认值的状态没有改变时，不用回调UI
    if (isDefaultConfig == defaultConfig) {
        return;
    }

    isDefaultConfig = defaultConfig;
    m_configChangeCallback(defaultConfig);
}

void HveTimeline::SetCropRect(const HmcRectD &rect)
{
    m_cropRect = rect;
    SetCropRectSize(rect);
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(GetEditor(), &canvasWidth, &canvasHeight);
    for (const auto &item : m_assets) {
        if (item.second->GetType() != HMC_ASSET_IMAGE) {
            continue;
        }

        float left = m_cropRect.left / canvasWidth;
        float top = 1 - m_cropRect.top / canvasHeight;
        float right = m_cropRect.right / canvasWidth;
        float bottom = 1 - m_cropRect.bottom / canvasHeight;
        HmcAssetSetCropPosition(item.first.GetUid(), left, top, right, bottom);
    }
}

void HveTimeline::SetCropRectDefault(const HmcRectD &rect)
{
    m_cropRectDefault = rect;
}

void HveTimeline::SwitchPreviewMode()
{
    for (const auto &item : m_assets) {
        if (item.second != nullptr) {
            item.second->SwitchPreviewMode(m_cropRect, m_cropOperationArea);
        }
    }

    auto editorImp = static_cast<HmcEditorImp *>(GetEditor());
    if (editorImp != nullptr) {
        editorImp->OnDisplayAreaChanged();
    }
}

void HveTimeline::UpdateCompileParameter(bool isSave)
{
    for (const auto &item : m_assets) {
        if (item.second != nullptr) {
            item.second->UpdateTransformInfo(m_cropRect, m_cropOperationArea, isSave);
            item.second->HandleVignetForSave(isSave);
        }
    }
}

void HveTimeline::SetXTStyleThumbnailCallback(HmcXTStyleThumbCallbackFunc cb)
{
    xtStyleThumbnailCallback = cb;
}

HmcXTStyleThumbCallbackFunc HveTimeline::GetXTStyleThumbnailCallback()
{
    return xtStyleThumbnailCallback;
}

/**
 * 返回个性风格缩略图
 * @param timeline
 * @param editor
 * @param eventMsg
 */
void HveTimeline::HandleXTStyleThumbnail(HveTimeline *timeline, HmcEditor *editor, HmcDict *eventMsg)
{
    HmcDictHelper params(eventMsg);
    int32_t xtStyleId = params[DICT_KEY_THUMBNAIL_FILTER_ID];
    HmcImage *thumbnail = params[DICT_KEY_THUMBNAIL_FILTER_RESULT].AsPointer<HmcImage>();
    
    HmcImageBase *imageBase = (HmcImageBase *)thumbnail;
    if (imageBase == nullptr) {
        LOGE("HandleXTStyleThumbnail thumbnail is nullptr");
        return;
    }
    SHARED_PTR<Image> rgbaThumbnail = imageBase->ConvertToImage();
    if (rgbaThumbnail == nullptr) {
        LOGE("HandleXTStyleThumbnail Convert thumbnail to pixel buffer failed");
        return;
    }
    
    HmcPixelMapInfo *info = nullptr;
    auto xtStyleThumbnailCallback = timeline->GetXTStyleThumbnailCallback();
    if (xtStyleThumbnailCallback == nullptr) {
        LOGW("GetXTStyleThumbnailCallback is null, Destroy thumbnail");
    } else {
        info = ConvertPixelmapNativeToNapi(rgbaThumbnail->nativePixelmap, rgbaThumbnail->width, rgbaThumbnail->height);
        rgbaThumbnail->nativePixelmap = nullptr;
        xtStyleThumbnailCallback(info->pixelmapNapi, std::to_string(xtStyleId));
        delete info;
    }
}