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

#include "HveAdjustCommand.h"
#include "HveAutoAdjustCommand.h"
#include "MediaCreative/HmcError.h"

HveCmdAdjustValue::HveCmdAdjustValue(int timelineId, std::string const &type, std::string const &assetId,
                                     std::string const &adjustName, double value)
    : HveCommand(timelineId, type, assetId), m_curName(adjustName), m_curValue(value)
{
    auto iter = std::find(AUTO_AFFECTED_ADJUST_NAME_LIST.begin(), AUTO_AFFECTED_ADJUST_NAME_LIST.end(), adjustName);
    m_isAssociatedItem = iter != AUTO_AFFECTED_ADJUST_NAME_LIST.end() ? true : false;
}
HveCmdAdjustValue::~HveCmdAdjustValue() {}
int HveCmdAdjustValue::Execute()
{
    USE_ASSET(HMC_ERR);
    m_lastValue = hveAsset->GetAdjustValue(m_curName);
    m_lastName = m_curName;
    m_lastEnable = hveAsset->GetAdjustEnableValue(m_curName + "_enable");

    // 调节与一键调节关联的项时，一键调节被动关闭
    if (m_isAssociatedItem) {
        m_curAutoValue = 0;
        m_curAutoEnable = false;
        m_lastAutoValue = hveAsset->GetAdjustValue(DICT_KEY_ADJUST_AUTO);
        m_lastAutoEnable = hveAsset->GetAdjustEnableValue(DICT_KEY_ADJUST_AUTO_ENABLE);
    }
    // UI调用进度为0.1，这里提升精度为1，降低调用SDK频率，同时解决UI滑块位置数据与调用SDK时的参数不同导致的撤销恢复时滑块不在原来位置的问题
    if (lround(m_lastValue) == lround(m_curValue)) {
        hveAsset->SetAdjustValue(m_curName, m_curValue);
        // 这里虽然不进入SDK，但命令不能舍弃，所以反回HMC_OK
        return HMC_OK;
    }

    m_curEnable = true;

    int ret = ComAdjust(m_curName, m_curValue, m_curEnable, m_curAutoValue, m_curAutoEnable);
    if (ret != HMC_OK) {
        LOGE("%s value set failed.", m_curName.c_str());
        return ret;
    }

    return HMC_OK;
}

int HveCmdAdjustValue::ComAdjust(std::string const &adjustName, int value, bool enable, int autoValue,
                                 bool autoEnable)
{
    USE_ASSET(HMC_ERR);
    HmcUid adjustEffectId = HveAssetOper::FindEffectByType(editor, assetUid, HMC_EFFECT_ADJUST);
    // 首次设置调节参数，需先添加调节效果
    if (HmcUidIsNull(&adjustEffectId)) {
        HmcDictHelper adjustPara;
        adjustPara[DICT_KEY_EFFECT_NAME] = HmcDefault::EFFECT_ADJUST_DEFAULT_NAME;
        adjustPara[DICT_KEY_EFFECT_TYPE] = HMC_EFFECT_ADJUST;
        HmcEffectAdd(editor, assetUid, adjustPara, &adjustEffectId);
    }
    HmcDictHelper dict;
    dict[adjustName.c_str()] = value;
    std::string adjustEnable = adjustName + "_enable";
    dict[adjustEnable.c_str()] = enable;
    if (m_isAssociatedItem) {
        dict[DICT_KEY_ADJUST_AUTO] = autoValue;
        dict[DICT_KEY_ADJUST_AUTO_ENABLE] = autoEnable;
    }

    int ret = HmcEffectSetProperty(editor, adjustEffectId, dict);
    if (ret != HMC_OK) {
        LOGE("ComAdjust set adjust property failed with error %d.", ret);
        return ret;
    }
    hveAsset->SetRefreshThumbnails(true);
    hveAsset->SetAdjustValue(adjustName, value);
    hveAsset->SetAdjustEnableValue(m_curName + "_enable", enable);
    if (m_isAssociatedItem) {
        hveAsset->SetAdjustValue(DICT_KEY_ADJUST_AUTO, autoValue);
        hveAsset->SetAdjustEnableValue(DICT_KEY_ADJUST_AUTO_ENABLE, autoEnable);
    }

    return HMC_OK;
}

void HveCmdAdjustValue::SetEnableChecked(bool isEnableChecked)
{
    // 滑动强度条，调节项被动打开场景，undo时，强度值和开关项算做一次操作需要同时撤销
    m_isEnableChecked = isEnableChecked;
}

std::string HveCmdAdjustValue::Redo()
{
    USE_ASSET("");
    LOGD("UndoRedo HveCmdAdjustValue Redo cur_name = %s, cur_value = %lf, m_curEnable=%d", m_curName.c_str(),
         m_curValue, m_curEnable);
    int ret = ComAdjust(m_curName, m_curValue, m_curEnable, m_curAutoValue, m_curAutoEnable);
    if (ret != HMC_OK) {
        return "";
    }

    return ResultString(m_curValue, m_curEnable, m_curAutoValue, m_curAutoEnable);
}

std::string HveCmdAdjustValue::Undo()
{
    USE_ASSET("");
    LOGD("UndoRedo HveCmdAdjustValue Undo cur_name = %s, last_value = %lf, m_lastEnable=%d", m_lastName.c_str(),
         m_lastValue, m_lastEnable);
    int ret = ComAdjust(m_lastName, m_lastValue, m_lastEnable, m_lastAutoValue, m_lastAutoEnable);
    if (ret != HMC_OK) {
        return "";
    }

    return ResultString(m_lastValue, m_isEnableChecked ? false : m_lastEnable, m_lastAutoValue, m_lastAutoEnable);
}

int HveCmdAdjustValue::Merge()
{
    USE_ASSET(HMC_ERR);
    double value = hveAsset->GetAdjustValue(m_curName);
    if (abs(m_lastValue - value) <= UNDO_REDO_EPS) {
        LOGI("The adjustValue has not changed!");
        return HMC_ERR;
    }
    m_curValue = value;
    if (m_isAssociatedItem) {
        m_curAutoValue = hveAsset->GetAdjustValue(DICT_KEY_ADJUST_AUTO);
        m_curAutoEnable = hveAsset->GetAdjustEnableValue(DICT_KEY_ADJUST_AUTO_ENABLE);
    }
    LOGI("UndoRedo Merge lastAdjust:%s, lastValue:%lf, curAdjust:%s, curValue:%lf, lastEnable:%d", m_lastName.c_str(),
         m_lastValue, m_curName.c_str(), m_curValue, m_lastEnable);
    return HMC_OK;
}

std::string HveCmdAdjustValue::ResultString(int itemValue, bool itemEnable, int autoValue, bool autoEnable)
{
    Json::Value json;
    json["id"] = type;
    json["itemValue"] = itemValue;
    json["itemEnable"] = itemEnable ? 1 : 0;
    if (m_isAssociatedItem) {
        json["autoValue"] = autoValue;
        json["autoEnable"] = autoEnable ? 1 : 0;
    }
    return m_fastWriter.write(json);
}

HveCmdAdjustEnable::HveCmdAdjustEnable(int timelineId, std::string const &type, std::string const &assetId,
                                       std::string const &adjustName, bool enable)
    : HveCommand(timelineId, type, assetId), m_curName(adjustName), m_curEnable(enable)
{
    auto iter = std::find(AUTO_AFFECTED_ADJUST_NAME_LIST.begin(), AUTO_AFFECTED_ADJUST_NAME_LIST.end(), adjustName);
    m_isAssociatedItem = iter != AUTO_AFFECTED_ADJUST_NAME_LIST.end() ? true : false;
}

HveCmdAdjustEnable::~HveCmdAdjustEnable() {}

int HveCmdAdjustEnable::Execute()
{
    USE_ASSET(HMC_ERR);
    m_adjustEnableName = m_curName + "_enable";
    m_lastEnable = hveAsset->GetAdjustEnableValue(m_adjustEnableName);
    m_lastName = m_curName;
    LOGI("UndoRedo enable lastAdjust:%s, lastEnable:%d, curEnable:%d", m_lastName.c_str(), m_lastEnable, m_curEnable);

    if (hveAsset->GetAdjustValue(m_curName) == 0 || m_lastEnable == m_curEnable) {
        // 当前如果效果为0；调节开、关就未改变素材，故不记录undoredo；
        LOGD("%s value is 0", m_curName.c_str());
        return HMC_ERR;
    }
    // 调节与一键调节关联的项时，一键调节被动关闭
    if (m_isAssociatedItem) {
        m_curAutoValue = 0;
        m_curAutoEnable = false;
        m_lastAutoValue = hveAsset->GetAdjustValue(DICT_KEY_ADJUST_AUTO);
        m_lastAutoEnable = hveAsset->GetAdjustEnableValue(DICT_KEY_ADJUST_AUTO_ENABLE);
    }
    int ret = ComAdjustEnable(m_adjustEnableName, m_curEnable, m_curAutoValue, m_curAutoEnable);
    if (ret != HMC_OK) {
        LOGE("Set adjustEnable fail");
        return ret;
    }

    return ret;
}

std::string HveCmdAdjustEnable::Undo()
{
    USE_ASSET("");

    LOGD("UndoRedo HveCmdAdjustEnable Undo lastname = %s, lastEnable = %d", m_lastName.c_str(), m_lastEnable);
    int ret = ComAdjustEnable(m_adjustEnableName, m_lastEnable, m_lastAutoValue, m_lastAutoEnable);
    if (ret != HMC_OK) {
        LOGE("Set adjustEnable fail");
        return "";
    }
    std::string idInfo = m_curName + (m_lastEnable ? "_off" : "_on");
    return ResultString(idInfo, m_lastEnable, m_lastAutoValue, m_lastAutoEnable);
}

std::string HveCmdAdjustEnable::Redo()
{
    USE_ASSET("");

    LOGD("UndoRedo HveCmdAdjustEnable Redo curname = %s, curenable = %d", m_curName.c_str(), m_curEnable);
    int ret = ComAdjustEnable(m_adjustEnableName, m_curEnable, m_curAutoValue, m_curAutoEnable);
    if (ret != HMC_OK) {
        LOGE("Set adjustEnable fail");
        return "";
    }
    std::string idInfo = m_curName + (m_curEnable ? "_on" : "_off");
    return ResultString(idInfo, m_curEnable, m_curAutoValue, m_curAutoEnable);
}

int HveCmdAdjustEnable::ComAdjustEnable(std::string const &adjustName, bool enable, int autoValue, bool autoEnable)
{
    USE_ASSET(HMC_ERR);

    HmcUid adjustEffectId = HveAssetOper::FindEffectByType(editor, assetUid, HMC_EFFECT_ADJUST);
    HmcDictHelper dict;
    dict[adjustName.c_str()] = enable;
    if (m_isAssociatedItem) {
        dict[DICT_KEY_ADJUST_AUTO] = autoValue;
        dict[DICT_KEY_ADJUST_AUTO_ENABLE] = autoEnable;
    }

    int ret = HmcEffectSetProperty(editor, adjustEffectId, dict);
    if (ret != HMC_OK) {
        LOGE("ComAdjustEnable set adjust property failed with error %d.", ret);
        return ret;
    }

    hveAsset->SetRefreshThumbnails(true);
    hveAsset->SetAdjustEnableValue(adjustName.c_str(), enable);
    if (m_isAssociatedItem) {
        hveAsset->SetAdjustValue(DICT_KEY_ADJUST_AUTO, autoValue);
        hveAsset->SetAdjustEnableValue(DICT_KEY_ADJUST_AUTO_ENABLE, autoEnable);
    }
    return ret;
}

std::string HveCmdAdjustEnable::ResultString(std::string const &idInfo, bool itemEnable, int autoValue,
                                             bool autoEnable)
{
    Json::Value json;
    json["id"] = idInfo;
    json["itemEnable"] = itemEnable ? 1 : 0;
    if (m_isAssociatedItem) {
        json["autoValue"] = autoValue;
        json["autoEnable"] = autoEnable ? 1 : 0;
    }
    return m_fastWriter.write(json);
}