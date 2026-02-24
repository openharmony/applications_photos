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
#ifndef HMC_ENCODER_MANAGER_H
#define HMC_ENCODER_MANAGER_H

#include "Editor/HmcEventHandler.h"
#include "HmcEngine.h"

using HmcEncodeParam = struct HmcEncodeParam {
    double fps = 25.0F;
    /* *
     * 渲染输出的画面大小
     */
    INT32 srcWidth = 0;
    INT32 srcHeight = 0;
    INT32 pixel = 720;
    /* *
     * 实际保存的视频大小，会把渲染输出的src进行scale到dst大小后再进行编码
     */
    INT32 dstWidth = 1280;
    INT32 dstHeight = 720;
    INT32 vbitrate = 3000000;
    INT32 abitrate = 128000;
    INT32 asampleRate = 44100;
    INT32 achannelNum = 2;
    INT32 mediaType = 0; // HmcExportMediaType
    INT32 videoEncoder = 0;

    uint64_t videoStreamDuration = 0;
    uint64_t audioStreamDuration = 0;
};

enum EncodeType {
    ENCODE_SOFTWARE,
    ENCODE_HARDWARE,
};


class HmcEncoderManager : public HmcThreadMain {
public:
    HmcEncoderManager();

    virtual ~HmcEncoderManager();

    static HmcEncoderManager *Create(const STRING &exportPath, const HmcEncodeParam &parameter,
        HmcEventHandler *eventHandler);

    INT32 SetPcmData(UINT8 **pcmData, INT32 pcmSize);

    INT32 SetRgbaData(UINT8 *rgba, INT32 m_w, INT32 m_h);

    INT32 FinishExport();

    VOID CancelExport();

    VOID ThreadMain(HmcThread *selfThread, VOID *userData) final;
    
    static bool HasAuxiliaryImage(OH_PictureNative *picture);

    static HmcImage *ExportImage(OH_PixelmapNative *pixelmap, INT32 width, INT32 height);

    static INT32 ExportEditImage(OH_PictureNative *outPicture, STRING path, STRING mimeType,
        SHARED_PTR<HmcImageMetaData> metadata);

    INT32 FlushEncoder();
    INT32 FlushAudioEncoder();

    OHNativeWindow *GetOhosVecNativeWindow();

    EncodeType GetEncodeType() const;

    static PixelmapFrame *GetFrameFromPixelmapNative(OH_PixelmapNative *pixelmap, INT32 width, INT32 height);

private:
    INT32 Init(const STRING &exportPath, const HmcEncodeParam &parameter, HmcEventHandler *eventHandler);

    INT32 InitEncodeCodecs();

    INT32 ClearEncodeCodecs();

    INT32 ExportAudioData();

    INT32 ReceiveAudioPacket();

    INT32 CreateOhosVideoCodec(std::function<void()> callback);
    INT32 CreateOhosAudioCodec();

    INT32 OhosExportAudioData();
    INT32 OhosReceiveAudioPacket();

    STRING m_exportPath;
    HmcEncodeParam m_exportPam{ 0 };

    HmcMutex m_videoFrameListLock;

    LIST<PAIR<VOID *, INT32>> m_audioPcmList;
    HmcMutex m_audioPcmListLock;

    const STRING ENCODE_THREAD = "ExportManagerEncodeThread";
    HmcThread *m_encodeThread{ nullptr };
    HmcEvent m_encodeRequestEvent;
    BOOL m_encodeFinish{ FALSE };
    HmcMutex m_finishMutex;

    static constexpr INT32 DEFAULT_EXPORT_FPS = 25;
    static constexpr INT32 DEFAULT_QUALITY = 100;
    EncodeType m_encodeType = ENCODE_SOFTWARE;
    BOOL m_hasHeaderWritten = FALSE;

    HmcEventHandler *m_eventHandler{ nullptr };
};

#endif // HMC_ENCODER_MANAGER_H