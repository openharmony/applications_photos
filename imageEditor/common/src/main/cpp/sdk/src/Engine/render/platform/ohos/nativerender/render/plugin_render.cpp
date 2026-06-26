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

#include <stdint.h>

#include "plugin_render.h"
#include "../common/plugin_common.h"
#include "../plugin_manager.h"
#include "ohos/jscaller/DataAbilityHelper.h"

#ifdef __cplusplus
extern "C" {
#endif

std::unordered_map<std::string, PluginRender *> PluginRender::instance_;

OH_NativeXComponent_Callback PluginRender::callback_;

void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    LOGI("OnSurfaceCreatedCB Input");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceCreated(component, window);
    LOGI("OnSurfaceCreatedCB, component id: %s", id.c_str());
}

void OnSurfaceChangedCB(OH_NativeXComponent *component, void *window)
{
    LOGI("OnSurfaceChangedCB Input");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceChanged(component, window);
    LOGI("OnSurfaceChangedCB, component id: %s", id.c_str());
}

void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    LOGI("OnSurfaceDestroyedCB, Input");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceDestroyed(component, window);
    LOGI("OnSurfaceDestroyedCB, component id: %s", id.c_str());
}

void DispatchTouchEventCB(OH_NativeXComponent *component, void *window)
{
    LOGD("DispatchTouchEventCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->DispatchTouchEvent(component, window);
}

PluginRender::PluginRender(std::string &id) : id_(id), component_(nullptr)
{
    nativeWindow_ = new HmcNativeWindow(id);
    auto renderCallback = PluginRender::GetNXComponentCallback();
    renderCallback->OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback->OnSurfaceChanged = OnSurfaceChangedCB;
    renderCallback->OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    renderCallback->DispatchTouchEvent = DispatchTouchEventCB;
}

PluginRender::~PluginRender()
{
    LOGI("~PluginRender");
    if (nativeWindow_) {
        delete nativeWindow_;
        nativeWindow_ = nullptr;
        SaveNativeWindow(nullptr);
    }
}

PluginRender *PluginRender::GetInstance(std::string &id)
{
    LOGI("GetInstance %s, id length: %d, instance_ address:****%lx", id.c_str(), id.size(), FAKE_POINTER(&instance_));
    if (instance_.find(id) == instance_.end()) {
        PluginRender *instance = new (std::nothrow) PluginRender(id);
        if (instance == nullptr) {
            LOGE("Failed to create PluginRender instance");
            return nullptr;
        }
        LOGI("[preview] create PluginRender instance (w=%.2f, h=%.2f).", instance->width_, instance->height_);
        instance_[id] = instance;
        return instance;
    } else {
        LOGI("[preview] GetInstance (w=%.2f, h=%.2f).", instance_[id]->nativeWindow_->width_,
             instance_[id]->nativeWindow_->height_);
        return instance_[id];
    }
}

OH_NativeXComponent_Callback *PluginRender::GetNXComponentCallback()
{
    return &PluginRender::callback_;
}

void PluginRender::SetNativeXComponent(OH_NativeXComponent *component)
{
    component_ = component;
    OH_NativeXComponent_RegisterCallback(component_, &PluginRender::callback_);
}

void PluginRender::OnSurfaceCreated(OH_NativeXComponent *component, void *window)
{
    LOGI("PluginRender::OnSurfaceCreated");
    if (window == nullptr) {
        LOGE("PluginRender::OnSurfaceCreated: window is null");
    }
    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS && nativeWindow_ != nullptr) {
        HmcNativeWindow *nativeWindow = nativeWindow_;
        float width = static_cast<float>(width_);
        float height = static_cast<float>(height_);
        nativeWindow->SetWindowParams(window, width, height);
        SaveNativeWindow(nativeWindow);
    } else {
        if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
            LOGE("PluginRender::OnSurfaceCreated: ret fail");
        }
        if (nativeWindow_ == nullptr) {
            LOGE("PluginRender::OnSurfaceCreated: nativeWindow_ is nullptr");
        }
    }
}

void PluginRender::OnSurfaceChanged(OH_NativeXComponent *component, void *window)
{
    LOGI("PluginRender::OnSurfaceChanged");
    if (window == nullptr) {
        LOGE("PluginRender::OnSurfaceCreated: window is null");
    }
    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS && nativeWindow_ != nullptr) {
        HmcNativeWindow *nativeWindow = nativeWindow_;
        float width = static_cast<float>(width_);
        float height = static_cast<float>(height_);
        nativeWindow->SetWindowParams(window, width, height);

        for (const auto &watcher : m_surfaceSizeWatchers) {
            watcher(width, height);
        }
    } else {
        if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
            LOGE("PluginRender::OnSurfaceChanged: ret fail");
        }
        if (nativeWindow_ == nullptr) {
            LOGE("PluginRender::OnSurfaceChanged: nativeWindow_ is nullptr");
        }
    }
}

void PluginRender::OnSurfaceDestroyed(OH_NativeXComponent *component, void *window) {}

void PluginRender::DispatchTouchEvent(OH_NativeXComponent *component, void *window)
{
    int32_t ret = OH_NativeXComponent_GetTouchEvent(component, window, &touchEvent_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        LOGD("Touch Info : x = %f, y = %f screenx = %f, screeny = %f", touchEvent_.x, touchEvent_.y,
            touchEvent_.screenX, touchEvent_.screenY);
        for (decltype(touchEvent_.numPoints) i = 0; i < touchEvent_.numPoints; i++) {
            LOGE("Touch Info : dots[%d] id %d x = %f, y = %f", i, touchEvent_.touchPoints[i].id,
                touchEvent_.touchPoints[i].x, touchEvent_.touchPoints[i].y);
            LOGE("Touch Info : screenx = %f, screeny = %f", touchEvent_.touchPoints[i].screenX,
                touchEvent_.touchPoints[i].screenY);
            LOGE("vtimeStamp = %llu, isPressed = %d", touchEvent_.touchPoints[i].timeStamp,
                touchEvent_.touchPoints[i].isPressed);
        }
    } else {
        LOGE("Touch fail");
    }
}

void PluginRender::RegSurfaceSizeWatcher(const SurfaceSizeWatcher &watcher)
{
    std::lock_guard<std::mutex> guard(m_watchersMutex);
    m_surfaceSizeWatchers.push_back(watcher);
}

void PluginRender::unRegSurfaceSizeWatcher()
{
    std::lock_guard<std::mutex> guard(m_watchersMutex);
    m_surfaceSizeWatchers.clear();
}

#ifdef __cplusplus
}
#endif