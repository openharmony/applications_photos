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

#include <HmcBase.h>
#include "Material/HmcMaterialConstant.h"
#include "HmcMaterialJsonUtil.h"
#include "HmcMaterialRenderResUtil.h"
#include "../HmcMaterialManager.h"
#include "../HmcMaterialUtil.h"

constexpr const char *RENDER_PARSE_JSON_KEY_DEFAULT_ENTITIES = "defaultEntities";

MAP<HmcMaterialRenderResUtil::PreRenderType, STRING> HmcMaterialRenderResUtil::m_renderTypePathMap;
STRING HmcMaterialRenderResUtil::m_resPath;
STRING HmcMaterialRenderResUtil::m_appPath;

VOID HmcMaterialRenderResUtil::UtilInit()
{
    m_renderTypePathMap[PRE_RENDER_TYPE_CHROMA] = GetResourceRootPath() + FILE_SEPARATOR_STR + "Chroma";
    m_renderTypePathMap[PRE_RENDER_TYPE_CHROMA_HSV] = GetResourceRootPath() + FILE_SEPARATOR_STR + "ChromaHsv";
    m_renderTypePathMap[PRE_RENDER_TYPE_TRANSFORM] = GetResourceRootPath() + FILE_SEPARATOR_STR + "Transform";
    m_renderTypePathMap[PRE_RENDER_TYPE_MASK] = GetResourceRootPath() + FILE_SEPARATOR_STR + "Mask";
    m_renderTypePathMap[PRE_RENDER_TYPE_MIRROR] = GetResourceRootPath() + FILE_SEPARATOR_STR + "Mirror";
    m_renderTypePathMap[PRE_RENDER_TYPE_RENDER_COLOR_ADJUST] =
        GetResourceRootPath() + FILE_SEPARATOR_STR + "Render" + FILE_SEPARATOR_STR + "ColorAdjust";
    m_renderTypePathMap[PRE_RENDER_TYPE_RENDER_CROP] =
        GetResourceRootPath() + FILE_SEPARATOR_STR + "Render" + FILE_SEPARATOR_STR + "Crop";
    m_renderTypePathMap[PRE_RENDER_TYPE_FACE_SPLIT] = GetResourceRootPath() + FILE_SEPARATOR_STR + "ImageMask";

    m_renderTypePathMap[PRE_RENDER_TYPE_TEXT_TEMPLATE_TAIL_A] =
        GetResourceRootPath() + FILE_SEPARATOR_STR + "TextTemplateTailA";
    m_renderTypePathMap[PRE_RENDER_TYPE_TEXT_TEMPLATE_TAIL_B] =
        GetResourceRootPath() + FILE_SEPARATOR_STR + "TextTemplateTailB";

    m_renderTypePathMap[PRE_RENDER_TYPE_CROP_TRANSFORM] = GetResourceRootPath() + FILE_SEPARATOR_STR + "CropTransform";
    m_renderTypePathMap[PRE_RENDER_TYPE_CROP_BLUR] =
        GetResourceRootPath() + FILE_SEPARATOR_STR "Render" + FILE_SEPARATOR_STR + "CropBlur";
}

INT32 HmcMaterialRenderResUtil::GenMaterialFromString(const STRING &contentStr, Material &material)
{
    Json::Value jsonRoot;
    if (HmcMaterialJsonUtil::LoadJsonFromString(contentStr, jsonRoot) != HMC_OK) {
        LOGE("load material file failed.");
        return HMC_ERR;
    }
    return GenMaterialFromJson(jsonRoot, material);
}

INT32 HmcMaterialRenderResUtil::GenMaterial(const STRING &materialPath, Material &material)
{
    Json::Value jsonRoot;
    if (HmcMaterialJsonUtil::LoadJsonFromFile(materialPath, jsonRoot) != HMC_OK) {
        LOGE("load material file failed.");
        return HMC_ERR;
    }
    return GenMaterialFromJson(jsonRoot, material);
}

INT32 HmcMaterialRenderResUtil::GenMaterialFromJson(const Json::Value &jsonRoot, Material& material)
{
    auto names = jsonRoot.getMemberNames();
    for (auto begin = names.begin(); begin != names.end(); ++begin) {
        STRING name = *begin;
        const Json::Value& ele = jsonRoot[name];
        std::string type;
        if (!JsonValueUtil::ParseValueIfHas(ele, "type", type)) {
            continue;
        }
        if (!JsonValueUtil::IsMemberAndNotNull(ele, "defaultValue")) {
            continue;
        }
        const Json::Value& value = ele["defaultValue"];

        if (type == STRING("int")) {
            SetMaterialByInt(name, value, material);
        } else if (type == STRING("float")) {
            SetMaterialByFloat(name, value, material);
        } else if (type == STRING("vec2")) {
            SetMaterialByVec2(name, value, material);
        } else if (type == STRING("vec3")) {
            SetMaterialByVec3(name, value, material);
        } else if (type == STRING("vec4")) {
            SetMaterialByVec4(name, value, material);
        } else if (type == STRING("texture")) {
            SetMaterialByTexture(name, value, material);
        } else if (type == STRING("mat2")) {
        } else if (type == STRING("mat3")) {
        } else if (type == STRING("mat4")) {
        }
    }
    return HMC_OK;
}

void HmcMaterialRenderResUtil::SetMaterialByInt(const std::string& name, const Json::Value& jsonValue,
                                                Material& material)
{
    if (jsonValue.isInt()) {
        material.Set(name, jsonValue.asInt());
        return;
    }
    LOGE("Set material by int failed.");
}

void HmcMaterialRenderResUtil::SetMaterialByFloat(const std::string& name, const Json::Value& jsonValue,
                                                  Material& material)
{
    if (jsonValue.isDouble()) {
        material.Set(name, jsonValue.asFloat());
        return;
    }
    LOGE("Set material by float failed.");
}

void HmcMaterialRenderResUtil::SetMaterialByVec2(const std::string& name, const Json::Value& jsonValue,
                                                 Material& material)
{
    float vx;
    float vy;
    if (!JsonValueUtil::ParseFloatIfHas(jsonValue, "x", vx) || !JsonValueUtil::ParseFloatIfHas(jsonValue, "y", vy)) {
        LOGE("Set material by Vec2 failed.");
        return;
    }
    Vec2 tempV2(vx, vy);
    material.Set(name, tempV2);
}

void HmcMaterialRenderResUtil::SetMaterialByVec3(const std::string& name, const Json::Value& jsonValue,
                                                 Material& material)
{
    float vx;
    float vy;
    float vz;
    if (!JsonValueUtil::ParseFloatIfHas(jsonValue, "x", vx) || !JsonValueUtil::ParseFloatIfHas(jsonValue, "y", vy) ||
        !JsonValueUtil::ParseFloatIfHas(jsonValue, "z", vz)) {
        LOGE("Set material by Vec3 failed.");
        return;
    }
    Vec3 tempV3(vx, vy, vz);
    material.Set(name, tempV3);
}

void HmcMaterialRenderResUtil::SetMaterialByVec4(const std::string& name, const Json::Value& jsonValue,
                                                 Material& material)
{
    float vx;
    float vy;
    float vz;
    float vw;
    if (!JsonValueUtil::ParseFloatIfHas(jsonValue, "x", vx) || !JsonValueUtil::ParseFloatIfHas(jsonValue, "y", vy) ||
        !JsonValueUtil::ParseFloatIfHas(jsonValue, "z", vz) || !JsonValueUtil::ParseFloatIfHas(jsonValue, "w", vw)) {
        LOGE("Set material by Vec4 failed.");
        return;
    }
    Vec4 tempV4(vx, vy, vz, vw);
    material.Set(name, tempV4);
}

void HmcMaterialRenderResUtil::SetMaterialByTexture(const std::string& name, const Json::Value& jsonValue,
                                                    Material& material)
{
    if (jsonValue.isInt()) {
        material.SetTexture(name, jsonValue.asInt());
        return;
    }
    LOGE("Set material by Texture failed.");
}

static MAP<STRING, Mesh::Primitive::Value> STR_TO_PRIMITIVE_TYPE_TBL = {
    { STRING("triangle"), Mesh::Primitive::Value::TRIANGLES },
    { STRING("triangle_strip"), Mesh::Primitive::Value::TRIANGLE_STRIP },
    { STRING("triangle_fan"), Mesh::Primitive::Value::TRIANGLE_FAN }
};

static MAP<STRING, Mesh::AttribType::Value> STR_TO_ATTRIB_TYPE_TBL = {
    { STRING("float"), Mesh::AttribType::Value::FLOAT_VALUE },
    { STRING("vec2"), Mesh::AttribType::Value::VEC2_VALUE },
    { STRING("vec3"), Mesh::AttribType::Value::VEC3_VALUE },
    { STRING("vec4"), Mesh::AttribType::Value::VEC4_VALUE },
};

INT32 HmcMaterialRenderResUtil::GenMesh(const STRING &meshPath, Mesh &mesh, bool isLoadFromFile)
{
    Json::Value jsonRoot;
    if (isLoadFromFile) {
        if (HmcMaterialJsonUtil::LoadJsonFromFile(meshPath, jsonRoot) != HMC_OK) {
            LOGE("load material file failed.");
            return HMC_ERR;
        }
    } else {
        if (HmcMaterialJsonUtil::LoadJsonFromString(meshPath, jsonRoot) != HMC_OK) {
            LOGE("load material file failed.");
            return HMC_ERR;
        }
    }

    int vertexCount;
    if (!JsonValueUtil::ParseValueIfHas(jsonRoot, "vertexCount", vertexCount)) {
        LOGE("load material vertexCount failed.");
        return HMC_ERR;
    }
    mesh.SetVertexCount(vertexCount);

    std::string primitiveString;
    if (!JsonValueUtil::ParseValueIfHas(jsonRoot, "primitive", primitiveString)) {
        LOGE("load material primitive failed.");
        return HMC_ERR;
    }
    Mesh::Primitive::Value primitiveType = STR_TO_PRIMITIVE_TYPE_TBL[primitiveString];
    mesh.SetPrimitive(primitiveType);

    const Json::Value &attribArrays = jsonRoot["attribArrays"];
    auto names = attribArrays.getMemberNames();
    for (auto begin = names.begin(); begin != names.end(); ++begin) {
        STRING name = *begin;
        const Json::Value &ele = attribArrays[name];

        std::string attribTypeName;
        if (!JsonValueUtil::ParseValueIfHas(ele, "type", attribTypeName) ||
            !JsonValueUtil::IsMemberAndNotNull(ele, "data")) {
            LOGE("load material type or data failed.");
            return HMC_ERR;
        }
        const Json::Value& dataArrays = ele["data"];
        VECTOR<FLOAT> arrayData;
        for (const auto& v : dataArrays) {
            if (v.isDouble()) {
                arrayData.push_back(v.asFloat());
            }
        }
        if (arrayData.size() > 0) {
            mesh.SetArray(name, STR_TO_ATTRIB_TYPE_TBL[attribTypeName], arrayData);
        }
    }
    return HMC_OK;
}

INT32 HmcMaterialRenderResUtil::GetShaderContent(const STRING &shaderPath, STRING &shader)
{
    if (shaderPath.empty()) {
        LOGE("path is empty.");
        return HMC_ERR;
    }

    STRING tmpPath(HmcGetPathWithSystemSeparator(shaderPath));
    if (HmcMaterialJsonUtil::HmcStringDeserializeMaterialPath(tmpPath, shader) != HMC_OK) {
        LOGE("load shader failed.");
        return HMC_ERR;
    }

    return HMC_OK;
}

INT32 HmcMaterialRenderResUtil::GetShaderFromPath(STRING &shaderString, const STRING &shaderPath, BOOL isEncrypted)
{
    int buffLen = 0;
    if (isEncrypted) {
        UINT8 *shaderBuffer = NULL;
        if (shaderBuffer == NULL) {
            LOGE("get data failed.");
            return HMC_ERR;
        }
        shaderString.assign((CHAR *)shaderBuffer, buffLen);
        free(shaderBuffer);
        shaderBuffer = NULL;
        return HMC_OK;
    }
    if (GetShaderContent(shaderPath, shaderString) != HMC_OK) {
        LOGE("get shader failed.");
        return HMC_ERR;
    }
    return HMC_OK;
}

INT32 HmcMaterialRenderResUtil::GetShaderPassConfigs(const STRING &basePath, const Json::Value &jsonRoot,
                                                     HmcMaterialRenderResource *renderRes, bool isEncrypted)
{
    renderRes->m_shaderPassResource.clear();
    const Json::Value& shaderPassConfigs = jsonRoot[MATERIAL_CONFIG_FIELD_SHADER_PASS];
    for (auto const& shaderPassConfig : shaderPassConfigs) {
        HmcMaterialShaderPassResource tmpShaderRes;
        if (!JsonValueUtil::ParseValueIfHas(shaderPassConfig, "name", tmpShaderRes.m_name)) {
            continue;
        }
        std::string vertexShaderPath;
        if (!JsonValueUtil::ParseValueIfHas(shaderPassConfig, MATERIAL_CONFIG_FIELD_SHADER_VERTEX, vertexShaderPath)) {
            continue;
        }
        std::string tmpPath = HmcGetPathWithSystemSeparator(basePath + vertexShaderPath);
        if (GetShaderFromPath(tmpShaderRes.m_vertexShader, tmpPath, isEncrypted) != HMC_OK) {
            LOGE("get vert shader failed.");
            return HMC_ERR;
        }
        std::string fragShaderPath;
        if (!JsonValueUtil::ParseValueIfHas(shaderPassConfig, MATERIAL_CONFIG_FIELD_SHADER_FRAGMENT, fragShaderPath)) {
            continue;
        }
        tmpPath = HmcGetPathWithSystemSeparator(basePath + fragShaderPath);
        if (GetShaderFromPath(tmpShaderRes.m_fragmentShader, tmpPath, isEncrypted) != HMC_OK) {
            LOGE("get frag shader failed.");
            return HMC_ERR;
        }

        LOGD("start to get material.");
        std::string materialPath;
        if (!JsonValueUtil::ParseValueIfHas(shaderPassConfig, "materialPath", materialPath)) {
            continue;
        }
        if (GenMaterial((basePath + materialPath), tmpShaderRes.m_material) != HMC_OK) {
            LOGE("get material failed.");
            return HMC_ERR;
        }
        LOGD("start to get mesh.");
        std::string meshPath;
        if (!JsonValueUtil::ParseValueIfHas(shaderPassConfig, "meshPath", meshPath)) {
            continue;
        }
        if (GenMesh((basePath + meshPath), tmpShaderRes.m_mesh) != HMC_OK) {
            LOGE("get mesh failed.");
            return HMC_ERR;
        }
        tmpShaderRes.m_holdBetweenFrame = HmcMaterialJsonUtil::GetInt32("holdBetweenFrame", shaderPassConfig, 0);
        tmpShaderRes.m_delayInit = HmcMaterialJsonUtil::GetInt32("delayInit", shaderPassConfig, 0);
        renderRes->m_shaderPassResource.emplace_back(std::move(tmpShaderRes));
    }
    return HMC_OK;
}

INT32 HmcMaterialRenderResUtil::GetImageConfigs(const Json::Value &jsonValue, const STRING &basePath,
    LIST<HmcMaterialImageResource> &imageRes)
{
    STRING name;
    STRING type;
    STRING tmpPath;
    LOGD("start to get imageConfigs.");
    imageRes.clear();
    const Json::Value &imageConfigs = jsonValue;
    for (auto const & imageConfig : imageConfigs) {
        if (!JsonValueUtil::ParseValueIfHas(imageConfig, "name", name)) {
            continue;
        }
        if (!JsonValueUtil::ParseValueIfHas(imageConfig, "type", type)) {
            continue;
        }
        std::string pathInner;
        if (!JsonValueUtil::ParseValueIfHas(imageConfig, "path", pathInner)) {
            continue;
        }
        tmpPath = HmcGetPathWithSystemSeparator(basePath + pathInner);
        // 沙箱路径lut
        tmpPath = HmcOhosGetHapFilesDir() + FILE_SEPARATOR_STR + tmpPath.substr(strlen("rawfile/"));
        imageRes.emplace_back(tmpPath, name, type);
    }

    return HMC_OK;
}

VOID HmcMaterialRenderResUtil::GetDefaultEntities(const Json::Value &jsonRoot, HmcMaterialRenderResource *renderRes)
{
    Json::Value defaultEntities;
    if (HmcMaterialJsonUtil::GetMemberIfHas(RENDER_PARSE_JSON_KEY_DEFAULT_ENTITIES, jsonRoot, defaultEntities) ==
        false) {
        LOGW("could not get member:%s", RENDER_PARSE_JSON_KEY_DEFAULT_ENTITIES);
        return;
    }
    LOGD("start to get defaultEntities.");
    STRING strValue;
    INT32 intValue;
    UINT32 uintValue;
    DOUBLE doubleValue;
    bool boolValue;
    renderRes->m_defaultEntities.clear();
    auto entityNames = defaultEntities.getMemberNames();
    for (auto const & entityName : entityNames) {
        switch (defaultEntities[entityName].type()) {
            case Json::stringValue:
                strValue = defaultEntities[entityName].asString();
                renderRes->m_defaultEntities.insert_or_assign(entityName, HmcRenderValue(strValue));
                break;
            case Json::intValue:
                intValue = defaultEntities[entityName].asInt();
                renderRes->m_defaultEntities.insert_or_assign(entityName, HmcRenderValue((INT32)intValue));
                break;
            case Json::uintValue:
                uintValue = defaultEntities[entityName].asUInt();
                renderRes->m_defaultEntities.insert_or_assign(entityName, HmcRenderValue((DOUBLE)uintValue));
                break;
            case Json::realValue:
                doubleValue = defaultEntities[entityName].asDouble();
                renderRes->m_defaultEntities.insert_or_assign(entityName, HmcRenderValue(doubleValue));
                break;
            case Json::booleanValue:
                boolValue = defaultEntities[entityName].asBool();
                renderRes->m_defaultEntities.insert_or_assign(entityName, HmcRenderValue(boolValue));
                break;
            default:
                LOGW("unknown type: %d", (INT32)defaultEntities[entityName].type());
                break;
        }
    }
}

INT32 HmcMaterialRenderResUtil::GetScript(const STRING &basePath, const Json::Value &jsonRoot,
    HmcMaterialRenderResource *renderRes, bool isEncrypted)
{
    LOGD("start to get script.");
    if (isEncrypted) {
        int buffLen = 0;
        UINT8 *script = NULL;
        if (script == NULL) {
            LOGE("get data failed.");
            return HMC_ERR;
        }
        renderRes->m_script.assign((CHAR *)script, buffLen);
        free(script);
        script = NULL;
    } else {
        std::string scriptPath;
        if (!JsonValueUtil::ParseValueIfHas(jsonRoot, MATERIAL_CONFIG_FIELD_SCRIPT, scriptPath)) {
            LOGE("get script failed.");
            return HMC_ERR;
        }
        std::string tmpPath = HmcGetPathWithSystemSeparator(basePath + scriptPath);
        if (HMC_OK != HmcMaterialJsonUtil::HmcStringDeserializeMaterialPath(tmpPath, renderRes->m_script)) {
            LOGE("get script failed.");
            return HMC_ERR;
        }
    }

    return HMC_OK;
}

INT32 HmcMaterialRenderResUtil::GetRenderResource(const STRING &resourcePath, HmcMaterialRenderResource *renderRes,
    bool isEncrypted)
{
    if (renderRes == NULL) {
        LOGE("renderRes is NULL.");
        return HMC_ERR;
    }

    STRING basePath = HmcGetPathWithSystemSeparator(resourcePath + FILE_SEPARATOR_STR);
    STRING configFilePath = basePath + MATERIAL_CONFIG_JSON_FILE_NAME;
    LOGD("start to parse config.json. configFilePath: %s", configFilePath.c_str());
    Json::Value jsonRoot;
    int ret = HmcMaterialJsonUtil::LoadJsonFromFile(configFilePath, jsonRoot);
    if (ret != HMC_OK) {
        LOGE("load config file failed.");
        return ret;
    }
    // 以下字段默认必定存在
    if (!JsonValueUtil::ParseValueIfHas(jsonRoot, "tarballFormat", renderRes->m_tarballFormat)) {
        LOGE("get render resource tarballFormat failed.");
        return HMC_ERR;
    }
    if (!JsonValueUtil::ParseValueIfHas(jsonRoot, "version", renderRes->m_version)) {
        LOGE("get render resource version failed.");
        return HMC_ERR;
    }
    if (!JsonValueUtil::ParseValueIfHas(jsonRoot, "effectName", renderRes->m_effectName)) {
        LOGE("get render resource effectName failed.");
        return HMC_ERR;
    }
    if (!JsonValueUtil::ParseValueIfHas(jsonRoot, "effectType", renderRes->m_effectType)) {
        LOGE("get render resource effectType failed.");
        return HMC_ERR;
    }

    if (jsonRoot.isMember(MATERIAL_CONFIG_FIELD_SHADER_PASS) && !jsonRoot[MATERIAL_CONFIG_FIELD_SHADER_PASS].isNull()) {
        ret = GetShaderPassConfigs(basePath, jsonRoot, renderRes, isEncrypted);
        if (ret != HMC_OK) {
            LOGE("get shader failed.");
            return ret;
        }
    }

    if (jsonRoot.isMember("imageConfigs") && !jsonRoot["imageConfigs"].isNull()) {
        GetImageConfigs(jsonRoot["imageConfigs"], basePath, renderRes->m_imageResource);
    }

    GetDefaultEntities(jsonRoot, renderRes);
    ret = GetScript(basePath, jsonRoot, renderRes, isEncrypted);

    return ret;
}

INT32 HmcMaterialRenderResUtil::GetPrepareRenderRes(HmcMaterialRenderResource *res, PreRenderType preRenderType)
{
    STRING path = m_renderTypePathMap[preRenderType];
    int ret = GetRenderResource(path, res, false);
    if (ret != HMC_OK) {
        LOGW("get render resource failed, ret:%d, type:%d", ret, preRenderType);
    }
    return ret;
}

INT32 HmcMaterialRenderResUtil::GetRenderResWithEffectJson(const Json::Value &renderConfigJson, const STRING &basePath,
    HmcMaterialRenderResource *renderRes)
{
    if (renderRes == NULL) {
        LOGE("param is null");
        return HMC_ERR;
    }
    // 解析 得到rendererEffectPath
    STRING rendererEffectPath = HmcMaterialJsonUtil::GetString("rendererEffectPath", renderConfigJson, "");
    LOGI("get rendererEffectPath is:%s", rendererEffectPath.c_str());
    if (rendererEffectPath.empty()) {
        LOGW("rendererEffectPath path empty");
        return HMC_ERR;
    }
    STRING resPath = basePath + rendererEffectPath;
    int ret = GetRenderResource(resPath, renderRes, false); // 文字模板中的 这个没有加密 todo
    if (ret != HMC_OK) {
        LOGE("get text effect render resource failed. ret:%d", ret);
        return HMC_ERR;
    }
    return HMC_OK;
}

STRING HmcMaterialRenderResUtil::GetResourceRootPath()
{
    return "rawfile/ImageResource";
}
