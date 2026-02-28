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

#ifndef HMCIMAGEASSET_H
#define HMCIMAGEASSET_H
#include "Asset/HmcVisionAsset.h"
#include "MediaCreative/HmcDictKey.h"
#include "image/decoder/HmcOhosImageDecoder.h"
#include "render/graphic/HmcRenderTexture.h"

class HmcImageAsset : public HmcVisionAsset {
public:
    HmcImageAsset(HmcUid laneUid, HmcEventHandler *eventHandler);

    HmcImageAsset(const HmcVisionAsset &asset, HmcImage *freezeImage);

    explicit HmcImageAsset(const HmcVisionAsset &asset);

    ~HmcImageAsset() override;
    
public:
    HmcRenderTexture *GetTexture() const override;
    HmcSurfaceTexture *GetSurfaceTexture() const override;
    INT32 CopyTextureToCompare();
    VOID refreshCompareEffectList();
    VOID UpdateTransformToCompareLayer(std::shared_ptr<HmcRenderLayer> &layer);
    VOID ClearCompareLayer();
    VOID ClearCompareEffectList();
    
    BOOL Init(const HmcDict *dict) override;

    INT32 SetSource(const STRING &path, BOOL IsRestoresDraft, BOOL isSupportWaterMark) override;
    
    INT32 SetSource(const STRING &path, BOOL IsRestoresDraft) override;

    INT32 SetSource(SHARED_PTR<Image> image, BOOL isOverwriteAll = true) override;

    INT32 ReplaceSource(const STRING &path) override;

    HmcImage *GetPreview(INT64 timestamp, bool exactMode = true) override;

    int32_t PackGraphicsRenderInfo(uint64_t timestamp, std::shared_ptr<VideoRenderInfo> &renderInfo,
        bool exactMode = true) override;

    IHmcAsset *Duplicate() override;

    Json::Value Serialize() override;

    BOOL Deserialize(const Json::Value &jsonData) override;

    HmcUid AddEffect(HmcDict *dict) override;

    const HmcRenderTexture *GetRenderTexture() const;

    INT32 GetDisplayWidth() const override;
    INT32 GetDisplayHeight() const override;

    STRING GetOrientation() const override;

public:
    VOID RequestThumbnail(INT64 timestamp);

    VOID CancelThumbnail();
    
    VOID InitPreloadWatermarkInfo(const HmcDict *dict);
    
    HmcRenderTexture *GetOriginalTexture();
    FLOAT GetDownSampleScale();
    void UpdateDownSimplerDisplayInfos(INT32 width, INT32 height);
    bool GeneratorRfDataB();

protected:
    HmcImageAsset(const HmcImageAsset &image);

private:
    VOID FetchXtStyleExifInfo(const INT64 fd);
    
    VOID FetchFactRectsExifInfo(const INT64 fd);
    
    VOID FetchXmageColorMode(const INT64 fd);
    
    VOID FetchFactXmageColorCode(const INT64 fd);
    
    HmcImageAsset &operator = (HmcImageAsset &other) = default;

    VOID InitSurfaceTexture();

    VOID FetchExifInfo(const STRING &path);
    
    INT32 UpdateTexture();
    
    INT32 UpdateOnlyTexture(BOOL isNeedRelease);
    
    INT32 UpdateOriginalTexture(BOOL isOverwrite = false);

    VOID AttachPreloadWatermarkInfoToImage(HmcImageFromFile *imageFromFile);

    STRING GetCacheId(const STRING &filePath);

    INT32 PrepareCacheImages();

    INT32 PrepareCacheDirectory();
    
    void UpdateDisplayInfos(SHARED_PTR<Image> image);
    
    inline INT32 Denormalize(float normalizedValue, int minValue, int maxValue);
private:
    static constexpr INT32 HMC_IMAGE_DOWNSAMPLING_THRETHOLD = 2160;
    static constexpr INT32 HMC_IMAGE_DOWNSAMPLING_LINES = 1080;
    static VECTOR<STRING> EXIF_XT_STYLE_KEYS;
    BOOL m_needDownsampling{ FALSE };
    STRING m_cacheDir;

    // 下采样和去掉旋转之后的图片路径
    STRING m_previewImagePath;

    STRING m_thumbnailImagePath;

    HmcImage *m_previewImage{ nullptr };
    HmcImage *m_thumbnailImage{ nullptr };
    ATOMIC_BOOL m_isChangingPic = false;
    HmcRenderTexture *m_texture{ nullptr };
    HmcRenderTexture *m_originalTexture{ nullptr };
    HmcSurfaceTexture *m_surfaceTexture{ nullptr };
    HmcRenderTexturePtr m_compareTexture = nullptr; //切tab页时，备份的图

    std::mutex m_textureMutex;
};

#endif
