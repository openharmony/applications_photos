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

#include "MediaCreative.h"
#include "HmcService.h"
#include "MediaCreative/HmcUid.h"

std::shared_ptr<HmcEditor> HmcEditorOpen(const HmcUid &projectId, HmcEditMediaType mediaType,
    HmcEditorCallback callback, void *userData, std::string const & editData)
{
    LOGI("open begin");
    if (callback == NULL) {
        return NULL;
    }
    auto editorImp = std::make_shared<HmcEditorImp>(callback, userData);
    if (!editorImp->Init(projectId, mediaType, editData)) {
        return NULL;
    }
    return editorImp;
}

HmcUid HmcEditorGetProjectId(HmcEditor *editor)
{
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return HMC_UID_NULL;
    }

    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->GetProjectId();
}

void HmcEditorClose(HmcEditor *editor)
{
    LOGI("close");
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return;
    }
    HmcEditorImp *editorImp = (HmcEditorImp *)(editor);
    editorImp = NULL;
}

std::string HmcEditorGetEditData(HmcEditor *editor)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return "";
    }
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->GetEditData();
}

Json::Value HmcEditorGetImageEffectJson(HmcEditor *editor)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return "";
    }
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->GetImageEffectJson();
}

bool HmcEditorIsSystemEditData(const std::string &data)
{
    return HmcProjectEntity::IsSystemEditData(data);
}

bool HmcEditorIsThirdEditData(const std::string &data)
{
    return HmcProjectEntity::IsThirdEditData(data);
}

bool HmcEditorHasWatermarkEffect(const std::string &data, std::function<void(std::string const &jsonPos)> cb)
{
    return HmcProjectEntity::HasWatermarkEffect(data, cb);
}

DOUBLE HmcEditorGetCropRotation(const std::string &data)
{
    return HmcProjectEntity::GetCropRotation(data);
}

void HmcEditorApplyEditData(HmcEditor *editor, int sourceFileFd, const std::string &data, int &result,
                            std::function<void(std::string const &assetId)> onDecodePicture)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return;
    }

    auto editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->ApplyEditData(sourceFileFd, data, result, onDecodePicture);
}

HmcUid HmcEditorGetPreLaneUid(HmcEditor *editor)
{
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return HMC_UID_NULL;
    }

    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->GetPreLaneUid();
}

HmcUid HmcEditorGetPreAssetUid(HmcEditor *editor)
{
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return HMC_UID_NULL;
    }

    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->GetPreAssetUid();
}

void HmcEditorSetPreviewWindow(HmcEditor *editor, void *window)
{
    LOGI("set preview window, window:%s", (window == nullptr) ? "null" : "not null");
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->SetPreviewWindow(window);
}

void HmcEditorSeekTo(HmcEditor *editor, int64_t timestamp, bool isExactMode)
{
    LOGI("timestamp %lld", timestamp);
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->SeekTo(timestamp, isExactMode);
}

void HmcEditorPlay(HmcEditor *editor, int64_t startTime, int64_t endTime)
{
    LOGI("play");
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->Play(startTime, endTime);
}

void HmcEditorPause(HmcEditor *editor)
{
    LOGI("pause");
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->Pause();
}

int HmcEditorGetAutoFlush(HmcEditor *editor)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return FALSE;
    }

    auto editorImp = static_cast<HmcEditorImp *>(editor);

    return editorImp->GetAutoFlush();
}

void HmcEditorSetAutoFlush(HmcEditor *editor, int enable)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return;
    }

    auto editorImp = static_cast<HmcEditorImp *>(editor);

    editorImp->SetAutoFlush(enable);
}

int64_t HmcEditorGetDuration(HmcEditor *editor)
{
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return 0;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    INT64 time = editorImp->GetDuration();
    LOGI("duration %lld", time);
    return time;
}

int64_t HmcEditorImportResultNotify(HmcEditor *editor, int result)
{
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return HMC_ERR;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->OnExportResultNotify(result);
    return HMC_OK;
}

int64_t HmcEditorExportResultNotify(HmcEditor *editor, int result)
{
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return HMC_ERR;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->OnImportResultNotify(result);
    return HMC_OK;
}

int64_t HmcEditorCalcWidthAndLength(int &exportW, int &exportH, int mediaType)
{
    if (exportW < 0 || exportH < 0) {
        LOGE("export size invalid, size=%dx%d", exportW, exportH);
        return HMC_ERR;
    }
    if (exportW == 0) {
        exportW = 1;
    }
    if (exportH == 0) {
        exportH = 1;
    }

    if (mediaType == HMC_ASSET_IMAGE) {
        LOGI("export image size=%dx%d", exportW, exportH);
    } else {
        LOGE("export with invalid mediaType=%d", mediaType);
        return HMC_ERR;
    }
    return HMC_OK;
}

int64_t HmcEditorStartExporting(HmcEditor *editor, HmcDict *dict, HmcEditExportFunc func)
{
    LOGI("start exporting");
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return HMC_ERR;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->StartExporting(dict, func);
}

int64_t HmcEditorEncodePicture(HmcEditor *editor, OH_PictureNative *dstPicture, HmcDict *dict,
    std::function<void (const std::string &, const std::string &)> callback)
{
    LOGI("HmcEditorEncodePicture start exporting");
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        HmcDictDestroy(dict);
        return HMC_ERR;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->EncodePicture(dict, dstPicture, callback);
}

void HmcEditorCancelExporting(HmcEditor *editor)
{
    LOGI("cancel");
    if (editor == NULL) {
        LOGE("%s error, editor is NULL", __FUNCTION__);
        return;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->CancelExporting();
}

int HmcEditorSetCanvasSize(HmcEditor *editor, float width, float height)
{
    int ret = FALSE;
    if (editor == nullptr) {
        LOGE("error, editor is NULL");
        return ret;
    }
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->SetCanvasSize(HmcSize{
        .width = width,
        .height = height });
    return ret;
}

int HmcEditorGetCanvasSize(HmcEditor *editor, float *width, float *height)
{
    if (editor == nullptr) {
        LOGE("error, editor is NULL");
        return HMC_ERR;
    }
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    auto size = editorImp->GetCanvasSize();
    *width = size.width;
    *height = size.height;

    return HMC_OK;
}

int HmcEditorSetUserData(HmcEditor *editor, HmcUid objUid, HmcDict *dict)
{
    if (editor == nullptr || dict == nullptr) {
        LOGE("Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->SetUserData(objUid, dict);
}

int HmcEditorGetUserData(HmcEditor *editor, HmcUid objUid, HmcDict **poutDict)
{
    if (editor == nullptr) {
        LOGE("Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    auto editorImp = static_cast<HmcEditorImp *>(editor);
    return editorImp->GetUserData(objUid, poutDict);
}

long long HmcEditorGetCacheSize()
{
    return static_cast<long>(0);
}

void HmcEditorClearCache(int savingDays)
{
    LOGD("clear cache, savingdays:%d", savingDays);
}

void HmcEditorSetPreviewPeriodRange(HmcEditor *editor, uint64_t startTime, uint64_t endTime)
{
    if (editor == nullptr) {
        LOGE("HmcEditorSetPreviewPeriodRange failed, invalid parameter: editor is null!");
        return;
    }

    auto editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->SetPreviewPeriodRange(startTime, endTime);
}

int32_t HmcEditorGetPreviewPeriodRange(HmcEditor *editor, uint64_t &startTime, uint64_t &endTime)
{
    if (editor == nullptr) {
        LOGE("HmcEditorSetPreviewPeriodRange failed, invalid parameter: editor is null!");
        return HMC_ERR;
    }

    auto editorImp = static_cast<HmcEditorImp *>(editor);
    editorImp->GetPreviewPeriodRange(startTime, endTime);

    return HMC_OK;
}

STRING HmcEditorHasXTStyleEffect(const std::string &data)
{
    return HmcProjectEntity::HasXTStyleEffect(data);
}
