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

#ifndef VIDEO_TRANSFORM_INFO_H
#define VIDEO_TRANSFORM_INFO_H

#include "DefaultValue/HmcDefaultValueManager.h"

struct VisionTransformInfo {
    PropertyType<FLOAT> offsetX{ 0.0f, TRUE }; // 中心点平移距离的x坐标
    PropertyType<FLOAT> offsetY{ 0.0f, TRUE }; // 中心点平移距离的y坐标
    PropertyType<FLOAT> offsetZ{ 0.0f, TRUE }; // 中心点平移距离的z坐标
    // 图像旋转角度(逆时针，0°~360°)
    PropertyType<FLOAT> rotationX{ 0.0f, TRUE };
    PropertyType<FLOAT> rotationY{ 0.0f, TRUE };
    PropertyType<FLOAT> rotationZ{ 0.0f, TRUE };

    // 图像缩放比例,由用户设置
    PropertyType<FLOAT> scaleX{ 1.0f, TRUE };
    PropertyType<FLOAT> scaleY{ 1.0f, TRUE };
    PropertyType<FLOAT> scaleZ{ 1.0f, TRUE };
    // 图像缩放比例,由画布调整得到
    FLOAT ratioX = 1.0;
    FLOAT ratioY = 1.0;
    FLOAT scale = 1.0;       // 后期废除
    FLOAT scaleReduce = 1.0; // 图像和原始视频比例变化，后用于降采样使用
    // 图像变换的参考点x坐标
    FLOAT refX = 0;
    // 图像变换的参考点y坐标
    FLOAT refY = 0;

    PropertyType<BOOL> mirrorHorizontal{ FALSE, TRUE };
    PropertyType<BOOL> mirrorVertical{ FALSE, TRUE };
    PropertyType<FLOAT> opacity{ 1.0f, TRUE };
    
    VisionTransformInfo& operator=(const VisionTransformInfo &other)
    {
        if (this != &other) {
            this->offsetX = other.offsetX;
            this->offsetY = other.offsetY;
            this->offsetZ = other.offsetZ;
            this->rotationX = other.rotationX;
            this->rotationY = other.rotationY;
            this->rotationZ = other.rotationZ;
            this->scaleX = other.scaleX;
            this->scaleY = other.scaleY;
            this->scaleZ = other.scaleZ;
            this->opacity = other.opacity;
            this->mirrorHorizontal = other.mirrorHorizontal;
            this->mirrorVertical = other.mirrorVertical;
            this->ratioX = other.ratioX;
            this->ratioY = other.ratioY;
            this->scale = other.scale;
            this->scaleReduce = other.scaleReduce;
            this->refX = other.refX;
            this->refY = other.refY;
        }
        return *this;
    }
    
    bool operator==(const VisionTransformInfo &other) const
    {
        auto isEqual = [](float a, float b) -> bool {
            float diff = a - b;
            return (diff < 0 ? -diff : diff) < EPSILON;
        };
        
        return isEqual(this->offsetX.GetValue(), other.offsetX.GetValue()) &&
            isEqual(this->offsetY.GetValue(), other.offsetY.GetValue()) &&
            isEqual(this->offsetZ.GetValue(), other.offsetZ.GetValue()) &&
            isEqual(this->rotationX.GetValue(), other.rotationX.GetValue()) &&
            isEqual(this->rotationY.GetValue(), other.rotationY.GetValue()) &&
            isEqual(this->rotationZ.GetValue(), other.rotationZ.GetValue()) &&
            isEqual(this->scaleX.GetValue(), other.scaleX.GetValue()) &&
            isEqual(this->scaleY.GetValue(), other.scaleY.GetValue()) &&
            isEqual(this->scaleZ.GetValue(), other.scaleZ.GetValue()) &&
            isEqual(this->opacity.GetValue(), other.opacity.GetValue()) &&
            this->mirrorHorizontal.GetValue() == other.mirrorHorizontal.GetValue() &&
            this->mirrorVertical.GetValue() == other.mirrorVertical.GetValue() &&
            isEqual(this->ratioX, other.ratioX) &&
            isEqual(this->ratioY, other.ratioY) &&
            isEqual(this->scale, other.scale) &&
            isEqual(this->scaleReduce, other.scaleReduce) &&
            isEqual(this->refX, other.refX) &&
            isEqual(this->refY, other.refY);
    }
};

using RenderTransformInfo = VisionTransformInfo;

using RenderTransformInfoPtr = SHARED_PTR<RenderTransformInfo>;

#endif // VIDEO_TRANSFORM_INFO_H
