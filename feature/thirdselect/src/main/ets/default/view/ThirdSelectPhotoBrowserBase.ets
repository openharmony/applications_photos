/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import Matrix4 from '@ohos.matrix4';
import {
  Action,
  BigDataConstants,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  BrowserConstants,
  Constants,
  Log,
  MediaDataSource,
  MediaItem,
  mMultimodalInputManager,
  PhotoDataSource,
  ReportToBigDataUtil,
  ScreenManager,
  SelectUtil,
  ThirdSelectManager
} from '@ohos/common';
import {
  BrowserController,
  PhotoBrowserBg,
  PhotoSwiper,
  ThirdSelectPhotoBrowserActionBar
} from '@ohos/common/CommonComponents';

import { FormConstants, IS_HORIZONTAL } from '../utils/ThirdSelectConstants';
import { ThirdSelectedPanel } from './ThirdSelectedPanel';
import { MouseTurnPageOperation } from '@ohos/browser/BrowserComponents';
import { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4'
import ability from '@ohos.ability.ability';
import common from '@ohos.app.ability.common';
import { Results } from '@ohos/common/src/main/ets/default/view/PhotoSwiper';

const TAG: string = 'thiSel_ThirdSelectPhotoBrowserBase';

interface Params {
  isFromFa: boolean;
  selectMode: boolean;
  position: number;
  transition: string;
  bundleName: string;
  title: string;
  maxSelectCount: number;
};

// third selection photoBrowser
@Component
export struct ThirdSelectPhotoBrowserBase {
  @Provide backgroundColorResource: Resource = $r('app.color.default_background_color');
  @State totalSelectedCount: number = 0;
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide isSelected: boolean = true;
  @State isShowBar: boolean = true;
  @Provide isDefaultBackgroundColor: boolean = true;
  @State isPhotoScaled: boolean = false;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  selectManager: ThirdSelectManager | null = null;
  bundleName: string = '';
  isMultiPick = true;
  mTransition: string = '';
  controller: SwiperController = new SwiperController();
  @Provide('transitionIndex') currentIndex: number = 0;
  @State currentUri: string = '';
  isFromFa: boolean = false;
  @Provide canSwipe: boolean = true;
  // position
  mPosition: number = 0;
  @State title: string = '';
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @StorageLink(IS_HORIZONTAL) isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  maxSelectCount: number = 0;
  @StorageLink('geometryOpacity') geometryOpacity: number = 1;
  @State @Watch('onGeometryChanged') geometryTransitionId: string = 'default_id';
  @Link isRunningAnimation: boolean;
  @ObjectLink browserController: BrowserController;
  @Provide isDeleting: boolean = false;
  // DataSource
  private dataSource: ThirdBrowserDataSource = new ThirdBrowserDataSource();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private geometryTransitionEnable: boolean = false;
  private isSelectMode: boolean = false;
  private pullDownFunc: Function = (): Boolean => this.onBackPress();
  private dataSizeChangedFunc: Function = (size: number): void => this.onDataSizeChanged(size);
  private selectFunc: Function = (position: number, key: string, value: boolean): void => this.selectCallback(position, key, value);
  private dataContentChangedFunc: Function = (index: number): void => this.onPhotoChanged(index);
  private jumpThirdPhotoBrowserFunc: Function = (name: string, item: MediaItem, isSelectMode = false): void =>
  this.jumpBrowserCallback(name, item, isSelectMode);
  private setDisableSwipeFunc: Function = (value: boolean): void => this.setDisableSwipe(value);

  onGeometryChanged() {
    AppStorage.SetOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'photoBrowser aboutToAppear');
    this.backgroundColorResource = $r('app.color.black');
    this.isDefaultBackgroundColor = false;
    this.geometryTransitionId = AppStorage.get<string>('geometryTransitionBrowserId') as string;
    this.browserController.browserBackFunc = (): boolean => this.onBackPress();
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
    this.selectManager = AppStorage.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER) as ThirdSelectManager;
    this.dataSource.setAlbumDataSource(AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) as MediaDataSource);
    this.isMultiPick = this.selectManager.getIsMultiPick();
    if (this.isMultiPick) {
      this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    } else {
      this.totalSelectedCount = 1;
    }

    let param: Params = this.browserController.browserParam as Params;
    this.isFromFa = param.isFromFa;
    this.isSelectMode = param.selectMode;
    if (param.selectMode) {
      this.dataSource.setSelectMode(this.selectManager);
    }
    this.onPhotoChanged(param.position);
    this.mTransition = param.transition;
    this.bundleName = param.bundleName;
    this.title = param.title;
    this.maxSelectCount = param.maxSelectCount;

    this.dataSource.setBroadCast(this.broadCast);

    this.broadCast.on(BrowserConstants.PULL_DOWN_END, this.pullDownFunc);
    this.broadCast.on(BrowserConstants.DATA_SIZE_CHANGED, this.dataSizeChangedFunc);
    this.broadCast.on(BroadCastConstants.SELECT, this.selectFunc);
    this.broadCast.on(BrowserConstants.DATA_CONTENT_CHANGED, this.dataContentChangedFunc);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
    this.broadCast.on(BrowserConstants.SET_DISABLE_SWIPE, this.setDisableSwipeFunc);

    if (this.pageStatus) {
      this.onPageShow();
    }
  }

  aboutToDisappear(): void {
    this.broadCast.release();
    if(this.broadCast) {
      this.broadCast.off(BrowserConstants.PULL_DOWN_END, this.pullDownFunc);
      this.broadCast.off(BrowserConstants.DATA_SIZE_CHANGED, this.dataSizeChangedFunc);
      this.broadCast.off(BroadCastConstants.SELECT, this.selectFunc);
      this.broadCast.off(BrowserConstants.DATA_CONTENT_CHANGED, this.dataContentChangedFunc);
      this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
      this.broadCast.off(BrowserConstants.SET_DISABLE_SWIPE, this.setDisableSwipeFunc);
    }
    this.dataSource.release();
    mMultimodalInputManager.unregisterListener();
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG, `onDataSizeChanged, size is ${size}`);
    if (size == 0) {
      this.onBackPress();
    }
  }

  setDisableSwipe(value: boolean): void {
    Log.info(TAG, `set swiper swipe ${value}`);
    this.canSwipe = value;
  }

  onPhotoChanged(index: number): void {
    this.currentIndex = index;
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
    } else {
      this.isSelected = this.selectManager?.isItemSelected(currentPhoto.uri) ?? false;
      this.currentUri = currentPhoto.uri;

      let dataSourceIndex = this.isSelectMode ? (this.selectManager?.getSelectItemDataSourceIndex(currentPhoto) ?? Constants.INVALID) : index;
      let timelineIndex = this.dataSource.getPositionByIndex(dataSourceIndex);
      AppStorage.SetOrCreate<number>('placeholderIndex', timelineIndex);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + this.isSelected;
      Log.info(TAG, `onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}, \
        geometryTransitionId = ${this.geometryTransitionId}, placeholderIndex = ${timelineIndex}`);
    }
  }

  selectStateChange() {
    Log.info(TAG, 'change selected.');
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }
    this.isSelected = !this.isSelected;
    if (this.isSelected) {
      this.selectManager?.toggle(currentPhoto.uri, true);
    } else {
      this.selectManager?.toggle(currentPhoto.uri, false);
    }
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + this.isSelected;
    this.appBroadCast.emit(BroadCastConstants.UPDATE_SELECT, [currentPhoto.uri, this.isSelected]);
    Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after state change geometryTransitionId ${this.geometryTransitionId}`);
  }

  selectCallback(position: number, key: string, value: boolean) {
    if (key === this.currentUri) {
      this.isSelected = value;
    }
    if (this.selectManager) {
      this.selectManager.toggle(key, value);
    }
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after select callback`);
  }

  onPageChanged() {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onPageShow() {
    Log.debug(TAG, 'onPageShow');
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.mTransition]);
  }

  onPageHide() {
    Log.debug(TAG, 'onPageHide');
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.mTransition]);
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    if (action.actionID === Action.BACK.actionID) {
      interface Msg {
        from: string;
      }
      let msg: Msg = {
        from: BigDataConstants.BY_CLICK,
      }
      ReportToBigDataUtil.report(BigDataConstants.ESC_PHOTO_BROWSER_WAY, msg);
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
    Log.debug(TAG, 'getCurrentPhoto  ' + this.currentIndex);
    return this.dataSource.getData(this.currentIndex)?.data;
  }

  onBackPress() {
    if (this.geometryTransitionEnable) {
      this.controller.finishAnimation((): void => this.onBackPressInner());
    } else {
      router.back({
        url: '',
        params: { index: this.currentIndex }
      });
    }
    return true;
  }

  @Builder buildCheckBox() {
    if (this.isMultiPick) {
      Row() {
        Image(this.isSelected ? $r('app.media.picker_checkbox_selected_dark') : $r('app.media.picker_checkbox_unselected_dark'))
          .width($r('app.float.icon_size'))
          .aspectRatio(1)
          .key('Checkbox_' + this.currentIndex)
          .margin({
            right: $r('sys.float.ohos_id_max_padding_end'),
            bottom: $r('app.float.picker_browser_checkbox_margin_bottom')
          })
          .onClick(() => {
            this.selectStateChange();
          })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
      .opacity(this.geometryOpacity)
      // @ts-ignore
      .transition(TransitionEffect.opacity(0))
      .hitTestBehavior(HitTestMode.Transparent)
    }
  }

  @Builder buildPanel() {
    ThirdSelectedPanel({
      maxSelectCount: this.maxSelectCount,
      onMenuClicked: (action: Action): void => this.onMenuClicked(action),
      isBrowserMode: true,
      isMultiPick: this.isMultiPick,
      mTransition: TAG,
      isFromFa: this.isFromFa,
      currentUri: this.currentUri,
      isShowBar: $isShowBar,
      totalSelectedCount: $totalSelectedCount
    })
      .opacity(this.geometryOpacity)
        // @ts-ignore
      .transition(TransitionEffect.opacity(0))
      .hitTestBehavior(HitTestMode.Transparent)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack({ alignContent: Alignment.TopStart }) {
        PhotoBrowserBg({ isShowBar: $isShowBar })
          .opacity(this.geometryOpacity)
            // @ts-ignore
          .transition(TransitionEffect.opacity(0))

        PhotoSwiper({
          dataSource: this.dataSource,
          mTransition: this.mTransition,
          onPhotoChanged: (index: number): void => this.onPhotoChanged(index),
          swiperController: this.controller,
          verifyPhotoScaledFunc:  (matrix?: Matrix4.Matrix4Transit): void => this.verifyPhotoScaled(matrix),
          geometryTransitionEnable: true,
          broadCast: $broadCast,
          isRunningAnimation: $isRunningAnimation
        })

        if (this.isHorizontal) {
          MouseTurnPageOperation({
            dataSource: this.dataSource,
            controller: this.controller,
            isPhotoScaled: this.isPhotoScaled,
            isShowBar: this.isShowBar
          })
            .opacity(this.geometryOpacity)
              // @ts-ignore
            .transition(TransitionEffect.opacity(0))
            .hitTestBehavior(HitTestMode.Transparent)

        }
        ThirdSelectPhotoBrowserActionBar({
          isMultiPick: this.isMultiPick,
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          title: this.title,
          isThird: true,
          isShowBar: $isShowBar,
          totalSelectedCount: $totalSelectedCount
        })
          .opacity(this.geometryOpacity)
            // @ts-ignore
          .transition(TransitionEffect.opacity(0))
          .hitTestBehavior(HitTestMode.Transparent)
      }

      this.buildCheckBox()
      this.buildPanel()
    }
    .padding({ bottom: $r('app.float.buttonWithoutText') })
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: BrowserConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
    PageTransitionExit({ duration: BrowserConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
  }

  verifyPhotoScaled(matrix?: Matrix4.Matrix4Transit): void {
    if (matrix) {
      let mat: number[] | undefined = (matrix.copy() as Matrix4x4).matrix4x4;
      if (mat) {
        let xScale: number = mat[0];
        let yScale: number = mat[5];
        Log.info(TAG, `photo in PhotoItem has Scaled x scale: ${xScale}, y scale: ${yScale}, mat: ${mat}`);
        this.isPhotoScaled = xScale != 1 || yScale != 1
      }
    } else {
      this.isPhotoScaled = false
      Log.info(TAG, `photo in PhotoItem has not Scaled isPhotoScaled: ${this.isPhotoScaled}`);
    }
  }

  private onBackPressInner(): void {
    this.browserController.hideBrowser();
  }

  private jumpBrowserCallback(name: string, item: MediaItem, isSelectMode = false) {
    if (this.dataSource && item && this.currentUri != item.uri) {
      let tgtIndex = this.dataSource.getDataIndex(item);
      Log.debug(TAG, `jump to index ${tgtIndex}`)
      this.onPhotoChanged(tgtIndex);
    }
  }

  private setPickResult(): void {
    if (this.isFromFa) {
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto) {
        Log.debug(TAG, `setPickResult. updateFormData obj: ${currentPhoto.uri}  currentIndex: ${this.currentIndex}`);
        this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
          ['', AppStorage.get<string>(FormConstants.FORM_ITEM_ALBUM_URI), AppStorage.get<Resource>(FormConstants.FORM_ITEM_DISPLAY_NAME),
          currentPhoto.uri, false]);
      } else {
        Log.error(TAG, 'Fa setPickResult is null');
      }
      return;
    }
    let uriArray: Array<string>;
    if (this.isMultiPick) {
      if (this.selectManager === null) {
        Log.error(TAG, 'Select Manager empty');
        return;
      }
      uriArray = SelectUtil.getUriArray(this.selectManager?.clickedSet ?? new Set());
      Log.info(TAG, `uri size: ${uriArray}`);
    } else {
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined) {
        return;
      }
      uriArray = [currentPhoto.uri];
    }
    let promise: Promise<void> = SelectUtil.grantPermissionForUris(uriArray, this.bundleName);
    let abilityResult: ability.AbilityResult = {
      resultCode: 0,
      want: {
        parameters: {
          'select-item-list': uriArray,
        }
      }
    };
    let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    context.terminateSelfWithResult(abilityResult).then((result: void) => {
      Log.info(TAG, `terminateSelf result: ${result}, self result ${JSON.stringify(abilityResult)}`);
    });
  }
}

/**
 * 用于预览已选中的图片的dataSource
 * 数据源取自selectManager的当前已选中图片
 */
class ThirdBrowserDataSource extends PhotoDataSource {
  private isSelectMode = false;
  private selectedItems: MediaItem[] = new Array<MediaItem>();

  totalCount() {
    if (this.isSelectMode) {
      return this.selectedItems.length;
    }
    return super.totalCount();
  }

  getData(index: number): Results {
    if (this.isSelectMode) {
      return this.packData(index, this.selectedItems[index]) as Results;
    }
    return super.getData(index) as Results;
  }

  setSelectMode(manager: ThirdSelectManager) {
    this.isSelectMode = true;
    this.selectedItems = manager.getSelectItems();
  }
}
