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
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { FaceBeautyConstants } from '@ohos/common/src/main/ets/default/model/common/FaceBeautyConstants';
import lazy { PhotoAsset } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { window } from '@kit.ArkUI';
import lazy fs from '@ohos.file.fs';
import {
  EditorSDK,
  EffectDetail, ImageEffectChangeMsg, ImageEffectChangeParams,
  ImageEffectState } from '@oh-image-editor/editor-common';

/* instrument ignore file */
const TAG: string = 'FaceBeautyHelper';

export class FaceBeautyHelper {
  private static initEditorSDK(): void {
    let abilityStageContext = AppStorage.get<Context>('photosGlobalContext') as Context;
    const abilityContext = LocalStorage.getShared()?.get<Context>('photosAbilityContext') as Context;
    let windowStage = LocalStorage.getShared()?.get<window.WindowStage>('photosWindowStage') as window.WindowStage;
    let moduleContext = LocalStorage.getShared()?.get<Context>('photoLibraryContext');
    let mainWindow = LocalStorage.getShared()?.get<window.Window>('mainWindow') as window.Window;
    EditorSDK.initialize(abilityStageContext, abilityContext, windowStage, moduleContext, mainWindow);
  }

  public static async setFaceBeauty(context: Context, photoAsset: PhotoAsset | undefined): Promise<boolean> {
    return new Promise(async (resolve, reject) => {
      let callback: (msg: ImageEffectChangeMsg) => void = (msg: ImageEffectChangeMsg): void => {
        let success: boolean = msg.result === ImageEffectChangeMsg.SUCCESS;
        Log.info(TAG, `setFaceBeauty result: ${success}`);
        resolve(success);
      };

      try {
        const effectDetail: EffectDetail = {
          effectName: Constants.FACE_BEAUTY_NAME,
          effectStatus: ImageEffectState.OPEN,
          effectValues: []
        };
        let params: ImageEffectChangeParams = {
          effectDetails: [effectDetail],
          context: context,
          asset: photoAsset,
        };
        FaceBeautyHelper.initEditorSDK();
        await EditorSDK.selectEffects(params, callback);
      } catch (error) {
        Log.error(TAG, `setFaceBeauty selectEffects error. ${error.name}: ${error.message}`);
        reject(false);
      }
    });
  }

  public static async cancelFaceBeauty(context: Context, photoAsset: PhotoAsset | undefined): Promise<boolean> {
    return new Promise(async (resolve, reject) => {
      let callback: (msg: ImageEffectChangeMsg) => void = (msg: ImageEffectChangeMsg): void => {
        let success: boolean = msg.result === ImageEffectChangeMsg.SUCCESS;
        Log.info(TAG, `cancelFaceBeauty result: ${success}`);
        resolve(success);
      };

      try {
        const effectDetail: EffectDetail = {
          effectName: Constants.FACE_BEAUTY_NAME,
          effectStatus: ImageEffectState.CLOSE,
          effectValues: []
        };
        let params: ImageEffectChangeParams = {
          effectDetails: [effectDetail],
          context: context,
          asset: photoAsset,
        };
        FaceBeautyHelper.initEditorSDK();
        EditorSDK.selectEffects(params, callback);
      } catch (error) {
        Log.error(TAG, `cancelFaceBeauty selectEffects error. ${error.name}: ${error.message}`);
        reject(false);
      }
    });
  }

  public static async isBeauty(curItem: MediaItem): Promise<string> {
    let photoAsset: PhotoAsset | undefined = curItem.data;
    if (!photoAsset) {
      Log.info(TAG, '[isBeauty] MediaItem photoAsset is undefined');
      photoAsset = await UserFileManagerAccess.getInstance().getPhotoAssetByUri(curItem.uri);
    }
    try {
      if (!photoAsset) {
        Log.warn(TAG, 'isBeauty photoAsset undefined');
        return FaceBeautyConstants.AI_FAILURE_FACE_BEAUTY_STATE;
      }
      let isEdited: Boolean = await photoAsset.isEdited();
      Log.info(TAG, `[isBeauty] get from medialibrary: isEdited is ${isEdited}`);
      if (!isEdited) {
        Log.info(TAG, '[isBeauty] no editData');
        return FaceBeautyConstants.AI_NO_FACE_BEAUTY_STATE;
      }
      let data: photoAccessHelper.MediaAssetEditData = await photoAsset.getEditData();

      let editData: string = data.data;
      let isThird: boolean = !(editData.indexOf(FaceBeautyConstants.SINGLE_THIRD_JSON) === -1);
      Log.info(TAG, `compatibleFormat ${data.compatibleFormat} and compatibleFormat is ${data.data}`);
      // 三方数据不支持一键美肤
      if (data.compatibleFormat !== '' && data.compatibleFormat !== 'system' || isThird) {
        Log.info(TAG, '[isBeauty] editData is third is not SupportFaceBeauty ');
        return FaceBeautyConstants.AI_THIRD_FACE_BEAUTY_STATE;
      }

      Log.info(TAG, `[isBeauty] get from medialibrary: editData is ${editData}}`);
      const beautyState: string = editData.indexOf(FaceBeautyConstants.SINGLE_BEAUTY_JSON) ===
        -1 ? FaceBeautyConstants.AI_NO_FACE_BEAUTY_STATE : FaceBeautyConstants.AI_ALREADY_FACE_BEAUTY_STATE;
      Log.info(TAG, `[isBeauty] get from editData: beauty state is ${beautyState}`);
      return beautyState;
    } catch (err) {
      Log.error(TAG, `[isBeauty] get isBeauty state err: ${err}`);
      return FaceBeautyConstants.AI_FAILURE_FACE_BEAUTY_STATE;
    }
    // return ''
  }

  /**
   * 判断当前的编创框架版本是否支持美肤效果器
   *
   */
  private static isImageEffectSupport(): boolean {
    let isSupport: boolean | undefined = AppStorage.get(Constants.IS_SUPPORT_BEAUTY);
    if (isSupport === undefined) {
      FaceBeautyHelper.initEditorSDK();
      isSupport = EditorSDK.isSupportEffect(Constants.FACE_BEAUTY_NAME);
      AppStorage.setOrCreate<boolean>(Constants.IS_SUPPORT_BEAUTY, isSupport);
    }
    Log.info(TAG, `support face beauty: ${isSupport}`);
    // return isSupport;
    return false
  }

  public static isSupportFaceBeauty(albumUri: string | undefined): boolean {
    if (albumUri === undefined) {
      Log.info(TAG, 'albumUri is undefined, cannot get whether to support facebeauty.');
      return false;
    }
    return FaceBeautyHelper.isImageEffectSupport() && !UserFileManagerAccess.isRecycleBin(albumUri) &&
      AppStorage.get(Constants.ENABLE_PIANO) as string === 'true';
  }

  private static async isFaceBeautySupport(): Promise<boolean> {
    let isSupport: boolean | undefined = AppStorage.get<boolean>(Constants.IS_SUPPORT_BEAUTY);
    if (isSupport !== undefined) {
      Log.info(TAG, `isFaceBeautySupport: ${isSupport}`);
      return isSupport;
    }

    let isSoExist: boolean = false;
    try {
      isSoExist = await taskpool.execute(isFaceBeautySoExist) as boolean;
      Log.info(TAG, `face beauty so is exist: ${isSoExist}`);
    } catch (err) {
      Log.error(TAG, `check face beauty so is exist error. message: ${err.message}`);
    }
    AppStorage.setOrCreate<boolean>(Constants.IS_SUPPORT_BEAUTY, isSoExist);
    return isSoExist;
  }

  public static async isSupportFaceBeautyAsync(albumUri: string | undefined): Promise<boolean> {
    if (albumUri === undefined) {
      Log.info(TAG, 'albumUri is undefined, cannot get whether to support facebeauty.');
      return false;
    }
    return await FaceBeautyHelper.isFaceBeautySupport() && !UserFileManagerAccess.isRecycleBin(albumUri) &&
      AppStorage.get(Constants.ENABLE_PIANO) as string === 'true';
  }
}

@Concurrent
async function isFaceBeautySoExist(): Promise<boolean> {
  let isExist: boolean = false;
  try {
    const faceBeautySoPath: string = '/chip_prod/lib64/passthrough/libmrc_cg_beauty.so';
    isExist = await fs.access(faceBeautySoPath);
  } catch (err) {
    isExist = false;
    Log.error('FaceBeautyHelper', `check face beauty so error. message: ${err.message}`);
  }
  return isExist;
}
