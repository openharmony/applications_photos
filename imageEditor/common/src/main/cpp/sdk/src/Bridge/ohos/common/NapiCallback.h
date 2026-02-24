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
#ifndef OH_NAPICALLBACK_H
#define OH_NAPICALLBACK_H

#include "NapiCommon.h"
#include <js_native_api_types.h>
#include "json/json.h"

class NapiCallback {
public:
    NapiCallback(napi_env env, napi_value callbackRef);
    ~NapiCallback();

    void Call(size_t argc, std::function<void(napi_env, napi_value *)> argvCallback,
        std::function<void()> onEndCallback = nullptr);

    void Call(bool value);
    void Call(int64_t value);
    void CallJs(Json::Value json);

private:
    napi_env env = nullptr;
    napi_ref callbackRef = nullptr;
};

#endif // OH_NAPICALLBACK_H
