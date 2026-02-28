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
import lazy { UIContext } from '@ohos.arkui.UIContext';
import lazy { CustomColors } from '@ohos.arkui.theme';
import lazy { Constants } from '../model/browser/photo/Constants';
import lazy { Log } from '../utils/Log';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';
import lazy { UiUtil } from '../utils/UiUtil';
import lazy { WindowUtil } from '../utils/WindowUtil';
import lazy { Constants as CommonConstants } from '../model/common/Constants';
import lazy performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { SingleSelectionMode } from '../model/common/SelectParams';
import lazy { ShortCut } from '../model/ShortCut';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { DeviceInfo as DeviceInfoCommon } from '../utils/DeviceInfo';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { IdGenerator } from '../utils/IdGenerator';
import lazy { PreselectedInfo } from '@ohos.file.PhotoPickerComponent';

const TAG = 'BrowserController';

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
  isAllMode?: boolean;
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
  item: MediaItem;
  pickerIndex?: number;
  preselectedInfos?: PreselectedInfo[];
}

@Observed
export class BrowserController {
  public currentItem: MediaItem | undefined;
  public browserControllerId: number = IdGenerator.generatorIdOldStatic();
  public geometryTransitionEnable: boolean = false;
  public isAnimating: boolean = false;
  // 大图显示部分
  public isBrowserShow: boolean = false;
  // 非大图部分，包括actionbar、toolbar、缩略图预览条
  public isBrowserShowContent: boolean = false;
  public currentIndex: number = 0;
  public browserParam?: Object;
  public browserBackFunc: Function = (): void => {
  };
  public isSelectBrowserShow: boolean = false;
  public selectBrowserParam?: Object;
  public pageFrom: string = '';
  // 是否支持拖拽
  public isDrag: boolean = false;
  public isStartHide: boolean = false;
  public isStartShowWhileHide: boolean = false;
  public isPullDownAndDrag: boolean = false;
  public isSelectedMode: boolean = false;
  public isAllMode: boolean = false;
  public enableClick: boolean = true;
  private animateCounter: number = 0;
  private isEntering: boolean = true;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public isFromSearch: boolean = false;
  private focusCtrlManager = FocusCtrlManager.getInstance();
  public isFromPortrait: boolean = false;

  constructor(isGeometryEnable: boolean) {
    this.geometryTransitionEnable = isGeometryEnable;
  }

  showBrowser(geometryIndex: number | undefined, geometryString: string, name: string, param: Object): void {
    Log.info(TAG, 'call show browser geometryIndex ' + geometryIndex + ` geometryString ${geometryString}`);
    LocalStorage.getShared()?.setOrCreate<number>('currentOperateControllerId', this.browserControllerId)
    // instrument ignore else
    if (geometryIndex !== undefined && geometryString !== undefined) {
      this.currentIndex = geometryIndex;
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
      // 大图打开，isShowBrowserAni 是否在做大图打开动效，默认为false
      LocalStorage.getShared()?.setOrCreate<boolean>('isShowBrowserAni', true);
      performanceMonitor.begin(BigDataConstants.OPEN_BROWSER, performanceMonitor?.ActionType.LAST_UP);
      // 退出大图会将url置为astc，复用大图时需要重置回去
      this.appBroadCast.emit(BroadCastConstants.RECOVER_SHOW_RESOURCE);
      LocalStorage.getShared()?.setOrCreate<boolean>('isAnimating', true);
      Log.info(TAG, 'animateToImmediately start');
      animateToImmediately({
        curve: Constants.OPEN_PHOTO_CURVE,
        finishCallbackType: FinishCallbackType.LOGICALLY,
        onFinish: () => {
          Log.debug(TAG, 'show browser animate end');
          clearTimeout(timer);
          performanceMonitor.end(BigDataConstants.OPEN_BROWSER);
          if (!this.isEntering) {
            return;
          }
          ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_ANIMATION_FINISH);
          this.finishAnimation();
          LocalStorage.getShared()?.setOrCreate<boolean>('isShowBrowserAni', false);
          LocalStorage.getShared()?.setOrCreate<boolean>('isAnimating', false);
          UiUtil.setBundleNameValue(true, LocalStorage.getShared());
          if (name !== 'ThirdSelectPhotoGridBase' && !(param as Params)?.isCollagePageEnter) {
            // 后续横竖屏适配需求完成后放开
            WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
          }
        }
      }, (): void => {
        Log.info(TAG, 'animateToImmediately end');
        Log.info(TAG, `showBrowse isBrowserShow:${this.isBrowserShow}`);
        UiUtil.resetGeometryTransitionParams();
        LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', geometryIndex);
        LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', true);
        this.pageFrom = name;
        this.browserParam = param;
        this.isBrowserShow = true;
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

  doAnimate(): void {
    animateToImmediately({
      curve: Constants.OPEN_OTHER_CONTENT,
      delay: Constants.OPEN_OTHER_CONTENT_DURATION,
    }, (): void => {
      this.isBrowserShowContent = true;
    });
  }

  hideBrowser(position: number): void {
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
      LocalStorage.getShared()?.setOrCreate<boolean>('isAnimating', true);
      animateTo({
        curve: Constants.CLOSE_PHOTO_CURVE,
        onFinish: (): void => {
          clearTimeout(timer);
          LocalStorage.getShared()?.setOrCreate<boolean>('isAnimating', false);
          if (this.isStartShowWhileHide) {
            this.isStartHide = false;
            return;
          }
          UiUtil.resetGeometryTransitionParams();
          this.finishAnimation();
          UiUtil.setBundleNameValue(false, LocalStorage.getShared());
        }
      }, (): void => {
        Log.info(TAG, `hideBrowserIf isBrowserShow:${this.isBrowserShow}`);
        this.isBrowserShow = false;
        LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', false);
        this.browserParam;
        LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', -(position + 1));
        this.appBroadCast.emit(BroadCastConstants.CLOSE_BROWSER_AND_RETURN_TO_SELECT_VIEW);
      });
    } else {
      let isGalleryCleanupPage: boolean = storage?.get<boolean>(CommonConstants.IS_GALLERY_CLEANUP_PAGE) ?? false;
      if (isGalleryCleanupPage) {
        this.isAnimating = true;
        animateToImmediately({
          curve: Constants.CLOSE_PHOTO_CURVE,
          onFinish: (): void => {
            this.afterAnimation(timer, position);
          }
        }, (): void => {
          this.beforeAnimation(position);
        });
      } else {
        let uiContext: UIContext = LocalStorage.getShared()?.get<UIContext>('uiContext') as UIContext;
        if (!uiContext) {
          Log.error(TAG, 'uiContext undefined');
          return;
        }
        this.isAnimating = true;
        performanceMonitor.begin('CLOSE_BROWSER', performanceMonitor?.ActionType.LAST_UP);
        uiContext.animateTo({
          curve: Constants.CLOSE_PHOTO_CURVE,
          onFinish: (): void => {
            this.afterAnimation(timer, position);
            performanceMonitor.end('CLOSE_BROWSER');
          }
        }, (): void => {
          this.beforeAnimation(position);
        });
      }

    }
  }

  private beforeAnimation(position: number): void {
    Log.info(TAG, `hideBrowserElse isBrowserShow:${this.isBrowserShow}`);
    this.isBrowserShow = false;
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
    UiUtil.resetGeometryTransitionParams();
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

  showSelectBrowser(geometryIndex: number, geometryString: string, name: string, param: Object): void {
    LocalStorage.getShared()?.setOrCreate<number>('currentOperateControllerId', this.browserControllerId)
    Log.info(TAG, 'call show select browser');
    this.isAnimating = true;
    let timer: number = setTimeout((): void => {
      Log.error(TAG, `showSelectBrowser timeout, geometryIndex=${geometryIndex}`);
    }, ANIMATE_TIME_LIMIT)
    LocalStorage.getShared()?.setOrCreate<boolean>('isShowBrowserAni', true);
    this.isEntering = true;
    // 退出大图会将url置为astc，复用大图时需要重置回去
    this.appBroadCast.emit(BroadCastConstants.RECOVER_SHOW_RESOURCE);
    animateTo({
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
      UiUtil.resetGeometryTransitionParams();
      UiUtil.updateGeometryTapInfo(geometryIndex, geometryString);
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
    Log.info(TAG, `finishAnimation isAnimating = false ${this.isSelectedMode}`);
    this.isAnimating = false;
    this.isDrag = false;
    this.isStartHide = false;
    this.isStartShowWhileHide = false;
    if (!DeviceInfo.isPhoneUx() && this.focusCtrlManager.getFocusItemKey() && !this.isBrowserShow && !this.isSelectedMode) {
      let isSuccessFoucsed: boolean = focusControl.requestFocus(this.focusCtrlManager.getFocusItemKey());
      ShortCut.mSelectManager?.deSelectAll();
      this.focusCtrlManager.getFocusItemUri() &&
      ShortCut.mSelectManager?.toggle(this.focusCtrlManager.getFocusItemUri(), isSuccessFoucsed);
    } else if (DeviceInfo.isPc() && this.focusCtrlManager.getFocusItemKey()
      && !this.isBrowserShow && this.isSelectedMode) {
      if (this.pageFrom === CommonConstants.PHOTO_TRANSITION_TIMELINE ||
        this.pageFrom === CommonConstants.PHOTO_TRANSITION_HIDDEN_VIEW_PC) {
        focusControl.requestFocus(this.pageFrom);
      } else {
        focusControl.requestFocus(CommonConstants.PHOTO_GRID_VIEW_PC);
      }
    }
  }
}