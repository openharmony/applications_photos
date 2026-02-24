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

#include "HveCropCommand.h"
#include "MediaCreative/HmcEditorAsset.h"
#include "MediaCreative/HmcError.h"
#include "ohos/BackgroundTaskManager.h"
#include "../util/HveTransformUtil.h"

static int g_two = 2;
static double g_halfProgress = 0.5;
static int g_animationTime = 400;
static int g_MillForOneSecond = 1000;

/*
 * Description: 裁剪撤销恢复基类
 * Create: 2023/11/20
 */
HveCmdCropBase::HveCmdCropBase(int timelineId, std::string const & assetId, std::string const & type)
    : HveCommand(timelineId, type, assetId)
{}

HveCmdCropBase::~HveCmdCropBase() {}

std::string HveCmdCropBase::Undo()
{
    LOGI("UndoRedo HveCmdCropBase Undo.");
    USE_ASSET(NAPI_JSON_ERROR_RETURN);

    bool previewMode = hveAsset->GetInPreviewMode();
    float undoAssetPosX = m_lastAssetPos.x;
    float undoAssetPosY = m_lastAssetPos.y;
    float undoAssetWidth = m_lastAssetSize.width;
    float undoAssetHeight = m_lastAssetSize.height;
    HmcRectD undoLastCropRect = m_lastCropRect;

    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, m_cmdCanvasSize.width, m_cmdCanvasSize.height);
    if (!isDefaultCanvas) {
        auto undoCropRect = timeline->GetCropRect();
        auto cropScale = HveCmdSetRotation::CalCropRectRadio(undoCropRect, m_lastCropRect);
        undoAssetWidth = m_lastAssetSize.width * cropScale;
        undoAssetHeight = m_lastAssetSize.height * cropScale;
        undoLastCropRect = CalCropRectByUpdateCanvas(undoCropRect, m_lastCropRect, cropScale);
        int result = CalAssetPosByUpdateCanvas(editor, assetUid, undoLastCropRect, m_lastCropRect, m_lastAssetPos,
            cropScale, &undoAssetPosX, &undoAssetPosY);
        if (result != HMC_OK) {
            return NAPI_JSON_ERROR_RETURN;
        }
    }

    HmcEditorSetAutoFlush(editor, false);
    HmcAssetSetPositionByCenter(editor, assetUid, undoAssetPosX, undoAssetPosY);
    HmcSize hmcSize = { undoAssetWidth, undoAssetHeight };
    HmcAssetSetSize(editor, assetUid, hmcSize);
    auto cropOperationArea = timeline->GetCropOperationArea();
    HmcRectD newCropRect =
        HveAssetOper::SetCropRectInner(timeline, assetUid, undoLastCropRect, cropOperationArea, 0, 1, false, false);
    hveAsset->SwitchCropMode();
    if (previewMode) {
        timeline->SwitchPreviewMode();
    }
    hveAsset->RefreshWatermarkCropRect(timeline->GetCropRect());
    HmcEditorSetAutoFlush(editor, true);

    HveCmdSetRotation::UpdateCropRectLimitation(timeline, m_lastCropRect, m_lastCropLimitation, isDefaultCanvas);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, m_lastCropRect, m_lastBaseRotationAssetSize.width,
        m_lastBaseRotationAssetSize.height, isDefaultCanvas);
    hveAsset->SetRefreshThumbnails(TRUE);

    Json::Value json;
    json["id"] = type;
    json["left"] = newCropRect.left;
    json["top"] = newCropRect.top;
    json["right"] = newCropRect.right;
    json["bottom"] = newCropRect.bottom;

    LOGI("UndoRedo HveCmdCropBase Undo json:%s", m_fastWriter.write(json).c_str());
    return m_fastWriter.write(json);
}

std::string HveCmdCropBase::Redo()
{
    LOGI("UndoRedo HveCmdCropAsset Redo.");
    USE_ASSET(NAPI_JSON_ERROR_RETURN);

    bool previewMode = hveAsset->GetInPreviewMode();
    float redoAssetPosX = m_curAssetPos.x;
    float redoAssetPosY = m_curAssetPos.y;
    float redoAssetWidth = m_curAssetSize.width;
    float redoAssetHeight = m_curAssetSize.height;
    HmcRectD redoLastCropRect = m_curCropRect;

    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, m_cmdCanvasSize.width, m_cmdCanvasSize.height);
    if (!isDefaultCanvas) {
        auto redoCropRect = timeline->GetCropRect();
        float cropScale = HveCmdSetRotation::CalCropRectRadio(redoCropRect, m_curCropRect);
        redoAssetWidth = m_curAssetSize.width * cropScale;
        redoAssetHeight = m_curAssetSize.height * cropScale;
        redoLastCropRect = CalCropRectByUpdateCanvas(redoCropRect, m_curCropRect, cropScale);
        int result = CalAssetPosByUpdateCanvas(editor, assetUid, redoLastCropRect, m_curCropRect, m_curAssetPos,
            cropScale, &redoAssetPosX, &redoAssetPosY);
        if (result != HMC_OK) {
            return NAPI_JSON_ERROR_RETURN;
        }
    }

    HmcEditorSetAutoFlush(editor, false);
    HmcAssetSetPositionByCenter(editor, assetUid, redoAssetPosX, redoAssetPosY);
    HmcSize size = { redoAssetWidth, redoAssetHeight };
    HmcAssetSetSize(editor, assetUid, size);
    auto cropOperationArea = timeline->GetCropOperationArea();
    HmcRectD newCropRect =
        HveAssetOper::SetCropRectInner(timeline, assetUid, redoLastCropRect, cropOperationArea, 0, 1, false, false);
    hveAsset->SwitchCropMode();
    if (previewMode) {
        timeline->SwitchPreviewMode();
    }
    hveAsset->RefreshWatermarkCropRect(timeline->GetCropRect());
    HmcEditorSetAutoFlush(editor, true);

    HveCmdSetRotation::UpdateCropRectLimitation(timeline, m_curCropRect, m_curCropLimitation, isDefaultCanvas);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, m_curCropRect, m_curBaseRotationAssetSize.width,
        m_curBaseRotationAssetSize.height, isDefaultCanvas);
    hveAsset->SetRefreshThumbnails(TRUE);

    Json::Value json;
    json["id"] = type;
    json["left"] = newCropRect.left;
    json["top"] = newCropRect.top;
    json["right"] = newCropRect.right;
    json["bottom"] = newCropRect.bottom;

    LOGI("UndoRedo HveCmdCropBase Redo json:%s", m_fastWriter.write(json).c_str());
    return m_fastWriter.write(json);
}

int HveCmdCropBase::Merge()
{
    LOGI("UndoRedo HveCmdCropBase Merge.");
    USE_ASSET(HMC_ERR);
    m_curCropRect = timeline->GetCropRect();
    m_curAssetPos.x = hveAsset->GetAssetPosX();
    m_curAssetPos.y = hveAsset->GetAssetPosY();
    m_curAssetSize.width = hveAsset->GetAssetWidth();
    m_curAssetSize.height = hveAsset->GetAssetHeight();
    m_curCropLimitation = timeline->GetCropLimitation();
    m_curBaseRotationAssetSize.width = hveAsset->GetBaseRotationAssetWidth();
    m_curBaseRotationAssetSize.height = hveAsset->GetBaseRotationAssetHeight();

    if (abs(m_curCropRect.Width() - m_lastCropRect.Width()) > UNDO_REDO_EPS ||
        abs(m_curCropRect.Height() - m_lastCropRect.Height()) > UNDO_REDO_EPS ||
        abs(m_curAssetPos.x - m_lastAssetPos.x) > UNDO_REDO_EPS ||
        abs(m_curAssetPos.y - m_lastAssetPos.y) > UNDO_REDO_EPS ||
        abs(m_curAssetSize.width - m_lastAssetSize.width) > UNDO_REDO_EPS ||
        abs(m_curAssetSize.height - m_lastAssetSize.height) > UNDO_REDO_EPS) {
        return HMC_OK;
    }
    LOGI("The Crop has not changed!");
    return HMC_ERR;
}

int HveCmdCropBase::UpdateCropLastAssetData()
{
    USE_ASSET(HMC_ERR);
    m_lastCropRect = timeline->GetCropRect();
    m_lastCropLimitation = timeline->GetCropLimitation();

    float startX;
    float startY;
    HmcAssetGetPositionByCenter(editor, assetUid, &startX, &startY);
    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);

    m_lastAssetPos.x = startX;
    m_lastAssetPos.y = startY;
    m_lastAssetSize.width = size.width;
    m_lastAssetSize.height = size.height;
    m_lastBaseRotationAssetSize.width = hveAsset->GetBaseRotationAssetWidth();
    m_lastBaseRotationAssetSize.height = hveAsset->GetBaseRotationAssetHeight();
    HmcEditorGetCanvasSize(editor, &m_cmdCanvasSize.width, &m_cmdCanvasSize.height);
    return HMC_OK;
}

int HveCmdCropBase::UpdateCropCurAssetData()
{
    USE_ASSET(HMC_ERR);
    m_curCropRect = timeline->GetCropRect();
    m_curCropLimitation = timeline->GetCropLimitation();

    m_curAssetPos.x = hveAsset->GetAssetPosX();
    m_curAssetPos.y = hveAsset->GetAssetPosY();
    m_curAssetSize.width = hveAsset->GetAssetWidth();
    m_curAssetSize.height = hveAsset->GetAssetHeight();
    m_curBaseRotationAssetSize.width = hveAsset->GetBaseRotationAssetWidth();
    m_curBaseRotationAssetSize.height = hveAsset->GetBaseRotationAssetHeight();
    return HMC_OK;
}

int HveCmdCropBase::CalAssetPosByUpdateCanvas(HmcEditor *editor, const HmcUid &assetUid, const HmcRectD &newCropRect,
    const HmcRectD &oldCropRect, HmcAssetPoint inputPosition, double cropScale, float *assetPosX, float *assetPosY)
{
    HmcSize canvasSize;
    int result = HmcEditorGetCanvasSize(editor, &canvasSize.width, &canvasSize.height);
    if (result != HMC_OK) {
        LOGE("HveCmdCropBase get canvas failed.");
        return result;
    }
    int isHorizontalMirror = 0;
    result = HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    if (result != HMC_OK) {
        LOGE("HveCmdCropBase get mirror flag failed.");
        return result;
    }

    UpdateCanvasRect updCanvasCropRect = { m_cmdCanvasSize, canvasSize, oldCropRect, newCropRect };
    HmcAssetPoint assetPosition =
        HveAssetOper::CalAssetPositionByCanvas(updCanvasCropRect, inputPosition, cropScale, isHorizontalMirror);
    *assetPosX = assetPosition.x;
    *assetPosY = assetPosition.y;
    return HMC_OK;
}

HmcRectD HveCmdCropBase::CalCropRectByUpdateCanvas(const HmcRectD &newCropRect, const HmcRectD &oldCropRect,
    double cropScale)
{
    double lastCropRectWidth = oldCropRect.Width() * cropScale;
    double lastCropRectHeight = oldCropRect.Height() * cropScale;
    HmcRectD updateCropRect(newCropRect.CenterX() - lastCropRectWidth / 2,
        newCropRect.CenterY() - lastCropRectHeight / 2, newCropRect.CenterX() + lastCropRectWidth / 2,
        newCropRect.CenterY() + lastCropRectHeight / 2);
    return updateCropRect;
}

/*
 * Description: 旋转、水平矫正、垂直矫正支持撤销恢复
 * Create: 2023/7/20
 */
HveCmdSetRotation::HveCmdSetRotation(int timelineId, std::string const & assetId, double rotation, int axis,
    std::string const & type)
    : HveCommand(timelineId, type, assetId), curRotation(rotation), curAxis(axis)
{}

HveCmdSetRotation::~HveCmdSetRotation() {}

int HveCmdSetRotation::Execute()
{
    LOGI("UndoRedo HveCmdSetRotation Execute rotation = %lf, axis = %d", curRotation, curAxis);
    int ret = UpdateRotationLastAssetData();
    if (ret != HMC_OK) {
        return ret;
    }

    ret = ComSetRotation(timelineId, assetId, curRotation, curAxis, false);
    if (ret != HMC_OK) {
        return ret;
    }

    ret = UpdateRotationCurAssetData();
    return ret;
}

std::string HveCmdSetRotation::Undo()
{
    LOGI("UndoRedo HveCmdSetRotation Undo rotation = %lf, axis = %d", lastRotation, curAxis);
    USE_ASSET(NAPI_JSON_ERROR_RETURN);

    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, cmdCanvasWidth, cmdCanvasHeight);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, cmdCropRect, lastBaseRotationAssetWidth,
        lastBaseRotationAssetHeight, isDefaultCanvas);

    // 非裁剪页面撤销恢复完成后，需要恢复当前预览模式
    bool previewMode = hveAsset->GetInPreviewMode();
    int ret = ComSetRotation(timelineId, assetId, lastRotation, curAxis, previewMode);
    hveAsset->Notify();
    if (ret != HMC_OK) {
        return NAPI_JSON_ERROR_RETURN;
    }

    HveCmdSetRotation::UpdateCropRectLimitation(timeline, cmdCropRect, lastCropLimitation, isDefaultCanvas);
    Json::Value json;
    json["id"] = type;
    json[type] = lastRotation;
    return m_fastWriter.write(json);
}

std::string HveCmdSetRotation::Redo()
{
    LOGI("UndoRedo HveCmdSetRotation Redo rotation = %lf, axis = %d", curRotation, curAxis);
    USE_ASSET(NAPI_JSON_ERROR_RETURN);

    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, cmdCanvasWidth, cmdCanvasHeight);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, cmdCropRect, curBaseRotationAssetWidth,
        curBaseRotationAssetHeight, isDefaultCanvas);

    bool previewMode = hveAsset->GetInPreviewMode();
    int ret = ComSetRotation(timelineId, assetId, curRotation, curAxis, previewMode);
    hveAsset->Notify();
    if (ret != HMC_OK) {
        return NAPI_JSON_ERROR_RETURN;
    }

    HveCmdSetRotation::UpdateCropRectLimitation(timeline, cmdCropRect, curCropLimitation, isDefaultCanvas);

    Json::Value json;
    json["id"] = type;
    json[type] = curRotation;
    return m_fastWriter.write(json);
}

int HveCmdSetRotation::Merge()
{
    USE_ASSET(HMC_ERR);
    double rotation = hveAsset->GetRotation((HmcRotationAxis)curAxis);
    if (abs(rotation - lastRotation) <= UNDO_REDO_EPS) {
        LOGI("The Rotation has not changed!");
        return HMC_ERR;
    }
    curRotation = rotation;
    if (curAxis == 2) {
        curRotation = curRotation - hveAsset->GetBaseRotation();
    }
    curBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    curBaseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    curCropLimitation = timeline->GetCropLimitation();
    return HMC_OK;
}

int HveCmdSetRotation::ComSetRotation(int timelineId, std::string const & assetId, double rotation, int axis,
    bool previewMode)
{
    LOGI("UndoRedo HveCmdSetRotation ComSetRotation rotation = %lf, axis = %d", rotation, axis);
    USE_ASSET(HMC_ERR);

    HmcEditorSetAutoFlush(editor, false);

    auto cropRect = timeline->GetCropRect(); // 裁剪框在Surface上的位置, 左上原点，右下为正

    auto newRotation = rotation;
    if (axis == 2) {
        CalculateCoordinates(cropRect, newRotation, previewMode, axis);
    } else if (axis == 0 || axis == 1) {
        HmcAssetSetRotation(timeline->GetEditor(), assetUid, rotation, (HmcRotationAxis)axis);
        FillCropRectAndSwitchMode(0, cropRect, previewMode, HveAssetOper::RotateRule);
    } else {
        FillCropRectAndSwitchMode(0, cropRect, previewMode, HveAssetOper::DefaultRule);
    }
    HmcEditorSetAutoFlush(editor, true);
    hveAsset->SetRotation(newRotation, (HmcRotationAxis)axis, false);
    hveAsset->SetRefreshThumbnails(TRUE);
    return HMC_OK;
}

void HveCmdSetRotation::CalculateCoordinates(auto &cropRect, auto &newRotation, bool &previewMode, int &axis)
{
    USE_ASSET();
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight); // canvas为整个surface的大小，左上原点，右下为正

    float posX;
    float posY;
    HmcAssetGetPositionByCenter(editor, assetUid, &posX, &posY); // 获取素材在整个画布上的位置，中心原点，右上为正

    int isHorizontalMirror = 0;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    float baseOffsetX = (static_cast<float>(cropRect.CenterX()) - canvasWidth / 2) * 2;
    if (isHorizontalMirror) {
        posX = posX + baseOffsetX;
    }
    posX = canvasWidth / g_two + posX;
    posY = canvasHeight / g_two - posY;

    // 对于Z轴旋转，中心点需要始终保持为裁剪框中心点
    float oldRotation;
    HmcAssetGetRotation(timeline->GetEditor(), assetUid, &oldRotation, (HmcRotationAxis)axis);
    newRotation += hveAsset->GetBaseRotation();
    HmcAssetSetRotation(timeline->GetEditor(), assetUid, newRotation, (HmcRotationAxis)axis);
    float degree = newRotation - oldRotation; // 正值：逆时针，负值：顺时针
    float rad = degree * MathUtils::PI / 180; // 弧度

    // 裁剪框中心a点以素材中心o点为中心逆时针旋转rad弧度后得到b点
    float ox = posX;
    float oy = -posY;
    float ax = cropRect.CenterX();
    float ay = -cropRect.CenterY();
    float bx = (ax - ox) * cos(rad) - (ay - oy) * sin(rad) + ox;
    float by = (ax - ox) * sin(rad) + (ay - oy) * cos(rad) + oy;
    LOGD("o=%lf,%lf a=%lf,%lf b=%lf,%lf degree=%lf", ox, oy, ax, ay, bx, by, degree);

    // 素材进行移动补偿，使b点移动到a点位置
    posX += (ax - bx);
    posY -= (ay - by);
    float newPosX = posX - canvasWidth / 2;
    float newPosY = canvasHeight / 2 - posY;
    if (isHorizontalMirror) {
        newPosX = newPosX - baseOffsetX;
    }
    HmcAssetSetPositionByCenter(timeline->GetEditor(), assetUid, newPosX, newPosY);
    FillCropRectAndSwitchMode(0, cropRect, previewMode, HveAssetOper::RotateRule);
    hveAsset->SetResetVertex(true);
}

int HveCmdSetRotation::UpdateRotationLastAssetData()
{
    USE_ASSET(HMC_ERR);
    float oldRotation = 0.0f;
    HmcAssetGetRotation(timeline->GetEditor(), assetUid, &oldRotation, (HmcRotationAxis)curAxis);
    lastRotation = oldRotation;
    if (curAxis == 2) {
        lastRotation = lastRotation - hveAsset->GetBaseRotation();
    }

    cmdCropRect = timeline->GetCropRect();
    lastCropLimitation = timeline->GetCropLimitation();
    lastBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    lastBaseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    HmcEditorGetCanvasSize(editor, &cmdCanvasWidth, &cmdCanvasHeight);
    return HMC_OK;
}

int HveCmdSetRotation::UpdateRotationCurAssetData()
{
    USE_ASSET(HMC_ERR);
    curCropLimitation = timeline->GetCropLimitation();
    curBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    curBaseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    return HMC_OK;
}

void HveCmdSetRotation::FillCropRectAndSwitchMode(double animMs, const HmcRectD &cropRect, bool previewMode,
    std::function<bool(float *, float *, float *)> rule)
{
    USE_ASSET();
    HveAssetOper::FillCropRectForRotation(timeline, assetUid, animMs, cropRect, rule);
    if (previewMode) {
        timeline->SwitchPreviewMode();
    } else {
        hveAsset->SwitchCropMode();
    }
}

void HveCmdSetRotation::UpdateCropRectLimitation(HveTimeline *timeline, const HmcRectD &undoRedoCropRect,
    const HmcRectD &undoRedoCropLimitation, bool isDefaultCanvas)
{
    if (isDefaultCanvas) {
        timeline->SetCropLimitation(undoRedoCropLimitation);
    } else {
        auto newCropRect = timeline->GetCropRect();
        float cropScale = HveCmdSetRotation::CalCropRectRadio(newCropRect, undoRedoCropRect);
        HveAssetOper::UpdateCropLimitation(timeline, undoRedoCropRect, newCropRect, undoRedoCropLimitation, cropScale);
    }
}

void HveCmdSetRotation::UpdateBaseRotationAsset(HveTimeline *timeline, HmcUid assetUid,
    const HmcRectD &undoRedoCropRect, float assetWidth, float assetHeight, bool isDefaultCanvas)
{
    HveAsset *hveAsset = timeline->GetHveAsset(assetUid);
    if (isDefaultCanvas) {
        hveAsset->SetBaseRotationAssetSize(assetWidth, assetHeight);
    } else {
        float cropScale = HveCmdSetRotation::CalCropRectRadio(timeline->GetCropRect(), undoRedoCropRect);
        hveAsset->SetBaseRotationAssetSize(assetWidth * cropScale, assetHeight * cropScale);
    }
}

bool HveCmdSetRotation::IsDefaultCanvas(HveTimeline *timeline, float oldCanvasWidth, float oldCanvasHeight)
{
    float curCanvasWidth, curCanvasHeight;
    HmcEditorGetCanvasSize(timeline->GetEditor(), &curCanvasWidth, &curCanvasHeight);
    bool isDefaultCanvas = fabsf(oldCanvasWidth - curCanvasWidth) < UNDO_REDO_EPS &&
        fabsf(oldCanvasHeight - curCanvasHeight) < UNDO_REDO_EPS;
    return isDefaultCanvas;
}

float HveCmdSetRotation::CalCropRectRadio(const HmcRectD &newCropRect, const HmcRectD &undoRedoCropRect)
{
    float cropWidthScale = newCropRect.Width() / undoRedoCropRect.Width();
    float cropHeightScale = newCropRect.Height() / undoRedoCropRect.Height();
    return HMC_MIN(cropWidthScale, cropHeightScale);
}

/*
 * Description: 90°旋转支持撤销恢复
 * Create: 2023/7/20
 */
HveCmdRotate90Acw::HveCmdRotate90Acw(int timelineId, std::string const & assetId,
    std::function<void(std::string const & jsonPos)> cb, int frame, std::string const & type)
    : HveCommand(timelineId, type, assetId), cb(cb), frame(frame)
{}
bool HveCmdRotate90Acw::m_isRotateReseting = false; // 旋转结束回调处理中静态变量初始化
int HveCmdRotate90Acw::m_lastRotateFrame = 0; // 旋转结束回调处理中静态变量初始化
UINT64 HveCmdRotate90Acw::m_lastRotateResetingTime = 0; // 旋转结束回调处理中静态变量初始化
HveCmdRotate90Acw::~HveCmdRotate90Acw() {}

int HveCmdRotate90Acw::Execute()
{
    LOGI("UndoRedo HveCmdRotate90Acw Execute.");
    int ret = UpdateRotate90AcwLastAssetData();
    if (ret != HMC_OK) {
        return ret;
    }

    ret = ComRotate90Acw(timelineId, assetId, cb, COMMAND_EXECUTE);
    if (ret != HMC_OK) {
        return ret;
    }

    ret = UpdateRotate90AcwCurAssetData();
    return ret;
}

std::string HveCmdRotate90Acw::Undo()
{
    LOGI("UndoRedo HveCmdRotate90Acw Undo.");
    USE_ASSET(NAPI_JSON_ERROR_RETURN);

    int ret = ComRotate90Acw(timelineId, assetId, cb, COMMAND_UNDO);
    if (ret != HMC_OK) {
        return NAPI_JSON_ERROR_RETURN;
    }

    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, cmdCanvasWidth, cmdCanvasHeight);
    HveCmdSetRotation::UpdateCropRectLimitation(timeline, lastCropRect, lastCropLimitation, isDefaultCanvas);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, lastCropRect, lastBaseRotationAssetWidth,
        lastBaseRotationAssetHeight, isDefaultCanvas);
    auto cropRect = timeline->GetCropRect();
    Json::Value json;
    json["id"] = type;
    json["left"] = cropRect.left;
    json["top"] = cropRect.top;
    json["right"] = cropRect.right;
    json["bottom"] = cropRect.bottom;

    LOGI("UndoRedo HveCmdRotate90Acw Undo json:%s", m_fastWriter.write(json).c_str());
    return m_fastWriter.write(json);
}

std::string HveCmdRotate90Acw::Redo()
{
    LOGI("UndoRedo HveCmdRotate90Acw Redo.");
    USE_ASSET(NAPI_JSON_ERROR_RETURN);

    int ret = ComRotate90Acw(timelineId, assetId, cb, COMMAND_REDO);
    if (ret != HMC_OK) {
        return NAPI_JSON_ERROR_RETURN;
    }

    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, cmdCanvasWidth, cmdCanvasHeight);
    HveCmdSetRotation::UpdateCropRectLimitation(timeline, curCropRect, curCropLimitation, isDefaultCanvas);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, curCropRect, curBaseRotationAssetWidth,
        curBaseRotationAssetHeight, isDefaultCanvas);
    auto cropRect = timeline->GetCropRect();
    Json::Value json;
    json["id"] = type;
    json["left"] = cropRect.left;
    json["top"] = cropRect.top;
    json["right"] = cropRect.right;
    json["bottom"] = cropRect.bottom;

    LOGI("UndoRedo HveCmdRotate90Acw Redo json:%s", m_fastWriter.write(json).c_str());
    return m_fastWriter.write(json);
}

int HveCmdRotate90Acw::ComRotate90Acw(int timelineId, std::string const & assetId,
    std::function<void(std::string const & jsonPos)> cb, UndoRedoCommandType commandType)
{
    USE_ASSET(HMC_ERR);
    auto oldRectD = timeline->GetCropRect();
    auto cropOperationArea = timeline->GetCropOperationArea();

    int clickTimes = hveAsset->GetClick90AckTimes() + 1;
    hveAsset->SetClick90AckTimes(clickTimes);
    bool isDefaultRectRatio = (clickTimes % 2) == 0 ? true : false;

    float ratio = oldRectD.Width() / oldRectD.Height();
    HmcRectD cropRect(0, 0, 0, 0);
    if (isDefaultRectRatio) {
        cropRect = oldRectD;
    } else {
        HveAssetOper::GetCenterInsideRectUnderRatio(1 / ratio, cropOperationArea, &cropRect);
    }
    timeline->SetCropRectSize(cropRect);
    timeline->SetCropLimitation(cropRect);

    auto baseRotation = hveAsset->GetBaseRotation();
    auto oldRotation = hveAsset->GetRotation(HMC_AXIS_Z);
    auto extraRotation = oldRotation - baseRotation;
    float undoRotation = (commandType != COMMAND_UNDO) ? 0.0F : 180.0F;

    int isHorizontalMirror = 0;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    if (isHorizontalMirror) {
        baseRotation = ((int)(baseRotation - undoRotation - 90)) % 360;
    } else {
        baseRotation = ((int)(baseRotation + undoRotation + 90)) % 360;
    }
    hveAsset->SetBaseRotation(baseRotation);
    auto newRotation = extraRotation + baseRotation; // 每调用一次接口，逆时针90度（逆时针：正值）
    hveAsset->SetRotation(newRotation, HMC_AXIS_Z, true);
    
    /* 旋转逻辑：step1;先基于原裁剪框旋转计算出旋转后中心点；step2:基于旋转后的裁剪框算出缩放比
           step3:计算因缩放导致的中心点偏移 */
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(timeline->GetEditor(), &canvasWidth, &canvasHeight);
    CalculateRotation(cropRect, isHorizontalMirror, commandType, canvasWidth, canvasHeight, cb);
    hveAsset->SetRefreshThumbnails(TRUE);
    return HMC_OK;
}

int HveCmdRotate90Acw::UndoRedoRotate90Acw(float scale, float newRotation, HmcSize size, HmcAssetPoint assetPosition,
    const HmcRectD &cropRect)
{
    USE_ASSET(HMC_ERR);
    bool previewMode = hveAsset->GetInPreviewMode();

    HmcEditorSetAutoFlush(editor, false);
    HmcAssetSetRotation(editor, assetUid, newRotation, HMC_AXIS_Z);
    HmcAssetSetSize(editor, assetUid, size);
    HmcAssetSetPositionByCenter(editor, assetUid, assetPosition.x, assetPosition.y);
    timeline->SetCropRect(cropRect);
    hveAsset->SetInPreviewMode(true);
    hveAsset->SetAssetSize(size.width, size.height);
    hveAsset->SwitchCropMode();
    if (hveAsset->CanDrawWatermark() && previewMode) {
        hveAsset->RefreshWatermarkCropRect(cropRect);
    }
    if (previewMode) {
        timeline->SwitchPreviewMode();
    }
    HmcEditorSetAutoFlush(editor, true);

    hveAsset->ResetRotate90AcwTempValue();
    hveAsset->SetRefreshThumbnails(TRUE);
    return HMC_OK;
}

int HveCmdRotate90Acw::UpdateRotate90AcwLastAssetData()
{
    USE_ASSET(HMC_ERR);
    lastCropRect = timeline->GetCropRect();
    lastCropLimitation = timeline->GetCropLimitation();
    lastBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    lastBaseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    HmcEditorGetCanvasSize(editor, &cmdCanvasWidth, &cmdCanvasHeight);
    return HMC_OK;
}

int HveCmdRotate90Acw::UpdateRotate90AcwCurAssetData()
{
    USE_ASSET(HMC_ERR);
    curCropRect = timeline->GetCropLimitation();
    curCropLimitation = timeline->GetCropLimitation();
    curBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    curBaseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    return HMC_OK;
}

/*
 * Description: 镜像支持撤销恢复
 * Create: 2023/7/20
 */
HveCmdSetMirror::HveCmdSetMirror(int timelineId, std::string const & assetId, int mirrorFlag, int mirrorType,
    std::function<void(std::string const & jsonPos)> cb, std::string const & type)
    : HveCommand(timelineId, type, assetId), curMirrorFlag(mirrorFlag), curMirrorType(mirrorType), cb(cb)
{}

HveCmdSetMirror::~HveCmdSetMirror() {}

int HveCmdSetMirror::Execute()
{
    LOGI("UndoRedo HveCmdSetMirror Execute.");
    int ret = UpdateMirrorLastAssetData();
    if (ret != HMC_OK) {
        return ret;
    }
    LOGD("original param mirrorFlag=%d, mirrorType=%d", curMirrorFlag, curMirrorType);
    // 镜像校正，修复EXIF信息预览默认为镜像时，初次点击镜像无效果的问题
    curMirrorFlag = CalculateMirrorFlag(timelineId, assetId, curMirrorType, curMirrorFlag);
    ret = ComSetMirror(timelineId, assetId, curMirrorFlag, curMirrorType, cb, COMMAND_EXECUTE);
    if (ret != HMC_OK) {
        return ret;
    }

    ret = UpdateMirrorCurAssetData();
    return ret;
}

std::string HveCmdSetMirror::Undo()
{
    LOGI("UndoRedo HveCmdSetMirror Undo.");
    USE_ASSET(NAPI_JSON_ERROR_RETURN);

    bool previewMode = hveAsset->GetInPreviewMode();
    int undoMirrorFlag = curMirrorFlag ? 0 : 1;
    HmcEditorSetAutoFlush(editor, false);
    HveAssetOper::StartMirrorAnimation(editor, timeline, assetUid);

    auto cropRect = timeline->GetCropRect();
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    float baseOffsetX = (static_cast<float>(cropRect.CenterX()) - canvasWidth / 2) * 2;
    float posX;
    float posY;
    HmcAssetGetPositionByCenter(editor, assetUid, &posX, &posY);
    float fixPosX = undoMirrorFlag ? (posX - baseOffsetX) : (posX + baseOffsetX);
    HmcAssetSetPositionByCenter(timeline->GetEditor(), assetUid, fixPosX, posY);

    HmcAssetSetMirror(editor, assetUid, undoMirrorFlag, (HmcAssetMirrorType)curMirrorType);
    hveAsset->SwitchCropMode();
    if (previewMode) {
        timeline->SwitchPreviewMode();
    }
    HmcEditorSetAutoFlush(editor, true);
    hveAsset->SetAssetPosXY(fixPosX, posY);
    hveAsset->SetMirror(undoMirrorFlag);
    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, cmdCanvasWidth, cmdCanvasHeight);
    HveCmdSetRotation::UpdateCropRectLimitation(timeline, mirrorCropRect, lastCropLimitation, isDefaultCanvas);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, mirrorCropRect, lastBaseRotationAssetWidth,
        lastBaseRotationAssetHeight, isDefaultCanvas);

    Json::Value json;
    json["id"] = type;
    hveAsset->SetRefreshThumbnails(TRUE);
    return m_fastWriter.write(json);
}

std::string HveCmdSetMirror::Redo()
{
    LOGI("UndoRedo HveCmdSetMirror Redo.");
    USE_ASSET(NAPI_JSON_ERROR_RETURN);

    bool previewMode = hveAsset->GetInPreviewMode();
    HmcEditorSetAutoFlush(editor, false);
    HveAssetOper::StartMirrorAnimation(editor, timeline, assetUid);

    auto cropRect = timeline->GetCropRect();
    float curCanvasWidth, curCanvasHeight;
    HmcEditorGetCanvasSize(editor, &curCanvasWidth, &curCanvasHeight);
    float baseOffsetX = (static_cast<float>(cropRect.CenterX()) - curCanvasWidth / 2) * 2;
    float posX;
    float posY;
    HmcAssetGetPositionByCenter(editor, assetUid, &posX, &posY);
    float fixPosX = curMirrorFlag ? (posX - baseOffsetX) : (posX + baseOffsetX);
    HmcAssetSetPositionByCenter(timeline->GetEditor(), assetUid, fixPosX, posY);

    HmcAssetSetMirror(editor, assetUid, curMirrorFlag, (HmcAssetMirrorType)curMirrorType);
    hveAsset->SwitchCropMode();
    if (previewMode) {
        timeline->SwitchPreviewMode();
    }
    HmcEditorSetAutoFlush(editor, true);
    hveAsset->SetAssetPosXY(fixPosX, posY);
    hveAsset->SetMirror(curMirrorFlag);
    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, cmdCanvasWidth, cmdCanvasHeight);
    HveCmdSetRotation::UpdateCropRectLimitation(timeline, mirrorCropRect, curCropLimitation, isDefaultCanvas);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, mirrorCropRect, curBaseRotationAssetWidth,
        curBaseRotationAssetHeight, isDefaultCanvas);
    Json::Value json;
    json["id"] = type;
    hveAsset->SetRefreshThumbnails(TRUE);
    return m_fastWriter.write(json);
}

int HveCmdSetMirror::CalculateMirrorFlag(int timelineId, std::string const & assetId, int mirrorType, int mirrorFlag)
{
     USE_ASSET(HMC_ERR);
    if (HMC_ASSET_MIRROR_HORIZONTAL == (HmcAssetMirrorType)mirrorType) {
        bool isDefaultHorizontalMirror = hveAsset->GetDefaultHorizontalMirror();
        return isDefaultHorizontalMirror ? (mirrorFlag == 1 ? 0 : 1) : mirrorFlag;
    }
    if (HMC_ASSET_MIRROR_VERTICAL == (HmcAssetMirrorType)mirrorType) {
        int isDefaultVerticalMirror = hveAsset->GetDefaultVerticalMirror();
        return isDefaultVerticalMirror ? (mirrorFlag == 1 ? 0 : 1) : mirrorFlag;
    }
    return mirrorFlag;
}

int HveCmdSetMirror::ComSetMirror(int timelineId, std::string const & assetId, int mirrorFlag, int mirrorType,
    std::function<void(std::string const & jsonPos)> cb, UndoRedoCommandType commandType)
{
    USE_ASSET(HMC_ERR);
    LOGD("mirrorFlag=%d, mirrorType=%d", mirrorFlag, mirrorType);

    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    hveAsset->SetBaseRotationAssetSize(size.width, size.height);
    timeline->SetCropLimitation(timeline->GetCropRect());

    CancelAnimation();
    int refreshRate = hveAsset->GetRefreshRate();
    postAnimation(
        [editor, timeline, hveAsset, assetUid, mirrorFlag, mirrorType, cb, this](float progress, bool startFlag) {
            // 镜像动画分三步，step1：动画前半段先进行宽缩放（1~0.1），step2：在动画一半时，进行镜像操作；step3：剩下一半动画再恢复宽缩放（0.1~1）
            HmcEditorSetAutoFlush(editor, false);
            if (fabs(progress - 1.0) < 0.001) {
                HmcAssetSetMirror(editor, assetUid, mirrorFlag, (HmcAssetMirrorType)mirrorType);
                hveAsset->SetInPreviewMode(false);
                hveAsset->UpdatePreviewMode(timeline->GetCropRect(), timeline->GetCropOperationArea(), false);
                HmcEditorSetAutoFlush(editor, true);
                BACKGROUND_TASK_MGR->Submit([mirrorFlag, editor, cb] {
                    Json::Value json;
                    Json::FastWriter fastWriter;
                    json["code"] = 0;
                    LOGI("Set mirror %d success, cb %s", mirrorFlag, fastWriter.write(json).c_str());
                    cb(fastWriter.write(json));
                },
                    __FUNCTION__);
                return;
            }
            this->CorrectionOffset(startFlag, progress, mirrorFlag, mirrorType);
        },
        g_animationTime, refreshRate);

    hveAsset->SetMirror(mirrorFlag);
    hveAsset->SetRefreshThumbnails(TRUE);
    return HMC_OK;
}

int HveCmdSetMirror::CorrectionOffset(bool startFlag, float progress, int mirrorFlag, int mirrorType)
{
    USE_ASSET(HMC_ERR);
    auto newZoomX = 1.0f;
    auto halfFlag = true;
    constexpr float minScale = 0.1;
    if (startFlag) {
        HveAssetOper::StartMirrorAnimation(editor, timeline, assetUid);
    }
    auto previewScale = 1.0f;
    auto previewOffsetX = hveAsset->GetPreviewOffsetX();
    auto previewOffsetY = hveAsset->GetPreviewOffsetY();
    if (progress < g_halfProgress) {
        newZoomX = previewScale - (previewScale - minScale) * progress * g_two;
        HmcAssetCropTransformSetPosition(editor, assetUid, previewOffsetX, previewOffsetY, newZoomX, previewScale, 0);
        HmcEditorSetAutoFlush(editor, true);
        return HMC_OK;
    }

    int isHorizontalMirror = 0;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    // 画布中心点坐标和裁剪可操作区域中心点坐标不一致时，在设置镜像开关前需要修正X轴偏移量
    if (isHorizontalMirror != mirrorFlag) {
        auto cropRect = timeline->GetCropRect();
        float canvasWidth, canvasHeight;
        HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
        float baseOffsetX = (static_cast<float>(cropRect.CenterX()) - canvasWidth / 2) * 2;
        float posX;
        float posY;
        HmcAssetGetPositionByCenter(editor, assetUid, &posX, &posY);
        float fixPosX = mirrorFlag ? (posX - baseOffsetX) : (posX + baseOffsetX);
        HmcAssetSetPositionByCenter(timeline->GetEditor(), assetUid, fixPosX, posY);
        hveAsset->SetAssetPosXY(fixPosX, posY);
    }

    if (halfFlag) {
        HmcAssetSetMirror(editor, assetUid, mirrorFlag, (HmcAssetMirrorType)mirrorType);
        halfFlag = false;
    }
    newZoomX = minScale + (previewScale - minScale) * (progress - g_halfProgress) * g_two;
    LOGI("CurrenCorrectionOffset is newZoomX=%lf , minScale=%lf, previewScale=%lf, progress=%lf, g_halfProgress=%f",
        newZoomX, minScale, previewScale, progress, g_halfProgress);
    HmcAssetCropTransformSetPosition(editor, assetUid, previewOffsetX, previewOffsetY, newZoomX, previewScale,
        0);
    HmcEditorSetAutoFlush(editor, true);
    return HMC_OK;
}

int HveCmdSetMirror::UpdateMirrorLastAssetData()
{
    USE_ASSET(HMC_ERR);
    mirrorCropRect = timeline->GetCropRect();
    lastCropLimitation = timeline->GetCropLimitation();
    lastBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    lastBaseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    HmcEditorGetCanvasSize(editor, &cmdCanvasWidth, &cmdCanvasHeight);
    return HMC_OK;
}

int HveCmdSetMirror::UpdateMirrorCurAssetData()
{
    USE_ASSET(HMC_ERR);
    curCropLimitation = timeline->GetCropLimitation();
    curBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    curBaseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    return HMC_OK;
}

/*
 * Description: 固定比例和自由比例裁剪支持撤销恢复
 * Create: 2023/7/20
 */
HveCmdSetCropRect::HveCmdSetCropRect(int timelineId, std::string const & assetId, const HmcRectD &rect, double animMs,
    int clipRatioType, std::string const & chooseRatio, std::string const & type)
    : HveCommand(timelineId, type, assetId),
      inputCropRect(rect),
      animMs(animMs),
      clipRatioType(clipRatioType),
      curChooseRatio(chooseRatio)
{}

HveCmdSetCropRect::~HveCmdSetCropRect() {}

int HveCmdSetCropRect::Execute()
{
    LOGI("UndoRedo HveCmdSetCropRect Execute.");
    USE_ASSET(HMC_ERR);

    int ret = UpdateCropRectLastAssetData();
    if (ret != HMC_OK) {
        return ret;
    }

    auto cropOperationArea = timeline->GetCropOperationArea();
    HveAssetOper::SetCropRectInner(timeline, assetUid, inputCropRect, cropOperationArea, animMs, clipRatioType, true,
        false);

    ret = UpdateCropRectCurAssetData();
    if (ret != HMC_OK) {
        return ret;
    }

    hveAsset->SetRefreshThumbnails(TRUE);
    if (!((ClipRatioType)clipRatioType == SPECIFIED_RATIO_CLICK_CROP || (ClipRatioType)clipRatioType == DRAG_CROP)) {
        return HMC_ERR;
    }
    if (!IsChanged()) {
        LOGI("The CropRect has not changed!");
        return HMC_ERR;
    } else {
        return HMC_OK;
    }
}

bool HveCmdSetCropRect::IsChanged()
{
    if (abs(curCropRect.Width() - lastCropRect.Width()) > UNDO_REDO_EPS ||
        abs(curCropRect.Height() - lastCropRect.Height()) > UNDO_REDO_EPS ||
        abs(curAssetPosX - lastAssetPosX) > UNDO_REDO_EPS || abs(curAssetPosY - lastAssetPosY) > UNDO_REDO_EPS ||
        abs(curAssetWidth - lastAssetWidth) > UNDO_REDO_EPS || abs(curAssetHeight - lastAssetHeight) > UNDO_REDO_EPS) {
        return true;
    }
    return false;
}

std::string HveCmdSetCropRect::Undo()
{
    LOGI("UndoRedo HveCmdSetCropRect Undo.");
    USE_ASSET(NAPI_JSON_ERROR_RETURN);
    bool previewMode = hveAsset->GetInPreviewMode();
    float undoAssetPosX = lastAssetPosX;
    float undoAssetPosY = lastAssetPosY;
    float undoAssetWidth = lastAssetWidth;
    float undoAssetHeight = lastAssetHeight;
    HmcRectD undoLastCropRect = lastCropRect;

    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, cmdCanvasWidth, cmdCanvasHeight);
    if (!isDefaultCanvas) {
        int result = CustomCanvas(undoAssetWidth, undoAssetHeight, undoAssetPosX, undoAssetPosY, undoLastCropRect);
        if (result == HMC_ERR) {
            return NAPI_JSON_ERROR_RETURN;
        }
    }

    HmcEditorSetAutoFlush(editor, false);
    HmcAssetSetPositionByCenter(editor, assetUid, undoAssetPosX, undoAssetPosY);
    HmcSize size = { undoAssetWidth, undoAssetHeight };
    HmcAssetSetSize(editor, assetUid, size);
    auto cropOperationArea = timeline->GetCropOperationArea();
    HmcRectD calCropRect = HveAssetOper::SetCropRectInner(timeline, assetUid, undoLastCropRect, cropOperationArea, 0,
        clipRatioType, false, false);
    hveAsset->SwitchCropMode();
    if (previewMode) {
        timeline->SwitchPreviewMode();
    }
    // 根据最新的高度和宽度刷新水印信息
    hveAsset->RefreshWatermarkCropRect(calCropRect);
    HmcEditorSetAutoFlush(editor, true);

    HveCmdSetRotation::UpdateCropRectLimitation(timeline, lastCropRect, lastCropLimitation, isDefaultCanvas);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, lastCropRect, lastBaseRotationAssetWidth,
        lastBaseRotationAssetHeight, isDefaultCanvas);

    hveAsset->SetRefreshThumbnails(TRUE);
    Json::Value json;
    json["id"] = type;
    json["left"] = calCropRect.left;
    json["top"] = calCropRect.top;
    json["right"] = calCropRect.right;
    json["bottom"] = calCropRect.bottom;

    if ((ClipRatioType)clipRatioType == SPECIFIED_RATIO_CLICK_CROP) {
        json["ratio"] = lastChooseRatio;
        json[type] = calCropRect.Width() / calCropRect.Height();
        hveAsset->SetChooseRatio(lastChooseRatio);
    }
    LOGI("UndoRedo HveCmdSetCropRect Undo json:%s", m_fastWriter.write(json).c_str());
    return m_fastWriter.write(json);
}

std::string HveCmdSetCropRect::Redo()
{
    LOGI("UndoRedo HveCmdSetCropRect Redo.");
    USE_ASSET(NAPI_JSON_ERROR_RETURN);
    bool previewMode = hveAsset->GetInPreviewMode();
    float redoAssetPosX = curAssetPosX;
    float redoAssetPosY = curAssetPosY;
    float redoAssetWidth = curAssetWidth;
    float redoAssetHeight = curAssetHeight;
    HmcRectD redoLastCropRect = curCropRect;

    bool isDefaultCanvas = HveCmdSetRotation::IsDefaultCanvas(timeline, cmdCanvasWidth, cmdCanvasHeight);
    if (!isDefaultCanvas) {
        int result = CustomCanvas(redoAssetWidth, redoAssetHeight, redoAssetPosX, redoAssetPosY, redoLastCropRect);
        if (result == HMC_ERR) {
            return NAPI_JSON_ERROR_RETURN;
        }
    }
    HmcEditorSetAutoFlush(editor, false);
    HmcAssetSetPositionByCenter(editor, assetUid, redoAssetPosX, redoAssetPosY);
    HmcSize size = { redoAssetWidth, redoAssetHeight };
    HmcAssetSetSize(editor, assetUid, size);
    auto cropOperationArea = timeline->GetCropOperationArea();
    HmcRectD calCropRect = HveAssetOper::SetCropRectInner(timeline, assetUid, redoLastCropRect, cropOperationArea, 0,
        clipRatioType, false, false);
    hveAsset->SwitchCropMode();
    if (previewMode) {
        timeline->SwitchPreviewMode();
    }
    // 根据最新的高度和宽度刷新水印信息
    hveAsset->RefreshWatermarkCropRect(calCropRect);
    HmcEditorSetAutoFlush(editor, true);

    HveCmdSetRotation::UpdateCropRectLimitation(timeline, curCropRect, curCropLimitation, isDefaultCanvas);
    HveCmdSetRotation::UpdateBaseRotationAsset(timeline, assetUid, curCropRect, curBaseRotationAssetWidth,
        curBaseRotationAssetHeight, isDefaultCanvas);
    hveAsset->SetRefreshThumbnails(TRUE);
    timeline->SetCropLimitation(curCropLimitation);
    Json::Value json;
    json["id"] = type;
    json["left"] = calCropRect.left;
    json["top"] = calCropRect.top;
    json["right"] = calCropRect.right;
    json["bottom"] = calCropRect.bottom;

    if ((ClipRatioType)clipRatioType == SPECIFIED_RATIO_CLICK_CROP) {
        json["ratio"] = curChooseRatio;
        json[type] = calCropRect.Width() / calCropRect.Height();
        hveAsset->SetChooseRatio(curChooseRatio);
    }
    LOGI("UndoRedo HveCmdSetCropRect Redo json:%s", m_fastWriter.write(json).c_str());
    return m_fastWriter.write(json);
}

int HveCmdSetCropRect::CustomCanvas(float &assetWidth, float &assetHeight, float &assetPosX,
    float &assetPosY, HmcRectD &lastCropRect)
{
    USE_ASSET(HMC_ERR);
    auto redoCropRect = timeline->GetCropRect();
    float cropScale = HveCmdSetRotation::CalCropRectRadio(redoCropRect, lastCropRect);

    assetWidth = assetWidth * cropScale;
    assetHeight = assetHeight * cropScale;

    double curCropRectWidth = lastCropRect.Width() * cropScale;
    double curCropRectHeight = lastCropRect.Height() * cropScale;
    HmcRectD updateLastCropRect(
        redoCropRect.CenterX() - curCropRectWidth / g_two, redoCropRect.CenterY()
            - curCropRectHeight / g_two,
        redoCropRect.CenterX() + curCropRectWidth / g_two, redoCropRect.CenterY()
            + curCropRectHeight / g_two);
    lastCropRect = updateLastCropRect;

    HmcSize canvasSize;
    int result = HmcEditorGetCanvasSize(editor, &canvasSize.width, &canvasSize.height);
    if (result != HMC_OK) {
        LOGE("HveCmdSetCropRect redo get canvas failed.");
        return HMC_ERR;
    }
    int isHorizontalMirror = 0;
    result = HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    if (result != HMC_OK) {
        LOGE("HveCmdSetCropRect redo get mirror flag failed.");
        return HMC_ERR;
    }
    UpdateCanvasRect updCanvasCropRect = {HmcSize{cmdCanvasWidth, cmdCanvasHeight}, canvasSize, curCropRect,
                                          lastCropRect};
    HmcAssetPoint assetPosition = HveAssetOper::CalAssetPositionByCanvas(
        updCanvasCropRect, HmcAssetPoint{assetPosX, assetPosY}, cropScale, isHorizontalMirror);
    assetPosX = assetPosition.x;
    assetPosY = assetPosition.y;
    return HMC_OK;
}

int HveCmdSetCropRect::UpdateCropRectLastAssetData()
{
    if (clipRatioType != 1 && clipRatioType != 2) {
        return HMC_OK;
    }

    USE_ASSET(HMC_ERR);
    if (clipRatioType == 1) {
        lastChooseRatio = hveAsset->GetChooseRatio();
    }

    lastCropRect = timeline->GetCropRect();
    lastCropLimitation = timeline->GetCropLimitation();

    float startX;
    float startY;
    HmcAssetGetPositionByCenter(editor, assetUid, &startX, &startY);
    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_DEST, &size);

    lastAssetPosX = startX;
    lastAssetPosY = startY;
    lastAssetWidth = size.width;
    lastAssetHeight = size.height;
    lastBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    lastBaseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    HmcEditorGetCanvasSize(editor, &cmdCanvasWidth, &cmdCanvasHeight);
    return HMC_OK;
}

int HveCmdSetCropRect::UpdateCropRectCurAssetData()
{
    if (clipRatioType != 1 && clipRatioType != 2) {
        return HMC_OK;
    }

    USE_ASSET(HMC_ERR);
    auto newCropRect = timeline->GetCropRect();

    curCropRect = newCropRect;
    curCropLimitation = timeline->GetCropLimitation();

    curAssetPosX = hveAsset->GetAssetPosX();
    curAssetPosY = hveAsset->GetAssetPosY();
    curAssetWidth = hveAsset->GetAssetWidth();
    curAssetHeight = hveAsset->GetAssetHeight();
    curBaseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    curBaseRotationAssetHeight = hveAsset->GetAssetHeight();
    if (clipRatioType == 1) {
        hveAsset->SetChooseRatio(curChooseRatio);
    }
    return HMC_OK;
}

/*
 * Description: 移动和缩放支持撤销恢复
 * Create: 2023/7/20
 */
HveCmdCropAsset::HveCmdCropAsset(int timelineId, std::string const & assetId, int cropType, int aniDuration,
    const HmcRectD &rect, std::string const & type)
    : HveCmdCropBase(timelineId, assetId, type), inputCropRect(rect), aniDuration(aniDuration), cropType(cropType)
{}

HveCmdCropAsset::~HveCmdCropAsset() {}

int HveCmdCropAsset::Execute()
{
    LOGI("UndoRedo HveCmdCropAsset Execute.");
    USE_ASSET(HMC_ERR);
    int ret = UpdateCropAssetLastAssetData();
    if (ret != HMC_OK) {
        return ret;
    }

    // ONE_FINGER_MOVE_START和TWO_FINGER_SCALE_START状态仅用于撤销恢复功能记录缩放/移动操作开始
    if ((CropAssetOperation)cropType != ONE_FINGER_MOVE_START &&
        (CropAssetOperation)cropType != TWO_FINGER_SCALE_START) {
        HveAssetOper::FillCropRect(timeline, assetUid, aniDuration, inputCropRect, HveAssetOper::DefaultRule);
    }
    ret = UpdateCropAssetCurAssetData();
    if (ret != HMC_OK) {
        return ret;
    }

    hveAsset->SetRefreshThumbnails(TRUE);
    if ((CropAssetOperation)cropType != OTHER_TYPE_OPER) {
        return HMC_OK;
    } else {
        return HMC_ERR;
    }
}

int HveCmdCropAsset::UpdateCropAssetLastAssetData()
{
    if ((CropAssetOperation)cropType == OTHER_TYPE_OPER) {
        return HMC_OK;
    }
    return HveCmdCropBase::UpdateCropLastAssetData();
}

int HveCmdCropAsset::UpdateCropAssetCurAssetData()
{
    if ((CropAssetOperation)cropType == OTHER_TYPE_OPER) {
        return HMC_OK;
    }
    return HveCmdCropBase::UpdateCropCurAssetData();
}

/*
 * Description: 反向裁剪
 * Create: 2023/11/13
 */
HveCmdReverseCrop::HveCmdReverseCrop(int timelineId, std::string const &assetId, std::vector<double> rect,
    std::vector<int> direction, double ratio, double pressure, std::string const &type)
    : HveCmdCropBase(timelineId, assetId, type), m_direction(direction), m_ratio(ratio), m_pressure(pressure)
{
    m_inputCropRect.left = rect[0];
    m_inputCropRect.top = rect[1];
    m_inputCropRect.right = rect[2];
    m_inputCropRect.bottom = rect[3];
    m_realCropRect.left = rect[4];
    m_realCropRect.top = rect[5];
    m_realCropRect.right = rect[6];
    m_realCropRect.bottom = rect[7];
}

HveCmdReverseCrop::~HveCmdReverseCrop() {}

int HveCmdReverseCrop::Execute()
{
    LOGI("UndoRedo HveCmdReverseCrop Execute.");
    USE_ASSET(HMC_ERR);
    int ret = UpdateCropLastAssetData();
    if (ret != HMC_OK) {
        return ret;
    }

    double offsetX;
    double offsetY;
    CalAssetOffset(timeline, assetUid, &offsetX, &offsetY);
    FixInputCropRect(timeline->GetCropOperationArea());
    auto offsetCropRect = GetOffsetCropRect(m_fixInputCropRect, offsetX, offsetY);

    float input[4] = {(float)offsetCropRect.left, (float)offsetCropRect.top, (float)offsetCropRect.right,
                      (float)offsetCropRect.bottom};
    float output[4] = {0, 0, 0, 0};
    bool succeed = GetReachableRect(editor, assetUid, input, RECT_SIZE, output, RECT_SIZE);
    if (!succeed) {
        LOGE("[ReverseCrop]Get reachable rect failed.");
        return HMC_ERR;
    }

    HmcRectD outputRect(output[0], output[1], output[2], output[3]);
    OutputRectHandler(m_fixInputCropRect, offsetCropRect, outputRect);

    if (!CheckOutputRect(timeline->GetCropRect(), outputRect)) {
        CalForwardCropRect(timeline, outputRect);
        LOGW("[ReverseCrop]Same cropRect and return.");
        return HMC_ERR;
    }

    double scale = CalRectScale(m_fixInputCropRect, outputRect);
    scale = CalReverseCropRect(outputRect, m_fixInputCropRect, scale, hveAsset->GetCropRectMinLen());
    double centerX;
    double centerY;
    ret = CalScaleCenter(&centerX, &centerY);
    if (ret != HMC_OK) {
        LOGE("[ReverseCrop]CalScaleCenter failed.");
        return HMC_ERR;
    }

    if (fabs(scale - 1.0) > DOUBLE_PRECISION) {
        Asset::Scale(timelineId, assetId, scale, centerX, centerY);
    }

    ReverseCropAfter(timeline, assetUid);

    ret = UpdateCropCurAssetData();
    if (ret != HMC_OK) {
        return ret;
    }

    hveAsset->SetRefreshThumbnails(TRUE);
    return HMC_OK;
}

void HveCmdReverseCrop::FixInputCropRect(const HmcRectD &operArea)
{
    // 修正超出可裁剪区域部分
    FixInputRectByFreeRatio(operArea);

    if (fabs(m_ratio) > DOUBLE_PRECISION && GetChangedSide() == 3) {
        // 修正按比例裁剪拖动一条边时的输入裁剪框坐标
        FixInputRectForDragSide3(operArea);
    } else if (fabs(m_ratio) > DOUBLE_PRECISION && GetChangedSide() == 2) {
        // 修正按比例裁剪拖动角时的输入裁剪框坐标
        FixInputRectForDragSide2(operArea);
    }
}

void HveCmdReverseCrop::FixInputRectByFreeRatio(const HmcRectD &operArea)
{
    m_fixInputCropRect = m_inputCropRect;
    if (m_fixInputCropRect.left < operArea.left) {
        m_fixInputCropRect.left = operArea.left;
    }
    if (m_fixInputCropRect.top < operArea.top) {
        m_fixInputCropRect.top = operArea.top;
    }
    if (m_fixInputCropRect.right > operArea.right) {
        m_fixInputCropRect.right = operArea.right;
    }
    if (m_fixInputCropRect.bottom > operArea.bottom) {
        m_fixInputCropRect.bottom = operArea.bottom;
    }
}

void HveCmdReverseCrop::FixInputRectForDragSide3(const HmcRectD &operArea)
{
    // 按比例裁剪，依次修正拖动的三个边坐标
    if (m_direction[0] == 0) {
        FixInputRectExactRatioRight(operArea);
    } else if (m_direction[1] == 0) {
        FixInputRectExactRatioBottom(operArea);
    } else if (m_direction[2] == 0) {
        FixInputRectExactRatioLeft(operArea);
    } else {
        FixInputRectExactRatioTop(operArea);
    }
}

void HveCmdReverseCrop::FixInputRectExactRatioRight(const HmcRectD &operArea)
{
    double width = m_fixInputCropRect.right - m_realCropRect.left;
    double height = width / m_ratio;
    double topLen = m_realCropRect.CenterY() - operArea.top;
    double bottomLen = operArea.bottom - m_realCropRect.CenterY();
    double minLen = HMC_MIN(topLen, bottomLen);
    if (height > minLen * 2) {
        height = minLen * 2;
        width = height * m_ratio;
    }
    m_fixInputCropRect.left = m_realCropRect.left;
    m_fixInputCropRect.right = m_realCropRect.left + width;
    m_fixInputCropRect.bottom = m_realCropRect.CenterY() + height / 2;
    m_fixInputCropRect.top = m_realCropRect.CenterY() - height / 2;
}

void HveCmdReverseCrop::FixInputRectExactRatioBottom(const HmcRectD &operArea)
{
    double height = m_fixInputCropRect.bottom - m_realCropRect.top;
    double width = height * m_ratio;
    double leftLen = m_realCropRect.CenterX() - operArea.left;
    double rightLen = operArea.right - m_realCropRect.CenterX();
    double minLen = HMC_MIN(leftLen, rightLen);
    if (width > minLen * 2) {
        width = minLen * 2;
        height = width / m_ratio;
    }
    m_fixInputCropRect.bottom = m_realCropRect.top + height;
    m_fixInputCropRect.left = m_realCropRect.CenterX() - width / 2;
    m_fixInputCropRect.right = m_realCropRect.CenterX() + width / 2;
    m_fixInputCropRect.top = m_realCropRect.top;
}

void HveCmdReverseCrop::FixInputRectExactRatioLeft(const HmcRectD &operArea)
{
    double width = m_realCropRect.right - m_fixInputCropRect.left;
    double height = width / m_ratio;
    double topLen = m_realCropRect.CenterY() - operArea.top;
    double bottomLen = operArea.bottom - m_realCropRect.CenterY();
    double minLen = HMC_MIN(topLen, bottomLen);
    if (height > minLen * 2) {
        height = minLen * 2;
        width = height * m_ratio;
    }
    m_fixInputCropRect.left = m_realCropRect.right - width;
    m_fixInputCropRect.right = m_realCropRect.right;
    m_fixInputCropRect.bottom = m_realCropRect.CenterY() + height / 2;
    m_fixInputCropRect.top = m_realCropRect.CenterY() - height / 2;
}

void HveCmdReverseCrop::FixInputRectExactRatioTop(const HmcRectD &operArea)
{
    double height = m_realCropRect.bottom - m_fixInputCropRect.top;
    double width = height * m_ratio;
    double leftLen = m_realCropRect.CenterX() - operArea.left;
    double rightLen = operArea.right - m_realCropRect.CenterX();
    double minLen = HMC_MIN(leftLen, rightLen);
    if (width > minLen * 2) {
        width = minLen * 2;
        height = width / m_ratio;
    }
    m_fixInputCropRect.bottom = m_realCropRect.bottom;
    m_fixInputCropRect.left = m_realCropRect.CenterX() - width / 2;
    m_fixInputCropRect.right = m_realCropRect.CenterX() + width / 2;
    m_fixInputCropRect.top = m_realCropRect.bottom - height;
}

void HveCmdReverseCrop::FixInputRectForDragSide2(const HmcRectD &operArea)
{
    // 按比例裁剪，依次修正拖动角对应边的坐标
    if (m_direction[0] == 1 && m_direction[1] == 1) {
        FixInputRectExactRatioLeftTop(operArea);
    } else if (m_direction[1] == 1 && m_direction[2] == 1) {
        FixInputRectExactRatioRightTop(operArea);
    } else if (m_direction[2] == 1 && m_direction[3] == 1) {
        FixInputRectExactRatioRightBottom(operArea);
    } else {
        FixInputRectExactRatioLeftBottom(operArea);
    }
}

void HveCmdReverseCrop::FixInputRectExactRatioLeftTop(const HmcRectD &operArea)
{
    m_fixInputCropRect.right = m_realCropRect.right;
    m_fixInputCropRect.bottom = m_realCropRect.bottom;
    double fixWidth;
    double fixHeight;
    int widthOrHeight = GetFixInputSize(&fixWidth, &fixHeight);

    if (HveAssetOper::LessAndEqual(m_fixInputCropRect.right - fixWidth, operArea.left)) {
        m_fixInputCropRect.left = operArea.left;
        double newWidth = m_fixInputCropRect.Width();
        double newHeight = newWidth / m_ratio;
        m_fixInputCropRect.top = m_fixInputCropRect.bottom - newHeight;
    } else if (widthOrHeight == 0 && m_ratio < 1) {
        m_fixInputCropRect.left = m_fixInputCropRect.right - fixWidth;
        m_fixInputCropRect.top = m_fixInputCropRect.bottom - fixHeight;
    }

    if (HveAssetOper::LessAndEqual(m_fixInputCropRect.bottom - fixHeight, operArea.top)) {
        m_fixInputCropRect.top = operArea.top;
        double newHeight = m_fixInputCropRect.Height();
        double newWidth = newHeight * m_ratio;
        m_fixInputCropRect.left = m_fixInputCropRect.right - newWidth;
    } else if (widthOrHeight == 1 && m_ratio > 1) {
        m_fixInputCropRect.left = m_fixInputCropRect.right - fixWidth;
        m_fixInputCropRect.top = m_fixInputCropRect.bottom - fixHeight;
    }
}

void HveCmdReverseCrop::FixInputRectExactRatioRightTop(const HmcRectD &operArea)
{
    m_fixInputCropRect.left = m_realCropRect.left;
    m_fixInputCropRect.bottom = m_realCropRect.bottom;

    double fixWidth;
    double fixHeight;
    int widthOrHeight = GetFixInputSize(&fixWidth, &fixHeight);

    if (HveAssetOper::GreatAndEqual(m_fixInputCropRect.left + fixWidth, operArea.right)) {
        m_fixInputCropRect.right = operArea.right;
        double newWidth = m_fixInputCropRect.Width();
        double newHeight = newWidth / m_ratio;
        m_fixInputCropRect.top = m_fixInputCropRect.bottom - newHeight;
    } else if (widthOrHeight == 0 && m_ratio < 1) {
        m_fixInputCropRect.right = m_fixInputCropRect.left + fixWidth;
        m_fixInputCropRect.top = m_fixInputCropRect.bottom - fixHeight;
    }

    if (HveAssetOper::LessAndEqual(m_fixInputCropRect.bottom - fixHeight, operArea.top)) {
        m_fixInputCropRect.top = operArea.top;
        double newHeight = m_fixInputCropRect.Height();
        double newWidth = newHeight * m_ratio;
        m_fixInputCropRect.right = m_fixInputCropRect.left + newWidth;
    } else if (widthOrHeight == 1 && m_ratio > 1) {
        m_fixInputCropRect.right = m_fixInputCropRect.left + fixWidth;
        m_fixInputCropRect.top = m_fixInputCropRect.bottom - fixHeight;
    }
}

void HveCmdReverseCrop::FixInputRectExactRatioRightBottom(const HmcRectD &operArea)
{
    m_fixInputCropRect.left = m_realCropRect.left;
    m_fixInputCropRect.top = m_realCropRect.top;
    double fixWidth;
    double fixHeight;
    int widthOrHeight = GetFixInputSize(&fixWidth, &fixHeight);

    if (HveAssetOper::GreatAndEqual(m_fixInputCropRect.left + fixWidth, operArea.right)) {
        m_fixInputCropRect.right = operArea.right;
        double newWidth = m_fixInputCropRect.Width();
        double newHeight = newWidth / m_ratio;
        m_fixInputCropRect.bottom = m_fixInputCropRect.top + newHeight;
    } else if (widthOrHeight == 0 && m_ratio < 1) {
        m_fixInputCropRect.right = m_fixInputCropRect.left + fixWidth;
        m_fixInputCropRect.bottom = m_fixInputCropRect.top + fixHeight;
    }

    if (HveAssetOper::GreatAndEqual(m_fixInputCropRect.top + fixHeight, operArea.bottom)) {
        m_fixInputCropRect.bottom = operArea.bottom;
        double newHeight = m_fixInputCropRect.Height();
        double newWidth = newHeight * m_ratio;
        m_fixInputCropRect.right = m_fixInputCropRect.left + newWidth;
    } else if (widthOrHeight == 1 && m_ratio > 1) {
        m_fixInputCropRect.right = m_fixInputCropRect.left + fixWidth;
        m_fixInputCropRect.bottom = m_fixInputCropRect.top + fixHeight;
    }
}

void HveCmdReverseCrop::FixInputRectExactRatioLeftBottom(const HmcRectD &operArea)
{
    m_fixInputCropRect.right = m_realCropRect.right;
    m_fixInputCropRect.top = m_realCropRect.top;
    double fixWidth;
    double fixHeight;
    int widthOrHeight = GetFixInputSize(&fixWidth, &fixHeight);

    if (HveAssetOper::LessAndEqual(m_fixInputCropRect.right - fixWidth, operArea.left)) {
        m_fixInputCropRect.left = operArea.left;
        double newWidth = m_fixInputCropRect.Width();
        double newHeight = newWidth / m_ratio;
        m_fixInputCropRect.bottom = m_fixInputCropRect.top + newHeight;
    } else if (widthOrHeight == 0 && m_ratio < 1) {
        m_fixInputCropRect.left = m_fixInputCropRect.right - fixWidth;
        m_fixInputCropRect.bottom = m_fixInputCropRect.top + fixHeight;
    }
    if (HveAssetOper::GreatAndEqual(m_fixInputCropRect.top + fixHeight, operArea.bottom)) {
        m_fixInputCropRect.bottom = operArea.bottom;
        double newHeight = m_fixInputCropRect.Height();
        double newWidth = newHeight * m_ratio;
        m_fixInputCropRect.left = m_fixInputCropRect.right - newWidth;
    } else if (widthOrHeight == 1 && m_ratio > 1) {
        m_fixInputCropRect.left = m_fixInputCropRect.right - fixWidth;
        m_fixInputCropRect.bottom = m_fixInputCropRect.top + fixHeight;
    }
}

int HveCmdReverseCrop::GetFixInputSize(double *fixW, double *fixH)
{
    double width = m_fixInputCropRect.Width();
    double height = m_fixInputCropRect.Height();
    double fixWidth = height * m_ratio;
    double fixHeight = width / m_ratio;
    int widthOrHeight = -1;
    if (width > fixWidth && height < fixHeight) {
        fixHeight = height;
        widthOrHeight = 0;
    } else if (width < fixWidth && height > fixHeight) {
        fixWidth = width;
        widthOrHeight = 1;
    }
    *fixW = fixWidth;
    *fixH = fixHeight;
    return widthOrHeight;
}

int HveCmdReverseCrop::CalAssetOffset(HveTimeline *timeline, const HmcUid &assetUid, double *offsetX, double *offsetY)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);

    HmcSize size;
    int result = HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    if (result != HMC_OK) {
        LOGE("[ReverseCrop]Get asset size failed.");
        return result;
    }
    auto baseRotation = hveAsset->GetBaseRotation();
    if (HveAssetOper::AssetSizeIsExchanged(baseRotation)) {
        std::swap(size.width, size.height);
    }

    double cropPercent = m_pressure < 0.5 ? LIGHT_PRESSURE_CROP_PERCENTAGE : HEAVY_PRESSURE_CROP_PERCENTAGE;
    *offsetX = size.width * cropPercent / REVERSE_CROP_CALL_TIMES;
    *offsetY = size.height * cropPercent / REVERSE_CROP_CALL_TIMES;
    return HMC_OK;
}

HmcRectD HveCmdReverseCrop::GetOffsetCropRect(const HmcRectD &inputRect, double offsetX, double offsetY)
{
    HmcRectD moveCropRect = inputRect;
    if (fabs(m_ratio) > DOUBLE_PRECISION && GetChangedSide() == 3) {
        moveCropRect = GetOffsetCropRectForDragSide3(inputRect, offsetX, offsetY);
    } else {
        if (m_direction[0] == 1) {
            moveCropRect.left = inputRect.left - offsetX;
        }
        if (m_direction[1] == 1) {
            moveCropRect.top = inputRect.top - offsetY;
        }
        if (m_direction[2] == 1) {
            moveCropRect.right = inputRect.right + offsetX;
        }
        if (m_direction[3] == 1) {
            moveCropRect.bottom = inputRect.bottom + offsetY;
        }
    }
    return moveCropRect;
}

HmcRectD HveCmdReverseCrop::GetOffsetCropRectForDragSide3(const HmcRectD &inputRect, double offsetX, double offsetY)
{
    HmcRectD moveCropRect = inputRect;
    if (m_direction[2] == 0) {
        moveCropRect.left = inputRect.left - offsetX;
        moveCropRect.top = inputRect.top - offsetY / 2;
        moveCropRect.bottom = inputRect.bottom + offsetY / 2;
    } else if (m_direction[3] == 0) {
        moveCropRect.top = inputRect.top - offsetY;
        moveCropRect.left = inputRect.left - offsetX / 2;
        moveCropRect.right = inputRect.right + offsetX / 2;
    } else if (m_direction[0] == 0) {
        moveCropRect.right = inputRect.right + offsetX;
        moveCropRect.top = inputRect.top - offsetY / 2;
        moveCropRect.bottom = inputRect.bottom + offsetY / 2;
    } else {
        moveCropRect.bottom = inputRect.bottom + offsetY;
        moveCropRect.left = inputRect.left - offsetX / 2;
        moveCropRect.right = inputRect.right + offsetX / 2;
    }
    return moveCropRect;
}

int HveCmdReverseCrop::GetReachableRect(HmcEditor *editor, const HmcUid &assetUid, float *input, size_t inputRectSize,
    float *output, size_t outputRectSize)
{
    LOGD("[ReverseCrop]GetReachableRect begin %zu,%zu", inputRectSize, outputRectSize);
    float ratio = static_cast<float>(m_ratio);
    int direction[] = {m_direction[0], m_direction[1], m_direction[2], m_direction[3]};
    bool succeed = HveAssetOper::CalcOptimalCropRect(
        editor, assetUid,
        [ratio, direction](float *corners, float *input, float *output) {
            return HveAssetOper::ReachableRectRule(ratio, (int *)direction, corners, input, output);
        },
        input, RECT_SIZE, output, RECT_SIZE);
    return succeed;
}

void HveCmdReverseCrop::OutputRectHandler(const HmcRectD &fixInputRect, const HmcRectD &offsetCropRect,
    HmcRectD &outputRect)
{
    if (fabs(m_ratio) < DOUBLE_PRECISION || GetChangedSide() != 3) {
        return;
    }

    if (CheckExceedLeft(outputRect.left, offsetCropRect.left)) {
        OutputRectHandlerForExceedLeft(fixInputRect, outputRect);
    } else if (CheckExceedRight(outputRect.right, offsetCropRect.right)) {
        OutputRectHandlerForExceedRight(fixInputRect, outputRect);
    } else if (CheckExceedTop(outputRect.top, offsetCropRect.top)) {
        OutputRectHandlerForExceedTop(fixInputRect, outputRect);
    } else if (CheckExceedBottom(outputRect.bottom, offsetCropRect.bottom)) {
        OutputRectHandlerForExceedBottom(fixInputRect, outputRect);
    }
}

void HveCmdReverseCrop::OutputRectHandlerForExceedLeft(const HmcRectD &fixInputRect, HmcRectD &outputRect)
{
    double offsetX = (fixInputRect.left - outputRect.left) * 2;
    double width = fixInputRect.Width() + offsetX;
    double height = width / m_ratio;
    double offsetY = height - fixInputRect.Height();
    outputRect.right = fixInputRect.right + offsetX / 2;
    if (m_direction[1] == 0) {
        outputRect.bottom = fixInputRect.bottom + offsetY;
    } else {
        outputRect.top = fixInputRect.top - offsetY;
    }
}

void HveCmdReverseCrop::OutputRectHandlerForExceedRight(const HmcRectD &fixInputRect, HmcRectD &outputRect)
{
    double offsetX = (outputRect.right - fixInputRect.right) * 2;
    double width = fixInputRect.Width() + offsetX;
    double height = width / m_ratio;
    double offsetY = height - fixInputRect.Height();
    outputRect.left = fixInputRect.left - offsetX / 2;
    if (m_direction[1] == 0) {
        outputRect.bottom = fixInputRect.bottom + offsetY;
    } else {
        outputRect.top = fixInputRect.top - offsetY;
    }
}

void HveCmdReverseCrop::OutputRectHandlerForExceedTop(const HmcRectD &fixInputRect, HmcRectD &outputRect)
{
    double offsetY = (fixInputRect.top - outputRect.top) * 2;
    double height = fixInputRect.Height() + offsetY;
    double width = height * m_ratio;
    double offsetX = width - fixInputRect.Width();
    outputRect.bottom = fixInputRect.bottom + offsetY / 2;
    if (m_direction[0] == 0) {
        outputRect.right = fixInputRect.right + offsetX;
    } else {
        outputRect.left = fixInputRect.left - offsetX;
    }
}

void HveCmdReverseCrop::OutputRectHandlerForExceedBottom(const HmcRectD &fixInputRect, HmcRectD &outputRect)
{
    double offsetY = (outputRect.bottom - fixInputRect.bottom) * 2;
    double height = fixInputRect.Height() + offsetY;
    double width = height * m_ratio;
    double offsetX = width - fixInputRect.Width();
    outputRect.top = fixInputRect.top - offsetY / 2;
    if (m_direction[0] == 0) {
        outputRect.right = fixInputRect.right + offsetX;
    } else {
        outputRect.left = fixInputRect.left - offsetX;
    }
}

bool HveCmdReverseCrop::CheckOutputRect(const HmcRectD &srcCropRect, const HmcRectD &dstCropRect)
{
    if (fabs(m_ratio) < DOUBLE_PRECISION && GetChangedSide() > 2) {
        return true;
    }

    if (HveAssetOper::GreatAndEqual(dstCropRect.left, srcCropRect.left) &&
        HveAssetOper::GreatAndEqual(dstCropRect.top, srcCropRect.top) &&
        HveAssetOper::LessAndEqual(dstCropRect.right, srcCropRect.right) &&
        HveAssetOper::LessAndEqual(dstCropRect.bottom, srcCropRect.bottom)) {
        return false;
    }
    return true;
}

void HveCmdReverseCrop::CalForwardCropRect(HveTimeline *timeline, const HmcRectD &outputRect)
{
    if (fabs(m_ratio) < DOUBLE_PRECISION && GetChangedSide() == 2) {
        HmcRectD returnRect = m_fixInputCropRect;
        returnRect.left = HMC_MAX(m_fixInputCropRect.left, outputRect.left);
        returnRect.top = HMC_MAX(m_fixInputCropRect.top, outputRect.top);
        returnRect.right = HMC_MIN(m_fixInputCropRect.right, outputRect.right);
        returnRect.bottom = HMC_MIN(m_fixInputCropRect.bottom, outputRect.bottom);
        timeline->SetReverseCropRect(returnRect);
    } else if (fabs(m_ratio) > DOUBLE_PRECISION) {
        HmcRectD returnRect = HveAssetOper::CheckCropRectBoundary(timeline->GetCropOperationArea(), outputRect);
        timeline->SetReverseCropRect(returnRect);
    }
}

double HveCmdReverseCrop::CalRectScale(const HmcRectD &cropRect, const HmcRectD &outputRect)
{
    double scale = 1.0F;
    double scaleW = cropRect.Width() / outputRect.Width();
    double scaleH = cropRect.Height() / outputRect.Height();
    if (fabs(m_ratio) < DOUBLE_PRECISION && GetChangedSide() == 2) {
        scale = HMC_MAX(scaleW, scaleH);
    } else {
        scale = HMC_MIN(scaleW, scaleH);
    }
    return HMC_MIN(scale, 1.0);
}

double HveCmdReverseCrop::CalReverseCropRect(const HmcRectD &reachableRect, const HmcRectD &fixInputRect, double scale,
    double cropRectMinLen)
{
    m_outputCropRect = fabs(scale - 1) > DOUBLE_PRECISION ? fixInputRect : reachableRect;

    // 自由比例模式下拖动裁剪框的一条边时素材缩放，裁剪框坐标需要重新计算（缩放比为1时返回输入坐标）；其他场景裁剪框坐标不变
    if (fabs(m_ratio) > DOUBLE_PRECISION || GetChangedSide() != 1 || fabs(scale - 1) < DOUBLE_PRECISION) {
        return scale;
    }

    double fixScale = scale;
    auto scaleRect = reachableRect;
    scaleRect.Scale(scale, scaleRect.CenterX(), scaleRect.CenterY());

    if (m_direction[0] == 1 || m_direction[2] == 1) {
        if (scaleRect.Height() < cropRectMinLen) {
            scaleRect.top = fixInputRect.CenterY() - cropRectMinLen / 2;
            scaleRect.bottom = fixInputRect.CenterY() + cropRectMinLen / 2;
            fixScale = cropRectMinLen / fixInputRect.Height();
        }
        scaleRect.left = fixInputRect.left;
        scaleRect.right = fixInputRect.right;
    } else {
        if (scaleRect.Width() < cropRectMinLen) {
            scaleRect.left = fixInputRect.CenterX() - cropRectMinLen / 2;
            scaleRect.right = fixInputRect.CenterX() + cropRectMinLen / 2;
            fixScale = cropRectMinLen / fixInputRect.Width();
        }
        scaleRect.top = fixInputRect.top;
        scaleRect.bottom = fixInputRect.bottom;
    }
    m_outputCropRect = scaleRect;

    return fixScale;
}

int HveCmdReverseCrop::CalScaleCenter(double *centerX, double *centerY)
{
    // 拖动裁剪框一个角时，缩放中心点取对角坐标
    if (GetChangedSide() == 2) {
        CalScaleCenterForDragSide2(centerX, centerY);
        return HMC_OK;
    }

    // 拖动裁剪框一个边时，缩放中心点取对边中心点坐标
    if (fabs(m_ratio) < DOUBLE_PRECISION) {
        if (GetChangedSide() == 1) {
            CalScaleCenterForDragSide1(centerX, centerY);
        } else {
            LOGE("[ReverseCrop]Invalid direction with ratio 0.");
            return HMC_ERR_PARAM;
        }
    } else {
        if (GetChangedSide() == 3) {
            CalScaleCenterForDragSide3(centerX, centerY);
        } else {
            LOGE("[ReverseCrop]Invalid direction with other side.");
            return HMC_ERR_PARAM;
        }
    }
    return HMC_OK;
}

void HveCmdReverseCrop::CalScaleCenterForDragSide1(double *centerX, double *centerY)
{
    double scaleCenterX;
    double scaleCenterY;
    if (m_direction[0] == 1) {
        scaleCenterX = m_fixInputCropRect.right;
        scaleCenterY = m_fixInputCropRect.top + m_fixInputCropRect.Height() / 2;
    } else if (m_direction[1] == 1) {
        scaleCenterX = m_fixInputCropRect.left + m_fixInputCropRect.Width() / 2;
        scaleCenterY = m_fixInputCropRect.bottom;
    } else if (m_direction[2] == 1) {
        scaleCenterX = m_fixInputCropRect.left;
        scaleCenterY = m_fixInputCropRect.top + m_fixInputCropRect.Height() / 2;
    } else {
        scaleCenterX = m_fixInputCropRect.left + m_fixInputCropRect.Width() / 2;
        scaleCenterY = m_fixInputCropRect.top;
    }
    *centerX = scaleCenterX;
    *centerY = scaleCenterY;
}

void HveCmdReverseCrop::CalScaleCenterForDragSide2(double *centerX, double *centerY)
{
    double scaleCenterX;
    double scaleCenterY;
    if (m_direction[0] == 1 && m_direction[1] == 1) {
        scaleCenterX = m_fixInputCropRect.right;
        scaleCenterY = m_fixInputCropRect.bottom;
    } else if (m_direction[1] == 1 && m_direction[2] == 1) {
        scaleCenterX = m_fixInputCropRect.left;
        scaleCenterY = m_fixInputCropRect.bottom;
    } else if (m_direction[2] == 1 && m_direction[3] == 1) {
        scaleCenterX = m_fixInputCropRect.left;
        scaleCenterY = m_fixInputCropRect.top;
    } else {
        scaleCenterX = m_fixInputCropRect.right;
        scaleCenterY = m_fixInputCropRect.top;
    }
    *centerX = scaleCenterX;
    *centerY = scaleCenterY;
}

void HveCmdReverseCrop::CalScaleCenterForDragSide3(double *centerX, double *centerY)
{
    double scaleCenterX;
    double scaleCenterY;
    if (m_direction[2] == 0) {
        scaleCenterX = m_fixInputCropRect.right;
        scaleCenterY = m_fixInputCropRect.top + m_fixInputCropRect.Height() / 2;
    } else if (m_direction[3] == 0) {
        scaleCenterX = m_fixInputCropRect.left + m_fixInputCropRect.Width() / 2;
        scaleCenterY = m_fixInputCropRect.bottom;
    } else if (m_direction[0] == 0) {
        scaleCenterX = m_fixInputCropRect.left;
        scaleCenterY = m_fixInputCropRect.top + m_fixInputCropRect.Height() / 2;
    } else {
        scaleCenterX = m_fixInputCropRect.left + m_fixInputCropRect.Width() / 2;
        scaleCenterY = m_fixInputCropRect.top;
    }
    *centerX = scaleCenterX;
    *centerY = scaleCenterY;
}

int HveCmdReverseCrop::GetChangedSide()
{
    int number = 0;
    for (int i = 0; i < m_direction.size(); i++) {
        if (m_direction[i] == 1) {
            number++;
        }
    }
    return number;
}

void HveCmdReverseCrop::ReverseCropAfter(HveTimeline *timeline, HmcUid assetUid)
{
    HmcRectD outputRect = HveAssetOper::CheckCropRectBoundary(timeline->GetCropOperationArea(), m_outputCropRect);
    timeline->SetCropRect(outputRect);
    timeline->SetCropLimitation(outputRect);
    LOGI("[ReverseCrop]Set cropRect=[%lf, %lf, %lf, %lf].", outputRect.left, outputRect.top, outputRect.right,
        outputRect.bottom);

    HmcSize size;
    HmcAssetGetSize(timeline->GetEditor(), assetUid, HMC_SIZE_RENDER, &size);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    hveAsset->SetBaseRotationAssetSize(size.width, size.height);
    float posX;
    float posY;
    HmcAssetGetPositionByCenter(timeline->GetEditor(), assetUid, &posX, &posY);
    hveAsset->SetAssetSizeAndPosXY(size.width, size.height, posX, posY, true);
}

int HveCmdRotate90Acw::CalculateRotation(HmcRectD &cropRect, int &isHorizontalMirror, UndoRedoCommandType &commandType,
    float &canvasWidth, float &canvasHeight, std::function<void(std::string const & jsonPos)> &cb)
{
    USE_ASSET(HMC_ERR);

    float calPosX;
    float calPosY;
    HmcAssetGetPositionByCenter(timeline->GetEditor(), assetUid, &calPosX, &calPosY);

    float baseOffsetX = (static_cast<float>(cropRect.CenterX()) - canvasWidth / 2) * 2;
    if (isHorizontalMirror) {
        calPosX = calPosX + baseOffsetX;
    }

    calPosX = canvasWidth / g_two + calPosX;
    calPosY = canvasHeight / g_two - calPosY;

    int clickTimes = hveAsset->GetClick90AckTimes();
    float degree = (90 * clickTimes) % 360; // 正值：逆时针，负值：顺时针
    if ((isHorizontalMirror && commandType != COMMAND_UNDO) || ((!isHorizontalMirror && commandType == COMMAND_UNDO))) {
        degree = -degree;
    }
    float rad = degree * MathUtils::PI / 180; // 弧度

    // 裁剪框中心a点以素材中心o点为中心逆时针旋转rad弧度后得到b点
    float ox = calPosX;
    float oy = -calPosY;
    float ax = cropRect.CenterX();
    float ay = -cropRect.CenterY();
    float bx = (ax - ox) * cos(rad) - (ay - oy) * sin(rad) + ox;
    float by = (ax - ox) * sin(rad) + (ay - oy) * cos(rad) + oy;
    LOGD("o=%lf,%lf a=%lf,%lf b=%lf,%lf degree=%lf", ox, oy, ax, ay, bx, by, degree);

    // 素材进行移动补偿，使b点移动到a点位置
    calPosX += (ax - bx);
    calPosY -= (ay - by);
    HmcAssetPoint assetPosition = {(calPosX - canvasWidth / 2), (canvasHeight / 2 - calPosY)};
    CalculateScaling(cropRect, assetPosition, canvasWidth, canvasHeight, baseOffsetX,
        isHorizontalMirror, commandType, cb);
    return HMC_OK;
}

int HveCmdRotate90Acw::CalculateScaling(HmcRectD &cropRect, HmcAssetPoint &assetPosition, float &canvasWidth,
    float &canvasHeight, float &baseOffsetX, int &isHorizontalMirror, UndoRedoCommandType &commandType,
    std::function<void(std::string const & jsonPos)> &cb)
{
    USE_ASSET(HMC_ERR);
    int clickTimes = hveAsset->GetClick90AckTimes();
    bool isDefaultRectRatio = (clickTimes % 2) == 0 ? true : false;
    auto oldRectD = timeline->GetCropRect();
    auto scale = isDefaultRectRatio
                     ? 1.0f
                     : (HveAssetOper::GetAssetScaleForRotate90Acw(oldRectD, cropRect.Width(), cropRect.Height()));
    HmcSize size;
    HmcAssetGetSize(timeline->GetEditor(), assetUid, HMC_SIZE_RENDER, &size);
    HveTransformUtil::CalcAssetPositionAfterScale(assetPosition, cropRect, scale, &size, timeline->GetEditor());
    if (isHorizontalMirror) {
        assetPosition.x = assetPosition.x - baseOffsetX;
    }
    auto newRotation2 = hveAsset->GetRotation(HMC_AXIS_Z);
    if (commandType != COMMAND_EXECUTE) {
        return UndoRedoRotate90Acw(scale, newRotation2, size, assetPosition, cropRect);
    }
    hveAsset->SetBaseRotationAssetSize(size.width, size.height);
    hveAsset->SetAssetSize(size.width, size.height);
    RotationPreview(cropRect, scale, size, assetPosition, cb);
    return HMC_OK;
}

int HveCmdRotate90Acw::RotationPreview(HmcRectD &cropRect, auto &scale, HmcSize &size, HmcAssetPoint &assetPosition,
    std::function<void(std::string const & jsonPos)> &cb)
{
    USE_ASSET(HMC_ERR);
    int clickTimes = hveAsset->GetClick90AckTimes();
    LOGI("CurrenclickTimes is clickTimes=%d ", clickTimes);
    float srcRotation = (clickTimes > 1) ? hveAsset->GetClick90AckPreviewRotation() : 0.0F;
    float srcPreScale = (clickTimes > 1) ? hveAsset->GetClick90AckPreviewScale() : 1.0F;

    bool previewMode;
    if (clickTimes > 1) {
        previewMode = hveAsset->GetClick90AckInPreviewMode();
    } else {
        previewMode = hveAsset->GetInPreviewMode();
        hveAsset->SetClick90AckInPreviewMode(previewMode);
    }
    
    double previewModeScale =
        previewMode ? hveAsset->CalcPreviewModeAssetScale(cropRect, timeline->GetCropOperationArea()) : 1.0;
    int refreshRate = hveAsset->GetRefreshRate();
    postAnimation(
        [timeline, assetUid, scale, size, assetPosition, cb, cropRect, previewMode, previewModeScale, clickTimes,
         srcRotation, srcPreScale, this](float progress, bool startFlag) {
            auto editor = timeline->GetEditor();
            auto hveAsset = timeline->GetHveAsset(assetUid);
            if (editor == nullptr || hveAsset == nullptr) {
                LOGE("editor or asset is null.");
                return;
            }

            HmcEditorSetAutoFlush(editor, false);
            if (fabs(progress - 1.0) < DOUBLE_PRECISION) {
                BackgroundTask(size, assetPosition, cropRect, previewMode, cb);
            } else {
                if (startFlag && previewMode) {
                    timeline->SwitchPreviewMode();
                }
                auto previewOffsetX = hveAsset->GetPreviewOffsetX();
                auto previewOffsetY = hveAsset->GetPreviewOffsetY();
                auto newScale = srcPreScale + (scale * previewModeScale - srcPreScale) * progress;
                auto rotation = srcRotation + (90 * clickTimes - srcRotation) * progress;
                LOGI("CurrenRotation is clickTimes=%d , srcRotation=%lf, rotation=%lf, progress=%lf", clickTimes,
                    srcRotation, rotation, progress);
                HmcAssetCropTransformSetPosition(editor, assetUid, previewOffsetX, previewOffsetY, newScale, newScale,
                                                 rotation);
                hveAsset->SetClick90AckPreviewScale(newScale);
                hveAsset->SetClick90AckPreviewRotation(rotation);
                HmcEditorSetAutoFlush(editor, true);
            }
        },
        g_animationTime, refreshRate);
    hveAsset->SetRefreshThumbnails(TRUE);
    return HMC_OK;
}

int HveCmdRotate90Acw::BackgroundTask(const HmcSize &size, const HmcAssetPoint &assetPosition,
    const HmcRectD &cropRect, bool previewMode, const std::function<void(std::string const & jsonPos)> &cb)
{
    // 判断连续旋转只有最后一次再走回调
    if (frame < m_lastRotateFrame) {
        LOGI("Asset rotate90Acw result not the last, frame=%d, lastFrame=%d", frame, m_lastRotateFrame);
        return HMC_OK;
    }
    m_isRotateReseting = true;
    m_lastRotateResetingTime = HmcGetCurrTimeMillSec();
    USE_ASSET(HMC_ERR);
    auto newRotation = hveAsset->GetRotation(HMC_AXIS_Z);
    HmcAssetSetRotation(editor, assetUid, newRotation, HMC_AXIS_Z);
    HmcAssetSetSize(editor, assetUid, size);
    HmcAssetSetPositionByCenter(editor, assetUid, assetPosition.x, assetPosition.y);
    timeline->SetCropRect(cropRect);
    hveAsset->SetInPreviewMode(false);
    if (previewMode) {
        hveAsset->SwitchPreviewMode(cropRect, timeline->GetCropOperationArea());
    } else {
        hveAsset->UpdatePreviewMode(cropRect, timeline->GetCropOperationArea(), false);
    }
    HmcEditorSetAutoFlush(editor, true);
    hveAsset->ResetRotate90AcwTempValue();
    BACKGROUND_TASK_MGR->Submit([timeline, editor, hveAsset, cropRect, cb, previewMode, this] {
        Json::Value json;
        Json::FastWriter fastWriter;
        json["left"] = cropRect.left;
        json["top"] = cropRect.top;
        json["right"] = cropRect.right;
        json["bottom"] = cropRect.bottom;
        LOGI("Asset rotate90Acw result frame=%d, rect=%s", frame, fastWriter.write(json).c_str());
        m_isRotateReseting = false;
        cb(fastWriter.write(json));
    },
        __FUNCTION__);
    return HMC_OK;
}

bool HveCmdRotate90Acw::IsRotateReseting()
{
    LOGI("Asset rotate90Acw result reseting IsRotateReseting, lastTime = %u", m_lastRotateResetingTime);
    if (!m_isRotateReseting) {
        return false;
    }
    LOGI("Asset rotate90Acw result reseting check timeout, lastTime = %u", m_lastRotateResetingTime);
    return int(HmcGetCurrTimeMillSec() - m_lastRotateResetingTime) < g_MillForOneSecond; 
}

void HveCmdRotate90Acw::SetLastRotateFrame(int lastRotateFrame)
{
    m_lastRotateFrame = lastRotateFrame;
}