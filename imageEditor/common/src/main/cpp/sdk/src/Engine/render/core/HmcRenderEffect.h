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

#ifndef HMCRENDEREFFECT_H
#define HMCRENDEREFFECT_H

#include "render/base/RenderBase.h"
#include "Material.h"
#include "Mesh.h"
#include "HmcMaterialRenderResource.h"


const STRING MAIN_TEX = "__main";
const STRING BACKGROUND_TEX = "__background";
const STRING INPUT_TEX = "InputTexture";

struct TexInInfo {
    explicit TexInInfo(STRING k = MAIN_TEX, STRING lk = INPUT_TEX)
    {
        key = k;
        luaKey = lk;
    }
    STRING key;
    STRING luaKey;
};

class HmcRenderEffect // : public Drawable {
{
public:
    HmcRenderEffect();
    explicit HmcRenderEffect(const HmcRenderEffect *other);
    ~HmcRenderEffect() = default;

    void AddTexture(const STRING &key, const STRING &luaKey = INPUT_TEX);
    void SetParam(const STRING &key, INT32 value);
    void SetParam(const STRING &key, DOUBLE value);
    void SetParam(const STRING &key, VOID* value);
    void SetParam(const STRING &key, const STRING &value);
    BOOL GetParam(const STRING &key, INT32 &value);
    BOOL GetParam(const STRING &key, DOUBLE &value);
    BOOL GetParam(const STRING &key, STRING &value);

    void SetOutTex(const STRING &tex);

    int GetDepth() const;

    enum ResControlTag {
        UPDATE = 0, // 触发内部特效重新创建，需要m_resource；如未创建，触发创建；当前帧渲染前执行
        REUSE = 1, // 如未创建内部特效，触发创建，如已创建,使用已创建的对象，创建时需要m_resource
        PRERELEASE = 2,  // 触发释放，在当前帧开始之前，当前帧不再渲染
        POSTRELEASE = 3, // 触发释放，在当前帧渲染结束之后
    };

    STRING m_name; // key值，作为当前对象的唯一名称和对象缓存的key
    INT64 m_startTime = 0; // 特效的起始时间，为绝对时间，sdk需保证当前特效在其有效时间内，否则不渲染
    INT64 m_endTime = 0; // 特效的结束时间，为绝对时间，sdk需保证当前特效在其有效时间内，否则不渲染
    INT64 m_timeStamp = 0;

    MAP<STRING, HmcRenderValue> m_effectParam; // 特效的可调选项，对应UI上的可调项，如滤镜强度

    ResControlTag m_resControlTag = REUSE; // 当前行为选项

    LIST<TexInInfo> m_inTex;
    STRING m_outTex;

    SHARED_PTR<HmcMaterialRenderResource> m_resource;
    
    VOID CopyHmcEffect(std::shared_ptr<HmcRenderEffect> &srcHmcEffect);
};

using HmcRenderEffectPtr = SHARED_PTR<HmcRenderEffect>;

#endif // HMCRENDEREFFECT_H
