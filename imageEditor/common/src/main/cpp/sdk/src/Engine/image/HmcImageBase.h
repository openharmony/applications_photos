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

#ifndef HMCIMAGEBASE_H
#define HMCIMAGEBASE_H

#include "HmcBase.h"
#include "MediaCreative/HmcImage.h"
#include "ohos/jscaller/DataAbilityHelper.h"
// 可序列化图片类ID
extern const HmcUid HMC_CLSID_IMAGE_FROM_FILE_SERIALIZED;
extern const HmcUid HMC_CLSID_IMAGE_FROM_CGIMAGE;

#ifdef __cplusplus

using Image = PicInfo;

class HmcImageBase {
public:
    HmcImageBase() = default;
    virtual ~HmcImageBase() = default;

    /* *
     * 克隆接口
     * @return              已克隆对象
     */
    virtual HmcImageBase *Clone() = 0;

    /* *
     * 序列化接口
     * @param size          输出已序列化数据总长度
     * @return              已序列化数据指针，必须使用HmcFree接口释放
     */
    virtual VOID *Serialize(UINT32 *size) = 0;

    /* *
     * 反序列化接口
     * @param dict          序列化数据头字典
     * @param data          序列化数据体
     * @param size          序列化数据体大小
     * @return              HMC_OK代表成功<br>其他值表示错误码
     * @note                1.并非所有的子类都必须实现反序列化接口，所以此接口非纯虚<br>
     * 2.此接口实现并不持有header/data，调用完毕后必须由调用者释放相关资源
     */
    virtual INT32 Deserialize(HmcDict *dict, const VOID *data, UINT32 size);

    virtual BOOL IsGpuTexture()
    {
        return FALSE;
    }

    virtual HmcImage *TransferFromGpu()
    {
        return nullptr;
    }

    virtual SHARED_PTR<Image> ConvertToImage()
    {
        return nullptr;
    }
};

#endif // __cplusplus


/**
 * 从本地文件创建HmcImage对象
 * @param filePath  文件路径
 * @return          HmcImage对象，必须使用HmcImageDestroy接口释放<br>
 * NULL表示创建失败
 */
HMC_C_API HmcImage *HmcImageCreateFromFile(const CHAR *filePath, BOOL isSupportWaterMark);

/**
 * 序列化HmcImage对象
 * @param image     待序列化HmcImage对象
 * @param size      输出序列化数据长度，不可为空
 * @return          序列化数据，必须使用HmcFree接口释放，NULL表示序列化失败
 */
HMC_C_API VOID *HmcImageSerialize(const HmcImage *image, UINT32 *size);

/**
 * 反序列化HmcImage对象
 * @param data      待反序列化数据
 * @param size      待反序列化数据长度
 * @return          HmcImage对象，必须使用HmcImageDestroy接口释放<br>
 * NULL表示反序列化失败
 */
HMC_C_API HmcImage *HmcImageDeserialize(const VOID *data, UINT32 size);

/**
 * 复制HmcImage对象
 * @param image     待复制HmcImage对象
 * @return          已复制HmcImage对象，必须使用HmcImageDestroy接口释放<br>
 * NULL表示复制失败
 */
HMC_C_API HmcImage *HmcImageDuplicate(const HmcImage *image);

/**
 * 从本地文件创建HmcImage对象
 * @param filePath  文件路径
 * @return          HmcImage对象，必须使用HmcImageDestroy接口释放<br>
 * NULL表示创建失败
 */
HMC_C_API HmcImage *HmcImageCreateFromFile(const CHAR *filePath, BOOL isSupportWaterMark);


#endif // HMCIMAGEBASE_H
