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

#ifndef MEDIACREATIVE_HMCMATERIALUTIL_H
#define MEDIACREATIVE_HMCMATERIALUTIL_H

#include "HmcBase.h"
#include "MediaCreative.h"
#include <json/value.h>

class HmcMaterialContent;
class HmcMaterialUtil {
public:
    static STRING GetBuiltinMaterialRootDir();
    static STRING GetMaterialRootDir();
    static void ConfigEnvironment();

    static inline STRING GetMaterialLibraryPreviewDir()
    {
        return GetMaterialLibraryDir() + FILE_SEPARATOR_STR + "Preview";
    }

    static inline STRING GetMaterialLibraryDir()
    {
        return GetMaterialRootDir() + FILE_SEPARATOR_STR + "Library";
    }

    static inline STRING GetBuiltinMaterialLibraryDir()
    {
        return GetBuiltinMaterialRootDir() + FILE_SEPARATOR_STR + "Library";
    }

    static inline STRING GetMaterialLibrarySettingDir()
    {
        return GetMaterialLibraryDir() + FILE_SEPARATOR_STR + "Setting";
    }

    static inline STRING GetBuiltinMaterialLibrarySettingDir()
    {
        return GetBuiltinMaterialLibraryDir() + FILE_SEPARATOR_STR + "Setting";
    }

    static inline STRING GetMaterialLibraryPicDir()
    {
        return GetMaterialLibraryDir() + FILE_SEPARATOR_STR + "Pic";
    }

    static inline STRING GetColumnSettingDir()
    {
        return GetMaterialLibrarySettingDir() + FILE_SEPARATOR_STR + "Column";
    }

    static inline STRING GetBuiltinColumnSettingDir()
    {
        return GetBuiltinMaterialLibrarySettingDir() + FILE_SEPARATOR_STR + "Column";
    }

    static inline STRING GetContentSettingDir()
    {
        return GetMaterialLibrarySettingDir() + FILE_SEPARATOR_STR + "Content";
    }

    static inline STRING GetBuiltinContentSettingDir()
    {
        return GetBuiltinMaterialLibrarySettingDir() + FILE_SEPARATOR_STR + "Content";
    }

    static inline STRING GetUidSettingDir()
    {
        return GetMaterialLibrarySettingDir() + FILE_SEPARATOR_STR + "Uid";
    }

    static inline STRING GetCodeIdMapSettingPath()
    {
        return GetMaterialLibrarySettingDir() + FILE_SEPARATOR_STR + "CodeIdMap.json";
    }

    static VOID FreeMaterial(HmcMaterialLibraryType materialType, VOID **material);

    static VOID FreeLibraryPic(HmcMaterialPic &materialPic);

    static STRING GetPathWithoutRoot(const STRING &path);
    static STRING GetPathWithoutRootForEveryOne(const STRING &path);

    /* *
     * 比较2个版本号的大小
     * @param v1 版本1
     * @param v2 版本2
     * @return int v1 > v2, 返回1，v1 == v2返回0，v1 < v2返回-1
     */
    static INT32 CompareVersion(STRING &v1, STRING &v2);
    static VOID InitLibraryColumn(HmcMaterialLibraryColumn &column);
    static VOID FreeLibrarySubColumnList(HmcMaterialLibraryColumn *column);
    static VOID FreeLibraryContentList(HmcMaterialLibraryContent *contentList, int cnt);

    /* *
     * 获取文件名中路径和后缀及文件名, 其中路径不包含/, 后缀不包含.号
     *
     * @param fileName, 文件名
     * @param filePath, 文件路径
     * @param fileNameWithoutExt, 除去后缀的文件名
     * @param fileExt, 后缀，不包含.号
     */
    static VOID HmcGetFilePathNameAndExt(const STRING &fileName, STRING &filePath, STRING &fileNameWithoutExt,
        STRING &fileExt);

    // url 获取下载保存的文件名。music 是最后一个
    static STRING GetFileNameFromUrl(const STRING &url);
    static STRING GetMaterialDownFileNameFromUrl(const STRING &url, STRING &encryptName);

    static void CopyFileTo(const STRING &srcPath, const STRING &dstPath);
    static INT32 CopyAllFiles(const STRING &srcPath, const STRING &dstPath);

    static void FreeLibraryContent(HmcMaterialLibraryContent &content);
    static INT32 DownAndCheckMaterial(HmcMaterialContent *content, const HmcSimpleString &secretKey);
    static char *DupCString(const STRING &string);
    // 解析单双纹理
    static HmcMaterialTransitionSubType GetTransitionType(const STRING &materialCloudId);

    static STRING GetMaterialContentId(HmcUid &materialUid);
    // 给effect和textbox使用
    static STRING GetMaterialCloudIdFromUid(const Json::Value &jsonData, const STRING &uidKey, const STRING &cloudKey);

    static void DestroyOutDateList(const HmcMaterialOutDateList &materialOutDateList);
};

#endif // MEDIACREATIVE_HMCMATERIALUTIL_H
