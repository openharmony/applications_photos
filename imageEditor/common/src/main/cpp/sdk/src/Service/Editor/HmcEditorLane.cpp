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

static inline HmcLaneManager *GetLaneManager(const HmcEditor *editor)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return nullptr;
    }

    auto editorImp = static_cast<const HmcEditorImp *>(editor);

    return editorImp->GetLaneManager();
}

int HmcLaneGetCount(HmcEditor *editor, HmcLaneType type)
{
    HmcLaneManager *manager = GetLaneManager(editor);
    if (manager == nullptr) {
        return 0;
    }

    return manager->GetLaneCount(type);
}

void HmcLaneGetArr(HmcEditor *editor, HmcLaneType type, HmcUid *laneUid, int *count)
{
    HmcLaneManager *manager = GetLaneManager(editor);
    if (manager == nullptr) {
        *count = 0;
        return;
    }

    manager->GetLaneArr(type, laneUid, count);
}

int HmcLaneGetAssetCount(HmcEditor *editor, HmcUid laneUid)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return 0;
    }

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        return 0;
    }

    VECTOR<HmcUid> assetList;
    lane->GetAssetList(assetList);

    return static_cast<int>(assetList.size());
}

void HmcLaneGetAssetArr(HmcEditor *editor, HmcUid laneUid, HmcUid *assetUid, int *count)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        *count = 0;
        return;
    }

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        *count = 0;
        return;
    }

    VECTOR<HmcUid> assetList;
    lane->GetAssetList(assetList);

    int size = 0;
    for (const auto &uid : assetList) {
        if (size >= *count) {
            break;
        }
        IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(uid);
        if (asset) {
            assetUid[size] = uid;
            size++;
        }
    }

    *count = size;
}

HmcLaneType HmcLaneGetType(HmcEditor *editor, HmcUid laneUid)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return HMC_LANE_NONE;
    }

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        return HMC_LANE_NONE;
    }

    return lane->GetType();
}

int HmcLaneGetIndex(const HmcEditor *editor, HmcUid laneUid, unsigned int *index)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return HMC_ERR_PARAM;
    }

    HmcLaneManager *laneManager = GetLaneManager(editor);
    if (laneManager == nullptr) {
        return HMC_ERR;
    }

    return laneManager->GetLaneIndex(laneUid, *index);
}

HmcUid HmcLaneCreate(HmcEditor *editor, HmcLaneType type)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return HMC_UID_NULL;
    }

    HmcLaneManager *laneManager = GetLaneManager(editor);
    if (laneManager == nullptr) {
        return HMC_UID_NULL;
    }

    return laneManager->CreateLane(type);
}

HmcUid HmcLaneCreateLaneEntity(HmcEditor *editor, HmcLaneType type)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return HMC_UID_NULL;
    }

    HmcLaneManager *laneManager = GetLaneManager(editor);
    if (laneManager == nullptr) {
        return HMC_UID_NULL;
    }

    return laneManager->CreateLaneEntity(type);
}

HMC_API int HmcLaneAppend(HmcEditor *editor, HmcUid laneUid)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("HmcLaneRemove error, editor is nullptr");
        return HMC_ERR_PARAM;
    }

    HmcLaneManager *laneManager = GetLaneManager(editor);
    if (laneManager == nullptr) {
        LOGE("HmcLaneAppend, laneManager is nullptr");
        return HMC_ERR;
    }

    return laneManager->AppendLane(laneUid);
}

int HmcLaneInsert(HmcEditor *editor, HmcUid laneUid, unsigned int index)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("HmcLaneRemove error, editor is nullptr");
        return HMC_ERR_PARAM;
    }

    HmcLaneManager *laneManager = GetLaneManager(editor);
    if (laneManager == nullptr) {
        LOGE("HmcLaneInsert, laneManager is nullptr");
        return HMC_ERR;
    }

    return laneManager->InsertLane(laneUid, index);
}

int HmcLaneDestroy(HmcEditor *editor, HmcUid laneUid)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return HMC_ERR_PARAM;
    }

    int result = HmcLaneRemove(editor, laneUid);
    if (result != HMC_OK) {
        LOGE("remove lane from lane manager failed with error: %d", result);
        return result;
    }

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane != nullptr) {
        delete lane;
    }

    return HMC_OK;
}

int HmcLaneRemove(HmcEditor *editor, HmcUid laneUid)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("HmcLaneRemove error, editor is nullptr");
        return HMC_ERR_PARAM;
    }

    HmcLaneManager *laneManager = GetLaneManager(editor);
    if (laneManager == nullptr) {
        LOGE("HmcLaneRemove, laneManager is nullptr");
        return HMC_ERR;
    }

    laneManager->RemoveLane(laneUid);

    return HMC_OK;
}

HmcUid HmcLaneGetAvailableLane(HmcEditor *editor, HmcLaneType type, int64_t startTime, int64_t endTime)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return HMC_UID_NULL;
    }

    HmcLaneManager *manager = GetLaneManager(editor);
    if (manager == nullptr) {
        LOGE("get lane manager failed");
        return HMC_UID_NULL;
    }

    return manager->GetAvailableLane(type, startTime, endTime);
}

int HmcLaneSetMute(HmcEditor *editor, HmcUid laneUid, int mute)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return HMC_ERR_PARAM;
    }

    BOOL isMute = (mute ? TRUE : FALSE);

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("lane is invalid, please check your lane id");
        return HMC_ERR_SERVICE_LANE_INVALID;
    }

    lane->SetMute(isMute);

    return HMC_OK;
}

int HmcLaneIsMute(HmcEditor *editor, HmcUid laneUid)
{
    HMC_UNUSED(editor);

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("lane is invalid, please check your lane id");
        return FALSE;
    }

    return lane->IsMute();
}

int HmcLaneSetVolume(HmcEditor *editor, HmcUid laneUid, int volume)
{
    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("lane is invalid, please check your lane id");
        return HMC_ERR;
    }

    int count = HmcLaneGetAssetCount(editor, laneUid);
    if (count == 0) {
        return HMC_OK;
    }

    HmcUid *pAssetUid = new HmcUid[count];
    HmcLaneGetAssetArr(editor, laneUid, pAssetUid, &count);
    LOGD("HmcLaneSetVolume count=%d", count);

    delete[] pAssetUid;
    return HMC_OK;
}

int HmcLaneSetVisible(HmcEditor *editor, HmcUid laneUid, int visible)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return HMC_ERR_PARAM;
    }

    BOOL isVisible = (visible ? TRUE : FALSE);

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("lane is invalid, please check your lane id");
        return HMC_ERR_SERVICE_LANE_INVALID;
    }

    lane->SetVisible(isVisible);

    return HMC_OK;
}

int HmcLaneIsVisible(HmcEditor *editor, HmcUid laneUid)
{
    HMC_UNUSED(editor);

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("lane is invalid, please check your lane id");
        return FALSE;
    }

    return lane->IsVisible();
}