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
import lazy window from '@ohos.window';
import lazy { Router, UIContext } from '@ohos.arkui.UIContext';
import lazy { CustomColors } from '@ohos.arkui.theme';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { JumpSourceToMain } from '@ohos/common/src/main/ets/default/model/browser/photo/JumpSourceToMain';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { Constants as CommonConstants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { SingleSelectionMode } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { ShortCut } from '@ohos/common/src/main/ets/default/model/ShortCut';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BasePhotoBrowserController } from './BasePhotoBrowserController';
import lazy { BrowserCaller, ShowBrowserParam } from './ShowBrowserParam';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { PhotoAsset } from '../view/dialog/ShareBrowserCustomDialog';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy settings from '@ohos.settings';
import lazy display from '@ohos.display';
import lazy { PhotoBrowserUtils } from '@ohos/common/src/main/ets/default/utils/PhotoBrowserUtils';
import lazy { LibraryConstants } from './LibraryConstants';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy common from '@ohos.app.ability.common';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { MenuOperationFactory } from '@ohos/common/src/main/ets/default/interface/MenuOperationFactory';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy {
  GotoPhotosMenuOperation
} from '@ohos/common/src/main/ets/default/view/browserOperation/GotoPhotosMenuOperation';
import lazy { BrowserAnimController } from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';

const TAG: string = 'PhotosHmBrowserController';

// animateTo动效2s超时
const ANIMATE_TIME_LIMIT = 2000;
const SWITCH_DIFFER_ALBUM_DELAY = 20;

export interface Params {
  showCancel: boolean;
  position: number;
  bundleName: string;
  tokenId: number;
  transition: string;
  title: string;
  selectMode: boolean;
  maxSelectCount: number;
  maxSelectedReminderMode: number;
  isFromFa: boolean;
  geometryTransitionEnable: boolean;
  isNeedSelectBar: boolean;
  isShowSerialNum: boolean;
  isFromPickerView: boolean;
  singleSelectionMode: SingleSelectionMode;
  checkBoxColor: string;
  checkboxTextColor: string;
  isOriginalSupported: boolean;
  photoBrowserBackgroundColorMode: number;
  isRepeatSelectSupported: boolean;
  customColor: CustomColors | undefined;
  completeButtonText: number;
  isPhotoBrowserCheckboxVisible: boolean;
  isPhotoBrowserBackButtonVisible: boolean;
  photoBrowserCheckboxPosition: [number, number];
  isImmersiveCompared: boolean;
  isCollagePageEnter: boolean;
  highlightPickerType: string;
  isHighlightPickerView: boolean;
  photoBrowserMargin: Margin;
}

/**
 * 图库大图的控制器，作为大图组件和图库的桥接层，负责图库特殊的业务处理
 */
@Observed
export class PhotosHmBrowserController extends BasePhotoBrowserController {
  public geometryTransitionEnable: boolean = false;
  public browserParam?: Object;
  public browserBackFunc: Function = (): void => {
  };
  public isSelectBrowserShow: boolean = false;
  public selectBrowserParam?: Object;
  public isStartHide: boolean = false;
  public isStartShowWhileHide: boolean = false;
  public isSelectedMode: boolean = false;
  public enableClick: boolean = true;
  private animateCounter: number = 0;
  private isEntering: boolean = true;
  public isFromSearch: boolean = false;
  public dataSource: PhotoDataSource = new PhotoDataSource(this.stateMachine);
  private originOrientation: number = 0;
  private shareIsInit: boolean = false;
  private shareTimer: number = Number.NaN;
  private focusCtrlManager = FocusCtrlManager.getInstance();
  // public photosRotateType: string = PhotosRotateType.TYPE_SYSTEM;

  public showBrowser(geometryIndex: number, geometryString: string, name: string, param: Object, param1: ShowBrowserParam): void {
    Log.info(TAG, 'call show browser geometryIndex ' + geometryIndex + ` geometryString ${geometryString}`);
    LocalStorage.getShared()?.setOrCreate<number>('currentOperateControllerId', this.browserControllerId)
    this.showBrowserInner(param, param1);

    // instrument ignore else
    if (geometryIndex !== undefined && geometryString !== undefined) {
      this.setCurrentIndex(geometryIndex);
      this.stateMachine.processThumnailViewShowEvent();
      Log.info(TAG, 'Showing large image');
      this.geometryTransitionEnable = true;
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_ANIMATION_START);
      this.isAnimating = true;
      this.isStartShowWhileHide = this.isStartHide;
      let timer: number = setTimeout((): void => {
        Log.error(TAG, `showBrowser timeout, geometryIndex=${geometryIndex}`);
      }, ANIMATE_TIME_LIMIT)
      // 大图打开
      this.isEntering = true;
      this.stateMachine.processExitAnimationEndEvent();
      // 大图打开，isShowBrowserAni 是否在做大图打开动效，默认为false
      LocalStorage.getShared()?.setOrCreate<boolean>('isShowBrowserAni', true);
      if (this.browserAnimController.isTransitionEnable) {
        performanceMonitor.begin(BigDataConstants.OPEN_BROWSER, performanceMonitor?.ActionType.LAST_UP);
        // 退出大图会将url置为astc，复用大图时需要重置回去
        this.appBroadCast.emit(BroadCastConstants.RECOVER_SHOW_RESOURCE);
      }
      Log.info(TAG, 'animateToImmediately start');
      if (!this.browserAnimController.isTransitionEnable) {
        this.browserParam = param;
        this.isBrowserShow = true;
      }
      animateToImmediately({
        // TODO: 等it4的时候将这块逻辑和新动画区分，onfinish逻辑放到新动画里
        duration: Constants.OPEN_PHOTO_DURATION,
        curve: Constants.OPEN_PHOTO_CURVE,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        onFinish: () => {
          Log.debug(TAG, 'show browser animate end');
          clearTimeout(timer);
          if (this.browserAnimController.isTransitionEnable) {
            performanceMonitor.end(BigDataConstants.OPEN_BROWSER);
          }
          if (!this.isEntering) {
            return;
          }
          ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_ANIMATION_FINISH);
          this.finishAnimation();
          LocalStorage.getShared()?.setOrCreate<boolean>('isShowBrowserAni', false);

          if (name !== 'ThirdSelectPhotoGridBase' && !(param as Params)?.isCollagePageEnter) {
            // this.photosRotateType = PhotosRotateController.getPhotosRotateType(getContext(this));
            // if (DeviceInfo.isPhone() && !DeviceInfo.isFoldDevice() &&
            //   this.photosRotateType == PhotosRotateType.TYPE_ALWAYS) {
            // } else {
            //   // 后续横竖屏适配需求完成后放开
            //   WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
            // }
          }
          try {
            this.originOrientation = display.getDefaultDisplaySync().orientation;
          } catch (error) {
            Log.error(TAG, `getDefaultDisplaySync error: ${error}, code: ${error?.code}`);
          }
          Log.warn(TAG, `display orientation: ${this.originOrientation}`);
        }
      }, (): void => {
        Log.info(TAG, 'animateToImmediately end');
        Log.info(TAG, `showBrowse isBrowserShow:${this.isBrowserShow}`);
        UiUtil.updateGeometryTapInfo(geometryIndex, geometryString);
        if (this.browserAnimController.isTransitionEnable) {
          UiUtil.resetGeometryTransitionParams();
          this.browserParam = param;
          this.isBrowserShow = true;
        }
        LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', true);
        this.pageFrom = name;
        this.appBroadCast.emit(BroadCastConstants.OPEN_BROWSER_IN_SELECT_VIEW);
      });

      Log.info(TAG, 'call show browser non-image content');
      this.doAnimate();

    } else {
      geometryIndex = -1;
      geometryString = '';
      UiUtil.resetGeometryTransitionParams();
      UiUtil.updateGeometryTapInfo(geometryIndex, geometryString);
      this.geometryTransitionEnable = false;
      this.isBrowserShow = true;
      LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', true);
      this.pageFrom = name;
      this.browserParam = param;
      this.isAnimating = false;
      this.isDrag = false;
      this.appBroadCast.emit(BroadCastConstants.OPEN_BROWSER_IN_SELECT_VIEW);
    }
  }

  /**
   * 进入大图动画期间，处理除了大图动画外的业务逻辑(暂未抽取完全)
   */
  public onEnterAnimating(): void {
    UiUtil.resetGeometryTransitionParams();
  }

  /**
   * 进入大图前，处理除了大图动画外的业务逻辑(暂未抽取完全)
   */
  public enterOnStartFun: () => void = () => {
    // 退出大图会将url置为astc，复用大图时需要重置回去
    this.appBroadCast.emit(BroadCastConstants.RECOVER_SHOW_RESOURCE);
  }

  /**
   * 进入大图后，处理除了大图动画外的业务逻辑(暂未抽取完全)
   */
  public enterOnfinishFun: () => void = () => {

  }

  /**
   * 进入大图前，处理除了大图动画外的业务逻辑(暂未抽取完全)
   */
  public exitOnfinishFun: () => void = () => {

  }


  doAnimate(): void {
    animateToImmediately({
      curve: Constants.OPEN_OTHER_CONTENT,
      delay: Constants.OPEN_OTHER_CONTENT_DURATION,
    }, (): void => {
      this.isBrowserShowContent = true;
    });
  }

  hideBrowser(position: number, aniFunc?: Function): void {
    Log.info(TAG, `call hide browser, isDrag = ${this.isDrag}`);
    LocalStorage.getShared()?.setOrCreate<number>('currentOperateControllerId', this.browserControllerId)
    this.isStartHide = true;
    let storage = LocalStorage.getShared();
    this.isBrowserShowContent = false;
    let timer: number = setTimeout((): void => {
      Log.error(TAG, `hideBrowser timeout, geometryIndex=${position}`);
    }, ANIMATE_TIME_LIMIT)
    this.isEntering = false;
    this.animateCounter++;
    if (storage?.has(CommonConstants.PHOTO_PICKER_SESSION_KEY)) {
      this.isAnimating = true;
      animateTo({
        curve: Constants.CLOSE_PHOTO_CURVE,
        onFinish: (): void => {
          clearTimeout(timer);
          if (this.isStartShowWhileHide) {
            this.isStartHide = false;
            return;
          }
          LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
          UiUtil.resetGeometryTransitionParams();
          this.finishAnimation();
        }
      }, (): void => {
        Log.info(TAG, `hideBrowserIf isBrowserShow:${this.isBrowserShow}`);
        this.isBrowserShow = false;
        this.isBrowserShowContent = false;
        LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', false);
        this.browserParam;
        LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', -(position + 1));
        this.appBroadCast.emit(BroadCastConstants.CLOSE_BROWSER_AND_RETURN_TO_SELECT_VIEW);
      });
    } else {
      let isGalleryCleanupPage: boolean = storage?.get<boolean>(CommonConstants.IS_GALLERY_CLEANUP_PAGE) ?? false;
      Log.info(TAG, `hideBrowser isGalleryCleanupPage = ${isGalleryCleanupPage}`);
      if (isGalleryCleanupPage) {
        this.isAnimating = true;
        animateToImmediately({
          curve: Constants.CLOSE_PHOTO_CURVE,
          onFinish: (): void => {
            this.afterAnimation(timer, position);
          }
        }, (): void => {
          this.beforeAnimation(position, aniFunc);
        });
      } else {
        let uiContext: UIContext = LocalStorage.getShared()?.get<UIContext>('uiContext') as UIContext;
        if (!uiContext) {
          Log.error(TAG, 'uiContext undefined');
          return;
        }
        this.isAnimating = true;
        if (this.browserAnimController.isTransitionEnable) {
          performanceMonitor.begin('CLOSE_BROWSER', performanceMonitor?.ActionType.LAST_UP);
        }
        TraceControllerUtils.startTrace('Exit Big Photo');
        uiContext.animateToImmediately({
          curve: Constants.CLOSE_PHOTO_CURVE,
          onFinish: (): void => {
            this.afterAnimation(timer, position);
            if (this.browserAnimController.isTransitionEnable) {
              performanceMonitor.end('CLOSE_BROWSER');
            }
            TraceControllerUtils.finishTrace('Exit Big Photo');
          }
        }, (): void => {
          this.beforeAnimation(position, aniFunc);
        });
      }

    }
  }

  private beforeAnimation(position: number, aniFunc?: Function): void {
    Log.info(TAG, `hideBrowserElse isBrowserShow:${this.isBrowserShow}`);
    if (aniFunc) {
      aniFunc()
    } else {
      this.isBrowserShow = false;
    }
    this.isBrowserShowContent = false;
    LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', false);
    this.browserParam;
    LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', -(position + 1));
    this.appBroadCast.emit(BroadCastConstants.CLOSE_BROWSER_AND_RETURN_TO_SELECT_VIEW);
  }

  private afterAnimation(timer: number, position: number): void {
    clearTimeout(timer);
    this.animateCounter--;
    Log.info(TAG,
      `hideBrowser animateCounter=${this.animateCounter}, isStartShowWhileHide=${this.isStartShowWhileHide}`)
    if (this.animateCounter > 0 || this.isEntering) {
      return;
    }
    Log.info(TAG, `hideBrowser finish position=${position}, reset geometryTransitionBrowserId`);
    LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
    if (this.browserAnimController.isTransitionEnable) {
      UiUtil.resetGeometryTransitionParams();
    }
    this.finishAnimation();
  }

  /* instrument ignore next */
  hideBrowserImmediately(): void {
    Log.info(TAG, `call hide browser immediately, isDrag = ${this.isDrag}` + this.isBrowserShow);
    this.isBrowserShow = false;
    LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', false);
    this.browserParam;
    this.isAnimating = false;
    this.isDrag = false;
    this.isStartHide = false;
    this.appBroadCast.emit(BroadCastConstants.CLOSE_BROWSER_AND_RETURN_TO_SELECT_VIEW);
  }

  showSelectBrowser(geometryIndex: number, geometryString: string, name: string, param: Object, param1?: ShowBrowserParam): void {
    Log.info(TAG, 'call show select browser');
    LocalStorage.getShared()?.setOrCreate<number>('currentOperateControllerId', this.browserControllerId)
    this.setCurrentIndex(geometryIndex);
    this.isAnimating = true;
    this.showBrowserInner(param, param1);
    this.stateMachine.processThumnailViewShowEvent();
    let timer: number = setTimeout((): void => {
      Log.error(TAG, `showSelectBrowser timeout, geometryIndex=${geometryIndex}`);
    }, ANIMATE_TIME_LIMIT)
    LocalStorage.getShared()?.setOrCreate<boolean>('isShowBrowserAni', true);
    this.isEntering = true;
    this.stateMachine.processExitAnimationEndEvent();
    this.geometryTransitionEnable = true;
    if (this.browserAnimController.isTransitionEnable) {
      // 退出大图会将url置为astc，复用大图时需要重置回去
      this.appBroadCast.emit(BroadCastConstants.RECOVER_SHOW_RESOURCE);
    }
    animateTo({
      // TODO: 等it4的时候将这块逻辑和新动画区分，onfinish逻辑放到新动画里
      duration: Constants.OPEN_PHOTO_DURATION,
      curve: Constants.OPEN_PHOTO_CURVE,
      onFinish: () => {
        clearTimeout(timer);
        if (!this.isEntering) {
          return;
        }
        this.finishAnimation();
        LocalStorage.getShared()?.setOrCreate<boolean>('isShowBrowserAni', false);
      }
    }, (): void => {
      UiUtil.updateGeometryTapInfo(geometryIndex, geometryString);
      if (this.browserAnimController.isTransitionEnable) {
        UiUtil.resetGeometryTransitionParams();
      }
      this.isSelectBrowserShow = true;
      this.pageFrom = name;
      this.selectBrowserParam = param;
    });
  }

  hideSelectBrowser(position: number): void {
    Log.info(TAG, `call hide select browser, isDrag = ${this.isDrag}`);
    LocalStorage.getShared()?.setOrCreate<number>('currentOperateControllerId', this.browserControllerId)

    this.isStartHide = true;
    this.isAnimating = true;
    let timer: number = setTimeout((): void => {
      Log.error(TAG, `hideSelectBrowser timeout, geometryIndex=${position}`);
    }, ANIMATE_TIME_LIMIT)
    this.isEntering = false;
    this.geometryTransitionEnable = false;
    animateTo({
      curve: Constants.CLOSE_PHOTO_CURVE,
      onFinish: (): void => {
        clearTimeout(timer);
        this.animateCounter--;
        Log.info(TAG,
          `hideSelectBrowser animateCounter=${this.animateCounter}, isStartShowWhileHide=${this.isStartShowWhileHide}`)
        if (this.animateCounter > 0 || this.isEntering) {
          return;
        }
        Log.info(TAG, `hideSelectBrowser finish position=${position}, reset geometryTransitionBrowserId`);
        LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
        UiUtil.resetGeometryTransitionParams();
        this.finishAnimation();
      }
    }, (): void => {
      this.isSelectBrowserShow = false;
      this.selectBrowserParam;
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', -(position + 1));
    });
  }

  /* instrument ignore next */
  hideSelectBrowserImmediately(position: number): void {
    Log.info(TAG, `call hide select browser, isDrag = ${this.isDrag}`);
    this.isSelectBrowserShow = false;
    this.selectBrowserParam;
    this.isAnimating = false;
    this.isDrag = false;
    this.isStartHide = false;
  }

  finishAnimation(): void {
    Log.info(TAG, `finishAnimation isAnimating = false, isSelectedMode: ${this.isSelectedMode}`);
    this.isAnimating = false;
    this.isDrag = false;
    this.isStartHide = false;
    this.isStartShowWhileHide = false;
    if (!DeviceInfo.isPhoneUx() && this.focusCtrlManager.getFocusItemKey() &&
      !this.isBrowserShow && !this.isSelectedMode) {
      focusControl.requestFocus(this.focusCtrlManager.getFocusItemKey());
      ShortCut.mSelectManager?.deSelectAll();
      this.focusCtrlManager.getFocusItemUri() &&
      ShortCut.mSelectManager?.toggle(this.focusCtrlManager.getFocusItemUri(), true);
    } else if (DeviceInfo.isPc() && !this.isBrowserShow && this.isSelectedMode) {
      focusControl.requestFocus(this.focusCtrlManager.getFocusItemKey());
      ShortCut.mSelectManager?.deSelectAll();
      this.focusCtrlManager.getFocusItemUri() &&
      ShortCut.mSelectManager?.toggle(this.focusCtrlManager.getFocusItemUri(), true);
    }
  }

  // TODO: 大图拉起和大图组件拉起菜单更新逻辑区分 + 重构
  public async updateMenu(index: number, isShowVideo?: boolean): Promise<void> {
    super.updateMenu(index, isShowVideo);
  }

  initSelectPhotoBrowserDatasource(pageFrom: number, deviceId: string, broadCast: BroadCast): void {
    if (pageFrom == CommonConstants.ENTRY_FROM.RECYCLE) {
      this.dataSource = new PhotoDataSource(this.stateMachine, 'Recycle');
    } else if (pageFrom == CommonConstants.ENTRY_FROM.DISTRIBUTED) {
      this.dataSource.setDeviceId(deviceId);
    }
    this.dataSource.setAlbumDataSource(AppStorage.get<MediaDataSource>(CommonConstants.APP_KEY_PHOTO_BROWSER));
    this.dataSource.setBroadCast(broadCast);
    this.dataSource.setBroadCastToAlbum(broadCast);
  }

  // 图库大图组件 对比按钮
  public getEnhancedPhotoCompare(currentPhoto: MediaItem, enhancedPhoto: PhotoAsset | undefined) {
    if (enhancedPhoto) {
      this.dataSource.getMediaItemByUri(enhancedPhoto.uri, (item: MediaItem | undefined) => {
        Log.info(TAG, `handleCloudEnhanceCompare compare ${enhancedPhoto?.uri} ${item?.index} ${item?.uri}`);
        if (currentPhoto && item) {
          this.setComparedList(currentPhoto, item);
        }
      });
    } else if (this.comparable && this.comparedMediaItem) {
      this.setComparedList(currentPhoto, this.comparedMediaItem);
    }
  }

  private setComparedList(cur: MediaItem, target: MediaItem): void {
    Log.info(TAG, `setComparedList isFromSearch ${this.pageFrom === BrowserCaller.SEARCH_GRID_PAGE ||
      this.pageFrom === BrowserCaller.SEARCH_SLOT_ITEM_PAGE} `);
  }

  // 根据旋转开关控制窗口旋转
  async resetOrientation(): Promise<void> {
    WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
  }

  /**
   * 图库大图返回操作回调
   *
   */
  public onBackPress(isNoPhotos?: boolean, isMouseScrolling?: boolean, browserControllerId?: number): void {
    let msg: Record<string, number | string | boolean> = {
      'from': BigDataConstants.BY_CLICK
    };
    ReportToBigDataUtil.report(BigDataConstants.ESC_PHOTO_BROWSER_WAY, msg);
    Log.info(TAG,
      `[GeometryLogger] onBackPress, cur_index = ${this.getCurrentIndex()}, target_index = ${this.getTargetIndex()
      }, isDoDeleteAnim: ${this.isDoDeleteAnim} this.pageFrom: ${this.pageFrom} isNoPhotos: ${isNoPhotos}`);
    // 如果正在执行删除动画且还有图片，无法返回
    if (this.isDoDeleteAnim && !isNoPhotos) {
      return;
    }
    // 图片编辑、详情的返回不需要设置自动旋转
    let isEditorShown: boolean = LocalStorage.getShared()?.get('isEditorShown') ?? false;
    if (!isEditorShown && !this.stateMachine.isPropertiesShow()) {
      // 恢复原始朝向策略
      PhotoBrowserUtils.offSensorOrientation(0);
      PhotoBrowserUtils.setOrientationAuto();
    }
    this.emitCallback(LibraryConstants.PHOTOSHM_CONTROLLER_BACK_EVENT,
      [(isPullingUp: boolean, isEditorBack: boolean, swiperController: SwiperController, needUnLock: boolean, aniFun?: Function) => {
        if (isPullingUp) {
          let activeStart: number = this.dataSource?.getAlbumDataSource()?.activeStart || 0;
          let activeEnd: number = this.dataSource?.getAlbumDataSource()?.activeEnd || 0;
          if (this.getTargetIndex() < activeStart || this.getTargetIndex() > activeEnd) {
            this.dataSource?.updateSlidingWindow(this.getTargetIndex());
          }
          let item: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.getTargetIndex());
          this.broadCast.emit(BroadCastConstants.CLOSE_CLICK_DETAIL_BY_BACK_PRESS + item?.path, []);
        } else if (isEditorBack) {
        } else if (needUnLock) {
          this.onBackPressInner(needUnLock, browserControllerId, aniFun);
        }else {
          this.broadCast.emit(BroadCastConstants.CHANGE_LOADING_STATUS, [true]);
          this.isPhotoActive = false;
          swiperController.finishAnimation((): void => this.onBackPressInner(false, browserControllerId, aniFun));
        }
      }]);
    this.updateFocusWhenBackToPhotoGridView();
  }

  private updateFocusWhenBackToPhotoGridView(): void {
    if (!AccessibilityUtil.isOpenTouchGuideSync()) {
      return;
    }
    let index: number = this.getCurrentIndex() ?? 0;
    let targetFocusedElementId: string;
    targetFocusedElementId = `photoGridView_gird_${index.toString()}`;
    Log.info(TAG, `targetFocusedElementId is ${targetFocusedElementId}`);
    AccessibilityUtil.sendFocusAccessibilityEvent(targetFocusedElementId);
  }

  onBackPressInner(needUnlock: boolean, browserControllerId?: number, aniFunc?: Function): void {
    this.isAnimating = true;
    Log.info(TAG, `onBackPressInner: To page: ${this.pageFrom}
      geometryTransitionEnable:${this.geometryTransitionEnable}.`);
    this.onBackPressSwing();
    this.appBroadCast.emit(BroadCastConstants.PHOTO_PHOTO_BACK_PRESS, [undefined, undefined, browserControllerId]);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, []);
    // 视频恢复
    this.emitCallback(LibraryConstants.UPDATE_VIDEO_STATE, []);
    this.broadCast.emit(Constants.RESET_VIDEO_FRAME_BEFORE_EDIT, []);


    if (this.pageFrom === BrowserCaller.VIEWDATA_PAGE &&
      !this.isFromViewDataWithMediaUri && !this.isFromViewDataWithThirdUri) {
      Log.info(TAG, 'onBackPressInner: from FACard (ViewData without viewData flags), back to album page');
      AppStorage.get<Router>('router')?.replaceUrl({
        url: 'MainAbility/view/index',
        params: {
          jumpSource: JumpSourceToMain.FORM_ABILITY_PHOTO_BROWSER
        }
      });
      this.isAnimating = false;
      return;
    }

    switch (this.pageFrom) {
      case BrowserCaller.TIMELINE_PAGE:
        AppStorage.setOrCreate<number>('TimelinePageIndex', this.getCurrentIndex()); // call scrollTo
        AppStorage.setOrCreate<number>('TimelinePageIndex', Constants.INVALID);
        break;
      case BrowserCaller.TIMELINE_PAGE_GROUP:
        AppStorage.setOrCreate<number>('TimelinePageIndex', this.getCurrentIndex()); // call scrollTo
        AppStorage.setOrCreate<number>('TimelinePageIndex', Constants.INVALID);
        break;
      case BrowserCaller.ALBUM_PAGE:
        AppStorage.setOrCreate('PhotoGridPageIndex', this.getCurrentIndex()); // call scrollTo
        AppStorage.setOrCreate('PhotoGridPageIndex', Constants.INVALID);
        break;
      case BrowserCaller.CAMERA_PAGE:
        // Entering from the camera does not need to return to close directly
        let context: common.UIAbilityContext =
          LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
        context.terminateSelf();
        this.isAnimating = false;
        return;
      case BrowserCaller.VIEWDATA_PAGE:
        PhotoBrowserUtils.setViewDataResult(true, this.isFromViewDataWithMediaUri, this.isFromViewDataWithThirdUri);
        this.isAnimating = false;
        return;
      default:
        break;
    }
    // 控制侧边栏是否冻结
    LocalStorage.getShared()?.setOrCreate<boolean>('isOpenBrowser', false);
    if (this.geometryTransitionEnable) {
      let timelineIndex = this.dataSource.getPositionByIndex(this.getCurrentIndex());
      this.onPhotoChanged(this.getCurrentIndex());
      if (DeviceInfo.isVerdeFoldable()) {
        // 防止快速进出大图底部菜单栏错误
        this.emitCallback(LibraryConstants.HIDE_BARS_CALLBACK, []);
      } else {
        this.emitCallback(LibraryConstants.SHOW_BARS_CALLBACK, []);
      }
      if (this.pageFrom === BrowserCaller.HIDDEN_ALBUM && needUnlock) {
        Log.info(TAG, 'isHiddenAlbum and needUnlock, back to album page');
        AppStorage.get<Router>('router')?.replaceUrl({
          url: 'MainAbility/view/index',
          params: {
            jumpSource: JumpSourceToMain.ALBUM,
          }
        });
      }
      this.hideBrowser(timelineIndex as number, aniFunc);
    } else {
      LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', -(this.getCurrentIndex() + 1));
      LocalStorage.getShared()?.setOrCreate<number>('geometryOffsetX', 0);
      LocalStorage.getShared()?.setOrCreate<number>('geometryOffsetY', 0);
      this.appBroadCast.emit(BroadCastConstants.PUZZLE_IMAGE_ON_BACK, []);
      AppStorage.get<Router>('router')?.back({
        url: '',
        params: {
          index: this.getCurrentIndex(),
        }
      });
    }
  }

  public onDisappearHarmonyShare(): void { }
  public onDisappearSwing(): void { }
  public onDisappearDial(): void { }

  private clearShareTimer(): void {
    if (Number.isNaN(this.shareTimer)) {
      return;
    }
    clearTimeout(this.shareTimer);
    this.shareTimer = Number.NaN;
  }

  private onBackPressSwing(): void {
    this.cancelSwingService();
  }

  // 保持原大图逻辑，在onPageShowHarmonyShare函数用一个定时器打开一碰传和Swing
  public onPageShowSwing(): void { }
  // 原大图逻辑onPageShow不打开表盘监听
  public onPageShowDial(): void { }

  public onWindowStatusShareListen(windowType?: window.WindowStageEventType, windowStatus?: number): void {
    if ((windowType === window.WindowStageEventType.ACTIVE ||
      windowType === window.WindowStageEventType.RESUMED) &&
      this.pageFrom !== BrowserCaller.HIDDEN_ALBUM &&
      !UserFileManagerAccess.isRecycleBin(this.albumUri)) {
    } else if (windowStatus === window.WindowStatusType.MINIMIZE ||
      windowType === window.WindowStageEventType.PAUSED) {
      this.cancelSwingService();
    }
  }

  public onPageHideEnd(): void {
    super.onPageHideEnd();
  }

  public onPageHideSwing(): void {
    this.cancelSwingService();
  }

  public goToPhotosAction(currentPhoto: MediaItem | undefined): void {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined.');
      return;
    }
    AppStorage.setOrCreate<string>('form_currentUri', '');
    let menuContext: MenuContext = new MenuContext();
    menuContext.withJumpSourceToMain(JumpSourceToMain.CAMERA);
    this.videoPlayController?.reset();
    MenuOperationFactory.getInstance()
      .createMenuOperation(GotoPhotosMenuOperation, menuContext).doAction();
  }

  /**
   * 从数据集中读取当前图片
   *
   * @returns 当前图片对应的 MediaItem
   */
  public getCurrentPhoto(): MediaItem | undefined {
    let currentPhoto: MediaItem | undefined;
    if (DeviceInfo.isPc()) {
      Log.info(TAG, `getCurrentPhoto, currentIndex: ${this.getCurrentIndex()},
      targetIndex: ${this.getTargetIndex()}`);
      currentPhoto = this.dataSource.getRawData(this.getCurrentIndex()).data;
      if (!currentPhoto) {
        Log.warn(TAG, `getCurrentPhoto, currentIndex: ${this.getCurrentIndex()},
        getRawData currentPhoto is undefined`);
        currentPhoto = this.dataSource.getData(this.getCurrentIndex())?.item;
      }
      if (!currentPhoto) {
        Log.warn(TAG, `getCurrentPhoto, currentIndex: ${this.getCurrentIndex()},
        getData currentPhoto is undefined`);
      } else {
        Log.info(TAG, `getCurrentPhoto, currentIndex: ${this.getCurrentIndex()}, success!`);
      }
    } else {
      currentPhoto = super.getCurrentPhoto();
    }
    return currentPhoto;
  }
}