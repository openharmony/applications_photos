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

#include "HveComposeCommand.h"
#include "MediaCreative/HmcEditorEffect.h"
#include "MediaCreative/HmcError.h"
#include "ohos/BackgroundTaskManager.h"
static const int ROTATION_90 = 90;
static const int ROTATION_270 = 270;
static const uint32_t PIXEL_LENGTH_RGBA8888 = 4;

HveCmdCompose::HveCmdCompose(int timelineId, std::string const & type, std::string const & assetId, void *pixelBuffer,
    int x, int y, int width, int height)
    : HveCommand(timelineId, type, assetId),
      pixelBuffer(pixelBuffer),
      type(type),
      x(x),
      y(y),
      width(width),
      height(height)
{}

HveCmdCompose::~HveCmdCompose() {}

int HveCmdCompose::Execute() {}

int HveCmdCompose::Execute(std::function<void(napi_value value)> cb)
{
    USE_ASSET(HMC_ERR);
    LOGI("UndoRedo HveCmdCompose Execute");
    BACKGROUND_TASK_MGR->Submit(
        [this]() {
            if (IsEditorSwitchEnable(EDITOR_DEBUG_ENABLE)) {
                NativePixelMap *pixelMap = (NativePixelMap *)pixelBuffer;
                void *addrPtr = nullptr;
                OH_PixelMap_AccessPixels(pixelMap, &addrPtr);
                std::string fileName = "/data/storage/el2/base/files/OnComposeDst_w" + std::to_string(width) + "_h" +
                    std::to_string(height) + ".dat";
                DumpBuffer((uint8_t *)addrPtr, width * height * PIXEL_LENGTH_RGBA8888, fileName);
            }
        },
        __FUNCTION__);
    return ComStylus(timelineId, assetId, cb);
}
std::string HveCmdCompose::Undo() {}
std::string HveCmdCompose::Redo() {}
int HveCmdCompose::ComStylus(int timelineId, std::string const & assetId, std::function<void(napi_value value)> cb)
{
    USE_ASSET(HMC_ERR);
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);

    HmcDict *dict = HmcDictCreate();
    HmcDictSetInt32(dict, DICT_KEY_EFFECT_TYPE, HMC_EFFECT_COMPOSE);
    HmcDictSetPointer(dict, "dst_bmp", pixelBuffer);
    HmcDictSetInt32(dict, "dst_rect_left", x);
    HmcDictSetInt32(dict, "dst_rect_top", y);
    HmcDictSetInt32(dict, "dst_rect_width", width);
    HmcDictSetInt32(dict, "dst_rect_height", height);

    auto cropRect = timeline->GetCropRect();
    HmcSize assetSize;
    HmcAssetGetSize(timeline->GetEditor(), assetUid, HMC_SIZE_RENDER, &assetSize);

    HmcDictSetDouble(dict, "dst_scale_x", cropRect.Width() / assetSize.width);
    HmcDictSetDouble(dict, "dst_scale_y", cropRect.Height() / assetSize.height);
    LOGI("x:%d, y:%d, width:%d, height:%d, dst_scale_x:%lf, dst_scale_y:%lf", x, y, width, height,
        cropRect.Width() / assetSize.width, cropRect.Height() / assetSize.height);

    HmcUid effectId;
    int ret = HmcEffectAdd(editor, assetUid, dict, &effectId);
    ComposeTimeline(timelineId, assetId, HMC_ASSET_IMAGE, effectId, cb);
    if (ret != HMC_OK) {
        LOGE("HmcEffectAdd failed, ret=%d", ret);
        HmcDictDestroy(dict);
        return -1;
    }
    HmcDictDestroy(dict);
    return HMC_OK;
}
int HveCmdCompose::Merge() {}

static bool AssetSizeIsExchanged3(float baseRotation)
{
    if (baseRotation == ROTATION_90 || baseRotation == ROTATION_270) {
        return true;
    }
    return false;
}

static void SetPictureHmcDict(HmcDictHelper &dict, std::string const assetId, INT32 exportW, INT32 exportH,
    auto cropRect)
{
    // picture need set below parameters
    dict[PROJECT_KEY_IMAGE_EXPORT_PATH] = "";
    dict[PROJECT_KEY_MEDIA_EXPORT_TYPE] = HMC_EXPORT_MEDIA_TYPE_IMAGE;
    dict[PROJECT_KEY_ASSET_ID] = assetId;

    // video and picture all need set below parameters
    dict[PROJECT_KEY_VIDEO_WIDTH] = exportW;
    dict[PROJECT_KEY_VIDEO_HEIGHT] = exportH;
    dict["export_crop_left"] = cropRect.left;
    dict["export_crop_top"] = cropRect.top;
    dict["export_crop_right"] = cropRect.right;
    dict["export_crop_bottom"] = cropRect.bottom;
}

void HveCmdCompose::ComposeTimeline(int timelineId, std::string const & assetId, int mediaType, HmcUid effectId,
    std::function<void(napi_value value)> cb)
{
    LOGI("HveCmdCompose compileTimeline, timelineId=%d, assetId=%s, mediaType=%d", timelineId, assetId.c_str(),
        mediaType);
    USE_EDITOR()
    HmcUid assetUid = HmcUidHelper(assetId);
    auto hveAsset = timeline->GetHveAsset(assetUid);

    HmcEditorSetAutoFlush(editor, false);
    timeline->UpdateCompileParameter(true); // export更新transform

    HmcDictHelper dict;
    auto cropRect = timeline->GetCropRect();
    HmcSize originalSize;
    HmcAssetGetSize(editor, assetUid, HMC_SIZE_ORIGINAL, &originalSize);

    HmcSize assetSize;
    HmcAssetGetSize(timeline->GetEditor(), assetUid, HMC_SIZE_RENDER, &assetSize);

    //  线程中这里取值不安全，需要改成先取，通过lamdab传入的方式来比较,后面去掉2，和NAPIService冲突
    if (AssetSizeIsExchanged3(hveAsset->GetBaseRotation())) {
        std::swap(assetSize.width, assetSize.height);
        std::swap(originalSize.width, originalSize.height);
    }

    double fps = 0.0f;
    int64_t result = 0;
    INT32 bitRate = 0;
    INT32 exportW = originalSize.width;
    INT32 exportH = originalSize.height;

    double cropRectWidth = cropRect.Width();
    double cropRectHeight = cropRect.Height();
    if ((cropRectWidth > 0) && (cropRectHeight > 0) && (assetSize.width > 0) && (assetSize.height > 0)) {
        exportW = round(cropRectWidth / assetSize.width * originalSize.width);
        exportH = round(cropRectHeight / assetSize.height * originalSize.height);
    }
    HmcDictSetInt32(dict, "compose_export", 1);
    result = HmcEditorCalcWidthAndLength(exportW, exportH, mediaType);
    if (result == HMC_OK) {
        SetPictureHmcDict(dict, assetId, exportW, exportH, cropRect);

        HmcEditExportFunc func = {
            .exportType = 1,
            .exportPixelmapFunc =
                [assetUid, effectId, editor, cb](HmcPixelMapInfo *info) {
                    LOGI("compileTimeline HmcRenderExportInfoFunc end");
                    HmcEffectRemove(editor, assetUid, effectId);
                    cb(info->pixelmapNapi);
                    OH_PictureNative_Release(info->nativePicture);
                    delete info;
                    HmcEditorSetAutoFlush(editor, true);
                }
        };
        result = HmcEditorStartExporting(editor, dict, func);
    }
    LOGI("HveCmdCompose compileTimeline fps=%d, bitRate=%d, exportW=%d, exportH=%d, result=%d", fps, bitRate, exportW,
        exportH, result);
}