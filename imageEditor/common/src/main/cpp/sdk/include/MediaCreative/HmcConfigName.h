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

#ifndef HMCCONFIGNAME_H
#define HMCCONFIGNAME_H

// 视频解码引擎类型选择，类型字符串，当前支持的配置值:
// "auto"       自动根据硬件配置自动选择合适的解码器，默认值
// "sw"         仅使用软解码器
#define HMC_CFG_VIDEO_DECODER_TYPE "video.decoder.type"

#define HMC_HIANALYTICS_UUID_START "uuid_start"
#define HMC_HIANALYTICS_UUID_EXIT "uuid_exit"
#define HMC_APPLY_NOTIFICATION_AGREE "apply_notification"

#endif // HMCCONFIGNAME_H
