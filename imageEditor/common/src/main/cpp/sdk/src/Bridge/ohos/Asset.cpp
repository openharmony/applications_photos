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

#include "MediaCreative/HmcEditorAsset.h"
#include "MediaCreative/HmcError.h"
#include "interface/index.h"

#include "common/HmcDictHelper.h"
#include "common/Animation.h"
#include "ohos/BackgroundTaskManager.h"
#include "ohos/common/HmcUidHelper.h"
#include "ohos/hve/HveTimeline.h"
#include "ohos/hve/animation/updatecanvas/HveUpdOperAreaPreviewAvoidance.h"
#include "ohos/hve/animation/updatecanvas/HveUpdOperAreaWithPrev2Prev.h"
#include "ohos/hve/animation/updatecanvas/HveUpdateOperationArea.h"
#include "ohos/hve/ProjectConfig.h"
#include "ohos/undoredo/HveAutoAdjustCommand.h"
#include "render/platform/ohos/nativerender/render/plugin_render.h"
#include "system/HmcSystem.h"
#include "util/HmcRectD.h"
#include "undoredo/UndoRedoManager.h"
#include "undoredo/HveComposeCommand.h"
#include "undoredo/HveCutCommand.h"
#include "undoredo/HveAdjustCommand.h"
#include "undoredo/HveCropCommand.h"
#include "ohos/hve/HveAssetOper.h"
#include "ohos/hve/animation/switchpage/HvePreview2Crop.h"
#include "ohos/hve/animation/switchpage/HveCrop2Preview.h"
#include "ohos/hve/animation/switchpage/HvePreview2Preview.h"

static BOOL g_originalSpeedMode = FALSE;

static int g_canvasHalf = 2;

static double g_dampingRatio = 0.7;

static int g_indexZero = 0;

static int g_indexOne = 1;

static int g_indexTwo = 2;

static int g_indexThree = 3;

static int g_indexFour = 4;

static int g_indexFive = 5;

static int g_indexSix = 6;

static int g_indexNinetyNine = 99;

static int g_axisRotation = 2;

static int g_axisIntelligentCorrection = 3;

static int g_proportionsPageId = 4;

static int G_WATERMARK_XT_STYLE_PARAM_LIMIT = 3;

static int G_DO_XTSTYLE_TRI_FOLD_ANIMATION_PARAM_LIMIT = 6;
static int G_DO_XTSTYLE_TRI_FOLD_BOOL_PARAM_LIMIT = 2;


void Asset::SetDeviceType(int timelineId, std::string const & assetId, std::string const & deviceType)
{
    USE_ASSET();
    hveAsset->SetDeviceType(deviceType);
}

void Asset::setSupportNewWatermark(int timelineId, std::string const & assetId, bool supportNewWatermark)
{
    USE_ASSET();
    hveAsset->setSupportNewWatermark(supportNewWatermark);
}

void Asset::SetEditDataType(int timelineId, std::string const & assetId, std::string const & type)
{
    USE_ASSET();
    hveAsset->SetEditDataType(type);
}

void Asset::GetDuration(int timelineId, std::string const & assetId) {}

void Asset::GetPath(int timelineId, std::string const & assetId) {}

void Asset::RequestThumbnail(int timelineId, std::string const & assetId, int64_t startMs, int64_t durationMs,
    int64_t intervalMs)
{
    USE_ASSET();
    hveAsset->SetRefreshThumbnails(false);
    if (!hveAsset->GetInPreviewMode()) {
        LOGW("please do not request thumbnail in crop mode.");
        return;
    }
    BACKGROUND_TASK_MGR->Submit([editor, assetUid, startMs, durationMs, intervalMs]() {
        LOGD("requestThumbnail begin");
        HmcAssetCancelThumbnail(editor, assetUid);
        HmcAssetRequestThumbnail(editor, assetUid, startMs, durationMs, intervalMs);
        LOGD("requestThumbnail end");
    },
        __FUNCTION__);
}

void Asset::requestThumbnailList(int timelineId, std::string const & assetId, std::vector<int64_t> requestList)
{
    USE_ASSET();
    BACKGROUND_TASK_MGR->Submit([editor, assetUid, requestList]() {
        int count = (int)requestList.size();
        if (count == 0) {
            LOGD("requestThumbnailList: request thumbnail count is zero");
            return;
        }
        LOGD("requestThumbnailList begin");
        HmcAssetCancelThumbnail(editor, assetUid);
        int64_t *tbTimeStampArr = (int64_t *)malloc(sizeof(int64_t) * count);
        if (!tbTimeStampArr) {
            LOGD("requestThumbnailList: tbTimeStampArr is NULL");
            return;
        }

        HmcMemZero(tbTimeStampArr, sizeof(int64_t) * count);
        for (int index = 0; index < count; index++) {
            *(tbTimeStampArr + index) = requestList[index];
        }
        HmcAssetRequestThumbnailList(editor, assetUid, tbTimeStampArr, count);
        free(tbTimeStampArr);
        LOGD("requestThumbnailList end");
    },
        __FUNCTION__);
}

void Asset::RequestFilterThumbnail(int timelineId, std::string const & assetId)
{
    USE_ASSET();
    BACKGROUND_TASK_MGR->Submit([editor, assetUid]() {
        LOGD("RequestFilterThumbnail begin");
        HmcAssetRequestFilterThumbnail(editor, assetUid);
        LOGD("RequestFilterThumbnail end");
    },
        __FUNCTION__);
}

void Asset::CancelThumbnail(int timelineId, std::string const & assetId)
{
    USE_ASSET();
    // setThumbnailCallback需要在JS线程下被调用
    timeline->SetThumbnailCallback(nullptr);
    timeline->SetFilterThumbnailCallback(nullptr);
    timeline->SetXTStyleThumbnailCallback(nullptr);
}

void Asset::SetRotation(int timelineId, std::string const & assetId, double rotation, int axis)
{
    std::string type;
    if (axis == 0) {
        type = "verticalCorrection";
    } else if (axis == 1) {
        type = "horizontalCorrection";
    } else if (axis == 2) {
        type = "rotation";
    } else if (axis == g_axisIntelligentCorrection) {
        axis = g_axisRotation;
        type = "intelligentCorrection";
    } else {
        LOGE("SetRotation invalid axis=%d", axis);
        return;
    }

    auto cmd = new (std::nothrow) HveCmdSetRotation(timelineId, assetId, rotation, axis, type);
    if (cmd == nullptr) {
        LOGE("Create HveCmdSetRotation error");
        return;
    }
    UNDO_REDO_MGR->Execute(cmd);
}

void Asset::Rotate90Acw(int timelineId, std::string const & assetId, int frame,
    std::function<void(std::string const & jsonPos)> cb)
{
    // 正在做停止旋转处理时不再执行旋转，防止跳变
    if (HveCmdRotate90Acw::IsRotateReseting()) {
        LOGW("rotate90Acw start not execute, last rotate result processing.");
        return;
    }
    auto cmd = new (std::nothrow) HveCmdRotate90Acw(timelineId, assetId, cb, frame, "ninetyRotate");
    if (cmd == nullptr) {
        LOGE("Create HveCmdRotate90Acw error");
        return;
    }
    HveCmdRotate90Acw::SetLastRotateFrame(frame);
    UNDO_REDO_MGR->Execute(cmd);
}

int Asset::GetTrimOut(int timelineId, std::string const & assetId)
{
    USE_ASSET(0);

    return hveAsset->GetTrimOut();
}

void Asset::InitCropOperationArea(int timelineId, std::string const & assetId, std::vector<double> inputCropRect,
    std::vector<double> boundarySize, std::function<void(std::string const & jsonPos)> cb)
{
    USE_ASSET();
    LOGI("InitCropOperationArea size:%lf, %lf, %lf, %lf. expandedHotspots width:%lf, height:%lf", inputCropRect[0],
        inputCropRect[1], inputCropRect[2], inputCropRect[3], boundarySize[0], boundarySize[1]);
    hveAsset->SetExpandedHotspotsWidth(boundarySize[0]);
    hveAsset->SetExpandedHotspotsHeight(boundarySize[1]);
    hveAsset->SetCropRectMinLen(boundarySize[2]);

    timeline->SetCropOperationArea({ inputCropRect[0], inputCropRect[1], inputCropRect[2], inputCropRect[3] });
    HveAssetOper::InitAsset(timeline, assetUid);

    auto cropRect = timeline->GetCropRect();
    
    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = cropRect.left;
    json["top"] = cropRect.top;
    json["right"] = cropRect.right;
    json["bottom"] = cropRect.bottom;
    cb(fastWriter.write(json));
}

void Asset::UpdateCropOperationArea(int timelineId, std::string const & assetId, double left, double top, double right,
    double bottom, double canvasWidth, double canvasHeight, bool isDeviceVertical, int updateCropAreaType,
    std::function<void(std::string const & jsonPos)> cb)
{
    USE_ASSET();
    LOGI("UpdateCropOperationArea size:%lf, %lf, %lf, %lf. canvasWidth:%lf, canvasHeight:%lf. UpdateCropAreaType:%d",
        left, top, right, bottom, canvasWidth, canvasHeight, updateCropAreaType);

    auto oldCropOperationArea = timeline->GetCropOperationArea();
    // 更新裁剪可操作区域坐标
    HmcRectD rect(left, top, right, bottom);
    timeline->SetCropOperationArea(rect);
    HmcSize newCanvasSize = { static_cast<float>(canvasWidth), static_cast<float>(canvasHeight) };
    HveAssetOper::UpdateAsset(timeline, assetUid, newCanvasSize, oldCropOperationArea, isDeviceVertical,
        updateCropAreaType);

    auto cropRect = timeline->GetCropRect();
    
    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = cropRect.left;
    json["top"] = cropRect.top;
    json["right"] = cropRect.right;
    json["bottom"] = cropRect.bottom;
    cb(fastWriter.write(json));
}

std::string Asset::ReverseCrop(int timelineId, std::string const & assetId, std::vector<double> inputCropRect,
    double ratio, std::vector<int> direction, double pressure)
{
    USE_ASSET(NAPI_JSON_ERROR_RETURN);
    LOGI("ReverseCrop input=[%lf,%lf,%lf,%lf] direction=[%d,%d,%d,%d], ratio=%lf, pressure=%lf", inputCropRect[0],
        inputCropRect[1], inputCropRect[2], inputCropRect[3], direction[0], direction[1], direction[2], direction[3],
        ratio, pressure);

    HmcRectD newCropRect;
    timeline->SetReverseCropRect(timeline->GetCropRect());
    auto cmd =
        new (std::nothrow) HveCmdReverseCrop(timelineId, assetId, inputCropRect, direction, ratio, pressure, "crop");
    int result = HMC_ERR;
    if (cmd != nullptr) {
        result = UNDO_REDO_MGR->Execute(cmd);
    }
    if (result != HMC_OK) {
        newCropRect = timeline->GetReverseCropRect();
    } else {
        newCropRect = timeline->GetCropRect();
    }

    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = newCropRect.left;
    json["top"] = newCropRect.top;
    json["right"] = newCropRect.right;
    json["bottom"] = newCropRect.bottom;
    return fastWriter.write(json);
}

void Asset::ResetPosition(int timelineId, std::string const & assetId,
    std::function<void(std::string const & jsonPos)> cb)
{
    USE_ASSET();
    HveAssetOper::ResetPosition(timeline, assetUid);
    auto cropRect = timeline->GetCropRect();
    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = cropRect.left;
    json["top"] = cropRect.top;
    json["right"] = cropRect.right;
    json["bottom"] = cropRect.bottom;
    cb(fastWriter.write(json));
    hveAsset->SetResetVertex(true);
}

bool Asset::SetCropRect(int timelineId, std::string const & assetId, double left, double top, double right,
    double bottom, double animMs, int clipRatioType, std::string const & chooseRatio,
    std::function<void(std::string const & jsonPos)> cb)
{
    USE_ASSET(false);
    LOGD("SetCropRect size:%lf, %lf, %lf, %lf. clipRatioType:%d", left, top, right, bottom, clipRatioType);

    std::string type;
    if (clipRatioType == 1) {
        type = "clipRatio";
    } else if (clipRatioType == 2) {
        type = "crop";
    } else {
        type = "";
    }
    HmcRectD rect(left, top, right, bottom);
    auto cmd =
        new (std::nothrow) HveCmdSetCropRect(timelineId, assetId, rect, animMs, clipRatioType, chooseRatio, type);
    if (cmd == nullptr) {
        LOGE("Create HveCmdSetCropRect error");
        return false;
    }
    UNDO_REDO_MGR->Execute(cmd);

    auto newCropRect = timeline->GetCropRect();
    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = newCropRect.left;
    json["top"] = newCropRect.top;
    json["right"] = newCropRect.right;
    json["bottom"] = newCropRect.bottom;

    cb(fastWriter.write(json));
    return hveAsset->IsAssetPosChange(DEVIATION);
}

/**
 * 获取素材坐标
 *
 * @param timelineId 泳道当前时刻
 * @param assetId    剪辑的UID
 */
std::string Asset::GetCanvasPosition(int timelineId, std::string const &assetId)
{
    USE_ASSET("");
    auto cropRect = timeline->GetCropRect();
    float canvasWidth;
    float canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    HmcRectD rect((canvasWidth - cropRect.Width()) / g_canvasHalf, (canvasHeight - cropRect.Height()) / g_canvasHalf,
                  (canvasWidth + cropRect.Width()) / g_canvasHalf, (canvasHeight + cropRect.Height()) / g_canvasHalf);
    if (hveAsset->GetInPreviewMode()) {
        auto previewScale = hveAsset->GetPreviewScale();
        auto previewOffsetX = hveAsset->GetPreviewOffsetX();
        auto previewOffsetY = hveAsset->GetPreviewOffsetY();
        rect.Scale(previewScale, rect.CenterX(), rect.CenterY());
        rect.Translate(previewOffsetX, -previewOffsetY);
    } else {
        auto cropOffsetX = cropRect.CenterX() - canvasWidth / g_canvasHalf;
        auto cropOffsetY = canvasHeight / g_canvasHalf - cropRect.CenterY();
        auto cropScale = 1.0F;
        rect.Scale(cropScale, rect.CenterX(), rect.CenterY());
        rect.Translate(cropOffsetX, -cropOffsetY);
    }
    Json::Value json;
    Json::FastWriter fastWriter;
    json["x"] = rect.left;
    json["y"] = rect.top;
    json["width"] = rect.Width();
    json["height"] = rect.Height();
    return fastWriter.write(json);
}

static void GesturePositon(auto cropRect, double offsetX, double offsetY, int screenOperationType,
    int& isReachableBoundary, HmcEditor *editor, HveAsset *hveAsset, HmcUid &assetUid)
{
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    HmcRectD rect((canvasWidth - cropRect.Width()) / g_canvasHalf, (canvasHeight - cropRect.Height()) / g_canvasHalf,
                  (canvasWidth + cropRect.Width()) / g_canvasHalf, (canvasHeight + cropRect.Height()) / g_canvasHalf);
    auto previewScale = hveAsset->GetPreviewScale();
    auto previewOffsetX = hveAsset->GetPreviewOffsetX();
    auto previewOffsetY = hveAsset->GetPreviewOffsetY();
    rect.Scale(previewScale, rect.CenterX(), rect.CenterY());
    rect.Translate(previewOffsetX, -previewOffsetY);
    float vertex[] = {(float)rect.left,  (float)rect.top,    (float)rect.right, (float)rect.top,
                      (float)rect.right, (float)rect.bottom, (float)rect.left,  (float)rect.bottom};
    HveAssetOper::VertexTranslate(vertex, offsetX, offsetY);

    double fixOffsetX = offsetX;
    double fixOffsetY = offsetY;
    HmcRectD translateCropRect(0, 0, 0, 0);
    bool succeed =
        HveAssetOper::CalcReachableBoundaryCropRect(vertex, cropRect, &translateCropRect,
                                                    hveAsset->CanDrawWatermark()?hveAsset->GetWatermarkType() : 0);
    if (succeed) {
        HveAssetOper::GetReachableBoundaryOffset(translateCropRect, cropRect, true, screenOperationType, offsetX,
                                                 offsetY, &fixOffsetX, &fixOffsetY);
        isReachableBoundary = HveAssetOper::IsReachableBoundary(translateCropRect, cropRect);
    }

    auto newPreviewOffsetX = hveAsset->GetPreviewOffsetX() + fixOffsetX;
    auto newPreviewOffsetY = hveAsset->GetPreviewOffsetY() - fixOffsetY;
    hveAsset->SetPreviewOffsetX(newPreviewOffsetX);
    hveAsset->SetPreviewOffsetY(newPreviewOffsetY);
    LOGD("asset translate in PreviewMode newPreviewOffsetX=%f, newPreviewOffsetY=%f", newPreviewOffsetX,
         newPreviewOffsetY);
    HmcAssetCropTransformSetPosition(editor, assetUid, newPreviewOffsetX, newPreviewOffsetY, previewScale, previewScale,
                                     0);

    hveAsset->SetGestureCenterX(cropRect.CenterX());
    hveAsset->SetGestureCenterY(cropRect.CenterY());
}

/**
 * 移动素材
 *
 * @param timelineId 泳道当前时刻
 * @param assetId    剪辑的UID
 * @param offsetX    移动偏移量X坐标值
 * @param offsetY    移动偏移量Y坐标值
 * @param screenOperationType 屏幕操作类型，0：触屏操作，1：鼠标操作
 */
int Asset::Translate(int timelineId, std::string const & assetId, double offsetX, double offsetY,
    int screenOperationType)
{
    USE_ASSET(0);
    CancelAnimation();

    LOGD("Asset::Translate offsetX:%lf, offsetY:%lf", offsetX, offsetY);
    int isReachableBoundary = 0;
    auto cropRect = timeline->GetCropRect();
    HmcEditorSetAutoFlush(editor, false);
    if (hveAsset->GetInPreviewMode()) {
        hveAsset->SetIsDragImage(true);
        GesturePositon(cropRect, offsetX, offsetY, screenOperationType, isReachableBoundary, editor, hveAsset,
            assetUid);
    } else {
        float vertex[8];
        HmcAssetGetVertexPosition(editor, assetUid, vertex, CROP_VERTEX_SIZE);
        HveAssetOper::VertexTranslate(vertex, offsetX, offsetY);

        double fixOffsetX = offsetX;
        double fixOffsetY = offsetY;
        HmcRectD translateCropRect(0, 0, 0, 0);
        bool succeed = HveAssetOper::CalcReachableBoundaryCropRect(vertex, cropRect, &translateCropRect,
                                                                   hveAsset->CanDrawWatermark() ?
                                                                   hveAsset->GetWatermarkType() : 0);
        if (succeed) {
            HveAssetOper::GetReachableBoundaryOffset(translateCropRect, cropRect, false, screenOperationType, offsetX,
                offsetY, &fixOffsetX, &fixOffsetY);
            isReachableBoundary = HveAssetOper::IsReachableBoundary(translateCropRect, cropRect);
        }

        int isHorizontalMirror = 0;
        HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
        float posX;
        float posY;
        HmcAssetGetPositionByCenter(editor, assetUid, &posX, &posY);

        float newOffsetX = 0.0;
        float newOffsetY = posY - fixOffsetY;
        if (isHorizontalMirror) {
            newOffsetX = posX - fixOffsetX;
        } else {
            newOffsetX = posX + fixOffsetX;
        }
        LOGD("asset translate in CropMode newOffsetX=%f, newOffsetY=%f", newOffsetX, newOffsetY);
        HmcAssetSetPositionByCenter(timeline->GetEditor(), assetUid, newOffsetX, newOffsetY);
        hveAsset->SetResetVertex(true);
    }
    HmcEditorSetAutoFlush(editor, true);
    return isReachableBoundary;
}

void Asset::CalculateCropSize(int timelineId, const std::string &assetId, std::function<void(int width, int height)> cb)
{
    LOGI("enter CalculateCropSize");
    USE_ASSET();

    auto cropRect = timeline->GetCropRect();
    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("get asset object failed, please check your asset id");
        return;
    }
    auto visionAsset = (HmcVisionAsset *)asset;
    HmcSize assetSize = visionAsset->HmcAssetGetCurSize();

    INT32 imageW = originalSize.width;
    INT32 imageH = originalSize.height;

    double cropRectWidth = cropRect.Width();
    double cropRectHeight = cropRect.Height();

    FLOAT downSampleScale = ((HmcImageAsset *)asset)->GetDownSampleScale();
    LOGI("CalculateCropSize downSampleScale: %f", downSampleScale);

    if (HveAssetOper::AssetSizeIsExchanged(hveAsset->GetBaseRotation())) {
        std::swap(assetSize.width, assetSize.height);
        std::swap(originalSize.width, originalSize.height);
    }

    if ((cropRectWidth > 0) && (cropRectHeight > 0) && (assetSize.width > 0) && (assetSize.height > 0)) {
        imageW = round(cropRectWidth / assetSize.width * originalSize.width) / downSampleScale;
        imageH = round(cropRectHeight / assetSize.height * originalSize.height) / downSampleScale;
    }

    LOGI("CalculateCropSize image: %d %d, assetSize: %f %f", imageW, imageH, assetSize.width, assetSize.height);

    cb(imageW, imageH);
}

static void CalculateRectangular(HveTimeline *timeline, HmcEditor *editor, HmcUid &assetUid, double &scale,
    HveAsset *hveAsset, double &fixScale, HmcSize &size)
{
    auto cropRect = timeline->GetCropRect();
    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);
    // 最大放大倍数为单边像素2
    double cropMaxScale = HMC_MIN(originalSize.width / 2.0, originalSize.height / 2.0);
    // 1. 放大且最大放大倍数<= 1时素材保持不变   2. 缩放比例为1时素材保持不变
    if ((scale > CROP_REBOUND_MIN_SCALE && cropMaxScale <= CROP_REBOUND_MIN_SCALE) || fabs(scale) < DOUBLE_PRECISION) {
        return;
    }

    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    float initWidth = size.width;
    float initHeight = size.height;
    auto baseRotation = hveAsset->GetBaseRotation();
    if (HveAssetOper::AssetSizeIsExchanged(baseRotation)) {
        std::swap(size.width, size.height);
        std::swap(initWidth, initHeight);
    }

    // 缩放到1:1时，增加0.7倍的缩放比例差值，增加阻尼感
    if (scale < CROP_REBOUND_MIN_SCALE &&
        HveAssetOper::LessNotEqual(size.width, cropRect.Width() * CROP_REBOUND_MIN_SCALE)) {
        scale = scale + (CROP_REBOUND_MIN_SCALE - scale) * g_dampingRatio;
        fixScale = scale;
    }

    size.width = size.width * scale;
    size.height = size.height * scale;
    float ratio = size.width / size.height;

    LOGD("Scale size:%f,%f, cropRect:%f,%f", size.width, size.height, cropRect.Width(), cropRect.Height());
    if (size.width > cropRect.Width() * cropMaxScale && cropMaxScale > CROP_REBOUND_MIN_SCALE) {
        size.width = cropRect.Width() * cropMaxScale;
        size.height = size.width / ratio;
        fixScale = size.width / initWidth;
    } else if (size.height > cropRect.Height() * cropMaxScale && cropMaxScale > CROP_REBOUND_MIN_SCALE) {
        size.height = cropRect.Height() * cropMaxScale;
        size.width = size.height * ratio;
        fixScale = size.height / initHeight;
    }

    if (HveAssetOper::AssetSizeIsExchanged(baseRotation)) {
        std::swap(size.width, size.height);
    }
}

static void CalculatePosition(HveTimeline *timeline, HmcEditor *editor, HmcUid &assetUid, double centerX,
    double centerY, float canvasWidth, float canvasHeight, HveAsset *hveAsset, double &fixScale, HmcSize &size,
    double &scale)
{
    // 计算缩放后偏移坐标
    float posX;
    float posY;
    HmcAssetGetPositionByCenter(editor, assetUid, &posX, &posY);

    int isHorizontalMirror = 0;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    if (isHorizontalMirror) {
        // 添加镜像效果后，缩放中心点X坐标取画布中心点对称值
        centerX = canvasWidth - centerX;
    }

    double newPosX = centerX - canvasWidth / 2 - posX;
    double newPosY = posY - (canvasHeight / 2 - centerY);
    double offsetX = newPosX - newPosX * fixScale;
    double offsetY = newPosY - newPosY * fixScale;
    HmcEditorSetAutoFlush(editor, false);
    HmcAssetSetPositionByCenter(timeline->GetEditor(), assetUid, posX + offsetX, posY - offsetY);

    HmcAssetSetSize(editor, assetUid, size);
    HmcEditorSetAutoFlush(editor, true);
    hveAsset->SetResetVertex(true);
    LOGI("HmcAssetSetSize %lf  w = %lf  h = %lf", scale, size.width, size.height);
}

void Asset::Scale(int timelineId, std::string const & assetId, double scale, double centerX, double centerY)
{
    USE_ASSET();
    LOGI("Asset::Scale:%lf, centerX:%lf, centerY:%lf", scale, centerX, centerY);

    CancelAnimation();

    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(timeline->GetEditor(), &canvasWidth, &canvasHeight);
    double fixScale = scale;

    if (hveAsset->GetInPreviewMode()) {
        auto previewScale = hveAsset->GetPreviewScale();
        float newPreviewScale = previewScale * scale;

        // 缩放到1:1时，增加0.7倍的缩放比例差值，增加阻尼感
        if (scale < CROP_REBOUND_MIN_SCALE && newPreviewScale < CROP_REBOUND_MIN_SCALE) {
            fixScale = scale + (CROP_REBOUND_MIN_SCALE - scale) * 0.7;
            newPreviewScale = previewScale * fixScale;
        }

        // 预览区缩放回弹最大倍数 = 预览区缩放最大倍数 + 1
        float previewMaxScale = HveAssetOper::CalPreviewMaxScale(timeline, assetUid);
        float previewReboundMaxScale = previewMaxScale + 1.0f;

        // 暂时不用对数算法，当前对比发现按比例缩放回弹效果和xxx也很接近，另外使用对数算法缩放，效果也不是很好。后面看大家使用效果再优化
        if (newPreviewScale > previewReboundMaxScale) {
            newPreviewScale = previewReboundMaxScale;
            fixScale = newPreviewScale / previewScale;
        } else if (newPreviewScale < PREVIEW_REBOUND_MIN_SCALE) {
            newPreviewScale = PREVIEW_REBOUND_MIN_SCALE;
            fixScale = newPreviewScale / previewScale;
        }
        LOGD("Asset::fixScale:%f", fixScale);

        double posX = centerX - canvasWidth / 2 - hveAsset->GetPreviewOffsetX();
        double posY = hveAsset->GetPreviewOffsetY() - (canvasHeight / 2 - centerY);
        auto newPreviewOffsetX = hveAsset->GetPreviewOffsetX() + (posX - posX * fixScale);
        auto newPreviewOffsetY = hveAsset->GetPreviewOffsetY() - (posY - posY * fixScale);
        HmcEditorSetAutoFlush(editor, false);
        hveAsset->SetPreviewOffsetX(newPreviewOffsetX);
        hveAsset->SetPreviewOffsetY(newPreviewOffsetY);
        HmcAssetCropTransformSetPosition(timeline->GetEditor(), assetUid, newPreviewOffsetX, newPreviewOffsetY,
            newPreviewScale, newPreviewScale, 0);
        hveAsset->SetPreviewScale(newPreviewScale);
        hveAsset->SetGestureCenterX(centerX);
        hveAsset->SetGestureCenterY(centerY);
        HmcEditorSetAutoFlush(editor, true);
    } else {
        HmcSize size;
        CalculateRectangular(timeline, editor, assetUid, scale, hveAsset, fixScale, size);
        CalculatePosition(timeline, editor, assetUid, centerX, centerY, canvasWidth, canvasHeight, hveAsset,
            fixScale, size, scale);
    }
}

float Asset::GetPreviewMaxScale(int timelineId, std::string const & assetId)
{
    USE_ASSET(0.0f);
    return HveAssetOper::CalPreviewMaxScale(timeline, assetUid);
}

bool Asset::FillCropRect(int timelineId, std::string const & assetId, int cropType, int aniDuration, double left,
    double top, double right, double bottom, std::function<void(std::string const & jsonPos)> cb)
{
    USE_ASSET(false);
    LOGI("[FillCropRect] input cropRect=%lf,%lf,%lf,%lf cropType=%d  aniDuration=%d", left, top, right, bottom,
        cropType, aniDuration);

    if (hveAsset->GetInPreviewMode()) {
        HveAssetOper::PreviewScaleVibration(timeline, assetUid, (CropAssetOperation)cropType, cb);
        HveAssetOper::FillPreviewRect(timeline, assetUid, aniDuration, HveAssetOper::DefaultRule);
        return hveAsset->IsAssetPosChange(DEVIATION);
    }

    // 连续操作 缩放、移动结束时设置动画结束回调
    if ((CropAssetOperation)cropType == ONE_FINGER_MOVE_END || (CropAssetOperation)cropType == TWO_FINGER_SCALE_END) {
        hveAsset->SetAssetOperationCb(MOVE_SCALE_END, cb);
    }

    std::string type;
    if (cropType != 0) {
        type = "crop";
    } else {
        type = "";
    }
    HmcRectD rect(left, top, right, bottom);
    auto cmd = new (std::nothrow) HveCmdCropAsset(timelineId, assetId, cropType, aniDuration, rect, type);
    if (cmd == nullptr) {
        LOGE("Create HveCmdCropAsset error");
        return false;
    }
    UNDO_REDO_MGR->Execute(cmd);
    return hveAsset->IsAssetPosChange(DEVIATION);
}

void Asset::SwitchPreviewMode(int timelineId, std::string const & assetId)
{
    USE_ASSET();
    auto switchCrop2Preview = std::make_shared<HveCrop2Preview>(timeline, assetUid, SWITCH_PAGE_ANIMATION_TIME);
    switchCrop2Preview->Execute();

    auto editorImp = static_cast<HmcEditorImp *>(editor);
    if (editorImp != nullptr) {
        editorImp->OnDisplayAreaChanged();
    }
}

void Asset::SwitchCropMode(int timelineId, std::string const & assetId)
{
    USE_ASSET();
    HmcAssetCancelThumbnail(editor, assetUid);
    auto switchPreview2Crop = std::make_shared<HvePreview2Crop>(timeline, assetUid, SWITCH_PAGE_ANIMATION_TIME);
    switchPreview2Crop->Execute();
}

void Asset::SwitchPageRender(int timelineId, std::string const & assetId)
{
    LOGI("SwitchPageRender enter");
    USE_ASSET();
    hveAsset->SetIsSwitchPage(true);
    // 这一步刷新是为将 透明度刷成0 防止动画跳变
    hveAsset->RefreshWatermarkCropRectAndOpacity(timeline->GetCropRect());
    HMC_EDITOR_SETTER(editor);
    LOGI("SwitchPageRender end");
}

/**
 * 手动开启自动刷新
 *
 * @param timelineId 时间轴的UID
 * @param assetId    资源ID
 */
void Asset::SetEditorAutoFlush(int timelineId, std::string const &assetId)
{
    USE_ASSET();
    LOGI("SetEditorAutoFlush");

    HmcEditorSetAutoFlush(editor, false);
    HmcEditorSetAutoFlush(editor, true);
}

/**
 * 裁剪区域图像显示开关
 *
 * @param timelineId 时间轴的UID
 * @param assetId    资源ID
 * @param enable   true:只显示裁剪框部分图像; false: 显示全部图像
 */
void Asset::SetCropAreaEnable(int timelineId, std::string const &assetId, bool enabled)
{
    USE_ASSET();
    LOGI("SetCropAreaEnable enabled:%d", enabled);

    HmcEditorSetAutoFlush(editor, false);
    if (enabled) {
        hveAsset->UpdatePreviewMode(timeline->GetCropRect(), timeline->GetCropOperationArea(),
            hveAsset->GetInPreviewMode());
        hveAsset->SetAdjustVignetteEnable(true);

        auto editorImp = static_cast<HmcEditorImp *>(editor);
        if (editorImp != nullptr) {
            editorImp->OnDisplayAreaChanged();
        }
    } else {
        hveAsset->UpdateCropMode();
    }
    HmcEditorSetAutoFlush(editor, true);
}

std::string Asset::CalcOptimalRectUnderRatio(int timelineId, std::string const & assetId, double left, double top,
    double right, double bottom, double ratio)
{
    USE_ASSET(NAPI_JSON_ERROR_RETURN);
    float input[4];
    auto cropLimitation = timeline->GetCropLimitation();
    input[0] = (float)cropLimitation.left;
    input[1] = (float)cropLimitation.top;
    input[2] = (float)cropLimitation.right;
    input[3] = (float)cropLimitation.bottom;

    float output[4] = { 0, 0, 0, 0 };
    bool succeed = HveAssetOper::CalcOptimalCropRect(
        editor, assetUid,
        [ratio](float *corners, float *input, float *output) {
            return HveAssetOper::SwitchRatioRule(ratio, corners, input, output);
        },
        input, RECT_SIZE, output, RECT_SIZE);
    if (!succeed) {
        return NAPI_JSON_ERROR_RETURN;
    }
    LOGI("calcOptimalRectUnderRatio output=%lf,%lf,%lf,%lf", output[0], output[1], output[2], output[3]);

    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = output[0];
    json["top"] = output[1];
    json["right"] = output[2];
    json["bottom"] = output[3];

    return fastWriter.write(json);
}

std::string Asset::GetReachableCropRect(int timelineId, std::string const & assetId, double left, double top,
    double right, double bottom, double ratio, int dleft, int dtop, int dright, int dbottom,
    std::function<void(std::string const & jsonPos)> cb)
{
    USE_ASSET(NAPI_JSON_ERROR_RETURN);
    LOGD("GetReachableCropRect input=%lf,%lf,%lf,%lf", left, top, right, bottom);

    auto cropRect = timeline->GetCropRect();
    HmcRectD inputCropRect(left, top, right, bottom);
    Json::Value json;
    Json::FastWriter fastWriter;
    if (cropRect.IsSameRect(inputCropRect)) {
        json["left"] = cropRect.left;
        json["top"] = cropRect.top;
        json["right"] = cropRect.right;
        json["bottom"] = cropRect.bottom;
        return fastWriter.write(json);
    }

    int direction[] = { dleft, dtop, dright, dbottom };
    float input[] = { static_cast<float>(left), static_cast<float>(top),
                      static_cast<float>(right), static_cast<float>(bottom) };
    double minEdgeX = 0;
    double minEdgeY = 0;
    HveAssetOper::GetMinCropSize(timeline, assetUid, ratio, &minEdgeX, &minEdgeY);
    if ((right - left) < minEdgeX) {
        if (direction[g_indexZero]) {
            input[0] = right - minEdgeX;
        }
        if (direction[g_indexTwo]) {
            input[2] = left + minEdgeX;
        }
    }
    if ((bottom - top) < minEdgeY) {
        if (direction[g_indexOne]) {
            input[1] = bottom - minEdgeY;
        }
        if (direction[g_indexThree]) {
            input[3] = top + minEdgeY;
        }
    }

    float output[4] = { 0, 0, 0, 0 };
    bool succeed = HveAssetOper::CalcOptimalCropRect(
        editor, assetUid,
        [ratio, direction](float *corners, float *input, float *output) {
            return HveAssetOper::ReachableRectRule(ratio, (int *)direction, corners, input, output);
        },
        input, RECT_SIZE, output, RECT_SIZE);
    if (!succeed) {
        return NAPI_JSON_ERROR_RETURN;
    }
    json["left"] = output[0];
    json["top"] = output[1];
    json["right"] = output[2];
    json["bottom"] = output[3];
    return fastWriter.write(json);
}

void Asset::SetMirror(int timelineId, std::string const & assetId, int mirrorFlag, int mirrorType,
    std::function<void(std::string const & jsonPos)> cb)
{
    auto cmd = new (std::nothrow) HveCmdSetMirror(timelineId, assetId, mirrorFlag, mirrorType, cb, "mirror");
    if (cmd == nullptr) {
        LOGE("Create HveCmdSetMirror error");
        return;
    }
    UNDO_REDO_MGR->Execute(cmd);
}

void Asset::SetAdjustValue(int timelineId, std::string const & assetId, std::string const & adjustName, double value,
    std::function<void(std::string const & jsonStr)> cb)
{
    std::string type = adjustName.c_str();
    HveCommand *cmd;
    if (adjustName == DICT_KEY_ADJUST_AUTO) {
        cmd = new (std::nothrow) HveCmdAutoAdjustValue(timelineId, adjustName, assetId, value, cb);
    } else {
        cmd = new (std::nothrow) HveCmdAdjustValue(timelineId, type, assetId, adjustName.c_str(), value);
    }
    if (cmd == nullptr) {
        LOGE("new HveAdjustValue error");
        return;
    }
    UNDO_REDO_MGR->Execute(cmd);
}
void Asset::SetAdjustEnable(int timelineId, std::string const & assetId, std::string const & adjustEnableName,
    bool enabled, std::function<void(std::string const & jsonStr)> cb)
{
    std::string type = adjustEnableName.c_str();
    HveCommand *cmd;
    if (adjustEnableName == DICT_KEY_ADJUST_AUTO) {
        cmd = new (std::nothrow) HveCmdAutoAdjustEnable(timelineId, adjustEnableName, assetId, enabled, cb);
    } else {
        cmd = new (std::nothrow) HveCmdAdjustEnable(timelineId, type, assetId, adjustEnableName.c_str(), enabled);
    }
    if (cmd == nullptr) {
        LOGE("new HveAdjustEnable error");
        return;
    }
    UNDO_REDO_MGR->Execute(cmd);
}
void Asset::SetAdjustValueAndEnable(int timelineId, std::string const &assetId, std::string const &adjustName,
                                    double value, std::function<void(std::string const &jsonStr)> cb)
{
    std::string type = adjustName.c_str();
    HveCmdAdjustValue *cmd = new (std::nothrow) HveCmdAdjustValue(timelineId, type, assetId, adjustName.c_str(), value);
    cmd->SetEnableChecked(true);
    if (cmd == nullptr) {
        LOGE("new HveAdjustValue error");
        return;
    }
    UNDO_REDO_MGR->Execute(cmd);
}

void Asset::PreloadAdjustResource(int timelineId, std::string const &assetId)
{
    USE_ASSET();
}

std::string Asset::GetAdjustProperty(int timelineId, std::string const & assetId)
{
    USE_ASSET(NAPI_JSON_ERROR_RETURN);
    HmcDict *dict = HmcDictCreate();
    HmcUid adjustEffectId = HveAssetOper::FindEffectByType(timeline->GetEditor(), assetUid, HMC_EFFECT_ADJUST);
    // 调节不是内置效果，如果还没创建，返回默认参数给ui(适配当前uid代码)
    if (!HmcUidIsNull(&adjustEffectId)) {
        HmcEffectGetProperty(editor, adjustEffectId, dict);
    }

    std::string result = hveAsset->ConvAdjustDict2Json(dict);
    HmcDictDestroy(dict);
    return result;
}

void Asset::ResetAdjustProperty(int timelineId, std::string const & assetId)
{
    USE_ASSET();
    HmcUid adjustEffectId = HveAssetOper::FindEffectByType(timeline->GetEditor(), assetUid, HMC_EFFECT_ADJUST);
    HmcDict *dict = HmcDictCreate();
    hveAsset->SetDefaultValueToAdjustDict(dict);
    HmcEffectSetProperty(editor, adjustEffectId, dict);
    HmcDictDestroy(dict);
}

void Asset::SetRefreshRate(int timelineId, std::string const &assetId, int refreshRate)
{
    USE_ASSET();
    LOGD("SetRefreshRate %d", refreshRate);
    hveAsset->SetRefreshRate(refreshRate);
}

void Asset::AddStylus(int timelineId, std::string const &assetId, void *dstPixel, int x, int y, int width, int height,
                      std::function<void(napi_value value)> cb)
{
    USE_ASSET();
    LOGI("AddStylus begin timelineid=%d, assetId=%s, x=%d, y=%d, width=%d, height=%d", timelineId,
         assetId.c_str(), x, y, width, height);
    auto cmd = new (std::nothrow) HveCmdCompose(timelineId, "", assetId, dstPixel, x, y, width, height);
    if (cmd != nullptr) {
        // 不进入unredomanager
        cmd->Execute(cb);
        delete cmd;
    } else {
        LOGE("AddStylus cmd = null, timelineId=%d, assetId=%s", timelineId, assetId.c_str());
    }
}

int Asset::SetOriginalColorMode(int timelineId, std::string const & assetId, int mode)
{
    USE_ASSET(-1);
    return HmcAssetSetOriginalColorMode(timeline->GetEditor(), assetUid, mode);
}

int Asset::GetOriginalColorMode(int timelineId, std::string const & assetId)
{
    USE_ASSET(-1);
    return HmcAssetGetOriginalColorMode(assetUid);
}

void Asset::RequestAssetAudioWave(int timelineId, std::string const & assetId, int64_t stattimestamp,
    int64_t audioDuration, int64_t previewDuration, int previewPoints)
{
    USE_EDITOR();
    BACKGROUND_TASK_MGR->Submit([editor, assetId, stattimestamp, audioDuration, previewDuration, previewPoints] {
        HmcUid assetUid = HmcUidHelper(assetId);

        int doublePoints = previewPoints * 2;
        int64_t doublePreviewDuration = previewDuration * 2;
        int pts = round((double)audioDuration / previewDuration * previewPoints);
        LOGD("RequestAssetAudioWave assetId=%s, stattimestamp=%lld, duration=%lld, previewDuration=%lld, "
            "previewPoints=%d, pts=%d",
            assetId.c_str(), stattimestamp, audioDuration, previewDuration, previewPoints, pts);
        if (pts < doublePoints) {
            HmcAssetRequestAudioWave(editor, assetUid, stattimestamp, audioDuration, pts);
        } else {
            HmcAssetRequestAudioWave(editor, assetUid, stattimestamp, doublePreviewDuration, doublePoints);
            HmcAssetRequestAudioWave(editor, assetUid, stattimestamp + doublePreviewDuration,
                audioDuration - doublePreviewDuration, pts - doublePoints);
        }
    },
        __FUNCTION__);
}

int Asset::AssetIsInCurrentTime(int timelineId, std::string const & assetId)
{
    USE_ASSET(0);
    if (HmcAssetIsInCurrentTime(editor, assetUid)) {
        return 1;
    }

    return 0;
}

void Asset::SetUserData(int timelineId, std::string const & assetId, std::string const & key, double value)
{
    USE_ASSET();
    HmcDict *dict = nullptr;
    HmcEditorGetUserData(editor, assetUid, &dict);
    if (dict == nullptr) {
        LOGE("get asset user data fail.");
        return;
    }
    HmcDictSetDouble(dict, key.c_str(), value);
    HmcEditorSetUserData(editor, assetUid, dict);
    HmcDictDestroy(dict);
}

void Asset::SetSourceByPixelMap(int timelineId, std::string const & assetId, void* pixels)
{
    USE_ASSET();
    HmcAssetSetSourceByPixelMap(editor, assetUid, pixels);
}

double Asset::GetUserData(int timelineId, std::string const & assetId, std::string const & key)
{
    double doubleValue = -1;
    USE_ASSET(doubleValue);
    HmcDict *dict = nullptr;
    HmcEditorGetUserData(editor, assetUid, &dict);
    if (dict == nullptr) {
        LOGE("get asset user data fail.");
        return doubleValue;
    }

    HmcDictGetDouble(dict, key.c_str(), &doubleValue);
    HmcDictDestroy(dict);
    return doubleValue;
}

/**
 * 用户切换页面，UI同步给SDK
 *
 * @param timelineId 时间轴的UID
 * @param assetId    资源ID
 * @param pageId     页面ID，0：智能校正；1:旋转；2:水平矫正；3:垂直矫正；4:比例
 */
void Asset::SwitchCropPage(int timelineId, std::string const & assetId, int pageId)
{
    USE_ASSET();

    switch (pageId) {
        case 4:
            HveAssetOper::UpdateCropLimitation(timeline);
            break;
        case 0:
        case 1:
        case 2:
        case 3:
            HveAssetOper::UpdateBaseRotationAssetSize(timeline, assetUid);
            break;
        default:
            LOGW("SwitchCropPage invalid pageId.");
    }
}

bool Asset::GetRefreshThumbnails(int timelineId, std::string const & assetId)
{
    USE_ASSET(false);
    return hveAsset->GetRefreshThumbnails();
}

void Asset::FinishAnimation(int timelineId, std::string const & assetId)
{
    USE_ASSET();
    FinishAnimationInner();
}

/**
 * 计算画框水印高度
 * @param width 图片宽
 * @param height 图片高
 * @param isFrameSticker 是否边框水印
 * @param isBorderSticker 是否四边白框水印
 * @param cb 回调
 */
void Asset::CalculateFrameSize(int width, int height, STRING const &watermarkType, STRING const &editData,
                               std::function<void(std::string const &jsonPos)> cb)
{
    Json::Value json;
    Json::FastWriter fastWriter;
    json["top"] = 0;
    json["bottom"] = 0;
    json["left"] = 0;
    json["right"] = 0;
    cb(fastWriter.write(json));
}

/**
 * 将 当前的XXX参数添加到水印数据中
 * @param timelineId
 * @param assetId
 * @param xtStyleTextParams XXX数据
 */
void Asset::AddXtStyleParamToWatermark(int timelineId, std::string const &assetId,
                                       VECTOR<STRING> const &xtStyleTextParams, bool autoFlush, bool needInitCache)
{
    USE_ASSET();
    if (xtStyleTextParams.size() < G_WATERMARK_XT_STYLE_PARAM_LIMIT) {
        return;
    }
     // 0 位置是 颜色
    STRING xtStyleColor = xtStyleTextParams[g_indexZero];

     // 1 位置是 XXX名称
    STRING xtStyleText  = xtStyleTextParams[g_indexOne];
     // 2 位置是 XXX参数
    STRING xtStyleCode  = xtStyleTextParams[g_indexTwo];
    // 防止重复刷新水印缓存。
    if (xtStyleColor == hveAsset->GetXtStyleColor() && xtStyleText == hveAsset->GetXtStyleText()
        && xtStyleCode == hveAsset->GetXtStyleCode()) {
        LOGI("AddXtStyleParamToWatermark is same param so return");
        return;
    }
    hveAsset->SetXtStyleColor(xtStyleColor);
    hveAsset->SetXtStyleText(xtStyleText);
    hveAsset->SetXtStyleCode(xtStyleCode);
    hveAsset->RefreshWatermarkXtStyleParam(timeline->GetCropRect(), autoFlush, needInitCache);
}

/**
 * 请求个性风格缩略图
 * @param timelineId
 * @param assetId
 * @param xtStyleParams 每4个为一组，包含每种风格模板，以及对应的参数，创建模式默认为0
 */
void Asset::RequestXTStyleThumbnail(int timelineId, std::string const &assetId, std::vector<int> xtStyleParams)
{
    USE_ASSET();
    BACKGROUND_TASK_MGR->Wait();
    BACKGROUND_TASK_MGR->Submit([editor, assetUid, xtStyleParams]() {
        LOGD("RequestXTStyleThumbnail begin");
        HmcAssetRequestXTStyleThumbnail(editor, assetUid, xtStyleParams);
        LOGD("RequestXTStyleThumbnail end");
    },
        __FUNCTION__);
}

void Asset::DoXtStyleTriFoldAnimation(int timelineId, std::string const &assetId, std::vector<double> doubleParams,
                                      VECTOR<bool> boolParams, std::function<void(std::string const &jsonPos)> cb)
{
    USE_ASSET();
    if (doubleParams.size() < G_DO_XTSTYLE_TRI_FOLD_ANIMATION_PARAM_LIMIT ||
        boolParams.size() < G_DO_XTSTYLE_TRI_FOLD_BOOL_PARAM_LIMIT) {
        LOGE("DoXtStyleTriFoldAnimation double param size not allow");
        return;
    }
    bool noAnimation = boolParams[0];
    bool isOpen = boolParams[g_indexOne];
    
    auto type = isOpen ? OPEN_XTSTYLE_PALETTE : CLOSE_XTSTYLE_PALETTE;
    // 前四个为 预览区的 左 上， 右 下
    LOGI("DoXtStyleTriFoldAnimation size:%lf, %lf, %lf, %lf. canvasWidth:%lf, canvasHeight:%lf", doubleParams[0],
         doubleParams[g_indexOne], doubleParams[g_indexTwo], doubleParams[g_indexThree], doubleParams[g_indexFour],
         doubleParams[g_indexFive]);
    auto oldCropOperationArea = timeline->GetCropOperationArea();
    // 更新裁剪可操作区域坐标
    HmcRectD rect(doubleParams[0], doubleParams[g_indexOne], doubleParams[g_indexTwo], doubleParams[g_indexThree]);
    timeline->SetCropOperationArea(rect);
    HmcSize newCanvasSize = {static_cast<float>(doubleParams[g_indexFour]),
                             static_cast<float>(doubleParams[g_indexFive])};
    if (noAnimation) {
        auto updateOperationArea = std::make_shared<HveUpdateOperationArea>(
            timeline, assetUid, newCanvasSize, oldCropOperationArea, hveAsset->GetDeviceVertical(), type);
        updateOperationArea->Execute();
        return;
    }
    
    auto cropRect = timeline->GetCropRect();
    
    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = cropRect.left;
    json["top"] = cropRect.top;
    json["right"] = cropRect.right;
    json["bottom"] = cropRect.bottom;
    cb(fastWriter.write(json));
}

void Asset::SetPreviewMode(int timelineId, std::string const &assetId, bool value)
{
    USE_ASSET();
    hveAsset->SetInPreviewMode(value);
}

void Asset::SetShowWatermarkValue(int timelineId, std::string const &assetId, bool value)
{
    USE_ASSET();
    hveAsset->SetShowWatermarkValue(value);
}

void Asset::RefreshCompareEffectList(int timelineId, std::string const &assetId)
{
    USE_ASSET();
    hveAsset->RefreshCompareEffectList();
}

bool Asset::HasXtStyleCode(HveAsset *hveAsset)
{
    auto xtStyleCode = hveAsset->GetXtStyleCode();
    LOGI("HasXtStyleCode = %s", xtStyleCode.c_str());
    return xtStyleCode != EMPTY_STR;
}

VECTOR<INT32> Asset::GetExifXtStyleParam(int timelineId, const std::string &assetId)
{
    USE_ASSET({});
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    return asset->GetExifXtStyleParam();
}

STRING Asset::GetCurrentXtStyleParams(int timelineId, std::string const &assetId)
{
    USE_ASSET("");
    XTStyleParams params = hveAsset->GetXTStyleParam();
    LOGI("GetCurrentXtStyleParams params = %s", params.toString().c_str());
    if (params.styleType == -1) {
        return "";
    }
    Json::Value root;
    Json::FastWriter firstWriter;
    root[PROJECT_KEY_XTSTYLE_TYPE] = params.styleType;
    root[PROJECT_KEY_XTSTYLE_COLOR_TEMPERATURE] =
        std::to_string(params.colorTemperature) + "/" + std::to_string(XTSTYLE_MAX_COLOR_TEMPERATURE_VALUE);
    root[PROJECT_KEY_XTSTYLE_SATURATION] =
        std::to_string(params.saturation) + "/" + std::to_string(XTSTYLE_MAX_SATURATION_VALUE);
    root[PROJECT_KEY_XTSTYLE_LIGHT_AND_SHADOW] =
        std::to_string(params.lightShadow) + "/" + std::to_string(XTSTYLE_MAX_LIGHT_SHADOW_VALUE);
    return firstWriter.write(root);
}

void Asset::SwitchTabWidthWatermarkAnim(int timelineId, std::string const &assetId, int waterMarkType,
                                        int cost = SWITCH_SEAL_ANIMATION_TIME)
{
    USE_ASSET();
    AnimationType animationType;
    if (waterMarkType == g_indexZero) {
        animationType = UPD_STICKER_NO_SIZE;
    } else if (waterMarkType == g_indexOne) {
        animationType = UPD_STICKER_WITH_SIZE;
    } else {
        LOGE("SwitchTabWidthWatermarkAnim failed, waterMarkType = %d", waterMarkType);
        return;
    }
    auto switchPreview2Preview =
        std::make_shared<HvePreview2Preview>(timeline, assetUid, animationType, cost);
    switchPreview2Preview->setIsShowWaterChangeAnimation(false);
    switchPreview2Preview->Execute();
}

void Asset::RefreshWatermarkCache(int timelineId, std::string const &assetId)
{
    USE_ASSET();
    hveAsset->InitWatermarkCache(timeline->GetCropRect());
}

/**
 * 获取裁剪后图片宽高
 * @param timelineId timelineId
 * @param assetId assetId
 * @param cb 回调方法
 */
void Asset::GetExportSize(int timelineId, const std::string &assetId, std::function<void(int width, int height)> cb)
{
    USE_ASSET();
    hveAsset->setExportSize(timeline->GetCropRect());
    cb(hveAsset->GetExportW(), hveAsset->GetExportH());
}

DOUBLE Asset::GetIntelligentCorrectionValue(int timelineId, std::string const &assetId)
{
    USE_ASSET(0.0);
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    if (editorImp != nullptr) {
       return editorImp->GetIntelligentCorrectionAngle(editor, assetUid);
    }
    return HMC_ERR_INTELLIGENT_CORRECTION;
}

DOUBLE Asset::ImageEffectRestore(Json::Value restoreInfoData) {
    OH_ImageEffect *imageEffect = OH_ImageEffect_Restore(Json::FastWriter().write(restoreInfoData).c_str());
    if (imageEffect == nullptr) {
        LOGE("Restore mImageEffect failed");
        return HMC_ERR;
    }
    OH_ImageEffect_Release(imageEffect);
    return HMC_OK;
}

DOUBLE Asset::Restore(Json::Value restoreInfoData) {
    // extra_info结构不完整还需要调用编创的restore接口
    Json::Value extraInfo = restoreInfoData["extra_info"];
    if (extraInfo.empty() || !extraInfo.isMember("lane_module")) {
        LOGE("restore lane_module is null");
        return ImageEffectRestore(restoreInfoData);
    }
    Json::Value laneModule = extraInfo["lane_module"];
    if (laneModule.empty() || !laneModule.isMember("lane") || laneModule["lane"] == 0) {
        LOGE("restore lane is null");
        return ImageEffectRestore(restoreInfoData);
    }
    Json::Value lane = laneModule["lane"][0];
    if (lane.empty() || !lane.isMember("asset") || lane["asset"] == 0) {
        LOGE("restore asset is null");
        return ImageEffectRestore(restoreInfoData);
    }
    Json::Value asset = lane["asset"][0];
    if (asset.empty() || !asset.isMember("effect")) {
        LOGE("restore effect is null");
        return ImageEffectRestore(restoreInfoData);
    }
    Json::Value effect = asset["effect"];
    for (int i = 0; i < effect.size(); i++) {
        Json::Value effectJson = effect[i];
        if (effectJson["name"] == "wideAperture") {
            Json::Value wideAperture;
            wideAperture["name"] = "Wide_Aperture";
            restoreInfoData["imageEffect"]["filters"].append(wideAperture);
        }
    }
    return ImageEffectRestore(restoreInfoData);
}

DOUBLE Asset::IsSupportsDifferentiatedAlgorithms(std::string const &editData) {
    LOGI("algorithms Restore start");
    Json::Reader reader;
    Json::Value restoreInfoData;
    if (!reader.parse(editData, restoreInfoData)) {
        LOGE("algorithms image effect failed because of parsing data to json object.");
        return HMC_ERR;
    }
     if (restoreInfoData.empty() || !restoreInfoData.isMember("imageEffect")) {
        LOGE("algorithms imageEffect is null");
        return HMC_ERR;
    }
     Json::Value imageEffect = restoreInfoData["imageEffect"];
     if (imageEffect.empty() || !imageEffect.isMember("filters")) {
        LOGE("algorithms filters is null");
        return HMC_ERR;
    }
    if (restoreInfoData.empty() || !restoreInfoData.isMember("extra_info")) {
        LOGE("algorithms extra_info is null");
        return ImageEffectRestore(restoreInfoData);
    }
    return Restore(restoreInfoData);
}

STRING Asset::GetXtStyleName(int timelineId, std::string const &assetId)
{
    USE_ASSET(EMPTY_STR);
    return hveAsset->GetXtStyleText();
}

bool Asset::IsAllowEditXtStyle(int timelineId, const std::string &assetId) {
    HmcUid assetUid = HmcUidHelper(assetId);
    auto asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("IsAllowEditXtStyle not found asset");
        return false;
    }
    return (asset->GetExifXtStyleParam()[0] > 0 ||
            (asset->GetExifXtStyleParam()[0] == 0 && asset->GetExifXmageColorMode() == 0));
}

void Asset::DoPreviewAvoidanceAnimation(int timelineId, std::string const &assetId, std::vector<double> doubleParams,
                                        std::function<void(std::string const &jsonPos)> cb) {
    USE_ASSET();
    hveAsset->SetIsSwitchPage(true);
    LOGD("DoPreviewAvoidanceAnimation size:%lf, %lf, %lf, %lf. canvasWidth:%lf, canvasHeight:%lf",
    doubleParams[0], doubleParams[1], doubleParams[2], doubleParams[3], doubleParams[4], doubleParams[5]);
    auto oldCropOperationArea = timeline->GetCropOperationArea();

    // 更新裁剪可操作区域坐标
    HmcRectD rect(doubleParams[0], doubleParams[1], doubleParams[2], doubleParams[3]);
    timeline->SetCropOperationArea(rect);
    HmcSize newCanvasSize = { static_cast<float>(doubleParams[4]), static_cast<float>(doubleParams[5]) };
    auto params = std::make_tuple(
        timeline, assetUid, newCanvasSize, oldCropOperationArea, hveAsset->GetDeviceVertical(), MODEL_BOX_EDGE_OPEN); 
    auto xtStyleAnimation = std::make_shared<HveUpdOperPreviewAvoidance>(params);
    xtStyleAnimation->UpdateAnimationTime(DEFAULT_ANIMATION_TIME);
    xtStyleAnimation->Execute();
    auto cropRect = timeline->GetCropRect();
    
    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = cropRect.left;
    json["top"] = cropRect.top;
    json["right"] = cropRect.right;
    json["bottom"] = cropRect.bottom;
    cb(fastWriter.write(json));
}

/**
 * 设置projectConfig属性值
 * @param key 需要设置的字段
 * @param value 设置的值
 * @return
 */
bool Asset::SetProjectConfigValue(const STRING &key, const STRING &value)
{
    return ProjectConfig::Instance().SetValueByKey(key, value);
}

void Asset::GeneratorRfDataB(int timelineId, std::string const & assetId, std::function<void(bool res)> cb)
{
    USE_ASSET();
    static_cast<HmcEditorImp *>(editor)->GeneratorRfDataB(assetUid, cb);
}
