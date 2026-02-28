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

#ifndef HMC_EXPORT_ENGINE_ITF_H
#define HMC_EXPORT_ENGINE_ITF_H

#include "MediaCreative.h"
#include "Editor/HmcEventHandler.h"
#include "render/core/HmcRenderEngineItf.h"

/**
 * @brief 导出引擎，提供导出，取消导出的功能。
 */
class HmcExportEngineItf {
public:
    /* *
     * @brief 导出图片、视频的接口.
     * @param dict 导出接口的参数
     * @return int32_t 成功返回HMC_OK, 其他表示失败的错误码.
     */
    virtual int32_t Export(const HmcDict *dict) = 0;

    /* *
     * @brief 取消导出.
     */
    virtual void Cancel() = 0;

    /* *
     * @brief 获取导出canvas的大小.
     * @return HmcSize 导出canvas的大小.
     */
    virtual HmcSize GetCanvasSize() const = 0;

    /* *
     * @brief 设置导出canvas的size.
     * @param size canvas的size，包括宽高.
     */
    virtual void SetCanvasSize(const HmcSize &size) = 0;

    /* *
     * @brief
     * 设置预览canvas的size，导出功能内部要根据预览canvas的大小和要渲染画面的缩放位移等，来调整导出画面的缩放位移等.
     * @param size canvas的size，包括宽高.
     */
    virtual void SetPreviewCanvasSize(const HmcSize &size) = 0;

    /* *
     * @brief 创建导出引擎，无需调用者手动销毁.
     * @param handler editor的事件通知接口.
     * @param graphicsRenderEngine 图形渲染引擎的接口，由调用者创建并传进导出引擎.
     * @param type 导出媒体的类型：支持图片和视频.
     * @return std::shared_ptr<HmcExportEngineItf> 导出引擎的智能指针，无需调用者手动销毁.
     */
    static std::shared_ptr<HmcExportEngineItf> CreateExportEngine(HmcEventHandler *handler,
        std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine, HmcExportMediaType type);
    
    virtual void SetExportInfoCallback(HmcEditExportFunc func) = 0;

    virtual void EncodePicture(HmcDict *dict, OH_PictureNative *pictureNative,
        std::function<void (const std::string &, const std::string &)> callback) = 0;

    virtual std::shared_ptr<HmcTaskManager> GetExportTask() = 0;
};

#endif // HMC_EXPORT_ENGINE_ITF_H
