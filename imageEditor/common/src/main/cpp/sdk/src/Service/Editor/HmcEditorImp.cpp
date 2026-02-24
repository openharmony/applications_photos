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

#include "Editor/HmcEventHandler.h"
#include "MediaCreative.h"
#include "HmcBase.h"
#include "HmcService.h"
#include "Editor/Preview/HmcPreviewEngineItf.h"
#include "Editor/Export/HmcExportEngineItf.h"
#include "MediaCreative/HmcUid.h"
#include "common/HmcSingleton.h"
#include "./Project/HmcProjectEntity.h"

#include <multimedia/image_effect/image_effect.h>

using HmcNotifyMsg = struct HmcNotifyMsg {
    HmcEventId eventId;
    HmcDict *dictMsg;
};

HmcEditorImp::HmcEditorImp(HmcEditorCallback callback, void *userData)
    : m_callback(callback), m_userData(userData), m_projectId(HMC_UID_NULL)
{
    LOGI("[HmcEditor] HmcEditorImp create.");
}

HmcEditorImp::~HmcEditorImp()
{
    LOGI("~HmcEditorImp");

    if (GetState() == HMC_EDITOR_STATE_EXPORT) {
        CancelExporting();
    }
    LOGI("~HmcEditorImp cancel export end");

    Pause();

    if (m_previewEngine) { // 关闭前需要等待所有任务完成.
        m_previewEngine->Shutdown();
    }
    LOGI("~HmcEditorImp lane manager has been shutdown finish.");

    if (m_graphicsRenderEngine) {
        m_graphicsRenderEngine->Destroy();
    }
    LOGI("~HmcEditorImp graphics render engine has been shutdown finish.");
    
    if (m_offScreenRenderEngine) {
        m_offScreenRenderEngine->Destroy();
    }
    LOGI("~HmcEditorImp offScreenRenderEngine render engine has been shutdown finish.");

    if (m_laneManager) {
        m_laneManager = nullptr;
    }
    LOGI("~HmcEditorImp lane manager has been destroyed finish");

    if (m_stateMachine) {
        m_stateMachine = nullptr;
    }
    LOGI("~HmcEditorImp state machine has been destroyed finish");
    m_taskMgr->Wait();
    LOGI("~HmcEditorImp task manager wait all task finish.");
    
    LOGI("~HmcEditorImp HmcProjectEntity has been cleared");

    SINGLETON(HmcProjectEntity)->HmcProjectEntityClear();
    LOGI("~HmcEditorImp HmcProjectEntity has been cleared");
}

static VOID DestroyNotifyMsgThumbnailUpdate(const HmcNotifyMsg &notifyMsg)
{
    HmcImage *image = nullptr;
    HmcDictGetPointer(notifyMsg.dictMsg, "thumbnail", &image);
    if (image != nullptr) {
        HmcImageDestroy(image);
    }
}

static VOID DestroyNotifyMsgFilterThumbnail(const HmcNotifyMsg &notifyMsg)
{
    HmcImage *image = nullptr;
    HmcDictGetPointer(notifyMsg.dictMsg, DICT_KEY_THUMBNAIL_FILTER_RESULT, &image);
    if (image != nullptr) {
        HmcImageDestroy(image);
    }
}

static VOID DestroyNotifyMsg(const HmcNotifyMsg &notifyMsg)
{
    switch (notifyMsg.eventId) {
        case HMC_EVENT_THUMBNAIL_UPDATE: {
            DestroyNotifyMsgThumbnailUpdate(notifyMsg);
            break;
        }
        case HMC_EVENT_FILTER_THUMBNAIL_UPDATE: {
            DestroyNotifyMsgFilterThumbnail(notifyMsg);
            break;
        }
        case HMC_EVENT_XTStyle_THUMBNAIL_UPDATE: {
            DestroyNotifyMsgFilterThumbnail(notifyMsg);
            break;
        }
        default:
            break;
    }
    HmcDictDestroy(notifyMsg.dictMsg);
}

BOOL HmcEditorImp::Init(const HmcUid projectId, HmcEditMediaType mediaType, std::string const & editData)
{
    LOGI("[HmcEditor] HmcEditorImp init.");

    RegisterEventFuncs();

    m_taskMgr = std::make_shared<HmcTaskManager>("HmcEditorEvent", HmcTaskManagerTimeOpt::SEQUENTIAL);
    m_stateMachine = std::make_shared<HmcStateMachine>(this);
    m_stateMachine->Init();

    m_laneManager = std::make_shared<HmcLaneManager>(this);

    m_graphicsRenderEngine = HmcVideoRenderCreate(RenderType::DRAW);
    m_graphicsRenderEngine->InitEnv(editData);
    m_graphicsRenderEngine->InitEngine(nullptr);
    
    LOGI("[HmcEditor] HmcEditorImp mediaType: %d", mediaType);

    m_previewEngine = HmcPreviewEngineItf::CreatePreviewEngine(this, m_graphicsRenderEngine, mediaType);
    m_previewEngine->Startup();

    HmcExportMediaType exportMediaType = (mediaType == HmcEditMediaType::HMC_EDIT_MEDIA_TYPE_IMAGE) ?
        HmcExportMediaType::HMC_EXPORT_MEDIA_TYPE_IMAGE :
        HmcExportMediaType::HMC_EXPORT_MEDIA_TYPE_VIDEO_WITH_AUDIO;
    m_exportEngine = HmcExportEngineItf::CreateExportEngine(this, m_graphicsRenderEngine, exportMediaType);

    m_offScreenRenderEngine = HmcVideoRenderCreate(RenderType::THUMBNAIL);
    m_offScreenRenderEngine->InitEnv(editData);
    m_offScreenRenderEngine->InitEngine(nullptr);
    
    LOGD("HmcEditorOpen Init end");
    return TRUE;
}

VOID HmcEditorImp::RegisterEventFuncs()
{
    GetDataFunc func;

    // HMC::GET_DATA_VIDEO_DURATION
    func = std::bind(&HmcEditorImp::GetDataVideoDurationFunc, this, std::placeholders::_1, std::placeholders::_2);
    m_getDataFuncMap.insert(make_pair(HMC::GET_DATA_VIDEO_DURATION, func));

    // HMC::GET_DATA_CANVAS_SIZE
    func = std::bind(&HmcEditorImp::GetDataCanvasSize, this, std::placeholders::_1, std::placeholders::_2);
    m_getDataFuncMap.insert(make_pair(HMC::GET_DATA_CANVAS_SIZE, func));

    // HMC::GET_DATA_CURRENT_TIME
    func = std::bind(&HmcEditorImp::GetDataCurrentTime, this, std::placeholders::_1, std::placeholders::_2);
    m_getDataFuncMap.insert(make_pair(HMC::GET_DATA_CURRENT_TIME, func));

    // HMC::GET_DATA_EDITOR_STATE
    func = std::bind(&HmcEditorImp::GetDataEditorState, this, std::placeholders::_1, std::placeholders::_2);
    m_getDataFuncMap.insert(make_pair(HMC::GET_DATA_EDITOR_STATE, func));

    // HMC::GET_DATA_NATIVE_WINDOW
    func = std::bind(&HmcEditorImp::GetDataNativeWindow, this, std::placeholders::_1, std::placeholders::_2);
    m_getDataFuncMap.insert(make_pair(HMC::GET_DATA_NATIVE_WINDOW, func));

    // HMC::GET_DATA_NATIVE_WINDOW
    func = std::bind(&HmcEditorImp::GetDataTimeLineEndTime, this, std::placeholders::_1, std::placeholders::_2);
    m_getDataFuncMap.insert(make_pair(HMC::GET_DATA_TIMELINE_END_TIME, func));
}

VOID HmcEditorImp::NotifyMessage(HmcNotifyMsg msg)
{
    auto weakThis = weak_from_this();
    m_taskMgr->Submit([weakThis, msg]() {
        auto editorImp = weakThis.lock();
        if (editorImp == nullptr) {
            LOGE("NotifyMessage editorImp is nullptr.");
            DestroyNotifyMsg(msg);
            return;
        }
        editorImp->m_callback(editorImp.get(), msg.eventId, msg.dictMsg, editorImp->m_userData);
        DestroyNotifyMsg(msg);
    },
        __FUNCTION__);
}

std::shared_ptr<HmcTaskManager> HmcEditorImp::GetTaskMgr()
{
    return m_previewEngine->GetTaskMgr();
}

DOUBLE HmcEditorImp::GetIntelligentCorrectionAngle(HmcEditor *editor, HmcUid assetUid)
{
    LOGI("GetIntelligentCorrectionAngle start");
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("GetIntelligentCorrectionAngle asset is invalid, please check your asset id");
        return HMC_ERR_INTELLIGENT_CORRECTION;
    }
    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("GetIntelligentCorrectionAngle asset is not version type, please check your asset id");
        return HMC_ERR_INTELLIGENT_CORRECTION;
    }
    HmcRenderTexture *texture = ((HmcImageAsset *)asset)->GetOriginalTexture();
    OH_PixelmapNative *inputPixelmap = texture->GetImage()->nativePixelmap;
    OH_EffectFilter *filter = OH_EffectFilter_Create("Horizontal_Correction");
    if (filter == nullptr) {
        LOGE("GetIntelligentCorrectionAngle OH_EffectFilter_Create failed");
        delete texture;
        return HMC_ERR_INTELLIGENT_CORRECTION;
    }
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_Render(filter, inputPixelmap, inputPixelmap);
    LOGI("GetIntelligentCorrectionAngle OH_EffectFilter_Render errorCode=%d", errorCode);
    if (errorCode != ImageEffect_ErrorCode::EFFECT_SUCCESS) {
        LOGE("GetIntelligentCorrectionAngle acquire padding size failed");
        delete texture;
        delete filter;
        return HMC_ERR_INTELLIGENT_CORRECTION;
    }
    delete texture;
    ImageEffect_Any angle;
    ImageEffect_ErrorCode getValueErrorCode = OH_EffectFilter_GetValue(filter, "FILTER_CORRECTION_ANGLE", &angle);
    LOGI("GetIntelligentCorrectionAngle OH_EffectFilter_GetValue getValueErrorCode=%d", getValueErrorCode);
    if (getValueErrorCode != ImageEffect_ErrorCode::EFFECT_SUCCESS) {
        LOGE("GetIntelligentCorrectionAngle GetIntelligentCorrectionValue failed");
        delete filter;
        return HMC_ERR_INTELLIGENT_CORRECTION;
    }
    delete filter;
    return -angle.dataValue.doubleValue;
}

VOID HmcEditorImp::UpdateCanvasRatioToAsset()
{
    if (m_laneManager == nullptr) {
        LOGE("UpdateCanvasRatioToAsset, update canvas ratio to asset failed, lane manager is null");
        return;
    }

    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION };
    for (auto i : vc) {
        VECTOR<HmcUid> laneList;
        m_laneManager->GetLaneList(i, laneList);

        for (const auto &laneUid : laneList) {
            IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
            VECTOR<HmcUid> assetList;
            lane->GetAssetList(assetList);

            for (const auto &assetUid : assetList) {
                IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
                if (asset == nullptr) {
                    continue;
                }

                if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
                    continue;
                }

                auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
                if (visionAsset != nullptr) {
                    visionAsset->SetCanvasRatio();
                }
            }
        }
    }
}

VOID HmcEditorImp::UpdateAssetOffset(FLOAT ratioX)
{
    if (m_laneManager == nullptr) {
        LOGE("UpdateAssetOffset, update canvas ratio to asset failed, lane manager is null");
        return;
    }

    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION };
    for (auto i : vc) {
        VECTOR<HmcUid> assetLaneList;
        m_laneManager->GetLaneList(i, assetLaneList);

        for (const auto &laneUid : assetLaneList) {
            IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
            if (lane == nullptr) {
                continue;
            }

            VECTOR<HmcUid> assetList;
            lane->GetAssetList(assetList);

            for (const auto &assetUid : assetList) {
                IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
                if (asset == nullptr) {
                    continue;
                }

                if (HmcAssetUtils::IsVisionAsset(asset->GetType())) {
                    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
                    if (visionAsset == nullptr) {
                        continue;
                    }

                    visionAsset->UpdatePositionByWindowRatio(ratioX, ratioX);
                }
            }
        }
    }
}

VOID HmcEditorImp::OnDisplayAreaChanged()
{
}

VOID HmcEditorImp::OnEventNotify(HMC::EventId eventId, VOID *eventMsg, VOID *eventData)
{
    HmcNotifyMsg msg;
    LOGD("OnEventNotify eventId=%d", eventId);

    auto dictMsg = static_cast<HmcDict *>(eventMsg);
    EvenJudge(eventId, msg, dictMsg);
}

VOID HmcEditorImp::EvenJudge(HMC::EventId eventId, HmcNotifyMsg &msg, auto &dictMsg)
{
    switch (eventId) {
        case HMC::EVENT_THUMBNAIL_IMAGE_UPDATE:
        case HMC::EVENT_THUMBNAIL_UPDATE:
            msg = {HMC_EVENT_THUMBNAIL_UPDATE, dictMsg};
            break;
        case HMC::EVENT_FILTER_THUMBNAIL:
            msg = {HMC_EVENT_FILTER_THUMBNAIL_UPDATE, dictMsg};
            break;
        case HMC::EVENT_DURATION_CHANGE: {
            INT64 duration = m_laneManager->GetDuration();
            uint64_t startTime = 0;
            uint64_t endTime = 0;
            m_previewEngine->GetPreviewPeriodRange(startTime, endTime);
            if (startTime == 0 && endTime == 0) { // 第一次初始化，将播放区间设置为视频原始长度.
                    m_previewEngine->SetPreviewPeriodRange(0, duration);
            }
            dictMsg = HmcDictCreate();
            LOGD("duration %lld", duration);
            HmcDictSetInt64(dictMsg, "duration", duration);
            msg = {HMC_EVENT_DURATION_CHANGE, dictMsg};
            break;
        }
        case HMC::EVENT_ERROR:
            msg = {HMC_EVENT_ERROR, dictMsg};
            break;
        case HMC::EVENT_REMOVE_EFFECT: {
            STRING effectName = HmcDictGetString(dictMsg, "name");
            m_graphicsRenderEngine->RemoveEffect(effectName);
            HmcDictDestroy(dictMsg);
            return;
        }
        case HMC::EVENT_INIT_INNER_EFFECT: {
            VOID *effect;
            HmcDictGetPointer(dictMsg, "effect", &effect);
            m_graphicsRenderEngine->InitInnerEffect(effect);
            return;
        }
        case HMC::EVENT_EXPORT_STATE_CHANGE:
            msg = {HMC_EVENT_EXPORT_STATE_CHANGE, dictMsg};
            break;
    
        default:
            HmcEventId callbackId = eventId > HMC::EVENT_TEST ? HMC_EVENT_TEST : static_cast<HmcEventId>(eventId);
            msg = {callbackId, dictMsg};
            break;
    }
    
    // asset 回调处理完后，扔到线程抛给UI
    if (dictMsg != nullptr) {
        NotifyMessage(msg);
    }
}

VOID HmcEditorImp::OnGetData(HMC::GetDataId eventId, VOID *eventMsg, VOID *eventData)
{
    auto it = m_getDataFuncMap.find(eventId);
    if (it == m_getDataFuncMap.end()) {
        LOGE("not find func, id:%d", eventId);
        return;
    }

    auto func = it->second;
    func(eventMsg, eventData);
}

std::shared_ptr<VideoRenderInfo> HmcEditorImp::OnPackGraphicsRenderInfo(uint64_t time, bool exactMode)
{
    std::shared_ptr<VideoRenderInfo> renderInfo = std::make_shared<VideoRenderInfo>();
    int32_t result = m_laneManager->PackGraphicsRenderInfo(time, renderInfo, exactMode);
    if (result != HMC_OK) {
        LOGE("OnPackGraphicsRenderInfo failed, laneManager PackGraphicsRenderInfo failed with err: %d", result);
        return nullptr;
    }
    return renderInfo;
}
VOID HmcEditorImp::OnSeekEnd()
{
    LOGD("HmcEditorImp seek end");
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to OnSeekEnd");
        return;
    }
    m_stateMachine->DoAction(HMC_EDITOR_ACTION_SEEK_END);
}

VOID HmcEditorImp::UpdatePlayPos(INT64 time)
{
    HmcDict *dictMsg = HmcDictCreate();
    HmcDictSetInt64(dictMsg, "playPos", time);
    HmcNotifyMsg msg = { HMC_EVENT_PLAY_POS_CHANGE, dictMsg };
    NotifyMessage(msg);
    LOGD("UpdatePlayPos time=%lld", time);
}

HmcUid HmcEditorImp::GetMainAsset()
{
    std::vector<HmcUid> laneList;
    m_laneManager->GetLaneList(HMC_LANE_VISION, laneList);

    for (const auto &laneUid : laneList) {
        IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);

        std::vector<HmcUid> assetList;
        lane->GetAssetList(assetList);

        for (const auto &assetUid : assetList) {
            IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
            auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
            if (visionAsset != nullptr) {
                return assetUid;
            }
        }
    }

    return HMC_UID_NULL;
}

VOID HmcEditorImp::GetDataVideoDurationFunc(VOID * /* eventMsg */, VOID *eventData)
{
    if (eventData) {
        *(INT64 *)eventData = m_laneManager->GetDuration(HMC_LANE_VISION);
    }
}

VOID HmcEditorImp::GetDataCanvasSize(VOID * /* eventMsg */, VOID *eventData)
{
    auto canvasSize = static_cast<HmcSize *>(eventData);
    if (canvasSize != nullptr) {
        *canvasSize = GetCanvasSize();
    }
}

VOID HmcEditorImp::GetDataCurrentTime(VOID * /* eventMsg */, VOID *eventData)
{
    uint64_t currentTime = m_previewEngine->GetCurrentTime();
    *(INT64 *)eventData = static_cast<int64_t>(currentTime);
}

VOID HmcEditorImp::GetDataEditorState(VOID * /* eventMsg */, VOID *eventData)
{
    if (eventData) {
        *(HmcEditorState *)eventData = GetState();
    }
}

VOID HmcEditorImp::GetDataNativeWindow(VOID * /* eventMsg */, VOID *eventData)
{
    auto surfaceTexture = m_previewEngine->CreateSurface();
    auto dict = (HmcDict *)eventData;
    HmcDictSetPointer(dict, "surfaceTexture", surfaceTexture);
}

VOID HmcEditorImp::GetDataTimeLineEndTime(VOID * /* eventMsg */, VOID *eventData)
{
    uint64_t startTime = 0;
    uint64_t endTime = 0;
    m_previewEngine->GetPreviewPeriodRange(startTime, endTime);
    *(INT64 *)eventData = static_cast<int64_t>(endTime);
}

VOID HmcEditorImp::OnExportStateChange(INT32 state)
{
    LOGI("export state change, state=%d", state);
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to OnExportStateChange");
        return;
    }
    HmcDict *dictMsg = HmcDictCreate();
    HmcDictSetInt32(dictMsg, "export_state", state);
    HmcNotifyMsg msg = { HMC_EVENT_EXPORT_STATE_CHANGE, dictMsg };
    m_stateMachine->DoAction(HMC_EDITOR_ACTION_EXPORTEND);

    NotifyMessage(msg);
}


VOID HmcEditorImp::OnImportResultNotify(INT32 result)
{
    LOGI("OnImportResultNotify, result = %d", result);
    HmcDict *dictMsg = HmcDictCreate();
    HmcDictSetInt32(dictMsg, "importResult", result);
    HmcNotifyMsg msg = { HMC_EVENT_IMPORT_RESULT_NOTIFY, dictMsg };
    NotifyMessage(msg);
}

VOID HmcEditorImp::OnExportResultNotify(INT32 result)
{
    LOGI("OnExportResultNotify, result = %d", result);
    HmcDict *dictMsg = HmcDictCreate();
    HmcDictSetInt32(dictMsg, "exportResult", result);
    HmcNotifyMsg msg = { HMC_EVENT_EXPORT_RESULT_NOTIFY, dictMsg };
    NotifyMessage(msg);
}

void HmcEditorImp::RequestPrefetching()
{
    if (!m_laneManager) {
        return;
    }

    auto preAssetUid = m_laneManager->GetPreAssetUid();
    if (HmcUidIsNull(&preAssetUid)) {
        return;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(preAssetUid);
    auto videoAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (!videoAsset) {
        return;
    }

    videoAsset->RequestPrefetching();
}

VOID HmcEditorImp::OnExportProgressChange(uint32_t state)
{
    LOGD("export progress change %d", state);
    HmcDict *dictMsg = HmcDictCreate();
    HmcDictSetInt32(dictMsg, "exportProgress", state);
    HmcNotifyMsg msg = { HMC_EVENT_EXPORT_PROGRESS_CHANGE, dictMsg };
    NotifyMessage(msg);
}

std::string HmcEditorImp::GetEditData()
{
    Json::Value previewData = m_previewEngine->Serialize();
    Json::Value laneJson = m_laneManager->SerializeData();
    return SINGLETON(HmcProjectEntity)->GetEditData(laneJson, previewData);
}

Json::Value HmcEditorImp::GetImageEffectJson()
{
    Json::Value imageEffectJson = m_graphicsRenderEngine->SaveImageEffect();
    return imageEffectJson;
}

void HmcEditorImp::ApplyEditData(INT32 sourceFileFd, const std::string &data, int &result,
                                 std::function<void(std::string const &assetId)> onDecodePicture)
{
    // 将要编辑的对象替换成原始文件的fd.
    std::string fdString = "fd://" + std::to_string(sourceFileFd);
    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(data, jsonEditData);
    if (!parseResult) {
        LOGE("apply edit data failed because of parsing data to json object.");
        return;
    }

    Json::Value systemJson = jsonEditData;

    if (!systemJson.isMember("extra_info") || !systemJson["extra_info"].isObject()) {
        result = HMC_ERR_EDITDATA_NO_EXTRA_INFO;
        LOGE("apply edit data failed because of no extra_info.");
        return;
    }

    if (!SINGLETON(HmcProjectEntity)->CheckHMCEditorDataSignature(systemJson["extra_info"])) {
        result = HMC_ERR_EDITDATA_NO_SIGNATURE;
        LOGE("apply edit data failed because of no SIGNATURE.");
        return;
    }
    std::string correctedData =
        SINGLETON(HmcProjectEntity)
            ->UpdateJsonStringValue(systemJson["extra_info"], DICT_KEY_ASSET_PROPERTY_PATH, fdString);

    // 应用编辑数据到 HmcProjectEntity
    SINGLETON(HmcProjectEntity)->ApplyEditData(correctedData);
    Json::Value previewJson = SINGLETON(HmcProjectEntity)->GetPreviewJson();
    Json::Value laneJson = SINGLETON(HmcProjectEntity)->GetLaneJson();
    auto assetId = GetPreAssetUid();
    onDecodePicture(HmcUidToString(&assetId).c_str());
    // 反序列化
    m_previewEngine->Deserialize(previewJson);
    m_laneManager->DeserializeData(laneJson);
    TryApplyImageEffectDataToHmcEffect(systemJson);
    m_previewEngine->Flush(0);
    result = HMC_OK;
}

VOID HmcEditorImp::TryApplyImageEffectDataToHmcEffect(const Json::Value &jsonEditData)
{
    if (!jsonEditData.isMember("imageEffect") || !jsonEditData["imageEffect"].isMember("filters")) {
        LOGI("TryApplyImageEffectDataToHmcEffect not handle AddXTStyleEffect");
        return;
    }
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(GetPreAssetUid());
    if (asset == nullptr) {
        return;
    }
    auto imageAsset = dynamic_cast<HmcImageAsset *>(asset);
    if (imageAsset == nullptr) {
        return;
    }
    TryApplyXtStyleDataToHmcEffect(jsonEditData, jsonEditData["imageEffect"]["filters"], imageAsset);
}

VOID HmcEditorImp::TryApplyXtStyleDataToHmcEffect(const Json::Value &editData, const Json::Value &jsonFilters,
                                                  HmcImageAsset *imageAsset)
{
    if (LaneModuleNodeHasXtStyleJson(editData)) {
        LOGI("LaneModuleNodeHasXtStyleJson not handle AddXTStyleEffect");
        return;
    }
}

BOOL HmcEditorImp::LaneModuleNodeHasXtStyleJson(const Json::Value &editData)
{
    if (!editData.isMember("extra_info")) {
        return false;
    }
    auto extraInfoNode = editData["extra_info"];
    if (!extraInfoNode.isMember("lane_module")) {
        return false;
    }
    auto laneModuleNode = extraInfoNode["lane_module"];
    if (!laneModuleNode.isMember("lane")) {
        return false;
    }
    auto laneNode = laneModuleNode["lane"];
    if (!laneNode.isArray() || laneNode.size() <= 0) {
        return false;
    }
    auto oneLanNode = laneNode[0];
    if (!oneLanNode.isMember("asset")) {
        return false;
    }
    auto assetNode = oneLanNode["asset"];
    if (!assetNode.isArray() || assetNode.size() <= 0) {
        return false;
    }
    auto oneAssetNode = assetNode[0];
    if (!oneAssetNode.isMember("effect")) {
        return false;
    }
    for (auto &effect : oneAssetNode["effect"]) {
        if (effect.isMember("name") && effect["name"].isString() && effect["name"].asString() == XTSTYLE_FILTER_NAME) {
            return true;
        }
    }
    return false;
}

HmcUid HmcEditorImp::GetPreLaneUid()
{
    HmcUid laneUid = HMC_UID_NULL;
    if (m_laneManager) {
        laneUid = m_laneManager->GetPreLaneUid();
    }
    return laneUid;
}

HmcUid HmcEditorImp::GetPreAssetUid()
{
    HmcUid assetUid = HMC_UID_NULL;
    if (m_laneManager) {
        assetUid = m_laneManager->GetPreAssetUid();
    }
    return assetUid;
}

VECTOR<STRING> HmcEditorImp::GetAssetsPath()
{
    VECTOR<STRING> assetsPath;
    if (m_laneManager == nullptr) {
        LOGE("GetAssetsPath failed, lane manager is null");
        return assetsPath;
    }

    VECTOR<HmcLaneType> vc = { HMC_LANE_VISION };
    for (auto i : vc) {
        VECTOR<HmcUid> assetLaneList;
        m_laneManager->GetLaneList(i, assetLaneList);

        for (const auto &laneUid : assetLaneList) {
            IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
            VECTOR<HmcUid> assetList;
            lane->GetAssetList(assetList);

            for (const auto &assetUid : assetList) {
                IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
                if (asset == nullptr) {
                    continue;
                }

                assetsPath.emplace_back(asset->GetPath());
            }
        }
    }

    return assetsPath;
}

VOID HmcEditorImp::SetPreviewWindow(VOID *window)
{
    LOGI("[HmcEditor] set preview window.");
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to SetPreviewWindow");
        return;
    }
    auto nativeWindow = static_cast<HmcNativeWindow *>(window);
    if (nativeWindow->window_ == nullptr) {
        LOGE("HmcEditorImp SetPreviewWindow nativeWindow->window_ is nullptr");
    } else {
        LOGI("HmcEditorImp SetPreviewWindow nativeWindow->window_ not nullptr");
    }
    if (m_stateMachine->DoAction(HMC_EDITOR_ACTION_INIT)) {
        auto originCanvasSize = GetCanvasSize();

        m_previewEngine->Shutdown();
        m_previewEngine->SetPreviewWindow(window);
        m_previewEngine->Startup();

        auto canvasSize = GetCanvasSize();
        if (canvasSize.width > 0 && canvasSize.height > 0 && originCanvasSize.width > 0 &&
            originCanvasSize.height > 0) {
            FLOAT ratio = canvasSize.width / originCanvasSize.width;
            UpdateAssetOffset(ratio);
            UpdateCanvasRatioToAsset();
        }
    }
}

VOID HmcEditorImp::SeekTo(INT64 timestamp, bool isExactMode)
{
    LOGD("SeekTo timestamp:%lld isExactMode %d", timestamp, isExactMode);
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to SeekTo");
        return;
    }
    UpdatePlayPos(timestamp);
    if (m_stateMachine->DoAction(HMC_EDITOR_ACTION_SEEK)) {
        m_waitAutoFlushCnt = 0;
        m_previewEngine->Flush(timestamp, isExactMode);
    }
}

VOID HmcEditorImp::Play(INT64 startTime, INT64 endTime)
{
    LOGD("HmcEditorImp play");
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to Play");
        return;
    }
    if (m_stateMachine->DoAction(HMC_EDITOR_ACTION_PLAY)) {
        constexpr uint32_t defaultFps = 25; // 默认按照25帧率来播放.
        uint32_t fps = defaultFps;
        HmcUid mainAssetUid = GetMainAsset();
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(mainAssetUid);
        auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
        if (visionAsset == nullptr) {
            LOGW("get main asset failed, play with default fps(25)");
        } else {
            fps = static_cast<uint32_t>(visionAsset->GetVideoFps());
        }

        m_previewEngine->Play(startTime, endTime, fps);
    }
}

BOOL HmcEditorImp::Pause(BOOL isEditAction)
{
    // pause 功能需要停止一切，时间点卡在最后一次play 或seek点，并渲染结束。先停止timeline，将状态切换到idle
    // 状态，再执行edit
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to Pause");
        return false;
    }
    m_stateMachine->DoAction(HMC_EDITOR_ACTION_PAUSE);
    m_previewEngine->Pause();
    if (m_stateMachine->GetState() == HMC_EDITOR_STATE_IDLE || m_stateMachine->GetState() == HMC_EDITOR_STATE_INIT) {
        return TRUE;
    }
    return FALSE;
}

VOID HmcEditorImp::Flush()
{
    m_previewEngine->Flush();
}

VOID HmcEditorImp::FlushForce()
{
    m_previewEngine->FlushForce();
}

void HmcEditorImp::SetPreviewPeriodRange(uint64_t startTime, uint64_t endTime)
{
    m_previewEngine->SetPreviewPeriodRange(startTime, endTime);
}

void HmcEditorImp::GetPreviewPeriodRange(uint64_t &startTime, uint64_t &endTime)
{
    m_previewEngine->GetPreviewPeriodRange(startTime, endTime);
}

UINT64 HmcEditorImp::GetCurrentTimeline()
{
    return m_previewEngine->GetCurrentTime();
}

INT64 HmcEditorImp::GetDuration()
{
    uint64_t startTime = 0;
    uint64_t endTime = 0;
    m_previewEngine->GetPreviewPeriodRange(startTime, endTime);

    return endTime - startTime + 1;
}

INT64 HmcEditorImp::StartExporting(HmcDict *dict, HmcEditExportFunc func)
{
    LOGD("start export");

    if (GetState() == HMC_EDITOR_STATE_PLAY) {
        Pause(TRUE);
    }
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to StartExporting");
        return HMC_ERR;
    }
    m_stateMachine->DoAction(HMC_EDITOR_ACTION_EXPORT);

    auto assetUid = GetMainAsset();
    auto asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset != nullptr) {
        std::string path = asset->GetPath();
        HmcDictSetString(dict, DICT_KEY_ASSET_PROPERTY_PATH_TYPE, path.c_str());
    }

    int32_t width = 0;
    int32_t height = 0;
    HmcDictGetInt32(dict, PROJECT_KEY_VIDEO_WIDTH, &width);
    HmcDictGetInt32(dict, PROJECT_KEY_VIDEO_HEIGHT, &height);

    HmcSize previewCanvasSize = GetCanvasSize();

    m_exportEngine->SetCanvasSize({
        .width = static_cast<float>(width),
        .height = static_cast<float>(height) });
    m_exportEngine->SetPreviewCanvasSize(previewCanvasSize);
    m_exportEngine->SetExportInfoCallback(func);
    return m_exportEngine->Export(dict);
}

INT64 HmcEditorImp::EncodePicture(HmcDict *dict, OH_PictureNative *dstPicture,
    std::function<void (const std::string &, const std::string &)> callback)
{
    LOGI("HmcEditorImp EncodePixelMap");
    m_exportEngine->EncodePicture(dict, dstPicture, callback);
    return HMC_OK;
}

VOID HmcEditorImp::CancelExporting()
{
    LOGD("cancel export");
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to CancelExporting");
        return;
    }
    if (m_stateMachine && m_stateMachine->DoAction(HMC_EDITOR_ACTION_CANCEL_EXPORT)) {
        m_exportEngine->Cancel();
    }
}

HmcLaneManager *HmcEditorImp::GetLaneManager() const
{
    return m_laneManager.get();
}

BOOL HmcEditorImp::SetCanvasSize(const HmcSize &canvasSize)
{
    auto originCanvasSize = GetCanvasSize();
    m_previewEngine->SetCanvasSize(canvasSize);
    auto canvasSizeNew = GetCanvasSize();
    if (canvasSizeNew.width > 0 && canvasSizeNew.height > 0 && originCanvasSize.width > 0 &&
        originCanvasSize.height > 0) {
        FLOAT ratio = canvasSizeNew.width / originCanvasSize.width;
        UpdateAssetOffset(ratio);
        UpdateCanvasRatioToAsset();
    }

    return TRUE;
}

HmcSize HmcEditorImp::GetCanvasSize()
{
    return m_previewEngine->GetCanvasSize();
}

HmcUid HmcEditorImp::GetProjectId()
{
    return m_projectId;
}

int HmcEditorImp::SetUserData(const HmcUid &objUid, HmcDict *dict)
{
    return SINGLETON(HmcProjectEntity)->SetUserData(objUid, dict);
}

int HmcEditorImp::GetUserData(const HmcUid &objUid, HmcDict **poutDict)
{
    return SINGLETON(HmcProjectEntity)->GetUserData(objUid, poutDict);
}

HmcEditorState HmcEditorImp::GetState() const
{
    if (nullptr == m_stateMachine) {
        LOGE("m_stateMachine is null");
        return HMC_EDITOR_STATE_INIT;
    }
    return m_stateMachine->GetState();
}

HmcEditorState HmcEditorImp::GetLastState() const
{
    if (nullptr == m_stateMachine) {
        LOGE("m_stateMachine is null");
        return HMC_EDITOR_STATE_INIT;
    }
    return m_stateMachine->GetLastState();
}

VOID HmcEditorImp::IncreaseWaitAutoFlushCnt()
{
    m_waitAutoFlushCnt++;
    LOGD("IncreaseWaitAutoFlushCnt m_waitAutoFlushCnt=%d", m_waitAutoFlushCnt.load());
}

VOID HmcEditorImp::SetAutoFlush(BOOL enable)
{
    m_autoFlush = enable;
    LOGD("SetAutoFlush  m_autoFlush=%d m_waitAutoFlushCnt=%d ", m_autoFlush, m_waitAutoFlushCnt.load());
    if (m_autoFlush && m_waitAutoFlushCnt > 0) {
        Flush();
        m_waitAutoFlushCnt = 0;
    }
}

BOOL HmcEditorImp::GetAutoFlush() const
{
    return m_autoFlush;
}

VOID HmcEditorImp::GetRGBData(HmcImage *image, HmcSize canvasSize, const HmcUid &assetUid,
    std::function<void(HmcImage *image)> callback)
{
    auto asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        LOGE("get asset failed, visionAsset is null");
        return;
    }
}

void HmcEditorImp::WaitForIdleToRunTask()
{
    if (m_stateMachine == nullptr) {
        LOGE("HmcEditorImp failed to WaitForIdleToRunTask");
        return;
    }
    return m_stateMachine->WaitForIdleToRunTask();
}

VOID HmcEditorImp::HmcWaitTaskFinish(std::function<void()> cb)
{
    auto weakThis = weak_from_this();
    ffrt::submit([weakThis, cb]() {
        auto editorImp = weakThis.lock();
        if (editorImp == nullptr) {
            LOGI("HmcEditorImp::HmcWaitTaskFinish editorImp is nullptr.");
            return;
        }
        std::shared_ptr<HmcTaskManager> renderTask = editorImp->GetTaskMgr();
        if (renderTask != nullptr) {
            renderTask->Wait();
            cb();
        }
    });
}

VOID HmcEditorImp::CleanWatermarkCache()
{
    m_graphicsRenderEngine->CleanWatermarkCache();
}

void HmcEditorImp::SetSportCallBack(SportFunc sportFunc)
{
    std::shared_ptr<HmcTaskManager> renderTask = m_previewEngine->GetTaskMgr();
    CHECK_LOG(renderTask != nullptr, "HmcEditorImp SetSportCallBack failed");
    auto weakThis = weak_from_this();
    renderTask->Submit([weakThis, sportFunc]() {
        auto strongThis = weakThis.lock();
        CHECK_LOG(strongThis != nullptr, "HmcEditorImp SetSportCallBack this is nullptr");
        std::lock_guard<std::mutex> locker(strongThis->m_sportMutex);
        strongThis->m_sportCallBack = sportFunc;
    });
}

void HmcEditorImp::CallSportFunction(bool res)
{
    LOGI("HmcEditorImp CallSportFunction res = %d", res);
    std::shared_ptr<HmcTaskManager> renderTask = m_previewEngine->GetTaskMgr();
    CHECK_LOG(renderTask != nullptr, "HmcEditorImp CallSportFunction failed");
    auto weakThis = weak_from_this();
    renderTask->Submit([weakThis, res]() {
        auto strongThis = weakThis.lock();
        CHECK_LOG(strongThis != nullptr, "HmcEditorImp CallSportFunction this is nullptr");
        std::lock_guard<std::mutex> locker(strongThis->m_sportMutex);
        CHECK_LOG(strongThis->m_sportCallBack != nullptr, "HmcEditorImp CallSportFunction callback is nullptr");
        strongThis->m_sportCallBack(res);
    });
}

std::shared_ptr<HmcTaskManager> HmcEditorImp::GetExportTaskMgr()
{
    return m_exportEngine->GetExportTask();
}

void HmcEditorImp::GeneratorRfDataB(HmcUid assetUid, std::function<void(bool res)> cb)
{
    std::shared_ptr<HmcTaskManager> renderTask = m_previewEngine->GetTaskMgr();
    CHECK_LOG(renderTask != nullptr, "HmcEditorImp GeneratorRfDataB failed");
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    
    renderTask->Submit([asset, cb]() {
        bool res = ((HmcImageAsset *)asset)->GeneratorRfDataB();
        cb(res);
    }, __FUNCTION__);
}