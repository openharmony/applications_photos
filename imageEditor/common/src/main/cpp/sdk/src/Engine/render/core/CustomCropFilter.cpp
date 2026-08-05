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
#include <algorithm>
#include <cmath>
#include <cstring>
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
    float rotationZ;
    float cropRotate;
    bool isDragImage = false;
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
    float rotationZ = filterInfo.rotationZ;
    float cropRotate = filterInfo.cropRotate;
    
    int bytesPerPixel = 4;
    dst.width = viewportX;
    dst.height = viewportY;
    dst.rowSize = dst.width * bytesPerPixel;
    dst.format = src.format;
    dst.addr = malloc(dst.rowSize * dst.height);
    memset_s(dst.addr, dst.rowSize * dst.height, 0, dst.rowSize * dst.height);

    float totalRotate = rotationZ + cropRotate;
    float centerX = viewportX / 2.0f;
    float centerY = viewportY / 2.0f;
 
    float totalScaleX = ratioX * scaleX;
    float totalScaleY = ratioY * scaleY;
    if (totalScaleX == 0 || totalScaleY == 0) {
        return;
    }
 
    float halfSrcW = static_cast<float>(src.width) / 2.0f;
    float halfSrcH = static_cast<float>(src.height) / 2.0f;

    // 计算旋转后在dst空间的包围盒，减少遍历范围
    float rad = totalRotate * static_cast<float>(M_PI) / 180.0f;
    float c = cosf(rad);
    float s = sinf(rad);
    auto rotatePoint = [&](float x, float y) -> std::pair<float, float> {
        return { c * x - s * y, s * x + c * y };
    };
    std::pair<float, float> p0 = rotatePoint((-halfSrcW) * totalScaleX, (-halfSrcH) * totalScaleY);
    std::pair<float, float> p1 = rotatePoint(( halfSrcW) * totalScaleX, (-halfSrcH) * totalScaleY);
    std::pair<float, float> p2 = rotatePoint(( halfSrcW) * totalScaleX, ( halfSrcH) * totalScaleY);
    std::pair<float, float> p3 = rotatePoint((-halfSrcW) * totalScaleX, ( halfSrcH) * totalScaleY);

    float minX = std::min(std::min(p0.first, p1.first), std::min(p2.first, p3.first));
    float maxX = std::max(std::max(p0.first, p1.first), std::max(p2.first, p3.first));
    float minY = std::min(std::min(p0.second, p1.second), std::min(p2.second, p3.second));
    float maxY = std::max(std::max(p0.second, p1.second), std::max(p2.second, p3.second));

    // dst坐标：center + rotatedScaled + offset（注意Y方向offsetY在原逻辑中是减号，这里保持一致）
    float drawLeft = centerX + minX + offsetX;
    float drawRight = centerX + maxX + offsetX;
    float drawTop = centerY + minY - offsetY;
    float drawBottom = centerY + maxY - offsetY;

    int startX = static_cast<int>(std::max(0.0f, std::floor(drawLeft)));
    int endX   = static_cast<int>(std::min((float)dst.width, std::ceil(drawRight)));
    int startY = static_cast<int>(std::max(0.0f, std::floor(drawTop)));
    int endY   = static_cast<int>(std::min((float)dst.height, std::ceil(drawBottom)));
    if (startX >= endX || startY >= endY) {
        return;
    }
 
    uint8_t* dstData = static_cast<uint8_t*>(dst.addr);
    uint8_t* srcData = static_cast<uint8_t*>(src.addr);
    bool useFastSampling = filterInfo.isDragImage;

    // inverse rotate by -rad; c/s already come from +rad and can be reused.
    float invC = c;
    float invS = s;
    float invScaleX = 1.0f / totalScaleX;
    float invScaleY = 1.0f / totalScaleY;
    float srcStepX = invC * invScaleX;
    float srcStepY = -invS * invScaleY;
    int maxSrcX = src.width - 1;
    int maxSrcY = src.height - 1;
    if (maxSrcX < 0 || maxSrcY < 0) {
        return;
    }

    for (int y = startY; y < endY; ++y) {
        float dy = static_cast<float>(y) - centerY + offsetY;
        float dx = static_cast<float>(startX) - centerX - offsetX;
        float rx = invC * dx + invS * dy;
        float ry = -invS * dx + invC * dy;
        float srcXFloat = rx * invScaleX + halfSrcW;
        float srcYFloat = ry * invScaleY + halfSrcH;

        uint8_t* dstPixel = dstData + y * dst.rowSize + startX * bytesPerPixel;
        for (int x = startX; x < endX; ++x) {
            if (useFastSampling) {
                int srcX = static_cast<int>(lroundf(srcXFloat));
                int srcY = static_cast<int>(lroundf(srcYFloat));
                if (srcX >= 0 && srcX <= maxSrcX && srcY >= 0 && srcY <= maxSrcY) {
                    uint8_t* srcPixel = srcData + srcY * src.rowSize + srcX * bytesPerPixel;
                    memcpy(dstPixel, srcPixel, bytesPerPixel);
                }
            } else if (srcXFloat >= 0.0f && srcYFloat >= 0.0f &&
                srcXFloat < static_cast<float>(maxSrcX) && srcYFloat < static_cast<float>(maxSrcY)) {
                int srcX0 = static_cast<int>(srcXFloat);
                int srcY0 = static_cast<int>(srcYFloat);
                int srcX1 = srcX0 + 1;
                int srcY1 = srcY0 + 1;
                float xFactor = srcXFloat - srcX0;
                float yFactor = srcYFloat - srcY0;

                uint8_t* p00 = srcData + srcY0 * src.rowSize + srcX0 * bytesPerPixel;
                uint8_t* p01 = srcData + srcY0 * src.rowSize + srcX1 * bytesPerPixel;
                uint8_t* p10 = srcData + srcY1 * src.rowSize + srcX0 * bytesPerPixel;
                uint8_t* p11 = srcData + srcY1 * src.rowSize + srcX1 * bytesPerPixel;
                for (int cIndex = 0; cIndex < bytesPerPixel; ++cIndex) {
                    float topVal = p00[cIndex] * (1 - xFactor) + p01[cIndex] * xFactor;
                    float bottomVal = p10[cIndex] * (1 - xFactor) + p11[cIndex] * xFactor;
                    dstPixel[cIndex] = static_cast<uint8_t>(topVal * (1 - yFactor) + bottomVal * yFactor);
                }
            } else {
                int srcX = static_cast<int>(lroundf(srcXFloat));
                int srcY = static_cast<int>(lroundf(srcYFloat));
                srcX = std::clamp(srcX, 0, maxSrcX);
                srcY = std::clamp(srcY, 0, maxSrcY);
                uint8_t* srcPixel = srcData + srcY * src.rowSize + srcX * bytesPerPixel;
                memcpy(dstPixel, srcPixel, bytesPerPixel);
            }

            srcXFloat += srcStepX;
            srcYFloat += srcStepY;
            dstPixel += bytesPerPixel;
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
    OH_EffectFilter_GetValue(filter, "rotationZ", &value);
    // rotationZ可能由外部以float/double两种类型写入，这里兼容读取
    if (value.dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_DOUBLE) {
        filterInfo.rotationZ = static_cast<float>(value.dataValue.doubleValue);
    } else {
        filterInfo.rotationZ = value.dataValue.floatValue;
    }
    OH_EffectFilter_GetValue(filter, "cropRotate", &value);
    if (value.dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_DOUBLE) {
        filterInfo.cropRotate = static_cast<float>(value.dataValue.doubleValue);
    } else {
        filterInfo.cropRotate = value.dataValue.floatValue;
    }
    ImageEffect_Any dragValue;
    memset_s(&dragValue, sizeof(ImageEffect_Any), 0, sizeof(ImageEffect_Any));
    OH_EffectFilter_GetValue(filter, "isDragImage", &dragValue);
    if (dragValue.dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_INT32) {
        filterInfo.isDragImage = dragValue.dataValue.int32Value != 0;
    } else if (dragValue.dataType == ImageEffect_DataType::EFFECT_DATA_TYPE_BOOL) {
        filterInfo.isDragImage = dragValue.dataValue.boolValue;
    }
    
    EffectBufferInfo outputBufferInfo;
    // 调用自定义滤镜算法。
    ApplyCustomAlgo(inputBufferInfo, outputBufferInfo, filterInfo);
    
    OH_EffectBufferInfo *outputOhInfo = OH_EffectBufferInfo_Create();
    OH_EffectBufferInfo_SetAddr(outputOhInfo, outputBufferInfo.addr);
    OH_EffectBufferInfo_SetWidth(outputOhInfo, outputBufferInfo.width);
    OH_EffectBufferInfo_SetHeight(outputOhInfo, outputBufferInfo.height);
    OH_EffectBufferInfo_SetRowSize(outputOhInfo, outputBufferInfo.rowSize);
    OH_EffectBufferInfo_SetEffectFormat(outputOhInfo, outputBufferInfo.format);
    
    pushData(filter, outputOhInfo);
    
    OH_EffectBufferInfo_Release(outputOhInfo);
    if (outputBufferInfo.addr != NULL) {
        free(outputBufferInfo.addr);
        outputBufferInfo.addr = nullptr;
    }
    inputBufferInfo.addr = nullptr;
    
    return true;
}

ImageEffect_FilterDelegate filterDelegate = {
    .setValue = [](OH_EffectFilter *filter, const char *key, const ImageEffect_Any *value) {
        HMC_UNUSED(filter);
        HMC_UNUSED(key);
        HMC_UNUSED(value);
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

bool doInitialize()
{
    OH_EffectFilterInfo *filterInfo = OH_EffectFilterInfo_Create();
    if (filterInfo == nullptr) {
        LOGE("CustomCropFilter doInitialize failed: filterInfo is null");
        return false;
    }
    OH_EffectFilterInfo_SetFilterName(filterInfo, "CustomCropFilter");
    ImageEffect_BufferType bufferTypeArray[] = {ImageEffect_BufferType::EFFECT_BUFFER_TYPE_PIXEL};
    OH_EffectFilterInfo_SetSupportedBufferTypes(filterInfo, sizeof(bufferTypeArray) / sizeof(ImageEffect_BufferType),
                                                bufferTypeArray);
    ImageEffect_Format formatArray[] = { ImageEffect_Format::EFFECT_PIXEL_FORMAT_RGBA8888  };
    OH_EffectFilterInfo_SetSupportedFormats(filterInfo, sizeof(formatArray) / sizeof(ImageEffect_Format), formatArray);
    
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_Register(filterInfo, &filterDelegate);
    if (errorCode != ImageEffect_ErrorCode::EFFECT_SUCCESS) {
        LOGE("CustomCropFilter register failed, errorCode=%d", (int)errorCode);
        return false;
    }
    LOGI("CustomCropFilter register success");
    return true;
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
        bool ok = doInitialize();
        // 只有注册成功才标记初始化完成，避免首次失败后永久无法恢复
        this->isInitialized_ = ok;
        return ok;
    }
}