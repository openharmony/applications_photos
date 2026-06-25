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

#include "interface/index.h"

#include "hve/Project.h"
#include "hve/ProjectConfig.h"
#include "hve/HveAssetOper.h"
#include "log/HmcLog.h"
#include "common/HmcDictHelper.h"
#include "common/Animation.h"
#include "common/motion/FrictionMotion.h"
#include "ohos/BackgroundTaskManager.h"
#include "ohos/common/HmcUidHelper.h"
#include "ohos/interface/JSArguments.hpp"
#include "render/graphic/HmcNativeWindow.h"
#include "render/platform/ohos/nativerender/render/plugin_render.h"
#include "common/lpsolver/simplex.h"
#include "string/HmcString.h"
#include "util/HmcRectD.h"
#include <vector>
#include "undoredo/UndoRedoManager.h"
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include "HmcService.h"
#include "util/HveBridgeUtil.h"
#include "util/ExifTransformUtil.h"
#include "MediaCreative.h"
#include "hve/HveMaterial.h"

const float MAXIMUM_RESOLUTION = 8192.0f; // 导入时视频和图片支持的最大分辨率

constexpr char *BRIDGE_DATA_ROOT_KEY = "";

bool needExtraInfo = true;

const int IS_FRONT_CAMERA = 2; // 传入图片为手机前置拍照

// 一键美肤场景下如果编辑数据为空，或者编辑数据中没有extra_info字段，则序列化时去掉extra_info字段
void EditorContext::CheckEditData(std::string const editdata)
{
    Json::Reader reader;
    Json::Value jsonEditData;
    reader.parse(editdata, jsonEditData);

    if (editdata.empty() || !jsonEditData.isMember("extra_info") || jsonEditData["extra_info"].empty()) {
        needExtraInfo = false;
    } else {
        needExtraInfo = true;
    }
}

/*
 * 美肤时调用。如果有除雾等预处理效果，美肤时会先在子线程中调用预处理效果器，而在主线程中美肤会加入到预处理器列表中，
 * 导致调用两次美肤效果器，此处会等待子线程完成后再将美肤加入预处理器列表。
 */
void EditorContext::WaitTaskFinish(int timelineId, std::function<void()> cb)
{
    USE_EDITOR()
    static_cast<HmcEditorImp *>(editor)->HmcWaitTaskFinish(cb);
}

// 一键美肤场景调用，如果编辑数据中有 extra_info 字段则不需要额外处理 exif
void EditorContext::ProcessExifInfo(int timelineId, std::string const & assetId)
{
    if (needExtraInfo) {
        return;
    }
    
    USE_EDITOR()
    HmcUid assetUid = HmcUidHelper(assetId);
    ExifTransformUtil::ProcessExifOnExist(timeline, assetUid, false, false);
}

bool AssetSizeIsExchanged2(float baseRotation)
{
    if (baseRotation == 90 || baseRotation == 270) {
        return true;
    }
    return false;
}

void EditorContext::CallEmpty(std::function<void(int64_t val)> cb)
{
    LOGD("%s invoked", __FUNCTION__);
    BACKGROUND_TASK_MGR->Submit([=]() {
        cb((int64_t)0);
        LOGD("EditorContext_callEmpty finished");
    },
        __FUNCTION__);
}
void EditorContext::CreateTimeline(CreateTimelineParam const &param,
    std::function<void(std::string const & jsonPos)> sdkCallback,
    std::function<void(std::string const & jsonPos)> createResult)
{
    HmcUid projectUid = HmcUidHelper(param.projectId);
    LOGI("EditorContext_createTimeline UID=%s, mediaType=%d", param.projectId.c_str(), param.mediaType);
    ProjectConfig::Instance().SetValueByKey("HdrShownOpen", std::to_string(param.isHdrShownOpen));
    ProjectConfig::Instance().SetValueByKey("HideWatermarkResource", std::to_string(param.isHideWatermarkResource));
    ProjectConfig::Instance().SetValueByKey("AiWatermarkEnabled", std::to_string(param.isAiWatermarkEnabled));
    int mediaType = param.mediaType;
    std::string editData = param.editData;
    BACKGROUND_TASK_MGR->Submit([projectUid, mediaType, sdkCallback, createResult, editData]() {
        LOGD("createTimeline begin");
        Project::Instance().CreateTimeline(projectUid, mediaType, sdkCallback, createResult, editData);
        LOGD("createTimeline end");
    },
        __FUNCTION__);
}
std::string EditorContext::ModifyTimeline(int timelineId, std::string const & jsonAttr)
{
    USE_TIMELINE("{}")
    Json::Value json;
    Json::Reader reader;
    Json::FastWriter fastWriter;
    reader.parse(jsonAttr, json);
    Json::Value ret = timeline->modify(json);
    return fastWriter.write(ret);
}
void EditorContext::BindTimelineWithXComponent(int timelineId, std::string xComponentId, double canvasWidth,
    double canvasHeight, std::function<void(int width, int height)> cb)
{
    USE_TIMELINE()

    LOGI("bindTimelineWithXComponent begin. canvasWidth=%lf, canvasHeight=%lf", canvasWidth, canvasHeight);
    HmcNativeWindow *nativeWindow = PluginRender::GetInstance(xComponentId)->nativeWindow_;
    if (nativeWindow->window_ == nullptr) {
        LOGE("nativeWindow->window_ is nullptr.");
        HmcNativeWindow *jsNativeWindow = GetNativeWindow();
        if (jsNativeWindow == nullptr) {
            LOGE("nativeWindow from js is nullptr");
            return;
        }
        if (jsNativeWindow->width_ != 0 && jsNativeWindow->height_ != 0 && jsNativeWindow->window_!= nullptr) {
            nativeWindow->SetWindowParams(jsNativeWindow->window_, jsNativeWindow->width_, jsNativeWindow->height_);
        }
    } else {
        LOGI("nativeWindow->window_ not nullptr, bindTimelineWithXComponent id=%s, timelineId=%d",
             xComponentId.c_str(), timelineId);
    }

    HmcEditorSetPreviewWindow(timeline->GetEditor(), nativeWindow);
    HmcEditorSetCanvasSize(timeline->GetEditor(), static_cast<float>(canvasWidth), static_cast<float>(canvasHeight));
    cb(canvasWidth, canvasHeight);
}
void EditorContext::PlayTimeline(int timelineId, int64_t startTime, int64_t endTime)
{
    USE_EDITOR()
    HmcEditorPlay(editor, startTime, endTime);
}

void EditorContext::PauseTimeline(int timelineId)
{
    USE_EDITOR()
    BACKGROUND_TASK_MGR->Submit([editor]() {
        HmcEditorPause(editor);
    },
        __FUNCTION__);
}

void EditorContext::SeekTimeline(int timelineId, int64_t timeMs, bool isExactMode)
{
    USE_EDITOR()
    HmcEditorSeekTo(editor, timeMs, isExactMode);
}

static std::string SerializeEditData(int timelineId, std::string const & assetId)
{
    USE_ASSET("")

    std::string editData = HmcEditorGetEditData(editor);

    Json::Value editDataJson;
    Json::Reader reader;
    reader.parse(editData, editDataJson);
    Json::Value bridgeData = timeline->SerializeBridgeData();

    editDataJson[BRIDGE_DATA_ROOT_KEY] = bridgeData;
    Json::FastWriter fastWriter;
    
    Json::Value systemJson;
    Json::Value imageEffectJson = HmcEditorGetImageEffectJson(editor);
    if (needExtraInfo) {
        imageEffectJson["extra_info"] = editDataJson;
    }
    needExtraInfo = true;

    // 最终存到媒体库的是systemJson
    return fastWriter.write(imageEffectJson);
}

static void DeSerializeEditData(int timelineId, const std::string &editData)
{
    USE_EDITOR()

    Json::Value editDataJson;
    Json::Reader reader;
    reader.parse(editData, editDataJson);
    if (!editDataJson.isMember(BRIDGE_DATA_ROOT_KEY)) {
        LOGE("deserialize bridge data failed, can not find filed: %s", BRIDGE_DATA_ROOT_KEY);
        return;
    }
    if (editDataJson[BRIDGE_DATA_ROOT_KEY].type() != Json::objectValue) {
        LOGE("deserialize bridge data failed, can not find filed: %s", BRIDGE_DATA_ROOT_KEY);
        return;
    }
    Json::Value json = editDataJson[BRIDGE_DATA_ROOT_KEY];
    timeline->DeserializeBridgeData(json);
}


static void SetPictureHmcDict(HmcDictHelper &dict, std::string path, std::string mimeType, std::string const assetId,
    INT32 exportW, INT32 exportH, auto cropRect)
{
    // picture need set below parameters
    dict[PROJECT_KEY_IMAGE_EXPORT_PATH] = path;
    dict[PROJECT_KEY_IMAGE_MIMETYPE] = mimeType;
    dict[PROJECT_KEY_MEDIA_EXPORT_TYPE] = HMC_EXPORT_MEDIA_TYPE_IMAGE;
    dict[PROJECT_KEY_ASSET_ID] = assetId;

    // video and picture all need set below parameters
    dict[PROJECT_KEY_VIDEO_WIDTH] = exportW;
    dict[PROJECT_KEY_VIDEO_HEIGHT] = exportH;
    dict["export_crop_left"] = cropRect.left;
    dict["export_crop_top"] = cropRect.top;
    dict["export_crop_right"] = cropRect.right;
    dict["export_crop_bottom"] = cropRect.bottom;
}

static void calculateExportSize(HveTimeline *timeline, HmcUid assetUid, INT32 &exportW, INT32 &exportH)
{
    HmcSize originalSize;
    HmcAssetGetSize(timeline->GetEditor(), assetUid, HMC_SIZE_ORIGINAL, &originalSize);
    HmcSize assetSize;
    HmcAssetGetSize(timeline->GetEditor(), assetUid, HMC_SIZE_RENDER, &assetSize);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    //  线程中这里取值不安全，需要改成先取，通过lamdab传入的方式来比较,后面去掉2，和NAPIService冲突
    if (AssetSizeIsExchanged2(hveAsset->GetBaseRotation())) {
        std::swap(assetSize.width, assetSize.height);
        std::swap(originalSize.width, originalSize.height);
    }
    exportW = originalSize.width;
    exportH = originalSize.height;

    auto cropRect = timeline->GetCropRect();
    double cropRectWidth = cropRect.Width();
    double cropRectHeight = cropRect.Height();
    if ((cropRectWidth > 0) && (cropRectHeight > 0) && (assetSize.width > 0) && (assetSize.height > 0)) {
        exportW = round(cropRectWidth / assetSize.width * originalSize.width);
        exportH = round(cropRectHeight / assetSize.height * originalSize.height);
    }
}

void EditorContext::getExportRect(int timelineId, std::string const & assetId, std::function<void(INT32, INT32)> cb)
{
    LOGI("getExportRect, timelineId=%d, assetId=%s", timelineId, assetId.c_str());
    USE_EDITOR()
    HmcUid assetUid = HmcUidHelper(assetId);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    ASSERT_LOG(hveAsset == nullptr, "asset is null.");
    INT32 exportW;
    INT32 exportH;
    calculateExportSize(timeline, assetUid, exportW, exportH);
    cb(exportW, exportH);
}

void EditorContext::EncodePixelMap(int timelineId, const STRING &path, const STRING &assetId, const STRING &editData,
    const STRING &mimeType, OH_PixelmapNative *dstPixel, const STRING &waterMarkInfo,
    std::function<void(STRING const & json, STRING const & type)> callback)
{
    USE_EDITOR()
    HmcDict *dict = HmcDictCreate();
    HmcDictSetString(dict, PROJECT_KEY_IMAGE_EXPORT_PATH, path.c_str());
    HmcDictSetString(dict, PROJECT_KEY_IMAGE_MIMETYPE, mimeType.c_str());
    HmcDictSetString(dict, "waterMarkInfo", waterMarkInfo.c_str());
    std::string exportEditData = SerializeEditData(timelineId, assetId);
    HmcDictSetString(dict, "editData", exportEditData.c_str());
    
    OH_PictureNative *dstPicture = nullptr;
    LOGI("EncodePixelMap flow2Base Picture not exists.");
    Image_ErrorCode errorCode = OH_PictureNative_CreatePicture(dstPixel, &dstPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || dstPicture == nullptr) {
        LOGE("EncodePixelMap CreatePicture errorCode=%d", errorCode);
        OH_PixelmapNative_Release(dstPixel);
        return;
    }
    OH_PixelmapNative_Release(dstPixel);
    // 处理exif带旋转角度的
    HmcUid assetUid = HmcUidHelper(assetId);
    STRING orientation = ExifTransformUtil::ProcessExifOnExistForPicture(assetUid, dstPicture);
    HmcDictSetString(dict, "orientation", orientation.c_str());
    BACKGROUND_TASK_MGR->Submit([editor, dstPicture, dict, callback]() {
        HmcEditorEncodePicture(editor, dstPicture, dict, callback);
    },
        __FUNCTION__);
}

void EditorContext::ReleaseFlowSource(int flowType)
{
}

void EditorContext::CompileTimeline(int timelineId, std::string path, std::string const & assetId, int mediaType,
    std::string mimeType, std::function<void(std::string const & json, std::string const & type)> callback,
    bool autoFlush = false)
{
    BACKGROUND_TASK_MGR->Submit([mediaType, path, mimeType, assetId, timelineId, callback, autoFlush]() {
    LOGI("compileTimeline, timelineId=%d, path=%s, assetId=%s, mediaType=%d, mimeType=%s, autoFlush=%d",
        timelineId, path.c_str(), assetId.c_str(), mediaType, mimeType.c_str(), autoFlush);
    USE_EDITOR()
    HmcUid assetUid = HmcUidHelper(assetId);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    ASSERT_LOG(hveAsset == nullptr, "asset is null.")
    HmcEditorSetAutoFlush(editor, autoFlush);
    ExifTransformUtil::ProcessExifOnExist(timeline, assetUid, false, true, false);
    timeline->UpdateCompileParameter(true);

    HmcDictHelper dict;
    auto cropRect = timeline->GetCropRect();
    INT32 exportW;
    INT32 exportH;
    calculateExportSize(timeline, assetUid, exportW, exportH);
    LOGD("compileTimeline calculate export width: %d, height: %d", exportW, exportH);
    double fps = 0.0f;
    int64_t result = 0;
    INT32 bitRate = 0;
    result = HmcEditorCalcWidthAndLength(exportW, exportH, mediaType);
    if (result == HMC_OK) {
        SetPictureHmcDict(dict, path, mimeType, assetId, exportW, exportH, cropRect);
        std::string editDataType = hveAsset->GetEditDataType();
        LOGI("editDataType: %s", editDataType.c_str());
        HmcEditExportFunc func = {
            .exportType = 0,
            .needAddWatermark = true,
            .exportInfoFunc =
                [exportW, exportH, fps, bitRate, timelineId, assetId, callback, timeline,
                 editDataType](std::string watermarkData) {
                    HmcUid assetUid = HmcUidHelper(assetId);
                    // 导出时先还原EXIF预览效果，导出完成后重做EXIF预览，避免预导出取消后图片旋转显示异常
                    std::string editData = SerializeEditData(timelineId, assetId);
                    callback(editData, editDataType);
                    ExifTransformUtil::ProcessExifOnExist(timeline, assetUid, false, false, false);
                },
        };
        HmcDictSetInt32(dict, "compose_export", EXPORT_TYPE_SAVE);
        result = HmcEditorStartExporting(editor, dict, func);
    }
    LOGI("fps=%f, bitRate=%d, exportW=%d, exportH=%d, result=%d", fps, bitRate, exportW, exportH, result);
    if (result != HMC_OK) {
        ExifTransformUtil::ProcessExifOnExist(timeline, assetUid, false, false, false);
        HmcEditorExportResultNotify(editor, result);
    }
    }, __func__);
}

void EditorContext::CompileTimelinePixelMap(int timelineId, STRING path, bool isOriginColor, STRING const & assetId,
    int mediaType, std::function<void(napi_value value, STRING const & json, STRING waterMarkInfo)> callback,
    bool isToAiPage, bool needAddWatermark, bool isSave)
{
    BACKGROUND_TASK_MGR->Submit([timelineId, assetId, mediaType, isOriginColor, path, needAddWatermark, isSave,
        callback, isToAiPage]() {
    LOGI("CompileTimelinePixelMap, timelineId=%d, assetId=%s, mediaType=%d", timelineId, assetId.c_str(), mediaType);
    USE_EDITOR()
    HmcUid assetUid = HmcUidHelper(assetId);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    ASSERT_LOG(hveAsset == nullptr, "asset is null.")
        
    HmcEditorSetAutoFlush(editor, false);
    timeline->UpdateCompileParameter(true);

    HmcDictHelper dict;
    auto cropRect = timeline->GetCropRect();
    INT32 exportW;
    INT32 exportH;
    calculateExportSize(timeline, assetUid, exportW, exportH);

    HmcDictSetInt32(dict, "export_type", 1);
    int curColor = HmcAssetGetOriginalColorMode(assetUid);
    HmcAssetSetOriginalColorMode(editor, assetUid, isOriginColor ? 1 : curColor);
    int64_t result = HmcEditorCalcWidthAndLength(exportW, exportH, mediaType);
    if (result == HMC_OK) {
        SetPictureHmcDict(dict, path, "", assetId, exportW, exportH, cropRect);

        HmcEditExportFunc func = {
            .exportType = 1,
            .needAddWatermark = needAddWatermark,
            .isSave = isSave,
            .exportPixelmapFunc =
                [callback, timelineId, assetId, curColor, editor, assetUid, isToAiPage,
                  exportW, exportH](HmcPixelMapInfo *info) {
                    std::string editData = SerializeEditData(timelineId, assetId);
                    LOGI("CompileTimelinePixelMap, Change type = %d", isToAiPage);
                    OH_PictureNative_Release(info->nativePicture);
                    HmcUid assetUid = HmcUidHelper(assetId);
                    // 预先将 显示信息 降为 2k 防止水印回贴场景读取到异常值，导致水印动画回贴异常
                    HmcUpdateDownSimplerDisplayInfo(editor, assetUid, exportW, exportH);
                    callback(info->pixelmapNapi, editData, info->waterMarkInfos);
                    delete info;
                    HmcAssetSetOriginalColorMode(editor, assetUid, curColor);
                }
        };

        result = HmcEditorStartExporting(editor, dict, func);
    }

    LOGI("CompileTimelinePixelMap, exportW=%d, exportH=%d, result=%d", exportW, exportH, result);
    if (result != HMC_OK) {
        HmcEditorExportResultNotify(editor, result);
    }
    }, __func__);
}

void EditorContext::CancelCompileTimeline(int timelineId, std::string const & assetId, std::function<void()> callback)
{
    USE_EDITOR()
    BACKGROUND_TASK_MGR->Submit([editor, callback, timeline]() {
        timeline->UpdateCompileParameter(false);
        HmcEditorCancelExporting(editor);
        // 保存时暂停自动刷新, 取消保存时清楚缓存计数并恢复自动刷新
        HmcEditorSetAutoFlush(editor, true);
        callback();
    },
        __FUNCTION__);
}

void EditorContext::SetThumbnailCallback(int timelineId,
    std::function<void(const std::string &, const std::string &, int64_t pts, ArrayBuffer const &, int, int)> cb)
{
    USE_TIMELINE()
    timeline->SetThumbnailCallback(cb);
}

void EditorContext::SetFilterThumbnailCallback(int timelineId, std::function<void(const std::string &,
    const std::string &, const std::string &, int64_t pts, napi_value pixelmapNapi, int, int)>
                                                                   cb)
{
    USE_TIMELINE()
    timeline->SetFilterThumbnailCallback(cb);
}

void EditorContext::SetPreviewPeriodRange(int timelineId, int64_t startTime, int64_t endTime)
{
    LOGD("%s invoked", __FUNCTION__);
    USE_EDITOR()
    HmcEditorSetPreviewPeriodRange(editor, static_cast<uint64_t>(startTime), static_cast<uint64_t>(endTime));
}

void EditorContext::SaveProject(int timelineId, std::function<void(std::string const & jsonPos)> cb)
{
    USE_EDITOR()
    timeline->SerializeBridgeData();
    HmcEditorPause(editor);
    //  保存需要花费的时间来决策是否异步
    BACKGROUND_TASK_MGR->Submit([editor, cb]() {
        LOGD("saveProject begin");

        Json::Value json;
        Json::FastWriter fastWriter;
        json["code"] = HMC_OK;
        cb(fastWriter.write(json));
        LOGD("saveProject end");
    },
        __FUNCTION__);
}
void EditorContext::CloseProject(int timelineId, std::function<void(std::string const & jsonPos)> cb)
{
    USE_EDITOR()
    //  关闭需要花费的时间来决策是否异步
    CancelAnimation();
    Project::Instance().CloseTimeline(timelineId);
    ffrt::submit([timelineId, editor, cb]() {
        BACKGROUND_TASK_MGR->Wait();
        LOGI("closeProject begin");
        // 关闭工程时，在此处清理数据
        UNDO_REDO_MGR->Clear();
        HmcEditorClose(editor);
        ClearAllOpenedFds();
        Project::Instance().Clear(timelineId);
        ProjectConfig::Instance().DeInit();
        Json::Value json;
        Json::FastWriter fastWriter;
        json["code"] = HMC_OK;
        cb(fastWriter.write(json));
        LOGI("closeProject end");
    });
}

std::string EditorContext::UpdateEditData(const std::string &data)
{
    Json::Value jsonEditData;
    Json::Reader reader;
    bool parseResult = reader.parse(data, jsonEditData);
    if (!parseResult) {
        LOGE("update edit data failed, data is not valid json format.");
        return data;
    }
    if (SINGLETON(HmcProjectEntity)->CheckHMCEditorDataSignature(jsonEditData)) {
        // 场景一：旧版本的编辑组件数据
        LOGI("update HMC edit data");
        Json::Value jsonExtraInfo;
        jsonExtraInfo["extra_info"] = jsonEditData;
        Json::Value jsonUpdatedEditData = jsonExtraInfo;
        return Json::FastWriter().write(jsonUpdatedEditData);
    }
    if (SINGLETON(HmcProjectEntity)->CheckSystemEditorDataSignature(jsonEditData)) {
        Json::Value jsonUpdatedEditData = jsonEditData["system"];
        return Json::FastWriter().write(jsonUpdatedEditData);
    }
    if (SINGLETON(HmcProjectEntity)->CheckThirdEditorDataSignature(jsonEditData)) {
        Json::Value jsonUpdatedEditData = jsonEditData["third"];
        return Json::FastWriter().write(jsonUpdatedEditData);
    }

    LOGE("update edit data failed, data is not valid version format.");
    return data;
}

bool EditorContext::IsSystemEditData(std::string const &data)
{
    return HmcEditorIsSystemEditData(data);
}

bool EditorContext::IsThirdEditData(std::string const &data)
{
    return HmcEditorIsThirdEditData(data);
}

bool EditorContext::HasWatermarkEffect(std::string const &data, std::function<void(std::string const &jsonPos)> cb)
{
    return HmcEditorHasWatermarkEffect(data, cb);
}

DOUBLE EditorContext::GetCropRotation(std::string const &data)
{
    return HmcEditorGetCropRotation(data);
}

bool EditorContext::IsOldFilterEditData(std::string const &data)
{
    Json::Value jsonImageEffect;
    Json::Reader reader;
    bool parseResult = reader.parse(data, jsonImageEffect);
    if (!parseResult) {
        LOGE("update edit data failed, data is not valid json format.");
        return false;
    }
    if (!JsonValueUtil::IsMemberAndNotNull(jsonImageEffect, "imageEffect")) {
        return false;
    }
    Json::Value filters = jsonImageEffect["imageEffect"];
    if (filters.isMember("filters") && filters["filters"].isArray()) {
        for (const auto &jsonFilter : filters["filters"]) {
            if (!JsonValueUtil::IsString(jsonFilter, "name")
                || jsonFilter["name"].asString().compare("HMCEFilter") != 0) {
                continue;
            }
            if (!JsonValueUtil::IsMemberAndNotNull(jsonFilter, "values")) {
                continue;
            }
            Json::Value jsonValues = jsonFilter["values"];
            if (JsonValueUtil::IsString(jsonValues, "m_effectType")
                && jsonValues["m_effectType"].asString().compare("filter") == 0) {
                return true;
            }
        }
    }
    return false;
}

void InitPreviewEnv(HveTimeline *timeline, const HmcUid &assetUid)
{
    HmcEditor *editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("InitPreviewEnv failed, asset is null.");
        return;
    }

    hveAsset->SwitchPreviewMode(timeline->GetCropRect(), timeline->GetCropOperationArea(), false);

    if (hveAsset->GetType() == HMC_ASSET_IMAGE) {
        hveAsset->SwitchCropMode();
    }
    HmcEditorSetAutoFlush(editor, false);

    BACKGROUND_TASK_MGR->Submit([editor, assetUid]() {
        HmcAssetDelayInit(editor, assetUid);
    },
        __FUNCTION__);
}

static int DeserializeData(HveTimeline *timeline, HmcEditor *editor, std::string &msg, int sourceFileFd,
                           const std::string &editdata,
                           std::function<void(std::string const &assetId)> onDecodePicture)
{
    int32_t result = HMC_OK;
    if (editor == nullptr) {
        LOGE("ApplyEditData failed, editor is null. ");
        result = HMC_ERR_PARAM;
        msg = "invalid timeline id, get timeline obj failed.";
        return result;
    }

    int errorCode = HMC_ERR_EDITDATA_BASE;
    if (sourceFileFd == HMC_INVALID_FD) {
        LOGE("ApplyEditData failed, timeline is null. %d", timeline->GetHveTimelineId());
        result = HMC_ERR_PARAM;
        msg = "source fd is invalid(-1).";
        return result;
    }
    HmcEditorApplyEditData(editor, sourceFileFd, editdata, errorCode, onDecodePicture);

    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(editdata, jsonEditData);
    if (!parseResult) {
        result = HMC_ERR_PARAM;
        LOGE("apply edit data failed because of parsing data to json object.");
        return result;
    }

    timeline->SyncDataFromService();
    if (errorCode == HMC_ERR_EDITDATA_NO_EXTRA_INFO || errorCode == HMC_ERR_EDITDATA_NO_SIGNATURE) {
        result = HMC_ERR_DICT_KEY;
        LOGE("apply edit data failed because of CheckHMCEditorDataSignature false.");
        return result;
    }
    if (errorCode != HMC_OK) {
        result = HMC_ERR;
        return result;
    }

    Json::Value systemJson = jsonEditData;
    DeSerializeEditData(timeline->GetHveTimelineId(), Json::FastWriter().write(systemJson["extra_info"]));
    return result;
}

static bool verifyLaneAssetUid(HmcUid &laneUid, HmcUid &assetUid, int32_t &result, std::string &msg)
{
    if (HmcUidIsNull(&laneUid)) {
        LOGE("ApplyEditData failed, laneUid is null. ");
        result = HMC_ERR_SERVICE_LANE_INVALID;
        msg = "deserialize lane object failed.";
        return false;
    }

    if (HmcUidIsNull(&assetUid)) {
        LOGE("ApplyEditData failed, assetUid is null. ");
        result = HMC_ERR_SERVICE_ASSET_INVALID;
        msg = "deserialize asset object failed.";
        return false;
    }
    return true;
}

void EditorContext::ApplyEditData(int timelineId, int sourceFileFd, const std::string &editdata, int mediaType,
                                  std::function<void(std::string const &jsonStr)> cb,
                                  std::function<void(std::string const &assetId)> onDecodePicture)
{
    BACKGROUND_TASK_MGR->Submit([timelineId, sourceFileFd, editdata, mediaType, cb, onDecodePicture] {
        LOGI("ApplyEditData begin, sourceFileFd=%d, editdata=%s", sourceFileFd, editdata.c_str());
        int32_t result = HMC_OK;
        std::string msg = "success";
        Json::Value data;
        do {
            HveTimeline *timeline = Project::Instance().GetTimeline(timelineId);
            if (nullptr == timeline) {
                LOGE("ApplyEditData failed, timeline is null. %d", timelineId);
                result = HMC_ERR_PARAM;
                msg = "invalid timeline id, get timeline obj failed.";
                break;
            }

            HmcEditor *editor = timeline->GetEditor();
            result = DeserializeData(timeline, editor, msg, sourceFileFd, editdata, onDecodePicture);
            if (result == HMC_ERR) {
                return;
            } else if (result != HMC_OK) {
                break;
            }

            HmcUid laneUid = HmcEditorGetPreLaneUid(editor);
            HmcUid assetUid = HmcEditorGetPreAssetUid(editor);
            if (!verifyLaneAssetUid(laneUid, assetUid, result, msg)) {
                break;
            }

            InitPreviewEnv(timeline, assetUid);
            ExifTransformUtil::ProcessExifOnExist(timeline, assetUid, true, false);
            HveAssetOper::UpdateBaseRotationAssetSize(timeline, assetUid); // 解决再编辑旋转缩放问题
            data["lane"] = HmcUidToString(&laneUid).c_str();
            data["asset"] = HmcUidToString(&assetUid).c_str();
        } while (false);
        Json::Value ret;
        ret["data"] = data;
        ret["result"] = result;
        ret["msg"] = msg.c_str();
        Json::FastWriter fastWriter;
        cb(fastWriter.write(ret));
    },
        __FUNCTION__);
}

void EditorContext::UndoRedoManagerClear()
{
    UNDO_REDO_MGR->Clear();
}

void EditorContext::Reset(int timelineId, bool refreshExif, std::string const assetId,
    std::function<void(std::string const & jsonStr)> cb)
{
    LOGI("reset function has been invoked.");
    USE_TIMELINE();
    BACKGROUND_TASK_MGR->Submit(
        [timelineId, refreshExif, assetId, cb] {
            LOGI("reset task is running begin.");
            int32_t result = HMC_OK;
            std::string msg = "success";
            Json::Value data;

            do {
                HveTimeline *timeline = Project::Instance().GetTimeline(timelineId);
                if (nullptr == timeline) {
                    LOGE("reset failed, timeline is null. %d", timelineId);
                    result = HMC_ERR_PARAM;
                    msg = "invalid timeline id, get timeline obj failed.";
                    break;
                }

                timeline->Reset();
                if (refreshExif && &assetId != nullptr) {
                    HmcUid assetUid = HmcUidFromString(assetId);
                    ExifTransformUtil::ProcessExifOnExist(timeline, assetUid, true, false);
                }
            
                data = timeline->getAssets()[0];
            } while (false);

            std::string ret = HveBridgeUtil::BuildCommonResult(result, msg, data);

            cb(ret);

            LOGI("reset task run finish.");
        },
        __FUNCTION__);
}

void EditorContext::SetConfigChangeCallback(int timelineId, std::function<void(bool)> cb)
{
    USE_TIMELINE()
    timeline->SetConfigChangeCallback(cb);
}

void EditorContext::CalConfigChangeCallback(int timelineId)
{
    USE_TIMELINE()
    timeline->CalConfigChangeCallback();
}

int64_t EditorContext::GetCacheSize()
{
    auto size = HmcEditorGetCacheSize();
    return static_cast<int64_t>(size);
}

void EditorContext::ClearCache()
{
    HmcEditorClearCache(0);
}

std::string EditorContext::Undo()
{
    return UNDO_REDO_MGR->Undo();
}
std::string EditorContext::Redo()
{
    return UNDO_REDO_MGR->Redo();
}

void EditorContext::Start()
{
    UNDO_REDO_MGR->Start();
}
void EditorContext::Stop()
{
    UNDO_REDO_MGR->Stop();
}

void EditorContext::RegUndoRedoStateChangeCb(
    std::function<void(bool undoEnable, bool redoEnable)> undoRedoStateChangeCb)

{
    UNDO_REDO_MGR->RegUndoRedoStateChangeCb(undoRedoStateChangeCb);
}

void EditorContext::SetAutoFlush(int timelineId, bool autoFlush)
{
    USE_EDITOR()
    HmcEditorSetAutoFlush(editor, autoFlush);
}

std::string Timeline::GetVideoLane(int timelineId)
{
    USE_TIMELINE("{}")

    Json::Value ret = timeline->getVideoLanes();
    ASSERT_RET(ret.size() == 0, "{}")
    Json::FastWriter fastWriter;
    // 当前轨道只有一个，先默认返回第一个
    return fastWriter.write(ret[0]);
}

std::string Timeline::AppendVideoLane(int timelineId)
{
    USE_EDITOR("{}")
    LOGI("appendVideoLane begin, timelineId=%d", timelineId);
    HmcUid laneUid = timeline->AppendLane(HMC_LANE_VISION);
    LOGD("appendVideoLane end");

    if (HmcUidIsNull(&laneUid)) {
        LOGD("appendVideoLane laneUid is Null");
        HmcEditorImportResultNotify(editor, HMC_ERR_SERVICE_LANE);
    }
    //  这里是否直接返回uid就可以了
    Json::Value json;
    json["uid"] = (std::string)HmcUidHelper(laneUid);
    Json::FastWriter fastWriter;
    return fastWriter.write(json);
}

std::string Timeline::AppendVisionLane(int timelineId)
{
    USE_TIMELINE("{}")
    LOGD("appendVisionLane begin");
    HmcUid laneUid = timeline->AppendLane(HMC_LANE_VISION);
    LOGD("appendVisionLane end");

    //  这里是否直接返回uid就可以了
    Json::Value json;
    json["uid"] = (std::string)HmcUidHelper(laneUid);
    Json::FastWriter fastWriter;
    return fastWriter.write(json);
}

void Timeline::RemoveLane(int timelineId, std::string const & laneId)
{
    USE_TIMELINE()
    BACKGROUND_TASK_MGR->Submit([timeline, laneId] {
        if (HMC_OK != HmcLaneDestroy(timeline->GetEditor(), HmcUidHelper(laneId))) {
            LOGE("HmcLaneDestroy failed, laneUid=%s.", laneId.c_str());
        } else {
            LOGE("HmcLaneDestroy success, laneUid=%s.", laneId.c_str());
        }
    },
        __FUNCTION__);
}

void Timeline::SetLaneVisible(int timelineId, std::string const & laneId, bool visible)
{
    USE_TIMELINE()

    if (HmcLaneSetVisible(timeline->GetEditor(), HmcUidHelper(laneId), visible) != HMC_OK) {
        LOGE("setLaneVisible %d failed, laneUid=%s.", visible, laneId.c_str());
    } else {
        LOGE("setLaneVisible %d success, laneUid=%s.", visible, laneId.c_str());
    }
}

void Lane::AppendAsset(int timelineId, std::string const & laneId, std::string const & path, int mediaType,
    void *inputPixelMap, std::function<void(std::string const & jsonStr)> cb, std::string const & editData,
    bool isMediaSource, bool isSupportWaterMark, bool isFrontCamera, bool isCameraEditData)
{
    LOGI("appendAsset, timelineId=%d, laneId=%s, mediaType=%d, path=%s, isMediaSource=%d", timelineId,
         laneId.c_str(), mediaType, path.c_str(), isMediaSource ? 1 : 0);
    USE_EDITOR()
    BACKGROUND_TASK_MGR->Submit(
        [timeline, editor, laneId, path, mediaType, inputPixelMap, cb, editData, isMediaSource, isSupportWaterMark,
         isFrontCamera, isCameraEditData] {
            LOGD("appendAsset begin");
            HmcEditorSetAutoFlush(editor, false); // 等待计算好初始位置后再开启刷新
            HmcDictHelper dict;
            dict[DICT_KEY_ASSET_PROPERTY_PATH] = path;
            dict[DICT_KEY_ASSET_PROPERTY_EDIT_DATA] = editData;
            dict[DICT_KEY_ASSET_PROPERTY_IS_MEDIA_SOURCE] = isMediaSource ? 1 : 0;
            dict[DICT_KEY_ASSET_PROPERTY_IS_SUPPORT_WATERMARK] = isSupportWaterMark ? 1 : 0;
            dict[DICT_KEY_ASSET_PROPERTY_IS_CAMERA_EDIT_DATA] = isCameraEditData ? 1 : 0;
            HmcDictSetInt32(dict, DICT_KEY_ASSET_PROPERTY_IS_FRONT_CAMERA, isFrontCamera ? IS_FRONT_CAMERA : 1);
            HmcDictSetPointer(dict, DICT_KEY_THUMBNAIL_LCD_PIXELMAP, inputPixelMap);
            // 画布固定为全屏大小，不根据首次添加的素材来确定，所以不需要HmcDictSetInt32(dict,
            HmcUid assetUid = HMC_UID_NULL;
            HmcSize originalSize;
            originalSize.width = 0.0;
            originalSize.height = 0.0;
            int64_t originalDuration = 0;
            double fps = 0.0f;
            int result = HMC_OK;

            result = HmcAssetCreate(timeline->GetEditor(), HmcUidHelper(laneId), dict, &assetUid);
            if (result == HMC_OK) {
                // 同步创建bridge asset
                timeline->AppendAsset(assetUid, static_cast<HmcAssetType>(mediaType));
                timeline->SyncDataFromServiceOnly();
                HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);
                originalDuration = HmcAssetGetFileDuration(editor, assetUid);
                HmcAssetGetVideoFps(editor, assetUid, &fps);
                if ((originalSize.width > MAXIMUM_RESOLUTION) || (originalSize.height > MAXIMUM_RESOLUTION)) {
                    LOGE("appendAsset failed, width = %f, height = %f", originalSize.width, originalSize.height);
                    result = HMC_ERR;
                }
            } else {
                HmcEditorImportResultNotify(editor, HMC_ERR_SERVICE_ASSET_INVALID);
            }

            Json::Value json;
            json["uid"] = (std::string)HmcUidHelper(assetUid);
            json["originalWidth"] = originalSize.width;
            json["originalHeight"] = originalSize.height;
            json["originalDuration"] = originalDuration;
            json["originalFps"] = fps;
            json["result"] = result;
            Json::FastWriter fastWriter;
            cb(fastWriter.write(json));
            LOGD("appendAsset end, result = %d", result);
        },
        __FUNCTION__);
}

void Lane::ReplaceSource(int timelineId, std::string const & laneId, std::string const & path,
    std::function<void(int32_t res)> cb)
{
    USE_EDITOR()
    LOGD("ReplaceSource, laneId=%s, path=%s", laneId.c_str(), path.c_str());
    BACKGROUND_TASK_MGR->Submit(
        [editor, laneId, path, cb] {
            HmcDictHelper dict;
            int32_t res = HmcAssetReplaceSource(editor, dict, HmcUidHelper(laneId), path);
            cb(res);
        },
        __FUNCTION__);
}

void Lane::GetAsset(int timelineId, std::string const & laneId, std::function<void(std::string const & jsonStr)> cb)
{
    LOGI("getAsset, timelineId=%d, laneId=%s", timelineId, laneId.c_str());
    USE_EDITOR()
    HmcUid laneUid = HmcUidHelper(laneId);
    if (HmcUidIsNull(&laneUid)) {
        LOGD("getAsset laneUid is Null");
        HmcEditorImportResultNotify(editor, HMC_ERR_SERVICE_LANE);
    }

    Json::Value ret = timeline->getAssets()[0];
    Json::FastWriter fastWrite;
    LOGI("getAsset, timelineId=%d, ret=%s", timelineId, fastWrite.write(ret).c_str());

    cb(fastWrite.write(ret));
}

void RemoveLaneAsset(HmcEditor *editor, const HmcUid &laneUid, bool autoPauseEditor = true, int startIndex = 0)
{
    std::vector<HmcUid> laneUidList;
    auto lane = IHmcLane::QueryLaneObj(laneUid);
    if (lane != nullptr) {
        lane->ClearAsset();
    }
}

void Lane::RemoveAllAssets(int timelineId, std::string const & laneId)
{
    USE_EDITOR()
    BACKGROUND_TASK_MGR->Submit([editor, laneId] {
        RemoveLaneAsset(editor, HmcUidHelper(laneId));
    },
        __FUNCTION__);
}
double Motion::ResetFrictionMotion(double friction, double initPosition, double initVelocity)
{
    FrictionMotion::GetInstance()->Reset(friction, initPosition, initVelocity);
    return FrictionMotion::GetInstance()->GetFinalTime();
}

double Motion::GetPosition(double offsetTime)
{
    return FrictionMotion::GetInstance()->GetPosition(offsetTime);
}

double Motion::GetVelocity(double offsetTime)
{
    return FrictionMotion::GetInstance()->GetVelocity(offsetTime);
}

STRING EditorContext::HasXTStyleEffect(std::string const &data)
{
    return HmcEditorHasXTStyleEffect(data);
}

/**
 * 设置个性风格缩略图回调函数
 * @param timelineId
 * @param cb
 */
void EditorContext::setXTStyleThumbnailCallback(int timelineId,
    std::function<void(napi_value pixelmapNapi, std::string jsonStr)> cb)
{
    USE_TIMELINE()
    timeline->SetXTStyleThumbnailCallback(cb);
}