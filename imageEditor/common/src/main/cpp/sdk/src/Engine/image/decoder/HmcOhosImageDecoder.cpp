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
#include "HmcOhosImageDecoder.h"
#include <hitrace/trace.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <uv.h>

#include "../Base/util/HmcSampleSizer.h"
#include "ohos/common/NapiCommon.h"
#include "image/HmcImageInfo.h"
#include "../../../Bridge/ohos/hve/ProjectConfig.h";
#include "../../../Bridge/ohos/util/PixelmapUtil.h"

static const uint32_t PIXEL_LENGTH_RGBA8888 = 4;
static const int g_two = 2;

static std::shared_ptr<OH_DecodingOptionsForPicture> CreateDecodingOptions()
{
    OH_DecodingOptionsForPicture *options = nullptr;
    Image_ErrorCode errorCode = OH_DecodingOptionsForPicture_Create(&options);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("HmcOhosImageDecoder OH_DecodingOptions_Create fail! errorCode=%d", errorCode);
        return nullptr;
    }
    
    std::shared_ptr<OH_DecodingOptionsForPicture> optionsPtr(options, [](OH_DecodingOptionsForPicture *options) {
        OH_DecodingOptionsForPicture_Release(options);
    });

    return optionsPtr;
}

static std::shared_ptr<OH_DecodingOptions> CreatePixelMapDecodingOptions(Image_Size *size)
{
    OH_DecodingOptions *options = nullptr;
    Image_ErrorCode errorCode = OH_DecodingOptions_Create(&options);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_DecodingOptions_Create fail! errorCode=%d", errorCode);
        return nullptr;
    }
    
    errorCode = OH_DecodingOptions_SetDesiredSize(options, size);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_DecodingOptions_SetDesiredSize fail! errorCode=%d", errorCode);
        return nullptr;
    }
    
    std::shared_ptr<OH_DecodingOptions> optionsPtr(options, [](OH_DecodingOptions *options) {
        OH_DecodingOptions_Release(options);
    });

    return optionsPtr;
}

VOID HmcOhosImageDecoder::ParseAuxiLiaryPicture(OH_PictureNative *picture, Image *result, bool isSupportWaterMark)
{
    Image_ErrorCode errorCode = OH_PictureNative_GetAuxiliaryPicture(
        picture, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP, &result->gainMapAuxiliaryPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || result->gainMapAuxiliaryPicture == nullptr) {
        LOGE("CreateImageByPicture OH_PictureNative_GetAuxiliaryPicture GAINMAP fail! errorCode=%d", errorCode);
    }
    errorCode = OH_PictureNative_GetAuxiliaryPicture(
        picture, Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_FRAGMENT_MAP, &result->fragmentMapAuxiliaryPicture);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || result->fragmentMapAuxiliaryPicture == nullptr) {
        LOGE("CreateImageByPicture OH_PictureNative_GetAuxiliaryPicture FRAGMENT_MAP fail! errorCode=%d", errorCode);
    }
    if (result->fragmentMapAuxiliaryPicture != nullptr && isSupportWaterMark) {
        errorCode = OH_AuxiliaryPictureNative_GetMetadata(
            result->fragmentMapAuxiliaryPicture, Image_MetadataType::FRAGMENT_METADATA, &result->fragmentMetadata);
        if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || result->fragmentMetadata == nullptr) {
            LOGE("CreateImageByPicture OH_PictureNative_GetMetadata fragmentMetadata fail! errorCode=%d", errorCode);
        }
    }
}

bool HmcOhosImageDecoder::UpdateMetaData(OH_PictureNative *picture)
{
    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(picture, &mainPixelMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || mainPixelMap == nullptr) {
        LOGE("UpdateMetaData fail! errorCode=%d", errorCode);
        return false;
    }
    PixelmapInfo pxlInfo = PixelmapUtil::GetPixelmapInfo(mainPixelMap);
    OH_PixelmapNative_Release(mainPixelMap);
    // 更新gainMap信息
    PictureUtil::UpdatePictureAuxiliaryByGainMap(picture);
    
    OH_PictureMetadata *exifMetadata = nullptr;
    errorCode = OH_PictureNative_GetMetadata(picture, EXIF_METADATA, &exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || exifMetadata == nullptr) {
        LOGE("UpdateMetaData OH_PictureNative_GetMetadata fail! errorCode=%d", errorCode);
        return false;
    }
    
    OH_PictureMetadata *outExifMetadata = nullptr;
    errorCode = OH_PictureMetadata_Clone(exifMetadata, &outExifMetadata);
    OH_PictureMetadata_Release(exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || outExifMetadata == nullptr) {
        LOGE("UpdateMetaData PictureMetadata_Clone fail! errorCode=%d", errorCode);
        return false;
    }
    
    SetPictureMetadataProperty(outExifMetadata, OHOS_IMAGE_PROPERTY_IMAGE_LENGTH, std::to_string(pxlInfo.height));
    SetPictureMetadataProperty(outExifMetadata, OHOS_IMAGE_PROPERTY_IMAGE_WIDTH, std::to_string(pxlInfo.width));
    OH_PictureNative_SetMetadata(picture, Image_MetadataType::EXIF_METADATA, outExifMetadata);
    OH_PictureMetadata_Release(outExifMetadata);
    return true;
}

static float CalculateMinScale(uint32_t width, uint32_t height, float gainScale)
{
    while (width * gainScale < DMA_REQUIRE_MIN_SIZE || height * gainScale < DMA_REQUIRE_MIN_SIZE) {
        gainScale = gainScale * g_two;
    }
    gainScale = HMC_MIN(gainScale, 1.0);
    return gainScale;
}

bool HmcOhosImageDecoder::ScalePictureIfNecessary(OH_PictureNative *picture, Image_Size imageSize,
    float *downSampleScale)
{
    HMC_TRACE_GUARD("ScalePictureIfNecessary");
    LOGI("ScalePictureIfNecessary begin");
    OH_PixelmapNative *mainPixelMap = nullptr;
    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(picture, &mainPixelMap);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, false,
        "ScalePictureIfNecessary OH_PictureNative_GetMainPixelmap fail! errorCode=%d", errorCode);
    
    uint32_t width = 0;
    OH_Pixelmap_ImageInfo *pixelMapInfo = nullptr;
    OH_PixelmapImageInfo_Create(&pixelMapInfo);
    OH_PixelmapNative_GetImageInfo(mainPixelMap, pixelMapInfo);
    OH_PixelmapImageInfo_GetWidth(pixelMapInfo, &width);
    OH_PixelmapImageInfo_Release(pixelMapInfo);
    int scale = width / imageSize.width;
    if (scale <= 1) {
        LOGI("ScalePictureIfNecessary No scaling required.");
        OH_PixelmapNative_Release(mainPixelMap);
        return true;
    }
    *downSampleScale = 1.0 / scale;
    OH_PixelmapNative_Scale(mainPixelMap, static_cast<float>(*downSampleScale), static_cast<float>(*downSampleScale));
    OH_PixelmapNative_Release(mainPixelMap);
    
    OH_PixelmapNative *gainPixelMap = nullptr;
    errorCode = OH_PictureNative_GetGainmapPixelmap(picture, &gainPixelMap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || gainPixelMap == nullptr) {
        LOGE("ScalePictureIfNecessary OH_PictureNative_GetGainmapPixelmap fail! errorCode=%d", errorCode);
    } else {
        // 辅图降采样之后小于512*512时，向上增加倍数，避免小于512时申请DMA buffer失败合成异常
        PixelmapInfo gainInfo = PixelmapUtil::GetPixelmapInfo(gainPixelMap);
        float gainScale = CalculateMinScale(gainInfo.width, gainInfo.height, *downSampleScale);
        LOGI("ScalePictureIfNecessary gainScale=%f", gainScale);
        OH_PixelmapNative_Scale(gainPixelMap, static_cast<float>(gainScale), static_cast<float>(gainScale));
        OH_PixelmapNative_Release(gainPixelMap);
    }
    
    // 更新metadata
    OH_PictureMetadata *metaData = nullptr;
    errorCode = OH_PictureNative_GetMetadata(picture, EXIF_METADATA, &metaData);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || metaData == nullptr) {
        LOGE("ScalePictureIfNecessary OH_PictureNative_GetMetadata fail! errorCode=%d", errorCode);
    } else {
        UpdateMetaData(picture);
        OH_PictureMetadata_Release(metaData);
    }
    // 下采样 UNREFOCUS_MAP
    PictureUtil::CloneAuxiliaryPicture(picture, picture, AUXILIARY_PICTURE_TYPE_UNREFOCUS_MAP, *downSampleScale);
    // 下采样 抓拍图
    PictureUtil::CloneAuxiliaryPicture(picture, picture, static_cast<Image_AuxiliaryPictureType>
        (AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_SNAP_MAP), *downSampleScale);
    // 下采样 抓拍图GainMap
    PictureUtil::CloneAuxiliaryPicture(picture, picture, static_cast<Image_AuxiliaryPictureType>
        (AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_SNAP_GAINMAP), *downSampleScale);
    LOGI("ScalePictureIfNecessary end downSampleScale=%f", *downSampleScale);
    return true;
}

SHARED_PTR<Image> HmcOhosImageDecoder::CreateImageByPicture(OH_PictureNative *picture, Image_Size imageSize,
    bool isSupportWaterMark, bool isForExport)
{
    auto result = new (std::nothrow) Image();
    if (result == nullptr) {
        LOGE("CreateImageByPicture new result fail!");
        return nullptr;
    }

    Image_ErrorCode errorCode = OH_PictureNative_GetMainPixelmap(picture, &result->nativePixelmap);
    
    LOGI("CreateImageByPicture picture: %d nativePixelmap: %d", picture, result->nativePixelmap);
    
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || result->nativePixelmap == nullptr) {
        LOGE("CreateImageByPicture OH_PictureNative_GetMainPixelmap fail! errorCode=%d", errorCode);
        delete result;
        return nullptr;
    }
    // 下采样前先进行水印切图，避免下采样之后水印宽高不对其问题
    // 对Picture进行下采样
    float downSampleScale = 1.0f;
    bool res = ScalePictureIfNecessary(picture, imageSize, &downSampleScale);
    if (!res) {
        LOGE("CreateImageByPicture ScalePictureIfNecessary fail!");
        delete result;
        return nullptr;
    }

    errorCode = OH_PictureNative_GetMetadata(picture, Image_MetadataType::EXIF_METADATA, &result->exifMetadata);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || result->exifMetadata == nullptr) {
        LOGE("CreateImageByPicture OH_PictureNative_GetMetadata exifMetadata fail! errorCode=%d", errorCode);
    }
    PixelmapInfo info = PixelmapUtil::GetPixelmapInfo(result->nativePixelmap);
    result->width = info.width;
    result->height = info.height;
    result->stride = info.rowStride / PIXEL_LENGTH_RGBA8888;
    result->nativePicture = picture;
    result->downSampleScale = downSampleScale;
    LOGI("CreateImageByPicture mainPixelmap: width=%d, height=%d, downSampleScale=%f", result->width, result->height,
        downSampleScale);
    result->UpdateHdrCloseShownPicture(ProjectConfig::Instance().IsHdrShownOpen() || isForExport);
    return SHARED_PTR<Image>(result);
}

std::shared_ptr<OH_ImageSourceNative> HmcOhosImageDecoder::getImageSourcePtr(int64_t fd)
{
    LOGI("HmcOhosImageDecoder getImageSourcePtr");
    OH_ImageSourceNative *imageSource = nullptr;
    Image_ErrorCode errorCode = OH_ImageSourceNative_CreateFromFd(static_cast<int32_t>(fd), &imageSource);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_ImageSourceNative_CreateFromFd fail! errorCode=%d", errorCode);
        return nullptr;
    }

    std::shared_ptr<OH_ImageSourceNative> imageSourcePtr(imageSource, [](OH_ImageSourceNative *imageSource) {
        OH_ImageSourceNative_Release(imageSource);
    });
    return imageSourcePtr;
}

OH_PictureNative *HmcOhosImageDecoder::DecodeToPicture(std::shared_ptr<OH_ImageSourceNative> &imageSourcePtr,
    std::shared_ptr<OH_DecodingOptionsForPicture> &optionsPtr, Image_Size &imageSize)
{
    LOGD("HmcOhosImageDecoder DecodeToPicture start");
    OH_PictureNative *picture = nullptr;
    OH_HiTrace_StartTrace("DecodeToPicture");
    Image_ErrorCode errorCode = OH_ImageSourceNative_CreatePicture(imageSourcePtr.get(), optionsPtr.get(), &picture);
    OH_HiTrace_FinishTrace();
    if (errorCode == Image_ErrorCode::IMAGE_SUCCESS && picture != nullptr) {
        LOGD("DecodeToPicture end");
        return picture;
    }
    LOGE("HmcOhosImageDecoder DecodeToPicture OH_ImageSourceNative_CreatePicture fail! errorCode=%d", errorCode);
    std::shared_ptr<OH_DecodingOptions> pixelMapOptionsPtr = CreatePixelMapDecodingOptions(&imageSize);
    OH_PixelmapNative *pixelmap = nullptr;
    OH_HiTrace_StartTrace("DecodeToPixelmap");
    errorCode = OH_ImageSourceNative_CreatePixelmap(imageSourcePtr.get(), pixelMapOptionsPtr.get(), &pixelmap);
    OH_HiTrace_FinishTrace();
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || pixelmap == nullptr) {
        LOGE("HmcOhosImageDecoder DecodeToPicture OH_ImageSourceNative_CreatePixelmap fail! errorCode=%d", errorCode);
        return nullptr;
    }
    errorCode = OH_PictureNative_CreatePicture(pixelmap, &picture);
    OH_PixelmapNative_Release(pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || picture == nullptr) {
        LOGE("HmcOhosImageDecoder DecodeToPicture OH_PictureNative_CreatePicture fail! errorCode=%d", errorCode);
        return nullptr;
    }
    LOGD("HmcOhosImageDecoder DecodeToPicture by pixelMap end");
    return picture;
}

SHARED_PTR<Image> HmcOhosImageDecoder::Decode(int64_t fd)
{
    HMC_TRACE_GUARD("ImageDecode");

    Image_Size previewSize = {}, exportSize = {};
    OH_PictureNative *picture = DecodeAndCalculateSize(fd, &previewSize, &exportSize);
    CHECK_AND_RETURN_RET_LOG(picture != nullptr, nullptr, "HmcOhosImageDecoder DecodePictureByFd error");
    LOGI("HmcOhosImageDecoder Decode export width=%d,height=%d, preview width=%d, height=%d",
        exportSize.width, exportSize.height, previewSize.width, previewSize.height);
    OH_PictureNative *exportPicture = nullptr;
    if (exportSize.width > previewSize.width || exportSize.height > previewSize.height) {
        // 导出图最大8K
        float downSampleScale = 1.0f;
        ScalePictureIfNecessary(picture, exportSize, &downSampleScale);
        LOGI("HmcOhosImageDecoder CreateExportPicture for downSample： %f", downSampleScale);
        exportPicture = CloneDmaPicture(picture);
    }
    SHARED_PTR<Image> res = CreateImageByPicture(picture, previewSize);
    if (res == nullptr) {
        LOGE("HmcOhosImageDecoder CreateImageByPicture fail!");
        OH_PictureNative_Release(picture);
        if (exportPicture != nullptr) {
            OH_PictureNative_Release(exportPicture);
        }
        return nullptr;
    }
    if (exportPicture != nullptr) {
        // 导出的下采样比例重新修正，最大导出8K，否则可能出现导出超过8K
        res->downSampleScale = previewSize.width * 1.0 / exportSize.width;
        res->originalPicture = exportPicture;
        res->originalWidth = exportSize.width;
        res->originalHeight = exportSize.height;
        // todo 临时方案，目前nativePicture在4k图情况下，不是原图，只有在2k及以下，才为原图.2阶段需要使用编辑数据判断
        EditEffectMode editEffectMode = ProjectConfig::Instance().GetEditEffectMode();
        if (ProjectConfig::Instance().IsEdit() && editEffectMode == EditEffectMode::SNAP) {
            LOGI("HmcOhosImageDecoder replace for snap");
            OH_PictureNative *outputPicture = PictureUtil::ConvertSnapToMain(res->nativePicture);
            if (outputPicture != nullptr) {
                OH_PictureNative_Release(res->nativePicture);
                res->nativePicture = outputPicture;
                OH_PixelmapNative_Release(res->nativePixelmap);
                res->nativePixelmap = nullptr;
                OH_PictureNative_GetMainPixelmap(outputPicture, &res->nativePixelmap);
                res->UpdateHdrCloseShownPicture(ProjectConfig::Instance().IsHdrShownOpen());
            }
        }
    }
    LOGI("HmcOhosImageDecoder CreateImageByPicture complete, downSampleScale:%f, width=%d, height=%d, exportWidth=%d,"
         "exportHeight=%d", res->downSampleScale, res->width, res->height, res->originalWidth, res->originalHeight);
    ProjectConfig::Instance().SetValueByKey("DecodeScale", std::to_string(res->downSampleScale));
    LOGI("HmcOhosImageDecoder end");
    return res;
}

OH_PictureNative *HmcOhosImageDecoder::DecodePictureByFd(int64_t fd, Image_Size maxDecodeSize)
{
    std::shared_ptr<OH_ImageSourceNative> imageSourcePtr = getImageSourcePtr(fd);
    if (imageSourcePtr == nullptr) {
        return nullptr;
    }

    std::shared_ptr<OH_DecodingOptionsForPicture> optionsPtr = CreateDecodingOptions();
    if (optionsPtr == nullptr) {
        LOGE("HmcOhosImageDecoder CreateDecodingOptions fail!");
        return nullptr;
    }
    SetSourceMimeType(fd);
    return DecodeToPicture(imageSourcePtr, optionsPtr, maxDecodeSize);
}

OH_PictureNative *HmcOhosImageDecoder::DecodeAndCalculateSize(int fd, Image_Size *previewSize, Image_Size *exportSize)
{
    CalculateDecodeSize(fd, previewSize, exportSize);
    // 解码最大支持编辑导出尺寸的PixelMap、Picture
    OH_PictureNative *picture = DecodePictureByFd(fd, *exportSize);
    if (picture == nullptr) {
        LOGE("HmcOhosImageDecoder DecodePictureByFd error");
        return nullptr;
    }

    PixelmapInfo info = PictureUtil::GetMainPixelmapInfo(picture);
    LOGI("Decode Input： ImageInfo %d|%d|HDR=%d", info.width, info.height, PictureUtil::IsHdr(picture));
    // 输出picture有哪些辅助图信息
    PictureUtil::PrintPictureAuxiliaries(picture);
    PictureUtil::PrintPictureMetadatas(picture);
    return picture;
}

void HmcOhosImageDecoder::CalculateDecodeSize(int fd, Image_Size *previewSize, Image_Size *exportSize)
{
    std::string path = "fd://" + std::to_string(fd);
    HmcImageInfo info(path);
    bool infoInitRet = info.Init();
    bool isNeedDownSample = !infoInitRet || info.GetFormat() != HmcImageInfo::ImageFormat::ICO;
    if (isNeedDownSample) {
        *previewSize = GetSimplerSizer(info.GetWidth(), info.GetHeight(), HmcSimplerSizer::MIN_PREVIEW_SIZE);
        *exportSize = GetSimplerSizer(info.GetWidth(), info.GetHeight(), HmcSimplerSizer::MAX_IMAGE_SIZE);
    } else {
        previewSize->width = static_cast<uint32_t>(info.GetWidth());
        previewSize->height = static_cast<uint32_t>(info.GetHeight());
        exportSize = previewSize;
    }
}
Image_Size HmcOhosImageDecoder::GetSimplerSizer(uint32_t width, uint32_t height, int maxSize)
{
    SHARED_PTR<HmcSimplerSizer> sizer = std::make_shared<HmcSimplerSizer>(width, height, maxSize);
    Image_Size imageSize = {.width = static_cast<uint32_t>(sizer->GetSampleWidth()),
                            .height = static_cast<uint32_t>(sizer->GetSampleHeight())};
    return imageSize;
}

Image_Size HmcOhosImageDecoder::GetSimplerPreviewSizer(uint32_t width, uint32_t height)
{
    return GetSimplerSizer(width, height, HmcSimplerSizer::MIN_PREVIEW_SIZE);
}

void HmcOhosImageDecoder::SetSourceMimeType(int fd)
{
    OH_ImageSourceNative *imageSource = nullptr;
    Image_ErrorCode code = OH_ImageSourceNative_CreateFromFd(static_cast<int32_t>(fd), &imageSource);
    CHECK_LOG(code == Image_ErrorCode::IMAGE_SUCCESS,
        "HmcOhosImageDecoder SetSourceMimeType Create ImageSource failed");
    std::shared_ptr<OH_ImageSourceNative> imageSourcePtr(imageSource,
        [](OH_ImageSourceNative *imageSource) { OH_ImageSourceNative_Release(imageSource); });
    
    OH_ImageSource_Info *imageInfo = nullptr;
    code = OH_ImageSourceInfo_Create(&imageInfo);
    CHECK_LOG(code == Image_ErrorCode::IMAGE_SUCCESS,
        "HmcOhosImageDecoder SetSourceMimeType ImageSourceInfo_Create failed");
    std::shared_ptr<OH_ImageSource_Info> imageInfoPtr(imageInfo,
        [](OH_ImageSource_Info *imageInfo) { OH_ImageSourceInfo_Release(imageInfo); });
    
    code = OH_ImageSourceNative_GetImageInfo(imageSource, 0, imageInfo);
    CHECK_LOG(code == Image_ErrorCode::IMAGE_SUCCESS,
        "HmcOhosImageDecoder SetSourceMimeType GetImageInfo failed");
    
    Image_MimeType imageMimeType = {.data = nullptr, .size = 0};
    code = OH_ImageSourceInfo_GetMimeType(imageInfo, &imageMimeType);
    CHECK_LOG(code == Image_ErrorCode::IMAGE_SUCCESS,
        "HmcOhosImageDecoder SetSourceMimeType GetMimeType failed");
    
    STRING mimeType(imageMimeType.data, imageMimeType.size);
    ProjectConfig::Instance().SetValueByKey("MimeType", mimeType);
}