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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy taskpool from '@ohos.taskpool';
import lazy { common, ConfigurationConstant } from '@kit.AbilityKit';
import lazy { updateFilePositionAsync } from '../../view/PhotoPropertiesAsync';
import lazy {
  FocusModeType,
  DragonFruitTemplateNameType,
  XMageColorModeType,
  SuffixType
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { PhotoProperties } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoProPerties';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';

/* instrument ignore file */
const TAG = 'PropertiesViewModel';

const X_MAGE_COLOR_MODE_MAP: Map<string, Resource> = new Map([
  [XMageColorModeType.ORIGINAL, $r('app.string.xmage_original')],
  [XMageColorModeType.VIVID, $r('app.string.xmage_vivid')],
  [XMageColorModeType.BRIGHT, $r('app.string.xmage_bright')],
  [XMageColorModeType.MONO, $r('app.string.xmage_mono')],
]);

const LIGHT_SOURCE_ICON_MAP: Map<string, Resource> = new Map([
  ['other', $r('sys.symbol.color_temperature')],
  ['Cloudy weather', $r('sys.symbol.icloud')],
  ['Fluorescent', $r('sys.symbol.fluorescent')],
  ['Tungsten incandescent light', $r('sys.symbol.Incandescent_lamp')],
  ['Daylight', $r('sys.symbol.sun')]
]);

const WHITE_BALANCE_RES_MAP: Map<string, Resource> = new Map([
  ['other', $r('app.string.white_balance_other')],
  ['Cloudy weather', $r('app.string.white_balance_cloudy')],
  ['Fluorescent', $r('app.string.white_balance_fluorescent')],
  ['Tungsten incandescent light', $r('app.string.white_balance_tungsten_incandescent_light')],
  ['Daylight', $r('app.string.white_balance_daylight')],
  ['Auto', $r('app.string.white_balance_auto')]
]);

export abstract class PropertiesViewModel {
  public photoDate: string = '';
  public photoTime: string = '';
  public isCommentChanged: boolean = false;

  public getPhotoDateTime(timestamp: number): void {
    this.photoDate = DateUtil.getLocalizedDate(timestamp);
    this.photoTime = DateUtil.getLocalizedTime(timestamp);
  }

  public updateCommit(uri: string, photoNote: string, isHiddenAlbum: boolean | undefined) {
    Log.info(TAG, `updateCommit isCommentChanged: ${this.isCommentChanged}`);
    if (this.isCommentChanged) {
      try {
        UserFileManagerAccess.getInstance()
          .editUserComment(uri, photoNote, isHiddenAlbum);
      } catch (error) {
        Log.error(TAG, `UserFileManagerAccess error: ${error}`);
      }
      this.isCommentChanged = false;
    }
  }

  public getTemplateName(templateName: string | null): string {
    Log.info(TAG, `getTemplateName: ${templateName}`);
    if (!templateName) {
      return '';
    }
    const map: Map<string, string> = new Map([
      [DragonFruitTemplateNameType.N, 'N'],
      [DragonFruitTemplateNameType.F, 'F'],
      [DragonFruitTemplateNameType.C, 'C'],
      [DragonFruitTemplateNameType.A, 'A'],
      [DragonFruitTemplateNameType.V, 'V'],
      [DragonFruitTemplateNameType.B, 'B'],
      [DragonFruitTemplateNameType.H, 'H']
    ]);
    if (!map.has(templateName)) {
      return '';
    }
    return map.get(templateName)!;
  }

  public getXMageColorModeText(xMageColorMode: string): string {
    let colorModeText = X_MAGE_COLOR_MODE_MAP.get(xMageColorMode);
    Log.info(TAG, `getXMageColorMode:${xMageColorMode}, colorModeText:${colorModeText}`);
    return getContext().resourceManager.getStringSync(colorModeText);
  }

  public getXMageColorModeIcon(xMageColorMode: string,
    currentMode: ConfigurationConstant.ColorMode): Resource | undefined {
    Log.info(TAG, `getXMageColorModeIcon xMageColorMode:${xMageColorMode}, ColorMode:${currentMode}`);
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      if (xMageColorMode.search('0') !== -1) {
        return $r('app.media.XMAGE_Original_dark');
      } else if (xMageColorMode.search('1') !== -1) {
        return $r('app.media.XMAGE_Vivid_dark');
      } else if (xMageColorMode.search('2') !== -1) {
        return $r('app.media.XMAGE_Bright_dark');
      } else if (xMageColorMode.search('3') !== -1) {
        return $r('app.media.XMAGE_Black_And_White_dark');
      }
    } else {
      if (xMageColorMode.search('0') !== -1) {
        return $r('app.media.XMAGE_Original_light');
      } else if (xMageColorMode.search('1') !== -1) {
        return $r('app.media.XMAGE_Vivid_light');
      } else if (xMageColorMode.search('2') !== -1) {
        return $r('app.media.XMAGE_Bright_light');
      } else if (xMageColorMode.search('3') !== -1) {
        return $r('app.media.XMAGE_Black_And_White_light');
      }
    }
    return undefined;
  }

  public getPhotoFocusMode(status: string | null): string {
    Log.info(TAG, `getPhotoFocusMode:${status}`);
    switch (status) {
      case FocusModeType.AF:
        return 'AF';
      case FocusModeType.MF:
        return 'MF';
      default:
        return 'AF';
    }
  }

  public async updateFilePosition(item: MediaItem,
    dataSource: PhotoDataSource | undefined): Promise<PhotoProperties | undefined> {
    if (!item) {
      Log.error(TAG, 'item is undefined');
      return undefined;
    }
    Log.info(TAG, `item position changed: ${item.getPosition()}`);
    // 文件位置信息，目前不支持position字段变更通知，需要实时查询
    const fetchColumns: string[] =
      [photoAccessHelper.PhotoKeys.DYNAMIC_RANGE_TYPE, photoAccessHelper.PhotoKeys.POSITION];
    let fileAsset: photoAccessHelper.PhotoAsset | undefined =
      await dataSource?.fetchItemInAlbumByUri(item.uri, dataSource?.getAlbumUri() ?? '', fetchColumns);
    if (!fileAsset) {
      Log.error(TAG, 'updateFilePosition: get fileAsset undefined, return');
      return undefined;
    }
    return await taskpool.execute(
      updateFilePositionAsync, getContext(this), fileAsset) as PhotoProperties;
  }

  // public jumpToMap(location: mapCommon.LatLng | undefined): void {
  public jumpToMap(location: object | undefined): void {
    if (!location) {
      Log.error(TAG, 'location is undefined or null');
      return;
    }
    let wantParam: Record<string, Object> = {
      'sceneType': 2,
      // 'destinationLatitude': location.latitude,
      // 'destinationLongitude': location.longitude,
      'showLocation': false
    };

    let context: common.UIAbilityContext =
      LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    let abilityStartCallback: common.AbilityStartCallback = {
      onError: (code: number, name: string, message: string) => {
        Log.info(TAG, 'code:' + code + `name:` + name + `message:` + message);
      }
    }
    const startTime: number = Date.now();
    Log.info(TAG, `jumpToMap start time:${startTime}`);
    context.startAbilityByType('navigation', wantParam, abilityStartCallback, (err) => {
      if (err) {
        Log.error(TAG, 'startAbilityByType fail}');
      } else {
        Log.info(TAG, `jumpToMap success, time cost:${Date.now() - startTime}`);
      }
    });

    ReportToBigDataUtil.report(BigDataConstants.PHOTO_DETAIL_ADDRESS_CLICK);
  }

  public checkTitleInvalid(value: string): boolean {
    let passCheck = StringUtil.checkNameInvalid(value);
    if (passCheck) {
      UiUtil.showToast($r('app.string.specific_characters_not_supported'));
      return true;
    }
    if (value.trim() === '') {
      UiUtil.showToast($r('app.string.please_enter_name'));
      return true;
    }
    return false;
  }

  public checkPhotoNoteInvalid(value: string): boolean {
    if (value) {
      return !value.trim();
    }
    return false;
  }

  public getTitle(item: MediaItem): string {
    let title: string = item.getTitle();
    if (title) {
      return title;
    }
    if (!item.displayName) {
      Log.error(TAG, 'getTitle: displayName of item is undefined.');
      return '';
    }
    let index = item.displayName.lastIndexOf('.');
    return item.displayName.substr(0, index);
  }

  public getUriSuffix(item: MediaItem): string {
    if (item.uri) {
      let uriSplitArray: string[] = item.uri.split('.');
      let suffix: string = uriSplitArray[uriSplitArray.length - 1].toUpperCase();
      if (suffix === SuffixType.HEIC) {
        return SuffixType.HEIF;
      }
      return suffix;
    }
    return '';
  }

  /* instrument ignore next  */
  public getUriSuffixByMimeType(item: MediaItem): string {
    if (item?.mimeType) {
      let uriSplitArray: string[] = item.mimeType.split('/');
      let suffix: string = uriSplitArray[uriSplitArray.length - 1].toUpperCase();
      if (suffix === SuffixType.HEIC) {
        return SuffixType.HEIF;
      } else if (suffix === 'JPEG') {
        return 'JPG';
      }
      return suffix;
    }
    return this.getUriSuffix(item);
  }

  public getLightSourceIcon(lightSource: string): Resource {
    return LIGHT_SOURCE_ICON_MAP.get(lightSource) ?? $r('sys.symbol.color_temperature');
  }

  public getWhiteBalanceText(lightSource: string): string {
    let res = WHITE_BALANCE_RES_MAP.get(lightSource) ?? $r('app.string.white_balance_other');
    return getContext().resourceManager.getStringSync($r('app.string.white_balance'),
      getContext().resourceManager.getStringSync(res));
  }

  public getAutoBalanceText(): string {
    return getContext().resourceManager.getStringSync(
      $r('app.string.white_balance'), getContext().resourceManager.getStringSync($r('app.string.white_balance_auto')));
  }

  public getFlashText(flash: string) {
    if (flash.search('return light detected') !== -1) {
      return getContext().resourceManager.getStringSync($r('app.string.camera_flash_steady'));
    } else if (flash.search('auto mode') !== -1) {
      return getContext().resourceManager.getStringSync($r('app.string.camera_flash_auto'));
    } else if (flash.search('Flash fired') !== -1) {
      return getContext().resourceManager.getStringSync($r('app.string.camera_flash_on'));
    } else if (flash.search('Flash did not fire') !== -1) {
      return getContext().resourceManager.getStringSync($r('app.string.camera_flash_off'));
    }
    return '';
  }

  public getMeteringModeText(meteringMode: string): string {
    if (meteringMode === 'Pattern') {
      return getContext().resourceManager.getStringSync($r('app.string.camera_metering_center_weighted'));
    }
    if (meteringMode === 'Center-weighted average') {
      return getContext().resourceManager.getStringSync($r('app.string.camera_metering_field'));
    }
    if (meteringMode === 'Spot') {
      return getContext().resourceManager.getStringSync($r('app.string.camera_metering_spot'));
    }
    return '';
  }

  public getFlashIcon(flash: string) {
    if (flash.search('return light detected') !== -1) {
      return $r('sys.symbol.lightbulb_1');
    } else if (flash.search('auto mode') !== -1) {
      return $r('sys.symbol.camera_flash_auto');
    } else if (flash.search('Flash fired') !== -1) {
      return $r('sys.symbol.camera_flash');
    } else if (flash.search('Flash did not fire') !== -1) {
      return $r('sys.symbol.camera_flash_slash');
    }

    return undefined;
  }

  public getMeteringModeIcon(meteringMode: string) {
    if (meteringMode === 'Pattern') {
      return $r('sys.symbol.camera_metering_center_weighted');
    }
    if (meteringMode === 'Center-weighted average') {
      return $r('sys.symbol.camera_metering_field');

    }
    if (meteringMode === 'Spot') {
      return $r('sys.symbol.camera_metering_spot');
    }

    return undefined;
  }

  // 计算人像大小
  public getOneThirdItemWidth(imageFaceDataSize: number): Length {
    // PC或者长度小于3时，人像大小占总宽度度的三分之一
    const marginLen: Length = (Constants.SCROLL_BAR_SIDE_MIN_GAP + Constants.COLUMN_MARGIN) *
      (Constants.PORTRAIT_OPTIONS_COUNT - 1);
    return `calc((${Constants.PERCENT_100} - ${marginLen}vp)/${Constants.PORTRAIT_OPTIONS_COUNT})`;
  }
}

