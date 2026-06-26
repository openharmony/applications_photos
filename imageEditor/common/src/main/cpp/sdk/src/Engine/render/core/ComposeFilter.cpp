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

#include <algorithm>
#include <sstream>
#include "ComposeFilter.h"
#include "log/HmcLog.h"
#include <multimedia/image_effect/image_effect_filter.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>

void doInitialize();

ComposeFilterInit &ComposeFilterInit::getInstance()
{
    static ComposeFilterInit instance;
    return instance;
}

bool ComposeFilterInit::initialize()
{
    if (this->isInitialized_) {
        return false;
    } else {
        doInitialize();
        this->isInitialized_ = true;
        return true;
    }
}

struct EffectBufferInfo {
    void *addr = nullptr;
    int32_t width = 0;
    int32_t height = 0;
    int32_t rowSize = 0;
    ImageEffect_Format format = ImageEffect_Format::EFFECT_PIXEL_FORMAT_UNKNOWN;
};

struct FilterInfo {
    void *dstBmp = nullptr;
    int32_t dstRectWidth = 0;
    int32_t dstRectHeight = 0;
    int32_t dstScaleX = 1;
    int32_t dstScaleY = 1;
};

void ApplyCustomAlgo(EffectBufferInfo& effectBufferInfo, FilterInfo& filterInfo)
{
    constexpr uint32_t PIXEL_SIZE_RGBA8888 = 4;
    if (effectBufferInfo.addr == nullptr || filterInfo.dstBmp == nullptr) {
        LOGE("ApplyCustomAlgo invalid buffer, dst=%p, srcBmp=%p", effectBufferInfo.addr, filterInfo.dstBmp);
        return;
    }
    if (effectBufferInfo.width <= 0 || effectBufferInfo.height <= 0 || effectBufferInfo.rowSize <= 0 ||
        filterInfo.dstRectWidth <= 0 || filterInfo.dstRectHeight <= 0) {
        LOGE("ApplyCustomAlgo invalid size, dst(%d, %d, %d), srcHint(%d, %d)", effectBufferInfo.width,
            effectBufferInfo.height, effectBufferInfo.rowSize, filterInfo.dstRectWidth, filterInfo.dstRectHeight);
        return;
    }

    uint32_t dstWidth = static_cast<uint32_t>(effectBufferInfo.width);
    uint32_t dstHeight = static_cast<uint32_t>(effectBufferInfo.height);
    uint32_t dstStride = static_cast<uint32_t>(effectBufferInfo.rowSize);
    uint8_t *dst = static_cast<uint8_t *>(effectBufferInfo.addr);

    OhosPixelMapInfos srcPixelInfo {};
    int ret = OH_PixelMap_GetImageInfo(static_cast<NativePixelMap *>(filterInfo.dstBmp), &srcPixelInfo);
    LOGI("OH_PixelMap_GetImageInfo ret %d", ret);
    if (ret != 0) {
        return;
    }

    uint32_t srcWidth = std::min(static_cast<uint32_t>(srcPixelInfo.width),
        static_cast<uint32_t>(filterInfo.dstRectWidth));
    uint32_t srcHeight = std::min(static_cast<uint32_t>(srcPixelInfo.height),
        static_cast<uint32_t>(filterInfo.dstRectHeight));
    uint32_t srcStride = static_cast<uint32_t>(srcPixelInfo.rowSize);
    LOGI("ApplyCustomAlgo dst(%d, %d, %d) src(%d, %d, %d) srcHint(%d, %d)", dstWidth, dstHeight, dstStride,
        srcWidth, srcHeight, srcStride, filterInfo.dstRectWidth, filterInfo.dstRectHeight);
    if (srcWidth == 0 || srcHeight == 0 || srcStride == 0) {
        return;
    }

    void *addrPtr = nullptr;
    ret = OH_PixelMap_AccessPixels(static_cast<NativePixelMap *>(filterInfo.dstBmp), &addrPtr);
    LOGI("OH_PixelMap_AccessPixels ret %d", ret);
    if (ret != 0) {
        return;
    }

    auto unaccessPixels = [&filterInfo]() {
        int unaccessRet = OH_PixelMap_UnAccessPixels(static_cast<NativePixelMap *>(filterInfo.dstBmp));
        if (unaccessRet != 0) {
            LOGE("OH_PixelMap_UnAccessPixels ret %d", unaccessRet);
        }
    };

    uint8_t *src = static_cast<uint8_t *>(addrPtr);
    uint32_t blendWidth = std::min(std::min(dstWidth, srcWidth),
        std::min(dstStride / PIXEL_SIZE_RGBA8888, srcStride / PIXEL_SIZE_RGBA8888));
    uint32_t blendHeight = std::min(dstHeight, srcHeight);
    if (blendWidth == 0 || blendHeight == 0) {
        unaccessPixels();
        return;
    }

    for (uint32_t y = 0; y < blendHeight; y++) {
        uint32_t srcY = srcHeight - y - 1;
        for (uint32_t x = 0; x < blendWidth; x++) {
            size_t dstPos = static_cast<size_t>(y) * dstStride + x * PIXEL_SIZE_RGBA8888;
            size_t srcPos = static_cast<size_t>(srcY) * srcStride + x * PIXEL_SIZE_RGBA8888;
            uint8_t alpha = src[srcPos + 3];
            if (alpha != 0) {
                uint16_t srcR = src[srcPos + 0];
                uint16_t srcG = src[srcPos + 1];
                uint16_t srcB = src[srcPos + 2];
                uint16_t srcA = src[srcPos + 3];
                uint16_t dstR = dst[dstPos + 0];
                uint16_t dstG = dst[dstPos + 1];
                uint16_t dstB = dst[dstPos + 2];
                uint16_t dstA = dst[dstPos + 3];
                uint8_t outA = (srcA + dstA * (1.0 - srcA / 255.0));
                uint8_t outR = (srcR + dstR * (1.0 - srcA / 255.0));
                uint8_t outG = (srcG + dstG * (1.0 - srcA / 255.0));
                uint8_t outB = (srcB + dstB * (1.0 - srcA / 255.0));
                dst[dstPos + 0] = outR;
                dst[dstPos + 1] = outG;
                dst[dstPos + 2] = outB;
                dst[dstPos + 3] = outA;
            }
        }
    }
    unaccessPixels();
}

bool Render(OH_EffectFilter *filter, OH_EffectBufferInfo *info, OH_EffectFilterDelegate_PushData pushData)
{
    EffectBufferInfo inputBufferInfo;
    OH_EffectBufferInfo_GetAddr(info, &inputBufferInfo.addr);
    OH_EffectBufferInfo_GetWidth(info, &inputBufferInfo.width);
    OH_EffectBufferInfo_GetHeight(info, &inputBufferInfo.height);
    OH_EffectBufferInfo_GetRowSize(info, &inputBufferInfo.rowSize);
    OH_EffectBufferInfo_GetEffectFormat(info, &inputBufferInfo.format);

    FilterInfo filterInfo;
    ImageEffect_Any value;
    OH_EffectFilter_GetValue(filter, "dst_bmp", &value);
    filterInfo.dstBmp = value.dataValue.ptrValue;
    OH_EffectFilter_GetValue(filter, "dst_rect_width", &value);
    filterInfo.dstRectWidth = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "dst_rect_height", &value);
    filterInfo.dstRectHeight = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "dst_scale_x", &value);
    filterInfo.dstScaleX = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "dst_scale_y", &value);
    filterInfo.dstScaleY = value.dataValue.int32Value;

    ApplyCustomAlgo(inputBufferInfo, filterInfo);

    pushData(filter, info);
    return true;
}

ImageEffect_FilterDelegate filterDelegate = {
    .setValue = [](OH_EffectFilter *filter, const char *key, const ImageEffect_Any *value) {
        std::string strKey(key);
        std::ostringstream oss;
        oss << "compose filter setValue, key: " << strKey << ", value: ";
        if (value->dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_INT32) {
            oss << value->dataValue.int32Value;
        } else if (value->dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT) {
            oss << value->dataValue.floatValue;
        } else if (value->dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_DOUBLE) {
            oss << value->dataValue.doubleValue;
        } else if (value->dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_CHAR) {
            oss << value->dataValue.charValue;
        } else if (value->dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_LONG) {
            oss << value->dataValue.longValue;
        } else if (value->dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_BOOL) {
            oss << value->dataValue.boolValue;
        } else if (value->dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_PTR) {
            if (strKey == "dst_bmp") {
                oss << value->dataValue.ptrValue;
            } else {
                std::string str(static_cast<char *>(value->dataValue.ptrValue));
                oss << str;
            }
        }
        (void)filter;
        LOGI("[ohblue_native] %s", oss.str().c_str());
        return true;
    },
    .render = [](OH_EffectFilter *filter, OH_EffectBufferInfo *info, OH_EffectFilterDelegate_PushData pushData) {
        return Render(filter, info, pushData);
    },
    .save = [](OH_EffectFilter *filter, char **info) {
        (void)filter;
        *info = "{\"compose\": \"\"}";
        return true;
    },
    .restore = [](const char *info) {
        (void)info;
        OH_EffectFilter *filter = OH_EffectFilter_Create("ComposeFilter");
        return filter;
    }
};

void doInitialize()
{
    OH_EffectFilterInfo *filterInfo = OH_EffectFilterInfo_Create();
    if (filterInfo == nullptr) {
        LOGI("OH_EffectFilter_GetValue fail!");
        return;
    }
    OH_EffectFilterInfo_SetFilterName(filterInfo, "ComposeFilter");
    ImageEffect_BufferType bufferTypeArray[] = {ImageEffect_BufferType::EFFECT_BUFFER_TYPE_PIXEL};
    OH_EffectFilterInfo_SetSupportedBufferTypes(filterInfo, sizeof(bufferTypeArray) / sizeof(ImageEffect_BufferType),
        bufferTypeArray);
    ImageEffect_Format formatArray[] = { ImageEffect_Format::EFFECT_PIXEL_FORMAT_RGBA8888 };
    OH_EffectFilterInfo_SetSupportedFormats(filterInfo, sizeof(formatArray) / sizeof(ImageEffect_Format), formatArray);

    ImageEffect_ErrorCode errorCode = OH_EffectFilter_Register(filterInfo, &filterDelegate);
    if (errorCode != ImageEffect_ErrorCode::EFFECT_SUCCESS) {
        LOGI("OH_EffectFilter_Register fail!");
        return;
    }
}