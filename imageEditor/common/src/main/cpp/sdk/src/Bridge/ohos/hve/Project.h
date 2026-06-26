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
#ifndef OH_PROJECT_H
#define OH_PROJECT_H

#include <map>
#include "HveTimeline.h"

class Project {
public:
    static Project &Instance()
    {
        static Project prj;
        return prj;
    }

    int CreateTimeline(HmcUid projectUid, int mediaType, std::function<void(std::string const & jsonPos)> sdkCallback,
        std::function<void(std::string const & jsonPos)> createResult, std::string const & editData)
    {
        uuid++;
        HveTimeline *timeline = new HveTimeline(uuid, projectUid, mediaType, sdkCallback, createResult, editData);
        id2timeline[uuid] = timeline;
        return uuid;
    }

    HveTimeline *GetTimeline(int targetUid)
    {
        HveTimeline *timeline = id2timeline.find(targetUid) != id2timeline.end() ? id2timeline[targetUid] : nullptr;
        if (timeline && !timeline->IsClosed()) {
            return timeline;
        }
        return nullptr;
    }

    HmcEditor *GetEditor(int targetUid)
    {
        HveTimeline *timeline = GetTimeline(targetUid);
        return timeline != nullptr ? timeline->GetEditor() : nullptr;
    }

    void Clear(int targetUid)
    {
        auto timeline = id2timeline.find(targetUid) != id2timeline.end() ? id2timeline[targetUid] : nullptr;
        if (timeline != nullptr) {
            id2timeline.erase(targetUid);
            delete timeline;
        }
    }
    void CloseTimeline(int targetUid)
    {
        auto timeline = GetTimeline(targetUid);
        if (timeline != nullptr) {
            timeline->Close();
        }
    }
    
    HveTimeline *GetCurrentTimeLine()
    {
        return GetTimeline(uuid);
    }

protected:
    std::map<int, HveTimeline *> id2timeline;
    int uuid = 1;
};

#endif // OH_PROJECT_H
