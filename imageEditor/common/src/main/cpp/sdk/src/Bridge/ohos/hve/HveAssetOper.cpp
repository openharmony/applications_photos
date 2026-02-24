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

#include "HveAssetOper.h"
#include "ohos/BackgroundTaskManager.h"
#include "ohos/hve/animation/HveAnimationBase.h"
#include "ohos/hve/animation/updatecanvas/HveUpdOperAreaWithCrop2Prev.h"
#include "ohos/hve/animation/updatecanvas/HveUpdOperAreaWithPrev2Prev.h"
#include "ohos/hve/animation/updatecanvas/HveUpdOperAreaWithPrev2Crop.h"
#include "ohos/hve/animation/updatecanvas/HveUpdateOperationArea.h"
#include "ohos/util/ExifTransformUtil.h"

const double MIN_DIFF = 0.001;
const double MIN_SCALE = 0.0001;
const int g_two = 2;

bool HveAssetOper::AssetSizeIsExchanged(float baseRotation)
{
    if (baseRotation == 90 || baseRotation == 270) {
        return true;
    }
    return false;
}

void HveAssetOper::SetPosition(HveTimeline *timeline, HmcUid assetUid, float posX, float posY, float width,
    float height, double animMs, bool needAutoFlush, const HmcRectD &cropRect)
{
    auto hmcEditor = timeline->GetEditor();

    float startX;
    float startY;
    HmcAssetGetPositionByCenter(hmcEditor, assetUid, &startX, &startY);
    HmcSize size;
    HmcAssetGetSize(hmcEditor, assetUid, HMC_SIZE_RENDER, &size);
    float startW = size.width;
    float startH = size.height;
    float destX = posX;
    float destY = posY;
    float destW = width;
    float destH = height;
    
    auto hveAsset = timeline->GetHveAsset(assetUid);
    int refreshRate = hveAsset->GetRefreshRate();
    HmcAssetSetDestSize(hmcEditor, assetUid, {width, height});

    postAnimation(
        [timeline, assetUid, startX, startY, startW, startH, destX, destY, destW, destH,
         needAutoFlush](float progress, bool startFlag) {
            auto editor = timeline->GetEditor();
            if (needAutoFlush) {
                HmcEditorSetAutoFlush(editor, false);
            }

            float curX = startX + (destX - startX) * progress;
            float curY = startY + (destY - startY) * progress;
            float curW = startW + (destW - startW) * progress;
            float curH = startH + (destH - startH) * progress;
            HmcAssetSetPositionByCenter(editor, assetUid, curX, curY);
            HmcSize size;
            size.width = curW;
            size.height = curH;
            HmcAssetSetSize(editor, assetUid, size);
            if (needAutoFlush) {
                HmcEditorSetAutoFlush(editor, true);
            }

            if (fabsf(progress - 1.0f) < DOUBLE_PRECISION) {
                HveAssetOper::ProcessEndCb(timeline, assetUid);
            }
        },
        (UINT64)animMs, refreshRate);
}

void HveAssetOper::GetCenterInsideRectUnderRatio(float dstRatio, const HmcRectD &rect, HmcRectD *outputRect)
{
    if (outputRect == nullptr) {
        return;
    }
    float rectRatio = rect.Width() / rect.Height();
    float assetWidth;
    float assetHeight;
    if (dstRatio > rectRatio) {
        assetWidth = rect.Width();
        assetHeight = assetWidth / dstRatio;
    } else {
        assetHeight = rect.Height();
        assetWidth = assetHeight * dstRatio;
    }
    float offsetX = (rect.Width() - assetWidth) / 2;
    float offsetY = (rect.Height() - assetHeight) / 2;
    outputRect->left = rect.left + offsetX;
    outputRect->top = rect.top + offsetY;
    outputRect->right = rect.right - offsetX;
    outputRect->bottom = rect.bottom - offsetY;
}

void HveAssetOper::ResetPosition(HveTimeline *timeline, HmcUid &assetUid)
{
    auto editor = timeline->GetEditor();
    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);
    float assetRatio = originalSize.width / originalSize.height;

    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("ResetPosition, asset is null.");
        return;
    }

    auto cropOperationArea = timeline->GetCropOperationArea();

    HmcRectD cropRect(0, 0, 0, 0);
    GetCenterInsideRectUnderRatio(assetRatio, cropOperationArea, &cropRect);

    HmcAssetSetRotation(editor, assetUid, 0, HMC_AXIS_X);
    HmcAssetSetRotation(editor, assetUid, 0, HMC_AXIS_Y);
    HmcAssetSetRotation(editor, assetUid, 0, HMC_AXIS_Z);
    hveAsset->SetBaseRotation(0);

    float canvasWidth;
    float canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);

    float posX = cropRect.CenterX() - canvasWidth / 2;
    float posY = canvasHeight / 2 - cropRect.CenterY();
    float width = cropRect.Width();
    float height = cropRect.Height();
    HmcEditorSetAutoFlush(editor, false);
    HmcAssetSetMirror(editor, assetUid, false, HMC_ASSET_MIRROR_HORIZONTAL);
    SetPosition(timeline, assetUid, posX, posY, width, height, 0, true, cropRect);
    timeline->SetCropRect(cropRect);
    hveAsset->SetAssetInitSize(width, height);
    hveAsset->SetAssetInitPosXY(posX, posY);
    hveAsset->SetRotation(0, HMC_AXIS_X, false);
    hveAsset->SetRotation(0, HMC_AXIS_Y, false);
    hveAsset->SetRotation(0, HMC_AXIS_Z, true);
    hveAsset->SetMirror(false);
    HmcEditorSetAutoFlush(editor, true);
}

HmcUid HveAssetOper::FindEffectByType(HmcEditor *editor, HmcUid assetUid, HmcEffectType type)
{
    int count = (int)HmcEffectGetEffectCount(editor, assetUid, type);
    if (count != 1) {
        LOGD("FindEffectByType: HmcEffectGetEffectCount failed");
        return HMC_UID_NULL;
    }

    HmcUid *effectUidArr = (HmcUid *)malloc(sizeof(HmcUid) * count);
    if (!effectUidArr) {
        LOGD("FindEffectByType: effectUidArr is NULL");
        return HMC_UID_NULL;
    }

    memset_s(effectUidArr, sizeof(HmcUid) * count, 0, sizeof(HmcUid) * count);

    if (HmcEffectGetEffects(editor, assetUid, type, effectUidArr, count) != HMC_OK) {
        LOGD("FindEffectByType: HmcEffectGetEffects failed");
        free(effectUidArr);
        return HMC_UID_NULL;
    }

    HmcUid result = effectUidArr[0];
    free(effectUidArr);
    return result;
}

void HveAssetOper::InitAsset(HveTimeline *timeline, HmcUid &assetUid)
{
    auto editor = timeline->GetEditor();
    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);
    float assetRatio = originalSize.width / originalSize.height;

    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("InitAsset, asset is null.");
        return;
    }

    auto cropOperationArea = timeline->GetCropOperationArea();

    HmcRectD cropRect(0, 0, 0, 0);
    GetCenterInsideRectUnderRatio(assetRatio, cropOperationArea, &cropRect);
    LOGD("SetCropRectInner Init cropRect=%lf,%lf,%lf,%lf", cropRect.left, cropRect.top, cropRect.right,
        cropRect.bottom);
    timeline->SetCropRect(cropRect);
    timeline->SetCropLimitation(cropRect);
    timeline->SetCropRectDefault(cropRect);
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);

    double posX = cropRect.CenterX() - canvasWidth / 2;
    double posY = canvasHeight / 2 - cropRect.CenterY();
    double width = cropRect.Width();
    double height = cropRect.Height();
    HmcEditorSetAutoFlush(editor, false);
    HmcAssetSetPositionByCenter(editor, assetUid, posX, posY);
    HmcSize size;
    size.width = width;
    size.height = height;
    HmcAssetSetSize(editor, assetUid, size);
    hveAsset->SwitchPreviewMode(cropRect, timeline->GetCropOperationArea());

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset->GetType() == HMC_ASSET_IMAGE) {
        hveAsset->SwitchCropMode();
    }

    hveAsset->SetAssetInitSize(width, height);
    hveAsset->SetAssetInitPosXY(posX, posY);
    // EXIF 信息渲染
    ExifTransformUtil::ProcessExifOnExist(timeline, assetUid, false, false);
    HmcEditorSetAutoFlush(editor, true);
    BACKGROUND_TASK_MGR->Submit([editor, assetUid]() {
        HmcAssetDelayInit(editor, assetUid);
    },
        __FUNCTION__);
}

void HveAssetOper::UpdateAsset(HveTimeline *timeline, const HmcUid &assetUid, HmcSize newCanvasSize,
    const HmcRectD &oldCropOperationArea, bool isDeviceVertical, int animationType)
{
    AnimationType type = (AnimationType)animationType;
    switch (type) {
        case ONLY_UPDATE_OPERATION_AREA: {
            auto updateOperationArea = std::make_shared<HveUpdateOperationArea>(timeline, assetUid, newCanvasSize,
                oldCropOperationArea, isDeviceVertical, type);
            updateOperationArea->Execute();
        }
            break;
        case UPD_OPER_AREA_CROP_TO_PREV: {
            auto updOperAreaCrop2Prev = std::make_shared<HveUpdOperAreaWithCrop2Prev>(timeline, assetUid, newCanvasSize,
                oldCropOperationArea, isDeviceVertical, type);
            updOperAreaCrop2Prev->Execute();

            auto editorImp = static_cast<HmcEditorImp *>(timeline->GetEditor());
            if (editorImp != nullptr) {
                editorImp->OnDisplayAreaChanged();
            }
        }
            break;
        case UPD_OPER_AREA_PREV_TO_CROP: {
            HmcAssetCancelThumbnail(timeline->GetEditor(), assetUid);

            auto updOperAreaPrev2Crop = std::make_shared<HveUpdOperAreaWithPrev2Crop>(timeline, assetUid, newCanvasSize,
                oldCropOperationArea, isDeviceVertical, type);
            updOperAreaPrev2Crop->Execute();
        }
            break;
        case UPD_OPER_AREA_PREV_TO_PREV: {
            auto updOperAreaPrev2Prev = std::make_shared<HveUpdOperAreaWithPrev2Prev>(timeline, assetUid, newCanvasSize,
                oldCropOperationArea, isDeviceVertical, type);
            updOperAreaPrev2Prev->Execute();
        }
            break;
        default:
            LOGE("Animation type invalid.");
    }
}

void HveAssetOper::UpdateAssetDefaultArea(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &cropOperationArea,
    HmcSize newCanvasSize, HmcSize oldCanvasSize)
{
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("asset is null.");
        return;
    }

    auto oldDefaultCropRect = timeline->GetDefaultCropRect();
    HmcRectD defaultCropRect(0, 0, 0, 0);
    auto whRatio = oldDefaultCropRect.Width() / oldDefaultCropRect.Height();
    HveAssetOper::GetCenterInsideRectUnderRatio(static_cast<float>(whRatio), cropOperationArea, &defaultCropRect);
    LOGD("SetDefaultCropRect(%lf,%lf,%lf,%lf)", defaultCropRect.left, defaultCropRect.top, defaultCropRect.right,
        defaultCropRect.bottom);
    timeline->SetCropRectDefault(defaultCropRect);

    int isHorizontalMirror;
    HmcAssetGetMirror(timeline->GetEditor(), assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    UpdateAssetArea area = {oldCanvasSize, newCanvasSize, oldDefaultCropRect, defaultCropRect};
    HveAssetOper::UpdateAssetDefaultInfo(hveAsset, area, isHorizontalMirror);
}


void HveAssetOper::UpdatePreviewModeAsset(HveTimeline *timeline, HmcUid &assetUid, const HmcRectD &oldCropRect,
    const HmcRectD &newCropRect, const HmcRectD &oldCropOperationArea, HmcSize oldCanvasSize, float cropScale)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    LOGI("CalPreviewAssetPos. cropScale=%f", cropScale);

    HmcAssetPoint previewPos =
        HveAssetOper::CalPreviewAssetPos(timeline, assetUid, oldCropRect, newCropRect, oldCanvasSize, cropScale);
    auto previewScale = hveAsset->GetPreviewScale();
    auto old2PreModeScale = hveAsset->CalcPreviewModeAssetScale(oldCropRect, oldCropOperationArea);
    LOGI("CalPreviewAssetPos. previewScale=%f old2PreModeScale=%f", previewScale, old2PreModeScale);
    auto basePreviewScale = previewScale / old2PreModeScale;
    auto new2PreModeScale = hveAsset->CalcPreviewModeAssetScale(newCropRect, timeline->GetCropOperationArea());
    auto newPreviewScale = basePreviewScale * new2PreModeScale;
    LOGI("CalPreviewAssetPos. newPreviewScale=%f new2PreModeScale=%f", newPreviewScale, new2PreModeScale);

    float left = static_cast<float>(newCropRect.left) / canvasWidth;
    float top = 1 - static_cast<float>(newCropRect.top) / canvasHeight;
    float right = static_cast<float>(newCropRect.right) / canvasWidth;
    float bottom = 1 - static_cast<float>(newCropRect.bottom) / canvasHeight;
    HmcAssetCropPosition cropPosition = { { left, top }, { left, bottom }, { right, top }, { right, bottom } };
    HmcAssetCropTransformSetCrop(editor, assetUid, &cropPosition);
    HmcAssetCropTransformSetPosition(editor, assetUid, previewPos.x, previewPos.y, newPreviewScale, newPreviewScale, 0);
    hveAsset->SetPreviewOffsetX(previewPos.x);
    hveAsset->SetPreviewOffsetY(previewPos.y);
    hveAsset->SetPreviewScale(newPreviewScale);
}

HmcAssetPoint HveAssetOper::CalPreviewAssetPos(HveTimeline *timeline, HmcUid &assetUid, const HmcRectD &oldCropRect,
    const HmcRectD &newCropRect, HmcSize oldCanvasSize, float cropScale)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    float canvasWidth;
    float canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    LOGI("CalPreviewAssetPos. previewOffsetY=%f ", hveAsset->GetPreviewOffsetY());

    auto previewScale = hveAsset->GetPreviewScale();
    auto new2PreModeScale = hveAsset->CalcPreviewModeAssetScale(newCropRect, timeline->GetCropOperationArea());
    //前preOffsetX 与  preOffsetY的计算，暂时不考虑水印对x轴的移动影响,因为现有的水印都是左右对称的
    float preOffsetX = hveAsset->GetPreviewOffsetX() -
                       (static_cast<float>(oldCropRect.CenterX()) - oldCanvasSize.width / 2);
    float preOffsetY = hveAsset->GetPreviewOffsetY() -
                       (oldCanvasSize.height / 2 - static_cast<float>(oldCropRect.CenterY()) / 2);
    //baseOffsetX 与 baseOffsetY的计算，暂时不考虑水印对x轴的移动影响,因为现有的水印都是左右对称的
    float baseOffsetX = static_cast<float>(newCropRect.CenterX() - canvasWidth / 2);
    float baseOffsetY = static_cast<float>(canvasHeight / 2 - newCropRect.CenterY() / 2);
    HmcAssetPoint previewPos;
    previewPos.x = preOffsetX * cropScale + baseOffsetX;
    previewPos.y = preOffsetY * cropScale + baseOffsetY;
    LOGI("CalPreviewAssetPos. previewPos.y=%f preOffsetY=%f cropScale=%f baseOffsetY=%f", previewPos.y, preOffsetY,
         cropScale, baseOffsetY);
    return previewPos;
}

HmcRectD HveAssetOper::SetCropRectInner(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &rect,
    const HmcRectD &cropOperationArea, double animMs, int type, bool needAutoFlush, bool isRotationOper)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("asset or cropOperationArea is null");
        return HmcRectD(0, 0, 0, 0);
    }

    HmcRectD cropRect(0, 0, 0, 0);
    GetCenterInsideRectUnderRatio(rect.Width() / rect.Height(), cropOperationArea, &cropRect);

    // 防止重复计算导致裁剪框坐标误差扩大
    auto oldCropRect = timeline->GetCropRect();
    if (cropRect.IsSameRect(oldCropRect)) {
        cropRect = oldCropRect;
    }

    float offsetX = cropRect.CenterX() - rect.CenterX();
    int isHorizontalMirror = 0;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    if (isHorizontalMirror) {
        offsetX = -offsetX;
    }
    float offsetY = cropRect.CenterY() - rect.CenterY();
    float posX, posY;
    HmcAssetGetPositionByCenter(editor, assetUid, &posX, &posY);
    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    LOGI("SetCropRectInner canvas=%lf,%lf, offset=%lf,%lf", canvasWidth, canvasHeight, offsetX, offsetY);

    HmcRectD assetPos(posX - size.width / 2, -posY - size.height / 2, posX + size.width / 2, -posY + size.height / 2);
    assetPos.Translate(canvasWidth / 2, canvasHeight / 2);
    assetPos.Translate(offsetX, offsetY);

    LOGI("cropRect=%lf,%lf rect=%lf,%lf", cropRect.Width(), cropRect.Height(), rect.Width(), rect.Height());
    double ratioX = cropRect.Width() / rect.Width();
    double ratioY = cropRect.Height() / rect.Height();
    double scale = HMC_MIN(ratioX, ratioY);
    // 解决小角度旋转时裁剪框左上、右下角在素材坐标外的误差问题，放大10^5倍向上取整再缩小10^5
    if (isRotationOper && scale > 1.0) {
        scale = HMC_MAX(ratioX, ratioY);
        scale = ceil(scale * 100000) / 100000;
    }

    LOGI("SetCropRectInner old assetPos=%lf,%lf size=%lf,%lf, scale=%lf", posX, posY, size.width, size.height, scale);
    
    SetNewAssetSize(editor, assetUid, size, scale);
    
    if (isHorizontalMirror) {
        assetPos.Scale(scale, canvasWidth - cropRect.CenterX(), cropRect.CenterY());
    } else {
        assetPos.Scale(scale, cropRect.CenterX(), cropRect.CenterY());
    }

    SetPositionXY(timeline, assetPos, canvasWidth, canvasHeight, hveAsset, cropRect, assetUid, animMs, needAutoFlush,
        rect, type, isRotationOper);
    return timeline->GetCropRect();
}

void HveAssetOper::SetNewAssetSize(HmcEditor *editor, HmcUid assetUid, HmcSize size, double scale)
{
    HmcSize newSize;
    newSize.width = size.width * scale;
    newSize.height = size.height * scale;
    
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("get asset object failed, please check your asset id");
        return;
    }
    auto visionAsset = (HmcVisionAsset *)asset;
    visionAsset->HmcAssetSetCurSize(newSize);
    LOGD("SetNewAssetSize assetSize=%lf,%lf, scale=%lf", size.width, size.height, scale);
}

void HveAssetOper::SetPositionXY(HveTimeline *timeline, HmcRectD &assetPos, float canvasWidth, float canvasHeight,
                                 auto hveAsset, HmcRectD &cropRect, HmcUid &assetUid, double animMs, bool needAutoFlush,
                                 const HmcRectD &rect, int type, bool isRotationOper)
{
    float newPosX = assetPos.CenterX() - canvasWidth / 2;
    float newPosY = canvasHeight / 2 - assetPos.CenterY();
    float assetWidth = assetPos.Width();
    float assetHeight = assetPos.Height();
    // 多次旋转归零后，SDK浮点计算的误差会累计，导致保存按钮高亮。此处增加默认值修复逻辑，如果素材回到默认大小时，SDK值恢复初始值
    if (!hveAsset->IsAssetPosChangeAndFix(&assetWidth, &assetHeight, &newPosX, &newPosY, cropRect.Width(),
                                          cropRect.Height())) {
        LOGD("SetCropRectInner fix cropRect default size");
        HveAssetOper::FixDefaultCropRect(timeline, assetUid, &cropRect);
    }

    HveAssetOper::SetPosition(timeline, assetUid, newPosX, newPosY, assetWidth, assetHeight, animMs, needAutoFlush,
                              cropRect);
    LOGD("SetCropRectInner new assetPos=%f,%f size=%f,%f", newPosX, newPosY, assetWidth, assetHeight);

    timeline->SetCropRect(cropRect);
    LOGI("SetCropRectInner cropRect=%lf,%lf,%lf,%lf", cropRect.left, cropRect.top, cropRect.right, cropRect.bottom);
    HveAssetOper::UpdateCropLimitation(timeline, rect, cropRect, type);
    if (!isRotationOper) {
        hveAsset->SetBaseRotationAssetSize(assetWidth, assetHeight);
    }

    hveAsset->SetAssetSizeAndPosXY(assetWidth, assetHeight, newPosX, newPosY, !isRotationOper);
}

void HveAssetOper::FixDefaultCropRect(HveTimeline *timeline, HmcUid assetUid, HmcRectD *outputRect)
{
    auto editor = timeline->GetEditor();
    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);
    float assetRatio = originalSize.width / originalSize.height;

    auto cropOperationArea = timeline->GetCropOperationArea();

    GetCenterInsideRectUnderRatio(assetRatio, cropOperationArea, outputRect);
}

void HveAssetOper::UpdateCropLimitation(HveTimeline *timeline, const HmcRectD &rect, const HmcRectD &cropRect, int type)
{
    float ratioX = cropRect.Width() / rect.Width();
    float ratioY = cropRect.Height() / rect.Height();
    float scale = HMC_MIN(ratioX, ratioY);

    // type为1时表示固定比例裁剪，对cropLimitation进行等比缩放；其他场景cropLimitation取当前裁剪框坐标
    if (type == 1) {
        timeline->Scale(scale);
    } else {
        timeline->SetCropLimitation(cropRect);
    }
}

void HveAssetOper::UpdateCropLimitation(HveTimeline *timeline, const HmcRectD &oldCropRect, const HmcRectD &newCropRect,
    const HmcRectD &cropLimitation, double cropScale)
{
    if (cropLimitation.IsSameRect(oldCropRect)) {
        timeline->SetCropLimitation(newCropRect);
    } else {
        double newCropLimitationWidth = cropLimitation.Width() * cropScale;
        double newCropLimitationHeight = cropLimitation.Height() * cropScale;
        HmcRectD newCropLimitation(newCropRect.CenterX() - newCropLimitationWidth / 2,
            newCropRect.CenterY() - newCropLimitationHeight / 2, newCropRect.CenterX() + newCropLimitationWidth / 2,
            newCropRect.CenterY() + newCropLimitationHeight / 2);
        timeline->SetCropLimitation(newCropLimitation);
    }
}

/**
 * 求原始rect在vertex顶点组成的不规则凸四边形范围内，在满足给定的约束规则rule（线性规划）下的最优解
 * @param vertex 素材4个顶点的x、y坐标位置，个数为8个
 * @param rule 约束规则rule（线性规划）
 * @param input 原始rect（裁剪框）
 * @param output 根据rule求出来一个最优解区域
 * @return true表示有最优解，false表示无最优解
 */
bool HveAssetOper::CalcOptimalCropRect(float *vertex, std::function<bool(float *, float *, float *)> rule, float *input,
                                       size_t inputSize, float *output, size_t outputSize, int watermarkType)
{
    if (input == nullptr || output == nullptr) {
        return false;
    }
    float left = input[0];
    float top = input[1];
    float right = input[2];
    float bottom = input[3];
    LOGI("calcOptimalCropRect input=%lf,%lf,%lf,%lf vertex=%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf", left, top, right, bottom,
        vertex[0], vertex[1], vertex[2], vertex[3], vertex[4], vertex[5], vertex[6], vertex[7]);

    // 对异常值进行过滤及保留2位小数
    for (int i = 0; i < 8; i++) {
        if (abs(vertex[i]) > 10e10) {
            LOGE("calcOptimalCropRect failed, some parameter is out of range");
            return false;
        }
    }

    // 边缘吸附，避免上层转换的rect与OpenGL获取的vertex计算精度存在微弱差异问题
    if (abs(left - HMC_MAX(vertex[0], vertex[6])) < 1e-2) {
        left = HMC_MAX(vertex[0], vertex[6]);
    }
    if (abs(top - HMC_MAX(vertex[1], vertex[3])) < 1e-2) {
        top = HMC_MAX(vertex[1], vertex[3]);
    }
    if (abs(right - HMC_MIN(vertex[2], vertex[4])) < 1e-2) {
        right = HMC_MIN(vertex[2], vertex[4]);
    }
    if (abs(bottom - HMC_MIN(vertex[5], vertex[7])) < 1e-2) {
        bottom = HMC_MIN(vertex[5], vertex[7]);
    }

    // UI坐标系转换到数学坐标系
    top = -top;
    bottom = -bottom;
    vertex[1] = -vertex[1];
    vertex[3] = -vertex[3];
    vertex[5] = -vertex[5];
    vertex[7] = -vertex[7];

    // corners和rect值都转换到大于0的值后进行运算
    float minLeft = HMC_MIN(left, HMC_MIN(vertex[0], vertex[6]));
    float minBottom = HMC_MIN(bottom, HMC_MIN(vertex[5], vertex[7]));
    left -= minLeft;
    right -= minLeft;
    vertex[0] -= minLeft;
    vertex[2] -= minLeft;
    vertex[4] -= minLeft;
    vertex[6] -= minLeft;
    top -= minBottom;
    bottom -= minBottom;
    vertex[1] -= minBottom;
    vertex[3] -= minBottom;
    vertex[5] -= minBottom;
    vertex[7] -= minBottom;

    float *corners = vertex;
    LOGI("calcOptimalCropRect coners=%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf", corners[0], corners[1], corners[2], corners[3],
        corners[4], corners[5], corners[6], corners[7]);
    float inputRect[] = {static_cast<float>(left), static_cast<float>(top), static_cast<float>(right),
                         static_cast<float>(bottom)};
    LOGI("calcOptimalCropRect input=%lf,%lf,%lf,%lf", inputRect[0], inputRect[1], inputRect[2], inputRect[3]);
    bool succeed = rule(corners, inputRect, output);
    // 艺术签名水印无最优解，使用watermarkType控制
    if (!succeed && (watermarkType == HMC_ASSET_BORDER_STICKER || watermarkType == HMC_ASSET_RENEWAL_STICKER ||
                     watermarkType == HMC_ASSET_FROSTED_STICKER || watermarkType == HMC_ASSET_XT_STYLE_FRAME_STICKER ||
                     watermarkType == HMC_ASSET_PERSONALIZED_STICKER_STYLE1 ||
                     watermarkType == HMC_ASSET_PERSONALIZED_STICKER_STYLE2)) {
        LOGE("calcOptimalCropRect failed.");
        // 值转换为原坐标系
        output[0] += minLeft;
        output[1] += minBottom;
        output[2] += minLeft;
        output[3] += minBottom;
        output[1] = -output[1];
        output[3] = -output[3];
        LOGD("calcOptimalCropRect output=%lf,%lf,%lf,%lf", output[0], output[1], output[2], output[3]);
        return true;
    }
    
    if (!succeed) {
        LOGE("calcOptimalCropRect failed.");
        return false;
    }

    // 值转换为原坐标系
    output[0] += minLeft;
    output[1] += minBottom;
    output[2] += minLeft;
    output[3] += minBottom;
    output[1] = -output[1];
    output[3] = -output[3];
    LOGD("calcOptimalCropRect output=%lf,%lf,%lf,%lf", output[0], output[1], output[2], output[3]);
    return true;
}

bool HveAssetOper::CalcOptimalCropRect(HmcEditor *editor, HmcUid assetUid,
    std::function<bool(float *, float *, float *)> rule, float *input, size_t inputSize, float *output,
    size_t outputSize)
{
    float vertex[8];
    HmcAssetGetVertexPosition(editor, assetUid, vertex, CROP_VERTEX_SIZE);
    return CalcOptimalCropRect(vertex, rule, input, inputSize, output, outputSize, 0);
}

void HveAssetOper::FillPreviewRect(HveTimeline *timeline, HmcUid assetUid, double animMs,
    std::function<bool(float *, float *, float *)> rule)
{
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("asset is null.");
        return;
    }
    auto cropRect = timeline->GetCropRect();

    double scaleSize = hveAsset->CalcPreviewModeAssetScale(cropRect, timeline->GetCropOperationArea());
    cropRect.Scale(scaleSize, cropRect.CenterX(), cropRect.CenterY());

    auto editor = timeline->GetEditor();
    float canvasWidth;
    float canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    HmcRectD rect((canvasWidth - cropRect.Width()) / 2, (canvasHeight - cropRect.Height()) / 2,
        (canvasWidth + cropRect.Width()) / 2, (canvasHeight + cropRect.Height()) / 2);
    auto previewScale = hveAsset->GetPreviewScale();
    auto previewOffsetX = hveAsset->GetPreviewOffsetX();
    auto previewOffsetY = hveAsset->GetPreviewOffsetY();
    rect.Scale(previewScale / scaleSize, rect.CenterX(), rect.CenterY());
    rect.Translate(previewOffsetX, -previewOffsetY);
    float vertex[] = {(float)rect.left,  (float)rect.top,    (float)rect.right, (float)rect.top,
                      (float)rect.right, (float)rect.bottom, (float)rect.left,  (float)rect.bottom};
    float input[] = {(float)cropRect.left, (float)cropRect.top, (float)cropRect.right, (float)cropRect.bottom};
    float output[4] = {0, 0, 0, 0};
    /* 当素材放大倍数超过最大倍数时，素材需要从当倍数回弹到最大倍数。calcOptimalCropRect函数input参数为原始rect（裁剪框），函数作用是在
       当前剪辑内找到和原始rect同等大小的框，由于剪辑会回调到最大倍数，所以如果剪辑大小不变化的情况下，就需要把原始rect放大diffScale倍数(diffScale算法如下：)
     */
    float previewMaxScale = HveAssetOper::CalPreviewMaxScale(timeline, assetUid);
    if (previewScale > previewMaxScale) {
        auto diffScale = previewScale / previewMaxScale;
        auto newCropRect = cropRect;
        newCropRect.Scale(diffScale, newCropRect.CenterX(), newCropRect.CenterY());
        input[0] = (float)newCropRect.left;
        input[1] = (float)newCropRect.top;
        input[2] = (float)newCropRect.right;
        input[3] = (float)newCropRect.bottom;

        double posX = hveAsset->GetGestureCenterX() - canvasWidth / 2 - hveAsset->GetPreviewOffsetX();
        double posY = hveAsset->GetPreviewOffsetY() - (canvasHeight / 2 - hveAsset->GetGestureCenterY());
        previewOffsetX = previewOffsetX + (posX - posX * (1 / diffScale));
        previewOffsetY = previewOffsetY - (posY - posY * (1 / diffScale));
    }
    bool succeed = CalcOptimalCropRect(vertex, rule, input, RECT_SIZE, output, RECT_SIZE, 
                                       hveAsset->CanDrawWatermark() ? hveAsset->GetWatermarkType() : 0);
    LOGD("fillPreviewRect output=%lf,%lf,%lf,%lf", output[0], output[1], output[2], output[3]);
    if (succeed) {
        PreviewAnimation(timeline, assetUid, cropRect, output, scaleSize, previewOffsetX, previewOffsetY, animMs);
    }
}

void HveAssetOper::PreviewAnimation(HveTimeline *timeline, HmcUid assetUid, auto cropRect, float output[],
    double scaleSize, auto previewOffsetX, auto previewOffsetY, double animMs)
{
    auto hveAsset = timeline->GetHveAsset(assetUid);
    auto previewScale = hveAsset->GetPreviewScale();
    float srcScale = hveAsset->GetPreviewScale();
    float dstScale = previewScale * (cropRect.Width() / (output[2] - output[0]));
    if (fabsf(dstScale - 1.0) < MIN_SCALE) {
        dstScale = scaleSize;
    }
    bool isDrawWatermark = hveAsset->GetShowWatermarkValue();
    float wmOffset = 0.0;
    float srcOffsetX = hveAsset->GetPreviewOffsetX();
    float dstOffsetX = previewOffsetX + cropRect.CenterX() - (output[2] + output[0]) / 2;
    float srcOffsetY = hveAsset->GetPreviewOffsetY();
    float dstOffsetY = previewOffsetY - (cropRect.CenterY() - (output[3] + output[1]) / 2) + wmOffset * dstScale;
    LOGD("fillPreviewRect previewScale=%lf previewOffsetX=%lf previewOffsetX=%lf", dstScale, dstOffsetX, dstOffsetY);

    int refreshRate = hveAsset->GetRefreshRate();
    auto editor = timeline->GetEditor();
    postAnimation(
        [editor, hveAsset, assetUid, srcScale, srcOffsetX, srcOffsetY, dstScale, dstOffsetX,
         dstOffsetY, timeline](float progress, bool startFlag) {
            // 偶先小概率 startFlag 无作用， 因此用极小值 做个兜底。
            if (startFlag || progress < DOUBLE_PRECISION) {
                hveAsset->SetIsSwitchPage(true);
            }
            if (fabsf(progress - 1.0) < DOUBLE_PRECISION) { 
                hveAsset->SetIsSwitchPage(false);
            }   
            hveAsset->SetIsDragImage(false);
            HmcEditorSetAutoFlush(editor, false);
            auto newPreviewScale = srcScale + (dstScale - srcScale) * progress;
            auto newPreviewOffsetX = srcOffsetX + (dstOffsetX - srcOffsetX) * progress;
            auto newPreviewOffsetY = srcOffsetY + (dstOffsetY - srcOffsetY) * progress;
            hveAsset->SetPreviewScale(newPreviewScale);
            hveAsset->SetPreviewOffsetX(newPreviewOffsetX);
            hveAsset->SetPreviewOffsetY(newPreviewOffsetY);
            HmcAssetCropTransformSetPosition(editor, assetUid, newPreviewOffsetX, newPreviewOffsetY, newPreviewScale,
                                             newPreviewScale, 0);
            HmcEditorSetAutoFlush(editor, true);

            if (fabsf(progress - 1.0f) < DOUBLE_PRECISION) {
                HveAssetOper::ProcessEndCb(timeline, assetUid);
            }
        },
        animMs, refreshRate);
}

/**
 * 截取/调节/滤镜页面的预览区缩放，满足如下条件时增加震感反馈
 * 1. 缩放比例小于预览区原始尺寸
 * 2. 缩放比例大于最大放大倍数2
 *
 * @param timeline 泳道当前时刻
 * @param assetUid 剪辑的UID
 * @param cropType 剪辑操作类型@CropAssetOperation
 * @param cb       是否有震感反馈
 */
void HveAssetOper::PreviewScaleVibration(HveTimeline *timeline, HmcUid assetUid, CropAssetOperation cropType,
    std::function<void(std::string const & jsonPos)> cb)
{
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("PreviewScaleVibration asset is null.");
        cb(NAPI_JSON_ERROR_RETURN);
        return;
    }

    auto cropRect = timeline->GetCropRect();

    int vibrationStatus = 0;
    float previewScale = hveAsset->GetPreviewScale();
    double scaleSize = hveAsset->CalcPreviewModeAssetScale(cropRect, timeline->GetCropOperationArea());
    float previewMaxScale = HveAssetOper::CalPreviewMaxScale(timeline, assetUid);
    if (cropType == TWO_FINGER_SCALE_END && (previewScale < scaleSize || previewScale > previewMaxScale)) {
        LOGD("PreviewScaleVibration need vibration.");
        vibrationStatus = 1;
    }

    Json::Value json;
    Json::FastWriter fastWriter;
    json["vibration"] = vibrationStatus;
    cb(fastWriter.write(json));
}

/**
 * 按照指定比例对矩形缩放
 *
 * @param scaleSize 缩放比例
 * @param input     未缩放坐标 left bottom right top
 * @param output    缩放后坐标 left bottom right top
 * @return true     缩放成功，false 参数非法，缩放失败
 */
bool HveAssetOper::ScaleRectArray(float scaleSize, float *input, size_t inputSize, float *output, size_t outputSize)
{
    if (input == nullptr || output == nullptr) {
        return false;
    }

    float centerX = (input[0] + input[2]) / 2;
    float centerY = (input[1] + input[3]) / 2;
    output[0] = centerX + (input[0] - centerX) * scaleSize;
    output[1] = centerY + (input[1] - centerY) * scaleSize;
    output[2] = centerX + (input[2] - centerX) * scaleSize;
    output[3] = centerY + (input[3] - centerY) * scaleSize;
    return true;
}

void HveAssetOper::FillCropRect(HveTimeline *timeline, HmcUid assetUid, double animMs, const HmcRectD &cropRect,
    std::function<bool(float *, float *, float *)> rule)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("asset is null.");
        return;
    }

    float input[] = {(float)cropRect.left, (float)cropRect.top, (float)cropRect.right, (float)cropRect.bottom};
    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    if (HveAssetOper::AssetSizeIsExchanged(hveAsset->GetBaseRotation())) {
        std::swap(size.width, size.height);
    }

    float output[4] = {0, 0, 0, 0};
    bool succeed = CalcOptimalCropRect(editor, assetUid, rule, input, RECT_SIZE, output, RECT_SIZE);
    if (succeed) {
        HmcRectD rect(output[0], output[1], output[2], output[3]);
        SetCropRectInner(timeline, assetUid, rect, cropRect, animMs, 0, true, false);
    }
}

void HveAssetOper::FillCropRectForRotation(HveTimeline *timeline, HmcUid assetUid, double animMs,
    const HmcRectD &cropRect, std::function<bool(float *, float *, float *)> rule)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("asset is null.");
        return;
    }

    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    float baseRotationAssetWidth = hveAsset->GetBaseRotationAssetWidth();
    float baseRotationAssetHeight = hveAsset->GetBaseRotationAssetHeight();
    // 影响首次编辑旋转回0缩放，回退修改
    bool baseRotationAssetBigger = size.width > baseRotationAssetWidth || size.height > baseRotationAssetHeight;
    LOGI("FillCropRectForRotation baseRotationAssetBigger=%d, size w=%f,h=%f, baseRotationAsset w=%f,h=%f",
         baseRotationAssetBigger, size.width, size.height, baseRotationAssetWidth, baseRotationAssetHeight);
    float output[4] = {0, 0, 0, 0};
    float input[] = {(float)cropRect.left, (float)cropRect.top, (float)cropRect.right, (float)cropRect.bottom};
    bool succeed = CalcOptimalCropRect(editor, assetUid, rule, input, RECT_SIZE, output, RECT_SIZE);
    if (!succeed) {
        // 矫正后裁剪中心在素材边框外时RotateRule无解，使用MoveRule求移动裁剪框至素材内最近的解
        HveAssetOper::SetCropRectForRotation(timeline, assetUid, cropRect);
        return;
    }

    HmcRectD rotationCropRect(output[0], output[1], output[2], output[3]);

    // 旋转过程中如果裁剪框在素材范围内且素材宽高小于等于旋转前素材大小时，不更新素材大小
    if ((output[2] - output[0] > input[2] - input[0]) && !baseRotationAssetBigger) {
        LOGD("CropRotation no asset size needs to be updated.");
        return;
    }

    SetCropRectInner(timeline, assetUid, rotationCropRect, cropRect, animMs, 0, false, true);
}

bool HveAssetOper::MoveRule(float *corners, float *input, float *output)
{
    bool findNearest = getNearestMovement(corners, CROP_VERTEX_SIZE, input, RECT_SIZE, output, RECT_SIZE);
    if (findNearest) {
        LOGD("getNearestMovement output=%lf,%lf,%lf,%lf", output[0], output[1], output[2], output[3]);
        return true;
    } else {
        LOGE("getNearestMovement failed.");
        return false;
    }
}

/**
 * 自动缩放&移动填充空白区域算法
 * 1、先判断是否仅移动有最优解，如果有则使用仅移动的最小距离
 * 2、如果没有则求最大的缩小倍数
 * 3、最大的缩小倍数的结果存在多个最优解，需要找到移动距离最近的一个解
 * 4、如果第三步无解则使用第二步的解兜底，保证图像可以正常填充空白区域
 *
 * @param corners
 * 规则凸四边形的四个顶点坐标，分别为左上角x，左上角y，右上角x，右上角y，右下角x，右下角y，左下角x，左下角y
 * @param input   指定的矩形
 * @param output  最小移动的距离对应的矩形
 * @return true表示有最优解，false表示无最优解
 */
bool HveAssetOper::DefaultRule(float *corners, float *input, float *output)
{
    bool findNearest = getNearestMovement(corners, CROP_VERTEX_SIZE, input, RECT_SIZE, output, RECT_SIZE);
    if (findNearest) {
        LOGD("getNearestMovement output=%lf,%lf,%lf,%lf", output[0], output[1], output[2], output[3]);
        return true;
    }

    float ratio = (input[2] - input[0]) / (input[1] - input[3]);
    bool findLargest = getLargestAlignedRect(corners, ratio, output);
    if (!findLargest) {
        LOGE("getLargestAlignedRect failed. ratio=%lf", ratio);
        return false;
    }
    LOGD("getLargestAlignedRect ratio=%lf output=%lf,%lf,%lf,%lf", ratio, output[0], output[1], output[2], output[3]);

    float scaleSize = (output[3] - output[1]) / (input[3] - input[1]);
    float newInput[4] = {0, 0, 0, 0};
    bool scaleRst = ScaleRectArray(scaleSize, input, RECT_SIZE, newInput, RECT_SIZE);
    if (!scaleRst) {
        LOGW("ScaleRectArray failed, use getLargestAlignedRect result.");
        return true;
    }

    float outputBackup[4] = {output[0], output[1], output[2], output[3]};
    output[0] = 0;
    output[1] = 0;
    output[2] = 0;
    output[3] = 0;

    bool findScaleNearest = getNearestMovement(corners, CROP_VERTEX_SIZE, newInput, RECT_SIZE, output, RECT_SIZE);
    if (findScaleNearest) {
        LOGD("getNearestMovement output=%lf,%lf,%lf,%lf", output[0], output[1], output[2], output[3]);
    } else {
        LOGW("getNearestMovement failed, use getLargestAlignedRect result.");
        output[0] = outputBackup[0];
        output[1] = outputBackup[1];
        output[2] = outputBackup[2];
        output[3] = outputBackup[3];
    }
    return true;
}

bool HveAssetOper::RotateRule(float *corners, float *input, float *output)
{
    float ratio = (input[2] - input[0]) / (input[1] - input[3]);
    float centerX = (input[0] + input[2]) / 2;
    float centerY = (input[1] + input[3]) / 2;
    bool findLargest = getLargestAlignedRect(corners, ratio, centerX, centerY, output);
    if (findLargest) {
        LOGD("RotateRule getLargestAlignedRect ratio=%f output=%f,%f,%f,%f", ratio, output[0], output[1], output[2],
            output[3]);
        return true;
    } else {
        LOGW("RotateRule getLargestAlignedRect failed. ratio=%f", ratio);
        return false;
    }
}

bool HveAssetOper::SwitchRatioRule(float ratio, float *corners, float *input, float *output)
{
    LOGI("switchRatioRule ratio=%lf, coners=%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf", ratio, corners[0], corners[1], corners[2],
        corners[3], corners[4], corners[5], corners[6], corners[7]);
    LOGI("switchRatioRule limitation=%lf,%lf,%lf,%lf", input[0], input[1], input[2], input[3]);
    float centerX = (input[0] + input[2]) / 2;
    float centerY = (input[1] + input[3]) / 2;
    bool succeed = getLargestRectUnderRatio(corners, input, centerX, centerY, ratio, output);
    if (succeed) {
        LOGD("getLargestRectUnderRatio output=%lf,%lf,%lf,%lf", output[0], output[1], output[2], output[3]);
    } else {
        LOGE("getLargestRectUnderRatio failed.");
        return false;
    }
    return true;
}

bool HveAssetOper::GetDisplayResultbyRatio(HmcUid assetUid, float ratio, float *input, size_t inputSize, float *output,
    size_t outputSize)
{
    bool result = HveAssetOper::CalcOptimalCropRect(
        nullptr, assetUid,
        [ratio](float *corners, float *input, float *output) {
            return HveAssetOper::SwitchRatioRule(ratio, corners, input, output);
        },
        input, inputSize, output, outputSize);
    if (!result) {
        LOGE("CalcOptimalCropRect failed for filter thumb.");
        return false;
    }
    return true;
}

bool HveAssetOper::ReachableRectRule(float ratio, int *direction, float *corners, float *input, float *output)
{
    LOGD("reachableRectRule coners=%f,%f,%f,%f,%f,%f,%f,%f", corners[0], corners[1], corners[2], corners[3], corners[4],
        corners[5], corners[6], corners[7]);
    LOGD("reachableRectRule ratio=%f input=%f,%f,%f,%f", ratio, input[0], input[1], input[2], input[3]);
    LOGD("reachableRectRule direction=%d,%d,%d,%d", direction[0], direction[1], direction[2], direction[3]);
    bool succeed = getReachableRect(corners, input, ratio, direction, output);
    if (succeed) {
        LOGD("reachableRectRule output=%f,%f,%f,%f", output[0], output[1], output[2], output[3]);
        return true;
    }

    if (fabsf(ratio) >= 1e-6) {
        LOGE("reachableRectRule failed.");
        return false;
    }

    // 自由比例模式下获取可移动裁剪框兜底策略
    succeed = getReachableRectFreeRatio(corners, CROP_VERTEX_SIZE, input, RECT_SIZE, output, RECT_SIZE);
    if (succeed) {
        LOGD("getReachableRectFreeRatio output=%f,%f,%f,%f", output[0], output[1], output[2], output[3]);
        return true;
    } else {
        LOGE("getReachableRectFreeRatio failed.");
        return false;
    }
}

/**
 * 获取移动移动到边界的裁剪框位置
 *
 * @param vertex     素材4个顶点的x、y坐标位置，个数为8个
 * @param cropRect   原始rect（裁剪框）
 * @param outRect    偏移后的裁剪框坐标
 * @param watermarkType    水印类型
 * @return true表示有最优解，false表示无最优解
 */
bool HveAssetOper::CalcReachableBoundaryCropRect(float *vertex, const HmcRectD &cropRect, HmcRectD *outRect,
                                                 int watermarkType)
{
    float input[] = {(float)cropRect.left, (float)cropRect.top, (float)cropRect.right, (float)cropRect.bottom};
    float output[4] = {0, 0, 0, 0};
    bool succeed = CalcOptimalCropRect(vertex, MoveRule, input, RECT_SIZE, output, RECT_SIZE, watermarkType);
    if (succeed) {
        outRect->left = output[0];
        outRect->top = output[1];
        outRect->right = output[2];
        outRect->bottom = output[3];
    } else {
        LOGW("calcOptimalCropRect of reachable boundary failed.");
    }
    return succeed;
}

void HveAssetOper::GetReachableBoundaryOffset(const HmcRectD &translateCropRect, const HmcRectD &cropRect,
    bool isPreviewMode, int screenOperationType, double inputOffsetX, double inputOffsetY, double *fixOffsetX,
    double *fixOffsetY)
{
    if (screenOperationType == 1 && !isPreviewMode) {
        // PC设备上鼠标操作，素材移动不能出裁剪框
        if (fabs(translateCropRect.CenterX() - cropRect.CenterX()) > 0.01) {
            *fixOffsetX = inputOffsetX - (translateCropRect.CenterX() - cropRect.CenterX());
        }
        if (fabs(translateCropRect.CenterY() - cropRect.CenterY()) > 0.01) {
            *fixOffsetY = inputOffsetY - (translateCropRect.CenterY() - cropRect.CenterY());
        }
    } else if (screenOperationType == 2) {
        // 惯性移动触边后，移动速度跟手比为10:1
        if (fabs(translateCropRect.CenterX() - cropRect.CenterX()) > 0.01) {
            *fixOffsetX = inputOffsetX / 10;
        }
        if (fabs(translateCropRect.CenterY() - cropRect.CenterY()) > 0.01) {
            *fixOffsetY = inputOffsetY / 10;
        }
    } else {
        // 触屏设备上素材移动如果到达边界，移动速度跟手比为2:1
        if (fabs(translateCropRect.CenterX() - cropRect.CenterX()) > 0.01) {
            *fixOffsetX = inputOffsetX / 2;
        }
        if (fabs(translateCropRect.CenterY() - cropRect.CenterY()) > 0.01) {
            *fixOffsetY = inputOffsetY / 2;
        }
    }
}

bool HveAssetOper::IsReachableBoundary(const HmcRectD &translateCropRect, const HmcRectD &cropRect)
{
    return ((fabs(translateCropRect.CenterX() - cropRect.CenterX()) > 0.01) ||
        (fabs(translateCropRect.CenterY() - cropRect.CenterY()) > 0.01));
}

void HveAssetOper::VertexTranslate(float *vertex, double offsetX, double offsetY)
{
    vertex[0] = vertex[0] + offsetX;
    vertex[1] = vertex[1] + offsetY;
    vertex[2] = vertex[2] + offsetX;
    vertex[3] = vertex[3] + offsetY;
    vertex[4] = vertex[4] + offsetX;
    vertex[5] = vertex[5] + offsetY;
    vertex[6] = vertex[6] + offsetX;
    vertex[7] = vertex[7] + offsetY;
}

float HveAssetOper::GetAssetScaleForRotate90Acw(const HmcRectD &oldRectD, double width, double height)
{
    float scale = 1.0f;
    float scaleX = oldRectD.Height() / width;
    float scaleY = oldRectD.Width() / height;
    LOGD("GetAssetScaleForRotate90Acw: scaleX:%lf, scaleY:%lf", scaleX, scaleY);

    // 如果旋转后裁剪框的高大于旋转前裁剪框的宽，说明剪辑需要缩放才能把旋转前画面填充到新裁剪框中。同理旋转后宽大于旋转前高也一样
    if (scaleX > 1.0 && scaleY < 1.0) {
        scale = 1.0 / scaleX;
    } else if (scaleY > 1.0 && scaleX < 1.0) {
        scale = 1.0 / scaleY;
    } else {
        scale = 1.0 / HMC_MAX(scaleX, scaleY);
    }

    return scale;
}

void HveAssetOper::StartMirrorAnimation(HmcEditor *editor, HveTimeline *timeline, HmcUid assetUid)
{
    HmcUid mirrorEffectId = HveAssetOper::FindEffectByType(editor, assetUid, HMC_EFFECT_MIRROR);
    // 首次设置镜像，需先添加镜像效果
    if (HmcUidIsNull(&mirrorEffectId)) {
        HmcDictHelper mirrorPara;
        mirrorPara[DICT_KEY_EFFECT_NAME] = HmcDefault::EFFECT_MIRROR_DEFAULT_NAME;
        mirrorPara[DICT_KEY_EFFECT_TYPE] = HMC_EFFECT_MIRROR;
        HmcEffectAdd(editor, assetUid, mirrorPara, &mirrorEffectId);
    }
    
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("asset is null.");
        return;
    }
    hveAsset->SwitchCropMode();
    if (hveAsset->GetInPreviewMode()) {
        timeline->SwitchPreviewMode();
    }
}

void HveAssetOper::UpdateCropLimitation(HveTimeline *timeline)
{
    auto cropRect = timeline->GetCropRect();
    timeline->SetCropLimitation(cropRect);
}

void HveAssetOper::UpdateBaseRotationAssetSize(HveTimeline *timeline, HmcUid assetUid)
{
    HmcSize size;
    HmcAssetGetSize(timeline->GetEditor(), assetUid, HMC_SIZE_RENDER, &size);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("asset is null.");
        return;
    }

    hveAsset->SetBaseRotationAssetSize(size.width, size.height);
}

float HveAssetOper::CalPreviewMaxScale(HveTimeline *timeline, HmcUid assetUid)
{
    auto editor = timeline->GetEditor();
    float canvasWidth;
    float canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);

    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);

    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (HveAssetOper::AssetSizeIsExchanged(hveAsset->GetBaseRotation())) {
        std::swap(size.width, size.height);
        std::swap(originalSize.width, originalSize.height);
    }

    auto cropRect = timeline->GetCropRect();
    double cropAssetWidth = cropRect.Width() / size.width * originalSize.width;
    double cropAssetHeight = cropRect.Height() / size.height * originalSize.height;
    double ratio = cropRect.Width() / cropRect.Height();

    float previewMaxWidth = canvasWidth / PREVIEW_MAX_PIXEL_SCALE;
    float previewMaxHeight = canvasHeight / PREVIEW_MAX_PIXEL_SCALE;

    float previewMaxScale = 1.0f;
    if (static_cast<float>(ratio) > canvasWidth / canvasHeight) {
        if (cropAssetWidth > previewMaxWidth) {
            previewMaxScale = cropAssetWidth / previewMaxWidth;
        }
    } else {
        if (cropAssetWidth > previewMaxWidth) {
            previewMaxScale = cropAssetHeight / previewMaxHeight;
        }
    }

    LOGD("CalPreviewMaxScale is %f", previewMaxScale);
    return previewMaxScale;
}

bool HveAssetOper::IsReachableMaxScale(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &rotationCropRect)
{
    auto cropRect = timeline->GetCropRect();
    // 如果新的裁剪框坐标大于等于当前裁剪框坐标，表示素材要缩小，直接返回
    if (cropRect.Width() < rotationCropRect.Width() || fabs(cropRect.Width() - rotationCropRect.Width()) < 0.01) {
        return false;
    }

    auto editor = timeline->GetEditor();
    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);

    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    if (HveAssetOper::AssetSizeIsExchanged(hveAsset->GetBaseRotation())) {
        std::swap(size.width, size.height);
        std::swap(originalSize.width, originalSize.height);
    }

    float ratioX = cropRect.Width() / rotationCropRect.Width();
    float ratioY = cropRect.Height() / rotationCropRect.Height();
    float cropScale = HMC_MIN(ratioX, ratioY);
    size.width = size.width * cropScale;
    size.height = size.height * cropScale;

    double cropMaxScale = HMC_MIN(originalSize.width / 2.0, originalSize.height / 2.0);
    if (size.width > cropRect.Width() * cropMaxScale || size.height > cropRect.Height() * cropMaxScale) {
        LOGD("ReachableMaxScale scale:%lf, maxScale:%lf", cropScale, cropMaxScale);
        return true;
    } else {
        return false;
    }
}

void HveAssetOper::SetCropRectForRotation(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &cropRect)
{
    auto editor = timeline->GetEditor();
    float output[4] = {0, 0, 0, 0};
    float input[] = {(float)cropRect.left, (float)cropRect.top, (float)cropRect.right, (float)cropRect.bottom};
    bool findNearest =
        CalcOptimalCropRect(editor, assetUid, HveAssetOper::MoveRule, input, RECT_SIZE, output, RECT_SIZE);
    if (!findNearest) {
        LOGE("CropRotation getNearestMovement failed.");
        return;
    }

    HmcRectD rect(output[0], output[1], output[2], output[3]);
    float offsetX = cropRect.CenterX() - rect.CenterX();
    float offsetY = cropRect.CenterY() - rect.CenterY();
    float posX, posY;
    HmcAssetGetPositionByCenter(editor, assetUid, &posX, &posY);
    float newOffsetX = posX + offsetX;
    float newOffsetY = posY - offsetY;
    int isHorizontalMirror = 0;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    if (isHorizontalMirror) {
        newOffsetX = posX - offsetX;
    }

    HmcAssetSetPositionByCenter(timeline->GetEditor(), assetUid, newOffsetX, newOffsetY);
    timeline->SetCropLimitation(cropRect);
    auto hveAsset = timeline->GetHveAsset(assetUid);
    hveAsset->SetAssetPosXY(newOffsetX, newOffsetY);
}

/**
 * 获取当前可以裁剪的最小宽高
 *
 * @param timeline 泳道当前时刻
 * @param assetUid 剪辑的UID
 * @param minCropW 可裁剪最小宽度
 * @param minCropH 可裁剪最小高度
 */
void HveAssetOper::GetMinCropSize(HveTimeline *timeline, HmcUid assetUid, double ratio, double *minCropW,
    double *minCropH)
{
    auto editor = timeline->GetEditor();
    auto hveAsset = timeline->GetHveAsset(assetUid);
    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);

    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);
    if (HveAssetOper::AssetSizeIsExchanged(hveAsset->GetBaseRotation())) {
        std::swap(size.width, size.height);
        std::swap(originalSize.width, originalSize.height);
    }

    // 最大放大倍数为单边像素2
    double cropMaxScaleW = originalSize.width / 2.0;
    double cropMaxScaleH = originalSize.height / 2.0;
    double cropMaxScale = HMC_MIN(cropMaxScaleW, cropMaxScaleH);

    auto cropRect = timeline->GetCropRect();
    double minEdgeX = cropRect.Width();
    double minEdgeY = cropRect.Height();
    bool isInMaxRangeWidth = cropMaxScaleW >= CROP_REBOUND_MIN_SCALE && size.width / cropRect.Width() <= cropMaxScaleW;
    bool isInMaxRangeHeight =
        cropMaxScaleH >= CROP_REBOUND_MIN_SCALE && size.height / cropRect.Height() <= cropMaxScaleH;

    // 如果缩放是按比例缩放，那么最终的裁剪框要保持用户设置的比例，否则就按剪辑的比例
    if (fabs(ratio) < DOUBLE_PRECISION) {
        if (isInMaxRangeWidth) {
            minEdgeX = size.width / cropMaxScaleW;
        }
        if (isInMaxRangeHeight) {
            minEdgeY = size.height / cropMaxScaleH;
        }
    } else {
        float assetRatio = size.width / size.height;
        if (assetRatio > ratio) {
            if (isInMaxRangeWidth) {
                minEdgeX = size.width / cropMaxScale;
            }
            minEdgeY = minEdgeX / ratio;
        } else {
            if (isInMaxRangeHeight) {
                minEdgeY = size.height / cropMaxScale;
            }
            minEdgeX = minEdgeY * ratio;
        }
    }
    *minCropW = minEdgeX;
    *minCropH = minEdgeY;
}

HmcAssetPoint HveAssetOper::CalAssetPositionByCanvas(UpdateCanvasRect updCanvasCropRect, HmcAssetPoint inputPosition,
    float cropScale, bool isHorizontalMirror)
{
    float offsetX = inputPosition.x -
        (static_cast<float>(updCanvasCropRect.oldCropRect.CenterX()) - updCanvasCropRect.oldCanvasSize.width / 2);
    float offsetY = inputPosition.y -
        (updCanvasCropRect.oldCanvasSize.height / 2 - static_cast<float>(updCanvasCropRect.oldCropRect.CenterY()));
    if (isHorizontalMirror) {
        offsetX = offsetX +
            (static_cast<float>(updCanvasCropRect.oldCropRect.CenterX()) - updCanvasCropRect.oldCanvasSize.width / 2) *
            2;
    }

    float baseOffsetX =
        static_cast<float>(updCanvasCropRect.newCropRect.CenterX() - updCanvasCropRect.newCanvasSize.width / 2);
    float baseOffsetY =
        static_cast<float>(updCanvasCropRect.newCanvasSize.height / 2 - updCanvasCropRect.newCropRect.CenterY());

    // 适配裁剪可操作区域中心点坐标与画布中心点坐标不一致场景，偏移坐标 = 原始增量偏移 * 缩放比例 + 新的基础偏移量
    float posX = offsetX * cropScale + baseOffsetX;
    float posY = offsetY * cropScale + baseOffsetY;
    if (isHorizontalMirror) {
        posX = posX -
            (static_cast<float>(updCanvasCropRect.newCropRect.CenterX()) - updCanvasCropRect.newCanvasSize.width / 2) *
            2;
    }
    return HmcAssetPoint{ posX, posY };
}

HmcRectD HveAssetOper::CheckCropRectBoundary(const HmcRectD &boundaryArea, const HmcRectD &inputRect)
{
    HmcRectD outputRect;
    outputRect.left = HMC_MAX(boundaryArea.left, inputRect.left);
    outputRect.top = HMC_MAX(boundaryArea.top, inputRect.top);
    outputRect.right = HMC_MIN(boundaryArea.right, inputRect.right);
    outputRect.bottom = HMC_MIN(boundaryArea.bottom, inputRect.bottom);
    return outputRect;
}

bool HveAssetOper::GreatNotEqual(double num1, double num2)
{
    return (fabs(num1 - num2) > COMPARE_PRECISION && (num1 > num2));
}

bool HveAssetOper::GreatAndEqual(double num1, double num2)
{
    return (fabs(num1 - num2) < COMPARE_PRECISION || (num1 > num2));
}

bool HveAssetOper::LessNotEqual(double num1, double num2)
{
    return (fabs(num1 - num2) > COMPARE_PRECISION && (num1 < num2));
}

bool HveAssetOper::LessAndEqual(double num1, double num2)
{
    return (fabs(num1 - num2) < COMPARE_PRECISION || (num1 < num2));
}

void HveAssetOper::UpdateAssetDefaultInfo(HveAsset *asset, UpdateAssetArea area, int isHorizontalMirror)
{
    auto cropRectScale = area.dstDefaultCropRect.Width() / area.srcDefaultCropRect.Width();

    float oldWidthDefault = 0.0f;
    float oldHeightDefault = 0.0f;
    float oldPoXDefault = 0.0f;
    float oldPoYDefault = 0.0f;
    asset->GetAssetSizeAndPosXYDefault(oldWidthDefault, oldHeightDefault, oldPoXDefault, oldPoYDefault);
    LOGD("UpdateAssetDefaultInfo oldHeightDefault = %f, cropRectScale = %f", oldHeightDefault, cropRectScale);
    double oldOffsetXCropRefCanvas = area.srcDefaultCropRect.CenterX() - area.srcCanvas.width / g_two;
    double oldOffsetYCropRefCanvas = area.srcCanvas.height / g_two - area.srcDefaultCropRect.CenterY();
    double oldOffsetXAssetRefCrop = oldPoXDefault - oldOffsetXCropRefCanvas;
    double oldOffsetYAssetRefCrop = oldPoYDefault - oldOffsetYCropRefCanvas;
    
    if (isHorizontalMirror) {
        oldOffsetXAssetRefCrop = oldOffsetXAssetRefCrop +
            (area.srcDefaultCropRect.CenterX() - area.srcCanvas.width / g_two) * g_two;
    }

    double offsetXAssetRefCrop = oldOffsetXAssetRefCrop * cropRectScale;
    double offsetYAssetRefCrop = oldOffsetYAssetRefCrop * cropRectScale;
    double offsetXCropRefCanvas = area.dstDefaultCropRect.CenterX() - (area.dstCanvas.width / g_two);
    double offsetYCropRefCanvas = (area.dstCanvas.height / g_two) - area.dstDefaultCropRect.CenterY();
    double posXDefault = offsetXCropRefCanvas + offsetXAssetRefCrop;
    double posYDefault = offsetYCropRefCanvas + offsetYAssetRefCrop;

    if (isHorizontalMirror) {
        posXDefault = posXDefault - (area.dstDefaultCropRect.CenterX() - (area.dstCanvas.width / g_two)) * g_two;
    }

    double widthDefault = oldWidthDefault * cropRectScale;
    double heightDefault = oldHeightDefault * cropRectScale;

    asset->SetAssetSizeAndPosXYDefault(static_cast<float>(widthDefault), static_cast<float>(heightDefault),
        static_cast<float>(posXDefault), static_cast<float>(posYDefault));
}

void HveAssetOper::ProcessEndCb(HveTimeline *timeline, const HmcUid& assetUid)
{
    if (timeline == nullptr) {
        LOGE("timeline is null.");
        return;
    }

    auto hveAsset = timeline->GetHveAsset(assetUid);
    AssetOperationCb cb = hveAsset->GetAssetOperationCb(MOVE_SCALE_END);
    if (cb == nullptr) {
        return; // 非移动&镜像回弹场景不需要回调
    }

    // 移动/镜像回弹动画结束回调UI
    BACKGROUND_TASK_MGR->Submit(
        [cb] {
            Json::Value json;
            Json::FastWriter fastWriter;
            json["vibration"] = 0;
            cb(fastWriter.write(json));
        },
        __FUNCTION__);
    hveAsset->RemoveAssetOperationCb(MOVE_SCALE_END);
}