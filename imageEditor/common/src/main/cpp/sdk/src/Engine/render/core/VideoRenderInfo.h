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

#ifndef VIDEO_RENDER_INFO_H
#define VIDEO_RENDER_INFO_H

#include "HmcBaseType.h"
class HmcRenderLayer;
class HmcRenderCanvas;

class VideoRenderInfo {
public:
    ~VideoRenderInfo()
    {
        layers.clear();
    }

public:
    ATOMIC_BOOL *m_isChangingPicPtr = nullptr;
    std::vector<std::shared_ptr<HmcRenderLayer>> layers;
    std::shared_ptr<HmcRenderCanvas> canvas{ nullptr };
    float scale = 1.0;
    bool isDiscard =
        false; // 原视频非固定帧率导出,sdk
               // timeline固定时间间隔请求帧,对于请求重复帧,surface解码不能再复用,用该标志标识跳过重复帧编码
    std::string mimeType;
    int32_t m_exportType; // 用于表示正常导出，还是涂鸦合成。0表示正常导出，1表示涂鸦合成
    void setMimeType(const std::string &type) { mimeType = type; }
 
    // Getter 方法
    std::string getMimeType() const { return mimeType; }
    
    void setExportType(int32_t type)
    {
        m_exportType = type;
    }
    
    int32_t getExportType()
    {
        return m_exportType;
    }
    void setIsPicChangingPtr(ATOMIC_BOOL *isChangingPicPtr)
    {
        m_isChangingPicPtr = isChangingPicPtr;
    }
};

#endif // VIDEO_RENDER_INFO_H
