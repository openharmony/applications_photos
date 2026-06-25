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

#include <cmath>
#include "../Effect/Utils/HmcEffectUtils.h"
#include "../Effect/HmcEffect.h"
#include "../Effect/HmcEffectAdjust.h"
#include "../Effect/HmcEffectTransform.h"
#include "../Effect/HmcEffectMirror.h"
#include "../Effect/HmcEffectCropBlur.h"
#include "../Effect/HmcEffectCompose.h"
#include "HmcService.h"
#include "MediaCreative/HmcDict.h"
#include "MediaCreative/HmcEditorEffect.h"
#include "Project/HmcProjectSerializeKey.h"
#include "ohos/hve/ProjectConfig.h"
#include "util/HmcRectD.h"
#include "Utils/VertexSorter.h"
#include "../Base/util/HmcColorUtil.h"
#include "log/HmcLog.h"
#include "image/HmcImageInfo.h"
#include "HmcVisionAsset.h"

constexpr UINT32 g_HMC_ASSET_CANVAS_WIDTH = 1280;
constexpr UINT32 g_HMC_ASSET_CANVAS_HEIGHT = 720;
constexpr UINT32 g_MAX_EFFECT_COUNT = UINT_MAX;

constexpr UINT32 g_NET_RESOURCE_DEPTH = 5;

namespace {
const float HMC_MATH_PI = 3.1415926f;
}

HmcVisionAsset::HmcVisionAsset() : HmcVisionAsset(HMC_UID_NULL, nullptr) {}

HmcVisionAsset::HmcVisionAsset(HmcUid laneUid, HmcEventHandler *eventHandler)
    : IHmcAsset(laneUid, eventHandler), m_width(0), m_height(0), m_displayWidth(0), m_displayHeight(0), m_rotation(0)
{
    m_effectList.clear();
}

HmcVisionAsset::HmcVisionAsset(const HmcVisionAsset &asset) : IHmcAsset(asset)
{
    m_width = asset.m_width;
    m_height = asset.m_height;
    m_displayWidth = asset.m_displayWidth;
    m_displayHeight = asset.m_displayHeight;
    m_transInfo = asset.m_transInfo;
    m_rotation = asset.m_rotation;
    for (const auto &effectUid : asset.m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (effect != nullptr) {
            auto effectDup = effect->Duplicate();
            if (effectDup) {
                effectDup->SetAssetUid(m_uid);
                m_effectList.push_back(effectDup->GetUid());
            }
        }
    }
    m_cropOffset = asset.m_cropOffset;
}

HmcVisionAsset &HmcVisionAsset::operator = (const HmcVisionAsset &vision)
{
    if (this == &vision) {
        return *this;
    }

    IHmcAsset::operator = (vision);

    m_width = vision.m_width;
    m_height = vision.m_height;
    m_displayWidth = vision.m_displayWidth;
    m_displayHeight = vision.m_displayHeight;
    m_transInfo = vision.m_transInfo;
    m_rotation = vision.m_rotation;
    for (const auto &effectUid : vision.m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (effect != nullptr) {
            auto effectDup = effect->Duplicate();
            if (effectDup) {
                effectDup->SetAssetUid(m_uid);
                m_effectList.push_back(effectDup->GetUid());
            }
        }
    }
    m_cropOffset = vision.m_cropOffset;
    return *this;
}

HmcVisionAsset::~HmcVisionAsset()
{
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        delete effect;
    }
    m_effectList.clear();
    if (m_offScreenEngine) {
        delete m_offScreenEngine;
        m_offScreenEngine = nullptr;
    }
}

INT32 HmcVisionAsset::GetWidth() const
{
    return m_width;
}

INT32 HmcVisionAsset::GetHeight() const
{
    return m_height;
}

HmcSize HmcVisionAsset::GetSize() const
{
    HmcSize size = { 0, 0 };
    FLOAT scaleX = 0.0;
    FLOAT scaleY = 0.0;
    GetZoom(scaleX, scaleY);

    size.width = (float)GetDisplayWidth() * scaleX * GetRenderScale();
    size.height = (float)GetDisplayHeight() * scaleY * GetRenderScale();
    
    LOGD("GetSize scaleX = %f, scaleY = %f, GetDisplayWidth = %d, GetDisplayHeight = %d, GetRenderScale = %f",
        scaleX, scaleY, GetDisplayWidth(), GetDisplayHeight(), GetRenderScale());
    LOGD("GetSize size width = %f, height = %f", size.width, size.height);
    return size;
}

VOID HmcVisionAsset::SetSize(const HmcSize &size)
{
    if (m_width == 0 || m_height == 0) {
        LOGE("Invalid asset size: (%d, %d)", m_width, m_height);
        return;
    }

    float zoomX = (float)size.width / ((float)GetDisplayWidth() * GetRenderScale());
    float zoomY = (float)size.height / ((float)GetDisplayHeight() * GetRenderScale());

    LOGI("size.width=%f, size.height=%f, displayWidth=%d, displayHeight=%d, renderScale=%f, zoomX=%f, zoomY=%f",
         size.width, size.height, GetDisplayWidth(), GetDisplayHeight(), GetRenderScale(), zoomX, zoomY);
    SetZoom(zoomX, zoomY);
}

HmcSize HmcVisionAsset::GetDestSize() const
{
    if (m_destWidth > 0 && m_destHeight > 0) {
        return { m_destWidth, m_destHeight };
    }
    return GetSize();
}

VOID HmcVisionAsset::SetDestSize(const HmcSize &size)
{
    m_destWidth = size.width;
    m_destHeight = size.height;
}

HmcSize HmcVisionAsset::HmcAssetGetCurSize() const
{
    return newAssetSize;
}

VOID HmcVisionAsset::HmcAssetSetCurSize(const HmcSize &size)
{
    newAssetSize.width = size.width;
    newAssetSize.height = size.height;
}

VOID HmcVisionAsset::GetPosition(FLOAT &offsetX, FLOAT &offsetY) const
{
    offsetX = m_transInfo.offsetX.GetValue();
    offsetY = m_transInfo.offsetY.GetValue();
}

VOID HmcVisionAsset::SetPosition(FLOAT offsetX, FLOAT offsetY)
{
    m_transInfo.offsetX.SetValue((FLOAT)offsetX);
    m_transInfo.offsetY.SetValue((FLOAT)offsetY);
}

VOID HmcVisionAsset::GetZoom(FLOAT &scaleX, FLOAT &scaleY) const
{
    scaleX = m_transInfo.scaleX.GetValue();
    scaleY = m_transInfo.scaleY.GetValue();
}

VOID HmcVisionAsset::SetZoom(FLOAT scaleX, FLOAT scaleY)
{
    m_transInfo.scaleX.SetValue((FLOAT)scaleX);
    m_transInfo.scaleY.SetValue((FLOAT)scaleY);
}

FLOAT HmcVisionAsset::GetRotation(HmcRotationAxis axis) const
{
    switch (axis) {
        case HMC_AXIS_X:
            return m_transInfo.rotationX.GetValue();
        case HMC_AXIS_Y:
            return m_transInfo.rotationY.GetValue();
        case HMC_AXIS_Z:
            return m_transInfo.rotationZ.GetValue();
        default:
            LOGE("GetRotation failed, unknown axis: %d", axis);
            return 0;
    }
}

VOID HmcVisionAsset::SetRotation(HmcRotationAxis axis, FLOAT angle)
{
    switch (axis) {
        case HMC_AXIS_X:
            m_transInfo.rotationX.SetValue(angle);
            break;
        case HMC_AXIS_Y:
            m_transInfo.rotationY.SetValue(angle);
            break;
        case HMC_AXIS_Z:
            m_transInfo.rotationZ.SetValue(angle);
            break;
        default:
            LOGE("SetRotation failed, unknown axis: %d", axis);
            break;
    }
}

INT32 HmcVisionAsset::GetBaseRotation() const
{
    return m_rotation;
}

VOID HmcVisionAsset::GetRotation(FLOAT &angleX, FLOAT &angleY, FLOAT &angleZ) const
{
    angleX = m_transInfo.rotationX.GetValue();
    angleY = m_transInfo.rotationY.GetValue();
    angleZ = m_transInfo.rotationZ.GetValue();
}

VOID HmcVisionAsset::SetRotation(FLOAT angleX, FLOAT angleY, FLOAT angleZ)
{
    m_transInfo.rotationX.SetValue(angleX);
    m_transInfo.rotationY.SetValue(angleY);
    m_transInfo.rotationZ.SetValue(angleZ);
}

FLOAT HmcVisionAsset::GetOpacity() const
{
    return m_transInfo.opacity.GetValue();
}

VOID HmcVisionAsset::SetOpacity(FLOAT opacity)
{
    if (opacity < 0 || opacity > 1) {
        LOGD("SetTransformOpacity opacity invalid");
        opacity = opacity < 0 ? 0 : 1;
    }
    m_transInfo.opacity.SetValue((FLOAT)opacity);
}

BOOL HmcVisionAsset::GetMirrorHorizontal() const
{
    return m_transInfo.mirrorHorizontal.GetValue();
}

VOID HmcVisionAsset::SetMirrorHorizontal(BOOL mirror)
{
    m_transInfo.mirrorHorizontal.SetValue(mirror);
}

BOOL HmcVisionAsset::GetMirrorVertical() const
{
    return m_transInfo.mirrorVertical.GetValue();
}

VOID HmcVisionAsset::SetMirrorVertical(BOOL mirror)
{
    m_transInfo.mirrorVertical.SetValue(mirror);
}

VisionTransformInfo HmcVisionAsset::GetTransformInfo() const
{
    VisionTransformInfo transInfo;

    /* 支持关键帧的属性，获取时，需要调用GetAnimationProperty接口来获取 */
    FLOAT scaleX = 0.0f;
    FLOAT scaleY = 0.0f;
    GetZoom(scaleX, scaleY);
    transInfo.scaleX.SetValue(scaleX);
    transInfo.scaleY.SetValue(scaleY);
    transInfo.rotationX.SetValue(GetRotation(HMC_AXIS_X));
    transInfo.rotationY.SetValue(GetRotation(HMC_AXIS_Y));
    transInfo.rotationZ.SetValue(GetRotation(HMC_AXIS_Z));
    transInfo.opacity.SetValue(GetOpacity());

    FLOAT offsetX = 0.0f;
    FLOAT offsetY = 0.0f;
    GetPosition(offsetX, offsetY);
    transInfo.offsetX.SetValue(offsetX);
    transInfo.offsetY.SetValue(offsetY);

    transInfo.ratioX = GetRenderScale();
    transInfo.ratioY = transInfo.ratioX;
    transInfo.refX = m_transInfo.refX;
    transInfo.refY = m_transInfo.refY;
    transInfo.mirrorHorizontal.SetValue(GetMirrorHorizontal());
    transInfo.mirrorVertical.SetValue(GetMirrorVertical());

    return transInfo;
}

VOID HmcVisionAsset::UpdatePositionByWindowRatio(FLOAT ratioX, FLOAT ratioY)
{
    float offsetX = 0.0f;
    float offsetY = 0.0f;
    GetPosition(offsetX, offsetY);
    m_transInfo.offsetX.SetValue(offsetX * ratioX);
    m_transInfo.offsetY.SetValue(offsetY * ratioY);
}

VECTOR<FLOAT> HmcVisionAsset::GetVertexPosition()
{
    VisionTransformInfo transformInfo = GetTransformInfo();
    INT32 textureWidth = GetWidth();
    INT32 textureHeight = GetHeight();
    HmcSize canvasSize;
    m_eventHandler->OnGetData(HMC::GET_DATA_CANVAS_SIZE, nullptr, &canvasSize);
    float viewPortX = canvasSize.width;
    float viewPortY = canvasSize.height;

    VECTOR<FLOAT> vertex = MathUtils::CalVertexPos((float)transformInfo.offsetX.GetValue(),
        (float)transformInfo.offsetY.GetValue(), (float)transformInfo.scaleX.GetValue(),
        (float)transformInfo.scaleY.GetValue(), (float)transformInfo.ratioX, (float)transformInfo.ratioY,
        (float)transformInfo.rotationX.GetValue(), (float)transformInfo.rotationY.GetValue(),
        (float)transformInfo.rotationZ.GetValue(), textureWidth, textureHeight, (float)viewPortX, (float)viewPortY,
        (float)transformInfo.refX, (float)transformInfo.refY, (BOOL)transformInfo.mirrorHorizontal.GetValue());
    LOGI("GetVertexPosition texture=%d,%d canvas=%f,%f CalVertexPos=%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf", textureWidth,
        textureHeight, viewPortX, viewPortY, vertex.at(0), vertex.at(1), vertex.at(2), vertex.at(3), vertex.at(4),
        vertex.at(5), vertex.at(6), vertex.at(7));
    // Canvas坐标转换到数学坐标系
    vertex[1] = -vertex[1];
    vertex[3] = -vertex[3];
    vertex[5] = -vertex[5];
    vertex[7] = -vertex[7];

    VECTOR<FLOAT> sorted = SortVertex(vertex);

    // 数学坐标系转换到Canvas坐标
    sorted[1] = -sorted[1];
    sorted[3] = -sorted[3];
    sorted[5] = -sorted[5];
    sorted[7] = -sorted[7];
    return sorted;
}

HmcImage *HmcVisionAsset::GetPreview(INT64 timestamp, bool exactMode)
{
    HMC_UNUSED(timestamp);

    return nullptr;
}

VOID HmcVisionAsset::GetAssetParamValue(HmcDict *dict) const
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return;
    }

    IHmcAsset::GetAssetParamValue(dict);

    HmcDictSetInt32(dict, DICT_KEY_ASSET_PROPERTY_WIDTH, m_width);
    HmcDictSetInt32(dict, DICT_KEY_ASSET_PROPERTY_HEIGHT, m_height);
}

BOOL HmcVisionAsset::Init(const HmcDict *dict)
{
    if (!IHmcAsset::Init(dict)) {
        return FALSE;
    }

    DOUBLE doubleValue = 0.0;
    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_OFFSET_X, &doubleValue) == HMC_OK) {
        m_transInfo.offsetX.SetValue(static_cast<FLOAT>(doubleValue));
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_OFFSET_Y, &doubleValue) == HMC_OK) {
        m_transInfo.offsetY.SetValue(static_cast<FLOAT>(doubleValue));
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONX, &doubleValue) == HMC_OK) {
        m_transInfo.rotationX.SetValue(static_cast<FLOAT>(doubleValue));
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONY, &doubleValue) == HMC_OK) {
        m_transInfo.rotationY.SetValue(static_cast<FLOAT>(doubleValue));
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONZ, &doubleValue) == HMC_OK) {
        m_transInfo.rotationZ.SetValue(static_cast<FLOAT>(doubleValue));
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_SCALE, &doubleValue) == HMC_OK) {
        m_transInfo.scale = static_cast<FLOAT>(doubleValue);
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_SCALE_X, &doubleValue) == HMC_OK) {
        m_transInfo.scaleX.SetValue(static_cast<FLOAT>(doubleValue));
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_SCALE_Y, &doubleValue) == HMC_OK) {
        m_transInfo.scaleY.SetValue(static_cast<FLOAT>(doubleValue));
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_RATIO_X, &doubleValue) == HMC_OK) {
        m_transInfo.ratioX = static_cast<FLOAT>(doubleValue);
    }

    if (HmcDictGetDouble(dict, DICT_KEY_ASSET_PROPERTY_TRANS_RATIO_Y, &doubleValue) == HMC_OK) {
        m_transInfo.ratioY = static_cast<FLOAT>(doubleValue);
    }

    InitMode(dict);
    return TRUE;
}

VOID HmcVisionAsset::InitMode(const HmcDict *dict)
{
    INT32 intValue = 0;
    if (HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_MIRROR_HORIZONTAL, &intValue) == HMC_OK) {
        m_transInfo.mirrorHorizontal.SetValue(static_cast<BOOL>(intValue));
    }

    if (HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_MIRROR_VERTICAL, &intValue) == HMC_OK) {
        m_transInfo.mirrorVertical.SetValue(static_cast<BOOL>(intValue));
    }

    if (HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_WIDTH, &intValue) == HMC_OK) {
        m_width = intValue;
    }

    if (HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_HEIGHT, &intValue) == HMC_OK) {
        m_height = intValue;
    }
}

VOID HmcVisionAsset::SetAssetParamValue(const HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return;
    }

    IHmcAsset::SetAssetParamValue(dict);

    INT32 value = 0;
    if (HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_WIDTH, &value) == HMC_OK) {
        LOGI("set asset width to: %d", value);
        m_width = value;
    }
    if (HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_HEIGHT, &value) == HMC_OK) {
        LOGI("set asset height to: %d", value);
        m_height = value;
    }
}

VOID HmcVisionAsset::SerializeTransInfo(Json::Value &json) const
{
    json[DICT_KEY_ASSET_PROPERTY_TRANS_OFFSET_X] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.offsetX);
    json[DICT_KEY_ASSET_PROPERTY_TRANS_OFFSET_Y] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.offsetY);
    json[DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONX] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.rotationX);
    json[DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONY] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.rotationY);
    json[DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONZ] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.rotationZ);

    json[DICT_KEY_ASSET_PROPERTY_TRANS_SCALE] = m_transInfo.scale;
    json[DICT_KEY_ASSET_PROPERTY_TRANS_SCALE_X] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.scaleX);
    json[DICT_KEY_ASSET_PROPERTY_TRANS_SCALE_Y] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.scaleY);
    json[DICT_KEY_ASSET_PROPERTY_TRANS_RATIO_X] = m_transInfo.ratioX;
    json[DICT_KEY_ASSET_PROPERTY_TRANS_RATIO_Y] = m_transInfo.ratioY;
    json[DICT_KEY_ASSET_PROPERTY_MIRROR_HORIZONTAL] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.mirrorHorizontal);
    json[DICT_KEY_ASSET_PROPERTY_MIRROR_VERTICAL] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.mirrorVertical);
    json[DICT_KEY_ASSET_PROPERTY_TRANS_OPACITY] =
        SINGLETON(HmcDefaultValueManager)->SerializeProperty(m_transInfo.opacity);
}

Json::Value HmcVisionAsset::Serialize()
{
    Json::Value json = IHmcAsset::Serialize();

    json[DICT_KEY_ASSET_PROPERTY_WIDTH] = (Json::Value::Int)m_width;
    json[DICT_KEY_ASSET_PROPERTY_HEIGHT] = (Json::Value::Int)m_height;
    SerializeTransInfo(json);

    json[PROJECT_KEY_ASSET_CROP_OFFSET_X] = m_cropOffset.offsetX;
    json[PROJECT_KEY_ASSET_CROP_OFFSET_Y] = m_cropOffset.offsetY;

    HMC_MUTEX_LOCK(m_locker);
    Json::Value effectList;
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        // crop transform不需要保存到草稿。（恢复会导致草稿恢复后，预览画面会存在短暂的之前放大的效果，再回到正常大小）
        if (effect != nullptr && effect->GetType() != HMC_EFFECT_NONE && effect->GetType() != HMC_EFFECT_CROP_BLUR) {
            Json::Value jsonEffect = effect->Serialize();
            effectList.append(jsonEffect);
        }
    }
    HMC_MUTEX_UNLOCK(m_locker);

    json[DICT_KEY_ASSET_PROPERTY_EFFECT] = effectList;

    LOGD("Serialize effect list size: %d", m_effectList.size());

    return json;
}

BOOL HmcVisionAsset::Deserialize(const Json::Value &jsonData)
{
    // todo: 解析json前需要判断json中有没有对应的字段，字段类型是否正确
    if (!IHmcAsset::Deserialize(jsonData)) {
        LOGE("deserialize hmc asset failed");
        return FALSE;
    }  

    JsonValueUtil::ParseValueIfHas(jsonData, DICT_KEY_ASSET_PROPERTY_WIDTH, m_width);
    JsonValueUtil::ParseValueIfHas(jsonData, DICT_KEY_ASSET_PROPERTY_HEIGHT, m_height);

    if (!DeserializeTransInfo(jsonData)) {
        return FALSE;
    }

    if (!DeserializeCrop(jsonData)) {
        return FALSE;
    }

    Json::Value effectList = jsonData[DICT_KEY_ASSET_PROPERTY_EFFECT];
    HMC_MUTEX_LOCK(m_locker);
    for (const auto &jsonData : effectList) {
        HmcEffect *effect = CreateEffect(jsonData);
        if (effect != nullptr) {
            if (effect->Init() != TRUE) {
                LOGE("init effect failed");
                delete effect;
                continue;
            }
            m_effectList.emplace_back(effect->GetUid());
            effect->SetAssetUid(m_uid);

            HmcDict *dict = HmcDictCreate();
            HmcDictSetPointer(dict, "effect", effect->GetRenderEffectPtr().get());
            m_eventHandler->OnEventNotify(HMC::EVENT_INIT_INNER_EFFECT, dict, nullptr);
        }
    }
    HMC_MUTEX_UNLOCK(m_locker);
    LOGD("Deserialize effect list size: %d", m_effectList.size());

    return TRUE;
}

BOOL HmcVisionAsset::DeserializeTransInfo(const Json::Value &jsonData)
{
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_TRANS_OFFSET_X, m_transInfo.offsetX);
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_TRANS_OFFSET_Y, m_transInfo.offsetY);
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONX, m_transInfo.rotationX);
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONY, m_transInfo.rotationY);
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONZ, m_transInfo.rotationZ);

    m_transInfo.scale = jsonData[DICT_KEY_ASSET_PROPERTY_TRANS_SCALE].asFloat();
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_TRANS_SCALE_X, m_transInfo.scaleX);
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_TRANS_SCALE_Y, m_transInfo.scaleY);
    m_transInfo.ratioX = jsonData[DICT_KEY_ASSET_PROPERTY_TRANS_RATIO_X].asFloat();
    m_transInfo.ratioY = jsonData[DICT_KEY_ASSET_PROPERTY_TRANS_RATIO_Y].asFloat();
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_MIRROR_HORIZONTAL, m_transInfo.mirrorHorizontal);
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_MIRROR_VERTICAL, m_transInfo.mirrorVertical);
    SINGLETON(HmcDefaultValueManager)
        ->DeserializeProperty(jsonData, DICT_KEY_ASSET_PROPERTY_TRANS_OPACITY, m_transInfo.opacity);

    return TRUE;
}

BOOL HmcVisionAsset::DeserializeCrop(const Json::Value &jsonData)
{
    JsonValueUtil::ParseFloatIfHas(jsonData, PROJECT_KEY_ASSET_CROP_OFFSET_X, m_cropOffset.offsetX);
    JsonValueUtil::ParseFloatIfHas(jsonData, PROJECT_KEY_ASSET_CROP_OFFSET_Y, m_cropOffset.offsetY);

    return TRUE;
}

BOOL HmcVisionAsset::InitEffect()
{
    AddTransformEffect();

    return TRUE;
}

VOID HmcVisionAsset::AddTransformEffect()
{
    VECTOR<HmcUid> effectList;
    GetEffectList(effectList, HMC_EFFECT_TRANSFORM);
    if (effectList.empty()) {
        HmcDict *dict = HmcDictCreate();
        HmcDictSetString(dict, DICT_KEY_EFFECT_NAME, HmcDefault::EFFECT_TRANSFORM_DEFAULT_NAME);
        HmcDictSetInt32(dict, DICT_KEY_EFFECT_TYPE, HMC_EFFECT_TRANSFORM);
        (VOID)AddEffect(dict);

        HmcDictDestroy(dict);
    }
}

void HmcVisionAsset::SetNewWatermarkPara(HmcDict *&dict, JsonCpp::Value &values, std::string &filterName,
                                         std::string &directory)
{
    std::string shotSign = values[PROJECT_KEY_WATERMARK_FILTER_SHOT_SIGN].asString();
    std::string shotParm = values[PROJECT_KEY_WATERMARK_FILTER_SHOT_PARAM].asString();
    std::string shotDate = values[PROJECT_KEY_WATERMARK_FILTER_SHOT_DATE].asString();
    std::string shotLocation = values[PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION].asString();
    std::string userInput = values[PROJECT_KEY_WATERMARK_FILTER_STICKER_DEFINITION].asString();
    int32_t watermarkBackgroundType = values[PROJECT_KEY_WATERMARK_FILTER_BACKGROUND_TYPE].asInt();
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_PARAM, shotParm.empty() ? 0 : 1);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_DATE, shotDate.empty() ? 0 : 1);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_LOCATION, shotLocation.empty() ? 0 : 1);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_FILTER_BACKGROUND_TYPE, watermarkBackgroundType);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_DIRECTORY,
                     IsEditorSwitchEnable(HIDE_WATERMARK_ENABLE) ? directory.c_str() : directory.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_SHOT_SIGN, shotSign.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_SHOT_SIGN_FONT, SHOT_SIGN_FONT);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION, shotLocation.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_STICKER_DEFINITION, userInput.c_str());
    LOGI("editData shotParm = %s , shotDate = %s  shotSign = %s", shotParm.c_str(), shotDate.c_str(), shotSign.c_str());
}

void CAMOUFLAGE_DIRECTORY() {

}

void HmcVisionAsset::SetInPlaceStickerPara(HmcDict *dict, Json::Value &values) {
    STRING directory = HmcMaterialJsonUtil::GetString(PROJECT_KEY_WATERMARK_DIRECTORY, values, "");
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_TYPE, HMC_ASSET_IN_PLACE_STICKER);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_PARAM, 1);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_DIRECTORY,
                     IsEditorSwitchEnable(HIDE_WATERMARK_ENABLE) ? directory.c_str() : directory.c_str());
}

void HmcVisionAsset::SetTimingStickerPara(HmcDict *dict, Json::Value &values, INT32 isCameraEditData) {
    std::string shotLocation = values[PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION].asString();
    std::string definition = values[PROJECT_KEY_WATERMARK_FILTER_STICKER_DEFINITION].asString();
    std::string shotDate = values[PROJECT_KEY_WATERMARK_FILTER_SHOT_DATE].asString();
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_TYPE, HMC_ASSET_IN_PLACE_STICKER);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_DATE, shotDate.empty() ? 0 : 1);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_LOCATION, shotLocation.empty() ? 0 : 1);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION,
                     shotLocation.empty() ? "" : shotLocation.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_STICKER_DEFINITION,
                     definition.empty() ? "" : definition.c_str());

    // Before HMOS 6.0, TimingSticker may be empty if only has date option
    bool hasSelect = !shotLocation.empty() || !definition.empty() || !shotDate.empty();
    if (!hasSelect && !isCameraEditData) {
        HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_DATE, 1);
    }
}

void HmcVisionAsset::SetFrameStickerPara(HmcDict *dict, Json::Value &values) {
    STRING directory = HmcMaterialJsonUtil::GetString(PROJECT_KEY_WATERMARK_DIRECTORY, values, "");
    std::string shotLocation = values[PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION].asString();
    std::string definition = values[PROJECT_KEY_WATERMARK_FILTER_STICKER_DEFINITION].asString();
    std::string shotParm = values[PROJECT_KEY_WATERMARK_FILTER_SHOT_PARAM].asString();
    std::string shotDate = values[PROJECT_KEY_WATERMARK_FILTER_SHOT_DATE].asString();
    LOGI("FrameSticker editData: shotParm = %s , shotDate = %s", shotParm.c_str(), shotDate.c_str());
    LOGI("FrameSticker exifInfo: shotParm = %s , shotDate = %s", GetShotParam().c_str(), GetShotDate().c_str());
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_TYPE, HMC_ASSET_FRAME_STICKER);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_PARAM, shotParm.empty() ? 0 : 1);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_DATE, shotDate.empty() ? 0 : 1);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_DIRECTORY,
                     IsEditorSwitchEnable(HIDE_WATERMARK_ENABLE) ? directory.c_str() : directory.c_str());
    SetXtStyleParamToWatermark(dict, values);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_LOCATION, shotLocation.empty() ? 0 : 1);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION,
                     shotLocation.empty() ? "" : shotLocation.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_STICKER_DEFINITION,
                     definition.empty() ? "" : definition.c_str());
}

void HmcVisionAsset::SetXtStyleStickerPara(HmcDict *dict, Json::Value &values) {
    STRING directory = HmcMaterialJsonUtil::GetString(PROJECT_KEY_WATERMARK_DIRECTORY, values, "");
    std::string shotLocation = values[PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION].asString();
    std::string shotParm = values[PROJECT_KEY_WATERMARK_FILTER_SHOT_PARAM].asString();
    std::string shotDate = values[PROJECT_KEY_WATERMARK_FILTER_SHOT_DATE].asString();
    LOGI("XtStyleSticker editData: shotParm = %s , shotDate = %s", shotParm.c_str(), shotDate.c_str());
    LOGI("XtStyleSticker exifInfo: shotParm = %s , shotDate = %s", GetShotParam().c_str(), GetShotDate().c_str());
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_TYPE, HMC_ASSET_XT_STYLE_FRAME_STICKER);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_PARAM, shotParm.empty() ? 0 : 1);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_DATE, shotDate.empty() ? 0 : 1);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_DIRECTORY,
                     IsEditorSwitchEnable(HIDE_WATERMARK_ENABLE) ? directory.c_str() : directory.c_str());
    SetXtStyleParamToWatermark(dict, values);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_LOCATION, shotLocation.empty() ? 0 : 1);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION,
                     shotLocation.empty() ? "" : shotLocation.c_str());
}

void HmcVisionAsset::SetXtStyleParamToWatermark(const void *dict, Json::Value &values) const
{
    std::string xt_definition = values[PROJECT_KEY_WATERMARK_FILTER_XT_DEFINITION].asString();
    std::string xt_param = values[PROJECT_KEY_WATERMARK_FILTER_XT_PARAM].asString();
    std::string xt_color = values[PROJECT_KEY_WATERMARK_FILTER_XT_COLOR].asString();
    bool isEnable = values[PROJECT_KEY_WATERMARK_FILTER_XT_ENABLE].asBool();
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_XT_STYLE, isEnable);
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_XT_DEFINITION, xt_definition.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_XT_PARAM, xt_param.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_XT_COLOR, xt_color.c_str());   
    LOGI("editData: watermark isContainXtStyle = %d , xt_definition = %s", isEnable,
         xt_definition.c_str());
    LOGI("editData: watermark xt_param = %s , xt_color = %s", xt_param.c_str(), xt_color.c_str());
}

INT32 HmcVisionAsset::Denormalize(float normalizedValue, int minValue, int maxValue)
{
    return normalizedValue * (maxValue - minValue) + minValue;
}

void HmcVisionAsset::InitEffectWithEditData(std::string editData, INT32 isMediaSource, INT32 isFrontCamera,
                                            INT32 isCameraEditData)
{
    HMC_TRACE_GUARD("InitEffectWithEditData");
    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(editData, jsonEditData);
    if (!parseResult) {
        LOGE("apply edit data failed because of parsing data to json object.");
        return;
    }
    Json::Value imageEffect = jsonEditData["imageEffect"];
    Json::Value jsonFilters = imageEffect["filters"];
    // 媒体库效果图，只恢复水印编辑数据
    if (isMediaSource == 1) {
        LOGI("only init watermark effect. isMediaSource:%d", isMediaSource);
        return;
    }
}

VOID HmcVisionAsset::SetExportWidthAndHeight(std::string editData, INT32 isMediaSource)
{
    if (isMediaSource == 0) {
        LOGI("no need to set export height. isMediaSource:%d", isMediaSource);
        return;
    }

    Json::Reader reader;
    Json::Value jsonEditData;
    bool parseResult = reader.parse(editData, jsonEditData);
    if (!parseResult) {
        LOGE("apply edit data failed because of parsing data to json object.");
        return;
    }
    if (!JsonValueUtil::IsMemberAndNotNull(jsonEditData, "imageEffect")) {
        return;
    }
    Json::Value imageEffect = jsonEditData["imageEffect"];
    if (!JsonValueUtil::IsMemberAndNotNull(imageEffect, "filters")) {
        return;
    }
    Json::Value jsonFilters = imageEffect["filters"];
    for (const auto &filter : jsonFilters) {
        if (!JsonValueUtil::IsMemberAndNotNull(filter, "name") ||
            !JsonValueUtil::IsMemberAndNotNull(filter, "values")) {
            continue;
        }
        std::string filterName = filter["name"].asString();
        if (filterName == "FrameSticker" || filterName == "XtStyleSticker" || filterName == "BorderSticker" ||
            filterName =="FrostedSticker" || filterName == "FestivalSticker" ||
            filterName == "PersonalizedStickerStyle1") {
            Json::Value values = filter["values"];
            INT32 inputHeight = 0;
            INT32 inputWidth = 0;
            JsonValueUtil::ParseValueIfHas(values, "inputHeight", inputHeight);
            JsonValueUtil::ParseValueIfHas(values, "inputWidth", inputWidth);
            m_exportHeight = inputHeight;
            m_exportWidth = inputWidth;
        }
    }
}

VOID HmcVisionAsset::AddMirrorEffect()
{
    VECTOR<HmcUid> effectList;
    GetEffectList(effectList, HMC_EFFECT_MIRROR);
    if (effectList.empty()) {
        HmcDict *dict = HmcDictCreate();
        HmcDictSetString(dict, DICT_KEY_EFFECT_NAME, HmcDefault::EFFECT_MIRROR_DEFAULT_NAME);
        HmcDictSetInt32(dict, DICT_KEY_EFFECT_TYPE, HMC_EFFECT_MIRROR);
        (VOID)AddEffect(dict);

        HmcDictDestroy(dict);
    }
}

HmcEffect *HmcVisionAsset::CreateEffectResult(HmcDict *dict)
{
    HmcEffectType type = HmcEffectUtils::GetEffectType(dict);
    HmcEffect *effect = CreateEffectEntity(type);
    if (effect == nullptr) {
        LOGE("Create effect entity failed");
        return nullptr;
    }
    if (effect->Init(dict) != TRUE) {
        LOGE("Init effect failed");
        delete effect;
        effect = nullptr;
    }
    return effect;
}

VOID HmcVisionAsset::AddEffect(const HmcUid &effectUid, INT32 index)
{
    HMC_MUTEX_LOCK(m_locker);
    auto idx = static_cast<size_t>(index);
    if (index < 0 || idx >= m_effectList.size()) {
        m_effectList.push_back(effectUid);
    } else {
        auto iter = m_effectList.begin();
        std::advance(iter, index);
        m_effectList.insert(iter, effectUid);
    }
    HMC_MUTEX_UNLOCK(m_locker);
}

HmcUid HmcVisionAsset::AddEffect(HmcDict *dict)
{
    HmcUid effectUid = HMC_UID_NULL;

    HMC_MUTEX_LOCK(m_locker);
    do {
        if (m_effectList.size() >= g_MAX_EFFECT_COUNT) {
            LOGE("effect count beyond %u", g_MAX_EFFECT_COUNT);
            break;
        }

        auto materialCloudId = HmcEffectUtils::GetEffectMaterialCloudIdFromDict(dict);
        effectUid = GetEffectByMaterial(materialCloudId);
        if (!HmcUidIsNull(&effectUid)) {
            break;
        }

        HmcEffectType type = HmcEffectUtils::GetEffectType(dict);

        HmcEffect *effect = nullptr;
        if (HmcEffectUtils::IsUniqueEffect(type)) {
            effect = ReplaceEffect(dict, true);
        } else {
            effect = CreateEffect(dict);
        }

        if (effect == nullptr) {
            LOGE("create effect failed");
            break;
        }

        effectUid = effect->GetUid();

        INT32 index = -1;
        (VOID)HmcDictGetInt32(dict, DICT_KEY_EFFECT_INDEX, &index);
        AddEffect(effectUid, index);
    } while (false);
    HMC_MUTEX_UNLOCK(m_locker);

    return effectUid;
}

INT32 HmcVisionAsset::InsertEffect(const HmcUid &effectUid, unsigned int index)
{
    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        LOGE("invalid effect uid");
        return HMC_ERR_PARAM;
    }

    HMC_MUTEX_GUARD(m_locker);

    auto effectCount = m_effectList.size();
    if (index > effectCount) {
        m_effectList.push_back(effectUid);
    } else {
        auto it = m_effectList.begin();
        std::advance(it, index);
        m_effectList.insert(it, effectUid);
    }

    effect->SetAssetUid(m_uid);
    effect->OnAssetDurationChange(m_complexDuration.GetTime());

    return HMC_OK;
}

UINT32 HmcVisionAsset::GetEffectCount(HmcEffectType type) const
{
    HMC_MUTEX_LOCK(m_locker);
    UINT32 size = 0;
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (effect != nullptr) {
            if (effect->GetType() == type || type == HMC_EFFECT_NONE) {
                size++;
            }
        }
    }
    HMC_MUTEX_UNLOCK(m_locker);
    return size;
}

VOID HmcVisionAsset::GetEffectList(VECTOR<HmcUid> &effectList, HmcEffectType type) const
{
    effectList.clear();
    HMC_MUTEX_LOCK(m_locker);
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (!effect) {
            continue;
        }
        if (effect->GetType() == type || type == HMC_EFFECT_NONE) {
            effectList.push_back(effectUid);
        }
    }
    HMC_MUTEX_UNLOCK(m_locker);
}

VOID HmcVisionAsset::GetEffectList(VECTOR<HmcUid> &effectList) const
{
    effectList.clear();
    HMC_MUTEX_LOCK(m_locker);
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (!effect) {
            continue;
        }

        effectList.push_back(effectUid);
    }
    HMC_MUTEX_UNLOCK(m_locker);
}

VOID HmcVisionAsset::GetEffectList(VECTOR<HmcUid> &effectList, const VECTOR<HmcEffectType> &typeList) const
{
    effectList.clear();
    for (auto type : typeList) {
        VECTOR<HmcUid> effectListTemp;
        GetEffectList(effectListTemp, type);
        effectList.insert(effectList.end(), effectListTemp.begin(), effectListTemp.end());
    }
}

VOID HmcVisionAsset::RemoveEffect(const HmcUid &effectUid)
{
    HMC_MUTEX_LOCK(m_locker);
    for (auto iter = m_effectList.begin(); iter != m_effectList.end(); iter++) {
        if (HmcUidIsEqual(&(*iter), &effectUid)) {
            auto effect = SINGLETON(HmcUidAdmin)->GetEffect(*iter);
            if (effect != nullptr) {
                effect->SetAssetUid(HMC_UID_NULL);
            }
            char strUid[HMC_UID_STR_LEN] = { 0 };
            HmcUidToString(&effectUid, strUid, HMC_UID_STR_LEN);
            HmcDict *dict = HmcDictCreate();
            STRING name = strUid;
            HmcDictSetString(dict, "name", name.c_str());
            m_eventHandler->OnEventNotify(HMC::EVENT_REMOVE_EFFECT, dict, nullptr);

            m_effectList.erase(iter);
            break;
        }
    }
    HMC_MUTEX_UNLOCK(m_locker);
}

VOID HmcVisionAsset::RemoveEffectByType(HmcEffectType effectType)
{
    HMC_MUTEX_LOCK(m_locker);
    for (auto iter = m_effectList.begin(); iter != m_effectList.end();) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(*iter);
        if (effect == nullptr) {
            continue;
        }

        if (effect->GetType() == effectType) {
            delete effect;
            iter = m_effectList.erase(iter);
        } else {
            ++iter;
        }
    }
    HMC_MUTEX_UNLOCK(m_locker);
}

VOID HmcVisionAsset::RemoveAllEffects()
{
    HMC_MUTEX_LOCK(m_locker);
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (effect != nullptr) {
            effect->SetAssetUid(HMC_UID_NULL);
        }
    }
    m_effectList.clear();
    HMC_MUTEX_UNLOCK(m_locker);
}

BOOL HmcVisionAsset::GetEffectIndex(const HmcUid &effectUid, unsigned int &index) const
{
    unsigned int indexTemp = 0;
    for (const auto &uid : m_effectList) {
        if (HmcUidIsEqual(&uid, &effectUid)) {
            index = indexTemp;
            return TRUE;
        } else {
            indexTemp++;
        }
    }

    return FALSE;
}

BOOL HmcVisionAsset::AdvanceEffect(HmcUid effectUid, int distance)
{
    if (distance == 0) { // 距离为0，表示不移动
        return TRUE;
    }

    BOOL result = FALSE;
    int index = 0;

    HMC_MUTEX_LOCK(m_locker);
    for (auto iter = m_effectList.begin(); iter != m_effectList.end(); iter++) {
        if (HmcUidIsEqual(&effectUid, &(*iter))) {
            int size = static_cast<int>(m_effectList.size());
            if ((distance < 0 && abs(distance) > index) || (distance > 0 && distance > (size - index))) {
                LOGE("invalid advance distance");
                break;
            } else {
                auto oldIter = iter;
                std::advance(iter, distance);
                m_effectList.insert(iter, effectUid);
                m_effectList.erase(oldIter);
                result = TRUE;
                break;
            }
        }
        index++;
    }
    HMC_MUTEX_UNLOCK(m_locker);

    return result;
}

bool IsTransformEffect(HmcUid uid)
{
    auto effect = SINGLETON(HmcUidAdmin)->GetEffect(uid);
    if (effect && effect->GetType() == HMC_EFFECT_TRANSFORM) {
        return TRUE;
    }

    return FALSE;
}

int GetDepth(HmcUid uid)
{
    // 调色 -> 滤镜 -> transform -> 镜像 -> 蒙版
    MAP<HmcEffectType, int> checkParam = {
        { HMC_EFFECT_ADJUST, 3 }, { HMC_EFFECT_TRANSFORM, 5 },
        { HMC_EFFECT_MIRROR, 6 }, { HMC_EFFECT_CROP_BLUR, 7 }, { HMC_EFFECT_COMPOSE, 8 },
    };

    auto effect = SINGLETON(HmcUidAdmin)->GetEffect(uid);
    if (effect == NULL) {
        return 0;
    }
    // 用户特效 和滤镜 等网络素材返回2
    auto ite = checkParam.find(effect->GetType());
    if (ite == checkParam.end()) {
        return g_NET_RESOURCE_DEPTH;
    }
    return checkParam[effect->GetType()];
}

// 视频 -> 光场 -> 调色 ->人像分割 -> 用户特效1~N -> 抠像 -> 镜像 -> 裁剪 -> 蒙版 -> transform -> 转场
VOID HmcVisionAsset::SortEffectList()
{
    if (m_effectList.size() > 0) {
        HMC_MUTEX_LOCK(m_locker);
        m_effectList.sort([](HmcUid a, HmcUid b) { return GetDepth(a) < GetDepth(b); });
        HMC_MUTEX_UNLOCK(m_locker);
    }
}

bool HmcVisionAsset::IsOriginalColorMode(HmcEffectType type) const
{
    if (m_originalColorMode == 0) {
        return false;
    }

    return (type == HMC_EFFECT_ADJUST);
}

bool HmcVisionAsset::IsOriginalColorMode() const
{
    if (m_originalColorMode == 0) {
        return false;
    }
    
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (effect && effect->IsEnable()) {
            auto effectType = effect->GetType();
            if (IsOriginalColorMode(effectType)) {
                return true;
            }
        }
    }
    return false;
}

void HmcVisionAsset::PackEffectRenderInfo(INT64 pts, std::vector<HmcRenderEffectPtr> &effectList,
                                          const std::set<HmcEffectType> &filterEffect)
{
    HMC_MUTEX_LOCK(m_locker);
    SortEffectList();

    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (filterEffect.contains(effect->GetType())) {
            continue;
        }
        if (effect && effect->IsEnable()) {
            HmcRenderEffectPtr renderEffect = effect->GetRenderEffectPtr();
            HmcRenderEffectPtr renderEffectDup = std::make_shared<HmcRenderEffect>(renderEffect.get());
            renderEffectDup->m_timeStamp = pts;
            renderEffectDup->m_inTex.clear();
            renderEffectDup->AddTexture("__main");
            renderEffectDup->SetOutTex("__main");
            effectList.push_back(renderEffectDup);
        }
    }

    HMC_MUTEX_UNLOCK(m_locker);
}

// 图片展示尺寸
int32_t HmcVisionAsset::GetImageSize(const std::string &path, int32_t &width, int32_t &height)
{
    HmcImageInfo info(path);
    if (!info.Init()) {
        LOGE("Failed to get image size, get image info error!");
        return HMC_ERR;
    }

    if (info.GetWidth() > INT32_MAX || info.GetHeight() > INT32_MAX) {
        LOGE("Failed to get image size, width=%lld, height=%lld", info.GetWidth(), info.GetHeight());
        return HMC_ERR;
    }

    LOGI("GetImageSize. m_exportWidth=%d, m_exportHeight=%d", m_exportWidth, m_exportHeight);
    width = static_cast<INT32>(m_exportWidth > 0 ? m_exportWidth : info.GetWidth());
    height = static_cast<INT32>(m_exportHeight > 0 ? m_exportHeight : info.GetHeight());
    LOGI("GetImageSize, width=%d, height=%d", width, height);

    return HMC_OK;
}

bool HmcVisionAsset::SetEffectRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT64 timeOffset)
{
    HMC_MUTEX_LOCK(m_locker);
    layer->m_IsInPreviewMode = m_IsInPreviewMode;
    layer->m_isDrawWaterMark = m_isDrawWaterMark;
    layer->m_IsSwitchPage = m_isSwitchPage;
    layer->m_isDragImage = m_isDragImage;
    SortEffectList(); // 当前剪辑的effect已经排好序了
    bool originalColorMode = false;

    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (effect && effect->IsEnable()) {
            HmcRenderEffectPtr renderEffect = effect->GetRenderEffectPtr();
            renderEffect->m_inTex.clear();
            renderEffect->AddTexture("__main");
            renderEffect->SetOutTex("__main");

            auto effectType = effect->GetType();
            if (effectType == HMC_EFFECT_TRANSFORM) {
                float scale = GetRenderScale();
                renderEffect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_X, (double)scale);
                renderEffect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_Y, (double)scale);
            }

            effect->SetRenderLayer(layer);
        }
    }

    HMC_MUTEX_UNLOCK(m_locker);
    return originalColorMode;
}

BOOL HmcVisionAsset::MoveEffect(HmcEffect *effect, INT64 moveTime)
{
    if (!effect) {
        return FALSE;
    }

    // 重新设置效果的startTime
    INT64 oldStartTime = effect->GetStartTime();
    effect->SetStartTime(moveTime - GetStartTime());

    LOGD("move effect from %lld to %lld", oldStartTime, effect->GetStartTime());
    return TRUE;
}

VisionRenderTexturePtr HmcVisionAsset::CreateTextureByPath(const STRING &path)
{
    LOGI("HmcVisionAsset::CreateTextureByPath");
    HmcImage *image = HmcImageCreateFromFile(path.c_str(), false);
    if (image == nullptr) {
        LOGE("create image from file failed");
        return nullptr;
    }

    HmcRenderTexturePtr inputTex = std::make_shared<HmcRenderTexture>(TRUE);

    if (inputTex == nullptr) {
        LOGE("malloc memory for input tex");
        HmcImageDestroy(image);
        return nullptr;
    }

    if ((inputTex->CreateTexture(image)) == FALSE) {
        LOGE("create texture failed!!");
        HmcImageDestroy(image);
        return nullptr;
    }

    INT32 width = 0;
    INT32 height = 0;
    INT32 rotation = 0;
    if (GetImageSize(path, width, height) != HMC_OK) {
        LOGW("get image rotation fail, path:%s.", path.c_str());
    }

    inputTex->m_rotation = rotation;

    HmcImageDestroy(image);
    return inputTex;
}

VOID HmcVisionAsset::SetCanvasRatio()
{
    m_transInfo.ratioX = GetRenderScale();
    m_transInfo.ratioY = m_transInfo.ratioX;
    LOGD("SetCanvasRatio ratioX=%f ratioY=%f", m_transInfo.ratioX, m_transInfo.ratioY);
}

FLOAT HmcVisionAsset::GetRenderScale() const
{
    HmcSize canvasSize;
    m_eventHandler->OnGetData(HMC::GET_DATA_CANVAS_SIZE, nullptr, &canvasSize);

    auto cropRatioX = 1.0f;
    auto cropRatioY = 1.0f;

    auto sourceWidth = GetDisplayWidth();
    auto sourceHeight = GetDisplayHeight();

    float widthScale = canvasSize.width / (float)sourceWidth;
    float heightScale = canvasSize.height / (float)sourceHeight;
    LOGD("GetRenderScale width = %f, height = %f, sourceWidth = %d, sourceHeight = %d", canvasSize.width,
        canvasSize.height, sourceWidth, sourceHeight);
    return HMC_MIN(widthScale, heightScale);
}

HmcUid HmcVisionAsset::GetEffectByMaterial(const STRING &materialCloudId)
{
    if (materialCloudId.empty()) {
        return {};
    }

    HmcUid result = HMC_UID_NULL;
    HMC_MUTEX_LOCK(m_locker);
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (effect) {
            STRING tmpMaterialCloudId = effect->GetMaterialCloudId();
            if (tmpMaterialCloudId.compare(materialCloudId) == 0) {
                result = effectUid;
                break;
            }
        }
    }
    HMC_MUTEX_UNLOCK(m_locker);

    return result;
}


int32_t HmcVisionAsset::PackGraphicsRenderInfo(uint64_t timestamp, std::shared_ptr<VideoRenderInfo> &renderInfo,
    bool exactMode)
{
    HMC_UNUSED(timestamp);

    return HMC_OK;
}

HmcEffect *HmcVisionAsset::CreateEffectEntity(HmcEffectType type)
{
    HmcEffect *effect = nullptr;
    switch (type) {
        case HMC_EFFECT_ADJUST:
            effect = new (std::nothrow) HmcEffectAdjust(m_uid, m_eventHandler);
            break;
        case HMC_EFFECT_TRANSFORM:
            effect = new (std::nothrow) HmcEffectTransform(m_uid, m_eventHandler);
            break;
        case HMC_EFFECT_MIRROR:
            effect = new (std::nothrow) HmcEffectMirror(m_uid, m_eventHandler);
            break;
        case HMC_EFFECT_CROP_BLUR:
            effect = new (std::nothrow) HmcEffectCropBlur(m_uid, m_eventHandler);
            break;
        case HMC_EFFECT_COMPOSE:
            effect = new (std::nothrow) HmcEffectCompose(m_uid, m_eventHandler);
            break;
        default:
            LOGE("invalid effect type: %d", type);
            break;
    }

    return effect;
}

HmcEffect *HmcVisionAsset::CreateEffect(HmcDict *dict)
{
    HmcEffectType type = HmcEffectUtils::GetEffectType(dict);

    HmcEffect *effect = CreateEffectEntity(type);
    if (effect == nullptr) {
        LOGE("create effect entity failed");
        return nullptr;
    }

    if (effect->Init(dict) != TRUE) {
        LOGE("init effect failed");
        delete effect;
        return nullptr;
    }

    if (effect != nullptr) {
        HmcDict *dict = HmcDictCreate();
        HmcDictSetPointer(dict, "effect", effect->GetRenderEffectPtr().get());
        m_eventHandler->OnEventNotify(HMC::EVENT_INIT_INNER_EFFECT, dict, nullptr);
    }

    return effect;
}

HmcEffect *HmcVisionAsset::ReplaceEffect(HmcDict *dict, bool force)
{
    HmcEffectType type = HmcEffectUtils::GetEffectType(dict);

    VECTOR<HmcUid> lastEffectList;
    GetEffectList(lastEffectList, type);

    auto effect = CreateEffect(dict);
    if (effect == nullptr) {
        LOGE("create new effect failed");
        return nullptr;
    }

    for (auto effectUid : lastEffectList) {
        (VOID)RemoveEffect(effectUid);
    }

    return effect;
}

HmcEffect *HmcVisionAsset::CreateEffect(const Json::Value &jsonData)
{
    HmcEffectType type = HMC_EFFECT_NONE;
    int typeValue;
    if (JsonValueUtil::ParseValueIfHas(jsonData, DICT_KEY_EFFECT_TYPE, typeValue)) {
        type = (HmcEffectType)typeValue;
    } else {
        LOGE("Get effect type from json data failed.");
        return nullptr;
    }

    LOGD("Effect type: %d", type);

    HmcEffect *effect = CreateEffectEntity(type);
    if (effect == nullptr) {
        LOGE("Alloc memory for effect failed");
        return nullptr;
    }

    if (effect->Deserialize(jsonData) != TRUE) {
        LOGE("Deserialize effect failed.");
        delete effect;
        return nullptr;
    }

    return effect;
}

BOOL HmcVisionAsset::IsInsideAsset(HmcPosition position)
{
    VisionTransformInfo transInfo = GetTransformInfo();
    HmcPosition center = { transInfo.offsetX.GetValue(), transInfo.offsetY.GetValue() };
    float width = transInfo.scaleX.GetValue() * transInfo.ratioX * (float)GetDisplayWidth();
    float height = transInfo.scaleY.GetValue() * transInfo.ratioX * (float)GetDisplayHeight();
    // todo 默认绕Z轴，后续根据需求扩展旋转轴入参
    HmcRectangle rect(center, width, height, transInfo.rotationZ.GetValue());
    return rect.IsMatchRect(position);
}

HmcImage *HmcVisionAsset::GetImageByBlurred(UINT32 timeStamp, INT64 strength)
{
    //  重新实现
    return nullptr;
}

double HmcVisionAsset::GetVideoFps() const
{
    return m_videofps;
}

INT32 HmcVisionAsset::GetVideoBitRate() const
{
    return m_videoBitRate;
}

INT32 HmcVisionAsset::GetOriginalColorMode()
{
    return m_originalColorMode;
}

void HmcVisionAsset::SetOriginalColorMode(INT32 mode)
{
    m_originalColorMode = mode;
}

void HmcVisionAsset::setCropPosition(float left, float top, float right, float bottom)
{
    cropPosition = {{left, top}, {left, bottom}, {right, top}, {right, bottom}};
}

HmcAssetCropPosition HmcVisionAsset::getCropPosition() const
{
    LOGE("HmcVisionAsset getCropPosition %f ", cropPosition.leftTop.x);
    return cropPosition;
}

STRING HmcVisionAsset::GetOrientation() const
{
    return m_orientation;
}

void HmcVisionAsset::SetPreviewMode(bool isPreviewMode)
{
    m_IsInPreviewMode = isPreviewMode;
}

void HmcVisionAsset::SetIsSwitchPage(bool isSwitchPage)
{
    LOGI("HmcVisionAsset::SetIsSwitchPage: %d", isSwitchPage);
    m_isSwitchPage = isSwitchPage;
}

void HmcVisionAsset::SetDrawWaterMarkValue(bool isDrawWaterMark)
{
    m_isDrawWaterMark = isDrawWaterMark;
}

void HmcVisionAsset::SetIsDragImage(bool isDragImage)
{
    if (m_isDragImage == isDragImage) {
        return;
    }
    LOGD("HmcVisionAsset::SetIsDragImage: %d", isDragImage);
    m_isDragImage = isDragImage;
}