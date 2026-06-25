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

#include "HveCutCommand.h"
#include "MediaCreative/HmcError.h"

HveCmdTrim::HveCmdTrim(int timelineId, std::string const & type, std::string const & assetId, int trimDirection,
    int offset)
    : HveCommand(timelineId, type, assetId), trimDirection(trimDirection), curOffset(offset)
{}
HveCmdTrim::~HveCmdTrim() {}
int HveCmdTrim::Execute()
{
    USE_ASSET(HMC_ERR);
    LOGI("UndoRedo HveCmdTrim Execute trimDirection = %d, offset = %d", trimDirection, curOffset);
    if ((HmcTrimType)trimDirection == HMC_TRIM_OUT) {
        lastOffset = hveAsset->GetTrimOut();
    }
    return ComTrim(trimDirection, curOffset);
}

std::string HveCmdTrim::Undo()
{
    LOGI("UndoRedo HveCmdTrim Undo trimDirection = %d, last_offset = %d", trimDirection, lastOffset);
    int ret = ComTrim(trimDirection, lastOffset);
    if (ret != HMC_OK) {
        return "";
    }
    std::string subType = trimDirection == 0 ? "trimLeft" : "trimRight";
    Json::Value json;
    json["id"] = type;
    json[subType] = lastOffset;
    return m_fastWriter.write(json);
}

std::string HveCmdTrim::Redo()
{
    LOGI("UndoRedo HveCmdTrim Redo trimDirection = %d, last_offset = %d", trimDirection, curOffset);
    int ret = ComTrim(trimDirection, curOffset);
    if (ret != HMC_OK) {
        return "";
    }
    std::string subType = trimDirection == 0 ? "trimLeft" : "trimRight";

    Json::Value json;
    json["id"] = type;
    json[subType] = curOffset;
    return m_fastWriter.write(json);
}

int HveCmdTrim::ComTrim(int type, int offset)
{
    USE_ASSET(HMC_ERR);
    if (timeline == nullptr) {
        LOGE("timeline is null. %d", timelineId);
        return HMC_ERR;
    }

    if ((HmcTrimType)type == HMC_TRIM_OUT) {
        if (hveAsset->GetTrimOut() == offset) {
            LOGE("offset not changge, offset=%d", offset);
            return HMC_ERR;
        }
        hveAsset->SetTrimOut(offset);
    }
    // 更新预览区区间
    int64_t duration = HmcAssetGetFileDuration(editor, assetUid);
    int64_t startTime = hveAsset->GetTrimIn();
    int64_t endTime = duration - hveAsset->GetTrimOut();
    HmcEditorSetPreviewPeriodRange(editor, startTime, endTime);
    return HMC_OK;
}


HveCmdMute::HveCmdMute(int timelineId, std::string const & type, std::string const & assetId, int mute)
    : HveCommand(timelineId, type, assetId), curMute(mute)
{}
HveCmdMute::~HveCmdMute() {}

std::string HveCmdMute::Undo()
{
    USE_ASSET("");
    int ret = ComMute(lastMute);
    if (ret != HMC_OK) {
        return "";
    }

    Json::Value json;
    if (lastMute == 0) {
        json["id"] = "volumeOff";
        json["isMute"] = lastMute;
    } else {
        json["id"] = "volumeOn";
        json["isMute"] = lastMute;
    }
    return m_fastWriter.write(json);
}
std::string HveCmdMute::Redo()
{
    USE_ASSET("");
    int ret = ComMute(curMute);
    if (ret != HMC_OK) {
        return "";
    }
    Json::Value json;
    if (curMute == 0) {
        json["id"] = "volumeOn";
        json["isMute"] = curMute;
    } else {
        json["id"] = "volumeOff";
        json["isMute"] = curMute;
    }
    return m_fastWriter.write(json);
}

int HveCmdMute::Execute()
{
    USE_ASSET(HMC_ERR);
    lastMute = hveAsset->GetMute();
    return ComMute(curMute);
}

int HveCmdMute::ComMute(int mute)
{
    USE_ASSET(HMC_ERR);
    int ret = HmcAssetSetMute(timeline->GetEditor(), assetUid, mute);
    if (ret != HMC_OK) {
        return ret;
    }
    hveAsset->SetMute(mute);
    return ret;
}