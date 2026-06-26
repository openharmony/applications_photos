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

#ifndef OH_HVE_ASSET_OPER_H
#define OH_HVE_ASSET_OPER_H

#include "ohos/common/Animation.h"
#include "ohos/common/HmcUidHelper.h"
#include "ohos/hve/HveTimeline.h"
#include "render/platform/ohos/nativerender/render/plugin_render.h"
#include "ohos/common/lpsolver/simplex.h"
#include "util/HmcRectD.h"
#include "ohos/undoredo/UndoRedoManager.h"

constexpr double PREVIEW_MAX_SCALE = 2.0;         // 预览模式下缩放最大倍数
constexpr double PREVIEW_REBOUND_MAX_SCALE = 3.0; // 预览模式下缩放回弹最大倍数
constexpr double PREVIEW_REBOUND_MIN_SCALE = 0.5; // 预览模式下缩放回弹最小倍数
constexpr double CROP_MAX_SCALE = 25.0;           // 裁剪模式下缩放最大倍数
constexpr double CROP_REBOUND_MAX_SCALE = 30.0;   // 裁剪模式下缩放回弹最大倍数
constexpr double CROP_REBOUND_MIN_SCALE = 1.0;    // 裁剪模式下缩放回弹最小倍数
constexpr float PREVIEW_MAX_PIXEL_SCALE = 6.0;    // 预览区单边像素最大放大极值
constexpr SIZE_T RECT_SIZE = 4;
constexpr SIZE_T CROP_VERTEX_SIZE = 8;

constexpr double DOUBLE_PRECISION = 1e-6; // double类型精度误差
constexpr double COMPARE_PRECISION = 1e-2;        // 比较精度误差

const std::string NAPI_JSON_ERROR_RETURN = "{\"code\": -1}";

// 单指移动或双指缩放动作结束
const std::string MOVE_SCALE_END = "MOVE_OR_SCALE_END";

typedef enum ClipRatioType {
    OTHER_TYPE_CROP,
    SPECIFIED_RATIO_CLICK_CROP,
    DRAG_CROP
} ClipRatioType;

typedef enum CropAssetOperation {
    OTHER_TYPE_OPER,
    ONE_FINGER_MOVE_START,
    ONE_FINGER_MOVE_END,
    TWO_FINGER_SCALE_START,
    TWO_FINGER_SCALE_END
} CropAssetOperation;

typedef struct HmcAssetArea {
    float width;
    float height;
    float posX;
    float posY;
} HmcAssetArea;

typedef struct UpdateCanvasRect {
    HmcSize oldCanvasSize;
    HmcSize newCanvasSize;
    HmcRectD oldCropRect;
    HmcRectD newCropRect;
} UpdateCanvasRect;

typedef struct UpdateAssetArea {
    HmcSize srcCanvas;
    HmcSize dstCanvas;
    HmcRectD srcDefaultCropRect;
    HmcRectD dstDefaultCropRect;
} UpdateAssetArea;

class HveAssetOper {
public:
    static bool AssetSizeIsExchanged(float baseRotation);
    static void SetPosition(HveTimeline *timeline, HmcUid assetUid, float posX, float posY, float width, float height,
        double animMs, bool needAutoFlush, const HmcRectD &cropRect);
    static void GetCenterInsideRectUnderRatio(float dstRatio, const HmcRectD &rect, HmcRectD *outputRect);
    static void ResetPosition(HveTimeline *timeline, HmcUid &assetUid);
    static HmcUid FindEffectByType(HmcEditor *editor, HmcUid assetUid, HmcEffectType type);
    static void InitAsset(HveTimeline *timeline, HmcUid &assetUid);
    static void UpdateAsset(HveTimeline *timeline, const HmcUid &assetUid, HmcSize newCanvasSize,
        const HmcRectD &oldCropOperationArea, bool isDeviceVertical, int animationType);
    static void UpdatePreviewModeAsset(HveTimeline *timeline, HmcUid &assetUid, const HmcRectD &oldCropRect,
        const HmcRectD &newCropRect, const HmcRectD &oldCropOperationArea, HmcSize oldCanvasSize, float cropScale);
    static void UpdateAssetDefaultArea(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &cropOperationArea,
        HmcSize newCanvasSize, HmcSize oldCanvasSize);
    static HmcAssetPoint CalPreviewAssetPos(HveTimeline *timeline, HmcUid &assetUid, const HmcRectD &oldCropRect,
        const HmcRectD &newCropRect, HmcSize oldCanvasSize, float cropScale);

    static void UpdateAssetDefaultInfo(HveAsset *asset, UpdateAssetArea area, int isHorizontalMirror);
    static HmcRectD SetCropRectInner(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &rect,
        const HmcRectD &cropOperationArea, double animMs, int type, bool needAutoFlush, bool isRotationOper);
    static void SetPositionXY(HveTimeline *timeline, HmcRectD &assetPos, float canvasWidth,
        float canvasHeight, auto hveAsset, HmcRectD &cropRect, HmcUid &assetUid,
        double animMs, bool needAutoFlush, const HmcRectD &rect, int type, bool isRotationOper);
    static void SetNewAssetSize(HmcEditor *editor, HmcUid assetUid, HmcSize size, double scale);
    static bool CalcOptimalCropRect(float *vertex, std::function<bool(float *, float *, float *)> rule, float *input,
                                    size_t inputSize, float *output, size_t outputSize, int watermarkType);
    static bool CalcOptimalCropRect(HmcEditor *editor, HmcUid assetUid,
        std::function<bool(float *, float *, float *)> rule, float *input, size_t inputSize, float *output,
        size_t outputSize);
    static void FillPreviewRect(HveTimeline *timeline, HmcUid assetUid, double animMs,
        std::function<bool(float *, float *, float *)> rule);
    static void PreviewAnimation(HveTimeline *timeline, HmcUid assetUid, auto cropRect, float output[],
        double scaleSize, auto previewOffsetX, auto previewOffsetY, double animMs);
    static bool ScaleRectArray(float scaleSize, float *input, size_t inputSize, float *output, size_t outputSize);
    static void FillCropRect(HveTimeline *timeline, HmcUid assetUid, double animMs, const HmcRectD &cropRect,
        std::function<bool(float *, float *, float *)> rule);
    static void FillCropRectForRotation(HveTimeline *timeline, HmcUid assetUid, double animMs, const HmcRectD &cropRect,
        std::function<bool(float *, float *, float *)> rule);
    static bool MoveRule(float *corners, float *input, float *output);
    static bool DefaultRule(float *corners, float *input, float *output);
    static bool RotateRule(float *corners, float *input, float *output);
    static bool SwitchRatioRule(float ratio, float *corners, float *input, float *output);
    static bool GetDisplayResultbyRatio(HmcUid assetUid, float ratio, float *input, size_t inputSize, float *output,
        size_t outputSize);
    static bool ReachableRectRule(float ratio, int *direction, float *corners, float *input, float *output);
    static bool CalcReachableBoundaryCropRect(float *vertex, const HmcRectD &cropRect, HmcRectD *outRect,
                                              int watermarkType);
    static void GetReachableBoundaryOffset(const HmcRectD &translateCropRect, const HmcRectD &cropRect,
        bool isPreviewMode, int screenOperationType, double inputOffsetX, double inputOffsetY, double *fixOffsetX,
        double *fixOffsetY);
    static bool IsReachableBoundary(const HmcRectD &translateCropRect, const HmcRectD &cropRect);
    static void VertexTranslate(float *vertex, double offsetX, double offsetY);
    static float GetAssetScaleForRotate90Acw(const HmcRectD &oldRectD, double width, double height);
    static void StartMirrorAnimation(HmcEditor *editor, HveTimeline *timeline, HmcUid assetUid);
    static void UpdateCropLimitation(HveTimeline *timeline);
    static void UpdateCropLimitation(HveTimeline *timeline, const HmcRectD &rect, const HmcRectD &cropRect, int type);
    static void UpdateCropLimitation(HveTimeline *timeline, const HmcRectD &oldCropRect, const HmcRectD &newCropRect,
        const HmcRectD &cropLimitation, double cropScale);
    static void FixDefaultCropRect(HveTimeline *timeline, HmcUid assetUid, HmcRectD *outputRect);
    static void UpdateBaseRotationAssetSize(HveTimeline *timeline, HmcUid assetUid);
    static void PreviewScaleVibration(HveTimeline *timeline, HmcUid assetUid, CropAssetOperation cropType,
        std::function<void(std::string const & jsonPos)> cb);
    static float CalPreviewMaxScale(HveTimeline *timeline, HmcUid assetUid);
    static bool IsReachableMaxScale(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &rotationCropRect);
    static void SetCropRectForRotation(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &cropRect);
    static void GetMinCropSize(HveTimeline *timeline, HmcUid assetUid, double ratio, double *minCropW,
        double *minCropH);
    static HmcAssetPoint CalAssetPositionByCanvas(UpdateCanvasRect updCanvasCropRect, HmcAssetPoint inputPosition,
        float cropScale, bool isHorizontalMirror);
    static HmcRectD CheckCropRectBoundary(const HmcRectD &boundaryArea, const HmcRectD &inputRect);
    static bool GreatNotEqual(double num1, double num2);
    static bool GreatAndEqual(double num1, double num2);
    static bool LessNotEqual(double num1, double num2);
    static bool LessAndEqual(double num1, double num2);
    static void ProcessEndCb(HveTimeline *timeline, const HmcUid &assetUid);
};

#endif // oh_HveAssetOper_H
