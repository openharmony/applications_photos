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

#include "HmcPreviewEngine.h"
#include "render/graphic/HmcNativeWindow.h"
#include "render/core/HmcRenderEngine.h"
#include "render/platform/ohos/nativerender/render/plugin_render.h"

namespace Hmc::Service::Preview {
constexpr int OPEN_GL_CALIBRATION_RATIO = 4; // opengl 4字节校准.

HmcPreviewEngine::HmcPreviewEngine(HmcEventHandler *handler, std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine)
    : m_eventHandler(handler), m_graphicsRender(graphicsRenderEngine)
{
    LOGI("[preview] create preview engine.");

    ResetRenderCanvasBgInfo();

    m_renderResultCallback = [this](int code) {
        if (!this->m_graphicsFirstRenderSuccess.load()) {
            this->m_eventHandler->OnImportResultNotify(code);
            this->m_graphicsFirstRenderSuccess.store(true);
        }
    };

    LOGI("[preview] create preview engine finish.");
}

HmcPreviewEngine::~HmcPreviewEngine()
{
    LOGI("[preview] destroy HmcPreviewEngine.");
    if (m_previewWindow != nullptr) {
        auto nativeWindow = static_cast<HmcNativeWindow *>(m_previewWindow);
        PluginRender *instance = PluginRender::GetInstance(nativeWindow->id_);
        if (instance != nullptr) {
            instance->unRegSurfaceSizeWatcher();
        }
    }
}

int32_t HmcPreviewEngine::Startup()
{
    LOGI("[preview] startup preview engine.");

    if (m_previewWindow == nullptr) {
        LOGE("[preview] startup preview engine failed, preview window is invalid.");
        return HMC_ERR;
    }

    auto nativeWindow = static_cast<HmcNativeWindow *>(m_previewWindow);
    if (nativeWindow->window_ == nullptr) {
        LOGE("Startup nativeWindow->window_ is nullptr.");
    } else {
        LOGI("Startup nativeWindow->window_ not nullptr.");    
    }
    m_graphicsRender->InitEngine(nativeWindow->window_);

    PluginRender::GetInstance(nativeWindow->id_)->RegSurfaceSizeWatcher([this](float width, float height) {
        LOGI("[preview] surface size has changed from (w=%.2f, h=%.2f) to (w=%.2f, h=%.2f).", m_windowSize.width,
            m_windowSize.height, width, height);
        m_windowSize.width = width;
        m_windowSize.height = height;
    });

    LOGI("[preview] startup preview engine finish.");

    return HMC_OK;
}

void HmcPreviewEngine::Shutdown()
{
    LOGI("[preview] shutdown preview engine.");
}

void HmcPreviewEngine::SetPreviewWindow(void *window)
{
    LOGI("[preview] set preview window.");

    m_previewWindow = window;
    auto nativeWindow = (HmcNativeWindow *)m_previewWindow;
    if (nativeWindow->window_ == nullptr) {
        LOGE("SetPreviewWindow nativeWindow->window_ is nullptr");
    } else {
        LOGI("SetPreviewWindow nativeWindow->window_ not nullptr");
    }
    m_windowSize.width = nativeWindow->width_;
    m_windowSize.height = nativeWindow->height_;

    SetCanvasSize({
        .width = m_windowSize.width,
        .height = m_windowSize.height });
}

void HmcPreviewEngine::SetCanvasSize(const HmcSize &canvasSize)
{
    LOGI("[preview] set canvas from (w=%.2f, h=%.2f) to (w=%.2f, h=%.2f).", m_canvasSize.width, m_canvasSize.height,
        canvasSize.width, canvasSize.height);
    m_canvasSize.width = canvasSize.width;
    m_canvasSize.height = canvasSize.height;

    SyncRenderCanvas();
}

HmcSize HmcPreviewEngine::GetCanvasSize() const
{
    return m_canvasSize;
}

void HmcPreviewEngine::Play(uint64_t startTime, uint64_t endTime, uint32_t fps)
{
    LOGI("[preview] preview engine play from %d to %d, fps: %d.", startTime, endTime, fps);
}

void HmcPreviewEngine::Pause()
{
    LOGI("[preview] pause preview engine.");
}

void HmcPreviewEngine::Flush()
{
    LOGI("[preview] preview engine flush.");
}

void HmcPreviewEngine::Flush(uint64_t time, bool exactMode)
{
    LOGI("[preview] preview engine flush pts: %lld exactMode %d", time, exactMode);
}

void HmcPreviewEngine::FlushForce()
{
    LOGI("[preview] preview engine FlushForce.");
}

void HmcPreviewEngine::GetPreviewPeriodRange(uint64_t &startTime, uint64_t &endTime)
{
    startTime = 0;
    endTime = 0;
}

void HmcPreviewEngine::SetPreviewPeriodRange(uint64_t startTime, uint64_t endTime)
{
    LOGI("[preview] set preview period range(%d ~ %d).", startTime, endTime);
}

uint64_t HmcPreviewEngine::GetCurrentTime() const
{
    return 0;
}

void HmcPreviewEngine::ResetRenderCanvasBgInfo()
{
    LOGI("[preview] reset render canvas background info.");

    m_renderCanvas.bgTexture_.reset();

    m_renderCanvas.bgColor_.x = 0.0f;
    m_renderCanvas.bgColor_.y = 0.0f;
    m_renderCanvas.bgColor_.z = 0.0f;
    m_renderCanvas.bgColor_.w = 1.0f;
}

Json::Value HmcPreviewEngine::Serialize() const
{
    LOGI("[preview] serialize preview engine data.");
    Json::Value previewJson;
    previewJson[PROJECT_KEY_PREVIEW_CANVAS_WIDTH] = m_canvasSize.width;
    previewJson[PROJECT_KEY_PREVIEW_CANVAS_HEIGHT] = m_canvasSize.height;
    return previewJson;
}

bool HmcPreviewEngine::Deserialize(const Json::Value &previewJson)
{
    const char *previewData = previewJson.toStyledString().c_str();
    LOGI("[preview] deserialize preview engine, data: %s.", previewData != nullptr ? previewData : "");
    JsonValueUtil::ParseFloatIfHas(previewJson, PROJECT_KEY_PREVIEW_CANVAS_WIDTH, m_canvasSize.width);
    JsonValueUtil::ParseFloatIfHas(previewJson, PROJECT_KEY_PREVIEW_CANVAS_HEIGHT, m_canvasSize.height);
    return true;
}

void HmcPreviewEngine::SyncRenderCanvas()
{
    LOGI("[preview] sync render canvas.");

    std::lock_guard<std::mutex> guard(m_renderCanvasMutex);

    m_renderCanvas.width_ = lround(m_canvasSize.width / OPEN_GL_CALIBRATION_RATIO) * OPEN_GL_CALIBRATION_RATIO;
    m_renderCanvas.height_ = lround(m_canvasSize.height / OPEN_GL_CALIBRATION_RATIO) * OPEN_GL_CALIBRATION_RATIO;

    m_renderCanvas.canvasWidth_ = m_renderCanvas.width_;
    m_renderCanvas.canvasHeight_ = m_renderCanvas.height_;

    constexpr int lengthToCenterRatio = 2; // 长度或者宽度除以2，得到中心点.
    // 以下计算，是计算将渲染canvas放在屏幕中心后，左上角的点在屏幕上以屏幕左上角为坐标原点[x向右为正，y向下为正]的坐标.
    m_renderCanvas.x_ = lround((m_windowSize.width - static_cast<float>(m_renderCanvas.width_)) / lengthToCenterRatio);
    m_renderCanvas.y_ =
        lround((m_windowSize.height - static_cast<float>(m_renderCanvas.height_)) / lengthToCenterRatio);

    LOGI("[preview] set render canvas to (w=%d, h=%d, x=%d, y=%d).", m_renderCanvas.width_, m_renderCanvas.height_,
         m_renderCanvas.x_, m_renderCanvas.y_);
}

void HmcPreviewEngine::RenderGraphics(std::shared_ptr<VideoRenderInfo> &renderInfo)
{
    std::lock_guard<std::mutex> guard(m_renderCanvasMutex);

    if (renderInfo->canvas) {
        if (renderInfo->canvas->bgTexture_ != nullptr) {
            m_renderCanvas.bgTexture_ = renderInfo->canvas->bgTexture_;
        }
        m_renderCanvas.bgColor_.x = (renderInfo->canvas->bgColor_.x);
        m_renderCanvas.bgColor_.y = (renderInfo->canvas->bgColor_.y);
        m_renderCanvas.bgColor_.z = (renderInfo->canvas->bgColor_.z);
        m_renderCanvas.bgColor_.w = (renderInfo->canvas->bgColor_.w);
    }
    LOGI("RenderGraphics renderInfo->layers: %d", renderInfo->layers.empty());
    // 在这里执行个性风格调节时的预处理。需要判断是否是真的需要进行预处理。通过参数判断
        
    if (!renderInfo->layers.empty()) {
        m_graphicsRender->Draw(renderInfo->layers, m_renderCanvas, m_renderResultCallback, 0,
                               renderInfo->m_isChangingPicPtr);
    }
}

HmcSurfaceTexture *HmcPreviewEngine::CreateSurface()
{
    auto renderEngine = std::dynamic_pointer_cast<HmcRenderEngine>(m_graphicsRender);
    if (renderEngine == nullptr) {
        LOGE("[preview] create surface for render failed, can not convert m_graphicsRender to HmcRenderEngine.");
        return nullptr;
    }

    return renderEngine->CreateSurfaceTexture();
}
}