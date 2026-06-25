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

#ifndef NEWPHOTOS_HVEFASTTRANSFERCOMMAND_H
#define NEWPHOTOS_HVEFASTTRANSFERCOMMAND_H

#include "ohos/hve/HveTimeline.h"
#include <string>

class HveFastTransform {
public:
    HveFastTransform(HveTimeline *timeline, HmcUid &assetUid);
    HveFastTransform(HveTimeline *timeline, HmcUid &assetUid, bool reEdit, bool revert, bool setDefault);

    /**
     * 处理 Orientation 变换
     *
     * @param orientation 变换方位
     */
    void ProcessOrientation(const std::string orientation);

    /**
     * 还原 Orientation 变化
     *
     * @param orientation 要还原的变换方位
     */
    void RevertOrientation(const std::string orientation);

protected:
    /**
     * 水平翻转
     */
    void HorizontallyFlip();

    /**
     * 逆时针旋转90°
     *
     * @param times 旋转次数
     */
    void ClockwiseRotate90(const UINT8 times);

private:
    void AddMirrorEffect();
    void HorizontalMirrorCorrect(HveAsset *hveAsset, int isHorizontalMirror, bool mirrorFlag);
    HmcRectD CalculateNewCropRect(bool isDefaultRectRatio);
    void BaseRotationCorrect(HveAsset *hveAsset, int times);
    void CalculateRotation(HveAsset *hveAsset, HmcRectD cropRect, HmcRectD oldRectD);
    void RotationParamSet(HmcRectD cropRect, HmcRectD oldRectD, int isHorizontalMirror, HmcAssetPoint &assetPosition);
    void RotationPreview(HveAsset *hveAsset, HmcSize size, HmcAssetPoint assetPosition, HmcRectD cropRect);

protected:
    HveTimeline *timeline;
    HmcUid &assetUid;
    bool reEdit = false;
    bool revert = false;
    bool setDefault = true;
};

#endif // NEWPHOTOS_HVEFASTTRANSFERCOMMAND_H
