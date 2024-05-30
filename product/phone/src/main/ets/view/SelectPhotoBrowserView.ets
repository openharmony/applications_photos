/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import {
  Action,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  Log,
  MediaItem,
  mMultimodalInputManager,
  BrowserConstants as PhotoConstants,
  PhotoDataSource,
  ScreenManager,
  SelectManager,
  SelectUtil,
  UiUtil,
  MediaDataSource
} from '@ohos/common';
import {
  BrowserController,
  PhotoBrowserBg,
  PhotoSwiper,
  ThirdSelectPhotoBrowserActionBar
} from '@ohos/common/CommonComponents';
import ability from '@ohos.ability.ability';
import common from '@ohos.app.ability.common';

const TAG: string = 'SelectPhotoBrowserView';

interface Params {
  pageFrom: number;
  deviceId: string;
  position: number;
  transition: string;
};

// select mode
@Component
export struct SelectPhotoBrowserView {
  @Provide backgroundColorResource: Resource = $r('app.color.default_background_color');
  @State selectedCount: number = 0;
  @State broadCast: BroadCast = new BroadCast();
  @Provide isSelected: boolean = true;
  @State isShowBar: boolean = true;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @Provide canSwipe: boolean = true;
  selectManager: SelectManager | null = null;
  isMultiPick = true;
  mTransition: string = '';
  controller: SwiperController = new SwiperController();
  @Provide isDeleting: boolean = false;
  @Provide canEdit: boolean = false;

  // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
  @Provide('transitionIndex') currentIndex: number = 0;

  // position
  mPosition: number = 0;
  timelineIndex: number = -1;
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @StorageLink('geometryOpacity') geometryOpacity: number = 1;
  @State @Watch('onGeometryChanged') geometryTransitionId: string = 'default_id';
  @Link isRunningAnimation: boolean;
  @ObjectLink browserController: BrowserController;
  // dataSource
  private dataSource: PhotoDataSource = new PhotoDataSource();
  // The global BroadCast of the application process. Event registration and destruction should be paired
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private geometryTransitionEnable: boolean = false;
  private pullDownEndFunc: Function = (): void => this.pullDownEnd();
  private dataSizeChangedFunc: Function = (size: number): void => this.onDataSizeChanged(size);
  private dataContentChangedFunc: Function = (size: number): void => this.dataContentChanged(size);
  private setDisableSwipeFunc: Function = (value: boolean): void => this.setDisableSwipe(value);

  private pullDownEnd(): void {
    this.onBackPress();
  }

  private dataContentChanged(size: number): void {
    // onContentChanged only the current item is updated
    Log.info(TAG, `DATA_CONTENT_CHANGED : ${size}`);
    this.onPhotoChanged(this.currentIndex);
  }

  private setDisableSwipe(value: boolean): void {
    Log.info(TAG, `set swiper swipe ${value}`);
    this.canSwipe = value;
  }

  onPageChanged() {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onGeometryChanged() {
    AppStorage.setOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'photoBrowser aboutToAppear');
    this.geometryTransitionId = AppStorage.get<string>('geometryTransitionBrowserId') as string;
    Log.info(TAG, `photoBrowser aboutToAppear  ${this.geometryTransitionId}`);
    this.backgroundColorResource = $r('app.color.black');
    mMultimodalInputManager.registerListener((control: number) => {
      Log.info(TAG, `key control : ${control} index ${this.currentIndex}`);
      if (control == 0) {
        if (this.currentIndex > 0) {
          this.onPhotoChanged(this.currentIndex - 1);
        }
      } else if (control == 1) {
        if (this.currentIndex < this.dataSource.totalCount() - 1) {
          this.onPhotoChanged(this.currentIndex + 1);
        }
      } else {
        this.onBackPress();
      }
    });
    this.selectManager = AppStorage.get<SelectManager>(Constants.PHOTO_GRID_SELECT_MANAGER) as SelectManager;
    try {
      let param: Params = this.browserController.selectBrowserParam as Params;
      if (param.pageFrom) {
        this.pageFrom = param.pageFrom;
      }
      if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
        this.dataSource = new PhotoDataSource('Recycle');
      } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
        this.dataSource.setDeviceId(param.deviceId);
      }
      this.dataSource.setAlbumDataSource(
        AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) as MediaDataSource);
      if (this.isMultiPick == true && this.selectManager) {
        this.selectedCount = this.selectManager.getSelectedCount();
      }
      this.onPhotoChanged(param.position);
      this.mTransition = param.transition;
    } catch (e) {
      Log.error(TAG, `param error ${e}`);
    }
    this.dataSource.setBroadCast(this.broadCast);
    this.broadCast.on(PhotoConstants.PULL_DOWN_END, this.pullDownEndFunc);
    this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, this.dataSizeChangedFunc);
    this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, this.dataContentChangedFunc);
    this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, this.setDisableSwipeFunc);
    this.appBroadCast.on(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, this.pullDownEndFunc);
  }

  aboutToDisappear(): void {
    this.broadCast.release();
    this.dataSource.release();
    mMultimodalInputManager.unregisterListener();
    if (this.broadCast) {
      this.broadCast.off(PhotoConstants.PULL_DOWN_END, this.pullDownEndFunc);
      this.broadCast.off(PhotoConstants.DATA_SIZE_CHANGED, this.dataSizeChangedFunc);
      this.broadCast.off(PhotoConstants.DATA_CONTENT_CHANGED, this.dataContentChangedFunc);
      this.broadCast.off(PhotoConstants.SET_DISABLE_SWIPE, this.setDisableSwipeFunc);
    }
    this.appBroadCast.off(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, this.pullDownEndFunc);
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG, `onDataSizeChanged, size is ${size}`);
    if (size == 0) {
      this.onBackPress();
    }
  }

  onPhotoChanged(index: number): void {
    this.currentIndex = index;
    this.timelineIndex = this.dataSource.getPositionByIndex(index);
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
    } else {
      this.isSelected = this.selectManager?.isItemSelected(currentPhoto.uri, this.timelineIndex) ?? false;
      AppStorage.setOrCreate<number>('placeholderIndex', this.timelineIndex);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + this.isSelected;
      Log.info(TAG, `onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri},\
        isSelected: ${this.isSelected}  geometryTransitionId ${this.geometryTransitionId}`);
    }
  }

  selectStateChange() {
    Log.info(TAG, `change selected, timeline index ${this.timelineIndex}`);
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }
    this.isSelected = !this.isSelected;
    if (this.selectManager?.toggle(currentPhoto.uri, this.isSelected, this.timelineIndex)) {
      this.selectedCount = this.selectManager?.getSelectedCount() ?? 0;
    }
    this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + this.isSelected;
    Log.info(TAG, `selectedCount: ${this.selectedCount} after state change`)
  }

  onPageShow() {
    Log.info(TAG, 'onPageShow');
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.mTransition]);
  }

  onPageHide() {
    Log.info(TAG, 'onPageHide');
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.mTransition]);
  }

  onMenuClicked(action: Action) {
    Log.debug(TAG, `onMenuClicked, action: ${action.actionID}`);
    if (action.actionID === Action.BACK.actionID) {
      this.onBackPress();
    } else if (action.actionID === Action.MATERIAL_SELECT.actionID) {
      Log.info(TAG, 'click UN_SELECTED');
      this.selectStateChange();
    } else if (action.actionID === Action.SELECTED.actionID) {
      Log.info(TAG, 'click SELECTED');
      this.selectStateChange();
    } else if (action.actionID === Action.OK.actionID) {
      Log.info(TAG, 'click OK');
      this.setPickResult();
    }
  }

  getCurrentPhoto(): MediaItem {
    return this.dataSource.getData(this.currentIndex)?.data;
  }

  onBackPress() {
    Log.info(TAG, 'onBackPress');
    if (this.geometryTransitionEnable) {
      this.browserController.hideSelectBrowser();
    } else {
      router.back({
        url: '',
        params: { index: this.currentIndex }
      });
    }
    return true;
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      PhotoBrowserBg({ isShowBar: $isShowBar })
        .opacity(this.geometryOpacity)
        .transition(TransitionEffect.opacity(0))
      PhotoSwiper({
        dataSource: this.dataSource,
        mTransition: this.mTransition,
        onPhotoChanged: (index: number): void => this.onPhotoChanged(index),
        swiperController: this.controller,
        geometryTransitionEnable: this.geometryTransitionEnable,
        broadCast: $broadCast,
        isInSelectedMode: true,
        isRunningAnimation: $isRunningAnimation
      })

      ThirdSelectPhotoBrowserActionBar({
        isMultiPick: this.isMultiPick,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        isShowBar: $isShowBar,
        totalSelectedCount: $selectedCount
      })
        .opacity(this.geometryOpacity)
        .transition(TransitionEffect.opacity(0))
    }
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
    PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
  }

  private setPickResult(): void {
    let uriArray: string[];
    if (this.isMultiPick) {
      uriArray = SelectUtil.getUriArray(this.selectManager?.clickedSet ?? new Set());
      Log.debug(TAG, `uri size: ${uriArray}`);
    } else {
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined) {
        return;
      }
      uriArray = [currentPhoto.uri];
    }
    let abilityResult: ability.AbilityResult = {
      resultCode: 0,
      want: {
        parameters: {
          'select-item-list': uriArray
        }
      }
    };
    let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    context.terminateSelfWithResult(abilityResult).then((result: void) => {
      Log.info(TAG, `terminateSelfWithResult result: ${result}`);
    });
  }
}
