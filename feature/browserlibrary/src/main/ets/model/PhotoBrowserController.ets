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
import lazy display from '@ohos.display';
import lazy { FastPhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/FastPhotoDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { BasePhotoBrowserController } from './BasePhotoBrowserController';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { LibraryConstants } from './LibraryConstants';
import lazy { image } from '@kit.ImageKit';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { common, ConfigurationConstant } from '@kit.AbilityKit';
import lazy { componentUtils, window } from '@kit.ArkUI';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { PhotoAsset } from '../view/dialog/ShareBrowserCustomDialog';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy media from '@ohos.multimedia.media';
import lazy { PhotoDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImplAsync';
import lazy { JumpType } from './LibraryConstants';
import lazy { setHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy {
  CameraAnimController, GridStartParams
} from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { BrowserCaller } from './ShowBrowserParam';
import lazy { FoldUtil } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import { PauseReason } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';

const TAG: string = 'PhotoBrowserController';
const MEDIA_TYPE_IMAGE: string = 'image';

export interface NavigationToPhoto{
  onStart: () => void;
  onFinish: () => void;
}

/**
 * 正在执行动画，此时侧滑返回被拦截，延时200毫秒后重新触发侧滑返回操作
 */
const ON_BACK_PRESS_DELAY_TIME: number = 200;

/**
 * 相机大图的控制器，作为大图组件和三方的桥接层，负责相机特殊的业务处理
 */
@Observed
export class PhotoBrowserController extends BasePhotoBrowserController {
  // 大图显示部分
  public isBrowserShow: boolean = true;
  // 非大图部分，包括actionbar、toolbar、缩略图预览条
  public isBrowserShowContent: boolean = true;
  public dataSource: FastPhotoDataSource = new FastPhotoDataSource(this.stateMachine);
  private cameraRectangleId: string = 'COMPONENT_ID_THUMBNAIL_1'
  /**
   * 隐藏大图组件回调
   */
  public hidePhotoBrowser: Function = (isPlayAni: boolean, index: number = 0): void => {
  };

  private enterOnStart: () => void = () => {
  };

  public enterOnfinish: () => void = () => {
  };

  public exitOnStart: () => void = () => {
  };

  public exitOnfinish: () => void = () => {
  };

  public getGridStartParams: () => GridStartParams = () => {
    return {
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      radius: 0,
      borderWidth: 0,
      slideBarWidth: 0,
      ratio: 1
    };
  }

  public getGridStartParamsFunc: () => GridStartParams = () => {
    let result = this.getGridStartParams();
    if (result.mDirection !== undefined) {
      return result;
    }
    if (!this.uiContext) {
      return {
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        radius: 0,
        borderWidth: 0,
        slideBarWidth: 0,
        ratio: 1
      };
    }
    const componentInfo: componentUtils.ComponentInfo =
      this.uiContext?.getComponentUtils().getRectangleById('COMPONENT_ID_THUMBNAIL_1');
    const left: number = px2vp(componentInfo.windowOffset.x);
    const right: number = left + px2vp(componentInfo.size.width);
    const top: number = px2vp(componentInfo.windowOffset.y);
    const bottom: number = top + px2vp(componentInfo.size.height);
    Log.info(TAG, `CameraAnimController left: ${left} right: ${right} top: ${top} bottom: ${bottom}`);
    return {
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      radius: componentInfo.size.width / 2,
      borderWidth: 1.5,
      slideBarWidth: 0,
      ratio: 1
    };
  }

  /**
   * 拉起大图组件初始化SystemUi属性
   *
   * @param isHorizontal 是否是横屏
   */
  public initSystemUi(isHorizontal: boolean) {
    if (!isHorizontal) {
      setTimeout((): void => {
        this.setSystemUi(false);
      }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);
    }
    AppStorage.setOrCreate<number>('fontSizeScale', this.abilityContext.config.fontSizeScale);
    AppStorage.setOrCreate<number>('currentFontSizeScale', this.abilityContext.config.fontSizeScale);
    setTimeout((): void => {
      this.setDefaultStatusBarProperties();
    }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);
  }

  public lockThumbnail() {
    this.dataSource.lockThumbnail();
  }

  public unlockThumbnail() {
    this.dataSource.unlockThumbnail();
  }

  public removeCachedThumbnail(item?: MediaItem) {
    this.dataSource.removeCachedThumbnail(item);
  }


  /**
   * 相机进大图动效初始化
   *
   * @param onEnter 动效开始回调
   * @param onExit 动效结束回调
   *
   */
  public initCameraAnim(onEnter: NavigationToPhoto, onExit: NavigationToPhoto,
    getGridStartParams: () => GridStartParams): void {
    Log.info(TAG, `initCameraAnim`);
    this.enterOnStart = onEnter.onStart;
    this.enterOnfinish = onEnter.onFinish;
    this.exitOnStart = onExit.onStart;
    this.exitOnfinish = onExit.onFinish;
    this.getGridStartParams = getGridStartParams;
    this.browserAnimController.initFun(this.enterOnStartFun, this.enterOnfinishFun, this.exitOnStartFun,
      this.exitOnfinishFun);
  }

  /**
   * 大图组件切后台
   */
  public pullUpToCamera(): void {
  }

  public enterOnStartFun: () => void = () => {
    Log.info(TAG, `enterOnStartFun`);
    this.enterOnStart();
  };
  public enterOnfinishFun: () => void = () => {
    Log.info(TAG, `enterOnfinishFun`);
    this.enterOnfinish();
  };
  public exitOnStartFun: () => void = () => {
    Log.info(TAG, `exitOnStartFun`);
    this.exitOnStart();
  };
  public exitOnfinishFun: () => void = () => {
    Log.info(TAG, `exitOnfinishFun`);
    this.exitOnfinish();
    this.hidePhotoBrowser(false);
  };
  /**
   * 进入大图动画期间，处理除了大图动画外的业务逻辑(暂未抽取完全)
   */
  public onEnterAnimating(): void {
    UiUtil.resetGeometryTransitionParams();
  }

  public setHidePhotoBrowser(hidePhotoBrowser: Function): void {
    if (typeof hidePhotoBrowser !== 'function') {
      Log.info(TAG,'hidePhotoBrowser must be a function');
    }
    this.hidePhotoBrowser = hidePhotoBrowser;
  };

  public setCameraAnimController(): void {
    let cameraAnimController: CameraAnimController =
      new CameraAnimController(this.uiContext, this.getGridStartParamsFunc);
    this.browserAnimController.init(cameraAnimController);
  }

  private lastCaptureMediaUri: string | undefined = undefined;
  // 点击缩略图拉起大图组件时间点
  private clickThumbnailTime = 0;
  private saveOverTime: number = 0;
  private largePhotoCompletedFunc: (captureId: string, thumbnailUri: string, uri: string, index: number) =>
  void = (captureId: string, thumbnailUri: string, uri: string, index: number): void => {
    this.onLargePhotoCompleted(captureId, thumbnailUri, uri, index);
  }

  /**
   * 大图组件控制器，使用三方传递的上下信息，完成初始化
   *
   * @param abilityContext 三方传入的 ability 上下文信息
   * @param windowStage 三方传入的窗口信息
   * @param abilityStage 三方传入的 ability 信息
   */
  constructor(abilityContext: common.UIAbilityContext, windowStage: window.WindowStage |
  undefined, abilityStage: Context) {
    super(abilityContext, windowStage, abilityStage);
    LocalStorage.getShared()?.setOrCreate('photosAbilityContext', abilityContext);
    global.setCtx(abilityContext);
    AppStorage.setOrCreate('formContext', abilityContext);
    if (windowStage) {
      LocalStorage.getShared()?.setOrCreate('photosWindowStage', windowStage);
    }
    AppStorage.setOrCreate('photosGlobalContext', abilityStage);
    AppStorage.setOrCreate<ConfigurationConstant.ColorMode>('currentColorMode', abilityContext.config.colorMode);
    AppStorage.setOrCreate<number>('fontSizeScale', abilityContext.config.fontSizeScale);
    AppStorage.setOrCreate<number>('currentFontSizeScale', abilityContext.config.fontSizeScale);
    if (!AppStorage.get<string>('cameraShotKey')) {
      AppStorage.setOrCreate<string>('cameraShotKey', '');
    }
  }

  public registerBroadCast(broadCast?: BroadCast): void {
    super.registerBroadCast(broadCast);
    this.appBroadCast.on(BroadCastConstants.LARGE_PHOTO_COMPLETED, this.largePhotoCompletedFunc);
  }

  public unregisterBroadCast(broadCast?: BroadCast): void {
    super.unregisterBroadCast(broadCast);
    this.appBroadCast.off(BroadCastConstants.LARGE_PHOTO_COMPLETED, this.largePhotoCompletedFunc);
  }

  /**
   * 相机新拍照每次都会调用，用于更新index，保持与相机左下角一致
   * setCurrentMediaUri、setLastCaptureMediaUri时序：
   * 1.相机每次拍照调用setCurrentMediaUri设置mediaUri
   * 2.相机点击左下角缩略图，调用setCurrentMediaUri设置pixmap，如果此时80分未落盘，后续通过
   * setLastCaptureMediaUri设置点击时的mediaUri
   * MediaUri可能和拍照顺序不一致
   * @param mediaUri
   * @deprecated
   */
  public setCurrentMediaUri(mediaUri?: string, pixmap?: image.PixelMap): void {
    if (!pixmap && !mediaUri) {
      Log.error(TAG, '[enterLibrary] error happened. the param of pixelMap and mediaUri is undefined');
      return;
    }
    if (this.isPhotoBrowserViewShow) {
      return;
    }
    // 默认设置index为0
    this.setDefaultIndex();
    // 非拍照点击场景/单段式拍照，只会传url，不会传pixelMap,依赖图库从媒体库中查询
    if (mediaUri && !pixmap) {
      Log.info(TAG, `[enterLibrary] pull up photo component, mediaUri is ${mediaUri}`);
      this.setLastCaptureMediaUriInner(mediaUri);
      this.setCurrentMediaUriInner(mediaUri);
      PhotoConfig.setIsSupportFastThumbnail(false);
      return;
    }
    let imageInfo = pixmap?.getImageInfoSync();
    Log.info(TAG, `[enterLibrary] set piexlMap mediaUri: ${mediaUri}, this.singleGeometryId: ${this.singleGeometryId},
        size(${imageInfo?.size?.width}, ${imageInfo?.size?.height}), this.hashCode: ${this.hashCode}`);
    // 80分图落盘场景，同时会有uri和pixelMap
    this.pixmap = pixmap;
    LocalStorage.getShared()?.setOrCreate('fastPixmap', pixmap);
    this.setLastCaptureMediaUriInner(mediaUri);
    if (mediaUri) {
      this.setCurrentMediaUriInner(mediaUri);
      this.saveOverTime = setTimeout((): void => {
        Log.info(TAG, `[enterLibrary]setCurrentMediaUri saveOvertime ${mediaUri} ${this.getCurrentIndex()}`);
        this.onLargePhotoCompleted(mediaUri, mediaUri, mediaUri, 0);
      }, 2000);
    }
    PhotoConfig.setIsSupportFastThumbnail(true);
  }

  protected setDefaultIndex(index: number = 0): void {
    Log.info(TAG, `[enterLibrary] setDefaultIndex ${this.getCurrentIndex()}`);
    this.setTargetIndex(index);
    if (this.getCurrentIndex() === index) {
      return;
    }
    this.setCurrentItem(index);
    this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [index]);
  }

  private setLastCaptureMediaUriInner(mediaUri?: string): void {
    this.lastCaptureMediaUri = mediaUri;
    let lastUri = this.dataSource.getUriByCaptureId(mediaUri ?? '');
    LocalStorage.getShared()?.setOrCreate<string>('lastUri', !!lastUri ? lastUri : mediaUri);
  }

  /**
   *  大图加载完成之后广播调用，触发swiper动效替换pixelMap
   * @param uri 完成加载的大图uri
   * @param index 大图mPosition
   */
  private onLargePhotoCompleted(captureId: string, thumbnailUri: string, uri: string, index: number): void {
    Log.info(TAG, `onLargePhotoCompleted captureId: ${captureId} thumbnailUri: ${thumbnailUri} uri: ${uri},
    lastCaptureMediaUri: ${this.lastCaptureMediaUri}`);
    if (this.lastCaptureMediaUri && StringUtil.isSamePhotoAsset(captureId, thumbnailUri, uri,
      this.lastCaptureMediaUri) && PhotoConfig.getIsSupportFastThumbnail()) {
      Log.info(TAG, `[enterLibrary] onLargePhotoCompleted ${uri} ${this.lastCaptureMediaUri}`);
      clearTimeout(this.saveOverTime);
      this.emitCallback(LibraryConstants.LOAD_SWIPERVIEW, []);
      this.lastCaptureMediaUri = undefined;
      this.appBroadCast.off(BroadCastConstants.LARGE_PHOTO_COMPLETED, this.largePhotoCompletedFunc);
      if (this.getCurrentIndex() !== index) {
        this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [this.getCurrentIndex()]);
      }
      this.appBroadCast.emit(BroadCastConstants.OPEN_MOVING_PHOTO_FROM_LIBRARY, [index]);
      this.setCurrentIndex(index);
      this.currentMediaUri = uri;
      this.currentMediaUriOnSubScreen = thumbnailUri;
      this.dataSource.updateCurrent(index);
      this.emitCallback(LibraryConstants.UPDATE_CURRENT_INDEX, [index]);
      this.setTargetIndex(index);
    }
  }

  /**
   * 拉起时80分图未落盘，后补uri给图库
   * @param mediaUri
   * @deprecated
   */
  public setLastCaptureMediaUri(mediaUri: string): void {
    Log.info(TAG, `[enterLibrary] setLastCaptureMediaUri mediaUri: ${mediaUri}, currentIndex: ${this.getCurrentIndex()}`);
    this.setLastCaptureMediaUriInner(mediaUri);
    PhotoConfig.setIsSupportFastThumbnail(true);
    this.setCurrentMediaUriInner(mediaUri);
    // 未落盘场景下有可能出现落盘失败的情况，5s后直接显示swiper第一张图
    clearTimeout(this.saveOverTime);
    this.saveOverTime = setTimeout((): void => {
      Log.info(TAG, `[enterLibrary]saveOvertime ${mediaUri} ${this.getCurrentIndex()}`);
      this.onLargePhotoCompleted(mediaUri, mediaUri, mediaUri, 0);
    }, 5000);
  }

  /**
   * 增加缩略图（注：相机需保证按序调用此接口新增缩略图）
   *
   * @param captureId 缩略图ID
   * @param pixmap 真正的缩略图
   */
  public addThumbnail(captureId: string, pixmap: image.PixelMap, isLivePhoto: boolean,
    params: Map<string, object>): void {
    TraceControllerUtils.startTrace(`addThumbnail-${captureId}`);
    Log.info(TAG, `[enterLibrary] addThumbnail ${captureId}`);
    this.setCurrentItem(0);
    this.dataSource.addThumbnail(captureId, pixmap, isLivePhoto);
    TraceControllerUtils.finishTrace(`addThumbnail-${captureId}`);
  }

  /**
   * 更新缩略图
   *
   * @param captureId 缩略图ID
   * @param photoAsset 图片基本信息
   */
  public updateThumbnail(captureId: string, photoAsset: photoAccessHelper.PhotoAsset): void {
    TraceControllerUtils.startTrace(`updateThumbnail-${captureId}-${photoAsset?.uri}`);
    Log.info(TAG, `[enterLibrary] updateThumbnail ${captureId} uri: ${photoAsset?.uri}`);
    this.dataSource.updateThumbnail(captureId, photoAsset);
    if (LocalStorage.getShared()?.get<string>('lastUri') === captureId) {
      LocalStorage.getShared()?.setOrCreate<string>('lastUri', photoAsset.uri);
    }
    TraceControllerUtils.finishTrace(`updateThumbnail-${captureId}-${photoAsset?.uri}`);
  }
  /**
   * 删除缩略图（用于连拍场景的删除）
   *
   * @param captureId 缩略图ID
   */
  public removeThumbnail(captureId: string): void {
    Log.info(TAG, `[enterLibrary] removeThumbnail ${captureId}`);
    this.dataSource.removeThumbnail(captureId);
  }

  /**
   * 设置当前图片的 GeometryId，用于后续一镜到底动效的图片配对
   *
   * @param singleGeometryId 一镜到底动效 ID
   */
  public setSingleGeometryId(singleGeometryId: string): void {
    Log.info(TAG, `old singleGeometryId: ${this.singleGeometryId}, new singleGeometryId: ${singleGeometryId}`);
    this.singleGeometryId = singleGeometryId;
    if (!this.pixmap) {
      LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', this.singleGeometryId);
    }
  }

  /**
   *  更新大图组件CameraShotKey
   *
   * @param cameraShotKey 锁屏状态的key
   */
  public updateCameraShotKey(cameraShotKey: string | undefined): void {
    if (this.cameraShotKey !== cameraShotKey) {
      this.cameraShotKey = cameraShotKey;
      AppStorage.setOrCreate<string>('cameraShotKey', assert.asDefault(this.cameraShotKey, ''));
      if (!this.cameraShotKey) {
        this.dataSource.onChange(MEDIA_TYPE_IMAGE, true);
      } else {
        Log.debug(TAG, 'no need data reload on security gallery');
      }
    }
  }

  protected DataContentChanged(): void {
    this.reportToBigDataForCameraIn()
    super.DataContentChanged();
  }

  /**
   * 数据上报回调，上报用户从相机拉起大图组件
   */
  private reportToBigDataForCameraIn(): void {
    if (this.clickThumbnailTime === 0) {
      return;
    }

    interface Msg {
      clickThumbnailTime: number;
      ShowSinglePhoto: number;
      FileName?: string;
    }

    let msg: Msg = {
      clickThumbnailTime: this.clickThumbnailTime,
      ShowSinglePhoto: Date.now(),
    }
    let fileName = ReportToBigDataUtil.getFileNameOfPhotoTakenByCamera(this.getPhotoByIndex(0));
    if (fileName) {
      msg.FileName = fileName;
    }

    ReportToBigDataUtil.report(BigDataConstants.BROWSE_PHOTO_FROM_CAMERA_ID, msg);
    this.clickThumbnailTime = 0;
  }

  /**
   * 数据集 dataSource 内容有变化时候触发回调，以相机场景为例子，通常发生在生成新图片、新视频时候
   *
   * @param changeType 新增内容类型，当前支持图片或视频
   */
  public onMediaLibDataChange(changeType: string): void {
    super.onMediaLibDataChange(changeType);
    // 待相机模块有媒体库监听逻辑后，可删除此逻辑
    // 当 PhotoBrowserView 组件还未加载时，收到媒体库变化（新增或删除时），需要重新更新下index
    if (!this.dataSource.hasThumbnail()) {
      this.changeCurrentMediaUri(this.currentMediaUri);
    }
  }

  /**
   * 数据集 dataSource 内容有变化时候触发回调，以相机场景为例子，通常发生在生成新图片、新视频时候
   *
   * @param changeType 新增内容类型，当前支持图片或视频
   */
  public onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    super.onMediaLibDataNfy(nfyInfo);
    // 待相机模块有媒体库监听逻辑后，可删除此逻辑
    // 当 PhotoBrowserView 组件还未加载时，收到媒体库变化（新增或删除时），需要重新更新下index
    if (!this.dataSource.hasThumbnail()) {
      this.changeCurrentMediaUri(this.currentMediaUri);
    }
  }

  /**
   * 大图组件返回操作回调
   * isMouseScrolling  首次进入相机大图动效中是否鼠标滚动
   */
  public onBackPress(isNoPhotos?: boolean, isMouseScrolling?: boolean): void {
    if (PhotoConfig.isSwitchSwiper) {
      // 正在进行SwitchSwiper动画，返回操作被拦截了，延时200再次触发
      Log.warn(TAG, 'on back press return, IsSwitchSwiper is true');
      clearTimeout(this.backPressOverTime);
      this.backPressOverTime = setTimeout((): void => {
        Log.info(TAG, `on back press again`); // 延时200再次触发
        this.onBackPress(isNoPhotos, isMouseScrolling);
      }, ON_BACK_PRESS_DELAY_TIME);
      return;
    }
    Log.info(TAG, 'on back press');
    this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_CENTER, []);
    this.emitCallback(LibraryConstants.CONTROLLER_BACK_EVENT,
      [(isPullingUp: boolean, isEditorBack: boolean, isShowVideo: boolean,
        videoState: media.AVPlayerState, isSwiperOffsetZero: Boolean) => {
        if (isPullingUp) {
          let item: MediaItem | undefined = this.getPhotoByIndex(this.getTargetIndex());
          this.broadCast.emit(BroadCastConstants.CLOSE_CLICK_DETAIL_BY_BACK_PRESS + item?.path, []);
        } else if (isEditorBack) {
          Log.info(TAG, 'is editor back');
        } else if (isMouseScrolling) {
          // 相机大图鼠标向上滚动不退出
          Log.info(TAG, 'is mouse rolling');
        } else {
          Log.info(TAG, 'jump to camera start');
          if (!this.isSandboxEnv) {
            try {
              PhotoDataImplAsync.startPrelaunch(this.abilityContext).then((): void => {
                Log.debug(TAG, 'prelaunch finish');
              });
            } catch (err) {
              Log.error(TAG, `camera open prelaunch error: ${err}, code: ${err?.code}`);
            }
          }
          this.emitCallback(LibraryConstants.JUMP_TYPE, [JumpType.JUMP_TO_CAMERA, Date.now()]);
          Log.info(TAG, `onBackPress, isBrowserFullShow: ${this.isBrowserFullShow}`);
          this.updateTransIdAndDoMenuBack(isNoPhotos);
        }
      }]);
  }

  public onAppearSwing(): void {
    this.initSwingService();
  }

  public onDisappearSwing(): void {
    this.cancelSwingService();
  }

  public onPageShowSwing(): void { }
  public onPageShowDial(): void { }

  public onWindowStatusShareListen(windowType?: window.WindowStageEventType, windowStatus?: number): void { }

  public onPageHideEnd(): void {
    super.onPageHideEnd();
    if (this.pageFrom !== BrowserCaller.PUZZLE_PAGE) {
      this.setRotationCapability(false);
    }
    if (FoldUtil.isTriExpand(FoldUtil.getInstance().getCurFoldStatus()) || DeviceInfo.isTv()) {
      Log.info(TAG, 'isTriExpand or isTv');
      return;
    }
    setHorizontal(false);
  }

  public onPageHideSwing(): void { }

  public onPageHideDial(): void { }

  public goToPhotosAction(currentPhoto: MediaItem | undefined): void {
    let param: Want = {
      bundleName: 'com.ohos.photos',
      abilityName: 'com.ohos.photos.MainAbility',
      parameters: {
        uri: Constants.WANT_PARAM_URI_CAMERA,
      }
    };
    Log.debug(TAG, `routeToTimelinePage parm: ${JSON.stringify(param)}`);
    this.videoPlayController?.pause(PauseReason.OTHERS);
    this.abilityContext.startAbility(param);
    this.emitCallback(LibraryConstants.JUMP_TYPE, [JumpType.JUMP_TO_TIMELINE]);
  }

  public updateHorizontal(): void {
    let originOrientation: display.Orientation = 0;
    if (!DeviceInfo.isVerdeFoldable()) {
      try {
        originOrientation = getScreen().getDisplayFixedForSmallFold().orientation;
      } catch (error) {
        Log.error(TAG, `getDefaultDisplaySync failed, error: ${error}, code: ${error?.code}`);
      }
    }
    Log.info(TAG, `updateHorizontal orientation: ${originOrientation}`);
    if (originOrientation === display.Orientation.LANDSCAPE ||
      originOrientation === display.Orientation.LANDSCAPE_INVERTED) {
      setHorizontal(true);
    } else {
      setHorizontal(false);
    }
  }
}