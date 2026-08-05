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
import lazy {
  ActionBarColorMode,
  ActionBarMode,
  ActionBarSelectionMode
} from '../../../default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '../../../default/view/browserOperation/ActionBarProp';
import lazy { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy { BroadCast } from '../../../default/utils/BroadCast';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { getScreen, isOrientationHorizontal, WindowMode } from '../../../default/model/common/ScreenManager';
import lazy { Log } from '../../../default/utils/Log';
import lazy { UiUtil } from '../../../default/utils/UiUtil';
import lazy { UserFileManagerAccess } from '../../../default/access/UserFileManagerAccess';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../../../default/model/common/BroadCastManager';
import lazy { ActionBar } from '../../../../../../../browserCommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy { BusinessError } from '@ohos.base';
import lazy { ImmersiveController } from '../../../default/utils/ImmersiveController';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { DuplicateAlbumDataImpl } from '../../../default/model/browser/album/DuplicateAlbumDataImpl';
import lazy { SHARE_ALBUM_LPATH } from '../../../default/access/PhotoAccessHelperAccess';
import lazy { MenuListUtil } from '../../../default/utils/MenuListUtil';
import lazy { display } from '@kit.ArkUI';
import lazy { FoldUtil, FoldData } from '../../../default/utils/FoldUtil';
import lazy { AlbumUtils } from '../../../default/utils/AlbumUtils';
import lazy { GridViewMode } from '../../../default/view/grid/GridView';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { AlbumGridSortHelper } from '../../../default/model/AlbumGridSortHelper';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { CREATION, CREATION_INVALID } from './CreationAction';
import lazy { MOVIE, MOVIE_INVALID } from './MovieAction';
import lazy { VIDEO_SPLICING, VIDEO_SPLICING_INVALID } from './VideoSplicingAction';
import lazy window from '@ohos.window';

/* instrument ignore file */
const TAG: string = 'browser_PhotoGridPageActionBar';

export enum FeatureType {
  FEATURE_PHOTO_CREATE, // 图库创作特性
  FEATURE_PHOTO_AUTO_CLIP //流光易剪
}

@Component
export struct PhotoGridPageActionBar {
  @LocalStorageLink('isSidebarDrawerShown') isSidebarDrawerShown: boolean = true;
  @Link @Watch('updateActionBarProp') private isSelectedMode: boolean;
  @Consume @Watch('updateAllSelectedStatus') isAllSelected: boolean;
  // 记录上次选择状态是否为全选
  private lastAllSelectedStatus: boolean = false;
  @StorageLink('isHorizontal') @Watch('updateActionBarProp') isHorizontal: boolean =
    isOrientationHorizontal();
  @Provide selectedCount: number = 0;
  @Link @Watch('updateTotalSelectedCount') totalSelectedCount: number;
  @State totalSelectedCountForActionBar: number = 0;
  @Consume @Watch('updateActionBarProp') isEmpty: boolean;
  @Link moreMenuList: Action[];
  @State creationMenuList: Action[] = [];
  @Prop private moreMenuListPC: RightClickMenuGroup[] = [];
  public title: string | Resource = '';
  public isFromFa: boolean = false;
  public albumInfo: AlbumInfo | undefined = undefined;
  public isFromLocation = false;
  public locationBroadCast: BroadCast = new BroadCast();
  @State private broadCast: BroadCast = new BroadCast();
  private portraitSetMeCompleteFunc: Function = (albumInfo: AlbumInfo): void => this.portraitSetMeComplete(albumInfo);
  @State private albumInfoForMe: AlbumInfo = new AlbumInfo();
  private onLoadingFinishedFunc: Function = (size: number): void => this.onLoadingFinished(size);
  @Link actionMoreMenuList: Action[];
  onMenuClicked: Function = (): void => {
  };
  public isDistributedAlbum: boolean = false;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @State private isNeedPlaceholder: boolean = true;
  public isNavTitle: boolean = false;
  public isSearchResultPage: boolean = false;
  public isPhotoCityGrid: boolean = false;
  @Prop isFromPortrait: boolean = false;
  public isFromPortraitCoverSet: boolean = false;
  public isFromRealTime: boolean = false;
  private isSearchPageFromCategory: boolean = false;
  @Prop private isShowSideBar: boolean = false;
  @State private isLevelOneHeadTitle: boolean = false;
  @Provide albumsShow: boolean = false;
  public isNavDestinationPageActionBar: boolean = false;
  private locationDiameter: string[] = [];
  @Prop refreshActionBar: boolean = false;
  @Prop @Watch('updateActionBarColor') isShowTransparent: boolean = false;
  @StorageLink('getFoldStatus') @Watch('updateActionBarProp') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('updateActionBarProp') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private updateTitleFunc: (name: string) => void = (name: string): void => this.updateTitle(name);
  @State updateName: ResourceStr = '';
  @Link isScreenRecordingAlbum: boolean;
  @Prop private immersiveController: ImmersiveController;
  @Prop @Watch('updateActionBarProp') private isFromCategory: boolean = false;
  @Prop @Watch('updateActionBarProp') private isFromShootView: boolean = false;
  @StorageLink('windowPcmodeSwitchStatus') windowPcmodeSwitchStatus: boolean = false;
  private updatePlaceholderStatusFunc: Function = (): void => {
    if (this.isFromPortrait || this.isFromGroup) {
      // 人像相册二级页面没有侧边栏，不需要 Placeholder
      this.isNeedPlaceholder = false;
      return;
    }
    if (this.windowStatus === window.WindowStatusType.FLOATING ||
      this.windowStatus === window.WindowStatusType.SPLIT_SCREEN) {
      this.isNeedPlaceholder = false;
      return;
    }
    this.isNeedPlaceholder = ActionBarVar.updatePlaceholderStatus();
  };
  @StorageLink('isFullMode') @Watch('updateActionBarProp') private isFullMode: boolean = getScreen().isFullMode();
  private allSelectStatus: boolean = false;
  @State actionBarBackgroundColor: ResourceColor = $r('sys.color.ohos_id_color_sub_background');
  private isDuplicateAlbum: boolean = false;
  private isUserCreatedAlbum: boolean = false;
  @State private isShowActionBar: boolean = true;
  private hideActionBarFunc: Function = (isShowActionBar?: boolean): void => {
    this.isShowActionBar = false;
  };
  @State curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  private foldDataChangeListener: (foldData: FoldData) => void = this.onFoldDataChange.bind(this);
  @State private isFromGalleryCleanupPage: boolean = false;
  @LocalStorageProp('isActionBarColorNormal') private isActionBarColorNormal: boolean = true;
  @Prop selectMediaType: number;
  @StorageLink('windowStatus') windowStatus: number | undefined = undefined;
  isFromGroup: boolean = false;

  private onFoldDataChange(foldData: FoldData) {
    this.curFoldStatus = foldData.curFoldStatus;
  }

  private updateTitle(name: ResourceStr): void {
    if (!name) {
      return;
    }
    this.updateName = name;
    this.actionBarProp.setTitle(name);
    this.updateActionBarProp();
  }

  aboutToAppear(): void {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().subscribe(this.foldDataChangeListener);
    }
    this.updateActionBarProp();
    Log.info(TAG, `this.isHorizontal ${
    this.isHorizontal} this.isFoldExpanded ${this.isFoldExpanded} this.isNavTitle ${this.isNavTitle}`);
    if (this.isFromLocation) {
      this.locationBroadCast.on(Constants.ON_LOADING_FINISHED, this.onLoadingFinishedFunc);
      this.locationDiameter = AppStorage.get(Constants.KEY_OF_MAP_DIAMETER) as string[];
    }
    this.updatePlaceholderStatusFunc();
    this.appBroadCast.on(BroadCastConstants.UPDATE_TITLE, this.updateTitleFunc);
    this.appBroadCast.on(BroadCastConstants.ON_SIDEBAR_CHANGED, this.updatePlaceholderStatusFunc);
    this.appBroadCast.on(BroadCastConstants.HIDE_GRID_VIEW_ACTION_BAR, this.hideActionBarFunc);
  }

  aboutToDisappear(): void {
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().unSubscribe(this.foldDataChangeListener);
    }
    if (this.isFromLocation) {
      this.locationBroadCast.off(Constants.ON_LOADING_FINISHED, this.onLoadingFinishedFunc);
    }
    this.appBroadCast.off(BroadCastConstants.UPDATE_TITLE, this.updateTitleFunc);
    this.appBroadCast.off(BroadCastConstants.ON_SIDEBAR_CHANGED, this.updatePlaceholderStatusFunc);
    this.appBroadCast.off(BroadCastConstants.HIDE_GRID_VIEW_ACTION_BAR, this.hideActionBarFunc);
  }

  private portraitSetMeComplete(albumInfo: AlbumInfo): void {
    this.albumInfoForMe = albumInfo;
    if (this.isFromPortrait && !this.updateName && !this.albumInfo?.albumName &&
      this.albumInfoForMe?.uri === this.albumInfo?.uri) {
      this.updateTitle($r('app.string.portrait_me'));
    }
  }

  private updateActionBar(): void {
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      this.actionBarProp = this.createActionBar();
    } else if (this.isHorizontal || (DeviceInfo.isFoldable() && this.isFullMode && !DeviceInfo.isPhoneVde())) {
      Log.info(TAG, 'createHorizontalActionBar');
      this.actionBarProp = this.createHorizontalActionBar();
    } else {
      this.actionBarProp = this.createActionBar();
    }
  }

  private updateTotalSelectedCount(): void {
    const oriSelectedCount = this.selectedCount;
    this.selectedCount = this.totalSelectedCount;
    /**
     * 特殊情况才需要整个actionbar重建
     * 0 --> 未选择
     * 1 --> 分享、删除、添加到、收藏、隐藏
     * 2 --> 对比、拼图
     *
     * count>2的情况，仅需更新左上角"已选择n项"中的数量
     */
    const shouldUpdateActionBar =
      (this.albumInfo?.viewMode === GridViewMode.GROUP && oriSelectedCount < 2 || this.selectedCount < 3 ||
      this.allSelectStatus || AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS));
    if (shouldUpdateActionBar) {
      this.updateActionBar();
      this.totalSelectedCountForActionBar = this.selectedCount;
    }
    this.allSelectStatus = false;

    // 针对彩蛋功能（重复照片宫格），初始化过程中会刷新，需要触发调用更新
    if (this.isDuplicateAlbum) {
      this.updateActionBar();
    }
  }

  private updateAllSelectedStatus(): void {
    this.selectedCount = this.totalSelectedCount;
    if (this.isAllSelected !== this.lastAllSelectedStatus) {
      this.allSelectStatus = true;
      this.updateActionBar();
    }
    this.lastAllSelectedStatus = this.isAllSelected;
  }

  updateActionBarProp(): void {
    this.selectedCount = this.totalSelectedCount;
    this.updateActionBar();
    if (DeviceInfo.isGRLFoldScreen() && this.totalSelectedCountForActionBar === 0 && this.selectedCount > 0) {
      this.totalSelectedCountForActionBar = this.selectedCount;
    }
    if (this.isShowTransparent) {
      this.actionBarProp.setColorMode(ActionBarColorMode.TRANSPARENT);
      getScreen().setImmersiveStatusBarProperties(Constants.COLOR_TRANSPARENT);
    } else if (this.isFromPortrait || this.isFromGroup) {
      this.actionBarProp.setColorMode(ActionBarColorMode.NORMAL);
      getScreen().setDefaultStatusBarProperties(true);
    }
  }

  updateActionBarColor(): void {
    if (this.isShowTransparent) {
      this.actionBarProp.setColorMode(ActionBarColorMode.TRANSPARENT);
      getScreen().setImmersiveStatusBarProperties(Constants.COLOR_TRANSPARENT);
    } else {
      this.actionBarProp.setColorMode(ActionBarColorMode.NORMAL);
      getScreen().setDefaultStatusBarProperties();
    }
  }

  private isSecondaryPage(): boolean {
    return this.isFromPortrait || this.isFromCategory ||
    this.isFromShootView || this.isSearchResultPage || this.isFromGroup;
  }

  @Builder
  buildActionBar() {
    ActionBar({
      actionBarProp: $actionBarProp,
      onMenuClicked: this.onMenuClicked,
      isFromPhotoBrowser: this.isFromLocation || this.isPhotoCityGrid,
      isNeedPlaceholder: this.isNeedPlaceholder,
      totalSelectedCount: this.totalSelectedCountForActionBar,
      actionMoreMenuList: this.actionMoreMenuList,
      isNavDestinationPageActionBar: this.isNavDestinationPageActionBar,
      isShowTransparent: this.isShowTransparent,
      isShowSideBar: this.isShowSideBar,
      isSelected: this.isFromGalleryCleanupPage ? this.isSelectedMode && this.selectedCount > 0 : this.isSelectedMode,
      immersiveController: this.immersiveController,
      isFromPortrait: this.isFromPortrait,
      isFromPortraitCoverSet: this.isFromPortraitCoverSet,
      moreMenuList: this.moreMenuList,
      creationMenuList: this.creationMenuList,
      moreMenuListPC: this.moreMenuListPC,
      isFromRealTime: this.isFromRealTime,
      isSearchResultPage: this.isSearchResultPage,
      isSecondaryPage: this.isSecondaryPage(),
      isUserCreatedAlbum: this.isUserCreatedAlbum,
      isSearchPageFromCategory: this.isSearchPageFromCategory,
      selectMediaType: this.selectMediaType,
    })
      .padding(
        {
          start: LengthMetrics.vp((DeviceInfo.isPc() && this.isSidebarDrawerShown) ?
          Constants.DRAWER_BUTTON_WIDTH_PC : 0),
          bottom: (DeviceInfo.isPc() || (this.isSearchResultPage && this.isHorizontal)) ? LengthMetrics.vp(0) :
          LengthMetrics.resource($r('app.float.bar_grid_bottom_padding')),
        })
      .onAreaChange((oldValue: Area, newValue: Area): void => {
        Log.debug(TAG, `PhotoGridPageActionBar: ${newValue.height}`);
        ActionBarVar.pcActionBarHeight = newValue.height as number;
      })
      .backgroundColor((DeviceInfo.isPc() && !this.isFromPortrait && !this.isFromGroup) ?
      this.actionBarBackgroundColor : Color.Transparent)
  }

  build() {
    Column() {
      if (this.refreshActionBar) {
        this.buildActionBar();
      } else {
        this.buildActionBar();
      }
    }
    .key('PhotoGridPageActionBar')
    .opacity(!this.isShowActionBar && DeviceInfo.isPc() ? 0.5 : 1)
    .padding({
      left: this.isNavTitle ? $r('app.float.nav_title_padding') : 0
    })
  }

  private onLoadingFinished(size: number): void {
    Log.info(TAG, `ON_LOADING_FINISHED size location: ${size}`);
    if (this.isFromLocation) {
      try {
        this.title = getContext(this).resourceManager.getPluralStringValueSync($r('app.plural.show_photo_num'), size);
      } catch (error) {
        let err = (error as BusinessError);
        Log.error(TAG, `getStringSync failed, error code: ${err.code}, message: ${err.message}.`);
      }
      this.updateActionBarProp();
      AppStorage.setOrCreate(Constants.KEY_OF_MARKER_REFRESH, this.locationDiameter[4] !== size.toString());
    }
  }

  private createSelectedHorizontalActionBar(menuList: Action[], actionBarProp: ActionBarProp): void {
    if (this.albumInfo?.isTrashAlbum) {
      menuList.push(
        this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
        Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    } else if (this.isDistributedAlbum) {
      menuList.push(
        (this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL));
    } else {
      this.createSelectedHorizontalActionBarOther(menuList);
    }
    actionBarProp
      .setLeftAction(Action.CANCEL)
      .setMode((DeviceInfo.isPc() && this.isSecondaryPage()) ?
      ActionBarMode.SELECTION_NO_TITLE_MODE : ActionBarMode.SELECTION_MODE)
      .setSelectionMode(ActionBarSelectionMode.MULTI);
  }

  private isNewAlbum(): boolean {
    return !this.albumInfo?.isSystemAlbum && !this.isDistributedAlbum && !this.isSearchResultPage &&
      !this.albumInfo?.isShootingAlbum && !this.albumInfo?.isSourceAlbum &&
      !this.isPhotoCityGrid;
  }

  private getFeatureType(type: FeatureType): boolean {
    return false;
  }

  private getVideoMenuList(menuList: Action[]): void {
    if (DeviceInfo.isSupportMovie()) {
      menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL)
      if (this.getFeatureType(FeatureType.FEATURE_PHOTO_CREATE)) {
        menuList.push(this.selectedCount === 0 ? VIDEO_SPLICING_INVALID : VIDEO_SPLICING);
      }
      if (this.getFeatureType(FeatureType.FEATURE_PHOTO_AUTO_CLIP)) {
        menuList.push(this.selectedCount === 0 ? MOVIE_INVALID : MOVIE);
      }
      menuList.push(
          Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID,
          Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    } else {
      menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
          Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID,
          Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    }
  }

  private createSelectedHorizontalActionBarOther(menuList: Action[]): void {
    if (!DeviceInfo.isTv() && (this.albumInfo?.uri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE))) {
      this.getVideoMenuList(menuList);
    } else if (this.isScreenRecordingAlbum) {
      this.getVideoMenuList(menuList);
    } else if (this.isDuplicateAlbum) {
      menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
        Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    } else {
      /* instrument ignore next */
      if (DeviceInfo.isVerdeFoldable()) {
        menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
          Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID,
          Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID)
      } else {
        if (DeviceInfo.isSupportMovie()) {
          menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
            Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID,
            (this.selectedCount === 0 ? CREATION_INVALID : CREATION),
            Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
        } else {
          menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
              Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID,
              Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
        }
      }
    }
  }

  private moreMenuJudgments(): boolean {
    if (this.albumInfo?.isTrashAlbum && DeviceInfo.isPc()) {
      return true;
    }
    let subType: number = this.albumInfo?.subType ?? 0;
    if ((!DeviceInfo.isPhoneUx() && !DeviceInfo.isTablet() && !DeviceInfo.isGRLFoldScreen()) ||
      !AlbumUtils.isAlbumGroupModeSupported()) {
      let isAlbumHasMoreMenu: boolean;
      switch (subType) {
        case Number(photoAccessHelper.AlbumSubtype.IMAGE):
        case Number(photoAccessHelper.AlbumSubtype.VIDEO):
        case Number(photoAccessHelper.AlbumSubtype.FAVORITE):
        case Number(photoAccessHelper.AlbumSubtype.PORTRAIT):
        case Number(photoAccessHelper.AlbumSubtype.GEOGRAPHY_CITY):
        case Number(photoAccessHelper.AlbumSubtype.CLASSIFY):
        case Number(photoAccessHelper.AlbumSubtype.SOURCE_GENERIC):
        case Number(photoAccessHelper.AlbumSubtype.TRASH):
        case Number(photoAccessHelper.AlbumSubtype.HIDDEN):
          isAlbumHasMoreMenu = false;
          break;
        default:
          isAlbumHasMoreMenu = true;
      }
      return !this.isSearchResultPage && !this.isPhotoCityGrid &&
        !this.isFromPortrait && isAlbumHasMoreMenu && !this.isFromGroup;
    }

    let isAlbumHasMoreMenu: boolean;
    switch (subType) {
      case Number(photoAccessHelper.AlbumSubtype.PORTRAIT):
      case Number(photoAccessHelper.AlbumSubtype.GEOGRAPHY_CITY):
      case Number(photoAccessHelper.AlbumSubtype.CLASSIFY):
      case Number(photoAccessHelper.AlbumSubtype.TRASH):
      case Number(photoAccessHelper.AlbumSubtype.HIDDEN):
        isAlbumHasMoreMenu = false;
        break;
      default:
        isAlbumHasMoreMenu = true;
    }
    return !this.isSearchResultPage && !this.isPhotoCityGrid && !this.isFromPortrait && isAlbumHasMoreMenu;
  }

  private searchMenuJudgements(): boolean {
    let subType: number = this.albumInfo?.subType ?? 0;
    let isAlbumHasSearch: boolean = false;
    // 分屏或者小窗状态直接返回false, 避免其他引用此组件的场景出现不必要的搜索按钮
    if(this.windowStatus === window.WindowStatusType.FLOATING ||
      this.windowStatus === window.WindowStatusType.SPLIT_SCREEN) {
      return false;
    }

    if(DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) {
      switch (subType) {
        case Number(photoAccessHelper.AlbumSubtype.PORTRAIT):
        case Number(photoAccessHelper.AlbumSubtype.GEOGRAPHY_CITY):
        case Number(photoAccessHelper.AlbumSubtype.CLASSIFY):
        case Number(photoAccessHelper.AlbumSubtype.TRASH):
        case Number(photoAccessHelper.AlbumSubtype.HIDDEN):
        case Number(photoAccessHelper.AlbumSubtype.SHOOTING_MODE):
          isAlbumHasSearch = false;
          break;
        default:
          isAlbumHasSearch = true;
      }
    }

    return !this.isSearchResultPage && !this.isFromPortrait && isAlbumHasSearch;
  }

  private horizontalSelectMenuList(menuList: Action[], actionBarProp: ActionBarProp): void {
    if (this.isSelectedMode && !DeviceInfo.isPc()) {
      this.createSelectedHorizontalActionBar(menuList, actionBarProp);
    } else {
      if (!this.isEmpty && !DeviceInfo.isPc()) {
        menuList.push(Action.MULTISELECT);
      }

      if (!this.isEmpty && this.searchMenuJudgements()) {
        menuList.push(Action.PHOTO_SEARCH);
      }

      if (!this.albumInfo?.isSystemAlbum && !this.isDistributedAlbum && !this.isSearchResultPage &&
        !this.albumInfo?.isShootingAlbum && !this.albumInfo?.isSourceAlbum &&
        !this.isPhotoCityGrid) {
        menuList.push(Action.NEW);
      }
      if (!this.isEmpty && DeviceInfo.isPc()) {
        menuList.push(Action.MULTISELECT);
        if (this.albumInfo?.isTrashAlbum && DeviceInfo.isPc()) {
          menuList.push(Action.CLEAR_RECYCLE);
        }
      }
      if (!this.isEmpty && DeviceInfo.isTv() && this.albumInfo?.isTrashAlbum) {
        menuList.push(Action.CLEAR_RECYCLE);
      }
      if (this.actionMoreMenuList.length && this.moreMenuJudgments()) {
        menuList.push(Action.ACTION_MORE);
      }
    }
  }

  private createHorizontalActionBar(): ActionBarProp {
    if (this.isFromPortrait || this.isFromPortraitCoverSet) {
      return this.portraitActionBarHandler();
    }
    if (this.isFromGalleryCleanupPage) {
      return this.galleryCleanupActionBarHandler();
    }
    if (this.isFromGroup) {
      return this.groupActionBarHandler();
    }
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    MenuListUtil.verifyMenuList(menuList, actionBarProp);
    actionBarProp
      .setLeftAction(this.getLeftAction())
      .setTitle(this.updateName && !this.isSelectedMode ? `${this.updateName}` : this.getTitle(this.albumInfo))
      .setTitleFontSize(DeviceInfo.isPc() ? ActionBarProp.TITLE_TEXT_SIZE : this.isFromCategory ?
        $r('sys.float.Title_S'):
        ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE)
      .setIsLevelOneHeadTitle(this.isLevelOneHeadTitle)
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setIsNavTitle(this.isNavTitle)
      .setAlbumInfo(this.albumInfo);
    if (this.isFromFa || this.albumInfo == null) {
      actionBarProp.setMenuList(menuList);
      return actionBarProp;
    }
    this.horizontalSelectMenuList(menuList, actionBarProp);
    actionBarProp.setMenuList(menuList);
    return actionBarProp;
  }

  private portraitActionBarHandler(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(this.getLeftAction())
      .setTitle(this.getTitle(this.albumInfo))
      .setMode(ActionBarMode.STANDARD_MODE)
      .setIsNavTitle(false);
    if (this.isFromPortrait && !this.isEmpty) {
      menuList.push(Action.MULTISELECT);
      menuList.push(Action.ACTION_MORE);
      MenuListUtil.verifyMenuList(menuList, actionBarProp);
      actionBarProp.setMenuList(menuList);
    }
    if (this.isSelectedMode && !DeviceInfo.isPc()) {
      if (!DeviceInfo.isPc()) {
        menuList = [];
        menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
        if (this.isHorizontal || (DeviceInfo.isFoldable() && this.isFullMode)) {
          menuList = this.portraitMenuList();
        }
      } else {
        menuList = this.portraitMenuList();
      }
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setSelectionMode(ActionBarSelectionMode.MULTI)
        .setMode((DeviceInfo.isPc() && this.isSecondaryPage()) ?
        ActionBarMode.SELECTION_NO_TITLE_MODE : ActionBarMode.SELECTION_MODE)
        .setMenuList(menuList)
        .setColorMode((this.isFromPortrait && DeviceInfo.isPc()) ? ActionBarColorMode.TRANSPARENT :
        ActionBarColorMode.NORMAL);
    } else if (DeviceInfo.isPc() && !this.isEmpty) {
      menuList = this.portraitMenuListForPc();
      MenuListUtil.verifyMenuList(menuList, actionBarProp);
      actionBarProp
        .setLeftAction(Action.BACK)
        .setMenuList(menuList)
        .setColorMode((this.isFromPortrait && DeviceInfo.isPc() && !this.isActionBarColorNormal) ?
        ActionBarColorMode.TRANSPARENT : ActionBarColorMode.NORMAL);
      if (this.totalSelectedCount > 0 || this.isSelectedMode) {
        actionBarProp
          .setSelectionMode(ActionBarSelectionMode.MULTI)
          .setMode((DeviceInfo.isPc() && this.isSecondaryPage()) ?
          ActionBarMode.SELECTION_NO_TITLE_MODE : ActionBarMode.SELECTION_MODE)
      }
      if (this.isSelectedMode) {
        actionBarProp
          .setLeftAction(Action.CANCEL)
      }
    }
    return actionBarProp;
  }

  private groupActionBarHandler(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(this.getLeftAction())
      .setTitle(this.getTitle(this.albumInfo))
      .setMode(ActionBarMode.STANDARD_MODE)
      .setIsNavTitle(false);
    if (this.isFromGroup && !this.isEmpty) {
      menuList.push(Action.MULTISELECT);
      menuList.push(Action.ACTION_MORE);
      MenuListUtil.verifyMenuList(menuList, actionBarProp);
      actionBarProp.setMenuList(menuList);
    }
    if (this.isSelectedMode && !DeviceInfo.isPc()) {
      if (!DeviceInfo.isPc()) {
        menuList = [];
        menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
        if (this.isHorizontal || (DeviceInfo.isFoldable() && this.isFullMode)) {
          menuList = this.portraitMenuList();
        }
      } else {
        menuList = this.portraitMenuList();
      }
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setSelectionMode(ActionBarSelectionMode.MULTI)
        .setMode((DeviceInfo.isPc() && this.isSecondaryPage()) ?
        ActionBarMode.SELECTION_NO_TITLE_MODE : ActionBarMode.SELECTION_MODE)
        .setMenuList(menuList)
        .setColorMode((this.isFromGroup && DeviceInfo.isPc()) ? ActionBarColorMode.TRANSPARENT :
        ActionBarColorMode.NORMAL);
    } else if (DeviceInfo.isPc() && !this.isEmpty) {
      menuList = this.portraitMenuListForPc();
      MenuListUtil.verifyMenuList(menuList, actionBarProp);
      actionBarProp
        .setLeftAction(Action.BACK)
        .setMenuList(menuList)
        .setColorMode((this.isFromGroup && DeviceInfo.isPc()) ? ActionBarColorMode.TRANSPARENT :
        ActionBarColorMode.NORMAL);
      if (this.totalSelectedCount > 0 || this.isSelectedMode) {
        actionBarProp
          .setSelectionMode(ActionBarSelectionMode.MULTI)
          .setMode((DeviceInfo.isPc() && this.isSecondaryPage()) ?
          ActionBarMode.SELECTION_NO_TITLE_MODE : ActionBarMode.SELECTION_MODE)
      }
      if (this.isSelectedMode) {
        actionBarProp
          .setLeftAction(Action.CANCEL)
      }
    }
    return actionBarProp;
  }

  private galleryCleanupActionBarHandler(): ActionBarProp {
    let menuList: Action[] = [];
    if (!this.isEmpty) {
      menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
    }
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle(this.albumInfo ? this.albumInfo.albumName : '')
      .setTitleFontSize(ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE)
      .setIsLevelOneHeadTitle(this.isLevelOneHeadTitle)
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setIsNeedTitle(true);
    Log.info(TAG, `galleryCleanupActionBarHandler, isSelectedMode: ${this.isSelectedMode}`);

    // 图片清理页面默认显示返回按钮
    if (this.isSelectedMode && this.selectedCount > 0) {
      actionBarProp.setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    }
    return actionBarProp;
  }

  private getLeftAction(): Action {
    if (this.albumInfo && this.albumInfo.lpath === SHARE_ALBUM_LPATH
      && AppStorage.get('viewDataToHwShareGird') === Constants.IS_VIEW_SHARE_GRID) {
      Log.info(TAG, `viewShareGrid: ${AppStorage.get('viewDataToHwShareGird')}`);
      return Action.BACK;
    }
    if (DeviceInfo.isPc() || (((DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus)) ||
    DeviceInfo.isTv()) && (getScreen().getWinMode() !== WindowMode.FLOATING || this.windowPcmodeSwitchStatus))) {
      return ((
        this.isSearchResultPage ||
        this.isFromPortrait ||
        this.isFromPortraitCoverSet ||
        this.isFromCategory ||
        this.isFromShootView ||
        this.isFromGroup  ||
        this.isFromLocation ||
        this.isPhotoCityGrid) ?
      Action.BACK : Action.NONE);
    }
    return this.isNavTitle ? Action.NONE : Action.BACK;
  }

  private portraitMenuList(): Action[] {
    let menuList: Action[] = [];
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
        Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID,
        Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    } else {
      menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
        Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID,
        (this.selectedCount === 0 ? CREATION_INVALID : CREATION),
        Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    }

    return menuList;
  }

  private portraitMenuListForPc(): Action[] {
    let menuList: Action[] = [];
    if (this.isSelectedMode) {
      menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
    }
    menuList.push(
      Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID,
      Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
    return menuList;
  }

  private selectMenuList(menuList: Action[], actionBarProp: ActionBarProp) {
    if (this.isSelectedMode) {
      menuList = [];
      if (!DeviceInfo.isPc()) {
        if (!this.albumInfo) {
          Log.info(TAG, 'albumInfo is null');
        }
        menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
      }
      if (!this.albumInfo?.isTrashAlbum) {
        menuList.push(Boolean(this.selectedCount) ? Action.MOVE : Action.MOVE_INVALID);
      }
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMenuList(menuList)
        .setMode((DeviceInfo.isPc() && this.isSecondaryPage()) ?
        ActionBarMode.SELECTION_NO_TITLE_MODE : ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    }
  }

  private isAlbumNeedMoreAction(): boolean {
    // 系统相册、回收站 通过这个条件控制不显示更多菜单
    if (AlbumUtils.isAlbumGroupModeSupported()) {
      return !this.isFromPortrait && !this.isFromLocation && !this.isPhotoCityGrid &&
        !this.albumInfo?.isTrashAlbum && !this.isFromGroup;
    }
    if (this.albumInfo?.isSourceAlbum || this.albumInfo?.isSystemAlbum) {
      return AlbumGridSortHelper.getInstance().isOpenGridSort;
    } else {
      return !this.albumInfo?.isTrashAlbum && !this.isPhotoCityGrid &&
        !this.isFromPortrait && !this.albumInfo?.isShootingAlbum && !this.isFromGroup;
    }
  }

  private createActionBar(): ActionBarProp {
    if (this.isFromPortrait || this.isFromPortraitCoverSet) {
      return this.portraitActionBarHandler();
    }
    if (this.isFromGalleryCleanupPage) {
      return this.galleryCleanupActionBarHandler();
    }
    if (this.isFromGroup) {
      return this.groupActionBarHandler();
    }
    let actionBarProp: ActionBarProp = new ActionBarProp();
    let menuList: Action[] = this.createMenuList();

    actionBarProp
      .setLeftAction(this.getLeftAction())
      .setTitle(this.updateName && !this.isSelectedMode ? `${this.updateName}` : this.getTitle(this.albumInfo))
      .setTitleFontSize(DeviceInfo.isPc() ? ActionBarProp.TITLE_TEXT_SIZE :
      ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE)
      .setIsLevelOneHeadTitle(this.isLevelOneHeadTitle)
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setIsNavTitle(this.isNavTitle)
      .setAlbumInfo(this.albumInfo);
    Log.info(TAG, `createActionBar, isSelectedMode: ${this.isSelectedMode}`);

    this.selectMenuList(menuList, actionBarProp);
    return actionBarProp;
  }

  private createMenuList(): Action[] {
    let menuList: Action[] = [];
    if (!this.isEmpty && !DeviceInfo.isPc()) {
      menuList.push(Action.MULTISELECT);
    }

    if (!this.isEmpty && this.searchMenuJudgements()) {
      menuList.push(Action.PHOTO_SEARCH);
    }

    if (!(this.albumInfo?.isSystemAlbum) && !this.isDistributedAlbum && !this.isFromFa && !this.isSearchResultPage &&
      !this.albumInfo?.isShootingAlbum && !this.albumInfo?.isSourceAlbum &&
      !this.isPhotoCityGrid) {
      menuList.push(Action.NEW);
    }

    if (!this.isEmpty && DeviceInfo.isPc()) {
      menuList.push(Action.MULTISELECT);
    }
    if (this.actionMoreMenuList.length && !this.isSearchResultPage && !DeviceInfo.isPc() &&
    this.isAlbumNeedMoreAction()) {
      menuList.push(Action.ACTION_MORE);
    }
    return menuList;
  }

  private getTitle(albumInfo: AlbumInfo | undefined): Resource | string {
    if (this.isFromLocation) {
      return this.title;
    }
    if (this.isFromPortraitCoverSet) {
      return $r('app.string.Tab_change_cover');
    }
    if (this.isFromPortrait) {
      if (this.updateName) {
        return this.updateName;
      }
      if (albumInfo?.albumName) {
        return albumInfo.albumName;
      }
      return this.albumInfoForMe?.uri === this.albumInfo?.uri ? $r('app.string.portrait_me') : '';
    }
    if (this.isFromGroup) {
      return '';
    }
    if (albumInfo?.isDuplicateAlbum) {
      return $r('app.string.duplicate_photo');
    }
    if (albumInfo) {
      let res = UiUtil.getDisplayNameResourceByAlbumInfo(albumInfo);
      if (res != null) {
        return res;
      }
    }
    if (this.isFromFa) {
      return $r('app.string.album_photos');
    }
    return this.title;
  }
}