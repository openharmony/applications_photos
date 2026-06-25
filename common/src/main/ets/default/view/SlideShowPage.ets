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
import lazy { Log } from './../utils/Log';
import lazy { NavigationConstants } from './../model/common/NavigationConstants';
import lazy { ImageUtil } from './../utils/ImageUtil';
import lazy { getScreen } from './../model/common/ScreenManager';
import lazy { ScaleOpt } from '@ohos/tools/src/main/interface/PointData';
import lazy { WindowUtil } from './../utils/WindowUtil';
import lazy common from '@ohos.app.ability.common';
import lazy { BroadCastConstants } from './../model/common/BroadCastConstants';
import lazy { SlideShowIntervalController } from '../model/common/SlideShowIntervalController';
import lazy { ScreenManager } from './../model/common/ScreenManager';
import lazy { BroadCast } from './../utils/BroadCast';
import lazy { ReportToBigDataUtil, BigDataConstants } from './../utils/ReportToBigDataUtil';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { AnimatorResult, curves, window } from '@kit.ArkUI';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { CustomTransitionManager } from '../model/CustomTransitionManager';
import lazy {
  PhotoBrowserStateMachine
} from '../../../../../../browserCommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { Constants } from './../model/common/Constants';
import { PhotoDataSource } from '../model/browser/photo/PhotoDataSource';

/* instrument ignore file */
@Builder
export function SlideShowPageLoader($$: SlideShowLoaderParams) {
  SlideShowPage({
    navigationPageInfos: $$.navigationPageInfos,
  })
}

export interface SlideShowLoaderParams {
  navigationPageInfos: NavPathStack;
}

export interface SlideShowParams {
  items: PhotoDataSource;
  broadCast: BroadCast;
  currentIndex: number;
  isImmersive?: boolean;
  imagePadding?: Padding;
}

interface TranslateType {
  x: number,
  y: number,
};

const MILLISECONDS_PER_SECOND: number = 1000;
const TAG: string = 'SliceShowPage';
const DEFAULT_SLIDE_PADDING: Padding = { top: 0, right: 0, bottom: 0, left: 0 };
const PC_TRANSLATE_ANIM_DURATION = 300;
const PC_TRANSLATE_ANIM_TIMEOUT = 550;

@Component
export struct SlideShowPage {
  @State upperAnimator: AnimatorResult | undefined = undefined;
  @State lowerAnimator: AnimatorResult | undefined = undefined;
  @State opacityAnimatorUpper: AnimatorResult | undefined = undefined;
  @State opacityAnimatorLower: AnimatorResult | undefined = undefined;
  private isUpperAnimatorProcessing: boolean = false;
  private isOpacityAnimatorUpperProcessing: boolean = false;
  private isOpacityAnimatorLowerProcessing: boolean = false;
  private isLowerAnimatorProcessing: boolean = false;
  private navigationPageInfos: NavPathStack = new NavPathStack();
  @State translateListIndex: number = 0;
  @State isShowLower: boolean = false;
  @State zIndexUpper: number = 2;
  @State opacityUpper: number = 1;
  @State translateUpper: TranslateType = { x: 0, y: 0 };
  @State scaleUpper: ScaleOpt = { x: 1, y: 1 };
  @State countUpper: number = 0;
  @State zIndexLower: number = 1;
  @State opacityLower: number = 0;
  @State translateLower: TranslateType = { x: 0, y: 0 };
  @State scaleLower: ScaleOpt = { x: 1, y: 1 };
  @State countLower: number = 1;
  private changeIndexPC: number = 0;
  private ANIMATION_DURATION: number = 3000; // scale,translate动画时长
  private OPACITY_ANIMATION_DURATION: number = 1000; // 透明度动画时长
  private IMAGE_SWIPER_WIDTH: string = '100%';
  private IMAGE_LAYOUT_SIZE: string = '100%';
  private SCALE_EXPAND: number = 1.2; // 图片放大系数
  private SCALE_EXPAND_PC: number = 1.05; // 图片放大系数
  private PLAY_ANIMATION_WAIT_TIME: number = 500; // 动画播放等待时长
  private imgListLength: number = 0;
  private timer: number = 0;
  private translateList: TranslateType[] = [
    { x: 0, y: -6 },
    { x: 0, y: 6 },
    { x: -6, y: 0 },
    { x: 6, y: 0 }
  ];
  private onPageHideFunc: Function = (msg: string): void => this.onPageHideInner(msg);
  private hasBack: boolean = false; // 返回后停止循环动效，防止泄漏
  private returnIndex: number = 0;
  private dataSource: PhotoDataSource | undefined = new PhotoDataSource(new PhotoBrowserStateMachine());
  private broadCast: BroadCast | undefined = new BroadCast();
  private startTime: number = 0;
  @State isPCPaused: boolean = false;
  @State pageOpacity: number = 1;
  @State navDestinationColor: string = '#ff000000';
  @State slideImagePadding: Padding = DEFAULT_SLIDE_PADDING;
  private swiperImagePadding: Padding = DEFAULT_SLIDE_PADDING;
  @LocalStorageLink('photoSwiperOpacity') photoSwiperOpacity: number = 1;
  private isPush: boolean = true;
  private isImmersive: boolean = false;
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  private isImageComplete: boolean = true; // 图片是否加载完成
  private isWinSizeChangedFinished: boolean = false; // 窗口变化回调是否已执行完成
  private orientataion: number = 0;

  defineAnimator() {
    Log.info(TAG, 'defineAnimator method action')
    this.upperAnimator = this.getUIContext()?.createAnimator({
      duration: this.ANIMATION_DURATION / 2,
      easing: 'sharp',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: 1,
      end: this.SCALE_EXPAND_PC,
    });
    this.upperAnimator.onFinish = () => {
      Log.info(TAG, 'upperAnimator onFinish callback');
      this.isUpperAnimatorProcessing = false;
      if (this.countUpper === this.imgListLength - 1 || this.hasBack) {
        return;
      }
      this.translateListIndex ===
        3 ? this.translateListIndex = 0 : this.translateListIndex = this.translateListIndex + 1;
      this.isOpacityAnimatorUpperProcessing = true;
      this.opacityAnimatorUpper?.play();
      if (this.hasBack) {
        return;
      }
      Log.info(TAG, `animationLowerPC countLower: ${this.countLower}`);
      this.isLowerAnimatorProcessing = true;
      this.lowerAnimator?.play();
    }
    this.upperAnimator.onFrame = (value: number) => {
      let tempTranslateUpper: TranslateType = this.translateList[this.translateListIndex];
      let percent: number = (value - 1) / (this.SCALE_EXPAND_PC - 1);
      let xTemp: number = tempTranslateUpper.x * percent;
      let yTemp: number = tempTranslateUpper.y * percent;
      this.translateUpper = { x: xTemp, y: yTemp };
      let scaleOpt: ScaleOpt = { x: value, y: value };
      this.scaleUpper = scaleOpt;
    }
    this.opacityAnimatorUpper = this.getUIContext()?.createAnimator({
      duration: this.OPACITY_ANIMATION_DURATION,
      easing: 'sharp',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: 1,
      end: 0,
    });
    this.opacityAnimatorUpper.onFinish = () => {
      Log.info(TAG, 'opacityAnimatorUpper onFinish callback');
      this.isOpacityAnimatorUpperProcessing = false;
      this.countUpper = this.countLower + 1 === this.imgListLength ? this.countUpper : this.countLower + 1;
      this.returnIndex = this.countLower;
      this.changeIndexPC = this.countLower;
      this.translateUpper = { x: 0, y: 0 };
      this.scaleUpper = { x: 1, y: 1 };
    }
    this.opacityAnimatorUpper.onFrame = (value: number) => {
      this.opacityUpper = value;
      this.opacityLower = -value + 1;
    }

    this.opacityAnimatorLower = this.getUIContext()?.createAnimator({
      duration: this.OPACITY_ANIMATION_DURATION,
      easing: 'sharp',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: 0,
      end: 1,
    });
    this.opacityAnimatorLower.onFinish = () => {
      Log.info(TAG, 'opacityAnimatorLower onFinish callback');
      this.isOpacityAnimatorLowerProcessing = false;
      this.countLower = this.countUpper + 1 === this.imgListLength ? this.countLower : this.countUpper + 1;
      this.returnIndex = this.countUpper;
      this.changeIndexPC = this.countUpper;
      this.translateLower = { x: 0, y: 0 };
      this.scaleLower = { x: 1, y: 1 };
    }
    this.opacityAnimatorLower.onFrame = (value: number) => {
      this.opacityUpper = value;
      this.opacityLower = -value + 1;
    }

    this.lowerAnimator = this.getUIContext()?.createAnimator({
      duration: this.ANIMATION_DURATION / 2,
      easing: 'sharp',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: 1,
      end: this.SCALE_EXPAND_PC,
    });
    this.lowerAnimator.onFinish = () => {
      Log.info(TAG, 'lowerAnimator onFinish callback');
      this.isLowerAnimatorProcessing = false;
      if (this.countLower === this.imgListLength - 1 || this.hasBack) {
        return;
      }
      this.translateListIndex ===
        3 ? this.translateListIndex = 0 : this.translateListIndex = this.translateListIndex + 1;
      this.isOpacityAnimatorLowerProcessing = true;
      this.opacityAnimatorLower?.play();
      if (this.hasBack) {
        return;
      }
      Log.info(TAG, `animationUpperPC countUpper: ${this.countUpper}`);
      this.isUpperAnimatorProcessing = true;
      this.upperAnimator?.play();
    }
    this.lowerAnimator.onFrame = (value: number) => {
      let tempTranslateLower: TranslateType = this.translateList[this.translateListIndex];
      let percent: number = (value - 1) / (this.SCALE_EXPAND_PC - 1);
      let xTemp: number = tempTranslateLower.x * percent;
      let yTemp: number = tempTranslateLower.y * percent;
      this.translateLower = { x: xTemp, y: yTemp };
      this.scaleLower = { x: value, y: value };
    }
  }

  private controlSlidePage(): void {
    Log.info(TAG, 'enter listener action')
    this.isPCPaused = !this.isPCPaused;
    if (this.isUpperAnimatorProcessing) {
      if (this.isPCPaused) {
        this.upperAnimator?.pause();
      } else {
        this.upperAnimator?.play();
      }
    }
    if (this.isOpacityAnimatorUpperProcessing) {
      if (this.isPCPaused) {
        this.opacityAnimatorUpper?.pause();
      } else {
        this.opacityAnimatorUpper?.play();
      }
    }
    if (this.isLowerAnimatorProcessing) {
      if (this.isPCPaused) {
        this.lowerAnimator?.pause();
      } else {
        this.lowerAnimator?.play();
      }
    }
    if (this.isOpacityAnimatorLowerProcessing) {
      if (this.isPCPaused) {
        this.opacityAnimatorLower?.pause();
      } else {
        this.opacityAnimatorLower?.play();
      }
    }
  }

  private back2Grid(): void {
    Log.info(TAG, `back2Grid method start ${this.returnIndex}`)
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.broadCast?.emit(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, [this.changeIndexPC]);
    }
    this.hasBack = true;
    this.navigationPageInfos.pop(this.returnIndex);
  };

  aboutToAppear() {
    Log.info(TAG, 'About to appear start.');
    WindowUtil.getPreferredOrientation().then(result => {
      this.orientataion = result ? result : 0;
      Log.info(TAG, `Before SlideShowPage Orientation: ${this.orientataion}`);
    });
    Log.info(TAG, `Set SlideShowPage Orientation: ${window.Orientation.AUTO_ROTATION_UNSPECIFIED}`);
    WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    AppStorage.setOrCreate(Constants.APP_STORAGE_KEY_JUMP_TO_SLIDE_SHOW_PAGE, true);
    let params: SlideShowParams =
      this.navigationPageInfos.getParamByName(NavigationConstants.NAVIGATION_SLIDE_SHOW_PAGE)[0] as SlideShowParams;
    this.countUpper = params.currentIndex;
    this.returnIndex = this.countUpper;
    this.dataSource = params.items;
    this.broadCast = params.broadCast;
    this.swiperImagePadding = params.imagePadding ?? this.swiperImagePadding;
    this.slideImagePadding = this.swiperImagePadding;
    this.isImmersive = params.isImmersive ?? this.isImmersive;
    this.imgListLength = this.dataSource.totalCount();
    this.ANIMATION_DURATION =
      SlideShowIntervalController.getSlideShowIntervalSettings(getContext(this)) * MILLISECONDS_PER_SECOND;
    Log.info(TAG, `startIndex: ${this.countUpper}, items length: ${this.imgListLength},
      animation_duration: ${this.ANIMATION_DURATION}`);
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.changeIndexPC = params.currentIndex;
      this.defineAnimator();
      // 设置屏幕常亮
      this.setWindowKeepScreenOnPC(true);
      this.registerNavigationCallback();
      getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    } else {
      WindowUtil.setWindowKeepScreenOn(
        LocalStorage.getShared()?.get<Context>('photosAbilityContext') as common.UIAbilityContext, true);
    }
    this.getUIContext().getHostContext()?.eventHub.on(BroadCastConstants.ON_PAGE_HIDE, this.onPageHideFunc);
    getContext().eventHub.on(BroadCastConstants.ON_PHOTO_SEARCH_PAGE_HIDE, this.onPageHideFunc);
    this.startTime = Date.now();
  }

  aboutToDisappear() {
    WindowUtil.setOrientation(this.orientataion);
    AppStorage.delete(Constants.APP_STORAGE_KEY_JUMP_TO_SLIDE_SHOW_PAGE);
    if (this.timer) {
      clearTimeout(this.timer);
    }
    this.reportBigData();
    this.hasBack = true;
    this.getUIContext().getHostContext()?.eventHub.off(BroadCastConstants.ON_PAGE_HIDE, this.onPageHideFunc);
    getContext().eventHub.off(BroadCastConstants.ON_PHOTO_SEARCH_PAGE_HIDE, this.onPageHideFunc);
    this.dataSource = undefined;
    this.broadCast = undefined;
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.upperAnimator = undefined;
      this.opacityAnimatorUpper = undefined;
      this.lowerAnimator = undefined;
      this.opacityAnimatorLower = undefined;
      this.setWindowKeepScreenOnPC(false);
      CustomTransitionManager.getInstance().unRegisterNavParam(NavigationConstants.NAVIGATION_SLIDE_SHOW_PAGE);
      getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    } else {
      WindowUtil.setWindowKeepScreenOn(
        LocalStorage.getShared()?.get<Context>('photosAbilityContext') as common.UIAbilityContext, false);
    }
    Log.info(TAG, 'aboutToDisappear finish.');
  }

  private setWindowKeepScreenOnPC(isKeepScreenOn: boolean): void {
    let windowStage: window.WindowStage =
      LocalStorage.getShared()?.get<window.WindowStage>('photosWindowStage') as window.WindowStage;
    try {
      windowStage.getMainWindow().then((windows) => {
        windows.setWindowKeepScreenOn(isKeepScreenOn).then((): void => {
          Log.info(TAG, `Photos succeeded in setting the screen to be always on. ${isKeepScreenOn}`);
        }).catch((err: BusinessError): void => {
          Log.error(TAG, `Photos failed to set the screen to be always on. Cause:  ${err}`);
        });
      }).catch((err: BusinessError): void => {
        Log.error(TAG, `Failed to obtain the top window. Cause: ${err}`);
      });
    } catch (exception) {
      Log.error(TAG, `Failed to obtain the top window. Cause: ${exception}`);
    }
  }

  private reportBigData(): void {
    let msg: Record<string, number | string | boolean> = {
      'interval': this.ANIMATION_DURATION,
      'duration': Date.now() - this.startTime,
      'end': this.returnIndex === this.imgListLength - 1,
    };
    ReportToBigDataUtil.report(BigDataConstants.SLIDE_SHOW, msg);
  }

  private onPageHideInner(msg: string | undefined) {
    Log.info(TAG, `onPageHideInner() ${msg}`);
    this.hasBack = true;
    this.navigationPageInfos.pop();
  }

  private scaleOption(): ScaleOpt {
    let scaleOpt: ScaleOpt = { x: this.SCALE_EXPAND, y: this.SCALE_EXPAND };
    return scaleOpt;
  }

  private animationStart(): void {
    this.timer = setTimeout((): void => {
      if (this.imgListLength > this.countUpper) {
        this.isShowLower = true;
        this.countLower = this.countUpper + 1;
      }
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        if (this.hasBack) {
          return;
        }
        this.isUpperAnimatorProcessing = true;
        Log.info(TAG, `upperAnimator start play`);
        this.upperAnimator?.play();
      } else {
        this.animationUpper();
      }
    }, this.PLAY_ANIMATION_WAIT_TIME);
  }

  // Stack层级高的图片做放大和位移动效
  private animationUpper(): void {
    if (this.hasBack) {
      return;
    }
    Log.info(TAG, `animationUpper countUpper: ${this.countUpper}`);
    animateTo({
      duration: this.ANIMATION_DURATION / 2,
      curve: Curve.Sharp,
      onFinish: () => {
        if (this.countUpper === this.imgListLength - 1 || this.hasBack) {
          return;
        }
        this.translateListIndex ===
          3 ? this.translateListIndex = 0 : this.translateListIndex = this.translateListIndex + 1;
        this.opacityAnimation(true);
        this.animationLower();
      }
    }, () => {
      this.translateUpper = this.translateList[this.translateListIndex];
      this.scaleUpper = this.scaleOption();
    });
  }

  // Stack层级低的图片做放大和位移动效
  private animationLower(): void {
    if (this.hasBack) {
      return;
    }
    Log.info(TAG, `animationLower countLower: ${this.countLower}`);
    animateTo({
      duration: this.ANIMATION_DURATION / 2,
      curve: Curve.Sharp,
      onFinish: () => {
        if (this.countLower === this.imgListLength - 1 || this.hasBack) {
          return;
        }
        this.translateListIndex ===
          3 ? this.translateListIndex = 0 : this.translateListIndex = this.translateListIndex + 1;
        this.opacityAnimation(false);
        this.animationUpper();
      }
    }, () => {
      this.translateLower = this.translateList[this.translateListIndex];
      this.scaleLower = this.scaleOption();
    });
  }

  /*
   * 透明度动效，消失图片opacity 0->1 出现图片opacity 1->0
   * isUpperDisAppear: 是否是Stack层级高的图片消失
   */
  opacityAnimation(isUpperDisAppear: boolean): void {
    animateTo({
      duration: this.OPACITY_ANIMATION_DURATION,
      curve: Curve.Sharp,
      onFinish: (): void => {
        if (isUpperDisAppear) {
          this.countUpper = this.countLower + 1 === this.imgListLength ? this.countUpper : this.countLower + 1;
          this.returnIndex = this.countLower;
          this.broadCast?.emit(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, [this.countLower]);
          this.translateUpper = { x: 0, y: 0 };
          this.scaleUpper = { x: 1, y: 1 };
        } else {
          this.countLower = this.countUpper + 1 === this.imgListLength ? this.countLower : this.countUpper + 1;
          this.returnIndex = this.countUpper;
          this.broadCast?.emit(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, [this.countUpper]);
          this.translateLower = { x: 0, y: 0 };
          this.scaleLower = { x: 1, y: 1 };
        }
      }
    }, () => {
      this.opacityUpper = isUpperDisAppear ? 0 : 1;
      this.opacityLower = isUpperDisAppear ? 1 : 0;
    });
  }

  // 获取LCD图uri
  private getActualImage(index: number): string {
    let item = this.dataSource?.getData(index)?.item;
    if (item) {
      let res = ImageUtil.getLCDUri(item.uri, item.path, item.getDateModified?.());
      return res;
    }
    return '';
  }

  private registerNavigationCallback() {
    // 初始化过场动画环境
    this.pageOpacity = 0;
    // 已进入沉浸式状态，不执行渐变动效，使用转场时间等待图片加载
    if (this.swiperImagePadding.bottom === 0 && this.swiperImagePadding.left === 0 &&
      this.swiperImagePadding.right === 0 && this.swiperImagePadding.top === 0) {
      Log.info(TAG, 'ImagePadding already changed.');
    } else {
      this.navDestinationColor = '#00000000';
      this.isImageComplete = false;
    }

    CustomTransitionManager.getInstance()
      .registerNavParam(NavigationConstants.NAVIGATION_SLIDE_SHOW_PAGE, (isPush: boolean) => {
        this.isPush = isPush;
        // 全屏场景不在此处执行转场动画，会被窗口动画打断;进入动画在image加载完成时执行
        if (this.isImmersive || this.isPush) {
          return;
        }
        this.doTranslateAnimation();
      }, PC_TRANSLATE_ANIM_TIMEOUT);
  }

  private onWinSizeChanged(): void {
    // 图片载入未完成，不执行转场动画
    if (!this.isImmersive || !this.isImageComplete) {
      Log.info(TAG, 'onWinSizeChanged Transition ignore');
      this.isWinSizeChangedFinished = true;
      return;
    }
    Log.info(TAG, 'Navigation Transition onWinSizeChanged');
    this.doTranslateAnimation();
  }

  private onImageComplete(): void {
    this.pageOpacity = 1;
    // 首次载入图片时执行
    if (!DeviceInfo.isPc() || this.isImageComplete) {
      return;
    }
    this.isImageComplete = true;
    // 沉浸式窗口动效未完成不执行转场动画
    if (this.isImmersive && !this.isWinSizeChangedFinished) {
      Log.info(TAG, 'onImageComplete Transition ignore');
      return;
    }
    Log.info(TAG, 'Navigation Transition onImageComplete');
    this.doTranslateAnimation();
  }

  private doTranslateAnimation(): void {
    Log.info(TAG, `Navigation Transition begin, isPush:${this.isPush}`);
    if (this.isPush) {
      this.photoSwiperOpacity = 0;
      this.getUIContext()?.animateTo({
        duration: PC_TRANSLATE_ANIM_DURATION,
        curve: curves.cubicBezierCurve(0.2, 0.0, 0.2, 1.0),
        onFinish: () => {
          Log.info(TAG, 'Push Navigation Transition finished');
          this.photoSwiperOpacity = 1;
        }
      }, () => {
        this.navDestinationColor = '#ff000000';
        this.slideImagePadding = DEFAULT_SLIDE_PADDING;
      })
    } else {
      // 暂停幻灯片动效，返回正在播放的照片
      if (!this.isPCPaused) {
        this.controlSlidePage();
      }
      this.changeIndexPC = this.isLowerAnimatorProcessing ? this.countLower : this.countUpper;
      this.broadCast?.emit(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, [this.changeIndexPC]);
      this.photoSwiperOpacity = 0;
      this.getUIContext()?.animateTo({
        duration: PC_TRANSLATE_ANIM_DURATION,
        curve: curves.cubicBezierCurve(0.2, 0.0, 0.2, 1.0),
        onFinish: () => {
          Log.info(TAG, 'Pop Navigation Transition finished');
          this.photoSwiperOpacity = 1;
        }
      }, () => {
        Log.info(TAG, 'Pop Navigation Transition do');
        this.navDestinationColor = '#00000000'
        this.slideImagePadding = this.swiperImagePadding;
        Log.info(TAG, `slideImagePadding is top:${this.slideImagePadding.top} bottom:${this.slideImagePadding.bottom}`);
        // 幻灯片动效状态复原
        if (this.isLowerAnimatorProcessing) {
          this.scaleLower = { x: 1, y: 1 };
          this.translateLower = { x: 0, y: 0 };
          this.opacityLower = 1;
          this.opacityUpper = 0;
        } else {
          this.scaleUpper = { x: 1, y: 1 };
          this.translateUpper = { x: 0, y: 0 };
          this.opacityUpper = 1;
          this.opacityLower = 0;
        }
      })
    }
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          if (this.isShowLower) {
            Image(this.getActualImage(this.countLower))
              .width(this.IMAGE_LAYOUT_SIZE)
              .height(this.IMAGE_LAYOUT_SIZE)
              .opacity(this.opacityLower)
              .translate(this.translateLower)
              .scale(this.scaleLower)
              .zIndex(this.zIndexLower)
              .objectFit(ImageFit.Contain)
              .draggable(false)
          }

          Image(this.getActualImage(this.countUpper))
            .width(this.IMAGE_LAYOUT_SIZE)
            .height(this.IMAGE_LAYOUT_SIZE)
            .opacity(this.opacityUpper)
            .translate(this.translateUpper)
            .scale(this.scaleUpper)
            .zIndex(this.zIndexUpper)
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .onComplete(() => {
              this.onImageComplete();
            })
            .onAppear((): void => {
              this.animationStart();
            })
        }
        .padding(this.slideImagePadding)
      }
      .onClick(() => {
        /* instrument ignore next */
        if (DeviceInfo.isPc()) {
          this.changeIndexPC = this.isLowerAnimatorProcessing ? this.countLower : this.countUpper;
          this.broadCast?.emit(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, [this.changeIndexPC]);
        }
        Log.info(TAG, `onClick back ${this.returnIndex}`);
        this.hasBack = true;
        this.navigationPageInfos.pop(this.returnIndex);
      })
      .width(this.IMAGE_SWIPER_WIDTH)
      .height(this.IMAGE_SWIPER_WIDTH)
      .clip(true)
    }
    .onKeyEvent((event: KeyEvent) => {
      Log.info(TAG, `slideShowPage onKeyEvent keyCode: ${event.keyCode} type: ${event.type}`);
      if (event.type === KeyType.Down && DeviceInfo.isPc()) {
        if (event.keyCode === KeyCode.KEYCODE_ENTER) {
          this.controlSlidePage();
        } else if (event.keyCode === KeyCode.KEYCODE_ESCAPE) {
          this.back2Grid();
        } else if (event.keyCode === KeyCode.KEYCODE_SPACE) {
          this.controlSlidePage();
        }
      }
    })
    .onBackPressed((): boolean => {
      Log.info(TAG, 'onBackPress return Browser');
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        this.changeIndexPC = this.isLowerAnimatorProcessing ? this.countLower : this.countUpper;
        this.broadCast?.emit(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, [this.changeIndexPC]);
      }
      this.hasBack = true;
      this.navigationPageInfos.pop(this.returnIndex);
      return true;
    })
    .onWillAppear((): void => {
      getScreen().setSystemUi(false);
      getScreen().setIsInImmersivePage(true);
    })
    .onWillDisappear(() => {
      getScreen().setIsInImmersivePage(false);
      getScreen().setSystemUi(true);
    })
    .hideTitleBar(true)
    .backgroundColor(this.navDestinationColor)
    .opacity(this.pageOpacity)
  }
}