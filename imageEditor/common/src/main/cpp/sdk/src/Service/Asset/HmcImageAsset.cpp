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

#include <native_window/external_window.h>

#include "../Base/util/HmcSampleSizer.h"
#include "HmcService.h"
#include "../Base/file/ImagePropertyHelper.h"
#include "MediaCreative/HmcError.h"
#include "Project/HmcProjectSerializeKey.h"
#include "image/HmcImageInfo.h"
#include "file/HmcFile.h"
#include "../Effect/HmcEffect.h"
#include "../../Bridge/ohos/hve/ProjectConfig.h"

#define DEFAULT_EXIF_VALUE "default_exif_value"

#define FACT_RECT_EXIF_KEY "HwMnoteFaceRect"

#define FACT_RECT_COUNT_EXIF_KEY "HwMnoteFaceCount"

#define XMAGE_COLOR_MODE_EXIF_KEY "HwMnoteXmageColorMode"

constexpr INT32 IMAGE_ROTATE_ANGLE = 90;
constexpr INT32 MAX_SPEED_RATINGS = 65535;
constexpr int PARAM_POSITION_INDEX = 1;
constexpr INT32 PIXEL_BYTES_FOUR = 4;

std::mutex g_mutex;

VECTOR<STRING> HmcImageAsset::EXIF_XT_STYLE_KEYS = {"HwMnoteXtStyleTemplateName",
                                                    "HwMnoteXtStyleCustomLightAndShadow",
                                                    "HwMnoteXtStyleCustomSaturation",
                                                    "HwMnoteXtStyleCustomHue"};

// 冻结帧场景
HmcImageAsset::HmcImageAsset(HmcUid laneUid, HmcEventHandler *eventHandler)
    : HmcVisionAsset(laneUid, eventHandler),
      m_needDownsampling(FALSE),
      m_previewImage(nullptr),
      m_thumbnailImage(nullptr),
      m_texture(nullptr)
{
    m_type = HMC_ASSET_IMAGE;
    m_complexDuration.SetTime(HMC_ASSET_DEFAULT_DURATION);
}

HmcImageAsset::HmcImageAsset(const HmcVisionAsset &asset) : HmcVisionAsset(asset)
{
    m_type = HMC_ASSET_IMAGE;
    m_pureDuration = 0;
    m_thumbnailImage = nullptr;
    m_previewImage = nullptr;
    m_texture = nullptr;
    m_originalTexture = nullptr;
    m_needDownsampling = FALSE;

    if (asset.GetType() == HMC_ASSET_IMAGE) {
        auto imagePtr = dynamic_cast<const HmcImageAsset *>(&asset);
        if (imagePtr) {
            m_needDownsampling = imagePtr->m_needDownsampling;
        }
    } else {
        m_path.clear();
        m_pureDuration = 0;
        m_speed = ASSET_DEFAULT_SPEED;
        m_trimIn = 0;
        m_trimOut = 0;
        m_isBackward = FALSE;
    }
}

// 冻结帧场景
HmcImageAsset::HmcImageAsset(const HmcVisionAsset &asset, HmcImage *freezeImage) : HmcImageAsset(asset)
{
    m_previewImage = freezeImage;
    m_thumbnailImage = nullptr;
    m_texture = nullptr;
}

HmcImageAsset::~HmcImageAsset()
{
    if (m_previewImage != nullptr) {
        HmcImageDestroy(m_previewImage);
        m_previewImage = nullptr;
    }

    if (m_thumbnailImage != nullptr) {
        HmcImageDestroy(m_thumbnailImage);
        m_thumbnailImage = nullptr;
    }

    if (m_surfaceTexture != nullptr) {
        OH_NativeWindow_DestroyNativeWindow(m_surfaceTexture->m_nativeWindow);
        OH_NativeImage_Destroy(&m_surfaceTexture->m_nativeImage);
        delete m_surfaceTexture;
        m_surfaceTexture = nullptr;
    }

    if (m_texture != nullptr) {
        delete m_texture;
        m_texture = nullptr;
    }
    if (m_originalTexture != nullptr) {
        delete m_originalTexture;
        m_originalTexture = nullptr;
    }
    std::unique_lock<std::mutex> lock(g_mutex);
    LOGI("~HmcImageAsset");
}

HmcImageAsset::HmcImageAsset(const HmcImageAsset &image) : HmcVisionAsset(image)
{
    if (image.m_previewImage != nullptr) {
        m_previewImage = HmcImageDuplicate(image.m_previewImage);
    }

    if (image.m_thumbnailImage != nullptr) {
        m_thumbnailImage = HmcImageDuplicate(image.m_thumbnailImage);
    }

    m_texture = nullptr;
    m_originalTexture = nullptr;

    m_needDownsampling = image.m_needDownsampling;
}

HmcRenderTexture *HmcImageAsset::GetTexture() const
{
    HmcRenderTexture *textureDup = new (std::nothrow) HmcRenderTexture(FALSE);
    if (m_texture == nullptr) {
        LOGE("GetTexture, m_texture is nullptr");
        return textureDup;
    }
    *textureDup = *m_texture;
    return textureDup;
}

HmcRenderTexture *HmcImageAsset::GetOriginalTexture()
{
    HmcRenderTexture *textureDup = new (std::nothrow) HmcRenderTexture(FALSE);
    if (m_originalTexture == nullptr) {
        LOGE("GetOriginalTexture is nullptr");
        return textureDup;
    }
    *textureDup = *m_originalTexture;
    return textureDup;
}

INT32 HmcImageAsset::CopyTextureToCompare()
{
    if (m_texture == nullptr) {
        LOGE("CopyTextureToCompare, m_texture is nullptr");
        return HMC_ERR;
    }
    if (m_compareTexture == nullptr) {
        m_compareTexture = std::make_shared<HmcRenderTexture>(FALSE);
    }
    if (!m_compareTexture) {
        LOGE("CopyTextureToCompare, alloc m_compareTexture failed");
        return HMC_ERR;
    }
    HmcRenderTexture *temp  = m_compareTexture.get();
    *temp = *m_texture;
    return HMC_OK;
}

VOID HmcImageAsset::refreshCompareEffectList()
{
    LOGI("HmcVisionAsset::refreshCompareEffectList enter");
    
    {
        std::lock_guard<ffrt::mutex> lock(m_layerMutex);
        if (m_CompareLayer == nullptr) {
            LOGI("HmcVisionAsset::refreshCompareEffectList m_CompareLayer is null");
            m_CompareLayer = std::make_shared<HmcRenderLayer>();
        }
        LOGI("refresh m_layer to m_compareLayer before");
        m_CompareLayer->CopyHmcLayerInfo(m_layer);
        LOGI("refresh m_layer to m_compareLayer after");
    }
    
    CopyTextureToCompare();
    LOGI("HmcVisionAsset::refreshCompareEffectList end");
}

VOID HmcImageAsset::ClearCompareLayer()
{
    LOGI("HmcImageAsset::ClearCompareLayer clear enter");
    if (m_CompareLayer == nullptr || m_CompareLayer->m_effectList.empty()) {
        LOGE("layer is null Or effectList is empty!");
        return ;
    }
    for (auto it = m_CompareLayer->m_effectList.begin(); it != m_CompareLayer->m_effectList.end();) {
        if ((*it) && (*it)->m_resource->m_effectType == "watermark") {
            it++;
            continue;
        }
        it = m_CompareLayer->m_effectList.erase(it);
    }
}

VOID HmcImageAsset::ClearCompareEffectList()
{
    ClearCompareLayer();
    CopyTextureToCompare();
}

VOID HmcImageAsset::UpdateTransformToCompareLayer(std::shared_ptr<HmcRenderLayer> &layer)
{
    LOGI("HmcImageAsset::UpdateTransformToCompareLayer enter");
    if (layer == nullptr) {
        LOGE("UpdateTransformToCompareLayer, layer is nullptr");
        return ;
    }
    for (const auto &effectUid : m_effectList) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        if (!effect || !effect->IsEnable() || effect->GetType() != HMC_EFFECT_TRANSFORM) {
            continue;
        }
        
        HmcRenderEffectPtr renderEffect = effect->GetRenderEffectPtr();
        renderEffect->m_inTex.clear();
        renderEffect->AddTexture("__main");
        renderEffect->SetOutTex("__main");
        
        float scale = GetRenderScale();
        renderEffect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_X, (double)scale);
        renderEffect->SetParam(PROJECT_KEY_TRANSFORM_SCALE_Y, (double)scale);
        
        int index = -1;
        auto it = std::find_if(layer->m_effectList.begin(), layer->m_effectList.end(), [](HmcRenderEffectPtr &effect) {
            return effect && effect->m_resource && effect->m_resource->m_effectType == "transform";
        });
        if (it != layer->m_effectList.end()) {
            index = std::distance(layer->m_effectList.begin(), it);
            layer->m_effectList.erase(it);
        }
        effect->SetRenderLayer(layer, index);
        break;
    }
}

HmcSurfaceTexture *HmcImageAsset::GetSurfaceTexture() const
{
    return m_surfaceTexture;
}

INT32 HmcImageAsset::SetSource(const STRING &path, BOOL IsRestoresDraft, BOOL isSupportWaterMark)
{
    m_path = path;
    m_size = HmcFile::GetSize(path);
    InitSurfaceTexture();
    if (m_previewImage != nullptr) {
        HmcImageDestroy(m_previewImage);
        m_previewImage = nullptr;
    }

    if (m_thumbnailImage != nullptr) {
        HmcImageDestroy(m_thumbnailImage);
        m_thumbnailImage = nullptr;
    }

    m_previewImagePath = m_path;
    m_thumbnailImagePath = m_path;
    // 显示宽高
    if (GetImageSize(m_previewImagePath, m_displayWidth, m_displayHeight) != HMC_OK) {
        LOGE("get image size fail, path:%s.", m_previewImagePath.c_str());
        return HMC_ERR;
    }

    // 当图片大于最大支持大小时降采样
    SHARED_PTR<HmcSimplerSizer> preSizer = std::make_shared<HmcSimplerSizer>(m_displayWidth, m_displayHeight);
    m_displayWidth = preSizer->GetSampleWidth();
    m_displayHeight = preSizer->GetSampleHeight();
    LOGI("HmcImageAsset decode SetSource displayWidth = %d, displayHeight = %d", m_displayWidth, m_displayHeight);
    // 原始宽高
    if (IsRestoresDraft != TRUE) {
        if (GetImageSize(m_path, m_width, m_height) != HMC_OK) {
            LOGE("get image size fail, path:%s.", m_path.c_str());
            return HMC_ERR;
        }
    }
    FetchExifInfo(path);
    // 当图片大于最大支持大小时降采样
    SHARED_PTR<HmcSimplerSizer> sizer = std::make_shared<HmcSimplerSizer>(m_width, m_height);
    m_width = sizer->GetSampleWidth();
    m_height = sizer->GetSampleHeight();
    LOGI("HmcImageAsset decode SetSource width = %d, height = %d", m_width, m_height);
    auto previewImage = HmcImageCreateFromFile(m_previewImagePath.c_str(), isSupportWaterMark);
    CHECK_AND_RETURN_RET_LOG(previewImage != nullptr, HMC_ERR, "create image from file failed, path:%s",
        m_previewImagePath.c_str());

    m_previewImage = previewImage;
    m_thumbnailImage = HmcImageCreateFromFile(m_thumbnailImagePath.c_str(), isSupportWaterMark);
    CHECK_AND_RETURN_RET_LOG(m_thumbnailImage != nullptr, HMC_ERR, "create image from file failed, path:%s",
        m_thumbnailImagePath.c_str());

    InitEffect();
    UpdateOriginalTexture(true);
    return HMC_OK;
}

INT32 HmcImageAsset::SetSource(const STRING &path, BOOL IsRestoresDraft)
{
    return SetSource(path, IsRestoresDraft, false);
}

INT32 HmcImageAsset::SetSource(SHARED_PTR<Image> image, BOOL isOverwriteAll)
{
    bool hasTexture = m_texture != nullptr && m_texture->GetImage() != nullptr;
    LOGI("setSource hasTexture = %d", hasTexture);
    if (hasTexture) {
        CopyPictureNativeMetadata(m_texture->GetImage()->nativePicture, image->nativePicture);
    }
    if (m_previewImage != nullptr) {
        HmcImageDestroy(m_previewImage);
        m_previewImage = nullptr;
    }

    if (m_thumbnailImage != nullptr) {
        HmcImageDestroy(m_thumbnailImage);
        m_thumbnailImage = nullptr;
    }

    if (m_surfaceTexture != nullptr) {
        OH_NativeWindow_DestroyNativeWindow(m_surfaceTexture->m_nativeWindow);
        OH_NativeImage_Destroy(&m_surfaceTexture->m_nativeImage);
        delete m_surfaceTexture;
        m_surfaceTexture = nullptr;
    }
    
    UpdateDisplayInfos(image);

    // 使用pixelMap更换source后，重新创建previewImage 和 thumbnailImage
    m_previewImage = new PixelmapFrame(image);
    m_thumbnailImage = new PixelmapFrame(image);

    m_isChangingPic = true;
    auto res = UpdateOnlyTexture(TRUE);
    if (res == HMC_OK) {
        m_texture->SetImage(image);
    }
    m_isChangingPic = false;
    // 更新原图texture
    UpdateOriginalTexture(isOverwriteAll);
    return HMC_OK;
}

/**
 * 更新显示的宽高信息。如果存在原图，则从原图的宽高信息获取。如果不存在原图，则直接获取。
 * 从原图宽高获取通过向下取整的方式。由于pixelMap实际大小是向上取整，直接使用会有精度偏差
 * @param image
 */
void HmcImageAsset::UpdateDisplayInfos(SHARED_PTR<Image> image)
{
    if (image->originalPicture == nullptr) {
        m_width = (INT32)image->width;
        m_height = (INT32)image->height;
    } else {
        SHARED_PTR<HmcSimplerSizer> sizer =
            std::make_shared<HmcSimplerSizer>(image->originalWidth, image->originalHeight);
        m_width = sizer->GetSampleWidth();
        m_height = sizer->GetSampleHeight();
    }
    m_displayWidth = m_width;
    m_displayHeight = m_height;
    LOGD("HmcImageAsset SetSource width = %d, height = %d", m_width, m_height);
}

/**
 * @param width 宽度
 * @param height 高度
 * 更新显示信息，但是会参考2k下采样限制
 */
void HmcImageAsset::UpdateDownSimplerDisplayInfos(INT32 width, INT32 height)
{
    HmcSimplerSizer sizer = HmcSimplerSizer(width, height);
    m_width = sizer.GetSampleWidth();
    m_height = sizer.GetSampleHeight();
    m_displayWidth = m_width;
    m_displayHeight = m_height;
    LOGI("HmcImageAsset UpdateDownSimplerDisplayInfos width = %d, height = %d",
         m_width, m_height);
}

STRING HmcImageAsset::GetCacheId(const STRING &filePath)
{
    return "";
}

FLOAT HmcImageAsset::GetDownSampleScale()
{
    if (m_originalTexture == nullptr) {
        LOGE("GetDownSampleScale originalTexture is nullptr");
        return 1.0;
    }
    SHARED_PTR<Image> image = m_originalTexture->GetImage();
    if (image == nullptr) {
        LOGE("GetDownSampleScale image is nullptr");
        return 1.0;
    }
    return image->downSampleScale;
}

INT32 HmcImageAsset::PrepareCacheImages()
{
    if (PrepareCacheDirectory() != HMC_OK) {
        LOGE("Prepare cache directory failed, path:%s", m_path.c_str());
        return HMC_ERR;
    }
    // 当前OH单视频剪辑规格不包含贴纸，后续再进行适配

    return HMC_OK;
}

INT32 HmcImageAsset::PrepareCacheDirectory()
{
    return HMC_OK;
}

INT32 HmcImageAsset::ReplaceSource(const STRING &path)
{
    INT32 result = SetSource(path, FALSE);
 
    SetNameFromPath();
    if (m_texture != nullptr) {
        delete m_texture;
        m_texture = nullptr;
    }
    if (m_originalTexture != nullptr) {
        delete m_originalTexture;
        m_originalTexture = nullptr;
    }
 
    return result;
}

HmcImage *HmcImageAsset::GetPreview(INT64 timestamp, bool exactMode)
{
    HMC_UNUSED(timestamp);
    return HmcImageDuplicate(m_previewImage);
}

VOID HmcImageAsset::InitSurfaceTexture()
{
    HmcDict *dict = HmcDictCreate();
    m_eventHandler->OnGetData(HMC::GET_DATA_NATIVE_WINDOW, nullptr, (void *)dict);
    void *data = nullptr;
    int texId = 0;
    HmcDictGetPointer(dict, "surfaceTexture", &data);
    HmcSurfaceTexture *surfaceTexture = static_cast<HmcSurfaceTexture *>(data);
    HmcDictDestroy(dict);
    m_surfaceTexture = surfaceTexture;
}

int32_t HmcImageAsset::PackGraphicsRenderInfo(uint64_t timestamp,
    std::shared_ptr<VideoRenderInfo> &renderInfo, bool exactMode)
{
    LOGD("HmcImageAsset::PackGraphicsRenderInfo");
    if (renderInfo == nullptr) {
        LOGE("invalid parameter renderInfo");
        return HMC_ERR_PARAM;
    }

    auto layer = std::make_shared<HmcRenderLayer>();
    if (layer == nullptr) {
        LOGE("malloc memory for layer");
        return HMC_ERR_SERVICE_LANE;
    }
    renderInfo->setIsPicChangingPtr(&m_isChangingPic);
    layer->m_sourceAsset = m_uid;
    layer->m_sourceLane = m_laneUid;

    if (m_texture == nullptr) {
        int32_t result = UpdateTexture();
        if (result != HMC_OK) {
            LOGE("UpdateTexture failed, result = %d", result);
            return result;
        }
    }
    
    if (m_compareTexture == nullptr) {
        CopyTextureToCompare();
    }

    {
        std::lock_guard<std::mutex> lock(m_textureMutex);
        if (m_texture == nullptr) {
            return HMC_ERR_PARAM;
        }
        m_texture->m_rotation = m_rotation;
    }
    layer->SetTimeStamp(timestamp);
    // 对比时，切换预处理管线的图，使用上一个tab的编辑数据
    bool isOriginalColorMode = IsOriginalColorMode();
    LOGI("HmcImageAsset::PackGraphicsRenderInfo m_originalColorMode = %d, isOriginalColorMode = %d",
         m_originalColorMode, isOriginalColorMode);
    if (m_originalColorMode == 1 && m_compareTexture != nullptr) {
        LOGI("PackGraphicsRenderInfo, add with m_compareTexture");
        m_compareTexture->m_rotation = m_rotation;
        layer->AddTexture(m_compareTexture.get());
    } else {
        LOGI("PackGraphicsRenderInfo, add with m_texture");
        std::lock_guard<std::mutex> lock(m_textureMutex);
        if (m_texture == nullptr) {
            return HMC_ERR_PARAM;
        }
        layer->AddTexture(m_texture);
    }
    if (m_originalColorMode == 1) {
        LOGI("PackGraphicsRenderInfo, set m_CompareLayer");
        layer->CopyHmcLayerInfo(m_CompareLayer);
        UpdateTransformToCompareLayer(layer);
        layer->m_isDrawWaterMark = m_isDrawWaterMark;
        layer->m_IsInPreviewMode = m_IsInPreviewMode;
    } else {
        LOGI("PackGraphicsRenderInfo, set layer");
        SetEffectRenderLayer(layer);
    }
    LOGD("HmcImageAsset PackGraphicsRenderInfo width = %d, height = %d", m_width, m_height);
    LOGI("m_isDrawWaterMark %d, m_IsInPreviewMode %d, m_IsSwitchPage %d",
        layer->m_isDrawWaterMark, layer->m_IsInPreviewMode, layer->m_IsSwitchPage);

    HmcVisionAsset::PackGraphicsRenderInfo(timestamp, renderInfo);
    renderInfo->layers.push_back(layer);
    {
        LOGI("m_layer use before");
        std::lock_guard<ffrt::mutex> lock(m_layerMutex);
        m_layer->CopyHmcLayerInfo(layer);
        LOGI("m_layer use after");
        if (m_CompareLayer == nullptr) {
            m_CompareLayer = std::make_shared<HmcRenderLayer>();
            m_CompareLayer->CopyHmcLayerInfo(layer);
        }
    }
    return HMC_OK;
}

INT32 HmcImageAsset::UpdateTexture()
{
    if (m_originalTexture == nullptr) {
        LOGE("PackGraphicsRenderInfo m_originalTexture is nullptr");
        return HMC_ERR_PARAM;
    }
    auto res = UpdateOnlyTexture(FALSE);
    if (res != HMC_OK) {
        return res;
    }
    m_texture->SetImage(m_originalTexture->GetImage());
    return HMC_OK;
}

INT32 HmcImageAsset::UpdateOnlyTexture(BOOL isNeedRelease)
{
    std::lock_guard<std::mutex> lock(m_textureMutex);
    LOGI("HmcImageAsset UpdateOnlyTexture start");
    if (m_texture != nullptr) {
        delete m_texture;
        m_texture = nullptr;
    }
    m_texture = new (std::nothrow) HmcRenderTexture(isNeedRelease);
    if (m_texture == nullptr) {
        LOGE("malloc memory for texture failed");
        return HMC_ERR_PARAM;
    }
    return HMC_OK;
}

INT32 HmcImageAsset::UpdateOriginalTexture(BOOL isOverwrite)
{
    LOGI("UpdateOriginalTexture over = %d", isOverwrite);
    if (!isOverwrite) {
        return HMC_OK;
    }
    if (m_originalTexture != nullptr) {
        delete m_originalTexture;
        m_originalTexture = nullptr;
    }
    // 原图texture，供缩略图、对比时使用
    if (m_originalTexture == nullptr) {
        m_originalTexture = new (std::nothrow) HmcRenderTexture(FALSE);
        if (m_originalTexture == nullptr) {
            LOGE("malloc memory for originalTexture failed");
            return HMC_ERR_PARAM;
        }
        OH_HiTrace_StartTrace("StaticEdit_Decode");
        auto originImage = static_cast<HmcImageBase *>(m_previewImage)->ConvertToImage();
        OH_HiTrace_FinishTrace();
        m_originalTexture->SetImage(originImage);
        if (IsEditorSwitchEnable(EDITOR_DEBUG_ENABLE)) {
            PictureUtil::DumpPicture(originImage->nativePicture, "originImageNative");
            PictureUtil::DumpPicture(originImage->originalPicture, "originImageOriginal");
        }
    }
    return HMC_OK;
}

IHmcAsset *HmcImageAsset::Duplicate()
{
    auto asset = new (std::nothrow) HmcImageAsset(*this);
    if (asset == nullptr) {
        LOGE("malloc memory for image asset failed");
        return nullptr;
    }

    return asset;
}

Json::Value HmcImageAsset::Serialize()
{
    Json::Value json = HmcVisionAsset::Serialize();

    return json;
}

BOOL HmcImageAsset::Deserialize(const Json::Value &jsonData)
{
    if (!HmcVisionAsset::Deserialize(jsonData)) {
        LOGE("deserialize hmc asset failed");
        return FALSE;
    }

    if (!m_path.empty()) {
        LOGI("deserialize image success");
        return TRUE;
    }

    std::string encodeStr;
    if (!JsonValueUtil::ParseValueIfHas(jsonData, PROJECT_KEY_ASSET_IMAGE_CONTENT, encodeStr)) {
        LOGE("image data is invalid");
        return FALSE;
    }
    if (encodeStr.empty()) {
        LOGE("deserialize image from encoded image data failed, date is empty");
        return FALSE;
    }

    return TRUE;
}

VOID HmcImageAsset::RequestThumbnail(INT64 timestamp) {}

VOID HmcImageAsset::CancelThumbnail() {}

HmcUid HmcImageAsset::AddEffect(HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("invalid parameter: dict is nullptr");
        return HMC_UID_NULL;
    }

    INT32 typeVale;
    if (HmcDictGetInt32(dict, DICT_KEY_EFFECT_TYPE, &typeVale) != HMC_OK) {
        LOGE("get effect type from dict failed");
        return HMC_UID_NULL;
    }

    return HmcVisionAsset::AddEffect(dict);
}

const HmcRenderTexture *HmcImageAsset::GetRenderTexture() const
{
    return m_texture;
}

INT32 HmcImageAsset::GetDisplayWidth() const
{
    if (m_displayWidth == 0) {
        return HmcVisionAsset::GetDisplayWidth();
    }

    return m_displayWidth;
}

INT32 HmcImageAsset::GetDisplayHeight() const
{
    if (m_displayHeight == 0) {
        return HmcVisionAsset::GetDisplayHeight();
    }

    return m_displayHeight;
}

VOID HmcImageAsset::FetchExifInfo(const STRING &path)
{
    HmcFile file;
    LOGI("HmcImageAsset FetchExifInfo begin");
    file.Open(path, HmcFile::HMC_FILE_READ);
    INT64 fd = file.FileNo();
    std::string path1 = "fd://" + std::to_string(fd);
    HmcImageInfo info(path1);
    info.Init();
    m_orientation = ImagePropertyHelper::GetImageProperty(fd, "Orientation");
    std::string dateTime = ImagePropertyHelper::GetImageProperty(fd, "DateTimeOriginal");
    auto first = dateTime.find(" ");
    if (first != std::string::npos) {
        std::string headSubString = dateTime.substr(0, first);
        std::replace(headSubString.begin(), headSubString.end(), ':', '/');
        std::string tailSubString = dateTime.substr(first, 6);
        m_shotDate = headSubString + tailSubString;
        LOGE("FetchExifInfo: m_shotDate = %s", m_shotDate.c_str());
    }

    std::string filmValue = ImagePropertyHelper::GetImageProperty(fd, "FocalLengthIn35mmFilm");
    std::string fNumberValue = ImagePropertyHelper::GetImageProperty(fd, "FNumber");
    std::transform(fNumberValue.begin(), fNumberValue.end(), fNumberValue.begin(), ::toupper);
    auto pos = fNumberValue.find("/");
    if (pos != std::string::npos) {
        fNumberValue.replace(pos, PARAM_POSITION_INDEX, "");
    }
    std::string exposureTimeValue = ImagePropertyHelper::GetImageProperty(fd, "ExposureTime");
    std::string isoSpeedRatingsValue = ImagePropertyHelper::GetImageProperty(fd, "ISOSpeedRatings");
    bool isNumeric =
        !isoSpeedRatingsValue.empty() &&
        std::all_of(isoSpeedRatingsValue.begin(), isoSpeedRatingsValue.end(), [](char c) { return std::isdigit(c); });
    if (isNumeric && std::stoi(isoSpeedRatingsValue) >= MAX_SPEED_RATINGS) {
        std::string recommendExposureIndexValue = ImagePropertyHelper::GetImageProperty(fd, "RecommendedExposureIndex");
        isoSpeedRatingsValue = recommendExposureIndexValue;
    }
    m_shotParam = filmValue + "mm " + fNumberValue + " " + exposureTimeValue.substr(0, exposureTimeValue.find(" ")) +
                  "s ISO" + isoSpeedRatingsValue;
    std::string aiEdit = ImagePropertyHelper::GetImageProperty(fd, "HwMnoteAiEdit");
    if ("1" == aiEdit) {
        LOGI("FetchExifInfo get aiEdit success");
    } else {
        LOGE("FetchExifInfo failed because aiEdit is null, value = %s", aiEdit.c_str());
    }
    FetchXtStyleExifInfo(fd);
    FetchFactRectsExifInfo(fd);
    FetchFactXmageColorCode(fd);
}
// 加载 exif里面的xmageColorCode
VOID HmcImageAsset::FetchFactXmageColorCode(const INT64 fd)
{
    STRING srcStr = ImagePropertyHelper::GetImageProperty(fd, XMAGE_COLOR_MODE_EXIF_KEY);
    if (srcStr == EMPTY_STR || srcStr == DEFAULT_EXIF_VALUE) {
        return;
    }
    bool isNumeric =
    std::all_of(srcStr.begin(), srcStr.end(), [](char c) { return std::isdigit(c); });
    if (!isNumeric) {
        return;
    }
    LOGI("FetchExifInfo XmageColorCodeMode %s", srcStr.c_str());
    m_exifSourceXmageColorMode = std::stoi(srcStr);
}
// 加载 exif里面的XXX滤镜信息
VOID HmcImageAsset::FetchXtStyleExifInfo(const INT64 fd)
{
    VECTOR<STRING> xtStyleParam = ImagePropertyHelper::GetImageProperties(fd, EXIF_XT_STYLE_KEYS);
    if (xtStyleParam.empty()) {
        LOGI("FetchExifInfo failed no xtStyle data ");
        return;
    }
    if (EXIF_XT_STYLE_KEYS.size() != xtStyleParam.size()) {
        LOGE("FetchExifInfo failed size not equal, fetch size: %d, expect size %d",
             xtStyleParam.size(), EXIF_XT_STYLE_KEYS.size());
        return;
    }
    if (xtStyleParam[0] == DEFAULT_EXIF_VALUE) {
        LOGI("FetchExifInfo failed no xtStyle data ");
        return;
    }
    m_exifXtStyleParam = {};
    auto lightShow = xtStyleParam[EXIF_LIGHT_SHADOW_INDEX];
    auto saturation = xtStyleParam[EXIF_SATURATION_INDEX];
    auto colorTemperature = xtStyleParam[EXIF_COLOR_TEMPERATURE_INDEX];
    m_exifXtStyleParam.push_back(std::stoi(xtStyleParam[0]));
    m_exifXtStyleParam.push_back(lightShow == DEFAULT_EXIF_VALUE? -1:
                                 Denormalize(std::stof(lightShow),
                                             XTSTYLE_MIN_LIGHT_SHADOW_VALUE,
                                             XTSTYLE_MAX_LIGHT_SHADOW_VALUE));
    m_exifXtStyleParam.push_back(saturation == DEFAULT_EXIF_VALUE? -1:
                                 Denormalize(std::stof(saturation),
                                             XTSTYLE_MIN_SATURATION_VALUE,
                                             XTSTYLE_MAX_SATURATION_VALUE));
    m_exifXtStyleParam.push_back(colorTemperature == DEFAULT_EXIF_VALUE? -1:
                                 Denormalize(std::stof(colorTemperature),
                                             XTSTYLE_MIN_COLOR_TEMPERATURE_VALUE,
                                             XTSTYLE_MAX_COLOR_TEMPERATURE_VALUE));
    LOGI("FetchExifInfo xtStyle data %d %d %d %d", m_exifXtStyleParam[0], m_exifXtStyleParam[EXIF_LIGHT_SHADOW_INDEX],
         m_exifXtStyleParam[EXIF_SATURATION_INDEX], m_exifXtStyleParam[EXIF_COLOR_TEMPERATURE_INDEX]);
}

// 加载 exif 人脸数据
VOID HmcImageAsset::FetchFactRectsExifInfo(const INT64 fd)
{
    STRING factRect = ImagePropertyHelper::GetImageProperty(fd, FACT_RECT_EXIF_KEY);
    STRING factRectCountStr = ImagePropertyHelper::GetImageProperty(fd, FACT_RECT_COUNT_EXIF_KEY);
    if (factRect == EMPTY_STR || factRect == DEFAULT_EXIF_VALUE ||
        factRectCountStr == EMPTY_STR || factRectCountStr == DEFAULT_EXIF_VALUE) {
        LOGE("FetchExifInfo factRects failed no FactRect data ");
        return;
    }
    bool isNumeric =
    std::all_of(factRectCountStr.begin(), factRectCountStr.end(), [](char c) { return std::isdigit(c); });
    if (!isNumeric) {
        LOGE("FetchExifInfo factRects failed  because of factRectCountStr not number ,src %s",
             factRectCountStr.c_str()); 
        return;
    }
    m_exifFaceCount = std::stoul(factRectCountStr);
    m_exifFactRectData = factRect;
    LOGI("FetchExifInfo factRects data %s factRectCount %s", factRect.c_str(), factRectCountStr.c_str());
}

INT32 HmcImageAsset::Denormalize(float normalizedValue, int minValue, int maxValue)
{
    return normalizedValue * (maxValue - minValue) + minValue;
}

STRING HmcImageAsset::GetOrientation() const { return m_orientation; }

BOOL HmcImageAsset::Init(const HmcDict *dict)
{
    if (!HmcVisionAsset::Init(dict)) {
        return FALSE;
    }
    InitPreloadWatermarkInfo(dict);
    return TRUE;
}

VOID HmcImageAsset::InitPreloadWatermarkInfo(const HmcDict *dict)
{
    auto data = HmcDictGetString(dict,  DICT_KEY_ASSET_PROPERTY_EDIT_DATA);
    LOGI("HmcImageAsset::InitPreloadWatermarkInfo.  data:%s", data);
}

bool HmcImageAsset::GeneratorRfDataB()
{
    return true;
}