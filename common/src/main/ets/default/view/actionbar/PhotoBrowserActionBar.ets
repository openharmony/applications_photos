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

import lazy { Action } from '../../../default/view/browserOperation/Action';
import lazy { RightClickMenuGroup } from '../menu/MenuController';
import lazy { ActionBarColorMode, ActionBarMode } from '../../../default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '../../../default/view/browserOperation/ActionBarProp';
import lazy { Constants as BrowserConstants } from '../../../default/model/browser/photo/Constants';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
} from '../../../default/model/common/ScreenManager';
import lazy { Log } from '../../../default/utils/Log';
import lazy Curves from '@ohos.curves';
import lazy { ActionBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy { display, LengthMetrics } from '@kit.ArkUI';
import lazy { MenuListUtil } from '../../../default/utils/MenuListUtil';
import lazy { FoldUtil, FoldData } from '../../../default/utils/FoldUtil';

const TAG: string = 'browser_PhotoBrowserActionBar';

@Component
export struct PhotoBrowserActionBar {
  @Consume @Watch('onShowChanged') isShowBar: boolean;
  @State @Watch('opacityValueChanged') opacityValue: number = 1;
  @State isVisibility: boolean = !DeviceInfo.isVerdeFoldable();
  @State currentBackgroundColor: Resource = ActionBarProp.PHOTO_BROWSER_ACTIONBAR_BACKGROUND_COLOR;
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  onMenuClicked: Function = (): void => {
  };
  public isVideoPage: boolean = false;
  @StorageLink('isHorizontal') isHorizontal: boolean =
    isOrientationHorizontal();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @Consume @Watch('updateActionBarProp') menuList: Action[];
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @Provide albumsShow: boolean = false;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @Prop private moreMenuList: Action[] = [];
  @Prop private moreMenuListPC: RightClickMenuGroup[] = [];
  @Prop private showMovingPhotoCloseEffect: boolean = false;
  @Prop private movingPhotoEffectMode?: number = 0;
  @Prop isShowSearchBrowser: boolean = false;
  // 连拍浏览的操作栏list
  @Prop private burstMenuList: Action[] = [];
  // 是否连拍图片展示页面
  @Prop private isBurstPhotos: boolean = false;
  // 连拍图片数目
  @Prop private totalBurstPhotosNO: number = 1;
  // 连拍图片选择数目
  @Prop private selectedBurstPhotosNO: number;
  @Prop @Watch('isShowSearchBrowserChange') private isShowSideBar: boolean = false;
  private detailFlexWidth: number = 0;
  @LocalStorageLink('detailLeftMenuWidth') private detailLeftMenuWidth: number = 0;
  public isCameraActionBar: boolean = false;
  @LocalStorageLink('isSidebarDrawerShown') isSidebarDrawerShown: boolean = true;
  @State curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  private foldDataChangeListener: (foldData: FoldData) => void = this.onFoldDataChange.bind(this);

  private onFoldDataChange(foldData: FoldData) {
    this.curFoldStatus = foldData.curFoldStatus;
  }

  opacityValueChanged(): void {
    Log.info(TAG, `opacityValueChanged ${this.opacityValue}`);
  }

  updateActionBarProp(): void {
    Log.info(TAG, 'updateActionBarProp');
    this.updateByMenuList(this.actionBarProp);
  }

  isShowSearchBrowserChange(): void {
    this.isShowSearchBrowser = !this.isShowSideBar;
  }

  aboutToAppear(): void {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().subscribe(this.foldDataChangeListener);
    }
    this.actionBarProp = this.createActionBar();
  }

  aboutToDisappear(): void {
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().unSubscribe(this.foldDataChangeListener);
    }
  }

  onShowChanged(): void {
    if (this.isShowBar) {
      this.isVisibility = this.isShowBar;
    }

    animateTo({
      duration: BrowserConstants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? BrowserConstants.IMMERSE_ANIM_DELAY : 0,
      curve: this.isShowBar ? Curves.cubicBezier(0.6, 0.0, 0.6, 1.0) : Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
      onFinish: () => {
        if (!this.isShowBar) {
          this.isVisibility = this.isShowBar;
        }
      }
    }, () => {
      if (this.isShowBar || this.isBurstPhotos) {
        this.opacityValue = 1;
      } else {
        this.opacityValue = 0;
      }
    })
  }

  build() {
    if (this.isVisibility || this.isBurstPhotos) {
      Stack() {
        ActionBar({
          actionBarProp: $actionBarProp,
          onMenuClicked: this.onMenuClicked,
          isNeedPlaceholder: false,
          isFromPhotoBrowser: true,
          moreMenuList: this.moreMenuList,
          moreMenuListPC: this.moreMenuListPC,
          isBurstPhotos: this.isBurstPhotos,
          burstMenuList: this.burstMenuList,
          totalBurstPhotosNO: this.totalBurstPhotosNO,
          selectedBurstPhotosNO: this.selectedBurstPhotosNO,
          isShowSideBar: this.isShowSideBar,
          isShowSearchBrowser: this.isShowSearchBrowser,
          isCameraActionBar: this.isCameraActionBar,
          showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
          movingPhotoEffectMode: this.movingPhotoEffectMode,
        })
      }
      .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .padding(DeviceInfo.isPc() ? {
        top: LengthMetrics.vp(this.getPaddingTop()),
        start: LengthMetrics.vp(this.getPaddingLeft()),
        end: LengthMetrics.vp(this.diggingHoleCameraArea.right),
      } :
        {
          top: this.getPaddingTop(),
          left: this.getPaddingLeft(),
          right: this.getPaddingRight(),
        }
      )
      .opacity(this.opacityValue)
      .backgroundColor(DeviceInfo.isPc() || DeviceInfo.isTv() ? Color.Transparent : this.currentBackgroundColor)
      .backgroundBlurStyle(DeviceInfo.isPc() ? BlurStyle.COMPONENT_THICK : BlurStyle.NONE)
      .key(TAG)
      .border(DeviceInfo.isPc() ? {
        width: {
          bottom: Constants.MENU_DIVIDER_STROKE_WIDTH,
        },
        color: { bottom: $r('sys.color.comp_divider') },
      } : {})
    }
  }

  private getPaddingTop(): number {
    let tempResult: boolean =
      !DeviceInfo.isFoldable() && !(DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus));
    return ((this.isHorizontal && tempResult) || this.isVerdeFoldable) ?
      0 : px2vp(this.statusBarHeight)
  }

  private getPaddingLeft(): number {
    if (this.isFoldExpanded || (DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus))) {
      return 0;
    } else if (DeviceInfo.isPc() && this.isSidebarDrawerShown) {
      return this.diggingHoleCameraArea.left + Constants.DRAWER_BUTTON_WIDTH_PC;
    } else {
      return this.diggingHoleCameraArea.left;
    }
  }

  private getPaddingRight(): number {
    if (DeviceInfo.isGRLFullExpanded() && !this.isHorizontal) {
      Log.info(TAG, 'GRL full expanded and isHorizontal = false,padding right = 0');
      return 0;
    }
    return this.diggingHoleCameraArea.right;
  }

  private createActionBar(): ActionBarProp {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setHasTabBar(false)
      .setLeftAction(Action.BACK)
      .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
      .setMode(ActionBarMode.TOP_MODE)
      .setColorMode(ActionBarColorMode.NORMAL);
    this.updateByMenuList(actionBarProp);
    return actionBarProp;
  }

  private updateByMenuList(actionBarProp: ActionBarProp): void {
    if (DeviceInfo.isPc()) {
      this.detailFlexWidth = this.getUIContext().getSharedLocalStorage()?.get('detailFlexWidth') ?? 0;
      Log.info(TAG, `detailActionBar flexWidth:${this.detailFlexWidth} leftMenuWidth:${this.detailLeftMenuWidth}`);
      let menuList: Action[] = this.menuList.filter((menu: Action) => {
        return menu.componentKey;
      })
      actionBarProp
        .setMenuList(menuList)
        .setDetailMenuPanelWidth(this.detailFlexWidth - this.detailLeftMenuWidth);
      MenuListUtil.verifyMenuList(menuList, actionBarProp);
    } else {
      actionBarProp
        .setMenuList(this.menuList);
    }
  }

  onFoldDisplayModeChanged() {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }
}