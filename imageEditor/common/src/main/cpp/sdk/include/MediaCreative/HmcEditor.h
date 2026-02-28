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

#ifndef HMCEDITOR_H
#define HMCEDITOR_H

#include <functional>
#include <json/json.h>
#include <string>
#include "../../src/Bridge/ohos/jscaller/DataAbilityHelper.h"
#include "MediaCreative/HmcDict.h"
#include "MediaCreative/HmcEventId.h"
#include "MediaCreative/HmcUid.h"

// 工程句柄
typedef void HmcEditor;

#ifdef __cplusplus
extern "C" {
#endif

typedef enum HmcEditMediaType {    // 编辑素材类型
    HMC_EDIT_MEDIA_TYPE_VIDEO = 0, // 视频
    HMC_EDIT_MEDIA_TYPE_IMAGE = 1  // 图片
} HmcEditMediaType;

typedef enum HmcExportMediaType {               // 导出媒体类型
    HMC_EXPORT_MEDIA_TYPE_VIDEO_WITH_AUDIO = 0, // 音视频
    HMC_EXPORT_MEDIA_TYPE_VIDEO = 1,            // 纯视频
    HMC_EXPORT_MEDIA_TYPE_AUDIO = 2,            // 纯音频
    HMC_EXPORT_MEDIA_TYPE_IMAGE = 3             // 图片
} HmcExportMediaType;

using HmcRenderExportInfoFunc = std::function<void(std::string watermarkData)>;
using HmcRenderExportPixelmapFunc = std::function<void(HmcPixelMapInfo *info)>;
struct HmcEditExportFunc {
    int32_t exportType;
    HmcRenderExportInfoFunc exportInfoFunc;
    HmcRenderExportPixelmapFunc exportPixelmapFunc;
    bool needAddWatermark = false;
    bool isSave = false;
};

typedef void (*HmcEditorCallback)(HmcEditor *editor, HmcEventId eventId, HmcDict *eventMsg, void *userData);

// Part 工程
/**
 * 打开工程，用户必须提供有效的回调参数，否则无法创建editor，或得不到事件信息通知。
 * @param projectId     工程标识，传入HMC_UID_NULL就新建工程；否则根据projectId打开已保存的工程
 * @param callback      回调函数指针
 * @param userData      用户自定义参数，在回调中返回
 * @param editData      编辑数据
 * @return              创建得到的工程句柄<br>NULL 创建失败
 */
HMC_API std::shared_ptr<HmcEditor> HmcEditorOpen(const HmcUid &projectId, HmcEditMediaType mediaType,
    HmcEditorCallback callback, void *userData, std::string const & editData);

/**
 * 获取editor当前在编辑的项目的ID
 * @param editor        编辑器句柄
 * @return              项目ID（HmcId类型）
 */
HMC_API HmcUid HmcEditorGetProjectId(HmcEditor *editor);

/**
 * 关闭工程
 * @param project       编辑器句柄
 */
HMC_API void HmcEditorClose(HmcEditor *editor);

/**
 * 保存edit data数据
 * @param editor        编辑器句柄
 * @return              editdata数据
 */
HMC_API std::string HmcEditorGetEditData(HmcEditor *editor);

/**
 * 获取image effect数据
 * @param editor        编辑器句柄
 * @return              image effect数据
 */
HMC_API Json::Value HmcEditorGetImageEffectJson(HmcEditor *editor);

/**
 * 检查editdata数据是否为system数据
 * @param data      编辑数据
 * @return              true编辑数据有效；false编辑数据无效
 */
HMC_API bool HmcEditorIsSystemEditData(const std::string &data);

/**
 * 检查editdata数据是否为third数据
 * @param data      编辑数据
 * @return              true编辑数据有效；false编辑数据无效
 */
HMC_API bool HmcEditorIsThirdEditData(const std::string &data);

/**
 * 检查editdata数据是否存在水印效果
 * @param data  编辑数据
 * @param cb  回调方法
 * @return      true带水印；false不带水印
 */
HMC_API bool HmcEditorHasWatermarkEffect(const std::string &data, std::function<void(std::string const &jsonPos)> cb);

/**
 * 获取editdata数据里的裁剪角度
 * @param data  编辑数据
 * @return      裁剪角度
 */
HMC_API DOUBLE HmcEditorGetCropRotation(const std::string &data);

/**
 * 将editdata数据作用到素材上
 * @param editor        编辑器句柄
 * @param data          编辑数据
 * @param result        applyEditData结果
 * @return              HMC_OK成功，其他值失败
 */
HMC_API void HmcEditorApplyEditData(HmcEditor *editor, int sourceFileFd, const std::string &data, int &result,
                                    std::function<void(std::string const &assetId)> onDecodePicture);

/**
 * 获取第一个lane的Uid
 * @param editor        编辑器句柄
 * @return              返回第一个lane的Uid
 */
HMC_API HmcUid HmcEditorGetPreLaneUid(HmcEditor *editor);

/**
 * 获取第一个lane上第一个asset的Uid
 * @return              返回第一个lane上第一个asset的Uid
 */
HMC_API HmcUid HmcEditorGetPreAssetUid(HmcEditor *editor);

// Part 播控

/**
 * 设置预览窗口-不计算画布大小
 * @param  editor       编辑器句柄
 * @param  window       OHOS下为HmcNativeWindow
 */
HMC_API void HmcEditorSetPreviewWindow(HmcEditor *editor, void *window);

/**
 * 拖动到指定位置
 * @param  editor       编辑器句柄
 * @param  timestamp    时间戳，单位ms
 * @param  isExactMode  是否精确seek
 */
HMC_API void HmcEditorSeekTo(HmcEditor *editor, int64_t timestamp, bool isExactMode);

/**
 * 播放,时间点在seekto后SDK更新当前时间
 * @param  editor       编辑器句柄
 */
HMC_API void HmcEditorPlay(HmcEditor *editor, int64_t startTime, int64_t endTime);

/**
 * 暂停,状态在SDK内部切换
 * @param  editor       编辑器句柄
 */
HMC_API void HmcEditorPause(HmcEditor *editor);

/**
 * 获取修改类操作后是否自动刷新
 * @param  editor       编辑器句柄
 * @return              TRUE(1)为开启自动刷新, FALSE(0)为关闭自动刷新
 */
HMC_API int HmcEditorGetAutoFlush(HmcEditor *editor);

/**
 * 执行修改类操作后，自动刷新
 * @param  editor       编辑器句柄
 * @param  enable       TRUE(1)，FALSE(0)为开启自动刷新
 */
HMC_API void HmcEditorSetAutoFlush(HmcEditor *editor, int enable);

/**
 * 获取总时长
 * @param  editor       编辑器句柄
 * @return              总时长，单位:ms
 */
HMC_API int64_t HmcEditorGetDuration(HmcEditor *editor);

// Part 导出

/**
 * 导入
 * @param editor        编辑器句柄
 * @param result        导入结果通知
 */
HMC_API int64_t HmcEditorImportResultNotify(HmcEditor *editor, int result);

/**
 * 导出
 * @param editor        编辑器句柄
 * @param result        导出结果通知
 */
HMC_API int64_t HmcEditorExportResultNotify(HmcEditor *editor, int result);

/**
 * 计算导出视频/图片时的长宽
 * @param width        长
 * @param height       宽
 * @param mediaType    素材类型
 */
HMC_API int64_t HmcEditorCalcWidthAndLength(int &exportW, int &exportH, int mediaType);

/**
 * 导出
 * @param editor        编辑器句柄
 * @param dict          导出参数字典（宽、高、fps、像素, 路径等）
 */
HMC_API int64_t HmcEditorStartExporting(HmcEditor *editor, HmcDict *dict, HmcEditExportFunc func);

/**
 * 保存Picture
 * @param editor editor
 * @param dstPicture OH_PictureNative
 * @param dict HmcDict字典, 存放mimeType,导出文件路径
 * @param callback 导出完成回调
 * @return 错误码
 */
HMC_API int64_t HmcEditorEncodePicture(HmcEditor *editor, OH_PictureNative *dstPicture, HmcDict *dict,
    std::function<void (const std::string &, const std::string &)> callback);

/**
 * 取消导出
 * @param editor        编辑器句柄
 */
HMC_API void HmcEditorCancelExporting(HmcEditor *editor);

/**
 * 设置整体画布宽高和颜色
 * @param editor        编辑器句柄，通过HmcEditorOpen获取
 */
HMC_API int HmcEditorSetCanvasSize(HmcEditor *editor, float width, float height);

/**
 * 获取整体画布宽高
 * @param editor        编辑器句柄，通过HmcEditorOpen获取
 */
HMC_API int HmcEditorGetCanvasSize(HmcEditor *editor, float *width, float *height);

/**
 * 设置用户自定义数据
 * @param editor              编辑器句柄
 * @param objUid              对象的UID（比如：project、lane、asset、effect）
 * @param ObjUid              存储用户自定义数据
 * @return                    HMC_OK 成功；否则失败
 */
HMC_API int HmcEditorSetUserData(HmcEditor *editor, HmcUid objUid, HmcDict *dict);

/**
 * 获取剪辑（asset）的裁剪位置信息
 * @param editor              编辑器句柄
 * @param objUid              对象的UID（比如：project、lane、asset、effect）
 * @param poutDict            输出参数：返回对应的自定义数据的HmcDict指针对象的地址，返回的dcit对象需要调用者释放
 * @return                    HMC_OK 成功；否则失败
 */
HMC_API int HmcEditorGetUserData(HmcEditor *editor, HmcUid objUid, HmcDict **poutDict);

/**
 * 获取缓存大小
 * @return                    缓存大小(字节)
 */
HMC_API long long HmcEditorGetCacheSize();

/**
 * 清理缓存
 * @param savingDays          保留最近天数，0代表全部清理
 */
HMC_API void HmcEditorClearCache(int savingDays);

/**
 * 设置预览时间区间
 * @param editor        编辑器句柄，不能为nullptr
 * @param startTime     起始时间
 * @param endTime       结束时间
 */
HMC_API void HmcEditorSetPreviewPeriodRange(HmcEditor *editor, uint64_t startTime, uint64_t endTime);

/**
 * 获取预览时间区间
 * @param editor        编辑器句柄，不能为nullptr
 * @param startTime     起始时间
 * @param endTime       结束时间
 */
HMC_API int32_t HmcEditorGetPreviewPeriodRange(HmcEditor *editor, uint64_t &startTime, uint64_t &endTime);

/**
 * 检查 edit data 数据是否存在个性风格效果
 * @param data  编辑数据
 * @return json格式字符串
 */
HMC_API std::string HmcEditorHasXTStyleEffect(const std::string &data);

#ifdef __cplusplus
}
#endif

#endif // HMCEDITOR_H
