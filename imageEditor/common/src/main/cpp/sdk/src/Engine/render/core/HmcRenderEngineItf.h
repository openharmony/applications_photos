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

#ifndef HMCRENDERENGINEITF_H
#define HMCRENDERENGINEITF_H

#include "render/base/RenderBase.h"
#include "HmcEngine.h"

#include "render/core/VisionTransformInfo.h"
#include "render/base/math/MathUtils.h"
#include "render/core/HmcRenderEffect.h"
#include "render/graphic/HmcRenderTexture.h"
#include "render/core/HmcRenderLayer.h"
#include "render/core/HmcRenderCanvas.h"
#include "render/base/task/RenderTask.h"

/**
 * 目前有两个RenderEngine
 * 一个是大图，用于大图的渲染和导出
 * 一个是缩略图，缩略图的RenderEngine只用于导出
 */
enum class RenderType : INT32 {
    DRAW,
    THUMBNAIL
};

class ExportData {
public:
    ExportData() {}
    ExportData(UINT8 *rgba, INT32 w, INT32 h, UINT64 id) : m_data(rgba), m_width(w), m_height(h), m_id(id) {}
    ~ExportData(){};
    UCHAR *m_data = NULL;
    INT32 m_width = 0;
    INT32 m_height = 0;
    UINT64 m_id = 0;
};

typedef std::function<ExportData(OH_PictureNative *picture, INT32 w, INT32 h, UINT64 id)> HmcRenderExportFunc;
typedef std::function<VOID(INT32 code)> HmcRenderResultFunc;

typedef enum RenderEngineType {
    TYPE_PREVIEW = 0x001,
    TYPE_EXPORT = 0x010,
    TYPE_SAVE = 0x011
} SurfaceType;

typedef enum RenderInputType {
    // 初始未设置状态
    UNSET,
    // 渲染使用降采样的预览图
    PREVIEW,
    // 导出时使用原图
    ORIGINAL,
    // 关闭HDR显示时使用SDR图
    SDR
} InputType;

struct ExportParam {
    HmcRenderExportFunc func;
    UINT64 id;
    UINT32 encodeType = 0;
    UINT32 needRGBA = 1;
    UINT32 exportType = 0; // 用于表示正常导出，还是涂鸦合成。0表示正常导出，1表示涂鸦合成, 2表示保存导出
    bool addWatermark = true;
};
const UINT32 EXPORT_TYPE_SAVE = 2;

class HmcRenderEngineItf {
public:
    virtual ~HmcRenderEngineItf(){};

    virtual VOID Destroy(){};

    virtual VOID InitEnv(std::string const & editData){};

    virtual VOID InitEngine(VOID *surface) { HMC_UNUSED(surface); };

    virtual VOID InitExportEngine(VOID *surface) { HMC_UNUSED(surface); };

    virtual VOID DrawOnOffScreen(VECTOR<HmcRenderLayerPtr> &renderLayers, const HmcRenderCanvas &canvas)
    {
        HMC_UNUSED(renderLayers);
        HMC_UNUSED(canvas);
    }

    virtual VOID SetCropRect(int x, int y, int w, int h)
    {
        HMC_UNUSED(x);
        HMC_UNUSED(y);
        HMC_UNUSED(w);
        HMC_UNUSED(h);
    }
    virtual VOID Draw(VECTOR<HmcRenderLayerPtr> &renderLayers, const HmcRenderCanvas &canvas,
        HmcRenderResultFunc func = nullptr,UINT64 id = 0, ATOMIC_BOOL *isPicChangingPtr = nullptr) = 0;

    virtual std::future<ExportData> Export(VECTOR<HmcRenderLayerPtr> &renderLayers, const HmcRenderCanvas &canvas,
        const ExportParam &param) = 0;

    virtual VOID RemoveEffect(const STRING &name) { HMC_UNUSED(name); }

    // 允许外部调用者向渲染引擎中注册外部任务，该任务将会由渲染线程执行.
    virtual BOOL RegExternalTask(RenderCommonTaskPtr task)
    {
        HMC_UNUSED(task);
        return FALSE;
    }

    virtual VOID InitInnerEffect(VOID *effect) { HMC_UNUSED(effect); }

    virtual Json::Value SaveImageEffect() { return Json::Value::nullSingleton(); }

    virtual INT32 RestoreImageEffect(const STRING &restoreInfo) { return HMC_ERR; }

    virtual VOID CleanWatermarkCache()
    {
    };
};

std::shared_ptr<HmcRenderEngineItf> HmcVideoRenderCreate(RenderType renderType);


#endif // HMCRENDERENGINEITF_H
