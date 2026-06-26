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
import { PhotoAsset } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { window } from '@kit.ArkUI';
import {
  ActionID,
} from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import { EffectPhotoContext } from './EffectPhotoContext';

/* instrument ignore file */
const TAG: string = 'EffectToggleHelper';

// 光圈打开
// const VIRTUAL_APERTURE_DETAIL: EffectDetail = {
//   effectName: Constants.WIDE_APERTURE,
//   effectStatus: ImageEffectState.OPEN,
//   effectValues: []
// }
//
// // 光圈关闭
// const CLOSE_VIRTUAL_APERTURE_DETAIL: EffectDetail = {
//   effectName: Constants.WIDE_APERTURE,
//   effectStatus: ImageEffectState.CLOSE,
//   effectValues: []
// }
//
// // 抓拍
// const CAPTURE_DETAIL: EffectDetail = {
//   effectName: Constants.SPORT,
//   effectStatus: ImageEffectState.OPEN,
//   effectValues: [{type: '1', value: '1'}]
// }
//
// // 关闭抓拍
// const CLOSE_CAPTURE_DETAIL: EffectDetail = {
//   effectName: Constants.SPORT,
//   effectStatus: ImageEffectState.CLOSE,
//   effectValues: [{type: '1', value: '0'}]
// }
//
// // 摇拍
// const SHAKE_DETAIL: EffectDetail = {
//   effectName: Constants.SPORT,
//   effectStatus: ImageEffectState.OPEN,
//   effectValues: [{type: '2', value: '0.5'}]
// }
// // 关闭摇拍
// const CLOSE_SHAKE_DETAIL: EffectDetail = {
//   effectName: Constants.SPORT,
//   effectStatus: ImageEffectState.CLOSE,
//   effectValues: [{type: '2', value: '0'}]
// }
//
// const EFFECT_DETAIL_MAP: Map<ActionID, EffectDetail> = new Map([
// // 抓拍
//   [ActionID.FLASH_CAPTURE, CAPTURE_DETAIL],
//   // 关闭抓拍
//   [ActionID.CLOSE_FLASH_CAPTURE, CLOSE_CAPTURE_DETAIL],
//   // 光圈
//   [ActionID.VIRTUAL_APERTURE, VIRTUAL_APERTURE_DETAIL],
//   //关闭光圈
//   [ActionID.CLOSE_VIRTUAL_APERTURE, CLOSE_VIRTUAL_APERTURE_DETAIL],
//   // 摇拍
//   [ActionID.DYNAMIC_PANNING, SHAKE_DETAIL],
// ]);

export class EffectToggleHelper {
  public static initEditorSDK(): void {
    let abilityStageContext = AppStorage.get<Context>('photosGlobalContext') as Context;
    const abilityContext = LocalStorage.getShared()?.get<Context>('photosAbilityContext') as Context;
    let windowStage = LocalStorage.getShared()?.get<window.WindowStage>('photosWindowStage') as window.WindowStage;
    let moduleContext = LocalStorage.getShared()?.get<Context>('photoLibraryContext');
    let mainWindow = LocalStorage.getShared()?.get<window.Window>('mainWindow') as window.Window;
    // EditorSDK.initialize(abilityStageContext, abilityContext, windowStage, moduleContext, mainWindow);
  }

  // public static async setEffectToggle(actionID: number, context: Context, photoAsset: PhotoAsset | undefined,
  //   successCallback: Function): Promise<boolean> {
  // //   return new Promise(async (resolve, reject) => {
  // //     let callback: (msg: ImageEffectChangeMsg) => void = (msg: ImageEffectChangeMsg): void => {
  // //       let success: boolean = msg.result === ImageEffectChangeMsg.SUCCESS;
  // //       Log.info(TAG, `setFaceBeauty result success: ${success}`);
  // //       successCallback?.(success);
  // //       resolve(success);
  // //     };
  // //
  // //     try {
  // //       // const effectDetail: EffectDetail | undefined = EFFECT_DETAIL_MAP.get(actionID);
  // //       if (!effectDetail) {
  // //         Log.info(TAG, `effectDetail is null`);
  // //         reject(false);
  // //         return;
  // //       }
  // //       Log.info(TAG, `EditorSDK.selectEffects ${JSON.stringify(effectDetail)}`);
  // //       // let params: ImageEffectChangeParams = {
  // //         effectDetails: [effectDetail],
  // //         context: context,
  // //         asset: photoAsset,
  // //       };
  // //       await EditorSDK.selectEffects(params, callback);
  // //     } catch (error) {
  // //       Log.error(TAG, `setFaceBeauty selectEffects error. ${error.name}: ${error.message}`);
  // //       reject(false);
  // //     }
  // //   });
  // }
}