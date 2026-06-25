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

#ifndef HMC_MATERIAL_MANAGER_H
#define HMC_MATERIAL_MANAGER_H

#include "HmcBase.h"
#include "MediaCreative.h"

#include "Entity/HmcMaterialContent.h"
#include "Entity/HmcMaterialColumn.h"

#include "HmcMaterialRes.h"
#include "Utils/HmcMaterialRenderResUtil.h"

#ifdef __cplusplus

class HmcMaterialUid;
class HmcMaterialManager {
    DECLARE_SINGLETON(HmcMaterialManager);

public:
    /* *
     * 根据素材UID获取素材名
     * @param uid, 素材uid
     * @return HMC_OK -> 成功, !HMC_OK -> 失败
     */
    INT32 GetMaterialContentName(const STRING &cloudId, STRING &name);

    /* *
     * 根据素材UID获取渲染相关素材的渲染对象 HmcMaterialRenderResource
     * 使用缓存机制
     * @param uid, 素材uid
     * @param renderResource, 输出的渲染对象
     * @return HMC_OK -> 成功, !HMC_OK -> 失败
     */
    INT32 GetMaterialRenderResource(const STRING &cloudId, HmcMaterialRenderResource *renderResource,
        bool isEncrypted = true);

    /* *
     * 根据素材UID获取素材的绝对路径
     * @param uid, 素材uid
     * @param filePath, 素材的绝对路径
     * @return HMC_OK -> 成功, !HMC_OK -> 失败
     */
    INT32 GetMaterialPath(const HmcUid &uid, STRING &filePath);

private:
    HmcMaterialManager();

    VOID InitMaterialList();

    INT32 LoadCodeIdMap();

    /* *
     * 根据UID获取栏目或者素材
     *
     * @param uid, 要获取的UID
     * @param materialType, 获取到的UID对应的栏目或者素材类型, 调用者需要传入非NULL值
     * @param material, 获取到的UID对应的栏目或者素材, 函数内分配内存, 调用者自行调用FreeMaterial()释放内存
     * @return HMC_OK -> 获取成功, !HMC_OK -> 获取失败
     */
    static INT32 GetMaterialByUid(const HmcUid *uid, HmcMaterialLibraryType *materialType, VOID **material,
        bool *isRootColumn);
    /* *
     * 根据UID获取素材路径, 此路径为相对路径, 需要绝对路径时需要GetMaterialRootDir()拼接得到
     * @param uid 素材UID
     * @param filePath 返回的素材相对路径
     * @param contentResult 返回的素材, 为 nullptr 时不返回
     * @return HMC_OK -> 获取成功, !HMC_OK -> 获取失败
     */
    INT32 GetMaterialContentPath(const HmcUid &uid, STRING &filePath, HmcMaterialContent *contentResult);

    // 查找有效状态下的素材
    INT32 GetValidMaterialByUid(const HmcUid &uid, HmcMaterialContent &findContent);
    INT32 GetMaterialContentByUid(const HmcUid &uid, HmcMaterialContent &findContent);
};

#endif // __cplusplus

#endif // HMC_MATERIAL_MANAGER_H
