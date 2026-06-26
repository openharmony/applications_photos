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

#ifndef HMCRENDERTEXTURE_H
#define HMCRENDERTEXTURE_H

#include "render/base/RenderBase.h"
#include <native_image/native_image.h>
#include "image/HmcImageBase.h"

struct HmcSurfaceTexture {
    OH_NativeImage *m_nativeImage;
    OHNativeWindow *m_nativeWindow;
    INT32 m_nativeTexId;
};

class HmcRenderTexture {
public:
    // 统一使用HmcImage创建一个纹理，isNeedRelease表示上层结构，如layer，被释放时，其中的texture是否需要被同步释放
    explicit HmcRenderTexture(BOOL isNeedRelease = FALSE);
    ~HmcRenderTexture();

    BOOL CreateTexture(HmcImage *image);
    BOOL CreateTexture(HmcImage *image, HmcSurfaceTexture *surfaceTex);
    BOOL CreateTexture(UINT32 width, UINT32 height, UCHAR r, UCHAR g, UCHAR b, UCHAR a = 255); // rgba范围0~255
    INT32 GetWidth();
    INT32 GetHeight();
    VOID SetRotation(INT32 r);
    INT32 GetRotation();
    BOOL NeedRelease() const;
    INT32 GetDisplayWidth();
    INT32 GetDisplayHeight();
    HmcRenderTexture(const HmcRenderTexture &texture);
    HmcRenderTexture &operator = (const HmcRenderTexture &texture);

    HmcSurfaceTexture *GetSurfaceTexture();
    HmcSurfaceTexture *m_surfaceTexture{ nullptr };

    SHARED_PTR<Image> GetImage();
    void SetImage(SHARED_PTR<Image> path);
    // 图片RGBA数据
    SHARED_PTR<Image> m_imagePtr;

    BOOL m_isNeedRelease;
    int m_rotation = 0;
    HmcUid m_uid;
};

using HmcRenderTexturePtr = SHARED_PTR<HmcRenderTexture>;

#endif // HMCRENDERTEXTURE_H
