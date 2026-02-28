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

#ifndef NEWPHOTOS_HVESTYLUSCOMMAND_H
#define NEWPHOTOS_HVESTYLUSCOMMAND_H

#include "HveCommand.h"

class HveCmdCompose final : public HveCommand {
public:
    HveCmdCompose(int timelineId, std::string const & type, std::string const & assetId, void *pixelBuffer, int x,
        int y, int width, int height);

    ~HveCmdCompose() final;

    int Execute() final;
    
    int Execute(std::function<void(napi_value value)> cb);

    std::string Undo() final;

    std::string Redo() final;

    int Merge() final;

    int ComStylus(int timelineId, std::string const & assetId, std::function<void(napi_value value)> cb);

    void ComposeTimeline(int timelineId, std::string const & assetId, int mediaType, HmcUid effectId,
                         std::function<void(napi_value value)> cb);

private:
    void *pixelBuffer;
    std::string type;
    int x;
    int y;
    int width;
    int height;
};

#endif // NEWPHOTOS_HVESTYLUSCOMMAND_H
