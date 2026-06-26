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
#include "HmcEffectTransform.h"
#include "Project/HmcProjectSerializeKey.h"
#include "Utils/HmcEffectUtils.h"

HmcEffectTransform::HmcEffectTransform(HmcUid assetUid, HmcEventHandler *eventHandler)
    : HmcEffect(assetUid, eventHandler)
{
    m_type = HMC_EFFECT_TRANSFORM;
}

HmcEffectTransform::~HmcEffectTransform()
{
    LOGI("destroy transform effect finish.");
}
HmcEffectTransform::HmcEffectTransform(const HmcEffectTransform &transform) : HmcEffect(transform)
{
    m_renderEffect->m_effectParam = transform.m_renderEffect->m_effectParam;
    m_TransformParameter = transform.m_TransformParameter;
}

HmcEffectTransform &HmcEffectTransform::operator = (const HmcEffectTransform &transform)
{
    if (this == &transform) {
        return *this;
    }

    HmcEffect::operator = (transform);
    m_renderEffect->m_effectParam = transform.m_renderEffect->m_effectParam;
    m_TransformParameter = transform.m_TransformParameter;

    return *this;
}

HmcEffect *HmcEffectTransform::Duplicate()
{
    auto transform = new (std::nothrow) HmcEffectTransform(*this);
    if (transform == nullptr) {
        LOGE("malloc memory for transform failed");
        return nullptr;
    }

    if (transform->Init() != TRUE) {
        LOGE("init filter effect failed");
        delete transform;
        return nullptr;
    }

    transform->UpdateRenderInfo();

    return transform;
}

BOOL HmcEffectTransform::Init(HmcDict *dict)
{
    if (!HmcEffect::Init(dict)) {
        return FALSE;
    }

    SetEffectParameter(dict);

    return Init();
}

Json::Value HmcEffectTransform::Serialize()
{
    Json::Value json = HmcEffect::Serialize();

    json[PROJECT_KEY_TRANSFORM_OFFSET_X] = m_TransformParameter.offsetX.GetValue();
    json[PROJECT_KEY_TRANSFORM_OFFSET_Y] = m_TransformParameter.offsetY.GetValue();
    json[PROJECT_KEY_TRANSFORM_OFFSET_Z] = m_TransformParameter.offsetZ.GetValue();
    json[PROJECT_KEY_TRANSFORM_ROTATION_X] = m_TransformParameter.rotationX.GetValue();
    json[PROJECT_KEY_TRANSFORM_ROTATION_Y] = m_TransformParameter.rotationY.GetValue();
    json[PROJECT_KEY_TRANSFORM_ROTATION_Z] = m_TransformParameter.rotationZ.GetValue();
    json[PROJECT_KEY_TRANSFORM_SCALE_X] = m_TransformParameter.scaleX.GetValue();
    json[PROJECT_KEY_TRANSFORM_SCALE_Y] = m_TransformParameter.scaleY.GetValue();
    json[PROJECT_KEY_TRANSFORM_RATIO_X] = m_TransformParameter.ratioX;
    json[PROJECT_KEY_TRANSFORM_RATIO_Y] = m_TransformParameter.ratioY;
    json[PROJECT_KEY_TRANSFORM_REF_X] = m_TransformParameter.refX;
    json[PROJECT_KEY_TRANSFORM_REF_Y] = m_TransformParameter.refY;
    json[PROJECT_KEY_TRANSFORM_OPACITY] = m_TransformParameter.opacity.GetValue();
    json[PROJECT_KEY_TRANSFORM_VIEWPORT_X] = viewPortX;
    json[PROJECT_KEY_TRANSFORM_VIEWPORT_Y] = viewPortY;
    json[PROJECT_KEY_TRANSFORM_CROP_LB_X] = cropPosition.leftBottom.x;
    json[PROJECT_KEY_TRANSFORM_CROP_LB_Y] = cropPosition.leftBottom.y;
    json[PROJECT_KEY_TRANSFORM_CROP_RT_X] = cropPosition.rightTop.x;
    json[PROJECT_KEY_TRANSFORM_CROP_RT_Y] = cropPosition.rightTop.y;

    return json;
}

BOOL HmcEffectTransform::Deserialize(const Json::Value &jsonData)
{
    if (HmcEffect::Deserialize(jsonData) == FALSE) {
        LOGE("deserialize effect failed");
        return FALSE;
    }

    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_OFFSET_X, m_TransformParameter.offsetX);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_OFFSET_Y, m_TransformParameter.offsetY);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_OFFSET_Z, m_TransformParameter.offsetZ);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_ROTATION_X, m_TransformParameter.rotationX);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_ROTATION_Y, m_TransformParameter.rotationY);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_ROTATION_Z, m_TransformParameter.rotationZ);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_SCALE_X, m_TransformParameter.scaleX);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_SCALE_Y, m_TransformParameter.scaleY);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_RATIO_X, m_TransformParameter.ratioX);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_RATIO_Y, m_TransformParameter.ratioY);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_REF_X, m_TransformParameter.refX);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_REF_Y, m_TransformParameter.refY);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_OPACITY, m_TransformParameter.opacity);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_VIEWPORT_X, viewPortX);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_VIEWPORT_Y, viewPortY);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_CROP_LB_X, cropPosition.leftBottom.x);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_CROP_LB_Y, cropPosition.leftBottom.y);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_CROP_RT_X, cropPosition.rightTop.x);
    ParseTransformValue(jsonData, PROJECT_KEY_TRANSFORM_CROP_RT_Y, cropPosition.rightTop.y);

    if (Init() != TRUE) {
        LOGE("init transform failed");
        return FALSE;
    }

    UpdateRenderInfo();

    return TRUE;
}

VOID HmcEffectTransform::SetEffectParameter(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("parameter dict is null");
        return;
    }

    HmcEffect::SetEffectParameter(dict);

    char *dictStr = HmcDictSerialize(dict);
    LOGI("Transform dict: %s", dictStr);

    HmcFree(dictStr);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_OFFSET_X, m_TransformParameter.offsetX);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_OFFSET_Y, m_TransformParameter.offsetY);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_OFFSET_Z, m_TransformParameter.offsetZ);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_ROTATION_X, m_TransformParameter.rotationX);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_ROTATION_Y, m_TransformParameter.rotationY);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_ROTATION_Z, m_TransformParameter.rotationZ);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_SCALE_X, m_TransformParameter.scaleX);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_SCALE_Y, m_TransformParameter.scaleY);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_RATIO_X, m_TransformParameter.ratioX);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_RATIO_Y, m_TransformParameter.ratioY);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_REF_X, m_TransformParameter.refX);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_REF_Y, m_TransformParameter.refY);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_OPACITY, m_TransformParameter.opacity);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_VIEWPORT_X, viewPortX);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_VIEWPORT_Y, viewPortY);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_ENABLE, cropEnable);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, cropOffsetX);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, cropOffsetY);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_SCALE_X, cropScaleX);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_SCALE_Y, cropScaleY);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_ROTATION, cropRotate);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_LB_X, cropPosition.leftBottom.x);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_LB_Y, cropPosition.leftBottom.y);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_RT_X, cropPosition.rightTop.x);
    ParseTransformValue(dict, PROJECT_KEY_TRANSFORM_CROP_RT_Y, cropPosition.rightTop.y);
    LOGI("SetEffectParameter: ratioX = %f ratioY = %f scaleX = %f scaleY = %f", m_TransformParameter.ratioX,
        m_TransformParameter.ratioY, m_TransformParameter.scaleX.GetValue(), m_TransformParameter.scaleY.GetValue());
    UpdateRenderInfo();
}

VOID HmcEffectTransform::GetEffectParameter(HmcDict *dict)
{
    HmcEffect::GetEffectParameter(dict);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_OFFSET_X, (double)m_TransformParameter.offsetX.GetValue());
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_OFFSET_Y, (double)m_TransformParameter.offsetY.GetValue());
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_OFFSET_Z, (double)m_TransformParameter.offsetZ.GetValue());
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_ROTATION_X, (double)m_TransformParameter.rotationX.GetValue());
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_ROTATION_Y, (double)m_TransformParameter.rotationY.GetValue());
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_ROTATION_Z, (double)m_TransformParameter.rotationZ.GetValue());
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_SCALE_X, (double)m_TransformParameter.scaleX.GetValue());
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_SCALE_Y, (double)m_TransformParameter.scaleY.GetValue());
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_RATIO_X, (double)m_TransformParameter.ratioX);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_RATIO_Y, (double)m_TransformParameter.ratioY);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_REF_X, (double)m_TransformParameter.refX);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_REF_Y, (double)m_TransformParameter.refY);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_OPACITY, (double)m_TransformParameter.opacity.GetValue());
    HmcDictSetInt32(dict, PROJECT_KEY_TRANSFORM_VIEWPORT_X, viewPortX);
    HmcDictSetInt32(dict, PROJECT_KEY_TRANSFORM_VIEWPORT_Y, viewPortY);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_ENABLE, cropEnable);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, cropOffsetX);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, cropOffsetY);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_SCALE_X, cropScaleX);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_SCALE_Y, cropScaleY);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_ROTATION, cropRotate);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_LB_X, cropPosition.leftBottom.x);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_LB_Y, cropPosition.leftBottom.y);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_RT_X, cropPosition.rightTop.x);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_RT_Y, cropPosition.rightTop.y);
}

VOID HmcEffectTransform::ParseTransformValue(HmcDict *dict, const char *parameterName, INT32 &destValue)
{
    if (HmcDictGetInt32(dict, parameterName, &destValue) == HMC_OK) {
        LOGD("set Transform value %s to: %d", parameterName, destValue);
    }
}

VOID HmcEffectTransform::ParseTransformValue(const Json::Value &jsonData, const char *parameterName, INT32 &destValue)
{
    if (JsonValueUtil::ParseValueIfHas(jsonData, parameterName, destValue)) {
        destValue = jsonData[parameterName].asInt();
        LOGD("set Transform value %s to: %d", parameterName, destValue);
    }
}

VOID HmcEffectTransform::ParseTransformValue(HmcDict *dict, const char *parameterName, FLOAT &destValue)
{
    double value = 0.0;
    if (HmcDictGetDouble(dict, parameterName, &value) == HMC_OK) {
        destValue = (FLOAT)value;
        LOGD("set Transform value %s to: %.2f", parameterName, destValue);
    }
}

VOID HmcEffectTransform::ParseTransformValue(const Json::Value &jsonData, const char *parameterName, FLOAT &destValue)
{
    if (JsonValueUtil::ParseFloatIfHas(jsonData, parameterName, destValue)) {
        destValue = jsonData[parameterName].asFloat();
        LOGD("set Transform value %s to: %.2f", parameterName, destValue);
    }
}

VOID HmcEffectTransform::ParseTransformValue(HmcDict *dict, const char *parameterName, PropertyType<INT32> &destValue)
{
    INT32 value = 0;
    if (HmcDictGetInt32(dict, parameterName, &value) == HMC_OK) {
        destValue.SetValue(value);
        LOGD("set Transform value %s to: %d", parameterName, destValue.GetValue());
    }
}

VOID HmcEffectTransform::ParseTransformValue(const Json::Value &jsonData, const char *parameterName,
    PropertyType<INT32> &destValue)
{
    int value;
    if (JsonValueUtil::ParseValueIfHas(jsonData, parameterName, value)) {
        destValue.SetValue(value);
        LOGD("set Transform value %s to: %d", parameterName, destValue.GetValue());
    }
}

VOID HmcEffectTransform::ParseTransformValue(HmcDict *dict, const char *parameterName, PropertyType<FLOAT> &destValue)
{
    double value = 0.0;
    if (HmcDictGetDouble(dict, parameterName, &value) == HMC_OK) {
        destValue.SetValue((FLOAT)value);
        LOGD("set Transform value %s to: %.2f", parameterName, destValue.GetValue());
    }
}

VOID HmcEffectTransform::ParseTransformValue(const Json::Value &jsonData, const char *parameterName,
    PropertyType<FLOAT> &destValue)
{
    float value;
    if (JsonValueUtil::ParseFloatIfHas(jsonData, parameterName, value)) {
        destValue.SetValue(value);
        LOGD("set Transform value %s to: %.2f", parameterName, destValue.GetValue());
    }
}

BOOL HmcEffectTransform::Init()
{
    if (HmcEffect::Init() != TRUE) {
        LOGE("hmc effect init failed");
        return FALSE;
    }

    m_renderEffect->m_resource.get()->m_effectType = "transform";
    m_renderEffect->m_resource.get()->m_effectName = "transform";

    return TRUE;
}

VOID HmcEffectTransform::UpdateRenderInfo()
{
    HmcSize canvasSize;
    m_eventHandler->OnGetData(HMC::GET_DATA_CANVAS_SIZE, nullptr, &canvasSize);
    viewPortX = canvasSize.width;
    viewPortY = canvasSize.height;

    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_X, m_TransformParameter.offsetX.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_Y, m_TransformParameter.offsetY.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_Z, m_TransformParameter.offsetZ.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_ROTATION_X, m_TransformParameter.rotationX.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_ROTATION_Y, m_TransformParameter.rotationY.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_ROTATION_Z, m_TransformParameter.rotationZ.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_X, m_TransformParameter.scaleX.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_Y, m_TransformParameter.scaleY.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_MIRROR_H, m_TransformParameter.mirrorHorizontal.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_RATIO_X, m_TransformParameter.ratioX);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_RATIO_Y, m_TransformParameter.ratioY);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_REF_X, m_TransformParameter.refX);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_REF_Y, m_TransformParameter.refY);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_OPACITY, m_TransformParameter.opacity.GetValue());
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_VIEWPORT_X, viewPortX);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_VIEWPORT_Y, viewPortY);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, cropOffsetX);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, cropOffsetY);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_SCALE_X, cropScaleX);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_SCALE_Y, cropScaleY);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_ROTATION, cropRotate);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_LB_X, cropPosition.leftBottom.x);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_LB_Y, cropPosition.leftBottom.y);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_RT_X, cropPosition.rightTop.x);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_RT_Y, cropPosition.rightTop.y);
    m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_ENABLE, cropEnable);
}

VOID HmcEffectTransform::SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index)
{
    if (layer == nullptr) {
        LOGE("invalid parameter HmcRenderLayer");
        return;
    }

    UpdateTransformInfo();

    // 根据获取的预览图更新缩放比
    HmcSize canvasSize;
    m_eventHandler->OnGetData(HMC::GET_DATA_CANVAS_SIZE, nullptr, &canvasSize);
    if (!layer->m_textureList.empty()) {
        auto width = layer->m_textureList.begin()->second->GetDisplayWidth();
        auto height = layer->m_textureList.begin()->second->GetDisplayHeight();
        auto scale = HMC_MIN(canvasSize.width / width, canvasSize.height / height);

        m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_RATIO_X, scale);
        m_renderEffect->SetParam(PROJECT_KEY_TRANSFORM_RATIO_Y, scale);
    }

    layer->AddEffect(m_renderEffect, index);
}

VOID HmcEffectTransform::UpdateTransformInfo()
{
    HmcUid assetUid = GetAssetUid(); // 获取Transform效果所属asset
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid");
        return;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not an vision asset entity");
        return;
    }

    auto assetTmp = dynamic_cast<HmcVisionAsset *>(asset);
    if (assetTmp != nullptr) {
        m_TransformParameter = assetTmp->GetTransformInfo();
        UpdateRenderInfo();
    }
}

HmcAssetCropPosition HmcEffectTransform::GetCropPosition() const
{
    return cropPosition;
}