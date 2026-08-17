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

#ifndef HMCRENDEROHOSENGINE_H
#define HMCRENDEROHOSENGINE_H

#include "render/base/RenderBase.h"

#include "render/core/HmcRenderEngineItf.h"
#include "render/core/HmcRenderEffect.h"
#include "render/graphic/HmcRenderTexture.h"
#include "render/core/HmcRenderLayer.h"
#include "render/core/HmcRenderCanvas.h"
#include "render/base/worker/RenderThread.h"
#include "render/base/task/RenderTask.h"
#include "render/graphic/HmcNativeWindow.h"
#include "render/core/HmcEfilter.h"
#include "image/decoder/HmcOhosImageDecoder.h"
#include <native_image/native_image.h>

#include <multimedia/image_effect/image_effect.h>
#include <multimedia/image_effect/image_effect_filter.h>

#include "ohos/hve/ProjectConfig.h"

const int RGBA_COLOR_SIZE = 4;
const int RGBA_R_OFFSET = 0;
const int RGBA_G_OFFSET = 1;
const int RGBA_B_OFFSET = 2;
const int RGBA_A_OFFSET = 3;
const int DEFAULT_BUFFER_WIDTH = 10;
const int DEFAULT_BUFFER_HEIGHT = 10;
const int THREADE_NUM = 8;

// A取值偏移量
const unsigned int A_COLOR_OFFERSET = 24;
// R取值偏移量
const unsigned int R_COLOR_OFFERSET = 16;
// G取值偏移量
const unsigned int G_COLOR_OFFERSET = 8;

typedef struct RenderConfig {
    INT32 m_x = 0;
    INT32 m_y = 0;
    INT32 m_width = 0;
    INT32 m_height = 0;
    INT32 m_canvasWidth = 0;
    INT32 m_canvasHeight = 0;

    FLOAT m_borderColorX = 0.0f;
    FLOAT m_borderColorY = 0.0f;
    FLOAT m_borderColorZ = 0.0f;
    FLOAT m_borderColorW = 1.0f;

    INT32 renderType = 0;
    INT32 encodeType = 0;
    UINT64 externId = 0;
    UINT8 *bitmap = nullptr;
} RenderConfig;

typedef struct TransformInfo {
    INT32 mirrorH;
    INT32 mirrorV;
    INT32 srcW;
    INT32 srcH;
    FLOAT rotateX;
    FLOAT rotateY;
    FLOAT scaleX;
    FLOAT scaleY;
    FLOAT ratioX;
    FLOAT ratioY;
    DOUBLE lbX;
    DOUBLE lbY;
    DOUBLE rtX;
    DOUBLE rtY;
    INT32 viewportX;
    INT32 viewportY;
    DOUBLE cropTransformOffsetX;
    DOUBLE cropTransformOffsetY;
    DOUBLE cropTransformScaleX;
    DOUBLE cropTransformScaleY;
    DOUBLE cropTransformRotate;
    FLOAT rotate;
    FLOAT offsetX;
    FLOAT offsetY;
    INT32 minXint;
    INT32 minYint;
    INT32 maxXint;
    INT32 maxYint;
} TransformInfo;

class HmcRenderEngine : public HmcRenderEngineItf, public std::enable_shared_from_this<HmcRenderEngine> {
public:
    explicit HmcRenderEngine(UINT32 id, RenderType renderType);
    ~HmcRenderEngine() override;
    VOID Destroy() override;
    VOID InitEnv(std::string const & editData) override;

    VOID InitEngine(VOID *surface) override;

    VOID InitExportEngine(VOID *surface) override;

    VOID Draw(VECTOR<HmcRenderLayerPtr> &renderLayers, const HmcRenderCanvas &canvas, HmcRenderResultFunc func,
              UINT64 id, ATOMIC_BOOL *isPicChangingPtr) override;
    std::future<ExportData> Export(VECTOR<HmcRenderLayerPtr> &renderLayers, const HmcRenderCanvas &canvas,
                                   const ExportParam &param) override;
    VOID DrawOnOffScreen(VECTOR<HmcRenderLayerPtr> &renderLayer, const HmcRenderCanvas &canvas) override;

    VOID AddEffect(HmcRenderEffectPtr &effect);
    VOID RemoveEffect(const STRING &name) override;

    VOID SetCropRect(int x, int y, int w, int h) override;

    VOID CleanWatermarkCache() override;
    
    BOOL RegExternalTask(RenderCommonTaskPtr task) override;
    VOID InitInnerEffect(VOID *effect) override;

    HmcSurfaceTexture *CreateSurfaceTexture();

    Json::Value SaveImageEffect() override;

    INT32 RestoreImageEffect(const STRING &restoreInfo) override;

protected:
    VOID UpdateResCache(VECTOR<HmcRenderLayerPtr> &renderLayer, UINT64 id);

    VOID UpdateLayerRes(HmcRenderLayerPtr &renderLayer);

    STRING GetThreadId();

    VOID InitThread(std::string const & editData);

    VOID ReleaseThread();

    VOID AbandonAndClearEFilterList();

    VOID ReleaseImageEffectOnRenderThread();

    void ProcessComposeEffect(HmcRenderLayerPtr &layerInfo, RenderEngineType &type, unsigned int &needRGBA,
        HmcRenderEffectPtr &effect);
    bool IsSameXtStyleFilter(HmcRenderEffectPtr effect, HmcRenderEffectPtr preEffect);
    bool isFilterEffectChange(HmcRenderEffectPtr filterEffect, HmcRenderEffectPtr preFilterEffect);
    bool isAdjustEffectChange(HmcRenderEffectPtr adjustEffect, HmcRenderEffectPtr preAdjustEffect);
    bool isXtStyleEffectChange(HmcRenderEffectPtr xtStyleEffect, HmcRenderEffectPtr preXtStyleEffect);
    void CacheTransform(HmcRenderLayerPtr &layerInfo);
    void ProcessTransformCache(HmcRenderLayerPtr &layerInfo, RenderEngineType type);
    void GenConfigEFilter();
    RenderInputType GetInputType(std::shared_ptr<Image> &image, RenderEngineType type);
    bool SetInputPixelMap(std::shared_ptr<Image> &image, RenderEngineType type);
    VOID RemoveFilters();
    SHARED_PTR<Image> ConfigRenderInfo(HmcRenderLayerPtr &layerInfo, HmcEFilterPtr config, RenderEngineType type,
                          const HmcRenderCanvas &canvas, UINT32 needRGBA);
    VOID ConfigEffectFilter(HmcRenderLayerPtr &layerInfo, RenderEngineType type,
                            const HmcRenderCanvas &canvas, SHARED_PTR<Image> image);
    VOID ProcessEffect(RenderEngineType type, HmcRenderEffectPtr effect, HmcRenderLayerPtr &layerInfo);

    void UpdateTransformParam(HmcRenderEffectPtr &effect, HmcEFilterPtr nativeEffect, TransformInfo *&info);
    VOID CalculateEffectiveArea(HmcRenderEffectPtr effect, const HmcRenderCanvas &canvas, INT32 width, INT32 height,
        HmcEFilterPtr cropEfilter, INT32 baseRotationDeg, bool isDragImage);

    VOID ConfigEFilter(HmcRenderEffectPtr effect, RenderEngineType type);
    
    VOID ConfigEFilter(HmcRenderEffectPtr effect, HmcEFilterPtr hmcEFilterPtr, RenderEngineType type);

    void ConfigCanvas(const HmcRenderCanvas &canvas, HmcEFilterPtr hmcEFilterPtr);

    SHARED_PTR<VECTOR<HmcRenderLayerPtr>> UpdateCache(VECTOR<HmcRenderLayerPtr> &renderLayers, UINT64 taskId);

    VOID GenTransformInfo(const HmcRenderEffectPtr &transformEffect, TransformInfo *info) const;

    VOID UpdateCrossArea(TransformInfo *info, std::vector<Vec2> &crossArea) const;

    VOID UpdateRotate(int srcW, int srcH, float rotateX, float rotateY, Vec2 *xy) const;

    static void CameraMatrix(Mat4x4 &m);

    VOID GetLimit(TransformInfo *info, std::vector<Vec2> &crossArea);
 
    HmcEFilterPtr GenCropEFilter();
    HmcEFilterPtr GenBrightnessEFilter();
    HmcEFilterPtr GenContrastEFilter();

    VOID ProcessWatermarkEffect(HmcRenderLayerPtr &layerInfo, RenderEngineType type,
                                const HmcRenderCanvas &canvas, SHARED_PTR<Image> image);
    
    HmcRenderEffectPtr CopyParamToWatermark(HmcRenderLayerPtr &layerInfo, const HmcRenderCanvas &canvas);

    VOID AddWatermarkImage(HmcRenderEffectPtr effect, const HmcRenderCanvas &canvas,
                           VECTOR<SHARED_PTR<WatermarkPicInfo>> watermarkPicInfoVector, int &index, double opacity);
    HmcEFilterPtr AddTexMappingEFilter(HmcRenderEffectPtr effect, int &index);

    VOID CalculateWatermarkPosition(HmcRenderEffectPtr effect, SHARED_PTR<WatermarkPicInfo> watermarkPicInfo,
                                    const HmcRenderCanvas &canvas);

    VOID SetFragment(OH_PictureNative *pictureNative, SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, INT32 w, INT32 h);

    OH_PictureNative *GenerateOutputPicture(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, HmcRenderCanvas canvas,
                                            const ExportParam &param, INT32 taskId);
    OH_PictureNative *CreateOutputPicture(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, INT32 w, INT32 h,
        UINT32 exportType);
    OH_PixelmapNative *GenerateOutputPixelmap(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, HmcRenderCanvas canvas,
                                            UINT32 exportType, INT32 taskId);
    OH_PixelmapNative *CreateOutputPixelmap(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, INT32 w, INT32 h,
        UINT32 exportType);
    Image_Size CalcExportSizeAndFixOffset(SHARED_PTR<VECTOR<HmcRenderLayerPtr>> layers, const HmcRenderCanvas &canvas);
    
    bool ProcessXTStyleEFilter(HmcRenderEffectPtr effect);

    BOOL m_offscreenOnly{FALSE};
    volatile BOOL m_ready = {FALSE};
    volatile BOOL m_exported = {FALSE};

    std::shared_future<void> m_lastExportTaskFuture;

    UINT64 RequestTaskId();

    std::chrono::time_point<std::chrono::high_resolution_clock> m_frameEndTime;

    int m_bitWidth{0};
    int m_bitHeight{0};
    UCHAR *m_bitpng{NULL};

    std::mutex m_cacheMutex;
    MAP<STRING, HmcRenderEffectPtr> m_effectGlobalCache;
    ATOMIC_UINT64 m_currentTaskId{0};
    std::recursive_mutex m_renderMutex;

    RenderThread<> *m_renderThread{NULL};

    double exportCropRect[4]{0.0, 0.0, 0.0, 0.0};
    OHNativeWindow *m_exportWindow{NULL};

    OH_ImageEffect *mImageEffect = nullptr;
    
    char* exportInfo_ = "";
    
    OH_PictureNative *nativePicture = nullptr;
    
    LIST<HmcRenderEffectPtr> m_pre_effectList;
    std::map<std::string, HmcEFilterPtr> m_efilterList;
    bool configCacheSwitch_ = false;
    bool transformCacheSwitch_ = false;
    void* window_;

    UINT32 m_id{0}; // engine标识

    bool mIsHMCRenderEnable = false;
    
    std::string m_watermarkCacheId = "";
    std::string m_watermarkTag = "";
    std::map<std::string, SHARED_PTR<WatermarkPicInfo>> m_watermarkCache;
    
    INT32 m_firstFilterIndex{-1};
    INT32 m_restoredFilterCount{0};
    bool m_isSurfaceOutput = false;
    bool m_needFlush = false;
    
private:
    RenderType m_renderType;
    const char *TAG = "HmcRenderEngine";
    INT32 lastXtStyleMode = 1;
    RenderInputType m_lastRenderInputType = UNSET;
    
    std::mutex m_waterMarkMtx;
    std::tuple<uint32_t, uint32_t> CalcAuxPicturePositionAndHeight(
        const VECTOR<SHARED_PTR<WatermarkPicInfo>> &watermarkPtrVector);
};


#endif // HMCRENDEROHOSENGINE_H
