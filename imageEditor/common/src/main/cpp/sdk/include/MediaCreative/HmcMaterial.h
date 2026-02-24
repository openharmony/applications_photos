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

#ifndef HMC_MATERIAL_H
#define HMC_MATERIAL_H

#ifdef __cplusplus
extern "C" {
#endif

#define NAME_MAX_LEN 128

#define MATERIAL_COLUMN_NEXT_PAGE_YES (1)
#define MATERIAL_COLUMN_NEXT_PAGE_NO (0)

// --------------------- Material Dict Key ---------------------------------------------------------
#define HMC_MATERIAL_EXPIRED_CLOUD_ID "expired_material_cloud_id"
#define HMC_MATERIAL_FROM_NET "is_from_net"
#define HMC_MATERIAL_KEY_RETCODE "return_code"
#define HMC_MATERIAL_KEY_GET_TYPE "type"
#define HMC_MATERIAL_KEY_GET_COLUMN_LIST "column_list"
#define HMC_MATERIAL_KEY_GET_CONTENT_LIST "content_list"
#define HMC_MATERIAL_KEY_GET_CONTENT "content"
#define HMC_MATERIAL_KEY_CONTENT_STATE "content_state"
#define HMC_MATERIAL_KEY_UID "uid"
#define HMC_MATERIAL_KEY_PIC_IDX "pic_idx"
#define HMC_MATERIAL_KEY_PIC_PTR "pic_ptr"
#define HMC_MATERIAL_KEY_PIC_PATH "pic_path"
#define HMC_MATERIAL_KEY_PREVIEW_FILE_PATH "preview_file_path"
#define HMC_MATERIAL_KEY_URL "url"
#define HMC_MATERIAL_KEY_OFFSET "offset"
#define HMC_MATERIAL_KEY_COUNT "count"
#define HMC_MATERIAL_KEY_COLUMN_TYPE "column_type"
#define HMC_MATERIAL_KEY_EDITOR "editor"
#define HMC_MATERIAL_KEY_TEMPALTE_EDITABLE_ELEMENT "editbale_element"
#define HMC_MATERIAL_KEY_HAS_NEXT_PAGE "has_next_page"
#define HMC_MATERIAL_KEY_MATERIAL_CODE "material_code" // codeid，通过codeId cloudId下载素材时候需要
#define HMC_MATERIAL_KEY_CLOUD_ID "cloud_id"
#define HMC_MATERIAL_KEY_DESCRIPTION "description"
#define HMC_MATERIAL_KEY_TEXTURE_TYPE "transition_texture_type" // 转场纹理类型

#define HMC_MATERIAL_KEY_LOCAL_FILE_PATH "file_path"                     // 文件路径
#define HMC_MATERIAL_KEY_LOCAL_FILE_UID "file_uid"                       // 文件uid
#define HMC_MATERIAL_KEY_LOCAL_COVER_IMAGE "cover_image"                 // 封面
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_FORMAT "format"                 // 格式
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_TYPE "type"                     // 类型
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_DURATION "duration"             // 时长
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_FILE_SIZE "file_size"           // 文件大小
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_FILE_PIXEL "pixel"              // 像素
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_HEIGHT "height"                 // 高度
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_WIDTH "width"                   // 宽度
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_VIDEO_FPS "video_fps"           // 视频帧率
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_SAMPLING_RATE "sample_rate"     // 采样率
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_SOUND_CHANNEL "sound_channel"   // 声道
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_UNIT "unit"                     // 单位
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_VIDEO_BIT_RATE "video_bit_rate" // 视频码率
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_AUDIO_BIT_RATE "audio_bit_rate" // 音频码率
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_CREATETIME "create_time"        // 文件创建时间
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_AUDIO_CODER "audio_coder"       // 音频编解码器
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_VIDEO_CODER "video_coder"       // 视频编解码器
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_TRIM_IN "trim_in"               // trim in
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_TRIM_OUT "trim_out"             // trim out
#define HMC_MATERIAL_KEY_LOCAL_ATTRIBUTE_STRAT_TIME "start_time"         // 开始时间

// --------------------- Material Music Dict Key ---------------------------------------------------------
#define MATERIAL_MUSIC_KEY_START "start" // dict or json
#define MATERIAL_MUSIC_KEY_LIMIT "limit" // dict or json
#define MATERIAL_MUSIC_KEY_DICT_CONTENT_CODE "content_code"
#define MATERIAL_MUSIC_KEY_DICT_CONTENT_TYPE "content_type"
#define MATERIAL_MUSIC_KEY_DICT_QUERY_WORD "query_word"
#define MATERIAL_MUSIC_KEY_DICT_ARTIST_NAME "artist_name"

/**
 * 素材栏目类型
 */
typedef enum HmcMaterialLibraryColumnType {
    HMC_MATERIAL_COLUMN_MATERIAL = 0,       // 素材栏目, 包括视频
    HMC_MATERIAL_COLUMN_VIDEO_ANIMATION,    // 视频动画
    HMC_MATERIAL_COLUMN_SOUND_EFFECT,       // 音效栏目
    HMC_MATERIAL_COLUMN_STICKER,            // 贴纸栏目
    HMC_MATERIAL_COLUMN_FILTER,             // 滤镜栏目
    HMC_MATERIAL_COLUMN_TEXT,               // 文字栏目
    HMC_MATERIAL_COLUMN_EFFECT,             // 特效栏目
    HMC_MATERIAL_COLUMN_CANVAS,             // 画布栏目
    HMC_MATERIAL_COLUMN_MUSIC,              // 曲库/音乐栏目
    HMC_MATERIAL_COLUMN_TEMPLATE,           // 模板栏目
    HMC_MATERIAL_COLUMN_TEXT_FONT,          // 文字字体
    HMC_MATERIAL_COLUMN_TEXT_ART,           // 文字花字
    HMC_MATERIAL_COLUMN_TEXT_BUBBLE,        // 文字气泡
    HMC_MATERIAL_COLUMN_TEXT_ANIMATION,     // 文字动画
    HMC_MATERIAL_COLUMN_STICKER_ANIMATION,  // 贴纸动画
    HMC_MATERIAL_COLUMN_TEXT_TEMPLATE,      // 文字模板
    HMC_MATERIAL_COLUMN_TRANSITION,         // 转场栏目
    HMC_MATERIAL_COLUMN_WATER_MASK,         // 水印
    HMC_MATERIAL_COLUMN_CURVESPEED,         // 曲线变速
    HMC_MATERIAL_COLUMN_MASK,               // 蒙版
    HMC_MATERIAL_COLUMN_STICKER_FACE,       // 人脸贴纸
    HMC_MATERIAL_COLUMN_HAIR_DYEING,        // 一键美发栏目
    HMC_MATERIAL_COLUMN_AI_BOX,             // AI宝箱
    HMC_MATERIAL_COLUMN_TYPE_HW_MUSIC = 40, // 音乐曲库
    HMC_MATERIAL_COLUMN_BUTTOM              // 用来标识数组长度
} HmcMaterialLibraryColumnType;

/**
 * 素材的类型
 */
typedef enum HmcMaterialLibraryType {
    MATERIAL_CONTENT_TYPE_NONE = 0,               // 未定义
    MATERIAL_CONTENT_TYPE_VIDEO = 1,              // 视频素材
    MATERIAL_CONTENT_TYPE_EFFECT = 2,             // 特效
    MATERIAL_CONTENT_TYPE_FILTER = 3,             // 滤镜
    MATERIAL_CONTENT_TYPE_STICKER = 4,            // 贴纸
    MATERIAL_CONTENT_TYPE_VIDEO_ANIMATION = 5,    // 视频动画
    MATERIAL_CONTENT_TYPE_TEXT_FONT = 6,          // 文字字体
    MATERIAL_CONTENT_TYPE_TEXT_ART = 7,           // 文字花字
    MATERIAL_CONTENT_TYPE_TEXT_BUBBLE = 8,        // 文字气泡
    MATERIAL_CONTENT_TYPE_TEXT_ANIMATION = 9,     // 文字动画
    MATERIAL_CONTENT_TYPE_CANVAS = 10,            // 画布
    MATERIAL_CONTENT_TYPE_SOUND_EFFECT = 11,      // 音效
    MATERIAL_CONTENT_TYPE_MUSIC = 12,             // 曲库/音乐
    MATERIAL_CONTENT_TYPE_TEMPLATE = 13,          // 模板
    MATERIAL_CONTENT_TYPE_IMAGE = 15,             // 图片素材
    MATERIAL_CONTENT_TYPE_TRANSITION = 16,        // 转场
    MATERIAL_CONTENT_TYPE_MASK = 17,              // 蒙版
    MATERIAL_CONTENT_TYPE_STICKER_ANIMATION = 18, // 贴纸动画
    MATERIAL_CONTENT_TYPE_TEXT_TEMPLATE = 19,     // 文字模板
    MATERIAL_CONTENT_TYPE_AI = 20,                // AI素材
    MATERIAL_CONTENT_TYPE_CURVESPEED = 21,        // 曲线变速
    MATERIAL_CONTENT_TYPE_STICKER_FACE = 22,      // 人脸贴纸
    MATERIAL_CONTENT_TYPE_HAIR_DYEING = 23,       // 一键美发
    MATERIAL_CONTENT_TYPE_LIGHT = 24,             // 光场迁移
    MATERIAL_CONTENT_TYPE_LIGHT_FACE = 25,        // 人脸布光
    MATERIAL_CONTENT_TYPE_HW_MUSIC = 60,          // 音乐曲库

    MATERIAL_CONTENT_TYPE_COLUMN = 101 // 栏目
} HmcMaterialLibraryType;

/**
 * 素材状态
 */
typedef enum HmcMaterialState {
    MATERIAL_STATE_UNAVAILABLE = 0, // 不可用，如未下载或下载失败导致素材不可用
    MATERIAL_STATE_CREATING,        // 创建中，或者下载
    MATERIAL_STATE_AVAILABLE,       // 可用
    MATERIAL_STATE_NEED_UPDATE,     // 需要更新
    MATERIAL_STATE_UPDATING,        // 更新中
    MATERIAL_STATE_PARSING,         // 正在解析，文字模板解析过程中需要下载需要的素材
    MATERIAL_STATE_DOWNLOAD_FAILED, // 下载素材失败
    MATERIAL_STATE_TOTAL_CNT        // 无效状态
} HmcMaterialState;

typedef enum HmcMaterialEvent {
    HMC_MATERIAL_EVENT_NONE = 0,                // 未定义事件
    HMC_MATERIAL_EVENT_NET_GET_BY_BASE_COLUMN,  // 从网络获取父栏目下的子栏目列表
    HMC_MATERIAL_EVENT_NET_GET_BY_COLUMN,       // 从网络获取子栏目下的素材列表
    HMC_MATERIAL_EVENT_NET_GET_BY_CONTENT,      // 从网络获取素材
    HMC_MATERIAL_EVENT_NET_DOWNLOAD,            // 从网络下载素材
    HMC_MATERIAL_EVENT_NET_DOWNLOAD_PIC,        // 从网络下载素材的海报
    HMC_MATERIAL_EVENT_NET_DOWNLOAD_PREVIEW,    // 从网络下载素材（模板）的预览
    HMC_MATERIAL_EVENT_LOCAL_COVERIMAGEUPDATE,  // 本地素材封面图更新
    HMC_MATERIAL_EVENT_LOCAL_THUMBNAILUPDATE,   // 本地素材缩略图更新
    HMC_MATERIAL_EVENT_NET_DOWNLOAD_BY_CODE_ID, // 从网络根据codeid下载素材
    HMC_MATERIAL_EVENT_PARSE_TEXT_TEMPLATE,     // 解析文字模板素材，并自动下载需要的素材
    HMC_MATERIAL_EVENT_FUZZY_SEARCH_MUSIC,      // 搜索查询 曲库
    HMC_MATERIAL_EVENT_NEW_MATERIAL             // 上报新增光场素材
} HmcMaterialEvent;

/**
 * 本地素材类型
 */
typedef enum HmcLocalMaterialType {
    HMCLOCALMATERIALTYPE_NONE = 0,        // 无效
    HMCLOCALMATERIALTYPE_VIDEO,           // 视频
    HMCLOCALMATERIALTYPE_AUDIO,           // 音频
    HMCLOCALMATERIALTYPE_IMAGE,           // 图片
    HMCLOCALMATERIALTYPE_IMAGE_ANIMATION, // 动图(gif)
} HmcLocalMaterialType;

/**
 * 光场素材子类型
 */
typedef enum {
    HMC_MATERIAL_LIGHT_SUB_TYPE_NONE = 0,  // 无效
    HMC_MATERIAL_LIGHT_SUB_TYPE_LEARNING,  // 学习模板
    HMC_MATERIAL_LIGHT_SUB_TYPE_PRESERVED, // 预置 不可修改
    HMC_MATERIAL_LIGHT_SUB_TYPE_CUSTOM     // 学习之后的，可以重命名
} HmcLightMaterialSubType;

typedef enum {
    HMC_MATERIAL_TRANSITION_TEXTURE_TYPE_DOUBLE, // 双纹理
    HMC_MATERIAL_TRANSITION_TEXTURE_TYPE_SINGLE, // 单纹理
    HMC_MATERIAL_TRANSITION_TEXTURE_TYPE_COUNT   // 纹理种类计数
} HmcMaterialTransitionSubType;

/**
 * 素材的海报图
 */
typedef struct HmcMaterialPic {
    char *type;        // 图片类型
    char *aspectRatio; // 图片长宽比，如300*300，或者100*100，内存由SDK释放
    char *url;         // 图片URL地址，内存由SDK释放
    char *path;        // 图片的本地路径，内存由SDK在回调函数执行完后释放
    HmcImage *image;   // 素材展示的image，内存由SDK在回调函数执行完后释放
    char *selectedUrl; // 素材展示时在被选中时的图片，可为NULL，不为NULL时内存由SDK释放
    char *selectedPath; // 素材展示时在被选中时的图片本地路径，可为NULL，不为NULL时内存由SDK释放
    HmcImage *selectedImage; // 素材展示时在被选中时的image，内存由SDK释放
} HmcMaterialPic;

/**
 * 素材库网络素材的数据结构
 */
typedef struct HmcMaterialLibraryContent {
    HmcUid uid;                          // 素材唯一标识
    HmcMaterialLibraryType materialType; // 素材库类型
    HmcMaterialState state;              // 素材状态
    long duration;                       // 素材时长（单位:ms），视频及音频属性，其余为0
    int subType;                         // 子类型
    uint64_t createdTime;                // 素材创建时间 unix 时间戳
    int downloadCount;                   // 下载次数
    int picCnt;                          // 海报的数量
    int segments; // 模板素材，需要替换的素材个数，目前暂时只有模板有，其他类型素材无
    HmcMaterialPic *picList; // 海报，内存由SDK释放
    char *description;       // 素材的描述, 内存由SDK释放
    char *previewUrl;        // 素材预览URL, 目前暂时只有模板有，其他类型素材无, 内存由SDK释放
    char *previewPath; // 素材预览路径, 目前暂时只有模板有，其他类型素材无, 内存由SDK释放
    char *name;        // 展示素材名数据
    int nameLen;       // 限制长度 扩展，app需要校验strlen(name) 比较
    HmcDict *dict;     // 其他参数（比如作者是音乐的特殊参数）
    char *cloudId;     // 素材云端ID
} HmcMaterialLibraryContent;

/**
 * 素材库网络栏目的数据结构
 */
typedef struct HmcMaterialLibraryColumn {
    HmcUid uid;                                     // 素材唯一标识
    HmcMaterialLibraryColumnType columnType;        // 栏目类型
    unsigned char name[NAME_MAX_LEN];               // 栏目展示的名称
    struct HmcMaterialLibraryColumn *subColumnList; // 子栏目起始指针（由SDK释放）
    int subColumnCnt;                               // 子栏目数量
    HmcMaterialLibraryContent *contentList;         // 子素材起始指针（由SDK释放）
    int contentCnt;                                 // 子素材数量
    HmcDict *dict;                                  // 其他参数
    int realContentCnt;                             // 传递给界面的子素材数量
} HmcMaterialLibraryColumn;

typedef struct HmcMaterialItem {
    char *cloudId;
} HmcMaterialItem;

typedef struct HmcMaterialOutDateList {
    unsigned int count;
    HmcMaterialItem *outDateList;
} HmcMaterialOutDateList;

/**
 * 曲线变速时间点
 */
typedef struct HmcMaterialCurveSpeedPoint {
    float timeFactor; // 时间系数(百分比)
    float speed;      // 速度
} HmcMaterialCurveSpeedPoint;

/**
 * 曲线变速模板
 */
typedef struct HmcMaterialCurveSpeedTemplate {
    unsigned int pointCount;            // 变速点个数
    HmcMaterialCurveSpeedPoint *points; // 变速点数组指针
} HmcMaterialCurveSpeedTemplate;

/**
 * 素材模块的回调函数
 * @param eventId           事件ID
 * @param eventMsg          SDK传递的数据
 * @param userData          APP的入参
 */
typedef void (*HmcMaterialCallback)(HmcMaterialEvent eventId, HmcDict *eventMsg, void *userData);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // HMC_MATERIAL_H
