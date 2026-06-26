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

#ifndef HMC_PREVIEW_ENGINE_ITF_H
#define HMC_PREVIEW_ENGINE_ITF_H

#include "MediaCreative.h"
#include "Editor/HmcEventHandler.h"
#include "render/core/HmcRenderEngineItf.h"
#include "Project/IHmcDraft.h"

/**
 * @brief 预览引擎，提供刷新预览区画面、播放预览区画面、暂停播放等功能。
 */
class HmcPreviewEngineItf : public IHmcDraft {
public:
    /* *
     * @brief 创建预览引擎，无需调用者手动销毁.
     * @param handler editor的事件通知接口.
     * @param graphicsRenderEngine 图形渲染引擎的接口，由调用者创建并传进导出引擎.
     * @param mediaType 编辑的媒体的类型：支持图片和视频.
     * @return std::shared_ptr<HmcExportEngineItf> 预览引擎的智能指针，无需调用者手动销毁.
     */
    static std::shared_ptr<HmcPreviewEngineItf> CreatePreviewEngine(HmcEventHandler *handler,
        std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine, HmcEditMediaType mediaType);

    /* *
     * @brief 启动预览引擎.
     * @return HMC_OK表示成功，其他表示对应的错误码.
     */
    virtual int32_t Startup() = 0;

    /* *
     * @brief 关闭预览引擎.
     */
    virtual void Shutdown() = 0;

    /* *
     * @brief 设置预览窗口，设置后预览画面将在对应的屏幕窗口区域显示.
     * @param window 期望显示画面的窗口句柄指针
     */
    virtual void SetPreviewWindow(void *window) = 0;

    /* *
     * @brief 获取预览canvas的size.
     * @return size canvas的size，包括宽高.
     */
    virtual HmcSize GetCanvasSize() const = 0;

    /* *
     * @brief 设置预览canvas的size.
     * @param size canvas的size，包括宽高.
     */
    virtual void SetCanvasSize(const HmcSize &size) = 0;

    /* *
     * @brief 播放预览的对象，比如视频，音频；图片不支持该操作.
     * @param startTime 播放的起始时间（轨道上的时间）.
     * @param endTime 播放的结束时间（轨道上的时间）.
     * @param fps 播放帧率.
     */
    virtual void Play(uint64_t startTime, uint64_t endTime, uint32_t fps) = 0;

    /* *
     * @brief 暂停播放，图片不支持该操作.
     */
    virtual void Pause() = 0;

    /* *
     * @brief 刷新当前位置的画面：图片刷新第0帧（有且只有第0帧），视频刷新当前时间线位置所在的画面.
     */
    virtual void Flush() = 0;

    /* *
     * @brief
     * 刷新指定位置的画面：图片刷新第0帧（有且只有第0帧），视频刷新指定位置所在的画面，如果time>轨道的结束时间，则刷新最后一帧.
     */
    virtual void Flush(uint64_t time, bool exactMode = true) = 0;

    /* *
     * @brief 获取预览时间范围(轨道时间).
     * @param startTime 起始时间（轨道上的时间）.
     * @param endTime 结束时间（轨道上的时间）.
     */
    virtual void GetPreviewPeriodRange(uint64_t &startTime, uint64_t &endTime) = 0;

    /* *
     * @brief 设置预览时间范围(轨道时间).
     * @param startTime 起始时间（轨道上的时间）.
     * @param endTime 结束时间（轨道上的时间）.
     */
    virtual void SetPreviewPeriodRange(uint64_t startTime, uint64_t endTime) = 0;

    /* *
     * @brief 获取当前预览的时间位置(轨道时间).
     * @return uint64_t 当前预览的时间位置.
     */
    virtual uint64_t GetCurrentTime() const = 0;

    /* *
     * @brief
     * 创建一个解码和渲染需要使用的Surface，解码将数据解到该surface，渲染使用该surface的数据进行渲染，不需要主动释放，渲染结束后会自行释放.
     * @return HmcSurfaceTexture.
     */
    virtual HmcSurfaceTexture *CreateSurface() = 0;
    
    virtual std::shared_ptr<HmcTaskManager> GetTaskMgr() = 0;
    
    /**
     * 强制执行渲染任务
     * @return
     */
    virtual void FlushForce() = 0;
};

#endif // HMC_PREVIEW_ENGINE_ITF_H
