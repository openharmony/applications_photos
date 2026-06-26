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

#ifndef HMCVISIONASSET_H
#define HMCVISIONASSET_H

#include "HmcAsset.h"
#include "Effect/HmcEffect.h"
#include "MediaCreative/HmcEditorAsset.h"

using CanvasColor = struct CanvasColor {
    INT32 color = 0;
    FLOAT alpha = 0;
    BOOL enable = FALSE;
};

using StringItem = struct StringItem {
    STRING value;
    BOOL enable = FALSE;
};

using CropCenterOffset = struct CropCenterOffset {
    FLOAT offsetX = 0.0;
    FLOAT offsetY = 0.0;
};

using RenderTextureCache = struct RenderTextureCache {
    STRING m_path;
    HmcRenderTexturePtr m_texture{ nullptr };
};

using VisionRenderTexturePtr = HmcRenderTexturePtr;

struct HmcCanvasSize;
class HmcOffScreenEngine;

class HmcVisionAsset : public IHmcAsset {
public:
    HmcVisionAsset();
    HmcVisionAsset(HmcUid laneUid, HmcEventHandler *eventHandler);
    ~HmcVisionAsset() override;

public:
    BOOL Init(const HmcDict *dict) override;
    VOID InitMode(const HmcDict *dict);
    VOID SetAssetParamValue(const HmcDict *dict) override;
    VOID GetAssetParamValue(HmcDict *dict) const override;

    Json::Value Serialize() override;
    VOID SerializeTransInfo(Json::Value &json) const;
    BOOL Deserialize(const Json::Value &jsonData) override;
    void InitEffectWithEditData(std::string editData, INT32 isMediaSource, INT32 isFrontCamera,
                                INT32 isCameraEditData) override;
    void SetExportWidthAndHeight(std::string editData, INT32 isMediaSource) override;
    BOOL DeserializeTransInfo(const Json::Value &jsonData);
    BOOL DeserializeCrop(const Json::Value &jsonData);

public:
    virtual INT32 GetWidth() const;
    virtual INT32 GetHeight() const;
    virtual STRING GetOrientation() const override;
    virtual HmcRenderTexture *GetTexture() const
    {
        return nullptr;
    }
    virtual HmcSurfaceTexture *GetSurfaceTexture() const
    {
        return nullptr;
    }

    // 获取显示宽高，只有图片下采样后m_width和m_display_width不等，返回m_display_width
    virtual INT32 GetDisplayWidth() const
    {
        return m_width;
    }

    virtual INT32 GetDisplayHeight() const
    {
        return m_height;
    }

    virtual INT32 GetBaseRotation() const;

    virtual HmcSize GetSize() const;
    virtual HmcSize GetDestSize() const;
    virtual VOID SetSize(const HmcSize &size);
    virtual VOID SetDestSize(const HmcSize &size);
    
    virtual HmcSize HmcAssetGetCurSize() const;
    virtual VOID HmcAssetSetCurSize(const HmcSize &size);

    VOID GetPosition(FLOAT &offsetX, FLOAT &offsetY) const;
    virtual VOID SetPosition(FLOAT offsetX, FLOAT offsetY);

    virtual VOID GetZoom(FLOAT &scaleX, FLOAT &scaleY) const;
    virtual VOID SetZoom(FLOAT scaleX, FLOAT scaleY);

    virtual FLOAT GetRotation(HmcRotationAxis axis) const;
    virtual VOID SetRotation(HmcRotationAxis axis, FLOAT angle);

    virtual VOID GetRotation(FLOAT &angleX, FLOAT &angleY, FLOAT &angleZ) const;
    virtual VOID SetRotation(FLOAT angleX, FLOAT angleY, FLOAT angleZ);

    virtual FLOAT GetOpacity() const;
    virtual VOID SetOpacity(FLOAT opacity);

    virtual BOOL GetMirrorHorizontal() const;
    virtual VOID SetMirrorHorizontal(BOOL mirror);

    virtual BOOL GetMirrorVertical() const;
    virtual VOID SetMirrorVertical(BOOL mirror);

    virtual VECTOR<FLOAT> GetVertexPosition();

    virtual VisionTransformInfo GetTransformInfo() const;
    virtual VOID UpdatePositionByWindowRatio(FLOAT ratioX, FLOAT ratioY);

    virtual BOOL InitEffect();
    VOID AddTransformEffect();
    void SetNewWatermarkPara(HmcDict *&dict, JsonCpp::Value &values, std::string &filterName, std::string &directory);
    void SetWatermarkPara(HmcDict *dict, Json::Value &values, std::string &filterName, INT32 isCameraEditData);
    VOID AddMirrorEffect();
    HmcEffect *CreateEffectResult(HmcDict *dict);
    virtual VOID AddEffect(const HmcUid &effectUid, INT32 index);
    virtual HmcUid AddEffect(HmcDict *dict);
    virtual INT32 InsertEffect(const HmcUid &effectUid, unsigned int index);
    virtual VOID RemoveEffect(const HmcUid &effectUid);
    virtual VOID RemoveAllEffects();
    virtual BOOL AdvanceEffect(HmcUid effectUid, int distance); // 前后移动特效

    virtual BOOL GetEffectIndex(const HmcUid &effectUid, unsigned int &index) const;
    virtual UINT32 GetEffectCount(HmcEffectType type) const;
    virtual VOID GetEffectList(VECTOR<HmcUid> &effectList, HmcEffectType type) const;
    virtual VOID GetEffectList(VECTOR<HmcUid> &effectList) const;
    virtual VOID GetEffectList(VECTOR<HmcUid> &effectList, const VECTOR<HmcEffectType> &typeList) const;
    virtual HmcAssetCropPosition getCropPosition() const;

    virtual HmcImage *GetPreview(INT64 timestamp, bool exactMode = true);

    /* 判断指定坐标是否在ASSET内部 */
    BOOL IsInsideAsset(HmcPosition position) override;

    /* 删除剪辑（asset）的特定类型的效果 */
    virtual VOID RemoveEffectByType(HmcEffectType effectType);

    /* 效果操作相关函数 */
    BOOL MoveEffect(HmcEffect *effect, INT64 moveTime);

    /* 剪辑画布信息操作的处理 */
    HmcImage *GetImageByBlurred(UINT32 timeStamp, INT64 strength);
    VOID setCropPosition(float left, float top, float right, float bottom);

    virtual VOID SetCanvasRatio();
    virtual FLOAT GetRenderScale() const;

    int32_t PackGraphicsRenderInfo(uint64_t timestamp, std::shared_ptr<VideoRenderInfo> &renderInfo,
        bool exactMode = true) override;

    VOID SortEffectList();

    double GetVideoFps() const;
    INT32 GetVideoBitRate() const;
    INT32 GetOriginalColorMode();
    void SetOriginalColorMode(INT32 enable);
    bool IsOriginalColorMode(HmcEffectType type) const;
    bool IsOriginalColorMode() const;

    void PackEffectRenderInfo(INT64 pts, std::vector<HmcRenderEffectPtr> &effectList,
                              const std::set<HmcEffectType> &filterEffect = std::set<HmcEffectType>());

    int32_t GetImageSize(const std::string &path, int32_t &width, int32_t &height);
    void SetPreviewMode(bool isPreviewMode);
    void SetIsSwitchPage(bool isSwitchPage);
    void SetDrawWaterMarkValue(bool isDrawWaterMark);
    void SetIsDragImage(bool isDragImage);

protected:
    HmcVisionAsset(const HmcVisionAsset &asset);
    HmcVisionAsset &operator = (const HmcVisionAsset &vision);

protected:
    bool SetEffectRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT64 timeOffset = 0);

protected:
    INT32 m_width;                   // 视频、图片、贴纸宽度。
    INT32 m_height;                  // 视频、图片、贴纸高度。
    INT32 m_displayWidth;            // 视频、图片、贴纸显示宽度。
    INT32 m_displayHeight;           // 视频、图片、贴纸显示高度。
    float m_destWidth = -1;          // 图片编辑动效的目标宽度
    float m_destHeight = -1;         // 图片编辑动效的目标高度
    INT32 m_rotation;                // 视频、图片、贴纸原始旋转角度 EXIF中的方向信息
    VisionTransformInfo m_transInfo; // 视频、图片、贴纸变换信息，带默认初始化
    LIST<HmcUid> m_effectList;       // 效果列表
    INT32 m_originalColorMode = 0;   // 是否启用原始颜色模式, 0-不开启， 1 开启
    std::shared_ptr<HmcRenderLayer> m_layer = std::make_shared<HmcRenderLayer>();
    std::shared_ptr<HmcRenderLayer> m_CompareLayer = nullptr;
    ffrt::mutex m_layerMutex;     // m_layer的互斥锁
    mutable HmcMutex m_locker;       // m_effectList的互斥锁
    double m_videofps = 25.0F;
    INT32 m_videoBitRate = 0;
    CropCenterOffset m_cropOffset;
    HmcOffScreenEngine *m_offScreenEngine = nullptr;
    RenderTextureCache m_canvasRenderTextureCache;
    HmcAssetCropPosition cropPosition = {
        .leftTop = {0, 1}, .leftBottom = {0, 0}, .rightTop = {1, 1}, .rightBottom = {1, 0}};
    bool m_IsInPreviewMode = true;
    bool m_isDrawWaterMark = false;
    bool m_isSwitchPage = false;
    bool m_isDragImage = false;
    HmcSize newAssetSize = { width: 0.0, height: 0.0};
private:
    HmcEffect *CreateEffectEntity(HmcEffectType type);
    HmcEffect *CreateEffect(HmcDict *dict);
    HmcEffect *ReplaceEffect(HmcDict *dict, bool force);
    HmcEffect *CreateEffect(const Json::Value &jsonData);

    /* 根据图片路径创建纹理 */
    VisionRenderTexturePtr CreateTextureByPath(const STRING &path);

    HmcUid GetEffectByMaterial(const STRING &materialCloudId); // 通过效果素材id获取效果

    inline INT32 Denormalize(float normalizedValue, int minValue, int maxValue);

    void SetXtStyleParamToWatermark(const void *dict, Json::Value &values) const;
    void SetInPlaceStickerPara(HmcDict *dict, Json::Value &values);
    void SetTimingStickerPara(HmcDict *dict, Json::Value &values, INT32 isCameraEditData);
    void SetFrameStickerPara(HmcDict *dict, Json::Value &values);
    void SetXtStyleStickerPara(HmcDict *dict, Json::Value &values);
};

#endif
