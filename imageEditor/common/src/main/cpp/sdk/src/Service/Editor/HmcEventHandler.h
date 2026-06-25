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

#ifndef HMCEDITOREVENTHANDLER_H
#define HMCEDITOREVENTHANDLER_H

#include "HmcBase.h"

namespace HMC {
using EventId = enum EventId {
    EVENT_ERROR,
    EVENT_DURATION_CHANGE,
    EVENT_PLAY_STATE_CHANGE,
    EVENT_PLAY_POS_CHANGE,
    EVENT_EXPORT_PROGRESS_CHANGE,
    EVENT_EXPORT_STATE_CHANGE,
    EVENT_THUMBNAIL_UPDATE,
    EVENT_THUMBNAIL_IMAGE_UPDATE,
    EVENT_FILTER_THUMBNAIL,
    EVENT_REMOVE_EFFECT,
    EVENT_INIT_INNER_EFFECT,
    EVENT_TEST
};

using GetDataId = enum GetDataId {
    GET_DATA_VIDEO_DURATION,
    GET_DATA_CANVAS_SIZE,
    GET_DATA_CURRENT_TIME,
    GET_DATA_EDITOR_STATE,
    GET_DATA_NATIVE_WINDOW,
    GET_DATA_TIMELINE_END_TIME,
};
}

class VideoRenderInfo;
class AudioRenderInfo;

class HmcEventHandler {
public:
    virtual ~HmcEventHandler() {}
    // 泳道素材返回回调
    virtual VOID OnEventNotify(HMC::EventId eventId, VOID *eventMsg, VOID *eventData) = 0;
    virtual VOID OnGetData(HMC::GetDataId eventId, VOID *eventMsg, VOID *eventData) = 0;
    virtual std::shared_ptr<VideoRenderInfo> OnPackGraphicsRenderInfo(uint64_t time, bool exactMode = true) = 0;
    virtual void OnSeekEnd() = 0;
    virtual VOID OnExportStateChange(INT32 state) = 0;
    virtual void OnExportProgressChange(uint32_t progress) = 0;
    virtual VOID OnImportResultNotify(INT32 result) = 0;
    virtual VOID OnExportResultNotify(INT32 result) = 0;
    // 等待空闲执行
    virtual void WaitForIdleToRunTask(){};
    virtual void RequestPrefetching(){};
};

#endif // HMCEDITOREVENTHANDLER_H
