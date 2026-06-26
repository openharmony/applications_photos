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

#ifndef HMC_EXPORT_ENGINE_H
#define HMC_EXPORT_ENGINE_H

#include "util/HmcRectD.h"
#include "Editor/HmcEventHandler.h"
#include "render/core/HmcRenderEngineItf.h"
#include "Editor/Export/HmcExportEngineItf.h"
#include <multimedia/image_effect/image_effect_filter.h>

#define CHECK_IMAGEEFFECT_RETURN(effect, cond, fmt, ...)                                                               \
    if (!(cond)) {                                                                                                     \
        LOGE(fmt, ##__VA_ARGS__);                                                                                      \
        if (effect != nullptr) {                                                                                       \
            OH_ImageEffect_Release(effect);                                                                            \
            effect = nullptr;                                                                                          \
        }                                                                                                              \
        return HMC_ERR;                                                                                                \
    }

enum class HmcExportEngineState {
    INIT = 0,
    RUNNING,
    CANCELING,
    FINISH
};

typedef struct RenderFinishParam {
    int32_t width;
    int32_t height;
    OH_PictureNative *pictureNative;
    uint64_t index;
    bool needAddWatermark;
    bool isSave;
};

class HmcExportEngine : public HmcExportEngineItf, public std::enable_shared_from_this<HmcExportEngine> {
public:
    HmcExportEngine(HmcEventHandler *handler, std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine);
    virtual ~HmcExportEngine();

    int Export(const HmcDict *dict) override;

    void Cancel() override;

    HmcSize GetCanvasSize() const override;

    void SetPreviewCanvasSize(const HmcSize &size) override;
    
    void SetExportInfoCallback(HmcEditExportFunc func) override;
    
    std::shared_ptr<HmcTaskManager> GetExportTask() override;

protected:
    virtual int InitExportParameter(const HmcDict *dict);
    virtual void ResetEnv();
    virtual int InitExportEnv() = 0;
    virtual int ExportProc(HmcDict *exportParameter);
    virtual void SetCanvasSize(const HmcSize &size) = 0;
    virtual void SyncRenderCanvasSize() = 0;
    virtual void RenderGraphicsData(std::shared_ptr<VideoRenderInfo> &renderInfo, uint64_t index, uint32_t encodeType);
    virtual ExportData OnRenderFinish(RenderFinishParam renderFinishParam, std::string mimeType) = 0;
    virtual ExportData OnExportFinish(RenderFinishParam renderFinishParam) = 0;
    
    void SetFragmentForWatermark(OH_PictureNative *outPicture, LIST<HmcRenderEffectPtr> &effectList, int32_t w, int32_t h);

    void AdjustRenderCanvasColor(const std::shared_ptr<VideoRenderInfo> &renderInfo);

protected:
    void UpdateRenderInfo(std::shared_ptr<VideoRenderInfo> &renderInfo);

    void RunExportTask(HmcDict *exportParameter);

private:
    void CancelInner();
    std::shared_ptr<HmcTransformInfo> CalcTransformInfo(const HmcRectD &displayArea,
        const HmcTransformInfo &previewTransform) const;
    HmcRectD CalcDisplayArea(HmcRenderEffectPtr &transform) const;
    HmcTransformInfo CalcPreviewTransform(HmcRenderEffectPtr &transformEffect) const;
    HmcRenderEffectPtr GetTransformEffect(std::shared_ptr<VideoRenderInfo> &renderInfo);
    static void UpdateTransformEffect(HmcRenderEffectPtr &transform,
        const std::shared_ptr<HmcTransformInfo> &transformInfo);
    bool checkPreviewSize(const HmcSize &previewSize) const;

protected:
    HmcEventHandler *m_handler{ nullptr };

    HmcExportEngineState m_state{ HmcExportEngineState::INIT };

    std::string m_exportPath;
    HmcExportMediaType m_exportMediaType{ HMC_EXPORT_MEDIA_TYPE_VIDEO_WITH_AUDIO };

    HmcSize m_canvasSize{ 0.0, 0.0 }; // RenderManager自己的CanvasSize, RenderManager内部维护.
    HmcRenderCanvas m_renderCanvas;   // 用来对接渲染，符合渲染的canvas格式.

    HmcSize m_previewCanvasSize{ 0.0, 0.0 };

    std::shared_ptr<HmcTransformInfo> m_transformInfoForExport{ nullptr };

    std::shared_ptr<HmcRenderEngineItf> m_graphicsRender{ nullptr };

    std::shared_ptr<HmcTaskManager> m_taskMgr{ nullptr };

    HmcEditExportFunc exportInfoCallback_;
};

#endif // HMC_EXPORT_ENGINE_H
