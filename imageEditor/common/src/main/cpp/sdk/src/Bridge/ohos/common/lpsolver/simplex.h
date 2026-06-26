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

#ifndef oh_simplex.h_H
#define oh_simplex.h_H

#include <stddef.h>

/**
 * 获取不规则凸四边形内接的最大矩形
 * @param corners
 * 不规则凸四边形的四个顶点坐标，分别为左上角x，左上角y，右上角x，右上角y，右下角x，右下角y，左下角x，左下角y
 * @param ratio 内接矩形的比例
 * @param outputRect 输出的最大矩形
 * @return true表示有最优解，false表示无最优解
 */
bool getLargestAlignedRect(float *corners, float ratio, float *outputRect);

/**
 * 获取不规则凸四边形内接的最大矩形
 * @param corners
 * 不规则凸四边形的四个顶点坐标，分别为左上角x，左上角y，右上角x，右上角y，右下角x，右下角y，左下角x，左下角y
 * @param ratio 内接矩形的比例
 * @param centerX 内接矩形中心点X
 * @param centerY 内接矩形中心点Y
 * @param outputRect 输出的最大矩形
 * @return true表示有最优解，false表示无最优解
 */
bool getLargestAlignedRect(float *corners, float ratio, float centerX, float centerY, float *outputRect);

/**
 * 获取将指定矩形移动到不规则凸四边形内的最小移动距离
 * @param corners
 * 规则凸四边形的四个顶点坐标，分别为左上角x，左上角y，右上角x，右上角y，右下角x，右下角y，左下角x，左下角y
 * @param inputRect 指定的矩形
 * @param outputRect 最小移动的距离对应的矩形
 * @return true表示有最优解，false表示无最优解
 */
bool getNearestMovement(float *corners, unsigned cornersSize, float *inputRect, unsigned inputRectSize,
    float *outputRect, unsigned outputRectSize);

bool getLargestRectUnderRatio(float *corners, float *limitation, float centerX, float centerY, float targetRatio,
    float *outputOffset);

/**
 * 获取可到达的裁剪框
 *
 * @param corners 素材顶点信息
 * @param inputRect 裁剪框
 * @param targetRatio 裁剪框固定的宽高比，0代表不固定比例
 * @param direction
 * 用来标志拖动的方向，4位int，分别代表left,top,right,bottom，当值为1时表示该边可拖动，至少存在一个1，最多存在两个1
 * @param outputRect 更新后可到达的裁剪框
 * @return true表示可以获取到，false表示无法获取
 */
bool getReachableRect(float *corners, float *input, float targetRatio, int *direction, float *outputOffset);

/**
 * 自由比例模式判断裁剪框坐标是否在素材范围内
 *
 * @param corners        素材顶点信息
 * @param cornersSize    数组大小
 * @param inputRect      裁剪框
 * @param inputRectSize  数组大小
 * @param outputRect     更新后可到达的裁剪框
 * @param outputRectSize 数组大小
 * @return true表示在素材内，false表示不在素材内
 */
bool getReachableRectFreeRatio(float *corners, size_t cornersSize, float *inputRect, size_t inputRectSize,
    float *outputRect, size_t outputRectSize);

#endif // oh_simplex.h_H
