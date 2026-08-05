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

#include "HmcRenderEngine.h"
#include "Editor/Export/HmcEncoderManager.h"
#include "MediaCreative/HmcDictKey.h"
#include "MediaCreative/HmcEditorAsset.h"
#include "Project/HmcProjectSerializeKey.h"
#include "Project/HmcProjectEntity.h"
#include "ohos/jscaller/DataAbilityHelper.h"
#include "render/base/RenderBase.h"
#include "MediaCreative.h"
#include "render/core/ComposeFilter.h"
#include "render/core/CustomCropFilter.h"
#include "render/core/HmcRenderEffect.h"
#include "render/graphic/HmcNativeWindow.h"

#include <hitrace/trace.h>
#include <multimedia/image_effect/image_effect_errors.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <native_window/external_window.h>
#include <algorithm>
#include <string>

#ifndef GL_TEXTURE_EXTERNAL_OES
#define GL_TEXTURE_EXTERNAL_OES 0x8D65
#endif

#define RENDER_QUEUE_SIZE 8
#define COMMON_TASK_TAG 0
#define PREVIEW_TASK_TAG 1
#define EXPORT_TASK_TAG 2

const char *CONFIG_TEXTURE_M_ROTATION = "TEXTURE_M_ROTATION";
const char *CONFIG_TEXTURE_M_NEED_RELEASE = "TEXTURE_M_NEED_RELEASE";
const char *CONFIG_TEXTURE_M_UID = "TEXTURE_M_UID";

const char *CONFIG_TEXTURE_ADD_TEXTURE_FUNCTION = "TEXTURE_ADD_TEXTURE_FUNCTION";
const char *CONFIG_TEXTURE_RESIZE_TEX_CACHE_FUNCTION = "TEXTURE_RESIZE_TEX_CACHE_FUNCTION";
const char *CONFIG_SURFACE_SET_NATIVE_WINDOW = "SURFACE_SET_NATIVE_WINDOW";

const char *CONFIG_CANVAS_M_X_KEY = "CANVAS_M_X_KEY";
const char *CONFIG_CANVAS_M_Y_KEY = "CANVAS_M_Y_KEY";
const char *CONFIG_CANVAS_M_WIDTH_KEY = "CANVAS_M_WIDTH_KEY";
const char *CONFIG_CANVAS_M_HEIGHT_KEY = "CANVAS_M_HEIGHT_KEY";
const char *CONFIG_CANVAS_M_CANVAS_WIDTH_KEY = "CANVAS_M_CANVAS_WIDTH_KEY";
const char *CONFIG_CANVAS_M_CANVAS_HEIGHT_KEY = "CANVAS_M_CANVAS_HEIGHT_KEY";

const char *CONFIG_RENDER_TYPE_KEY = "RENDER_TYPE_KEY";
const char *CONFIG_RENDER_ENCODE_TYPE = "RENDER_ENCODE_TYPE";
const char *CONFIG_RENDER_OUT_BITMAP = "RENDER_OUT_BITMAP";
const char *CONFIG_RENDER_RGBA_OUTPUT = "RENDER_RGBA_OUTPUT";

const std::string START_CACHE_CONFIG = "START_CACHE";
const std::string CANCEL_CACHE_CONFIG = "CANCEL_CACHE";

static const Vec2 DEFAULT_ROI[4] = {
    Vec2(0.0, 0.0), // 左下
    Vec2(1.0, 0.0), // 右下
    Vec2(1.0, 1.0), // 右上
    Vec2(0.0, 1.0)  // 左上
};

static const VECTOR<STRING> ADJUST_ITEM = {
    "HUE",
    "SATURATION",
    "BRIGHTNESS",
    "CONTRAST",
    "TEMPERATURE",
    "SHARPNESS",
    "FADE",
    "EXPOSURE",
    "GRAIN",
    "HIGHLIGHT",
    "SHADOW",
    "VIGNETTE",
    "VIBRANCE",
    "BRIGHTZONE",
    "DARKZONE"
};

static const VECTOR<STRING> ADJUST_ITEM_STATUS = {
    "COLOR_ADJUST_HUE",
    "COLOR_ADJUST_SATURATION",
    "COLOR_ADJUST_BRIGHTNESS",
    "COLOR_ADJUST_CONTRAST",
    "COLOR_ADJUST_TEMPERATURE",
    "COLOR_ADJUST_SHARPNESS",
    "COLOR_ADJUST_FADE",
    "COLOR_ADJUST_EXPOSURE",
    "COLOR_ADJUST_GRAIN",
    "COLOR_ADJUST_HIGHLIGHT",
    "COLOR_ADJUST_SHADOW",
    "COLOR_ADJUST_VIGNETTE",
    "COLOR_ADJUST_VIBRANCE",
    "COLOR_ADJUST_BRIGHTZONE",
    "COLOR_ADJUST_DARKZONE"
};

static const VECTOR<STRING> XTSTYLE_ITEM = {
    PROJECT_KEY_XTSTYLE_COLOR_TEMPERATURE,
    PROJECT_KEY_XTSTYLE_SATURATION,
    PROJECT_KEY_XTSTYLE_LIGHT_AND_SHADOW
};

constexpr const double PI = 3.14159265;
constexpr const double HALF_CYCLE = 180.0;
constexpr const int VECTOR_SIZE = 4;
constexpr const int LEFT_BOTTOM = 0;
constexpr const int RIGHT_BOTTOM = 1;
constexpr const int RIGHT_TOP = 2;
constexpr const int LEFT_TOP = 3;
constexpr const int CAMERA_MATRIX_X = 3;
constexpr const int CAMERA_MATRIX_Y = 2;
constexpr const double CAMERA_MATRIX_ROTATE = 15.0;
constexpr const double HALF_FOR_CALCULATE = 0.5;

constexpr const double ALIGN_LENGTH = 720.0;
constexpr const double EXTRA_PIXEL = 16.0;
constexpr const int MIN_DEVIDE = 32;
constexpr const int RENEWAL_BUFFER_COUNT = 3;

HmcRenderEngine::HmcRenderEngine(UINT32 id, RenderType renderType)
{
std:
    std::lock_guard<std::recursive_mutex> guard(m_renderMutex);
    m_id = id;
    m_renderType = renderType;
    LOGI("[Render] Engine %ld Constructed!", m_id);
}

HmcRenderEngine::~HmcRenderEngine() { Destroy(); }

static ImageEffect_Any GetAny(void *value, ImageEffect_DataType type)
{
    ImageEffect_Any ohAny {};
    ImageEffect_DataValue dataValue {};
    if (value == nullptr) {
        LOGE("SetValue failed, value is null");
        ohAny.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_PTR;
        ohAny.dataValue.ptrValue = nullptr;
        return ohAny;
    }

    switch (type) {
        case ImageEffect_DataType::EFFECT_DATA_TYPE_INT32:
            dataValue.int32Value = *(int32_t *)(value);
            break;
        case ImageEffect_DataType::EFFECT_DATA_TYPE_DOUBLE:
            dataValue.doubleValue = *(double *)(value);
            break;
        case ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT:
            dataValue.floatValue = *(float *)(value);
            break;
        case ImageEffect_DataType::EFFECT_DATA_TYPE_LONG:
            dataValue.longValue = *(long *)(value);
            break;
        case ImageEffect_DataType::EFFECT_DATA_TYPE_PTR:
            dataValue.ptrValue = value;
            break;
        default:
            LOGE("Set Value Failed, type = %d", type);
            ohAny.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_PTR;
            ohAny.dataValue.ptrValue = nullptr;
            return ohAny;
    }
    ohAny.dataValue = dataValue;
    ohAny.dataType = type;
    return ohAny;
}

static VOID ConfigValue(OH_ImageEffect *effect, void *value, const char *key, ImageEffect_DataType type)
{
    if (effect == nullptr || key == nullptr || value == nullptr) {
        LOGE("ConfigValue skip. effect=%{public}d key=%{public}d value=%{public}d",
            effect != nullptr, key != nullptr, value != nullptr);
        return;
    }
    ImageEffect_Any ohAny = GetAny(value, type);
    OH_ImageEffect_Configure(effect, key, &ohAny);
}


static VOID SetValue(OH_EffectFilter *filter, void *value, const char *key, ImageEffect_DataType type)
{
    if (filter == nullptr || key == nullptr || value == nullptr) {
        LOGE("SetValue skip. filter=%{public}d key=%{public}d value=%{public}d",
            filter != nullptr, key != nullptr, value != nullptr);
        return;
    }
    ImageEffect_Any ohAny = GetAny(value, type);
    OH_EffectFilter_SetValue(filter, key, &ohAny);
}

Json::Value HmcRenderEngine::SaveImageEffect()
{
    LOGD("SaveImageEffect %s", exportInfo_);
    Json::Value imageEffectDataJson;
    Json::Reader reader;
    reader.parse(exportInfo_, imageEffectDataJson);
    return imageEffectDataJson;
}

INT32 HmcRenderEngine::RestoreImageEffect(const STRING &restoreInfo)
{
    if (restoreInfo == "") {
        LOGE("restore image effect fail ");
        ReleaseImageEffectOnRenderThread();
        if (mIsHMCRenderEnable) {
            mImageEffect = OH_ImageEffect_Create("HMC_EXT");
        } else {
            mImageEffect = OH_ImageEffect_Create("Photo");
        }
        m_restoredFilterCount = mImageEffect == nullptr ? 0 : OH_ImageEffect_GetFilterCount(mImageEffect);
        return HMC_ERR;
    }

    Json::Reader reader;
    Json::Value restoreInfoData;
    if (!reader.parse(restoreInfo, restoreInfoData)) {
        LOGE("restore image effect failed because of parsing data to json object.");
        return HMC_ERR;
    }

    ReleaseImageEffectOnRenderThread();

    Json::Value jsonSystem;
    if (SINGLETON(HmcProjectEntity)->CheckImageEffectEditorDataSignature(restoreInfoData)) {
        jsonSystem = restoreInfoData;
        if (mIsHMCRenderEnable) {
            jsonSystem["imageEffect"]["name"] = "HMC_EXT";  // 临时与框架协商处理
        } else {
            jsonSystem["imageEffect"]["name"] = "Photo";  // 临时与框架协商处理
        }
        mImageEffect = OH_ImageEffect_Restore(Json::FastWriter().write(jsonSystem).c_str());
    } else {
        LOGD("create image effect");
        if (mIsHMCRenderEnable) {
            mImageEffect = OH_ImageEffect_Create("HMC_EXT");
        } else {
            mImageEffect = OH_ImageEffect_Create("Photo");
        }
    }

    if (mImageEffect == nullptr) {
        LOGE("restore image effect failed because of mImageEffect is null.");
        return HMC_ERR;
    }
    m_restoredFilterCount = OH_ImageEffect_GetFilterCount(mImageEffect);
    LOGI("RestoreImageEffect filter count: %d", m_restoredFilterCount);
    return HMC_OK;
}

VOID HmcRenderEngine::Destroy()
{
std:
    std::lock_guard<std::recursive_mutex> guard(m_renderMutex);

    if (!m_ready) {
        LOGI("m_ready is null!", m_id);
        LOGI("[Render] Engine %ld destroy end!", m_id);
        return;
    }
    m_ready = FALSE;
    window_ = nullptr;
    if (m_lastExportTaskFuture.valid()) {
        m_lastExportTaskFuture.wait();
    }
    if (m_renderThread) {
        auto weakThis = weak_from_this();
        auto task = std::make_shared<RenderTask<>>([weakThis]() { 
                auto strong = weakThis.lock();
                if (strong == nullptr) {
                    LOGE("HmcRenderEngine::Destroy strong is nullptr.");
                    return;
                }
                strong->ReleaseThread();
            }, COMMON_TASK_TAG, RequestTaskId());
        m_renderThread->AddTask(task);
        task->Wait();
        delete m_renderThread;
        m_renderThread = nullptr;
    }
    if (m_bitpng != NULL) {
        delete[] m_bitpng;
        m_bitpng = nullptr;
    }
    std::lock_guard<std::mutex> locker(m_waterMarkMtx);
    m_watermarkCache.clear();
    m_effectGlobalCache.clear();
    LOGI("[Render] Engine %ld destroy end!", m_id);
}

VOID HmcRenderEngine::InitEnv(std::string const & editData)
{
    std::lock_guard<std::recursive_mutex> guard(m_renderMutex);
    LOGD("[Render] initEnv");
    if (m_renderThread == NULL) {
        // 自动回收纹理资源
        auto weakThis = weak_from_this();
        auto func = [weakThis, editData]() {
            auto strong = weakThis.lock();
            if (strong == nullptr) {
                LOGE("HmcRenderEngine::InitEnv1 strong is nullptr.");
                return;
            }
            if (strong->mIsHMCRenderEnable && strong->mImageEffect != nullptr) {
                int temp = 1;
                ConfigValue(strong->mImageEffect, &temp, CONFIG_TEXTURE_RESIZE_TEX_CACHE_FUNCTION,
                    ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
            }
            if (strong->m_needFlush) {
                strong->RestoreImageEffect(editData);
                strong->m_needFlush = false;
            }
        };
        m_renderThread = new RenderThread<>(RENDER_QUEUE_SIZE, func);
        m_renderThread->Start();
        auto task = std::make_shared<RenderTask<>>([weakThis, editData]() {
            auto strong = weakThis.lock();
            if (strong == nullptr) {
                LOGE("HmcRenderEngine::InitEnv2 strong is nullptr.");
                return;
            }
            strong->InitThread(editData);
        }, COMMON_TASK_TAG, RequestTaskId());
        m_renderThread->AddTask(task);
        task->Wait();
    }
    m_frameEndTime = std::chrono::high_resolution_clock::now();
    m_ready = TRUE;
}

VOID HmcRenderEngine::InitEngine(VOID *surface)
{
std:
    std::lock_guard<std::recursive_mutex> guard(m_renderMutex);
    LOGI("[Render] Engine %ld Init start!", m_id);
    if (surface != NULL) {
        window_ = surface;
        if (mIsHMCRenderEnable) {
            ConfigValue(mImageEffect, surface, CONFIG_SURFACE_SET_NATIVE_WINDOW,
                ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
        } else {
            m_isSurfaceOutput = true;
            OH_ImageEffect_SetOutputSurface(mImageEffect, static_cast<OHNativeWindow *>(surface));
        }
        m_offscreenOnly = FALSE;
    } else {
        m_offscreenOnly = TRUE;
    }
    LOGI("[Render] Engine %ld Init end!", m_id);
}

VOID HmcRenderEngine::InitExportEngine(VOID *surface)
{
    LOGI("[Render] InitExportEngine %ld begin", m_id);
    if (surface != NULL) {
        m_offscreenOnly = FALSE;
    } else {
        LOGI("[Render] surface is NULL");
    }
    LOGI("[Render] InitExportEngine %ld end", m_id);
}

VOID HmcRenderEngine::UpdateResCache(VECTOR<HmcRenderLayerPtr> &renderLayers, UINT64 id)
{
    for (auto &layer : renderLayers) {
        for (auto &effect : layer->m_effectList) {
            auto name = effect->m_name;
            switch (effect->m_resControlTag) {
                case HmcRenderEffect::REUSE:
                case HmcRenderEffect::UPDATE: {
                    HmcRenderEffectPtr ele = std::make_shared<HmcRenderEffect>(*(effect.get()));
                    m_effectGlobalCache[name] = ele;
                    break;
                }
                case HmcRenderEffect::PRERELEASE:
                case HmcRenderEffect::POSTRELEASE:
                    m_effectGlobalCache.erase(name);
                    break;
                default:
                    break;
            }
        }
    }
}

VOID HmcRenderEngine::UpdateLayerRes(HmcRenderLayerPtr &renderLayer)
{
    LIST<HmcRenderEffectPtr> list;
    for (auto &effect : renderLayer->m_effectList) {
        auto name = effect->m_name;
        HmcRenderEffectPtr ele = m_effectGlobalCache[name];
        list.push_back(ele);
    }
    renderLayer->m_effectList = list;
}

void HmcRenderEngine::GenConfigEFilter()
{
    const char *name = "HMCConfigEFilter";
    const char *type = "config";
    int count = OH_ImageEffect_GetFilterCount(mImageEffect);
    if (!m_efilterList.contains(type)) {
        HmcEFilterPtr filter = std::make_shared<HmcEFilter>(name, type);
        m_efilterList[type] =  filter;
        if (count > 0) {
            m_efilterList[type]->StartCache();
        }
    }
    OH_ImageEffect_AddFilterByFilter(mImageEffect, m_efilterList[type]->GetEFilter());
}

VOID HmcRenderEngine::Draw(VECTOR<HmcRenderLayerPtr> &renderLayers, const HmcRenderCanvas &canvas,
                           HmcRenderResultFunc func, UINT64 id, ATOMIC_BOOL *isPicChangingPtr)
{
std:
    std::lock_guard<std::recursive_mutex> guard(m_renderMutex);
    if (m_ready && !m_exported) {
        LOGD("[Render]Draw Frame %ld launched, Engine : %ld, canvas: %d %d %d %d %d %d\n", id, m_id, canvas.x_,
             canvas.y_, canvas.width_, canvas.height_, canvas.canvasWidth_, canvas.canvasHeight_);
    } else {
        LOGE("[Render]Not Ready! Draw Frame %ld, Engine : %ld\n", id, m_id);
        return;
    }

    if (m_offscreenOnly) {
        LOGE("[Render]: Can not Draw On Offscreen Surface!\n");
        return;
    }

    auto taskId = RequestTaskId();

    SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers = UpdateCache(renderLayers, taskId);

    RenderEngineType type = TYPE_PREVIEW;

    auto launchTime = std::chrono::high_resolution_clock::now();
    LOGD("RenderTask taskId:%d launchTime:%ld", taskId, launchTime);
    auto weakThis = weak_from_this();
    auto task = std::make_shared<RenderTask<>>(
        [weakThis, type, layers, canvas, taskId, launchTime, id, func, isPicChangingPtr]() {
            LOGD("[Render]Draw Frame running start, id: %ld, taskId: %d, launchTime:%ld", id, taskId, launchTime);
            OH_HiTrace_StartTrace("ImageEditorRenderDraw RunTask");
            auto strong = weakThis.lock();
            if (strong == nullptr) {
                LOGE("HmcRenderEngine::Draw strong is nullptr.");
                return;
            }
            if (isPicChangingPtr != nullptr && isPicChangingPtr->load()) {
                LOGE("HmcRenderEngine::image is changing so return");
                return;
            }
            VECTOR<SHARED_PTR<Image>> images;

            // 对预览渲染进行降分辨率处理，降低低端机单帧开销
            HmcRenderCanvas previewCanvas = canvas;
            bool isDraggingImage = std::any_of(layers->begin(), layers->end(),
                [](const HmcRenderLayerPtr &layerInfo) {
                    return layerInfo != nullptr && layerInfo->m_isDragImage;
                });
            const INT32 MAX_PREVIEW_EDGE_DEFAULT = 1280;
            const INT32 MAX_PREVIEW_EDGE_DRAG = 960;
            const INT32 maxPreviewEdge = isDraggingImage ? MAX_PREVIEW_EDGE_DRAG : MAX_PREVIEW_EDGE_DEFAULT;
            float scaleW = static_cast<float>(previewCanvas.canvasWidth_) / static_cast<float>(maxPreviewEdge);
            float scaleH = static_cast<float>(previewCanvas.canvasHeight_) / static_cast<float>(maxPreviewEdge);
            float downScale = std::max(scaleW, scaleH);
            float downScaleInv = 1.0f; // 用于同步 transform offset 的坐标系缩放
            if (downScale > 1.0f) {
                float inv = 1.0f / downScale;
                downScaleInv = inv;
                previewCanvas.canvasWidth_ = static_cast<INT32>(previewCanvas.canvasWidth_ * inv);
                previewCanvas.canvasHeight_ = static_cast<INT32>(previewCanvas.canvasHeight_ * inv);
                previewCanvas.width_ = static_cast<INT32>(previewCanvas.width_ * inv);
                previewCanvas.height_ = static_cast<INT32>(previewCanvas.height_ * inv);
                previewCanvas.x_ = static_cast<INT32>(previewCanvas.x_ * inv);
                previewCanvas.y_ = static_cast<INT32>(previewCanvas.y_ * inv);
                LOGD("[Render]Preview downScale:%f edge:%d drag:%d canvas(%d,%d,%d,%d,%d,%d)",
                    downScale, maxPreviewEdge, isDraggingImage, previewCanvas.x_, previewCanvas.y_,
                    previewCanvas.width_, previewCanvas.height_, previewCanvas.canvasWidth_, previewCanvas.canvasHeight_);
            }

            // 预览降分辨率会改变 transform 中使用的 viewportX/viewportY，
            // 而 transform 的 cropOffsetX/cropOffsetY/offsetX/offsetY 是按未降采样 canvas 坐标系算的。
            // 因此进入 ConfigRenderInfo 前需要按 downScaleInv 把这些 offset 同步缩放回来，
            // 否则会出现“裁剪框正常但图片不铺满/溢出”的错位。
            struct TransformOffsetBackup {
                HmcRenderEffectPtr effect;
                double cropOffsetX = 0.0;
                double cropOffsetY = 0.0;
                double offsetX = 0.0;
                double offsetY = 0.0;
                double scaleX = 0.0;
                double scaleY = 0.0;
                bool hasCropOffsetX = false;
                bool hasCropOffsetY = false;
                bool hasOffsetX = false;
                bool hasOffsetY = false;
                bool hasScaleX = false;
                bool hasScaleY = false;
            };
            std::vector<TransformOffsetBackup> offsetBackups;
            if (downScaleInv != 1.0f) {
                for (auto &layerInfo : *layers) {
                    for (auto &effect : layerInfo->m_effectList) {
                        if (effect == nullptr || effect->m_resource == nullptr) {
                            continue;
                        }
                        if (effect->m_resource->m_effectType != "transform") {
                            continue;
                        }

                        TransformOffsetBackup b;
                        b.effect = effect;
                        b.hasCropOffsetX = effect->GetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, b.cropOffsetX);
                        b.hasCropOffsetY = effect->GetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, b.cropOffsetY);
                        b.hasOffsetX = effect->GetParam(PROJECT_KEY_TRANSFORM_OFFSET_X, b.offsetX);
                        b.hasOffsetY = effect->GetParam(PROJECT_KEY_TRANSFORM_OFFSET_Y, b.offsetY);
                        b.hasScaleX = effect->GetParam(PROJECT_KEY_TRANSFORM_SCALE_X, b.scaleX);
                        b.hasScaleY = effect->GetParam(PROJECT_KEY_TRANSFORM_SCALE_Y, b.scaleY);

                        if (b.hasCropOffsetX) {
                            effect->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, b.cropOffsetX * downScaleInv);
                        }
                        if (b.hasCropOffsetY) {
                            effect->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, b.cropOffsetY * downScaleInv);
                        }
                        if (b.hasOffsetX) {
                            effect->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_X, b.offsetX * downScaleInv);
                        }
                        if (b.hasOffsetY) {
                            effect->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_Y, b.offsetY * downScaleInv);
                        }
                        if (b.hasScaleX) {
                            effect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_X, b.scaleX * downScaleInv);
                        }
                        if (b.hasScaleY) {
                            effect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_Y, b.scaleY * downScaleInv);
                        }
                        offsetBackups.emplace_back(b);
                    }
                }
            }

            for (auto &layerInfo : *layers) {
                images.emplace_back(strong->ConfigRenderInfo(layerInfo, nullptr, TYPE_PREVIEW, previewCanvas, 0));
            }
        
            OH_PixelmapNative *outPixelMap = strong->GenerateOutputPixelmap(layers, previewCanvas, 0, taskId);

            // restore original transform offsets
            if (!offsetBackups.empty()) {
                for (auto &b : offsetBackups) {
                    if (b.effect == nullptr) {
                        continue;
                    }
                    if (b.hasCropOffsetX) {
                        b.effect->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, b.cropOffsetX);
                    }
                    if (b.hasCropOffsetY) {
                        b.effect->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, b.cropOffsetY);
                    }
                    if (b.hasOffsetX) {
                        b.effect->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_X, b.offsetX);
                    }
                    if (b.hasOffsetY) {
                        b.effect->SetParam(PROJECT_KEY_TRANSFORM_OFFSET_Y, b.offsetY);
                    }
                    if (b.hasScaleX) {
                        b.effect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_X, b.scaleX);
                    }
                    if (b.hasScaleY) {
                        b.effect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_Y, b.scaleY);
                    }
                }
            }

            OH_ImageEffect_RemoveFilter(strong->mImageEffect, "CustomCropFilter");
            OH_ImageEffect_SetInputPixelmap(strong->mImageEffect, outPixelMap);
            if (strong->window_ != nullptr) {
                OH_ImageEffect_SetOutputSurface(strong->mImageEffect, static_cast<OHNativeWindow *>(strong->window_));
            }
            
            OH_HiTrace_StartTrace("ImageEditorRenderDraw");
            LOGD("[Render]Draw Frame OH_ImageEffect_Start start");
            OH_ImageEffect_Start(strong->mImageEffect);
            LOGD("[Render]Draw Frame OH_ImageEffect_Start end");
            OH_HiTrace_FinishTrace();

            if (func) {
                func(0);
            }
            OH_HiTrace_FinishTrace();
            images.clear();
            OH_PixelmapNative_Release(outPixelMap);
            strong->RemoveFilters();
            strong->m_needFlush = true;
            LOGD("[Render]Draw Frame running end, id: %ld, taskId: %d", id, taskId);
        },
        PREVIEW_TASK_TAG, taskId);
    OH_HiTrace_StartTrace("ImageEditorRenderDraw AddTask");
    m_renderThread->AddTask(task, true);
    OH_HiTrace_FinishTrace();
}

void HmcRenderEngine::ConfigCanvas(const HmcRenderCanvas &canvas, HmcEFilterPtr hmcEFilterPtr)
{
    int x = canvas.x_;
    hmcEFilterPtr->SetValue(&x, CONFIG_CANVAS_M_X_KEY, ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
    int y = canvas.y_;
    hmcEFilterPtr->SetValue(&y, CONFIG_CANVAS_M_Y_KEY, ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
    int width = canvas.width_;
    hmcEFilterPtr->SetValue(&width, CONFIG_CANVAS_M_WIDTH_KEY, ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
    int height = canvas.height_;
    hmcEFilterPtr->SetValue(&height, CONFIG_CANVAS_M_HEIGHT_KEY, ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
    int canvasWidth = canvas.canvasWidth_;
    hmcEFilterPtr->SetValue(&canvasWidth, CONFIG_CANVAS_M_CANVAS_WIDTH_KEY,
        ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
    int canvasHeight = canvas.canvasHeight_;
    hmcEFilterPtr->SetValue(&canvasHeight, CONFIG_CANVAS_M_CANVAS_HEIGHT_KEY,
        ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
}

SHARED_PTR<VECTOR<HmcRenderLayerPtr>> HmcRenderEngine::UpdateCache(VECTOR<HmcRenderLayerPtr> &renderLayers,
    UINT64 taskId)
{
    // 更新cache
    m_cacheMutex.lock();
    UpdateResCache(renderLayers, taskId);
    // 生成layer智能指针vector， 可以优化， 需要更换接口， service一同修改， 目前为了兼容Draw接口
    SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers = std::make_shared<VECTOR<HmcRenderLayerPtr>>();
    for (auto &layer : renderLayers) {
        auto ele = std::make_shared<HmcRenderLayer>(*layer);
        UpdateLayerRes(ele); // 将新layer内的智能指针指向engine内缓存的数据
        layers->push_back(ele);
    }
    m_cacheMutex.unlock();
    return layers;
    // 更新cache结束
}

Image_Size HmcRenderEngine::CalcExportSizeAndFixOffset(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers,
    const HmcRenderCanvas &canvas)
{
    Image_Size exportSize = {.width = (uint32_t)canvas.canvasWidth_, .height = (uint32_t)canvas.canvasHeight_};
    if (m_renderType == RenderType::THUMBNAIL) {
        return exportSize;
    }
    SHARED_PTR<Image> image = nullptr;
    for (auto &layerInfo : *layers) {
        auto it = layerInfo->m_textureList.find(MAIN_TEX);
        if (it == layerInfo->m_textureList.end()) {
            return exportSize;
        }
        auto tex = it->second;
        if (tex == nullptr) {
            LOGD("CreateOutputPicture tex is nullptr");
            continue;
        }
        image = tex->GetImage();
        if (image == nullptr || image->originalPicture == nullptr) {
            LOGI("CreateOutputPicture image isNUll: %d", image == nullptr);
            continue;
        }

        for (auto &effect : layerInfo->m_effectList) {
            // 根据类型判断是否需要校正
            if (effect->m_resource->m_effectType == "transform") {
                float offsetX = (FLOAT)effect->m_effectParam["offsetX"].Get<DOUBLE>();
                float offsetY = (FLOAT)effect->m_effectParam["offsetY"].Get<DOUBLE>();
                float offsetXNew = offsetX / image->downSampleScale;
                float offsetYNew = offsetY / image->downSampleScale;
                effect->m_effectParam.insert_or_assign("offsetX", HmcRenderValue(offsetXNew));
                effect->m_effectParam.insert_or_assign("offsetY", HmcRenderValue(offsetYNew));
                LOGI("CalcExportSizeAndFixOffset offset fix effect name=%s, X=%f, Y=%f, XNew=%f, YNew=%f ",
                    effect->m_name.c_str(), offsetX, offsetY, offsetXNew, offsetYNew);
            }
        }
        exportSize.width =  exportSize.width / image->downSampleScale;
        exportSize.height = exportSize.height / image->downSampleScale;
        LOGI("CalcExportSizeAndFixOffset originalPicture used scale:%f, w=%d, h=%d, scaleW=%d, sacleH=%d",
            image->downSampleScale, canvas.canvasWidth_, canvas.canvasHeight_, exportSize.width, exportSize.height);
    }
    return exportSize;
}

std::future<ExportData> HmcRenderEngine::Export(VECTOR<HmcRenderLayerPtr> &renderLayers, const HmcRenderCanvas &canvas,
    const ExportParam &param)
{
std:
    std::lock_guard<std::recursive_mutex> guard(m_renderMutex);
    m_exported = TRUE;
    LOGI("Export in");
    
    ComposeFilterInit::getInstance().initialize();

    auto prom = std::make_shared<std::promise<ExportData>>();
    std::future<ExportData> fut = prom->get_future();
    if (!m_ready) {
        LOGE("[Render]Not Ready! Export Frame %ld, Engine : %ld\n", param.id, m_id);
        m_exported = FALSE;
        prom->set_value(ExportData());
        return fut;
    }
    auto taskId = RequestTaskId();
    SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers = UpdateCache(renderLayers, taskId);
    
    auto weakThis = weak_from_this();
    auto task = std::make_shared<RenderTask<>>(
        [weakThis, layers, canvas, taskId, prom, param]() {
            LOGI("[Render]Export Frame start running, id: %ld, taskId: %d", param.id, taskId);
            auto strong = weakThis.lock();
            if (strong == nullptr || layers == nullptr) {
                LOGE("HmcRenderEngine::Export strong is nullptr = %d", strong == nullptr);
                if (strong != nullptr) {
                    strong->m_exported = FALSE;
                }
                prom->set_value(param.func(nullptr, canvas.canvasWidth_, canvas.canvasHeight_, param.id));
                return;
            }
            Image_Size exportSize = strong->CalcExportSizeAndFixOffset(layers, canvas);
            HmcRenderCanvas cvs = static_cast<HmcRenderCanvas>(canvas);
            cvs.canvasWidth_ = exportSize.width;
            cvs.canvasHeight_ = exportSize.height;
            HmcEFilterPtr config = strong->m_efilterList["config"];
            strong->RemoveFilters();
            VECTOR<SHARED_PTR<Image>> images;
            for (auto &layerInfo : *layers) {
                RenderEngineType type = param.exportType == EXPORT_TYPE_SAVE ? TYPE_SAVE : TYPE_EXPORT;
                images.emplace_back(strong->ConfigRenderInfo(layerInfo, config, type, cvs, param.needRGBA));
            }
            if (param.encodeType == 0) {
                if (strong->m_isSurfaceOutput) {
                    strong->m_isSurfaceOutput = false;
                    OH_ImageEffect_SetOutputSurface(strong->mImageEffect, nullptr);
                }
                OH_PixelmapNative *outPixelMap = strong->GenerateOutputPixelmap(layers, cvs, param.exportType, taskId);
                OH_PictureNative* outPicture;
                OH_PictureNative_CreatePicture(outPixelMap, &outPicture);
                OH_PixelmapNative_Release(outPixelMap);
                prom->set_value(param.func(outPicture, cvs.canvasWidth_, cvs.canvasHeight_, param.id));
            }
            images.clear();
            strong->m_exported = FALSE;
        },
        EXPORT_TASK_TAG, taskId);
    m_renderThread->AddTask(task);
    m_lastExportTaskFuture = task->GetFuture();
    return fut;
}

OH_PixelmapNative *HmcRenderEngine::GenerateOutputPixelmap(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers,
    HmcRenderCanvas canvas, UINT32 exportType, INT32 taskId)
{
    INT32 w = canvas.canvasWidth_;
    INT32 h = canvas.canvasHeight_;
    LOGI("[Render]Export Frame GenerateOutputPixelmap start, width=%d, height=%d", w, h);

    OH_PixelmapNative *outPixelMap = CreateOutputPixelmap(layers, w, h, exportType);
    if (outPixelMap == nullptr) {
        LOGE("outPixelMap is nullptr");
        return nullptr;
    }
    
    OH_HiTrace_StartTrace("ImageEditorRenderExport");
    OH_ImageEffect_Start(mImageEffect);
    
    OH_HiTrace_FinishTrace();
    
    return outPixelMap;
}

OH_PictureNative *HmcRenderEngine::GenerateOutputPicture(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers,
    HmcRenderCanvas canvas, const ExportParam &param, INT32 taskId)
{
    INT32 w = canvas.canvasWidth_;
    INT32 h = canvas.canvasHeight_;
    LOGI("[Render]Export Frame CreateOutputPicture start, width=%d, height=%d", w, h);

    OH_PictureNative *outPicture = CreateOutputPicture(layers, w, h, param.exportType);
    if (outPicture == nullptr) {
        LOGE("outPicture is nullptr");
        return nullptr;
    }

    if (mIsHMCRenderEnable) {
        int needRGBAOutput = param.needRGBA;
        ConfigValue(mImageEffect, &needRGBAOutput, CONFIG_RENDER_RGBA_OUTPUT,
                    ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
    }
    
    ImageEffect_ErrorCode code = OH_ImageEffect_Save(mImageEffect, &exportInfo_);
    LOGI("OH_ImageEffect_Save: %d %s", code, exportInfo_);
    OH_HiTrace_StartTrace("ImageEditorRenderExport");
    OH_ImageEffect_Start(mImageEffect);

    OH_HiTrace_FinishTrace();
    
    LOGI("GenerateOutputPicture exportType:%d", param.exportType);
    if (param.exportType == EXPORT_TYPE_SAVE && layers != nullptr && !layers->empty()) {
    }

    if (param.addWatermark) {
        OH_HiTrace_StartTrace("SetFragment");
        SetFragment(outPicture, layers, w, h);
        OH_HiTrace_FinishTrace();
    }
    return outPicture;
}

OH_PixelmapNative *HmcRenderEngine::CreateOutputPixelmap(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, INT32 w, INT32 h,
    UINT32 exportType)
{
    auto tex = layers->at(0)->m_textureList.find(MAIN_TEX)->second;
    if (tex == nullptr) {
        LOGE("CreateOutputPicture tex is nullptr");
        return nullptr;
    }
    SHARED_PTR<Image> image = tex->GetImage();
    if (image == nullptr) {
        LOGE("CreateOutputPicture image is nullptr");
        return nullptr;
    }
    OH_PictureNative *inPicture = nullptr;
    if (image->originalPicture != nullptr && m_renderType != RenderType::THUMBNAIL) {
        inPicture = image->originalPicture;
        LOGI("originalPicture used CreateOutputPicture");
    } else {
        inPicture = image->nativePicture;
    }

    OH_PictureNative *outPicture = CopyPicture(inPicture, w, h, false, exportType != 1);
    inPicture = nullptr;
    if (outPicture == nullptr) {
        LOGE("CreateOutputPicture outPicture is nullptr");
        return nullptr;
    }
    SetColorSpace(outPicture);

    OH_PixelmapNative* outPixelMap = nullptr;
    OH_PictureNative_GetMainPixelmap(outPicture, &outPixelMap);
    OH_ImageEffect_SetOutputPixelmap(mImageEffect, outPixelMap);
    
    OH_PictureNative_Release(outPicture);
    
    m_isSurfaceOutput = false;
    return outPixelMap;
}

OH_PictureNative *HmcRenderEngine::CreateOutputPicture(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, INT32 w, INT32 h,
    UINT32 exportType)
{
    auto tex = layers->at(0)->m_textureList.find(MAIN_TEX)->second;
    if (tex == nullptr) {
        LOGE("CreateOutputPicture tex is nullptr");
        return nullptr;
    }
    SHARED_PTR<Image> image = tex->GetImage();
    if (image == nullptr) {
        LOGE("CreateOutputPicture image is nullptr");
        return nullptr;
    }
    OH_PictureNative *inPicture = nullptr;
    if (image->originalPicture != nullptr && m_renderType != RenderType::THUMBNAIL) {
        inPicture = image->originalPicture;
        LOGI("originalPicture used CreateOutputPicture");
    } else {
        inPicture = image->nativePicture;
    }
    
    OH_PictureNative *outPicture = CopyPicture(inPicture, w, h, false, exportType != 1);
    inPicture = nullptr;
    if (outPicture == nullptr) {
        LOGE("CreateOutputPicture outPicture is nullptr");
        return nullptr;
    }
    SetColorSpace(outPicture);
    OH_ImageEffect_SetOutputPicture(mImageEffect, outPicture);
    m_isSurfaceOutput = false;
    return outPicture;
}

/**
 * positionY = min{positionY1, positionY2}
 * bottom = max{positionY1+height1, positionY2+height2}
 * height = bottom - positionY
 * @param watermarkPtrVector
 * @return [positionY, height]
 */
std::tuple<uint32_t, uint32_t> HmcRenderEngine::CalcAuxPicturePositionAndHeight(
    const VECTOR<SHARED_PTR<WatermarkPicInfo>> &watermarkPtrVector)
{
    if (watermarkPtrVector.empty()) {
        return std::make_tuple(0, 0);
    }
    uint32_t positionY = watermarkPtrVector[0]->positionY;
    for (size_t i = 1; i < watermarkPtrVector.size(); i++) {
        if (watermarkPtrVector[i]->positionY < positionY) {
            positionY = watermarkPtrVector[i]->positionY;
        }
    }

    uint32_t bottom = watermarkPtrVector[0]->positionY + watermarkPtrVector[0]->height;
    for (size_t j = 1; j < watermarkPtrVector.size(); j++) {
        if (watermarkPtrVector[j]->positionY + watermarkPtrVector[j]->height > bottom) {
            bottom = watermarkPtrVector[j]->positionY + watermarkPtrVector[j]->height;
        }
    }
    uint32_t height = bottom - positionY;
    return std::make_tuple(positionY, height);
}

VOID HmcRenderEngine::SetFragment(OH_PictureNative *picture, SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, INT32 w,
                                  INT32 h)
{}

VOID HmcRenderEngine::DrawOnOffScreen(VECTOR<HmcRenderLayerPtr> &renderLayers, const HmcRenderCanvas &canvas) {}

VOID HmcRenderEngine::SetCropRect(int x, int y, int w, int h)
{
    exportCropRect[0] = x;
    exportCropRect[1] = y;
    exportCropRect[2] = w;
    exportCropRect[3] = h;
}

VOID HmcRenderEngine::AddEffect(HmcRenderEffectPtr & /* effect */) {}

VOID HmcRenderEngine::RemoveEffect(const STRING &name) {}

STRING HmcRenderEngine::GetThreadId()
{
    std::ostringstream stream;
    stream << std::this_thread::get_id();
    return stream.str();
}

VOID HmcRenderEngine::InitThread(std::string const & editData)
{
#if R_ENABLE_BENCHMARK
    BENCHMARKTIME(t0);
#endif

    RestoreImageEffect(editData);

#if R_ENABLE_BENCHMARK
    BENCHMARKTIME(t1);
    LOGI("[Render] Render thread init timecost: %lf", BENCHMARKDURATION(t0, t1));
#endif
}

VOID HmcRenderEngine::AbandonAndClearEFilterList()
{
    for (auto &entry : m_efilterList) {
        if (entry.second != nullptr) {
            entry.second->AbandonFilterOwnership();
        }
    }
    m_efilterList.clear();
}

VOID HmcRenderEngine::ReleaseImageEffectOnRenderThread()
{
    AbandonAndClearEFilterList();
    if (mImageEffect != nullptr) {
        OH_ImageEffect_Release(mImageEffect);
        mImageEffect = nullptr;
    }
    m_restoredFilterCount = 0;
}

VOID HmcRenderEngine::ReleaseThread()
{
    ReleaseImageEffectOnRenderThread();
    nativePicture = nullptr;
    LOGI("HmcRenderEngine release imageEffect");
}

BOOL HmcRenderEngine::RegExternalTask(RenderCommonTaskPtr task)
{
std:
    std::lock_guard<std::recursive_mutex> guard(m_renderMutex);
    if (!m_ready) {
        LOGE("[Render] RegExternalTask Not Ready!\n");
        return FALSE;
    }
    if (task == nullptr) {
        LOGE("invalid task");
        return FALSE;
    }
    if (m_renderThread == nullptr) {
        LOGE("render thread has not inited, please check you render engine");
        return FALSE;
    }

    task->SetTag(COMMON_TASK_TAG);
    task->SetId(RequestTaskId());
    m_renderThread->AddTask(task);
    return TRUE;
}

UINT64 HmcRenderEngine::RequestTaskId()
{
    return m_currentTaskId.fetch_add(1);
}

HmcEFilterPtr HmcRenderEngine::GenCropEFilter()
{
    STRING type = "crop";
    if (!m_efilterList.contains(type)) {
        CustomCropFilter::GetInstance().Initialize();
        HmcEFilterPtr filter = std::make_shared<HmcEFilter>("CustomCropFilter", type);
        m_efilterList[type] =  filter;
    }
    
    OH_ImageEffect_AddFilterByFilter(mImageEffect, m_efilterList[type]->GetEFilter());
    return m_efilterList[type];
}

HmcEFilterPtr HmcRenderEngine::GenBrightnessEFilter() {
    STRING type = "brightness";
    
    if (!m_efilterList.contains(type)) {
        HmcEFilterPtr filter = std::make_shared<HmcEFilter>(OH_EFFECT_BRIGHTNESS_FILTER, type);
        m_efilterList[type] =  filter;
    }
    
    OH_ImageEffect_AddFilterByFilter(mImageEffect, m_efilterList[type]->GetEFilter());
    return m_efilterList[type];
}

HmcEFilterPtr HmcRenderEngine::GenContrastEFilter() {
    STRING type = "contrast";
    
    if (!m_efilterList.contains(type)) {
        HmcEFilterPtr filter = std::make_shared<HmcEFilter>(OH_EFFECT_CONTRAST_FILTER, type);
        m_efilterList[type] =  filter;
    }
    
    OH_ImageEffect_AddFilterByFilter(mImageEffect, m_efilterList[type]->GetEFilter());
    return m_efilterList[type];
}

bool IsSameAdjust(HmcRenderEffectPtr effect, HmcRenderEffectPtr preEffect)
{
    for (int i = 0; i < ADJUST_ITEM.size(); i++) {
        double value;
        double preValue;
        effect->GetParam(ADJUST_ITEM[i], value);
        preEffect->GetParam(ADJUST_ITEM[i], preValue);
        if (!fabs(value - preValue) < HMC_FLOAT_EPSINON) {
            return false;
        }
    }
    for (int i = 0; i < ADJUST_ITEM_STATUS.size(); i++) {
        int value;
        int preValue;
        effect->GetParam(ADJUST_ITEM_STATUS[i], value);
        preEffect->GetParam(ADJUST_ITEM_STATUS[i], preValue);
        if (value != preValue) {
            return false;
        }
    }
    return true;
}

bool IsSameFilter(HmcRenderEffectPtr effect, HmcRenderEffectPtr preEffect)
{
    return effect->m_resource->m_effectName.compare(preEffect->m_resource->m_effectName) == 0;
}

void HmcRenderEngine::ProcessComposeEffect(HmcRenderLayerPtr &layerInfo, RenderEngineType &type,
    unsigned int &needRGBA, HmcRenderEffectPtr &effect)
{
    if (effect->m_resource->m_effectType == "compose" && (type == TYPE_EXPORT || type == TYPE_SAVE)) {
        effect->SetParam("renderType", 1.0);
        int tempNeedRGBA = static_cast<int>(needRGBA);
        effect->SetParam("outPutFormat", tempNeedRGBA);
        for (auto &checkEffect : layerInfo->m_effectList) {
            if (checkEffect->m_resource->m_effectType == "transform") {
                    checkEffect->SetParam("outPutFormat", 0);
            }
        }
    }
}

bool HmcRenderEngine::IsSameXtStyleFilter(HmcRenderEffectPtr effect, HmcRenderEffectPtr preEffect)
{
    int type = 0;
    int preType = 0;
    effect->GetParam(PROJECT_KEY_XTSTYLE_TYPE, type);
    preEffect->GetParam(PROJECT_KEY_XTSTYLE_TYPE, preType);
    
    for (int i = 0; i < XTSTYLE_ITEM.size(); i++) {
        double value;
        double preValue;
        effect->GetParam(XTSTYLE_ITEM[i], value);
        preEffect->GetParam(XTSTYLE_ITEM[i], preValue);
        if (!fabs(value - preValue) < HMC_FLOAT_EPSINON) {
            return false;
        }
    }
    return type == preType;
}

bool HmcRenderEngine::isFilterEffectChange(HmcRenderEffectPtr filterEffect, HmcRenderEffectPtr preFilterEffect)
{
    return (filterEffect == nullptr && preFilterEffect != nullptr) ||
        (filterEffect != nullptr && preFilterEffect == nullptr) ||
        (filterEffect != nullptr && preFilterEffect != nullptr && !IsSameFilter(preFilterEffect, filterEffect));
}

bool HmcRenderEngine::isAdjustEffectChange(HmcRenderEffectPtr adjustEffect, HmcRenderEffectPtr preAdjustEffect)
{
    return (adjustEffect == nullptr && preAdjustEffect != nullptr) ||
        (adjustEffect != nullptr && preAdjustEffect == nullptr) ||
        (adjustEffect != nullptr && preAdjustEffect != nullptr && !IsSameAdjust(preAdjustEffect, adjustEffect));
}

bool HmcRenderEngine::isXtStyleEffectChange(HmcRenderEffectPtr xtStyleEffect, HmcRenderEffectPtr preXtStyleEffect)
{
    return  (xtStyleEffect == nullptr && preXtStyleEffect != nullptr) ||
        (xtStyleEffect != nullptr && preXtStyleEffect == nullptr) ||
        (xtStyleEffect != nullptr && preXtStyleEffect != nullptr &&
            !IsSameXtStyleFilter(xtStyleEffect, preXtStyleEffect));
}

void HmcRenderEngine::CacheTransform(HmcRenderLayerPtr &layerInfo)
{
    HmcRenderEffectPtr filterEffect = nullptr;
    HmcRenderEffectPtr preFilterEffect = nullptr;
    HmcRenderEffectPtr adjustEffect = nullptr;
    HmcRenderEffectPtr preAdjustEffect = nullptr;
    HmcRenderEffectPtr xtStyleEffect = nullptr;
    HmcRenderEffectPtr preXtStyleEffect = nullptr;
    if (m_pre_effectList.size() == 0 || !m_efilterList.contains("transform")) {
        LOGD("ProcessTransformCache skip empty transform list");
        return;
    }
    HmcEFilterPtr transform = m_efilterList["transform"];
    for (auto &effect : layerInfo->m_effectList) {
        if (effect->m_resource->m_effectType == "adjust") {
            adjustEffect = effect;
        }
        if (effect->m_resource->m_effectType == "filter") {
            filterEffect = effect;
        }
        if (effect->m_resource->m_effectType == XTSTYLE_FILTER_NAME) {
            xtStyleEffect = effect;
        }
    }

    for (auto &effect : m_pre_effectList) {
        if (effect->m_resource->m_effectType == "adjust") {
            preAdjustEffect = effect;
        }
        if (effect->m_resource->m_effectType == "filter") {
            preFilterEffect = effect;
        }
        if (effect->m_resource->m_effectType == XTSTYLE_FILTER_NAME) {
            preXtStyleEffect = effect;
        }
    }
    bool filterChange = isFilterEffectChange(filterEffect, preFilterEffect);
    bool adjustChange = isAdjustEffectChange(adjustEffect, preAdjustEffect);
    bool xtStyleChange = isXtStyleEffectChange(xtStyleEffect, preXtStyleEffect);
    bool needCache = !filterChange && !adjustChange && !xtStyleChange;

    if (!needCache && transform && transform->HasStartCache()) {
        transform->CancelCache();
    } else if (needCache && transform && !transform->HasStartCache()) {
        transform->StartCache();
    }
}

void HmcRenderEngine::ProcessTransformCache(HmcRenderLayerPtr &layerInfo, RenderEngineType type)
{
    if (m_renderType == RenderType::THUMBNAIL) {
        if (m_efilterList.contains("transform")) {
            HmcEFilterPtr transform = m_efilterList["transform"];
            if (transform && transform->HasStartCache()) {
                transform->CancelCache();
            }
        }
        return;
    }
    // 导出不走缓存，可能导致HDR图和HDR图使用缓存不一致问题
    if (type == TYPE_EXPORT) {
        return;
    }
    if (!layerInfo->m_IsSwitchPage && layerInfo->m_IsInPreviewMode && !layerInfo->m_isDragImage) {
        if (m_efilterList.contains("transform")) {
            HmcEFilterPtr transform = m_efilterList["transform"];
            if (transform && transform->HasStartCache()) {
                transform->CancelCache();
            }
        }
        return;
    }
    CacheTransform(layerInfo);
}

RenderInputType HmcRenderEngine::GetInputType(std::shared_ptr<Image> &image, RenderEngineType type)
{
    // 导出，非预览，且非缩略图生成时使用原图渲染
    if (TYPE_PREVIEW != type && image->originalPicture != nullptr && m_renderType != RenderType::THUMBNAIL) {
        return RenderInputType::ORIGINAL;
    }
    // HDR显示关闭时使用SDR渲染
    if (!image->isHdrShownOpen && image->nativeDrawPicture != nullptr) {
        return RenderInputType::SDR;
    }
    return RenderInputType::PREVIEW;
}

bool HmcRenderEngine::SetInputPixelMap(std::shared_ptr<Image> &image, RenderEngineType type)
{
    bool isPictureChange = nativePicture != image->nativePicture && nativePicture != nullptr;
    RenderInputType inputType = GetInputType(image, type);
    LOGD("SetInputPixelMap inputType=%d, lastInputType=%d, renderType=%d, m_renderType=%d, isPictureChange=%d",
         inputType, m_lastRenderInputType, type, m_renderType, isPictureChange);

    nativePicture = image->nativePicture;
    OH_PictureNative *inputPicture = nullptr;
    switch (inputType) {
    case SDR:
        inputPicture = image->nativeDrawPicture;
        break;
    case ORIGINAL:
        inputPicture = image->originalPicture;
        break;
    case PREVIEW:
        inputPicture = image->nativePicture;
        break;
    default:
        LOGE("RenderInputType not supported: %d", inputType);
        return false;
    }
    LOGD("SetInputPixelMap set lastRenderInputType=%d", inputType);
    m_lastRenderInputType = inputType;

    OH_PixelmapNative* pixelMap = nullptr;
    OH_PictureNative_GetMainPixelmap(inputPicture, &pixelMap);
    inputPicture = nullptr;
    
    if (pixelMap == nullptr) {
        LOGE("SetInputPixelmap");
    }
    ImageEffect_ErrorCode code = OH_ImageEffect_SetInputPixelmap(mImageEffect, pixelMap);
    OH_PixelmapNative_Release(pixelMap);
    if (code != ImageEffect_ErrorCode::EFFECT_SUCCESS) {
        LOGE("ConfigRenderInfo SetInputPicture failed: %d", code);
        return false;
    }
    return true;
}

VOID HmcRenderEngine::RemoveFilters()
{
    int size = OH_ImageEffect_GetFilterCount(mImageEffect);
    while (size > m_restoredFilterCount) {
        OH_ImageEffect_RemoveFilterByIndex(mImageEffect, m_restoredFilterCount);
        size--;
    }
}
SHARED_PTR<Image> HmcRenderEngine::ConfigRenderInfo(HmcRenderLayerPtr &layerInfo, HmcEFilterPtr config,
    RenderEngineType type, const HmcRenderCanvas &canvas, UINT32 needRGBA)
{
    auto tex = layerInfo->m_textureList.find(MAIN_TEX)->second;
    if (tex == nullptr) {
        LOGE("ConfigRenderInfo tex is nullptr");
        return nullptr;
    }

    SHARED_PTR<Image> image = tex->GetImage();
    if (image == nullptr || image->nativePicture == nullptr) {
        LOGE("ConfigRenderInfo pixelmap is nullptr");
        return nullptr;
    }
    if (!SetInputPixelMap(image, type)) {
        return nullptr;
    }
    
    GenBrightnessEFilter();
    GenContrastEFilter();
    LOGD("HmcRenderEngine::ConfigRenderInfo m_IsInPreviewMode %d, m_IsSwitchPage %d, m_isDragImage %d",
        layerInfo->m_IsInPreviewMode, layerInfo->m_IsSwitchPage, layerInfo->m_isDragImage);
    bool enableCropEfilter = layerInfo->m_IsInPreviewMode && !layerInfo->m_IsSwitchPage && !layerInfo->m_isDragImage;
    // 部分机型/链路在进入裁剪界面时 m_IsInPreviewMode 仍为 0，但 transform 的 cropEnable=1 已经生效；
    // 同时我们会跳过 transform 原生滤镜（避免依赖 libimage_effect_ext.so），因此必须保证 CustomCropFilter 被启用来承担几何变换。
    if (!enableCropEfilter) {
        for (auto &e : layerInfo->m_effectList) {
            if (e && e->m_resource && e->m_resource->m_effectType == "transform") {
                DOUBLE cropEnable = 0.0;
                if (e->GetParam("cropEnable", cropEnable) && cropEnable > 0.5) {
                    enableCropEfilter = true;
                    break;
                }
            }
        }
    }
    HmcEFilterPtr cropEfilter = enableCropEfilter ? GenCropEFilter() : nullptr;
    bool useOrgSize = type != TYPE_PREVIEW && image->originalPicture != nullptr &&
        m_renderType != RenderType::THUMBNAIL;
    for (auto &effect : layerInfo->m_effectList) {
        LOGD("[Render]effectType: %s", effect->m_resource->m_effectType.c_str());
        if (effect->m_resource->m_effectType == "adjust") {
            if (m_efilterList.contains("brightness")) {
                double brightnessValue = -100;
                effect->GetParam("BRIGHTNESS", brightnessValue);
                ImageEffect_Any value;
                value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT;
                value.dataValue.floatValue = 100 * brightnessValue;
                OH_EffectFilter_SetValue(m_efilterList["brightness"]->GetEFilter(), OH_EFFECT_FILTER_INTENSITY_KEY, &value);
            }
            if (m_efilterList.contains("contrast")) {
                double contrastValue = -100;
                effect->GetParam("CONTRAST", contrastValue);
                ImageEffect_Any value;
                value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT;
                value.dataValue.floatValue = 100 * contrastValue;
                OH_EffectFilter_SetValue(m_efilterList["contrast"]->GetEFilter(), OH_EFFECT_FILTER_INTENSITY_KEY, &value);
            }
        }
        if (effect->m_resource->m_effectType == "transform") {
            ProcessEffect(type, effect, layerInfo);
            int tempNeedRGBA = (int)needRGBA;
            effect->SetParam("outPutFormat", tempNeedRGBA);
            INT32 baseRotationDeg = 0;
            if (tex != nullptr) {
                baseRotationDeg = tex->GetRotation();
            }
            CalculateEffectiveArea(effect, canvas, useOrgSize ? image->originalWidth : image->width,
                useOrgSize ? image->originalHeight : image->height, cropEfilter, baseRotationDeg,
                layerInfo->m_isDragImage);
        }
        ProcessComposeEffect(layerInfo, type, needRGBA, effect);
    }

    ProcessTransformCache(layerInfo, type);
    ConfigEffectFilter(layerInfo, type, canvas, image);

    // 导出的时候不用更新上一次渲染效果器记录，避免缩略图导出影响渲染效果
    if (type == TYPE_EXPORT) {
        return image;
    }
    m_pre_effectList = layerInfo->m_effectList;
    return image;
}

VOID HmcRenderEngine::ConfigEffectFilter(HmcRenderLayerPtr &layerInfo, RenderEngineType type,
    const HmcRenderCanvas &canvas, SHARED_PTR<Image> image)
{
    for (auto &effect : layerInfo->m_effectList) {
        LOGD("HmcRenderEngine::ConfigEffectFilter m_effectType:%s", effect->m_resource->m_effectType.c_str());
        // 剪裁界面预览：不允许依赖扩展 so（libimage_effect_ext.so）时，transform 对应的原生滤镜创建会失败并刷屏。
        // 注意：部分链路中 layerInfo->m_IsInPreviewMode 在裁剪时为 0，但 transform 参数里的 cropEnable=1 能可靠表征裁剪状态。
        if (effect->m_resource->m_effectType == "transform") {
            DOUBLE cropEnable = 0.0;
            if (effect->GetParam("cropEnable", cropEnable) && cropEnable > 0.5) {
                LOGD("ConfigEffectFilter skip native transform filter (cropEnable=1)");
                continue;
            }
        }
        ConfigEFilter(effect, type);
    }
}

HmcSurfaceTexture *HmcRenderEngine::CreateSurfaceTexture()
{
    return nullptr;
}

VOID HmcRenderEngine::InitInnerEffect(VOID *e) {}

VOID HmcRenderEngine::ConfigEFilter(HmcRenderEffectPtr effect, HmcEFilterPtr efilter, RenderEngineType type)
{
    for (auto &kv : effect->m_effectParam) {
        STRING tempKey = static_cast<STRING>(kv.first);
        HmcRenderValue value = kv.second;
        switch (value.GetType()) {
            case HmcRenderValue::TYPE_INT: {
                INT32 temp = value.Get<INT32>();
                efilter->SetValue(&temp, tempKey.c_str(), ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
                if (type == TYPE_EXPORT || type == TYPE_SAVE) {
                    LOGD("ConfigEFilter key: %s, value: %d", tempKey.c_str(), temp);
                } else {
                    LOGD("ConfigEFilter key: %s, value: %d", tempKey.c_str(), temp);
                }
                break;
            }
            case HmcRenderValue::TYPE_DOUBLE: {
                DOUBLE temp = value.Get<DOUBLE>();
                efilter->SetValue(&temp, tempKey.c_str(), ImageEffect_DataType::EFFECT_DATA_TYPE_DOUBLE);
                if (type == TYPE_EXPORT || type == TYPE_SAVE) {
                    LOGD("ConfigEFilter key: %s, value: %f", tempKey.c_str(), temp);
                } else {
                    LOGD("ConfigEFilter key: %s, value: %f", tempKey.c_str(), temp);
                }
                break;
            }
            case HmcRenderValue::TYPE_PTR: {
                VOID *temp = value.Get<VOID *>();
                efilter->SetValue(temp, tempKey.c_str(), ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
                break;
            }
            default:
                LOGE("Set Value: unsupport type: %d  key: %s", value.GetType(), tempKey.c_str());
        }
    }
}

VOID HmcRenderEngine::ConfigEFilter(HmcRenderEffectPtr effect, RenderEngineType type)
{
    // 优先按资源的 effectName 创建；失败再尝试 HMCEFilter。
    // 线上日志显示部分环境缺少 libimage_effect_ext.so，会导致 HMCEFilter 创建失败；
    // 同时也存在部分环境 transform 不是扩展滤镜，直接用 "transform" 创建才可用。
    std::string createName = "HMCEFilter";
    if (!m_efilterList.contains(effect->m_resource->m_effectType)
        || m_efilterList[effect->m_resource->m_effectType] == nullptr) {
        if (effect->m_resource->m_effectType == "compose") {
            createName = "ComposeFilter";
        } else if (effect->m_resource->m_effectType == "transform" && !effect->m_resource->m_effectName.empty()) {
            createName = effect->m_resource->m_effectName; // usually "transform"
        }
        HmcEFilterPtr filter = std::make_shared<HmcEFilter>(createName, effect->m_resource->m_effectType);
        m_efilterList[effect->m_resource->m_effectType] = filter;

        // transform 尝试降级：如果按 effectName 创建失败，再尝试 HMCEFilter
        if (effect->m_resource->m_effectType == "transform") {
            OH_EffectFilter *nativeTry = filter != nullptr ? filter->GetEFilter() : nullptr;
            if (nativeTry == nullptr && createName != "HMCEFilter") {
                LOGW("ConfigEFilter transform create failed by name=%s, fallback to HMCEFilter",
                    createName.c_str());
                filter = std::make_shared<HmcEFilter>("HMCEFilter", effect->m_resource->m_effectType);
                m_efilterList[effect->m_resource->m_effectType] = filter;
            }
            // 缓存开关仅在滤镜可用时开启
            if (filter != nullptr && filter->GetEFilter() != nullptr) {
                filter->StartCache();
            }
        }
    }
    HmcEFilterPtr efilter = m_efilterList[effect->m_resource->m_effectType];
    OH_EffectFilter *native = efilter != nullptr ? efilter->GetEFilter() : nullptr;
    if (native == nullptr) {
        LOGE("ConfigEFilter failed, native filter is null. effectType=%s",
            effect->m_resource->m_effectType.c_str());
        // 下次渲染重新创建，避免持有一个永久为空的filter对象
        m_efilterList[effect->m_resource->m_effectType] = nullptr;
        return;
    }
    OH_ImageEffect_AddFilterByFilter(mImageEffect, native);
    efilter->SetValue(&effect->m_name, "m_name", ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    efilter->SetValue(&(effect->m_inTex.begin()->key), "m_inTex",
        ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    efilter->SetValue(&effect->m_outTex, "m_outTex", ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    efilter->SetValue(&effect->m_resource->m_effectName, "m_effectName",
        ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    efilter->SetValue(&effect->m_resource->m_effectType, "m_effectType",
        ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    ConfigEFilter(effect, efilter, type);
}

void HmcRenderEngine::UpdateTransformParam(HmcRenderEffectPtr &effect, HmcEFilterPtr nativeEffect, TransformInfo *&info)
{
    effect->SetParam("viewportX", info->viewportX);
    effect->SetParam("viewportY", info->viewportY);
    effect->SetParam("srcW", info->srcW);
    effect->SetParam("srcH", info->srcH);
    if (nativeEffect == nullptr) {
        effect->SetParam("roiL", 0.0);
        effect->SetParam("roiR", 1.0);
        effect->SetParam("roiB", 0.0);
        effect->SetParam("roiT", 1.0);
    } else {
        effect->SetParam("roiL", (DOUBLE)info->minXint / info->srcW);
        effect->SetParam("roiR", (DOUBLE)info->maxXint / info->srcW);
        effect->SetParam("roiB", (DOUBLE)info->minYint / info->srcH);
        effect->SetParam("roiT", (DOUBLE)info->maxYint / info->srcH);
    }
}

VOID HmcRenderEngine::CalculateEffectiveArea(HmcRenderEffectPtr effect, const HmcRenderCanvas &canvas, INT32 width,
    INT32 height, HmcEFilterPtr cropEfilter, INT32 baseRotationDeg, bool isDragImage)
{
    TransformInfo *info = new TransformInfo();
    info->srcW = width;
    info->srcH = height;
    VECTOR<Vec2> crossArea{ { 0.0, 0.0 }, { info->srcW, 0.0 }, { info->srcW, info->srcH }, { 0.0, info->srcH } };
    info->mirrorH = (INT32)effect->m_effectParam["mirrorH"].Get<DOUBLE>();
    info->mirrorV = (INT32)effect->m_effectParam["mirrorV"].Get<DOUBLE>();
    GenTransformInfo(effect, info);
    info->viewportX = canvas.canvasWidth_;
    info->viewportY = canvas.canvasHeight_;
    UpdateCrossArea(info, crossArea);
    GetLimit(info, crossArea);

    UpdateTransformParam(effect, cropEfilter, info);
    INT32 roiW = info->maxXint - info->minXint;
    INT32 roiH = info->maxYint - info->minYint;

    // 确定缩小后大小
    INT32 finalW = (INT32)(info->scaleX * info->ratioX * roiW + HALF_FOR_CALCULATE);
    INT32 finalH = (INT32)(info->scaleY * info->ratioY * roiH + HALF_FOR_CALCULATE);
    finalW = roiW < finalW ? roiW : finalW;
    finalH = roiH < finalH ? roiH : finalH;
    if (cropEfilter == nullptr) {
        LOGD("cropEfilter == nullptr");
        delete info;
        return;
    }
    
    cropEfilter->SetValue(&info->viewportX, "viewportX", EFFECT_DATA_TYPE_INT32);
    cropEfilter->SetValue(&info->viewportY, "viewportY", EFFECT_DATA_TYPE_INT32);
    cropEfilter->SetValue(&info->srcW, "srcW", EFFECT_DATA_TYPE_INT32);
    cropEfilter->SetValue(&info->srcH, "srcH", EFFECT_DATA_TYPE_INT32);
    cropEfilter->SetValue(&info->offsetX, "offsetX", EFFECT_DATA_TYPE_FLOAT);
    cropEfilter->SetValue(&info->offsetY, "offsetY", EFFECT_DATA_TYPE_FLOAT);
    cropEfilter->SetValue(&info->scaleX, "scaleX", EFFECT_DATA_TYPE_FLOAT);
    cropEfilter->SetValue(&info->scaleY, "scaleY", EFFECT_DATA_TYPE_FLOAT);
    cropEfilter->SetValue(&info->ratioX, "ratioX", EFFECT_DATA_TYPE_FLOAT);
    cropEfilter->SetValue(&info->ratioY, "ratioY", EFFECT_DATA_TYPE_FLOAT);
    // CustomCropFilter内部算法需要感知transform的平面旋转角度（rotationZ，单位：degree）
    float rotationZ = (FLOAT)effect->m_effectParam["rotationZ"].Get<DOUBLE>();
    // 90°旋转存放在纹理的 baseRotation（m_rotation）中；导出时 transform.rotationZ 可能为 0，
    // 需要把 baseRotation 合并进来，才能让 CustomCropFilter 真正旋转内容并填满画布。
    float rotationZTotal = rotationZ + static_cast<float>(baseRotationDeg);
    rotationZTotal = fmodf(rotationZTotal, 360.0f);
    if (rotationZTotal < 0.0f) {
        rotationZTotal += 360.0f;
    }
    cropEfilter->SetValue(&rotationZTotal, "rotationZ", EFFECT_DATA_TYPE_FLOAT);
    // 裁剪页微调旋转角（cropRotate，单位：degree）
    float cropRotate = (FLOAT)effect->m_effectParam["cropRotate"].Get<DOUBLE>();
    cropEfilter->SetValue(&cropRotate, "cropRotate", EFFECT_DATA_TYPE_FLOAT);
    INT32 dragImage = isDragImage ? 1 : 0;
    cropEfilter->SetValue(&dragImage, "isDragImage", EFFECT_DATA_TYPE_INT32);
             
    delete info;
}

HmcRenderEffectPtr HmcRenderEngine::CopyParamToWatermark(HmcRenderLayerPtr &layerInfo, const HmcRenderCanvas &canvas)
{
    HmcRenderEffectPtr cropEffect = nullptr;
    HmcRenderEffectPtr watermarkEffect = nullptr;
    for (auto &effect : layerInfo->m_effectList) {
        if (effect->m_resource->m_effectType == "transform") {
            cropEffect = effect;
        }
        if (effect->m_resource->m_effectType == "watermark") {
            watermarkEffect = effect;
        }
    }
    if (cropEffect == nullptr || watermarkEffect == nullptr) {
        LOGE("CopyParamToWatermark: cropEffect is null or watermarkEffect is null.");
        return nullptr;
    }
    TransformInfo *info = new TransformInfo();
    GenTransformInfo(cropEffect, info);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_LB_X, info->lbX);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_LB_Y, info->lbY);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_RT_X, info->rtX);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_RT_Y, info->rtY);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, info->cropTransformOffsetX);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, info->cropTransformOffsetY);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_SCALE_X, info->cropTransformScaleX);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_CROP_SCALE_Y, info->cropTransformScaleY);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_X, info->scaleX);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_RATIO_X, info->ratioX);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_VIEWPORT_X, canvas.canvasWidth_);
    watermarkEffect->SetParam(PROJECT_KEY_TRANSFORM_VIEWPORT_Y, canvas.canvasHeight_);
    delete info;

    return watermarkEffect;
}

VOID HmcRenderEngine::ProcessWatermarkEffect(HmcRenderLayerPtr &layerInfo, RenderEngineType type,
                                             const HmcRenderCanvas &canvas, SHARED_PTR<Image> image)
{
    HmcRenderEffectPtr effect = CopyParamToWatermark(layerInfo, canvas);
    if (effect == nullptr) {
        LOGE("ProcessWatermarkEffect: watermarkEffect is null.");
        return;
    }
    bool isPreviewMode = layerInfo->m_IsInPreviewMode;
    int watermarkType = effect->m_effectParam["watermarkType"].Get<INT32>();
    int isAlwaysShow = effect->m_effectParam["isAlwaysShow"].Get<INT32>();
    float opacity = (FLOAT)effect->m_effectParam["opacity"].Get<DOUBLE>();
    LOGI("watermark  type = %d, isPreviewMode = %d, isAlwaysShow = %d", watermarkType, isPreviewMode ? 1 : 0,
         isAlwaysShow);
    if (type == TYPE_EXPORT || type == TYPE_SAVE) {
        LOGI("render without watermark.");
        return;
    }
    if ((watermarkType == HMC_ASSET_NO_STICKER || !isPreviewMode) && isAlwaysShow == 0) {
        LOGI("render without watermark.");
        return;
    }

    if (!layerInfo->m_isDrawWaterMark) {
        LOGI("render without watermark because DrawWaterValue is false.");
        return;
    }
}

VOID HmcRenderEngine::AddWatermarkImage(HmcRenderEffectPtr effect, const HmcRenderCanvas &canvas,
                                        VECTOR<SHARED_PTR<WatermarkPicInfo>> watermarkPicInfoVector, int &index,
                                        double opacity)
{
    for (int i = 0; i < watermarkPicInfoVector.size(); i++) {
        LOGI("AddWatermarkImage. index=%d, id=%s", i, watermarkPicInfoVector[i]->id.c_str());
        effect->SetParam("mipmapPixelmap", (VOID *)(watermarkPicInfoVector[i]->nativePixelmap));
        effect->SetParam("mipmapTag", (VOID *)&watermarkPicInfoVector[i]->id);
        effect->SetParam("mipmapFormat", (watermarkPicInfoVector[i]->type == HMC_ASSET_IN_PLACE_STICKER ||
                                          watermarkPicInfoVector[i]->type == HMC_ASSET_RENEWAL_STICKER ||
                                          watermarkPicInfoVector[i]->type == HMC_ASSET_PERSONALIZED_STICKER_STYLE2)
                                             ? 1.0
                                             : 0.0);
        effect->SetParam("cacheId", (VOID *)&m_watermarkCacheId);

        CalculateWatermarkPosition(effect, watermarkPicInfoVector[i], canvas);
        HmcEFilterPtr filter = AddTexMappingEFilter(effect, index);
        double _opacity = opacity;
        filter->SetValue(&_opacity, "opacity", ImageEffect_DataType::EFFECT_DATA_TYPE_DOUBLE);
        index++;
    }
}

HmcEFilterPtr HmcRenderEngine::AddTexMappingEFilter(HmcRenderEffectPtr effect, int &index)
{
    STRING type = "mipmap";
    STRING m_name = type + std::to_string(index);
    LOGI("AddTexMappingEFilter. index=%d, m_name=%s", index, m_name.c_str());
    if (!m_efilterList.contains(m_name)) {
        LOGI("AddTexMappingEFilter: create HMCEFilter for mipmap.");
        HmcEFilterPtr filter = std::make_shared<HmcEFilter>("HMCEFilter", type);
        m_efilterList[m_name] = filter;
    }
    HmcEFilterPtr filter = m_efilterList[m_name];
    OH_ImageEffect_AddFilterByFilter(mImageEffect, filter->GetEFilter());
    filter->SetValue(&m_name, "m_name", ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    filter->SetValue(&type, "m_effectName", ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    filter->SetValue(&type, "m_effectType", ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    filter->SetValue(&(effect->m_inTex.begin()->key), "m_inTex", ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
    filter->SetValue(&effect->m_outTex, "m_outTex", ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);

    ConfigEFilter(effect, filter, TYPE_PREVIEW);
    return filter;
}

void HmcRenderEngine::CalculateWatermarkPosition(HmcRenderEffectPtr effect,
                                                 SHARED_PTR<WatermarkPicInfo> watermarkPicInfo,
                                                 const HmcRenderCanvas &canvas)
{
    LOGI("CalculateWatermarkPosition begin.");
    int watermarkType = watermarkPicInfo->type;

    double lbx = effect->m_effectParam[PROJECT_KEY_TRANSFORM_CROP_LB_X].Get<DOUBLE>();
    double lby = effect->m_effectParam[PROJECT_KEY_TRANSFORM_CROP_LB_Y].Get<DOUBLE>();
    double rtx = effect->m_effectParam[PROJECT_KEY_TRANSFORM_CROP_RT_X].Get<DOUBLE>();
    double rty = effect->m_effectParam[PROJECT_KEY_TRANSFORM_CROP_RT_Y].Get<DOUBLE>();
    double scaleX = effect->m_effectParam[PROJECT_KEY_TRANSFORM_SCALE_X].Get<DOUBLE>();
    double ratioX = effect->m_effectParam[PROJECT_KEY_TRANSFORM_RATIO_X].Get<DOUBLE>();
    double scale = scaleX * ratioX;
    double right = watermarkPicInfo->margin_right * scale / (double)canvas.canvasWidth_;
    double left = watermarkPicInfo->margin_left * scale / (double)canvas.canvasWidth_;
    double top = watermarkPicInfo->margin_top * scale / (double)canvas.canvasHeight_;
    double bottom = watermarkPicInfo->margin_bottom * scale / (double)canvas.canvasHeight_;

    double LBX = 0;
    double LBY = 0;
    double RTX = 0;
    double RTY = 0;
    if (watermarkType == HMC_ASSET_IN_PLACE_STICKER || watermarkType == HMC_ASSET_RENEWAL_STICKER ||
        watermarkType == HMC_ASSET_PERSONALIZED_STICKER_STYLE2) {
        LBX = lbx + watermarkPicInfo->positionX * scale / (double)canvas.canvasWidth_;
        LBY = rty - watermarkPicInfo->positionY * scale / (double)canvas.canvasHeight_ -
              watermarkPicInfo->height * scale / (double)canvas.canvasHeight_;
        RTX = lbx + watermarkPicInfo->positionX * scale / (double)canvas.canvasWidth_ +
              watermarkPicInfo->width * scale / (double)canvas.canvasWidth_;
        RTY = rty - watermarkPicInfo->positionY * scale / (double)canvas.canvasHeight_;
    } else if (watermarkType == HMC_ASSET_XT_STYLE_FRAME_STICKER || watermarkType == HMC_ASSET_BORDER_STICKER ||
               watermarkType == HMC_ASSET_FROSTED_STICKER || watermarkType == HMC_ASSET_PERSONALIZED_STICKER_STYLE1 ||
               watermarkType == HMC_ASSET_FRAME_STICKER || watermarkType == HMC_ASSET_FESTIVAL_STICKER ||
               watermarkType == HMC_ASSET_NATIONAL_DAY_STICKER) {
        LBX = lbx - left;
        LBY = lby - bottom;
        RTX = rtx + right;
        RTY = rty + top;
    } else {
        LBX = lbx;
        LBY = lby - watermarkPicInfo->margin_bottom * scale / (double)canvas.canvasHeight_;
        RTX = rtx;
        RTY = lby;
    }
    LOGI("LBX=%f, LBY=%f, RTX=%f, RTY=%f", LBX, LBY, RTX, RTY);

    effect->SetParam("mipmapLBX", (DOUBLE)(LBX));
    effect->SetParam("mipmapLBY", (DOUBLE)(LBY));
    effect->SetParam("mipmapRTX", (DOUBLE)(RTX));
    effect->SetParam("mipmapRTY", (DOUBLE)(RTY));
}

VOID HmcRenderEngine::ProcessEffect(RenderEngineType type, HmcRenderEffectPtr effect, HmcRenderLayerPtr &layerInfo)
{
    if (type == TYPE_EXPORT || type == TYPE_SAVE) {
        effect->SetParam("renderType", 1.0);
    } else {
        effect->SetParam("renderType", 0.0);
    }
    bool hasMirror = false;
    for (auto &other : layerInfo->m_effectList) {
        if (other->m_resource->m_effectType == "mirror") {
            effect->SetParam("mirrorH", (DOUBLE)other->m_effectParam["mirrorH"].Get<INT32>());
            effect->SetParam("mirrorV", (DOUBLE)other->m_effectParam["mirrorV"].Get<INT32>());
            hasMirror = true;
        }
    }
    if (!hasMirror) {
        effect->SetParam("mirrorH", (DOUBLE)0.0);
        effect->SetParam("mirrorV", (DOUBLE)0.0);
    }
}

VOID HmcRenderEngine::GenTransformInfo(const HmcRenderEffectPtr &transformEffect,
    TransformInfo *info) const
{
    info->rotateX = (FLOAT)transformEffect->m_effectParam["rotationX"].Get<DOUBLE>();
    info->rotateY = (FLOAT)transformEffect->m_effectParam["rotationY"].Get<DOUBLE>();
    info->scaleX = (FLOAT)transformEffect->m_effectParam["scaleX"].Get<DOUBLE>();
    info->scaleY = (FLOAT)transformEffect->m_effectParam["scaleY"].Get<DOUBLE>();
    info->ratioX = (FLOAT)transformEffect->m_effectParam["ratioX"].Get<DOUBLE>();
    info->ratioY = (FLOAT)transformEffect->m_effectParam["ratioY"].Get<DOUBLE>();
    info->lbX = transformEffect->m_effectParam["cropLBX"].Get<DOUBLE>();
    info->lbY = transformEffect->m_effectParam["cropLBY"].Get<DOUBLE>();
    info->rtX = transformEffect->m_effectParam["cropRTX"].Get<DOUBLE>();
    info->rtY = transformEffect->m_effectParam["cropRTY"].Get<DOUBLE>();
    info->cropTransformOffsetX = transformEffect->m_effectParam["cropOffsetX"].Get<DOUBLE>();
    info->cropTransformOffsetY = transformEffect->m_effectParam["cropOffsetY"].Get<DOUBLE>();
    info->cropTransformScaleX = transformEffect->m_effectParam["cropScaleX"].Get<DOUBLE>();
    info->cropTransformScaleY = transformEffect->m_effectParam["cropScaleY"].Get<DOUBLE>();
    info->cropTransformRotate = transformEffect->m_effectParam["cropRotate"].Get<DOUBLE>();
    info->rotate = (FLOAT)transformEffect->m_effectParam["rotationZ"].Get<DOUBLE>();
    info->offsetX = (FLOAT)transformEffect->m_effectParam["offsetX"].Get<DOUBLE>();
    info->offsetY = (FLOAT)transformEffect->m_effectParam["offsetY"].Get<DOUBLE>();

    info->rotate = info->rotate * PI / HALF_CYCLE;
}

VOID HmcRenderEngine::UpdateCrossArea(TransformInfo *info, std::vector<Vec2> &crossArea) const
{
    FLOAT c = cos(info->rotate);
    FLOAT s = sin(info->rotate);
    Mat2x2 rotateMatrix(c, -s, s, c);
    info->cropTransformRotate = info->cropTransformRotate * PI / HALF_CYCLE;
    FLOAT cpC = cos(info->cropTransformRotate);
    FLOAT cpS = sin(info->cropTransformRotate);
    Mat2x2 cpM(cpC, -cpS, cpS, cpC);
    Vec2 xy[VECTOR_SIZE];
    Vec2 cpCenter = Vec2(info->lbX + info->rtX, info->lbY + info->rtY) * Vec2(HALF_FOR_CALCULATE) *
        Vec2(info->viewportX, info->viewportY);
    for (int i = 0; i < VECTOR_SIZE; i++) {
        xy[i] = DEFAULT_ROI[i];
    }
    for (int i = 0; i < VECTOR_SIZE; i++) {
        xy[i] = cpM *
            ((xy[i] - Vec2(HALF_FOR_CALCULATE)) * Vec2(info->viewportX, info->viewportY) -
            Vec2(info->cropTransformOffsetX, info->cropTransformOffsetY)) /
            Vec2(info->cropTransformScaleX, info->cropTransformScaleY) +
            cpCenter;
        xy[i].y = info->mirrorV < HALF_FOR_CALCULATE ? xy[i].y : (info->viewportY - xy[i].y);
        xy[i].x = info->mirrorH < HALF_FOR_CALCULATE ? xy[i].x : (info->viewportX - xy[i].x);
        xy[i] = rotateMatrix *
            (xy[i] - Vec2(info->viewportX, info->viewportY) * Vec2(HALF_FOR_CALCULATE) -
            Vec2(info->offsetX, info->offsetY)) /
            Vec2(info->scaleX * info->ratioX, info->scaleY * info->ratioY) +
            Vec2(info->srcW, info->srcH) * Vec2(HALF_FOR_CALCULATE);
    }
    UpdateRotate(info->srcW, info->srcH, info->rotateX, info->rotateY, xy);
    crossArea.clear();
    if (info->mirrorV == info->mirrorH) {
        crossArea = MathUtils::GetTwoRectCrossAreaPoints({ 0.0, 0.0 }, { info->srcW, 0.0 }, { info->srcW, info->srcH },
            { 0.0, info->srcH }, xy[LEFT_BOTTOM], xy[RIGHT_BOTTOM], xy[RIGHT_TOP], xy[LEFT_TOP]);
    } else {
        crossArea = MathUtils::GetTwoRectCrossAreaPoints({ 0.0, 0.0 }, { info->srcW, 0.0 }, { info->srcW, info->srcH },
            { 0.0, info->srcH }, xy[LEFT_TOP], xy[RIGHT_TOP], xy[RIGHT_BOTTOM], xy[LEFT_BOTTOM]);
    }
}

VOID HmcRenderEngine::UpdateRotate(int srcW, int srcH, float rotateX, float rotateY, Vec2 *xy) const
{
    if (islessgreater(rotateX, 0.0) || islessgreater(rotateY, 0.0)) {
        Mat4x4 camera(1.0);
        Mat4x4 mvp(1.0);
        Mat4x4 projection = MathUtils::Perspective(MathUtils::Radians(30.0), 1.0, 0.001, 100);
        CameraMatrix(camera);
        if (srcW < srcH) {
            MathUtils::Rotate(mvp, mvp, MathUtils::Radians(rotateX), Vec3(1.0, 0.0, 0.0));
            MathUtils::Rotate(mvp, mvp, MathUtils::Radians(rotateY), Vec3(0.0, 1.0, 0.0));
        } else {
            MathUtils::Rotate(mvp, mvp, MathUtils::Radians(rotateY), Vec3(0.0, 1.0, 0.0));
            MathUtils::Rotate(mvp, mvp, MathUtils::Radians(rotateX), Vec3(1.0, 0.0, 0.0));
        }
        MathUtils::Multiply(mvp, camera, mvp);
        MathUtils::Multiply(mvp, projection, mvp);
        Mat3x3 projMat = MathUtils::CalProj2DInv(mvp);
        for (int i = 0; i < VECTOR_SIZE; i++) {
            xy[i] = xy[i] / Vec2(srcW, srcH);
            Vec3 v3 = Vec3(xy[i], 1.0);
            v3 = projMat * v3;
            v3 = isgreater(v3.z, 0.0f) ? (v3 / v3.z) : (Vec3(DEFAULT_ROI[i], 1.0f));
            xy[i] = Vec2(v3.x, v3.y) * Vec2(srcW, srcH);
        }
    }
}

VOID HmcRenderEngine::CameraMatrix(Mat4x4 &m)
{
    m[CAMERA_MATRIX_X][CAMERA_MATRIX_Y] = -1.0 / tan(CAMERA_MATRIX_ROTATE * PI / HALF_CYCLE);
}

VOID HmcRenderEngine::GetLimit(TransformInfo *info, std::vector<Vec2> &crossArea)
{
    DOUBLE minX = info->srcW;
    DOUBLE maxX = 0.0;
    DOUBLE minY = info->srcH;
    DOUBLE maxY = 0.0;
    for (const auto &v : crossArea) {
        minX = v.x < minX ? v.x : minX;
        maxX = v.x > maxX ? v.x : maxX;
        minY = v.y < minY ? v.y : minY;
        maxY = v.y > maxY ? v.y : maxY;
    }
    if (crossArea.size() == 0 || !isless(minX, maxX) || !isless(minY, maxY)) {
        LOGE("[Render] Render auto clip: INVALID ROI");
    }

    // 区域范围边缘增加一些像素， 如果不到720补齐到720
    if ((maxX - minX) < ALIGN_LENGTH && info->srcW >= ALIGN_LENGTH) {
        DOUBLE addition = ALIGN_LENGTH - (maxX - minX);
        maxX += (info->srcW - maxX) / ((info->srcW - maxX) + minX) * addition;
        minX -= minX / ((info->srcW - maxX) + minX) * addition;
    }
    if ((maxY - minY) < ALIGN_LENGTH && info->srcH >= ALIGN_LENGTH) {
        DOUBLE addition = ALIGN_LENGTH - (maxY - minY);
        maxY += (info->srcH - maxY) / ((info->srcH - maxY) + minY) * addition;
        minY -= minY / ((info->srcH - maxY) + minY) * addition;
    }
    // 稍微增加一些像素
    minX -= EXTRA_PIXEL;
    minY -= EXTRA_PIXEL;
    maxX += EXTRA_PIXEL;
    maxY += EXTRA_PIXEL;

    // 转整数
    info->minXint = (INT32)(minX) / MIN_DEVIDE * MIN_DEVIDE;
    info->minYint = (INT32)(minY) / MIN_DEVIDE * MIN_DEVIDE;
    info->maxXint = ((INT32)(maxX) + MIN_DEVIDE - 1) / MIN_DEVIDE * MIN_DEVIDE;
    info->maxYint = ((INT32)(maxY) + MIN_DEVIDE - 1) / MIN_DEVIDE * MIN_DEVIDE;
    info->minXint = std::clamp(info->minXint, 0, info->srcW);
    info->minYint = std::clamp(info->minYint, 0, info->srcH);
    info->maxXint = std::clamp(info->maxXint, 0, info->srcW);
    info->maxYint = std::clamp(info->maxYint, 0, info->srcH);
}

bool HmcRenderEngine::ProcessXTStyleEFilter(HmcRenderEffectPtr effect)
{
    if (effect->m_resource->m_effectType != XTSTYLE_FILTER_NAME || m_renderType == RenderType::DRAW) {
        LOGE("%s Failed to ProcessXTStyleEFilter, effect type = %s", TAG, effect->m_resource->m_effectType.c_str());
        return false;
    }
    STRING filterName = XTSTYLE_FILTER_NAME;
    auto modeValue = effect->m_effectParam[PROJECT_KEY_XTSTYLE_CREATE_MODE].Get<INT32>();
    if (!m_efilterList.contains(filterName) || lastXtStyleMode != modeValue) {
        LOGI("%s ProcessXTStyleEFilter add %s filter.", TAG, filterName.c_str());
        HmcEFilterPtr filter = std::make_shared<HmcEFilter>(filterName, XTSTYLE_FILTER_NAME);
        if (filter == nullptr || filter->GetEFilter() == nullptr) {
            LOGE("%s Failed to create %s", TAG, filterName.c_str());
            return false;
        }
        m_efilterList[filterName] = filter;
        lastXtStyleMode = modeValue;
    }
    HmcEFilterPtr filter = m_efilterList[filterName];
    OH_ImageEffect_AddFilterByFilter(mImageEffect, filter->GetEFilter());

    // 添加filter的参数, effect里面的数据，就是HmcEffectXTStyle的UpdateRenderInfo里面的数据，在m_effectParam中通过kv方式存储
    for (auto &kv : effect->m_effectParam) {
        STRING tempKey = static_cast<STRING>(kv.first);
        HmcRenderValue value = kv.second;
        switch (value.GetType()) {
            case HmcRenderValue::TYPE_INT: {
                INT32 temp = value.Get<INT32>();
                filter->SetValue(&temp, tempKey.c_str(), ImageEffect_DataType::EFFECT_DATA_TYPE_INT32);
                break;
            }
            case HmcRenderValue::TYPE_DOUBLE: {
                float temp = static_cast<float>(value.Get<DOUBLE>());
                filter->SetValue(&temp, tempKey.c_str(), ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT);
                break;
            }
            case HmcRenderValue::TYPE_PTR: {
                VOID *temp = value.Get<VOID*>();
                if (temp != nullptr) {
                    filter->SetValue(temp, tempKey.c_str(), ImageEffect_DataType::EFFECT_DATA_TYPE_PTR);
                }
                break;
            }
            default:
                LOGE("Set Value: unsupport type: %d  key: %s", value.GetType(), tempKey.c_str());
        }
    }
    return true;
}
// 清理水印贴图的缓存
VOID HmcRenderEngine::CleanWatermarkCache()
{
    std::lock_guard<std::mutex> locker(m_waterMarkMtx);
    m_watermarkCache.clear();
}