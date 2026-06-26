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

import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy {
  Constants as BrowserConstants,
  EditType
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log, reportEmpty } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy Bundles, { BUNDLE_NAMES } from '@ohos/tools/src/main/utils/Bundle';
import lazy {
  EditorMsg as ImageEditorMsg,
  EditorParams as ImageEditorParams,
  EditorSDK as ImageEditorSDK,
  EditorStatus as ImageEditorStatus,
  RectValue as ImageRectValue,
  SwitchAnimator as ImageSwitchAnimator
} from '@oh-image-editor/editor-pc';
import lazy window from '@ohos.window';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { image, sendableImage } from '@kit.ImageKit';
import lazy { hiTraceMeter } from '@kit.PerformanceAnalysisKit';
import lazy { Thumbnail } from '@ohos/common/src/main/ets/default/model/browser/photo/Thumbnail';
import lazy {
  SendablePhotoAccessHelper,
  SendablePhotoAlbum
} from '@ohos/common/src/main/ets/default/access/SendablePhotoAccessHelper';
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy {
  EditorPhotoContext,
  EditorStage as EditorContextStage
} from '@ohos/common/src/main/ets/default/utils/EditorPhotoContext';
import lazy { PickerEditorPhotoContext } from '@ohos/common/src/main/ets/default/utils/PickerEditorPhotoContext';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy {
  BaseEditorController,
  TAG,
  SUBTYPE,
  THUMBNAIL_HEIGHT,
  ANIMATION_FINISHED_KEY
} from '@ohos/browsercommon/src/main/ets/default/controller/BaseEditorController'

const DATA_LOAD_TIMEOUT_MS: number = 2000;
const TRIM_HEIGHT: number = 108;

/* instrument ignore file */
@Observed
export class EditorController extends BaseEditorController {
  private isCamera = Bundles.getInfo().name === BUNDLE_NAMES['camera'];

  public initEditorSdk(): void {
    let abilityStageContext = AppStorage.get<Context>('photosGlobalContext') as Context;
    const abilityContext = LocalStorage.getShared()?.get<Context>('photosAbilityContext') as Context;
    let windowStage = LocalStorage.getShared()?.get<window.WindowStage>('photosWindowStage') as window.WindowStage;
    let moduleContext = LocalStorage.getShared()?.get<Context>('photoLibraryContext');
    let mainWindow = LocalStorage.getShared()?.get<window.Window>('mainWindow') as window.Window;
    ImageEditorSDK.initialize(abilityStageContext, abilityContext, windowStage, moduleContext, mainWindow);
  }

  private processEditorCallbackExit(msg: ImageEditorMsg): boolean {
    if (msg.extra) {
      if (!this.needWaitPhotoFresh(msg.extra)) {
        Log.info(TAG, '[EditorPhotoContext] editor callback new uri in virtual album, direct return original photo.');
        let exitRatio = LocalStorage.getShared()?.get<number | undefined>('exitRatio');
        this.hideEditor(this.shownItem, exitRatio, this.shownItem?.uri);
        LocalStorage.getShared()?.setOrCreate<number | undefined>('exitRatio', undefined);
        return true;
      }
      this.broadCastEditExit(msg.extra);
      hiTraceMeter.startAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'EditExitCallbackBroadCast', 0,
        'default');
      this.broadCast?.emit(BroadCastConstants.EDITOR_SAVE_BACK_PHOTOITEM, []);
      this.dataLoadedTimeoutId = setTimeout((): void => {
        Log.error(TAG, 'onEditDataLoaded timeout');
        this.onEditDataLoaded(this.shownItem, this.shownItem?.uri);
      }, DATA_LOAD_TIMEOUT_MS);
      return true;
    }
    return this.hideEditor(this.shownItem);
  }

  public onEditorMessageCallback(msg: ImageEditorMsg): boolean {
    if (msg.extra) {
      this.setEditorUriOnExit(msg.extra, (msg as ImageEditorMsg)?.isOverride);
    }
    let msgId = msg?.id;
    if (!msgId) {
      Log.error(TAG, `onEditorMessageCallback ignored, msgId=${msgId}`);
      return false;
    }
    if (!this.isEditorShown) {
      Log.error(TAG, 'onEditorMessageCallback ignored, editor is not shown');
      return false;
    }
    Log.info(TAG, `onEditorMessageCallback params=${JSON.stringify(msg)} isEditorShown=${this.isEditorShown}`);
    let msgIdOnExit: string = ImageEditorMsg.MSG_ID_ON_EXIT;
    let msgIdOnExitDiscardModification: string = ImageEditorMsg.MSG_ID_ON_EXIT_DISCARD_MODIFICATION;
    let msgIdOnFirstFrame: string = ImageEditorMsg.MSG_ID_ON_FIRST_FRAME;
    if (msgId === msgIdOnExit) {
      return this.processEditorCallbackExit(msg);
    } else if (msgId === msgIdOnExitDiscardModification) {
      return this.hideEditor(this.shownItem, msg.extra as number);
    } else if (msgId === msgIdOnFirstFrame) {
      this.isFirstFrameArrived = true;
      this.finishShowEditorIfNeeded();
      return true;
    }
    Log.warn(TAG, `unknown msgId ${msgId}`);
    return false;
  }

  public onBackPress(): boolean {
    if ((this.isImageEditorShown && ImageEditorSDK.onBackPress())) {
      Log.info(TAG, 'onBackPress consumed by EditorSDK');
      return true;
    }
    return false;
  }

  public showEditor(albumUri: string, item: MediaItem | undefined): void {
    if (this.isInSwitchAnimation) {
      Log.warn(TAG, 'showEditor ignored, in switching animation');
      return;
    }
    const editorContext: EditorPhotoContext = EditorPhotoContext.getInstance();
    if (this.isEditorShown || this.isImageEditorShown || editorContext.getEditorStage() === EditorContextStage.SHOWN) {
      // 卡片/外部入口重复触发时，避免重复创建/重复动效导致闪退
      Log.warn(TAG,
        `showEditor ignored, editor already shown. current=${this.shownItem?.uri ?? ''}, incoming=${item?.uri ?? ''}`);
      this.setPcShowingEditor(true);
      LocalStorage.getShared()?.setOrCreate<boolean>('isEditorShown', true);
      return;
    }
    reportEmpty(item);
    if (!item) {
      Log.error(TAG, 'showEditor failed, current photo is null');
      return;
    }
    this.setPcShowingEditor(true);
    this.shownItem = item;
    let isVideo = item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    const effectMode: number = Number(item.data?.get(photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE));
    this.isLivePhoto = item.data?.get(SUBTYPE) === photoAccessHelper.PhotoSubtype.MOVING_PHOTO ||
      effectMode === photoAccessHelper.MovingPhotoEffectMode.IMAGE_ONLY;
    editorContext
      .setEditorStage(EditorContextStage.SHOWN)
      .setEditorUriOnEnter(item.uri)
      .setEditorType(isVideo ? EditType.VIDEO : (this.isLivePhoto ? EditType.MOVING_PHOTO : EditType.IMAGE));
    this.imageEditorParams.uri = item.uri;
    this.imageEditorParams.mediaType = ImageEditorParams.MEDIA_TYPE_IMAGE;
    this.imageEditorParams.albumUri = albumUri;
    this.imageEditorParams.asset = item.data;

    Log.info(TAG, `showEditor ${item.uri} albumUri=${albumUri} isVideo = ${isVideo}`);
    this.showEditorWithAnim(item);
  }

  //PC大图PhotoItem组件在进入编辑时，移除padding，退出编辑时，添加padding
  private setPcShowingEditor(param: boolean): void {
    animateTo({
      duration: Constants.SIDEBAR_ANIM_DURATION,
      curve: Curve.Smooth,
    }, (): void => {
      LocalStorage.getShared()?.setOrCreate<boolean>('isPcShowingEditor', param);
    })
    Log.info(TAG, `isPcShowingEditor is ${param}`)
  }

  private getDateTaken(asset: PhotoAsset): number {
    let dateTaken = 0;
    try {
      dateTaken = asset.get(photoAccessHelper.PhotoKeys.DATE_TAKEN) as number;
      Log.info(TAG, `get asset date_taken success. dateTaken:${dateTaken}`);
      return dateTaken;
    } catch (err) {
      Log.error(TAG, 'get asset date_taken failed!');
      return dateTaken;
    }
  }

  private showEditorWithAnimVariableChange(isVideo: boolean): void {
    this.showEditorAnimationFinished = false;
    this.isFirstFrameArrived = false;
    this.showEditorTimeout = false;
    this.isInSwitchAnimation = true;
    this.imageEditorStatus.startFadeoutAnim = false;
    this.imageEditorStatus.isPreviewHidden = true;
    this.isImageEditorShown = true;
    AppStorage.delete('form_albumUri');
    this.isEditorShown = true;
  }

  private showEditorWithAnim(item: MediaItem): void {
    Log.info(TAG, 'showEditorWithAnim, MediaItem width ' + item.width + `, height ${item.height}`);
    hiTraceMeter.startAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'showEditorWithAnim', 0, 'default');

    let isVideo = item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    const effectMode: number = Number(item.data?.get(photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE));
    let ratio = item.height !== 0 ? item.width / item.height : 1;
    let winWidth = getScreen().getWinLayoutWidth();
    let winHeight = getScreen().getWinLayoutHeight(this.isCamera);
    Log.info(TAG, `showEditorWithAnim, winWidth: ${winWidth}, winHeight: ${winHeight},ratio: ${ratio}`);
    AppStorage.setOrCreate<boolean>(Constants.APP_STORAGE_KEY_DOWNLOAD_FINISH, false);
    AppStorage.setOrCreate<boolean>(ANIMATION_FINISHED_KEY, false);
    let rectTo: ImageRectValue = ImageSwitchAnimator.getEditorPreviewRect({
        width: winWidth,
        height: winHeight,
      }, ratio, 'IMAGE');
    getScreen().setSystemUi(false);
    getScreen().setDecorButtonStyle(true);
    this.imageEditorParams.rectInfo = rectTo as ImageRectValue;
    AppStorage.setOrCreate<boolean>('isDefaultTab', true);
    this.showEditorWithAnimVariableChange(isVideo);
    // 执行大图背景动画
    LocalStorage.getShared()?.setOrCreate<boolean>('isEditorShown', true);

    Log.info(TAG, `emit show animation to ${JSON.stringify(rectTo)} isVideo = ${isVideo}`);
    if (this.isFromPickerToEditor) {
      //picker进入不做动画
      Log.info(TAG, 'from picker showEditor animation finished');
      this.showEditorAnimationFinished = true;
      this.finishShowEditorIfNeeded();
    } else {
      this.broadCast?.emit(BroadCastConstants.ANIMATE_TO_POSITION + item.uri,
        [null, rectTo, BrowserConstants.EDITOR_SWITCH_TOTAL_DURATION, (): void => {
          Log.info(TAG, 'showEditor animation finished');
          this.showEditorAnimationFinished = true;
          AppStorage.setOrCreate(ANIMATION_FINISHED_KEY, true);
          this.finishShowEditorIfNeeded();
        }, (): void => {}]);
    }

    this.showEditorTimeoutId = setTimeout((): void => {
      Log.warn(TAG, 'showEditor timeout');
      this.showEditorTimeout = true;
      this.finishShowEditorOnTimeout();
    }, BrowserConstants.EDITOR_SWITCH_ANIMATION_TIMEOUT_MS);
  }

  public callHideEditor(item: MediaItem | undefined, ratio?: number, uri?: string): boolean {
    return this.hideEditor(item, ratio, uri);
  }

  private hideEditor(item: MediaItem | undefined, ratio?: number, uri?: string): boolean {
    if (this.isInSwitchAnimation) {
      Log.warn(TAG, 'hideEditor ignored, in switching animation');
      return false;
    }
    if (!item) {
      Log.error(TAG, 'hideEditor failed, current photo is null');
      return false;
    }
    PickerEditorPhotoContext.getInstance().setIsThird(false);
    this.setPcShowingEditor(false);
    this.appBroadCast.emit(BroadCastConstants.OPEN_PIC_CLICK_EDIT, [true]);
    let isVideo = item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    Log.info(TAG, `hideEditor ${item.uri} isVideo ${isVideo}}`);
    this.appBroadCast?.emit(BroadCastConstants.CLOSE_PROGRESS_DIALOG, []);
    if (this.shownItem?.uri !== item.uri) {
      this.broadCast?.emit(BroadCastConstants.RESET_POSITION + (this.shownItem?.uniqueId ?? ''), []);
    }
    if (item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO && this.shownItem?.uri === item.uri) {
      Log.info(TAG, `hideEditor,video content changs, original thumbnail is ${this.shownItem?.thumbnail},
      current thumbnail is ${item.thumbnail}`);
      BroadCastManager.getInstance()
        .getBroadCast()
        .emit(BroadCastConstants.REFRESH_ON_COVERED_BY_EDIT, [this.shownItem, item]);
    }
    this.isLivePhoto = item.data?.get(SUBTYPE) === photoAccessHelper.PhotoSubtype.MOVING_PHOTO;
    let srcRatio = ratio ? ratio : (item.height !== 0 ? item.width / item.height : 1);
    let winWidth = getScreen().getWinLayoutWidth();
    let winHeight = getScreen().getWinLayoutHeight(this.isCamera);
    let isDefaultTab = AppStorage.get<boolean>('isDefaultTab') as boolean;
    let rectFrom = ImageSwitchAnimator.getEditorPreviewRect({
        width: winWidth,
        height: winHeight,
      }, srcRatio, 'IMAGE');
    setTimeout((): void => {
      this.broadCast?.emit(BroadCastConstants.UPDATE_SYSTEM_UI_ON_EDITOR_EXIT, []);
    }, BrowserConstants.EDITOR_SWITCH_IN_DURATION);
    this.isBrowserShown = true;
    this.isInSwitchAnimation = true;
    this.editorStatusChange(isVideo);
    getScreen().setDecorButtonStyle(false);
    // 执行大图背景动画
    LocalStorage.getShared()?.setOrCreate<boolean>('isEditorShown', false);
    Log.info(TAG, `emit hide animation from ${JSON.stringify(rectFrom)}`);
    let onFinish = (): void => {
      Log.info(TAG, '[EditorPhotoContext] hideEditor animation finished');
      this.isMovingPhotoEditorShown = false;
      this.isImageEditorShown = false;
      this.isEditorShown = false;
      this.isInSwitchAnimation = false;
      EditorPhotoContext.getInstance().clear();
    };
    let timeoutId = setTimeout((): void => {
      Log.warn(TAG, 'hideEditor timeout, force finish');
      onFinish();
    }, BrowserConstants.EDITOR_SWITCH_ANIMATION_TIMEOUT_MS);

    // 另存退出后onEditDataLoaded timeout 情况下，使用新图uri发送广播，保证动效id匹配photoItem
    let positionUri = uri ? uri : item.uri;
    Log.info(TAG, `hideEditor ${positionUri} isVideo ${isVideo}}`);
    //从picker进入不做动画
    if (this.isFromPickerToEditor) {
      clearTimeout(timeoutId);
      onFinish();
    } else {
      this.broadCast?.emit(BroadCastConstants.ANIMATE_TO_POSITION + positionUri,
        [rectFrom, null, BrowserConstants.EDITOR_SWITCH_PC_TOTAL_DURATION, (): void => {
          clearTimeout(timeoutId);
          onFinish();
        }, (): void => {
        }]);
    }
    return true;
  }

  private finishShowEditorIfNeeded(): void {
    if (!(this.isFirstFrameArrived && this.showEditorAnimationFinished && !this.showEditorTimeout)) {
      return;
    }
    hiTraceMeter.finishAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'showEditorWithAnim', 0);
    Log.info(TAG, 'showEditor finished(normal)');
    if (this.showEditorTimeoutId >= 0) {
      clearTimeout(this.showEditorTimeoutId);
      this.showEditorTimeoutId = EditorController.INVALID_TIMEOUT_ID;
    }
    this.isBrowserShown = false;
    this.isInSwitchAnimation = false;
    this.imageEditorStatus.isPreviewHidden = false;
  }

  private finishShowEditorOnTimeout(): void {
    if (!this.showEditorTimeout) {
      return;
    }
    hiTraceMeter.finishAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'showEditorWithAnim', 0);
    Log.warn(TAG, 'showEditor finished(timeout)');
    this.isBrowserShown = false;
    this.isInSwitchAnimation = false;
    this.imageEditorStatus.isPreviewHidden = false;
  }
}