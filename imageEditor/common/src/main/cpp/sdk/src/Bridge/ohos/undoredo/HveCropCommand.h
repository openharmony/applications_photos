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

#ifndef OH_HVE_CROP_COMMAND_H
#define OH_HVE_CROP_COMMAND_H

#include "HveCommand.h"
#include "ohos/interface/index.h"
#include "ohos/hve/HveAssetOper.h"

constexpr int REVERSE_CROP_CALL_TIMES = 40;
constexpr double LIGHT_PRESSURE_CROP_PERCENTAGE = 0.2;
constexpr double HEAVY_PRESSURE_CROP_PERCENTAGE = 0.4;

typedef enum UndoRedoCommandType {
    COMMAND_EXECUTE,
    COMMAND_UNDO,
    COMMAND_REDO
} UndoRedoCommandType;

class HveCmdCropBase : public HveCommand {
public:
    HveCmdCropBase(int timelineId, std::string const & assetId, std::string const & type);
    ~HveCmdCropBase() override;

    std::string Undo() override;
    std::string Redo() override;
    int Merge() override;
    int UpdateCropLastAssetData();
    int UpdateCropCurAssetData();

    inline HmcRectD GetLastCropRect() const { return m_lastCropRect; }

private:
    int CalAssetPosByUpdateCanvas(HmcEditor *editor, const HmcUid &assetUid, const HmcRectD &newCropRect,
        const HmcRectD &oldCropRect, HmcAssetPoint inputPosition, double cropScale, float *assetPosX, float *assetPosY);
    HmcRectD CalCropRectByUpdateCanvas(const HmcRectD &newCropRect, const HmcRectD &oldCropRect, double cropScale);

private:
    HmcRectD m_curCropRect = { 0, 0, 0, 0 };
    HmcRectD m_lastCropRect = { 0, 0, 0, 0 };
    HmcRectD m_curCropLimitation = { 0, 0, 0, 0 };
    HmcRectD m_lastCropLimitation = { 0, 0, 0, 0 };

    HmcSize m_lastAssetSize{ 0.0F };
    HmcSize m_curAssetSize{ 0.0F };
    HmcSize m_cmdCanvasSize{ 0.0F };
    HmcSize m_lastBaseRotationAssetSize{ 0.0F };
    HmcSize m_curBaseRotationAssetSize{ 0.0F };
    HmcAssetPoint m_lastAssetPos{ 0.0F };
    HmcAssetPoint m_curAssetPos{ 0.0F };
};

class HveCmdSetRotation final : public HveCommand {
public:
    HveCmdSetRotation(int timelineId, std::string const & assetId, double rotation, int axis, std::string const & type);
    ~HveCmdSetRotation() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int Merge() final;

    int ComSetRotation(int timelineId, std::string const & assetId, double rotation, int axis, bool previewMode);
    void CalculateCoordinates(auto &cropRect, auto &newRotation, bool &previewMode, int &axis);
    int UpdateRotationLastAssetData();
    int UpdateRotationCurAssetData();
    void FillCropRectAndSwitchMode(double animMs, const HmcRectD &cropRect, bool previewMode,
        std::function<bool(float *, float *, float *)> rule);
    static void UpdateCropRectLimitation(HveTimeline *timeline, const HmcRectD &undoRedoCropRect,
        const HmcRectD &undoRedoCropLimitation, bool isDefaultCanvas);
    static void UpdateBaseRotationAsset(HveTimeline *timeline, HmcUid assetUid, const HmcRectD &undoRedoCropRect,
        float assetWidth, float assetHeight, bool isDefaultCanvas);
    static bool IsDefaultCanvas(HveTimeline *timeline, float oldCanvasWidth, float oldCanvasHeight);
    static float CalCropRectRadio(const HmcRectD &newCropRect, const HmcRectD &undoRedoCropRect);

private:
    int curAxis;
    double curRotation;
    double lastRotation = 0.0f;
    HmcRectD curCropLimitation;
    HmcRectD lastCropLimitation;
    HmcRectD cmdCropRect;
    float cmdCanvasWidth = 0.0f;
    float cmdCanvasHeight = 0.0f;
    float curBaseRotationAssetWidth = 0.0f;
    float lastBaseRotationAssetWidth = 0.0f;
    float curBaseRotationAssetHeight = 0.0f;
    float lastBaseRotationAssetHeight = 0.0f;
};

class HveCmdRotate90Acw final : public HveCommand {
public:
    HveCmdRotate90Acw(int timelineId, std::string const & assetId, std::function<void(std::string const & jsonPos)> cb,
        int frame, std::string const & type);
    ~HveCmdRotate90Acw() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int ComRotate90Acw(int timelineId, std::string const & assetId, std::function<void(std::string const & jsonPos)> cb,
        UndoRedoCommandType commandType);
    int UndoRedoRotate90Acw(float scale, float newRotation, HmcSize size, HmcAssetPoint assetPosition,
        const HmcRectD &cropRect);
    int UpdateRotate90AcwLastAssetData();
    int UpdateRotate90AcwCurAssetData();

    int CalculateRotation(HmcRectD &cropRect, int &isHorizontalMirror, UndoRedoCommandType &commandType,
        float &canvasWidth, float &canvasHeight, std::function<void(std::string const &jsonPos)> &cb);
    int CalculateScaling(HmcRectD &cropRect, HmcAssetPoint &assetPosition, float &canvasWidth,
        float &canvasHeight, float &baseOffsetX, int &isHorizontalMirror, UndoRedoCommandType &commandType,
        std::function<void(std::string const & jsonPos)> &cb);
    int RotationPreview(HmcRectD &cropRect, auto &scale, HmcSize &size, HmcAssetPoint &assetPosition,
        std::function<void(std::string const & jsonPos)> &cb);
    int BackgroundTask(const HmcSize &size, const HmcAssetPoint &assetPosition, const HmcRectD &cropRect,
        bool previewMode, const std::function<void(std::string const &jsonPos)> &cb);
    static bool IsRotateReseting();
    static void SetLastRotateFrame(int lastRotateFrame);

private:
    HmcRectD curCropLimitation;
    HmcRectD lastCropLimitation;
    HmcRectD curCropRect;
    HmcRectD lastCropRect;
    float cmdCanvasWidth = 0.0f;
    float cmdCanvasHeight = 0.0f;
    float curBaseRotationAssetWidth = 0.0f;
    float lastBaseRotationAssetWidth = 0.0f;
    float curBaseRotationAssetHeight = 0.0f;
    float lastBaseRotationAssetHeight = 0.0f;
    std::function<void(std::string const & jsonPos)> cb;
    int frame = 0;
    static bool m_isRotateReseting;
    static UINT64 m_lastRotateResetingTime;
    static int m_lastRotateFrame;
};


class HveCmdSetMirror final : public HveCommand {
public:
    HveCmdSetMirror(int timelineId, std::string const & assetId, int mirrorFlag, int mirrorType,
        std::function<void(std::string const & jsonPos)> cb, std::string const & type);
    ~HveCmdSetMirror() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int CalculateMirrorFlag(int timelineId, std::string const & assetId, int mirrorType, int mirrorFlag);
    int ComSetMirror(int timelineId, std::string const & assetId, int mirrorFlag, int mirrorType,
        std::function<void(std::string const & jsonPos)> cb, UndoRedoCommandType commandType);
    int UpdateMirrorLastAssetData();
    int UpdateMirrorCurAssetData();
    int CorrectionOffset(bool startFlag, float progress, int mirrorFlag, int mirrorType);

private:
    int curMirrorFlag;
    int curMirrorType;
    HmcRectD mirrorCropRect;
    HmcRectD curCropLimitation;
    HmcRectD lastCropLimitation;
    float cmdCanvasWidth = 0.0f;
    float cmdCanvasHeight = 0.0f;
    float curBaseRotationAssetWidth = 0.0f;
    float lastBaseRotationAssetWidth = 0.0f;
    float curBaseRotationAssetHeight = 0.0f;
    float lastBaseRotationAssetHeight = 0.0f;
    std::function<void(std::string const & jsonPos)> cb;
};

class HveCmdSetCropRect final : public HveCommand {
public:
    HveCmdSetCropRect(int timelineId, std::string const & assetId, const HmcRectD &rect, double animMs,
        int clipRatioType, std::string const & chooseRatio, std::string const & type);
    ~HveCmdSetCropRect() final;

    int Execute() final;
    std::string Undo() final;
    std::string Redo() final;
    int UpdateCropRectLastAssetData();
    int UpdateCropRectCurAssetData();
    bool IsChanged();
    int CustomCanvas(float &redoAssetWidth, float &redoAssetHeight, float &redoAssetPosX, float &redoAssetPosY,
                     HmcRectD &redoLastCropRect);

private:
    int clipRatioType = 0;
    double animMs = 0.0;
    HmcRectD inputCropRect;
    HmcRectD curCropRect;
    HmcRectD lastCropRect;
    HmcRectD curCropLimitation;
    HmcRectD lastCropLimitation;
    std::string curChooseRatio;
    std::string lastChooseRatio;

    float cmdCanvasWidth = 0.0f;
    float cmdCanvasHeight = 0.0f;
    float lastAssetPosX = 0.0f;
    float lastAssetPosY = 0.0f;
    float lastAssetWidth = 0.0f;
    float lastAssetHeight = 0.0f;
    float curAssetPosX = 0.0f;
    float curAssetPosY = 0.0f;
    float curAssetWidth = 0.0f;
    float curAssetHeight = 0.0f;
    float curBaseRotationAssetWidth = 0.0f;
    float lastBaseRotationAssetWidth = 0.0f;
    float curBaseRotationAssetHeight = 0.0f;
    float lastBaseRotationAssetHeight = 0.0f;
};

class HveCmdCropAsset final : public HveCmdCropBase {
public:
    HveCmdCropAsset(int timelineId, std::string const & assetId, int cropType, int aniDuration, const HmcRectD &rect,
        std::string const & type);
    ~HveCmdCropAsset() final;

    int Execute() final;

private:
    int UpdateCropAssetLastAssetData();
    int UpdateCropAssetCurAssetData();

private:
    int cropType = 0;
    int aniDuration = 0;
    HmcRectD inputCropRect;
};

class HveCmdReverseCrop final : public HveCmdCropBase {
public:
    HveCmdReverseCrop(int timelineId, std::string const &assetId, std::vector<double> rect, std::vector<int> direction,
                      double ratio, double pressure, std::string const &type);
    ~HveCmdReverseCrop() final;

    int Execute() final;

private:
    /* *
     * 计算反向裁剪单次调用裁剪框增加的位移。
     * 压力小于0.5，按20%/s滚动，压力大于等于0.5，按40%/s滚动
     *
     * @param timeline 当前泳道
     * @param assetUid 剪辑的UID
     * @param offsetX  X轴位移
     * @param offsetY  Y轴位移
     * @return HMC_OK 成功， 其他值 失败
     */
    int CalAssetOffset(HveTimeline *timeline, const HmcUid &assetUid, double *offsetX, double *offsetY);

    /* *
     * 对UI输入的裁剪框进行修正，不超出裁剪可操作区域
     *
     * @param operArea 裁剪可操作区域
     */
    void FixInputCropRect(const HmcRectD &operArea);
    void FixInputRectByFreeRatio(const HmcRectD &operArea);
    void FixInputRectForDragSide3(const HmcRectD &operArea);
    void FixInputRectExactRatioLeft(const HmcRectD &operArea);
    void FixInputRectExactRatioTop(const HmcRectD &operArea);
    void FixInputRectExactRatioRight(const HmcRectD &operArea);
    void FixInputRectExactRatioBottom(const HmcRectD &operArea);
    void FixInputRectForDragSide2(const HmcRectD &operArea);
    void FixInputRectExactRatioLeftTop(const HmcRectD &operArea);
    void FixInputRectExactRatioRightTop(const HmcRectD &operArea);
    void FixInputRectExactRatioRightBottom(const HmcRectD &operArea);
    void FixInputRectExactRatioLeftBottom(const HmcRectD &operArea);
    int GetFixInputSize(double *fixWidth, double *fixHeight);

    /* *
     * 计算位移后的裁剪框坐标
     *
     * @param inputRect 输入裁剪框
     * @param offsetX   X轴位移
     * @param offsetY   Y轴位移
     * @return 位移后的裁剪框
     */
    HmcRectD GetOffsetCropRect(const HmcRectD &inputRect, double offsetX, double offsetY);
    HmcRectD GetOffsetCropRectForDragSide3(const HmcRectD &inputRect, double offsetX, double offsetY);

    /* *
     * 获取可到达的裁剪框
     *
     * @param editor         编辑器句柄
     * @param assetUid       剪辑UID
     * @param inputRect      数据裁剪框
     * @param inputRectSize  数组长度
     * @param outputRect     更新后可到达的裁剪框
     * @param outputRectSize 数组长度
     * @return true表示可以获取到，false表示无法获取
     */
    int GetReachableRect(HmcEditor *editor, const HmcUid &assetUid, float *inputRect, size_t inputRectSize,
        float *outputRect, size_t outputRectSize);

    /* *
     * 对目标裁剪框进行修正，不超出素材边界
     *
     * @param inputRect  原始输入裁剪框
     * @param offsetRect 位移后的裁剪框
     * @param outputRect 修正后的裁剪框
     */
    void OutputRectHandler(const HmcRectD &inputRect, const HmcRectD &offsetRect, HmcRectD &outputRect);
    void OutputRectHandlerForExceedLeft(const HmcRectD &inputRect, HmcRectD &outputRect);
    void OutputRectHandlerForExceedTop(const HmcRectD &inputRect, HmcRectD &outputRect);
    void OutputRectHandlerForExceedRight(const HmcRectD &inputRect, HmcRectD &outputRect);
    void OutputRectHandlerForExceedBottom(const HmcRectD &inputRect, HmcRectD &outputRect);

    /* *
     * 校验反向裁剪输出的裁剪框是否在当前裁剪框内
     * 如果在则说明本次反向裁剪输入不满足触发反向裁剪条件
     *
     * @param srcCropRect 当前裁剪框
     * @param dstCropRect 反向裁剪输出的裁剪框
     * @return true:不在当前裁剪框内， false:在当前裁剪框内
     */
    bool CheckOutputRect(const HmcRectD &srcCropRect, const HmcRectD &dstCropRect);
    
    /**
     * 计算正向裁剪返回给UI的裁剪框坐标
     *
     * @param timeline   当前泳道
     * @param outputRect 线性规划求解的裁剪框
     */
    void CalForwardCropRect(HveTimeline *timeline, const HmcRectD &outputRect);
    
    /**
     * 计算素材缩放比
     *
     * @param cropRect   原始输入裁剪框
     * @param outputRect 输出裁剪框
     * @return 素材缩放比
     */
    double CalRectScale(const HmcRectD &cropRect, const HmcRectD &outputRect);

    /* *
     * 计算一次反向裁剪操作后裁剪框坐标
     *
     * @param reachableRect  可到达的裁剪框
     * @param fixInputRect   输入裁剪框
     * @param scale          缩放比例
     * @param cropRectMinLen 裁剪框最小宽度
     * @return 修正后缩放比
     */
    double CalReverseCropRect(const HmcRectD &reachableRect, const HmcRectD &fixInputRect, double scale,
        double cropRectMinLen);

    /* *
     * 计算素材缩放中心点坐标
     *
     * @param centerX X轴坐标
     * @param centerY Y轴坐标
     * @return HMC_OK 成功， 其他值 失败
     */
    int CalScaleCenter(double *centerX, double *centerY);
    void CalScaleCenterForDragSide1(double *centerX, double *centerY);
    void CalScaleCenterForDragSide2(double *centerX, double *centerY);
    void CalScaleCenterForDragSide3(double *centerX, double *centerY);

    /* *
     * 计算反向裁剪拖动裁剪框的边的个数
     *
     * @return 拖动裁剪框边的个数
     */
    int GetChangedSide();

    void ReverseCropAfter(HveTimeline *timeline, HmcUid assetUid);

    inline bool IsDragHorizontal()
    {
        return m_direction[0] == 0 || m_direction[2] == 0;
    }

    inline bool IsDragVertical()
    {
        return m_direction[1] == 0 || m_direction[3] == 0;
    }

    inline bool CheckExceedLeft(double a, double b)
    {
        return HveAssetOper::GreatNotEqual(a, b) && IsDragVertical();
    }

    inline bool CheckExceedRight(double a, double b)
    {
        return HveAssetOper::LessNotEqual(a, b) && IsDragVertical();
    }

    inline bool CheckExceedTop(double a, double b)
    {
        return HveAssetOper::GreatNotEqual(a, b) && IsDragHorizontal();
    }

    inline bool CheckExceedBottom(double a, double b)
    {
        return HveAssetOper::LessNotEqual(a, b) && IsDragHorizontal();
    }

private:
    HmcRectD m_inputCropRect = { 0, 0, 0, 0 };
    HmcRectD m_outputCropRect = { 0, 0, 0, 0 };

    // UI保存的裁剪框坐标（正向裁剪）
    HmcRectD m_realCropRect = {0, 0, 0, 0};
    // 修正后的输入裁剪框
    HmcRectD m_fixInputCropRect = {0, 0, 0, 0};
    std::vector<int> m_direction;
    double m_ratio = 1.0;
    double m_pressure = 0.0;
};

#endif // OH_HVE_CROP_COMMAND_H
