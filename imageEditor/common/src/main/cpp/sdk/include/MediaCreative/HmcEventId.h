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

#ifndef HMCEVENTID_H
#define HMCEVENTID_H

// 回调事件
typedef enum HmcEventId {
    HMC_EVENT_ERROR,
    HMC_EVENT_DURATION_CHANGE,
    HMC_EVENT_PLAY_STATE_CHANGE,
    HMC_EVENT_PLAY_POS_CHANGE,
    HMC_EVENT_EXPORT_PROGRESS_CHANGE,
    HMC_EVENT_IMPORT_RESULT_NOTIFY,
    HMC_EVENT_EXPORT_RESULT_NOTIFY,
    HMC_EVENT_THUMBNAIL_UPDATE,
    HMC_EVENT_FILTER_THUMBNAIL_UPDATE,
    HMC_EVENT_EXPORT_STATE_CHANGE,
    HMC_EVENT_ASSET_SIZE_UPDATE,
    HMC_EVENT_ASSET_POSITION_UPDATE,
    HMC_EVENT_ASSET_FADE_DURATION_CHANGE,
    HMC_EVENT_SAVE_DRAFT,
    HMC_EVENT_TEST,
    HMC_EVENT_XTStyle_THUMBNAIL_UPDATE                  // 个性风格缩略图回调
} HmcEventId;

#endif // HMCEVENTID_H
