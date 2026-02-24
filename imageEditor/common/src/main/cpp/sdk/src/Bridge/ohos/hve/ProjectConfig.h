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

#ifndef NEWPHOTOS_PROJECTCONFIG_H
#define NEWPHOTOS_PROJECTCONFIG_H

#include "MediaCreative/HmcParams.h"

class ProjectConfig {
public:
    static const int QUALITY_MAX = 100;
    static const int QUALITY_DEFAULT = 95;

    static ProjectConfig &Instance();
    
    bool SetValueByKey(const STRING &key, const STRING &value);
    
    bool IsHdrShownOpen() const;
    int GetImageQuality() const;
    bool IsHideWatermarkResource() const;
    EditEffectMode GetEditEffectMode() const;
    bool IsUltraPhoto() const;
    bool IsSupportUltraPhoto() const;
    STRING GetMimeType() const;
    bool IsAiWatermarkEnabled() const;
    bool IsEdit() const;
    bool IsFromMovingAndIsUltraPhoto() const;
    bool IsExportFromBrowser() const;
    FLOAT GetDecodeScale() const;
    
    void DeInit();

private:
    void Init();
    bool isNumber(const STRING& str);
    bool ParseAndSetBoolValue(const STRING &srcValue, bool &dstValue);
    bool ParseAndSetIntValue(const STRING &srcValue, int &dstValue);
    bool ParseAndSetFloatValue(const STRING &srcValue, float &dstValue);
    
    bool SetHdrShownOpen(const STRING &isHdrShownOpen);
    bool SetHideWatermarkResource(const STRING &hideWatermarkResource);
    bool SetImageQuality(const STRING &imageQuality);
    bool SetUltraPhoto(const STRING &isUltraPhoto);
    bool SetSupportUltraPhoto(const STRING &isUltraPhoto);
    bool SetEditEffectMode(const STRING &mode);
    bool SetMimeType(const STRING &mimeType);
    bool SetIsAiWatermarkEnabled(const STRING &isAiWatermarkEnabled);
    bool SetReEdit(const STRING &isEdit);
    bool SetFromMovingAndIsUltraPhoto(const STRING &isUltraPhoto);
    bool SetExportFromBrowser(const STRING &exportMode);
    bool SetDecodeScale(const STRING &scale);
    
private:
    std::unordered_map<STRING, std::function<bool(const STRING &)>> m_handleFuncs;
    
    // 单例方法，退出编辑不会销毁
    // 增加属性，需要在DeInit函数中，恢复默认的值
    bool m_isHdrShownOpen = true;
    int m_imageQuality = QUALITY_DEFAULT;
    bool m_isHideWatermarkResource = false;
    bool m_isAiWatermarkEnabled = false;

    EditEffectMode m_editEffectMode = EditEffectMode::NONE;        // 当前编辑处于哪种效果组合模式
    bool m_isUltraPhoto = false;                                   // 是否是一拍多得照片
    bool m_isSupportUltraPhoto = false;                            // 是否支持一拍多得照片
    bool m_isEdit = false;                                         // 是否是二次编辑
    STRING m_mimeType = "";                                        // 图片的mimetype
    bool m_isFromMovingAndIsUltraPhoto = false;                    // 从动图跳转到静图，并且是一拍多得照片
    bool m_isExportFromBrowser = false;                            // 是否是从大图直接调用一拍多得效果
    FLOAT m_decodeScale = 1.0;                                       // 解码下采样比例
    mutable std::mutex m_mutex;
    static std::once_flag m_once;
};
#endif //NEWPHOTOS_PROJECTCONFIG_H