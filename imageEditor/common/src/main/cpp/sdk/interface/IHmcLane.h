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
#ifndef HMC_LANE_INTERFACE_H
#define HMC_LANE_INTERFACE_H

#include "MediaCreative.h"

/**
 * @brief 轨道编辑操作的接口，包括查询时长，获取轨道上的剪辑，序列化反序列化等针对某个轨道的操作。
 */
class IHmcLane {
public:
    virtual ~IHmcLane(){};
    /* *
     * @brief 通过LaneUID查询Lane的对象, 不允许delete该对象.
     * @param HmcUid 轨道UID
     * @return 查询到的IHmcLane对象的接口，返回nullptr是表示查询失败，当前无对应的lane对象，调用者注意判空.
     */
    static IHmcLane *QueryLaneObj(const HmcUid &laneUid);

    /* *
     * @brief 获取轨道的唯一标识UID.
     * @return HmcUid 轨道UID
     */
    virtual HmcUid GetLaneUid() const = 0;

    /* *
     * @brief 获取轨道的类型，如视轨、音轨、NONE轨道<无效轨道>.
     * @return HmcLaneType 轨道类型
     */
    virtual HmcLaneType GetType() const = 0;

    /* *
     * @brief 获取轨道的时长,单位为毫秒(ms).
     * @return INT64 轨道UID
     */
    virtual uint64_t GetDuration() const = 0;

    /* *
     * @brief
     * 在轨道上创建剪辑，创建的剪辑不再使用时需要调用DestroyAsset接口销毁，或者调用ClearAsset清空轨道上的所有剪辑，或者销毁轨道时会自动销毁轨道上的所有剪辑
     * @param dict 创建剪辑的参数，包括剪辑类型[VIDEO,IMAGE,AUDIO],轨道上剪辑的起始时间等.
     * @return HmcUid
     * 创建出的新剪辑的UID，接口内部可能失败，调用者需要调用HmcUidIsNull判断剪辑UID是否为NULL，若UID是HMC_UID_NULL,则表示失败
     */
    virtual HmcUid CreateAsset(const HmcDict *dict) = 0;

    /* *
     * @brief 销毁轨道上的某个剪辑，内部会释放asset内存，并从轨道的asset列表中删除asset对象，并更新轨道时长duration.
     * @param HmcUid 要销毁的剪辑对象的UID.
     */
    virtual void DestroyAsset(const HmcUid &assetUid) = 0;

    /* *
     * @brief 在轨道上插入一个剪辑.
     * @param assetUid 要插入的剪辑UID.
     * @param startTime 要插入的轨道上的起始时间, 单位为毫秒(ms).
     * @return int32_t 成功返回HMC_OK, 其他表示失败的错误码.
     */
    virtual int32_t InsertAsset(const HmcUid &assetUid, uint64_t startTime) = 0;

    /* *
     * @brief 从轨道上移除一个剪辑，不销毁剪辑内存；只从轨道的asset列表中删除asset对象，并更新轨道时长duration.
     * @param assetUid 要移除的剪辑UID.
     */
    virtual void RemoveAsset(const HmcUid &assetUid) = 0;

    /* *
     * @brief 清空轨道上的所有剪辑，同时销毁剪辑内存，更新轨道时长duration = 0.
     */
    virtual void ClearAsset() = 0;

    /* *
     * @brief 同轨道内移动一个剪辑到目标时间.
     * @param assetUid 要移动的剪辑UID.
     * @param startTime 要移动到的目标起始时间, 单位为毫秒(ms).
     * @return bool 成功返回true, 失败返回false.
     */
    virtual bool MoveAsset(const HmcUid &assetUid, uint64_t startTime) = 0;

    /* *
     * @brief 获取该轨道上某个时间点上的剪辑.
     * @param timestamp 要查询的时间, 单位为毫秒(ms).
     * @return HmcUid
     * 某个时间点可能没有剪辑，所以调用者需要调用HmcUidIsNull判断剪辑UID是否为NULL，若UID是HMC_UID_NULL则表示该时间无剪辑.
     */
    virtual HmcUid GetAsset(uint64_t timestamp) const = 0;

    /* *
     * @brief 获取该轨道上所有的剪辑.
     * @param assetList 出参，接收剪辑列表.
     */
    virtual void GetAssetList(VECTOR<HmcUid> &assetList) const = 0;

    /* *
     * @brief 判断轨道上某个时间范围内是否有剪辑存在.
     * @param startTime 时间范围的起点.
     * @param endTime 时间范围的终点.
     * @return bool 成功返回true, 失败返回false.
     */
    virtual bool IsEmpty(uint64_t startTime, uint64_t endTime) const = 0;

    /* *
     * @brief 查询当前轨道是否静音.
     * @return bool true: 当前轨道静音, false：当前轨道不静音.
     */
    virtual bool IsMute() const = 0;

    /* *
     * @brief 设置当前轨道是否静音.
     * @param  mute 轨道是否静音，bool true: 轨道静音, false：当前轨道不静音.
     */
    virtual void SetMute(bool mute) = 0;

    /* *
     * @brief 查询当前轨道是否可见.
     * @return bool true: 当前轨道可见, false：当前轨道不可见.
     */
    virtual bool IsVisible() const = 0;

    /* *
     * @brief 设置当前轨道是否可见.
     * @param  visible 轨道是否可见，bool true: 轨道可见, false：当前轨道不可见.
     */
    virtual void SetVisible(bool visible) = 0;

    virtual int32_t ReplaceSource(const HmcDict *dict, const std::string &path) = 0;
};

#endif
