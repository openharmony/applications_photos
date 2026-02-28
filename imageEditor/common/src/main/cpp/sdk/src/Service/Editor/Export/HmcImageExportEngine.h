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

#ifndef HMC_IMAGE_EXPORT_ENGINE_H
#define HMC_IMAGE_EXPORT_ENGINE_H

#include "render/core/HmcRenderEngineItf.h"
#include "Editor/Export/HmcExportEngine.h"
#include "HmcEncoderManager.h"
#include "ohos/hve/ProjectConfig.h"

class HmcImageExportEngine : public HmcExportEngine {
public:
    HmcImageExportEngine(HmcEventHandler *handler, std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine);
    ~HmcImageExportEngine() override;

    void Cancel() override;

protected:
    int InitExportEnv() override;
    int InitExportParameter(const HmcDict *dict) override;
    int ExportProc(HmcDict *exportParameter) override;
    void SetCanvasSize(const HmcSize &size) override;
    void SyncRenderCanvasSize() override;
    std::string AdaptHeicSmallSizeMimeType(std::string mimeType, uint32_t width, uint32_t height);
    ExportData OnRenderFinish(RenderFinishParam renderFinishParam, std::string mimeType ) override;
    ExportData OnExportFinish(RenderFinishParam renderFinishParam) override;
    void EncodePicture(HmcDict *dict, OH_PictureNative *pictureNative,
        std::function<void (const std::string &, const std::string &)> callback) override;

private:
    std::shared_ptr<HmcImageMetaData> GetMetadata(const char *assetUidStr) const;
    void ProcessExifOnExistForPixelmap(OH_PixelmapNative *srcPixel, STRING orientation);

private:
    std::shared_ptr<HmcImageMetaData> m_metadata{ nullptr };
};

#endif // HMC_IMAGE_EXPORT_ENGINE_H
