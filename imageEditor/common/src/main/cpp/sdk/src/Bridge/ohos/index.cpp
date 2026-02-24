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
#include "interface/index.h"

#include "render/platform/ohos/nativerender/napi/napi_export.h"
#include "common/NapiCommon.h"
#include "Material/Utils/HmcMaterialRenderResUtil.h"
#include <future>
#include <sstream>
#include <thread>

napi_env g_napiEnv = nullptr;
std::thread::id g_mainThreadId;

napi_value Index::_init(napi_env env, napi_value exports)
{
    LOGI("imageEditor init start");
    if (env == nullptr) {
        LOGD("init fail, env is nullptr");
    }
    // 初始化NAPI全局共享变量'
    g_napiEnv = env;

    //  初始化日志
    HmcLogInit();

    // 注册各模块NAPI暴露的接口
    NapiNativeRender::Export(env, exports);

    std::ostringstream ss;
    ss << std::this_thread::get_id();
    LOGI("init completed, %s", ss.str().c_str());
    return exports;
}

void Index::AppCreate() {}

void Index::AppDestory() {}

void Index::AppShow() {}

void Index::AppHide() {}

void Index::EditorShow() {}

void Index::EditorHide() {}

void Index::RegNativeOpenMedia(
    std::function<void(std::string const & url, std::string const & mode, int64_t callId)> cb)
{}

void Index::SetMediaFd(int64_t callId, int64_t fd) {}
