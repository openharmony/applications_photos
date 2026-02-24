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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy {
  ActionBarColorMode,
  ActionBarMode
} from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  updateAlbumPageGridPaddingLeftAndRight
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { SingleTitle } from './SingleTitle';
import lazy { DetailTitle } from './DetailTitle';
import lazy { SelectionTitle } from './SelectionTitle';
import lazy { MenuPanel } from './MenuPanel';
import lazy { DetailMenuPanel } from './DetailMenuPanel';
import lazy { ActionBarButton } from './ActionBarButton';
import lazy { WindowVariables } from '@ohos/tools/src/main/global/HapVariables';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy window from '@ohos.window';
import lazy { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { SearchSwitchManager } from '@ohos/common/src/main/ets/default/model/SearchSwitchManager';
import lazy { MenuListUtil } from '@ohos/common/src/main/ets/default/utils/MenuListUtil';
import lazy { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import lazy CommonEventManager from '@ohos.commonEventManager';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuController';

/* instrument ignore file */

/**
 * ActionBar 默认左边距
 */
const PADDING_LEFT: number = 40;

/**
 * ActionBar 默认上边距
 */
const PADDING_TOP: number = 48;

/**
 * ActionBar 选择模式下大小
 */
export const SELECTION_MODE_SIZE: number = 48;

export const SELECTION_MODE_SIZE_PC: number = 40;

/**
 * ActionBar Flex 布局中元素均分占比
 */
const DEFAULT_FLEX_GROW: number = 1;

/**
 * ActionBar Flex 默认 z 序
 */
const DEFAULT_ACTION_BAR_Z_INDEX: number = 3;

const TITLE_PADDING_LEFT_PC: number = 8;

const FLEX_PROTECTED_PADDING: number = 30;

const TAG: string = 'ActionBar';

/**
 * 通用 ActionBar 类，包含了图库内常见的左侧、右侧、底部 ActionBar
 */
@Component
export struct ActionBar {
  /* instrument ignore next */
  @LocalStorageLink('isActionBarColorNormal') private isActionBarColorNormal: boolean = true;
  /* instrument ignore next */
  /* instrument ignore next */
  @Link actionBarProp: ActionBarProp;
  /* instrument ignore next */
  onMenuClicked: Function = (): void => {
    /* instrument ignore next */
  };
  /* instrument ignore next */
  public isFromPhotoBrowser: boolean = false;
  /* instrument ignore next */
  public isFromCollage: boolean = false;
  /* instrument ignore next */
  public isFromMediaOperationBase: boolean = false;
  /* instrument ignore next */
  public isFromImmersiveCompared: boolean = false;
  /* instrument ignore next */
  public isFromHiddenSecondary: boolean = false;
  /* instrument ignore next */
  private isShowHiddenGridView: boolean = false;
  /* instrument ignore next */
  private isSearchPageFromCategory: boolean = false;
  /* instrument ignore next */
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  /* instrument ignore next */
  @Prop isNeedPlaceholder: boolean = false;
  /* instrument ignore next */
  @Prop totalSelectedCount: number = -1;
  /* instrument ignore next */
  @Prop actionMoreMenuList: Action[] = [];
  /* instrument ignore next */
  @Prop dateTitleOpacity: number = 0; // 从TimelinePage传递给TimelinePageActionBar下ActionBar下SingleTitle
  /* instrument ignore next */
  @Prop actionTitleOpacity: number = 1; // 从TimelinePage传递给TimelinePageActionBar下ActionBar下SingleTitle
  /* instrument ignore next */
  @Prop dateString: string = ''; // 从TimelinePage传递给TimelinePageActionBar下ActionBar下SingleTitle
  /* instrument ignore next */
  public isTimelinePageActionBar: boolean = false;
  /* instrument ignore next */
  public isAlbumSetPageActionBar: boolean = false;
  /* instrument ignore next */
  public isNavDestinationPageActionBar: boolean = false;
  /* instrument ignore next */
  public isCameraActionBar: boolean = false;
  /* instrument ignore next */
  public isFromRealTime: boolean = false;
  /* instrument ignore next */
  public isSearchResultPage: boolean = true;
  /* instrument ignore next */
  @Prop isShowTransparent: boolean = false;
  /* instrument ignore next */
  @Prop @Watch('onSelectedOrSideChange') private isShowSideBar?: boolean = true;
  /* instrument ignore next */
  @Prop private isGroupDayView: boolean = false;
  /* instrument ignore next */
  @Prop private isSelected?: boolean = false;
  @State private titlePaddingLeft: number = updateAlbumPageGridPaddingLeftAndRight();
  /* instrument ignore next */
  @State private topSearchViewWidth: number = Constants.SearchViewWidth;
  /* instrument ignore next */
  @StorageLink('isShowSearchIcon') @Watch('isShowSearchIconChange') private isShowSearchIcon: boolean = false;
  /* instrument ignore next */
  @Prop immersiveController: ImmersiveController;
  /* instrument ignore next */
  @Prop timeController: TimeController;
  /* instrument ignore next */
  @Prop subLocalityAddress: string;
  /* instrument ignore next */
  @Prop isShowAddress: boolean = false;
  /* instrument ignore next */
  @Prop isShowDateString: boolean = false;
  /* instrument ignore next */
  @Prop @Watch('isShowSearchBrowserChange') isShowSearchBrowser: boolean;
  /* instrument ignore next */
  @Prop isSecondaryPage: boolean = false;
  /* instrument ignore next */
  @State private isFirstUnHover: boolean = true;
  /* instrument ignore next */
  @State private firstTimer: number = -1;
  /* instrument ignore next */
  @Prop private notShowDate: boolean = false;
  /* instrument ignore next */
  @Prop isFromPortrait: boolean = false;
  /* instrument ignore next */
  @Prop isFromPortraitCoverSet: boolean = false;
  /* instrument ignore next */
  @Prop isPickerPhotoBrowser: boolean = false;
  /* instrument ignore next */
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  /* instrument ignore next */
  @Prop isPageEmpty: boolean = false;
  /* instrument ignore next */
  private updateActionBarPaddingFun: Function = (): void => this.updateActionBarPadding();
  /* instrument ignore next */
  @Prop private moreMenuListPC: RightClickMenuGroup[] = [];
  /* instrument ignore next */
  @Prop private moreMenuList: Action[] = [];
  @Prop private creationMenuList: Action[] = [];
  /* instrument ignore next */
  // 收藏动效相关 triggerValue=-1，没有动效
  /* instrument ignore next */
  private triggerValue: number = -1;
  /* instrument ignore next */
  private triggerValueLastTime: number = -1;
  /* instrument ignore next */
  @Prop private showMovingPhotoCloseEffect: boolean = false;
  /* instrument ignore next */
  @Prop private movingPhotoEffectMode?: number = 0;
  /* instrument ignore next */
  //在选择模式下PC和phone浏览大图为true，其他场景为false
  /* instrument ignore next */
  private isThirdSelectPhoto?: boolean = false;
  /* instrument ignore next */
  // 连拍浏览的操作栏list
  /* instrument ignore next */
  @Prop private burstMenuList: Action[] = [];
  /* instrument ignore next */
  // 是否连拍图片展示页面
  /* instrument ignore next */
  @Prop private isBurstPhotos: boolean = false;
  /* instrument ignore next */
  // 连拍图片数目
  /* instrument ignore next */
  @Prop private totalBurstPhotosNO: number = 1;
  /* instrument ignore next */
  // 连拍图片选择数目
  /* instrument ignore next */
  @Prop private selectedBurstPhotosNO: number;
  /* instrument ignore next */
  // 照片页日期、保存图标透明度
  /* instrument ignore next */
  @State detailTitleOpacity: number = 1;
  /* instrument ignore next */
  @State detailMenuPanelOpacity: number = 1;
  /* instrument ignore next */
  // 连拍界面选择标题、保存图标透明度
  /* instrument ignore next */
  @State burstDetailMenuPanelOpacity: number = 0;
  /* instrument ignore next */
  @State burstPhotosTextTitleOpacity: number = 0;
  /* instrument ignore next */
  private updateTopModeBuilderOpacityFunc: Function =
    (opacity: number): void => this.updateTopModeBuilderOpacity(opacity);
  /* instrument ignore next */
  private updateBurstTopModeBuilderOpacityFunc: Function =
    (opacity: number): void => this.updateBurstTopModeBuilderOpacity(opacity);
  private updateTriggerValueFunc: Function = (): void => this.updateTriggerValue();
  // to control action buttons move to more menu
  private flexWidth: number = 0;
  @LocalStorageLink('leftMenuWidth') private leftMenuWidth: number = 0;
  @LocalStorageLink('detailLeftMenuWidth') private detailLeftMenuWidth: number = 0;
  @LocalStorageLink('menuPanelWidth') @Watch('verifyMenuPanelWidth') private menuPanelWidth: number = 0;
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  @State isRTL: boolean = false;
  @StorageLink('windowFocused') private isWindowFocused: boolean = true;
  private winSizeChangeFunc: Function = (size: window.Size): void => this.winSizeChange(size);
  private isUserCreatedAlbum: boolean = false;
  @State @Watch('onLeftSizeChange') private leftButtonWidth: number = 0;
  @State @Watch('onLeftSizeChange') private titleWidth: number = 0;
  @State isEllipsis: boolean = true;
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;
  @Prop selectMediaType: number;

  private onLeftSizeChange(): void {
    this.leftMenuWidth = this.titleWidth + this.leftButtonWidth + px2vp(FLEX_PROTECTED_PADDING);
    Log.info(TAG, `titleWidth : ${this.titleWidth}, leftButtonWidth: ${this.leftButtonWidth},
      FLEX_PROTECTED_PADDING: ${px2vp(FLEX_PROTECTED_PADDING)}, leftMenuWidth: ${this.leftMenuWidth}`);
    if (DeviceInfo.isPc()) {
      this.detailLeftMenuWidth = this.titleWidth + this.leftButtonWidth;
      Log.info(TAG, `titleWidth : ${this.titleWidth}, leftButtonWidth: ${this.leftButtonWidth},
        detailLeftMenuWidth: ${this.detailLeftMenuWidth}`);
    }
    if (!this.isFromCollage && (this.flexWidth > this.leftMenuWidth)) {
      this.menuPanelWidth = this.flexWidth - this.leftMenuWidth;
      Log.info(TAG, `flexWidth : ${this.flexWidth}, leftMenuWidth: ${this.leftMenuWidth},
        menuPanelWidth: ${this.menuPanelWidth}`);
    }
  }

  /* instrument ignore next */
  isShowSearchBrowserChange(): void {
    Log.info(TAG, `this.isShowSearchBrowser: ${this.isShowSearchBrowser}`);
    this.onSelectedOrSideChange();
  }

  /* instrument ignore next */
  isShowSearchIconChange(): void {
    Log.info(TAG, `isShowSearchIconChange ${this.isShowSearchIcon}`);
    if (this.isShowSearchIcon) {
      this.topSearchViewWidth = SELECTION_MODE_SIZE_PC;
    } else {
      this.topSearchViewWidth = Constants.SearchViewWidth;
    }
  }

  /* instrument ignore next */
  verifyMenuPanelWidth(): void {
    if (!DeviceInfo.isPc()) {
      return;
    }
    if (this.actionBarProp.getMode() === ActionBarMode.TOP_MODE) {
      this.actionBarProp.setDetailMenuPanelWidth(this.flexWidth - this.detailLeftMenuWidth);
    }
    if (!this.isThirdSelectPhoto) {
      MenuListUtil.updateMenuList(this.actionBarProp?.getMenuList(), this.actionBarProp);
    }
    this.isEllipsis = this.actionBarProp?.getMenuList().length <= 1;
  }

  /* instrument ignore next */
  createArray(): ActionBarProp[] {
    let actionBarProps: ActionBarProp[] = [];
    actionBarProps.push(this.actionBarProp);
    return actionBarProps;
  }

  private winSizeChange(size: window.Size): void {
    this.updateTitlePaddingLeft();
    this.updateTopSearchViewWidth(px2vp(size.width));
  }

  /* instrument ignore next */
  private updateActionBarPadding(): void {
    this.titlePaddingLeft = updateAlbumPageGridPaddingLeftAndRight();
  }

  aboutToAppear(): void {
    Log.info(TAG, `this.notShowDate: ${this.notShowDate}`);
    AppStorage.setOrCreate('titlePaddingLeft', this.titlePaddingLeft);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.winSizeChangeFunc);
    this.appBroadCast.on(BroadCastConstants.ON_SIDEBAR_CHANGED, this.updateActionBarPaddingFun);
    this.updateTitlePaddingLeft();
    this.appBroadCast.on(BroadCastConstants.UPDATE_TRIGGER_VALUE_ACTION_BAR, this.updateTriggerValueFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_TOP_MODE_BUILDER_OPACITY, this.updateTopModeBuilderOpacityFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_BURST_TOP_MODE_BUILDER_OPACITY,
      this.updateBurstTopModeBuilderOpacityFunc);
    this.currentLanguage = i18n.System.getSystemLanguage();
    this.onLanguageChange();
    this.updateTopSearchViewWidth(getScreen().getWinWidth());
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      if (this.isFromPortrait) {
        this.isActionBarColorNormal = false;
      } else {
        this.isActionBarColorNormal = this.actionBarProp.getColorMode() !== ActionBarColorMode.TRANSPARENT;
      }
      Log.info(TAG, 'createSubscriber');
      let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
        events: [
          CommonEventManager.Support.COMMON_EVENT_LOCALE_CHANGED
        ],
      }
      commonEventManager.createSubscriber(subscribeInfo, (err: BusinessError,
        commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
        if (err) {
          Log.error(TAG, `failed to create subscriber. code is ${err.code}, message is ${err.message}`);
          return;
        }
        this.subscriber = commonEventSubscriber;
        this.subscribeEvent();
      })
    }
  }

  private subscribeEvent(): void {
    const methodName: string = 'subscribeEvent';
    if (this.subscriber === null) {
      Log.error(TAG, `${methodName}, need create subscriber`);
      return;
    }
    commonEventManager.subscribe(this.subscriber, (err: BusinessError,
      commonEventData: commonEventManager.CommonEventData) => {
      if (err) {
        Log.error(TAG, `${methodName}, subscribe error. code is ${err.code}, message is ${err.message}`);
        return;
      }
      Log.info(TAG,
        `${methodName}, subscribe success, event: ${commonEventData.event}, data: ${commonEventData?.data}`);
      // 监听到语言切换后，需要重新设置currentLanguage
      this.handleLocaleChange(commonEventData);
    });
  }

  private handleLocaleChange(commonEventData: commonEventManager.CommonEventData): void {
    let systemLanguage: string = i18n.System.getSystemLanguage();
    if (this.currentLanguage !== systemLanguage) {
      Log.info(TAG, `handleLocaleChange, set currentLanguage: ${systemLanguage}`);
      AppStorage.setOrCreate<string>('currentLanguage', systemLanguage);
    }
  }

  aboutToDisappear(): void {
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.winSizeChangeFunc);
    this.appBroadCast.off(BroadCastConstants.ON_SIDEBAR_CHANGED, this.updateActionBarPaddingFun);
    this.appBroadCast.off(BroadCastConstants.UPDATE_TRIGGER_VALUE_ACTION_BAR, this.updateTriggerValueFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_TOP_MODE_BUILDER_OPACITY, this.updateTopModeBuilderOpacityFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_BURST_TOP_MODE_BUILDER_OPACITY,
      this.updateBurstTopModeBuilderOpacityFunc);
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.unsubscribeEvent();
    }
  }

  private unsubscribeEvent(): void {
    const methodName: string = 'unsubscribeEvent';
    if (this.subscriber === null) {
      Log.error(TAG, `${methodName}, need create subscriber`);
      return;
    }
    commonEventManager.unsubscribe(this.subscriber, (err: BusinessError) => {
      if (err) {
        Log.warn(TAG, `${methodName}, unsubscribe failed, code: ${err.code}, message: ${err.message}`);
      } else {
        Log.info(TAG, `${methodName}, unsubscribe success`);
      }
    });
    this.subscriber = null; // 释放引用
  }

  private onLanguageChange(): void {
    Log.info(TAG, `onLanguageChange, currentLanguage: ${this.currentLanguage}`);
    UserFileManagerAccess.getInstance().clearAddressCache();
    if (this.currentLanguage) {
      Log.info(TAG, `onLanguageChange, before isRTL: ${this.isRTL}, after isRTL:${i18n.isRTL(this.currentLanguage)}`);
      this.isRTL = DeviceInfo.isPc() && i18n.isRTL(this.currentLanguage);
    }
  }

  private ignoreSidebar(): boolean {
    return this.isFromPhotoBrowser || this.isThirdSelectPhoto || this.isFromPortrait;
  }

  private updateTitlePaddingLeft(): void {
    const ignoreSideBar: boolean = (DeviceInfo.isTablet() || DeviceInfo.isTv()) && this.ignoreSidebar();
    this.titlePaddingLeft = updateAlbumPageGridPaddingLeftAndRight(ignoreSideBar);
    AppStorage.setOrCreate('titlePaddingLeft', this.titlePaddingLeft);
  }

  private onSelectedOrSideChange(): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.titlePaddingLeft = updateAlbumPageGridPaddingLeftAndRight();
      AppStorage.setOrCreate('titlePaddingLeft', this.titlePaddingLeft);
    } else if (DeviceInfo.isTablet() || DeviceInfo.isTv()) {
      this.titlePaddingLeft = updateAlbumPageGridPaddingLeftAndRight(this.ignoreSidebar());
      if (this.isFromPortrait) {
        // 人像相册二级页面的 actionbar 无需加入额外的 padding
        return;
      }
      /* instrument ignore next */
      if (this.isShowSearchBrowser) {
        this.titlePaddingLeft = this.titlePaddingLeft + (this.isShowSideBar ? 0 :
          Constants.ActionBarButtonHotZoneHeight + Constants.ActionBarButtonPadding);
      }
    }
  }

  /* instrument ignore next */
  private getTitlePaddingLeft(): number | Resource {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && !this.isSelected && this.isShowSideBar) {
      return !this.actionBarProp.getIsNavTitle() ? $r('sys.float.padding_level8') : 0;
    }
    return !this.actionBarProp.getIsNavTitle() ? $r('sys.float.padding_level8') : 0;
  }

  /* instrument ignore next */
  private getActionBarHeight(): Length {
    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      return Constants.TV_VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT;
    }
    if (!DeviceInfo.isPc()) {
      return 'auto';
    }
    return Constants.WindowDecorHeight;
  }

  private getActionBarMarginR(): number {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      let isUseSearchViewWidth = !(this.isFromPhotoBrowser || this.isFromPortrait || this.isFromCollage ||
      this.isFromMediaOperationBase || this.isThirdSelectPhoto || this.isSelected || this.isFromPortraitCoverSet);
      Log.info(TAG, `getActionBarMarginR isUseSearchViewWidth ${isUseSearchViewWidth}`);
      isUseSearchViewWidth = SearchSwitchManager.getInstance().isSupportPhotoSearch() ? isUseSearchViewWidth : false;
      let topSearchViewWidth: number = !isUseSearchViewWidth ?
        // 16 is margin between search and window three buttons
        0 : this.topSearchViewWidth + 16;
      // 三窗背板由28变为40
      let avoidWidth: number = WindowVariables.threeButtonAvoidWidth;
      Log.info(TAG, `avoidWidth ${avoidWidth}, paddingL ${this.titlePaddingLeft}, searchWidth ${topSearchViewWidth}`);
      let result: number = this.titlePaddingLeft + avoidWidth + topSearchViewWidth;
      if (isUseSearchViewWidth) {
        // 8 is margin between action button and search
        result += 8;
      } else {
        // 16 is margin between action button and window three buttons
        result += 16;
      }
      Log.info(TAG, `getActionBarMarginR result ${result}`);
      return result;
    }
    return this.titlePaddingLeft;
  }

  private updateTopSearchViewWidth(winWidth: number): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      MenuListUtil.updateTopSearchViewWidth(winWidth,
        (isShowSearchIcon: boolean, topSearchViewWidth: number) => {
          this.topSearchViewWidth = topSearchViewWidth;
        })
    }
  }

  private needToAddLeftMenus(): boolean {
    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      return this.actionBarProp.getLeftAction().equals(Action.CANCEL);
    }
    if (!this.actionBarProp.getLeftAction().equals(Action.NONE) && !DeviceInfo.isPc()) {
      return true;
    }
    return false;
  }

  @Builder
  LeftMenus() {
    ForEach(this.createArray(), (item: ActionBarProp): void => {
      ActionBarButton({
        res: item.getLeftAction().iconRes,
        action: item.getLeftAction(),
        actionMode: this.actionBarProp.getMode(),
        onMenuClicked: this.onMenuClicked,
        isAutoTint: item.getLeftAction().isAutoTint,
        colorMode: item.getColorMode(),
        actionMoreMenuList: this.actionMoreMenuList,
        isShowTransparent: this.isShowTransparent,
        immersiveController: this.immersiveController,
        timeController: this.timeController,
        isFirstUnHover: this.isFirstUnHover,
        firstTimer: this.firstTimer,
        isImmersive: item.getIsImmersive(),
        isLeftIcon: true,
        isThirdSelectPhoto: this.isThirdSelectPhoto,
        isBurstPhotos: this.isBurstPhotos,
        isPickerPhotoBrowser: this.isPickerPhotoBrowser,
        moreMenuList: this.moreMenuList,
        moreMenuListPC: this.moreMenuListPC,
        showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
        movingPhotoEffectMode: this.movingPhotoEffectMode,
        isFromCollage: this.isFromCollage,
        isFromImmersiveCompared: this.isFromImmersiveCompared,
        isFromPhotoBrowser: this.isFromPhotoBrowser,
        isSearchPageFromCategory: this.isSearchPageFromCategory,
        isShowHiddenGridView: this.isShowHiddenGridView,
        albumInfo: this.actionBarProp.getAlbumInfo(),
        selectMediaType: this.selectMediaType,
      })
    }, (item: ActionBarProp): string => {
      return item?.getLeftAction().actionID.toString() +
      String(this.moreMenuListPC.map(item => item.menuList).flat().map(action => action.componentKey));
    })
  }

  @Builder
  MenuPanelBuilder(selectedMode: boolean) {
    if (selectedMode) {
      MenuPanel({
        menuList: this.actionBarProp.getMenuList(),
        colorMode: this.actionBarProp.getColorMode(),
        actionMode: this.actionBarProp.getMode(),
        onMenuClicked: this.onMenuClicked,
        totalSelectedCount: this.totalSelectedCount,
        isShowTransparent: this.isShowTransparent,
        immersiveController: this.immersiveController,
        timeController: this.timeController,
        isPickerPhotoBrowser: this.isPickerPhotoBrowser,
        isThirdSelectPhoto: this.isThirdSelectPhoto,
        isGroupDayView: this.isGroupDayView,
        actionMoreMenuList: this.actionMoreMenuList,
        moreMenuList: this.moreMenuList,
        creationMenuList: this.creationMenuList,
        moreMenuListPC: this.moreMenuListPC,
        flexibleMenuList: this.actionBarProp.getFlexibleMenuList(),
        showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
        movingPhotoEffectMode: this.movingPhotoEffectMode,
        isTimelinePageActionBar: this.isTimelinePageActionBar,
        isFromRealTime: this.isFromRealTime,
        isSearchResultPage: this.isSearchResultPage,
        albumInfo: this.actionBarProp.getAlbumInfo(),
        selectMediaType: this.selectMediaType,
      })
    } else {
      MenuPanel({
        menuList: this.actionBarProp.getMenuList(),
        colorMode: this.actionBarProp.getColorMode(),
        actionMode: this.actionBarProp.getMode(),
        onMenuClicked: this.onMenuClicked,
        actionMoreMenuList: this.actionMoreMenuList,
        isShowTransparent: this.isShowTransparent,
        isShowAddress: this.isShowAddress,
        immersiveController: this.immersiveController,
        timeController: this.timeController,
        isImmersive: this.actionBarProp.getIsImmersive(),
        moreMenuList: this.moreMenuList,
        moreMenuListPC: this.moreMenuListPC,
        flexibleMenuList: this.actionBarProp.getFlexibleMenuList(),
        showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
        movingPhotoEffectMode: this.movingPhotoEffectMode,
        isFromCollage: this.isFromCollage,
        isFromRealTime: this.isFromRealTime,
        isTimelinePageActionBar: this.isTimelinePageActionBar,
        albumInfo: this.actionBarProp.getAlbumInfo(),
        selectMediaType: this.selectMediaType,
      })
    }
  }

  @Builder
  SingleTitleBuilder(isHiddenIfSideBar: boolean) {
    SingleTitle({
      actionBarProp: $actionBarProp,
      dateTitleOpacity: this.dateTitleOpacity,
      actionTitleOpacity: this.actionTitleOpacity,
      dateString: this.dateString,
      isShowAddress: this.isShowAddress,
      isTimelinePageHeadTitle: this.isTimelinePageActionBar,
      defaultFlexRow: DEFAULT_FLEX_GROW,
      isShowSideBar: this.isShowSideBar,
      isGroupDayView: this.isGroupDayView,
      isSelected: this.isSelected,
      isHiddenIfSideBar: (this.isTimelinePageActionBar || this.isFromMediaOperationBase) ? false : isHiddenIfSideBar,
      immersiveController: this.immersiveController,
      timeController: this.timeController,
      subLocalityAddress: this.subLocalityAddress,
      isShowDateString: this.isShowDateString,
      actionBarHeight: this.getActionBarHeight(),
      useOtherTitleLineHeight: !this.isFromCollage && !this.isFromImmersiveCompared && !this.isFromHiddenSecondary &&
        !this.isUserCreatedAlbum && !this.isFromPortrait,
      isPageEmpty: this.isPageEmpty,
      titleWidth: this.titleWidth,
      isEllipsis: this.isEllipsis,
    })
  }

  @Builder
  SelectionModeBuilder() {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Row() {
        if (!this.actionBarProp.getLeftAction().equals(Action.NONE) || !DeviceInfo.isPc()) {
          this.LeftMenus();
        }
        SelectionTitle({
          actionBarProp: $actionBarProp,
          immersiveController: this.immersiveController,
          isEllipsis: this.isEllipsis,
          titleWidth: this.titleWidth,
        })
      }
      .key('SelectionModeBuilder_row')
      .zIndex(DEFAULT_ACTION_BAR_Z_INDEX)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        Log.info(TAG, 'SelectionModeBuilder, onAreaChange');
        if (!DeviceInfo.isPc()) {
          return;
        }
        this.leftMenuWidth = (newValue.width as number) + px2vp(FLEX_PROTECTED_PADDING);
        this.menuPanelWidth = this.flexWidth - this.leftMenuWidth;
      })

      /* instrument ignore next */
    } else {
      Stack({ alignContent: Alignment.Start }) {
        SelectionTitle({
          actionBarProp: $actionBarProp,
          immersiveController: this.immersiveController,
          titleWidth: this.titleWidth,
        })
      }
      .flexGrow(DEFAULT_FLEX_GROW)
    }
    this.MenuPanelBuilder(true);
  }

  @Builder
  /* instrument ignore next */
  SelectionModeNoTitleBuilder() {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Row() {
        if (!this.actionBarProp.getLeftAction().equals(Action.NONE) || !DeviceInfo.isPc()) {
          this.LeftMenus();
        }
        SelectionTitle({
          actionBarProp: $actionBarProp,
          immersiveController: this.immersiveController,
          titleWidth: this.titleWidth,
        })
      }
      .zIndex(DEFAULT_ACTION_BAR_Z_INDEX)
    } else {
      Stack({ alignContent: Alignment.Start }) {
        SelectionTitle({
          actionBarProp: $actionBarProp,
          immersiveController: this.immersiveController,
          titleWidth: this.titleWidth,
        })
      }
      .flexGrow(DEFAULT_FLEX_GROW)
    }

    Blank()
      .flexGrow(DEFAULT_FLEX_GROW)

    this.MenuPanelBuilder(true);
  }

  @Builder
  TopModeBuilder() {
    if (!this.actionBarProp.getLeftAction().equals(Action.NONE) && DeviceInfo.isPc()) {
      Row() {
        this.LeftMenus();
      }
      .onAreaChange((oldValue: Area, newValue: Area) => {
        Log.info(TAG, 'TopModeBuilder, onAreaChange');
        if (!DeviceInfo.isPc()) {
          return;
        }
        this.leftButtonWidth = newValue.width as number;
      })
    }
    if (this.actionBarProp.getIsShowPhotoDate() && !this.notShowDate) {
      Stack({ alignContent: Alignment.Start }) {
        DetailTitle()
          .onAreaChange((oldValue: Area, newValue: Area) => {
            Log.info(TAG, 'DetailTitle, onAreaChange');
            if (!DeviceInfo.isPc()) {
              return;
            }
            this.titleWidth = newValue.width as number;
          })
      }
      .flexGrow(DEFAULT_FLEX_GROW)
      .opacity(this.detailTitleOpacity)

      DetailMenuPanel({
        menuList: this.actionBarProp.getMenuList(),
        flexibleMenuList: this.actionBarProp.getFlexibleMenuList(),
        actionBarProp: this.actionBarProp,
        onMenuClicked: this.onMenuClicked,
        moreMenuList: this.moreMenuList,
        moreMenuListPC: this.moreMenuListPC,
        triggerValue: this.getTriggerValue(),
        showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
        movingPhotoEffectMode: this.movingPhotoEffectMode,
        isFromPhotoBrowser: this.isFromPhotoBrowser,
      })
        .flexShrink(0)
        .opacity(this.detailMenuPanelOpacity)
    }
  }

  @Builder
  /* instrument ignore next */
  TopTitleModeBuilder() {
    if (!this.actionBarProp.getLeftAction().equals(Action.NONE) && DeviceInfo.isPc()) {
      this.LeftMenus();
    }

    Row() {
      this.SingleTitleBuilder(false);
    }
    .flexGrow(1)

    this.MenuPanelBuilder(false);
  }

  @Builder
  StandardModeBuilder() {
    if (!this.actionBarProp.getLeftAction().equals(Action.NONE) && DeviceInfo.isPc()) {
      Row() {
        this.LeftMenus();
      }
      .zIndex(DEFAULT_ACTION_BAR_Z_INDEX + 1)
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions): void => {
        if (newValue?.width) {
          this.leftButtonWidth = Number(newValue?.width);
          Log.info(TAG, `onSizeChange, leftButtonWidth: ${this.leftButtonWidth}`);
        }
      })
    }

    this.SingleTitleBuilder(!this.isSecondaryPage);

    this.MenuPanelBuilder(false);
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: this.isShowAddress && !this.isSelected && (this.isTimelinePageActionBar && !DeviceInfo.isPc()) ?
      ItemAlign.Start : ItemAlign.Center,
      justifyContent: FlexAlign.SpaceBetween,
    }) {
      if (this.isNeedPlaceholder && !DeviceInfo.isPc() &&
        !(this.actionBarProp.getMode() === ActionBarMode.SELECTION_MODE)) {
        Column() {
        }
        .padding({ left: PADDING_LEFT, top: PADDING_TOP })
        .width(DeviceInfo.isPc() ? SELECTION_MODE_SIZE_PC : SELECTION_MODE_SIZE)
        .height(DeviceInfo.isPc() ? SELECTION_MODE_SIZE_PC : SELECTION_MODE_SIZE)
      }

      if (this.needToAddLeftMenus()) {
        this.LeftMenus();
      }

      if (this.actionBarProp.getMode() === ActionBarMode.DETAIL_MODE) {
        DetailMenuPanel({
          actionBarProp: this.actionBarProp,
          onMenuClicked: this.onMenuClicked,
          moreMenuList: this.moreMenuList,
          moreMenuListPC: this.moreMenuListPC,
          isFromPhotoBrowser: this.isFromPhotoBrowser,
        })
      } else if (this.actionBarProp.getMode() === ActionBarMode.SELECTION_MODE) {
        this.SelectionModeBuilder();
      } else if (this.actionBarProp.getMode() === ActionBarMode.SELECTION_NO_TITLE_MODE) {
        this.SelectionModeNoTitleBuilder();
      } else if (this.actionBarProp.getMode() === ActionBarMode.TOP_MODE) {
        this.TopModeBuilder();
      } else if (this.actionBarProp.getMode() === ActionBarMode.TOP_TITLE_MODE) {
        this.TopTitleModeBuilder();
      } else {
        this.StandardModeBuilder();
      }
    }
    .key(TAG)
    .opacity((this.isWindowFocused || !DeviceInfo.isPc()) ? 1 : $r('sys.float.ohos_id_alpha_disabled'))
    .constraintSize({
      minHeight: Constants.ActionBarHeight,
    })
    .zIndex(DEFAULT_ACTION_BAR_Z_INDEX)
    .backgroundColor(Color.Transparent)
    .margin({
      left: DeviceInfo.isTv() ? 0 : this.getMarginLeft(),
      right: DeviceInfo.isTv() ? 0 : this.getMarginRight(),
      top: DeviceInfo.isTv() ? $r('app.float.tv_Grid_top_padding') : 0,
    })
    .height(this.getActionBarHeight())
    .clip(this.isAlbumSetPageActionBar)
    .gesture(
      TapGesture({ count: 2 }).onAction((): void => {
        WindowUtil.handleWinTopBarToggle(getContext(this));
      })
    )
    .onAreaChange((oldValue: Area, newValue: Area) => {
      Log.info(TAG, `Flex, oldValue width: ${oldValue.width}, newValue width: ${newValue.width},
        mode: ${this.actionBarProp.getMode()}, detailLeftMenuWidth: ${this.detailLeftMenuWidth}`);
      if (!DeviceInfo.isPc()) {
        return;
      }
      this.flexWidth = Number(newValue.width);
      if (this.actionBarProp.getMode() === ActionBarMode.TOP_MODE) {
        this.getUIContext().getSharedLocalStorage()?.setOrCreate('detailFlexWidth', this.flexWidth);
        this.actionBarProp.setDetailMenuPanelWidth(this.flexWidth - this.detailLeftMenuWidth);
      }
      this.menuPanelWidth = this.flexWidth - this.leftMenuWidth;
      Log.info(TAG, `Flex, flexWidth: ${this.flexWidth}, leftMenuWidth: ${this.leftMenuWidth},
        menuPanelWidth: ${this.menuPanelWidth}`);
    })
  }

  private getMarginLeft(): Length {
    Log.info(TAG, `getMarginLeft, isRTL: ${this.isRTL}, isCameraActionBar: ${this.isCameraActionBar},
      titlePaddingLeft: ${this.titlePaddingLeft}`);
    return this.isRTL ? this.getActionBarMarginR() : this.titlePaddingLeft;
  }

  private getMarginRight(): Length {
    Log.info(TAG, `getMarginRight, isRTL: ${this.isRTL}, isCameraActionBar: ${this.isCameraActionBar},
      titlePaddingLeft: ${this.titlePaddingLeft}`);
    return this.isRTL ? this.titlePaddingLeft - TITLE_PADDING_LEFT_PC : this.getActionBarMarginR();
  }

  private getTriggerValue(): number | undefined {
    if (this.triggerValue === this.triggerValueLastTime) {
      return undefined;
    } else {
      this.triggerValueLastTime = this.triggerValue;
      return this.triggerValue;
    }
  }

  /* instrument ignore next */
  updateTopModeBuilderOpacity(opacity: number): void {
    animateTo({
      duration: PhotoConstants.BURST_MEDIUM_DURATION,
      curve: Curve.Sharp,
      onFinish: (): void => {
      }
    }, (): void => {
      this.detailTitleOpacity = opacity;
    });

    animateTo({
      duration: PhotoConstants.BURST_SHORT_DURATION,
      curve: Curve.Sharp,
      onFinish: (): void => {
      },
    }, (): void => {
      this.detailMenuPanelOpacity = opacity;
    });
  }

  /* instrument ignore next */
  updateBurstTopModeBuilderOpacity(opacity: number): void {
    animateTo({
      duration: PhotoConstants.BURST_MEDIUM_DURATION,
      curve: Curve.Sharp,
      onFinish: (): void => {
      }
    }, (): void => {
      this.burstPhotosTextTitleOpacity = opacity;
    });

    animateTo({
      duration: PhotoConstants.BURST_SHORT_DURATION,
      curve: Curve.Sharp,
      onFinish: (): void => {
      }
    }, (): void => {
      this.burstDetailMenuPanelOpacity = opacity;
    });
  }

  /* instrument ignore next */
  updateTriggerValue(): void {
    this.triggerValue++;
  }
}