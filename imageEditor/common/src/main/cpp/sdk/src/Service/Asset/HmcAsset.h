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

#ifndef HMCASSET_H
#define HMCASSET_H

#include "HmcBase.h"
#include "HmcEngine.h"
#include "MediaCreative.h"
#include "../Editor/HmcEventHandler.h"
#include "Utils/HmcTime.h"

// 默认时长
constexpr INT64 HMC_ASSET_DEFAULT_DURATION = 0; // 图片/贴纸等没有时常的素材，默认采用该值作为默认时长

#define ASSET_DEFAULT_SPEED (1.0f)
#define ASSET_MIN_SPEED (0.1f)
#define ASSET_MAX_SPEED (10.0f)

using HmcTimeLinePosition = enum HmcTimeLinePosition {
    HMC_TIMELINE_INVALID_ASSET,
    HMC_TIMELINE_NOT_BETWEEN_NEAR_HEAD,
    HMC_TIMELINE_NOT_BETWEEN_NEAR_TAIL,
    HMC_TIMELINE_BETWEEN_NEAR_HEAD,
    HMC_TIMELINE_BETWEEN_NEAR_TAIL,
};

class IHmcAsset {
public:
    IHmcAsset();
    IHmcAsset(HmcUid laneUid, HmcEventHandler *eventHandler);
    virtual ~IHmcAsset();

public:
    HmcUid GetUid() const;
    HmcAssetType GetType() const;
    HmcUid GetMaterialUid() const;

    HmcUid GetLaneUid() const;
    VOID SetLaneUid(HmcUid laneUid);

    VOID SetNameFromPath();

    const STRING &GetPath() const;
    VOID GetFileSize(MAP<STRING, INT64> &infoList);
    HmcAssetPathType GetPathType() const;
    static STRING CovertPathToRelative(const STRING &path, const HmcAssetPathType &pathType);
    static STRING CovertPathToAbsolute(const STRING &path, const HmcAssetPathType &pathType);

public:
    virtual BOOL Init(const HmcDict *dict);

    virtual INT32 SetSource(const STRING &path, BOOL IsRestoresDraft, BOOL isSupportWaterMark) = 0; // 设置素材源文件.
    virtual INT32 SetSource(const STRING &path, BOOL IsRestoresDraft) = 0; // 设置素材源文件.
    virtual INT32 SetSource(SHARED_PTR<Image> image, BOOL isOverwriteAll = true) = 0; // 替换素材源文件.
    virtual INT32 ReplaceSource(const STRING &path) = 0;                   // 替换素材源文件.
    virtual INT32 SetAssetPathType(const HmcAssetPathType &pathType);      // 设置素材源文件路径类型.

    virtual const STRING &GetName() const;
    virtual VOID SetName(STRING name);

    virtual INT64 GetStartTime() const;
    virtual VOID SetStartTime(INT64 startTime);

    virtual INT64 GetEndTime() const;
    virtual VOID SetEndTime(INT64 endTime);

    virtual VOID SetTrimIn(INT64 trimIn);

    virtual INT64 GetTrimOut() const;
    virtual VOID SetTrimOut(INT64 trimOut);

    virtual VOID SetDuration(INT64 duration);
    virtual INT64 GetDurationTime() const;

    virtual VOID SetSpeed(FLOAT speed);
    virtual FLOAT GetSpeed() const;

    virtual INT64 GetPureDuration() const; // 获取本素材的纯净总时长，不和关联素材综合
    virtual INT64 GetFileDuration();

    virtual BOOL GetBackward();
    virtual BOOL SetBackward(BOOL isBackward);
    virtual Json::Value Serialize();
    virtual BOOL Deserialize(const Json::Value &jsonData);

    virtual BOOL IsDrawable(INT64 time) const;
    virtual int32_t PackGraphicsRenderInfo(uint64_t timestamp, std::shared_ptr<VideoRenderInfo> &renderInfo,
        bool exactMode = true);
    virtual VOID RequestPrefetching(){};

    virtual VOID GetAssetParamValue(HmcDict *dict) const;
    virtual VOID SetAssetParamValue(const HmcDict *dict);

    virtual IHmcAsset *Duplicate() = 0;

    virtual BOOL IsInsideAsset(HmcPosition position) = 0;

    virtual VOID DelayInit(){};

	virtual void InitEffectWithEditData(std::string editData, INT32 isMediaSource, INT32 isFrontCamera,
                                        INT32 isCameraEditData) {};
    virtual void SetExportWidthAndHeight(std::string editData, INT32 isMediaSource){};

    virtual STRING GetOrientation() const;
    virtual STRING GetShotDate() const;
    virtual STRING GetShotParam() const;
    virtual STRING GetShotSignFont() const;
    virtual VECTOR<INT32> GetExifXtStyleParam() const;
    virtual UINT32 GetExifXmageColorMode() const;
    virtual INT32 IsXtStyleForceOn() const;

public:
    HmcTimeLinePosition isTimelineBetweenAsset(INT64 timeline) const;

protected:
    IHmcAsset(const IHmcAsset &asset);
    IHmcAsset &operator = (const IHmcAsset &asset);

protected:
    HmcUid m_uid;                    // 剪辑（asset）UID
    HmcUid m_laneUid;                // 所属泳道的UID
    HmcUid m_materialUid;            // 原始素材的UID
    HmcAssetType m_type;             // 剪辑类型
    STRING m_name;                   // 资源名
    STRING m_path;                   // 资源路径
    HmcAssetPathType m_path_type;    // 资源路径类型
    INT64 m_trimIn;                  // 资源的裁剪入点
    INT64 m_trimOut;                 // 资源的裁剪出点
    INT64 m_pureDuration;            // 本素材的纯净总时长，视频，音频会有
    HmcTime m_complexDuration;       // 和关联素材综合后的总时长
    INT64 m_complexStartTime;        // 和关联素材综合后的起始时间
    FLOAT m_speed{ 1.0f };           // 速率
    BOOL m_isVisibility;             // 资源是否可见
    BOOL m_isBackward;               // 倒放（仅视频、音频有效）
    HmcEventHandler *m_eventHandler; // 回调函数指针

    INT64 m_size;
    STRING m_cloudContentId; // 素材云端ID
    STRING m_orientation;    // 文件描述符
    
    STRING m_shotParam = "";
    STRING m_shotDate = "";
    STRING m_shotSign = "";
    STRING m_shotSignFont = "";
    INT32 m_exportHeight = 0;  // 添加画框前图片高度
    INT32 m_exportWidth = 0;  // 添加画框前图片宽度
    
    VECTOR<INT32> m_exifXtStyleParam = {-1, -1, -1, -1};
    
    STRING m_exifFactRectData = EMPTY_STR;
    
    UINT32 m_exifFaceCount = 0;
    
    INT32 m_exifSourceXmageColorMode = -1;
    
    INT32 m_exifSourceXtStyleType = -1;
};
#endif /* HMCASSET_H */
