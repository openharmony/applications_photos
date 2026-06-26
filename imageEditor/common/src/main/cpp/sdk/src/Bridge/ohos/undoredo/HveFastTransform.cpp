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

#include "HveFastTransform.h"
#include "MediaCreative/HmcEditorAsset.h"
#include "MediaCreative/HmcUid.h"
#include "ohos/hve/HveAssetOper.h"
#include "../util/HveTransformUtil.h"

static int g_one = 1;
static int g_two = 2;
static int g_three = 3;
static int g_four = 4;
static int rotation_90 = 90;
static int rotation_semicircle = 180;
static int rotation_circle = 360;

/**
 * top-left：0°
 * right-top：顺时针90°
 * left-bottom：逆时针90° == 顺时针270°
 * bottom-right：180°
 * top-right：水平翻转
 * bottom-left：垂直翻转  == 旋转180°再水平翻转
 * left-top：顺时针90° + 水平翻转
 * right-bottom：逆时针90°+水平翻转
 */
std::unordered_map<std::string, std::function<void()>> strategyMap;
std::unordered_map<std::string, std::function<void()>> revertMap;

HveFastTransform::HveFastTransform(HveTimeline *timeline, HmcUid &assetUid, bool reEdit, bool revert, bool setDefault)
    : HveFastTransform(timeline, assetUid)
{
    this->reEdit = reEdit;
    this->revert = revert;
    this->setDefault = setDefault;
}

HveFastTransform::HveFastTransform(HveTimeline *timeline, HmcUid &assetUid) : timeline(timeline), assetUid(assetUid)
{
    strategyMap["top-left"] = [this]() -> void {};
    strategyMap["right-top"] = [this]() -> void { this->ClockwiseRotate90(g_three); };
    strategyMap["left-bottom"] = [this]() -> void { this->ClockwiseRotate90(g_one); };
    strategyMap["bottom-right"] = [this]() -> void { this->ClockwiseRotate90(g_two); };
    strategyMap["top-right"] = [this]() -> void { this->HorizontallyFlip(); };
    strategyMap["bottom-left"] = [this]() -> void {
        this->ClockwiseRotate90(g_two);
        this->HorizontallyFlip();
    };
    strategyMap["left-top"] = [this]() -> void {
        this->HorizontallyFlip();
        this->ClockwiseRotate90(g_one);
    };
    strategyMap["right-bottom"] = [this]() -> void {
        this->HorizontallyFlip();
        this->ClockwiseRotate90(g_three);
    };
    // 还原时反向操作
    revertMap["top-left"] = [this]() -> void {};
    revertMap["right-top"] = [this]() -> void { this->ClockwiseRotate90(g_one); };
    revertMap["left-bottom"] = [this]() -> void { this->ClockwiseRotate90(g_three); };
    revertMap["bottom-right"] = [this]() -> void { this->ClockwiseRotate90(g_two); };
    revertMap["top-right"] = [this]() -> void { this->HorizontallyFlip(); };
    revertMap["bottom-left"] = [this]() -> void {
        this->HorizontallyFlip();
        this->ClockwiseRotate90(g_two);
    };
    revertMap["left-top"] = [this]() -> void {
        this->ClockwiseRotate90(g_three);
        this->HorizontallyFlip();
    };
    revertMap["right-bottom"] = [this]() -> void {
        this->ClockwiseRotate90(g_one);
        this->HorizontallyFlip();
    };
};

void HveFastTransform::ProcessOrientation(const std::string orientation)
{
    std::string lowerOri = orientation;
    std::transform(lowerOri.begin(), lowerOri.end(), lowerOri.begin(), ::tolower);
    LOGD("HveFastTransform::ProcessOrientation: %s", lowerOri.c_str());
    HmcEditorSetAutoFlush(timeline->GetEditor(), false);
    std::function<void()> func = strategyMap[lowerOri];
    if (func != nullptr) {
        func();
        if (this->setDefault) {
            timeline->Notify();
        }
    }
}

void HveFastTransform::RevertOrientation(const std::string orientation)
{
    std::string lowerOri = orientation;
    std::transform(lowerOri.begin(), lowerOri.end(), lowerOri.begin(), ::tolower);
    LOGD("HveFastTransform::RevertOrientation: %s", lowerOri.c_str());
    std::function<void()> func = revertMap[lowerOri];
    if (func != nullptr) {
        func();
        if (this->setDefault) {
            timeline->Notify();
        }
    }
}

void HveFastTransform::HorizontallyFlip()
{
    LOGD("HorizontallyFlip start");
    HveAsset *hveAsset = timeline->GetHveAsset(assetUid);
    HmcEditor *editor = timeline->GetEditor();
    int isMirror;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isMirror);
    // 镜像状态，取当前状态再取反
    bool mirrorFlag = isMirror == g_one ? false : true;
    LOGD("HmcAssetSetMirror mirrorFlag: %d", mirrorFlag);

    HmcSize size;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_RENDER, &size);
    hveAsset->SetBaseRotationAssetSize(size.width, size.height);
    HmcRectD cropRect = timeline->GetCropRect();
    timeline->SetCropLimitation(cropRect);

    // 首次设置镜像，需先添加镜像效果
    AddMirrorEffect();

    int isHorizontalMirror = 0;
    HmcAssetGetMirror(editor, assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    HorizontalMirrorCorrect(hveAsset, isHorizontalMirror, mirrorFlag);
    if (!this->reEdit) {
        LOGD("SetDefaultHorizontalMirror : %d", mirrorFlag);
        hveAsset->SetDefaultHorizontalMirror(mirrorFlag);
    }
    hveAsset->SetMirrorDefault(mirrorFlag);
    hveAsset->SetMirror(mirrorFlag);

    HmcAssetSetMirror(editor, assetUid, mirrorFlag, HMC_ASSET_MIRROR_HORIZONTAL);

    hveAsset->SetRefreshThumbnails(TRUE);
    LOGD("HorizontallyFlip complete.");
}

void HveFastTransform::AddMirrorEffect()
{
    HmcUid mirrorEffectId = HveAssetOper::FindEffectByType(timeline->GetEditor(), assetUid, HMC_EFFECT_MIRROR);
    // 首次设置镜像，需先添加镜像效果
    if (HmcUidIsNull(&mirrorEffectId)) {
        HmcDictHelper mirrorPara;
        mirrorPara[DICT_KEY_EFFECT_NAME] = HmcDefault::EFFECT_MIRROR_DEFAULT_NAME;
        mirrorPara[DICT_KEY_EFFECT_TYPE] = HMC_EFFECT_MIRROR;
        HmcEffectAdd(timeline->GetEditor(), assetUid, mirrorPara, &mirrorEffectId);
    }
}

void HveFastTransform::HorizontalMirrorCorrect(HveAsset *hveAsset, int isHorizontalMirror, bool mirrorFlag)
{
    // 画布中心点坐标和裁剪可操作区域中心点坐标不一致时，在设置镜像开关前需要修正X轴偏移量
    if (isHorizontalMirror != mirrorFlag) {
        auto cropRect = timeline->GetCropRect();
        float canvasWidth, canvasHeight;
        HmcEditorGetCanvasSize(timeline->GetEditor(), &canvasWidth, &canvasHeight);
        float baseOffsetX = (static_cast<float>(cropRect.CenterX()) - canvasWidth / g_two) * g_two;
        float posX;
        float posY;
        HmcAssetGetPositionByCenter(timeline->GetEditor(), assetUid, &posX, &posY);
        float fixPosX = mirrorFlag ? (posX - baseOffsetX) : (posX + baseOffsetX);
        HmcAssetSetPositionByCenter(timeline->GetEditor(), assetUid, fixPosX, posY);
        hveAsset->SetAssetInitPosXY(fixPosX, posY);
        LOGD("CorrectionOffset Horizontal mirror posX: %f, fixPosX: %f", posX, fixPosX);
    }
}

void HveFastTransform::ClockwiseRotate90(UINT8 times)
{
    LOGD("ClockwiseRotate90 times: %d", times);
    HveAsset *hveAsset = timeline->GetHveAsset(assetUid);
    if (hveAsset == nullptr) {
        LOGE("InitAsset, asset is null.");
        return;
    }
    LOGD("ClockwiseRotate90 asset original width: %f, height: %f", hveAsset->GetAssetWidth(),
         hveAsset->GetAssetHeight());
    // 当前裁剪框位置
    HmcRectD oldRectD = timeline->GetCropRect();
    // 旋转框 横竖位置
    int clickTimes = (hveAsset->GetClick90AckTimes() + times) % g_four;
    LOGD("ClockwiseRotate90 effect clickTimes: %d", clickTimes);
    hveAsset->SetClick90AckTimes(clickTimes);
    bool isDefaultRectRatio = (clickTimes % g_two) == 0 ? true : false;
    // 旋转后的 裁剪框位置
    HmcRectD cropRect = CalculateNewCropRect(isDefaultRectRatio);
    timeline->SetCropRectSize(cropRect);
    timeline->SetCropLimitation(cropRect);

    BaseRotationCorrect(hveAsset, times);
    CalculateRotation(hveAsset, cropRect, oldRectD);
    LOGD("ClockwiseRotate90 complete");
}

HmcRectD HveFastTransform::CalculateNewCropRect(bool isDefaultRectRatio)
{
    // 当前裁剪框位置
    HmcRectD oldRectD = timeline->GetCropRect();
    // 当前裁剪操作区域
    HmcRectD cropOperationArea = timeline->GetCropOperationArea();
    // 裁剪框宽高比
    float ratio = oldRectD.Width() / oldRectD.Height();
    HmcRectD cropRect(0, 0, 0, 0);
    if (isDefaultRectRatio) {
        cropRect = oldRectD;
    } else {
        HveAssetOper::GetCenterInsideRectUnderRatio(g_one / ratio, cropOperationArea, &cropRect);
    }
    return cropRect;
}

void HveFastTransform::CalculateRotation(HveAsset *hveAsset, HmcRectD cropRect, HmcRectD oldRectD)
{
    // 旋转逻辑：step1;先基于原裁剪框旋转计算出旋转后中心点； step2:基于旋转后的裁剪框算出缩放比
    // step3:计算因缩放导致的中心点偏移
    HmcEditor *editor = timeline->GetEditor();
    // 编辑画布位置宽高
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    // 整个编辑画布的中心位置
    float calPosX;
    float calPosY;
    HmcAssetGetPositionByCenter(editor, assetUid, &calPosX, &calPosY);
    LOGD("ClockwiseRotate90 effect calPosX: %f, calPosY: %f", calPosX, calPosY);
    // 水平镜像
    int isHorizontalMirror = 0;
    HmcAssetGetMirror(timeline->GetEditor(), assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    if (isHorizontalMirror) {
        float baseOffsetX = (static_cast<float>(cropRect.CenterX()) - canvasWidth / g_two) * g_two;
        calPosX = calPosX + baseOffsetX;
    }
    calPosX = canvasWidth / g_two + calPosX;
    calPosY = canvasHeight / g_two - calPosY;

    int clickTimes = hveAsset->GetClick90AckTimes();
    float degree = (rotation_90 * clickTimes) % rotation_circle; // 正值：逆时针，负值：顺时针
    if (isHorizontalMirror) {
        degree = -degree;
    }
    float rad = degree * MathUtils::PI / rotation_semicircle; // 弧度
    // 裁剪框中心a点 以素材 中心o点 为中心逆时针旋转rad弧度后得到b点
    float ox = calPosX;
    float oy = -calPosY;
    float ax = cropRect.CenterX();
    float ay = -cropRect.CenterY();
    float bx = (ax - ox) * cos(rad) - (ay - oy) * sin(rad) + ox;
    float by = (ax - ox) * sin(rad) + (ay - oy) * cos(rad) + oy;
    LOGD("ClockwiseRotate90 o=%lf,%lf a=%lf,%lf b=%lf,%lf degree=%lf", ox, oy, ax, ay, bx, by, degree);

    // 素材进行移动补偿，使b点移动到a点位置
    calPosX += (ax - bx);
    calPosY -= (ay - by);
    HmcAssetPoint assetPosition = {(calPosX - canvasWidth / g_two), (canvasHeight / g_two - calPosY)};

    RotationParamSet(cropRect, oldRectD, isHorizontalMirror, assetPosition);
}

void HveFastTransform::RotationParamSet(HmcRectD cropRect, HmcRectD oldRectD, int isHorizontalMirror,
                                        HmcAssetPoint &assetPosition)
{
    auto hveAsset = timeline->GetHveAsset();
    int clickTimes = hveAsset->GetClick90AckTimes();
    bool isDefaultRectRatio = (clickTimes % g_two) == 0 ? true : false;
    // 缩放比例
    float scale = isDefaultRectRatio
                      ? 1.0f
                      : (HveAssetOper::GetAssetScaleForRotate90Acw(oldRectD, cropRect.Width(), cropRect.Height()));
    LOGD("ClockwiseRotate90 scale: %f", scale);
    HmcSize size;
    HmcAssetGetSize(timeline->GetEditor(), assetUid, HMC_SIZE_RENDER, &size);
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(timeline->GetEditor(), &canvasWidth, &canvasHeight);

    HveTransformUtil::CalcAssetPositionAfterScale(assetPosition, cropRect, scale, &size, timeline->GetEditor());

    if (isHorizontalMirror) {
        float baseOffsetX = (static_cast<float>(cropRect.CenterX()) - canvasWidth / g_two) * g_two;
        assetPosition.x = assetPosition.x - baseOffsetX;
    }
    LOGD("SetAssetInitSizeNotifyOptional %lf, %lf", size.width, size.height);
    if (this->setDefault) {
        hveAsset->SetBaseRotationAssetSize(size.width, size.height);
        hveAsset->SetAssetInitSize(size.width, size.height);
        hveAsset->SetAssetInitPosXY(assetPosition.x, assetPosition.y);
    } else {
        hveAsset->SetAssetSize(size.width, size.height);
        hveAsset->SetAssetPosXY(assetPosition.x, assetPosition.y);
    }
    RotationPreview(hveAsset, size, assetPosition, cropRect);
}

void HveFastTransform::RotationPreview(HveAsset *hveAsset, HmcSize size, HmcAssetPoint assetPosition, HmcRectD cropRect)
{
    HmcEditor *editor = timeline->GetEditor();
    auto newRotation = hveAsset->GetRotation(HMC_AXIS_Z);
    LOGD("ClockwiseRotate90 newRotation: %lf, size.width: %f, size.height: %f", newRotation, size.width, size.height);
    HmcAssetSetRotation(editor, assetUid, newRotation, HMC_AXIS_Z);
    HmcAssetSetSize(editor, assetUid, size);
    HmcAssetSetPositionByCenter(editor, assetUid, assetPosition.x, assetPosition.y);
    LOGD("RotationPreview HmcAssetSetPositionByCenter: %lf, %lf", assetPosition.x, assetPosition.y);
    timeline->SetCropRect(cropRect);
    if (this->setDefault) {
        timeline->SetCropRectDefault(cropRect);
    }
    // 保存前回退EXIF效果，EXIF旋转90°，切到滤镜直接保存，不做Preview会导致图片变形
    if (this->revert) {
        hveAsset->SetInPreviewMode(false);
        hveAsset->UpdatePreviewMode(cropRect, timeline->GetCropOperationArea(), false);
    }
    hveAsset->ResetRotate90AcwTempValue();
    hveAsset->SetRefreshThumbnails(TRUE);
}

void HveFastTransform::BaseRotationCorrect(HveAsset *hveAsset, int times)
{
    auto baseRotation = hveAsset->GetBaseRotation();
    auto oldRotation = hveAsset->GetRotation(HMC_AXIS_Z);
    // Z轴旋转偏移
    auto extraRotation = oldRotation - baseRotation;
    LOGD("ClockwiseRotate90 base-rotation: %f, z-rotation %f", baseRotation, oldRotation);
    // 水平镜像
    int isHorizontalMirror = 0;
    HmcAssetGetMirror(timeline->GetEditor(), assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &isHorizontalMirror);
    if (isHorizontalMirror) {
        baseRotation = ((int)(baseRotation - rotation_90 * times)) % rotation_circle;
    } else {
        baseRotation = ((int)(baseRotation + rotation_90 * times)) % rotation_circle;
    }
    hveAsset->SetBaseRotation(baseRotation);
    double newRotation = extraRotation + baseRotation; // 每调用一次接口，逆时针90度（逆时针：正值）
    if (this->setDefault) {
        hveAsset->SetRotationDefault(newRotation, HMC_AXIS_Z);
    } else {
        hveAsset->SetRotation(newRotation, HMC_AXIS_Z, false);
    }
}
