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

import lazy { MaskLayerUtils } from '../utils/MaskLayerUtils';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { PickerColorMode } from '@kit.MediaLibraryKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';

const TAG: string = 'PhotoPickerMaskLayer';

@Component
export struct PhotoPickerMaskLayer {
  @Link @Watch('onIsPickerMaskLayerShow') isPickerMaskLayerShow: boolean;
  @State maskLayerUtils: MaskLayerUtils = MaskLayerUtils.getInstance();
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @Prop photoBrowserBackgroundColorMode: number = PickerColorMode.AUTO;
  private storage: LocalStorage = LocalStorage.getShared();
  private param: SelectParams | null = null;

  build() {
    WithTheme({colorMode: this.photoBrowserBackgroundColorMode === PickerColorMode.AUTO ? ThemeColorMode.SYSTEM :
      (this.photoBrowserBackgroundColorMode === PickerColorMode.LIGHT ? ThemeColorMode.LIGHT : ThemeColorMode.DARK) }) {
      // PickerMaskLayer({
      //   onclose: () => {
      //     Log.info(TAG, 'PhotoPickerMaskLayer onclose!');
      //     const msg: Record<string, number | string | boolean> = {
      //       'lockedStatus': false,
      //       'isUnlockSuccess': true
      //     };
      //     ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_LOCKED_STATUS, msg);
      //   },
      //   appInfos: [{
      //     bundleName: 'com.ohos.photos',
      //     appIndex: 0,
      //   }],
      //   maskShow: this.isPickerMaskLayerShow,
      //   unlockProxy: true,
      //   currentMode: this.photoBrowserBackgroundColorMode === PickerColorMode.AUTO ? this.currentMode :
      //     (this.photoBrowserBackgroundColorMode === PickerColorMode.LIGHT ?
      //     ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT : ConfigurationConstant.ColorMode.COLOR_MODE_DARK),
      //   extras: {
      //     'hostBundleName': (this.param && this.param.bundleName) ? this.param.bundleName : 'com.ohos.photos',
      //     'hostAppIndex': (this.param && typeof this.param.appCloneIndex === 'number' &&
      //       this.param.appCloneIndex >= 0) ? this.param.appCloneIndex : 0,
      //   }
      // })
    }
  }

  private onIsPickerMaskLayerShow(): void {
    this.maskLayerUtils.setIsPickerMaskLayerShow(this.isPickerMaskLayerShow);
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear photoBrowserBackgroundColorMode = ${this.photoBrowserBackgroundColorMode}`);
    if (this.storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      this.param = this.storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
      Log.info(TAG, `bundleName = ${this.param?.bundleName}, appCloneIdx = ${this.param?.appCloneIndex}`);
    }
  }
}