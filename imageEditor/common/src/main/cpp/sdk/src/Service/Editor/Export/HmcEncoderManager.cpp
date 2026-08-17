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
#include "HmcBase.h"
#include "HmcService.h"
#include "HmcEncoderManager.h"
#include "image/PixelmapFrame/PixelmapFrame.h"
#include "log/HmcLog.h"
#include "mutex/HmcMutex.h"
#include "ohos/jscaller/DataAbilityHelper.h"
#include "util/HmcSecurityCheck.h"
#include <bits/alltypes.h>
#include <multimedia/image_framework/image/image_packer_native.h>
#include <unistd.h>
#include <uv.h>
#include "render/core/HmcRenderEngine.h"
#include "image/encoder/HmcJpegEncoder.h"
#include "../../../Bridge/ohos/util/PixelmapUtil.h"
#include "../../../Bridge/ohos/hve/ProjectConfig.h";

bool HmcEncoderManager::HasAuxiliaryImage(OH_PictureNative *picture)
{
    if (picture == nullptr) {
        LOGE("Failed to check HasAuxiliaryImage");
        return false;
    }
    VECTOR<Image_AuxiliaryPictureType> auxiliaryType = {
        Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_GAINMAP,
        Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_UNREFOCUS_MAP,
        Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_LINEAR_MAP,
        Image_AuxiliaryPictureType::AUXILIARY_PICTURE_TYPE_FRAGMENT_MAP
    };
    
    Image_ErrorCode code = Image_ErrorCode::IMAGE_SUCCESS;
    for (auto type : auxiliaryType) {
        OH_AuxiliaryPictureNative *auxiliary = nullptr;
        code = OH_PictureNative_GetAuxiliaryPicture(picture, type, &auxiliary);
        if (code == Image_ErrorCode::IMAGE_SUCCESS) {
            OH_AuxiliaryPictureNative_Release(auxiliary);
            return true;
        }
    }
    return false;
}

HmcEncoderManager::HmcEncoderManager() : m_encodeThread(nullptr), m_encodeFinish(FALSE) {}

HmcEncoderManager::~HmcEncoderManager()
{
    if (m_encodeThread) {
        m_encodeThread->RequestForStop();
        m_encodeRequestEvent.SetSignaled();
        m_encodeThread->Join();
        HmcThread::Destroy(m_encodeThread);
    }

    HMC_MUTEX_LOCK(m_audioPcmListLock);
    while (!m_audioPcmList.empty()) {
        auto audioItem = m_audioPcmList.front();
        m_audioPcmList.pop_front();
        HmcFree(audioItem.first);
    }
    HMC_MUTEX_UNLOCK(m_audioPcmListLock);

    ClearEncodeCodecs();
}

HmcEncoderManager *HmcEncoderManager::Create(const STRING &exportPath, const HmcEncodeParam &parameter,
    HmcEventHandler *eventHandler)
{
    auto exportManager = new HmcEncoderManager;
    if (HMC_OK != exportManager->Init(exportPath, parameter, eventHandler)) {
        delete exportManager;
        exportManager = nullptr;
        LOGE("Failed to create export manager, path:%s", exportPath.c_str());
        return nullptr;
    }

    return exportManager;
}

INT32 HmcEncoderManager::Init(const STRING &exportPath, const HmcEncodeParam &parameter, HmcEventHandler *eventHandler)
{
    LOGD("Start init export manager, output path:%s", exportPath.c_str());

    if (exportPath.empty()) {
        LOGE("Init Failed, output path is empty");
        return HMC_ERR;
    }

    m_eventHandler = eventHandler;
    m_exportPath = exportPath;
    m_exportPam = parameter;

    auto ret = InitEncodeCodecs();
    if (HMC_OK != ret) {
        ClearEncodeCodecs();
        return HMC_ERR;
    }

    m_encodeThread = HmcThread::Create(ENCODE_THREAD, this);
    if (!m_encodeThread) {
        LOGE("create %s failed.", ENCODE_THREAD.c_str());
        return HMC_ERR;
    }

    LOGD("Succeed to init export manager");
    return HMC_OK;
}

EncodeType HmcEncoderManager::GetEncodeType() const
{
    return m_encodeType;
}

VOID HmcEncoderManager::ThreadMain(HmcThread *thread, VOID *)
{
    LOGD("[export]HmcEncoderManager thread begin, %d", thread->GetThreadId());
    while (!thread->IsStopping() && !m_encodeFinish) {
        if (!m_hasHeaderWritten) {
            uv_sleep(20);
            continue;
        }

        ExportAudioData();
        ReceiveAudioPacket();
    }
    LOGD("export- HmcEncoderManager thread loop break");

    LOGD("export- HmcEncoderManager thread end");
}

INT32 HmcEncoderManager::InitEncodeCodecs()
{
    INT32 ret = 0;
    if (IsDataAbilityUri(m_exportPath.c_str())) {
        LOGD("Open data ability uri=%s", m_exportPath.c_str());
        int64_t fd = DataAbilityHelperOpen(m_exportPath.c_str(), "w");
    }

    return HMC_OK;
}

INT32 HmcEncoderManager::CreateOhosVideoCodec(std::function<void()> callback)
{
    return HMC_OK;
}

OHNativeWindow *HmcEncoderManager::GetOhosVecNativeWindow()
{
    return HMC_OK;
}

INT32 HmcEncoderManager::CreateOhosAudioCodec()
{
    return HMC_OK;
}

INT32 HmcEncoderManager::FlushAudioEncoder()
{
    LOGD("FlushAudioEncoder, push to audio list null");
    HMC_MUTEX_LOCK(m_audioPcmListLock);
    m_audioPcmList.emplace_back(std::make_pair(nullptr, 0));
    HMC_MUTEX_UNLOCK(m_audioPcmListLock);
    m_encodeRequestEvent.SetSignaled();
    return HMC_OK;
}

INT32 HmcEncoderManager::FlushEncoder()
{
    m_encodeRequestEvent.SetSignaled();
    return HMC_OK;
}

INT32 HmcEncoderManager::ClearEncodeCodecs()
{
    LOGI("ClearEncodeCodecs");

    return HMC_OK;
}

INT32 HmcEncoderManager::ReceiveAudioPacket()
{
    return HMC_OK;
}

INT32 HmcEncoderManager::ExportAudioData()
{
    HMC_MUTEX_LOCK(m_audioPcmListLock);
    while (!m_audioPcmList.empty() && !m_encodeThread->IsStopping()) {
        auto audioItem = m_audioPcmList.front();
        m_audioPcmList.pop_front();
        HMC_MUTEX_UNLOCK(m_audioPcmListLock);
        HmcFree(audioItem.first);
        HMC_MUTEX_LOCK(m_audioPcmListLock);
    }
    HMC_MUTEX_UNLOCK(m_audioPcmListLock);

    return HMC_OK;
}

INT32 HmcEncoderManager::OhosExportAudioData()
{
    HMC_MUTEX_LOCK(m_audioPcmListLock);
    if (!m_audioPcmList.empty()) {
        auto audioItem = m_audioPcmList.front();
        m_audioPcmList.pop_front();
        HMC_MUTEX_UNLOCK(m_audioPcmListLock);
        HmcFree(audioItem.first);
        HMC_MUTEX_LOCK(m_audioPcmListLock);
    }
    HMC_MUTEX_UNLOCK(m_audioPcmListLock);

    return HMC_OK;
}

INT32 HmcEncoderManager::OhosReceiveAudioPacket()
{
    return HMC_OK;
}

INT32 HmcEncoderManager::SetPcmData(UINT8 **pcmData, INT32 pcmSize)
{
    if (m_exportPam.mediaType == HMC_EXPORT_MEDIA_TYPE_VIDEO) {
        LOGE(" m_exportPam.mediaType is only video");
        return HMC_ERR;
    }

    if (!*pcmData) {
        // 音视频非对齐时写空包
        constexpr UINT32 defalutPcmSize = 7056;
        pcmSize = defalutPcmSize;
        if (pcmSize <= 0) {
            LOGE("pcmSize:%d", pcmSize);
            return HMC_ERR;
        }

        *pcmData = (UINT8 *)malloc(pcmSize);
        if (*pcmData == nullptr) {
            LOGE("Failed to alloc pcm data");
            return HMC_ERR_OOM;
        }
        HmcMemZero(*pcmData, pcmSize);
    }

    auto audioData = HmcMalloc(pcmSize);
    if (!audioData) {
        return HMC_ERR;
    }

    memcpy(audioData, *pcmData, pcmSize);
    HMC_MUTEX_LOCK(m_audioPcmListLock);
    m_audioPcmList.emplace_back(std::make_pair(audioData, pcmSize));
    HMC_MUTEX_UNLOCK(m_audioPcmListLock);
    m_encodeRequestEvent.SetSignaled();
    return HMC_OK;
}

INT32 HmcEncoderManager::SetRgbaData(UINT8 *rgba, INT32 width, INT32 height)
{
    return HMC_OK;
}

HmcImage *HmcEncoderManager::ExportImage(OH_PixelmapNative *pixelmap, INT32 width, INT32 height)
{
    if (pixelmap == nullptr) {
        LOGE("ExportImage pixelmap is null");
        return nullptr;
    }
    auto frame = GetFrameFromPixelmapNative(pixelmap, width, height);
    if (!frame) {
        LOGE("Faile to get frame frome rgba, pixel:%dx%d", width, height);
        return nullptr;
    }
    return frame;
}

PixelmapFrame *HmcEncoderManager::GetFrameFromPixelmapNative(OH_PixelmapNative *pixelmap, INT32 width, INT32 height)
{
    SHARED_PTR<Image> image = std::make_shared<Image>();
    image->width = width;
    image->height = height;
    image->nativePixelmap = pixelmap;
    return new PixelmapFrame(image);
}

std::shared_ptr<OH_PackingOptions> CreatePackingOptions(int quality, STRING mimeType)
{
    OH_PackingOptions *options = nullptr;
    Image_ErrorCode errorCode = OH_PackingOptions_Create(&options);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PackingOptions_Create error %d", errorCode);
        return nullptr;
    }

    std::shared_ptr<OH_PackingOptions> optionsPtr(options, [](OH_PackingOptions *options) {
        LOGD("OH_PackingOptions_Release start.");
        OH_PackingOptions_Release(options);
    });
    LOGI("CreatePackingOptions mimeType.c_str() %s", mimeType.c_str());
    OH_PackingOptions_SetQuality(optionsPtr.get(), quality);
    Image_MimeType format = {.data = const_cast<char *>(mimeType.c_str()), .size = strlen(mimeType.c_str())};
    OH_PackingOptions_SetMimeType(optionsPtr.get(), &format);
    OH_PackingOptions_SetDesiredDynamicRange(optionsPtr.get(), IMAGE_PACKER_DYNAMIC_RANGE_AUTO);
    OH_PackingOptions_SetNeedsPackProperties(optionsPtr.get(), true);
    return optionsPtr;
}

INT32 HmcEncoderManager::ExportEditImage(OH_PictureNative *outPicture, STRING path, STRING mimeType,
    SHARED_PTR<HmcImageMetaData> metadata)
{
    LOGI("ExportEditImage start:%s, path = %s", mimeType.c_str(), path.c_str());
    OH_ImagePackerNative *imagePacker = nullptr;
    Image_ErrorCode errorCode = OH_ImagePackerNative_Create(&imagePacker);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_ImagePackerNative_Create fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }

    std::shared_ptr<OH_ImagePackerNative> imagePackerPtr(imagePacker, [](OH_ImagePackerNative *imagePacker) {
        LOGD("OH_ImagePackerNative_Release start.");
        OH_ImagePackerNative_Release(imagePacker);
    });

    int quality = ProjectConfig::Instance().GetImageQuality(); // 影响保存图片的质量和大小
    LOGI("ExportEditImage package quality=%d", quality);

    std::shared_ptr<OH_PackingOptions> optionsPtr = CreatePackingOptions(quality, mimeType);
    HmcFile file;
    if (HMC_OK != file.Open(path, HmcFile::HMC_FILE_CREATE)) {
        LOGE("Failed to open %s for write!", path.c_str());
        return HMC_ERR;
    };
    int fd = file.FileNo();
    bool hasAuxiliary = HasAuxiliaryImage(outPicture);
    OH_PixelmapNative *mainPixelmap = nullptr;
    OH_PictureNative_GetMainPixelmap(outPicture, &mainPixelmap);
    PixelmapInfo pxlInfo = PixelmapUtil::GetPixelmapInfo(mainPixelmap);
    LOGI("ExportEditImage hasAuxiliary=%d, width=%d, height=%d, fd=%d", hasAuxiliary, pxlInfo.width, pxlInfo.height, fd);
    if (hasAuxiliary) {
        PictureUtil::TryUpdateExifSize(outPicture);
        errorCode = OH_ImagePackerNative_PackToFileFromPicture(imagePackerPtr.get(), optionsPtr.get(), outPicture, fd);
    } else {
        errorCode = OH_ImagePackerNative_PackToFileFromPixelmap(imagePackerPtr.get(), optionsPtr.get(), mainPixelmap,
            fd);
    }
    LOGI("ExportEditImage PackToFile end.");
    OH_PixelmapNative_Release(mainPixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_ImagePackerNative_PackToFileFromPicture fail! errorCode=%d", errorCode);
        file.ClearFd();
        return HMC_ERR;
    }
    file.ClearFd();
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS) {
        LOGE("OH_PictureNative_Release fail! errorCode=%d", errorCode);
    }
    LOGI("ExportEditImage end.");
    return HMC_OK;
}

INT32 HmcEncoderManager::FinishExport()
{
    LOGD("Finish export called");

    HMC_MUTEX_GUARD(m_finishMutex);
    if (m_encodeThread) {
        m_encodeThread->RequestForStop();
        m_encodeFinish = TRUE;
        LOGI("notify, finish export");
        m_encodeRequestEvent.SetSignaled();
        HmcThread::Destroy(m_encodeThread);
    }

    LOGD("Finish export called finish");
    return HMC_OK;
}

VOID HmcEncoderManager::CancelExport()
{
    LOGD("Cancel export called");

    FinishExport();

    HmcFile::Remove(m_exportPath);

    LOGD("Cancel export called finish");
}