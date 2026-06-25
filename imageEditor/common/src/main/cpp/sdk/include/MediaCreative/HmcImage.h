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

#ifndef HMCIMAGE_H
#define HMCIMAGE_H


#ifdef __OBJC__
#include <CoreGraphics/CoreGraphics.h>
#endif

#if (QT_VERSION >= 0x050000)
#include <QtGui/QImage>
#endif


#ifdef __cplusplus
extern "C" {
#endif

// 自定义图片对象
typedef void HmcImage;

#ifdef __OBJC__

/**
 * HmcImage对象转换成CGImage对象
 * @param image         待转换HmcImage对象
 * @return              转换出的CGImage位图对象，需要使用CGImageRelease接口释放
 */
HMC_API CGImageRef HmcImageToCGImage(HmcImage *image);

/**
 * 从CGImage创建HmcImage对象
 * @param image			CGImage对象
 * @return             	HmcImage对象，必须使用HmcImageDestroy接口释放<br>
 * 	NULL表示创建失败
 */
HMC_API HmcImage *HmcImageCreateFromCGImage(CGImageRef image);

#endif // __OBJC__

#if (QT_VERSION >= 0x050000)
HMC_API QImage *HmcImageToQImage(HmcImage *image);
#endif

/**
 * 释放HmcImage对象
 * @param image         待释放转换HmcImage对象
 */
HMC_API void HmcImageDestroy(HmcImage *image);

/**
 * 判断是否gpu缓存
 */
HMC_API int HmcImageIsGpuTexture(HmcImage *image);

/**
 * 从gpu拷贝数据到cpu
 * @param image         HmcImage对象
 * @return             	HmcImage对象，必须使用HmcImageDestroy接口释放<br>
 * 	NULL表示创建失败
 */
HMC_API HmcImage *HmcImageTransferFromGpu(HmcImage *image);


#ifdef __cplusplus
}
#endif

#endif // HMCIMAGE_H
