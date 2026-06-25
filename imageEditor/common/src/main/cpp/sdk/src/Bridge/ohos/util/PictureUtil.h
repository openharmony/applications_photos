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
#ifndef NEWPHOTOS_PICTUREUTIL_H
#define NEWPHOTOS_PICTUREUTIL_H

#include <initializer_list>
#include <multimedia/image_framework/image/picture_native.h>
#include <string>
#include "PixelmapUtil.h"
#include "HmcBaseType.h"
#include "ohos/util/PictureDeleter.h"

class PictureUtil {
public:
    static void CopyAllMetadata(OH_PictureNative *srcPicture, OH_PictureNative *destPicture);
    static void CopyMetaData(OH_PictureNative *srcPicture, OH_PictureNative *destPicture,
                             std::initializer_list<Image_MetadataType> metadataTypes);
    static void CopyMetaData(OH_PictureNative *srcPicture, OH_PictureNative *destPicture,
                             Image_MetadataType metadataType);
    static int CloneAuxiliaryPicture(OH_PictureNative *srcPicture, OH_PictureNative *dstPicture,
                                     Image_AuxiliaryPictureType auxiliaryPictureType, float scale);
    static int CopyAuxiliaryPicture(OH_PictureNative *srcPicture, OH_PictureNative *dstPicture,
                                    Image_AuxiliaryPictureType auxiliaryPictureType);
    static void DumpPicture(OH_PictureNative *picture, std::string key);
    static void DumpPictureMain(OH_PictureNative *picture, std::string key);
    static void DumpPictureGain(OH_PictureNative *picture, std::string key);
    static void DumpPictureHdrComposed(OH_PictureNative *picture, std::string key);
    static void DumpAllAuxiliaryPicture(OH_PictureNative *picture, const STRING &key);
    static void DumpAuxiliaryPicture(OH_PictureNative *picture, Image_AuxiliaryPictureType type, const STRING &key);
    
    static PixelmapInfo GetMainPixelmapInfo(OH_PictureNative *picture);
    static UNIQUE_PTR<OH_PixelmapNative, OH_PixelmapNativeDeleter> GetMainPixelmapUniquePtr(OH_PictureNative *picture);
    static void UpdatePictureAuxiliaryByGainMap(OH_PictureNative *picture);
    static void UpdatePictureAuxiliaryInfo(OH_AuxiliaryPictureNative *picture, PixelmapInfo pixelmapInfo);
    static void TryUpdateExifSize(OH_PictureNative *picture);
    static void DumpAuxiliaryPicture(OH_PictureNative *srcPicture,std::string key,Image_AuxiliaryPictureType type);
    static bool IsHdr(OH_PictureNative *picture);
    static void CopyPictureMetadata(OH_PictureNative *srcPicture, OH_PictureNative *outPicture);
    static void CopyMainNativeBuffer(OH_PictureNative *srcPicture, OH_PictureNative *outPicture);
    static void CopyGainNativeBuffer(OH_PictureNative *srcPicture, OH_PictureNative *outPicture);
    static float ScalePicture(OH_PictureNative *srcPicture, uint32_t maxSize);
    static bool UpdateMetaData(OH_PictureNative *picture);
    static OH_PictureNative *CopyMainAsPicture(OH_PictureNative *&srcPicture);
    static void CopyAuxiliaryGainMap(OH_PictureNative *&srcPicture, OH_PictureNative *&dstPicture);
    static OH_PictureNative *CloneDmaPicture(OH_PictureNative *&srcPicture);
    static PixelmapInfo GetAuxiliaryPictureSize(std::shared_ptr<OH_AuxiliaryPictureNative> &gainMap);
    static bool TryCloneGainmap(OH_PictureNative *&srcPicture, OH_PictureNative *&dstPicture);
    static bool ReadMainPixelMapData(OH_PictureNative *srcPicture, uint8_t *data, size_t size);
    static void CloneAuxiliaryPicture(OH_PictureNative *srcPicture, OH_PictureNative *dstPicture,
        const VECTOR<int> &auxiliaryTypes);
    static bool GetPictureContainAuxiliaries(OH_PictureNative *srcPicture, uint32_t &size,
        SHARED_PTR<Image_AuxiliaryPictureType[]> &auxiliaryTypes);
    static bool GetPictureContainMetadatas(OH_PictureNative *srcPicture, uint32_t &size,
        SHARED_PTR<Image_MetadataType[]> &metaDataTypes);
    static void UpDateMetadata(OH_PictureNative *srcPicture, Image_MetadataType srcType, OH_PictureNative *dstPicture,
        Image_MetadataType dstType);
    static void PrintPictureAuxiliaries(OH_PictureNative *srcPicture);
    static void PrintPictureMetadatas(OH_PictureNative *srcPicture);
    static bool GetAuxiliaryInfoByType(OH_PictureNative *picture, Image_AuxiliaryPictureType type, PixelmapInfo &info);
    static void PrintPictureInfo(OH_PictureNative *picture);
    static STRING getCurrentTimeString(const std::string& format = "%Y-%m-%d_%H-%M-%S");
    static OH_PictureNative *ConvertSnapToMain(OH_PictureNative *picture);
private:
    static OH_AuxiliaryPictureNative *CloneAuxiliaryPicture(OH_AuxiliaryPictureNative *auxiliary);
    static OH_AuxiliaryPictureNative *ScaleAuxiliaryPicture(OH_AuxiliaryPictureNative *auxiliaryPicture, float scale);
};

#endif //NEWPHOTOS_PICTUREUTIL_H
