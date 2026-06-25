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

#ifndef OH_HVE_CUT_COMMAND_H
#define OH_HVE_CUT_COMMAND_H

#include "HveCommand.h"

class HveCmdTrim final : public HveCommand {
public:
    HveCmdTrim(int timelineId, std::string const & type, std::string const & assetId, int trimDirection, int offset);
    ~HveCmdTrim() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int ComTrim(int trimDirection, int offset);

private:
    int trimDirection;
    INT64 curOffset;
    INT64 lastOffset = 0;
};

class HveCmdMute final : public HveCommand {
public:
    HveCmdMute(int timelineId, std::string const & type, std::string const & assetId, int mute);
    ~HveCmdMute() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int ComMute(int mute);

private:
    int curMute;
    int lastMute = 0;
};

#endif // OH_HVE_CUT_COMMAND_H
