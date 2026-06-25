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

#ifndef HMCEDITORIMP_H
#define HMCEDITORIMP_H

#include "Asset/HmcImageAsset.h"

struct HmcNotifyMsg;

class HmcRectD;

class HmcPreviewEngineItf;
class HmcExportEngineItf;

using GetDataFunc = std::function<VOID(VOID *eventMsg, VOID *eventData)>;

class HmcEditorImp : public HmcEventHandler, public std::enable_shared_from_this<HmcEditorImp> {
public:
    HmcEditorImp(HmcEditorCallback callback, void *userData);
    virtual ~HmcEditorImp();

public:
    BOOL Init(const HmcUid projectId, HmcEditMediaType mediaType, std::string const & editData);
    VOID OnEventNotify(HMC::EventId eventId, VOID *eventMsg, VOID *eventData);
    VOID EvenJudge(HMC::EventId eventId, HmcNotifyMsg &msg, auto &dictMsg);
    VOID OnGetData(HMC::GetDataId eventId, VOID *eventMsg, VOID *eventData);
    std::shared_ptr<VideoRenderInfo> OnPackGraphicsRenderInfo(uint64_t time, bool exactMode = true) override;
    void OnSeekEnd();
    VOID CleanWatermarkCache();
    VOID OnExportStateChange(INT32 state);
    void OnExportProgressChange(uint32_t progress) override;
    VOID OnImportResultNotify(INT32 result);
    VOID OnExportResultNotify(INT32 result);
    DOUBLE GetIntelligentCorrectionAngle(HmcEditor *editor, HmcUid assetUid);
    void RequestPrefetching() override;
    void WaitForIdleToRunTask() override;
    std::string GetEditData();
    std::string GetPreEditData(const std::string &assetId);
    Json::Value GetImageEffectJson();
    void ApplyEditData(INT32 sourceFileFd, const std::string &data, int &result,
                       std::function<void(std::string const &assetId)> onDecodePicture);
    HmcUid GetPreLaneUid();
    HmcUid GetPreAssetUid();
    VOID SetPreviewWindow(VOID *window);
    VOID SeekTo(INT64 timestamp, bool isExactMode);
    VOID Play(INT64 startTime, INT64 endTime);
    BOOL Pause(BOOL isEditAction = FALSE);
    VOID Flush();
    VOID FlushForce();
    VOID SetAutoFlush(BOOL enable);
    BOOL GetAutoFlush() const;
    VOID IncreaseWaitAutoFlushCnt();
    void SetPreviewPeriodRange(uint64_t startTime, uint64_t endTime);
    void GetPreviewPeriodRange(uint64_t &startTime, uint64_t &endTime);
    UINT64 GetCurrentTimeline();
    INT64 GetDuration();
    INT64 StartExporting(HmcDict *dict, HmcEditExportFunc func);
    INT64 EncodePicture(HmcDict *dict, OH_PictureNative *dstPicture,
        std::function<void (const std::string &, const std::string &)> callback);
    VOID CancelExporting();

    HmcLaneManager *GetLaneManager() const;
    HmcUid GetProjectId();
    BOOL SetCanvasSize(const HmcSize &canvasSize);
    HmcSize GetCanvasSize();
    int SetUserData(const HmcUid &objUid, HmcDict *dict);
    int GetUserData(const HmcUid &objUid, HmcDict **poutDict);
    HmcEditorState GetState() const;
    HmcEditorState GetLastState() const;

    VOID UpdateCanvasRatioToAsset();

    VOID UpdateAssetOffset(FLOAT ratioX);

    VOID OnDisplayAreaChanged();

    VOID GetRGBData(HmcImage *image, HmcSize canvasSize, const HmcUid &assetUid,
        std::function<void(HmcImage *image)> callback);
    
    // 获取渲染子线程
    std::shared_ptr<HmcTaskManager> GetTaskMgr();
    
    // 获取Export子线程
    std::shared_ptr<HmcTaskManager> GetExportTaskMgr();
    
    VOID HmcWaitTaskFinish(std::function<void()> cb);
    
    void SetSportCallBack(SportFunc sportFunc);
    
    void CallSportFunction(bool res);
    
    void GeneratorRfDataB(HmcUid assetUid, std::function<void(bool res)> cb);
    
private:
    VOID RegisterEventFuncs();
    VOID NotifyMessage(HmcNotifyMsg msg);
    VOID UpdatePlayPos(INT64 time);
    HmcUid GetMainAsset();

private:
    VOID GetDataVideoDurationFunc(VOID *eventMsg, VOID *eventData);
    VOID GetDataCanvasSize(VOID *eventMsg, VOID *eventData);
    VOID GetDataCurrentTime(VOID *eventMsg, VOID *eventData);
    VOID GetDataEditorState(VOID *eventMsg, VOID *eventData);
    VOID GetDataNativeWindow(VOID *eventMsg, VOID *eventData);
    VOID GetDataTimeLineEndTime(VOID *eventMsg, VOID *eventData);
    VECTOR<STRING> GetAssetsPath();
    VOID TryApplyImageEffectDataToHmcEffect(const Json::Value &jsonFilters);
    VOID TryApplyXtStyleDataToHmcEffect(const Json::Value &editData, const Json::Value &jsonFilters,
                                        HmcImageAsset *imageAsset);
    BOOL LaneModuleNodeHasXtStyleJson(const Json::Value &editData);
private:
    HmcEditorCallback m_callback{ nullptr };
    VOID *m_userData{ nullptr };
    HmcUid m_projectId;
    MAP<HMC::GetDataId, GetDataFunc> m_getDataFuncMap;
    BOOL m_autoFlush = TRUE;
    std::atomic_int m_waitAutoFlushCnt{ 0 };

    std::shared_ptr<HmcStateMachine> m_stateMachine{ nullptr };

    std::shared_ptr<HmcRenderEngineItf> m_graphicsRenderEngine{ nullptr };
    std::shared_ptr<HmcRenderEngineItf> m_offScreenRenderEngine{ nullptr };

    std::shared_ptr<HmcPreviewEngineItf> m_previewEngine{ nullptr };
    std::shared_ptr<HmcExportEngineItf> m_exportEngine{ nullptr };
    
    std::shared_ptr<HmcLaneManager> m_laneManager{ nullptr };

    std::shared_ptr<HmcTaskManager> m_taskMgr{ nullptr };
    
    SportFunc m_sportCallBack{ nullptr };
    std::mutex m_sportMutex;
};

#endif // HMCEDITORIMP_H
