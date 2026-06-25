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

/* instrument ignore file */

import lazy { common } from '@kit.AbilityKit';
import lazy { PhotoAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Log } from '../../../utils/Log';
import lazy { catchPromise, tryFunc } from '../../../utils/ErrUtil';
import lazy { image } from '@kit.ImageKit';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { Constants } from './Constants';
import lazy { PhotoProperties } from './PhotoProPerties';

const TAG: string = 'PhotoPropertiesManager';

export class PhotoPropertiesManager {
  private context: common.Context;
  private photoAccess: UserFileManagerAccess;

  constructor(context: common.Context) {
    Log.info(TAG, 'constructor');
    this.context = context;
    this.photoAccess = new UserFileManagerAccess();
    this.photoAccess.onCreate(this.context);
  }

  public async getPhotoProperties(fileAsset: PhotoAsset): Promise<PhotoProperties> {
    let filePosition: number = -1;
    if (fileAsset) {
      const position: photoAccessHelper.MemberType = fileAsset.get(photoAccessHelper.PhotoKeys.POSITION.toString());
      if (typeof position === 'number') {
        filePosition = position;
      } else {
        Log.error(TAG, 'position type not is number!');
      }
    }
    let isHdrVideo: number = 0;
    if (fileAsset?.photoType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      isHdrVideo = await this.getVideoProperty(fileAsset);
      return new PhotoProperties(filePosition, undefined, isHdrVideo);
    }

    let imageProperties: Record<PropertyKey, string> | undefined = undefined;
    if (filePosition !== photoAccessHelper.PositionType.CLOUD) {
      imageProperties = await this.getImageProperty(fileAsset);
    }
    return new PhotoProperties(filePosition, imageProperties, isHdrVideo);
  }

  private async getImageProperty(fileAsset: PhotoAsset | undefined): Promise<Record<PropertyKey, string> |
  undefined> {
    let openAsset = this.photoAccess?.openAsset;
    if (!openAsset) {
      return undefined;
    }
    let openAssetFunc: Function = async (mode: string, fileAsset: PhotoAsset):
      Promise<number> => await openAsset(mode, fileAsset);
    let fd: number = -1;
    fd = await catchPromise<number>(openAssetFunc('R', fileAsset));
    if (fd < 0) {
      Log.error(TAG, 'fd invalid');
      return undefined;
    }
    let api: image.ImageSource | undefined = undefined;
    api = tryFunc<image.ImageSource, number>(((f: number): image.ImageSource => image.createImageSource?.(f)), fd);
    Log.info(TAG, `open asset, asset is ${fileAsset?.displayName}, ${Log.stringify<Object>({ fd, api })}`);
    if (!api) {
      Log.error(TAG, 'create image source failed');
      return;
    }
    Log.info(TAG, `api.supportedFormats: ${api.supportedFormats}`);

    TraceControllerUtils.startTrace('getExifImageProperties');
    let imageProperties: Record<PropertyKey, string> =
      await catchPromise<Record<PropertyKey, string>>(api.getImageProperties(Constants.EXIF_ARRAY));
    TraceControllerUtils.finishTrace('getExifImageProperties');
    TraceControllerUtils.startTrace('getDragonFruitImageProperties');
    let xtStyleTemplateName: string =
      await catchPromise<string>(api.getImageProperty(Constants.XT_STYLE_TEMPLATE_NAME));
    let xtStyleCustomHue: string = await catchPromise<string>(api.getImageProperty(Constants.XT_STYLE_CUSTOM_HUE));
    let xtStyleCustomSaturation: string =
      await catchPromise<string>(api.getImageProperty(Constants.XT_STYLE_CUSTOM_SATURATION));
    let xtStyleCustomLightAndShadow: string =
      await catchPromise<string>(api.getImageProperty(Constants.XT_STYLE_CUSTOM_LIGHT_AND_SHADOW));
    let xMageColorMode: string = await catchPromise<string>(api.getImageProperty(Constants.X_MAGE_COLOR_MODE));
    TraceControllerUtils.finishTrace('getDragonFruitImageProperties');
    if (xtStyleTemplateName || xMageColorMode) {
      imageProperties[Constants.XT_STYLE_TEMPLATE_NAME] = xtStyleTemplateName;
      imageProperties[Constants.XT_STYLE_CUSTOM_HUE] = xtStyleCustomHue;
      imageProperties[Constants.XT_STYLE_CUSTOM_SATURATION] = xtStyleCustomSaturation;
      imageProperties[Constants.XT_STYLE_CUSTOM_LIGHT_AND_SHADOW] = xtStyleCustomLightAndShadow;
      imageProperties[Constants.X_MAGE_COLOR_MODE] = xMageColorMode;
    }
    Log.info(TAG,
      `get imageProperties success, displayName:${fileAsset?.displayName}, imageProperties:${JSON.stringify(imageProperties)}`);
    TraceControllerUtils.startTrace('ImagePropertiesApiRelease');
    await api.release();
    TraceControllerUtils.finishTrace('ImagePropertiesApiRelease');
    this.photoAccess?.closeAsset(fd, fileAsset);
    return imageProperties;
  }

  private async getVideoProperty(fileAsset: PhotoAsset | undefined): Promise<number> {
    let isHdrVideo: number = 0;
    if (!fileAsset) {
      Log.error(TAG, 'getVideoProperty: fileAsset is undefined!');
      return isHdrVideo;
    }
    let dynamicRangeType: photoAccessHelper.MemberType = fileAsset.get(photoAccessHelper.PhotoKeys.DYNAMIC_RANGE_TYPE);
    Log.info(TAG, `dynamicRangeType: ${dynamicRangeType}`);
    if (typeof dynamicRangeType === 'number') {
      isHdrVideo = dynamicRangeType;
    } else {
      Log.error(TAG, 'dynamicRangeType type not is number!');
    }
    return isHdrVideo;
  }
}