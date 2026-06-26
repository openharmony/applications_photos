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
#include "render/base/RenderBase.h"
#include "HmcEngine.h"
#include "HmcRenderTexture.h"

HmcRenderTexture::HmcRenderTexture(BOOL isNeedRelease)
    : m_imagePtr(NULL), m_isNeedRelease(isNeedRelease), m_rotation(0), m_uid(HMC_UID_NULL)
{}

HmcRenderTexture::HmcRenderTexture(const HmcRenderTexture &texture)
{
    m_surfaceTexture = texture.m_surfaceTexture;
    m_imagePtr = texture.m_imagePtr;
    m_isNeedRelease = texture.m_isNeedRelease;
    m_rotation = texture.m_rotation;
    m_uid = texture.m_uid;
}

HmcRenderTexture::~HmcRenderTexture() {}

HmcRenderTexture &HmcRenderTexture::operator = (const HmcRenderTexture &texture)
{
    m_surfaceTexture = texture.m_surfaceTexture;
    m_imagePtr = texture.m_imagePtr;
    m_isNeedRelease = texture.m_isNeedRelease;
    m_rotation = texture.m_rotation;
    m_uid = texture.m_uid;
    return *this;
}
BOOL HmcRenderTexture::CreateTexture(HmcImage *image, HmcSurfaceTexture *surfaceTex)
{
    return TRUE;
}

BOOL HmcRenderTexture::CreateTexture(HmcImage *image)
{
    // 除了视频其他从老的接口走
    auto frame = static_cast<HmcImageFromFile *>(image);
    if (frame == nullptr) {
        return FALSE;
    }
    m_imagePtr = frame->ConvertToImage();
    if (!m_imagePtr) {
        return FALSE;
    }

    return TRUE;
}

BOOL HmcRenderTexture::CreateTexture(UINT32 width, UINT32 height, UCHAR r, UCHAR g, UCHAR b, UCHAR a)
{
    return TRUE;
}

INT32 HmcRenderTexture::GetWidth()
{
    INT32 width = 0;
    if (!m_imagePtr) {
        LOGE("GetWidth failed, m_imagePtr is nullptr");
        return width;
    }

    width = static_cast<INT32>(m_imagePtr->width);

    return width;
}

INT32 HmcRenderTexture::GetHeight()
{
    INT32 height = 0;
    if (!m_imagePtr) {
        LOGE("GetHeight failed, m_imagePtr is nullptr");
        return height;
    }

    height = static_cast<INT32>(m_imagePtr->height);

    return height;
}

INT32 HmcRenderTexture::GetDisplayWidth()
{
    if (m_rotation == HMC_ROTATE_90_DEGREE || m_rotation == HMC_ROTATE_270_DEGREE) {
        // 宽高交换
        return GetHeight();
    }

    int width = GetWidth();

    return width;
}

INT32 HmcRenderTexture::GetDisplayHeight()
{
    if (m_rotation == HMC_ROTATE_90_DEGREE || m_rotation == HMC_ROTATE_270_DEGREE) {
        // 宽高交换
        int width = GetWidth();

        return width;
    }

    return GetHeight();
}

HmcSurfaceTexture *HmcRenderTexture::GetSurfaceTexture()
{
    return m_surfaceTexture;
}

SHARED_PTR<Image> HmcRenderTexture::GetImage()
{
    return m_imagePtr;
}

void HmcRenderTexture::SetImage(SHARED_PTR<Image> path)
{
    m_imagePtr = path;
}

VOID HmcRenderTexture::SetRotation(INT32 rotation)
{
    m_rotation = rotation > 0 ? rotation : (rotation + HMC_ROTATE_360_DEGREE);
}

INT32 HmcRenderTexture::GetRotation()
{
    return m_rotation;
}

BOOL HmcRenderTexture::NeedRelease() const
{
    return m_isNeedRelease;
}
