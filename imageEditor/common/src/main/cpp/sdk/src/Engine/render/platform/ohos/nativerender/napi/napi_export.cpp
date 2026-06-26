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

#include "napi_export.h"
#include "../common/plugin_common.h"
#include "../plugin_manager.h"

/*
 * function for module exports
 */
napi_value NapiNativeRender::Export(napi_env env, napi_value exports)
{
    LOGD("NapiNativeRender::Export");
    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("getContext", PluginManager::GetContext),
    };
    NAPI_CALL(env, napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc));

    bool ret = PluginManager::GetInstance()->Export(env, exports);
    if (!ret) {
        LOGE("NapiNativeRender::Export failed");
    }
    return exports;
}