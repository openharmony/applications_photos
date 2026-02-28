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

#include "Asset/Utils/HmcTimeUtil.h"
#include "Effect/HmcEffectTransform.h"
#include "HmcBase.h"
#include "MediaCreative.h"
#include "HmcService.h"
#include "log/HmcLog.h"
#include "ohos/common/HmcUidHelper.h"
#include "ohos/util/HveTransformUtil.h"
#include "../Bridge/ohos/util/PixelmapUtil.h"
#include "util/HmcSampleSizer.h"
#include "../Bridge/ohos/hve/ProjectConfig.h";
#include "image/decoder/HmcOhosImageDecoder.h"

static char uidStr[HMC_UID_STR_LEN] = {0};

static FLOAT g_originalVariableSpeed = 1.0;

static const uint32_t PIXEL_LENGTH_RGBA8888 = 4;

const uint32_t PIXEL_FORMAT_BGRA8888 = 4;

static inline VOID PreviewStateControl(HmcEditor *editor)
{
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    if (editorImp != nullptr && editorImp->GetLastState() == HMC_EDITOR_STATE_PLAY) {
        HMC_EDITOR_SETTER(editor, false);
    } else {
        HMC_EDITOR_SETTER(editor);
    }
}

static inline HmcLaneManager *GetLaneManager(HmcEditor *editor)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return nullptr;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    HmcLaneManager *manager = editorImp->GetLaneManager();
    return manager;
}

static inline IHmcAsset *GetAsset(HmcUid uid)
{
    return SINGLETON(HmcUidAdmin)->GetAsset(uid);
}

static HmcVisionAsset *GetImageOrVideoAsset(const HmcUid assetUid)
{
    auto visionAsset = dynamic_cast<HmcVisionAsset *>(GetAsset(assetUid));
    if (visionAsset == nullptr) {
        return nullptr;
    }

    auto type = visionAsset->GetType();
    if (type != HMC_ASSET_IMAGE) {
        return nullptr;
    }

    return visionAsset;
}

static inline IHmcLane *GetLaneFromAsset(HmcEditor *editor, HmcUid uid)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(uid);
    if (asset) {
        return SINGLETON(HmcUidAdmin)->GetLane(asset->GetLaneUid());
    }

    HMC_UNUSED(editor);
    return nullptr;
}

// 将(0, 0)原点坐标转为ASSET中心点偏移
static void GetAssetOffsetByPoint(HmcPosition &offset, HmcAssetPoint point, float width, float height)
{
    constexpr FLOAT HALF = 0.5f;

    offset.x = point.x - (width * HALF);
    offset.y = (height * HALF) - point.y;
}

// 将ASSET中心点偏移转为(0, 0)原点坐标
static void GetAssetPointByOffset(HmcAssetPoint &point, HmcPosition offset, float width, float height)
{
    constexpr FLOAT HALF = 0.5f;

    point.x = offset.x + (width * HALF);
    point.y = (height * HALF) - offset.y;
}

static void GetAssetPositionByOffset(HmcAssetPosition *poutPosition, HmcRectanglePosition assetOffset, float width,
    float height)
{
    GetAssetPointByOffset(poutPosition->center, assetOffset.center, width, height);
    GetAssetPointByOffset(poutPosition->leftTop, assetOffset.leftTop, width, height);
    GetAssetPointByOffset(poutPosition->leftBottom, assetOffset.leftBottom, width, height);
    GetAssetPointByOffset(poutPosition->rightTop, assetOffset.rightTop, width, height);
    GetAssetPointByOffset(poutPosition->rightBottom, assetOffset.rightBottom, width, height);
}

static void CreateAssetAfter(HmcEditor *editor, HmcUid assetUid, HmcDict *dict)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        return;
    }

    auto editorImp = static_cast<HmcEditorImp *>(editor);
    if (editorImp == nullptr) {
        return;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        return;
    }
    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset != nullptr) {
        visionAsset->SetCanvasRatio();
    }
}

int AssetCreate(HmcEditor *editor, HmcUid laneUid, HmcDict *dict, HmcUid *poutAssetUid, BOOL isCover = FALSE,
    bool autoPauseEditor = true)
{
    HMC_EDITOR_SETTER(editor, autoPauseEditor);

    if (editor == nullptr || dict == nullptr) {
        LOGE("error, editor or dict is nullptr");
        return HMC_ERR_PARAM;
    }
    char *dictStr = HmcDictSerialize(dict);
    LOGD("AssetCreate laneUid: %s, dict: %s", HmcUidToString(&laneUid, uidStr, HMC_UID_STR_LEN), dictStr);
    HmcFree(dictStr);

    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("lane is invalid, please check your lane id");
        return HMC_ERR_SERVICE_LANE_INVALID;
    }

    HmcUid assetUid = lane->CreateAsset(dict);
    if (HmcUidIsNull(&assetUid)) {
        LOGE("lane create asset failed");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (poutAssetUid) {
        *poutAssetUid = assetUid;
    }
    LOGD("create asset: %s", HmcUidToString(poutAssetUid, uidStr, HMC_UID_STR_LEN));

    CreateAssetAfter(editor, assetUid, dict);

    if (editor == nullptr) {
        LOGE("error, editor or dict is nullptr");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("error, invalid asset");
        return HMC_ERR;
    }
    
    INT32 isMediaSource = 0;
    INT32 isFrontCamera = 0;
    INT32 isCameraEditData = 0;
    HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_IS_MEDIA_SOURCE, &isMediaSource);
    HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_IS_FRONT_CAMERA, &isFrontCamera);
    HmcDictGetInt32(dict, DICT_KEY_ASSET_PROPERTY_IS_CAMERA_EDIT_DATA, &isCameraEditData);
    std::string editData = HmcDictGetString(dict, DICT_KEY_ASSET_PROPERTY_EDIT_DATA);
    asset->InitEffectWithEditData(editData, isMediaSource, isFrontCamera, isCameraEditData);
    return HMC_OK;
}

int HmcAssetSetSourceByPixelMap(HmcEditor *editor, HmcUid assetUid, void *pixelBuffer)
{
    if (pixelBuffer == nullptr) {
        LOGE("error, invalid pixelBuffer");
        return HMC_ERR;
    }
    OH_PixelmapNative *pixelmap = (OH_PixelmapNative *)pixelBuffer;
    if (editor == nullptr) {
        LOGE("error, editor or dict is nullptr");
        OH_PixelmapNative_Release(pixelmap);
        return HMC_ERR_PARAM;
    }
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("error, invalid asset");
        OH_PixelmapNative_Release(pixelmap);
        return HMC_ERR;
    }
    
    OH_PictureNative *nativePicture = nullptr;
    LOGI("HmcAssetSetSourceByPixelMap flow2Base is not exists.");
    Image_ErrorCode errorCode = OH_PictureNative_CreatePicture(pixelmap, &nativePicture);
    OH_PixelmapNative_Release(pixelmap);
    if (errorCode != Image_ErrorCode::IMAGE_SUCCESS || nativePicture == nullptr) {
        LOGE("OH_PictureNative_CreatePicture fail! errorCode=%d", errorCode);
        return HMC_ERR;
    }
    return HmcAssetSetSourceByPicture(editor, assetUid, nativePicture);
}

static int HmcAssetSetSourcePictureExec(IHmcAsset *asset, OH_PictureNative *nativePicture, bool isOriPicture)
{
    PixelmapInfo pxlInfo = PictureUtil::GetMainPixelmapInfo(nativePicture);
    LOGI("SetSource pixelmap from ets, width=%d, height=%d", pxlInfo.width, pxlInfo.height);
    // 降采样
    Image_Size imageSize = HmcOhosImageDecoder::GetSimplerPreviewSizer(pxlInfo.width, pxlInfo.height);
    SHARED_PTR<Image> composeImage;
    if (pxlInfo.width > imageSize.width || pxlInfo.height > imageSize.height) {
        LOGI("Do downSample, pxl.width=%d, pxl.height=%d, scaleWidth=%d, scaleHeight=%d", pxlInfo.width, pxlInfo.height,
            imageSize.width, imageSize.height);
        OH_PictureNative *downSampleExportPicture = nullptr;
        downSampleExportPicture = CloneDmaPicture(nativePicture);
        if (downSampleExportPicture == nullptr) {
            LOGE("downSampleExportPicture copy error.");
            return HMC_ERR;
        }
        if (IsEditorSwitchEnable(EDITOR_DEBUG_ENABLE)) {
            PictureUtil::DumpPicture(downSampleExportPicture, "SetSourceDownSampleOriginal");
        }
        composeImage = HmcOhosImageDecoder::CreateImageByPicture(downSampleExportPicture, imageSize, false);
        if (composeImage == nullptr) {
            LOGE("CreateImageByDownSamplePicture fail!");
            OH_PictureNative_Release(nativePicture);
            OH_PictureNative_Release(downSampleExportPicture);
            return HMC_ERR;
        }
        LOGI("SetSource pixelmap from ets downSampleScale:%f", composeImage->downSampleScale);
        composeImage->originalPicture = nativePicture;
        composeImage->originalWidth = pxlInfo.width;
        composeImage->originalHeight = pxlInfo.height;
    } else {
        composeImage = HmcOhosImageDecoder::CreateImageByPicture(nativePicture, imageSize, false);
         if (composeImage == nullptr) {
            LOGE("CreateImageByPicture fail!");
            OH_PictureNative_Release(nativePicture);
            return HMC_ERR;
        }
    }
    int ret = asset->SetSource(composeImage, isOriPicture);
    if (ret == HMC_OK) {
        ((HmcImageAsset *)asset)->ClearCompareEffectList();
    }
    return ret;
}

int HmcAssetSetSourceByPicture(HmcEditor *editor, HmcUid assetUid, OH_PictureNative *nativePicture, bool isOriPicture)
{
    if (nativePicture == nullptr) {
        LOGE("error, invalid nativePicture");
        return HMC_ERR;
    }
    if (editor == nullptr) {
        OH_PictureNative_Release(nativePicture);
        LOGE("error, editor or dict is nullptr");
        return HMC_ERR_PARAM;
    }
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        OH_PictureNative_Release(nativePicture);
        LOGE("error, invalid asset");
        return HMC_ERR;
    }

    LOGI("SetAssetSource nativePicture");
    if (IsEditorSwitchEnable(EDITOR_DEBUG_ENABLE)) {
        PictureUtil::DumpPicture(nativePicture, "SetSourcePicture");
    }
    return HmcAssetSetSourcePictureExec(asset, nativePicture, isOriPicture);
}

int HmcAssetCreate(HmcEditor *editor, HmcUid laneUid, HmcDict *dict, HmcUid *poutAssetUid, bool autoPauseEditor)
{
    return AssetCreate(editor, laneUid, dict, poutAssetUid, FALSE, autoPauseEditor);
}

int HmcAssetDestroy(HmcEditor *editor, HmcUid assetUid, bool autoPauseEditor)
{
    HMC_EDITOR_SETTER(editor, autoPauseEditor);

    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    }
    LOGD("asset destroy, assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("error, invalid asset");
        return HMC_ERR;
    }

    IHmcLane *lane = GetLaneFromAsset(editor, assetUid);
    if (lane == nullptr) {
        return HMC_ERR_SERVICE_LANE_INVALID;
    }

    lane->DestroyAsset(assetUid);

    return HMC_OK;
}

int HmcAssetGetMetaData(HmcEditor *editor, HmcUid assetUid, HmcDict *metaData)
{
    if (metaData == nullptr) {
        LOGE("error, metaData is nullptr");
        return HMC_ERR_PARAM;
    }

    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("error, invalid asset");
        return HMC_ERR;
    }

    asset->GetAssetParamValue(metaData);

    return HMC_OK;
}

int HmcAssetSetMetaData(HmcEditor *editor, HmcUid assetUid, HmcDict *metaData)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    }

    if (metaData == nullptr) {
        LOGE("error, metaData is nullptr");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("error, invalid asset");
        return HMC_ERR;
    }

    asset->SetAssetParamValue(metaData);

    return HMC_OK;
}

int32_t HmcAssetSetOriginalColorMode(HmcEditor *editor, HmcUid assetUid, int32_t mode)
{
    HMC_EDITOR_SETTER(editor);
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("invalid asset uid");
        return -1;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("not vision asset");
        return -1;
    }

    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        LOGE("not a vision asset");
        return -1;
    }

    visionAsset->SetOriginalColorMode(mode);
    return HMC_OK;
}

int32_t HmcAssetGetOriginalColorMode(HmcUid assetUid)
{
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("HmcAssetGetOriginalColorMode, invalid asset uid");
        return -1;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("HmcAssetGetOriginalColorMode, not vision asset");
        return -1;
    }

    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        LOGE("HmcAssetGetOriginalColorMode, not a vision asset");
        return -1;
    }

    return visionAsset->GetOriginalColorMode();
}

HmcUid HmcAssetGetMaterialUid(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_UID_NULL;
    }
    LOGD("HmcAssetGetMaterialUid assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("invalid asset uid");
        return HMC_UID_NULL;
    }

    return asset->GetMaterialUid();
}

int64_t HmcAssetGetDuration(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return 0;
    }

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset) {
        return asset->GetDurationTime();
    }
    return 0;
}

int64_t HmcAssetGetFileDuration(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return 0;
    }

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        return 0;
    }

    return asset->GetFileDuration();
}

int64_t HmcAssetGetStartTime(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == NULL) {
        LOGE("error, editor is NULL");
        return 0;
    }

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset) {
        return asset->GetStartTime();
    }
    return 0;
}

int64_t HmcAssetGetEndTime(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return 0;
    }
    LOGD("assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
    IHmcAsset *asset = GetAsset(assetUid);
    if (asset) {
        return asset->GetEndTime();
    }
    return 0;
}

HmcUid HmcAssetGetLaneId(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_UID_NULL;
    }
    LOGD("assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
    IHmcAsset *asset = GetAsset(assetUid);
    if (asset) {
        return asset->GetLaneUid();
    }
    return HMC_UID_NULL;
}

HmcAssetType HmcAssetGetType(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ASSET_NONE;
    }
    LOGD("assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
    IHmcAsset *asset = GetAsset(assetUid);
    if (asset) {
        return asset->GetType();
    }
    return HMC_ASSET_NONE;
}

void HmcAssetRequestThumbnail(HmcEditor *editor, HmcUid assetUid, int64_t startTimestamp, int64_t duration,
    unsigned int interval)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return;
    }

    LOGD("assetUid: %s, startTimestamp: %lld, duration: %u interval: %u",
        HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN), startTimestamp, duration, interval);

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset) {
        if (duration <= 0) {
            duration = asset->GetDurationTime();
        }
        HmcAssetType type = asset->GetType();
        if (type == HMC_ASSET_IMAGE) {
            ((HmcImageAsset *)asset)->RequestThumbnail(startTimestamp);
        }
    }
}

void HmcAssetRequestThumbnailList(HmcEditor *editor, HmcUid assetUid, int64_t *timeStamps, unsigned int count)
{
    if (editor == nullptr || timeStamps == nullptr) {
        LOGE("error, editor or timestamps is nullptr");
        return;
    }
}

void HmcAssetRequestFilterThumbnail(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return;
    }
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    if (editorImp == nullptr) {
        LOGE("editorImp is nullptr");
        return;
    }

    uint64_t currentTimeline = editorImp->GetCurrentTimeline();
    IHmcAsset *asset = GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is nullptr");
        return;
    }

    LOGD("RequestFilterThumbnail start currentTimeline=%ld", currentTimeline);

    // 获取当前preview
    HmcAssetType type = asset->GetType();
    HmcImage *hmcImage = nullptr;
    if (type == HMC_ASSET_IMAGE) {
        hmcImage = ((HmcImageAsset *)asset)->GetPreview(currentTimeline);
    }
    LOGD("RequestFilterThumbnail finish get hmcImage currentTimeline=%ld, type=%d", currentTimeline, type);
}

void HmcAssetCancelThumbnail(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return;
    }
    LOGD("cancel thumbnail assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
    IHmcAsset *asset = GetAsset(assetUid);
    if (asset) {
        HmcAssetType type = asset->GetType();
        if (type == HMC_ASSET_IMAGE) {
            ((HmcImageAsset *)asset)->CancelThumbnail();
        }
    }
}

void HmcAssetRequestAudioWave(HmcEditor *editor, HmcUid assetUid, int64_t statTimestamp, int64_t duration,
    int points = 1000)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return;
    }
    LOGD("assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
}

int HmcAssetGetPositionByCenter(HmcEditor *editor, HmcUid assetUid, float *offsetX, float *offsetY)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR;
    } else if (offsetX == nullptr || offsetY == nullptr) {
        LOGE("error, offsetX or offsetY is nullptr");
        return HMC_ERR;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        return HMC_ERR;
    }

    HmcAssetType type = asset->GetType();
    if (!HmcAssetUtils::IsVisionAsset(type)) {
        return HMC_ERR;
    }

    auto visionAsset = (HmcVisionAsset *)asset;
    visionAsset->GetPosition(*offsetX, *offsetY);

    return HMC_ERR;
}

int HmcAssetGetVideoFps(HmcEditor *editor, HmcUid assetUid, double *fps)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR;
    } else if (fps == nullptr) {
        LOGE("error, fps is nullptr");
        return HMC_ERR;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        return HMC_ERR;
    }

    HmcAssetType type = asset->GetType();
    if (HmcAssetUtils::IsVisionAsset(type)) {
        auto visionAsset = (HmcVisionAsset *)asset;
        *fps = visionAsset->GetVideoFps();
    }

    return HMC_OK;
}

int HmcAssetGetVideoBitRate(HmcEditor *editor, HmcUid assetUid, int32_t *bitRate)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR;
    } else if (bitRate == nullptr) {
        LOGE("error, bitRate is nullptr");
        return HMC_ERR;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        return HMC_ERR;
    }

    HmcAssetType type = asset->GetType();
    if (HmcAssetUtils::IsVisionAsset(type)) {
        auto visionAsset = (HmcVisionAsset *)asset;
        *bitRate = visionAsset->GetVideoBitRate();
    }

    return HMC_OK;
}

int HmcAssetSetPositionByCenter(HmcEditor *editor, HmcUid assetUid, float offsetX, float offsetY)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR;
    }

    PreviewStateControl(editor);

    LOGD("set asset(%s) position: (%.2f, %.2f)", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN), offsetX, offsetY);

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset) {
        HmcAssetType type = asset->GetType();
        if (HmcAssetUtils::IsVisionAsset(type)) {
            ((HmcVisionAsset *)asset)->SetPosition(offsetX, offsetY);
            return HMC_OK;
        }
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }
    return HMC_ERR_SERVICE_ASSET_INVALID;
}

int HmcAssetGetZoom(HmcEditor *editor, HmcUid assetUid, float *zoomX, float *zoomY)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    } else if (zoomX == nullptr || zoomY == nullptr) {
        LOGE("error, zoom is nullptr");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("get asset failed by asset uid");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not vision asset, no zoom");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    visionAsset->GetZoom(*zoomX, *zoomY);

    return HMC_OK;
}

int HmcAssetSetZoom(HmcEditor *editor, HmcUid assetUid, float zoomX, float zoomY)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    }

    if (zoomX < 0 || zoomY < 0) {
        LOGE("invalid zoom(.5f, .5f), zoom can not less than 0", zoomX, zoomY);
        return HMC_ERR_PARAM;
    }

    LOGD("assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset) {
        if (HmcAssetUtils::IsVisionAsset(asset->GetType())) {
            auto visionAsset = (HmcVisionAsset *)asset;
            visionAsset->SetZoom(zoomX, zoomY);
            return HMC_OK;
        }

        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    return HMC_ERR_SERVICE_ASSET_INVALID;
}

int HmcAssetGetRotation(HmcEditor *editor, HmcUid assetUid, float *rotation, HmcRotationAxis axis)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    } else if (rotation == nullptr) {
        LOGE("error, rotation is nullptr");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("get asset failed by asset uid");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not vision asset, no rotation");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    *rotation = visionAsset->GetRotation(axis);

    return HMC_OK;
}

int HmcAssetSetRotation(HmcEditor *editor, HmcUid assetUid, float rotation, HmcRotationAxis axis)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    }
    LOGD("assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset) {
        if (HmcAssetUtils::IsVisionAsset(asset->GetType())) {
            auto visionAsset = (HmcVisionAsset *)asset;
            visionAsset->SetRotation(axis, rotation);
            return HMC_OK;
        }

        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    return HMC_ERR_SERVICE_ASSET_INVALID;
}

int HmcAssetSetOpacity(HmcEditor *editor, HmcUid assetUid, float opacity)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    }
    LOGD("set opacity, assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    auto visionAsset = dynamic_cast<HmcVisionAsset *>(SINGLETON(HmcUidAdmin)->GetAsset(assetUid));
    if (visionAsset == nullptr) {
        LOGE("asset is not vision asset, can not set opacity");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    visionAsset->SetOpacity(opacity);

    return HMC_OK;
}

int HmcAssetSetSize(HmcEditor *editor, HmcUid assetUid, HmcSize size)
{
    if (editor == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    PreviewStateControl(editor);

    LOGD("assetUid: %s, new size: (%f, %f)", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN), size.width,
        size.height);

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("invalid asset uid");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    HmcAssetType type = asset->GetType();
    if (!HmcAssetUtils::IsVisionAsset(type)) {
        LOGE("invalid asset type: %d", type);
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    auto visionAsset = (HmcVisionAsset *)asset;
    visionAsset->SetSize(size);

    return HMC_OK;
}

int HmcAssetGetSize(HmcEditor *editor, HmcUid assetUid, HmcSizeType type, HmcSize *poutSize)
{
    if (editor == nullptr || poutSize == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR;
    }
    STRING id = HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN);
    LOGD("assetUid: %s", id.c_str());
    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("Get asset size failed: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
        return HMC_ERR;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("HmcAssetGetSize, Invalid asset type: %d", asset->GetType());
        return HMC_ERR;
    }

    auto visionAsset = (HmcVisionAsset *)asset;
    if (type == HMC_SIZE_ORIGINAL) {
        poutSize->width = visionAsset->GetWidth();
        poutSize->height = visionAsset->GetHeight();
    } else if (type == HMC_SIZE_RENDER) {
        *poutSize = visionAsset->GetSize();
    } else if (type == HMC_SIZE_DEST) {
        *poutSize = visionAsset->GetDestSize();
    }

    LOGD("assetUid size:(%f, %f)", poutSize->width, poutSize->height);

    return HMC_OK;
}

int HmcAssetSetDestSize(HmcEditor *editor, HmcUid assetUid, HmcSize size)
{
    if (editor == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    PreviewStateControl(editor);

    LOGD("assetUid: %s, new size: (%f, %f)", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN), size.width,
        size.height);

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("invalid asset uid");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    HmcAssetType type = asset->GetType();
    if (!HmcAssetUtils::IsVisionAsset(type)) {
        LOGE("invalid asset type: %d", type);
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    auto visionAsset = (HmcVisionAsset *)asset;
    visionAsset->SetDestSize(size);

    return HMC_OK;
}

int HmcAssetGetVertexPosition(HmcEditor *editor, HmcUid assetUid, float *output, unsigned outputSize)
{
    if (output == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR;
    }
    LOGD("assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("Get asset failed: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
        return HMC_ERR;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("Invalid asset type: %d", asset->GetType());
        return HMC_ERR;
    }

    auto visionAsset = (HmcVisionAsset *)asset;
    VECTOR<FLOAT> vertex = visionAsset->GetVertexPosition();
    for (size_t i = 0; i < vertex.size(); i++) {
        output[i] = vertex[i];
    }
    return HMC_OK;
}

void HmcAssetGetFilter(HmcEditor *editor, HmcUid assetUid, HmcDict *dict)
{
    if (editor == nullptr) {
        LOGE("%s error, editor is nullptr", __FUNCTION__);
        return;
    }
    LOGD("assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
    IHmcAsset *asset = GetAsset(assetUid);
    if (asset) {
        asset->GetAssetParamValue(dict);
    }
}

int HmcGetAssetName(HmcEditor *editor, HmcUid assetUid, char *name, int size)
{
    if (editor == nullptr || name == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }
    LOGD("AssetUid: %s.", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("GetAsset() failed, Invalid asset: %s!", uidStr);
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    STRING assetName = asset->GetName();
    LOGD("asset name: %s.", assetName.c_str());
    errno_t rc = strcpy_s(name, size, assetName.c_str());
    if (rc != EOK) {
        LOGE("Copy name failed: %d", rc);
        return HMC_ERR;
    }

    return HMC_OK;
}

int HmcGetAssetResource(HmcEditor *editor, HmcUid assetUid, char *path, int size)
{
    if (editor == nullptr || path == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }
    LOGD("AssetUid: %s.", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));
    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("GetAsset() failed, Invalid asset: %s!", uidStr);
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    STRING assetPath = asset->GetPath();
    LOGD("asset path: %s.", assetPath.c_str());
    errno_t rc = strcpy_s(path, size, assetPath.c_str());
    if (rc != EOK) {
        LOGE("Copy path failed: %d", rc);
        return HMC_ERR;
    }

    return HMC_OK;
}

int HmcAssetSetMute(HmcEditor *editor, HmcUid assetUid, int mute)
{
    if (editor == nullptr) {
        LOGE("Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    BOOL isMute = (mute ? TRUE : FALSE);

    char assetUidStr[HMC_UID_STR_LEN] = {0};
    LOGI("Set asset mute: %d assetUid: %s", mute, HmcUidToString(&assetUid, assetUidStr, HMC_UID_STR_LEN));
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("invalid asset uid: %s", assetUidStr);
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    return HMC_OK;
}

int HmcAssetIsMute(HmcEditor *editor, HmcUid assetUid, int *mute)
{
    if (editor == nullptr || mute == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("not find asset.");
        return HMC_ERR_PARAM;
    }

    LOGI("Get asset mute");

    int result = HMC_OK;
    HmcAssetType type = asset->GetType();
    if (type == HMC_ASSET_IMAGE) {
        *mute = 0;
    } else {
        LOGE("invalid asset type :%d", type);
        result = HMC_ERR;
    }

    return result;
}

int HmcAssetChangeSoundType(HmcEditor *editor, HmcUid assetUid, HmcAudioSoundType soundType)
{
    HMC_EDITOR_SETTER(editor);

    return HMC_ERR;
}

int HmcAssetGetSoundType(HmcEditor *editor, HmcUid assetUid, HmcAudioSoundType *soundType)
{
    if (editor == nullptr || soundType == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    return HMC_ERR;
}

int HmcAssetSetPitch(HmcEditor *editor, HmcUid assetUid, float pitch)
{
    HMC_EDITOR_SETTER(editor);

    return HMC_ERR;
}

int HmcAssetGetPitch(HmcEditor *editor, HmcUid assetUid, float *pitch)
{
    if (editor == nullptr || pitch == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    return HMC_ERR;
}

int HmcGetFadeInTimeMs(HmcEditor *editor, HmcUid assetUid, unsigned int *fadeInTimeMs)
{
    if (editor == nullptr || fadeInTimeMs == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("not find asset.");
        return HMC_ERR_PARAM;
    }

    return HMC_OK;
}

int HmcGetFadeInDurationMs(HmcEditor *editor, HmcUid assetUid, unsigned int *fadeInDurationMs)
{
    if (editor == nullptr || fadeInDurationMs == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("HmcGetFadeInDurationMs, not find asset.");
        return HMC_ERR_PARAM;
    }

    int result = HMC_OK;
    return result;
}

int HmcGetFadeOutTimeMs(HmcEditor *editor, HmcUid assetUid, unsigned int *fadeOutTimeMs)
{
    if (editor == nullptr || fadeOutTimeMs == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("HmcGetFadeOutTimeMs, not find asset.");
        return HMC_ERR_PARAM;
    }

    int result = HMC_OK;
    return result;
}

int HmcGetFadeOutDurationMs(HmcEditor *editor, HmcUid assetUid, unsigned int *fadeOutDurationMs)
{
    if (editor == nullptr || fadeOutDurationMs == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("HmcGetFadeOutDurationMs, not find asset.");
        return HMC_ERR_PARAM;
    }

    int result = HMC_OK;
    return result;
}

int HmcSetFadeInTimeMs(HmcEditor *editor, HmcUid assetUid, unsigned int fadeInTimeMs, unsigned int fadeInDurationMs)
{
    HMC_EDITOR_SETTER(editor);

    char assetUidStr[HMC_UID_STR_LEN] = {0};
    LOGI("Set asset fadein timeMs: %d assetUid: %s", fadeInDurationMs,
        HmcUidToString(&assetUid, assetUidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("invalid asset uid: %s", assetUidStr);
        return HMC_ERR_PARAM;
    }

    int result = HMC_OK;
    return result;
}

int HmcSetFadeOutTimeMs(HmcEditor *editor, HmcUid assetUid, unsigned int fadeOutTimeMs, unsigned int fadeOutDurationMs)
{
    HMC_EDITOR_SETTER(editor);

    char assetUidStr[HMC_UID_STR_LEN] = {0};
    LOGI("Set asset fadeout timeMs: %d assetUid: %s", fadeOutDurationMs,
        HmcUidToString(&assetUid, assetUidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("invalid asset uid: %s", assetUidStr);
        return HMC_ERR_PARAM;
    }

    int result = HMC_OK;
    return result;
}

int HmcAssetGetMirror(HmcEditor *editor, HmcUid assetUid, HmcAssetMirrorType type, int *mirror)
{
    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    } else if (mirror == nullptr) {
        LOGE("error, mirror is nullptr");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("get asset failed by asset uid");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not vision asset, no mirror");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (type == HMC_ASSET_MIRROR_VERTICAL) {
        *mirror = visionAsset->GetMirrorVertical();
        return HMC_OK;
    } else if (type == HMC_ASSET_MIRROR_HORIZONTAL) {
        *mirror = visionAsset->GetMirrorHorizontal();
        return HMC_OK;
    } else {
        LOGE("invalid type: %d", type);
        return HMC_ERR_PARAM;
    }
}

int HmcAssetSetMirror(HmcEditor *editor, HmcUid assetUid, int mirror, HmcAssetMirrorType type)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    LOGD("AssetUid: %s, mirror: %d, type: %d.", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN), mirror, type);

    auto asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("Invalid asset type.");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    auto visionAsset = (HmcVisionAsset *)asset;
    if (type == HMC_ASSET_MIRROR_HORIZONTAL) {
        visionAsset->SetMirrorHorizontal(mirror);
    } else if (type == HMC_ASSET_MIRROR_VERTICAL) {
        visionAsset->SetMirrorVertical(mirror);
    } else {
        LOGE("Invalid parameter mirror type: %d.", type);
        return HMC_ERR_PARAM;
    }

    return HMC_OK;
}

VOID SetCropDict(HmcDict *dict, HmcAssetCropPosition *position, HmcVisionAsset *visionAsset)
{
    if (dict == nullptr || position == nullptr || visionAsset == nullptr) {
        return;
    }

    HmcDictSetString(dict, DICT_KEY_EFFECT_NAME, DICT_KEY_TRANSFORM_NAME);
    HmcDictSetInt32(dict, DICT_KEY_EFFECT_TYPE, HMC_EFFECT_TRANSFORM);
    HmcDictSetDouble(dict, DICT_KEY_CROP_LEFTBOTTOM_X, (double)position->leftBottom.x);
    HmcDictSetDouble(dict, DICT_KEY_CROP_LEFTBOTTOM_Y, (double)position->leftBottom.y);
    HmcDictSetDouble(dict, DICT_KEY_CROP_RIGHTBOTTOM_X, (double)position->rightBottom.x);
    HmcDictSetDouble(dict, DICT_KEY_CROP_RIGHTBOTTOM_Y, (double)position->rightBottom.y);
    HmcDictSetDouble(dict, DICT_KEY_CROP_LEFTTOP_X, (double)position->leftTop.x);
    HmcDictSetDouble(dict, DICT_KEY_CROP_LEFTTOP_Y, (double)position->leftTop.y);
    HmcDictSetDouble(dict, DICT_KEY_CROP_RIGHTTOP_X, (double)position->rightTop.x);
    HmcDictSetDouble(dict, DICT_KEY_CROP_RIGHTTOP_Y, (double)position->rightTop.y);
}

int HmcAssetCrop(HmcEditor *editor, HmcUid assetUid, HmcAssetCropPosition *position)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr || position == nullptr) {
        LOGE("HmcAssetCrop, Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    HmcDict *dict = HmcDictCreate();
    SetCropDict(dict, position, visionAsset);

    VECTOR<HmcUid> transformEffectList;
    visionAsset->GetEffectList(transformEffectList, HMC_EFFECT_TRANSFORM);
    if (!transformEffectList.empty()) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(transformEffectList[0]);
        if (effect != nullptr) {
            effect->SetEffectParameter(dict);
        }
    } else {
        HmcUid effectUid = visionAsset->AddEffect(dict);
        if (HmcUidIsNull(&effectUid)) {
            LOGE("HmcAssetCrop, effectUid is null!");
            HmcDictDestroy(dict);
            return HMC_ERR;
        }
    }

    HmcDictDestroy(dict);

    return HMC_OK;
}

int HmcAssetCropTransformSetCrop(HmcEditor *editor, HmcUid assetUid, HmcAssetCropPosition *position)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr || position == nullptr) {
        LOGE("HmcAssetCropTransformSetCrop, Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    HmcDict *dict = HmcDictCreate();
    HmcDictSetInt32(dict, DICT_KEY_EFFECT_TYPE, HMC_EFFECT_TRANSFORM);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_LB_X, (double)position->leftBottom.x);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_LB_Y, (double)position->leftBottom.y);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_RT_X, (double)position->rightTop.x);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_RT_Y, (double)position->rightTop.y);

    VECTOR<HmcUid> cropEffectList;
    visionAsset->GetEffectList(cropEffectList, HMC_EFFECT_TRANSFORM);
    if (!cropEffectList.empty()) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(cropEffectList[0]);
        if (effect != nullptr) {
            effect->SetEffectParameter(dict);
        }
    } else {
        HmcUid effectUid = visionAsset->AddEffect(dict);
        if (HmcUidIsNull(&effectUid)) {
            LOGE("HmcAssetCropTransformSetCrop, effectUid is null!");
            HmcDictDestroy(dict);
            return HMC_ERR;
        }
    }

    HmcDictDestroy(dict);
    return HMC_OK;
}

int HmcAssetSetWatermark(HmcUid assetUid, WatermarkParam watermarkParam)
{
    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        LOGE("visionAsset is null.");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    
    HmcDict *dict = HmcDictCreate();
    HmcDictSetDouble(dict, PROJECT_KEY_WATERMARK_OPACITY, watermarkParam.watermarkOpacity);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_TYPE, watermarkParam.watermarkType);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_EXPORTW, watermarkParam.exportW);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_EXPORTH, watermarkParam.exportH);
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_ALWAYS_SHOW, watermarkParam.isAlwaysShow);

    VECTOR<HmcUid> cropEffectList;
    LOGI("setWatermarkEffectParameter, begin");
    if (!cropEffectList.empty()) {
        LOGI("setWatermarkEffectParameter, watermark effect is exist");
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(cropEffectList[0]);
        if (effect != nullptr) {
            effect->SetEffectParameter(dict);
        }
    } else {
        HmcUid effectUid = visionAsset->AddEffect(dict);
        if (HmcUidIsNull(&effectUid)) {
            LOGE("HmcAssetCropTransformSetCrop, effectUid is null!");
            HmcDictDestroy(dict);
            return HMC_ERR;
        }
    }

    HmcDictDestroy(dict);
    return HMC_OK;
}

int HmcAssetSetWatermarkXtStyleParam(HmcUid assetUid, bool isContainXtStyle,
                                     STRING xtStyleCode, STRING xtColor, STRING xtStyleText)
{
    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        LOGE("visionAsset is null.");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    VECTOR<HmcUid> cropEffectList;
    LOGI("setWatermarkEffectParameter, begin");
    if (cropEffectList.empty()) {
        return HMC_ERR;
    }
    LOGI("setWatermarkEffectParameter, watermark effect is exist");
    auto effect = SINGLETON(HmcUidAdmin)->GetEffect(cropEffectList[0]);
    if (effect == nullptr) {
        return HMC_ERR;
    }
    HmcDict *dict = HmcDictCreate();
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_XT_PARAM, xtStyleCode.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_XT_DEFINITION, xtStyleText.c_str());
    HmcDictSetString(dict, PROJECT_KEY_WATERMARK_FILTER_XT_COLOR, xtColor.c_str());
    HmcDictSetInt32(dict, PROJECT_KEY_WATERMARK_IS_CONTAIN_XT_STYLE, isContainXtStyle);
    effect->SetEffectParameter(dict);
    HmcDictDestroy(dict);
    return HMC_OK;
}

int HmcAssetCropTransformSetPosition(HmcEditor *editor, HmcUid assetUid, float x, float y, float scaleX, float scaleY,
    float rotate)
{
    if (editor == nullptr) {
        LOGE("HmcAssetCropTransformSetPosition, Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    PreviewStateControl(editor);

    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        LOGE("HmcAssetCropTransformSetPosition, visionAsset is null!");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    HmcDict *dict = HmcDictCreate();
    HmcDictSetInt32(dict, DICT_KEY_EFFECT_TYPE, HMC_EFFECT_TRANSFORM);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_OFFSET_X, (double)x);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y, (double)y);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_SCALE_X, (double)scaleX);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_SCALE_Y, (double)scaleY);
    HmcDictSetDouble(dict, PROJECT_KEY_TRANSFORM_CROP_ROTATION, (double)rotate);

    VECTOR<HmcUid> cropEffectList;
    visionAsset->GetEffectList(cropEffectList, HMC_EFFECT_TRANSFORM);
    if (!cropEffectList.empty()) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(cropEffectList[0]);
        if (effect != nullptr) {
            effect->SetEffectParameter(dict);
        }
    } else {
        HmcUid effectUid = visionAsset->AddEffect(dict);
        if (HmcUidIsNull(&effectUid)) {
            LOGE("HmcAssetCropTransformSetPosition, effectUid is null!");
            HmcDictDestroy(dict);
            return HMC_ERR;
        }
    }

    HmcDictDestroy(dict);
    return HMC_OK;
}

int HmcAssetSetCropPosition(HmcUid assetUid, float topLeftX, float topLeftY, float bottomRightX,
    float bottomRightY)
{
    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        LOGE("HmcAssetSetCropPosition, visionAsset is null!");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    visionAsset->setCropPosition(topLeftX, topLeftY, bottomRightX, bottomRightY);
    return HMC_OK;
}

int HmcAssetGetBackward(HmcEditor * /* editor */, HmcUid assetUid)
{
    constexpr INT32 GETBACKWARD_ERROR_CODE = -1;

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("not find asset");
        return GETBACKWARD_ERROR_CODE;
    }

    return asset->GetBackward() ? 1 : 0;
}

int HmcAssetSetBackward(HmcEditor *editor, HmcUid assetUid, int isBackward)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("error, editor is nullptr");
        return HMC_ERR_PARAM;
    }

    LOGD("assetUid:%s, isBackward:%d", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN), isBackward);

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (asset == nullptr) {
        LOGE("not find asset");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (asset->SetBackward(isBackward) == FALSE) {
        return HMC_ERR;
    }

    return HMC_OK;
}

HmcImage *HmcAssetGetImageByBlurred(HmcEditor *editor, HmcUid assetUid, int64_t timeStamp, unsigned int strength)
{
    HMC_UNUSED(editor);

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return nullptr;
    }

    if (asset->GetType() != HMC_ASSET_IMAGE) {
        LOGE("Invalid asset type.");
        return nullptr;
    }

    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset != nullptr) {
        return visionAsset->GetImageByBlurred(timeStamp, strength);
    }

    return nullptr;
}

int HmcAssetIsInCurrentTime(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("editor is null");
        return 0;
    }
    HmcEditorImp *editorImp = static_cast<HmcEditorImp *>(editor);
    auto currTime = editorImp->GetCurrentTimeline();

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return 0;
    }

    return asset->IsDrawable(currTime);
}

int HmcAssetDelayInit(HmcEditor *editor, HmcUid assetUid)
{
    HMC_UNUSED(editor);

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    asset->DelayInit();

    return HMC_OK;
}

int32_t HmcAssetReplaceSource(HmcEditor *editor, HmcDict *dict, HmcUid laneUid, const std::string path)
{
    IHmcLane *lane = SINGLETON(HmcUidAdmin)->GetLane(laneUid);
    if (lane == nullptr) {
        LOGE("lane is invalid, please check your lane id");
        return HMC_ERR;
    }

    int32_t res = lane->ReplaceSource(dict, path);
    if (res == HMC_OK) {
        // 云图场景要确保原图path替换成功，才能flush
        HMC_EDITOR_SETTER(editor, true);
    }
    return res;
}

int32_t HmcAssetSetPreviewMode(HmcEditor *editor, HmcUid assetUid, bool isInPreviewMode)
{
    if (editor == nullptr) {
        LOGE("HmcAssetSetPreviewMode, Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        LOGE("HmcAssetSetPreviewMode, visionAsset is null!");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    visionAsset->SetPreviewMode(isInPreviewMode);
    return HMC_OK;
}

int32_t HmcAssetSetIsSwitchPage(HmcEditor *editor, HmcUid assetUid, bool isSwitchPage)
{
    if (editor == nullptr) {
        LOGE("HmcAssetSetIsSwitchPage, Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        LOGE("HmcAssetSetIsSwitchPage, visionAsset is null!");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    visionAsset->SetIsSwitchPage(isSwitchPage);
    return HMC_OK;
}

int32_t HmcAssetSetDrawWaterMarkValue(HmcEditor *editor, HmcUid assetUid, bool isDrawWaterMark)
{
    if (editor == nullptr) {
        LOGE("HmcAssetSetDrawWaterMark, Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        LOGE("HmcAssetSetDrawWaterMark, visionAsset is null!");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    visionAsset->SetDrawWaterMarkValue(isDrawWaterMark);
    return HMC_OK;
}

int32_t HmcAssetRefreshCompareEffectList(HmcEditor *editor, HmcUid assetUid)
{
    if (editor == nullptr) {
        LOGE("HmcAssetRefreshCompareEffectList, Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    auto imageAsset = GetImageOrVideoAsset(assetUid);
    if (imageAsset == nullptr) {
        LOGE("HmcAssetRefreshCompareEffectList, visionAsset is null!");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    ((HmcImageAsset *)imageAsset)->refreshCompareEffectList();
    return HMC_OK;
}

void HmcAssetRequestXTStyleThumbnail(HmcEditor *editor, HmcUid assetUid, std::vector<int> xtStyleParams)
{
    if (editor == nullptr) {
        LOGE("Failed do HmcAssetRequestXTStyleThumbnail, editor is nullptr");
        return;
    }
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    if (editorImp == nullptr) {
        LOGE("Failed do HmcAssetRequestXTStyleThumbnail, editorImp is nullptr");
        return;
    }

    uint64_t currentTimeline = editorImp->GetCurrentTimeline();
    IHmcAsset *asset = GetAsset(assetUid);
    if (!asset) {
        LOGE("Failed do HmcAssetRequestXTStyleThumbnail, asset is nullptr");
        return;
    }

    LOGD("HmcAssetRequestXTStyleThumbnail start currentTimeline=%ld", currentTimeline);

    // 获取当前preview
    HmcAssetType type = asset->GetType();
    LOGD("HmcAssetRequestXTStyleThumbnail type = %d", type);
    HmcImage *hmcImage = nullptr;
    if (type == HMC_ASSET_IMAGE) {
        hmcImage = ((HmcImageAsset *)asset)->GetPreview(currentTimeline);
    }
    LOGD("HmcAssetRequestXTStyleThumbnail finish get hmcImage currentTimeline=%ld, type=%d", currentTimeline, type);
}

int32_t HmcAssetSetIsDragImage(HmcEditor *editor, HmcUid assetUid, bool isDragImage)
{
    if (editor == nullptr) {
        LOGE("HmcAssetSetIsDragImage, Invalid parameter!");
        return HMC_ERR_PARAM;
    }

    auto visionAsset = GetImageOrVideoAsset(assetUid);
    if (visionAsset == nullptr) {
        LOGE("HmcAssetSetIsDragImage, visionAsset is null!");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    visionAsset->SetIsDragImage(isDragImage);
    return HMC_OK;
}
