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
#include "NapiCallback.h"
#include <js_native_api_types.h>
#include <uv.h>

#include "HmcService.h"

struct WorkData {
    NapiCallback *napiCallback;
    size_t argc;
    std::function<void(napi_env, napi_value *)> argvGet;
    std::function<void()> onEndCallback;
};

NapiCallback::NapiCallback(napi_env env, napi_value callbackRef)
{
    this->env = env;
    napi_create_reference(env, callbackRef, 1, &this->callbackRef);
}

NapiCallback::~NapiCallback()
{
    // 暂时注释以避免该napi函数在非js线程下运行导致的崩溃问题
}

void NapiCallback::Call(size_t argc, std::function<void(napi_env, napi_value *)> argvCallback,
    std::function<void()> onEndCallback)
{
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(env, &loop);

    uv_work_t *work = new (std::nothrow) uv_work_t;
    if (work == nullptr) {
        return;
    }
    WorkData *data = new (std::nothrow) WorkData();
    if (data == nullptr) {
        delete work;
        return;
    }
    data->argc = argc;
    data->argvGet = argvCallback;
    data->onEndCallback = onEndCallback;
    data->napiCallback = this;
    work->data = (void *)data;

    uv_queue_work(
        loop, work, [](uv_work_t *work) {},
        [](uv_work_t *work, int status) {
            if (!work) {
                return;
            }
            WorkData *data = (WorkData *)work->data;
            if (!data) {
                delete work;
                return;
            }
            napi_handle_scope scope = nullptr;
            napi_open_handle_scope(data->napiCallback->env, &scope);
            if (scope == nullptr) {
                LOGE("napi_open_handle_scope failed");
                delete data;
                delete work;
                return;
            }

            napi_value callback = nullptr;
            napi_get_reference_value(data->napiCallback->env, data->napiCallback->callbackRef, &callback);
            napi_value ret;
            napi_value *argv = new napi_value[data->argc];
            data->argvGet(data->napiCallback->env, argv);
            napi_call_function(data->napiCallback->env, nullptr, callback, data->argc, argv, &ret);

            napi_close_handle_scope(data->napiCallback->env, scope);
            if (data->onEndCallback != nullptr) {
                data->onEndCallback();
            }
            delete[] argv;
            delete data;
            delete work;
        });
}

void NapiCallback::Call(int64_t value)
{
    Call(1, [value](napi_env env, napi_value *argv) { napi_create_int64(env, value, argv); });
}

void NapiCallback::Call(bool value)
{
    Call(1, [value](napi_env env, napi_value *argv) { napi_get_boolean(env, value, argv); });
}

void NapiCallback::CallJs(Json::Value json)
{
    Json::FastWriter fastWriter;
    std::string value = fastWriter.write(json);

    Call(1, [value](napi_env env, napi_value *argv) {
        napi_create_string_utf8(env, value.c_str(), NAPI_AUTO_LENGTH, argv);
    });
}