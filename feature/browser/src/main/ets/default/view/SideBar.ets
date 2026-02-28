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
// TODO: 大图组件归一暂时放回feature-browser，不放在common层
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { AlbumDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumDataImpl';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataSource } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSource';
import lazy {
  AlbumSetDataSourceManager
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSourceManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BrowserDataFactory } from '@ohos/common/src/main/ets/default/interface/BrowserDataFactory';
import lazy { BrowserDataInterface } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { CustomDialogView } from '@ohos/common/src/main/ets/default/view/dialog/CustomDialogView';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaCount, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { MenuOperationFactory } from '@ohos/common/src/main/ets/default/interface/MenuOperationFactory';
import lazy {
  SourceTypeAlbumDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/SourceTypeAlbumDataSource';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { FeatureSwitchUtil } from '@ohos/common/src/main/ets/default/utils/FeatureSwitchUtil';
import lazy { AlbumSetSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { AlbumSetDeleteMenuOperation } from '@ohos/common/src/main/ets/default/view/album/AlbumSetDeleteMenuOperation';
import lazy {
  AlbumSetInlineRenameMenuOperation
} from '@ohos/common/src/main/ets/default/view/album/AlbumSetInlineRenameMenuOperation';
import lazy { SideBarItem } from '@ohos/common/src/main/ets/default/view/album/SideBarItem';
import lazy curves from '@ohos.curves';
import lazy { SearchSwitchManager } from '@ohos/common/src/main/ets/default/model/SearchSwitchManager';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { AlbumSetRenameMenuOperation } from '@ohos/common/src/main/ets/default/view/album/AlbumSetRenameMenuOperation';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { IndexFocusOrder } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { LoadingListener } from '@ohos/common/src/main/ets/default/model/browser/LoadingListener';
import lazy { NonUserAlbumSideBarItem } from '@ohos/common/src/main/ets/default/view/album/NonUserAlbumSideBarItem';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { SourceAlbumSideBarItem } from '@ohos/common/src/main/ets/default/view/album/SourceAlbumSideBarItem';
import lazy UTD from '@ohos.data.uniformTypeDescriptor';
import lazy { ChevronArrow } from '@ohos/common/src/main/ets/default/view/album/ChevronArrow';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy uniformTypeDescriptor from '@ohos.data.uniformTypeDescriptor';
import lazy { SideBarVariables } from '@ohos/tools/src/main/global/HapVariables';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { ComponentSnapshot } from '@ohos.arkui.UIContext';
import lazy { image } from '@kit.ImageKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { common } from '@kit.AbilityKit';
import lazy { RightClickMenuGroup, } from '@ohos/common/src/main/ets/default/view/menu/MenuController';
import lazy { SystemSideBarMenuController } from '../viewModel/SystemSideBarMenuController';
import lazy { UserSideBarMenuController, UpdateMenuParamUserAlbum } from '../viewModel/UserSideBarMenuController';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { unifiedDataChannel } from '@kit.ArkData';
import lazy {
  getScreen,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';

/* instrument ignore file */
const TAG: string = 'SideBar';
const SOURCE_ALBUM_MIN_COUNT: number = 5;
const ICON_RADIUS: number = 6;
const userAlbumAllowDropList: UTD.UniformDataType[] = [UTD.UniformDataType.IMAGE, UTD.UniformDataType.VIDEO];
const TEXT_MARGIN: number = 12;
const NONE_SELECTED = -1;
const LIST_SPACE: number = 2;
const TV_LIST_SPACE: number = 16;
const HEADER_MARGIN_PC: number = 8;
const HEADER_PADDING_RIGHT: number = 5;
const HEADER_PADDING_LEFT: number = 9;
const HEADER_PADDING_TOP: number = 8;
const HEADER_PADDING_RIGHT_TV: number = 7;
const HEADER_PADDING_LEFT_TV: number = 12;
const HEADER_PADDING_TOP_TV: number = 11;

interface ParamAlbumInfo {
  item: string;
  isFromFACard?: boolean;
}

export enum SideBarType {
  SYS,
  TIMELINE,
  PHOTO,
  VIDEO,
  FAVORITE,
  CLOUD_ENHANCEMENT,
  CAMERA,
  SCREEN_SHOT,
  SCREEN_RECORDING,
  HIGHLIGHT,
  HIDDEN,
  RECYCLE,

  SMART,
  PORTRAIT,
  CLASSIFICATION,
  SHOOTING,

  SOURCE,
  USER,
}

const CACHED_COUNT: number = 5;
const CAN_RENAME_COUNT: number = 1;

export interface HeaderStyle {
  label?: string | Resource;
  onclick?: Function;
  getAngle?: Function;
  sideBarType?: SideBarType;
}

interface DragAnimate {
  animateIndex: number;
  placeBeforeIndex: number;
}

// 无法复用AlbumInfo考虑构造，PhotoGridView依赖AlbumInfo数据
@Observed
export class CustomItem {
  public label?: string | Resource;
  public count?: number;
}

@Extend(List)
function listStyle() {
  .scrollBar(BarState.Off)
  .backgroundColor(Color.Transparent)
  .alignListItem(ListItemAlign.Center)
  .borderRadius(DeviceInfo.isPc() ? 0 : $r('sys.float.ohos_id_corner_radius_card'))
  .padding({
    left: $r('sys.float.padding_level2'),
    right: $r('sys.float.padding_level2'),
    top: 0,
    bottom: 0,
  })
  .zIndex(0)
  .clip(false)
  .edgeEffect(EdgeEffect.None)
}

export class SysAlbumsCounter {
  public hasPhotos: 0 | 1 = 0;
  public hasVideos: 0 | 1 = 0;
  public hasFavorite: 0 | 1 = 0;
  public hasCloudEnhance: 0 | 1 = 0;

  public setHasPhoto(count: 0 | 1) {
    this.hasPhotos = count;
  }

  public setHasVideos(count: 0 | 1) {
    this.hasVideos = count;
  }

  public setHasFavorite(count: 0 | 1) {
    this.hasFavorite = count;
  }

  public setHasCloudEnhance(count: 0 | 1) {
    this.hasCloudEnhance = count;
  }

  public getAlbumsCount(): number {
    return this.hasPhotos + this.hasVideos + this.hasFavorite + this.hasCloudEnhance;
  }
}

export interface SideBarItemClickListener {
  onSideBarItemClick: (sideBarIndex: number) => void;
}

@Component
export struct SideBar {
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  // datasource
  private albums: AlbumSetDataSource = AlbumSetDataSourceManager.getInstance().getDataSource();
  private albumDataImpl: BrowserDataInterface | undefined;
  private sourceTypeAlbums: SourceTypeAlbumDataSource =
    new SourceTypeAlbumDataSource(getContext(this), SOURCE_ALBUM_MIN_COUNT, new BroadCast());
  @Provide private broadCast: BroadCast = AlbumSetDataSourceManager.getInstance().getBroadCast();
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  private isAlbumSetDsActive: boolean = false;
  // show control
  @State private isShowAlbumNewBtn: boolean = false;
  @State private isShowUserAlbumList: boolean = true;
  @State private isShowSmartAlbumList: boolean = true;
  @State private isShowSourceAlbumList: boolean = true;
  @Link private isShowHiddenGridView: boolean;
  @Link private isShowTimelinePage: boolean;
  @Link private isShowPhotoHiddenView: boolean;
  @Link private isShowPhotoClassifieds: boolean;
  @Link private isShowPhotoShooting: boolean;
  @Link private isShowPortraitAlbumsView: boolean;
  @Link private navigationPageInfos: NavPathStack;
  private isShowHighlightView: boolean = false;
  @StorageLink('isPhotoGridFocused') isPhotoGridFocused: boolean = false;
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  // menu list
  @Provide private operationMenuList: Action[] = [];
  @State private operationMenuListSystem: RightClickMenuGroup[] = [];
  @State private operationMenuListPC: RightClickMenuGroup[] = [];
  // dialog
  private deleteDialogIndex: number = 1;
  // sys item
  private sysAlbumsCounter: SysAlbumsCounter = new SysAlbumsCounter();
  public albumMSelectManage: AlbumSetSelectManager = new AlbumSetSelectManager();
  @State private isImageGridDragging: boolean = false;
  @State private sysAlbumsCount: number = 0;
  @State private sysAlbumsMap: Map<SideBarType, AlbumInfo | CustomItem> =
    new Map<SideBarType, AlbumInfo | CustomItem>();
  private iconMap: Map<SideBarType, Resource> =
    new Map<SideBarType, Resource>([
      [SideBarType.TIMELINE, $r('sys.symbol.picture')],
      [SideBarType.PHOTO, $r('sys.symbol.picture_on_square_1')],
      [SideBarType.VIDEO, $r('sys.symbol.video')],
      [SideBarType.FAVORITE, $r('sys.symbol.heart')],
      [SideBarType.CLOUD_ENHANCEMENT, $r('sys.symbol.AI_wand_stars_and_cloud')],
      [SideBarType.HIDDEN, $r('sys.symbol.eye_slash')],
      [SideBarType.RECYCLE, $r('sys.symbol.trash')],
      [SideBarType.USER, $r('sys.symbol.rectangle_on_rectangle')],
      [SideBarType.PORTRAIT, $r('sys.symbol.person')],
      [SideBarType.CLASSIFICATION, $r('sys.symbol.square_grid_2x2')],
      [SideBarType.SHOOTING, $r('sys.symbol.satellite_map')],
      [SideBarType.CAMERA, $r('sys.symbol.camera')],
      [SideBarType.SCREEN_SHOT, $r('sys.symbol.rectangle_and_cut')],
      [SideBarType.SCREEN_RECORDING, $r('sys.symbol.dot_video')],
    ]);
  private iconFillMap: Map<SideBarType, Resource> =
    new Map<SideBarType, Resource>([
      [SideBarType.TIMELINE, $r('sys.symbol.picture_fill')],
      [SideBarType.PHOTO, $r('sys.symbol.picture_on_square')],
      [SideBarType.VIDEO, $r('sys.symbol.video_fill')],
      [SideBarType.FAVORITE, $r('sys.symbol.heart_fill')],
      [SideBarType.CLOUD_ENHANCEMENT, $r('sys.symbol.AI_wand_stars_and_cloud')],
      [SideBarType.HIGHLIGHT, $r('sys.symbol.heart_square_stack_fill')],
      [SideBarType.HIDDEN, $r('sys.symbol.eye_slash')],
      [SideBarType.RECYCLE, $r('sys.symbol.trash_fill')],
      [SideBarType.USER, $r('sys.symbol.rectangle_on_rectangle_fill')],
      [SideBarType.PORTRAIT, $r('sys.symbol.person_fill')],
      [SideBarType.CLASSIFICATION, $r('sys.symbol.square_fill_grid_2x2')],
      [SideBarType.SHOOTING, $r('sys.symbol.satellite_map_fill')],
      [SideBarType.CAMERA, $r('sys.symbol.camera_fill')],
      [SideBarType.SCREEN_SHOT, $r('sys.symbol.rectangle_and_cut')],
      [SideBarType.SCREEN_RECORDING, $r('sys.symbol.dot_video_fill')],
    ]);
  private systemSourceLpathMap: Map<string, SideBarType> =
    new Map<string, SideBarType>([
      [Constants.LPATH_CAMERA, SideBarType.CAMERA],
      [Constants.LPATH_SCREEN_SHOT, SideBarType.SCREEN_SHOT],
      [Constants.LPATH_SCREEN_RECORDING, SideBarType.SCREEN_RECORDING],
    ]);
  // item index
  @State private sysAlbumsKeys: SideBarType[] = DeviceInfo.isTablet() || DeviceInfo.isGRLFoldScreen() ?
    [SideBarType.TIMELINE, SideBarType.PHOTO, SideBarType.VIDEO,
      SideBarType.FAVORITE, SideBarType.HIGHLIGHT, SideBarType.HIDDEN, SideBarType.RECYCLE] :
    (DeviceInfo.isTv() ? [SideBarType.TIMELINE, SideBarType.PHOTO, SideBarType.VIDEO, SideBarType.RECYCLE] :
      [SideBarType.TIMELINE, SideBarType.PHOTO, SideBarType.VIDEO,
        SideBarType.FAVORITE, SideBarType.HIDDEN, SideBarType.RECYCLE]);
  // +1是我的相册的expandHeader占了1
  @State private sysListTokenUpCount: number = this.sysAlbumsKeys.length + 1;
  @State private currentIndex: number = this.sysAlbumsKeys[0];
  @State private focusIndex: number = -1;
  @State @Watch('updateOperationMenuList') private userIndexSelected: Set<number> = new Set();
  @State albumBroadCast: BroadCast = new BroadCast();
  private savedIndex: number = -1;
  @State private isFreezeSelected: boolean = false;
  @State private isFreezeAlbumInfoChanged: boolean = false;
  private userAlbumInitialIndex = 100;
  // item index - for tablet new album picker situation
  private newCreatedAlbumIndex: number = -1;
  private newCreatedAlbumInitIndex: number = -1;
  // state for animation
  @State private isSideBarItemAniOpen: boolean = false;
  // params for drag
  @State private hasStartDrag: boolean = false;
  @State private translateArr: number[] = []; // 移位动效
  private dragItemNeedBack: boolean = false;
  private dragItemIsShow: boolean = false;
  private canDrag: boolean = true;
  private change2Rebuild: boolean = false;
  // params for smart albums
  @State private sourceCounts: number = this.sourceTypeAlbums.totalCount();
  @State private isShowPortraitEntry: boolean = false;
  // for SearchBlock SearchActionBar
  @Link private isSearchBarFocused: boolean;
  @Link @Watch('watchIsShowSearchPage') public isShowSearchPage: boolean;
  @Link private photoSearchWord: string;
  @Link private displaySearchWords: string;
  // for SearchBlock SearchMenu
  @Link searchHistoryClearOnSubmit: number;
  @Link photoHistoryWordClicked: string;
  // func
  private selectItemFunc: Function = (index: number, isRightClick?: boolean): void =>
  this.selectItem(index, isRightClick);
  private onDataReloadedCallbackFunc: Function = (): void => this.onDataReloadedCallback();
  private onPickerOperationFunc: Function = (displayName: string, albumUri: string, completedFunc?: Function): void =>
  this.onPickerOperation(displayName, albumUri, completedFunc);
  private onPickerOperationBackToNewAlbumFunc: Function = (): void => this.onPickerOperationBackToNewAlbum();
  private onMenuClickedForSingleItemFunc: Function = (action: Action, currentAlbum: AlbumInfo, index: number): void =>
  this.onMenuClickedForSingleItem(action, currentAlbum, index);
  private onOperationStartFunc: Function = (): void => this.onOperationStart();
  private switchItemAutoFunc: Function =
    (album: AlbumInfo, actionID: number): void => this.switchItemAuto(album, actionID);
  // inLine creating new and rename album
  @State private isCreatingNewAlbum: boolean = false;
  @State private isRenamingAlbum: boolean = false;
  private isDeferCreatingNewAlbum: boolean = false;
  // delete
  // animate
  static readonly SIDEBAR_ITEM_MOVE_ANIMATE_TIME = 300;
  static readonly OPEN_VIEW_ANIMATE_TIME = 350;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private readonly sourceAlbumListener: LoadingListener = {
    onDataLoadingFinished: () => this.onSourceAlbumLoadingFinished(),
    onSizeLoadingFinished: () => {
    },
    onDataChanged: (dataIndex: number) => {
    },
  } as LoadingListener;
  @State albumNextBtnBgColor: ResourceColor = Color.Transparent;
  @State private dragEnterIndex: number = -1;
  private insertIndex: number = -1;
  private insertIndexBefore: number = -1;
  @Link private searchKeyword: string;
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  private readonly onClickHideAlbumEventFunc: Function = (): void => this.isAccessHideAlbum();
  private readonly onClickBackToFirstAlbumEventFunc: Function = (): void => this.onClickBackToFirstAlbum();
  private onPcQuitSearchMainPageFunc: Function = (): void => this.onPcQuitSearchMainPage();
  @State isRTL: boolean = false;
  @StorageLink('windowFocused') private isWindowFocused: boolean = true;
  private sideBarItemClickListener: SideBarItemClickListener = {
    onSideBarItemClick: (sideBarIndex: number) => {
    },
  };
  private saveDialogController?: CustomDialogController;
  // @Consume browserController: PhotosHmBrowserController;
  // 是否显示侧边栏
  @LocalStorageLink('isShowSideBar') isShowSideBar: boolean = true;
  //‘已选择*项’组件是否显示
  @LocalStorageLink('isSelectionTitle') isSelectionTitle: boolean = true;
  private isRequestFocus: boolean = true;
  private onSetNewAlbumFocusStateFunc: Function =
    (isRequestFocus: boolean): void => this.onSetNewAlbumFocusState(isRequestFocus);
  private componentSnapper: ComponentSnapshot | undefined = undefined;
  private dragEnterable: boolean = true;
  private albumMenuController: UserSideBarMenuController = new UserSideBarMenuController();
  private albumSystemMenuController: SystemSideBarMenuController = new SystemSideBarMenuController();
  // 侧边栏宽度
  @Link sideBarWidth: number;

  private onPageChanged(): void {
    Log.info(TAG, `onPageChanged ${this.pageStatus}`);
    if (this.pageStatus) {
      this.onActive();
    } else {
      this.onInActive();
    }
  }

  private onDataReloadedCallback(): void {
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 30),
    }, (): void => {
      this.albums.onDataReloaded();
      this.updateSysAlbumMap();
    });
  }

  private onSetNewAlbumFocusState(isRequestFocus: boolean): void {
    this.isRequestFocus = isRequestFocus;
  }

  private deSelect(isCreatingNewAlbum: boolean): void {
    if (isCreatingNewAlbum) {
      this.savedIndex = this.currentIndex;
      this.currentIndex = -1;
      SideBarVariables.isSideBarDeselected = true;
    } else {
      this.currentIndex = this.savedIndex;
    }
    Log.info(TAG, `deSelect true savedIndex ${this.savedIndex}`);
  }

  private checkIsSmartAlbumFromGRL(): boolean {
    if (LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_IS_KEEP_CLASSIFIED)) {
      Log.info(TAG, 'classified is keep status');
      this.isShowPhotoClassifieds = true;
      this.currentIndex = SideBarType.CLASSIFICATION;
      return true;
    }
    if (LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_IS_KEEP_SHOOTING)) {
      Log.info(TAG, 'shoot is keep status');
      this.isShowPhotoShooting = true;
      this.currentIndex = SideBarType.SHOOTING;
      return true;
    }
    if (LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_PORTRAIT_ENTRY)) {
      Log.info(TAG, 'portrait is keep status');
      this.isShowPortraitAlbumsView = true;
      AppStorage.setOrCreate(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);
      this.currentIndex = SideBarType.PORTRAIT;
      return true;
    }
    if (LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_RECOVER_HIGHLIGHT)) {
      if (DeviceInfo.isGRLFoldScreen()) {
        this.currentIndex = SideBarType.HIGHLIGHT;
        return true;
      }
    }
    if (LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_HIDDEN_ENTRY)) {
      this.isShowPhotoHiddenView = true;
      this.currentIndex = -1;
      return true;
    }
    if (LocalStorage.getShared()?.get(Constants.APP_KEY_GRL_KEEP_SEARCH)) {
      Log.info(TAG, 'search page is keep status');
      this.currentIndex = SideBarType.TIMELINE;
      return true;
    }
    if (this.isShowTimelinePage) {
      this.currentIndex = SideBarType.TIMELINE;
      return true;
    }
    return false;
  }

  private changeCurrentIndexFromPhoneView(gridKeyIndex: number | undefined, param: ParamAlbumInfo): boolean {
    if (!param.item) {
      return false;
    }
    let albumInfo = JSON.parse(param.item) as AlbumInfo;
    if (!albumInfo) {
      return false;
    }
    let oldIndex = this.currentIndex;
    if (gridKeyIndex === -1 && albumInfo.subType !== photoAccessHelper.AlbumSubtype.TRASH) {
      this.currentIndex = SideBarType.TIMELINE;
      return true;
    }
    switch (albumInfo.subType) {
      case photoAccessHelper.AlbumSubtype.IMAGE:
        this.currentIndex = SideBarType.PHOTO;
        break;
      case photoAccessHelper.AlbumSubtype.VIDEO:
        this.currentIndex = SideBarType.VIDEO;
        break;
      case photoAccessHelper.AlbumSubtype.FAVORITE:
        this.currentIndex = SideBarType.FAVORITE;
        break;
      case photoAccessHelper.AlbumSubtype.TRASH:
        this.currentIndex = SideBarType.RECYCLE;
        break;
      case photoAccessHelper.AlbumSubtype.HIDDEN:
        this.currentIndex = SideBarType.HIDDEN;
        break;
      default:
        break;
    }
    if (albumInfo.lpath === Constants.LPATH_SCREEN_RECORDING) {
      this.currentIndex = SideBarType.SCREEN_RECORDING;
    }
    if (albumInfo.lpath === Constants.LPATH_SCREEN_SHOT) {
      this.currentIndex = SideBarType.SCREEN_SHOT;
    }
    if (albumInfo.lpath === Constants.LPATH_CAMERA) {
      this.currentIndex = SideBarType.CAMERA;
    }
    if (albumInfo && albumInfo.isSourceAlbum && !albumInfo.isSystemAlbum && gridKeyIndex !== undefined) {
      this.currentIndex = gridKeyIndex + SideBarType.SOURCE;
    }
    if (albumInfo && albumInfo.isUserCreatedAlbum && !albumInfo.isSystemAlbum && gridKeyIndex !== undefined) {
      this.currentIndex = gridKeyIndex + this.userAlbumInitialIndex;
    }
    return oldIndex !== this.currentIndex;
  }

  private processGRLContinue(): void {
    Log.info(TAG, `processGRLContinue time = ${this.isShowTimelinePage}`);
    if (this.checkIsSmartAlbumFromGRL()) {
      return;
    }
    let gridKeyIndex = AppStorage.get<number>(Constants.KEY_OF_SELECTED_ALBUM_INDEX);
    let param = AppStorage.get<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
    Log.info(TAG, `processGRLContinue albumIndex = ${gridKeyIndex}, albumItem = ${JSON.stringify(param)}`);
    if (!param) {
      return;
    }
    if (!this.changeCurrentIndexFromPhoneView(gridKeyIndex, param)) {
      Log.info(TAG, `recoverSideBarIndex = ${LocalStorage.getShared()?.get<number>(
        Constants.APP_KEY_GRL_RECOVER_SIDEBAR_INDEX)}`);
      this.currentIndex = LocalStorage.getShared()?.get<number>(
        Constants.APP_KEY_GRL_RECOVER_SIDEBAR_INDEX) ?? SideBarType.TIMELINE;
    }
  }

  private isAccessHideAlbum(): void {
    this.currentIndex = SideBarType.HIDDEN;
  }

  private onClickBackToFirstAlbum(): void {
    Log.error(TAG, `onClickBackToFirstAlbum ${this.sysAlbumsKeys}`);
    this.currentIndex = this.sysAlbumsKeys[0];
  }

  private onWinSizeChangedFunc: Function = (): void => {
    this.hasStartDrag = false;
    this.dragItemNeedBack = true;
  }

  aboutToAppear(): void {
    this.albums.setBlackUriList([
      UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE),
      UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE),
      UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE),
    ]);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    getScreen().on(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onWinSizeChangedFunc);
    getContext()?.eventHub.on(BroadCastConstants.ACCESS_HIDE_ALBUM_PAD, this.onClickHideAlbumEventFunc);
    getContext()?.eventHub.on(BroadCastConstants.BACK_TO_FIRST_ALBUM_PAD_AND_PC, this.onClickBackToFirstAlbumEventFunc);
    this.albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
    this.initOperationMenu();
    // customItem初始化，无数据也显示系统栏
    this.initSysAlbumsMap();
    this.updateSysAlbumMap();

    this.initDataSource();

    this.updateOperationMenuList();

    this.registerBroadcast();

    this.onActive();

    this.currentLanguage = i18n.System.getSystemLanguage();
    this.onLanguageChange();

    this.updateSelectedIndex();
    this.componentSnapper = this.getUIContext().getComponentSnapshot();

    setTimeout((): void => {
      if (!this.isShowAlbumNewBtn) {
        this.isShowAlbumNewBtn = true;
      }
    }, 100);

    // 悬浮窗返回全屏模式 时刻sidebar保持
    this.currentIndex = this.isShowHighlightView ? SideBarType.HIGHLIGHT : this.currentIndex;
    if (DeviceInfo.isGRLFoldScreen()) {
      this.processGRLContinue();
      if (this.currentIndex === SideBarType.TIMELINE) {
        this.isShowTimelinePage = true;
        AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);
      }
    }
  }

  aboutToDisappear(): void {
    this.albums.clearBlackUriList();
    this.unregisterBroadcast();
    this.saveDialogController = undefined;
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    getScreen().off(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onWinSizeChangedFunc);
    getContext()?.eventHub.off(BroadCastConstants.ACCESS_HIDE_ALBUM_PAD, this.onClickHideAlbumEventFunc);
    getContext()?.eventHub.off(BroadCastConstants.BACK_TO_FIRST_ALBUM_PAD_AND_PC,
      this.onClickBackToFirstAlbumEventFunc);
    if (DeviceInfo.isGRLFoldScreen()) {
      if (this.isShowTimelinePage) {
        AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);
      }
      LocalStorage.getShared()?.setOrCreate<number>(Constants.APP_KEY_GRL_RECOVER_SIDEBAR_INDEX, this.currentIndex);
    }
  }

  private onLanguageChange(): void {
    if (this.currentLanguage) {
      this.isRTL = DeviceInfo.isPc() && i18n.isRTL(this.currentLanguage);
    }
  }

  private initDataSource(): void {
    this.sourceTypeAlbums.initialize();
    this.sourceTypeAlbums.registerAlbumObserver();
  }

  private registerBroadcast(): void {
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedCallbackFunc);
    this.broadCast.on(BroadCastConstants.SET_BLACK_URI_LIST, (): void => {
      this.isFreezeAlbumInfoChanged = true;
    });
    this.broadCast.on(BroadCastConstants.CLEAR_BLACK_URI_LIST, (): void => {
      this.isFreezeAlbumInfoChanged = false;
    });
    if (!DeviceInfo.isPc()) {
      this.broadCast.on(BroadCastConstants.PICKER_OPERATION, this.onPickerOperationFunc);
      this.navigationBroadCast.on(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_NEW_ALBUM,
        this.onPickerOperationBackToNewAlbumFunc);
    }
    this.broadCast.on(BroadCastConstants.SIDEBAR_VIEW_SWITCH, this.switchItemAutoFunc);
    this.sourceTypeAlbums.addLoadingListener(this.sourceAlbumListener);
    this.broadCast.on(BroadCastConstants.UPDATE_SYS_ALBUM_MAP, this.updateSysAlbumMapFunc);
    this.appBroadCast.on(BroadCastConstants.PC_SET_NEW_ALBUM_FOCUS_STATE_OPERATION, this.onSetNewAlbumFocusStateFunc);
  }

  private unregisterBroadcast(): void {
    this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadedCallbackFunc);
    this.broadCast.off(BroadCastConstants.SET_BLACK_URI_LIST, (): void => {
      this.isFreezeAlbumInfoChanged = true;
    });
    this.broadCast.off(BroadCastConstants.CLEAR_BLACK_URI_LIST, (): void => {
      this.isFreezeAlbumInfoChanged = false;
    });
    if (!DeviceInfo.isPc()) {
      this.broadCast.off(BroadCastConstants.PICKER_OPERATION, this.onPickerOperationFunc);
      this.navigationBroadCast.off(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_NEW_ALBUM,
        this.onPickerOperationBackToNewAlbumFunc);
    }
    this.broadCast.off(BroadCastConstants.SIDEBAR_VIEW_SWITCH, this.switchItemAutoFunc);
    this.sourceTypeAlbums.removeLoadingListener(this.sourceAlbumListener);
    this.sourceTypeAlbums?.unregisterAlbumObserver();
    this.broadCast.off(BroadCastConstants.UPDATE_SYS_ALBUM_MAP, this.updateSysAlbumMapFunc);
    this.appBroadCast.off(BroadCastConstants.PC_SET_NEW_ALBUM_FOCUS_STATE_OPERATION, this.onSetNewAlbumFocusStateFunc);
    this.appBroadCast.off(BroadCastConstants.QUIT_SEARCH_MAIN_PAGE, this.onPcQuitSearchMainPageFunc);
  }

  private onActive(): void {
    this.isAlbumSetDsActive = true;
    Log.info(TAG, 'onActive');
    if (DeviceInfo.isGRLFoldScreen()) {
      setTimeout(() => {
        this.albums.resume();
      }, Constants.DELAY_HALF_SECOND);
    } else {
      this.albums.resume();
    }
    this.sourceTypeAlbums.onActive();
  }

  private onInActive(): void {
    this.isAlbumSetDsActive = false;
    Log.info(TAG, 'onInActive');
    this.albums.pause();
    this.sourceTypeAlbums.onInActive();
  }

  onPickerOperation(displayName: string, albumUri: string, completedFunc?: Function) {
    // Log.info(TAG,
    //   `onPickerOperation, albumName: ${AlbumDefine.getAnonymizeAlbumName(displayName)}, albumUri: ${albumUri}`);
    // const params: SelectParams = new SelectParams();
    // params.bundleName = Constants.PHOTO_BUNDLE_NAME;
    // params.isMultiPick = true;
    // params.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_ALL;
    // params.isFirstEnter = true;
    // params.maxSelectCount = Constants.LIMIT_MAX_THIRD_SELECT_COUNT;
    // params.uri = '';
    // params.cameraAble = false;
    // params.editAble = false;
    // params.albumName = displayName;
    // params.albumUri = albumUri;
    // params.isNewAlbum = true;
    // params.isFromAlbumSetPage = true;
    // this.navigationBroadCast.emitAsync(
    //   NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_PICKER_BASE_PAGE]).then(() => {
    //   this?.navigationPageInfos?.pushPath(
    //     new NavPathInfo(NavigationConstants.NAVIGATION_PICKER_BASE_PAGE, params), false);
    //   completedFunc?.();
    // });
  }

  private onPickerOperationBackToNewAlbum(): void {
    Log.info(TAG, 'onPickerOperationBackToNewAlbum');
    this.selectItem(this.userAlbumInitialIndex + this.newCreatedAlbumIndex);
    this.newCreatedAlbumIndex = -1;
  }

  private async initSysAlbumsMap(): Promise<void> {
    this.sysAlbumsMap.set(SideBarType.TIMELINE, this.getCustomItem($r('app.string.pictures_and_videos')));
    this.sysAlbumsMap.set(SideBarType.PHOTO, this.getCustomItem($r('app.string.album_photos')));
    this.sysAlbumsMap.set(SideBarType.VIDEO, this.getCustomItem($r('app.string.album_video')));
    this.sysAlbumsMap.set(SideBarType.FAVORITE, this.getCustomItem($r('app.string.album_favor')));
    this.sysAlbumsMap.set(SideBarType.CLOUD_ENHANCEMENT,
      this.getCustomItem($r('app.string.album_cloud_enhance')));
    this.sysAlbumsMap.set(SideBarType.HIGHLIGHT, this.getCustomItem($r('app.string.tab_highlights')));
    this.sysAlbumsMap.set(SideBarType.HIDDEN, this.getCustomItem($r('app.string.hidden_album')));
    this.sysAlbumsMap.set(SideBarType.RECYCLE, this.getCustomItem($r('app.string.album_recycle')));
  }

  private updateSysAlbumMapFunc: Function = (): Promise<void> => this.updateSysAlbumMap();

  private async updateSysAlbumMap() {
    Log.info(TAG, 'update SysAlbum SideBar MediaData');
    this.getTimelineCustomItem().then((custom: CustomItem): void => {
      this.sysAlbumsMap.set(SideBarType.TIMELINE, custom);
    });
    this.getPhotoAlbum().then((album: AlbumInfo | undefined): void => {
      if (album) {
        this.sysAlbumsCounter.setHasPhoto(album.count > 0 ? 1 : 0);
        this.sysAlbumsCount = this.sysAlbumsCounter.getAlbumsCount();
        this.sysAlbumsMap.set(SideBarType.PHOTO, album);
      }
    });
    this.getVideoAlbum().then((album: AlbumInfo | undefined): void => {
      if (album) {
        this.sysAlbumsCounter.setHasVideos(album.count > 0 ? 1 : 0);
        this.sysAlbumsCount = this.sysAlbumsCounter.getAlbumsCount();
        this.sysAlbumsMap.set(SideBarType.VIDEO, album);
      }
    });
    this.getFavouriteAlbum().then((album: AlbumInfo | undefined): void => {
      if (album) {
        this.sysAlbumsCounter.setHasFavorite(album.count > 0 ? 1 : 0);
        this.sysAlbumsCount = this.sysAlbumsCounter.getAlbumsCount();
        this.sysAlbumsMap.set(SideBarType.FAVORITE, album);
      }
    });

    this.getHiddenAlbum().then((album: AlbumInfo | undefined): void => {
      if (album) {
        this.sysAlbumsMap.set(SideBarType.HIDDEN, album);
      } else {
        this.sysAlbumsMap.set(SideBarType.HIDDEN, this.getCustomItem($r('app.string.hidden_album')));
      }
    });
    this.getRecycleAlbum().then((album: AlbumInfo | undefined): void => {
      if (album) {
        this.sysAlbumsMap.set(SideBarType.RECYCLE, album);
      }
    });
    if (!DeviceInfo.isPc()) {
      this.setSystemSourceAfterFavorite();
    }
  }

  /**
   * 在我的收藏相册后面更新系统来源相册
   */
  private setSystemSourceAfterFavorite(): void {
    let idxOfAdd: number = this.sysAlbumsKeys.indexOf(DeviceInfo.isTv() ? SideBarType.VIDEO : SideBarType.FAVORITE);
    if (idxOfAdd === -1) {
      return;
    }

    this.getSystemSourceAlbums().then((albums: AlbumInfo[]): void => {
      let idxOfCloud: number = this.sysAlbumsKeys.indexOf(SideBarType.CLOUD_ENHANCEMENT);
      if (idxOfCloud !== -1) {
        idxOfAdd++;
      }

      // 将媒体库查询出的系统来源相册转换为key为lpath值为album的map
      let lpathInDbMap: Map<string, AlbumInfo> = new Map();
      for (let album of albums) {
        if (album.lpath !== undefined) {
          lpathInDbMap.set(album.lpath, album);
        }
      }

      // 遍历相机、截图、录屏三个系统来源相册
      for (let lpath of UserFileManagerAccess.SYSTEM_SOURCE_ALBUM_LPATH_LIST) {
        let sideBarType: SideBarType | undefined = this.systemSourceLpathMap.get(lpath);
        if (sideBarType === undefined) {
          continue;
        }
        let albumInDb: AlbumInfo | undefined = lpathInDbMap.get(lpath);
        if (albumInDb !== undefined) {
          // 如果在媒体库中存在，将其添加到左侧边栏中
          idxOfAdd++;
          this.sysAlbumsMap.set(sideBarType, albumInDb);
          if (!this.sysAlbumsKeys.includes(sideBarType)) {
            this.sysAlbumsKeys.splice(idxOfAdd, 0, sideBarType);
          }
        } else {
          // 如果在媒体库中不存在，但是左侧边栏中存在，将其剔除
          let idx: number = this.sysAlbumsKeys.indexOf(sideBarType);
          if (idx !== -1) {
            this.sysAlbumsKeys.splice(idx, 1);
          }
        }
      }
      this.sysListTokenUpCount = this.sysAlbumsKeys.length + 1;
    });
  }

  build() {
    Stack() {
      Column() {
        this.SideBarHead();
        List() {
          // 普通相册
          ForEach(this.sysAlbumsKeys, (sideBarType: SideBarType, index: number): void => {
            this.systemAlbumListItem(sideBarType, index);
          })
          if (!DeviceInfo.isTv()) {
            // 我的相册 用户自建相册 新建相册
            ListItem() {
              this.expandHeader(this.getHeaderStyle(SideBarType.USER));
            }

            if (this.isShowUserAlbumList) {
              this.userSideBarList();
              if (this.isShowAlbumNewBtn) {
                this.albumNewBtn();
              }
            }
          }
          // 来源相册
          if (this.sourceCounts > 0) {
            ListItem() {
              this.expandHeader(this.getHeaderStyle(SideBarType.SOURCE));
            }
            .width(DeviceInfo.isTv() ? $r('app.float.tv_sidebar_item_width') : undefined)

            if (this.isShowSourceAlbumList) {
              LazyForEach(this.sourceTypeAlbums, (item: AlbumSetDataInfo, index: number) => {
                ListItem() {
                  this.sourceAlbumItem(item, index);
                }
                .width(DeviceInfo.isTv() ? $r('app.float.tv_sidebar_item_width') : undefined)
                .selected(this.currentIndex === (SideBarType.SOURCE + index))
                .listItemStyle()
              }, (item: AlbumSetDataInfo, index?: number): string => this.generateItemKey(item, index))
            }
          }
        }
        .onFocus(() => {
          this.isPhotoGridFocused = false;
        })
        .scrollBar(BarState.Auto)
        .height(`calc(100% - ${DeviceInfo.isPc() ? Constants.WindowDecorHeight : Constants.ActionBarHeight}vp)`)
        .align(Alignment.Top)
        .clip(true)
        .edgeEffect(EdgeEffect.Spring)
        .margin({
          top: DeviceInfo.isTablet() ? 8 : 0,
          left: DeviceInfo.isTv() ? 0 : $r('sys.float.padding_level2'),
          right: DeviceInfo.isTv() ? 0 : $r('sys.float.padding_level2'),
        })
        .tabIndex(IndexFocusOrder.SIDEBAR)
        .backgroundColor(Color.Transparent)
        .alignListItem(ListItemAlign.Center)
        .borderRadius(DeviceInfo.isPc() ? 0 : $r('sys.float.ohos_id_corner_radius_card'))
        .padding({
          left: DeviceInfo.isTv() ? 0 : $r('sys.float.padding_level6'),
          right: DeviceInfo.isTv() ? 0 : $r('sys.float.padding_level6'),
          bottom: DeviceInfo.isTv() ? 0 : $r('sys.float.padding_level2'),
        })
        .cachedCount(CACHED_COUNT)
        .fadingEdge(DeviceInfo.isTv(),
          { fadingEdgeLength: LengthMetrics.resource($r('app.float.tv_fade_edge_length')) })
      }

      CustomDialogView({ broadCast: $broadCast, deleteDialogIndex: this.deleteDialogIndex })
    }
    .focusScopeId('photo_SideBar_id', true, false)
    .focusable(this.isShowSideBar)
    .alignContent(Alignment.TopStart)
    .width('100%')
    .height('100%')
  }

  private checkIsUserIndex(itemIndex: number): boolean {
    return this.isShowUserAlbumList &&
      itemIndex >= this.sysListTokenUpCount &&
      itemIndex < this.sysListTokenUpCount + this.albums.getAlbumCount();
  }

  private getDragIndex(itemIndex: number): number {
    return itemIndex - this.sysListTokenUpCount;
  }

  private checkIsSystemAlbum(album: AlbumInfo): boolean {
    return album?.isSystemAlbum ?? false;
  }

  @Builder
  SideBarHead() {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Row() {
        Image($r('app.media.img_gallery_icon'))
          .height(Constants.ActionBarButtonHeight)
          .width(Constants.ActionBarButtonHeight)
          .borderRadius(ICON_RADIUS)
          .draggable(false)
        Text($r('app.string.app_name'))
          .fontSize(DeviceInfo.isPc() ? '31px' : 16)
          .maxFontScale(1)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .margin({
            left: this.isRTL ? 0 : TEXT_MARGIN,
            right: this.isRTL ? TEXT_MARGIN : 0,
          })
      }
      .opacity((this.isWindowFocused || !DeviceInfo.isPc()) ? 1 : $r('sys.float.ohos_id_alpha_disabled'))
      .width('100%')
      .height(Constants.WindowDecorHeight)
      .padding({
        left: this.isRTL ? 0 : Constants.ActionBarButtonHeight,
        right: this.isRTL ? Constants.ActionBarButtonHeight : 0,
      })
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .gesture(
        TapGesture({ count: 2 }).onAction((): void => {
          WindowUtil.handleWinTopBarToggle(getContext(this));
        })
      )
    } else {
      Column() {
      }
      .width('100%')
      .height(Constants.ActionBarHeight)
    }
  }

  @Styles
  listItemStyle() {
    .stateStyles({
      selected: {
        .backgroundColor(!DeviceInfo.isTv() && (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) ?
          $r('sys.color.comp_emphasize_tertiary') : undefined)
      },
      normal: {
        .backgroundColor(undefined)
      }
    })
  }

  @Builder
  systemAlbumListItem(sideBarType: SideBarType, index: number) {
    ListItem() {
      Column() {
        NonUserAlbumSideBarItem({
          controller: this.albumSystemMenuController,
          item: this.sysAlbumsMap.get(sideBarType),
          icon: this.iconMap.get(sideBarType),
          fillIcon: this.iconFillMap.get(sideBarType),
          sideBarIndex: sideBarType,
          sideBarType: SideBarType.SYS,
          currentIndex: $currentIndex,
          isSelected: this.currentIndex === sideBarType,
          canContextMenuBind: sideBarType === SideBarType.RECYCLE,
          operationMenuListSystem: this.operationMenuListSystem,
          isFreezeSelected: this.isFreezeSelected,
          selectItem: this.selectItemFunc,
          index: index,
          onMenuClickedForSingleItem: this.onMenuClickedForSingleItemFunc,
          isShowHiddenGridView: this.isShowHiddenGridView,
          isShowSearchPage: this.isShowSearchPage,
          isShowTimelinePage: this.isShowTimelinePage,
          isShowPhotoHiddenView: this.isShowPhotoHiddenView,
          sideBarItemClickListener: this.sideBarItemClickListener,
          isShowPhotoClassifieds: this.isShowPhotoClassifieds,
          isShowPortraitAlbumsView: this.isShowPortraitAlbumsView,
          isShowPhotoShooting: this.isShowPhotoShooting,
          navigationPageInfos: this.navigationPageInfos,
          isImageGridDragging: this.isImageGridDragging,
          sideBarWidth: this.sideBarWidth
        })
      }
    }
    .selected(this.currentIndex === sideBarType)
    .listItemStyle()
    .margin({
      top: this.getListSpace(sideBarType, index),
    })
    .width(DeviceInfo.isTv() ? $r('app.float.tv_sidebar_item_width') : undefined)
  }

  private getIsExpand(sideBarType: SideBarType | undefined): boolean {
    Log.info(TAG, `getIsExpand sideBarType ${sideBarType}`);
    if (!sideBarType) {
      return false;
    }
    if (sideBarType === SideBarType.USER) {
      return this.isShowUserAlbumList;
    } else if (sideBarType === SideBarType.SMART) {
      return this.isShowSmartAlbumList;
    } else if (sideBarType === SideBarType.SOURCE) {
      return this.isShowSourceAlbumList;
    }
    return false;
  }

  private getListSpace(sideBarType: SideBarType, index: number): number {
    if ((DeviceInfo.isPc() || DeviceInfo.isTv()) && index !== 0 && sideBarType !== SideBarType.HIDDEN) {
      return DeviceInfo.isPc() ? LIST_SPACE : TV_LIST_SPACE;
    }
    return 0;
  }

  @Builder
  expandHeader(headerStyle: HeaderStyle | undefined) {
    Row() {
      Text(headerStyle?.label)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize(DeviceInfo.isTv() ? 21 : $r('sys.float.ohos_id_text_size_body2'))
        .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
        .offset({ y: DeviceInfo.isTablet() ? 4 : 0 })

      Blank()

      ChevronArrow({
        isExpand: this.getIsExpand(headerStyle?.sideBarType),
        onClickFunc: () => {
          headerStyle?.onclick?.();
        },
      })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .padding(DeviceInfo.isTv() ?
      { left: HEADER_PADDING_LEFT_TV, right: HEADER_PADDING_RIGHT_TV, top: HEADER_PADDING_TOP_TV } :
      { left: HEADER_PADDING_LEFT, right: HEADER_PADDING_RIGHT, top: HEADER_PADDING_TOP })
    .height(DeviceInfo.isTv() ? Constants.SIDE_BAR_ITEM_HEIGHT_TV :
      (DeviceInfo.isPc() ? Constants.SIDE_BAR_ITEM_HEIGHT_PC : Constants.SIDE_BAR_ITEM_HEIGHT_TABLET))
    .justifyContent(FlexAlign.End)
    // 用于图片拖拽到我的相册标题，自动展开相册，请勿随意删除
    .allowDrop([])
    .onDrop((): void => {
    })
    .onDragEnter((event?: DragEvent, extraParams?: string): void => {
      if (headerStyle?.sideBarType === SideBarType.USER && !this.isShowUserAlbumList) {
        headerStyle?.onclick?.();
      }
    })
    .margin({
      top: DeviceInfo.isPc() ? HEADER_MARGIN_PC : 0,
    })
  }

  @Builder
  userAlbumContent() {
    List() {
      if (this.isShowUserAlbumList) {
        this.userSideBarList();
      }
    }
    .visibility(this.isShowUserAlbumList ? Visibility.Visible : Visibility.Hidden)
    .listStyle()

    if (this.isShowUserAlbumList) {
      this.albumNewBtn();
    }
  }

  private switchCurrentIndex(itemIndex: number, animateIndex: number): void {
    let dragAlbumIndex: number = this.userAlbumInitialIndex + itemIndex;
    let dragAlbumAnimateIndex: number = this.userAlbumInitialIndex + animateIndex;
    // dragItem is selected
    if (dragAlbumIndex === this.currentIndex) {
      this.dragUserIndexChange(dragAlbumAnimateIndex);
      this.currentIndex = dragAlbumAnimateIndex;
      return;
    }
    //  selectItem is before dragItem & dragItem move before selectItem
    if (this.currentIndex < dragAlbumIndex && dragAlbumAnimateIndex <= this.currentIndex) {
      this.dragUserIndexChange(this.currentIndex + 1);
      this.currentIndex = this.currentIndex + 1;
      return;
    }

    //  selectItem is after dragItem & dragItem move after selectItem
    if (this.currentIndex > dragAlbumIndex && dragAlbumAnimateIndex >= this.currentIndex) {
      this.dragUserIndexChange(this.currentIndex - 1);
      this.currentIndex = this.currentIndex - 1;
      return;
    }
  }

  private dragUserIndexChange(index: number) {
    this.userIndexSelected.clear();
    this.userIndexSelected.add(index);
  }

  private dataPrepareBeforeAnimate(itemIndex: number, animateIndex: number): void {
    animateTo({
      duration: 0,
    }, () => {
      this.change2Rebuild = !this.change2Rebuild;
      let addAlbum: AlbumInfo | undefined = this.albums.getAlbumByIndex(itemIndex);
      if (!addAlbum) {
        Log.error(TAG, `album null for ${itemIndex}`);
        addAlbum = new AlbumInfo();
      }
      this.albums.albums.splice(itemIndex, 1);
      this.albums.albums.splice(animateIndex, 0, addAlbum);
      this.albums.onDataReloaded();
    })
  }

  private doShiftAnimate(itemIndex: number, animateIndex: number, totalCount: number): void {
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 400, 38),
      duration: SideBar.SIDEBAR_ITEM_MOVE_ANIMATE_TIME,
    }, () => {
      for (let i = 0; i < totalCount; i++) {
        this.translateArr[i] = 0;
      }
    })
  }

  private releaseAlbumInfoCache(item: AlbumInfo): void {
    this.sourceTypeAlbums.releaseAlbumInfoItemCache(item);
  }

  @Builder
  userSideBarList() {
    LazyForEach(this.albums, (item: AlbumSetDataInfo, index: number): void => {
      if (item?.data && !this.checkIsSystemAlbum(item?.data)) {
        ListItem() {
          this.userSideBarItemBuilder(item, index);
        }
        .visibility(Visibility.Visible)
        .translate({ y: this.translateArr[index] ?? 0 })
        .onTouch((event: TouchEvent): void => {
          this.itemTouchEvent(event);
        })
        .selected(this.userAlbumInitialIndex + index === this.currentIndex)
        .listItemStyle()
        .margin({ bottom: $r('sys.float.padding_level1') })
        .clip(false)
        .onAppear(() => {
          if (!this.isShowAlbumNewBtn) {
            this.isShowAlbumNewBtn = true;
          }
        })
        .onAreaChange((oldVal: Area, newVal: Area) => {
          Log.info(TAG, `userSideBarList onAreaChange newVal: ${newVal.width}:${newVal.height}`);
        })
      } else {
        // lazyForEach下 空item; arr splice -> onDataReload -> lazyForEach item会为空
        ListItem()
          .visibility(Visibility.None)
      }
    }, (item: AlbumSetDataInfo, index?: number): string =>
    this.generateItemKey(item, index) + this.change2Rebuild + this.userIndexSelected.size)
  }

  @Builder
  userSideBarItemBuilder(item: AlbumSetDataInfo, index: number) {
    Column() {
      Column() {
        this.dragDivider();
      }
      .position({ y: 0 })
      .visibility(Visibility.Visible)
      .padding({
        left: 8,
      })

      SideBarItem({
        controller: this.albumMenuController,
        isNewCreated: this.isRequestFocus ? item.isNewCreated : false,
        albumSetDataInfo: item,
        item: item.data,
        icon: this.iconMap.get(SideBarType.USER),
        fillIcon: this.iconFillMap.get(SideBarType.USER),
        index: index,
        operationMenuListPC: this.operationMenuListPC,
        sideBarIndex: this.userAlbumInitialIndex + index,
        sideBarType: SideBarType.USER,
        sysAlbumsCount: this.sysAlbumsCount,
        isFreezeSelected: this.isFreezeSelected,
        isFreezeAlbumInfoChanged: this.isFreezeAlbumInfoChanged,
        switchItemAuto: (album: AlbumInfo, actionId: number): void => this.switchItemAuto(album, actionId),
        selectItem: this.selectItemFunc,
        deSelect: (isCreatingNewAlbum: boolean) => this.deSelect(isCreatingNewAlbum),
        isShowHiddenGridView: this.isShowHiddenGridView,
        isShowSearchPage: this.isShowSearchPage,
        currentIndex: this.currentIndex,
        canContextMenuBind: true,
        onMenuClickedForSingleItem: this.onMenuClickedForSingleItemFunc,
        createAlbumSetInlineRenameMenuOperation: this.createAlbumSetInlineRenameMenuOperation,
        isCreatingNewAlbum: this.isCreatingNewAlbum,
        onOperationStart: (): void => this.onOperationStart(),
        onOperationEnd: (): void => this.onOperationEnd(),
        isSideBarItemAniOpen: this.isSideBarItemAniOpen,
        hasStartDrag: this.hasStartDrag,
        dragEnterIndex: this.dragEnterIndex,
        isSelected: this.userIndexSelected.has(this.userAlbumInitialIndex + index),
        userAlbumInitialIndex: this.userAlbumInitialIndex,
        userIndexSelected: this.userIndexSelected,
        userSelectCount: this.userIndexSelected.size,
        isUserAlbumSelected: this.isUserAlbumSelected,
        sideBarItemClickListener: this.sideBarItemClickListener,
        resetIsNewCreated: (index: number): void => {
          this.resetIsNewCreated(index);
        },
        setIsRenamingAlbum: (isRenamingAlbum: boolean): void => {
          this.isRenamingAlbum = isRenamingAlbum;
        },
        sideBarWidth: this.sideBarWidth
      })
        .opacity(1)

      Column() {
        this.dragDivider();
      }
      .visibility(Visibility.Visible)
      .position({
        y: DeviceInfo.isPc() ? 39 : 47,
      })
      .padding({
        left: 8,
      })
    }
  }

  @Builder
  sourceAlbumContent() {
    // source album list
    List({ space: DeviceInfo.isPc() ? 2 : 0 }) {
      if (this.isShowSourceAlbumList) {
        LazyForEach(this.sourceTypeAlbums, (item: AlbumSetDataInfo, index: number) => {
          ListItem() {
            this.sourceAlbumItem(item, index);
          }
        }, (item: AlbumSetDataInfo, index?: number): string => this.generateItemKey(item, index))
      }
    }
    .visibility(this.isShowSourceAlbumList ? Visibility.Visible : Visibility.Hidden)
    .listStyle()
  }

  @Builder
  sourceAlbumItem(item: AlbumSetDataInfo, index: number) {
    Column() {
      SourceAlbumSideBarItem({
        albumSetDataInfo: item,
        item: item.data,
        index: index,
        sideBarIndex: SideBarType.SOURCE + index,
        currentIndex: this.currentIndex,
        isSelected: this.currentIndex === (SideBarType.SOURCE + index),
        isFreezeSelected: this.isFreezeSelected,
        selectItem: this.selectItemFunc,
        releaseAlbumInfoItemCache: (item: AlbumInfo): void => this.releaseAlbumInfoCache(item),
        isShowHiddenGridView: this.isShowHiddenGridView,
        isShowSearchPage: this.isShowSearchPage,
        isShowTimelinePage: this.isShowTimelinePage,
        isShowPhotoHiddenView: this.isShowPhotoHiddenView,
        sideBarItemClickListener: this.sideBarItemClickListener,
        isShowPhotoClassifieds: this.isShowPhotoClassifieds,
        isShowPortraitAlbumsView: this.isShowPortraitAlbumsView,
        isShowPhotoShooting: this.isShowPhotoShooting,
        navigationPageInfos: this.navigationPageInfos,
        sideBarWidth: this.sideBarWidth
      })
        .margin({
          top: this.getListSpace(SideBarType.SOURCE, index),
        })
    }
  }

  @Builder
  albumNewBtn() {
    // 新建相册
    ListItem() {
      Row() {
        Text($r('app.string.album_new_album_title'))
          .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
          .fontWeight(FontWeight.Medium)
          .focusable(true)
          .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
      }
      .width('100%')
      .height(DeviceInfo.isPc() ? Constants.SIDE_BAR_ITEM_HEIGHT_PC : Constants.SIDE_BAR_ITEM_HEIGHT_TABLET)
      .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level8'))
      .onHover((isHover: boolean): void => {
        this.albumNextBtnBgColor = isHover ? $r('sys.color.ohos_id_color_hover') : Color.Transparent
      })
      .backgroundColor(this.albumNextBtnBgColor)
      .padding({
        left: $r('sys.float.padding_level4'),
        right: $r('sys.float.padding_level6'),
      })
      .align(Alignment.Start)
      .onTouch((event: TouchEvent): void => {
        if (event.type === TouchType.Down) {
          this.albumNextBtnBgColor = $r('sys.color.ohos_id_color_click_effect');
        } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
          this.albumNextBtnBgColor = Color.Transparent;
        }
        this.canDrag = false;
      })
      .enabled(!(DeviceInfo.isPc() && this.isCreatingNewAlbum))
      .onClick((event: ClickEvent): void => {
        this.getUIContext()?.getFocusController()?.clearFocus();
        Log.info(TAG, `albumNewBtn: onClick: Start. isCreating ${this.isCreatingNewAlbum}`);
        this.isRequestFocus = true;
        if (this.isCreatingNewAlbum) {
          this.isDeferCreatingNewAlbum = true;
          SideBarVariables.isSideBarDeselected = true;
          return;
        }
        this.isFreezeSelected = false;
        this.appBroadCast.emit(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, []);
        /* instrument ignore next */
        if (DeviceInfo.isPc()) {
          this.isCreatingNewAlbum = true;
          this.deSelect(true);
          this.createNewAlbum(true);
          Log.info(TAG, `albumNewBtn: PC onClick: End`);
          return;
        }
        this.createNewAlbum();
        Log.info(TAG, `albumNewBtn: onClick: End`);
      })
    }
    .draggable(false)
  }

  // 新建相册逻辑：数据源新增数据，refresh datasource
  private createNewAlbum(isUsingRenameInput: boolean = false): void {
    let menuContext: MenuContext = new MenuContext();
    menuContext
      .withOperationStartCallback((): void => {
        this.albums.setNewAlbumIndex(this.albums.totalCount());
        this.onOperationStart();
      })
      .withOperationEndCallback((): void => {
        if (DeviceInfo.isTablet()) {
          this.albums.setNewAlbumIndex(this.newCreatedAlbumInitIndex);
        }
        this.onOperationEnd();
        if (isUsingRenameInput && SideBarVariables.isDeferCreatingNewAlbum) {
          this.doDeferCreateNewAlbum();
        }
      })
      .withOperationFailCallback((): void => {
        this.albums.resetIsNewCreatedIndex();
        this.isCreatingNewAlbum = false;
      })
      .withBroadCast(this.broadCast)
      .operate(DeviceInfo.isPc() ? Action.NEW_WITHOUT_DIALOG.actionID : Action.ALBUM_SET_NEW.actionID)
  }

  private doDeferCreateNewAlbum(): void {
    this.isDeferCreatingNewAlbum = false
    SideBarVariables.isDeferCreatingNewAlbum = false;
    this.createNewAlbum(true);
  }

  onOperationStart(): void {
    Log.debug(TAG, 'onOperationStart');
    this.albums.pause();
  }

  /**
   * 侧边栏相册操作（包括新建，重命名，删除）结束回调
   */
  onOperationEnd(): void {
    this.albums.resume();
    Log.info(TAG, 'onOperationEnd: Side bar album operation finish. -> All things done.');
  }

  private async getSystemSourceAlbums(): Promise<AlbumInfo[]> {
    if (this.albumDataImpl && this.albumDataImpl instanceof AlbumDataImpl) {
      Log.info(TAG, 'getSystemSourceAlbums');
      return this.albumDataImpl.getSystemSourceAlbums();
    }
    return [];
  }

  private getUpdateMenuParam(): UpdateMenuParamUserAlbum {
    const param: UpdateMenuParamUserAlbum = {
      canRename: this.userIndexSelected.size <= CAN_RENAME_COUNT,
    };
    return param;
  }

  private initOperationMenu(): void {
    this.albumMenuController.initMenu(this.getUpdateMenuParam());
    this.albumSystemMenuController.initMenu();
  }

  private updateOperationMenuList(): void {
    this.albumMenuController.dealMenuGroupByParams(this.getUpdateMenuParam());
    this.albumSystemMenuController.dealMenuGroupByParams();
    let tempMenuList: Action[] = [];
    if (this.userIndexSelected.size > 1) {
      tempMenuList.push(Action.DELETE_ALBUM);
    } else {
      tempMenuList.push(Action.RENAME, Action.DELETE_ALBUM);
    }
    let msg: string = tempMenuList.map((action: Action) => action.componentKey).join(',');
    Log.info(TAG, `operationMenuList: ${msg}   ${this.sysAlbumsKeys[this.currentIndex]} ${this.currentIndex}`);
    if (!UiUtil.isActionArrayEqual(this.operationMenuList, tempMenuList)) {
      this.operationMenuList = tempMenuList;
    }
  }

  /**
   * 当前用户相册是否选中
   *
   * @param index
   */
  private isUserAlbumSelected(index: number): boolean {
    return index >= this.userAlbumInitialIndex && this.userIndexSelected?.has(index);
  }

  /**
   * 判断是不是 我的相册 如果是，可以多选，多选后显示删除相册和合并相册
   * 按住shift选中焦点到选中的所有项，不改变焦点
   * 按住Ctrl选中和取消焦点项，切换焦点
   *
   * @param index
   */
  private dealMulSelectAlbum(index: number, isRightClick?: boolean): void {
    let recordPreIndex: number = this.focusIndex;
    // 选中是不是我的相册 不是则重新置为空
    if (index < this.userAlbumInitialIndex) {
      Log.info(TAG, `userIndexSelected-clear${recordPreIndex}`);
      this.userIndexSelected.clear();
      return;
    }
    Log.info(TAG, `dealMulSelectAlbum, isRightClick:${isRightClick} has:${this.userIndexSelected.has(index)}`);
    if (isRightClick && this.userIndexSelected.has(index) &&
      !(AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS) ||
      AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS))) {
      this.focusIndex = index;
      return;
    }
    if (!AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS)) {
      // 不按住shift
      this.focusIndex = index;

      enum ActionType {
        NONE,
        ADD,
        DELETE,
        CLEAR,
      };

      const actionMap: Map<number, Function> = new Map([
        [ActionType.DELETE, (index: number): void => {
          this.userIndexSelected.delete(index);
        }],
        [ActionType.ADD, (index: number): void => {
          this.userIndexSelected.add(index);
        }],
        [ActionType.CLEAR, (): void => this.userIndexSelected.clear()],
        [ActionType.NONE, (): void => {
        }],
      ]);
      // 如果不是点击项自选相册且按住了ctrl，先清空，如果是则无操作   然后判断有没有index，有就删除，没有则新增
      const firstStep: number = Number(!(index >= this.userAlbumInitialIndex &&
      Boolean(AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS)))) && ActionType.CLEAR;
      const nextStep: number = Number(Boolean(AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS)) &&
      this.userIndexSelected.has(index)) + 1;
      Log.info(TAG, `userIndexSelected nextStep： ${nextStep}`);
      actionMap.get(firstStep)?.();
      actionMap.get(nextStep)?.(index);
    } else if (!AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS)) {
      // 按住shift,不按ctrl 点击选中cur到index
      Log.info(TAG, `userIndexSelected-shift- ${Array.from(this.userIndexSelected)}`);
      this.userIndexSelected.clear();
      let left = Math.min(index, recordPreIndex);
      let right = Math.max(index, recordPreIndex);
      while (left <= right) {
        this.userIndexSelected.add(left);
        left++;
      }
    } else {
      // shift和ctrl都按住
      if (this.userIndexSelected.size >= 1) {
        this.userIndexSelected.add(index);
      } else {
        this.focusIndex = index;
      }
    }
    Log.info(TAG, `userIndexSelected shift： ${AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS)} ` +
      `ctrl： ${AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS)}`);
  }

  private selectItem(index: number, isRightClick?: boolean): void {
    let recordPreIndex: number = this.currentIndex;
    Log.info(TAG, `selectItem from ${this.currentIndex} to ${index}`);
    if (index === 1) {
      AppStorage.delete(Constants.KEY_OF_ALBUM_URI);
    }
    if (this.currentIndex !== index) {
      this.appBroadCast.emit(BroadCastConstants.SIDEBAR_CHANGE);
    }
    SideBarVariables.isSideBarDeselected = false;
    this.dealMulSelectAlbum(index, isRightClick);
    this.currentIndex = index;
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.isShowSearchPage = false;
      if (this.isShowPortraitAlbumsView) {
        this.appBroadCast.emit(BroadCastConstants.LOAD_PORTRAIT_PAGE, []);
      }
      // if (this.browserController.isBrowserShow) {
      //   // 如果回到原来的SideBar item,保留一镜到底的动效, 如果this.currentIndex 与index 不同，则清除一镜到底的动效
      //   if (recordPreIndex !== this.currentIndex) {
      //     this.isSelectionTitle = false;
      //     LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
      //     this.browserController.hidePCBrowser(this.browserController.getCurrentIndex());
      //   } else {
      //     this.browserController.hideBrowser(this.browserController.getCurrentIndex());
      //   }
      // }
      // if (this.browserController.isSelectBrowserShow) {
      //   let param: Params = this.browserController.selectBrowserParam as Params;
      //   Log.info(TAG, `hide_select_browser ${param.position}`);
      //   // 如果回到原来的SideBar item,保留一镜到底的动效, 如果this.currentIndex 与index 不同，则清除一镜到底的动效
      //   if (recordPreIndex !== this.currentIndex) {
      //     this.isSelectionTitle = false;
      //     LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
      //     this.browserController.hideSelectBrowserImmediately(param.position);
      //   } else {
      //     this.browserController.hideSelectBrowser(param.position);
      //   }
      // }
    }
    if (DeviceInfo.isGRLFoldScreen() && index === SideBarType.CLASSIFICATION) {
      LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_IS_KEEP_CLASSIFIED, true);
    }
    if (DeviceInfo.isGRLFoldScreen() && index === SideBarType.SHOOTING) {
      LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_IS_KEEP_SHOOTING, true);
    }
  }

  private resetIsNewCreated(index: number): void {
    Log.info(TAG, `resetIsNewCreated index: ${index}`);
    this.albums.resetIsNewCreatedIndex(index);
  }

  // 切换item
  private switchItemAuto(album: AlbumInfo, actionID: number): void {
    let totalCount: number = this.albums.totalCount();
    if (actionID === Action.DELETE_ALBUM.actionID) {
      // 实际布局index
      let delIndex: number = Math.max(this.albums.getIndexByAlbum(album), 0);
      Log.info(TAG, `switchItemAuto currentIndex ${this.currentIndex} delIndex ${delIndex}`);
      this.updateCurIdxPostDelAlbum(this.currentIndex, delIndex + this.userAlbumInitialIndex);
      return;
    }
    if (actionID === Action.NEW_WITHOUT_DIALOG.actionID) {
      let operatingIndex: number =
        album === undefined ? this.albums.getNewAlbumIndex() : Math.max(this.albums.getIndexByAlbum(album), 0);
      Log.info(TAG,
        `switchItemAuto from new_without_dialog newCreatedAlbumIndex ${operatingIndex} album ${JSON.stringify(album)}`);
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        this.selectItem(this.userAlbumInitialIndex + operatingIndex);
        return;
      }
    }
    /* instrument ignore next */
    if (actionID === Action.ALBUM_SET_NEW.actionID) {
      Log.info(TAG, `switchItemAuto from ALBUM_SET_NEW newCreatedAlbumIndex ${this.albums.getNewAlbumIndex()}`);
      this.newCreatedAlbumIndex = this.albums.getNewAlbumIndex();
      return;
    }
    if (actionID === Action.RENAME.actionID) {
      let operatingIndex: number = this.albums.getIndexByAlbum(album);
      Log.info(TAG,
        `switchItemAuto from rename count: ${totalCount}, cur: ${this.currentIndex}, operatingIndex ${operatingIndex}`);
      if (this.isCreatingNewAlbum) {
        return;
      }
      this.selectItem(this.userAlbumInitialIndex + operatingIndex);
    }
  }

  // 根据当前索引获取可用索引
  private updateCurIdxPostDelAlbum(curIndex: number, delIndex: number): void {
    if (curIndex < 0 || delIndex < 0) {
      return;
    }
    // 删除
    // 1. 选中当前，删除当前，需切换；1）先向后，若有，则后一位，2）否则向前，若有则前一位，3）其他切换至0
    // 2. 选中当前，处理其他时；1）处理之前，则需对应index前移一位
    // 3. 未选中，处理其他时；1）也无需切换
    if (curIndex === delIndex) {
      let albumIndex = curIndex - this.userAlbumInitialIndex;
      Log.info(TAG, `updateCurIdxPostDelAlbum albumIndex ${albumIndex}`);
      // 删除一个，对应curIndex需前移
      let albumsCount: number = this.albums.totalCount();
      if (delIndex - this.userAlbumInitialIndex < albumsCount - 1) {
        Log.info(TAG, `updateCurIdxPostDelAlbum same index ${this.currentIndex}`);
        return;
      }
      let album: AlbumInfo | undefined = this.albums.getAlbumByIndex(albumIndex - 1);
      if (album && !album.isSystemAlbum) {
        this.currentIndex = curIndex - 1;
        Log.info(TAG, `updateCurIdxPostDelAlbum index -1 ${this.currentIndex}`);
        return;
      }
      this.currentIndex = this.sysAlbumsKeys[0];
    }
    // 删除一个，对应curIndex需前移
    if (curIndex > delIndex) {
      this.currentIndex = curIndex - 1;
      Log.info(TAG, `updateCurIdxPostDelAlbum curIndex > delIndex  ${this.currentIndex}`);
    }
  }

  // 更新图片和视频数量
  private async getMediaCount(): Promise<MediaCount> {
    return await UserFileManagerAccess.getInstance()
      .getCountGroupByMediaType('SideBar getCount', false, false, false, false, true, true);
  }

  private async getTimelineCustomItem(): Promise<CustomItem> {
    let result: MediaCount = await this.getMediaCount();
    let item: AlbumInfo | CustomItem | undefined = this.sysAlbumsMap.get(SideBarType.TIMELINE);
    if (!item) {
      item = this.getCustomItem($r('app.string.pictures_and_videos'), 0);
    }
    item.count = result.imageCount + result.videoCount;
    return item;
  }

  private async getPhotoAlbum(): Promise<AlbumInfo | undefined> {
    if (this.albumDataImpl && this.albumDataImpl instanceof AlbumDataImpl) {
      return this.albumDataImpl.getPhotoAlbum();
    }
    return;
  }

  private async getVideoAlbum(): Promise<AlbumInfo | undefined> {
    if (this.albumDataImpl && this.albumDataImpl instanceof AlbumDataImpl) {
      return this.albumDataImpl.getVideoAlbum();
    }
    return;
  }

  private async getFavouriteAlbum(): Promise<AlbumInfo | undefined> {
    if (this.albumDataImpl && this.albumDataImpl instanceof AlbumDataImpl) {
      return this.albumDataImpl.getFavoriteAlbum();
    }
    return;
  }

  private async getRecycleAlbum(): Promise<AlbumInfo | undefined> {
    if (this.albumDataImpl && this.albumDataImpl instanceof AlbumDataImpl) {
      return this.albumDataImpl.getTrashAlbum();
    }
    return;
  }

  private async getHiddenAlbum(): Promise<AlbumInfo | undefined> {
    if (this.albumDataImpl && this.albumDataImpl instanceof AlbumDataImpl) {
      return this.albumDataImpl.getHiddenAlbumInfo();
    }
    return;
  }

  private getCustomItem(label: string | Resource, count?: number): CustomItem {
    let item: CustomItem = new CustomItem();
    item.count = count;
    item.label = label;
    return item;
  }

  private getHeaderStyle(sideBarType: SideBarType): HeaderStyle | undefined {
    let headerStyle: HeaderStyle | undefined;
    if (sideBarType === SideBarType.USER) {
      headerStyle = this.getUserHeaderStyle();
    }
    if (sideBarType === SideBarType.SMART) {
      headerStyle = {
        label: $r('app.string.smart_albums'),
        sideBarType: SideBarType.SMART,
        getAngle: (): number => {
          return this.isShowSmartAlbumList ? 0 : 180;
        },
        onclick: (): void => {
          animateTo({
            curve: curves.interpolatingSpring(0, 1, 228, 25),
          }, (): void => {
            this.isShowSmartAlbumList = !this.isShowSmartAlbumList;
          })
        }
      }
    }
    if (sideBarType === SideBarType.SOURCE) {
      headerStyle = {
        label: $r('app.string.photo_source'),
        sideBarType: SideBarType.SOURCE,
        getAngle: (): number => {
          return this.isShowSourceAlbumList ? 0 : 180;
        },
        onclick: () => {
          animateTo({
            curve: curves.interpolatingSpring(0, 1, 228, 25),
          }, (): void => {
            this.isShowSourceAlbumList = !this.isShowSourceAlbumList;
          })
        }
      }
    }
    return headerStyle;
  }

  private getUserHeaderStyle(): HeaderStyle {
    return {
      label: $r('app.string.my_albums'),
      sideBarType: SideBarType.USER,
      getAngle: (): number => {
        return this.isShowUserAlbumList ? 0 : 180;
      },
      onclick: (): void => {
        // 动效曲线影响整个list渲染动效 尺寸
        this.isSideBarItemAniOpen = false;
        animateTo({
          curve: curves.interpolatingSpring(0, 1, 228, 25),
        }, (): void => {
          this.isShowUserAlbumList = !this.isShowUserAlbumList;
          if (this.isShowUserAlbumList) {
            this.change2Rebuild = !this.change2Rebuild;
            this.albums.onDataReloaded();
          }
        })
      }
    }
  }

  private generateItemKey(item: AlbumSetDataInfo, index?: number): string {
    if (!item || !item.data) {
      return TAG + index;
    }
    return `${item.data.uri}_${item.data.coverUri}_${item.data.count}`;
  }

  // 拖拽占位
  @Builder
  dragItem() {
    Column() {
    }
    .width(0.5)
    .height(0.5)
  }

  private createAlbumSetInlineRenameMenuOperation(currentAlbum: AlbumInfo):
  AlbumSetInlineRenameMenuOperation | undefined {
    Log.info(TAG, `single menu click rename for currentUri: ${currentAlbum?.uri}`);
    if (!currentAlbum) {
      return undefined;
    }
    let menuContext: MenuContext = new MenuContext();
    menuContext
      .withFromSelectMode(false)
      .withAlbumInfo(currentAlbum)
      .withOperationStartCallback(this.onOperationStartFunc)// this指向SideBar
      .withOperationEndCallback((): void => {
        Log.info(TAG, 'createAlbumSetInlineRenameMenuOperation');
        this.onOperationEnd();
      })// this指向SideBar
      .withBroadCast(this.broadCast)
    return MenuOperationFactory.getInstance().createMenuOperation(AlbumSetInlineRenameMenuOperation, menuContext);
  }

  /**
   * 对单个相册执行处理，目前侧边栏相册长按菜单只有重命名和删除操作
   *
   * @param action menu action
   * @param currentAlbum album info
   * @param index album index
   */
  private onMenuClickedForSingleItem(action: Action, currentAlbum: AlbumInfo, index: number): void {
    Log.info(TAG, `onMenuClickedForSingleItem: Action: ${action?.actionID}, currentUri: ${currentAlbum?.uri}.`);
    if (!currentAlbum) {
      return;
    }
    let menuContext: MenuContext;
    if (action.actionID === Action.RENAME_ALBUM.actionID || action.actionID === Action.RENAME.actionID) {
      // renaming dealer function is in SideBarItem
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(false)
        .withAlbumInfo(currentAlbum)
        .withOperationStartCallback(this.onOperationStartFunc)
        .withOperationEndCallback((): void => {
          this.onOperationEnd();
          this.switchItemAuto(currentAlbum, action.actionID);
        })
        .withUIContext(getContext(this) as common.UIAbilityContext)
        .withBroadCast(this.broadCast);
      MenuOperationFactory.getInstance()
        .createMenuOperation(AlbumSetRenameMenuOperation, menuContext).doAction();
    } else if (action.actionID === Action.DELETE_ALBUM.actionID) {
      if (this.userIndexSelected.size > 1) {
        this.albumMSelectManage.clickedSet.clear();
        for (const albumIndex of this.userIndexSelected) {
          const album = this.albums.getAlbumByIndex(albumIndex - this.userAlbumInitialIndex);
          this.albumMSelectManage.clickedSet.add(album?.uri || '');
          Log.info(TAG, `userIndexSelected -delete- ${Array.from(this.userIndexSelected)}--${albumIndex}` +
            `--${album?.uri}--${AlbumDefine.getAnonymizeAlbumName(album?.albumName)}`);
        }
        menuContext = new MenuContext();
        menuContext
          .withFromSelectMode(true)
          .withSelectManager(this.albumMSelectManage)
          .withOperationStartCallback(this.onOperationStartFunc)
          .withOperationEndCallback((): void => {
            this.onOperationEnd();
            this.switchItemAuto(currentAlbum, Action.DELETE_ALBUM.actionID);
            this.userIndexSelected.clear();
            this.albumMSelectManage.clickedSet.clear();
          })
          .withBroadCast(this.broadCast);
        MenuOperationFactory.getInstance()
          .createMenuOperation(AlbumSetDeleteMenuOperation, menuContext).doAction();
      } else {
        if (this.currentIndex > this.userAlbumInitialIndex + index) {
          this.isFreezeSelected = true;
        }
        menuContext = new MenuContext();
        menuContext
          .withFromSelectMode(false)
          .withAlbumInfo(currentAlbum)
          .withOperationStartCallback(this.onOperationStartFunc)
          .withOperationEndCallback((): void => {
            this.onOperationEnd();
            this.switchItemAuto(currentAlbum, Action.DELETE_ALBUM.actionID);
          })
          .withBroadCast(this.broadCast);
        MenuOperationFactory.getInstance()
          .createMenuOperation(AlbumSetDeleteMenuOperation, menuContext).doAction();
      }
    }
  }

  @Builder
  private dragDivider() {
    Divider()
      .color($r('sys.color.comp_background_emphasize'))
      .strokeWidth(2)
      .width('calc(100% - 8vp)')
  }

  private itemTouchEvent(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      this.dragItemNeedBack = false;
      this.dragItemIsShow = false;
      this.canDrag = true;
    }
    if (event.type === TouchType.Up) {
      Log.info(TAG, `ontouch up ${this.dragItemNeedBack}, ${this.dragItemIsShow}`);
      let timer = setTimeout((): void => {
        Log.info(TAG, `ontouch up in timeout ${this.dragItemNeedBack}, ${this.dragItemIsShow}`);
        clearTimeout(timer);
      }, 50);
    }
  }

  private onSourceAlbumLoadingFinished(): void {
    this.sourceCounts = this.sourceTypeAlbums.totalCount();
  }

  private watchIsShowSearchPage(): void {
    Log.info(TAG, `watchIsShowSearchPage: isShowSearchPage=${this.isShowSearchPage}`);
    AppStorage.setOrCreate<boolean>('IsShowSearchPage', this.isShowSearchPage);
    this.updateSelectedIndex();
  }

  private updateSelectedIndex(): void {
    if (this.isShowSearchPage) {
      this.savedIndex = this.currentIndex;
      this.currentIndex = NONE_SELECTED;
    }
  }

  private onPcQuitSearchMainPage(): void {
    Log.info(TAG, `onPcQuitSearchMainPage`);
    this.isShowSearchPage = false;
    this.currentIndex = this.savedIndex;
  }
}