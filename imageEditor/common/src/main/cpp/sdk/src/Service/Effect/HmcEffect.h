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
#ifndef HMCEFFECT_H
#define HMCEFFECT_H

#include "../Editor/HmcEventHandler.h"
#include "HmcBase.h"
#include "HmcEngine.h"
#include "MediaCreative.h"
#include "HmcServiceDefaultValue.h"

class HmcEffect {
public:
    HmcEffect(const HmcUid &assetUid, HmcEventHandler *eventHandler);
    virtual ~HmcEffect();

public:
    HmcUid GetUid() const;

    HmcEffectType GetType() const;

    STRING GetMaterialCloudId() const;

    const STRING &GetName() const;
    void SetName(const STRING &name);

    BOOL IsEnable() const;
    virtual void SetEnable(BOOL enable);

    const HmcUid &GetAssetUid() const;
    virtual void SetAssetUid(const HmcUid &mAssetUid);

    INT64 GetStartTime() const;
    virtual VOID SetStartTime(INT64 startTime);

    INT64 GetDuration() const;
    virtual INT32 SetDuration(INT64 duration);

    virtual Json::Value Serialize();
    virtual BOOL Deserialize(const Json::Value &jsonData);

    virtual VOID SetEffectParameter(HmcDict *dict);
    virtual VOID GetEffectParameter(HmcDict *dict);

    virtual BOOL Init();
    virtual BOOL Init(HmcDict *dict);
    BOOL AssignMaterialCloudId(HmcDict *dict);

    virtual VOID UpdateRenderInfo();
    virtual VOID SetRenderLayer(std::shared_ptr<HmcRenderLayer> &layer, INT32 index = -1);

    virtual HmcEffect *Duplicate() = 0;

    virtual VOID OnAssetDurationChange(INT64 duration);

    HmcRenderEffectPtr GetRenderEffectPtr()
    {
        return m_renderEffect;
    }

protected:
    HmcEffect(const HmcEffect &effect);
    HmcEffect &operator = (const HmcEffect &effect);

protected:
    HmcUid m_uid;                            // 效果UID
    HmcUid m_assetUid;                       // 所属asset的UID
    STRING m_serialCloudId;                  // 效果的滤镜序列号ID
    STRING m_materialCloudId;                // 效果的原始素材的UID
    STRING m_name;                           // 效果的名字
    HmcEffectType m_type{ HMC_EFFECT_NONE }; // 效果类型
    BOOL m_enable{ TRUE };                   // 当前是否为启用状态
    INT64 m_startTime{ 0 };                  // 起始时间，值为相对于asset的起始时间的偏移值
    INT64 m_duration{
        HmcDefault::EFFECT_DURATION_EQUAL_ASSET
    }; // 持续时长，默认HMC_EFFECT_DURATION_EQUAL_ASSET，表示时长和其所在的asset保持一致
    HmcEventHandler *m_eventHandler;   // 回调函数指针
    HmcRenderEffectPtr m_renderEffect; // 效果渲染器
};

#endif // HMCEFFECT_H
