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

#ifndef HMC_NATIVE_WINDOW
#define HMC_NATIVE_WINDOW

#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>

#include <string>

class HmcNativeWindow {
public:
    explicit HmcNativeWindow(std::string &id) : id_(id){};
    void SetWindowParams(void *window, float w, float h);

public:
    std::string id_;
    float width_{ 0 };
    float height_{ 0 };
    void *window_{ nullptr };
};

#endif // HMC_NATIVE_WINDOW
