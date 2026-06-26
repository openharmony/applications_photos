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

#ifndef HMC_MATERIAL_RENDER_RES_UTIL_H
#define HMC_MATERIAL_RENDER_RES_UTIL_H

#include <json/json.h>
#include "HmcBase.h"
#include "MediaCreative.h"
#include "render/core/HmcMaterialRenderResource.h"

class HmcMaterialRenderResUtil {
public:
    using PreRenderType = enum {
        PRE_RENDER_TYPE_CHROMA,
        PRE_RENDER_TYPE_CHROMA_HSV,
        PRE_RENDER_TYPE_TRANSFORM,
        PRE_RENDER_TYPE_MASK,
        PRE_RENDER_TYPE_MIRROR,
        PRE_RENDER_TYPE_COLOR_MASK,
        PRE_RENDER_TYPE_FEATHERING,
        PRE_RENDER_TYPE_GAUSSIAN_BLUR,
        PRE_RENDER_TYPE_RENDER_COLOR_ADJUST,
        PRE_RENDER_TYPE_RENDER_CROP,
        PRE_RENDER_TYPE_FACE_SPLIT,
        PRE_RENDER_TYPE_TEXT_TEMPLATE_TAIL_A, // 中国，英国
        PRE_RENDER_TYPE_TEXT_TEMPLATE_TAIL_B, // 德国，法国
        PRE_RENDER_TYPE_CNT,
        PRE_RENDER_TYPE_CROP_TRANSFORM,
        PRE_RENDER_TYPE_CROP_BLUR
    }; // 预置素材类型

public:
    /* *
     * 解析素材包提供给渲染
     * @param resourcePath, 素材包解压后的目录路径
     * @param renderRes, 资源对象
     * @param isEncrypted 是否已加密
     */
    static INT32 GetRenderResource(const STRING &resourcePath, HmcMaterialRenderResource *renderRes,
        bool isEncrypted = true);

    static INT32 GetPrepareRenderRes(HmcMaterialRenderResource *res, PreRenderType preRenderType);

    static STRING GetResourceRootPath();

    static VOID UtilInit();

private:
    HmcMaterialRenderResUtil() = default;
    ~HmcMaterialRenderResUtil() = default;

    static INT32 GetImageConfigs(const Json::Value &jsonValue, const STRING &basePath,
        LIST<HmcMaterialImageResource> &imageRes);
    static INT32 GetShaderContent(const STRING &shaderPath, STRING &shader);
    static INT32 GetShaderPassConfigs(const STRING &basePath, const Json::Value &jsonRoot,
        HmcMaterialRenderResource *renderRes, bool isEncrypted);
    static INT32 GenMaterialFromString(const STRING &contentStr, Material &material);
    static INT32 GenMaterial(const STRING &materialPath, Material &material);
    static INT32 GenMesh(const STRING &meshPath, Mesh &mesh, bool isLoadFromFile = true);
    static VOID GetDefaultEntities(const Json::Value &jsonRoot, HmcMaterialRenderResource *renderRes);
    static INT32 GetScript(const STRING &basePath, const Json::Value &jsonRoot, HmcMaterialRenderResource *renderRes,
        bool isEncrypted);

    // 文字模板，解析rendererEffectPath 得到渲染资源
    static INT32 GetRenderResWithEffectJson(const Json::Value &renderConfigJson, const STRING &basePath,
        HmcMaterialRenderResource *renderRes);

private:
    static INT32 GetShaderFromPath(STRING &shaderString, const STRING &shaderPath, BOOL isEncrypted);
    static INT32 GenMaterialFromJson(const Json::Value &jsonRoot, Material &material);
    static void SetMaterialByInt(const std::string& name, const Json::Value& jsonValue, Material& material);
    static void SetMaterialByFloat(const std::string& name, const Json::Value& jsonValue, Material& material);
    static void SetMaterialByVec2(const std::string& name, const Json::Value& jsonValue, Material& material);
    static void SetMaterialByVec3(const std::string& name, const Json::Value& jsonValue, Material& material);
    static void SetMaterialByVec4(const std::string& name, const Json::Value& jsonValue, Material& material);
    static void SetMaterialByTexture(const std::string& name, const Json::Value& jsonValue, Material& material);

    static MAP<PreRenderType, STRING> m_renderTypePathMap;

    static STRING m_appPath;
    static STRING m_resPath;
};

#endif // !HMC_MATERIAL_RENDER_RES_UTIL_H
