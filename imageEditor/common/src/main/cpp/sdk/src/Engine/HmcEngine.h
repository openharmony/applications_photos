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

#ifndef HMCENGINE_H
#define HMCENGINE_H

#include "../Base/HmcBase.h"

#ifdef __cplusplus
#include <json/json.h>
#endif

// 毫秒为单位的时间基准
#define HMC_TIME_BASE_MS \
    (AVRational)         \
    {                    \
        1, 1000          \
    }
#define HMC_TIME_BASE_US \
    (AVRational)         \
    {                    \
        1, 1000000       \
    }


// 获取错误描述字符串
#define HMC_ERR2STR(e) \
    av_make_error_string((char *)__builtin_alloca(AV_ERROR_MAX_STRING_SIZE), AV_ERROR_MAX_STRING_SIZE, e)


#include <multimedia/player_framework/native_avcodec_videodecoder.h>

#include "../../include/MediaCreative/HmcImage.h"

#include "./image/HmcImageBase.h"
#include "./image/file/HmcImageFromFile.h"
#include "./image/file/HmcImageFromFileSerialized.h"
#include "./image/PixelmapFrame/PixelmapFrame.h"
#include "./image/encoder/HmcJpegEncoder.h"
#include "./image/decoder/HmcJpegDecoder.h"

#include "render/core/VisionTransformInfo.h"
#include "render/core/VideoRenderInfo.h"
#include "./render/base/AudioRenderInfo.h"

#include "render/core/HmcRenderEngineItf.h"
#include "render/core/HmcMaterialRenderResource.h"

#endif // HMCENGINE_H
