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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy{
  EditorMsg as ImageEditorMsg,
  EditorParams as ImageEditorParams,
  EditorSDK as ImageEditorSDK,
  EditorStatus as ImageEditorStatus,
  RectValue as ImageRectValue,
  SwitchAnimator as ImageSwitchAnimator,
} from '@oh-image-editor/editor-common';
import lazy window from '@ohos.window';
import lazy { hiTraceMeter } from '@kit.PerformanceAnalysisKit';
import lazy {
  EditorPhotoContext,
  EditorStage as EditorContextStage
} from '@ohos/common/src/main/ets/default/utils/EditorPhotoContext';
import lazy { PickerEditorPhotoContext } from '@ohos/common/src/main/ets/default/utils/PickerEditorPhotoContext';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';

export const TAG = 'EditorController';
export const THUMBNAIL_HEIGHT: number = 256;
export const ANIMATION_FINISHED_KEY = 'isVideoAnimFinish';
//媒体类型
export const SUBTYPE: string = 'subtype';

@Observed
export abstract class BaseEditorController {
  public isEditorShown: boolean = false;
  public isImageEditorShown: boolean = false;
  public isMovingPhotoEditorShown: boolean = false;
  public isBrowserShown: boolean = true;
  public isInSwitchAnimation: boolean = false;
  public imageEditorStatus: ImageEditorStatus = new ImageEditorStatus();
  public imageEditorParams: ImageEditorParams = new ImageEditorParams();
  protected static readonly INVALID_TIMEOUT_ID: number = -1;
  protected broadCast: BroadCast | undefined = undefined;
  protected appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  protected isFirstFrameArrived: boolean = false;
  protected showEditorAnimationFinished: boolean = false;
  protected showEditorTimeout: boolean = false;
  protected showEditorTimeoutId: number = 0;
  protected shownItem: MediaItem | undefined = undefined;
  protected isWaitingDataLoaded: boolean = false;
  protected isLivePhoto: boolean = false;
  protected dataLoadedTimeoutId: number = 0;
  protected orientationToRestore: number = 0;
  protected onCurrentPhotoLoadCompletedFunc: Function = (): void => {
  };
  protected onEditPhotoLoadFailedFunc: Function = (): void => {
  };
  //判断是否是从picker进入编辑
  protected isFromPickerToEditor: boolean = false;

  public updateIsFormPickerToEditor(value: boolean): void {
    this.isFromPickerToEditor = value;
    if (!DeviceInfo.isPc()) {
      this.imageEditorParams.isFromPicker = value;
    }
  }

  public getImageEditorParams(): ImageEditorParams {
    return this.imageEditorParams;
  }

  public init(broadCast: BroadCast, browserOrientation?: number): void {
    /* instrument ignore next */
    if (DeviceInfo.isEmulator()) {
      Log.error(TAG, 'init failed, not support emulator');
      return;
    }
    Log.info(TAG, 'init');
    this.broadCast = broadCast;
    if (!DeviceInfo.isPc()) {
      this.orientationToRestore = browserOrientation ? browserOrientation : 0;
    }
    this.initEditorSdk();
    this.onCurrentPhotoLoadCompletedFunc = (item: MediaItem): void => this.onCurrentPhotoLoadCompleted(item);
    this.onEditPhotoLoadFailedFunc = (): void => {
      Log.warn(TAG, 'onEditDataLoaded failed');
      this.onEditDataLoaded(this.shownItem);
    }
    if (!this.broadCast.has(BroadCastConstants.CURRENT_PHOTO_LOAD_COMPLETED)) {
      this.broadCast.on(BroadCastConstants.CURRENT_PHOTO_LOAD_COMPLETED, this.onCurrentPhotoLoadCompletedFunc);
    }
    if (!this.broadCast.has(BroadCastConstants.EDIT_PHOTO_LOAD_FAILED)) {
      this.broadCast.on(BroadCastConstants.EDIT_PHOTO_LOAD_FAILED, this.onEditPhotoLoadFailedFunc);
    }
  }

  protected onCurrentPhotoLoadCompleted(item: MediaItem): void {
    if (item === null || item === undefined) {
      Log.error(TAG, `current photo load completed ignored, item is ${item}`);
      return;
    }
    const uri: string | undefined = EditorPhotoContext.getInstance().getEditorUriOnExit();
    if (uri === item.uri) {
      Log.info(TAG, `current photo load completed, uri=${item.uri}`);
      // setTimeout避免图片加载完成回调中控制visibility导致crash
      setTimeout((): void => {
        this.onEditDataLoaded(item);
      });
    } else {
      Log.info(TAG, `current photo load completed,but not edit uri: ${item.uri}`);
    }
  }

  protected needWaitPhotoFresh(extra: Object): boolean {
    // 虚拟相册中,另存为保存返回的uri不在此相册中，直接返回大图，不用等修改刷新
    if (EditorPhotoContext.getInstance().getIsVirtualAlbum() &&
      !Array.isArray(extra) && ((extra as string) !== this.shownItem?.uri)) {
      return false;
    }
    return true;
  }

  protected onEditDataLoaded(item?: MediaItem, uri?: string): void {
    if (!item) {
      Log.error(TAG, 'onEditDataLoaded ignored');
      return;
    }
    if (this.isWaitingDataLoaded) {
      Log.info(TAG, 'onEditDataLoaded');
      this.isWaitingDataLoaded = false;
      hiTraceMeter.finishAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'EditExitCallbackBroadCast', 0);
      hiTraceMeter.finishAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'ImageEditorSaveOperation', 0);
      Log.info('Trace', 'ImageEditorSaveOperation end');
      LocalStorage.getShared()?.setOrCreate<string>(BroadCastConstants.PHOTO_EDIT_SAVE_URI, '');
      if (!DeviceInfo.isPc()) {
        this.broadCast?.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, Constants.PHOTO_TRANSITION_EDIT]);
      }
      this.appBroadCast?.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, Constants.PHOTO_TRANSITION_EDIT]);
      let exitRatio = LocalStorage.getShared()?.get<number | undefined>('exitRatio');
      this.callHideEditor(item, exitRatio, uri);
      LocalStorage.getShared()?.setOrCreate<number | undefined>('exitRatio', undefined);
    } else {
      Log.warn(TAG, `onEditDataLoaded do nothing, uri=${item.uri}`);
    }
    if (this.dataLoadedTimeoutId >= 0) {
      clearTimeout(this.dataLoadedTimeoutId);
      this.dataLoadedTimeoutId = BaseEditorController.INVALID_TIMEOUT_ID;
    }
  }

  abstract callHideEditor(item: MediaItem | undefined, ratio?: number, uri?: string): boolean;

  protected setEditorUriOnExit(extra: Object, isOverride?: boolean): void {
    Log.info(TAG, `[EditorPhotoContext] onEditorMessageCallback extra: ${extra}, isOverride:${isOverride}`);
    EditorPhotoContext.getInstance()
      .setEditorStage(EditorContextStage.EXIT)
      .setIsOverride(isOverride);

    if (!Array.isArray(extra)) {
      try {
        const ext: string | undefined = assert.asString(extra);
        EditorPhotoContext.getInstance()
          .setEditorUriOnExit(ext ?? '');
        if (PickerEditorPhotoContext.getInstance().isThird()) {
          PickerEditorPhotoContext.getInstance().setEditorUriOnExit(ext ?? '');
          PickerEditorPhotoContext.getInstance().setIsPickerWaitingEditExitBroadCast(true);
        }
      } catch(error) {
        Log.error(TAG, `TypeError: ${error.code}-${error.message}`);
      }
    } else {
      try {
        const msgObjArray: Object[] = extra as Object[];
        if (msgObjArray.length > 1) {
          const mediaUri: string | undefined = assert.asString(msgObjArray[0]);
          EditorPhotoContext.getInstance()
            .setNotifyHideEditor(true)
            .setEditorUriOnExit(mediaUri ?? '');
          if (PickerEditorPhotoContext.getInstance().isThird()) {
            PickerEditorPhotoContext.getInstance().setEditorUriOnExit(mediaUri ?? '');
            PickerEditorPhotoContext.getInstance().setIsPickerWaitingEditExitBroadCast(true);
          }
        }
      } catch(error) {
        Log.error(TAG, `ArrayProcessingError:: ${error.code}-${error.message}`);
      }
    }
  }

  abstract initEditorSdk(): void;

  protected editorStatusChange(isVideo: boolean): void {
    if (!this.isFromPickerToEditor) {
      //非picker进入编辑
      if (!isVideo) {
        this.imageEditorStatus.startFadeoutAnim = true;
        this.imageEditorStatus.isPreviewHidden = true;
      }
    }
  }

  public release(): void {
    Log.info(TAG, 'release');
    if (this.broadCast == null) {
      return;
    }
    this.broadCast.off(BroadCastConstants.CURRENT_PHOTO_LOAD_COMPLETED, this.onCurrentPhotoLoadCompletedFunc);
    this.broadCast.off(BroadCastConstants.EDIT_PHOTO_LOAD_FAILED, this.onEditPhotoLoadFailedFunc);
  }

  protected  broadCastEditExit(extra?: Object): string {
    this.isWaitingDataLoaded = true;
    LocalStorage.getShared()?.setOrCreate(BroadCastConstants.PHOTO_EDIT_SAVE_URI, extra);
    this.broadCast?.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, Constants.PHOTO_TRANSITION_EDIT]);
    this.appBroadCast?.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, Constants.PHOTO_TRANSITION_EDIT]);
    return extra as string;
  }

  abstract showEditor(albumUri: string, item: MediaItem | undefined): void;
}