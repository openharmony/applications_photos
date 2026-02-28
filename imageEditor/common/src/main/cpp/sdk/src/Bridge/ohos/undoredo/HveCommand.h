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

#ifndef HVECOMMAND_H
#define HVECOMMAND_H

#include "MediaCreative.h"
#include "HmcBase.h"
#include "MediaCreative/HmcError.h"
#include "ohos/common/HmcDictHelper.h"
#include "ohos/hve/Project.h"
constexpr double UNDO_REDO_EPS = 0.01; // 当前参数精度最小为0.1，这里用两个参数差值小于0.01表示未改变

#define USE_TIMELINE(ret)                                                \
    LOGD("%s invoked", __FUNCTION__);                                    \
    HveTimeline *timeline = Project::Instance().GetTimeline(timelineId); \
    if (timeline == nullptr) {                                           \
        LOGE("timeline is null. %d", timelineId);                        \
        return ret;                                                      \
    }

#define USE_EDITOR(ret)                        \
    USE_TIMELINE(ret)                          \
    HmcEditor *editor = timeline->GetEditor(); \
    if (nullptr == editor) {                   \
        LOGE("editor is null. ");              \
        return ret;                            \
    }

#define USE_ASSET(ret)                                      \
    USE_EDITOR(ret)                                         \
    HmcUid assetUid = HmcUidHelper(assetId);                \
    HveAsset *hveAsset = timeline->GetHveAsset(assetUid);   \
    if (nullptr == hveAsset) {                              \
        LOGE("asset is null. ");                            \
        return ret;                                         \
    }

class HveCommand {
public:
    HveCommand(int timelineId, std::string const & type, std::string const & assetId);
    virtual ~HveCommand();

    virtual int Execute() = 0;
    virtual std::string Undo() = 0;
    virtual std::string Redo() = 0;
    virtual int Merge()
    {
        return HMC_OK;
    }
    inline std::string GetCommandType() const
    {
        return type;
    }

public:
    int timelineId;
    std::string assetId;
    std::string type; // id
    Json::FastWriter m_fastWriter;
};

#endif // HVECOMMAND_H
