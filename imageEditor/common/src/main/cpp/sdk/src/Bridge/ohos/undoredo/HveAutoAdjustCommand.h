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

#ifndef OH_HVE_AUTOADJUST_COMMAND_H
#define OH_HVE_AUTOADJUST_COMMAND_H
#include "HveCommand.h"

// 顺序不能调整，因为自动调节算法出来的结果是按照下面的调节项的顺序给出的vector数组.
// 不关联子项有DICT_KEY_ADJUST_SHARPNESS,DICT_KEY_ADJUST_FADE,DICT_KEY_ADJUST_GRAIN,DICT_KEY_ADJUST_VIGNETTE
const std::vector<std::string> AUTO_AFFECTED_ADJUST_NAME_LIST = {
    DICT_KEY_ADJUST_EXPOSURE, DICT_KEY_ADJUST_BRIGHTNESS,  DICT_KEY_ADJUST_CONTRAST, DICT_KEY_ADJUST_HIGHLIGHT,
    DICT_KEY_ADJUST_SHADOW,   DICT_KEY_ADJUST_BRIGHTZONE,  DICT_KEY_ADJUST_DARKZONE, DICT_KEY_ADJUST_SATURATION,
    DICT_KEY_ADJUST_VIBRANCE, DICT_KEY_ADJUST_TEMPERATURE, DICT_KEY_ADJUST_HUE};

class HveCmdAutoAdjustEnable final : public HveCommand {
public:
    HveCmdAutoAdjustEnable(int timelineId, std::string const &type, std::string const &assetId, bool enable,
                           std::function<void(std::string const &jsonStr)> cb);
    ~HveCmdAutoAdjustEnable() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    inline HmcDict *GetCurProperty()
    {
        return m_curProperty;
    }
    static int ComAdjust(int timelineId, std::string const & assetId, HmcDict *property);

    static int GetAdjPropertyFromAI(void *data, int width, int height, int step, std::vector<float> &adjustVector);
    
private:
    int AutoAdjustProperty(int timelineId, std::string const & assetId);
    int CheckAutoAdjustCache(int timelineId, std::string const & assetId, bool &hasCache);

    void ConvAutoAdjustResultToDict(std::vector<float> const & props, HmcDict *dict);
    void NonAutoAdjustProperty(HmcDict *dict);
    int ComAdjustAndCallback(int timelineId, std::string const & assetId, HveAsset *hveAsset);

private:
    bool m_curEnable{ false };
    HmcDict *m_lastProperty{ nullptr };
    HmcDict *m_curProperty{ nullptr };
    std::function<void(std::string const & jsonStr)> m_resultCb{ nullptr };
};

class HveCmdAutoAdjustValue final : public HveCommand {
public:
    HveCmdAutoAdjustValue(int timelineId, std::string const &type, std::string const &assetId, double value,
                          std::function<void(std::string const &jsonStr)> cb);
    ~HveCmdAutoAdjustValue() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int Merge() final;

private:
    int AssociationAdjust();

private:
    double m_lastValue;
    double m_curValue;
    HmcDict *m_lastProperty{ nullptr };
    HmcDict *m_curProperty{ nullptr };
    std::function<void(std::string const & jsonStr)> m_resultCb{ nullptr };
};

#endif // OH_HVE_AUTOADJUST_COMMAND_H
