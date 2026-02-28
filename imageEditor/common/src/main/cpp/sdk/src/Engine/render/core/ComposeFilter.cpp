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
    // 初始化操作，只执行一次
    if (this->isInitialized_) {
        return false;
    } else {
        doInitialize();
        this->isInitialized_ = true;
        return true;
    }
}

// 图像信息结构体。
struct EffectBufferInfo {
    void *addr = nullptr;
    int32_t width = 0;
    int32_t height = 0;
    int32_t rowSize = 0;
    ImageEffect_Format format = ImageEffect_Format::EFFECT_PIXEL_FORMAT_UNKNOWN;
};

// 滤镜参数结构体
struct FilterInfo {
    void *dstBmp = nullptr;
    int32_t dstRectWidth = 0;
    int32_t dstRectHeight = 0;
    // 下面这两个暂时不用到，用于分析
    int32_t dstScaleX = 1;
    int32_t dstScaleY = 1;
};

void ApplyCustomAlgo(EffectBufferInfo& effectBufferInfo, FilterInfo& filterInfo) {
    uint32_t dstWidth = effectBufferInfo.width;
    uint32_t dstHeight = effectBufferInfo.height;
    uint32_t dstStride = effectBufferInfo.rowSize;
    uint8_t* dst = (uint8_t*)effectBufferInfo.addr;
    uint32_t srcWidth = filterInfo.dstRectWidth;
    uint32_t srcHeight = filterInfo.dstRectHeight;
    LOGI("ApplyCustomAlgo %d %d %d %d %d", dstWidth, dstHeight, dstStride, srcWidth, srcHeight);
    if (srcWidth == 0 ||srcHeight == 0) {
        return;
    }
    void *addrPtr = nullptr;
    int ret = OH_PixelMap_AccessPixels((NativePixelMap*)(filterInfo.dstBmp), &addrPtr);
    LOGI("OH_PixelMap_AccessPixels ret %d", ret);
    if (ret != 0) {
        return;
    }
    uint8_t* src = (uint8_t*)addrPtr;
    // format rgba
    for (int y = 0; y < dstHeight; y++) {
        for (int x = 0; x < dstWidth; x++) {
            size_t dst_pos = y * dstStride + x * 4;
            size_t src_pos = (dstHeight - y - 1) * dstWidth * 4 + x * 4;
            uint8_t alpha = src[src_pos + 3];
            uint8_t dst_alpha = 0;
            if (alpha != 0) {
                // https://zh.wikipedia.org/wiki/Alpha%E5%90%88%E6%88%90
                // 目前认为是预乘alpha的(dump出来数据中rgb都是小于alpha的)
                uint16_t src_r = src[src_pos + 0];
                uint16_t src_g = src[src_pos + 1];
                uint16_t src_b = src[src_pos + 2];
                uint16_t src_a = src[src_pos + 3];
                uint16_t dst_r = dst[dst_pos + 0];
                uint16_t dst_g = dst[dst_pos + 1];
                uint16_t dst_b = dst[dst_pos + 2];
                uint16_t dst_a = dst[dst_pos + 3];
                uint8_t out_a = (src_a + dst_a * (1.0 - src_a / 255.0));
                uint8_t out_r  = (src_r + dst_r * (1.0 - src_a / 255.0));
                uint8_t out_g  = (src_g + dst_g * (1.0 - src_a / 255.0));
                uint8_t out_b  = (src_b + dst_b * (1.0 - src_a / 255.0));
                dst[dst_pos + 0] = out_r;
                dst[dst_pos + 1] = out_g;
                dst[dst_pos + 2] = out_b;
                dst[dst_pos + 3] = out_a;
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
    
    FilterInfo filterInfo;
    ImageEffect_Any value;
    OH_EffectFilter_GetValue(filter, "dst_bmp", &value);
    filterInfo.dstBmp = value.dataValue.ptrValue;  // dstBmp 是 NativePixelMap 格式的数据指针
    OH_EffectFilter_GetValue(filter, "dst_rect_width", &value);
    filterInfo.dstRectWidth = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "dst_rect_height", &value);
    filterInfo.dstRectHeight = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "dst_scale_x", &value);
    filterInfo.dstScaleX = value.dataValue.int32Value;
    OH_EffectFilter_GetValue(filter, "dst_scale_y", &value);
    filterInfo.dstScaleY = value.dataValue.int32Value;

    // 调用自定义滤镜算法。
     ApplyCustomAlgo(inputBufferInfo, filterInfo);

    // 编辑完成后调用pushData直接传递原图。
    pushData(filter, info);
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
        *info = "{\"compose\": \"\"}";
        return true;
    },
    .restore = [](const char *info) {
        // 暂不支持反序列化，直接生成默认实例
        OH_EffectFilter *filter = OH_EffectFilter_Create("ComposeFilter");
        return filter;
    }
};

void doInitialize() {
    OH_EffectFilterInfo *filterInfo = OH_EffectFilterInfo_Create();
    if (filterInfo == nullptr) {
        LOGI("OH_EffectFilter_GetValue fail!");
        return;
    }
    OH_EffectFilterInfo_SetFilterName(filterInfo, "ComposeFilter");
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