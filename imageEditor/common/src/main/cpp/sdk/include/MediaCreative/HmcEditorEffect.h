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

#ifndef HMCEDITOREFFECT_H
#define HMCEDITOREFFECT_H

#include "HmcBaseType.h"
#include "MediaCreative/HmcEditor.h"
#include "MediaCreative/HmcEditorAsset.h"
#ifdef __cplusplus
extern "C" {
#endif

typedef enum HmcEffectType {
    HMC_EFFECT_NONE,
    HMC_EFFECT_ADJUST,    // 颜色调节.
    HMC_EFFECT_TRANSFORM, // Transform
    HMC_EFFECT_MIRROR,    // MIRROR
    HMC_EFFECT_CROP_BLUR,  // 裁剪区域外模糊
    HMC_EFFECT_COMPOSE,  // 涂鸦笔迹
} HmcEffectType;

typedef enum HmcEffectTextType {
    HMC_EFFECT_TEXT_TYPE_NONE,
    HMC_EFFECT_TEXT_TYPE_FONT,     // 文字字体
    HMC_EFFECT_TEXT_TYPE_ART,      // 文字花字
    HMC_EFFECT_TEXT_TYPE_BUBBLE,   // 文字气泡
    HMC_EFFECT_TEXT_TYPE_ANIMATION // 文字动画
} HmcEffectTextType;

/**
 * 给asset剪辑添加效果。
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param assetUid      剪辑Id
 * @param dict          要添加的效果的选项
 * @param poutEffectUid 新效果的UID
 * @return              HMC_OK表示成功，其他表示失败
 */
HMC_API int HmcEffectAdd(HmcEditor *editor, HmcUid assetUid, HmcDict *dict, HmcUid *poutEffectUid);

/**
 * 获取asset的转场效果时长
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param effectUid     转场效果的UID
 * @return              转场效果的duration
 */
HMC_API int64_t HmcEffectGetDuration(HmcEditor *editor, HmcUid effectUid);

/**
 * 获取asset的effect开始时间
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param effectUid     转场效果的UID
 * @return              转场效果的startTime
 */
HMC_API int64_t HmcEffectGetStartTime(HmcEditor *editor, HmcUid effectUid);

/**
 * 获取剪辑的效果数量
 * @param editor        编辑器句柄
 * @param assetUid      剪辑的UID
 * @param type          特效类型，NONE返回所有特效
 * @return              返回效果数量
 */
HMC_API unsigned int HmcEffectGetEffectCount(HmcEditor *editor, HmcUid assetUid, HmcEffectType type);

/**
 * 获取剪辑的效果数组，调用该API时，需要先调用HmcEffectGetEffectCount获取效果数量count，然后申请count大小的HmcUid类型的效果数组，作为effectBuffer
 * @param editor        编辑器句柄
 * @param assetUid      剪辑的UID
 * @param type          特效类型，NONE返回所有特效
 * @param effectBuffer  用于接收效果UID的数组
 * @param count         用于表示effectBuffer的大小
 * @return              HMC_OK表示成功，其他表示失败
 */
HMC_API int HmcEffectGetEffects(HmcEditor *editor, HmcUid assetUid, HmcEffectType type, HmcUid *effectBuffer,
    unsigned int count);

/**
 * 获取效果的原始素材UID
 * @param editor              编辑器句柄
 * @param effectUid           效果的UID
 * @return                    效果的原始素材ID,NULL表示失败;非NULL表示成功，返回的数值需要HmcFree释放
 */
HMC_API char *HmcEffectGetMaterialCloudId(HmcEditor *editor, HmcUid effectUid);

/**
 * 移动效果的叠放位置（在asset内的上下叠放次序），向前或者向后移动distance
 * @param editor        编辑器句柄
 * @param effectUid     剪辑的UID
 * @param distance      向前或者向后移动的距离，向前移动为负数，向后移动为正数
 * @return              HMC_OK表示成功，其他表示失败
 */
HMC_API int HmcEffectAdvance(HmcEditor *editor, HmcUid effectUid, int distance);

/**
 * 设置滤镜、特效等效果的参数
 * @param editor        编辑器句柄
 * @param effectUid     剪辑的UID
 * @param dict
 * 要设置的属性的字典，所有效果通用的key在HmcDictKey.h中的table-effect-property中，颜色调节在table-effect-adjust-property
 * @return              HMC_OK表示成功，其他表示失败
 */
HMC_API int HmcEffectSetProperty(HmcEditor *editor, HmcUid effectUid, HmcDict *dict);

/**
 * 获取滤镜、特效等效果的参数
 * @param editor        编辑器句柄
 * @param effectUid     剪辑的UID
 * @param dict
 * 用于接收要获取的属性的字典，所有效果通用的key在HmcDictKey.h中的table-effect-property中，颜色调节在table-effect-adjust-property
 * @return              HMC_OK表示成功，其他表示失败
 */
HMC_API int HmcEffectGetProperty(HmcEditor *editor, HmcUid effectUid, HmcDict *dict);

/**
 * 剪辑移除指定Id的效果,不销毁效果
 * @param editor        编辑器句柄
 * @param assetUid      剪辑的UID
 * @param effectUid     效果的UID
 * @return              HMC_OK 成功， 其他值代表失败
 */
HMC_API int HmcEffectRemove(HmcEditor *editor, HmcUid assetUid, HmcUid effectUid);

/**
 * 销毁剪辑上的指定效果,销毁效果，无法恢复
 * @param editor        编辑器句柄
 * @param assetUid      剪辑的UID
 * @param effectUid     效果的UID
 * @return              HMC_OK 成功， 其他值代表失败
 */
HMC_API int HmcEffectDestroy(HmcEditor *editor, HmcUid assetUid, HmcUid effectUid);

/**
 * 在剪辑的效果列表中的指定位置插入效果
 * @param editor        编辑器句柄
 * @param assetUid      剪辑的UID
 * @param effectUid     效果的UID
 * @param index         插入效果的位置
 * @return              HMC_OK 成功， 其他值代表失败
 */
HMC_API int HmcEffectInsert(HmcEditor *editor, HmcUid assetUid, HmcUid effectUid, unsigned int index);

/**
 * 获取剪辑上的指定效果在剪辑效果中的index
 * @param editor        编辑器句柄
 * @param assetUid      剪辑的UID
 * @param effectUid     效果的UID
 * @param index         出参：效果的index
 * @return              HMC_OK 成功， 其他值代表失败
 */
HMC_API int HmcEffectGetIndex(HmcEditor *editor, HmcUid assetUid, HmcUid effectUid, unsigned int *index);

/**
 * 剪辑移除所有效果
 * @param editor        编辑器句柄
 * @param assetUid      剪辑的UID
 * @return              HMC_OK 成功， 其他值代表失败
 */
HMC_API int HmcEffectRemoveAll(HmcEditor *editor, HmcUid assetUid);

/**
 * 重命名效果
 * @param editor        编辑器句柄
 * @param assetUid      效果的UID
 * @param name          效果要重命名的目标名字
 * @return              HMC_OK 成功， 其他值代表失败
 */
HMC_API int HmcEffectRename(HmcEditor *editor, HmcUid effectUid, const char *name);

/**
 * 设置效果为启用还是不启用
 * @param editor        编辑器句柄
 * @param assetUid      效果的UID
 * @param enable        效果的目标状态
 * @return              HMC_OK 成功， 其他值代表失败
 */
HMC_API int HmcEffectSetEnable(HmcEditor *editor, HmcUid effectUid, bool enable);

/**
 * 查询效果是否为启用（生效）状态
 * @param editor        编辑器句柄
 * @param assetUid      效果的UID
 * @return              TRUE表示启用，FALSE表示不启用
 */
HMC_API int HmcEffectIsEnable(HmcEditor *editor, HmcUid effectUid);

/**
 * 移动asset上的effect位置
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param assetUid      剪辑Id
 * @param laneUid       轨道Id
 * @param effectUid     效果的Id
 * @param timeStamp     效果的startTime
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcEffectMove(HmcEditor *editor, HmcUid assetUid, HmcUid laneUid, HmcUid effectUid, int64_t timeStamp);

/**
 * 更新 asset 高度 与宽度信息，按照下采样的规格更新
 * @param editor        编辑器句柄，通过HmcEditorOpen生成
 * @param assetUid      剪辑Id
 * @param width         宽度信息
 * @param height        高度信息
 * @return              HMC_OK 成功， 其他值 失败
 */
HMC_API int HmcUpdateDownSimplerDisplayInfo(HmcEditor *editor, HmcUid assetUid, INT32 width, INT32 height);

#ifdef __cplusplus
}
#endif

#endif // HMCEDITOREFFECT_H
