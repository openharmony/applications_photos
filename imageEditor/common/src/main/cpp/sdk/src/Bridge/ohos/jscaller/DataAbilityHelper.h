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

#ifndef OH_DATAABILITYHELPER_H
#define OH_DATAABILITYHELPER_H
#include "log/HmcLog.h"
#include <GLES3/gl3.h>
#include <cstdint>
#include <future>
#include <multimedia/image_framework/image/picture_native.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <string>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include "../util/PictureUtil.h"
#include "render/graphic/HmcNativeWindow.h"

const std::string EDITOR_DEBUG_ENABLE = "const.sys.photos.editor.debug.enable";
const std::string EDITOR_FILTER_ENABLE = "const.sys.photos.editor.filter.enable";
const std::string STANDARD_RENDER_ENABLE = "const.sys.photos.editor.render.enable";
const std::string HIDE_WATERMARK_ENABLE = "const.mspes.camera_watermark";
const std::string NEW_WATERMARK_ENABLE = "const.photo.watermark_artsignature.enable";
const std::string ULTRA_SPORT_ENABLE = "const.photo.support_ultraphoto";
const uint32_t DMA_REQUIRE_MIN_SIZE = 512;

bool IsDataAbilityUri(const char *uri);
bool IsRawFilePath(const char *path);

/**
 * 调用JS接口，打开uri文件的fd
 * 为实现同步返回，需要在非JS线程调用，否则会该方法会卡死
 *
 * @param uri 待打开的uri，如"datashare:///media/video/7"
 * @param mode 指示文件打开模式‘rwt’
 * @return 打开的文件fd
 */
int64_t DataAbilityHelperOpen(const char *uri, const char *mode);
void ClearOpenedFds(const char *uri);
void ClearAllOpenedFds();

/**
 * 调用JS接口，获取系统配置项systemParameter
 * 为实现同步返回，需要在非JS线程调用，否则会该方法会卡死
 *
 * @return debug开true，关false
 */
bool IsEditorSwitchEnable(const std::string &key);
void DumpBuffer(uint8_t *data, size_t size, const std::string& filename);
bool IsParamEnable(const std::string &key);

using HmcImageMetaData = struct {
    int32_t quality;
};

typedef struct PicInfo {
    uint32_t width;
    uint32_t height;
    uint32_t stride;
    GLubyte *imageBuffer = nullptr;
    OH_PictureNative *nativePicture = nullptr;
    OH_PixelmapNative *nativePixelmap;
    OH_AuxiliaryPictureNative *gainMapAuxiliaryPicture;
    OH_AuxiliaryPictureNative *fragmentMapAuxiliaryPicture;
    OH_PictureMetadata *exifMetadata;
    OH_PictureMetadata *fragmentMetadata = nullptr;
    std::shared_ptr<HmcImageMetaData> metaData;
    bool isHdrShownOpen = true;
    OH_PictureNative *nativeDrawPicture = nullptr;
    // 下采样之前的图片
    OH_PictureNative *originalPicture = nullptr;
    uint32_t originalWidth;
    uint32_t originalHeight;
    float downSampleScale = 1.0;
    
    ~PicInfo()
    {
        Image_ErrorCode errorCode = Image_ErrorCode::IMAGE_SUCCESS;
        if (imageBuffer != nullptr) {
            free(imageBuffer);
            imageBuffer = nullptr;
            LOGI("PicInfo imageBuffer release code = %d", errorCode);
        }
        if (nativePicture != nullptr) {
            LOGI("PicInfo del nativePicture");
            errorCode = OH_PictureNative_Release(nativePicture);
            nativePicture = nullptr;
            LOGI("PicInfo nativePicture release code = %d", errorCode);
        }
        if (nativeDrawPicture != nullptr) {
            LOGI("PicInfo del nativeDrawPicture");
            errorCode = OH_PictureNative_Release(nativeDrawPicture);
            nativeDrawPicture = nullptr;
            LOGI("PicInfo nativeDrawPicture release code = %d", errorCode);
        }
        if (nativePixelmap != nullptr) {
            LOGI("PicInfo del nativePixelmap");
            errorCode = OH_PixelmapNative_Release(nativePixelmap);
            LOGI("PicInfo nativePixelmap release code = %d", errorCode);
            nativePixelmap = nullptr;
        }
        if (gainMapAuxiliaryPicture != nullptr) {
            errorCode = OH_AuxiliaryPictureNative_Release(gainMapAuxiliaryPicture);
            LOGI("PicInfo gainMapAuxiliaryPicture release code = %d", errorCode);
            gainMapAuxiliaryPicture = nullptr;
        }
        if (fragmentMapAuxiliaryPicture != nullptr) {
            errorCode = OH_AuxiliaryPictureNative_Release(fragmentMapAuxiliaryPicture);
            fragmentMapAuxiliaryPicture = nullptr;
            LOGI("PicInfo fragmentMapAuxiliaryPicture release code = %d", errorCode);
        }
        if (exifMetadata != nullptr) {
            errorCode = OH_PictureMetadata_Release(exifMetadata);
            exifMetadata = nullptr;
            LOGI("PicInfo exifMetadata release code = %d", errorCode);
        }
        if (fragmentMetadata != nullptr) {
            errorCode = OH_PictureMetadata_Release(fragmentMetadata);
            fragmentMetadata = nullptr;
            LOGI("PicInfo fragmentMetadata release code = %d", errorCode);
        }
        if (originalPicture != nullptr) {
            LOGI("PicInfo del originalPicture");
            errorCode = OH_PictureNative_Release(originalPicture);
            LOGI("PicInfo originalPicture release code = %d", errorCode);
        }
    }

    void UpdateHdrCloseShownPicture(bool isHdrShownOpenParam)
    {
        isHdrShownOpen = isHdrShownOpenParam;
        if (isHdrShownOpen) {
            return;
        }
        if (nativeDrawPicture != nullptr) {
            OH_PictureNative_Release(nativeDrawPicture);
            nativeDrawPicture = nullptr;
        }
        Image_ErrorCode errorCode = OH_PictureNative_CreatePicture(nativePixelmap, &nativeDrawPicture);
        if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || nativeDrawPicture == nullptr) {
            LOGE("OH_PictureNative_CreatePicture fail! errorCode=%d", errorCode);
            return;
        }
        PictureUtil::CopyAllMetadata(nativePicture, nativeDrawPicture);
    }
};

typedef struct WatermarkPicInfo {
    int type;
    std::string id;

    uint32_t width;
    uint32_t height;
    uint32_t picture_width;
    uint32_t picture_height;
    uint32_t numHeight;
    uint32_t firstPositionY;
    uint32_t positionX;
    uint32_t positionY;
    OH_PixelmapNative *nativePixelmap;
    //上边距
    float margin_top;
    //下边距
    float margin_bottom;
    //左边距
    float margin_left;
    //右边距
    float margin_right;
    WatermarkPicInfo() = default;
    ~WatermarkPicInfo();
};

struct HmcPixelMapInfo {
    int width;
    int height;
    size_t len; // 数据总长度
    int32_t pixelFormat; // 图片格式
    void* data;
    std::condition_variable condition;
    std::mutex mutex;
    bool isReady = false;
    NativePixelMap *pixelmap;
    napi_value pixelmapNapi;
    OH_PixelmapNative *nativePixelmap;
    OH_PictureNative *nativePicture = nullptr;
    std::string waterMarkInfos; // 水印参数信息
};

enum class MetadataType {
    EXIF_METADATA = 1,
    FRAGMENT_METADATA = 2,
    XTSTYLE_METADATA = 3,
    RFDATAB_METADATA = 4,
    GIF_METADATA = 5,
    XDRAW4K_METADATA = 8,
    PRIVATE_METADATA = 9,
    RFDATAN_METADATA = 10,
    RFDATAS_METADATA = 11,
    HDRSNAP_METADATA = 12,
    HDRPAN_METADATA = 13,
    METADATA_MAX
};
    
enum class AuxiliaryPictureType {
    AUXILIARY_PICTURE_TYPE_GAINMAP = 1,
    AUXILIARY_PICTURE_TYPE_DEPTH_MAP = 2,
    AUXILIARY_PICTURE_TYPE_UNREFOCUS_MAP = 3,
    AUXILIARY_PICTURE_TYPE_LINEAR_MAP = 4,
    AUXILIARY_PICTURE_TYPE_FRAGMENT_MAP = 5,
    AUXILIARY_PICTURE_TYPE_SNAP_MAP = 6,
    AUXILIARY_PICTURE_TYPE_SNAP_GAINMAP = 7,
    AUXILIARY_PICTURE_TYPE_PAN_MAP = 8,
    AUXILIARY_PICTURE_TYPE_PAN_GAINMAP = 9,
    AUXILIARY_PICTURE_TYPE_MAX
};

// 为实现同步返回，需要在非JS线程调用，否则会该方法会卡死
HmcPixelMapInfo *GenPixelMapNapi(void *data, int width, int height);
HmcPixelMapInfo *ConvertPixelmapNativeToNapi(OH_PixelmapNative *pixelmap, int width, int height);
OH_PixelmapNative *CreatePixelMapNative(NativePixelMap *inputPixelmap, uint32_t pixelFormat);
OH_PixelmapNative *CreatePixelMapNativeWithInfo(uint8_t *data, int width, int height, int format, int srcFormat);
OH_PixelmapNative *CreatePixelMapWithAuxiliaryPicture(OH_AuxiliaryPictureNative *auxiliaryPicture);
UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter> CloneDmaPixelMapNative(OH_PixelmapNative *sourcePixelMap);
int GetSizeFromPixelmap(OH_PixelmapNative *pixelmap, uint32_t *width, uint32_t *height);
void CopyPictureNativeMetadata(OH_PictureNative *srcPicture, OH_PictureNative *destPicture);
OH_PictureNative *CopyPicture(OH_PictureNative *srcPicture, int32_t width, int32_t height, bool isCopyData = true,
    bool isNeedDmaMem = false);
void SetAuxPictureNativeForFragment(OH_PictureNative *srcPicture, uint32_t positionX, uint32_t positionY,
                                    uint32_t width, uint32_t height);
void ConvertRGBA2BGRA(unsigned char *data, uint32_t width, uint32_t height, uint32_t rowStride = 0);
unsigned char *GetFragmentBuffFromPicture(OH_PictureNative *srcPicture, uint32_t positionX, uint32_t positionY,
                                          uint32_t width, uint32_t height);
int SetMetadataForFragmentPicture(OH_AuxiliaryPictureNative *auxiliaryPicture, uint32_t positionX, uint32_t positionY,
                                  uint32_t width, uint32_t height);
int SetInfoForFragmentPicture(OH_AuxiliaryPictureNative *auxiliaryPicture, uint32_t width, uint32_t height);
int SetPictureMetadataProperty(OH_PictureMetadata *metadata, std::string key, std::string value);
void GetPictureMetadataProperty(OH_PictureMetadata *metadata, std::string key, uint32_t *value);
unsigned char *GetDataFromNativePixelMap(OH_PixelmapNative *pixelmap, int width, int height);
unsigned char *GetDataFromNativePixelMapAndRelease(OH_PixelmapNative *pixelmap, int width, int height);
bool CopyColorSpace(OH_PixelmapNative *src, OH_PixelmapNative *dst);
void CopyNativeBuffer(OH_PixelmapNative *src, OH_PixelmapNative *dst);
void CopyHDR_Metadata(OH_NativeBuffer *srcNativeBuff, OH_NativeBuffer *dstNativeBuff);
bool GetPixelMapInfos(OH_PixelmapNative *pixelMap, uint32_t &width, uint32_t &height,
    int32_t &pixelFormat, uint32_t &stride);
OH_PictureNative *CloneDmaPicture(OH_PictureNative *srcPicture);
OH_PictureNative *CloneDmaPictureTmp(OH_PictureNative *srcPicture);
int GetColorSpace(OH_PictureNative *srcPicture);
void SetColorSpace(OH_PictureNative *srcPicture);
STRING CreateFileByJs(const STRING &name, const STRING &suffix = "");
bool AddResourceInMainThread(int type, const STRING &path);
HmcNativeWindow *GetNativeWindow();
void SaveNativeWindow(HmcNativeWindow *window);
bool AddResource(int type, const STRING &path);
#endif // OH_DATAABILITYHELPER_H
