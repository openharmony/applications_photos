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

#ifndef PLUGIN_RENDER_H
#define PLUGIN_RENDER_H

#include <string>
#include <unordered_map>

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <napi/native_api.h>
#include <mutex>

#include "render/graphic/HmcNativeWindow.h"

using SurfaceSizeWatcher = std::function<void(float width, float height)>;

class PluginRender {
public:
    explicit PluginRender(std::string &id);
    ~PluginRender();
    static PluginRender *GetInstance(std::string &id);
    static OH_NativeXComponent_Callback *GetNXComponentCallback();
    void SetNativeXComponent(OH_NativeXComponent *component);

public:
    // NAPI interface
    napi_value Export(napi_env env, napi_value exports);

    // Callback, called by ACE XComponent
    void OnSurfaceCreated(OH_NativeXComponent *component, void *window);

    void OnSurfaceChanged(OH_NativeXComponent *component, void *window);

    void OnSurfaceDestroyed(OH_NativeXComponent *component, void *window);

    void DispatchTouchEvent(OH_NativeXComponent *component, void *window);

    void RegSurfaceSizeWatcher(const SurfaceSizeWatcher &watcher);

    void unRegSurfaceSizeWatcher();

public:
    static std::unordered_map<std::string, PluginRender *> instance_;
    static OH_NativeXComponent_Callback callback_;

    OH_NativeXComponent *component_{ nullptr };
    HmcNativeWindow *nativeWindow_{ nullptr };

    std::string id_;
    uint64_t width_{ 0 };
    uint64_t height_{ 0 };

    double x_{ 0.0 };
    double y_{ 0.0 };
    OH_NativeXComponent_TouchEvent touchEvent_{ 0 };

    std::vector<SurfaceSizeWatcher> m_surfaceSizeWatchers;
    std::mutex m_watchersMutex;
};

#endif // PLUGIN_RENDER_H
