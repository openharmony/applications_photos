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

#include "HveAutoAdjustCommand.h"
#include "MediaCreative/HmcDictKey.h"
#include "MediaCreative/HmcError.h"
#include "MediaCreative/HmcImage.h"
#include "ohos/undoredo/UndoRedoManager.h"
#include "ohos/hve/HveAssetOper.h"
#include "log/HmcLog.h"

// 调节项取值范围min、max，值顺序对应AUTO_AFFECTED_ADJUST_NAME_LIST各个项
const int AUTO_AFFECTED_ADJUST_VALUE_RANGE[11][2] = {
    {-20, 10},
    {-75, 60},
    {0, 60},
    {-80, 0},
    {0, 90},
    {-10, 10},
    {-30, 80},
    {0, 15},
    {-10, 80},
    {-5, 5},
    {-5, 5},
};
constexpr int32_t MAX_AUTO_ADJUST_VALUE = 100;
constexpr int32_t MIN_AUTO_ADJUST_VALUE = -100;
constexpr int32_t DEFAULT_AUTO_ADJUST_VALUE = 50;

HveCmdAutoAdjustEnable::HveCmdAutoAdjustEnable(int timelineId, std::string const &type, std::string const &assetId,
                                               bool enable, std::function<void(std::string const &jsonStr)> cb)
    : HveCommand(timelineId, type + "_enable", assetId), m_curEnable(enable), m_resultCb(cb) {}

HveCmdAutoAdjustEnable::~HveCmdAutoAdjustEnable()
{
    HmcDictDestroy(m_curProperty);
    HmcDictDestroy(m_lastProperty);
}

int HveCmdAutoAdjustEnable::Execute()
{
    USE_ASSET(HMC_ERR);

    LOGI("execute HveAutoAdjustEnable command, action = %s.", m_curEnable ? "enable" : "disable");

    m_lastProperty = HmcDictCreate();
    if (m_lastProperty == nullptr) {
        LOGE("AdjustEnable, create dict for last property.");
        return HMC_ERR_OOM;
    }

    m_curProperty = HmcDictCreate();
    if (m_curProperty == nullptr) {
        LOGE("AdjustEnable, create dict for current property.");
        return HMC_ERR_OOM;
    }

    hveAsset->GetAutoAdjustProperty(m_lastProperty);

    int ret = HMC_OK;
    if (m_curEnable) {
        ret = AutoAdjustProperty(timelineId, assetId);
        if (ret != HMC_OK) {
            LOGE("failed to obtain the automatic adjustment value with error %d!", ret);
            return ret;
        }
    } else {
        NonAutoAdjustProperty(m_curProperty);
        ret = ComAdjustAndCallback(timelineId, assetId, hveAsset);
        if (ret != HMC_OK) {
            LOGE("Failed to disable automatic adjustment with error %d!", ret);
            return ret;
        }
    }

    return HMC_OK;
}

int HveCmdAutoAdjustEnable::ComAdjust(int timelineId, std::string const & assetId, HmcDict *property)
{
    USE_ASSET(HMC_ERR);

    HmcUid adjustEffectId = HveAssetOper::FindEffectByType(editor, assetUid, HMC_EFFECT_ADJUST);
    // 首次设置调节参数，需先添加调节效果器
    if (HmcUidIsNull(&adjustEffectId)) {
        HmcDictHelper adjustPara;
        adjustPara[DICT_KEY_EFFECT_NAME] = HmcDefault::EFFECT_ADJUST_DEFAULT_NAME;
        adjustPara[DICT_KEY_EFFECT_TYPE] = HMC_EFFECT_ADJUST;
        HmcEffectAdd(editor, assetUid, adjustPara, &adjustEffectId);
    }

    int ret = HmcEffectSetProperty(editor, adjustEffectId, property);
    if (ret != HMC_OK) {
        LOGE("set adjust property failed with error %d.", ret);
        return ret;
    }

    hveAsset->SetRefreshThumbnails(true);
    hveAsset->SetAutoAdjustProperty(property);

    return HMC_OK;
}

int HveCmdAutoAdjustEnable::CheckAutoAdjustCache(int timelineId, std::string const & assetId, bool &hasCache)
{
    USE_ASSET(HMC_ERR);
    //查询缓存
    return HMC_OK;
}

int HveCmdAutoAdjustEnable::AutoAdjustProperty(int timelineId, std::string const & assetId)
{
    USE_ASSET(HMC_ERR);
    bool hasCache = false;
    int res = CheckAutoAdjustCache(timelineId, assetId, hasCache);
    if (hasCache) {
        return res;
    }
    LOGI("Auto Tuning Cache Misses");

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        LOGE("get main asset failed");
        return HMC_ERR;
    }

    auto hmcEditor = (HmcEditorImp *)editor;
    auto hmcImage = visionAsset->GetPreview(hmcEditor->GetCurrentTimeline());
    if (hmcImage == nullptr) {
        LOGE("get hmcImage failed.");
        return HMC_ERR;
    }

    HmcSize canvasSize = HmcSize{ (float)visionAsset->GetWidth(), (float)visionAsset->GetHeight() };

    hmcEditor->GetRGBData(hmcImage, canvasSize, assetUid,
        [this, hmcImage, timelineId, assetId, hveAsset](HmcImage *image) {
            HmcImageDestroy(hmcImage);

            if (image == nullptr) {
                return;
            }
            auto frame = static_cast<HmcImageBase *>(image)->ConvertToImage();
        
            HmcImageDestroy(image);
            std::vector<float> adjustVector;
            auto imageBuffer = GetDataFromNativePixelMap(frame->nativePixelmap, frame->width, frame->height);
            if (imageBuffer == nullptr) {
                LOGE("AutoAdjustProperty bad_alloc");
                return;
            }
            int result = GetAdjPropertyFromAI(imageBuffer, frame->width, frame->height, frame->width, adjustVector);
            delete[] imageBuffer;
            if (result != HMC_OK) {
                LOGE("get adjust property from ai failed with error %d", result);
                return;
            }

            ConvAutoAdjustResultToDict(adjustVector, m_curProperty);

            ComAdjustAndCallback(timelineId, assetId, hveAsset);
        });

    return HMC_OK;
}

std::string HveCmdAutoAdjustEnable::Redo()
{
    USE_ASSET("");
    LOGI("UndoRedo HveCmdAutoAdjustValue Redo cur_name = %s, cur_enable = %d",
        DICT_KEY_ADJUST_AUTO_ENABLE, m_curEnable);
    int ret = ComAdjust(timelineId, assetId, m_curProperty);
    if (ret != HMC_OK) {
        LOGE("Set adjustEnable fail error = %d", ret);
        return "";
    }

    std::string state = m_curEnable ? "_on" : "_off";

    Json::Value json;
    json["id"] = "auto" + state;
    json["value"] = hveAsset->ConvAdjustDict2Json(m_curProperty);
    return m_fastWriter.write(json);
}

std::string HveCmdAutoAdjustEnable::Undo()
{
    USE_ASSET("");
    LOGI("UndoRedo HveCmdAutoAdjustValue Undo cur_name = %s, last_enable = %d", DICT_KEY_ADJUST_AUTO_ENABLE,
        !m_curEnable);
    int ret = ComAdjust(timelineId, assetId, m_lastProperty);
    if (ret != HMC_OK) {
        LOGE("Set adjustEnable fail error = %d", ret);
        return "";
    }

    std::string state = m_curEnable ? "_on" : "_off";

    Json::Value json;
    json["id"] = "auto" + state;
    json["value"] = hveAsset->ConvAdjustDict2Json(m_lastProperty);
    return m_fastWriter.write(json);
}

int HveCmdAutoAdjustEnable::GetAdjPropertyFromAI(void *data, int width, int height, int step,
    std::vector<float> &adjustVector)
{
    LOGI("test Auto adjustment value: %f", sizeof(adjustVector) / sizeof(adjustVector[0]));
    LOGI("Auto adjustment value: %f %f %f %f %f %f %f %f %f %f %f", adjustVector[0], adjustVector[1], adjustVector[2],
        adjustVector[3], adjustVector[4], adjustVector[5], adjustVector[6], adjustVector[7], adjustVector[8],
        adjustVector[9], adjustVector[10]);
    return HMC_OK;
}

void HveCmdAutoAdjustEnable::ConvAutoAdjustResultToDict(std::vector<float> const & props, HmcDict *dict)
{
    if (props.size() != AUTO_AFFECTED_ADJUST_NAME_LIST.size()) {
        LOGE("inner error, size of auto adjust result != AUTO_ADJUST_NAME_LIST.size.");
        return;
    }

    for (size_t index = 0; index < AUTO_AFFECTED_ADJUST_NAME_LIST.size(); index++) {
        HmcDictSetInt32(dict, AUTO_AFFECTED_ADJUST_NAME_LIST.at(index).c_str(), lround(props[index] * 100));
        HmcDictSetInt32(dict, (AUTO_AFFECTED_ADJUST_NAME_LIST.at(index) + "_enable").c_str(), 1); // 0为关，1为开
    }

    HmcDictSetInt32(dict, DICT_KEY_ADJUST_AUTO, DEFAULT_AUTO_ADJUST_VALUE);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_AUTO_ENABLE, 1);
}

void HveCmdAutoAdjustEnable::NonAutoAdjustProperty(HmcDict *dict)
{
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_AUTO, 0);
    HmcDictSetInt32(dict, DICT_KEY_ADJUST_AUTO_ENABLE, 0);

    for (const auto &item : AUTO_AFFECTED_ADJUST_NAME_LIST) {
        HmcDictSetInt32(dict, item.c_str(), 0);
        HmcDictSetInt32(dict, (item + "_enable").c_str(), 1); // 0为关，1为开
    }
}

int HveCmdAutoAdjustEnable::ComAdjustAndCallback(int timelineId, std::string const & assetId, HveAsset *hveAsset)
{
    int result = ComAdjust(timelineId, assetId, m_curProperty);
    if (result != HMC_OK) {
        LOGE("set adjustEnable failed with error %d.", result);
        return result;
    }
    
    m_resultCb(hveAsset->ConvAdjustDict2Json(m_curProperty));

    return HMC_OK;
}


HveCmdAutoAdjustValue::HveCmdAutoAdjustValue(int timelineId, std::string const &type, std::string const &assetId,
                                             double value, std::function<void(std::string const &jsonStr)> cb)
    : HveCommand(timelineId, type, assetId), m_curValue(value), m_resultCb(cb) {}

HveCmdAutoAdjustValue::~HveCmdAutoAdjustValue()
{
    HmcDictDestroy(m_curProperty);
    HmcDictDestroy(m_lastProperty);
}

int HveCmdAutoAdjustValue::Execute()
{
    USE_ASSET(HMC_ERR);

    m_lastValue = hveAsset->GetAdjustValue(DICT_KEY_ADJUST_AUTO);

    LOGI("execute last_value %lf, cur_value %lf", m_lastValue, m_curValue);

    // UI调用进度为0.1，这里提升精度为1，降低调用SDK频率，同时解决UI滑块位置数据与调用SDK时的参数不同导致的撤销恢复时滑块不在原来位置的问题
    if (lround(m_lastValue) == lround(m_curValue)) {
        hveAsset->SetAdjustValue(DICT_KEY_ADJUST_AUTO, m_curValue);
        // 这里虽然不进入SDK，但命令不能舍弃，所以反回HMC_OK
        return HMC_OK;
    }

    m_lastProperty = HmcDictCreate();
    if (m_lastProperty == nullptr) {
        LOGE("create dict for last property.");
        return HMC_ERR_OOM;
    }

    m_curProperty = HmcDictCreate();
    if (m_curProperty == nullptr) {
        LOGE("create dict for current property.");
        return HMC_ERR_OOM;
    }

    hveAsset->GetAutoAdjustProperty(m_lastProperty);
    int ret = AssociationAdjust();
    if (ret != HMC_OK) {
        LOGE("Failed to associate other adjustment items with error %d!", ret);
        return ret;
    }

    ret = HveCmdAutoAdjustEnable::ComAdjust(timelineId, assetId, m_curProperty);
    if (ret != HMC_OK) {
        LOGE("Failed to associate other adjustment items with error %d!", ret);
        return ret;
    }

    m_resultCb(hveAsset->ConvAdjustDict2Json(m_curProperty));

    return HMC_OK;
}

std::string HveCmdAutoAdjustValue::Redo()
{
    USE_ASSET("");
    LOGI("UndoRedo HveAutoAdjustValue Redo cur_name = %s, cur_value = %lf", DICT_KEY_ADJUST_AUTO, m_curValue);
    int ret = HveCmdAutoAdjustEnable::ComAdjust(timelineId, assetId, m_curProperty);
    if (ret != HMC_OK) {
        LOGE("Set adjustValue fail error = %d", ret);
        return "";
    }

    Json::Value json;
    json["id"] = type;
    json["value"] = hveAsset->ConvAdjustDict2Json(m_curProperty);
    return m_fastWriter.write(json);
}

std::string HveCmdAutoAdjustValue::Undo()
{
    USE_ASSET("");
    LOGI("UndoRedo HveAutoAdjustValue Undo cur_name = %s, last_value = %lf", DICT_KEY_ADJUST_AUTO, m_lastValue);
    int ret = HveCmdAutoAdjustEnable::ComAdjust(timelineId, assetId, m_lastProperty);
    if (ret != HMC_OK) {
        LOGE("Set adjustValue fail error = %d", ret);
        return "";
    }

    Json::Value json;
    json["id"] = type;
    json["value"] = hveAsset->ConvAdjustDict2Json(m_lastProperty);
    return m_fastWriter.write(json);
}

int HveCmdAutoAdjustValue::Merge()
{
    USE_ASSET(HMC_ERR);
    double value = hveAsset->GetAdjustValue(DICT_KEY_ADJUST_AUTO);
    if (abs(m_lastValue - value) <= UNDO_REDO_EPS) {
        LOGI("The adjustValue has not changed!");
        return HMC_ERR;
    }
    m_curValue = value;
    hveAsset->GetAutoAdjustProperty(m_curProperty);
    return HMC_OK;
}

int HveCmdAutoAdjustValue::AssociationAdjust()
{
    if (m_curValue < MIN_AUTO_ADJUST_VALUE || m_curValue > MAX_AUTO_ADJUST_VALUE) {
        LOGE("incorrect input!");
        return HMC_ERR_PARAM;
    }

    int value;
    double res;
    for (size_t index = 0; index < AUTO_AFFECTED_ADJUST_NAME_LIST.size(); index++) {

        if (m_curValue <= 0) {
            res = m_curValue / MIN_AUTO_ADJUST_VALUE * AUTO_AFFECTED_ADJUST_VALUE_RANGE[index][0];
        } else if (m_curValue > DEFAULT_AUTO_ADJUST_VALUE) {
            res = (m_curValue - DEFAULT_AUTO_ADJUST_VALUE) / (MAX_AUTO_ADJUST_VALUE - DEFAULT_AUTO_ADJUST_VALUE) *
                (AUTO_AFFECTED_ADJUST_VALUE_RANGE[index][1] - value) +
                value;
        } else {
            res = m_curValue / DEFAULT_AUTO_ADJUST_VALUE * value;
        }

        HmcDictSetInt32(m_curProperty, AUTO_AFFECTED_ADJUST_NAME_LIST.at(index).c_str(), lround(res));
        HmcDictSetInt32(m_curProperty, (AUTO_AFFECTED_ADJUST_NAME_LIST.at(index) + "_enable").c_str(),
            1); // 0为关，1为开
    }
    HmcDictSetInt32(m_curProperty, DICT_KEY_ADJUST_AUTO, m_curValue);
    HmcDictSetInt32(m_curProperty, DICT_KEY_ADJUST_AUTO_ENABLE, 1);

    return HMC_OK;
}