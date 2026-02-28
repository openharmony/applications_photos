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
#ifndef OH_HVEASSET_H
#define OH_HVEASSET_H

#include <bits/alltypes.h>
#include <string>
#include "../common/NapiCallback.h"
#include "HmcService.h"
#include "MediaCreative/HmcError.h"
#include "ohos/common/HmcDictHelper.h"
#include "util/HmcRectD.h"
#include "MediaCreative/HmcUid.h"

#include <multimedia/image_effect/image_effect.h>
#include <multimedia/image_effect/image_effect_filter.h>

constexpr double DEFAULT_STRENGTH = 80.0f;

typedef enum HmcWordStyleType {
    HMC_SHADOW,
    HMC_STROKE,
    HMC_BACKGROUND
} HmcWordStyleType;

typedef enum HmcWordFont {
    HMC_REGULAR,
    HMC_SLIDECHUNFENG,
    HMC_CANGERXIAOWANZI
} HmcWordFont;

typedef enum HmcDeviceType {
    DEV_PHONE, // 手机
    DEV_TABLET // PC
} HmcDeviceType;

#define AUTO_SET_GET(type, funcName, valName, defaultValue) \
public:                                                     \
    void Set##funcName(type val)                            \
    {                                                       \
        m_##valName = val;                                  \
    }                                                       \
    type Get##funcName() const                              \
    {                                                       \
        return m_##valName;                                 \
    }                                                       \
                                                            \
protected:                                                  \
    type m_##valName                                        \
    {                                                       \
        defaultValue                                        \
    }

#define AUTO_SET_GET_DEFAULT(type, funcName, valName, defaultValue) \
public:                                                             \
    void Set##funcName(type val)                                    \
    {                                                               \
        m_##valName = val;                                          \
        Notify();                                                   \
    }                                                               \
    type Get##funcName() const                                      \
    {                                                               \
        return m_##valName;                                         \
    }                                                               \
                                                                    \
protected:                                                          \
    type m_##valName{ defaultValue };                               \
    type m_##valName##Default                                       \
    {                                                               \
        defaultValue                                                \
    }

using OnAssetChange = std::function<void()>;
using AssetOperationCb = std::function<void(const std::string& jsonCb)>;

class HveAsset {
public:
    HveAsset(HmcEditor *editor, HmcUid assetUid, HmcAssetType type, OnAssetChange callback);
    virtual ~HveAsset();

    AUTO_SET_GET(float, BaseRotation, baseRotation, 0.0f);
    AUTO_SET_GET(float, PreviewScale, previewScale, 1.0f);
    AUTO_SET_GET(float, Ratio, ratio, 0.0f);
    AUTO_SET_GET(bool, AdjustExpandedHotspots, isAdjustExpandedHotspots, false);
    AUTO_SET_GET(double, ExpandedHotspotsWidth, expandedHotspotsWidth, 0.0);
    AUTO_SET_GET(double, ExpandedHotspotsHeight, expandedHotspotsHeight, 0.0);
    AUTO_SET_GET(double, CropRectMinLen, cropRectMinLen, 0.0);
    AUTO_SET_GET(float, PreviewOffsetX, previewOffsetX, 0.0f);
    AUTO_SET_GET(float, PreviewOffsetY, previewOffsetY, 0.0f);
    AUTO_SET_GET(double, GestureCenterX, gestureCenterX, 0);
    AUTO_SET_GET(double, GestureCenterY, gestureCenterY, 0);
    AUTO_SET_GET(bool, ResetVertex, resetVertex, true);
    AUTO_SET_GET(HmcAssetType, Type, type, HMC_ASSET_NONE);
    AUTO_SET_GET(bool, ModifyBoxWidthFlag, modifyBoxWidthFlag, false);
    AUTO_SET_GET(int, FontTypeIndex, fontTypeIndex, 0);
    AUTO_SET_GET(float, CanvasRatio, canvasRatio, 1.0f);
    // 当前选择的比例，默认为0，表示“自由”比例
    AUTO_SET_GET(std::string, ChooseRatio, ChooseRatio, "0");
    AUTO_SET_GET(float, BaseRotationAssetWidth, baseRotationAssetWidth, 0.0f);
    AUTO_SET_GET(float, BaseRotationAssetHeight, baseRotationAssetHeight, 0.0f);

    AUTO_SET_GET(bool, RefreshThumbnails, isRefreshThumbnails, false);
    AUTO_SET_GET(int, VideoInnerAudioVolume, videoInnerAudioVolume, 100);
    AUTO_SET_GET(bool, DeviceVertical, isDeviceVertical, true);

    AUTO_SET_GET(int32_t, FilterStrengthDefault, filterStrengthDefault, 0);
    AUTO_SET_GET(std::string, FilterMaterialUidDefault, filterMaterialUidDefault, "");

    // 连续90度旋转中间参数
    AUTO_SET_GET(int, Click90AckTimes, click90AckTimes, 0);
    AUTO_SET_GET(float, Click90AckPreviewScale, click90AckPreviewScale, 1.0f);
    AUTO_SET_GET(float, Click90AckPreviewRotation, click90AckPreviewRotation, 0.0f);
    AUTO_SET_GET(bool, Click90AckInPreviewMode, click90AckInPreviewMode, false);
    AUTO_SET_GET(int, RefreshRate, refreshRate, 120);

    // 再编辑进入标识
    AUTO_SET_GET(bool, ReEdit, isReEdit, false);
    AUTO_SET_GET(bool, DefaultHorizontalMirror, defaultHorizontalMirror, false);
    AUTO_SET_GET(bool, DefaultVerticalMirror, defaultVerticalMirror, false);

    AUTO_SET_GET_DEFAULT(INT32, TrimIn, trimIn, 0);
    AUTO_SET_GET_DEFAULT(INT32, TrimOut, trimOut, 0);
    AUTO_SET_GET_DEFAULT(INT32, Mute, mute, 0);

    AUTO_SET_GET_DEFAULT(INT32, Mirror, mirror, 0);
    AUTO_SET_GET_DEFAULT(double, RotationX, rotationX, 0);
    AUTO_SET_GET_DEFAULT(double, RotationY, rotationY, 0);
    AUTO_SET_GET_DEFAULT(double, RotationZ, rotationZ, 0);
    AUTO_SET_GET_DEFAULT(float, AssetPosX, assetPosX, 0);
    AUTO_SET_GET_DEFAULT(float, AssetPosY, assetPosY, 0);
    AUTO_SET_GET_DEFAULT(float, AssetWidth, assetWidth, 0.0f);
    AUTO_SET_GET_DEFAULT(float, AssetHeight, assetHeight, 0.0f);

    // 添加水印
    AUTO_SET_GET_DEFAULT(int32_t, WatermarkType, watermarkType, 0);
    AUTO_SET_GET(int32_t, WatermarkHeight, watermarkHeight, 0);
    AUTO_SET_GET(int32_t, WatermarkWidth, watermarkWidth, 0);
    AUTO_SET_GET(int32_t, ExportW, exportW, 0);
    AUTO_SET_GET(int32_t, ExportH, exportH, 0);
    AUTO_SET_GET(std::string, FilterShotParam, filterShotParam, "");
    AUTO_SET_GET(std::string, XtStyleCode, xtStyleCode, "");
    AUTO_SET_GET(std::string, XtStyleColor, xtStyleColor, "");
    AUTO_SET_GET(std::string, XtStyleText, xtStyleText, "");

    AUTO_SET_GET(std::string, FilterShotDate, filterShotDate, "");
    AUTO_SET_GET_DEFAULT(std::string, FilterShotSign, filterShotSign, "");
    AUTO_SET_GET(std::string, FilterShotSignFont, filterShotSignFont, "");

    // 拍摄地点、自定义文本
    AUTO_SET_GET_DEFAULT(int32_t, ContainShotLocationFlag, isContainShotLocation, 0);
    AUTO_SET_GET_DEFAULT(std::string, FilterShotLocation, filterShotLocation, "");
    AUTO_SET_GET_DEFAULT(std::string, FilterUserInput, filterUserInput, "");

    AUTO_SET_GET_DEFAULT(int32_t, ContainShotParmFlag, isContainShotParm, 0);
    AUTO_SET_GET_DEFAULT(int32_t, ContainShotDateFlag, isContainShotDate, 0);
    AUTO_SET_GET_DEFAULT(int32_t, ContainXtStyleFlag, isContainXtStyleParam, 0);
    AUTO_SET_GET_DEFAULT(std::string, Directory, directory, "");

    // 节假日水印编辑
    AUTO_SET_GET_DEFAULT(int32_t, FilterBackgroundColor, backgroundColor, -1);
    AUTO_SET_GET_DEFAULT(int32_t, FilterBackgroundType, backgroundType, -1);
    AUTO_SET_GET_DEFAULT(int32_t, FilterTemplate, filterTemplate, 0);
    AUTO_SET_GET_DEFAULT(std::string, FilterCustomText, filterCustomText, "");
    AUTO_SET_GET_DEFAULT(int32_t, ContainLocationFlag, isContainLocation, 0);
    AUTO_SET_GET_DEFAULT(std::string, Definition, definition, "");
    AUTO_SET_GET_DEFAULT(std::string, ShotLocation, shotLocation, "");

    // 添加个性色调
    XTStyleParams t;
    AUTO_SET_GET_DEFAULT(XTStyleParams, XTStyleParam, xtStyleParam, t);
    
    // 大光圈编辑
    AUTO_SET_GET_DEFAULT(double, PositionX, positionX, 0);
    AUTO_SET_GET_DEFAULT(double, PositionY, positionY, 0);
    AUTO_SET_GET_DEFAULT(int32_t, FNum, fNum, -1);

    std::unordered_map<STRING, DOUBLE> m_adjustValue;
    std::unordered_map<STRING, bool> m_adjustEnableValue;
    std::unordered_map<STRING, DOUBLE> m_adjustValueDefault;
    std::unordered_map<STRING, bool> m_adjustEnableValueDefault;

    SET<STRING> m_filterStrengthSet = { DICT_KEY_FILTER_CLASSIC,
                                        DICT_KEY_FILTER_MOODY,
                                        DICT_KEY_FILTER_NATURAL,
                                        DICT_KEY_FILTER_BLOSSOM,
                                        DICT_KEY_FILTER_FAIR,
                                        DICT_KEY_FILTER_PINK,
                                        DICT_KEY_FILTER_HAZE_REMOVAL };
    
    // 添加运动模式
    SportParams sportParams;
    AUTO_SET_GET_DEFAULT(SportParams, SportParam, sportParams, sportParams);

public:
    inline void SetAssetInitSize(float width, float height)
    {
        LOGD("SetAssetInitSize SetAssetInitSize width = %f, height = %f", width, height);
        m_assetWidth = width;
        m_assetHeight = height;
        m_assetWidthDefault = width;
        m_assetHeightDefault = height;
        Notify();
    }
    inline void SetAssetInitPosXY(float posX, float posY)
    {
        m_assetPosX = posX;
        m_assetPosXDefault = posX;
        m_assetPosY = posY;
        m_assetPosYDefault = posY;
        Notify();
    }

    inline void SetAssetSize(float width, float height)
    {
        m_assetWidth = width;
        m_assetHeight = height;
        Notify();
    }

    inline void SetAssetPosXY(float posX, float posY)
    {
        m_assetPosX = posX;
        m_assetPosY = posY;
        Notify();
    }

    inline void SetAssetSizeAndPosXY(float width, float height, float posX, float posY, bool needNotify)
    {
        m_assetWidth = width;
        m_assetHeight = height;
        m_assetPosX = posX;
        m_assetPosY = posY;
        if (needNotify) {
            Notify();
        }
    }

    inline void SetAssetSizeAndPosXYDefault(float width, float height, float posX, float posY)
    {
        LOGD("SetAssetSizeAndPosXYDefault width = %f, height = %f", width, height);
        m_assetWidthDefault = width;
        m_assetHeightDefault = height;
        m_assetPosXDefault = posX;
        m_assetPosYDefault = posY;
        Notify();
    }

    inline void GetAssetSizeAndPosXYDefault(float &width, float &height, float &posX, float &posY)
    {
        width = m_assetWidthDefault;
        height = m_assetHeightDefault;
        posX = m_assetPosXDefault;
        posY = m_assetPosYDefault;
    }

    inline void ResetRotate90AcwTempValue()
    {
        m_click90AckTimes = 0;
        m_click90AckPreviewScale = 1.0F;
        m_click90AckPreviewRotation = 0.0F;
    }

    inline void SetAdjustValue(STRING adjustName, DOUBLE adjustValue)
    {
        m_adjustValue[adjustName] = adjustValue;
        Notify();
    }

    inline void GetAutoAdjustProperty(HmcDict *dict)
    {
        if (!dict) {
            return;
        }
        auto dictionary = (HmcDictionary *)dict;
        for (auto &iterate : m_adjustValue) {
            dictionary->SetInt32(iterate.first, lround(iterate.second));
        }

        for (auto &iterate : m_adjustEnableValue) {
            dictionary->SetInt32(iterate.first, (INT32)iterate.second);
        }
    }

    inline void SetAutoAdjustProperty(HmcDict *dict)
    {
        if (!dict) {
            return;
        }
        auto dictionary = (HmcDictionary *)dict;
        int32_t value;
        for (const auto &iterate : m_adjustValue) {
            int ret = dictionary->GetInt32(iterate.first, value);
            if (ret != HMC_OK) {
                continue;
            }
            m_adjustValue[iterate.first] = value;
        }

        for (const auto &iterate : m_adjustEnableValue) {
            int ret = dictionary->GetInt32(iterate.first, value);
            if (ret != HMC_OK) {
                continue;
            }
            m_adjustEnableValue[iterate.first] = value;
        }

        Notify();
    }

    inline DOUBLE GetAdjustValue(STRING adjustName)
    {
        return m_adjustValue[adjustName];
    }

    inline void SetAdjustEnableValue(STRING adjustEnableName, INT32 adjustEnableValue)
    {
        m_adjustEnableValue[adjustEnableName] = adjustEnableValue;
        Notify();
    }

    inline bool GetAdjustEnableValue(STRING adjustEnableName)
    {
        return m_adjustEnableValue[adjustEnableName];
    }

    void Notify()
    {
        if (m_assetChangeCb != nullptr) {
            m_assetChangeCb();
        }
    }

    inline void SetBaseRotationAssetSize(float assetWidth, float assetHeight)
    {
        m_baseRotationAssetWidth = assetWidth;
        m_baseRotationAssetHeight = assetHeight;
    }

    void SetModifyTime()
    {
        m_modifyTime = static_cast<int64_t>(HmcGetCurrTimeMillSec());
    }
    int64_t GetModifyTime() const
    {
        return m_modifyTime;
    }
    
    inline AssetOperationCb GetAssetOperationCb(const std::string& operKey)
    {
        return m_assetOperCbMap.find(operKey) != m_assetOperCbMap.end() ? m_assetOperCbMap[operKey] : nullptr;
    }

    inline void SetAssetOperationCb(const std::string& operKey, const AssetOperationCb& cb)
    {
        if (operKey.empty() || cb == nullptr) {
            LOGE("SetAssetOperationCb key or value is empty");
            return;
        }
        
        m_assetOperCbMap[operKey] = cb;
    }

    inline void RemoveAssetOperationCb(const std::string& operKey)
    {
        m_assetOperCbMap.erase(operKey);
    }

    void SetDeviceType(std::string const & deviceType);
    void setSupportNewWatermark(bool supportNewWatermark);
    void InitColorAdjustValue();
    HmcDeviceType GetDeviceType();
    bool getSupportNewWatermark();
    void SetEditDataType(std::string const &type);
    std::string GetEditDataType();
    void SetInPreviewMode(bool isInPreviewMode);
    bool GetInPreviewMode() const;
    void SetIsSwitchPage(bool isSwitchPage);
    bool GetIsSwitchPage() const;
    void SetShowWatermarkValue(bool isDrawWaterMark);
    void RefreshCompareEffectList();
    bool GetShowWatermarkValue() const;
    void SetIsDragImage(bool isDragImage);
    bool GetIsDragImage() const;
    bool IsLandscape() const;
    void SetRotation(double rotation, HmcRotationAxis axis, bool needNotify);
    double GetRotation(HmcRotationAxis axis) const;
    Json::Value Serialize();
    void Deserialize(Json::Value data);
    void SyncDataFromService();
    void SyncAdjustDataFromService();
    void SyncTrimDataFromService();
    void SyncTransformDataFromService();
    void HandleVignetForSave(bool isEnableVignette);
    void SwitchPreviewMode(const HmcRectD &cropRect, const HmcRectD &cropOperationArea, bool flag = true);
    void SwitchCropMode();
    void SetAdjustVignetteEnable(bool enable);
    void UpdatePreviewMode(const HmcRectD &cropRect, const HmcRectD &cropOperationArea,
                           bool useHotspotsPreScale = true);
    void RefreshWatermarkCropRectAndOpacity(const HmcRectD &cropRect, double watermarkOpacity = 0);
    void RefreshWatermarkCropRect(const HmcRectD &cropRect);
    void RefreshWatermarkXtStyleParam(const HmcRectD &cropRect, bool autoFlush = false, bool needInitCache = false);
    void setExportSize(const HmcRectD &cropRect);
    void InitWatermarkCache(const HmcRectD &cropRect);

    INT32 CalculateFocusPosition(bool isRequestRealPosition, HmcPosition &viewPosition,
                                        HmcPosition &realPosition, float cropScale = 0.0);
    void UpdateCropMode();
    void UpdateTransformInfo(const HmcRectD &cropRect, const HmcRectD &cropOperationArea, bool isSave);
    bool IsDefaultConfig();
    HveAsset *Duplicate(HmcUid newAssetUid);
    HmcUid GetAssetUid()
    {
        return m_assetUid;
    }
    bool IsAssetPosChange(float precision);
    bool IsAssetPosChangeAndFix(float *assetWidth, float *assetHeight, float *assetPosX, float *assetPosY,
        double cropRectWidth, double cropRectHeight);
    double CalcPreviewModeAssetScale(const HmcRectD &cropRect, const HmcRectD &cropOperationArea);
    std::string ConvAdjustDict2Json(HmcDict *dict);
    void SetDefaultValueToAdjustDict(HmcDict *dict);
    void Reset();
    void ResetTransform();
    void ResetMirror();
    void SetMirrorDefault(bool mirrorFlag);
    void ResetRotation();
    void SetRotationDefault(double rotation, HmcRotationAxis axis);
    void ResetBaseInfo();
    void ResetColorAdjust();
    Json::Value GetAdjustInfo();
    void ResetClick90AckCycle();
    void ResetClickMirrorCycle();
    bool CanDrawWatermark() const
    {
        return m_isDrawWaterMark;
    }
protected:
    HveAsset(const HveAsset &asset);

private:
    bool IsAdjustChange();
    HmcUid FindEffectByType(HmcEffectType type);
    void CleanWatermarkCache();

public:
    BOOL isVignetteHasValue = FALSE;
    BOOL isVignetteHasEnable = TRUE;

protected:
    HmcEditor *m_editor{ nullptr };
    HmcUid m_assetUid{ HMC_UID_NULL };
    OnAssetChange m_assetChangeCb{ nullptr };
    std::function<void(std::string const & assetId, std::string const & jsonPos)> m_assetPositionChangeCallback{
        nullptr
    };
    std::function<void(std::string const & assetId, std::string const & jsonPos)> m_assetTimePosChangeCallback{
        nullptr
    };
    int64_t m_modifyTime = 0;
    HmcDeviceType m_deviceType = DEV_PHONE;
    bool m_supportNewWatermark = false;
    std::string m_currentSign = "";
    std::string m_editDataType = "";
    std::unordered_map<std::string, AssetOperationCb> m_assetOperCbMap;
    bool m_isInPreviewMode = false;
    bool m_isDrawWaterMark = true;
    bool m_isSwitchPage = false;
    bool m_isDragImage = false;
};

#endif // OH_HVEASSET_H
