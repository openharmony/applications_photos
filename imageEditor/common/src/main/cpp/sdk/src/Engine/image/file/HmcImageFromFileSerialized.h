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

#ifndef HMCIMAGEFROMFILESERIALIZED_H
#define HMCIMAGEFROMFILESERIALIZED_H

#ifdef __cplusplus

class HmcImageFromFileSerialized : public HmcImageBase {
public:
    HmcImageFromFileSerialized();
    ~HmcImageFromFileSerialized() override;

    /* *
     * 克隆接口
     * @return              已克隆对象
     */
    HmcImageBase *Clone() final;

    /* *
     * 序列化接口
     * @param size          输出已序列化数据总长度
     * @return              已序列化数据指针，必须使用HmcFree接口释放
     */
    VOID *Serialize(UINT32 *size) final;

    /* *
     * 反序列化接口
     * @param dict          序列化数据头字典
     * @param data          序列化数据体
     * @param size          序列化数据体大小
     * @return              HMC_OK代表成功<br>其他值表示错误码
     * @note                1.并非所有的子类都必须实现反序列化接口，所以此接口非纯虚<br>
     * 2.此接口实现并不持有header/data，调用完毕后必须由调用者释放相关资源
     */
    INT32 Deserialize(HmcDict *dict, const VOID *data, UINT32 size) final;

private:
    STRING GenerateSerializationHeader();

private:
    HmcDict *m_header;
    VOID *m_fileData;
    UINT32 m_fileSize;
};

#endif // __cplusplus

#endif // HMCIMAGEFROMFILESERIALIZED_H
