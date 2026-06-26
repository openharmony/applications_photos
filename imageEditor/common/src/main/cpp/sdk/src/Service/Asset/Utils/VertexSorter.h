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

#ifndef OH_VERTEX_SORTER_H
#define OH_VERTEX_SORTER_H

#include <vector>

constexpr int LEFT_TOP = 0;
constexpr int RIGHT_TOP = 1;
constexpr int RIGHT_DOWN = 2;
constexpr int LEFT_DOWN = 3;

constexpr double COMPARE_PRECISION = 1e-2; // 比较精度误差

float g_floatAccuracy = 0.01F; // 避免浮点运算误差导致相同的x值判断成了左上、右上两个点

struct PointF {
    float x;
    float y;
};

// 表示一般型直线方程 ax + by = c
struct Line {
    float a;
    float b;
    float c;
};

bool ProcessSortResult(const std::vector<std::vector<PointF>> &inputResult, std::vector<float> &outputResult);
bool GetCrossPoint(const std::vector<PointF> &inputRect, PointF &crossPoint);
void SolveLine(const PointF &a, const PointF &b, Line &line);
std::vector<float> PointF2Float(const std::vector<PointF> &inputPoint);

double CrossProductZ(const PointF &a, const PointF &b)
{
    return a.x * b.y - a.y * b.x;
}

/**
 * 计算a、b、c三角形的方向，返回值小于0表示顺时针，大于0表示逆时针，等于0表示一条直线
 */
double Orientation(const PointF &a, const PointF &b, const PointF &c)
{
    return CrossProductZ(a, b) + CrossProductZ(b, c) + CrossProductZ(c, a);
}

/**
 * 判断a、b、c、d四个点是否满足左上、右上、右下、左下顺序
 */
bool IsClockwiseStartFromTopLeft(const PointF &a, const PointF &b, const PointF &c, const PointF &d)
{
    if (Orientation(a, b, c) < 0.0 && a.x < b.x && b.y > c.y && abs(a.x - b.x) > g_floatAccuracy &&
        abs(b.y - c.y) > g_floatAccuracy) {
        if (Orientation(a, c, d) < 0.0 && c.x > d.x && a.y > d.y && abs(c.x - d.x) > g_floatAccuracy &&
            abs(a.y - d.y) > g_floatAccuracy) {
            return true;
        }
    }
    return false;
}

/**
 * 全排列递归实现
 */
void Permute(std::vector<PointF> &input, int start, std::vector<std::vector<PointF>> &result)
{
    if (start >= input.size()) {
        if (IsClockwiseStartFromTopLeft(input[0], input[1], input[2], input[3])) {
            result.push_back(input);
        }
        return;
    }

    for (int i = start; i < input.size(); i++) {
        std::swap(input[start], input[i]);
        Permute(input, start + 1, result);
        std::swap(input[start], input[i]);
    }
}

/**
 * 为了方便进行线性规划运算，对四边形的点进行排序，按左上、右上、右下、左下顺序返回；
 * 上下左右边定义：x，y为四边形内的一点，y值可以表示为上边线与下边线之间，x在左边线与右边线之间；
 */
std::vector<float> SortVertex(const std::vector<float> &vertex)
{
    std::vector<PointF> points = {
        {vertex[0], vertex[1]}, {vertex[2], vertex[3]}, {vertex[4], vertex[5]}, {vertex[6], vertex[7]}};
    std::vector<std::vector<PointF>> result;
    // 1. 全排列找出所有满足指定顺序的解
    Permute(points, 0, result);

    // 2. 找出满足左上、右上、右下、左下顺序的唯一解
    std::vector<float> outputResult;
    bool success = ProcessSortResult(result, outputResult);
    if (success) {
        return outputResult;
    }

    return vertex;
}


/**
 * 处理有多个满足左上、右上、右下、左下排序条件的场景
 * 对于如下四边形同时有两个解abcd和 bcda，起始点坐标在对角线交点坐标左上角为满足条件排序结果
 *
 *    a  /¯¯--__ b
 *      /      /
 *    d ¯¯--__/ c
 *
 * @param inputResult  顺时针排序的多组解
 * @param outputResult 满足条件的唯一解
 * @return 是否找到解
 */
bool ProcessSortResult(const std::vector<std::vector<PointF>> &inputResult, std::vector<float> &outputResult)
{
    if (inputResult.empty()) {
        return false;
    }

    outputResult = PointF2Float(inputResult[0]);

    // 1. 只有一组解，返回当前值
    if (inputResult.size() == 1) {
        return true;
    }

    // 2. 有两组解的场景，找出起点为左上的解
    std::vector<PointF> secondResult = inputResult[1];
    PointF center;
    bool isCross = GetCrossPoint(secondResult, center);
    if (isCross && secondResult[LEFT_TOP].x < center.x &&
        (fabs(secondResult[LEFT_TOP].y - center.y) < COMPARE_PRECISION || (secondResult[LEFT_TOP].y > center.y))) {
        outputResult = PointF2Float(secondResult);
    }
    return true;
}

/**
 * 求凸四边形对角线ac、bd的交点坐标
 *
 * @param inputRect 四边形a,b,c,d四个点坐标
 * @param crossPoint 对角线交点坐标
 * @return 是否有交点
 */
bool GetCrossPoint(const std::vector<PointF> &inputRect, PointF &crossPoint)
{
    PointF lt = inputRect[LEFT_TOP];
    PointF rt = inputRect[RIGHT_TOP];
    PointF rd = inputRect[RIGHT_DOWN];
    PointF ld = inputRect[LEFT_DOWN];
    Line line1;
    Line line2;

    SolveLine(lt, rd, line1);
    SolveLine(rt, ld, line2);
    float detBase = CrossProductZ(PointF{line1.a, line1.b}, PointF{line2.a, line2.b});
    if (fabsf(detBase) < 1e-6) {
        return false;
    }

    float dx = CrossProductZ(PointF{line1.c, line1.b}, PointF{line2.c, line2.b});
    float dy = CrossProductZ(PointF{line1.a, line1.c}, PointF{line2.a, line2.c});

    crossPoint.x = dx / detBase;
    crossPoint.y = dy / detBase;
    return true;
}

void SolveLine(const PointF &a, const PointF &b, Line &line)
{
    line.a = b.y - a.y;
    line.b = a.x - b.x;
    line.c = a.x * b.y - b.x * a.y;
}

std::vector<float> PointF2Float(const std::vector<PointF> &inputPoint)
{
    std::vector<float> outputPoint = {inputPoint[LEFT_TOP].x,  inputPoint[LEFT_TOP].y,   inputPoint[RIGHT_TOP].x,
                                      inputPoint[RIGHT_TOP].y, inputPoint[RIGHT_DOWN].x, inputPoint[RIGHT_DOWN].y,
                                      inputPoint[LEFT_DOWN].x, inputPoint[LEFT_DOWN].y};
    return outputPoint;
}
#endif // OH_VERTEX_SORTER_H
