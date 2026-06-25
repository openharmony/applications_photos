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

#ifndef HMCEDITORLANE_H
#define HMCEDITORLANE_H

#ifdef __cplusplus
extern "C" {
#endif

// 属性//
typedef enum HmcLaneType {
    HMC_LANE_VISION = 0,
    HMC_LANE_AUDIO,
    HMC_LANE_NONE
} HmcLaneType;

/**
 * 添加泳道,创建泳道并自动附加到轨道列表最后
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param type          泳道类型，相同类型的Asset可放一个泳道
 * @return              成功，返回泳道标识 HmcUid <br>HMC_UID_NULL,创建失败
 */
HMC_API HmcUid HmcLaneCreate(HmcEditor *editor, HmcLaneType type);

/**
 * 创建泳道，不添加到轨道列表
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param type          泳道类型，相同类型的Asset可放一个泳道
 * @return              成功，返回泳道标识 HmcUid <br>HMC_UID_NULL,创建失败
 */
HMC_API HmcUid HmcLaneCreateLaneEntity(HmcEditor *editor, HmcLaneType type);

/**
 * 添加轨道到相应轨道列表末尾
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param laneUid       轨道UID
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcLaneAppend(HmcEditor *editor, HmcUid laneUid);

/**
 * 添加轨道到相应轨道列表的指定位置
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param laneUid       轨道UID
 * @param index         泳道添加位置，只影响同类型泳道，从0开始
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcLaneInsert(HmcEditor *editor, HmcUid laneUid, unsigned int index);

/**
 * 从泳道列表中移除泳道，不销毁内存，可重新append或者insert到轨道列表中
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param laneUid       泳道标识
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcLaneRemove(HmcEditor *editor, HmcUid laneUid);

/**
 * 销毁泳道（该接口会销毁内存，无法撤销，当前还未销毁）
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param laneUid       泳道标识
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcLaneDestroy(HmcEditor *editor, HmcUid laneUid);

/**
 * 获取泳道类型
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param laneUid       泳道标识，通过HmcLaneCreate生成
 * @return              HmcLaneType 返回泳道类型
 */
HMC_API HmcLaneType HmcLaneGetType(HmcEditor *editor, HmcUid laneUid);

/**
 * 获取泳道index
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param laneUid       泳道标识，通过HmcLaneCreate生成
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcLaneGetIndex(const HmcEditor *editor, HmcUid laneUid, unsigned int *index);

/**
 * 获取泳道数量
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param type          泳道类型，相同类型的Asset可放一个泳道
 * @return              int 泳道数量
 */
HMC_API int HmcLaneGetCount(HmcEditor *editor, HmcLaneType type);

/**
 * 获取泳道列表
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param type          泳道类型，相同类型的Asset可放一个泳道
 * @param laneUid       泳道uid数组，空间由用户申请释放，数组有效空间应大于等于count值
 * @param count         泳道uid数组空间，返回实际uid数量，返回值小于等于用户传入值
 */
HMC_API void HmcLaneGetArr(HmcEditor *editor, HmcLaneType type, HmcUid *laneUid, int *count);

/**
 * 获取泳道素材数量
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param laneUid       泳道标识，通过HmcLaneCreate生成
 * @return              int 素材数量
 */
HMC_API int HmcLaneGetAssetCount(HmcEditor *editor, HmcUid laneUid);

/**
 * 获取素材列表
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param laneUid       泳道标识，通过HmcLaneCreate生成
 * @param assetUid      素材uid数组，空间由用户申请释放，数组有效空间应大于等于count值
 * @param count         素材uid数组空间，返回实际uid数量，返回值小于等于用户传入值
 */
HMC_API void HmcLaneGetAssetArr(HmcEditor *editor, HmcUid laneUid, HmcUid *assetUid, int *count);

/**
 * 获取泳道是否可见（参与渲染）
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param laneUid       泳道标识，通过HmcLaneCreate生成
 * @return              TRUE(1)表示轨道可见（参与渲染），FALSE（0）表示不可见
 */
HMC_API int HmcLaneIsVisible(HmcEditor *editor, HmcUid laneUid);

/**
 * 设置泳道是否可见（参与渲染）
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param laneUid       泳道标识，通过HmcLaneCreate生成
 * @param visible       TRUE(1)表示轨道可见（参与渲染），FALSE（0）表示不可见
 * @return              成功返回HMC_OK，失败返回其他
 */
HMC_API int HmcLaneSetVisible(HmcEditor *editor, HmcUid laneUid, int visible);

/**
 * 获取第一个在start time 到 end time之间可用（空白）的轨道
 * @param editor        编辑器句柄，通过HmcEditorOpenProject生成
 * @param type          泳道类型，如音频轨道/视频轨道等
 * @param startTime     起始时间
 * @param endTime       结束时间
 * @return HmcUid       成功返回第一个可用对到的轨道ID，如果所有轨道都不可用，则返回HMC_UID_NULL
 */
HMC_API HmcUid HmcLaneGetAvailableLane(HmcEditor *editor, HmcLaneType type, int64_t startTime, int64_t endTime);

/**
 * Lane设置静音:只要轨道静音，就看轨道的静音状态；轨道不静音，看剪辑的静音状态
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param mute          静音标志：TRUE，静音；FALSE，非静音
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcLaneSetMute(HmcEditor *editor, HmcUid laneUid, int mute);

/**
 * 判断一个Lane是否静音
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @return              静音标志：TRUE，静音；FALSE，非静音
 */
HMC_API int HmcLaneIsMute(HmcEditor *editor, HmcUid laneUid);

/**
 * Lane设置音量；获取轨道所有剪辑，同步设置音量
 * @param editor        编辑器句柄
 * @param assetUid      剪辑UID
 * @param volume        音量
 * @return              HMC_OK 成功；否则失败
 */
HMC_API int HmcLaneSetVolume(HmcEditor *editor, HmcUid laneUid, int volume);

#ifdef __cplusplus
}
#endif

#endif // HMCEDITORLANE_H
