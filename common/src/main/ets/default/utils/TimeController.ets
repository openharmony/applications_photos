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
import lazy { Animator as animator, AnimatorOptions, AnimatorResult, curves } from '@kit.ArkUI';
import lazy { Log } from './Log';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Constants } from '../model/common/Constants'

const TAG: string = 'TimeController';

export enum MViewType {
  YEAR,
  MONTH,
  DAY,
  GROUP_DAY
}

export class TimeController {
  // 动画延迟0s
  private static ANIMATION_DELAY_ZERO: number = 0;
  // 手指离开滚动条后, 滚动条2s后隐藏
  private static SCROLLER_HIDDEN_DELAY: number = 2000;
  // 年月日视图日期标题
  public singleTitleOpacity: number = 1;
  // 年视图屏幕左侧时间胶囊透明度
  public yearViewLeftCapsulesOpacity: number = 0;
  // 拖动滚动条胶囊时,滚动条左侧时间胶囊的透明度
  public timelineScrollerLeftCapsulesOpacity: number = 0;
  // 滚动条胶囊的透明度
  public timelineScrollerOpacity: number = 0;
  // 年胶囊透明度动效是否启动
  public isStartYearOpacity: boolean = false;
  // 是否显示年视图时间胶囊
  public isShowYearCapsules: boolean = false;
  // 标题栏地址信息透明度
  public subLocalityAddressOpacity: number = 0;
  // 是否显示多选按钮
  public isShowMultiSelect: boolean = false;
  // 是否启用动效
  public isMultiSelectUseAnimation: boolean = false;
  // 年视图时间胶囊透明度动效对象
  private opacityAnimator: AnimatorResult | undefined;
  // 日期Text开始显示或消失的透明度阈值
  private timeOpacityStartThreshold: number = 0.2;
  // 滚动条、滚动条左侧时间胶囊2s消失定时器
  private scrollerTimer: number = -1;

  /**
   * 更新当前日期透明度
   *
   * @param currentType 当前视图类型
   * @param targetType 目标视图类型
   * @param endOpacity 最终透明度
   * @param durationTime 动效持续时间
   * @param isInImmersive 是否沉浸态
   */
  public updateTimeOpacity(currentType: MViewType, targetType: MViewType, endOpacity: number,
    durationTime: number, isInImmersive: boolean): void {
    Log.info(TAG, `updateTimeOpacity ${currentType} to ${targetType}, isInImmersive: ${isInImmersive}` +
      `, currentOpacity: ${this.yearViewLeftCapsulesOpacity}, endOpacity: ${endOpacity}, isStartYearOpacity: ` +
      `${this.isStartYearOpacity}`);
    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      this.singleTitleOpacity = Constants.OPAQUE;
      this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      return;
    }
    // 根据目的透明度判断年胶囊是显示还是消失
    if (endOpacity === Constants.TRANSPARENT) {
      this.isShowYearCapsules = false;
    } else {
      this.isShowYearCapsules = true;
    }
    if ((currentType === MViewType.YEAR || targetType === MViewType.YEAR) && isInImmersive &&
      this.yearViewLeftCapsulesOpacity !== endOpacity) {
      if (!this.isStartYearOpacity) {
        this.isStartYearOpacity = true;
        let startOpacity: number = Constants.OPAQUE;
        if (endOpacity === Constants.OPAQUE) {
          startOpacity = Constants.TRANSPARENT;
        }
        this.updateCapsulesOpacityAnimator(durationTime, startOpacity, endOpacity);
      }
    } else {
      this.handleOtherSceneOpacity(currentType, targetType, isInImmersive);
    }
  }

  private handleOtherSceneOpacity(currentType: MViewType, targetType: MViewType, isInImmersive: boolean): void {
    if (currentType === MViewType.MONTH && targetType === MViewType.YEAR) {
      if (isInImmersive) {
        this.singleTitleOpacity = Constants.TRANSPARENT;
        this.yearViewLeftCapsulesOpacity = Constants.OPAQUE;
      } else {
        this.opacityAnimator?.finish();
        this.singleTitleOpacity = Constants.OPAQUE;
        this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      }
    } else {
      if (isInImmersive) {
        if (targetType !== MViewType.YEAR) {
          this.opacityAnimator?.finish();
          this.singleTitleOpacity = Constants.OPAQUE;
          this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
        } else {
          this.singleTitleOpacity = Constants.TRANSPARENT;
          this.yearViewLeftCapsulesOpacity = Constants.OPAQUE;
        }
      } else {
        this.opacityAnimator?.finish();
        this.singleTitleOpacity = Constants.OPAQUE;
        this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      }
    }
  }

  /**
   * 年视图屏幕左侧时间胶囊透明度可打断动画
   *
   * @param durationTime 动画执行时间
   * @param startOpacity 起始透明度
   * @param endOpacity 终止透明度
   */
  private updateCapsulesOpacityAnimator(durationTime: number, startOpacity: number, endOpacity: number): void {
    try {
      let options: AnimatorOptions = this.createAnimatorOptions(durationTime, TimeController.ANIMATION_DELAY_ZERO,
        startOpacity, endOpacity, 'sharp');
      if (this.opacityAnimator) {
        this.opacityAnimator.finish();
        this.opacityAnimator.reset(options);
      } else {
        this.opacityAnimator = animator.create(options);
      }
      this.opacityAnimator.onFrame = (progress: number) => {
        this.yearViewLeftCapsulesOpacity = progress;
        this.handleSingleTitleOpacity(endOpacity, progress);
      };
      this.opacityAnimator.onFinish = () => {
        this.isStartYearOpacity = false;
        Log.info(TAG, `updateCapsulesOpacityAnimator finish Opacity singleTitleOpacity:${this.singleTitleOpacity}` +
          `, yearViewLeftCapsulesOpacity:${this.yearViewLeftCapsulesOpacity}`);
      };
      Log.info(TAG, `updateCapsulesOpacityAnimator play Opacity:${startOpacity} to ${endOpacity},Time:${durationTime}`);
      this.opacityAnimator.play();
    } catch (e) {
      Log.error(TAG, `updateCapsulesOpacityAnimator error: ${e}`);
    }
  }

  private handleSingleTitleOpacity(endOpacity: number, progress: number): void {
    if (endOpacity === Constants.TRANSPARENT) {
      if (progress <= this.timeOpacityStartThreshold) {
        this.singleTitleOpacity = Constants.OPAQUE;
      }
    } else {
      if (progress >= this.timeOpacityStartThreshold) {
        this.singleTitleOpacity = Constants.TRANSPARENT;
      }
    }
  }

  /**
   * 可打断动画参数
   */
  private createAnimatorOptions(durationTime: number, delayTime: number, startValue: number,
    endValue: number, easingType: string): AnimatorOptions {
    let options: AnimatorOptions = {
      duration: durationTime,
      easing: easingType,
      delay: delayTime,
      fill: 'forwards',
      direction: 'normal',
      begin: startValue,
      end: endValue,
      iterations: 1,
    };
    return options;
  }

  /**
   * 执行透明度动效
   *
   * @param durationTime 动效持续时间
   * @param endTimeOpacity 动效最终透明度
   * @param func 动效执行逻辑
   */
  public updateOpacityBySharp(durationTime: number, endTimeOpacity: number, func: () => void): void {
    /* instrument ignore next */
    animateToImmediately({
      delay: 0,
      duration: durationTime,
      curve: curves.initCurve(Curve.Sharp),
      onFinish: (): void => {
        if (endTimeOpacity === Constants.TRANSPARENT) {
          this.singleTitleOpacity = Constants.OPAQUE;
        }
        Log.info(TAG, 'updateTimeOpacity onFinish');
      }
    }, () => {
      func();
    });
  }

  /**
   * 更新当前日期透明度
   *
   * @param isScrollerBarTouch 当前手指是否按压在滚动条滚动胶囊上
   * @param isInImmersive 是否沉浸态
   * @param currentViewType 当前视图类型
   */
  public startCapsuleAndSingleTitleVisibilityAnimation(isScrollerBarTouch: boolean, isInImmersive: boolean,
    currentViewType: MViewType): void {
    Log.info(TAG, 'startCapsuleAndSingleTitleVisibilityAnimation start');
    clearTimeout(this.scrollerTimer);
    // 手指拖动滚动条时, 年视图屏幕左侧时间胶囊隐藏动画、滚动条左侧时间胶囊显示动画立刻执行
    if (isScrollerBarTouch) {
      this.singleTitleOpacity = Constants.OPAQUE;
      this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      this.timelineScrollerLeftCapsulesOpacity = Constants.OPAQUE;
      this.timelineScrollerOpacity = Constants.OPAQUE;
      return;
    }
    // 手指离开滚动条时采用定时器做滚动条、胶囊2s隐藏
    /* instrument ignore next */
    this.scrollerTimer = setTimeout((): void => {
      if (isInImmersive && currentViewType === MViewType.YEAR) {
        this.singleTitleOpacity = Constants.TRANSPARENT;
        this.yearViewLeftCapsulesOpacity = Constants.OPAQUE;
      } else {
        this.singleTitleOpacity = Constants.OPAQUE;
        this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      }
      this.timelineScrollerLeftCapsulesOpacity = Constants.TRANSPARENT;
      this.timelineScrollerOpacity = Constants.TRANSPARENT;
    }, TimeController.SCROLLER_HIDDEN_DELAY);
  }

  /**
   * 宫格滑动场景控制控制滚动胶囊显隐藏. 宫格滑动时滚动胶囊显示、宫格滑动停止2s后滚动胶囊隐藏
   *
   * @param isScrollStop 是否滚动停止
   * @param isScrollTouch 当前手指是否按压在滚动条滚动胶囊上
   * @param isInImmersive 是否沉浸态
   * @param currentViewType 当前视图类型
   */
  public startScrollerCapsuleAnimation(isScrollStop: boolean, isScrollTouch: boolean = false,
    isInImmersive: boolean, currentViewType: MViewType): void {
    if (isScrollTouch) {
      Log.info(TAG, 'startScrollerCapsuleAnimation isScrollTouch');
      return;
    }

    // 拖动滚动条场景手指离屏后会触发setTimeout, 在2s内如果再次滑动宫格则清除掉定时器,防止定时器造成滚动胶囊闪烁
    if (isScrollStop) {
      this.updateYearViewLeftCapsulesOpacityByDelay(isInImmersive, currentViewType);
      Log.info(TAG, 'startScrollerCapsuleAnimation isScrollStop');
      return;
    }

    clearTimeout(this.scrollerTimer);
    // 宫格滑动时需要显示出滚动条胶囊
    this.timelineScrollerOpacity = Constants.OPAQUE;
    // 宫格滑动时需要将滚动条左侧胶囊隐藏
    this.timelineScrollerLeftCapsulesOpacity = Constants.TRANSPARENT;
    // PAD设备无年胶囊，因此不做透明度动效
    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      this.singleTitleOpacity = Constants.OPAQUE;
      this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      Log.info(TAG, 'startScrollerCapsuleAnimation isTablet');
    } else {
      // 宫格滑动时若处于沉浸态, 需要将标题栏文字隐藏, 宫格滑动时若处于年视图并且是沉浸态, 需要将年视图左侧时间胶囊显示出来
      if (isInImmersive && currentViewType === MViewType.YEAR) {
        this.singleTitleOpacity = Constants.TRANSPARENT;
        this.yearViewLeftCapsulesOpacity = Constants.OPAQUE;
      } else {
        this.singleTitleOpacity = Constants.OPAQUE;
        this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      }
      Log.info(TAG, `startScrollerCapsuleAnimation:${this.timelineScrollerOpacity}`);
    }
  }

  private updateYearViewLeftCapsulesOpacityByDelay(isInImmersive: boolean, currentViewType: MViewType): void {
    clearTimeout(this.scrollerTimer);
    // 手指离开滚动体条后没有滑动宫格
    if (this.timelineScrollerLeftCapsulesOpacity !== Constants.TRANSPARENT) {
      this.handleYearViewLeftCapsulesOpacity(isInImmersive, currentViewType);
    } else {
      // 滑动宫格后宫格停止滚动, 因为开始滚动宫格时滚动条右侧胶囊已经被隐藏,
      // 所以timelineScrollerLeftCapsulesOpacity===0时标识滚动条停止
      clearTimeout(this.scrollerTimer);
      this.scrollerTimer = setTimeout((): void => {
        this.timelineScrollerOpacity = Constants.TRANSPARENT;
      }, TimeController.SCROLLER_HIDDEN_DELAY);
    }
  }

  private handleYearViewLeftCapsulesOpacity(isInImmersive: boolean, currentViewType: MViewType): void {
    this.scrollerTimer = setTimeout((): void => {
      // PAD设备无年胶囊，因此不做透明度动效
      /* instrument ignore next */
      if (DeviceInfo.isTablet()) {
        this.singleTitleOpacity = Constants.OPAQUE;
        this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
        Log.info(TAG, 'startScrollerCapsuleAnimation isTablet');
      } else {
        // 年视图并且沉浸态时需要隐藏标题栏、隐藏滚动条左侧胶囊
        if (isInImmersive && currentViewType === MViewType.YEAR) {
          this.singleTitleOpacity = Constants.TRANSPARENT;
          this.yearViewLeftCapsulesOpacity = Constants.OPAQUE;
        } else {
          this.singleTitleOpacity = Constants.OPAQUE;
          this.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
        }
      }
      this.timelineScrollerLeftCapsulesOpacity = Constants.TRANSPARENT;
      this.timelineScrollerOpacity = Constants.TRANSPARENT;
    }, TimeController.SCROLLER_HIDDEN_DELAY);
  }

  /**
   * 视图切换时需要清除2s定时器并终止切换视图前的动画
   */
  public updateScrollerOpacity(): void {
    clearTimeout(this.scrollerTimer);
    // 防止滚动体离手后2s内切换视图, 并且视图切换成功后立马滑动宫格时滚动条左侧时间胶囊闪烁
    this.timelineScrollerOpacity = Constants.TRANSPARENT;
    this.timelineScrollerLeftCapsulesOpacity = Constants.TRANSPARENT;
  }

  /**
   * 暂停透明度动效
   */
  public pauseOpacityAnimator(): void {
    if (this.opacityAnimator) {
      this.opacityAnimator.pause();
      this.isStartYearOpacity = false;
      Log.info(TAG, `pauseOpacityAnimator:${this.yearViewLeftCapsulesOpacity}, ${this.singleTitleOpacity}`);
    }
  }

  /**
   * 更新是否显示多选按钮状态
   *
   * @param isShowMultiSelect 是否显示多选按钮
   */
  public updateMultiSelectState(isShowMultiSelect: boolean): void {
    this.isShowMultiSelect = isShowMultiSelect;
  }

  /**
   * 更新是否使用动效
   *
   * @param isMultiSelectUseAnimation 是否使用动效
   */
  public updateMultiSelectUseAnimation(isMultiSelectUseAnimation: boolean): void {
    this.isMultiSelectUseAnimation = isMultiSelectUseAnimation;
  }
}