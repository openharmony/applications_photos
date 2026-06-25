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
#include "DataAbilityHelper.h"

#include <condition_variable>
#include <js_native_api.h>
#include <mutex>
#include <native_buffer/buffer_common.h>
#include <native_buffer/native_buffer.h>
#include <thread>
#include <string>
#include <uv.h>

#include <native_color_space_manager/native_color_space_manager.h>
#include <multimedia/image_framework/image_pixel_map_napi.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <hitrace/trace.h>

#include "../common/NapiCommon.h"
#include "HmcService.h"
#include "../interface/JSArguments.hpp"
#include "MediaCreative/HmcError.h"
#include "../../../Bridge/ohos/util/PixelmapUtil.h"
#include "ohos/hve/ProjectConfig.h"

static std::condition_variable g_openUriCondition;
static bool g_openUri_ready = false;
static std::mutex g_openUriMutex;
static std::mutex g_openUri_syncMutex;
static int64_t g_openedFd = -1;
static std::map<std::string, int64_t> openedFds;

static std::condition_variable g_isDebugEnableCondition;
static bool g_debugEnable_ready = false;
static std::mutex g_isDebugEnableMutex;
static std::mutex g_debugEnable_syncMutex;
static bool g_debugEnable = false;
static napi_value g_ConvertPixelMap2RGBAValue;

const uint32_t PIXEL_FORMAT_RGBA8888 = 3;
const uint32_t PIXEL_FORMAT_BGRA8888 = 4;
const uint32_t PIXEL_BYTES_FOUR = 4;

const VECTOR<int> auxiliaryTypes = {2, 3, 4, 5, 6, 7, 8, 9, 10};

struct WorkData {
    const char *uri;
    const char *mode;
};

struct GetGainMapParam {
    int32_t width;
    int32_t height;
    uint32_t mainWidth;
    uint32_t mainHeight;
    bool isCopyData;
};

struct SwitchWorkData {
    std::string switchName;
};

struct CreateFdParams {
    const char *name = nullptr;
    const char *suffix = nullptr;
    STRING result = "";
    bool isReady = false;
    std::condition_variable condition;
    std::mutex mutex;
    
    CreateFdParams(const char *name, const char *suffix): name(name), suffix(suffix) {}
};

struct AddResourceParams {
    int type = 0;
    const char *path = nullptr;
    bool result = false;
    bool isReady = false;
    std::condition_variable condition;
    std::mutex mutex;
    
    AddResourceParams(int type, const char *path): type(type), path(path) {}
};

struct IsParamEnableParams {
    const char *key = nullptr;
    
    bool result = false;
    bool isReady = false;
    std::condition_variable condition;
    std::mutex mutex;
    
    explicit IsParamEnableParams(const char *key): key(key) {}
};

WatermarkPicInfo::~WatermarkPicInfo()
{
    LOGI("~WatermarkPicInfo enter");
    if (nativePixelmap != nullptr) {
        LOGI("WatermarkPicInfo Delete. id:%s", id.c_str());
        OH_PixelmapNative_Release(nativePixelmap);
    }
}

static napi_value OnOpened(napi_env env, napi_callback_info info)
{
    LOGD("OnOpened called");
    size_t argc = 1;
    napi_value argv[1] = { 0 };
    napi_value thisVar = nullptr;
    void *data = nullptr;
    napi_get_cb_info(env, info, &argc, argv, &thisVar, &data);

    napi_get_value_int64(env, argv[0], &g_openedFd);
    LOGD("openUriCondition OnOpened fd = %lld", g_openedFd);
    {
        std::unique_lock<std::mutex> lock{ g_openUriMutex };
        g_openUri_ready = true;
        g_openUriCondition.notify_one();
    }
    return wrap_void_to_js(env);
}

static napi_value onGetDebugEnable(napi_env env, napi_callback_info info)
{
    LOGI("onGetDebugEnable called");
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_value thisVar = nullptr;
    void *data = nullptr;
    napi_get_cb_info(env, info, &argc, argv, &thisVar, &data);

    napi_get_value_bool(env, argv[0], &g_debugEnable);
    LOGD("onGetDebugEnable  = %d", g_debugEnable);
    {
        std::unique_lock<std::mutex> lock{g_isDebugEnableMutex};
        g_debugEnable_ready = true;
        g_isDebugEnableCondition.notify_one();
    }
    return wrap_void_to_js(env);
}

static napi_value onGetDebugEnableInMainThread(napi_env env, napi_callback_info info)
{
    LOGI("onGetDebugEnableInMainThread called");
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_value thisVar = nullptr;
    void *data = nullptr;
    napi_get_cb_info(env, info, &argc, argv, &thisVar, &data);

    napi_get_value_bool(env, argv[0], &g_debugEnable);
    LOGD("onGetDebugEnableInMainThread  = %d", g_debugEnable);
    return wrap_void_to_js(env);
}

bool IsDataAbilityUri(const char *uri)
{
    if (uri == nullptr) {
        return false;
    }
    std::string str(uri);
    if (str.find("file://") == 0) {
        return true;
    }
    if (str.find("datashare:///") == 0) {
        return true;
    }
    if (str.find("fd://") == 0) {
        return true;
    }
    return false;
}

bool IsRawFilePath(const char *path)
{
    if (path == nullptr) {
        return false;
    }
    std::string str(path);
    if (str.find("rawfile") == 0) {
        return true;
    }
    return false;
}

static napi_status GetFunction(napi_env env, const std::string &instanceName, const std::string &functionName,
    napi_value &global, napi_value &function)
{
    napi_status status = napi_get_global(env, &global);
    if (status != napi_ok) {
        LOGE("napi_get_global failed, status=%d", status);
        return status;
    }

    napi_value globalThis;
    status = napi_get_named_property(env, global, "globalThis", &globalThis);
    if (status != napi_ok) {
        LOGE("napi_get_named_property globalThis failed, status=%d", status);
        return status;
    }

    napi_value instance;
    status = napi_get_named_property(env, globalThis, instanceName.c_str(), &instance);
    if (status != napi_ok) {
        LOGE("napi_get_named_property %s failed, status=%d", instanceName.c_str(), status);
        return status;
    }

    status = napi_get_named_property(env, instance, functionName.c_str(), &function);
    if (status != napi_ok) {
        LOGE("napi_get_named_property %s failed, status=%d", functionName.c_str(), status);
        return status;
    }

    return status;
}

static void openDataShareUri(napi_env env, const char *uri, const char *mode)
{
    napi_value global;
    napi_value mediaLibraryProxy;
    napi_status status = napi_get_global(env, &global);
    if (status != napi_ok) {
        LOGE("napi_get_global failed, status=%d", status);
    }
    napi_value globalThis;
    status = napi_get_named_property(env, global, "globalThis", &globalThis);
    if (status != napi_ok) {
        LOGE("napi_get_named_property globalThis failed, status=%d", status);
    }
    status = napi_get_named_property(env, globalThis, "image_editor_MediaLibraryProxy", &mediaLibraryProxy);
    if (status != napi_ok) {
        LOGD("napi_get_named_property mediaLibraryProxy failed, status=%d", status);
    }
    napi_value funcOpenUri;
    status = napi_get_named_property(env, mediaLibraryProxy, "openUri", &funcOpenUri);
    if (status != napi_ok) {
        LOGD("napi_get_named_property funcOpenUri failed, status=%d", status);
    }
    napi_value ret;
    size_t argc = 3;
    napi_value argv[argc];
    status = napi_create_string_utf8(env, uri, NAPI_AUTO_LENGTH, &argv[0]);
    status = napi_create_string_utf8(env, mode, NAPI_AUTO_LENGTH, &argv[1]);
    napi_create_function(env, "OnOpened", NAPI_AUTO_LENGTH, OnOpened, (void *)uri, &argv[2]);

    LOGD("napi_call_function begin");
    // 调用方法
    status = napi_call_function(env, global, funcOpenUri, argc, argv, &ret);
    LOGD("napi_call_function end");
    if (status != napi_ok) {
        LOGD("napi_call_function failed, status=%d", status);
    }
}

void ClearOpenedFds(const char *uri)
{
    std::unique_lock<std::mutex> syncLock{g_openUri_syncMutex };
    if (openedFds.find(uri) != openedFds.end()) {
        openedFds.erase(uri);
    }
}

void ClearAllOpenedFds()
{
    std::unique_lock<std::mutex> syncLock{g_openUri_syncMutex };
    for (const auto &fd : openedFds) {
        LOGI("ClearAllOpenedFds file id = %lld", fd.second);
        close(fd.second);
    }
    openedFds.clear();
}

int64_t DataAbilityHelperOpen(const char *uri, const char *mode)
{
    if (!IsDataAbilityUri(uri)) {
        return open(uri, O_RDONLY);
    }
    std::string str(uri);
    if (str.find("fd://") == 0) {
        long long fd = std::stoll(str.substr(5));
        LOGD("DataAbilityHelperOpen fd=%lld", fd);
        return fd;
    }

    std::unique_lock<std::mutex> syncLock{g_openUri_syncMutex };
    if (openedFds.find(uri) != openedFds.end()) {
        return openedFds[uri];
    }
    std::unique_lock<std::mutex> lock{ g_openUriMutex };
    napi_env env = g_napiEnv;

    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(env, &loop);
    uv_work_t *work = new (std::nothrow) uv_work_t;
    if (work == nullptr) {
        return 0;
    }
    WorkData *data = new (std::nothrow) WorkData();
    if (data == nullptr) {
        return 0;
    }
    data->uri = uri;
    data->mode = mode;
    work->data = (void *)data;
    g_openUri_ready = false;
    uv_queue_work(
        loop, work, [](uv_work_t *work) {
            LOGI("openDataShareUri work run");
        },
        [](uv_work_t *work, int status) {
            WorkData *data = (WorkData *)work->data;
            LOGD("openFile(%s, %s)", data->uri, data->mode);
            openDataShareUri(g_napiEnv, data->uri, data->mode);
            if (data != nullptr) {
                delete data;
            }
            if (work != nullptr) {
                delete work;
            }
        });

    g_openUriCondition.wait(lock, [&] { return g_openUri_ready; });

    if (g_openedFd != -1) {
        openedFds[uri] = g_openedFd;
    }
    LOGI("DataAbilityHelperOpen openedFd = %lld, uri = %s", g_openedFd, uri);
    return g_openedFd;
}

void DumpBuffer(uint8_t *data, size_t size, const std::string& filename)
{
    if (data == nullptr) {
        LOGE("Input data addr is null");
        return;
    }

    std::ofstream rawDataFile(filename.c_str(), std::ofstream::binary);
    if (!rawDataFile.good()) {
        LOGE("DumpBuffer open failed: (%s) %s", filename.c_str(), std::strerror(errno));
        rawDataFile.close();
        return;
    }
    rawDataFile.write(reinterpret_cast<const char *>(data), size);
    rawDataFile.close();
    LOGI("DumpBuffer file: %s", filename.c_str());
}

static void isDebugEnable(napi_env env, const STRING &key)
{
    LOGI("isDebugEnable enter");
    napi_value global;
    napi_value funcIsDebugEnable;
    napi_status status = GetFunction(env, "image_editor_MediaLibraryProxy", "isDebugEnable", global, funcIsDebugEnable);

    size_t argc = 2;
    napi_value argv[argc];
    status = napi_create_string_utf8(env, key.c_str(), NAPI_AUTO_LENGTH, &argv[0]);
    napi_create_function(env, "onGetDebugEnable", NAPI_AUTO_LENGTH, onGetDebugEnable, nullptr, &argv[1]);
    napi_value ret;
    status = napi_call_function(env, global, funcIsDebugEnable, argc, argv, &ret);
    if (status != napi_ok) {
        LOGE("napi_call_function failed, status=%d", status);
    }
}

static napi_value onConvertPixelMap2RGBACallbackInMainThread(napi_env env, napi_callback_info info)
{
    LOGI("onConvertPixelMap2RGBACallback called");
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_value thisVar = nullptr;
    void *data = nullptr;
    napi_get_cb_info(env, info, &argc, argv, &thisVar, &data);
    g_ConvertPixelMap2RGBAValue = argv[0];
    LOGD("onConvertPixelMap2RGBACallback end");
    return wrap_void_to_js(env);
}

static void ReleaseNapiPixelMap(napi_env env, napi_value *pixelmapNapi)
{
    LOGI("ReleaseNapiPixelMap enter");
    napi_value global;
    napi_value releaseNapiPixelMap;
    napi_status status = GetFunction(env, "image_editor_MediaLibraryProxy", "releaseNapiPixelMap",
        global, releaseNapiPixelMap);
    size_t argc = 1;
    napi_value argv[argc];
    argv[0] = *pixelmapNapi;
    napi_value ret;
    status = napi_call_function(env, global, releaseNapiPixelMap, argc, argv, &ret);
    if (status != napi_ok) {
        LOGE("ReleaseNapiPixelMap napi_call_function failed, status=%d", status);
    }
    LOGI("ReleaseNapiPixelMap end");
}

void SaveNativeWindow(HmcNativeWindow *adds) {
    LOGI("saveNativeWindow enter, nativeWindow address:****%lx", FAKE_POINTER(adds));
    napi_value global;
    napi_value saveNativeWindowFun;
    napi_status status = GetFunction(g_napiEnv, "image_editor_MediaLibraryProxy", 
        "saveNativeWindow", global, saveNativeWindowFun);
    if (status != napi_ok) {
        LOGE("saveNativeWindow GetFunction failed, status=%d", status);
        return;
    }
    size_t argc = 1;
    napi_value argv[argc];
    status = napi_create_int64(g_napiEnv, reinterpret_cast<std::uintptr_t>(adds), &argv[0]);
    if (status != napi_ok) {
        LOGE("saveNativeWindow napi_create_int64 failed, status=%d", status);
        return;
    }
    napi_value ret;
    status = napi_call_function(g_napiEnv, global, saveNativeWindowFun, argc, argv, &ret);
    if (status != napi_ok) {
        LOGE("saveNativeWindow napi_call_function failed, status=%d", status);
        return;
    }
    LOGI("saveNativeWindow end");
}

HmcNativeWindow *GetNativeWindow() {
    LOGI("getNativeWindow enter");
    napi_value global;
    napi_value getNativeWindowFunc;
    napi_status status = GetFunction(g_napiEnv, "image_editor_MediaLibraryProxy", 
        "getNativeWindow", global, getNativeWindowFunc);
    if (status != napi_ok) {
        LOGE("getNativeWindow GetFunction failed, status=%d", status);
        return nullptr;
    }
    size_t argc = 1;
    napi_value argv[argc];
    napi_value ret;
    status = napi_call_function(g_napiEnv, global, getNativeWindowFunc, argc, argv, &ret);
    if (status != napi_ok) {
        LOGE("getNativeWindow napi_call_function failed, status=%d", status);
        return nullptr;
    }
    int64_t nativeWindowAddress;
    status = napi_get_value_int64(g_napiEnv, ret, &nativeWindowAddress);
    if (status != napi_ok) {
        LOGE("getNativeWindow napi_get_value_int64 failed, status=%d", status);
        return nullptr;
    }
    LOGI("getNativeWindow end, nativeWindow address:****%lx",
         FAKE_POINTER(reinterpret_cast<HmcNativeWindow *>(nativeWindowAddress)));
    return reinterpret_cast<HmcNativeWindow *>(nativeWindowAddress);
}

/**
 * 在主线程中调用，转换PixelMap为RGBA格式
 *
 * @param env napi_env
 * @param pixelmapNapi napi_value PixelMap
 * @return 转换后的 napi_value PixelMap
 */
static void ConvertPixelMap2RGBAInMainThread(napi_env env, napi_value *pixelmapNapi)
{
    LOGI("ConvertPixelMap2RGBA enter");
    OH_HiTrace_StartTrace("ConvertPixelMap2RGBA");
    napi_value global;
    napi_value funcConvertPixelMap2RGBA;
    napi_status status = GetFunction(env, "image_editor_MediaLibraryProxy",
    "convertPixelMap2RGBA", global, funcConvertPixelMap2RGBA);
    size_t argc = 2;
    napi_value argv[argc];
    argv[0] = *pixelmapNapi;
    napi_create_function(env, "callback", NAPI_AUTO_LENGTH, onConvertPixelMap2RGBACallbackInMainThread,
        nullptr, &argv[1]);
    napi_value ret;
    status = napi_call_function(env, global, funcConvertPixelMap2RGBA, argc, argv, &ret);
    if (status != napi_ok) {
        LOGE("ConvertPixelMap2RGBA napi_call_function failed, status=%d", status);
    }
    // 获取返回结果
    LOGI("ConvertPixelMap2RGBA end");
    pixelmapNapi = &g_ConvertPixelMap2RGBAValue;
    OH_HiTrace_FinishTrace();
}

bool IsMainThread()
{
    std::thread::id thisThreadId = std::this_thread::get_id();
    std::ostringstream ss;
    ss << "thisThreadId = " << thisThreadId << " g_mainThreadId = " << g_mainThreadId;
    LOGI("[ImageEditor] %s", ss.str().c_str());
    if (g_mainThreadId == thisThreadId) {
        return true;
    }
    return false;
}

bool IsEditorSwitchEnableInMainThread(const std::string &key)
{
    napi_value global;
    napi_value funcIsDebugEnable;
    napi_status status = GetFunction(g_napiEnv, "image_editor_MediaLibraryProxy", "isDebugEnable",
        global, funcIsDebugEnable);

    size_t argc = 2;
    napi_value argv[argc];
    status = napi_create_string_utf8(g_napiEnv, key.c_str(), NAPI_AUTO_LENGTH, &argv[0]);
    napi_create_function(g_napiEnv, "onGetDebugEnableInMainThread", NAPI_AUTO_LENGTH, onGetDebugEnableInMainThread,
                         nullptr, &argv[1]);
    napi_value ret;
    status = napi_call_function(g_napiEnv, global, funcIsDebugEnable, argc, argv, &ret);
    if (status != napi_ok) {
        LOGE("napi_call_function failed, status=%d", status);
    }
    return g_debugEnable;
}

bool IsEditorSwitchEnable(const std::string &key)
{
    LOGI("IsEditorSwitchEnable enter key is %s", key.c_str());
    if (IsMainThread()) {
        return IsEditorSwitchEnableInMainThread(key);
    }
    std::unique_lock<std::mutex> syncLock{ g_debugEnable_syncMutex };
    napi_env env = g_napiEnv;
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(env, &loop);
    uv_work_t *work = new (std::nothrow) uv_work_t;
    if (work == nullptr) {
        return 0;
    }
    SwitchWorkData *data = new (std::nothrow) SwitchWorkData();
    if (data == nullptr) {
        return 0;
    }
    data->switchName = key;
    work->data = (void *)data;
    std::unique_lock<std::mutex> lock{ g_isDebugEnableMutex };
    g_debugEnable_ready = false;
    uv_queue_work(
        loop, work, [](uv_work_t *work) {
            LOGI("IsEditorSwitchEnable work run");
        },
        [](uv_work_t *work, int status) {
            SwitchWorkData *data = (SwitchWorkData *)work->data;
            isDebugEnable(g_napiEnv, data->switchName);
            if (data != nullptr) {
                delete data;
            }
            if (work != nullptr) {
                delete work;
            }
        });

    g_isDebugEnableCondition.wait(lock, [&] { return g_debugEnable_ready; });

    LOGI("g_debugEnable=%d", g_debugEnable);
    return g_debugEnable;
}

HmcPixelMapInfo *GenPixelMapNapi(void *data, int width, int height)
{
    napi_env env = g_napiEnv;
    LOGI("GenPixelMap start");
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(env, &loop);
    uv_work_t *work = new (std::nothrow) uv_work_t;
    HmcPixelMapInfo *imageInfo = new (std::nothrow) HmcPixelMapInfo();
    imageInfo->width = width;
    imageInfo->height = height;
    imageInfo->data = data;
    work->data = (void *)imageInfo;
    LOGD("GenPixelMap ready");

    uv_queue_work(
        loop, work, [](uv_work_t *work) {
            LOGI("GenPixelMap work run");
        },
        [](uv_work_t *work, int status) {
            if (work) {
                LOGI("GenPixelMap prepare");
                HmcPixelMapInfo *data = (HmcPixelMapInfo *)work->data;
                if (!data) {
                    delete work;
                    return;
                }
                LOGD("GenPixelMap work start");
                OhosPixelMapCreateOps info;
                info.width = data->width;
                info.height = data->height;
                info.pixelFormat = PIXEL_FORMAT_BGRA8888;
                info.alphaType = 0;
                napi_value res = nullptr;
                LOGD("GenPixelMap work width %d height %d", data->width, data->height);
                int ret = OH_PixelMap_CreatePixelMap(g_napiEnv, info, data->data, 4 * data->width * data->height, &res);
                LOGD("OH_PixelMap_CreatePixelMap ret = %d", ret);
                data->pixelmapNapi = res;
                NativePixelMap *out = OH_PixelMap_InitNativePixelMap(g_napiEnv, res);
                data->pixelmap = out;
                delete []data->data;

                std::unique_lock<std::mutex> lock(data->mutex);
                data->isReady = true;
                data->condition.notify_all();
                LOGI("GenPixelMap work end");
                delete work;
            }
        });
    std::unique_lock<std::mutex> lock(imageInfo->mutex);
    imageInfo->condition.wait(lock, [&] { return imageInfo->isReady; });
    LOGI("GenPixelMap sucess");
    return imageInfo;
}

HmcPixelMapInfo *ConvertPixelmapNativeToNapi(OH_PixelmapNative *pixelmap, int width, int height)
{
    napi_env env = g_napiEnv;
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(env, &loop);
    uv_work_t *work = new (std::nothrow) uv_work_t;
    HmcPixelMapInfo *imageInfo = new (std::nothrow) HmcPixelMapInfo();
    imageInfo->width = width;
    imageInfo->height = height;
    imageInfo->nativePixelmap = pixelmap;
    work->data = (void *)imageInfo;

    uv_queue_work(
        loop, work, [](uv_work_t *work) { LOGI("ConvertPixelmapNativeToNapi work run"); },
        [](uv_work_t *work, int status) {
            if (work) {
                LOGI("ConvertPixelmapNativeToNapi prepare");
                HmcPixelMapInfo *data = (HmcPixelMapInfo *)work->data;
                if (!data) {
                    delete work;
                    return;
                }
                OH_PixelmapNative_ConvertPixelmapNativeToNapi(g_napiEnv, data->nativePixelmap, &data->pixelmapNapi);
                std::unique_lock<std::mutex> lock(data->mutex);
                data->isReady = true;
                data->condition.notify_all();
                delete work;
                LOGI("ConvertPixelmapNativeToNapi Release native pixelmap");
                OH_PixelmapNative_Release(data->nativePixelmap);
            }
        });
    std::unique_lock<std::mutex> lock(imageInfo->mutex);
    imageInfo->condition.wait(lock, [&] { return imageInfo->isReady; });
    LOGI("ConvertPixelmapNativeToNapi sucess");
    return imageInfo;
}

struct ImageInfo {
    uint8_t *data = nullptr;
    uint32_t width = 0;
    uint32_t height = 0;
    uint32_t rowStride = 0;
    uint32_t len = 0;
};

static ImageInfo GetImageInfo(OhosPixelMapInfos &pixelMapInfo, void *addr)
{
    ImageInfo imageInfo = {
        .data = static_cast<uint8_t *>(addr),
        .width = pixelMapInfo.width,
        .height = pixelMapInfo.height,
        .rowStride = pixelMapInfo.rowSize,
        .len = imageInfo.height * imageInfo.rowStride,
    };

    return imageInfo;
}

static void CopyData(ImageInfo &src, ImageInfo &dst)
{
    uint8_t *srcBuffet = src.data;
    uint8_t *dstBuffer = dst.data;
    if (srcBuffet == dstBuffer) {
        LOGI("Buffer is same, not need copy.");
        return;
    }

    LOGD("CopyData: srcH=%d, srcStride=%d, "
        " dstH=%d, dstStride=%d",
        src.height, src.rowStride, dst.height, dst.rowStride);
    uint32_t srcRowStride = src.rowStride;
    uint32_t dstRowStride = dst.rowStride;
    uint32_t srcBufferLen = src.len;
    uint32_t dstBufferLen = dst.len;

    // direct copy the date while the size is same.
    if (srcRowStride == dstRowStride && srcBufferLen == dstBufferLen) {
        errno_t ret = memcpy_s(dstBuffer, dstBufferLen, srcBuffet, srcBufferLen);
        if (ret != 0) {
            LOGE("CopyData memcpy_s failed. ret=%d, dstBufLen=%d,"
                " srcBufLen=%d", ret, dstBufferLen, srcBufferLen);
        }
        return;
    }

    // copy by row
    uint32_t srcRowCount = src.height;
    uint32_t dstRowCount = dst.height;
    uint32_t rowCount = srcRowCount > dstRowCount ? dstRowCount : srcRowCount;
    uint32_t count = srcRowStride > dstRowStride ? dstRowStride : srcRowStride;
    if (rowCount * dstRowStride > dstBufferLen || rowCount * srcRowStride > srcBufferLen) {
        LOGE("Out of buffer available range! Copy fail! srcH=%d, srcStride=%d, "
            "srcLen=%d, dstH=%d, dstStride=%d, dstLen=%d",
            src.height, src.rowStride, srcBufferLen, dst.height, dst.rowStride, dstBufferLen);
        return;
    }
    for (uint32_t i = 0; i < rowCount; i++) {
        errno_t ret = memcpy_s(dstBuffer + i * dstRowStride, dstRowStride, srcBuffet + i * srcRowStride, count);
        if (ret != 0) {
            LOGE("CopyData: copy by row memcpy_s failed. ret=%d, row=%d, srcH=%d, "
                "srcStride=%d, srcLen=%d, dstH=%d, "
                "dstStride=%d, dstLen=%d", ret, i, src.height, src.rowStride, srcBufferLen,
                dst.height, dst.rowStride, dstRowStride);
            continue;
        }
    }
}

static void GetPixelMapImageInfo(ImageInfo &src, ImageInfo &dst, std::shared_ptr<uint8_t> &pixelMapBuffer)
{
    dst.width = src.width;
    dst.height = src.height;
    dst.rowStride = PIXEL_BYTES_FOUR * dst.width;
    dst.len = dst.height * dst.rowStride;
    if (dst.rowStride == src.rowStride) {
        dst.data = src.data;
        return;
    }

    size_t bufferSize = static_cast<size_t>(dst.len);
    auto *data = static_cast<uint8_t *>(malloc(bufferSize));
    std::shared_ptr<uint8_t> buffer(data, [](void *buffer) {
        if (buffer != nullptr) {
            LOGD("GetPixelMapImageInfo: free buffer.");
            free(buffer);
        }
    });
    pixelMapBuffer = buffer;
    dst.data = buffer.get();
    CopyData(src, dst);
}

OH_PixelmapNative *CreatePixelMapNative(NativePixelMap *inputPixelmap, uint32_t pixelFormat)
{
    OhosPixelMapInfos nativePixelMapInfo;
    int32_t res = OH_PixelMap_GetImageInfo(inputPixelmap, &nativePixelMapInfo);

    void *addr = nullptr;
    res = OH_PixelMap_AccessPixels(inputPixelmap, &addr);
    if (res != 0) {
        LOGE("OH_PixelMap_AccessPixels outputPixelMap fail!");
        return nullptr;
    }

    res = OH_PixelMap_UnAccessPixels(inputPixelmap);
    if (res != 0) {
        LOGE("OH_PixelMap_UnAccessPixels outputPixelMap fail!");
        return nullptr;
    }

    ImageInfo imageInfo = GetImageInfo(nativePixelMapInfo, addr);

    LOGD("CreatePixelMapNative: GetImageInfo w=%d, h=%d, rowStride=%d, "
        "len=%d", imageInfo.width, imageInfo.height, imageInfo.rowStride, imageInfo.len);

    std::shared_ptr<uint8_t> pixelmapNativeBuffer;
    ImageInfo pixelmapNativeImageInfo;
    GetPixelMapImageInfo(imageInfo, pixelmapNativeImageInfo, pixelmapNativeBuffer);
    return CreatePixelMapNativeWithInfo(pixelmapNativeImageInfo.data, pixelmapNativeImageInfo.width,
        pixelmapNativeImageInfo.height, PIXEL_FORMAT_RGBA8888, pixelFormat);
}

OH_PixelmapNative *CreatePixelMapNativeWithInfo(uint8_t *data, int width, int height, int format, int srcFormat)
{
    OH_Pixelmap_InitializationOptions *options = nullptr;
    Image_ErrorCode errorCode = OH_PixelmapInitializationOptions_Create(&options);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapInitializationOptions_Create fail! errorCode=%d", errorCode);
        return nullptr;
    }
    std::shared_ptr<OH_Pixelmap_InitializationOptions> optionsPtr(options,
        [](OH_Pixelmap_InitializationOptions *options) {
            LOGD("OH_PixelmapInitializationOptions_Release start.");
            OH_PixelmapInitializationOptions_Release(options);
        }
    );

    errorCode = OH_PixelmapInitializationOptions_SetWidth(optionsPtr.get(), width);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapInitializationOptions_SetWidth fail! errorCode=%d", errorCode);
        return nullptr;
    }
    errorCode = OH_PixelmapInitializationOptions_SetHeight(optionsPtr.get(), height);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapInitializationOptions_SetHeight fail! errorCode=%d", errorCode);
        return nullptr;
    }
    errorCode = OH_PixelmapInitializationOptions_SetPixelFormat(optionsPtr.get(), format);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapInitializationOptions_SetPixelFormat fail! errorCode=%d", errorCode);
        return nullptr;
    }

    errorCode = OH_PixelmapInitializationOptions_SetSrcPixelFormat(optionsPtr.get(), srcFormat);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapInitializationOptions_SetPixelFormat fail! errorCode=%d", errorCode);
        return nullptr;
    }

    OH_PixelmapNative *pixelmap = nullptr;
    errorCode = OH_PixelmapNative_CreatePixelmap(data, width * height * PIXEL_BYTES_FOUR, options, &pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapNative_CreatePixelmap fail! errorCode=%d", errorCode);
        return nullptr;
    }

    return pixelmap;
}

OH_PixelmapNative *CreatePixelMapWithAuxiliaryPicture(OH_AuxiliaryPictureNative *auxiliaryPicture)
{
    OH_AuxiliaryPictureInfo *info = nullptr;
    Image_ErrorCode errorCode = OH_AuxiliaryPictureNative_GetInfo(auxiliaryPicture, &info);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureNative_GetInfo fail! errorCode=%d", errorCode);
        return nullptr;
    }
    PIXEL_FORMAT pixelFormat;
    Image_Size imageSize;
    OH_AuxiliaryPictureInfo_GetSize(info, &imageSize);
    OH_AuxiliaryPictureInfo_GetPixelFormat(info, &pixelFormat);
    OH_AuxiliaryPictureInfo_Release(info);

    size_t dataLength = imageSize.width * imageSize.height * PIXEL_BYTES_FOUR;
    unsigned char *data = new unsigned char[dataLength];
    errorCode = OH_AuxiliaryPictureNative_ReadPixels(auxiliaryPicture, data, &dataLength);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureNative_ReadPixels fail! errorCode=%d", errorCode);
        delete[] data;
        return nullptr;
    }

    OH_PixelmapNative *pixelmap =
        CreatePixelMapNativeWithInfo(data, imageSize.width, imageSize.height, pixelFormat, pixelFormat);
    if (pixelmap == nullptr) {
        LOGE("CreatePixelMapNativeWithInfo fail!");
    }
    delete[] data;
    return pixelmap;
}

int GetSizeFromPixelmap(OH_PixelmapNative *pixelmap, uint32_t *width, uint32_t *height)
{
    OH_Pixelmap_ImageInfo *imageInfo = nullptr;
    OH_PixelmapImageInfo_Create(&imageInfo);
    Image_ErrorCode errorCode = OH_PixelmapNative_GetImageInfo(pixelmap, imageInfo);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapNative_GetImageInfo fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    OH_PixelmapImageInfo_GetWidth(imageInfo, width);
    OH_PixelmapImageInfo_GetHeight(imageInfo, height);
    OH_PixelmapImageInfo_Release(imageInfo);
    return HMC_OK;
}

unsigned char *GetDataFromNativePixelMapAndRelease(OH_PixelmapNative *pixelmap, int width, int height)
{
    unsigned char *data = new unsigned char[width * height * PIXEL_BYTES_FOUR];
    size_t bufferSize = width * height * PIXEL_BYTES_FOUR;
    Image_ErrorCode errorCode = OH_PixelmapNative_ReadPixels(pixelmap, data, &bufferSize);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapNative_ReadPixels fail! errorCode=%d", errorCode);
        delete [] data;
        return nullptr;
    }
    errorCode = OH_PixelmapNative_Release(pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapNative_Release fail! errorCode=%d", errorCode);
    }
    return data;
}

unsigned char *GetDataFromNativePixelMap(OH_PixelmapNative *pixelmap, int width, int height)
{
    PixelmapInfo pixelMapInfos = PixelmapUtil::GetPixelmapInfo(pixelmap);
    size_t bufferSize = pixelMapInfos.height * pixelMapInfos.rowStride;
    unsigned char *data = new (std::nothrow) unsigned char[bufferSize];
    if (data == nullptr) {
        LOGE("GetDataFromNativePixelMap bad_alloc");
        return nullptr;
    }
    Image_ErrorCode errorCode = OH_PixelmapNative_ReadPixels(pixelmap, data, &bufferSize);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapNative_ReadPixels fail! errorCode=%d", errorCode);
        delete [] data;
        return nullptr;
    }
    return data;
}

static bool CreatePixelMapNapiWithStride(HmcPixelMapInfo *data)
{
    if (!data) {
        return false;
    }
    OhosPixelMapCreateOps outputNativePixelMapInfo = {
        .width = static_cast<uint32_t>(data->width),
        .height = static_cast<uint32_t>(data->height),
        .pixelFormat = PIXEL_FORMAT_RGBA8888
    };
    size_t len = data->width * data->height * PIXEL_FORMAT_BGRA8888;
    int32_t rowStride = data->width  * PIXEL_FORMAT_BGRA8888;
    int32_t res = OH_PixelMap_CreatePixelMapWithStride(g_napiEnv, outputNativePixelMapInfo,
        data->data, len, rowStride, &data->pixelmapNapi);
    if (res != 0) {
        LOGE("Create DMA PixelMap OH_PixelMap_CreatePixelMapWithStride failed res = %d", res);
        delete [] data->data;
        data->data = nullptr;
        return false;
    }
    return true;
}

OH_PixelmapNative *CreateDmaPixelMapWithData(OhosPixelMapCreateOps &outputNativePixelMapInfo,
    const std::shared_ptr<uint8_t[]> &mainData, size_t len)
{
    OH_PixelmapNative *nativePixelmap = nullptr;
    OH_Pixelmap_InitializationOptions *pixelMapOptions = nullptr;
    Image_ErrorCode code = OH_PixelmapInitializationOptions_Create(&pixelMapOptions);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CreateDmaPixelMapWithData failed, because InitializationOptions error code = %d", code);
    std::shared_ptr<OH_Pixelmap_InitializationOptions> pixelMapOptionsPtr(pixelMapOptions,
        [](OH_Pixelmap_InitializationOptions *pixelMapOptions) {
            OH_PixelmapInitializationOptions_Release(pixelMapOptions);
    });
    code = OH_PixelmapInitializationOptions_SetWidth(pixelMapOptions, outputNativePixelMapInfo.width);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CreateDmaPixelMapWithData failed, because InitializationOptions SetWidth error code = %d", code);
    code = OH_PixelmapInitializationOptions_SetHeight(pixelMapOptions, outputNativePixelMapInfo.height);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CreateDmaPixelMapWithData failed, because InitializationOptions SetHeight error code = %d", code);
    code = OH_PixelmapInitializationOptions_SetPixelFormat(pixelMapOptions,
        outputNativePixelMapInfo.pixelFormat);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CreateDmaPixelMapWithData failed, because InitializationOptions SetPixelFormat error code = %d", code);
    code = OH_PixelmapInitializationOptions_SetSrcPixelFormat(pixelMapOptions,
        outputNativePixelMapInfo.pixelFormat);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CreateDmaPixelMapWithData failed, because InitializationOptions SetSrcPixelFormat error code = %d", code);
    code = OH_PixelmapNative_CreatePixelmapUsingAllocator(mainData.get(), len, pixelMapOptions,
        IMAGE_ALLOCATOR_MODE::IMAGE_ALLOCATOR_MODE_DMA, &nativePixelmap);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CreateDmaPixelMapWithData failed, because CreatePixelmapUsingAllocator error code = %d", code);
    return nativePixelmap;
}

void GetAuxiliaryPictureSize(OH_AuxiliaryPictureNative *picture, Image_Size *gainSize)
{
    OH_AuxiliaryPictureInfo *info = nullptr;
    Image_ErrorCode errCode = OH_AuxiliaryPictureInfo_Create(&info);
    if (errCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("GetAuxiliaryPictureSize PictureInfo_Create result: %d", errCode);
        return;
    }
    errCode = OH_AuxiliaryPictureNative_GetInfo(picture, &info);
    if (errCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("GetAuxiliaryPictureSize GetInfo result: %d", errCode);
        OH_AuxiliaryPictureInfo_Release(info);
        return;
    }
    Image_Size gainSizeParam = {.width = 0, .height = 0};
    errCode = OH_AuxiliaryPictureInfo_GetSize(info, &gainSizeParam);
    OH_AuxiliaryPictureInfo_Release(info);
    if (errCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("GetAuxiliaryPictureSize PictureInfo_GetSize errCode: %d", errCode);
        return;
    }
    gainSize->width = gainSizeParam.width;
    gainSize->height = gainSizeParam.height;
    LOGI("GetAuxiliaryPictureSize width: %d, height: %d", gainSize->width, gainSize->height);
}

Image_Size GetGainMapSize(OH_AuxiliaryPictureNative *gainMap, GetGainMapParam param)
{
    Image_Size gainSize = {.width = static_cast<uint32_t>(param.mainWidth) / 2,
                           .height = static_cast<uint32_t>(param.mainHeight) / 2};
    GetAuxiliaryPictureSize(gainMap, &gainSize);
    float radioW = static_cast<float>(gainSize.width) / param.mainWidth;
    float radioH = static_cast<float>(gainSize.height) / param.mainHeight;
    int32_t g_width = param.width * radioW;
    int32_t g_height = param.height * radioH;
    Image_Size size{.width = static_cast<uint32_t>(g_width), .height = static_cast<uint32_t>(g_height)};
    return size;
}

void TryToGetGainMap(OH_PictureNative *&srcPicture, OH_PictureNative *&outPicture, GetGainMapParam param)
{
    OH_AuxiliaryPictureNative *gainMap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetAuxiliaryPicture(srcPicture,
        Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, &gainMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || gainMap == nullptr) {
        LOGE("CopyPicture OH_PictureNative_GetAuxiliaryPicture fail! errorCode=%d", errorCode);
        return;
    }
    Image_Size size = GetGainMapSize(gainMap, param);
    size_t len = size.width * size.height * PIXEL_FORMAT_BGRA8888;
    LOGI("TryToGetGainMap width: %d, height: %d, len: %d", size.width, size.height, len);
    uint8_t *gainData = new uint8_t[len];
    if (param.isCopyData) {
        errorCode = OH_AuxiliaryPictureNative_ReadPixels(gainMap, gainData, &len);
    }
    OH_AuxiliaryPictureNative_Release(gainMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyPicture CreatePicture OH_AuxiliaryPictureNative_ReadPixels fail! errorCode=%d", errorCode);
        delete[] gainData;
        return;
    }
    // 创建接口bug：如果要创建RGBA的gainMap只能传入BGRA的数据
    ConvertRGBA2BGRA(gainData, size.width, size.height);
    OH_AuxiliaryPictureNative *dstGainMap = nullptr;
    errorCode = OH_AuxiliaryPictureNative_Create(gainData, len, &size,
        Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, &dstGainMap);
    delete[] gainData;
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyPicture CreatePicture OH_AuxiliaryPictureNative_Create fail! errorCode=%d", errorCode);
        OH_AuxiliaryPictureNative_Release(dstGainMap);
        return;
    }
    errorCode = OH_PictureNative_SetAuxiliaryPicture(outPicture,
        Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, dstGainMap);
    OH_AuxiliaryPictureNative_Release(dstGainMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyPicture CreatePicture OH_PictureNative_SetAuxiliaryPicture fail! errorCode=%d", errorCode);
        return;
    }
    
    OH_PixelmapNative *srcPixelmap = nullptr;
    OH_PictureNative_GetGainmapPixelmap(srcPicture, &srcPixelmap);
    OH_PixelmapNative *dstPixelmap = nullptr;
    OH_PictureNative_GetGainmapPixelmap(outPicture, &dstPixelmap);
    CopyColorSpace(srcPixelmap, dstPixelmap);
    CopyNativeBuffer(srcPixelmap, dstPixelmap);
    OH_PixelmapNative_Release(srcPixelmap);
    OH_PixelmapNative_Release(dstPixelmap);
}

void TryToGetExifMetadata(OH_PictureNative *srcPicture, OH_PictureNative *&outPicture)
{
    LOGI("TryToGetExifMetadata enter");
    OH_PictureMetadata *exifMetadata = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMetadata(srcPicture, Image_MetadataType::EXIF_METADATA,
        &exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyPicture GetMetadata fail! errorCode=%d", errorCode);
        return;
    }
    OH_PictureMetadata *outExifMetadata = nullptr;
    errorCode = OH_PictureMetadata_Clone(exifMetadata, &outExifMetadata);
    OH_PictureMetadata_Release(exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || outExifMetadata == nullptr) {
        LOGE("CopyPicture PictureMetadata_Clone fail! errorCode=%d", errorCode);
        return;
    }
    errorCode = OH_PictureNative_SetMetadata(outPicture, Image_MetadataType::EXIF_METADATA, outExifMetadata);
    OH_PictureMetadata_Release(outExifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyPicture SetMetadata fail! errorCode=%d", errorCode);
        return;
    }
}

bool CopyColorSpace(OH_PixelmapNative *src, OH_PixelmapNative *dst)
{
    if (src == nullptr || dst == nullptr) {
        LOGE("CopyColorSpace failed, because src is nullptr or dst is nullptr");
        return false;
    }
    OH_NativeColorSpaceManager *srcColorSpaceNative = nullptr;
    Image_ErrorCode errorCode = OH_PixelmapNative_GetColorSpaceNative(src, &srcColorSpaceNative);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || srcColorSpaceNative == nullptr) {
        LOGE("CopyColorSpace OH_PixelmapNative_GetColorSpaceNative fail! errorCode=%d", errorCode);
        return false;
    }
    errorCode = OH_PixelmapNative_SetColorSpaceNative(dst, srcColorSpaceNative);
    OH_NativeColorSpaceManager_Destroy(srcColorSpaceNative);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyColorSpace OH_PixelmapNative_SetColorSpaceNative fail! errorCode=%d", errorCode);
        return false;
    }
    LOGD("CopyColorSpace success.");
    return true;
}

void CopyNativeBuffer(OH_PixelmapNative *src, OH_PixelmapNative *dst)
{
    OH_NativeBuffer *srcNativeBuff = nullptr;
    Image_ErrorCode errorCode = OH_PixelmapNative_GetNativeBuffer(src, &srcNativeBuff);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyColorSpace OH_PixelmapNative_GetNativeBuffer src fail! code=%d", errorCode);
        return;
    }
    OH_NativeBuffer *dstNativeBuff = nullptr;
    errorCode = OH_PixelmapNative_GetNativeBuffer(dst, &dstNativeBuff);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        OH_NativeBuffer_Unreference(srcNativeBuff);
        LOGE("CopyColorSpace OH_PixelmapNative_GetNativeBuffer dst fail! code=%d", errorCode);
        return;
    }
    OH_NativeBuffer_ColorSpace colorSpace;
    int32_t code = OH_NativeBuffer_GetColorSpace(srcNativeBuff, &colorSpace);
    if (code != Image_ErrorCode::IMAGE_SUCCESS) {
        OH_NativeBuffer_Unreference(srcNativeBuff);
        OH_NativeBuffer_Unreference(dstNativeBuff);
        LOGE("CopyNativeBuffer OH_NativeBuffer_GetColorSpace fail! code=%d", code);
        return;
    }
    code = OH_NativeBuffer_SetColorSpace(dstNativeBuff, colorSpace);
    if (code != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyNativeBuffer OH_NativeBuffer_SetColorSpace fail! code=%d", code);
        OH_NativeBuffer_Unreference(srcNativeBuff);
        OH_NativeBuffer_Unreference(dstNativeBuff);
        return;
    }
    CopyHDR_Metadata(srcNativeBuff, dstNativeBuff);
    OH_NativeBuffer_Unreference(srcNativeBuff);
    OH_NativeBuffer_Unreference(dstNativeBuff);
    LOGI("CopyNativeBuffer finish");
}

void CopyHDR_Metadata(OH_NativeBuffer *srcNativeBuff, OH_NativeBuffer *dstNativeBuff)
{
    VECTOR<OH_NativeBuffer_MetadataKey> hdr_metadata_keys = {
        OH_NativeBuffer_MetadataKey::OH_HDR_METADATA_TYPE,
        OH_NativeBuffer_MetadataKey::OH_HDR_STATIC_METADATA,
        OH_NativeBuffer_MetadataKey::OH_HDR_DYNAMIC_METADATA,
    };
    for (auto key : hdr_metadata_keys) {
        int32_t size;
        uint8_t *metadata = nullptr;
        int32_t code = OH_NativeBuffer_GetMetadataValue(srcNativeBuff, key, &size, &metadata);
        if (code != Image_ErrorCode::IMAGE_SUCCESS) {
            free(metadata);
            LOGE("CopyHDRMetadata OH_NativeBuffer_GetMetadataValue %d fail! code=%d", key, code);
            continue;
        }
        code = OH_NativeBuffer_SetMetadataValue(dstNativeBuff, key, size, metadata);
        if (code != Image_ErrorCode::IMAGE_SUCCESS) {
            LOGE("CopyHDRMetadata OH_NativeBuffer_SetMetadataValue %d fail! code=%d", key, code);
        } else {
            LOGD("CopyHDRMetadata %d success", key);
        }
        free(metadata);
        metadata = nullptr;
    }
}

bool GetPixelMapInfos(OH_PixelmapNative *pixelMap, uint32_t &width, uint32_t &height,
    int32_t &pixelFormat, uint32_t &stride)
{
    OH_Pixelmap_ImageInfo *pixelMapInfo = nullptr;
    OH_PixelmapImageInfo_Create(&pixelMapInfo);
    OH_PixelmapNative_GetImageInfo(pixelMap, pixelMapInfo);
    OH_PixelmapImageInfo_GetWidth(pixelMapInfo, &width);
    OH_PixelmapImageInfo_GetHeight(pixelMapInfo, &height);
    OH_PixelmapImageInfo_GetRowStride(pixelMapInfo, &stride);
    OH_PixelmapImageInfo_GetPixelFormat(pixelMapInfo, &pixelFormat);
    OH_PixelmapImageInfo_Release(pixelMapInfo);
    return true;
}

OH_PictureNative *CopyPicture(OH_PictureNative *srcPicture, int32_t width, int32_t height, bool isCopyData,
    bool isNeedDmaMem)
{
    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(srcPicture, &mainPixelMap);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
         "CopyPicture GetMainPixelmap fail! errorCode=%d", errorCode);
    
    PixelmapInfo pxlInfo = PixelmapUtil::GetPixelmapInfo(mainPixelMap);
    OH_PixelmapNative *mainPixelMapCopy = nullptr;

    bool isCreateDma = isNeedDmaMem && width > DMA_REQUIRE_MIN_SIZE && height > DMA_REQUIRE_MIN_SIZE;
    size_t len = width * height * PIXEL_BYTES_FOUR;
    std::shared_ptr<uint8_t[]> mainData = std::make_shared<uint8_t[]>(len);
    CHECK_AND_RETURN_RET_LOG_WITH_FUNCTION(mainData != nullptr, nullptr, { OH_PixelmapNative_Release(mainPixelMap); },
        "CopyPicture new mainData failed");
    if (isCopyData) {
        OH_PixelmapNative_ReadPixels(mainPixelMap, mainData.get(), &len);
    }
    if (isCreateDma) {
        OhosPixelMapCreateOps pixelMapInfo = {.width = static_cast<UINT32>(width),
                                              .height = static_cast<UINT32>(height),
                                              .pixelFormat = pxlInfo.pixelFormat };
        mainPixelMapCopy = CreateDmaPixelMapWithData(pixelMapInfo, mainData, len);
    } else {
        mainPixelMapCopy = CreatePixelMapNativeWithInfo(mainData.get(), width, height, pxlInfo.pixelFormat,
            pxlInfo.pixelFormat);
    }
    mainData.reset(); // 及时释放内存，避免峰值内存过高
    CHECK_AND_RETURN_RET_LOG_WITH_FUNCTION(mainPixelMapCopy != nullptr, nullptr,
        { OH_PixelmapNative_Release(mainPixelMap); }, "CopyPicture CreatePixelMapNativeWithInfo fail!");

    CopyColorSpace(mainPixelMap, mainPixelMapCopy);
    CopyNativeBuffer(mainPixelMap, mainPixelMapCopy);
    OH_PixelmapNative_Release(mainPixelMap);

    OH_PictureNative *outPicture = nullptr;
    errorCode = OH_PictureNative_CreatePicture(mainPixelMapCopy, &outPicture);
    OH_PixelmapNative_Release(mainPixelMapCopy);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
         "CopyPicture CreatePicture fail! errorCode=%d", errorCode);

    GetGainMapParam param = {width, height, pxlInfo.width, pxlInfo.height, isCopyData};
    TryToGetGainMap(srcPicture, outPicture, param);
    PictureUtil::CopyAllMetadata(srcPicture, outPicture);
    PictureUtil::CloneAuxiliaryPicture(srcPicture, outPicture, auxiliaryTypes);
    LOGI("CopyPicture end.");
    return outPicture;
}

VOID CopyPictureNativeMetadata(OH_PictureNative *srcPicture, OH_PictureNative *destPicture)
{
    if (srcPicture == nullptr || destPicture == nullptr) {
        LOGE("CopyPictureNativeMetadata picture is nullptr");
        return;
    }
    OH_PictureMetadata *exifMetadata = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMetadata(srcPicture, Image_MetadataType::EXIF_METADATA,
        &exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || exifMetadata == nullptr) {
        LOGE("OH_PictureNative_GetMetadata exifMetadata fail! errorCode=%d", errorCode);
        return;
    }
    OH_PictureMetadata *outExifMetadata = nullptr;
    errorCode = OH_PictureMetadata_Clone(exifMetadata, &outExifMetadata);
    OH_PictureMetadata_Release(exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || outExifMetadata == nullptr) {
        LOGE("OH_PictureMetadata_Clone exifMetadata fail! errorCode=%d", errorCode);
        return;
    }
    errorCode = OH_PictureNative_SetMetadata(destPicture, Image_MetadataType::EXIF_METADATA, outExifMetadata);
    OH_PictureMetadata_Release(outExifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PictureNative_SetMetadata exifMetadata fail! errorCode=%d", errorCode);
    }
}

void SetAuxPictureNativeForFragment(OH_PictureNative *srcPicture, uint32_t positionX, uint32_t positionY,
                                    uint32_t width, uint32_t height)
{
    UINT8 *data = GetFragmentBuffFromPicture(srcPicture, positionX, positionY, width, height);
    if (data == nullptr) {
        LOGE("GetFragmentDataFromPicture fail! positionX:%d, positionY:%d, width:%d, height:%d", positionX, positionY,
             width, height);
        return;
    }

    // picture默认使用BGRA创建辅图, 生成rgba的pixelmap
    ConvertRGBA2BGRA(data, width, height);

    size_t dataLength = width * height * PIXEL_BYTES_FOUR;
    Image_Size size = {.width = width, .height = height};

    OH_AuxiliaryPictureNative *auxiliaryPicture;
    Image_ErrorCode errorCode = OH_AuxiliaryPictureNative_Create(
        data, dataLength, &size, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_FRAGMENT_MAP, &auxiliaryPicture);
    delete[] data;
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || auxiliaryPicture == nullptr) {
        LOGE("OH_AuxiliaryPictureNative_Create fail! errorCode=%d", errorCode);
        return;
    }

    if (SetInfoForFragmentPicture(auxiliaryPicture, width, height) == HMC_ERR) {
        LOGE("SetInfoForFragmentPicture fail! width=%d, height=%d", width, height);
        OH_AuxiliaryPictureNative_Release(auxiliaryPicture);
        return;
    }
    if (SetMetadataForFragmentPicture(auxiliaryPicture, positionX, positionY, width, height) == HMC_ERR) {
        LOGE("SetMetadataForFragmentPicture fail! width=%d, height=%d", width, height);
        OH_AuxiliaryPictureNative_Release(auxiliaryPicture);
        return;
    }
    errorCode = OH_PictureNative_SetAuxiliaryPicture(
        srcPicture, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_FRAGMENT_MAP, auxiliaryPicture);
    OH_AuxiliaryPictureNative_Release(auxiliaryPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PictureNative_SetAuxiliaryPicture FRAGMENT_MAP fail! errorCode=%d", errorCode);
        return;
    }
    LOGI("SetAuxPictureNativeForFragment success. positionX:%d, positionY:%d, width:%d, height:%d", positionX,
         positionY, width, height);
    return;
}

int SetMetadataForFragmentPicture(OH_AuxiliaryPictureNative *auxiliaryPicture, uint32_t positionX, uint32_t positionY,
                                  uint32_t width, uint32_t height)
{
    OH_PictureMetadata *metadata;
    Image_ErrorCode errorCode = OH_PictureMetadata_Create(FRAGMENT_METADATA, &metadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PictureMetadata_Create fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    SetPictureMetadataProperty(metadata, OHOS_IMAGE_PROPERTY_X_IN_ORIGINAL, std::to_string(positionX));
    SetPictureMetadataProperty(metadata, OHOS_IMAGE_PROPERTY_Y_IN_ORIGINAL, std::to_string(positionY));
    SetPictureMetadataProperty(metadata, OHOS_IMAGE_PROPERTY_FRAGMENT_WIDTH, std::to_string(width));
    SetPictureMetadataProperty(metadata, OHOS_IMAGE_PROPERTY_FRAGMENT_HEIGHT, std::to_string(height));
    errorCode = OH_AuxiliaryPictureNative_SetMetadata(auxiliaryPicture, FRAGMENT_METADATA, metadata);
    OH_PictureMetadata_Release(metadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureNative_SetInfo FRAGMENT_MAP fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    LOGI("SetMetadataForFragmentPicture success.");
    return HMC_OK;
}

int SetInfoForFragmentPicture(OH_AuxiliaryPictureNative *auxiliaryPicture, uint32_t width, uint32_t height)
{
    OH_AuxiliaryPictureInfo *auxInfo;
    Image_ErrorCode errorCode = OH_AuxiliaryPictureInfo_Create(&auxInfo);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || auxInfo == nullptr) {
        LOGE("OH_AuxiliaryPictureInfo_Create FRAGMENT_MAP fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    errorCode = OH_AuxiliaryPictureInfo_SetRowStride(auxInfo, width * PIXEL_BYTES_FOUR);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureInfo_SetRowStride FRAGMENT_MAP fail! errorCode=%d", errorCode);
        OH_AuxiliaryPictureInfo_Release(auxInfo);
        return HMC_ERR;
    }
    errorCode =
        OH_AuxiliaryPictureInfo_SetType(auxInfo, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_FRAGMENT_MAP);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureInfo_SetType FRAGMENT_MAP fail! errorCode=%d", errorCode);
        OH_AuxiliaryPictureInfo_Release(auxInfo);
        return HMC_ERR;
    }
    Image_Size size = {.width = width, .height = height};
    errorCode = OH_AuxiliaryPictureInfo_SetSize(auxInfo, &size);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureInfo_SetSize FRAGMENT_MAP fail! errorCode=%d", errorCode);
        OH_AuxiliaryPictureInfo_Release(auxInfo);
        return HMC_ERR;
    }
    errorCode = OH_AuxiliaryPictureInfo_SetPixelFormat(auxInfo, PIXEL_FORMAT_RGBA_8888);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureInfo_SetSize FRAGMENT_MAP fail! errorCode=%d", errorCode);
        OH_AuxiliaryPictureInfo_Release(auxInfo);
        return HMC_ERR;
    }
    errorCode = OH_AuxiliaryPictureNative_SetInfo(auxiliaryPicture, auxInfo);
    OH_AuxiliaryPictureInfo_Release(auxInfo);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_AuxiliaryPictureNative_SetInfo FRAGMENT_MAP fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    LOGI("SetInfoForFragmentPicture success.");
    return HMC_OK;
}

INT32 SetPictureMetadataProperty(OH_PictureMetadata *metadata, STRING key, STRING value)
{
    Image_String imageKey = {const_cast<char *>(key.c_str()), size_t(key.size())};
    Image_String imageValue = {const_cast<char *>(value.c_str()), size_t(value.size())};
    Image_ErrorCode errorCode = OH_PictureMetadata_SetProperty(metadata, &imageKey, &imageValue);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PictureMetadata_SetProperty FRAGMENT_MAP fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    return HMC_OK;
}

VOID GetPictureMetadataProperty(OH_PictureMetadata *metadata, STRING key, uint32_t *value)
{
    Image_String imageKey = {const_cast<char *>(key.c_str()), size_t(key.size())};
    Image_String imageValue = {};
    Image_ErrorCode errorCode = OH_PictureMetadata_GetProperty(metadata, &imageKey, &imageValue);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PictureMetadata_SetProperty FRAGMENT_MAP fail! errorCode=%d", errorCode);
        return;
    }
    *value = std::atoi(imageValue.data);
}

unsigned char *GetFragmentBuffFromPicture(OH_PictureNative *srcPicture, uint32_t positionX, uint32_t positionY,
                                          uint32_t width, uint32_t height)
{
    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(srcPicture, &mainPixelMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("CopyPicture GetMainPixelmap fail! errorCode=%d", errorCode);
        return nullptr;
    }

    OH_Pixelmap_ImageInfo *pixelMapInfo = nullptr;
    int32_t pixelFormat;
    uint32_t mainWidth;
    uint32_t mainHeight;
    OH_PixelmapImageInfo_Create(&pixelMapInfo);
    OH_PixelmapNative_GetImageInfo(mainPixelMap, pixelMapInfo);
    OH_PixelmapImageInfo_GetPixelFormat(pixelMapInfo, &pixelFormat);
    OH_PixelmapImageInfo_GetWidth(pixelMapInfo, &mainWidth);
    OH_PixelmapImageInfo_GetHeight(pixelMapInfo, &mainHeight);
    OH_PixelmapImageInfo_Release(pixelMapInfo);

    // 画框水印不用裁剪
    if (positionY == mainHeight) {
        LOGI("return empty buff for FrameSticker.");
        OH_PixelmapNative_Release(mainPixelMap);
        return new unsigned char[width * height * PIXEL_BYTES_FOUR];
    }

    UINT8 *mainData = GetDataFromNativePixelMap(mainPixelMap, mainWidth, mainHeight);
    OH_PixelmapNative_Release(mainPixelMap);
    if (mainData == nullptr) {
        LOGE("GetDataFromNativePixelMap failed.  mainWidth=%d, mainHeight=%d", mainWidth, mainHeight);
        return nullptr;
    }
    auto mainPixelMapCopy = CreatePixelMapNativeWithInfo(mainData, mainWidth, mainHeight, pixelFormat, pixelFormat);
    delete[] mainData;
    if (mainPixelMapCopy == nullptr) {
        LOGE("GetDataFromNativePixelMap failed.  mainWidth=%d, mainHeight=%d", mainWidth, mainHeight);
        return nullptr;
    }

    // 裁剪fragment
    Image_Region image_Region = {.x = positionX, .y = positionY, .width = width, .height = height};
    Image_ErrorCode image_ErrorCode = OH_PixelmapNative_Crop(mainPixelMapCopy, &image_Region);
    if (image_ErrorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PixelmapNative_Crop failed.");
        OH_PixelmapNative_Release(mainPixelMapCopy);
        return nullptr;
    }
    LOGI("image_Region x=%d,y=%d,width=%d,height=%d", positionX, positionY, width, height);

    UINT8 *data = GetDataFromNativePixelMap(mainPixelMapCopy, width, height);
    OH_PixelmapNative_Release(mainPixelMapCopy);
    LOGI("GetFragmentDataFromPicture success.");
    return data;
}

void ConvertRGBA2BGRA(UINT8 *data, UINT32 width, UINT32 height, uint32_t rowStride)
{
    rowStride = rowStride == 0 ? width * PIXEL_BYTES_FOUR : rowStride;
    const int32_t R = 0;
    const int32_t B = 2;

    LOGI("Convert color format begin: Swap R and B, width = %d, height = %d", width, height);
    for (uint32_t y = 0; y < height; ++y) {
        for (uint32_t x = 0; x < width; ++x) {
            uint32_t index = rowStride * y + x * PIXEL_BYTES_FOUR;
            uint8_t r = data[index + R];
            uint8_t b = data[index + B];
            data[index + R] = b;
            data[index + B] = r;
        }
    }
    LOGI("Convert color format end: Swap R and B ");
}

OH_PixelmapNative *CreateDmaPixelMapWithDataInMainThread(OhosPixelMapCreateOps &outputNativePixelMapInfo,
    const std::shared_ptr<uint8_t[]> &mainData, size_t len)
{
    napi_env env = g_napiEnv;
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(env, &loop);
    uv_work_t *work = new (std::nothrow) uv_work_t;
    HmcPixelMapInfo *imageInfo = new (std::nothrow) HmcPixelMapInfo();
    if (work == nullptr || imageInfo == nullptr) {
        LOGE("CreateDmaPixelMapWithDataInMainThread fail!");
        delete work;
        delete imageInfo;
        return nullptr;
    }
    imageInfo->width = outputNativePixelMapInfo.width;
    imageInfo->height = outputNativePixelMapInfo.height;
    imageInfo->data = mainData.get();
    imageInfo->len = len;
    imageInfo->pixelFormat = outputNativePixelMapInfo.pixelFormat;
    work->data = (void *)imageInfo;
    uv_queue_work(loop, work, [](uv_work_t *work) { LOGI("CreateDmaPixelMapWithDataInMainThread work run"); },
        [](uv_work_t *work, int status) {
            if (!work) { return; }
            LOGI("CreateDmaPixelMapWithDataInMainThread prepare");
            HmcPixelMapInfo *data = (HmcPixelMapInfo *)work->data;
            OhosPixelMapCreateOps pixelMapInfo = {.width = static_cast<uint32_t>(data->width),
                .height = static_cast<uint32_t>(data->height), .pixelFormat = data->pixelFormat
            };
            int32_t res = OH_PixelMap_CreatePixelMapWithStride(g_napiEnv, pixelMapInfo,
                data->data, data->len, 0, &data->pixelmapNapi);
            if (res != 0) {
                LOGE("CreateDmaPixelMapWithDataInMainThread CreatePixelMapWithStride failed res = %d", res);
                delete work;
                delete data;
                return;
            }
            OH_PixelmapNative_ConvertPixelmapNativeFromNapi(g_napiEnv, data->pixelmapNapi, &data->nativePixelmap);
            ReleaseNapiPixelMap(g_napiEnv, &data->pixelmapNapi);

            std::unique_lock<std::mutex> lock(data->mutex);
            data->isReady = true;
            data->condition.notify_all();
            delete work;
        });
    { std::unique_lock<std::mutex> lock(imageInfo->mutex);
        imageInfo->condition.wait(lock, [&] { return imageInfo->isReady; }); }

    LOGI("CreateDmaPixelMapWithDataInMainThread success.");
    OH_PixelmapNative *resPixelMap = imageInfo->nativePixelmap;
    delete imageInfo;
    return resPixelMap;
}

UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter> CloneDmaPixelMapNative(OH_PixelmapNative *sourcePixelMap)
{
    PixelmapInfo pxlInfo = PixelmapUtil::GetPixelmapInfo(sourcePixelMap);
    LOGI("CloneDmaPicture mainWidth = %d, mainHeight = %d, mainStride = %d", pxlInfo.width, pxlInfo.height,
         pxlInfo.rowStride);

    size_t len = pxlInfo.height * pxlInfo.rowStride;
    std::shared_ptr<uint8_t[]> mainData = std::make_unique<uint8_t[]>(len);
    CHECK_AND_RETURN_RET_LOG(mainData != nullptr, nullptr, "CloneDmaPicture failed, because mainData is nullptr");

    Image_ErrorCode code = OH_PixelmapNative_ReadPixels(sourcePixelMap, mainData.get(), &len);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
                             "CloneDmaPicture failed, because read pixel error code = %d", code);
    OhosPixelMapCreateOps pixelMapInfo = {.width = pxlInfo.width, .height = pxlInfo.height,
                                          .pixelFormat = pxlInfo.pixelFormat };
    OH_PixelmapNative *nativePixelmap = CreateDmaPixelMapWithData(pixelMapInfo, mainData, len);
    CHECK_AND_RETURN_RET_LOG(nativePixelmap != nullptr, nullptr,
                             "CloneDmaPicture failed, because create dma pixel error");
    return UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter>(nativePixelmap);
}

OH_PictureNative *CloneDmaPictureTmp(OH_PictureNative *srcPicture)
{
    if (srcPicture == nullptr) {
        return nullptr;
    }
    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode code = OH_PictureNative_GetMainPixelmap(srcPicture, &mainPixelMap);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CloneDmaPicture failed, because pixelMap is nullptr code = %d", code);
 
    std::shared_ptr<OH_PixelmapNative> mainPixelMapPtr(mainPixelMap, [](OH_PixelmapNative *mainPixelMap) {
        OH_PixelmapNative_Release(mainPixelMap);
    });
    
    PixelmapInfo pxlInfo = PixelmapUtil::GetPixelmapInfo(mainPixelMapPtr.get());
    LOGI("CloneDmaPicture mainWidth = %d, mainHeight = %d, mainStride = %d", pxlInfo.width, pxlInfo.height,
        pxlInfo.rowStride);
    
    size_t len = pxlInfo.height * pxlInfo.rowStride;
    std::shared_ptr<uint8_t[]> mainData = std::make_unique<uint8_t[]>(len);
    CHECK_AND_RETURN_RET_LOG(mainData != nullptr, nullptr, "CloneDmaPicture failed, because mainData is nullptr");
    
    code = OH_PixelmapNative_ReadPixels(mainPixelMapPtr.get(), mainData.get(), &len);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CloneDmaPicture failed, because read pixel error code = %d", code);
    OhosPixelMapCreateOps pixelMapInfo = {.width = pxlInfo.width, .height = pxlInfo.height,
        .pixelFormat = pxlInfo.pixelFormat };
    OH_PixelmapNative *nativePixelmap = CreateDmaPixelMapWithData(pixelMapInfo, mainData, len);
    CHECK_AND_RETURN_RET_LOG(nativePixelmap != nullptr, nullptr,
        "CloneDmaPicture failed, because create dma pixel error");
    
    CopyColorSpace(mainPixelMapPtr.get(), nativePixelmap);
    CopyNativeBuffer(mainPixelMapPtr.get(), nativePixelmap);
 
    OH_PictureNative *outPicture = nullptr;
    code = OH_PictureNative_CreatePicture(nativePixelmap, &outPicture);
 
    GetGainMapParam param = {static_cast<int32_t>(pxlInfo.width), static_cast<int32_t>(pxlInfo.height), pxlInfo.width,
                             pxlInfo.height, true};
 
    TryToGetGainMap(srcPicture, outPicture, param);
    PictureUtil::CopyAllMetadata(srcPicture, outPicture);
    PictureUtil::CopyAuxiliaryPicture(srcPicture, outPicture, AUXILIARY_PICTURE_TYPE_LINEAR_MAP);
    PictureUtil::CopyAuxiliaryPicture(srcPicture, outPicture, AUXILIARY_PICTURE_TYPE_UNREFOCUS_MAP);
    OH_PixelmapNative_Release(nativePixelmap);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CloneDmaPicture failed, because create picture error code = %d", code);
    
    return outPicture;
}

OH_PictureNative *CloneDmaPicture(OH_PictureNative *srcPicture)
{
    if (srcPicture == nullptr) {
        return nullptr;
    }
    
    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode code = OH_PictureNative_GetMainPixelmap(srcPicture, &mainPixelMap);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "CloneDmaPicture failed, because pixelMap is nullptr code = %d", code);
    OH_NativeBuffer* destNativeBuffer = nullptr;
    code = OH_PixelmapNative_GetNativeBuffer(mainPixelMap, &destNativeBuffer);
    OH_PixelmapNative_Release(mainPixelMap);
    bool isDma = destNativeBuffer == nullptr ? false : true;
    LOGI("CloneDmaPicture src is DMA = %d", isDma);
    if (destNativeBuffer) {
        OH_NativeBuffer_Unreference(destNativeBuffer);
        destNativeBuffer = nullptr;
    }

    if (!isDma) {
        return CloneDmaPictureTmp(srcPicture);
    }
    
    UINT32 srcAuxilarySize = 0;
    SHARED_PTR<Image_AuxiliaryPictureType[]> srcAuxiliaryTypes;
    UINT32 srcMetaDataSize = 0;
    SHARED_PTR<Image_MetadataType[]> srcMetaDataTypes;

    bool res = PictureUtil::GetPictureContainAuxiliaries(srcPicture, srcAuxilarySize, srcAuxiliaryTypes);
    CHECK_AND_RETURN_RET_LOG(res == true, nullptr, "CloneDmaPicture src GetPictureContainAuxiliaries failed");

    res = PictureUtil::GetPictureContainMetadatas(srcPicture, srcMetaDataSize, srcMetaDataTypes);
    CHECK_AND_RETURN_RET_LOG(res == true, nullptr, "CloneDmaPicture src GetPictureContainMetadatas failed");

    OH_PictureNative *outPicture = nullptr;
    Image_AuxiliaryPictureType *mainPixelMapKey= nullptr;
    CHECK_AND_RETURN_RET_LOG(res == true, nullptr, "CloneDmaPicture DeepCopyPicture failed");
    return outPicture;
}

int GetColorSpace(OH_PictureNative *srcPicture)
{
    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode code = OH_PictureNative_GetMainPixelmap(srcPicture, &mainPixelMap);
    CHECK_AND_RETURN_RET_LOG(code == Image_ErrorCode::IMAGE_SUCCESS, -1,
        "GetColorSpace failed, because pixelMap is nullptr code = %d", code);
    
    std::shared_ptr<OH_PixelmapNative> mainPixelMapPtr(mainPixelMap, [](OH_PixelmapNative *mainPixelMap) {
        OH_PixelmapNative_Release(mainPixelMap);
    });
    
    OH_NativeColorSpaceManager *srcColorSpaceNative = nullptr;
    Image_ErrorCode errorCode = OH_PixelmapNative_GetColorSpaceNative(mainPixelMapPtr.get(), &srcColorSpaceNative);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || srcColorSpaceNative == nullptr) {
        LOGE("GetColorSpace OH_PixelmapNative_GetColorSpaceNative fail! errorCode=%d", errorCode);
        return 0;
    }
    // 获取colorspace的类别
    int srcColorSpaceName = OH_NativeColorSpaceManager_GetColorSpaceName(srcColorSpaceNative);
    OH_NativeColorSpaceManager_Destroy(srcColorSpaceNative);
    LOGI("GetColorSpace srcName = %d", srcColorSpaceName);
    return srcColorSpaceName;
}

void SetColorSpace(OH_PictureNative *srcPicture)
{
    if (srcPicture == nullptr) {
        LOGE("SetColorSpace failed, because src is nullptr or dst is nullptr");
        return;
    }

    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode code = OH_PictureNative_GetMainPixelmap(srcPicture, &mainPixelMap);
    if (code != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("SetColorSpace failed");
        return;
    }
    std::shared_ptr<OH_PixelmapNative> mainPixelMapPtr(mainPixelMap, [](OH_PixelmapNative *mainPixelMap) {
        OH_PixelmapNative_Release(mainPixelMap);
    });

    OH_NativeColorSpaceManager *srcColorSpaceNative = nullptr;
    Image_ErrorCode errorCode = OH_PixelmapNative_GetColorSpaceNative(mainPixelMapPtr.get(), &srcColorSpaceNative);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || srcColorSpaceNative == nullptr) {
        LOGE("SetColorSpace OH_PixelmapNative_GetColorSpaceNative fail! errorCode=%d", errorCode);
        return;
    }
    
    // 获取colorspace的类别
    int srcColorSpaceName = OH_NativeColorSpaceManager_GetColorSpaceName(srcColorSpaceNative);
    LOGI("SetColorSpace srcName = %d", srcColorSpaceName);
    if (srcColorSpaceName == ColorSpaceName::DCI_P3 || srcColorSpaceName == ColorSpaceName::ADOBE_RGB) {
        OH_NativeColorSpaceManager_Destroy(srcColorSpaceNative);
        srcColorSpaceNative = OH_NativeColorSpaceManager_CreateFromName(ColorSpaceName::DISPLAY_P3);
    } else {
        OH_NativeColorSpaceManager_Destroy(srcColorSpaceNative);
        return;
    }
    errorCode = OH_PixelmapNative_SetColorSpaceNative(mainPixelMapPtr.get(), srcColorSpaceNative);
    OH_NativeColorSpaceManager_Destroy(srcColorSpaceNative);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("SetColorSpace OH_PixelmapNative_SetColorSpaceNative fail! errorCode=%d", errorCode);
        return;
    }
    LOGD("SetColorSpace success.");
}

STRING CreateFileInMainThread(const char *name, const char *suffix)
{
    napi_value global;
    napi_value createFdFunc;
    napi_status status = GetFunction(g_napiEnv, "image_editor_MediaLibraryProxy", "createFd",
        global, createFdFunc);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, "", "%s failed, code = %d", __func__, status);

    size_t argc = 2;
    napi_value argv[argc];
    status = napi_create_string_utf8(g_napiEnv, name, NAPI_AUTO_LENGTH, &argv[0]);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, "", "%s create name failed, code = %d", __func__, status);
    status = napi_create_string_utf8(g_napiEnv, suffix, NAPI_AUTO_LENGTH, &argv[1]);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, "", "%s create suffix failed, code = %d", __func__, status);
    
    napi_value ret;
    status = napi_call_function(g_napiEnv, global, createFdFunc, argc, argv, &ret);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, "", "%s call function failed, code = %d", __func__, status);
    
    // 获取字符串长度
    size_t strSize = 0;
    status = napi_get_value_string_utf8(g_napiEnv, ret, nullptr, 0, &strSize);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, "", "%s get ret size failed, code = %d", __func__, status);
    
    // 分配内存获取字符串内容
    LOGI("CreateFileInMainThread strSize = %d", strSize);
    char* buffer = (char*)malloc(strSize + 1);
    CHECK_AND_RETURN_RET_LOG(buffer != nullptr, "", "%s malloc failed");

    status = napi_get_value_string_utf8(g_napiEnv, ret, buffer, strSize + 1, &strSize);
    CHECK_AND_RETURN_RET_LOG_WITH_FUNCTION(status == napi_ok, "", { free(buffer); },
        "%s get result failed, code = %d", __func__, status);
    STRING res = STRING(buffer, strSize);
    free(buffer);
    buffer = nullptr;
    return res;
}

STRING CreateFileByJs(const STRING &name, const STRING &suffix)
{
    LOGI("%s enter", __func__);
    if(IsMainThread()) {
        return CreateFileInMainThread(name.c_str(), suffix.c_str());
    }
    
    napi_env env = g_napiEnv;
    uv_loop_s *loop = nullptr;
    napi_status status = napi_get_uv_event_loop(env, &loop);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, "", "%s get_uv_event failed, code = %d", __func__, status);
    
    uv_work_t *work = new (std::nothrow) uv_work_t;
    CHECK_AND_RETURN_RET_LOG(work != nullptr, "", "%s new uv work failed", __func__);

    CreateFdParams *fdParams = new (std::nothrow) CreateFdParams(name.c_str(), suffix.c_str());
    CHECK_AND_RETURN_RET_LOG_WITH_FUNCTION(fdParams != nullptr, "", { delete work; },
        "%s new fd params failed", __func__);

    work->data = (void *)fdParams;
    uv_queue_work(loop, work, [](uv_work_t *work) { LOGI("%s work run", __func__); },
        [](uv_work_t *work, int status) {
            CreateFdParams *data = (CreateFdParams *)work->data;
            data->result = CreateFileInMainThread(data->name, data->suffix);
            std::unique_lock<std::mutex> lock(data->mutex);
            data->isReady = true;
            data->condition.notify_all();
        });

    {
        std::unique_lock<std::mutex> lock(fdParams->mutex);
        fdParams->condition.wait(lock, [&] { return fdParams->isReady; });
    }
    STRING res = fdParams->result;
    delete fdParams;
    delete work;
    return res;
}

bool AddResourceInMainThread(int type, const STRING &path)
{
    napi_value global;
    napi_value createFdFunc;
    napi_status status = GetFunction(g_napiEnv, "image_editor_MediaLibraryProxy", "addResource",
        global, createFdFunc);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s failed, code = %d", __func__, status);

    size_t argc = 2;
    napi_value argv[argc];
    status = napi_create_int32(g_napiEnv, type, &argv[0]);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s create type failed, code = %d", __func__, status);
    status = napi_create_string_utf8(g_napiEnv, path.c_str(), NAPI_AUTO_LENGTH, &argv[1]);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s create path failed, code = %d", __func__, status);
    
    napi_value ret;
    status = napi_call_function(g_napiEnv, global, createFdFunc, argc, argv, &ret);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s call function failed, code = %d", __func__, status);
    return true;
}

bool AddResource(int type, const STRING &path)
{
    if(IsMainThread()) {
        return AddResourceInMainThread(type, path);
    }
    napi_env env = g_napiEnv;
    uv_loop_s *loop = nullptr;
    napi_status status = napi_get_uv_event_loop(env, &loop);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s get_uv_event failed, code = %d", __func__, status);
    
    uv_work_t *work = new (std::nothrow) uv_work_t;
    CHECK_AND_RETURN_RET_LOG(work != nullptr, "", "%s new uv work failed", __func__);

    AddResourceParams *addResourceParams = new (std::nothrow) AddResourceParams(type, path.c_str());
    CHECK_AND_RETURN_RET_LOG_WITH_FUNCTION(addResourceParams != nullptr, "", { delete work; },
        "%s new params failed", __func__);

    work->data = (void *)addResourceParams;
    uv_queue_work(loop, work, [](uv_work_t *work) { LOGI("%s work run", __func__); },
        [](uv_work_t *work, int status) {
            AddResourceParams *data = (AddResourceParams *)work->data;
            data->result = AddResourceInMainThread(data->type, data->path);
            std::unique_lock<std::mutex> lock(data->mutex);
            data->isReady = true;
            data->condition.notify_all();
        });
    {
        std::unique_lock<std::mutex> lock(addResourceParams->mutex);
        addResourceParams->condition.wait(lock, [&] { return addResourceParams->isReady; });
    }
    bool res = addResourceParams->result;
    delete addResourceParams;
    delete work;
    return res;
}

bool IsEditorParamEnableInMainThread(const std::string &key)
{
    napi_value global;
    napi_value isParamEnableFunc;
    napi_status status = GetFunction(g_napiEnv, "image_editor_MediaLibraryProxy", "isParamEnable",
        global, isParamEnableFunc);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s failed, code = %d", __func__, status);
 
    size_t argc = 1;
    napi_value argv[argc];
    status = napi_create_string_utf8(g_napiEnv, key.c_str(), NAPI_AUTO_LENGTH, &argv[0]);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s create name failed, code = %d", __func__, status);
 
    napi_value result;
    status = napi_call_function(g_napiEnv, global, isParamEnableFunc, argc, argv, &result);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s call function failed, code = %d", __func__, status);
 
    bool res = false;
    status = napi_get_value_bool(g_napiEnv, result, &res);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s call function failed, code = %d", __func__, status);
    return res;
}
 
bool IsParamEnable(const std::string &key)
{
    LOGI("IsParamEnable enter key is %s", key.c_str());
    if (key == ULTRA_SPORT_ENABLE) {
        return ProjectConfig::Instance().IsSupportUltraPhoto();
    }

    if (IsMainThread()) {
        return IsEditorParamEnableInMainThread(key);
    }
 
    napi_env env = g_napiEnv;
    uv_loop_s *loop = nullptr;
    napi_status status = napi_get_uv_event_loop(env, &loop);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, false, "%s get_uv_event failed, code = %d", __func__, status);
    
    uv_work_t *work = new (std::nothrow) uv_work_t;
    CHECK_AND_RETURN_RET_LOG(work != nullptr, false, "%s new uv work failed", __func__);
    
    IsParamEnableParams *isParamEnableParams = new (std::nothrow) IsParamEnableParams(key.c_str());
    CHECK_AND_RETURN_RET_LOG_WITH_FUNCTION(isParamEnableParams != nullptr, false, { delete work; },
        "%s new fd params failed", __func__);
 
    work->data = (void *)isParamEnableParams;
    uv_queue_work(loop, work, [](uv_work_t *work) { LOGI("%s work run", __func__); },
        [](uv_work_t *work, int status) {
            IsParamEnableParams *data = (IsParamEnableParams *)work->data;
            data->result = IsEditorSwitchEnableInMainThread(data->key);
            std::unique_lock<std::mutex> lock(data->mutex);
            data->isReady = true;
            data->condition.notify_all();
        });
 
    {
        std::unique_lock<std::mutex> lock(isParamEnableParams->mutex);
        isParamEnableParams->condition.wait(lock, [&] { return isParamEnableParams->isReady; });
    }
    bool res = isParamEnableParams->result;
    delete isParamEnableParams;
    delete work;
    return res;
}