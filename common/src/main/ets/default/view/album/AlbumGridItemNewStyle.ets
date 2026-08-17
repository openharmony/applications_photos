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
import lazy { AlbumCardComponent, getBottomHeight } from '../../../default/view/AlbumCard';
import lazy { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataSourceManager } from '../../../default/model/browser/album/AlbumSetDataSourceManager';
import lazy { AlbumSetSelectManager } from '../../../default/model/browser/SelectManager';
import lazy { BigDataConstants, ReportToBigDataUtil, AlbumBrowsingInfo } from '../../../default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '../../../default/utils/BroadCast';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { Constants as BrowserConstants } from '../../../default/model/browser/photo/Constants';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { EventHelper } from '../../../default/view/ViewEventHelper';
import lazy { FeatureSwitchUtil } from '../../../default/utils/FeatureSwitchUtil';
import lazy { ColumnSize, getScreen, isOrientationHorizontal } from '../../../default/model/common/ScreenManager';
import lazy { Log } from '../../../default/utils/Log';
import lazy { MultimodalInputManager } from '../../../default/model/common/MultimodalInputManager';
import lazy { ParamAlbumInfo } from '../../../default/interface/Album';
import lazy { UiUtil, VibrateType } from '../../../default/utils/UiUtil';
import lazy { EmptyAlbumComponent } from './EmptyAlbumComponent';
import lazy { getDelayConst, getDurationConst, GridLink } from '../../model/browser/photo/const/GridLinkDelay';
import lazy Curves from '@ohos.curves';
import lazy performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy { AlbumGrid } from '../../model/AlbumGrid';
import lazy { display, LengthMetrics } from '@kit.ArkUI';
import lazy { AlbumSetDataSource } from '../../../default/model/browser/album/AlbumSetDataSource';
import lazy { AlbumDefine } from '../../../default/model/browser/AlbumDefine';
import lazy { FocusUtil } from '../../../default/utils/FocusUtil';
import lazy { AccessibilityUtil } from '../../../default/utils/AccessibilityUtil';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { AlbumRefreshConst, OnAlbumClickListener } from '../../../default/utils/AlbumRefreshUtil';
import lazy { uniformTypeDescriptor } from '@kit.ArkData';
import lazy { MediaDataSource } from '../../../default/model/browser/photo/MediaDataSource';
import lazy { AlbumDataSource } from '../../../default/model/AlbumDataSource';
import lazy { PhotoGridViewConstants, PhotoGridViewController } from '../../../default/view/grid/GridView';
import lazy { DataSourceCommonUtil } from '../../../default/utils/DataSourceCommonUtil';
import lazy { PhotoDataImplAsync } from '../../../default/model/browser/photo/PhotoDataImplAsync';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { Context } from '@ohos.arkui.UIContext';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy {
  AlbumBigDataConstants,
} from '../../../default/model/browser/album/ReportAlbumDataUtil';
import lazy {
  MenuController,
  MenuPopUpParams,
  PopType
} from '../../view/menu/MenuController';
import lazy { MenuPopUp } from '../menu/MenuView';
import lazy { common } from '@kit.AbilityKit';
import lazy { JSON } from '@kit.ArkTS';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { ImageUtil } from '../../utils/ImageUtil';

/* instrument ignore file */
const TAG: string = 'browser_AlbumGridItemNewStyle';
type commonContext = common.UIAbilityContext | common.ServiceExtensionContext;
const reportDataContext: commonContext = getContext(this) as commonContext;

const ALBUM_ITEM_PADDING: number = DeviceInfo.isPcOrTablet() ? 10 : 8;
const ALBUM_ITEM_OFFSET: number = DeviceInfo.isPcOrTablet() ? 5 : 4;
const HOVER_SCALE_START: number = 1.0;
const HOVER_SCALE_END: number = 0.95;
const SCALE_START: number = 0.95;
const SCALE_END: number = 1.05;

@Extend(Image)
function focusSetting(uri: string) {
  .key(`AlbumFocus_${uri}`)
  .focusable(true)
}

// The item of album grid, and it's new style.
@Reusable
@Component
export struct AlbumGridItemNewStyle {
  private albumContext?: Context;
  @ObjectLink @Watch('onAlbumInfoChanged') item: AlbumInfo;
  private dataSource: AlbumSetDataSource | undefined;
  @State isSelected: boolean = false;
  @State selectable: boolean = true;
  @Link bottomHeight: number;
  @State private isLongPressAlbum: boolean = false;
  private readonly albumLongPressPreviewPadding: number = 12;
  private readonly albumCardComponentHeight: number = 37;
  private readonly albumCardComponentMarginTop: number = 8;
  private readonly albumCardComponentMarginRight: number = 8;
  @StorageLink('isSidebar') isSidebar: boolean = getScreen().isSidebar();
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @Consume broadCast: BroadCast;
  @Consume('selectedCount') selectedCount: number;
  @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
  @Consume rightClickMenuList: Action[];
  @Prop private controller: MenuController;
  public currentRightClickMenuList: Action[] = [];
  onMenuClicked: Function = (): void => {
  };
  onMenuClickedForSingleItem: Function = (): void => {
  };
  public gridAspectRatio = Constants.CARD_ASPECT_RATIO;
  public iconMarkAnchorX = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  public iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  @State transitionId: string = '';
  @StorageLink('isShowPhotoGridView') isShowPhotoGridView: boolean = false;
  @StorageLink('isDoingGeometryTransitionAnimation') @Watch('onTransitionAnimationStatusChange')
  public isDoingGeometryTransitionAnimation: boolean = false;
  private keyIndex?: number;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  private recycleAlbumOfPhoneHeight: number = Constants.RECYCLE_ALBUM_OF_PHONE_HEIGHT;
  public isHiddenView: boolean = false;
  private albumBroadCast: BroadCast = AlbumSetDataSourceManager.getInstance().getBroadCast();
  private readonly onClickAlbumHelper: EventHelper<ClickEvent | GestureEvent> =
    new EventHelper<ClickEvent | GestureEvent>();
  private readonly onClickAlbumInfoHelper: EventHelper<ClickEvent> = new EventHelper<ClickEvent>();
  private readonly onKeyAlbumHelper: EventHelper<KeyEvent> = new EventHelper<KeyEvent>();
  // stop click event
  @Prop isStopEvent: boolean = false;
  // drag album scale animation
  @Prop isNeedInitializationAnimation: boolean = false;
  @State @Watch('coverUriFunction') coverUri: string = '';
  // @Consume('photoHiddenAlbumItem') hiddenAlbumItem: ParamAlbumInfo | undefined;
  // @Consume selectHiddenAlbumUri: string;
  // @Consume hiddenGridViewOpacity: number;
  // @Consume hiddenGridActionBarOpacity: number;
  @StorageLink('isPhotoGridFocused') isPhotoGridFocused: boolean = false;
  @Link public isShowHiddenGridView: boolean;
  // @Consume hiddenAlbumOtherScale: number;
  private updateSelectedFun: Function = (selected: boolean, uri: string):
    void => this.updateSelectedStatus(selected, uri);
  @Consume private longPressMenuList: Action[];
  private mSelectManager: AlbumSetSelectManager | undefined = undefined;
  private longPressClickedMenu: Action | undefined = undefined;
  private updateLongPressMenuList: Function = (): void => {
  };
  private isSecondClick: boolean = false;
  private isOpenAlbum: boolean = false;
  @Prop @Watch('onSelectStateChange') private isRefreshSelectState: boolean = false;
  @State private albumItemWidth: number = 0;
  @State private isCoverLoadError: boolean = false;
  @State private hasTriedThumbnailFallback: boolean = false;
  private boxSelectStr: string = '';
  private boxDeselectStr: string = '';
  private selectStr: string = '';
  private deselectStr: string = '';
  private clickActionStr: string = '';
  private onEnterAlbumFunc: Function = (): void => {
  };
  private onExitAlbumFunc: Function = (): void => {
  };
  public onClickListener: OnAlbumClickListener | undefined = undefined;
  @Link isDraggingToPage: boolean;
  @Prop @Watch('closeContextMenu') isPrivateHideState: boolean = false;
  @Link albumCardLargeHeight: number;
  private lastAlbumCoverUri: string = '';

  private onSelectStateChange(): void {
    if (!this.mSelectManager) {
      Log.error(TAG, 'selectManager undefined');
      return;
    }
    this.isSelected = this.mSelectManager.isItemSelected(this.item?.uri);
  }

  private onTransitionAnimationStatusChange(): void {
    if (!this.isShowPhotoGridView && !this.isDoingGeometryTransitionAnimation) {
      this.requestFocus('AlbumFocus_');
    }
  }

  coverUriFunction(): void {
    Log.info(TAG, ` coverUri ===${this.coverUri}`);
  }

  private onAlbumInfoChanged(): void {
    this.syncAlbumCoverState();
  }

  private syncAlbumCoverState(): void {
    let nextCoverUri: string = this.item?.coverUri ?? '';
    if (this.lastAlbumCoverUri !== nextCoverUri) {
      this.dataSource?.releaseAlbumCoverCache(this.item?.uri ?? '');
      this.lastAlbumCoverUri = nextCoverUri;
    }
    if (this.coverUri !== nextCoverUri || this.isCoverLoadError) {
      this.coverUri = nextCoverUri;
      this.isCoverLoadError = false;
      this.hasTriedThumbnailFallback = false;
    }
  }

  private requestFocus(keyName: string): void {
    if (!DeviceInfo.isPc()) {
      return;
    }
    let positionUri = AppStorage.get<string>('focusPosition');
    let isUpdate = AppStorage.get<boolean>('focusUpdate');
    if (this.item != null && isUpdate && positionUri === this.item.uri) {
      let ret: boolean = focusControl.requestFocus(keyName + this.item.uri);
      if (!ret) {
        Log.error(TAG, `requestFocus${keyName + this.item.uri}, ret:${ret}`);
      }
      AppStorage.setOrCreate<boolean>('focusUpdate', false);
    }
  }

  doAnimation(targetDataSource?: MediaDataSource): void {
    let albumToPhotoGridDuration: number | undefined;
    let albumActionBarDuration: number | undefined;
    albumToPhotoGridDuration = getDurationConst(GridLink.ALBUM_TO_PHOTO_GRID);
    if (!DeviceInfo.isPc()) {
      albumActionBarDuration = getDurationConst(GridLink.ALBUM_ACTIONBAR);
    } else {
      albumActionBarDuration = getDurationConst(GridLink.IN_ALBUM_ACTIONBAR);
    }
    // 从相册进入宫格
    animateTo({
      duration: albumToPhotoGridDuration,
      curve: Curve.Friction,
      onFinish: (): void => {
        AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, false);
        performanceMonitor.end(BigDataConstants.OPEN_ALBUM);
      }
    }, (): void => {
      Log.info(TAG, `albumToPhotoGrid animation, keyIndex: ${this.keyIndex}, isShow: ${this.isShowPhotoGridView}`);
      let showPhotoGridViewFlag: boolean = !this.isShowPhotoGridView;
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, !this.isShowPhotoGridView);
      let controller: PhotoGridViewController = new PhotoGridViewController();
      controller.setIsShow(TAG, 'doAnimation', controller.isShow, showPhotoGridViewFlag);
      controller.dataSource = targetDataSource;
      getContext().eventHub.emit(PhotoGridViewConstants.EVENT_KEY_SHOW_GRID_VIEW, controller);
      AppStorage.setOrCreate<number>(Constants.KEY_OF_SELECTED_ALBUM_INDEX, this.keyIndex ?? -1);
      AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, this.item.uri);
    })
    // 相册与相册ActionBar透明度动画
    animateTo({
      duration: albumActionBarDuration,
      curve: Curve.Sharp,
    }, () => {
      if (!DeviceInfo.isPc()) {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 0);
      }
      AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_ACTIONBAR_OPACITY, 0);
    })
    // 进入宫格透明度动画
    animateTo({
      duration: albumActionBarDuration,
      curve: Curve.Sharp,
      delay: getDelayConst(GridLink.IN_PHOTO_GRID),
    }, () => {
      if (!DeviceInfo.isPc()) {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
      }
    })
    // 触发送显
    animateToImmediately({
      duration: 0,
    }, (): void => {});

    this.continueDoAnimation();
  }

  private continueDoAnimation(): void {
    let photoGridActionBarDuration: number | undefined;
    let photoGridActionBarDelay: number | undefined;
    photoGridActionBarDuration = getDurationConst(GridLink.IN_PHOTO_GRID_ACTION_BAR);
    photoGridActionBarDelay = getDelayConst(GridLink.PHOTO_GRID_ACTIONBAR);

    // 宫格ActionBar透明度动画
    animateTo({
      duration: photoGridActionBarDuration,
      delay: photoGridActionBarDelay,
      curve: Curve.Sharp,
    }, (): void => {
      AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);
    })

    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      // 进入宫格透明度动画
      animateTo({
        duration: getDurationConst(GridLink.IN_PHOTO_GRID),
        delay: getDelayConst(GridLink.IN_PHOTO_GRID),
        curve: Curve.Sharp,
      }, (): void => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
      })
      // 相册透明度动画
      animateTo({
        duration: getDurationConst(GridLink.ALBUM),
        curve: Curve.Sharp,
      }, (): void => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 0);
      })
      // 侧边栏边界线透明度动画
      animateTo({
        duration: getDurationConst(GridLink.IN_SIDEBAR),
        curve: Curve.Sharp,
      }, (): void => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_SIDE_BAR_BOUNDARY_LINE_OPACITY, 0);
      })
    }

    Log.info(TAG, 'do animation');
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear---album uri: ${this.item.uri}`);
    this.syncAlbumCoverState();
    this.selectable = !this.item.isTrashAlbum;
    let isFirstPhotoItem = AppStorage.get<boolean>(Constants.KEY_OF_IS_FIRST_PHOTO_ITEM);
    let lastTransitionId = AppStorage.get<string>(Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT) as string;
    if (!isFirstPhotoItem && this.item.uri === AppStorage.get<string>(Constants.KEY_OF_ALBUM_URI)) {
      this.transitionId = lastTransitionId;
    } else {
      if (!this.isRecycleAlbumOfPhoneLikeDevice() && this.item.mediaItem) {
        let transitionId = `${this.item.mediaItem.getHashCode()}_${this.item.uri}`;
        Log.info(TAG, `transitionId: ${this.item.mediaItem.getHashCode()}_${this.item.uri}`);
        if (lastTransitionId === transitionId) {
          this.transitionId = transitionId;
        }
      }
    }
    Log.debug(TAG, `aboutToAppear lastTransitionId: ${lastTransitionId}, transitionId: ${this.transitionId}`);
    this.bottomHeight = getBottomHeight();
    this.initCurrentRightClickMenuList();
    this.broadCast.on(Constants.UPDATE_SELECTED, this.updateSelectedFun);
    this.onClickAlbumHelper.register(() => this.isStopEvent);
    this.onClickAlbumInfoHelper.register(() => this.isStopEvent);
    this.onKeyAlbumHelper.register(() => this.isStopEvent);
    this.onClickAlbumHelper.register(() => {
      this.albumClickEvent();
      return false;
    });
    this.onClickAlbumInfoHelper.register(() => {
      this.albumClickEvent();
      return false;
    });
    this.onKeyAlbumHelper.register((event: KeyEvent) => {
      this.albumKeyEvent(event);
      return false;
    });
  }

  aboutToDisappear(): void {
    this.broadCast.off(Constants.UPDATE_SELECTED, this.updateSelectedFun);
    this.dataSource?.releaseAlbumInfoItemCache(this.item);
  }

  aboutToReuse(params: ESObject): void {
    if (params === null || params === undefined) {
      Log.error(TAG, 'reuse failed');
      return;
    }
    if (this.isSelected != params.isSelected) {
      this.isSelected = params.isSelected;
    }
    this.syncAlbumCoverState();
  }

  aboutToRecycle() {
    this.dataSource?.releaseAlbumInfoItemCache(this.item);
  }

  private openAlbumAfterDrag(albumInfo: AlbumInfo | undefined): void {
    if (albumInfo && albumInfo.uri === this.item.uri) {
      this.albumClickEvent();
    }
  }

  onModeChange(): void {
    let multiIndex = this.currentRightClickMenuList.indexOf(Action.MULTISELECT);
    if (this.isAlbumSetSelectedMode) {
      // 移除多选项
      this.currentRightClickMenuList.splice(multiIndex, 1);
    } else {
      this.isSelected = false;
      // 添加多选项到第1个位置
      if (multiIndex < 0) {
        this.currentRightClickMenuList.splice(0, 0, Action.MULTISELECT);
      }
    }
  }

  selectStateChange(): void {
    Log.info(TAG, 'change selected.');
    if (!this.isAlbumSetSelectedMode && !DeviceInfo.isPc()) {
      this.isAlbumSetSelectedMode = true;
    }
    // 如果是系统相册、来源相册且不是隐藏相册相册视图、且处于相册选中状态 或者是PC场景时，点击置灰相册无响应
    if ((this.item?.isSystemAlbum || this.item?.isSourceAlbum) && !this.isHiddenView &&
      (this.isAlbumSetSelectedMode || DeviceInfo.isPc())) {
      this.selectable = false;
    }
    if (this.selectable) {
      let newState: boolean = !this.isSelected;
      let isSystemAlbum: boolean = this.item.isSystemAlbum;
      if (this.isHiddenView) {
        this.albumBroadCast.emit(BroadCastConstants.SELECT,
          [this.item?.uri, newState, isSystemAlbum, isSystemAlbum, this.keyIndex, (): void => {
            Log.info(TAG, 'albumBroadCast enter callback');
            this.isSelected = newState;
            // 点击选中后可以enter or space打开大图
            /* instrument ignore next */
            if (DeviceInfo.isPc() && this.item?.uri && this.isSelected) {
              FocusUtil.requestFocus(this.getUIContext()?.getFocusController(), 'AlbumFocus_' + this.item.uri);
            }
          }]);
      } else {
        this.broadCast.emit(BroadCastConstants.SELECT,
          [this.item?.uri, newState, isSystemAlbum || this.item?.isSourceAlbum,
            isSystemAlbum || this.item?.isSourceAlbum, (): void => {
              Log.info(TAG, 'enter callback');
              this.isSelected = newState;
            }]);
        this.broadCast.emit(BroadCastConstants.UPDATE_SELECT_ALBUMINFOS, [newState, this.item]);
      }
    }
  }

  initCurrentRightClickMenuList(): void {
    if (this.isHiddenView) {
      this.currentRightClickMenuList = [];
      if (!this.isAlbumSetSelectedMode) {
        this.currentRightClickMenuList.push(Action.MULTISELECT);
        this.currentRightClickMenuList.push(Action.DELETE);
      }
    } else {
      this.currentRightClickMenuList = [];
      if (!this.isAlbumSetSelectedMode) {
        this.currentRightClickMenuList.push(Action.MULTISELECT);
      }
      if (!this.item.isSystemAlbum) {
        this.currentRightClickMenuList.push(Action.RENAME_ALBUM);
        this.currentRightClickMenuList.push(Action.DELETE_ALBUM);
      }
    }
  }

  private onRightClick(menu: Action): void {
    if (menu === Action.MULTISELECT && !DeviceInfo.isPc()) {
      this.selectStateChange();
    } else if (menu === Action.MULTISELECT && DeviceInfo.isPc()) {
      this.isAlbumSetSelectedMode = true;
      this.selectStateChange();
    } else {
      // 1.当鼠标对着被选中的项按右键时，菜单中的功能，针对所有被选中的项做处理
      // 2.当鼠标对着未被选中的项按右键时，菜单中的功能，仅针对当前项处理，其他被选中的项不做任何处理
      if ((this.isAlbumSetSelectedMode || DeviceInfo.isPc()) && this.isSelected) {
        this.onMenuClicked?.(menu);
      } else {
        this.onMenuClickedForSingleItem?.(menu, this.item);
      }
    }
  }

  private getMenuPopUpParams(): MenuPopUpParams {
    const params: MenuPopUpParams = {
      type: PopType.NORMAL,
      onMenuClick: (menu: Action): void => this.onRightClick(menu),
    }
    return params;
  }

  @Builder
  RightClickMenuBuilder() {
    if (this.showRightClickPopup()) {
      if (DeviceInfo.isPc()) {
        MenuPopUp({
          controller: this.controller,
          menuPopUpParams: this.getMenuPopUpParams(),
        })
      } else {
        Menu() {
          ForEach(this.isAlbumSetSelectedMode &&
          this.isSelected ? this.rightClickMenuList : this.currentRightClickMenuList,
            (menu: Action, index: number) => {
              MenuItem({ content: this.changeTextResToPlural(menu), labelInfo: menu.shortKey })
                .height(Constants.MENU_ITEM_HEIGHT_PHONE)
                .margin({ top: index > 0 ? $r('sys.float.padding_level1') : undefined })
                .onClick((): void => {
                  this.onRightClick(menu);
                })
            }, (menu: Action) => menu.actionID.toString())
        }
      }
    }
  }

  isRecycleAlbumOfPhoneLikeDevice(): boolean {
    return !DeviceInfo.isPc() && this.item.isTrashAlbum;
  }

  @Builder
  recycleCard() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
    }) {
      Image($r('app.media.ic_gallery_public_delete_line'))
        .draggable(false)
        .width($r('app.float.phone_recycle_ico_size'))
        .aspectRatio(1)
        .fillColor($r('sys.color.icon_secondary'))
        .focusSetting(this.item.uri)
    }
    .width('100%')
    .aspectRatio(1)
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .border({
      radius: $r('sys.float.corner_radius_level6'),
    })
    .animation({
      duration: Constants.albumStyleSwitchDuration,
      curve: Curve.Friction,
    })
  }

  private onSelect(key: String, value: boolean, isDisableRename: boolean,
    isDisableDelete: boolean, callback: Function): void {
    Log.info(TAG, `album delete onSelect${JSON.stringify(key)}`);
    this.mSelectManager?.toolBarStateToggle(key as string, value, isDisableRename, isDisableDelete);
    if (this.mSelectManager?.toggle(key as string, value)) {
      Log.info(TAG, 'enter event process');
      callback();
    }
  }

  @Builder
  EmptyBuilder() {
  }

  /**
   * 长按相册菜单
   */
  @Builder
  LongPressMenuBuilder() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
    }) {
      Menu() {
        ForEach(this.longPressMenuList, (action: Action, index: number) => {
          MenuItem({ content: action.textRes }) {
          }
          .margin({ left: Constants.MENU_ITEM_START_MARGIN, right: Constants.MENU_ITEM_START_MARGIN })
          .padding({ left: Constants.MENU_ITEM_START_PADDING, right: Constants.MENU_ITEM_START_PADDING })
          .contentFont({ weight: 'medium' })
          .key(`Album_LongPress_${action.componentKey}`)
          .onClick((): void => {
            this.longPressClickedMenu = action;
            const msg: Record<string, number | string | boolean> = {
              'from': 'AlbumSetPage',
              'action': action.componentKey
            };
            ReportToBigDataUtil.report(BigDataConstants.LONG_PRESS_MENU_CLICK, msg);
          })
        })
      }
      .menuItemDivider({
        strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
        color: $r('sys.color.ohos_id_color_list_separator'),
        startMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
        endMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
      })
      .padding({
        left: Constants.MENU_LEFT_PADDING,
        right: Constants.MENU_LEFT_PADDING,
        top: Constants.MENU_TOP_PADDING,
        bottom: Constants.MENU_TOP_PADDING,
      })
      .width($r('app.float.more_menu_width'))
      .radius($r('sys.float.corner_radius_level10'))
      .key('AlbumGridItemNewStyle_Menu')
    }
  }

  @Builder
  normalAlbumCard() {
    // 封面缩略图为空或加载失败时，使用占位图，避免出现白屏
    if (this.coverUri && !this.isCoverLoadError) {
      Image(this.coverUri)
        .draggable(false)
        .border({ radius: $r('sys.float.corner_radius_level6') })
        .width('100%')
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .onComplete((event?: completed): void => {
          if ((event?.loadingStatus === ImageUtil.LOADING_STATUS_DECODE_SUCC)) {
            Log.info(TAG, `album cover show path : ${this.coverUri}`);
          } else {
            Log.info(TAG, `album cover onComplete, status: ${event?.loadingStatus}, path: ${this.coverUri}`);
            this.dataSource?.setAlbumCoverCache(this.item.uri, this.coverUri);
          }
        })
        .onError((event: ImageError): void => {
          if (!this.hasTriedThumbnailFallback && this.coverUri.includes('oper=astc')) {
            this.coverUri = this.coverUri.replace('oper=astc', 'oper=thumbnail');
            this.hasTriedThumbnailFallback = true;
            Log.warn(TAG, `album cover astc decode failed, retry thumbnail, path: ${this.coverUri}`);
            return;
          }
          Log.error(TAG, `album is empty or its cover is error, ` +
            `album_photoBrowser: ${AlbumDefine.getAnonymizeAlbumName(this.item?.albumName)}, ` +
            `path: ${this.coverUri}, error: ${event.message}`);
          this.dataSource?.releaseAlbumCoverCache(this.item.uri);
          this.isCoverLoadError = true;
        })
        .focusSetting(this.item.uri)
        .alt(this.dataSource?.getAlbumCoverCache(this.item.uri))
    } else {
      this.buildCoverErrorPlaceholder();
    }
  }

  /**
   * 相册封面加载失败或无封面时的占位图（图片/视频都有占位）
   */
  @Builder
  private buildCoverErrorPlaceholder() {
    Column() {
      SymbolGlyph(this.item?.isVideoAlbum ? $r('sys.symbol.resolution_video_fill') : $r('sys.symbol.picture_fill'))
        .fontSize($r('app.float.album_set_new_style_icon'))
        .draggable(false)
        .aspectRatio(1)
        .fontColor([$r('sys.color.ohos_id_color_click_effect')])
    }
    .width('100%')
    .aspectRatio(1)
    .border({ radius: $r('sys.float.corner_radius_level6') })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('sys.color.ohos_id_color_hover'))
  }

  private isShowLongPressMenu(item: AlbumInfo): boolean {
    if (this.isHiddenView) {
      return !this.isAlbumSetSelectedMode || this.selectedCount <= 1;
    }
    if (item?.isSystemAlbum) {
      return false;
    }
    if (this.isAlbumSetSelectedMode) {
      return this.selectedCount <= 1 && this.longPressMenuList?.length > 0;
    }
    if (item?.isSourceAlbum) {
      return false;
    }
    return this.longPressMenuList?.length > 0;
  }

  albumClickEvent() {
    if (!this.isRecycleAlbumOfPhoneLikeDevice() && this.item.mediaItem) {
      this.transitionId = `${this.item.mediaItem?.getHashCode()}_${this.item.uri}`;
    }
    this.albumOnClick();
  }

  private albumKeyEvent(event: KeyEvent): void {
    if (!event) {
      return;
    }
    if (KeyType.Up === event.type && event?.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER) {
      /* instrument ignore next */
      if (DeviceInfo.isPc() && this.isHiddenView) {
        if (this.mSelectManager?.getSelectedCount() && this.mSelectManager?.getSelectedCount() > 1) {
          return;
        }
        this.isOpenAlbum = true;
        this.albumOnClick();
        this.isOpenAlbum = false;
      } else {
        this.albumOnClick();
      }
    }
  }

  @Builder
  albumCardInfo() {
    Column() {
      AlbumCardComponent({ item: $item })
        .opacity(this.isAlbumSetSelectedMode &&
          ((this.item?.isSystemAlbum || this.item?.isSourceAlbum) && !this.isHiddenView) ?
        Constants.MULTISELECT_SYSTEM_ALBUM_INFO_OPACITY :
        Constants.SYSTEM_ALBUM_INFO_OPACITY)
    }
    .accessibilityLevel('no-hide-descendants')
    .padding({ top: $r('app.float.album_set_count_margin_bottom') })
    .opacity(this.isNeedInitializationAnimation ?
    Constants.DRAG_ALBUM_INFO_OPACITY_DISAPPEAR : Constants.DRAG_ALBUM_INFO_OPACITY_APPEAR)
    .animation({ curve: Curve.Sharp })
    .onClick((event: ClickEvent) => {
      this.onClickAlbumInfoHelper.process(event);
    })
  }

  @Builder
  favorAndVideoAlbumIcoDisplay() {
    SymbolGlyph(this.item.isFavorAlbum ? $r('sys.symbol.heart_fill') : $r('sys.symbol.video_fill'))
      .draggable(false)
      .aspectRatio(1)
      .fontSize($r('app.float.album_set_new_style_icon'))
      .fontColor([$r('sys.color.white')])
      .position({ x: '0%', y: '100%' })
      .markAnchor({ x: 0 - Constants.ALBUM_SET_NEW_ICON_MARGIN, y: this.getIconMarkAnchorY() })
  }

  @Builder
  maskLayer() {
    Image($r('app.media.gradient_mask_layer'))
      .draggable(false)
      .height('50%')
      .width('100%')
      .border({ radius: $r('sys.float.corner_radius_level6') })
  }

  @Builder
  selectedModeBg() {
    Column()
      .height('100%')
      .width('100%')
      .border({ radius: $r('sys.float.corner_radius_level6') })
      .backgroundColor((this.isSelected && this.isAlbumSetSelectedMode && this.selectable) ||
        (((this.item?.isSystemAlbum || this.item?.isSourceAlbum) && !this.isHiddenView) && this.isAlbumSetSelectedMode)
        ? $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.albumItemWidth = Number(newValue?.width ?? 0) + ALBUM_ITEM_PADDING;
      })
  }

  // 系统相册，屏幕朗读避免触发可点击事件
  private isAlbumDisabled(): boolean {
    return ((this.item?.isSystemAlbum || this.item?.isSourceAlbum) && this.isAlbumSetSelectedMode &&
      !this.isHiddenView && !DeviceInfo.isPc());
  }

  private getBorderColor(): Resource | Color {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && !this.isAlbumSetSelectedMode && this.isSelected) {
      return this.isPhotoGridFocused ? $r('sys.color.ohos_id_color_focused_outline') : Color.Grey;
    }
    return Color.Transparent;
  }

  private getBorderWidth(): Resource {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return $r('app.float.image_grid_item_border_width_pc');
    }
    return $r('app.float.image_grid_item_default_border_width');
  }

  private onMenuAboutToAppear(): void {
    if (!DeviceInfo.isPc()) {
      return;
    }
    this.getUIContext()?.getFocusController()?.clearFocus();
    if (!this.isSelected) {
      this.selectStateChange();
    }
  }

  private setFocusImage(): void {
    if (!DeviceInfo.isPc() || this.isSelected || this.isAlbumSetSelectedMode) {
      return;
    }
    this.selectStateChange();
  }

  private isShowMask(): boolean {
    if (!DeviceInfo.isPc()) {
      return !this.isSelected && (this.item?.isFavorAlbum || this.item?.isVideoAlbum ||
        (this.isAlbumSetSelectedMode && this.selectable));
    }
    return (!this.isSelected || !this.isAlbumSetSelectedMode) && (this.item?.isFavorAlbum || this.item?.isVideoAlbum ||
      (this.isAlbumSetSelectedMode && this.selectable));
  }

  @Styles
  albumStackLongPressAttr() {
    .bindContextMenu(this.isShowLongPressMenu(this.item) ? this.LongPressMenuBuilder() : this.EmptyBuilder,
      ResponseType.LongPress,
      this.isShowLongPressMenu(this.item) ?
        {
          aboutToAppear: (): void => {
            Log.info(TAG, 'LongPress MenuList aboutToAppear');
            UiUtil.touchVibrate(VibrateType.ALBUM);
            this.isLongPressAlbum = true;
          },
          onAppear: (): void => {
            Log.info(TAG, 'LongPress MenuList Show');
            const msg: Record<string, number | string | boolean> = { 'from': 'AlbumSetPage' };
            ReportToBigDataUtil.report(BigDataConstants.LONG_PRESS, msg);
            AlbumBrowsingInfo.albumLongPress = true;
          },
          onDisappear: (): void => {
            Log.info(TAG, 'LongPress MenuList onDisappear');
            this.isLongPressAlbum = false;
            // menu销毁时才处理事件，防止弹窗和menu动效重叠
            if (!this.longPressClickedMenu) {
              Log.error(TAG, 'get longPressClickedMenu failed');
              return;
            }
            this.handleLongPressMenuClick(this.longPressClickedMenu);
            this.longPressClickedMenu = undefined;
            AlbumBrowsingInfo.albumLongPress = false;
          },
          preview: this.AlbumPreview,
          previewAnimationOptions: {
            hoverScale: [HOVER_SCALE_START, HOVER_SCALE_END],
            scale: [SCALE_START, SCALE_END],
          },
          placement: this.isVerdeFoldable ? Placement.BottomLeft : undefined,
        } : {})
  }

  @Styles
  albumStackCommonAttr() {
    .enabled(!this.isAlbumDisabled() && !this.isDraggingToPage)
    .key(`AccessibilityAlbumStack_${this.keyIndex}`)
    .accessibilityText(this.getAlbumInfoText())
    .accessibilityDescription(this.getCheckActionStr())
    .accessibilitySelected(this.isSelected)
    .draggable(this.isAllowAlbumDrag((this.item?.isSystemAlbum || this.item?.isSourceAlbum)))
    .bindContextMenu(this.RightClickMenuBuilder, this.showRightClickPopup() ? ResponseType.RightClick : -1, {
      aboutToAppear: (): void => {
        this.onMenuAboutToAppear();
      },
    })
    .onKeyEvent((event: KeyEvent) => {
      this.onKeyAlbumHelper.process(event);
    })
    .onTouch((event: TouchEvent): void => {
      if (event.type === TouchType.Down) {
        this.updateLongPressMenuList?.();
      }
    })
    .onKeyPreIme((event: KeyEvent) => {
      if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_ENTER) {
        this.getUIContext()?.getFocusController()?.clearFocus();
        this.isOpenAlbum = true;
        this.albumOnClick();
        this.isOpenAlbum = false;
      }
      return false;
    })
  }

  @Builder
  buildAlbumGridItem() {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Stack({ alignContent: Alignment.Bottom }) {
        this.albumGridItemCommonBuilder();
      }
      .albumStackCommonAttr()
      .albumPCGestureAttr()
      .albumStackLongPressAttr();
    } else {
      Stack({ alignContent: Alignment.Bottom }) {
        this.albumGridItemCommonBuilder();
      }
      .albumStackCommonAttr()
      .albumGestureAttr()
      .albumStackLongPressAttr();
    }
  }

  @Styles
  albumGestureAttr() {
    .gesture(
      TapGesture({ count: 1 }).onAction((event: GestureEvent) => {
        Log.info(TAG, 'image tapgesture onAction');
        this.isOpenAlbum = false;
        if (this.isSecondClick) {
          this.isSecondClick = false;
          return;
        }
        this.getUIContext()?.getFocusController()?.clearFocus();
        this.onClickAlbumHelper.process(event);
      })
    )
  }

  @Styles
  albumPCGestureAttr() {
    .gesture(GestureGroup(GestureMode.Parallel,
      TapGesture({ count: 2 }).onAction((event: GestureEvent) => {
        Log.info(TAG, 'image tapgesture onAction:count-2');
        if (!DeviceInfo.isPc() || this.isAlbumSetSelectedMode) {
          return;
        }
        this.isSecondClick = true;
        this.getUIContext()?.getFocusController()?.clearFocus();
        this.isOpenAlbum = true;
        this.onClickAlbumHelper.process(event);
        this.isOpenAlbum = false;
      }),
      TapGesture({ count: 1 }).onAction((event: GestureEvent) => {
        Log.info(TAG, 'image tapgesture onAction');
        this.getUIContext()?.getFocusController()?.clearFocus();
        if (event.sourceTool === SourceTool.Finger) {
          this.isOpenAlbum = true;
          this.onClickAlbumHelper.process(event);
          LocalStorage.getShared()?.setOrCreate<boolean>('isTapGesture', true);
          this.isOpenAlbum = false;
        } else if (event.sourceTool === SourceTool.MOUSE) {
          this.isOpenAlbum = false;
          if (this.isSecondClick) {
            this.isSecondClick = false;
            return;
          }
          LocalStorage.getShared()?.setOrCreate<boolean>('isTapGesture', false);
          this.onClickAlbumHelper.process(event);
        }
      }),
    ))
  }

  build() {
    Column() {
      this.albumGridItemBuilder();
      this.albumCardInfo();
    }
  }

  private getDisplayName(albumInfo: AlbumInfo): Resource | string {
    const res = UiUtil.getDisplayNameResourceByAlbumInfo(albumInfo);
    if (res) {
      return res;
    }
    return albumInfo.albumName;
  }

  private getAlbumInfoText(): string {
    if (!this.albumContext) {
      this.albumContext = getContext();
    }
    let rsc: RscGetter = new RscGetter(this.albumContext.resourceManager);
    let unSelectedText = ''
    // 选择模式下未选中需要播报
    if (this.isAlbumSetSelectedMode && !this.isSelected &&
      (!this.item?.isSystemAlbum || !this.item?.isSourceAlbum) && this.selectable) {
      unSelectedText = `${rsc.toString($r('app.string.deselected'))},`
    }
    let name = rsc.toString(this.getDisplayName(this.item));
    let count = this.item.count;
    return `${unSelectedText} ${name} ${count}`;
  }

  private getCheckActionStr() {
    let checkActionStr = '';
    if (!this.isShowLongPressMenu(this.item)) {
      if (!this.isAlbumDisabled() && !this.isDraggingToPage) {
        checkActionStr = this.clickActionStr;
      } else {
        if (!this.albumContext) {
          this.albumContext = getContext();
        }
        let rsc: RscGetter = new RscGetter(this.albumContext.resourceManager);
        // 不可用
        checkActionStr = rsc.getString($r('app.string.disabled'));
      }
    }
    return checkActionStr;
  }

  @Builder
  albumGridItemCommonBuilder() {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Column() {
      }
      .width(this.albumItemWidth)
      .height(this.albumItemWidth)
      .offset({ y: ALBUM_ITEM_OFFSET })
      .border({
        color: this.getBorderColor(),
        width: this.getBorderWidth(),
        radius: $r('sys.float.corner_radius_level7'),
      })
    }

    if (this.isEmptyAlbum(this.item)) {
      EmptyAlbumComponent();
    }

    if (this.item.isTrashAlbum) {
      this.recycleCard();
    } else {
      // 普通视图显示相册封面图片
      this.normalAlbumCard();
    }

    if (this.isShowMask()) {
      this.maskLayer();
    }

    if (this.item.isFavorAlbum || this.item.isVideoAlbum) {
      this.favorAndVideoAlbumIcoDisplay();
    }

    this.selectedModeBg();
  }

  @Builder
  albumGridItemBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      this.buildAlbumGridItem()

      if (this.isAlbumSetSelectedMode && this.selectable &&
        ((!this.item?.isSystemAlbum && !this.item?.isSourceAlbum) || this.isHiddenView)) {
        Stack() {
          Checkbox()
            .key('AlbumCheckBox')
            .accessibilityLevel('no')
            .margin(0)
            .select(this.isSelected)
            .hitTestBehavior(HitTestMode.None)
            .backgroundColor($r('app.color.black'))
            .selectedColor($r('sys.color.comp_background_emphasize'))
            .opacity(this.isSelected ? $r('app.float.no_opacity') : $r('sys.float.alpha_fourth'))
            .border({ radius: $r('app.float.checkbox_border_radius') })
          Column()
            .height($r('app.float.checkbox_base_size'))
            .width($r('app.float.checkbox_base_size'))
            .border({
              color: $r('app.color.white'),
              width: this.isSelected ? $r('app.float.checkbox_selected_border_width') :
              $r('app.float.checkbox_unselected_border_width'),
              radius: $r('app.float.checkbox_border_radius'),
            })
        }
        .position({ x: '100%', y: '100%' })
        .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
        .height($r('app.float.icon_size'))
        .width($r('app.float.icon_size'))
        .accessibilityDescription(this.isSelected ? this.boxSelectStr : this.boxDeselectStr)
        .accessibilityRole(AccessibilityRoleType.STACK)
        .onClick((): void => {
          Log.info(TAG, 'albumSetSelectedMode, checkbox or Column onClicked');
          this.selectStateChange();
          if (AccessibilityUtil.isOpenTouchGuideSync()) {
            AccessibilityUtil.sendAnnounceAccessibilityEvent(this.isSelected ? this.selectStr : this.deselectStr);
          }
        })
      }
    }
    .accessibilityLevel('no')
    .width('100%')
    .aspectRatio(1)
    .border(this.isNeedInitializationAnimation ? { width: 0 } : {
      width: this.item?.count ? $r('app.float.album_card_border_width') : 0,
      color: this.isShowPhotoGridView || this.isDoingGeometryTransitionAnimation ? Color.Transparent :
      $r('app.color.album_card_border_color'),
      radius: $r('sys.float.corner_radius_level6'),
    })
    .opacity(this.isNeedInitializationAnimation ? Constants.DRAG_ALBUM_INFO_OPACITY_DISAPPEAR :
    Constants.DRAG_ALBUM_INFO_OPACITY_APPEAR)
    .animation({ curve: Curve.Sharp })
    .scale({
      x: this.isNeedInitializationAnimation ? Constants.DRAG_ALBUM_SCALE : Constants.DRAG_ALBUM_SCALE_RECOVER,
      y: this.isNeedInitializationAnimation ? Constants.DRAG_ALBUM_SCALE : Constants.DRAG_ALBUM_SCALE_RECOVER,
    })
    .animation({
      curve: Curves.interpolatingSpring(Constants.DRAG_ALBUM_SCALE_ANIMATION_VELOCITY,
        Constants.DRAG_ALBUM_SCALE_ANIMATION_MASS, Constants.DRAG_ALBUM_SCALE_ANIMATION_STIFFNESS,
        Constants.DRAG_ALBUM_SCALE_ANIMATION_DAMPING),
    })
    .animation({
      duration: Constants.albumStyleSwitchDuration,
      curve: Curve.Friction,
    })
    .onFocus((): void => {
      let isTapGesture: boolean = LocalStorage.getShared()?.get<boolean>('isTapGesture') ?? false;
      /* instrument ignore next */
      if (DeviceInfo.isPc() && isTapGesture) {
        return;
      }
      this.isPhotoGridFocused = true;
      this.setFocusImage();
    })
    .onTouch(() => {
      this.isPhotoGridFocused = true;
    })
  }

  // 长按相册页预览组件
  @Builder
  AlbumPreview() {
    Scroll() {
      Column() {
        if (this.isEmptyAlbum(this.item)) {
          EmptyAlbumComponent()
        } else {
          this.normalAlbumCard();
        }
        AlbumCardComponent({ item: $item })
          .height(this.albumCardComponentHeight)
          .margin({ top: this.albumCardComponentMarginTop, right: this.albumCardComponentMarginRight })
        if (this.item.isFavorAlbum || this.item.isVideoAlbum) {
          this.favorAndVideoAlbumIcoDisplay();
        }
      }
      .constraintSize({
        minWidth: getScreen().getAlbumPreviewColumnsWidth(ColumnSize.COLUMN_TWO),
        maxWidth: getScreen().getAlbumPreviewColumnsWidth(ColumnSize.COLUMN_TWO),
        minHeight: getScreen()
          .getAlbumPreviewColumnsWidth(ColumnSize.COLUMN_TWO) + this.albumCardLargeHeight +
        this.albumCardComponentMarginTop + this.albumCardComponentHeight,
        maxHeight: getScreen()
          .getAlbumPreviewColumnsWidth(ColumnSize.COLUMN_TWO) + this.albumCardLargeHeight +
        this.albumCardComponentMarginTop + this.albumCardComponentHeight
      })
      .padding(this.albumLongPressPreviewPadding)
      .backgroundColor($r('sys.color.background_secondary'))
    }
  }

  private getAllowDrop(): UniformDataType[] | null {
    if (this.isAlbumSetSelectedMode) {
      return null;
    }
    return [uniformTypeDescriptor.UniformDataType.IMAGE, uniformTypeDescriptor.UniformDataType.VIDEO];
  }

  // 隐藏相册video,收藏图标位置
  private getIconMarkAnchorY(): number {
    if (this.isLongPressAlbum) {
      return this.iconMarkAnchorY + this.albumCardComponentHeight + this.albumCardComponentMarginTop;
    }
    return this.iconMarkAnchorY;
  }

  private handleLongPressMenuClick(action: Action): void {
    if (action === Action.MULTISELECT && !this.isHiddenView) {
      this.onMenuClicked?.(action, null);
      this.onSelect(this.item?.uri, true, this.item?.isSystemAlbum || this.item?.isSourceAlbum,
        this.item?.isSystemAlbum || this.item?.isSourceAlbum, (): void => {
          Log.info(TAG, 'album select callback');
          this.broadCast.emit(Constants.UPDATE_SELECTED, [true, this.item?.uri]);
        });
      this.broadCast.emit(BroadCastConstants.UPDATE_SELECT_ALBUMINFOS, [true, this.item]);
    } else {
      this.onMenuClickedForSingleItem?.(action, this.item);
    }
  }

  private isAllowAlbumDrag(isSystemAlbum: boolean): boolean {
    if (DeviceInfo.isPhoneUx()) {
      Log.info(TAG, 'Album dragging is not allowed in phone');
      return false;
    }
    if (this.isHiddenView) {
      return !this.isAlbumSetSelectedMode || this.selectedCount <= 1;
    }
    return !isSystemAlbum && !this.isAlbumSetSelectedMode;
  }

  private changeTextResToPlural(action: Action): Resource {
    let textStr: Resource = action.textRes;
    if (Action.DELETE.equals(action)) {
      textStr = $r('app.string.action_delete');
    } else if (Action.ADD.equals(action)) {
      textStr = this.isSelected
        ? $r('app.plural.add_to_album_count', this.selectedCount, this.selectedCount)
        : $r('app.string.add_to_album');
    } else if (Action.MOVE.equals(action)) {
      textStr = $r('app.string.move_file_to');
    }
    return textStr;
  }

  private setStatusOnAnimationFinish(): void {
    setTimeout((): void => {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, false);
    }, getDurationConst(GridLink.ALBUM_TO_PHOTO_GRID))
  }

  private getSystemAlbumName(): string | Resource {
    if (this.item.subType === photoAccessHelper.AlbumSubtype.IMAGE) {
      return getContext().resourceManager.getStringSync($r('app.string.album_photos'));
    } else if (this.item.subType === photoAccessHelper.AlbumSubtype.VIDEO) {
      return getContext().resourceManager.getStringSync($r('app.string.album_video'));
    } else if (this.item.subType === photoAccessHelper.AlbumSubtype.FAVORITE) {
      return getContext().resourceManager.getStringSync($r('app.string.album_favor'));
    } else if (this.item.subType === photoAccessHelper.AlbumSubtype.USER_GENERIC) {
      return getContext().resourceManager.getStringSync($r('app.string.album_new_album'));
    } else if (this.item.subType === photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT) {
      return getContext().resourceManager.getStringSync($r('app.string.album_cloud_enhance'));
    } else {
      return this.item.albumName;
    }
  }

  private albumOnClick(): void {
    if (this.isAlbumSetSelectedMode || (DeviceInfo.isPc() && !this.isOpenAlbum)) {
      this.selectStateChange();
    } else {
      Log.info(TAG, `After onClick, MediaSet is: ${this.item?.printAlbumInfo()}`);
      const msg: Record<string, number | string | boolean | Resource> = {
        'ALBUM_TYPE': this.item.subType,
        'ALBUM_NAME': this.getSystemAlbumName(),
        'PICTURES_COUNT': this.item.count,
        'VIEW_STYLE': this.item.viewMode
      };
      ReportToBigDataUtil.report(BigDataConstants.CLICK_ON_THE_ALBUM, msg);
      this.reportToBigData();
      if (this.isHiddenView) {
        performanceMonitor.begin(BigDataConstants.OPEN_ALBUM, performanceMonitor?.ActionType?.LAST_UP);
        this.setStatusOnAnimationFinish();
        AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, true);
        let albumInfo: ParamAlbumInfo = { item: JSON.stringify(this.item) }
        // this.hiddenAlbumItem = albumInfo;
        AppStorage.setOrCreate<string>(Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT, this.transitionId);
        AlbumGrid.firstItem = this.item?.mediaItem?.data;
        AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_URI, this.item.uri);
        AppStorage.setOrCreate<string>('focusPosition', '');
        if (AccessibilityUtil.isOpenTouchGuideSync()) {
          AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_HIDDEN_SECONDARY_BACK);
        }
      } else if (!this.isShowPhotoGridView) {
        // 点击进相册后，注册该页面的监听，用以控制相册 inactive 状态。在随PhotoGridview的生命周期自动发送、销毁
        this.albumContext?.eventHub.on(AlbumRefreshConst.EVENT_KEY_APPEAR, this.onEnterAlbumFunc);
        this.albumContext?.eventHub.on(AlbumRefreshConst.EVENT_KEY_DISAPPEAR, this.onExitAlbumFunc);

        performanceMonitor.begin(BigDataConstants.OPEN_ALBUM, performanceMonitor?.ActionType?.LAST_UP);
        this.setStatusOnAnimationFinish();
        AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, true);
        let albumInfo: ParamAlbumInfo = { item: JSON.stringify(this.item) }
        AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, albumInfo);
        AlbumGrid.firstItem = this.item?.mediaItem?.data;
        AppStorage.setOrCreate<string>(Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT, this.transitionId);
        AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_URI, this.item.uri);
        AppStorage.setOrCreate<string>('focusPosition', '');

        /* instrument ignore next */
        if (DeviceInfo.isPhoneUx()) {
          let isDataSourceNormalization: boolean = DataSourceCommonUtil.isDataSourceNormalizationEnabled();
          let targetDataSource: MediaDataSource =
            new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, new PhotoDataImplAsync(TAG));
          let targetAlbumInfo: AlbumInfo = JSON.parse(albumInfo.item) as AlbumInfo;
          if (isDataSourceNormalization) {
            targetDataSource.releaseBroadCast();
            targetDataSource = new AlbumDataSource({ context: getContext(), albumInfo: targetAlbumInfo,
              isAccurateNotify: true, });
          } else {
            targetDataSource.setAlbumUri(targetAlbumInfo.uri);
            targetDataSource.setAlbumInfo(targetAlbumInfo);
            targetDataSource.setAlbumType(targetAlbumInfo.isSourceAlbum,
            targetAlbumInfo.isShootingAlbum || (targetAlbumInfo.subType === Constants.CITY_QUERY_SUB_TYPE));
          }
          this.doAnimation(targetDataSource);
        } else {
          this.doAnimation();
        }

        // 点击进入具体相册后，默认聚焦左上角返回按钮
        if (AccessibilityUtil.isOpenTouchGuideSync()) {
          AccessibilityUtil.sendFocusAccessibilityEvent(`ActionButton_${Action.BACK.componentKey}`);
        }
        this.isDraggingToPage = false;
      } else {
        Log.info(TAG, 'PhotoGridView is show, has no focus, Users need to manually activate the focus.');
      }
    }
  }

  private reportToBigData(): void {
    if (this.item?.isSystemAlbum) {
      let albumSubtype: number = this.item.subType;
      if (this.item.lpath === Constants.LPATH_CAMERA) {
        albumSubtype = AlbumBigDataConstants.CAMERA_ALBUM;
      } else if (this.item.lpath === Constants.LPATH_SCREEN_SHOT) {
        albumSubtype = AlbumBigDataConstants.SCREEN_SHOTS_ALBUM;
      } else if (this.item.lpath === Constants.LPATH_SCREEN_RECORDING) {
        albumSubtype = AlbumBigDataConstants.SCREEN_RECORDING;
      } else {
        albumSubtype = this.item.subType;
      }
      AlbumBrowsingInfo.albumSubtype = albumSubtype;

      const content: Record<string, number> = {
        'imageCount': this.item.count - this.item.videoCount,
        'videoCount': this.item.videoCount
      };
      const msg: Record<string, number | string | Object> = {
        'albumEvent': AlbumBigDataConstants.ENTER_SYSTEM_ALBUM,
        'albumType': albumSubtype,
        'content': JSON.stringify(content)
      };
      AlbumBrowsingInfo.albumSubtype = albumSubtype;
      ReportToBigDataUtil.report(AlbumBigDataConstants.ALBUM_CONTENT_REPORT, msg);
    } else if (this.item?.isUserCreatedAlbum) {
      Log.debug(TAG, `UserCreatedAlbum : ${this.item.albumType}, ${this.item.subType}`);
      const content: Record<string, number> = {
        'imageCount': this.item.count - this.item.videoCount,
        'videoCount': this.item.videoCount
      };
      const msg: Record<string, number | string | Object> = {
        'albumEvent': AlbumBigDataConstants.ENTER_USER_ALBUM,
        'albumType': this.item.subType,
        'content': JSON.stringify(content)
      };
      ReportToBigDataUtil.report(AlbumBigDataConstants.ALBUM_CONTENT_REPORT, msg);
      AlbumBrowsingInfo.albumSubtype = this.item.subType;
    }
    AlbumBrowsingInfo.enterAlbumTime = Date.now();
    AlbumBrowsingInfo.albumName = this.getSystemAlbumName();
  }

  private showRightClickPopup(): boolean {
    if (this.isAlbumSetSelectedMode && this.isSelected) {
      Log.debug(TAG, `Album ${AlbumDefine.getAnonymizeAlbumName(this.item?.albumName)} ` +
        `length1: ${this.rightClickMenuList.length}`);
      return this.rightClickMenuList.length > 0;
    } else {
      Log.debug(TAG, `Album ${AlbumDefine.getAnonymizeAlbumName(this.item?.albumName)} ` +
        `length2: ${this.currentRightClickMenuList.length}`);
      return this.currentRightClickMenuList.length > 0;
    }
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  updateSelectedStatus(selected: boolean, uri: string): void {
    if (this.item && this.item?.uri === uri) {
      this.isSelected = selected;
    }
  }

  private isEmptyAlbum(albumInfo: AlbumInfo): boolean {
    return !albumInfo || albumInfo.count === 0 || albumInfo.coverUri === '';
  }

  private closeContextMenu() {
    if (this.isPrivateHideState) {
      this.getUIContext().getContextMenuController()?.close();
    }
  }
}