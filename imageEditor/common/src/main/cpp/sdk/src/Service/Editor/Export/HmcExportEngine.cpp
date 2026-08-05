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

#include "Editor/Export/HmcExportEngine.h"
#include "HmcBase.h"
#include "HmcService.h"
#include "MediaCreative/HmcEditorAsset.h"
#include "system/HmcSystem.h"
#include "HmcExportEngine.h"
#include <multimedia/image_effect/image_effect.h>

const int MIRROR_OFFSET_RATE = 2;

HmcExportEngine::HmcExportEngine(HmcEventHandler *handler, std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine)
    : m_handler(handler), m_graphicsRender(graphicsRenderEngine)
{
    LOGI("[Export] create export engine.");
    m_taskMgr = std::make_shared<HmcTaskManager>("HmcExportEngine", HmcTaskManagerTimeOpt::SEQUENTIAL);
}

HmcExportEngine::~HmcExportEngine()
{
    LOGI("[Export] destroy export engine.");

    CancelInner();

    LOGI("[Export] destroy export engine finish.");
}

int32_t HmcExportEngine::Export(const HmcDict *dict)
{
    LOGI("[Export] export start");

    ResetEnv();

    m_state = HmcExportEngineState::INIT;

    auto exportDict = HmcDictDuplicate(dict);
    if (!exportDict) {
        m_handler->OnExportStateChange(HmcExportState::HMC_EXPORT_STATE_IDLE);
        LOGE("[Export] duplicate exportDict failed");
        return HMC_ERR;
    }

    m_state = HmcExportEngineState::RUNNING;
    auto weakThis = weak_from_this();
    m_taskMgr->Submit([weakThis, exportDict]() {
        auto strong = weakThis.lock();
        if (strong == nullptr) {
            LOGE("HmcExportEngine::Export strong is nullptr.");
            HmcDictDestroy(exportDict);
            return;
        }
        strong->RunExportTask(exportDict);
    },
        __FUNCTION__);

    LOGI("[Export] export task has been committed.");

    return HMC_OK;
}

void HmcExportEngine::Cancel()
{
    CancelInner();
}

void HmcExportEngine::RunExportTask(HmcDict *exportParameter)
{
    LOGI("[Export] export thread running...");

    int result = HMC_OK;

    do {
        if (exportParameter == nullptr) {
            LOGE("[Export] export failed, parameter for exporting is null");
            result = HMC_ERR;
            break;
        }

        auto result = InitExportParameter(exportParameter);
        if (result != HMC_OK) {
            LOGE("[Export] export failed, init parameter for exporting failed with error: %d", result);
            break;
        }

        result = InitExportEnv();
        if (result != HMC_OK) {
            LOGE("[Export] export failed, init export env failed with error: %d", result);
            break;
        }

        result = ExportProc(exportParameter);
        if (result != HMC_OK) {
            LOGE("[Export] export failed, execute export proc failed with error: %d", result);
            break;
        }
    } while (false);

    if (exportParameter) {
        HmcDictDestroy(exportParameter);
    }

    if (result != HMC_OK) {
        m_handler->OnExportStateChange(HmcExportState::HMC_EXPORT_STATE_IDLE);
        m_handler->OnExportResultNotify(result);
    }

    m_state = HmcExportEngineState::FINISH;

    LOGI("[Export] export task exit finish with result %d.", result);
}

int HmcExportEngine::InitExportParameter(const HmcDict *exportParameter)
{
    LOGI("[Export] init export parameter...");
}

int HmcExportEngine::ExportProc(HmcDict *exportParameter)
{
    LOGI("[Export] export proc running...");
}

void HmcExportEngine::SetExportInfoCallback(HmcEditExportFunc func)
{
    exportInfoCallback_ = func;
}

HmcSize HmcExportEngine::GetCanvasSize() const
{
    return HmcSize{
        .width = m_canvasSize.width,
        .height = m_canvasSize.height
    };
}

void HmcExportEngine::SetPreviewCanvasSize(const HmcSize &size)
{
    m_previewCanvasSize = size;
}

void HmcExportEngine::RenderGraphicsData(std::shared_ptr<VideoRenderInfo> &renderInfo, uint64_t index,
    uint32_t encodeType)
{
    if (m_graphicsRender == nullptr) {
        LOGE("[HmcImageExportEngine] ExportGraphicsData failed, graphics render is null.");
        return;
    }

    AdjustRenderCanvasColor(renderInfo);

    UpdateRenderInfo(renderInfo);

    auto mimeType = renderInfo->getMimeType();
    LOGI("HmcExportEngine::RenderGraphicsData:%s", mimeType.c_str());
    auto weakThis = weak_from_this();
    HmcRenderExportFunc onRenderFinishCb = [weakThis, mimeType, this](OH_PictureNative *outPicture, int32_t w,
        int32_t h, uint64_t index) -> ExportData {
        auto strong = weakThis.lock();
        if (strong == nullptr) {
            LOGI("HmcExportEngine::RenderGraphicsData strong is nullptr.");
            OH_PictureNative_Release(outPicture);
            return {};
        }
        RenderFinishParam renderFinishParam = {.width = w,
            .height = h,
            .pictureNative = outPicture,
            .index = index,
            .isSave = strong->exportInfoCallback_.isSave,
            .needAddWatermark = 0};
        if (strong->exportInfoCallback_.exportType == 1) {
            return strong->OnExportFinish(renderFinishParam);
        } else {
            return strong->OnRenderFinish(renderFinishParam, mimeType);
        }
    };
    ExportParam param = {onRenderFinishCb,
                         index,
                         encodeType,
                         0,
                         static_cast<UINT32>(renderInfo->getExportType()),
                         exportInfoCallback_.needAddWatermark};
    m_graphicsRender->Export(renderInfo->layers, m_renderCanvas, param);
}

void HmcExportEngine::AdjustRenderCanvasColor(const std::shared_ptr<VideoRenderInfo> &renderInfo)
{
    if (renderInfo->canvas == nullptr) {
        return;
    }

    if (renderInfo->canvas->bgTexture_ != nullptr) {
        m_renderCanvas.bgTexture_ = renderInfo->canvas->bgTexture_;
    }

    m_renderCanvas.bgColor_.x = (renderInfo->canvas->bgColor_.x);
    m_renderCanvas.bgColor_.y = (renderInfo->canvas->bgColor_.y);
    m_renderCanvas.bgColor_.z = (renderInfo->canvas->bgColor_.z);
    m_renderCanvas.bgColor_.w = (renderInfo->canvas->bgColor_.w);
}

void HmcExportEngine::UpdateRenderInfo(std::shared_ptr<VideoRenderInfo> &renderInfo)
{
    auto transformEffect = GetTransformEffect(renderInfo);

    HmcRectD displayArea = CalcDisplayArea(transformEffect);
    HmcTransformInfo previewTransformInfo = CalcPreviewTransform(transformEffect);
    m_transformInfoForExport = CalcTransformInfo(displayArea, previewTransformInfo);

    UpdateTransformEffect(transformEffect, m_transformInfoForExport);
}

std::shared_ptr<HmcTransformInfo> HmcExportEngine::CalcTransformInfo(const HmcRectD &displayArea,
    const HmcTransformInfo &previewTransform) const
{
    auto exportTransform = std::make_shared<HmcTransformInfo>();

    auto previewSize = HmcSize{
        .width = static_cast<float>(displayArea.Width()),
        .height = static_cast<float>(displayArea.Height())
    };
    auto exportSize = HmcSize{
        .width = m_canvasSize.width,
        .height = m_canvasSize.height
    };

    // 没有预览页面时将 scale 设置为固定值 1.0
    if (!checkPreviewSize(previewSize)) {
        exportTransform->scaleX = 1.0;
        exportTransform->scaleY = 1.0;
    } else {
        exportTransform->scaleX = (exportSize.width / previewSize.width) * previewTransform.scaleX;
        exportTransform->scaleY = (exportSize.height / previewSize.height) * previewTransform.scaleY;
    }

    // 屏幕或者canvas的中心点，屏幕左上角为坐标原点，X轴向右为正，Y轴向下为正
    float centerOfPreviewCanvasX = m_previewCanvasSize.width / 2;
    float centerOfPreviewCanvasY = m_previewCanvasSize.height / 2;

    // 裁剪框或者预览区的中心点，屏幕左上角为坐标原点，X轴向右为正，Y轴向下为正
    auto centerOfDisplayAreaX = static_cast<float>(displayArea.left + (displayArea.Width() / 2));
    auto centerOfDisplayAreaY = static_cast<float>(displayArea.top + (displayArea.Height() / 2));

    // 裁剪框或者预览区的中心点相对于屏幕中心点的位移，位移Y轴：向上为正，向下为负(注意这里和上面的预览区或者canvas的坐标方向是反的，所以计算偏移的时候也要反过来)；
    // 位移X轴：向右为正，向左为负.
    float displayAreaOffsetX = centerOfDisplayAreaX - centerOfPreviewCanvasX;
    float displayAreaOffsetY = centerOfPreviewCanvasY - centerOfDisplayAreaY;

    // 剪辑中心点相对于裁剪框/预览区中心点的位移;
    // 剪辑中保存的位移是相对于屏幕/canvas的中心点的位移，要转换为相对于预览区/裁剪框的中心的位移.
    float previewOffsetXRelativeCanvas = previewTransform.offsetX - displayAreaOffsetX;
    float previewOffsetYRelativeCanvas = previewTransform.offsetY - displayAreaOffsetY;
    // 镜像操作，做了offsetX位移修正，减了2倍预览中心到预览画布中心的距离，自定义导出画布中心素材中心重合，故要还原上述修正
    if (previewTransform.mirrorHorizontal == 1) {
        previewOffsetXRelativeCanvas += (MIRROR_OFFSET_RATE * displayAreaOffsetX);
    }

    // 没有预览页面时将 offset 设置为固定值 0.0
    if (!checkPreviewSize(previewSize)) {
        exportTransform->offsetX = 0.0;
        exportTransform->offsetY = 0.0;
    } else {
        exportTransform->offsetX = (exportSize.width / previewSize.width) * previewOffsetXRelativeCanvas;
        exportTransform->offsetY = (exportSize.height / previewSize.height) * previewOffsetYRelativeCanvas;
    }
    return exportTransform;
}

HmcRenderEffectPtr HmcExportEngine::GetTransformEffect(std::shared_ptr<VideoRenderInfo> &renderInfo)
{
    if (renderInfo->layers.empty()) {
        LOGW("[Export] layers is empty.");
        return nullptr;
    }

    for (auto &effect : renderInfo->layers[0]->m_effectList) {
        if (effect->m_resource->m_effectName == DICT_KEY_TRANSFORM_NAME) {
            return effect;
        }
    }

    return nullptr;
}

HmcRectD HmcExportEngine::CalcDisplayArea(HmcRenderEffectPtr &transformEffect) const
{
    if (transformEffect == nullptr) {
        LOGE("transformEffect is null");
        return { 0, 0, m_previewCanvasSize.width, m_previewCanvasSize.height };
    }

    double leftBottomX = 0.0;
    double leftBottomY = 0.0;
    double rightTopX = 1.0;
    double rightTopY = 1.0;

    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_CROP_LB_X, leftBottomX);
    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_CROP_LB_Y, leftBottomY);
    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_CROP_RT_X, rightTopX);
    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_CROP_RT_Y, rightTopY);

    HmcRectD displayArea;
    displayArea.left = m_previewCanvasSize.width * leftBottomX;
    displayArea.right = m_previewCanvasSize.width * rightTopX;

    // 1-y是将坐标系原点从左下角转换到左上角：HmcAssetCropPosition的坐标原点在屏幕(canvas)左下角，而显示区域DisplayAreaRect的坐标原点在屏幕(canvas)左上角。
    displayArea.top = m_previewCanvasSize.height * (1 - rightTopY);
    displayArea.bottom = m_previewCanvasSize.height * (1 - leftBottomY);

    return displayArea;
}

HmcTransformInfo HmcExportEngine::CalcPreviewTransform(HmcRenderEffectPtr &transformEffect) const
{
    HmcTransformInfo transform;
    double scale = 1.0;
    double ratio = 1.0;
    if (transformEffect == nullptr) {
        LOGE("transformEffect is null");
        transform.scaleX = scale * ratio;
        transform.scaleY = scale * ratio;
        return transform;
    }
    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_SCALE_X, scale);
    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_RATIO_X, ratio);
    transform.scaleX = scale * ratio;

    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_SCALE_Y, scale);
    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_RATIO_Y, ratio);
    transform.scaleY = scale * ratio;

    double offset = 0.0;
    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_OFFSET_X, offset);
    transform.offsetX = offset;

    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_OFFSET_Y, offset);
    transform.offsetY = offset;
    
    int mirror = 0;
    transformEffect->GetParam(PROJECT_KEY_TRANSFORM_MIRROR_H, mirror);
    transform.mirrorHorizontal = mirror;

    return transform;
}

void HmcExportEngine::UpdateTransformEffect(HmcRenderEffectPtr &transform,
    const std::shared_ptr<HmcTransformInfo> &transformInfo)
{
    transform->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_X, transformInfo->offsetX);
    transform->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_Y, transformInfo->offsetY);
    transform->SetParam(PROJECT_KEY_TRANSFORM_SCALE_X, transformInfo->scaleX);
    transform->SetParam(PROJECT_KEY_TRANSFORM_SCALE_Y, transformInfo->scaleY);
    transform->SetParam(PROJECT_KEY_TRANSFORM_RATIO_X, 1.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_RATIO_Y, 1.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_LB_X, 0.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_LB_Y, 0.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_RT_X, 1.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_RT_Y, 1.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, 0.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, 0.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_SCALE_X, 1.0);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_SCALE_Y, 1.0);
    // IMPORTANT:
    // Do not clear cropRotate/cropEnable during export/save, otherwise 90deg rotate
    // (implemented via transform/crop geometry) will not appear in the final saved image.
    // Keep current effect params as-is.
    double cropRotation = 0.0;
    double cropEnable = 0.0;
    transform->GetParam(PROJECT_KEY_TRANSFORM_CROP_ROTATION, cropRotation);
    transform->GetParam(PROJECT_KEY_TRANSFORM_CROP_ENABLE, cropEnable);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_ROTATION, cropRotation);
    transform->SetParam(PROJECT_KEY_TRANSFORM_CROP_ENABLE, cropEnable);
}

void HmcExportEngine::CancelInner()
{
    LOGI("[Export] cancel export.");

    m_state = HmcExportEngineState::CANCELING;

    if (m_taskMgr != nullptr) {
        LOGI("[Export] Cancel: start wait export task.");
        m_taskMgr->Wait();
        LOGI("[Export] Cancel: wait export task finish.");
    }

    m_transformInfoForExport = nullptr;

    m_state = HmcExportEngineState::INIT;

    LOGI("[Export] cancel export finish");
}

void HmcExportEngine::ResetEnv()
{
    Cancel();
}

// 如果是浅层交互，没有拉起编辑预览页面，preview size的宽高为0
bool HmcExportEngine::checkPreviewSize(const HmcSize &previewSize) const
{
    if (previewSize.width == 0 || previewSize.height == 0) {
        return false;
    }
    return true;
}

std::shared_ptr<HmcTaskManager> HmcExportEngine::GetExportTask()
{
    return m_taskMgr;
}