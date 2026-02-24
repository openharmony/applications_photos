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

#ifndef HMC_MATERIAL_RESOURCE_H
#define HMC_MATERIAL_RESOURCE_H

#include "render/base/RenderBase.h"
#include "HmcRenderValue.h"
#include "Material.h"
#include "Mesh.h"

enum class HmcAnimationType {
    NONE,
    ENTER,
    LEAVE,
    LOOP
};

struct HmcMaterialShaderPassResource {
    STRING m_name;
    STRING m_vertexShader;
    STRING m_fragmentShader;
    Material m_material;
    Mesh m_mesh;
    INT32 m_holdBetweenFrame;
    INT32 m_delayInit;
};

struct HmcMaterialImageResource {
    STRING m_name;
    STRING m_type;
    STRING m_path;

    HmcMaterialImageResource(STRING path, STRING name, STRING type) : m_name(name), m_type(type), m_path(path) {}
    HmcMaterialImageResource() = default;
};

struct HmcMaterialTextureLocation {
    FLOAT left;
    FLOAT bottom;
    FLOAT right;
    FLOAT top;
};

struct HmcMaterialRenderResource {
    STRING m_tarballFormat;
    INT32 m_version = -1;
    STRING m_effectName;
    STRING m_effectType;
    LIST<HmcMaterialShaderPassResource> m_shaderPassResource;
    LIST<HmcMaterialImageResource> m_imageResource;
    MAP<STRING, HmcRenderValue> m_defaultEntities;
    STRING m_script;
    HmcAnimationType m_type;
};

struct HmcOffsetResource {
    INT32 m_x;
    INT32 m_y;
};
#endif // !HMC_MATERIAL_RESOURCE_H
