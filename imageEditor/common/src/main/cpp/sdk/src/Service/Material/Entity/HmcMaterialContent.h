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

#ifndef HMC_MATERIAL_CONTENT_H
#define HMC_MATERIAL_CONTENT_H

#include "HmcBase.h"
#include "MediaCreative.h"
#include "../Utils/HmcMaterialJsonUtil.h"
#include "./HmcMaterialEntity.h"

#ifdef __cplusplus

class HmcParam : public HmcMaterialEntity {
public:
    STRING key;

    STRING value;
    inline Json::Value SerializeToJson() override
    {
        Json::Value paramJson(Json::objectValue);
        paramJson["key"] = key;
        paramJson["value"] = value;
        return paramJson;
    }

    inline VOID DeserializeFromJson(const Json::Value &paramJson) override
    {
        JsonValueUtil::ParseValueIfHas(paramJson, "key", key);
        JsonValueUtil::ParseValueIfHas(paramJson, "value", value);
    }
};

class HmcPic : public HmcMaterialEntity {
public:
    HmcMaterialState state; // 素材海报的状态
    int format;             // 图片格式，1->JPG，2->GIF
    STRING type;            // 海报类型
    STRING aspectRatio;     // 图片长宽比，如300*300，100*100
    STRING url;             // 图片URL地址
    STRING path;
    STRING selectedUrl; // 选中的图标海报，可选
    STRING selectedPath;

    HmcPic() : state(MATERIAL_STATE_UNAVAILABLE), format(0) {}
    ~HmcPic() override = default;

    Json::Value SerializeToJson() override;
    VOID DeserializeFromJson(const Json::Value &picJson) override;
};

class HmcMaterialContent;
class HmcMaterialContent : public HmcMaterialEntity {
public:
    HmcUid uid;                              // SDK全局唯一标识
    HmcUid columnUid;                        // 素材所在栏目的栏目UID
    HmcMaterialLibraryType type;             // 素材类型，如视频、音频、图片等等
    HmcMaterialLibraryColumnType columnType; // 素材所在栏目的类型
    HmcMaterialState
        state; // 素材的状态，包括未创建（未下载）、创建中（下载中）、可用（已下载）、不可用（下载失败）、待更新
    INT32 subType;      // 素材子类型
    INT32 duration;     // 时长，单位为ms，云侧返回的是秒，需要转换
    INT32 downloadCnt;  // 素材下载统计次数
    INT32 segments;     // 模板素材需要替换的素材个数
    UINT64 cacheTime;   // 数据缓存时间, 毫秒
    STRING code;        // code
    STRING contentId;   // 素材ID，网络素材库为云侧返回的ID，本地或者项目素材的则取UID
    STRING contentName; // 素材名称
    STRING previewUrl; // 素材预览图URL，网络素材库的为云侧返回的URL，本地或者项目素材的则为素材的本地路径
    STRING previewFilePath; // 素材预览图的本地路径
    STRING description;     // 描述
    STRING checksum; // SHA256，网络素材库为云侧返回的SHA256，本地或项目素材的则素材模块自己计算SHA256
    STRING updateTime; // 更新时间，网络素材库为云侧返回的时间，本地或项目素材则为创建或更新时间
    STRING minSDKVer; // 素材版本号，网络素材库为云侧返回的版本号，本地或项目素材则固定为1.0.0
    STRING categoryId; // 类别ID，网络素材库为云侧返回的类别ID，本地或项目素材则为所属栏目的ID
    STRING categoryName; // 类别名称，网络素材库为云侧返回的类别名称，本地或项目素材则为所属栏目的名称
    STRING downloadUrl; // 素材下载URL，网络素材库为云侧返回的内容，本地或项目则为本地路径
    STRING downloadFilePath; // 素材下载后的文件路径
    VECTOR<HmcPic> picList;  // 海报，网络素材库为云侧返回的内容，本地则为空
    VECTOR<HmcParam> params; // 素材扩展参数，网络素材库为云侧返回的内容，本地则为空
    STRING version;          // 缓存版本

    STRING musicContentType; // 音乐素材的type，下载需要
    STRING artistName;       // 音乐素材作者
    BOOL isEncrypted;        // 音乐素材需要加密
    FLOAT intensity;         // 光场素材的强度，asset需要
    FLOAT bgIntensity;       // 光场素材的 背景强度，asset需要
    FLOAT positionX;         // 人脸素材
    FLOAT positionY;         // 人脸素材
    UINT64 createdTime;      // 素材的创建时间

    // 反序列化
    /* *
     * 从json中反序列化时
     * CREATING或者Updating时更改成unavailble或needUpdate
     */

    HmcMaterialContent();
    HmcMaterialContent(const HmcMaterialContent &other);
    HmcMaterialContent &operator = (const HmcMaterialContent &other);
    ~HmcMaterialContent() override = default;

    static INT32 GetContentById(STRING contentId, HmcMaterialContent &content);

    static INT32 GetContentFromCacheByCode(const STRING &code, HmcMaterialContent *content);

    static INT32 LoadContent(const STRING &contentId);

    static void DeleteInvalidContent(const STRING &contentId);

    inline bool operator == (const HmcMaterialContent &rh) const
    {
        // 当前不会出现相同UID的content出现在不同的栏目下，不需要比较栏目UID
        return ((contentId == rh.contentId) && (code == rh.code));
    }

    Json::Value SerializeToJson() override;
    VOID DeserializeFromJson(const Json::Value &contentJson) override;

    VOID CopyWithoutUid(const HmcMaterialContent &rh);

    VOID DeleteContent() const;
    bool IsExpired() const override;

private:
    Json::Value GetSerializedPicJson();
    Json::Value GetParamsJson();
    VOID DeserializeNormal(const Json::Value &contentJson);
    void CopyFromOther(const HmcMaterialContent &other);
    static INT32 LoadContentFromConfigFile(const STRING &contentId, HmcMaterialContent *content);
    VOID SaveContentToConfigFile();
    VOID Clear();
    VOID DeleteDiskFile() const;
};

#endif // __cplusplus

#endif // !HMC_MATERIAL_CONTENT_H