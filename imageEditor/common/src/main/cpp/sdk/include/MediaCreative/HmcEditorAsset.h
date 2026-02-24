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
#ifndef HMCEDITORASSET_H
#define HMCEDITORASSET_H

#include "HmcBaseType.h"
#include "MediaCreative/HmcDict.h"
#include "MediaCreative/HmcEditor.h"
#include "MediaCreative/HmcImage.h"
#include "MediaCreative/HmcUid.h"
#include <multimedia/image_framework/image/picture_native.h>
#ifdef __cplusplus
extern "C" {
#endif

constexpr double EPSILON = 1e-6;
constexpr double DEVIATION = 0.1;
constexpr float EXIF_ROTATE_90 = 90.0;
constexpr float EXIF_ROTATE_180 = 180.0;

typedef enum HmcAudioSoundType {
    // 大叔类型
    HMC_AUDIO_TYPE_UNCLE,

    // 萝莉类型
    HMC_AUDIO_TYPE_LORI,

    // 女声类型
    HMC_AUDIO_TYPE_FEMALE,

    // 男声类型
    HMC_AUDIO_TYPE_MALE,

    // 怪物类型
    HMC_AUDIO_TYPE_MONSTER,

    // 正常类型
    HMC_AUDIO_TYPE_NORMAL
} HmcAudioSoundType;

typedef enum HmcAssetType {
    HMC_ASSET_IMAGE,
    HMC_ASSET_NONE
} HmcAssetType;

typedef enum HmcAssetQuality {
    HMC_ASSET_AUTO_QUALITY,
    HMC_ASSET_HIGH_QUALITY
} HmcAssetQuality;

typedef enum HmcTrimType {
    // 从资源的起点向后操作。
    HMC_TRIM_IN,
    // 从资源的终点向前操作。
    HMC_TRIM_OUT,
} HmcTrimType;

typedef enum HmcSizeType {
    // 剪辑原始尺寸。
    HMC_SIZE_ORIGINAL,
    // 剪辑渲染尺寸。
    HMC_SIZE_RENDER,
    // 剪辑目标尺寸
    HMC_SIZE_DEST,
} HmcSizeType;

typedef enum HmcRotationAxis {
    HMC_AXIS_X,
    HMC_AXIS_Y,
    HMC_AXIS_Z
} HmcRotationAxis;

typedef struct HmcTransformInfo {
    float offsetX; // 中心点平移距离的x坐标
    float offsetY; // 中心点平移距离的y坐标
    float offsetZ; // 中心点平移距离的z坐标
    // 图像旋转角度(逆时针，0°~360°)
    float rotationX;
    float rotationY;
    float rotationZ;
    // 图像缩放比例
    float scaleX;
    float scaleY;
    float scaleZ;

    // 水平镜像标识: 0, 非镜像; 1, 镜像
    int mirrorHorizontal;
    // 垂直镜像标识: 0, 非镜像; 1, 镜像
    int mirrorVertical;

    float opacity;
    
    HmcTransformInfo()
        : offsetX(0.0),
          offsetY(0.0),
          offsetZ(0.0),
          rotationX(0.0),
          rotationY(0.0),
          rotationZ(0.0),
          scaleX(0.0),
          scaleY(0.0),
          scaleZ(0.0),
          mirrorHorizontal(0),
          mirrorVertical(0),
          opacity(0.0)
    {}
    
    HmcTransformInfo& operator=(const HmcTransformInfo &other)
    {
        if (this != &other) {
            this->offsetX = other.offsetX;
            this->offsetY = other.offsetY;
            this->offsetZ = other.offsetZ;
            this->rotationX = other.rotationX;
            this->rotationY = other.rotationY;
            this->rotationZ = other.rotationZ;
            this->scaleX = other.scaleX;
            this->scaleY = other.scaleY;
            this->scaleZ = other.scaleZ;
            this->opacity = other.opacity;
            this->mirrorHorizontal = other.mirrorHorizontal;
            this->mirrorVertical = other.mirrorVertical;
        }
        return *this;
    }
    
    bool operator==(const HmcTransformInfo &other) const
    {
        auto isEqual = [](float a, float b) -> bool {
            float diff = a - b;
            return (diff < 0 ? -diff : diff) < EPSILON;
        };
        
        return isEqual(this->offsetX, other.offsetX) &&
            isEqual(this->offsetY, other.offsetY) &&
            isEqual(this->offsetZ, other.offsetZ) &&
            isEqual(this->rotationX, other.rotationX) &&
            isEqual(this->rotationY, other.rotationY) &&
            isEqual(this->rotationZ, other.rotationZ) &&
            isEqual(this->scaleX, other.scaleX) &&
            isEqual(this->scaleY, other.scaleY) &&
            isEqual(this->scaleZ, other.scaleZ) &&
            isEqual(this->opacity, other.opacity) &&
            this->mirrorHorizontal == other.mirrorHorizontal &&
            this->mirrorVertical == other.mirrorVertical;
    }
} HmcTransformInfo;

typedef struct HmcSize {
    float width;
    float height;
} HmcSize;

typedef struct HmcAssetPoint {
    float x;
    float y;
} HmcAssetPoint;

typedef struct HmcAssetPosition {
    HmcAssetPoint center;
    HmcAssetPoint leftTop;
    HmcAssetPoint leftBottom;
    HmcAssetPoint rightTop;
    HmcAssetPoint rightBottom;
} HmcAssetPosition;

typedef enum HmcAssetMirrorType {
    HMC_ASSET_MIRROR_VERTICAL,
    HMC_ASSET_MIRROR_HORIZONTAL
} HmcAssetMirrorType;

typedef struct HmcAssetCropPosition {
    HmcAssetPoint leftTop;
    HmcAssetPoint leftBottom;
    HmcAssetPoint rightTop;
    HmcAssetPoint rightBottom;
} HmcAssetCropPosition;

typedef struct WatermarkParam {
    int watermarkType;
    double watermarkOpacity;
    int exportW;
    int exportH;
    int isAlwaysShow;
    int oriWatermarkType;
    int oriIsContainParam;
    int oriIsContainDate;
} WatermarkParam;

typedef enum HmcAssetWatermarkType {
    // 无水印
    HMC_ASSET_NO_STICKER = 0,
    // 内嵌水印
    HMC_ASSET_IN_PLACE_STICKER = 1,
    // 画框水印
    HMC_ASSET_FRAME_STICKER = 2,
    // 个性水印
    HMC_ASSET_XT_STYLE_FRAME_STICKER = 3,
    // 新内嵌水印
    HMC_ASSET_RENEWAL_STICKER = 4,
    // 四边白框水印
    HMC_ASSET_BORDER_STICKER = 5,
    // 毛玻璃水印
    HMC_ASSET_FROSTED_STICKER = 6,
    // 春节水印
    HMC_ASSET_FESTIVAL_STICKER = 7,
    // 个性边框国风水印
    HMC_ASSET_PERSONALIZED_STICKER_STYLE1 = 8,
    // 个性内嵌国风水印
    HMC_ASSET_PERSONALIZED_STICKER_STYLE2 = 9,
    // 国庆水印
    HMC_ASSET_NATIONAL_DAY_STICKER = 10,
    // AI 标识
    HMC_ASSET_AI_STICKER = 11,
} HmcAssetWatermarkType;

// 混合模式BlendMode
typedef enum HmcEffectBlendType {
    HMC_EFFECT_BLEND_TYPE_NONE,       // 还原
    HMC_EFFECT_BLEND_TYPE_LIGHTEN,    // 变亮
    HMC_EFFECT_BLEND_TYPE_DARKEN,     // 变暗
    HMC_EFFECT_BLEND_TYPE_MULITIPLY,  // 正片叠底
    HMC_EFFECT_BLEND_TYPE_SCREEN,     // 滤色
    HMC_EFFECT_BLEND_TYPE_OVERLAY,    // 叠加
    HMC_EFFECT_BLEND_TYPE_SOFTLIGHT,  // 柔光
    HMC_EFFECT_BLEND_TYPE_HARDLIGHT,  // 强光
    HMC_EFFECT_BLEND_TYPE_COLORDODGE, // 颜色减淡
    HMC_EFFECT_BLEND_TYPE_COLORBURN,  // 颜色加深
    HMC_EFFECT_BLEND_TYPE_LINEARBURN  // 线性加深
} HmcEffectBlendType;

// 剪辑使用的路径类型
typedef enum HmcAssetPathType {
    HMC_ASEET_PATH_TYPE_ABSOLUTE, // path传入使用绝对路径/全路径，默认值为使用绝对路径
    HMC_ASEET_PATH_TYPE_SANDBOX,  // path传入的是沙盒的全路径，使用Documents、Library、Caches等
    HMC_ASEET_PATH_TYPE_MAIN_BUNDLE, // path传入的是Main Bundle路径，需要包含bundle名称，如word.bundle/font/test.ttf
    HMC_ASEET_PATH_TYPE_FRAMEWORK_BUNDLE, // path传入的是FrameWork BUNDLE路径，需要包含framwork名、bundle名称，
    // 如：test.framwork/word.bundle/font/test.ttf
    HMC_ASEET_PATH_TYPE_NET_MATERIAL, // 网络素材，序列化和反序列化自动添加路径。存相对路径
    HMC_ASEET_PATH_TYPE_DEFAULT_FONT, // 默认字体，使用时候根据exe路径和相对路径（font/word.ttf） 拼接。存相对路径
    HMC_ASEET_PATH_TYPE_RELATIVE
} HmcAssetPathType;

HMC_API int HmcAssetSetSourceByPixelMap(HmcEditor *editor, HmcUid assetUid, void *pixelBuffer);

HMC_API int HmcAssetSetSourceByPicture(HmcEditor *editor, HmcUid assetUid, OH_PictureNative *nativePicture,
                                       bool isOriPicture = true);

/**
 * 剪辑创建（返回错误码）
 */
HMC_API int HmcAssetCreate(HmcEditor *editor, HmcUid laneUid, HmcDict *dict, HmcUid *poutAssetUid,
    bool autoPauseEditor = true);

/**
 * 剪辑销毁(销毁内存，当前未销毁，待调用点修改成HmcAssetRemove后再修改这个接口为销毁)（返回错误码）
 */
HMC_API int HmcAssetDestroy(HmcEditor *editor, HmcUid assetUid, bool autoPauseEditor = true);

/**
 * 设置剪辑开启、关闭原色模式
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param mode          是否开启原色模式，1开启，0关闭
 * @return              设置成功返回0，-1表示失败
 */
HMC_API int32_t HmcAssetSetOriginalColorMode(HmcEditor *editor, HmcUid assetUid, int32_t mode);

/**
 * 获取剪辑原色模式
 * @param assetUid      剪辑uid
 * @return              获取成功返回模式，-1表示失败
 */
HMC_API int32_t HmcAssetGetOriginalColorMode(HmcUid assetUid);

/**
 * 获取剪辑的原始素材的UID
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @return              原始素材的UID, HMC_UID_NULL表示失败
 */
HMC_API HmcUid HmcAssetGetMaterialUid(HmcEditor *editor, HmcUid assetUid);

/**
 * 获取剪辑的元数据
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param metaData      用于接收剪辑的元数据
 * @return              HMC_OK 成功， 其他错误码失败
 */
HMC_API int HmcAssetGetMetaData(HmcEditor *editor, HmcUid assetUid, HmcDict *metaData);

/**
 * 设置剪辑的元数据
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param metaData      要设置的剪辑的元数据,支持的KEY:
 * DICT_KEY_ASSET_PROPERTY_START
 * DICT_KEY_ASSET_PROPERTY_DURATION
 * DICT_KEY_ASSET_PROPERTY_TRIM_IN
 * DICT_KEY_ASSET_PROPERTY_TRIM_OUT
 * DICT_KEY_ASSET_PROPERTY_WIDTH
 * DICT_KEY_ASSET_PROPERTY_HEIGHT
 * @return              HMC_OK 成功， 其他错误码失败
 */
HMC_API int HmcAssetSetMetaData(HmcEditor *editor, HmcUid assetUid, HmcDict *metaData);

/**
 * 获取视频素材原始视频的FPS。(返回错误码)
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param fps           原视频FPS
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetGetVideoFps(HmcEditor *editor, HmcUid assetUid, double *fps);

/**
 * 获取视频素材原始视频的码率。(返回错误码)
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param fps           原视频码率
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetGetVideoBitRate(HmcEditor *editor, HmcUid assetUid, int32_t *bitRate);

/**
 * 获取剪辑的开始时间。
 */
HMC_API int64_t HmcAssetGetStartTime(HmcEditor *editor, HmcUid assetUid);

/**
 * 获取剪辑的结束时间。
 */
HMC_API int64_t HmcAssetGetEndTime(HmcEditor *editor, HmcUid assetUid);

/**
 * 获取剪辑的可见时长
 */
HMC_API int64_t HmcAssetGetDuration(HmcEditor *editor, HmcUid assetUid);

/**
 * 获取剪辑的文件时长(仅视频、音频可用)
 */
HMC_API int64_t HmcAssetGetFileDuration(HmcEditor *editor, HmcUid assetUid);

/**
 * 获取剪辑的泳道的唯一Id。
 */
HMC_API HmcUid HmcAssetGetLaneId(HmcEditor *editor, HmcUid assetUid);

/**
 * 获取剪辑的类型。
 */
HMC_API HmcAssetType HmcAssetGetType(HmcEditor *editor, HmcUid assetUid);

/**
 * 获取批量缩略图
 * @param editor         编辑器句柄
 * @param assetUid       剪辑的uid，可以为HMC_UID_NULL,表示左边没有剪辑
 * @param startTimestamp 开始时间戳，单位毫秒（相对剪辑起点，可为负值）
 * @param duration       持续时长，单位毫秒
 * @param interval       缩略图间隔时长，单位毫秒
 */
HMC_API void HmcAssetRequestThumbnail(HmcEditor *editor, HmcUid assetUid, int64_t startTimestamp, int64_t duration,
    unsigned int interval);

/**
 * 根据列表请求缩略图(list)
 * @param editor         编辑器句柄
 * @param assetUid       剪辑的uid，可以为HMC_UID_NULL,表示左边没有剪辑
 * @param timeStamps     请求缩略图列表时间列表，单位毫秒
 * @param count          请求缩略图列表数目
 */
HMC_API void HmcAssetRequestThumbnailList(HmcEditor *editor, HmcUid assetUid, int64_t *timeStamps, unsigned int count);

/**
 * 根据列表请求滤镜缩略图(list)
 * @param editor         编辑器句柄
 * @param assetUid       剪辑的uid，可以为HMC_UID_NULL,表示左边没有剪辑
 */
HMC_API void HmcAssetRequestFilterThumbnail(HmcEditor *editor, HmcUid assetUid);

/**
 * 根据列表请求滤镜缩略图
 * @param editor         编辑器句柄
 * @param assetUid       剪辑的uid
 * @param xtStyleParams  个性风格json格式参数
 */
HMC_API void HmcAssetRequestXTStyleThumbnail(HmcEditor *editor, HmcUid assetUid, std::vector<int> xtStyleParams);

/**
 * 取消缩略图获取
 * @param editor         编辑器句柄
 * @param assetUid       剪辑的uid，可以为HMC_UID_NULL,表示左边没有剪辑
 */
HMC_API void HmcAssetCancelThumbnail(HmcEditor *editor, HmcUid assetUid);

/**
 * 获取波形数据
 * @param assetUid       剪辑的uid
 * @param startTimestamp 开始时间戳，单位毫秒
 * @param duration       持续时长，单位毫秒
 * @param points         请求的点数
 */
HMC_API void HmcAssetRequestAudioWave(HmcEditor *editor, HmcUid assetUid, int64_t stattimestamp, int64_t duration,
    int points);

/**
 * 获取剪辑的缩放比例（返回错误码）
 */
HMC_API int HmcAssetGetZoom(HmcEditor *editor, HmcUid assetUid, float *zoomX, float *zoomY);

/**
 * 设置剪辑的缩放比例（返回错误码）
 */
HMC_API int HmcAssetSetZoom(HmcEditor *editor, HmcUid assetUid, float zoomX, float zoomY);

/**
 * 获取剪辑的旋转角度（返回错误码）
 */
HMC_API int HmcAssetGetRotation(HmcEditor *editor, HmcUid assetUid, float *rotation, HmcRotationAxis axis);
/**
 * 设置剪辑的旋转角度（返回错误码）
 */
HMC_API int HmcAssetSetRotation(HmcEditor *editor, HmcUid assetUid, float rotation, HmcRotationAxis axis);

/**
 * 设置剪辑（asset）的透明度
 * @param editor         编辑器句柄
 * @param assetUid       剪辑的uid
 * @param opacity        透明度，0-1直接，对应0%-100%
 * @return               HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetSetOpacity(HmcEditor *editor, HmcUid assetUid, float opacity);

/**
 * 获取剪辑相对位置信息（在屏幕上相对于预览窗口中心点的相对位置）
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param offsetX       输出参数，剪辑位置信息
 * @param offsetY       输出参数，剪辑位置信息
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetGetPositionByCenter(HmcEditor *editor, HmcUid assetUid, float *offsetX, float *offsetY);

/**
 * 设置剪辑的坐标, 输入坐标以预览窗口中心点为原点
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param offsetX       剪辑位置信息
 * @param offsetY       剪辑位置信息
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetSetPositionByCenter(HmcEditor *editor, HmcUid assetUid, float offsetX, float offsetY);

/**
 * 设置剪辑尺寸
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param size          剪辑尺寸大小
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetSetSize(HmcEditor *editor, HmcUid assetUid, HmcSize size);

/**
 * 获取剪辑尺寸
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param type          剪辑尺寸类型
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetGetSize(HmcEditor *editor, HmcUid assetUid, HmcSizeType type, HmcSize *poutSize);

/**
 * 设置目标尺寸
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param size          剪辑尺寸大小
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetSetDestSize(HmcEditor *editor, HmcUid assetUid, HmcSize size);

/**
 * 获取素材的4个顶点的位置
 * @param editor        编辑器句柄
 * @param assetUid      剪辑uid
 * @param output        获取的4个顶点的位置
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcAssetGetVertexPosition(HmcEditor *editor, HmcUid assetUid, float *output, unsigned outputSize);

/**
 * 获取剪辑资源name
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param name          剪辑资源name
 * @param size          参数剪辑资源名字，建议使用 PATH_MAX
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcGetAssetName(HmcEditor *editor, HmcUid assetUid, char *name, int size);

/**
 * 获取剪辑资源path路径
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param path          剪辑资源路径
 * @param size          参数剪辑资源路径的大小，建议使用 PATH_MAX
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcGetAssetResource(HmcEditor *editor, HmcUid assetUid, char *path, int size);

/**
 * 获取声道数            编辑器句柄
 * @param editor       编辑器句柄
 * @param assetUid     剪辑UID
 * @param channelNum   声道数
 * @return
 */
HMC_API int HmcAssetGetChannelNum(HmcEditor *editor, HmcUid assetUid, int *channelNum);

/**
 * 获取音量
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param volume        音量
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetGetVolume(HmcEditor *editor, HmcUid assetUid, float *volume);

/**
 * 设置音量
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param volume        音量
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetVolume(HmcEditor *editor, HmcUid assetUid, float volume);

/**
 * 获取左声道音量
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param volume        音量
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetGetVolumeLeft(HmcEditor *editor, HmcUid assetUid, float *volume);

/**
 * 设置左声道音量
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param volume        音量
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetVolumeLeft(HmcEditor *editor, HmcUid assetUid, float volume);

/**
 * 获取右声道音量
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param volume        音量
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetGetVolumeRight(HmcEditor *editor, HmcUid assetUid, float *volume);

/**
 * 设置右声道音量
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param volume        音量
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetVolumeRight(HmcEditor *editor, HmcUid assetUid, float volume);

/**
 * 设置左声道db值
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param db            左声道db值
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetVolumeLeftDB(HmcEditor *editor, HmcUid assetUid, double db);

/**
 * 获取左声道db值
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param db            左声道db值
 * @return              HMC_OK 成功；否则失败
 **/
HMC_API int HmcAssetGetVolumeLeftDB(HmcEditor *editor, HmcUid assetUid, double *db);

/**
 * 设置右声道db值
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param db            右声道db值
 * @return              HMC_OK 成功；否则失败
 **/
HMC_API int HmcAssetSetVolumeRightDB(HmcEditor *editor, HmcUid assetUid, double db);

/**
 * 获取右声道db值
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param db            右声道db值
 * @return              HMC_OK 成功；否则失败
 **/
HMC_API int HmcAssetGetVolumeRightDB(HmcEditor *editor, HmcUid assetUid, double *db);

/**
 * 设置db值
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param db            db值
 * @return              HMC_OK 成功；否则失败
 **/
HMC_API int HmcAssetSetVolumeDB(HmcEditor *editor, HmcUid assetUid, double db);

/**
 * 获取db
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param db            db值
 * @return              HMC_OK 成功；否则失败
 **/
HMC_API int HmcAssetGetVolumeDB(HmcEditor *editor, HmcUid assetUid, double *db);

/**
 * 设置静音
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param mute          静音标志：TRUE，静音；FALSE，非静音
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetMute(HmcEditor *editor, HmcUid assetUid, int mute);

/**
 * 获取静音状态
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param mute          静音标志：TRUE，静音；FALSE，非静音
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetIsMute(HmcEditor *editor, HmcUid assetUid, int *mute);

/**
 * 设置变音
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param soundType     变音类型
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetChangeSoundType(HmcEditor *editor, HmcUid assetUid, HmcAudioSoundType soundType);

/**
 * 获取变音
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param soundType     变音类型
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetGetSoundType(HmcEditor *editor, HmcUid assetUid, HmcAudioSoundType *soundType);

/**
 * 设置音调
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param pitch         音调值
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetPitch(HmcEditor *editor, HmcUid assetUid, float pitch);

/**
 * 获取音调
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param pitch         音调值
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetGetPitch(HmcEditor *editor, HmcUid assetUid, float *pitch);

/**
 * 获取渐入时间
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param fadeInTimeMs  渐入时间
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcGetFadeInTimeMs(HmcEditor *editor, HmcUid assetUid, unsigned int *fadeInTimeMs);

/**
 * 获取渐入持续时间
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param fadeInDurationMs  渐入持续时间
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcGetFadeInDurationMs(HmcEditor *editor, HmcUid assetUid, unsigned int *fadeInDurationMs);

/**
 * 获取渐出时间
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param fadeOutTimeMs 渐出时间
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcGetFadeOutTimeMs(HmcEditor *editor, HmcUid assetUid, unsigned int *fadeOutTimeMs);

/**
 * 获取渐出持续时间
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param fadeOutDurationMs 渐出持续时间
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcGetFadeOutDurationMs(HmcEditor *editor, HmcUid assetUid, unsigned int *fadeOutDurationMs);

/**
 * 设置渐入时间
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param fadeInTimeMs  渐入时间
 * @param fadeInDurationMs 渐入持续时间
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcSetFadeInTimeMs(HmcEditor *editor, HmcUid assetUid, unsigned int fadeInTimeMs,
    unsigned int fadeInDurationMs);

/**
 * 设置渐出时间
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param fadeOutTimeMs 渐出时间
 * @param fadeOutDurationMs 渐出持续时间
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcSetFadeOutTimeMs(HmcEditor *editor, HmcUid assetUid, unsigned int fadeOutTimeMs,
    unsigned int fadeOutDurationMs);

/**
 * 获取剪辑镜像
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param mirror        镜像标志: 1, 镜像; 0, 非镜像
 * @param type          镜像类型: HMC_ASSET_MIRROR_VERTICAL, 垂直镜像; HMC_ASSET_MIRROR_HORIZONTAL, 水平镜像
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetGetMirror(HmcEditor *editor, HmcUid assetUid, HmcAssetMirrorType type, int *mirror);

/**
 * 设置剪辑镜像
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param mirror        镜像标志: 1, 镜像; 0, 非镜像
 * @param type          镜像类型: HMC_ASSET_MIRROR_VERTICAL, 垂直镜像; HMC_ASSET_MIRROR_HORIZONTAL, 水平镜像
 */
HMC_API int HmcAssetSetMirror(HmcEditor *editor, HmcUid assetUid, int mirror, HmcAssetMirrorType type);

/**
 * 设置裁剪剪辑（asset）的位置信息
 * @param editor              编辑器句柄
 * @param assetUid            视频剪辑UID
 * @param position
 * 裁剪视频的位置信息，以裁剪框视频左顶点为原点的坐标和视频宽高的比例（范围0-1），该坐标位置可以通过HmcAssetConverCropPosition接口将UI坐标转换为裁剪坐标比例
 * @return                    HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetCrop(HmcEditor *editor, HmcUid assetUid, HmcAssetCropPosition *position);

/**
 * 设置裁剪+位移缩放的effect
 * @param editor              编辑器句柄
 * @param assetUid            视频剪辑UID
 * @param position            裁剪信息
 * @return                    HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetCropTransformSetCrop(HmcEditor *editor, HmcUid assetUid, HmcAssetCropPosition *position);

/**
 * 设置预览显示水印参数
 * @param assetUid            视频剪辑UID
 * @param watermarkParam      水印参数
 * @return                    HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetWatermark(HmcUid assetUid, WatermarkParam watermarkParam);

/**
 * 设置裁剪+位移缩放的effect
 * @param editor              编辑器句柄
 * @param assetUid            视频剪辑UID
 * @param offsetX             位移
 * @param offsetY             位移
 * @param scaleX              缩放
 * @param scaleY              缩放
 * @param rotate              旋转
 * @return                    HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetCropTransformSetPosition(HmcEditor *editor, HmcUid assetUid, float x, float y, float scaleX,
    float scaleY, float rotate);

/**
 * 设置镂空区域模糊effect
 * @param assetUid            视频剪辑UID
 * @param topLeftX            左上角X 0-1之间
 * @param topLeftY            左上角Y 0-1之间
 * @param bottomRightX        右下角X 0-1之间
 * @param bottomRightY        右下角Y 0-1之间
 * @return                    HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetCropPosition(HmcUid assetUid, float topLeftX, float topLeftY,
    float bottomRightX, float bottomRightY);

/**
 * 获取剪辑倒放
 * @param editor              编辑器句柄
 * @param assetUid            视频剪辑UID
 * @return                    0:正放，1:倒放，-1:失败
 */
HMC_API int HmcAssetGetBackward(HmcEditor *editor, HmcUid assetUid);

/**
 * 设置剪辑倒放
 * @param editor              编辑器句柄
 * @param assetUid            视频剪辑UID
 * @param isBackward          是否倒放（0:否，1:倒放）
 * @return                    HMC_OK 成功；否则失败
 */
HMC_API int HmcAssetSetBackward(HmcEditor *editor, HmcUid assetUid, int isBackward);

/**
 * 获取剪辑的封面图片（带模糊度）
 * @param editor              编辑器句柄
 * @param assetUid            剪辑的UID
 * @param timeStamp           当前timeline时间
 * @param strength            模糊度数值（0~10）
 * @return                    出参：返回一个image对象（剪辑的第一帧带模糊度的image对象）
 */
HMC_API HmcImage *HmcAssetGetImageByBlurred(HmcEditor *editor, HmcUid assetUid, int64_t timeStamp,
    unsigned int strength);

/**
 * 判断当前时间是否在剪辑内
 * @param editor              编辑器句柄
 * @param assetUid            剪辑的UID
 * @return                    1 ：当前timeline在剪辑内，0：不在
 */
HMC_API int HmcAssetIsInCurrentTime(HmcEditor *editor, HmcUid assetUid);

/**
 * 延迟初始化剪辑数据
 * @param editor              编辑器句柄
 * @param assetUid            剪辑的UID
 * @return                    设置成功返回0，-1表示失败
 */
HMC_API int HmcAssetDelayInit(HmcEditor *editor, HmcUid assetUid);

/**
 * 替换原图source数据
 * @param editor         编辑器句柄
 * @param dict          设置画布的参数
 * @param assetUid       剪辑的uid，可以为HMC_UID_NULL,表示左边没有剪辑
 * @param path           原图存储地址
 * @return               设置成功返回0，-1表示失败
 */
HMC_API int32_t HmcAssetReplaceSource(HmcEditor *editor, HmcDict *dict, HmcUid laneUid, const std::string path);

/**
 * 设置预览模式
 * @param editor              编辑器句柄
 * @param assetUid            剪辑的uid
 * @param isInPreviewMode     是否在预览模式
 * @return                    设置成功返回0，-1表示失败
 */
HMC_API int32_t HmcAssetSetPreviewMode(HmcEditor *editor, HmcUid assetUid, bool isInPreviewMode);

/**
 * 设置页面切换状态
 *
 * @param editor 编辑器句柄
 * @param assetUid 剪辑的uid
 * @param isSwitchPage 是否在页面切换
 * @return 设置成功返回0，-1表示失败
 */
HMC_API int32_t HmcAssetSetIsSwitchPage(HmcEditor *editor, HmcUid assetUid, bool isSwitchPage);
/**
 * 设置是否显示水印
 * @param editor              编辑器句柄
 * @param assetUid            剪辑的uid
 * @param isInPreviewMode     是否显示水印
 * @return                    设置成功返回0，-1表示失败
 */
HMC_API int32_t HmcAssetSetDrawWaterMarkValue(HmcEditor *editor, HmcUid assetUid, bool isDrawWaterMark);

/**
 * 刷新对比效果器列表缓存
 * @param editor              编辑器句柄
 * @param assetUid            剪辑的uid
 * @return                    设置成功返回0，-1表示失败
 */
HMC_API int32_t HmcAssetRefreshCompareEffectList(HmcEditor *editor, HmcUid assetUid);

/**
 * 设置XXX水印的参数
 * @param assetUid            剪辑的uid
 * @param params              isContainXtStyle 是否在水印filter中开启XXX参数信息
 * @param xtStyleCode         XXX模板名称 例如 F101015
 * @param xtColor             XXX参数映射的颜色 格式如 F101015
 * @param xtStyleText         XXX模板名称或者用户自定义的模板名称
 * @return                    设置成功返回0，-1表示失败
 */
HMC_API int32_t HmcAssetSetWatermarkXtStyleParam(HmcUid assetUid, bool isContainXtStyle, STRING xtStyleCode,
                                                 STRING xtColor, STRING xtStyleText);

/**
 * 设置是否拖动图片
 *
 * @param editor 编辑器句柄
 * @param assetUid 剪辑的uid
 * @param isDragImage 是否在拖动图片
 * @return 拖动图片返回1，没有拖动图片返回0
 */
HMC_API int32_t HmcAssetSetIsDragImage(HmcEditor *editor, HmcUid assetUid, bool isDragImage);

#ifdef __cplusplus
}
#endif

#endif // HMCEDITORASSET_H
