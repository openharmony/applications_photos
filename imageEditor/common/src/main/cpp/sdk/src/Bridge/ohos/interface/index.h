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
#ifndef OH_INDEX_H
#define OH_INDEX_H

#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <functional>
#include <string>
#include "ArrayBuffer.hpp"
#include <napi/native_api.h>
#include "../hve/HveTimeline.h"

#define ASSERT_RET(cdt, ret) \
    if (cdt) {               \
        return ret;          \
    }

#define ASSERT_LOG(cdt, log, ...) \
    if (cdt) {                    \
        LOGE(log);                \
        return __VA_ARGS__;       \
    }

#define USE_TIMELINE(ret)                                                \
    LOGD("%s invoked", __FUNCTION__);                                 \
    HveTimeline *timeline = Project::Instance().GetTimeline(timelineId); \
    if (timeline == nullptr) {                                           \
        LOGE("timeline is null. %d", timelineId);                     \
        return ret;                                                      \
    }

#define USE_EDITOR(ret)                        \
    USE_TIMELINE(ret)                          \
    HmcEditor *editor = timeline->GetEditor(); \
    if (nullptr == editor) {                   \
        LOGE("editor is null. ");           \
        return ret;                            \
    }

#define USE_ASSET(ret)                                         \
    USE_EDITOR(ret)                                            \
    HmcUid assetUid = HmcUidHelper(assetId);                   \
    HveAsset *hveAsset = timeline->GetHveAsset(assetUid);      \
    if (nullptr == hveAsset) {                                 \
        LOGE("asset is null. assetId=%s", assetId.c_str()); \
        return ret;                                            \
    }

struct Index {
    static napi_value _init(napi_env env, napi_value exports);
    static void InitEnv();
    static void UnInitEnv();
    static void AppCreate();
    static void AppDestory();
    static void AppShow();
    static void AppHide();
    static void EditorShow();
    static void EditorHide();

    static void RegNativeOpenMedia(std::function<void(std::string const &url, std::string const &mode,
        int64_t callId)> cb);
    static void SetMediaFd(int64_t callId, int64_t fd);
};

struct EditorContext {
    static void CheckEditData(std::string const editdata);
    static void WaitTaskFinish(int timelineId, std::function<void()> cb);
    static void ProcessExifInfo(int timelineId, std::string const & assetId);
    static void CallEmpty(std::function<void(int64_t val)> cb);
    static void CreateTimeline(CreateTimelineParam const &param,
                               std::function<void(std::string const &jsonPos)> sdkCallback,
                               std::function<void(std::string const &jsonPos)> createResult);
    static std::string ModifyTimeline(int timelineId, std::string const &jsonAttr);
    static void BindTimelineWithXComponent(int timelineId, std::string xComponentId, double canvasWidth,
                                           double canvasHeight, std::function<void(int width, int height)> cb);
    static void PlayTimeline(int timelineId, int64_t startTime, int64_t endTime);
    static void PauseTimeline(int timelineId);
    static void SeekTimeline(int timelineId, int64_t timeMs, bool isExactMode);
    static void getExportRect(int timelineId, std::string const & assetId, std::function<void(INT32, INT32)> cb);
    static void CompileTimeline(int timelineId, std::string path, std::string const &assetId, int mediaType,
        std::string mimeType, std::function<void(std::string const & json, std::string const & type)> callback,
        bool autoFlush);
    static void EncodePixelMap(int timelineId, const STRING &path, const STRING &assetId, const STRING &editData,
        const STRING &mimeType, OH_PixelmapNative *dstPixel, const STRING &waterMarkInfo,
        std::function<void(STRING const & json, STRING const & type)> callback);
    static void ReleaseFlowSource(int flowType);
    static void CompileTimelinePixelMap(int timelineId, STRING path, bool isOriginColor, STRING const &assetId,
        int mediaType, std::function<void(napi_value value, STRING const &json, STRING waterMarkInfo)> callback,
        bool isToAiPage, bool needAddWatermark, bool isSave);
    static void CancelCompileTimeline(int timelineId, std::string const &assetId, std::function<void()> callback);
    static void SetThumbnailCallback(int timelineId, std::function<void(const std::string &laneId,
                                     const std::string &assetId, int64_t pts, ArrayBuffer const &buffer,
                                     int width, int height)> cb);

    static void SetFilterThumbnailCallback(int timelineId,
                                           std::function<void(const std::string &laneId, const std::string &assetId,
        const std::string &filterId, int64_t pts, napi_value pixelmapNapi, int width, int height)> cb);
    static void SetPreviewPeriodRange(int timelineId, int64_t startTime, int64_t endTime);
    static void SaveProject(int timelineId,
                            std::function<void(std::string const &jsonPos)> cb);
    static void CloseProject(int timelineId,
                             std::function<void(std::string const &jsonPos)> cb);
    static std::string UpdateEditData(const std::string &data);
    static bool IsSystemEditData(const std::string &data);
    static bool IsThirdEditData(std::string const &data);
    static bool IsOldFilterEditData(std::string const &data);
    static bool IsSupportWatermark(std::string const &data);
    static bool HasWatermarkEffect(std::string const &data, std::function<void(std::string const &jsonPos)> cb);
    static DOUBLE GetCropRotation(std::string const &data);
    static void ApplyEditData(int timelineId, int sourceFileFd, const std::string &editdata, int mediaType,
                              std::function<void(std::string const &jsonStr)> cb,
                              std::function<void(std::string const &assetId)> onDecodePicture);
    static void UndoRedoManagerClear();
    static void Reset(int timelineId, bool refreshExif, std::string const assetId,
        std::function<void(std::string const &jsonStr)> cb);
    static void SetConfigChangeCallback(int timelineId, std::function<void(bool)> cb);
    static void CalConfigChangeCallback(int timelineId);
    
    static int64_t GetCacheSize();
    static void ClearCache();
    
    static std::string Undo();
    static std::string Redo();
    static void RegUndoRedoStateChangeCb(std::function<void(bool undoEnable, bool redoEnable)> undoRedoStateChangeCb);
    static void Start();
    static void Stop();
    
    // 个性风格接口
    static STRING HasXTStyleEffect(std::string const &data);
    static void setXTStyleThumbnailCallback(int timelineId,
                                            std::function<void(napi_value pixelmapNapi, std::string jsonStr)> cb);
    static void SetAutoFlush(int timelineId, bool autoFlush);
};

struct AIEditorContext {
    /*AI编辑公共接口*/
    static void InitEditor(napi_value importPixelMap, bool enableDownSampling, bool useAiRemove,
        std::function<void(bool res)> resultCb);
    static void DeinitEditor();
    static void RefreshEditor(napi_value importPixelMap, std::function<void(bool res)> resultCb);
    static void ChangeEditorType(std::string typeString, std::function<void(bool res)> resultCb);
    static bool IsAiEdited();
    static bool IsAiEditedInCurEditor();
    static bool IsAiLableNeeded();
    static void GetDisplayPixelMapAsync(std::function<void(napi_value displayPixelMap)> resultCb);

    /*Undo/Redo相关接口*/
    static void Undo(std::function<void(bool res, std::string optType)> resultCb);
    static void Redo(std::function<void(bool res, std::string optType)> resultCb);
    static std::string GetPreOptType();
    static std::string GetUndoStepType();
    static napi_value GetCurOutputPixelMap();
    static napi_value GetCurCutoutPixelMap();
    static int32_t GetUndoSize();
    static int32_t GetRedoSize();
    static int32_t GetUndoPixelMapSize();
    static int32_t GetRedoPixelMapSize();
    static bool IsUndoMove();
    static int32_t GetCurFusionCount();

    /*出图及落盘接口*/
    static void GetExportPixelMap(std::function<void(bool res, bool isAiEdited, napi_value exportPixelMap)> resultCb, 
                                  int sourceFlowType);
    static void SaveExportFile(std::string outputPath, int32_t quality, std::function<void(bool res)> resultCb);
    /*AI编辑公共接口，END*/

    /*AI编辑-背景编辑相关接口*/
    static void SegObject(
        std::function<void(bool res, bool hasObject, napi_value outputMask, std::string contourJson)> resultCb);

    static void DoBackgroundBlur(int32_t blurLevel, bool recordFlag,
                std::function<void(bool res, napi_value displayPixelMap)> resultCb);
    static void EnableBackgroundBlur(bool blurEnable,
                std::function<void(bool res, napi_value displayPixelMap)> resultCb);
    static void EnableBackgroundDecolorization(bool decolorizationEnable,
                std::function<void(bool res, napi_value displayPixelMap)> resultCb);
    static void ReprocessBackground(bool decolorizationEnable,
                                               std::function<void(bool res, napi_value displayPixelMap)> resultCb);
    static std::string GetMaskContours(void *maskArray, int32_t width, int32_t height);
    static void GetHSDPreprocessData(
        void *maskArray, std::vector<int32_t> picSize, std::vector<int32_t> compSize,
        std::function<void(napi_value pixelMapBuffer, napi_value newOverlay, STRING pathPoints, STRING ctrlPoints)>
                                         resultCb);
    static ArrayBuffer *GaussianBlurMask(void *imageArray, void *maskArray, int32_t width, int32_t height);
    static ArrayBuffer *PixelMapToMask(void *imageArray, int32_t width, int32_t height);
    static ArrayBuffer *RemoveReflectPixelMapToMask(void *imageArray, int32_t width, int32_t height);
    static napi_value GetCurMaskPixelMap();
    static int32_t GetCurBlurLevel();
    static bool GetCurBlurEnable();
    static bool GetCurDecolorizationEnable();
    static std::string GetBackgroundStatJson();
    /*AI编辑-背景编辑相关接口，END*/

    /*AI编辑-对象消除相关接口*/
    static void InteractionSegment(napi_value maskPixelMap, std::string segTypeStr,
                std::function<void(bool res, napi_value outputMaskPixelMap)> resultCb);
    static void RemoveObject(std::function<void(bool res, std::string outputTypeStr, int32_t removePolicy,
                                                napi_value displayPixelMap)> resultCb);
    static void CancelRemoveObject();
    static napi_value GetCurObjectMask();
    static std::string GetCurObjectContourJson();
    static ArrayBuffer *CreateMaskBuffer(void *maskArray, int32_t width, int32_t height, bool isNeedSetOpacity);
    static void ExtractImageByMask(void *imageArray, void *maskArray, int32_t width, int32_t height,
        std::function<void(napi_value buffer, napi_value maskBuffer, int32_t width,
        int32_t height, int32_t posX, int32_t posY)> resultCb);
    static void ExtractImageByMaskForPicker(void *imageArray, void *maskArray, int32_t width, int32_t height,
        std::function<void(napi_value buffer, napi_value maskBuffer, int32_t width,
        int32_t height, int32_t posX, int32_t posY)> resultCb);
    static void AiMoveReleaseUndo(std::function<void(int32_t fusionNumber, long pixelMapIndex)> releaseFunc);
    static void SetModelCachePath(std::string cacheModelStr);
    static void SetFastSegPixmap(napi_value segPixelMap);
    /*AI编辑-对象消除相关接口，END*/
    
    /*AI编辑-最佳表情相关接口*/
    static void GetReplaceFaceDst(bool network, std::function<void(int32_t dstState,
        int32_t faceId, int32_t x, int32_t y, int32_t w, int32_t h, int32_t width, int32_t height)>resultCb);
    static void SetReplacePixelmap(std::string string, napi_value emo, int32_t mapSize,
        std::function<void(int32_t dstState, int32_t faceId, int32_t x, int32_t y, int32_t w, int32_t h, int32_t width,
        int32_t height)> resultCb);
    static void GetRejectJson(std::function<void(std::string rejectJson)> resultCb);
    static void ClickReplaceWithEmo(int32_t faceId, int32_t nowTime, std::function<void(bool isPopupUpdate,
        std::string imageId, int32_t x, int32_t y, int32_t width, int32_t height, int32_t thisTime)> resultCb);
    static napi_value GetSrcEmo(std::string imageId);
    static void DoReplaceEmo(int32_t faceId, std::string imageId,
        std::function<void(bool res, int32_t code, napi_value displayPixelMap)> resultCb);
    /*AI编辑-最佳表情相关接口，END*/
    
    /*AI编辑-魔法移物相关接口*/
    static void InitPickerEditPixelMap(napi_value pickerEditPixelMap);
    static void ResetPickerEditPixelMap();
    static napi_value GetPickerEditPixelMap();
    static void SegmentObject(napi_value maskPixelMap, std::string segTypeStr,  bool isBasePixelMapEditor,
        std::function<void(bool res, napi_value outputMaskPixelMap)> resultCb);
    static void SegmentObjectForPicker(napi_value maskPixelMap, std::string segTypeStr,  bool isBasePixelMapEditor,
        std::function<void(bool res, napi_value outputMaskPixelMap)> resultCb);
    static void SegmentObjectAiOneStep(napi_value maskPixelMap, bool isBasePixelMapEditor,
    std::function<void(bool res, napi_value outputMaskPixelMap)> resultCb);
    static void MoveObjectAI2Remove(std::function<void(bool res, std::string outputTypeStr, int32_t removePolicy,
        napi_value displayPixelMap)> resultCb);
    static void MoveObjectAI2RemoveOneStep(std::function<void(bool res, std::string outputTypeStr, int32_t removePolicy,
        napi_value displayPixelMap)> resultCb);
    static void RefreshMoveUndoRedoSize(DOUBLE widthRatio, DOUBLE heightRatio);

    static void UploadMoveExtraPatch(napi_value pixelMap, std::string pixelMapIndex,
                                     std::function<void(bool res)> resultCb);
    static bool UploadMoveExtraPatchSync(napi_value pixelMap, std::string pixelMapIndex);
    static void GetMoveObjectMaskInfo(std::function<void(std::string res)> resultCb);
    static void ReSegmentObject(std::function<void(bool res, std::string optType)> resultCb);
    /*AI编辑-魔法移物相关接口，END*/
    
    /*AI编辑-图片扩图相关接口*/
    static void GetExpandOperation(std::function<void(std::string res, napi_value displayPixelMap)> resultCb);
    static uint64_t GetInitExpandImageInfo(std::function<void(bool res, std::string infos)> resultCb,
                                           bool isCompose);
    static bool CancelInitExpandImageInfo(int64_t initComposeTaskId);
    static void DoImageExpand(double x, double y, double width, double height, double ratio, bool mirror,
                              std::function<void(std::string res, napi_value displayPixelMap)> resultCb);
    static bool CancelImageExpand();
    /*AI编辑-图片扩图相关接口，END*/
    
    /*AI修图大师相关接口*/
    static void DoRefine(STRING configure, std::function<void(STRING res)> resultCb);
    static void DoRefineUploadImage();
    static bool ChangeLightOrBlur(const STRING &configure, std::function<void(bool res)> resultCb);
    static bool ChangeStyleOrCompose(const STRING &configure, std::function<void(bool res)> resultCb);
    static void SetImageConfig(bool apertureFlag, bool portraitFlag, bool cloudCameraFlag, bool aiPSFlag);
    static bool CancelDoRefine();
    static void CancelRefineUpload();
    static bool ReleaseRefineAIGCSource();
    static bool ChangeOutPutPixelMapType(bool isHdr);
    static bool GetStyleThumbs(STRING configure, int ids, std::function<void(napi_value pixelMaps)> resultCb);
    static void FaceDetection(std::function<void(bool res)> resultCb);
    static void DiscardGainMap();
    static bool GetIsDoRefineMasterValue();
    /*AI修图大师相关接口，END*/

    /*AI去反光相关接口*/
    static void RemoveReflection(std::function<void(int32_t resCode, napi_value resPixelMap,
                                 napi_value maskPixelMap)> resultCb);
    static void CancelRemoveReflection(std::function<void(bool cancelSucc)> resultCb);
    static void RemoveReflectionUploadImage();
    static void CancelRemoveReflectionUpload();
    static void GetRemoveReflectOperation(std::function<void(napi_value displayPixelMap)> resultCb);
    /*AI去反光相关接口 END*/
};

struct Timeline {
    static std::string GetVideoLane(int timelineId);
    static std::string AppendVideoLane(int timelineId);
    static std::string AppendVisionLane(int timelineId);
    static void RemoveLane(int timelineId, std::string const &laneId);
    static void SetLaneVisible(int timelineId, std::string const &laneId, bool visible);
};

struct Lane {
    static void AppendAsset(int timelineId, std::string const &laneId, std::string const &path, int mediaType,
        void *inputPixelMap, std::function<void(std::string const &jsonStr)> cb, std::string const & editData,
            bool isMediaSource, bool isSupportWaterMark, bool isFrontCamera, bool isCameraEditData);
    static void GetAsset(int timelineId, std::string const &laneId, std::function<void(std::string const &jsonStr)> cb);
    static void RemoveAllAssets(int timelineId, std::string const &laneId);
    static void ReplaceSource(int timelineId, std::string const & laneId, std::string const & path,
        std::function<void(int32_t res)> cb);
};

struct Motion {
    static double ResetFrictionMotion(double friction, double initPosition, double initVelocity);
    static double GetPosition(double offsetTime);
    static double GetVelocity(double offsetTime);
};

struct Asset {
    static void SetDeviceType(int timelineId, std::string const &assetId, std::string const &deviceType);
    static void setSupportNewWatermark(int timelineId, std::string const &assetId, bool supportNewWatermark);

    static void SetEditDataType(int timelineId, std::string const & assetId, std::string const & type);

    //  没见实现，是否要去除？
    static void GetDuration(int timelineId, const std::string &assetId);
    //  没见实现，是否要去除？
    static void GetPath(int timelineId, std::string const &assetId);
    static void RequestThumbnail(int timelineId, std::string const &assetId,
                                 int64_t startMs, int64_t durationMs, int64_t intervalMs);
    static void requestThumbnailList(int timelineId, std::string const &assetId,
                                 std::vector<int64_t> requestList);
    static void RequestFilterThumbnail(int timelineId, std::string const &assetId);
    static void CancelThumbnail(int timelineId, std::string const &assetId);
    static void SetRotation(int timelineId, std::string const &assetId, double rotation, int axis);
    static void Rotate90Acw(int timelineId, std::string const &assetId, int frame,
                            std::function<void(std::string const &jsonPos)> cb);
    static void Trim(int timelineId, std::string const &assetId, int trimDirection, int offset);
    static int GetTrimOut(int timelineId, std::string const &assetId);
    static void InitCropOperationArea(int timelineId, std::string const &assetId, std::vector<double> inputCropRect,
                                      std::vector<double> boundarySize,
                                      std::function<void(std::string const &jsonPos)> cb);
    static void UpdateCropOperationArea(int timelineId, std::string const &assetId, double left, double top,
                                        double right, double bottom, double canvasWidth, double canvasHeight,
                                        bool isDeviceVertical, int updateCropAreaType,
                                        std::function<void(std::string const &jsonPos)> cb);
    static void ResetPosition(int timelineId, std::string const &assetId,
                              std::function<void(std::string const &jsonPos)> cb);
    static bool SetCropRect(int timelineId, std::string const &assetId, double left, double top, double right,
                            double bottom, double animMs, int clipRatioType, std::string const &chooseRatio,
                            std::function<void(std::string const &jsonPos)> cb);
    static int Translate(int timelineId, std::string const &assetId, double offsetX, double offsetY,
                         int screenOperationType);
    static void Scale(int timelineId, std::string const &assetId, double scale, double centerX, double centerY);
    static void CalculateCropSize(int timelineId, std::string const &assetId,
                                  std::function<void(int width, int height)> cb);
    static float GetPreviewMaxScale(int timelineId, std::string const &assetId);
    static std::string GetCanvasPosition(int timelineId, std::string const &assetId);
    static bool FillCropRect(int timelineId, std::string const &assetId, int cropType, int aniDuration, double left,
                             double top, double right, double bottom,
                             std::function<void(std::string const &jsonPos)> cb);
    static void SwitchPreviewMode(int timelineId, std::string const &assetId);
    static void SwitchCropMode(int timelineId, std::string const &assetId);
    static void SwitchPageRender(int timelineId, std::string const &assetId);
    static void SetEditorAutoFlush(int timelineId, std::string const &assetId);
    static void SetCropAreaEnable(int timelineId, std::string const &assetId, bool enabled);
    static std::string CalcOptimalRectUnderRatio(int timelineId, std::string const &assetId, double left, double top,
                                                 double right, double bottom, double ratio);
    static std::string GetReachableCropRect(int timelineId, std::string const &assetId,
                                            double left, double top, double right, double bottom, double ratio,
                                            int dleft, int dtop, int dright, int dbottom,
                                            std::function<void(std::string const &jsonPos)> cb);
    static std::string ReverseCrop(int timelineId, std::string const &assetId, std::vector<double> inputCropRect,
                                   double ratio, std::vector<int> direction, double pressure);
    static void SetMirror(int timelineId, std::string const &assetId, int mirrorFlag, int mirrorType,
                          std::function<void(std::string const &jsonPos)> cb);
    static void SetMute(int timelineId, std::string const &assetId, int mute);
    static void SetAdjustValue(int timelineId, std::string const &assetId, std::string const &adjustName,
                               double value, std::function<void(std::string const &jsonStr)> cb);
    static void SetAdjustEnable(int timelineId, std::string const &assetId, std::string const &adjustName,
                                bool enabled, std::function<void(std::string const &jsonStr)> cb);
    static void SetAdjustValueAndEnable(int timelineId, std::string const &assetId, std::string const &adjustName,
                                        double value, std::function<void(std::string const &jsonStr)> cb);
    static void PreloadAdjustResource(int timelineId, std::string const &assetId);
    static void SetVideoInnerAudioVolume(int timelineId, std::string const &assetId, int volume);
    static std::string GetAdjustProperty(int timelineId, std::string const &assetId);
    static void ResetAdjustProperty(int timelineId, std::string const &assetId);
    static void SetRefreshRate(int timelineId, std::string const &assetId, int refreshRate);
    static void SetSourceByPixelMap(int timelineId, std::string const &assetId, void* pixels);
    static void AddStylus(int timelineId, std::string const & assetId, void *dstPixel, int x, int y, int width,
        int height, std::function<void(napi_value value)> cb);
    static int SetOriginalColorMode(int timelineId, std::string const &assetId, int mode);
    static int GetOriginalColorMode(int timelineId, std::string const &assetId);
    static void RequestAssetAudioWave(int timelineId, std::string const &assetId, int64_t stattimestamp,
                                      int64_t audioDuration, int64_t previewDuration, int previewPoints);
    static int AssetIsInCurrentTime(int timelineId, std::string const &assetId);
    static void SetUserData(int timelineId, std::string const &assetId, std::string const &key, double value);
    static double GetUserData(int timelineId, std::string const &assetId, std::string const &key);
    static void SwitchCropPage(int timelineId, std::string const &assetId, int pageId);
    static bool GetRefreshThumbnails(int timelineId, std::string const &assetId);
    static void FinishAnimation(int timelineId, std::string const &assetId);
    static void ApplyCameraEditData(int timelineId, std::string const &assetId, std::string const &editData,
                                    std::function<void(std::string const &jsonPos)> cb);
    static void DoWatermarkAnimation(int timelineId, std::string const &assetId, bool isShow, int64_t animMs,
                                     std::function<void(std::string const &jsonPos)> cb);
    static void CalculateFrameSize(int width, int height, STRING const &watermarkType, STRING const &editData,
                                   std::function<void(std::string const &jsonPos)> cb);
    // 个性风格接口
    static void AddXtStyleParamToWatermark(int timelineId, std::string const &assetId,
                       VECTOR<STRING> const &xtStyleTextParams, bool autoFlush, bool needInitCache);
    static void RequestXTStyleThumbnail(int timelineId, std::string const &assetId, std::vector<int> xtStyleParams);
    static void DoXtStyleAnimation(int timelineId, std::string const &assetId, bool isOpen);
    static void DoXtStyleTriFoldAnimation(int timelineId, std::string const &assetId, std::vector<double> doubleParams,
                                           VECTOR<bool> boolParams,
                                          std::function<void(std::string const &jsonPos)> cb);
    static void SetPreviewMode(int timelineId, std::string const &assetId, bool value);
    static void SetShowWatermarkValue(int timelineId, std::string const &assetId, bool value);
    static void RefreshCompareEffectList(int timelineId, std::string const &assetId);
    static STRING GetCurrentXtStyleParams(int timelineId, std::string const &assetId);
    static void SwitchTabWidthWatermarkAnim(int timelineId, std::string const &assetId, int waterMarkType, int cost);
    static void CalculateFocusPosition(int timelineId, const std::string &assetId,
                                       std::function<void(double positionX, double positionY, int fNum)> cb);
    static void GetExportSize(int timelineId, const std::string &assetId,
                                       std::function<void(int width, int height)> cb);
    
    static double GetIntelligentCorrectionValue(int timelineId, std::string const &assetId);
    static bool HasWatermarkEditDataXtStyleCode(HmcVisionAsset* visionAsset);
    static bool HasXtStyleCode(HveAsset *hveAsset);
    static void RefreshWatermarkCache(int timelineId, const std::string &assetId);
    static VECTOR<INT32> GetExifXtStyleParam(int timelineId, const std::string &assetId);
    
    static double IsSupportsDifferentiatedAlgorithms(std::string const &editData);
    static double ImageEffectRestore(Json::Value restoreInfoData);
    static double Restore(Json::Value restoreInfoData);
    static STRING GetXtStyleName(int timelineId, std::string const &assetId);
    static void DoPreviewAvoidanceAnimation(int timelineId, std::string const &assetId,
        std::vector<double> doubleParams, std::function<void(std::string const &jsonPos)> cb);
    static bool IsAllowEditXtStyle(int timelineId, const std::string &assetId);

    // 一拍多得接口
    static bool SetProjectConfigValue(const STRING &key, const STRING &value);
    static void GeneratorRfDataB(int timelineId, std::string const & assetId, std::function<void(bool res)> cb);
};

struct NAPIMaterial {
    static void InitEnv(std::string const &version);
};

#endif // OH_INDEX_H
