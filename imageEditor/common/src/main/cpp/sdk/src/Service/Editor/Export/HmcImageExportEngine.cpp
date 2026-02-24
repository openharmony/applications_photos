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

#include "HmcBase.h"
#include "Editor/Export/HmcImageExportEngine.h"
#include "HmcService.h"
#include "ohos/util/PixelmapUtil.h"
#include "ohos/util/ExifTransformUtil.h"
#include "render/core/HmcRenderEngine.h"
#include <multimedia/image_framework/image/image_packer_native.h>
static const uint32_t PIXEL_LENGTH_RGBA8888 = 4;
constexpr int32_t SAVE_PROCESSING = 99;
constexpr int32_t SAVE_PROCESS_FINISH = 100;

HmcImageExportEngine::HmcImageExportEngine(HmcEventHandler *handler,
    std::shared_ptr<HmcRenderEngineItf> &graphicsRenderEngine)
    : HmcExportEngine(handler, graphicsRenderEngine)
{
    LOGI("[Export] create image export engine.");
}

HmcImageExportEngine::~HmcImageExportEngine()
{
    LOGI("[Export] destroy image export engine.");

    LOGI("[Export] destroy image export engine finish.");
}

void HmcImageExportEngine::Cancel()
{
    LOGI("[Export] canceling image exporting is not supported.");
}

std::string HmcImageExportEngine::AdaptHeicSmallSizeMimeType(std::string mimeType, uint32_t width, uint32_t height)
{
    if ((mimeType != "image/heif" && mimeType != "image/heic") ||
        width > DMA_REQUIRE_MIN_SIZE && height > DMA_REQUIRE_MIN_SIZE) {
        return mimeType;
    }
    // 小尺寸生成的主图PixelMap为非DMA内存，编码非DMA内存HEIC图会编码报错
    LOGI("HEIC image size too small, change mimeType to jpeg, mimeType=%d, width=%d, height=%d",
        mimeType.c_str(), width, height);
    return "image/jpeg";
}

void HmcImageExportEngine::EncodePicture(HmcDict *dict, OH_PictureNative *pictureNative,
    std::function<void (const std::string &, const std::string &)> callback)
{
    if (IsEditorSwitchEnable(EDITOR_DEBUG_ENABLE)) {
        PictureUtil::DumpPicture(pictureNative, "EncodePicture");
    }
    auto outputPath = HmcDictGetString(dict, PROJECT_KEY_IMAGE_EXPORT_PATH);
    STRING mimeType = HmcDictGetString(dict, PROJECT_KEY_IMAGE_MIMETYPE);
    STRING editData = HmcDictGetString(dict, "editData");
    PixelmapInfo pixelInfo = PictureUtil::GetMainPixelmapInfo(pictureNative);
    mimeType = AdaptHeicSmallSizeMimeType(mimeType, pixelInfo.width, pixelInfo.height);
    LOGI("HmcImageExportEngine EncodePicture type = %s", mimeType.c_str());
    
    LOGI("HmcImageExportEngine EncodePixelMap type = %s", mimeType.c_str());

    if (mimeType == "image/heif" || mimeType == "image/heic") {
        // HEIC图片转成DMA内存格式处理，否则编码可能会报错
        OH_PictureNative *temp = CloneDmaPicture(pictureNative);
        OH_PictureNative_Release(pictureNative);
        pictureNative = temp;
    }

    std::string watermarkData = "";
    auto renderInfo = m_handler->OnPackGraphicsRenderInfo(0);
    auto graphicsRenderInfo = std::static_pointer_cast<VideoRenderInfo>(renderInfo);

    // 导出
    m_handler->OnExportProgressChange(SAVE_PROCESSING);
    int32_t result = HmcEncoderManager::ExportEditImage(pictureNative, outputPath, mimeType, nullptr);
    OH_PictureNative_Release(pictureNative);
    m_handler->OnExportStateChange(HmcExportState::HMC_EXPORT_STATE_FINISH);

    if (result == HMC_OK) {
        m_handler->OnExportProgressChange(SAVE_PROCESS_FINISH);
        LOGI("HmcImageExportEngine EncodePicture to file success.");
    } else {
        LOGE("HmcImageExportEngine EncodePicture to file failed with error: %d.", result);
        m_handler->OnExportResultNotify(result);
    }
    HmcDictDestroy(dict);
    LOGI("HmcImageExportEngine EncodePicture watermark = %s", watermarkData.c_str());
}

void HmcImageExportEngine::ProcessExifOnExistForPixelmap(OH_PixelmapNative *srcPixel, STRING orientation)
{
    bool horizontal = false;
    bool vertical = false;
    float rotateValue = 0.0;
    
    if (orientation == "" || orientation == "Top-left") {
        return;
    }
    
    if (orientation == "Right-top") {
        rotateValue = EXIF_ROTATE_90;
    }
    if (orientation == "Left-bottom") {
        rotateValue = -EXIF_ROTATE_90;
    }
    if (orientation == "Bottom-right") {
        rotateValue = EXIF_ROTATE_180;
    }
    if (orientation == "Top-right") {
        horizontal = true;
    }
    if (orientation == "Bottom-left") {
        vertical = true;
    }
    if (orientation == "Left-top") {
        rotateValue = EXIF_ROTATE_90;
        vertical = true;
    }
    if (orientation == "Right-bottom") {
        rotateValue = EXIF_ROTATE_90;
        vertical = true;
    }
    ExifTransformUtil::DoMirrorOrRotate(srcPixel, horizontal, vertical, rotateValue);
}

ExportData HmcImageExportEngine::OnRenderFinish(RenderFinishParam renderFinishParam, std::string mimeType)
{
    int32_t width = renderFinishParam.width;
    int32_t height = renderFinishParam.height;
    OH_PictureNative *pictureNative = renderFinishParam.pictureNative;
    uint64_t index = renderFinishParam.index;
    
    HMC_UNUSED(index);

    LOGI("[Export] OnRenderFinish, width=%d, height=%d, mimeType=%s", width, height, mimeType.c_str());

    if (pictureNative == nullptr) {
        LOGE("[Export] OnRenderFinish, rgba data is null.");
        return {};
    }

    if (IsEditorSwitchEnable(EDITOR_DEBUG_ENABLE)) {
        PictureUtil::DumpPicture(pictureNative, "OnRenderFinish");
    }

    if (exportInfoCallback_.exportInfoFunc != nullptr) {
        exportInfoCallback_.exportInfoFunc("");
    } else {
        LOGE("[Export] OnRenderFinish, exportInfoFunc is null.");
    }
    
    // 设置导出进度, 图片保存只有1帧, 增强用户体验，伪进度
    m_handler->OnExportProgressChange(99);
    mimeType = AdaptHeicSmallSizeMimeType(mimeType, width, height);
    int32_t result = HmcEncoderManager::ExportEditImage(pictureNative, m_exportPath, mimeType, m_metadata);
    OH_PictureNative_Release(pictureNative);
    m_handler->OnExportStateChange(HmcExportState::HMC_EXPORT_STATE_FINISH);
    if (result == HMC_OK) {
        m_handler->OnExportProgressChange(100);
        LOGI("[Export] save image to file success.");
    } else {
        LOGE("[Export] OnRenderFinish, save rgba data to file failed with error: %d.", result);
        m_handler->OnExportResultNotify(result);
    }

    return {};
}

ExportData HmcImageExportEngine::OnExportFinish(RenderFinishParam renderFinishParam)
{
    int32_t width = renderFinishParam.width;
    int32_t height = renderFinishParam.height;
    OH_PictureNative *pictureNative = renderFinishParam.pictureNative;

    HMC_UNUSED(renderFinishParam.index);

    LOGI("[Export] OnExportFinish, width=%d, height=%d.", width, height);

    if (pictureNative == nullptr) {
        LOGE("[Export] OnExportFinish, outPicture is null.");
        return {};
    }

    OH_PixelmapNative *pixelmap = nullptr;
    if (renderFinishParam.isSave) {
        Image_ErrorCode errorCode = OH_PictureNative_GetHdrComposedPixelmap(pictureNative, &pixelmap);
        LOGI("OnExportFinish with save option, try hdr pixelmap result: %d", errorCode);
    }
    if (pixelmap == nullptr) {
        OH_PictureNative_GetMainPixelmap(pictureNative, &pixelmap);
    }
    
    if (IsEditorSwitchEnable(EDITOR_DEBUG_ENABLE)) {
        PixelmapUtil::DumpOHPixelMap(pixelmap, "OnExportFinish");
    }

    HmcPixelMapInfo *info = ConvertPixelmapNativeToNapi(pixelmap, width, height);
    if(info == nullptr){
        LOGE("[Export] Pixelmap convert info is null.");
        OH_PictureNative_Release(pictureNative);
        return {};
    }

    info->nativePicture = pictureNative;
    if (exportInfoCallback_.exportPixelmapFunc != nullptr) {
        exportInfoCallback_.exportPixelmapFunc(info);
    } else {
        LOGE("[Export] OnRenderFinish, exportPixelmapFunc is null.");
    }
    return {};
}

int HmcImageExportEngine::ExportProc(HmcDict *exportParameter)
{
    if (!m_graphicsRender) {
        LOGE("[Export] ExportProc failed, graphics render is null");
        return HMC_ERR;
    }

    auto renderInfo = m_handler->OnPackGraphicsRenderInfo(0);
    auto graphicsRenderInfo = std::static_pointer_cast<VideoRenderInfo>(renderInfo);
    
    if (graphicsRenderInfo == nullptr) {
        LOGE("[Export] ExportProc failed, graphicsRenderInfo is null");
        return HMC_ERR;
    }
    SyncRenderCanvasSize();
    AdjustRenderCanvasColor(graphicsRenderInfo);

    auto mimeType = HmcDictGetString(exportParameter, PROJECT_KEY_IMAGE_MIMETYPE);
    int exportType = 0;
    HmcDictGetInt32(exportParameter, "compose_export", &exportType);
    LOGI("HmcImageExportEngine::ExportProc:%s", mimeType);
    if (mimeType != nullptr) {
        graphicsRenderInfo->setMimeType(mimeType);
    }
    graphicsRenderInfo->setExportType(exportType);
    LOGI("HmcImageExportEngine::ExportProc graphicsRenderInfo->getMimeType():%s",
         graphicsRenderInfo->getMimeType().c_str());
    RenderGraphicsData(graphicsRenderInfo, 0, 0);

    return HMC_OK;
}

void HmcImageExportEngine::SetCanvasSize(const HmcSize &size)
{
    if (lround(size.width) == 0 || lround(size.height) == 0) {
        LOGE("[Export] SetCanvasSize failed, invalid size: (width = %f, height = %f).", size.width, size.height);
        return;
    }

    m_canvasSize.width = size.width;
    m_canvasSize.height = size.height;

    SyncRenderCanvasSize();
}

void HmcImageExportEngine::SyncRenderCanvasSize()
{
    m_renderCanvas.height_ = lround(m_canvasSize.height);
    m_renderCanvas.width_ = lround(m_canvasSize.width);

    constexpr int lengthToCenterRatio = 2; // 长度或者宽度除以该值，得到中心点.
    m_renderCanvas.x_ = lround((lround(m_canvasSize.width) - m_renderCanvas.width_) / lengthToCenterRatio);
    m_renderCanvas.y_ = lround((lround(m_canvasSize.height) - m_renderCanvas.height_) / lengthToCenterRatio);

    m_renderCanvas.canvasWidth_ = m_renderCanvas.width_;
    m_renderCanvas.canvasHeight_ = m_renderCanvas.height_;
}

int HmcImageExportEngine::InitExportParameter(const HmcDict *dict)
{
    const char *assetUid = HmcDictGetString(dict, PROJECT_KEY_ASSET_ID);
    if (!assetUid) {
        LOGW("[Export] InitExportParameter, assetId is null, skip copy meta data.");
    } else {
        m_metadata = GetMetadata(assetUid);
    }

    auto exportPath = HmcDictGetString(dict, PROJECT_KEY_IMAGE_EXPORT_PATH);
    if (!exportPath) {
        m_exportPath = "";
        LOGE("[Export] InitExportParameter failed, export image path is null");
        return HMC_ERR;
    }

    m_exportPath = exportPath;

    return HMC_OK;
}

std::shared_ptr<HmcImageMetaData> HmcImageExportEngine::GetMetadata(const char *assetUidStr) const
{
    LOGI("[Export] get metadata, assetId = %s", assetUidStr);

    HmcUid assetUid;
    if (HmcUidFromString(assetUidStr, &assetUid) != HMC_OK) {
        LOGE("[Export] GetMetadata failed, failed to convert HmcUid of asset %s.", assetUidStr);
        return nullptr;
    }

    auto asset = dynamic_cast<HmcImageAsset *>(SINGLETON(HmcUidAdmin)->GetAsset(assetUid));
    if (asset == nullptr) {
        LOGE("[Export] GetMetadata failed, failed to get ImageAsset object of asset %s.", assetUid);
        return nullptr;
    }

    auto texture = const_cast<HmcRenderTexture *>(asset->GetRenderTexture());
    if (texture == nullptr) {
        LOGE("[Export] GetMetadata failed, failed to get texture of ImageAsset");
        return nullptr;
    }

    auto image = texture->GetImage();
    if (image == nullptr) {
        LOGE("[Export] GetMetadata failed, get image from texture failed");
        return nullptr;
    }

    return image->metaData;
}

int HmcImageExportEngine::InitExportEnv()
{
    m_graphicsRender->InitExportEngine(nullptr);

    return HMC_OK;
}