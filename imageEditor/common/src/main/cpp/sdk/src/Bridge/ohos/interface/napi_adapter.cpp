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
#include "JSArguments.hpp"
#include "index.h"
#include <functional>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <numeric>

static int g_firstArg = 1;

static int g_secondArg = 2;

static int g_thirdArg = 3;

static int g_fourthArg = 4;

static int g_fifthArg = 5;

static int g_sixthArg = 6;

static int g_seventhArg = 7;

static int g_eighthArg = 8;

static int g_ninthArg = 9;

static int g_tenthArg = 10;

static int g_eleventhArg = 11;

static napi_value appCreate(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Index::AppCreate();
    return JSValue(env);
}

static napi_value appDestory(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Index::AppDestory();
    return JSValue(env);
}
static napi_value appShow(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Index::AppShow();
    return JSValue(env);
}
static napi_value appHide(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Index::AppHide();
    return JSValue(env);
}
static napi_value editorShow(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Index::EditorShow();
    return JSValue(env);
}
static napi_value editorHide(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Index::EditorHide();
    return JSValue(env);
}
static napi_value regNativeOpenMedia(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Index::RegNativeOpenMedia(JSCallback(args[0]));
    return JSValue(env);
}
static napi_value setMediaFd(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Index::SetMediaFd(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value EditorContext_checkEditData(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::CheckEditData(args[0]);
    return JSValue(env);
}
static napi_value EditorContext_waitTaskFinish(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::WaitTaskFinish(args[0], JSCallback(args[g_firstArg]));
    return JSValue(env);
}
static napi_value EditorContext_processExifInfo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::ProcessExifInfo(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value EditorContext_callEmpty(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::CallEmpty(JSCallback(args[0]));
    return JSValue(env);
}
static napi_value EditorContext_createTimeline(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    CreateTimelineParam param = {args[0], args[g_firstArg], args[g_secondArg],
        args[g_fifthArg], args[g_sixthArg], args[g_seventhArg]};
    EditorContext::CreateTimeline(param, JSCallback(args[g_thirdArg]), JSCallback(args[g_fourthArg]));
    return JSValue(env);
}
static napi_value EditorContext_modifyTimeline(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::ModifyTimeline(args[0], args[g_firstArg]));
}
static napi_value EditorContext_bindTimelineWithXComponent(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::BindTimelineWithXComponent(args[0], args[g_firstArg], args[g_secondArg],
        args[g_thirdArg], JSCallback(args[g_fourthArg]));
    return JSValue(env);
}
static napi_value EditorContext_playTimeline(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::PlayTimeline(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value EditorContext_pauseTimeline(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::PauseTimeline(args[0]);
    return JSValue(env);
}
static napi_value EditorContext_seekTimeline(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::SeekTimeline(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value EditorContext_getExportRect(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::getExportRect(args[0], args[g_firstArg], JSCallback(args[g_secondArg]));
    return JSValue(env);
}
static napi_value EditorContext_compileTimeline(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::CompileTimeline(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg], args[g_fourthArg],
        JSCallback(args[g_fifthArg]), args[g_sixthArg]);
    return JSValue(env);
}
static napi_value EditorContext_encodePixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    OH_PixelmapNative *dstPixel = nullptr;
    OH_PixelmapNative_ConvertPixelmapNativeFromNapi(env, args[g_fifthArg], &dstPixel);
    EditorContext::EncodePixelMap(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        args[g_fourthArg], dstPixel, args[g_sixthArg], JSCallback(args[g_seventhArg]));
    return JSValue(env);
}
static napi_value EditorContext_releaseFlowSource(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::ReleaseFlowSource(args[0]);
    return JSValue(env);
}
static napi_value EditorContext_compileTimelinePixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::CompileTimelinePixelMap(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
                                           args[g_fourthArg], JSCallback(args[g_fifthArg]), args[g_sixthArg],
                                           args[g_seventhArg], args[g_eighthArg]);
    return JSValue(env);
}
static napi_value EditorContext_cancelCompileTimeline(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::CancelCompileTimeline(args[0], args[g_firstArg], JSCallback(args[g_secondArg]));
    return JSValue(env);
}
static napi_value EditorContext_setThumbnailCallback(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::SetThumbnailCallback(args[0], JSCallback(args[g_firstArg]));
    return JSValue(env);
}
static napi_value EditorContext_setFilterThumbnailCallback(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::SetFilterThumbnailCallback(args[0], JSCallback(args[g_firstArg]));
    return JSValue(env);
}
static napi_value EditorContext_setPreviewPeriodRange(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::SetPreviewPeriodRange(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value EditorContext_saveProject(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::SaveProject(args[0], JSCallback(args[g_firstArg]));
    return JSValue(env);
}
static napi_value EditorContext_closeProject(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::CloseProject(args[0], JSCallback(args[g_firstArg]));
    return JSValue(env);
}
static napi_value EditorContext_updateEditData(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::UpdateEditData(args[0]));
}

static napi_value EditorContext_isSystemEditData(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::IsSystemEditData(args[0]));
}
static napi_value EditorContext_isThirdEditData(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::IsThirdEditData(args[0]));
}
static napi_value EditorContext_IsOldFilterEditData(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::IsOldFilterEditData(args[0]));
}
static napi_value EditorContext_HasWatermarkEffect(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::HasWatermarkEffect(args[0], JSCallback(args[g_firstArg])));
}
static napi_value EditorContext_GetCropRotation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::GetCropRotation(args[0]));
}
static napi_value EditorContext_applyEditData(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::ApplyEditData(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        JSCallback(args[g_fourthArg]), JSCallback(args[g_fifthArg]));
    return JSValue(env);
}
static napi_value EditorContext_UndoRedoManagerClear(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::UndoRedoManagerClear();
    return JSValue(env);
}
static napi_value EditorContext_reset(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::Reset(args[0], args[g_firstArg], args[g_secondArg], JSCallback(args[g_thirdArg]));
    return JSValue(env);
}
static napi_value EditorContext_setConfigChangeCallback(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::SetConfigChangeCallback(args[0], JSCallback(args[g_firstArg]));
    return JSValue(env);
}
static napi_value EditorContext_CalConfigChangeCallback(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::CalConfigChangeCallback(args[0]);
    return JSValue(env);
}
static napi_value EditorContext_getCacheSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::GetCacheSize());
}
static napi_value EditorContext_clearCache(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::ClearCache();
    return JSValue(env);
}
static napi_value EditorContext_undo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::Undo());
}

static napi_value EditorContext_redo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::Redo());
}

static napi_value EditorContext_Start(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::Start();
    return JSValue(env);
}

static napi_value EditorContext_Stop(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::Stop();
    return JSValue(env);
}

static napi_value EditorContext_RegUndoRedoStateChangeCb(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::RegUndoRedoStateChangeCb(JSCallback(args[0]));
    return JSValue(env);
}

static napi_value EditorContext_SetAutoFlush(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::SetAutoFlush(args[0], args[g_firstArg]);
    return JSValue(env);
}

static napi_value Motion_ResetFrictionMotion(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Motion::ResetFrictionMotion(args[0], args[g_firstArg], args[g_secondArg]));
}

static napi_value Motion_GetPosition(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Motion::GetPosition(args[0]));
}

static napi_value Motion_GetVelocity(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Motion::GetVelocity(args[0]));
}

static napi_value Timeline_getVideoLane(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Timeline::GetVideoLane(args[0]));
}
static napi_value Timeline_appendVideoLane(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Timeline::AppendVideoLane(args[0]));
}
static napi_value Timeline_appendVisionLane(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Timeline::AppendVisionLane(args[0]));
}
static napi_value Timeline_removeLane(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Timeline::RemoveLane(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Timeline_setLaneVisible(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Timeline::SetLaneVisible(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Lane_appendAsset(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    OH_PixelmapNative *dstPixel = nullptr;
    OH_PixelmapNative_ConvertPixelmapNativeFromNapi(env, args[g_fourthArg], &dstPixel);
    Lane::AppendAsset(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg], dstPixel,
        JSCallback(args[g_fifthArg]), args[g_sixthArg], args[g_seventhArg], args[g_eighthArg], args[g_ninthArg],
            args[g_tenthArg]);
    return JSValue(env);
}

static napi_value Lane_replaceSource(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Lane::ReplaceSource(args[0], args[g_firstArg], args[g_secondArg], JSCallback(args[g_thirdArg]));
    return JSValue(env);
}
static napi_value Lane_getAsset(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Lane::GetAsset(args[0], args[g_firstArg], JSCallback(args[g_secondArg]));
    return JSValue(env);
}
static napi_value Lane_removeAllAssets(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Lane::RemoveAllAssets(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_setDeviceType(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetDeviceType(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_setSupportNewWatermark(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::setSupportNewWatermark(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_setEditDataType(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetEditDataType(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_getDuration(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::GetDuration(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_getPath(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::GetPath(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_requestThumbnail(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::RequestThumbnail(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg], args[g_fourthArg]);
    return JSValue(env);
}
static napi_value Asset_requestThumbnailList(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::requestThumbnailList(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_requestFilterThumbnail(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::RequestFilterThumbnail(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_cancelThumbnail(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::CancelThumbnail(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_setRotation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetRotation(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg]);
    return JSValue(env);
}
static napi_value Asset_rotate90Acw(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::Rotate90Acw(args[0], args[g_firstArg], args[g_secondArg], JSCallback(args[g_thirdArg]));
    return JSValue(env);
}

static napi_value Asset_getTrimOut(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetTrimOut(args[0], args[g_firstArg]));
}

static napi_value Asset_initCropOperationArea(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::InitCropOperationArea(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        JSCallback(args[g_fourthArg]));
    return JSValue(env);
}
static napi_value Asset_UpdateCropOperationArea(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::UpdateCropOperationArea(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg], args[g_fourthArg],
        args[g_fifthArg], args[g_sixthArg], args[g_seventhArg], args[g_eighthArg], args[g_ninthArg],
        JSCallback(args[g_tenthArg]));
    return JSValue(env);
}
static napi_value Asset_resetPosition(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::ResetPosition(args[0], args[g_firstArg], JSCallback(args[g_secondArg]));
    return JSValue(env);
}
static napi_value Asset_getCanvasPosition(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetCanvasPosition(args[0], args[1]));
}
static napi_value Asset_getIntelligentCorrectionValue(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetIntelligentCorrectionValue(args[0], args[1]));
}
static napi_value IsSupports_DifferentiatedAlgorithms(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::IsSupportsDifferentiatedAlgorithms(args[0]));
}
static napi_value Asset_setCropRect(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::SetCropRect(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        args[g_fourthArg], args[g_fifthArg], args[g_sixthArg], args[g_seventhArg], args[g_eighthArg],
        JSCallback(args[g_ninthArg])));
}
static napi_value Asset_translate(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::Translate(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        args[g_fourthArg]));
}
static napi_value Asset_scale(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::Scale(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg], args[g_fourthArg]);
    return JSValue(env);
}
static napi_value Asset_setIsDragImage(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetIsDragImage(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_calculateCropSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::CalculateCropSize(args[0], args[g_firstArg], JSCallback(args[g_secondArg]));
    return JSValue(env);
}
static napi_value Asset_getPreviewMaxScale(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetPreviewMaxScale(args[0], args[g_firstArg]));
}
static napi_value Asset_fillCropRect(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::FillCropRect(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        args[g_fourthArg], args[g_fifthArg], args[g_sixthArg], args[g_seventhArg], JSCallback(args[g_eighthArg])));
}
static napi_value Asset_switchPreviewMode(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SwitchPreviewMode(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_switchCropMode(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SwitchCropMode(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_switchPageRender(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SwitchPageRender(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_SetEditorAutoFlush(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetEditorAutoFlush(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_SetCropAreaEnable(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetCropAreaEnable(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_calcOptimalRectUnderRatio(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::CalcOptimalRectUnderRatio(args[0], args[g_firstArg], args[g_secondArg],
        args[g_thirdArg], args[g_fourthArg], args[g_fifthArg], args[g_sixthArg]));
}
static napi_value Asset_getReachableCropRect(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetReachableCropRect(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        args[g_fourthArg], args[g_fifthArg], args[g_sixthArg], args[g_seventhArg], args[g_eighthArg],
        args[g_ninthArg], args[g_tenthArg], JSCallback(args[g_eleventhArg])));
}
static napi_value Asset_ReverseCrop(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::ReverseCrop(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        args[g_fourthArg], args[g_fifthArg]));
}
static napi_value Asset_setMirror(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetMirror(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg], JSCallback(args[g_fourthArg]));
    return JSValue(env);
}

static napi_value Asset_SetAdjustValue(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetAdjustValue(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        JSCallback(args[g_fourthArg]));
    return JSValue(env);
}
static napi_value Asset_GetRefreshThumbnails(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetRefreshThumbnails(args[0], args[g_firstArg]));
}
static napi_value Asset_SetAdjustEnable(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetAdjustEnable(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        JSCallback(args[g_fourthArg]));
    return JSValue(env);
}
static napi_value Asset_SetAdjustValueAndEnable(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetAdjustValueAndEnable(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
        JSCallback(args[g_fourthArg]));
    return JSValue(env);
}
static napi_value Asset_PreloadAdjustResource(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::PreloadAdjustResource(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_GetAdjustProperty(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetAdjustProperty(args[0], args[g_firstArg]));
}
static napi_value Asset_ResetAdjustProperty(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::ResetAdjustProperty(args[0], args[g_firstArg]);
    return JSValue(env);
}

static napi_value Asset_SetRefreshRate(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetRefreshRate(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_AddStylus(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    NativePixelMap *dstPixel = OH_PixelMap_InitNativePixelMap(env, args[g_secondArg]);
    Asset::AddStylus(args[0], args[g_firstArg], dstPixel, args[g_thirdArg], args[g_fourthArg], args[g_fifthArg],
        args[g_sixthArg], JSCallback(args[g_seventhArg]));
    return JSValue(env);
}
static napi_value Asset_IsSupportEffect(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    std::string name = args[0];
    bool isSupport = false;
    OH_EffectFilter  *filter = OH_EffectFilter_Create(name.c_str());
    if (filter != nullptr) {
        isSupport = true;
        OH_EffectFilter_Release(filter);
    }
    return JSValue(env, isSupport);
}
static napi_value Asset_SetOriginalColorMode(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::SetOriginalColorMode(args[0], args[g_firstArg], args[g_secondArg]));
}
static napi_value Asset_GetOriginalColorMode(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetOriginalColorMode(args[0], args[g_firstArg]));
}
static napi_value Asset_SetUserData(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetUserData(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg]);
    return JSValue(env);
}
static napi_value Asset_GetUserData(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetUserData(args[0], args[g_firstArg], args[g_secondArg]));
}
static napi_value Asset_SwitchCropPage(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SwitchCropPage(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_SetSourceByPixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    OH_PixelmapNative *dstPixel = nullptr;
    OH_PixelmapNative_ConvertPixelmapNativeFromNapi(env, args[g_secondArg], &dstPixel);
    Asset::SetSourceByPixelMap(args[0], args[g_firstArg], dstPixel);
    return JSValue(env);
}
static napi_value Asset_FinishAnimation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::FinishAnimation(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value NAPIMaterial_InitEnv(napi_env env, napi_callback_info info)
{
    g_mainThreadId = std::this_thread::get_id(); // 确保g_mainThreadId是主线程
    JSArguments args(env, info);
    NAPIMaterial::InitEnv(args[0]);
    return JSValue(env);
}

static napi_value aiEditorContextInitEditor(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextDeinitEditor(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextRefreshEditor(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextChangeEditorType(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextSegObject(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextClickObjectWithPoint(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextDoBackgroundBlur(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextEnableBackgroundBlur(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextEnableBackgroundDecolorization(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextReprocessBackground(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextDoInteractionSeg(napi_env env, napi_callback_info info) 
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value initPickerEditPixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value resetPickerEditPixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value getPickerEditPixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return nullptr;
}

static napi_value aiEditorContextDoObjectSeg(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextDoObjectSegForPicker(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextDoObjectMoveOperation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextDoObjectFusion(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextUploadMoveExtraPatch(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextGetMoveObjectMaskInfo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextDoObjectRemove(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetReplaceFaceDst(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextSetReplacePixelmap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetRejectJson(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextReturnReplaceEmo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetSrcEmo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextDoReplaceEmo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextDoObjectMoveAI2Remove(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextAiMoveSegmentOneStep(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextAiMoveCutoutOneStep(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextRefreshMoveUndoRedoSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextCancelObjectOperation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextRedo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextUndo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextMoveEnterReSegment(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetPreOptType(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
}
static napi_value aiEditorContextGetUndoStepType(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurMaskPixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurFusionCount(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurBlurLevel(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurBlurEnable(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurDecolorizationEnable(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurObjectMask(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurObjectContourJson(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetBackgroundStatJson(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurOutputPixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetCurCutoutPixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetRedoSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetUndoSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextIsAiEdited(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextIsAiEditedInCurEditor(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextIsAiLableNeeded(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextIsUndoMove(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextGetExportPixelMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value aiEditorContextSaveExportFile(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextGetMaskContours(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    void *data;
    size_t byteLength;
    napi_status status = napi_get_arraybuffer_info(env, args[0], &data, &byteLength);
    if (status != napi_ok) {
        LOGE("aiEditorContextGetMaskContours napi_get_arraybuffer_info fail");
    }
    return JSValue(env);
}

static napi_value aiEditorContextGetHSDPreprocessData(napi_env env, napi_callback_info info) {
    JSArguments args(env, info);
    void *data;
    size_t byteLength;
    napi_status status = napi_get_arraybuffer_info(env, args[0], &data, &byteLength);
    if (status != napi_ok) {
        LOGE("aiEditorContextGetHSDPreprocessData napi_get_arraybuffer_info fail");
    }
    return JSValue(env);
}

static napi_value aiEditorContextCreateMaskBuffer(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    void *data;
    size_t byteLength;
    napi_status status = napi_get_arraybuffer_info(env, args[0], &data, &byteLength);
    if (status != napi_ok) {
        LOGE("aiEditorContextGetMaskContours napi_get_arraybuffer_info fail");
    }
    return JSValue(env);
}

static napi_value aiEditorContextGaussianBlurMask(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    void *image, *mask;
    size_t byteLength;
    napi_status status = napi_get_arraybuffer_info(env, args[0], &image, &byteLength);
    status = napi_get_arraybuffer_info(env, args[1], &mask, &byteLength);
    if (status != napi_ok) {
        LOGE("aiEditorContextGetMaskContours napi_get_arraybuffer_info fail");
    }
    return JSValue(env);
}

static napi_value aiEditorContextExtractImageByMask(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    void *image, *mask;
    size_t byteLength;
    napi_status status = napi_get_arraybuffer_info(env, args[0], &image, &byteLength);
    if (status != napi_ok) {
        LOGE("aiEditorContextExtractImageByMask napi_get_arraybuffer_info fail");
    }
    status = napi_get_arraybuffer_info(env, args[1], &mask, &byteLength);
    if (status != napi_ok) {
        LOGE("aiEditorContextExtractImageByMask napi_get_arraybuffer_info fail");
    }
    return JSValue(env);
}

static napi_value aiEditorContextExtractImageByMaskForPicker(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    void *image;
    void *mask;
    size_t byteLength;
    napi_status status = napi_get_arraybuffer_info(env, args[0], &image, &byteLength);
    status = napi_get_arraybuffer_info(env, args[1], &mask, &byteLength);
    if (status != napi_ok) {
        LOGE("aiEditorContextExtractImageByMask napi_get_arraybuffer_info fail");
    }
    return JSValue(env);
}

static napi_value aiEditorContextAiMoveReleaseUndo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value aiEditorContextPixelMapToMask(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    void *image, *mask;
    size_t byteLength;
    napi_status status = napi_get_arraybuffer_info(env, args[0], &image, &byteLength);
    status = napi_get_arraybuffer_info(env, args[1], &mask, &byteLength);
    if (status != napi_ok) {
        LOGE("aiEditorContextGetMaskContours napi_get_arraybuffer_info fail");
    }
    return JSValue(env);
}

static napi_value AIEditorContext_SetModelCachePath(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value AIEditorContext_SetFastSegPixmap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value AIEditorContext_SaveExpandOperation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_SaveRawExpandRect(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);

    return JSValue(env);
}
static napi_value AIEditorContext_GetExpandOperation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_GetInitExpandImageInfo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_CancelInitExpandImageInfo(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_DoImageExpand(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_CancelImageExpand(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_GetUndoPixelMapSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_GetRedoPixelMapSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value Asset_CalculateFrameSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::CalculateFrameSize(args[0], args[g_firstArg], args[g_secondArg], args[g_thirdArg],
                              JSCallback(args[g_fourthArg]));
    return JSValue(env);
}
static napi_value Asset_GetExportSize(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::GetExportSize(args[0], args[g_firstArg], JSCallback(args[g_secondArg, g_thirdArg]));
    return JSValue(env);
}
static napi_value AIEditorContext_DoRefine(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_UploadImage(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_ChangeLightOrBlur(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_ChangeStyleOrCompose(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_GetDisplayPixelMapAsync(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_SetImageConfig(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_CancelDoRefine(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_CancelRefineUpload(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_ReleaseRefineAIGCSource(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_ChangeOutPutPixelMapType(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_GetStyleThumbs(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_FaceDetection(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_DiscardGainMap(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}
static napi_value AIEditorContext_GetIsDoRefineMasterValue(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value AIEditorContext_RemoveReflection(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value AIEditorContext_CancelRemoveReflection(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value AIEditorContext_RemoveReflectionUploadImage(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value AIEditorContext_GetRemoveReflectOperation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value AIEditorContext_CancelReflectionUpload(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env);
}

static napi_value AIEditorContext_PixelMapToMask(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    void *image, *mask;
    size_t byteLength;
    napi_status status = napi_get_arraybuffer_info(env, args[0], &image, &byteLength);
    status = napi_get_arraybuffer_info(env, args[1], &mask, &byteLength);
    if (status != napi_ok) {
        LOGE("AIEditorContext_PixelMapToMask napi_get_arraybuffer_info fail");
    }
    return JSValue(env);
}

static napi_value Asset_AddXtStyleParamToWatermark(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    VECTOR<STRING> xtStyleTextParams = args[g_secondArg];
    Asset::AddXtStyleParamToWatermark(args[0], args[g_firstArg], xtStyleTextParams, args[g_thirdArg],
                                      args[g_fourthArg]);
    return JSValue(env);
}

static napi_value EditorContext_HasXTStyleEffect(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, EditorContext::HasXTStyleEffect(args[0]));
}

static napi_value Asset_GetXtStyleName(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetXtStyleName(args[0], args[g_firstArg]));
}

static napi_value EditorContext_setXTStyleThumbnailCallback(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    EditorContext::setXTStyleThumbnailCallback(args[0], JSCallback(args[g_firstArg]));
    return JSValue(env);
}

static napi_value Asset_requestXTStyleThumbnail(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::RequestXTStyleThumbnail(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}

static napi_value Asset_DoPreviewAvoidanceAnimation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::DoPreviewAvoidanceAnimation(args[0], args[g_firstArg], args[g_secondArg],
                                       JSCallback(args[g_fifthArg]));
    return JSValue(env);
}

static napi_value Asset_DoXtStyleTriFoldAnimation(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::DoXtStyleTriFoldAnimation(args[0], args[g_firstArg], args[g_secondArg],
                                     {args[g_thirdArg], args[g_fourthArg]},JSCallback(args[g_fifthArg]));
    return JSValue(env);
}

static napi_value Asset_SetPreviewMode(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetPreviewMode(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_GetCurrentXtStyleParams(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::GetCurrentXtStyleParams(args[0], args[g_firstArg]));
}
static napi_value Asset_SetShowWatermarkValue(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::SetShowWatermarkValue(args[0], args[g_firstArg], args[g_secondArg]);
    return JSValue(env);
}
static napi_value Asset_RefreshCompareEffectList(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::RefreshCompareEffectList(args[0], args[g_firstArg]);
    return JSValue(env);
}
static napi_value Asset_SwitchTabWidthWatermarkAnim(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    int type = args[g_secondArg];
    int cost = args[g_thirdArg];
    Asset::SwitchTabWidthWatermarkAnim(args[0], args[g_firstArg], type, cost);
    return JSValue(env);
}

static napi_value Asset_RefreshWatermarkCache(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::RefreshWatermarkCache(args[0], args[g_firstArg]);
    return JSValue(env);
}

static napi_value Asset_GetExifXtStyleParam(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    auto xtStyleParams = Asset::GetExifXtStyleParam(args[0], args[g_firstArg]);
    LOGI("FetchExifInfo xtStyle data %d %d %d %d", xtStyleParams[0], xtStyleParams[g_firstArg],
         xtStyleParams[g_secondArg], xtStyleParams[g_thirdArg]);
    napi_value jsArray = nullptr;
    napi_create_array(env, &jsArray);
    for (size_t i = 0; i < xtStyleParams.size(); i++) {
        napi_value element = nullptr;
        napi_create_int32(env, xtStyleParams[i], &element);
        napi_set_element(env, jsArray, i, element);
    }
    return jsArray;
}
static napi_value Asset_SetProjectConfigValue(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    int argsSize = args.Size();
    if (argsSize != g_secondArg) {
        LOGE("Asset_SetProjectConfigValue failed, args size = %d", argsSize);
        return JSValue(env, false);
    }
    return JSValue(env, Asset::SetProjectConfigValue(args[0], args[g_firstArg]));
}
static napi_value Asset_GeneratorRfDataB(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    Asset::GeneratorRfDataB(args[0], args[g_firstArg], JSCallback(args[g_secondArg]));
    return JSValue(env);
}

static napi_value Asset_IsAllowEditXtStyle(napi_env env, napi_callback_info info)
{
    JSArguments args(env, info);
    return JSValue(env, Asset::IsAllowEditXtStyle(args[0], args[g_firstArg]));
}

static const napi_property_descriptor desc_thirty[] = {
    {"appCreate", nullptr, appCreate, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"appDestory", nullptr, appDestory, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"appShow", nullptr, appShow, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"appHide", nullptr, appHide, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"editorShow", nullptr, editorShow, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"editorHide", nullptr, editorHide, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"regNativeOpenMedia", nullptr, regNativeOpenMedia, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"setMediaFd", nullptr, setMediaFd, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"EditorContext_checkEditData", nullptr, EditorContext_checkEditData, nullptr, nullptr, nullptr, napi_default,
    nullptr},
    {"EditorContext_waitTaskFinish", nullptr, EditorContext_waitTaskFinish, nullptr, nullptr, nullptr, napi_default,
    nullptr},
    {"EditorContext_processExifInfo", nullptr, EditorContext_processExifInfo, nullptr, nullptr, nullptr, napi_default,
    nullptr},
    {"EditorContext_callEmpty", nullptr, EditorContext_callEmpty, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"EditorContext_createTimeline", nullptr, EditorContext_createTimeline, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_modifyTimeline", nullptr, EditorContext_modifyTimeline, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_bindTimelineWithXComponent", nullptr, EditorContext_bindTimelineWithXComponent, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"EditorContext_playTimeline", nullptr, EditorContext_playTimeline, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_pauseTimeline", nullptr, EditorContext_pauseTimeline, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_seekTimeline", nullptr, EditorContext_seekTimeline, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_getExportRect", nullptr, EditorContext_getExportRect, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_compileTimeline", nullptr, EditorContext_compileTimeline, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_encodePixelMap", nullptr, EditorContext_encodePixelMap, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_releaseFlowSource", nullptr, EditorContext_releaseFlowSource, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_compileTimelinePixelMap", nullptr, EditorContext_compileTimelinePixelMap, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_cancelCompileTimeline", nullptr, EditorContext_cancelCompileTimeline, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_setThumbnailCallback", nullptr, EditorContext_setThumbnailCallback, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_setFilterThumbnailCallback", nullptr, EditorContext_setFilterThumbnailCallback, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"EditorContext_setPreviewPeriodRange", nullptr, EditorContext_setPreviewPeriodRange, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_saveProject", nullptr, EditorContext_saveProject, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"EditorContext_closeProject", nullptr, EditorContext_closeProject, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_updateEditData", nullptr, EditorContext_updateEditData, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_isSystemEditData", nullptr, EditorContext_isSystemEditData, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_isThirdEditData", nullptr, EditorContext_isThirdEditData, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_HasWatermarkEffect", nullptr, EditorContext_HasWatermarkEffect, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_GetCropRotation", nullptr, EditorContext_GetCropRotation, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_isThirdEditData", nullptr, EditorContext_isThirdEditData, nullptr, nullptr, nullptr, napi_default,
            nullptr},
    {"EditorContext_IsOldFilterEditData", nullptr, EditorContext_IsOldFilterEditData, nullptr, nullptr, nullptr,
    napi_default, nullptr},
    {"EditorContext_applyEditData", nullptr, EditorContext_applyEditData, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_UndoRedoManagerClear", nullptr, EditorContext_UndoRedoManagerClear, nullptr, nullptr, nullptr,
    napi_default, nullptr},
    {"EditorContext_reset", nullptr, EditorContext_reset, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"EditorContext_setConfigChangeCallback", nullptr, EditorContext_setConfigChangeCallback, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_CalConfigChangeCallback", nullptr, EditorContext_CalConfigChangeCallback, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"EditorContext_getCacheSize", nullptr, EditorContext_getCacheSize, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"EditorContext_clearCache", nullptr, EditorContext_clearCache, nullptr, nullptr, nullptr, napi_default, nullptr}};

static const napi_property_descriptor desc_sixty[] = {
    {"EditorContext_undo", nullptr, EditorContext_undo, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"EditorContext_RegUndoRedoStateChangeCb", nullptr, EditorContext_RegUndoRedoStateChangeCb, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"EditorContext_redo", nullptr, EditorContext_redo, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"EditorContext_Start", nullptr, EditorContext_Start, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"EditorContext_Stop", nullptr, EditorContext_Stop, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"EditorContext_SetAutoFlush", nullptr, EditorContext_SetAutoFlush, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Motion_ResetFrictionMotion", nullptr, Motion_ResetFrictionMotion, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Motion_GetPosition", nullptr, Motion_GetPosition, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Motion_GetVelocity", nullptr, Motion_GetVelocity, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Timeline_getVideoLane", nullptr, Timeline_getVideoLane, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Timeline_appendVideoLane", nullptr, Timeline_appendVideoLane, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Timeline_appendVisionLane", nullptr, Timeline_appendVisionLane, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Timeline_removeLane", nullptr, Timeline_removeLane, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Timeline_setLaneVisible", nullptr, Timeline_setLaneVisible, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Lane_appendAsset", nullptr, Lane_appendAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Lane_replaceSource", nullptr, Lane_replaceSource, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Lane_getAsset", nullptr, Lane_getAsset, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Lane_removeAllAssets", nullptr, Lane_removeAllAssets, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_getDuration", nullptr, Asset_getDuration, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_getPath", nullptr, Asset_getPath, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_requestThumbnail", nullptr, Asset_requestThumbnail, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_requestThumbnailList", nullptr, Asset_requestThumbnailList, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_requestFilterThumbnail", nullptr, Asset_requestFilterThumbnail, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_cancelThumbnail", nullptr, Asset_cancelThumbnail, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_setSupportNewWatermark", nullptr, Asset_setSupportNewWatermark, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_setDeviceType", nullptr, Asset_setDeviceType, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_setEditDataType", nullptr, Asset_setEditDataType, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_setRotation", nullptr, Asset_setRotation, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_rotate90Acw", nullptr, Asset_rotate90Acw, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_getTrimOut", nullptr, Asset_getTrimOut, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_initCropOperationArea", nullptr, Asset_initCropOperationArea, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_UpdateCropOperationArea", nullptr, Asset_UpdateCropOperationArea, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_resetPosition", nullptr, Asset_resetPosition, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_setCropRect", nullptr, Asset_setCropRect, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_getCanvasPosition", nullptr, Asset_getCanvasPosition, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_getIntelligentCorrectionValue", nullptr, Asset_getIntelligentCorrectionValue, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"IsSupports_DifferentiatedAlgorithms", nullptr, IsSupports_DifferentiatedAlgorithms, nullptr, nullptr, nullptr, 
    napi_default, nullptr},
};

static const napi_property_descriptor desc_ninety[] = {
    {"Asset_translate", nullptr, Asset_translate, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_scale", nullptr, Asset_scale, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_setIsDragImage", nullptr, Asset_setIsDragImage, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_calculateCropSize", nullptr, Asset_calculateCropSize, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_getPreviewMaxScale", nullptr, Asset_getPreviewMaxScale, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_fillCropRect", nullptr, Asset_fillCropRect, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_switchPreviewMode", nullptr, Asset_switchPreviewMode, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_switchCropMode", nullptr, Asset_switchCropMode, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_switchPageRender", nullptr, Asset_switchPageRender, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SetCropAreaEnable", nullptr, Asset_SetCropAreaEnable, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SetEditorAutoFlush", nullptr, Asset_SetEditorAutoFlush, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_calcOptimalRectUnderRatio", nullptr, Asset_calcOptimalRectUnderRatio, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"Asset_getReachableCropRect", nullptr, Asset_getReachableCropRect, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_ReverseCrop", nullptr, Asset_ReverseCrop, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_setMirror", nullptr, Asset_setMirror, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SetAdjustValue", nullptr, Asset_SetAdjustValue, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SetAdjustEnable", nullptr, Asset_SetAdjustEnable, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SetAdjustValueAndEnable", nullptr, Asset_SetAdjustValueAndEnable, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_PreloadAdjustResource", nullptr, Asset_PreloadAdjustResource, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_GetRefreshThumbnails", nullptr, Asset_GetRefreshThumbnails, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_GetAdjustProperty", nullptr, Asset_GetAdjustProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_ResetAdjustProperty", nullptr, Asset_ResetAdjustProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SetRefreshRate", nullptr, Asset_SetRefreshRate, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_AddStylus", nullptr, Asset_AddStylus, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SetOriginalColorMode", nullptr, Asset_SetOriginalColorMode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_IsAllowEditXtStyle", nullptr, Asset_IsAllowEditXtStyle, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_GetOriginalColorMode", nullptr, Asset_GetOriginalColorMode, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"Asset_SetUserData", nullptr, Asset_SetUserData, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_GetUserData", nullptr, Asset_GetUserData, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SwitchCropPage", nullptr, Asset_SwitchCropPage, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_FinishAnimation", nullptr, Asset_FinishAnimation, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_SetSourceByPixelMap", nullptr, Asset_SetSourceByPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_IsSupportEffect", nullptr, Asset_IsSupportEffect, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextInitEditor", nullptr, aiEditorContextInitEditor, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextDeinitEditor", nullptr, aiEditorContextDeinitEditor, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextRefreshEditor", nullptr, aiEditorContextRefreshEditor, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextChangeEditorType", nullptr, aiEditorContextChangeEditorType, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextSegObject", nullptr, aiEditorContextSegObject, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextClickObjectWithPoint", nullptr, aiEditorContextClickObjectWithPoint, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextDoBackgroundBlur", nullptr, aiEditorContextDoBackgroundBlur, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextEnableBackgroundBlur", nullptr, aiEditorContextEnableBackgroundBlur, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextEnableBackgroundDecolorization", nullptr, aiEditorContextEnableBackgroundDecolorization, nullptr,
     nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextReprocessBackground", nullptr, aiEditorContextReprocessBackground, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextDoInteractionSeg", nullptr, aiEditorContextDoInteractionSeg, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"initPickerEditPixelMap", nullptr, initPickerEditPixelMap, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"resetPickerEditPixelMap", nullptr, resetPickerEditPixelMap, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"getPickerEditPixelMap", nullptr, getPickerEditPixelMap, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextDoObjectSeg", nullptr, aiEditorContextDoObjectSeg, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextDoObjectSegForPicker", nullptr, aiEditorContextDoObjectSegForPicker, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextDoObjectMoveOperation", nullptr, aiEditorContextDoObjectMoveOperation, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextDoObjectFusion", nullptr, aiEditorContextDoObjectFusion, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextGetMoveObjectMaskInfo", nullptr, aiEditorContextGetMoveObjectMaskInfo, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextDoObjectRemove", nullptr, aiEditorContextDoObjectRemove, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextDoObjectMoveAI2Remove", nullptr, aiEditorContextDoObjectMoveAI2Remove, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextAiMoveSegmentOneStep", nullptr, aiEditorContextAiMoveSegmentOneStep, nullptr, nullptr, nullptr,
    napi_default, nullptr},
    {"aiEditorContextAiMoveCutoutOneStep", nullptr, aiEditorContextAiMoveCutoutOneStep, nullptr,nullptr, nullptr,
    napi_default, nullptr},
    {"aiEditorContextRefreshMoveUndoRedoSize", nullptr, aiEditorContextRefreshMoveUndoRedoSize, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"aiEditorContextGetReplaceFaceDst", nullptr, aiEditorContextGetReplaceFaceDst, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextSetReplacePixelmap", nullptr, aiEditorContextSetReplacePixelmap, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetRejectJson", nullptr, aiEditorContextGetRejectJson, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextReturnReplaceEmo", nullptr, aiEditorContextReturnReplaceEmo, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetSrcEmo", nullptr, aiEditorContextGetSrcEmo, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextDoReplaceEmo", nullptr, aiEditorContextDoReplaceEmo, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextCancelObjectOperation", nullptr, aiEditorContextCancelObjectOperation, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextRedo", nullptr, aiEditorContextRedo, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextUndo", nullptr, aiEditorContextUndo, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextMoveEnterReSegment", nullptr, aiEditorContextMoveEnterReSegment, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetPreOptType", nullptr, aiEditorContextGetPreOptType, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextGetUndoStepType", nullptr, aiEditorContextGetUndoStepType, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextGetCurMaskPixelMap", nullptr, aiEditorContextGetCurMaskPixelMap, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetCurFusionCount", nullptr, aiEditorContextGetCurFusionCount, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextUploadMoveExtraPatch", nullptr, aiEditorContextUploadMoveExtraPatch, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetCurBlurLevel", nullptr, aiEditorContextGetCurBlurLevel, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextGetCurBlurEnable", nullptr, aiEditorContextGetCurBlurEnable, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetCurDecolorizationEnable", nullptr, aiEditorContextGetCurDecolorizationEnable, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"aiEditorContextGetCurObjectMask", nullptr, aiEditorContextGetCurObjectMask, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetCurObjectContourJson", nullptr, aiEditorContextGetCurObjectContourJson, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"aiEditorContextGetBackgroundStatJson", nullptr, aiEditorContextGetBackgroundStatJson, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetCurOutputPixelMap", nullptr, aiEditorContextGetCurOutputPixelMap, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetCurCutoutPixelMap", nullptr, aiEditorContextGetCurCutoutPixelMap, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetRedoSize", nullptr, aiEditorContextGetRedoSize, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextGetUndoSize", nullptr, aiEditorContextGetUndoSize, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextIsAiEdited", nullptr, aiEditorContextIsAiEdited, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextIsAiLableNeeded", nullptr, aiEditorContextIsAiLableNeeded, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextIsAiEditedInCurEditor", nullptr, aiEditorContextIsAiEditedInCurEditor, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGetMaskContours", nullptr, aiEditorContextGetMaskContours, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextGetHSDPreprocessData", nullptr, aiEditorContextGetHSDPreprocessData, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextCreateMaskBuffer", nullptr, aiEditorContextCreateMaskBuffer, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextGaussianBlurMask", nullptr, aiEditorContextGaussianBlurMask, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextExtractImageByMask", nullptr, aiEditorContextExtractImageByMask, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextExtractImageByMaskForPicker", nullptr, aiEditorContextExtractImageByMaskForPicker, nullptr,
     nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextAiMoveReleaseUndo", nullptr, aiEditorContextAiMoveReleaseUndo, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextPixelMapToMask", nullptr, aiEditorContextPixelMapToMask, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"aiEditorContextIsUndoMove", nullptr, aiEditorContextIsUndoMove, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"aiEditorContextGetExportPixelMap", nullptr, aiEditorContextGetExportPixelMap, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"aiEditorContextSaveExportFile", nullptr, aiEditorContextSaveExportFile, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"NAPIMaterial_InitEnv", nullptr, NAPIMaterial_InitEnv, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"AIEditorContext_SaveExpandOperation", nullptr, AIEditorContext_SaveExpandOperation, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_SaveRawExpandRect", nullptr, AIEditorContext_SaveRawExpandRect, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_GetExpandOperation", nullptr, AIEditorContext_GetExpandOperation, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_GetInitExpandImageInfo", nullptr, AIEditorContext_GetInitExpandImageInfo, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_CancelInitExpandImageInfo", nullptr, AIEditorContext_CancelInitExpandImageInfo, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_DoImageExpand", nullptr, AIEditorContext_DoImageExpand, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"AIEditorContext_CancelImageExpand", nullptr, AIEditorContext_CancelImageExpand, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_GetUndoPixelMapSize", nullptr, AIEditorContext_GetUndoPixelMapSize, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_GetRedoPixelMapSize", nullptr, AIEditorContext_GetRedoPixelMapSize, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"Asset_CalculateFrameSize", nullptr, Asset_CalculateFrameSize, nullptr, nullptr, nullptr, napi_default, nullptr},
    
    {"Asset_GetExportSize", nullptr, Asset_GetExportSize, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"Asset_AddXtStyleParamToWatermark", nullptr, Asset_AddXtStyleParamToWatermark, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"Asset_GetExifXtStyleParam", nullptr, Asset_GetExifXtStyleParam, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_SetModelCachePath", nullptr, AIEditorContext_SetModelCachePath, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_SetFastSegPixmap", nullptr, AIEditorContext_SetFastSegPixmap, nullptr, nullptr, nullptr,
     napi_default, nullptr},
};

static const napi_property_descriptor desc_aiMaster[] = {
    {"AIEditorContext_UploadImage", nullptr, AIEditorContext_UploadImage, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_DoRefine", nullptr, AIEditorContext_DoRefine, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"AIEditorContext_ChangeLightOrBlur", nullptr, AIEditorContext_ChangeLightOrBlur, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_ChangeStyleOrCompose", nullptr, AIEditorContext_ChangeStyleOrCompose, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_GetDisplayPixelMapAsync", nullptr, AIEditorContext_GetDisplayPixelMapAsync, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_SetImageConfig", nullptr, AIEditorContext_SetImageConfig, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_CancelDoRefine", nullptr, AIEditorContext_CancelDoRefine, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_ReleaseRefineAIGCSource", nullptr, AIEditorContext_ReleaseRefineAIGCSource, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_ChangeOutPutPixelMapType", nullptr, AIEditorContext_ChangeOutPutPixelMapType, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_GetStyleThumbs", nullptr, AIEditorContext_GetStyleThumbs, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_FaceDetection", nullptr, AIEditorContext_FaceDetection, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_DiscardGainMap", nullptr, AIEditorContext_DiscardGainMap, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_GetIsDoRefineMasterValue", nullptr, AIEditorContext_GetIsDoRefineMasterValue, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_CancelRefineUpload", nullptr, AIEditorContext_CancelRefineUpload, nullptr, nullptr,
     nullptr, napi_default, nullptr}
};

static const napi_property_descriptor desc_xtStyle[] = {
    {"EditorContext_HasXTStyleEffect", nullptr, EditorContext_HasXTStyleEffect, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_GetXtStyleName", nullptr, Asset_GetXtStyleName, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"EditorContext_setXTStyleThumbnailCallback", nullptr, EditorContext_setXTStyleThumbnailCallback, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_requestXTStyleThumbnail", nullptr, Asset_requestXTStyleThumbnail, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_DoPreviewAvoidanceAnimation", nullptr, Asset_DoPreviewAvoidanceAnimation, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_DoXtStyleTriFoldAnimation", nullptr, Asset_DoXtStyleTriFoldAnimation, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_SetPreviewMode", nullptr, Asset_SetPreviewMode, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_GetCurrentXtStyleParams", nullptr, Asset_GetCurrentXtStyleParams, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_SetShowWatermarkValue", nullptr, Asset_SetShowWatermarkValue, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_RefreshCompareEffectList", nullptr, Asset_RefreshCompareEffectList, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_SwitchTabWidthWatermarkAnim", nullptr, Asset_SwitchTabWidthWatermarkAnim, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"Asset_RefreshWatermarkCache", nullptr, Asset_RefreshWatermarkCache, nullptr, nullptr,
     nullptr, napi_default, nullptr},
};

static const napi_property_descriptor desc_removeReflection[] = {
    {"AIEditorContext_RemoveReflectionUploadImage", nullptr, AIEditorContext_RemoveReflectionUploadImage, nullptr,
     nullptr, nullptr, napi_default, nullptr},
    {"AIEditorContext_CancelReflectionUpload", nullptr, AIEditorContext_CancelReflectionUpload, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_RemoveReflection", nullptr, AIEditorContext_RemoveReflection, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"AIEditorContext_CancelRemoveReflection", nullptr, AIEditorContext_CancelRemoveReflection, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_GetRemoveReflectOperation", nullptr, AIEditorContext_GetRemoveReflectOperation, nullptr, nullptr,
     nullptr, napi_default, nullptr},
    {"AIEditorContext_PixelMapToMask", nullptr, AIEditorContext_PixelMapToMask, nullptr, nullptr, nullptr,
     napi_default, nullptr},
};

// 一拍多得接口
static const napi_property_descriptor desc_sport[] = {
    {"Asset_SetProjectConfigValue", nullptr, Asset_SetProjectConfigValue, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"Asset_GeneratorRfDataB", nullptr, Asset_GeneratorRfDataB, nullptr, nullptr, nullptr,
     napi_default, nullptr},
};

EXTERN_C_START
static napi_value MyInit(napi_env env, napi_value exports)
{
    int n = sizeof(desc_thirty)/sizeof(desc_thirty[0]) + sizeof(desc_sixty)/sizeof(desc_sixty[0])
        + sizeof(desc_ninety)/sizeof(desc_ninety[0]) + sizeof(desc_aiMaster)/sizeof(desc_aiMaster[0])
        + sizeof(desc_xtStyle)/sizeof(desc_xtStyle[0])
        + sizeof(desc_removeReflection)/sizeof(desc_removeReflection[0])
        + sizeof(desc_sport)/sizeof(desc_sport[0]);
    napi_property_descriptor mydesc[n];
    int index = 0;
    for (int i = 0, size = sizeof(desc_thirty) / sizeof(desc_thirty[0]); i < size; i++) {
        mydesc[index++] = desc_thirty[i];
    };
    for (int i = 0, size = sizeof(desc_sixty) / sizeof(desc_sixty[0]); i < size; i++) {
        mydesc[index++] = desc_sixty[i];
    };
    for (int i = 0, size = sizeof(desc_ninety) / sizeof(desc_ninety[0]); i < size; i++) {
        mydesc[index++] = desc_ninety[i];
    };
    for (int i = 0, size = sizeof(desc_aiMaster) / sizeof(desc_aiMaster[0]); i < size; i++) {
        mydesc[index++] = desc_aiMaster[i];
    };
    for (int i = 0, size = sizeof(desc_xtStyle) / sizeof(desc_xtStyle[0]); i < size; i++) {
        mydesc[index++] = desc_xtStyle[i];
    }
    for (int i = 0, size = sizeof(desc_removeReflection) / sizeof(desc_removeReflection[0]); i < size; i++) {
        mydesc[index++] = desc_removeReflection[i];
    }
    for (int i = 0, size = sizeof(desc_sport) / sizeof(desc_sport[0]); i < size; i++) {
        mydesc[index++] = desc_sport[i];
    }
    napi_define_properties(env, exports, sizeof(mydesc) / sizeof(mydesc[0]), mydesc);

    return Index::_init(env, exports);
}
EXTERN_C_END

static napi_module myModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = MyInit,
    .nm_modname = "ImageEditor",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterHelloModule(void)
{
    napi_module_register(&myModule);
}
