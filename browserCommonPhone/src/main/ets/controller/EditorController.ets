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
import lazy {
  Constants as BrowserConstants,
  EditType
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy {
  EditorMsg as ImageEditorMsg,
  EditorParams as ImageEditorParams,
  EditorSDK as ImageEditorSDK,
  EditorStatus as ImageEditorStatus,
  RectValue as ImageRectValue,
  SwitchAnimator as ImageSwitchAnimator,
} from '@oh-image-editor/editor-phone';
import lazy window from '@ohos.window';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { fileIo as fs } from '@kit.CoreFileKit';
import lazy promptAction from '@ohos.promptAction';
import lazy { PhotoAsset } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { image, sendableImage } from '@kit.ImageKit';
import lazy { BusinessError, systemParameter, systemParameterEnhance } from '@kit.BasicServicesKit';
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
import lazy { FaceBeautyHelper } from '@ohos/browsercommon/src/main/ets/default/utils/FaceBeautyHelper';
import lazy { FaceBeautyConstants } from '@ohos/common/src/main/ets/default/model/common/FaceBeautyConstants';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy process from '@ohos.process';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import lazy { PermissionPopup } from '@ohos/privacy/src/main/ets/about/consent/PermissionPopup';
import lazy {
  BaseEditorController,
  TAG,
  SUBTYPE,
  THUMBNAIL_HEIGHT,
  ANIMATION_FINISHED_KEY
} from '@ohos/browsercommon/src/main/ets/default/controller/BaseEditorController'

const DATA_LOAD_TIMEOUT_MS: number = 3000;
const LIVE_PHOTO_LOAD_TIMEOUT_MS: number = 3000;
// 视频编辑新增的MessageCallbackID，临时写在此处，待视频编辑har包刷新后删除
const MSG_ID_ON_SET_ORIENTATION: string = 'set_orientation';

interface EditData {
  imageEffect: ImageEffect,
}

interface ImageEffect {
  filters: Filter[],
}

interface Filter {
  name: string,
  values: FilterParam,
}

interface FilterParam {
  inputHeight: number,
  inputWidth: number,
  isFrameSticker: boolean,
  isBorderSticker: boolean,
  isFestivalSticker: boolean,
  isXtStyleSticker: boolean,
  isPersonalizedStickerStyle1: boolean,
  //水印名称
  watermarkName: string
}

export enum EntryType {
  // 无
  NONE = 0,
  // 【待适配】图库大图入口
  PHOTO_BROWSER,
  // 【待适配】相机大图入口（UIExtensionAbility通路）
  CAMERA_BROWSER,
  // 【待适配】picker入口
  PICKER_BROWSER,
  // 图库创作入口
  PHOTO_CREATE
}

export class EditorAsset {
  public uri: string = '';
  public media_type: string = '';
  public thumbnail: string = '';
  public albumUri: string = '';
  public live_photo_state: string = '';
  public asset: photoAccessHelper.PhotoAsset | undefined = undefined;
  public album: sendablePhotoAccessHelper.Album | undefined = undefined;
  public isRemoteSource: boolean = false; // 增加参数接收资源位置类型，图库传参（true表示为云端资源）
  public isLibrary: boolean = false;
  public live_photo_mode: number = 0;
}

@Observed
export class EditorController extends BaseEditorController {
  public isAiEditorEnabled: boolean = ImageEditorSDK.isAiEditorEnabled();
  public opacity = 1;

  public initEditorSdk(): void {
    let abilityStageContext = AppStorage.get<Context>('photosGlobalContext') as Context;
    const abilityContext = LocalStorage.getShared()?.get<Context>('photosAbilityContext') as Context;
    let windowStage = LocalStorage.getShared()?.get<window.WindowStage>('photosWindowStage') as window.WindowStage;
    let moduleContext = LocalStorage.getShared()?.get<Context>('photoLibraryContext');
    let mainWindow = LocalStorage.getShared()?.get<window.Window>('mainWindow') as window.Window;
    ImageEditorSDK.initialize(abilityStageContext, abilityContext, windowStage, moduleContext, mainWindow);
  }

  public onPenKitOrAiMessageCallback(entryType: string, imageUri: string, editData: string,
    clipRatio: number, tabIndex?: number): boolean {
    Log.info(TAG, `onPenKitOrAiMessageCallback entry ${entryType}, tabIndex: ${tabIndex}`);
    if (!entryType) {
      Log.error(TAG, `onPenKitOrAiMessageCallback is not entryType=${entryType}`);
      return false;
    }
    if (!imageUri) {
      Log.info(TAG, 'Video editing does not imageUri.');
      return false;
    }
    let item: MediaItem = new MediaItem(this.shownItem?.data);
    this.imageEditorParams.uri = imageUri;
    this.imageEditorParams.entryType = entryType;
    this.imageEditorParams.entryIndex = (tabIndex ?? -1);
    this.imageEditorParams.position = UserFileManagerAccess.FILE_LOCATION_LOCAL;
    this.imageEditorParams.editData = editData;
    this.imageEditorParams.mediaType = ImageEditorParams.MEDIA_TYPE_IMAGE;
    this.imageEditorParams.asset = this.shownItem?.data;
    this.imageEditorStatus.isInEmbedded = true;
    // 获取视频编辑裁剪框位置，从涂鸦/AI修图返回时做动效用
    let winWidth: number = getScreen().getWinLayoutWidth();
    let winHeight: number = getScreen().getWinLayoutHeight();
    this.prepareAnim(this.imageEditorParams.albumUri, item, ImageEditorParams.MEDIA_TYPE_IMAGE, false);
    return true;
  }

  public onEditorMessageCallback(msg: ImageEditorMsg): boolean {
    let msgId: string | undefined = msg?.id;
    Log.info(TAG, `onEditorMessageCallback msgId:${msgId}`);
    if (msg.extra && msgId !== MSG_ID_ON_SET_ORIENTATION) {
      this.setEditorUriOnExit(msg.extra, (msg as ImageEditorMsg)?.isOverride);
    }
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
      this.handleConflictDialogFlag();
      return this.processEditorCallbackExit(msg);
    } else if (msgId === msgIdOnExitDiscardModification) {
      this.handleConflictDialogFlag();
      // AI编辑中取消
      if (this.isMovingPhotoEditorShown && this.isImageEditorShown) {
        if ((msg instanceof ImageEditorMsg) && msg.isVdeFoldChanged) {
          // xxx时销毁视频编辑数据，并回到大图页面
          this.isMovingPhotoEditorShown = false;
          this.isLivePhoto = false;
          this.imageEditorStatus.isInEmbedded = false;
          this.hideEditor(this.shownItem, undefined, undefined, msg.isVdeFoldChanged);
        }
        return true;
      } else {
        return this.hideEditor(this.shownItem, msg.extra as number);
      }
    } else if (msgId === msgIdOnFirstFrame) {
      this.isFirstFrameArrived = true;
      this.finishShowEditorIfNeeded();
      return true;
    } else if (msgId == ImageEditorMsg.MSG_ID_ON_FINISH_STYLUS) {
      Log.info(TAG, 'stylus finished');
      // 涂鸦编辑完成时销毁视频编辑数据
      this.isMovingPhotoEditorShown = false;
      this.isLivePhoto = false;
      this.imageEditorStatus.isInEmbedded = false;
      return true;
    } else if (msgId === MSG_ID_ON_SET_ORIENTATION) {
      // UIExtension无法设置屏幕状态，只能通过回调形式通知大图设置，以改变UIExtension页面的横竖屏状态
      Log.info(TAG, 'Got set orientation message');
      let orientation: number =
        Number.isInteger(msg?.extra) ? Number(msg?.extra) : Number(window.Orientation.AUTO_ROTATION_RESTRICTED);
      WindowUtil.setOrientation(orientation);
    } else {
      Log.warn(TAG, `unknown msgId ${msgId}`);
    }
    return false;
  }

  private processEditorCallbackExit(msg: ImageEditorMsg): boolean {
    if (msg.extra) {
      if (this.isMovingPhotoEditorShown && this.isImageEditorShown &&
        this.imageEditorParams.entryType === ImageEditorParams.PARAM_ENTRY_TYPE_AI) {
        // 在动态照片编辑中打开图片编辑，保存图片编辑需要销毁动态照片编辑数据
        this.isMovingPhotoEditorShown = false;
        this.isLivePhoto = false;
        this.imageEditorStatus.isInEmbedded = false;
      }
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
      this.appBroadCast.emit(BroadCastConstants.EDITOR_SAVE_BACK_PHOTOITEM, []);
      this.dataLoadedTimeoutId = setTimeout((): void => {
        Log.error(TAG, 'onEditDataLoaded timeout');
        this.reportTimeout();
        this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, []);
        this.onEditDataLoaded(this.shownItem, this.shownItem?.uri);
      }, this.isLivePhoto ? LIVE_PHOTO_LOAD_TIMEOUT_MS : DATA_LOAD_TIMEOUT_MS);
      return true;
    } else {
      // 查询隐私协议云侧签署记录，感知隐私协议变更，触发重新弹窗
      PermissionPopup.queryCloudAgreements(getContext());
      return this.hideEditor(this.shownItem);
    }
    return false;
  }

  private async reportTimeout(): Promise<void> {
    let data: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    let isOverwrite: boolean = this.shownItem?.uri === EditorPhotoContext.getInstance().getEditorUriOnExit();
    let mediaType: number = this.shownItem?.mediaType ?? 1;
    mediaType = this.shownItem?.getIsMovingPhoto() ? 3 : mediaType;
    let msg: Record<string, number | string | boolean> = {
      'PROCESS_NAME': data.name,
      'SAVE_TYPE': isOverwrite,
      'MEDIA_TYPE': mediaType,
      'FAIL_MSG': 'TIME_OUT'
    };
    ReportToBigDataUtil.errEventReport(BigDataConstants.EDITOR_ERROR, msg);
  }

  private clearShowEditorTimeout() {
    if (this.showEditorTimeoutId >= 0 || this.showEditorTimeout) {
      Log.info(TAG, `clearShowEditorTimeout`);
      clearTimeout(this.showEditorTimeoutId);
      this.showEditorTimeout = false;
      this.showEditorTimeoutId = EditorController.INVALID_TIMEOUT_ID;
    }
  }

  public onBackPress(): boolean {
    if ((this.isImageEditorShown && ImageEditorSDK.onBackPress())) {
      Log.info(TAG, 'onBackPress consumed by EditorSDK');
      return true;
    }
    return false;
  }

  private getAssetPosition(asset: photoAccessHelper.PhotoAsset | undefined): photoAccessHelper.PositionType {
    let assetPosition: photoAccessHelper.PositionType = photoAccessHelper.PositionType.LOCAL;
    if (asset) {
      assetPosition = asset.get(photoAccessHelper.PhotoKeys.POSITION) as photoAccessHelper.PositionType;
    }
    return assetPosition;
  }

  private filterDownloadList(uri: string, downloadList: Map<string, string> | undefined): boolean {
    if (!downloadList || downloadList.size === 0) {
      Log.info(TAG, `downloadList is undefined or size is zero`);
      return false;
    }
    if (downloadList.has(uri)) {
      return true
    }
    return false;
  }

  public jumpEditor(albumUri: string, item: MediaItem[] | undefined, entryType: EntryType, autoClip?: boolean,
    downloadList?: Map<string, string>): void {
    if (!item || item.length === 0) {
      return;
    }
    let thumbnailWidth1: number | string = 0;
    if (item[0].imgHeight > 0) {
      thumbnailWidth1 = (THUMBNAIL_HEIGHT * (item[0].imgWidth / item[0].imgHeight)).toFixed(0);
    } else {
      thumbnailWidth1 = THUMBNAIL_HEIGHT;
    }

    for (let i = 0; i < item.length; i++) {
      let editorExtraAssets: EditorAsset = new EditorAsset();
      editorExtraAssets.uri = item[i].uri;
      editorExtraAssets.asset = item[i].data;
      editorExtraAssets.isLibrary = PhotoConfig.isLibrary();
      editorExtraAssets.media_type = item[i].mediaType === 2 ? 'VIDEO' : 'IMAGE';
      editorExtraAssets.albumUri = item[i].uri;
      editorExtraAssets.isRemoteSource = this.filterDownloadList(item[i].uri, downloadList) ? false :
        this.getAssetPosition(editorExtraAssets.asset) === photoAccessHelper.PositionType.CLOUD;
      let thumbnailWidth: number | string = 0;
      if (item[i].imgHeight > 0) {
        thumbnailWidth = (THUMBNAIL_HEIGHT * (item[i].imgWidth / item[i].imgHeight)).toFixed(0);
      } else {
        thumbnailWidth = THUMBNAIL_HEIGHT;
      }
      editorExtraAssets.thumbnail = `${item[i].uri}/thumbnail/${thumbnailWidth}/${THUMBNAIL_HEIGHT}`;
    }
    AppStorage.setOrCreate<boolean>(Constants.APP_STORAGE_KEY_DOWNLOAD_FINISH, false);
    if (!albumUri) {
      Log.warn(TAG, 'albumUri is null');
      return;
    }
    Log.info(TAG, 'start userFileManager.getAlbumByUri');
    let userFileManager: SendablePhotoAccessHelper = new SendablePhotoAccessHelper();
    userFileManager.onCreate(getContext());
    userFileManager.getAlbumByUri(albumUri).then((res: SendablePhotoAlbum | undefined) => {
      if (res) {
        Log.info(TAG, 'userFileManager.getAlbumByUri success');
      } else {
        Log.error(TAG, 'userFileManager.getAlbumByUri failed');
      }
    })
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

  public showEditor(albumUri: string, item: MediaItem | undefined): void {
    if (this.isInSwitchAnimation) {
      Log.warn(TAG, 'showEditor ignored, in switching animation');
      return;
    }
    if (!item) {
      Log.error(TAG, 'showEditor failed, current photo is null or albumUri is null');
      return;
    }
    this.imageEditorParams.entryType =
      AppStorage.get<boolean>(Constants.PHOTO_DIRECTLY_ENTER_AI_EDITING) ? ImageEditorParams.PARAM_ENTRY_TYPE_AI :
      ImageEditorParams.PARAM_ENTRY_TYPE_DEFAULT;
    AppStorage.delete(Constants.PHOTO_DIRECTLY_ENTER_AI_EDITING);
    this.imageEditorStatus.isInEmbedded = false;
    this.shownItem = item;
    let isVideo = item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    const effectMode: number = Number(item.data?.get(photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE));
    this.isLivePhoto = item.data?.get(SUBTYPE) === photoAccessHelper.PhotoSubtype.MOVING_PHOTO ||
      effectMode === photoAccessHelper.MovingPhotoEffectMode.IMAGE_ONLY;
    EditorPhotoContext.getInstance()
      .setEditorStage(EditorContextStage.SHOWN)
      .setEditorUriOnEnter(item.uri)
      .setEditorType(isVideo ? EditType.VIDEO : (this.isLivePhoto ? EditType.MOVING_PHOTO : EditType.IMAGE));
    if (!this.imageEditorParams.closeFinish) {
      Log.error(TAG, 'editorPage close is not finished');
      return;
    }
    this.imageEditorParams.uri = item.uri;
    this.imageEditorParams.mediaType = ImageEditorParams.MEDIA_TYPE_IMAGE;
    this.imageEditorParams.albumUri = albumUri;
    this.imageEditorParams.asset = item.data;
    // 静图一镜到底前置判断
    let outputEditdata = [];
    this.getFrameWatermarkParam(item, outputEditdata).then((filterParam?: FilterParam) => {
      Log.info(TAG, 'getFrameWatermarkParam success.');
      if (filterParam) {
        item.isFrameSticker = filterParam.watermarkName === 'FrameSticker';
        item.isFestivalSticker = filterParam.watermarkName === 'FestivalSticker';
        item.isXtStyleSticker = filterParam.watermarkName === 'XtStyleSticker';
        item.isPersonalizedStickerStyle1 = filterParam.watermarkName === 'PersonalizedStickerStyle1';
        item.isBorderSticker = filterParam.isBorderSticker;
        item.sealInputWidth = filterParam.inputWidth;
        item.sealInputHeight = filterParam.inputHeight;
        item.stickerFilterName = filterParam.watermarkName;
      }
      this.prepareAnim(albumUri, item, ImageEditorParams.MEDIA_TYPE_IMAGE, true, outputEditdata[0] ?? '');
    })
  }

  private prepareAnim(albumUri: string, item: MediaItem | undefined, type: string,
    isNeedAnimate: boolean = true, outputEditdata: string = ''): void {
    if (!item) {
      Log.error(TAG, 'prepareAnim failed, current photo is null');
      return;
    }
    let isHorizontal = isOrientationHorizontal();
    Log.info(TAG, `showEditor ${item.uri} albumUri=${albumUri} isHorizontal=${isHorizontal} type=${type}`);
    WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    this.showEditorWithAnim(item, isNeedAnimate, outputEditdata);
  }

  private showEditorWithAnimVariableChange(isVideo: boolean): void {
    Log.info(TAG, 'showEditorWithAnimVariableChange isVideo: ' + isVideo);
    this.showEditorAnimationFinished = false;
    this.isFirstFrameArrived = false;
    this.showEditorTimeout = false;
    this.isInSwitchAnimation = true;

    this.imageEditorStatus.startFadeoutAnim = false;
    this.imageEditorStatus.isPreviewHidden = true;
    this.isImageEditorShown = true;
    hiTraceMeter.finishAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'startShowEditorWithAnim', 0);
    AppStorage.delete('form_albumUri');

    this.isEditorShown = true;
  }

  isPortraitForEmbeddedEditor(): boolean | undefined {
    // 嵌入编辑界面，且有横竖屏缓存时，取缓存横竖屏状态值
    if (!this.imageEditorStatus.isInEmbedded || !AppStorage.has('editor_isPortrait')) {
      return undefined;
    }
    let isPortrait: boolean | undefined = AppStorage.get<boolean>('editor_isPortrait');
    Log.debug(TAG, `isPortraitForEmbeddedEditor: ${isPortrait}`);
    return isPortrait;
  }

  private async getFrameWatermarkParam(item: MediaItem, outputEditdata: string[]): Promise<FilterParam | undefined> {
    let photoAsset: PhotoAsset | undefined = item.data;
    let isCloudAsset = false;
    Log.info(TAG, `getFrameWatermarkParam, isCloudAsset: ${isCloudAsset}`);
    if (!photoAsset || isCloudAsset) {
      return;
    }
    let isEdit: boolean = false;
    let editData: photoAccessHelper.MediaAssetEditData;
    try {
      isEdit = await photoAsset.isEdited();
      editData = await photoAsset.getEditData();
      outputEditdata.push(editData.data);
      Log.info(TAG, 'isEdit:' + isEdit + ` editData:${editData.data}`);
    } catch (err) {
      Log.error(TAG, `request asset editData failed. :${err?.code}---${err}`);
      return;
    }

    Log.error(TAG, 'findFrameSealParam');
    let filterParam: FilterParam = this.findFrameSealParam(editData);
    if (!filterParam.isFrameSticker && !filterParam.isFestivalSticker &&
      !filterParam.isBorderSticker && !filterParam.isXtStyleSticker &&
      !filterParam.isPersonalizedStickerStyle1) {
      return;
    }
    let fd: number = await photoAsset.requestSource();
    let imageSource: image.ImageSource = image.createImageSource(fd);
    if (!imageSource || imageSource === undefined) {
      Log.error(TAG, `create imageSource Failed, imageFd: ${fd}`);
      return;
    }
    if (!this.isLivePhoto) {
      try {
        let options: image.ImagePropertyOptions = { index: 0, defaultValue: '' };
        let imageModel = await imageSource.getImageProperty(image.PropertyKey.MODEL, options);
        if (!imageModel || !this.hasSealResource(imageModel)) {
          imageSource?.release();
          Log.error(TAG, `do not have seal Resource. imageMode:${imageModel}`);
          return;
        }
      } catch (err) {
        imageSource?.release();
        Log.error(TAG, `get image property failed. :${err?.code}---${err}`);
        return;
      }
    }
    // 相机拍摄的原始图片
    if ((editData.data !== '') && !isEdit) {
      let imageInfo: image.ImageInfo = imageSource.getImageInfoSync();
      if (imageInfo) {
        filterParam.inputWidth = imageInfo.size.width;
        filterParam.inputHeight = imageInfo.size.height;
        Log.info(TAG, `imageInfo:${JSON.stringify(imageInfo)}`);
      } else {
        Log.error(TAG, 'Failed to get the image information.');
      }
    }

    imageSource?.release();

    Log.info(TAG, 'watermark filter name:' + filterParam.watermarkName +
      ' sealInputWidth:' + filterParam.inputWidth + ' sealInputHeight:' + filterParam.inputHeight);
    return filterParam;
    // return false
  }

  private findFrameSealParam(editData: photoAccessHelper.MediaAssetEditData) {
    let filterParam: FilterParam = {
      inputHeight: 0,
      inputWidth: 0,
      isFrameSticker: false,
      isBorderSticker: false,
      isFestivalSticker: false,
      isXtStyleSticker: false,
      isPersonalizedStickerStyle1: false,
      watermarkName: '',
    };
    if (!editData || !editData.data) {
      Log.error(TAG, 'editData is null');
      return filterParam;
    }
    let edit = JSON.parse(editData.data) as EditData;
    let filters: Filter[] = edit?.imageEffect?.filters;

    if (filters && filters.length > 0) {
      let index: number = 0;
      while (index < filters.length) {
        let filter: Filter = filters[index];
        if (filter.name === 'FrameSticker') {
          filterParam = filter.values;
          filterParam.watermarkName = filter.name;
          filterParam.isFrameSticker = true;
          break;
        } else if (filter.name === 'FestivalSticker') {
          filterParam = filter.values;
          filterParam.watermarkName = filter.name;
          filterParam.isFestivalSticker = true;
          break;
        } else if (filter.name === 'XtStyleSticker') {
          filterParam = filter.values;
          filterParam.watermarkName = filter.name;
          filterParam.isXtStyleSticker = true;
          break;
        } else if (filter.name === 'BorderSticker' || filter.name === 'FrostedSticker') {
          filterParam = filter.values;
          filterParam.watermarkName = filter.name;
          filterParam.isBorderSticker = true;
          break;
        } else if (filter.name === 'PersonalizedStickerStyle1') {
          Log.info(TAG, 'findFrameSealParam PersonalizedStickerStyle1');
          filterParam = filter.values;
          filterParam.watermarkName = filter.name;
          filterParam.isPersonalizedStickerStyle1 = true;
        }
        index++;
      }
    }
    return filterParam;
  }

  private hasSealResource(imageModel: string): boolean {
    try {
      let sourcePath: string = '';
      let isHide: string = systemParameterEnhance.getSync('const.mspes.camera_watermark');
      let devModel: string = systemParameterEnhance.getSync('const.product.name');
      Log.info(TAG, `isHide:${isHide} devModel:${devModel} imageModel:${imageModel}`);
      if (imageModel === 'unknown' && isHide === 'true') {
        sourcePath = '/sys_prod/resource/camera/camouflage/watermark';
      } else if (imageModel === devModel) {
        sourcePath = '/sys_prod/resource/camera/watermark';
      } else {
        return false;
      }
      let res = fs.accessSync(sourcePath);
      if (res) {
        Log.info(TAG, `watermark resource file exists. path:${sourcePath}`);
      } else {
        Log.info(TAG, `watermark resource file not exists.${sourcePath}`);
      }
      return res;
    } catch (error) {
      Log.info(TAG, `readWatermarkPath get error ${error}`);
      return false;
    }
  }

  private getRatioIsFrameSticker(item: MediaItem): number {
    let height = item.sealInputHeight;
    let width = item.sealInputWidth;
    // 连拍照片 旋转角度为90或270时 需要宽高比对调
    if ([90, 270].includes(item.orientation)) {
      height = item.sealInputWidth;
      width = item.sealInputHeight;
    }
    return height !== 0 ? width / height : 1;
  }

  private showEditorWithAnim(item: MediaItem, isNeedAnimate: boolean, editData: string): void {
    Log.info(TAG, 'showEditorWithAnim, MediaItem width ' + item.width + `, height ${item.height}`);
    hiTraceMeter.startAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'showEditorWithAnim', 0, 'default');
    hiTraceMeter.startAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'startShowEditorWithAnim', 0, 'default');
    let isVideo = item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    Log.info(TAG, 'isMovingPhotoEditorShown IS ' + this.isMovingPhotoEditorShown + ', mediaType ' + item.data?.get(SUBTYPE))
    const effectMode: number = Number(item.data?.get(photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE));
    let ratio = item.height !== 0 ? item.width / item.height : 1;
    if (item.isFrameSticker || item.isBorderSticker || item.isXtStyleSticker || item.isPersonalizedStickerStyle1 ||
    item.isFestivalSticker) {
      ratio = this.getRatioIsFrameSticker(item);
    }
    let livePhotosRatio = ratio;
    if (item.isFestivalSticker) { // 动态照片独用，为了不影响图片编辑春节水印
      livePhotosRatio = item.sealInputHeight !== 0 ? item.sealInputWidth / item.sealInputHeight : 1;
    }
    Log.info(TAG, `showEditorWithAnim, isFrameSticker: ${item.isFrameSticker} isFestivalSticker
      ${item.isFestivalSticker} ratio: ${ratio} isBorderSticker: ${item.isBorderSticker} isXtStyleSticker:
      ${item.isXtStyleSticker} isPersonalizedStickerStyle1:${item.isPersonalizedStickerStyle1}`);
    let winWidth: number = getScreen().getWinLayoutWidth();
    let winHeight: number = getScreen().getWinLayoutHeight();
    AppStorage.setOrCreate<boolean>(Constants.APP_STORAGE_KEY_DOWNLOAD_FINISH, false);
    AppStorage.setOrCreate(ANIMATION_FINISHED_KEY, false);
    let rectTo: ImageRectValue = ImageSwitchAnimator.getEditorPreviewRect({
      width: winWidth,
      height: winHeight,
    }, ratio, 'IMAGE', this.isPortraitForEmbeddedEditor(), item.stickerFilterName, editData);
    LocalStorage.getShared()?.setOrCreate<boolean>('isBlackBg', true);
    this.imageEditorParams.rectInfo = rectTo as ImageRectValue;
    this.showEditorWithAnimVariableChange(isVideo);
    LocalStorage.getShared()?.setOrCreate<boolean>('isEditorShown', true);

    Log.info(TAG, `emit show animation to ${JSON.stringify(rectTo)} isVideo = ${isVideo}`);
    if (this.broadCast != null) {
      if (this.isFromPickerToEditor) {
        Log.info(TAG, 'from picker showEditor animation finished');
        this.showEditorAnimationFinished = true;
        this.finishShowEditorIfNeeded();
      } else {
        if (isNeedAnimate) {
          this.broadCast.emit(BroadCastConstants.ANIMATE_TO_POSITION + item.uri,
            [null, rectTo, BrowserConstants.EDITOR_SWITCH_TOTAL_DURATION, (): void => {
              Log.info(TAG, 'showEditor animation finished');
              this.showEditorAnimationFinished = true;
              AppStorage.setOrCreate(ANIMATION_FINISHED_KEY, true);
              this.finishShowEditorIfNeeded();
            }, (): void => {}]);

          this.showEditorTimeoutId = setTimeout((): void => {
            Log.warn(TAG, 'showEditor timeout');
            this.showEditorTimeout = true;
            this.finishShowEditorOnTimeout();
          }, BrowserConstants.EDITOR_SWITCH_ANIMATION_TIMEOUT_MS);
          Log.info(TAG, 'end of dynamic effect');
        } else {
            this.showEditorAnimationFinished = true;
            AppStorage.setOrCreate(ANIMATION_FINISHED_KEY, true);
            this.finishShowEditorIfNeeded();
        }
      }
    }
  }

  public callHideEditor(item: MediaItem | undefined, ratio?: number, uri?: string): boolean {
    return this.hideEditor(item, ratio, uri);
  }

  private hideEditor(item: MediaItem | undefined, ratio?: number, uri?: string, isVdeFoldChanged?: boolean): boolean {
    if (this.isInSwitchAnimation && !isVdeFoldChanged) {
      Log.warn(TAG, 'hideEditor ignored, in switching animation');
      return false;
    }
    if (!item) {
      Log.error(TAG, 'hideEditor failed, current photo is null');
      return false;
    }
    if (AppStorage?.get('openCustomFilterCardTimer')) {
      // 清除展开调色盘的动效定时器, 防止退出编辑时调色盘展开
      Log.info(TAG, 'hideEditor clearTimeout');
      clearTimeout(AppStorage?.get('openCustomFilterCardTimer') ?? -1);
    }
    // 从编辑退到大图后再次进入编辑时不用直接展开调色盘
    AppStorage.setOrCreate('is_entry_XTStyle', false);
    this.opacity = 1;
    PickerEditorPhotoContext.getInstance().setIsThird(false);
    let isVideo = item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    Log.info(TAG, `hideEditor ${item?.uri}&width = ${item?.width}&height = ${item?.height}`);
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
    const effectMode: number = Number(item.data?.get(photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE));
    this.isLivePhoto = item.data?.get(SUBTYPE) === photoAccessHelper.PhotoSubtype.MOVING_PHOTO || effectMode === 10;
    if (this.orientationToRestore !== undefined) {
      WindowUtil.setOrientation(this.orientationToRestore);
    }
    Log.info(TAG, `hideEditor ${item.uri} isVideo ${isVideo} isMoving ${this.isLivePhoto}`);
    let srcRatio = ratio;
    if (!srcRatio) {
      if (item.isFrameSticker || item.isBorderSticker || item.isXtStyleSticker || item.isPersonalizedStickerStyle1 ||
          item.isFestivalSticker) {
        srcRatio = this.getRatioIsFrameSticker(item);
      } else {
        srcRatio = (item.height !== 0 ? item.width / item.height : 1);
      }
    }
    Log.info(TAG, `hideEditor  srcRatio : ${srcRatio}`);
    let winWidth = getScreen().getWinWidth();
    let winHeight = getScreen().getWinHeight();
    let rectFrom: ImageRectValue = ImageSwitchAnimator.getEditorPreviewRect({
      width: winWidth,
      height: winHeight,
    }, srcRatio, 'IMAGE', this.isPortraitForEmbeddedEditor(), item.stickerFilterName);
    LocalStorage.getShared()?.setOrCreate<boolean>('isBlackBg', false);
    setTimeout((): void => {
      this.broadCast?.emit(BroadCastConstants.UPDATE_SYSTEM_UI_ON_EDITOR_EXIT, []);
    }, BrowserConstants.EDITOR_SWITCH_IN_DURATION);
    this.isBrowserShown = true;
    this.isInSwitchAnimation = true;
    this.isEditorShown = false;
    LocalStorage.getShared()?.setOrCreate<boolean>('isEditorShown', false);
    this.editorStatusChange(isVideo);
    Log.info(TAG, `emit hide animation from ${JSON.stringify(rectFrom)}`);
    let onFinish = (): void => {
      Log.info(TAG, '[EditorPhotoContext] hideEditor animation finished');
      this.isMovingPhotoEditorShown = false;
      this.isImageEditorShown = false;
      this.isInSwitchAnimation = false;
      getScreen().setDefaultStatusBarProperties(false);
      EditorPhotoContext.getInstance().clear();
      if (AccessibilityUtil.isOpenTouchGuideSync()) {
        AccessibilityUtil.sendFocusAccessibilityEvent('ToolBarButtonEdit');
      }
    };
    let timeoutId = setTimeout((): void => {
      Log.warn(TAG, 'hideEditor timeout, force finish');
      onFinish();
    }, BrowserConstants.EDITOR_SWITCH_ANIMATION_TIMEOUT_MS);
    if (this.broadCast != null) {
      // 另存退出后onEditDataLoaded timeout 情况下，使用新图uri发送广播，保证动效id匹配photoItem
      let positionUri = uri ? uri : item.uri;
      Log.info(TAG, `hideEditor ${positionUri} isVideo ${isVideo}}`);
      if (this.isFromPickerToEditor) {
        clearTimeout(timeoutId);
        onFinish();
      } else {
        let hideEditTimeOut = setTimeout(()=> {
          this.isMovingPhotoEditorShown = false;
          this.isImageEditorShown = false;
        }, BrowserConstants.EDITOR_HIDE_TIMEOUT)
        this.broadCast.emit(BroadCastConstants.ANIMATE_TO_POSITION + positionUri,
          [rectFrom, null, BrowserConstants.EDITOR_SWITCH_TOTAL_DURATION, (): void => {
            clearTimeout(hideEditTimeOut);
            clearTimeout(timeoutId);
            onFinish();
          }, (): void => {}]);
      }
    }
    let isPicker: boolean = AppStorage?.get('isPickerPage') ?? false;
    let mainWindow: window.Window | undefined =
      isPicker ? LocalStorage.getShared()?.get<window.Window>('photosUiExtensionStage') :
      LocalStorage.getShared()?.get<window.Window>('mainWindow');
    if (mainWindow) {
      mainWindow.setWaterMarkFlag(false, (err: BusinessError<void>): void => {
        if (err.code) {
          Log.error(TAG, `Failed to set window water mark. Cause: ${err}`);
          return;
        }
        Log.info(TAG, 'Succeeded in setting window water mark.');
      });
    }
    return true;
  }

  private finishShowEditorIfNeeded(): void {
    Log.info(TAG,
      `finishShowEditor:${this.isFirstFrameArrived}, ${this.showEditorAnimationFinished},${this.showEditorTimeout}`);

    if (this.isFirstFrameArrived && this.showEditorAnimationFinished && !this.showEditorTimeout) {
      hiTraceMeter.finishAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'showEditorWithAnim', 0);
      Log.info(TAG, 'showEditor finished(normal)');
      if (this.showEditorTimeoutId >= 0) {
        clearTimeout(this.showEditorTimeoutId);
        this.showEditorTimeoutId = EditorController.INVALID_TIMEOUT_ID;
      }
      if (this.shownItem?.stickerFilterName != '' &&
        this.imageEditorParams?.entryType !== ImageEditorParams.PARAM_ENTRY_TYPE_SEAL) {
        this.imageEditorStatus.isPreviewHidden = this.imageEditorParams?.entryType ===
        ImageEditorParams.PARAM_ENTRY_TYPE_STYLUS;
        animateTo({
          duration: 200,
          curve: Curve.Sharp,
          onFinish: () => {
            this.isBrowserShown = false;
            this.isInSwitchAnimation = false;
            Log.info(TAG, `finishShowEditorIfNeeded entry ${this.imageEditorParams?.entryType},
        isPreviewHidden: ${this.imageEditorStatus.isPreviewHidden} this.isMovingPhotoEditorShown:${this.isMovingPhotoEditorShown},
        this.isImageEditorShown:${this.isImageEditorShown}`);
            if (this.isMovingPhotoEditorShown && this.isImageEditorShown) {
              let tabArr = [ImageEditorParams.PARAM_ENTRY_TYPE_TEXTEDIT,
                ImageEditorParams.PARAM_ENTRY_TYPE_MOSAIC,
                ImageEditorParams.PARAM_ENTRY_TYPE_XT_STYLE,
                ImageEditorParams.PARAM_ENTRY_TYPE_SEAL];
              if (tabArr.includes(this.imageEditorParams?.entryType)) {
                this.appBroadCast.emit('enterFromMovingPhoto');
              }
            }
          }
        }, (): void => {
          this.opacity = 0;
        })
        return;
      }
      this.isBrowserShown = false;
      this.isInSwitchAnimation = false;
      this.imageEditorStatus.isPreviewHidden = this.imageEditorParams?.entryType ===
      ImageEditorParams.PARAM_ENTRY_TYPE_STYLUS;
      Log.info(TAG, `finishShowEditorIfNeeded entry ${this.imageEditorParams?.entryType},
        isPreviewHidden: ${this.imageEditorStatus.isPreviewHidden}`);
      Log.info(TAG, `this.isMovingPhotoEditorShown:${this.isMovingPhotoEditorShown},
        this.isImageEditorShown:${this.isImageEditorShown}`);
      if (this.isMovingPhotoEditorShown && this.isImageEditorShown) {
        let tabArr = [ImageEditorParams.PARAM_ENTRY_TYPE_TEXTEDIT,
          ImageEditorParams.PARAM_ENTRY_TYPE_MOSAIC,
          ImageEditorParams.PARAM_ENTRY_TYPE_XT_STYLE,
          ImageEditorParams.PARAM_ENTRY_TYPE_SEAL];
        if (tabArr.includes(this.imageEditorParams?.entryType)) {
          this.appBroadCast.emit('enterFromMovingPhoto');
        }
      }
    }
  }

  /* instrument ignore next */
  private finishShowEditorOnTimeout(): void {
    if (this.showEditorTimeout) {
      hiTraceMeter.finishAsyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'showEditorWithAnim', 0);
      Log.warn(TAG, 'showEditor finished(timeout)');
      this.isBrowserShown = false;
      this.isInSwitchAnimation = false;
      if (this.isMovingPhotoEditorShown && this.isImageEditorShown) {
        if (this.imageEditorParams?.entryType === ImageEditorParams.PARAM_ENTRY_TYPE_AI) {
          // AI云修图超时时，提示网络超时
          promptAction.showToast({
            message: $r('app.string.ai_remove_network_abnorma_toast'),
            duration: 2000,
            bottom: '186vp',
          });
        }
      }
    }
  }

  // 静图返回动图时触发，将冲突标志重置
  private handleConflictDialogFlag():void {
    AppStorage.setOrCreate('editor_screen_block_flag', false);
  }
}