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

#include "HveCommand.h"
#include "ohos/hve/HveAssetOper.h"

#ifndef OH_HVE_ADJUST_COMMAND_H
#define OH_HVE_ADJUST_COMMAND_H

class HveCmdAdjustValue final : public HveCommand {
public:
    HveCmdAdjustValue(int timelineId, std::string const &type, std::string const &assetId,
                      std::string const &adjustName, double value);
    ~HveCmdAdjustValue() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int Merge() final;
    int ComAdjust(std::string const &adjustName, int value, bool enable, int autoValue, bool autoEnable);
    void SetEnableChecked(bool isEnableChecked);

private:
    std::string ResultString(int value, bool enable, int autoValue, bool autoEnable);

private:
    double m_curValue;
    std::string m_curName;
    double m_lastValue = 0;
    std::string m_lastName = "";
    bool m_curEnable = true;
    bool m_lastEnable = true;
    double m_curAutoValue;
    bool m_curAutoEnable;
    double m_lastAutoValue;
    bool m_lastAutoEnable;
    bool m_isAssociatedItem;
    bool m_isEnableChecked;
};

class HveCmdAdjustEnable final : public HveCommand {
public:
    HveCmdAdjustEnable(int timelineId, std::string const &type, std::string const &assetId,
                       std::string const &adjustName, bool enable);
    ~HveCmdAdjustEnable() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int ComAdjustEnable(std::string const &adjustName, bool enable, int autoValue, bool autoEnable);

private:
    std::string ResultString(std::string const &idInfo, bool itemEnable, int autoValue, bool autoEnable);

private:
    bool m_curEnable;
    std::string m_curName;
    bool m_lastEnable = true;
    std::string m_lastName = "";
    std::string m_adjustEnableName = "";
    double m_curAutoValue;
    bool m_curAutoEnable;
    double m_lastAutoValue;
    bool m_lastAutoEnable;
    bool m_isAssociatedItem;
};

#endif // oh_HveAdjustCommand_H
