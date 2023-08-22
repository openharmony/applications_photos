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
  BrowserController,
  Constants,
  Log,
  MediaItem,
  mMultimodalInputManager,
  PhotoBrowserBg,
  BrowserConstants as PhotoConstants,
  PhotoDataSource,
  PhotoSwiper,
  ScreenManager,
  SelectManager,
  SelectUtil,
  ThirdSelectPhotoBrowserActionBar,
  UiUtil
} from '@ohos/common';

const TAG: string = 'SelectPhotoBrowserView';

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
  selectManager: SelectManager;
  isMultiPick = true;
  mTransition: string;
  controller: SwiperController = new SwiperController();
  @Provide isDeleting: boolean = false;

  // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
  @Provide('transitionIndex') currentIndex: number = 0;

  // position
  mPosition: number;
  timelineIndex: number = -1;
  @Prop @Watch('onPageChanged') pageStatus: boolean;
  @StorageLink('geometryOpacity') geometryOpacity: number = 1;
  @State @Watch('onGeometryChanged') geometryTransitionId: string = 'default_id';
  @Link isRunningAnimation: boolean;
  @ObjectLink browserController: BrowserController;
  // dataSource
  private dataSource: PhotoDataSource = new PhotoDataSource();
  // The global BroadCast of the application process. Event registration and destruction should be paired
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private geometryTransitionEnable: boolean = false;

  onPageChanged() {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onGeometryChanged() {
    AppStorage.SetOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'photoBrowser aboutToAppear');
    this.geometryTransitionId = AppStorage.Get('geometryTransitionBrowserId')
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
    this.selectManager = AppStorage.Get(Constants.PHOTO_GRID_SELECT_MANAGER);
    let param: any = this.browserController.selectBrowserParam;
    if (param.pageFrom) {
      this.pageFrom = param.pageFrom;
    }
    if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
      this.dataSource = new PhotoDataSource('Recycle');
    } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
      this.dataSource.setDeviceId(param.deviceId);
    }

    this.dataSource.setAlbumDataSource(AppStorage.Get(Constants.APP_KEY_PHOTO_BROWSER));
    if (this.isMultiPick == true && this.selectManager) {
      this.selectedCount = this.selectManager.getSelectedCount();
    }

    this.onPhotoChanged(param.position);
    this.mTransition = param.transition;
    this.onMenuClicked = this.onMenuClicked.bind(this);

    this.dataSource.setBroadCast(this.broadCast);

    this.broadCast.on(PhotoConstants.PULL_DOWN_END, (event) => {
      Log.info(TAG, `PULL_DOWN_END : ${JSON.stringify(event)}`);
      this.onBackPress();
    });

    this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, (size: number) => {
      this.onDataSizeChanged(size);
    });

    this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, (size: number) => {
      // onContentChanged only the current item is updated
      Log.info(TAG, `DATA_CONTENT_CHANGED : ${size}`);
      this.onPhotoChanged(this.currentIndex);
    });

    this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, (value: boolean) => {
      Log.info(TAG, `set swiper swipe ${value}`);
      this.canSwipe = value;
    });

    this.appBroadCast.on(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, () => {
      Log.debug(TAG, 'hook back press from page.');
      this.onBackPress();
    });
  }

  aboutToDisappear(): void {
    this.broadCast.release();
    this.dataSource.release();
    mMultimodalInputManager.unregisterListener();
    this.controller = undefined;
    this.broadCast.off(null, null);
    this.appBroadCast.off(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, null);
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
      this.isSelected = this.selectManager.isItemSelected(currentPhoto.uri, this.timelineIndex);
      AppStorage.SetOrCreate<number>('placeholderIndex', this.timelineIndex);
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
    if (this.selectManager.toggle(currentPhoto.uri, this.isSelected, this.timelineIndex)) {
      this.selectedCount = this.selectManager.getSelectedCount();
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
    switch (action.actionID) {
      case Action.BACK.actionID:
        this.onBackPress();
        return;
      case Action.MATERIAL_SELECT.actionID:
        Log.info(TAG, 'click UN_SELECTED');
        this.selectStateChange();
        return;
      case Action.SELECTED.actionID:
        Log.info(TAG, 'click SELECTED');
        this.selectStateChange();
        return;
      case Action.OK.actionID:
        Log.info(TAG, 'click OK');
        this.setPickResult();
        break;
      default:
        break;
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
          // @ts-ignore
        .transition(TransitionEffect.opacity(0))
      PhotoSwiper({
        dataSource: this.dataSource,
        mTransition: this.mTransition,
        onPhotoChanged: this.onPhotoChanged.bind(this),
        swiperController: this.controller,
        geometryTransitionEnable: this.geometryTransitionEnable,
        broadCast: $broadCast,
        isInSelectedMode: true,
        isRunningAnimation: $isRunningAnimation
      })

      ThirdSelectPhotoBrowserActionBar({
        isMultiPick: this.isMultiPick,
        onMenuClicked: this.onMenuClicked,
        isShowBar: $isShowBar,
        totalSelectedCount: $selectedCount
      })
        .opacity(this.geometryOpacity)
          // @ts-ignore
        .transition(TransitionEffect.opacity(0))
    }
    .padding({ bottom: $r('app.float.selected_photos_list_bar') })
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
    PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
  }

  private setPickResult(): void {
    let uriArray;
    if (this.isMultiPick) {
      uriArray = SelectUtil.getUriArray(this.selectManager.clickedSet);
      Log.debug(TAG, `uri size: ${uriArray}`);
    } else {
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined) {
        return;
      }
      uriArray = currentPhoto.uri;
    }
    let abilityResult = {
      'resultCode': 0,
      'want': {
        'parameters': {
          'select-item-list': uriArray
        }
      }
    };
    globalThis.photosAbilityContext.terminateSelfWithResult(abilityResult).then((result) => {
      Log.info(TAG, `terminateSelfWithResult result: ${result}`);
    });
  }
}
