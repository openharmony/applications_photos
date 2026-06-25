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

#include "CustomCropFilter.h"
#include "../../../../libs/SecureC/include/securec.h"
#include <sstream>
#include "log/HmcLog.h"
#include "ohos/util/PixelmapUtil.h"
#include <multimedia/image_effect/image_effect_filter.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>

namespace {
// 图像信息结构体。
struct EffectBufferInfo {
    void *addr = nullptr;
    int32_t width = 0;
    int32_t height = 0;
    int32_t rowSize = 0;
    ImageEffect_Format format = ImageEffect_Format::EFFECT_PIXEL_FORMAT_UNKNOWN;
    EffectBufferInfo() = default;
};

// 滤镜参数结构体
struct FilterInfo {
    int32_t viewportX;
    int32_t viewportY;
    int32_t srcW;
    int32_t srcH;
    float offsetX;
    float offsetY;
    float scaleX;
    float scaleY;
    float ratioX;
    float ratioY;
};

void ApplyCustomAlgo(EffectBufferInfo& src, EffectBufferInfo& dst, FilterInfo& filterInfo)
{
    int32_t viewportX = filterInfo.viewportX;
    int32_t viewportY = filterInfo.viewportY;
    int32_t srcW = filterInfo.srcW;
    int32_t srcH = filterInfo.srcH;
    float offsetX = filterInfo.offsetX;
    float offsetY = filterInfo.offsetY;
    float scaleX = filterInfo.scaleX;
    float scaleY = filterInfo.scaleY;
    float ratioX = filterInfo.ratioX;
    float ratioY = filterInfo.ratioY;
    
    int bytesPerPixel = 4;
    dst.width = viewportX;
    dst.height = viewportY;
    dst.rowSize = dst.width * bytesPerPixel;
    dst.format = src.format;
    dst.addr = malloc(dst.rowSize * dst.height);
    memset_s(dst.addr, dst.rowSize * dst.height, 0, dst.rowSize * dst.height);

    LOGI("CustomCropFilter ApplyCustomAlgo %d %d %d", dst.width, dst.height, dst.rowSize);
    float centerX = viewportX / 2.0f;
    float centerY = viewportY / 2.0f;
 
    float totalScaleX = ratioX * scaleX;
    float totalScaleY = ratioY * scaleY;
    if (totalScaleX == 0 || totalScaleY == 0) {
        return;
    }
 
    float halfSrcW = static_cast<float>(src.width) / 2.0f;
    float halfSrcH = static_cast<float>(src.height) / 2.0f;

    float drawLeft = centerX + (0 - halfSrcW) * totalScaleX + offsetX; // 左边界 0
    float drawRight = centerX + (src.width - halfSrcW) * totalScaleX + offsetX; // 右边界 src.width
    float drawTop = centerY + (0 - halfSrcH) * totalScaleY - offsetY; // 上边界 0
    float drawBottom = centerY + (src.height - halfSrcH) * totalScaleY - offsetY; // 下边界 src.height

    int startX = static_cast<int>(std::max(0.0f, std::floor(drawLeft)));
    int endX   = static_cast<int>(std::min((float)dst.width, std::ceil(drawRight)));
    int startY = static_cast<int>(std::max(0.0f, std::floor(drawTop)));
    int endY   = static_cast<int>(std::min((float)dst.height, std::ceil(drawBottom)));
    if (startX >= endX || startY >= endY) {
        return;
    }
 
    uint8_t* dstData = static_cast<uint8_t*>(dst.addr);
    uint8_t* srcData = static_cast<uint8_t*>(src.addr);
 
    for (int y = startY; y < endY; ++y) {
        float srcYFloat = (y - centerY + offsetY) / totalScaleY + halfSrcH;
        if (srcYFloat < 0) {
            srcYFloat = 0;
        }
        if (srcYFloat >= src.height - 1) {
            srcYFloat = src.height - 1.001f;
        }
 
        int srcY0 = static_cast<int>(srcYFloat);
        int srcY1 = srcY0 + 1;
        float yFactor = srcYFloat - srcY0;
 
        for (int x = startX; x < endX; ++x) {
            float srcXFloat = (x - centerX - offsetX) / totalScaleX + halfSrcW;
 
            if (srcXFloat < 0) {
                srcXFloat = 0;
            }
            if (srcXFloat >= src.width - 1) {
                srcXFloat = src.width - 1.001f;
            }
 
            int srcX0 = static_cast<int>(srcXFloat);
            int srcX1 = srcX0 + 1;
            float xFactor = srcXFloat - srcX0;
 
            uint8_t* p00 = srcData + srcY0 * src.rowSize + srcX0 * 4;
            uint8_t* p01 = srcData + srcY0 * src.rowSize + srcX1 * 4;
            uint8_t* p10 = srcData + srcY1 * src.rowSize + srcX0 * 4;
            uint8_t* p11 = srcData + srcY1 * src.rowSize + srcX1 * 4;
 
            for (int c = 0; c < bytesPerPixel; ++c) {
                float topVal = p00[c] * (1 - xFactor) + p01[c] * xFactor;
                float bottomVal = p10[c] * (1 - xFactor) + p11[c] * xFactor;
                uint8_t finalVal = static_cast<uint8_t>(topVal * (1 - yFactor) + bottomVal * yFactor);
                uint8_t* dstPixel = dstData + y * dst.rowSize + x * 4;
                dstPixel[c] = finalVal;
            }
        }
    }
}

bool Render(OH_EffectFilter *filter, OH_EffectBufferInfo *info, OH_EffectFilterDelegate_PushData pushData)
{
    // 获取图像信息具体参数。
    EffectBufferInfo inputBufferInfo;
    OH_EffectBufferInfo_GetAddr(info, &inputBufferInfo.addr);
    OH_EffectBufferInfo_GetWidth(info, &inputBufferInfo.width);
    OH_EffectBufferInfo_GetHeight(info, &inputBufferInfo.height);
    OH_EffectBufferInfo_GetRowSize(info, &inputBufferInfo.rowSize);
    OH_EffectBufferInfo_GetEffectFormat(info, &inputBufferInfo.format);
    
    LOGI("CustomCropFilter Render getInput %d %d %d %d",
         inputBufferInfo.width, inputBufferInfo.height, inputBufferInfo.rowSize, inputBufferInfo.format);
    
    FilterInfo filterInfo;
    ImageEffect_Any value;
    OH_EffectFilter_GetValue(filter, "viewportX", &value);
    filterInfo.viewportX = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "viewportY", &value);
    filterInfo.viewportY = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "srcW", &value);
    filterInfo.srcW = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "srcH", &value);
    filterInfo.srcH = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "offsetX", &value);
    filterInfo.offsetX = value.dataValue.floatValue;
    OH_EffectFilter_GetValue(filter, "offsetY", &value);
    filterInfo.offsetY = value.dataValue.floatValue;
    OH_EffectFilter_GetValue(filter, "scaleX", &value);
    filterInfo.scaleX = value.dataValue.floatValue;
    OH_EffectFilter_GetValue(filter, "scaleY", &value);
    filterInfo.scaleY = value.dataValue.floatValue;
    OH_EffectFilter_GetValue(filter, "ratioX", &value);
    filterInfo.ratioX = value.dataValue.floatValue;
    OH_EffectFilter_GetValue(filter, "ratioY", &value);
    filterInfo.ratioY = value.dataValue.floatValue;
    
    LOGI("CustomCropFilter Render ApplyCustomAlgo");
    
    EffectBufferInfo outputBufferInfo;
    // 调用自定义滤镜算法。
    ApplyCustomAlgo(inputBufferInfo, outputBufferInfo, filterInfo);
    
    LOGI("CustomCropFilter Render getOutput %d %d %d %d",
         outputBufferInfo.width, outputBufferInfo.height, outputBufferInfo.rowSize, outputBufferInfo.format);

    OH_EffectBufferInfo *outputOhInfo = OH_EffectBufferInfo_Create();
    OH_EffectBufferInfo_SetAddr(outputOhInfo, outputBufferInfo.addr);
    OH_EffectBufferInfo_SetWidth(outputOhInfo, outputBufferInfo.width);
    OH_EffectBufferInfo_SetHeight(outputOhInfo, outputBufferInfo.height);
    OH_EffectBufferInfo_SetRowSize(outputOhInfo, outputBufferInfo.rowSize);
    OH_EffectBufferInfo_SetEffectFormat(outputOhInfo, outputBufferInfo.format);
    
    LOGI("CustomCropFilter Render pushData");

    pushData(filter, outputOhInfo);

    OH_EffectBufferInfo_Release(outputOhInfo);

    return true;
}

ImageEffect_FilterDelegate filterDelegate = {
    .setValue = [](OH_EffectFilter *filter, const char *key, const ImageEffect_Any *value) {
        std::string strKey(key);
        // 参数校验，校验成功时返回true，否则返回false。
        std::ostringstream oss;
        oss << "自定义滤镜传入kv, key: " << strKey << ", value: ";
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
                std::string str((char*)value->dataValue.ptrValue);
                oss << str;
            }
        }
        LOGI("[ohblue_native] %s", oss.str().c_str());
        
        // 当前为替换方案，目前不做参数校验，认为参数都是正确的
        return true;
    },
    .render = [](OH_EffectFilter *filter, OH_EffectBufferInfo *info, OH_EffectFilterDelegate_PushData pushData) {
        return Render(filter, info, pushData);
    },
    .save = [](OH_EffectFilter *filter, char **info) {
        // 暂不支持序列化能力
        *info = "{\"customCrop\": \"\"}";
        return true;
    },
    .restore = [](const char *info) {
        // 暂不支持反序列化，直接生成默认实例
        OH_EffectFilter *filter = OH_EffectFilter_Create("CustomCropFilter");
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
    OH_EffectFilterInfo_SetFilterName(filterInfo, "CustomCropFilter");
    ImageEffect_BufferType bufferTypeArray[] = {ImageEffect_BufferType::EFFECT_BUFFER_TYPE_PIXEL};
    OH_EffectFilterInfo_SetSupportedBufferTypes(filterInfo, sizeof(bufferTypeArray) / sizeof(ImageEffect_BufferType),
                                                bufferTypeArray);
    ImageEffect_Format formatArray[] = { ImageEffect_Format::EFFECT_PIXEL_FORMAT_RGBA8888  };
    OH_EffectFilterInfo_SetSupportedFormats(filterInfo, sizeof(formatArray) / sizeof(ImageEffect_Format), formatArray);
    
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_Register(filterInfo, &filterDelegate);
    if (errorCode != ImageEffect_ErrorCode::EFFECT_SUCCESS) {
        LOGI("OH_EffectFilter_Register fail!");
        return;
    }
}
}

CustomCropFilter &CustomCropFilter::GetInstance()
{
    static CustomCropFilter instance;
    return instance;
}

bool CustomCropFilter::Initialize()
{
    // 初始化操作，只执行一次
    if (this->isInitialized_) {
        return false;
    } else {
        doInitialize();
        this->isInitialized_ = true;
        return true;
    }
}