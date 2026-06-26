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

#include "HveAsset.h"
#include "MediaCreative/HmcEditorAsset.h"
#include "MediaCreative/HmcEditorEffect.h"
#include "MediaCreative/HmcUid.h"
#include "ohos/common/Animation.h"
#include "HveAssetOper.h"
#include "ohos/interface/index.h"
#include "ohos/util/HveTransformUtil.h"

constexpr char const * DEFAULT_FONT_PATH = "/system/fonts/HarmonyOS_Sans_SC_Regular.ttf";
constexpr char const *SERIALIZE_BASE_ROTATION = "base_rotation";
constexpr char const *SERIALIZE_CROP_ROTATION = "crop_rotation";
constexpr char const *SERIALIZE_CROP_RECT_MIN_LEN = "cropRectMinLen";
constexpr char const *SERIALIZE_EXPANDED_HOTSPOTS_WIDTH = "expandedHotspotsWidth";
constexpr char const *SERIALIZE_EXPANDED_HOTSPOTS_HEIGHT = "expandedHotspotsHeight";
static int g_two = 2;
static int g_percent = 100;

const std::vector<std::string> ADJUST_NAME_LIST = {
    DICT_KEY_ADJUST_AUTO,     DICT_KEY_ADJUST_HUE,         DICT_KEY_ADJUST_SATURATION, DICT_KEY_ADJUST_BRIGHTNESS,
    DICT_KEY_ADJUST_CONTRAST, DICT_KEY_ADJUST_TEMPERATURE, DICT_KEY_ADJUST_SHARPNESS,  DICT_KEY_ADJUST_FADE,
    DICT_KEY_ADJUST_EXPOSURE, DICT_KEY_ADJUST_GRAIN,       DICT_KEY_ADJUST_HIGHLIGHT,  DICT_KEY_ADJUST_SHADOW,
    DICT_KEY_ADJUST_VIGNETTE, DICT_KEY_ADJUST_VIBRANCE,    DICT_KEY_ADJUST_BRIGHTZONE, DICT_KEY_ADJUST_DARKZONE
};

std::string GetAdjustItemEnableName(const std::string &adjustItemName)
{
    return adjustItemName + "_enable";
}

HveAsset::HveAsset(HmcEditor *editor, HmcUid assetUid, HmcAssetType type, OnAssetChange callback)
    : m_editor(editor), m_assetUid(assetUid), m_type(type), m_assetChangeCb(callback)
{
    m_modifyTime = static_cast<int64_t>(HmcGetCurrTimeMillSec());

    InitColorAdjustValue();
}

HveAsset::HveAsset(const HveAsset &asset)
{
    m_baseRotation = asset.m_baseRotation;
    m_previewScale = asset.m_previewScale;
    m_isInPreviewMode = asset.m_isInPreviewMode;
    m_previewOffsetX = asset.m_previewOffsetX;
    m_previewOffsetY = asset.m_previewOffsetY;
    m_resetVertex = asset.m_resetVertex;
    m_type = asset.m_type;
    m_modifyBoxWidthFlag = asset.m_modifyBoxWidthFlag;
    m_fontTypeIndex = asset.m_fontTypeIndex;
    m_trimIn = asset.m_trimIn;
    m_trimOut = asset.m_trimOut;
    m_mute = asset.m_mute;
    m_mirror = asset.m_mirror;
    m_rotationX = asset.m_rotationX;
    m_rotationY = asset.m_rotationY;
    m_rotationZ = asset.m_rotationZ;
    m_assetPosX = asset.m_assetPosX;
    m_assetPosY = asset.m_assetPosY;
    m_assetWidth = asset.m_assetWidth;
    m_assetHeight = asset.m_assetHeight;
    m_editor = asset.m_editor;
    m_assetChangeCb = asset.m_assetChangeCb;
    m_modifyTime = static_cast<int64_t>(HmcGetCurrTimeMillSec());
    m_assetUid = HMC_UID_NULL;
}

HveAsset *HveAsset::Duplicate(HmcUid newAssetUid)
{
    auto asset = new (std::nothrow) HveAsset(*this);
    if (asset == nullptr) {
        return nullptr;
    }

    asset->m_assetUid = newAssetUid;
    return asset;
}

HveAsset::~HveAsset()
{
    CancelAnimation();
}

Json::Value HveAsset::Serialize()
{
    Json::Value json;
    json[SERIALIZE_BASE_ROTATION] = m_baseRotation;
    json[SERIALIZE_CROP_ROTATION] = m_ChooseRatio;
    json[SERIALIZE_EXPANDED_HOTSPOTS_WIDTH] = m_expandedHotspotsWidth;
    json[SERIALIZE_EXPANDED_HOTSPOTS_HEIGHT] = m_expandedHotspotsHeight;
    json[SERIALIZE_CROP_RECT_MIN_LEN] = m_cropRectMinLen;
    return json;
}

void HveAsset::Deserialize(Json::Value data)
{
    JsonValueUtil::ParseFloatIfHas(data, SERIALIZE_BASE_ROTATION, m_baseRotation);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_ROTATION, m_ChooseRatio);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_EXPANDED_HOTSPOTS_WIDTH, m_expandedHotspotsWidth);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_EXPANDED_HOTSPOTS_HEIGHT, m_expandedHotspotsHeight);
    JsonValueUtil::ParseValueIfHas(data, SERIALIZE_CROP_RECT_MIN_LEN, m_cropRectMinLen);
}

void HveAsset::SyncDataFromService()
{
    HMC_TRACE_GUARD("SyncDataFromService");
    HmcAssetIsMute(m_editor, m_assetUid, &m_mute);
    m_muteDefault = m_mute;

    SyncTrimDataFromService();

    SyncAdjustDataFromService();

    SyncTransformDataFromService();

    Notify();
}

void HveAsset::SyncAdjustDataFromService()
{
    HmcUid effectUid = HMC_UID_NULL;
    int result = HmcEffectGetEffects(m_editor, m_assetUid, HMC_EFFECT_ADJUST, &effectUid, 1);
    // 首次设置调节参数，需先添加调节效果器
    if (result != HMC_OK || HmcUidIsNull(&effectUid)) {
        return;
    }

    auto dict = HmcDictCreate();
    if (dict == nullptr) {
        LOGE("create dict for sync adjust data from service failed.");
        return;
    }

    result = HmcEffectGetProperty(m_editor, effectUid, dict);
    if (result != HMC_OK) {
        return;
    }

    for (const auto &it : ADJUST_NAME_LIST) {
        std::string adjustEnableItemName = GetAdjustItemEnableName(it);

        int32_t value = 0;
        HmcDictGetInt32(dict, it.c_str(), &value);
        m_adjustValue[it] = static_cast<double>(value);
        m_adjustValueDefault[it] = static_cast<double>(value);

        HmcDictGetInt32(dict, adjustEnableItemName.c_str(), &value);
        m_adjustEnableValue[adjustEnableItemName] = value;
        m_adjustEnableValueDefault[adjustEnableItemName] = value;
    }
}

void HveAsset::SyncTrimDataFromService()
{
    auto originalDuration = HmcAssetGetFileDuration(m_editor, m_assetUid);
    if (originalDuration <= 0) {
        LOGE("get duration from service failed, duration: %d.", originalDuration);
        return;
    }

    uint64_t startTime = 0;
    uint64_t endTime = 0;

    auto result = HmcEditorGetPreviewPeriodRange(m_editor, startTime, endTime);
    if (result != HMC_OK) {
        LOGE("get preview period range from service failed with error: %d.", result);
        return;
    }

    m_trimIn = static_cast<int>(startTime);
    m_trimOut = (originalDuration >= endTime) ? static_cast<int>((originalDuration - endTime)) :
                                                static_cast<int>(originalDuration);
    m_trimInDefault = m_trimIn;
    m_trimOutDefault = m_trimOut;
}

void HveAsset::SyncTransformDataFromService()
{
    HmcUid effectUid = HMC_UID_NULL;
    int result = HmcEffectGetEffects(m_editor, m_assetUid, HMC_EFFECT_TRANSFORM, &effectUid, 1);
    // 首次设置调节参数，需先添加调节效果器
    if (result != HMC_OK || HmcUidIsNull(&effectUid)) {
        return;
    }

    HmcDictHelper dict;
    result = HmcEffectGetProperty(m_editor, effectUid, dict);
    if (result != HMC_OK) {
        return;
    }

    result = HmcEffectGetProperty(m_editor, effectUid, dict);
    if (result != HMC_OK) {
        return;
    }

    m_rotationX = dict[PROJECT_KEY_TRANSFORM_ROTATION_X];
    m_rotationY = dict[PROJECT_KEY_TRANSFORM_ROTATION_Y];
    m_rotationZ = dict[PROJECT_KEY_TRANSFORM_ROTATION_Z];

    m_rotationXDefault = m_rotationX;
    m_rotationYDefault = m_rotationY;
    m_rotationZDefault = m_rotationZ;

    HmcAssetGetMirror(m_editor, m_assetUid, HMC_ASSET_MIRROR_HORIZONTAL, &m_mirror);
    m_mirrorDefault = m_mirror;

    HmcAssetGetPositionByCenter(m_editor, m_assetUid, &m_assetPosX, &m_assetPosY);
    m_assetPosXDefault = m_assetPosX;
    m_assetPosYDefault = m_assetPosY;

    HmcSize size;
    HmcAssetGetSize(m_editor, m_assetUid, HMC_SIZE_RENDER, &size);
    LOGD("SyncTransformDataFromService size width = %f, height = %f", size.width, size.height);
    m_assetWidth = size.width;
    m_assetHeight = size.height;
    m_assetWidthDefault = m_assetWidth;
    m_assetHeightDefault = m_assetHeight;
}

bool HveAsset::IsLandscape() const
{
    float baseRotationF = GetBaseRotation();
    auto baseRotation = lroundf(baseRotationF);
    return baseRotation == 90 || baseRotation == 270;
}

std::string HveAsset::ConvAdjustDict2Json(HmcDict *dict)
{
    int32_t value = 0;
    int32_t enable = 0;

    Json::Value jsonArray;
    Json::FastWriter fastWriter;
    for (const auto &adjustItem : ADJUST_NAME_LIST) {
        value = 0;
        enable = 0;
        int errorCode = HmcDictGetInt32(dict, adjustItem.c_str(), &value);
        if (errorCode != HMC_OK) {
            continue;
        }

        errorCode = HmcDictGetInt32(dict, GetAdjustItemEnableName(adjustItem).c_str(), &enable);
        if (errorCode != HMC_OK) {
            continue;
        }

        Json::Value json;
        json["name"] = adjustItem.c_str();
        json["value"] = value;
        json["enable"] = enable;
        jsonArray.append(json);
    }
    return fastWriter.write(jsonArray);
}

void HveAsset::SetDefaultValueToAdjustDict(HmcDict *dict)
{
    // 调节各项的默认值为0，调节开关各项的默认值为true
    for (const auto &adjustItem : ADJUST_NAME_LIST) {
        std::string adjustItemEnableName = GetAdjustItemEnableName(adjustItem);
        HmcDictSetInt32(dict, adjustItem.c_str(), lround(m_adjustValueDefault[adjustItem]));
        HmcDictSetInt32(dict, adjustItemEnableName.c_str(), m_adjustEnableValueDefault[adjustItemEnableName]);
        SetAdjustValue(adjustItem, m_adjustValueDefault[adjustItem]);
        SetAdjustEnableValue(adjustItemEnableName, m_adjustEnableValueDefault[adjustItemEnableName]);
    }
}

void HveAsset::InitColorAdjustValue()
{
    for (const auto &it : ADJUST_NAME_LIST) {
        std::string adjustItemEnableName = GetAdjustItemEnableName(it);
        m_adjustValue[it] = 0.0f;
        m_adjustEnableValue[adjustItemEnableName] = true;
        m_adjustValueDefault[it] = 0.0f;
        m_adjustEnableValueDefault[adjustItemEnableName] = true;
    }
    m_adjustEnableValue[DICT_KEY_ADJUST_AUTO_ENABLE] = false; // 一键调节默认关闭
    m_adjustEnableValueDefault[DICT_KEY_ADJUST_AUTO_ENABLE] = false;
}

void HveAsset::SetDeviceType(std::string const & deviceType)
{
    LOGI("HveAsset::SetDeviceType %s", deviceType.c_str());
    if (strcasecmp(deviceType.c_str(), "tablet") == 0 || strcasecmp(deviceType.c_str(), "2in1") == 0) {
        m_deviceType = DEV_TABLET;
    } else {
        m_deviceType = DEV_PHONE;
    }
}

// 判断是否支持艺术签名水印
void HveAsset::setSupportNewWatermark(bool supportNewWatermark)
{
    LOGI("HveAsset::setSupportNewWatermark %d", supportNewWatermark);
    m_supportNewWatermark = supportNewWatermark;
}

bool HveAsset::getSupportNewWatermark()
{
    return m_supportNewWatermark;
}

HmcDeviceType HveAsset::GetDeviceType()
{
    return m_deviceType;
}

void HveAsset::SetEditDataType(std::string const &type)
{
    LOGI("HveAsset::SetEditDataType %s", type.c_str());
    m_editDataType = type;
}

std::string HveAsset::GetEditDataType()
{
    return m_editDataType;
}

void HveAsset::SetRotationDefault(double rotation, HmcRotationAxis axis)
{
    switch (axis) {
        case HMC_AXIS_X: {
            m_rotationX = rotation;
            m_rotationXDefault = rotation;
            break;
        }
        case HMC_AXIS_Y: {
            m_rotationY = rotation;
            m_rotationYDefault = rotation;
            break;
        }
        case HMC_AXIS_Z: {
            m_rotationZ = rotation;
            m_rotationZDefault = rotation;
            break;
        }
        default: {
            break;
        }
    }
    LOGD("SetRotationDefault default XYZ: %f, %f, %f", m_rotationXDefault, m_rotationYDefault, m_rotationZDefault);
}

void HveAsset::SetRotation(double rotation, HmcRotationAxis axis, bool needNotify)
{
    switch (axis) {
        case HMC_AXIS_X: {
            m_rotationX = rotation;
            break;
        }
        case HMC_AXIS_Y: {
            m_rotationY = rotation;
            break;
        }
        case HMC_AXIS_Z: {
            m_rotationZ = rotation;
            break;
        }
        default: {
            break;
        }
    }
    if (needNotify) {
        Notify();
    }
}

double HveAsset::GetRotation(HmcRotationAxis axis) const
{
    switch (axis) {
        case HMC_AXIS_X: {
            return GetRotationX();
        }
        case HMC_AXIS_Y: {
            return GetRotationY();
        }
        case HMC_AXIS_Z: {
            return GetRotationZ();
        }
        default: {
            return 0;
        }
    }
}

HmcUid HveAsset::FindEffectByType(HmcEffectType type)
{
    auto count = HmcEffectGetEffectCount(m_editor, m_assetUid, type);
    if (count != 1) {
        LOGD("FindEffectByType HmcEffectGetEffectCount failed");
        return HMC_UID_NULL;
    }

    HmcUid *effectUidArr = (HmcUid *)malloc(sizeof(HmcUid) * count);
    if (!effectUidArr) {
        LOGD("FindEffectByType effectUidArr is NULL");
        return HMC_UID_NULL;
    }

    memset_s(effectUidArr, sizeof(HmcUid) * count, 0, sizeof(HmcUid) * count);

    if (HmcEffectGetEffects(m_editor, m_assetUid, type, effectUidArr, count) != HMC_OK) {
        LOGD("FindEffectByType HmcEffectGetEffects failed");
        free(effectUidArr);
        return HMC_UID_NULL;
    }

    HmcUid result = effectUidArr[0];
    free(effectUidArr);
    return result;
}

void HveAsset::HandleVignetForSave(bool isEnableVignette)
{
    if (m_isInPreviewMode || !isVignetteHasValue) {
        return;
    }

    HmcUid adjustEffectId = FindEffectByType(HMC_EFFECT_ADJUST);
    if (!HmcUidIsNull(&adjustEffectId)) {
        auto adjustEffect = HmcDictCreate();
        HmcDictSetInt32(adjustEffect, DICT_KEY_ADJUST_VIGNETTE_ENABLE, isEnableVignette);
        HmcEffectSetProperty(m_editor, adjustEffectId, adjustEffect);
        HmcDictDestroy(adjustEffect);
    }
}

void HveAsset::SwitchPreviewMode(const HmcRectD &cropRect, const HmcRectD &cropOperationArea, bool flag)
{
    if (m_isInPreviewMode) {
        return;
    }

    if (flag) {
        SetAdjustVignetteEnable(true);
    }
    UpdatePreviewMode(cropRect, cropOperationArea);

    m_isInPreviewMode = true;
}

void HveAsset::SwitchCropMode()
{
    if (!m_isInPreviewMode) {
        return;
    }
    SetAdjustVignetteEnable(false);
    UpdateCropMode();
    m_isInPreviewMode = false;
}

void HveAsset::UpdatePreviewMode(const HmcRectD &cropRect, const HmcRectD &cropOperationArea, bool useHotspotsPreScale)
{
    float canvasWidth;
    float canvasHeight;
    HmcEditorGetCanvasSize(m_editor, &canvasWidth, &canvasHeight);

    // 设置裁剪Crop信息
    float left = cropRect.left / canvasWidth;
    float top = 1 - cropRect.top / canvasHeight;
    float right = cropRect.right / canvasWidth;
    float bottom = 1 - cropRect.bottom / canvasHeight;
    HmcAssetCropPosition cropPosition = {{left, top}, {left, bottom}, {right, top}, {right, bottom}};
    HmcAssetCropTransformSetCrop(m_editor, m_assetUid, &cropPosition);

    // 无论是否处于“已预缩放”状态，都应当基于 cropRect/cropOperationArea 重新计算预览缩放。
    // 否则在首次进入裁剪页时 useHotspotsPreScale=false 会把缩放置为 1.0f，
    // 造成图片相对裁剪框偏大/不对齐（UI框正确但图片未按框铺满）。
    m_previewScale = CalcPreviewModeAssetScale(cropRect, cropOperationArea);
    m_previewOffsetX = cropRect.CenterX() - canvasWidth / g_two;
    m_previewOffsetY = canvasHeight / g_two - cropRect.CenterY() + m_previewScale / g_two;
    HmcAssetCropTransformSetPosition(m_editor, m_assetUid, m_previewOffsetX, m_previewOffsetY, m_previewScale,
                                     m_previewScale, 0);

    LOGD("cropRect=[left=%lf, top=%lf, right=%lf, bottom=%lf, width=%lf, height=%lf, OffsetX=%f, OffsetY=%f, Scale=%f]",
         cropRect.left, cropRect.top, cropRect.right, cropRect.bottom, cropRect.Width(), cropRect.Height(),
         m_previewOffsetX, m_previewOffsetY, m_previewScale);

    // setCropAreaEnable(true) 会直接走 UpdatePreviewMode，但如果不更新状态标记，
    // 后续基于 GetInPreviewMode() 的逻辑仍会走 crop 分支，导致“框对但图不对齐”。
    m_isInPreviewMode = true;
}

void HveAsset::setExportSize(const HmcRectD &cropRect)
{
    HmcSize originalSize;
    HmcAssetGetSize(m_editor, m_assetUid, HMC_SIZE_ORIGINAL, &originalSize);
    HmcSize assetSize;
    HmcAssetGetSize(m_editor, m_assetUid, HMC_SIZE_RENDER, &assetSize);

    if (HveAssetOper::AssetSizeIsExchanged(m_baseRotation)) {
        std::swap(assetSize.width, assetSize.height);
        std::swap(originalSize.width, originalSize.height);
    }
    SetExportW(originalSize.width);
    SetExportH(originalSize.height);

    double cropRectWidth = cropRect.Width();
    double cropRectHeight = cropRect.Height();
    if ((cropRectWidth > 0) && (cropRectHeight > 0) && (assetSize.width > 0) && (assetSize.height > 0)) {
        SetExportW(round(cropRectWidth / assetSize.width * originalSize.width));
        SetExportH(round(cropRectHeight / assetSize.height * originalSize.height));
    }
    LOGI("set export size exportW = %d exportH = %d ", GetExportW(), GetExportH());
}

void HveAsset::CleanWatermarkCache()
{
    LOGI("CleanWatermarkCache begin");
    auto editorImp = static_cast<HmcEditorImp *>(m_editor);
    if (editorImp == nullptr) {
        LOGE("editorImp is null ");
        return;
    }
    editorImp->CleanWatermarkCache();
}

void HveAsset::InitWatermarkCache(const HmcRectD &cropRect)
{
    LOGI("cacle InitWatermarkCache");
}

void HveAsset::RefreshWatermarkCropRectAndOpacity(const HmcRectD &cropRect, double watermarkOpacity)
{
    CleanWatermarkCache();
    InitWatermarkCache(cropRect);
    WatermarkParam watermarkParam = {
        .watermarkType = GetWatermarkType(),
        .watermarkOpacity = watermarkOpacity,
        .exportW = GetExportW(),
        .exportH = GetExportH(),
        .isAlwaysShow = 0 };
    HmcAssetSetWatermark(HveAsset::GetAssetUid(), watermarkParam);
}

void HveAsset::RefreshWatermarkCropRect(const HmcRectD &cropRect)
{
    RefreshWatermarkCropRectAndOpacity(cropRect, CanDrawWatermark()? 1 : 0);
}


void HveAsset::RefreshWatermarkXtStyleParam(const HmcRectD &cropRect,bool autoFlush, bool needInitCache)
{
    CleanWatermarkCache();
    bool isContainXtStyle = GetContainXtStyleFlag();
    
    HmcAssetSetWatermarkXtStyleParam(HveAsset::GetAssetUid(), isContainXtStyle, GetXtStyleCode(),
                                     GetXtStyleColor(), GetXtStyleText());
    if (needInitCache) {
        InitWatermarkCache(cropRect);
    } else {
        LOGI("Refresh xt style param without init watermark cache");
    }
     //  刷新水印资源防止卡顿
    if (autoFlush) {
        HMC_EDITOR_SETTER(m_editor);
    }
}

INT32 HveAsset::CalculateFocusPosition(bool isRequestRealPosition, HmcPosition &viewPosition, HmcPosition &realPosition,
    float cropScale)
{
    LOGI("CalculateFocusPosition start");
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(m_assetUid);
    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        LOGE("CalculateFocusPosition, visionAsset is null!");
        return HMC_ERR;
    }

    VECTOR<HmcUid> transformEffectList;
    visionAsset->GetEffectList(transformEffectList, HMC_EFFECT_TRANSFORM);
    if (transformEffectList.empty()) {
        LOGE("CalculateFocusPosition, transform effectList is null!");
        return HMC_ERR;
    }
    auto effect = SINGLETON(HmcUidAdmin)->GetEffect(transformEffectList[0]);
    HmcRenderEffectPtr effectPtr = effect->GetRenderEffectPtr();

    VECTOR<HmcUid> mirrorEffectList;
    visionAsset->GetEffectList(mirrorEffectList, HMC_EFFECT_MIRROR);
    if (mirrorEffectList.empty()) {
        effectPtr->SetParam("mirrorH", 0);
        effectPtr->SetParam("mirrorV", 0);
    } else {
        auto mirrorEffect = SINGLETON(HmcUidAdmin)->GetEffect(mirrorEffectList[0]);
        HmcRenderEffectPtr mirrorEffectPtr = mirrorEffect->GetRenderEffectPtr();
        INT32 mirrorH = 0;
        INT32 mirrorV = 0;
        mirrorEffectPtr->GetParam("mirrorH", mirrorH);
        mirrorEffectPtr->GetParam("mirrorV", mirrorV);
        effectPtr->SetParam("mirrorH", mirrorH);
        effectPtr->SetParam("mirrorV", mirrorV);
    }

    auto editorImp = static_cast<HmcEditorImp *>(m_editor);
    if (editorImp == nullptr) {
        LOGE("editorImp is null ");
        return HMC_ERR;
    }
    HmcSize canvasSize = editorImp->GetCanvasSize();
    LOGI("CalculateFocusPosition viewX=%f viewY=%f realX=%f realY=%f", viewPosition.x, viewPosition.y,
         realPosition.x, realPosition.y);
    return HMC_OK;
}

void HveAsset::UpdateCropMode()
{
    HmcAssetCropPosition cropPosition = {{0, 1}, {0, 0}, {1, 1}, {1, 0}};
    HmcAssetCropTransformSetCrop(m_editor, m_assetUid, &cropPosition);
    HmcAssetCropTransformSetPosition(m_editor, m_assetUid, 0, 0, 1, 1, 0);

    // 与 UpdatePreviewMode 互补：裁剪框禁用/切换时确保清掉预览状态。
    m_isInPreviewMode = false;
}

void HveAsset::SetAdjustVignetteEnable(bool enable)
{
    HmcUid adjustEffectId = FindEffectByType(HMC_EFFECT_ADJUST);
    if (HmcUidIsNull(&adjustEffectId)) {
        return;
    }

    HmcDictHelper dictHelper;
    int result = HmcEffectGetProperty(m_editor, adjustEffectId, dictHelper);
    if (result != HMC_OK) {
        LOGE("get adjust effect property failed with result: %d", result);
        return;
    }

    int vignetteResult = enable;
    int curVignetteEnable = dictHelper[DICT_KEY_ADJUST_VIGNETTE_ENABLE];
    if (!enable) {
        INT32 vignetteValue = dictHelper[DICT_KEY_ADJUST_VIGNETTE];
        isVignetteHasValue = vignetteValue != 0 ? TRUE : FALSE;
        isVignetteHasEnable = curVignetteEnable;
    } else {
        if (!isVignetteHasEnable && !curVignetteEnable) {
            vignetteResult = FALSE;
        }
    }
    
    HmcDictHelper realDictHelper;
    realDictHelper[DICT_KEY_ADJUST_VIGNETTE_ENABLE] = vignetteResult;
    HmcEffectSetProperty(m_editor, adjustEffectId, realDictHelper);
}

void HveAsset::UpdateTransformInfo(const HmcRectD &cropRect, const HmcRectD &cropOperationArea, bool isSave)
{
    if (m_isInPreviewMode) {
        return;
    }

    // 当导出文件时, 如果停留在裁剪页面, 需要根据 “保存” 或 “取消保存” 的动作更新crop和position
    if (isSave) {
        float canvasWidth;
        float canvasHeight;
        HmcEditorGetCanvasSize(m_editor, &canvasWidth, &canvasHeight);
        // 更新 Crop
        float left = cropRect.left / canvasWidth;
        float top = 1 - cropRect.top / canvasHeight;
        float right = cropRect.right / canvasWidth;
        float bottom = 1 - cropRect.bottom / canvasHeight;
        HmcAssetCropPosition cropPosition = { { left, top }, { left, bottom }, { right, top }, { right, bottom } };
        HmcAssetCropTransformSetCrop(m_editor, m_assetUid, &cropPosition);
        // 更新 Position
        float offsetX = cropRect.CenterX() - canvasWidth / 2;
        float offsetY = canvasHeight / 2 - cropRect.CenterY();
        float scale = 1.0;
        HmcAssetCropTransformSetPosition(m_editor, m_assetUid, offsetX, offsetY, scale, scale, 0);

        LOGD(
            "UpdateCompileTransformInfo cropRect=[%lf, %lf, %lf, %lf, %lf, %lf], Offset=[%f, %f], Scale=%f, W=%f, H=%f",
            cropRect.left, cropRect.top, cropRect.right, cropRect.bottom, cropRect.Width(), cropRect.Height(), offsetX,
            offsetY, scale, canvasWidth, canvasHeight);
    } else {
        HmcAssetCropPosition cropPosition = { { 0, 1 }, { 0, 0 }, { 1, 1 }, { 1, 0 } };
        HmcAssetCropTransformSetCrop(m_editor, m_assetUid, &cropPosition);
        HmcAssetCropTransformSetPosition(m_editor, m_assetUid, 0, 0, 1, 1, 0);
    }
}

bool HveAsset::IsAssetPosChange(float precision)
{
    if (fabsf(m_assetHeight - m_assetHeightDefault) > precision ||
        fabsf(m_assetWidth - m_assetWidthDefault) > precision || fabsf(m_assetPosX - m_assetPosXDefault) > precision ||
        fabsf(m_assetPosY - m_assetPosYDefault) > precision) {
        LOGD("IsAssetPosChange assetHeight = %f, assetHeightDefault = %f", m_assetHeight, m_assetHeightDefault);
        LOGD("IsAssetPosChange assetWidth = %f, assetWidthDefault = %f", m_assetWidth, m_assetWidthDefault);
        LOGD("IsAssetPosChange assetPosX = %f, assetPosXDefault = %f", m_assetPosX, m_assetPosXDefault);
        LOGD("IsAssetPosChange assetPosY = %f, assetPosYDefault = %f", m_assetPosY, m_assetPosYDefault);
        return true;
    }
    return false;
}

bool HveAsset::IsAssetPosChangeAndFix(float *assetWidth, float *assetHeight, float *assetPosX, float *assetPosY,
    double cropRectWidth, double cropRectHeight)
{
    if (fabsf(*assetHeight - m_assetHeightDefault) > DEVIATION ||
        fabsf(*assetWidth - m_assetWidthDefault) > DEVIATION || fabsf(*assetPosX - m_assetPosXDefault) > DEVIATION ||
        fabsf(*assetPosY - m_assetPosYDefault) > DEVIATION || fabs(cropRectWidth - m_assetWidthDefault) > DEVIATION ||
        fabs(cropRectHeight - m_assetHeightDefault) > DEVIATION) {
        return true;
    }

    *assetHeight = m_assetHeightDefault;
    *assetWidth = m_assetWidthDefault;
    *assetPosX = m_assetPosXDefault;
    *assetPosY = m_assetPosYDefault;
    return false;
}

bool HveAsset::IsAdjustChange()
{
    for (const auto &item : ADJUST_NAME_LIST) {
        std::string adjustEnableItemName = GetAdjustItemEnableName(item);
        // 开->开 且数据变化
        if (m_adjustEnableValueDefault[adjustEnableItemName] && m_adjustEnableValue[adjustEnableItemName] &&
            std::abs(m_adjustValue[item] - m_adjustValueDefault[item]) > 0.001) {
            return true;
        }

        // 开->关 且默认数据不为0
        if (m_adjustEnableValueDefault[adjustEnableItemName] && !m_adjustEnableValue[adjustEnableItemName] &&
            std::abs(0 - m_adjustValueDefault[item]) > 0.001) {
            return true;
        }

        // 关->开 且数据不为0
        if (!m_adjustEnableValueDefault[adjustEnableItemName] && m_adjustEnableValue[adjustEnableItemName] &&
            std::abs(0 - m_adjustValue[item]) > 0.001) {
            return true;
        }
    }

    return false;
}

Json::Value HveAsset::GetAdjustInfo()
{
    HmcDictHelper dict;
    HmcUid adjustEffectId = HveAssetOper::FindEffectByType(m_editor, m_assetUid, HMC_EFFECT_ADJUST);
    if (!HmcUidIsNull(&adjustEffectId)) {
        HmcEffectGetProperty(m_editor, adjustEffectId, dict);
    }

    int32_t value = 0;
    int32_t enable = 1;

    Json::Value jsonArray;
    for (const auto &adjustItem : ADJUST_NAME_LIST) {
        value = 0;
        enable = 1;
        int errorCode = HmcDictGetInt32(dict, adjustItem.c_str(), &value);
        if (errorCode != HMC_OK) {
            value = 0;
        }

        errorCode = HmcDictGetInt32(dict, GetAdjustItemEnableName(adjustItem).c_str(), &enable);
        if (errorCode != HMC_OK) {
            enable = 1;
        }

        Json::Value json;
        json["name"] = adjustItem.c_str();
        json["value"] = value;
        json["enable"] = enable;
        jsonArray.append(json);
    }

    return jsonArray;
}

bool HveAsset::IsDefaultConfig()
{
    bool isChange = IsAdjustChange();
    if (isChange) {
        LOGI("IsDefaultConfig filter change");
        return false;
    }

    if ((m_mute != m_muteDefault) || (m_trimIn != m_trimInDefault) || (m_trimOut != m_trimOutDefault)) {
        LOGI("IsDefaultConfig default value change");
        return false;
    }

    if ((m_mirror != m_mirrorDefault) || fabs(m_rotationX - m_rotationXDefault) > DEVIATION ||
        fabs(m_rotationY - m_rotationYDefault) > DEVIATION || fabs(m_rotationZ - m_rotationZDefault) > DEVIATION ||
        IsAssetPosChange(DEVIATION)) {
         LOGI("IsDefaultConfig hmc default value change");
         LOGD("IsDefaultConfig hmc m_mirror = %f, m_mirrorDefault = %f", m_mirror, m_mirrorDefault);
         LOGD("IsDefaultConfig hmc m_rotationX = %f, m_rotationXDefault = %f", m_rotationX, m_rotationXDefault);
         LOGD("IsDefaultConfig hmc m_rotationY = %f, m_rotationYDefault = %f", m_rotationY, m_rotationYDefault);
         LOGD("IsDefaultConfig hmc m_rotationZ = %f, m_rotationZDefault = %f", m_rotationZ, m_rotationZDefault);
        return false;
    }
    LOGI("IsDefaultConfig no change");
    return true;
}

double HveAsset::CalcPreviewModeAssetScale(const HmcRectD &cropRect, const HmcRectD &cropOperationArea)
{
    // 为了保证“裁剪框(cropRect)与图片显示区域一致铺满”，
    // 计算预览铺满缩放时不应再额外扩张 cropOperationArea（热点扩张只服务触控热区）。
    // 否则会导致 scale 偏大，出现“框正常但图片相对框偏大/外溢”的现象。
    HmcRectD expandedOperationArea = cropOperationArea;

    float sealHeight = GetExportH() == 0;
    float sealWidth = GetExportW() == 0;
    float dstRatio = (cropRect.Width() + sealWidth) / (cropRect.Height() + sealHeight);
    float rectRatio = expandedOperationArea.Width() / expandedOperationArea.Height();
    double scaleSize;
    if (dstRatio > rectRatio) {
        float assetWidth = expandedOperationArea.Width();
        scaleSize = assetWidth / (cropRect.Width() + sealWidth);
    } else {
        float assetHeight = expandedOperationArea.Height();
        scaleSize = assetHeight / (cropRect.Height() + sealHeight);
    }
    LOGI("HveAsset::CalcPreviewModeAssetScale scaleSize: %f  ", scaleSize);
    return scaleSize;
}

void HveAsset::Reset()
{
    ResetBaseInfo();
    ResetTransform();
    ResetColorAdjust();
}

void HveAsset::ResetBaseInfo()
{
    m_trimIn = 0;
    m_trimOut = 0;

    m_trimInDefault = 0;
    m_trimOutDefault = 0;

    int64_t duration = HmcAssetGetFileDuration(m_editor, m_assetUid);
    HmcEditorSetPreviewPeriodRange(m_editor, 0, duration);

    m_mute = 0;
    m_muteDefault = 0;

    HmcAssetSetMute(m_editor, m_assetUid, 0);

    m_isReEdit = false;

    m_assetOperCbMap.clear();
}

void HveAsset::ResetTransform()
{
    ResetMirror();
    ResetRotation();
    m_ratio = 0.0f;
    m_previewOffsetX = 0.0f;
    m_previewOffsetY = 0.0f;
    m_gestureCenterX = 0.0f;
    m_gestureCenterY = 0.0f;
    m_resetVertex = true;
    m_modifyBoxWidthFlag = false;
    m_fontTypeIndex = 0;
    m_canvasRatio = 1.0f;
    m_ChooseRatio = "0";
    m_baseRotationAssetWidth = 0.0f;
    m_baseRotationAssetHeight = 0.0f;
    m_isRefreshThumbnails = true;
    m_videoInnerAudioVolume = g_percent;

    m_assetPosX = 0;
    m_assetPosY = 0;
    m_assetWidth = 0;
    m_assetHeight = 0;
    m_assetPosXDefault = 0;
    m_assetPosYDefault = 0;
    m_assetWidthDefault = 0;
    m_assetHeightDefault = 0;

    ResetClick90AckCycle();
    ResetClickMirrorCycle();
    ResetRotate90AcwTempValue();
}

void HveAsset::ResetMirror()
{
    m_mirror = 0;
    m_mirrorDefault = 0;
    HmcAssetSetMirror(m_editor, m_assetUid, false, HMC_ASSET_MIRROR_HORIZONTAL);
}

void HveAsset::SetMirrorDefault(bool mirrorFlag) { m_mirrorDefault = mirrorFlag ? 1 : 0; }

void HveAsset::ResetRotation()
{
    m_baseRotation = 0.0f;
    m_rotationX = 0;
    m_rotationY = 0;
    m_rotationZ = 0;

    m_rotationXDefault = 0;
    m_rotationYDefault = 0;
    m_rotationZDefault = 0;

    HmcAssetSetRotation(m_editor, m_assetUid, 0, HMC_AXIS_X);
    HmcAssetSetRotation(m_editor, m_assetUid, 0, HMC_AXIS_Y);
    HmcAssetSetRotation(m_editor, m_assetUid, 0, HMC_AXIS_Z);
}

void HveAsset::ResetColorAdjust()
{
    InitColorAdjustValue();

    HmcUid adjustEffectId = HveAssetOper::FindEffectByType(m_editor, m_assetUid, HMC_EFFECT_ADJUST);
    if (HmcUidIsNull(&adjustEffectId)) {
        return;
    }

    HmcDictHelper dict;
    for (const auto &it : ADJUST_NAME_LIST) {
        std::string adjustItemEnableName = GetAdjustItemEnableName(it);
        dict[it.c_str()] = 0;
        dict[adjustItemEnableName.c_str()] = false;
    }

    int ret = HmcEffectSetProperty(m_editor, adjustEffectId, dict);
    if (ret != HMC_OK) {
        LOGE("reset adjust property failed with error: %d.", ret);
    }
}

void HveAsset::ResetClick90AckCycle() {}

void HveAsset::ResetClickMirrorCycle() {}

void HveAsset::SetInPreviewMode(bool isInPreviewMode)
{
    m_isInPreviewMode = isInPreviewMode;
    HmcAssetSetPreviewMode(m_editor, m_assetUid, isInPreviewMode);
}

bool HveAsset::GetInPreviewMode() const
{
    return m_isInPreviewMode;
}

void HveAsset::SetIsSwitchPage(bool isSwitchPage)
{
    m_isSwitchPage = isSwitchPage;
    HmcAssetSetIsSwitchPage(m_editor, m_assetUid, isSwitchPage);
}

bool HveAsset::GetIsSwitchPage() const
{
    return m_isSwitchPage;
}

void HveAsset::SetShowWatermarkValue(bool isDrawWaterMark)
{
    m_isDrawWaterMark = isDrawWaterMark;
    HmcAssetSetDrawWaterMarkValue(m_editor, m_assetUid, isDrawWaterMark);
}

void HveAsset::RefreshCompareEffectList()
{
    HmcAssetRefreshCompareEffectList(m_editor, m_assetUid);
}

bool HveAsset::GetShowWatermarkValue() const
{
    return m_isDrawWaterMark;
}

void HveAsset::SetIsDragImage(bool isDragImage)
{
    if (m_isDragImage == isDragImage) {
        return;
    }
    m_isDragImage = isDragImage;
    HmcAssetSetIsDragImage(m_editor, m_assetUid, isDragImage);
}

bool HveAsset::GetIsDragImage() const
{
    return m_isDragImage;
}