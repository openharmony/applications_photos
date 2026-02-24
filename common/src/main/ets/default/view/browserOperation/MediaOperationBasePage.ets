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

import lazy { MediaOperationType } from '../../model/common/MediaOperationType';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { Log } from '../../utils/Log';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { AlbumSetNewMenuOperation } from './AlbumSetNewMenuOperation';
import lazy { MenuOperationFactory } from '../../interface/MenuOperationFactory';
import lazy { AlbumAbstractInfo, AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { AlbumListCard } from './AlbumListCard';
import lazy { MenuContext, SourceSceneType } from './MenuContext';
import lazy { Action, ActionID } from './Action';
import lazy { JumpSourceToMain } from '../../model/browser/photo/JumpSourceToMain';
import lazy { CustomDialogView } from '../dialog/CustomDialogView';
import lazy { ColumnsWidth } from '../../model/common/ColumnsWidth';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '../../model/common/ScreenManager';
import lazy { Constants } from '../../model/common/Constants';
import lazy { AlbumSetDataInfo } from '../../model/common/AlbumSetDataInfo';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy { WindowUtil } from '../../utils/WindowUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy { AlbumSetDataSourceManager } from '../../model/browser/album/AlbumSetDataSourceManager';
import lazy common from '@ohos.app.ability.common';
import lazy window from '@ohos.window';
import lazy { NavigationBroadCastManager } from '../../model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '../../model/common/NavigationConstants';
import lazy { tryGetRouterParam } from '../../utils/RouterUtil';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { ActionBar } from '../../../../../../../browserCommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy { ActionBarProp } from './ActionBarProp';
import lazy { ActionBarMode } from './ActionBarMode';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { AlbumDefine } from '../../model/browser/AlbumDefine';
import lazy { display } from '@kit.ArkUI';
import lazy { IndexFocusOrder } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { PhotoGridViewController, PhotoGridViewConstants } from '../grid/GridView';
import lazy { MovePageAlbumDataSource } from '../../model/browser/album/MovePageAlbumDataSource';
import lazy { MediaObserver } from '../../model/browser/dataObserver/MediaObserver';
import lazy { FocusCtrl } from '@ohos/tools/src/main/variables/FocusCtrl';
import lazy { DynamicRangeMode } from '@ohos.multimedia.movingphotoview';

const TAG: string = 'common_MediaOperationBasePage';

/* instrument ignore next */
export interface AlbumChosenListener {
  onAlbumChosen: (displayName: string, albumUri: string, navigationPageFunc: () => void) => void;
}

export interface Params {
  pageType: string;
  pageFrom: string;
  albumInfo: AlbumInfo | undefined;
  mediaType: number;
  selectedItems: MediaItem[];
  mediaUri?: string;
  listener?: AlbumChosenListener;
  blackUriList?: string[];
  browserControllerId?: number;
}

@Builder
export function MediaOperationBasePageLoader() {
  MediaOperationBasePage();
}

@Component
export struct MediaOperationBasePage {
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @Provide pageType: string = MediaOperationType.ADD;
  @State broadCast: BroadCast = new BroadCast();
  @State dataSourceBroadCast: BroadCast = new BroadCast();
  @Provide loadingFinish: boolean = false;
  @State screenHeight: number = getScreen().getWinHeight();
  @State listCardWidth: number = 0;
  @State listCardPaddingBottom: number = 24;
  @State private hoverSelectIndex: number | undefined = undefined;
  public scroller: Scroller = new Scroller();
  public isActive: boolean = false; // Whether the page is in the foreground
  public sourceAlbumUri: string = '';
  public currentAlbum: AlbumInfo | undefined = undefined;
  private pageFrom: string = '';
  private listener: AlbumChosenListener | undefined;
  private selectedItems: MediaItem[] = [];
  private mediaType: number = 0;
  private listCardBorderRadius: number = 16;
  private isFromShareBrowserAdd: boolean = false;
  private mediaUri: string = '';
  private dividerMarginRight: number = 12;
  private albumListCardWidthAddLength: number = 36;
  private hdrDelayTime: number = 600;
  public timerForHdr: number = 0;
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  private onLoadFinishedFun: Function = (): void => this.onLoadFinished();
  private onWindowSizeChangedFun: Function = (): void => this.onWindowSizeChanged();
  private onMediaOperationFun: Function = (displayName: string, albumUri: string, completedFunc?: Function):
    void => this.onMediaOperation(displayName, albumUri, completedFunc);
  @StorageLink('statusBarHeight') @Watch('statusBarHeightChange') statusBarHeight: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State @Watch('onIsVerdeFoldableChanged') private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @State moreMenuList: Action[] = [];
  private onMenuClickedFunc: Function = (action: Action): void => this.onMenuClicked(action);
  @State private actionBarPaddingTop: number | Resource = 0;
  @State private isNeedPlaceholder: boolean = false;
  @Consume @Watch('onIndexPageShow') isShow: boolean;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public moveAlbums: MovePageAlbumDataSource = new MovePageAlbumDataSource();
  private browserControllerId: number | undefined = 0;
  private orientataion: number = 0;

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    WindowUtil.setOrientation(this.orientataion);
    MediaObserver.getInstance().unregisterObserver(this.moveAlbums);
    this.broadCast.emit(BroadCastConstants.HIDE_NEW_ALBUM_PHOTO_DIALOG, []);
    this.broadCast.off(BroadCastConstants.MEDIA_OPERATION, this.onMediaOperationFun);
    this.dataSourceBroadCast.off(Constants.ON_LOADING_FINISHED, this.onLoadFinishedFun);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
    if (DeviceInfo.isGRLFoldScreen()) {
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_MOVING_TO_PAGE);
    }
  }

  public static judgeIsEmptyAlbumsAndCallback(sourceAlbumUri: string |
  null | undefined, trueCallback: Function, falseCallback: Function): void {
    MediaOperationBasePage.judgeIsEmptyAlbumsAndCallbackByMediaType(sourceAlbumUri, trueCallback, falseCallback, 0);
  }

  public static async judgeIsEmptyAlbumsAndCallbackByMediaType(sourceAlbumUri: string |
  null | undefined, trueCallback: Function, falseCallback: Function, mediaType: number): Promise<void> {
    Log.info(TAG, `sourceAlbumUri:${sourceAlbumUri}, mediaType=${mediaType}`);
    // 根据mediaType获取截图/屏幕录制的lpath
    let blackAlbumLpath: string[] = MediaOperationBasePage.getSystemAlbumLpathByMediaType(mediaType);
    // 获取过滤源相册，黑名单Lpath后可以移动的相册数量
    let canMoveAlbumsCount =
      await UserFileManagerAccess.getInstance().getMovableAlbumsCount(sourceAlbumUri, blackAlbumLpath);
    /* instrument ignore if */
    if (canMoveAlbumsCount > 0) {
      falseCallback?.();
    } else {
      trueCallback?.();
    }
  }

  /**
   * 根据mediaType得到截图/屏幕录制的Lpath
   * @param mediaType
   * @returns
   */
  public static getSystemAlbumLpathByMediaType(mediaType: number): string[] {
    let blackAlbumLpath: string[] = [];
    if (mediaType & UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
      blackAlbumLpath.push(Constants.LPATH_SCREEN_RECORDING);
    }
    if (mediaType & UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      blackAlbumLpath.push(Constants.LPATH_SCREEN_SHOT);
    }
    return blackAlbumLpath;
  }

  private clearBlackUriList(): void {
    Log.info(TAG, 'clearBlackUriList');
    this.dataSourceBroadCast.emit(BroadCastConstants.CLEAR_BLACK_URI_LIST, []);
  }

  /* instrument ignore next */
  private getTopPadding(): number {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return 0;
    }
    if (this.isHorizontal && (!this.isFoldExpanded && !DeviceInfo.isTablet())) {
      return Constants.PC_ACIONBAR_MARGIN_TOP;
    }
    return px2vp(this.statusBarHeight);
  }

  private static isNeededAlbum(albumAbstract: AlbumInfo, sourceAlbumUri: string | null | undefined): boolean {
    return albumAbstract && !albumAbstract.isSystemAlbum && albumAbstract.uri !== sourceAlbumUri;
  }

  private static calculateAlbumsCount(albumsData: AlbumSetDataSource, sourceAlbumUri: string | null | undefined, blackUris: string[]):
    number {
    let count: number = 0;
    /* instrument ignore else */
    for (let i: number = albumsData.activeStart; i < albumsData.activeEnd; i++) {
      let albumInfo: AlbumInfo | undefined = albumsData.getPageData(i);
      if (!albumInfo) {
        continue;
      }
      // 需要过滤黑名单的相册
      if (blackUris.includes(albumInfo.uri)) {
        continue;
      }
      count += MediaOperationBasePage.isNeededAlbum(albumInfo, sourceAlbumUri) ? 1 : 0;
    }
    Log.info(TAG, `calculateAlbumsCount: AlbumsCount=${count}`);
    return count;
  }

  /* instrument ignore next */
  private createHorizontalActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    if (!this.isVerdeFoldable) {
      menuList.push(Action.NEW_ALBUM);
    }
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(this.isFromShareBrowserAdd ? Action.CANCEL : Action.BACK)
      .setTitle($r('app.string.move_file_to'))
      .setIsLevelOneHeadTitle(true)
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
    return actionBarProp;
  }

  private createActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    if (!this.isVerdeFoldable) {
      menuList.push(Action.NEW_ALBUM);
    }

    actionBarProp
      .setLeftAction(this.isFromShareBrowserAdd ? Action.CANCEL : Action.BACK)
      .setTitle($r('app.string.move_file_to'))
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)

    return actionBarProp;
  }

  private updateActionBar(): void {
    if (this.isHorizontal) {
      this.actionBarProp = this.createHorizontalActionBar();
    } else {
      this.actionBarProp = this.createActionBar();
    }
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    WindowUtil.getPreferredOrientation().then(result => {
      this.orientataion = result ? result : 0;
      Log.info(TAG, `Before MediaOperation Orientation: ${this.orientataion}`);
    });
    Log.info(TAG, `Set MediaOperation Orientation: ${window.Orientation.AUTO_ROTATION_UNSPECIFIED}`);
    WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    if (!DeviceInfo.isPcOrTablet()) {
      this.actionBarPaddingTop = px2vp(this.statusBarHeight);
    } else {
      this.actionBarPaddingTop = $r('app.float.album_set_page_action_bar_padding_top');
    }
    WindowUtil.prepareWinRouter();
    this.listCardPaddingBottom = px2vp(UiUtil.getResourceNumber($r('sys.float.padding_level8')));
    let param: Params;
    if (AppStorage.get<Router>('router')?.getState().name === Constants.PHOTO_TRANSITION_MEDIA_OPERATION) {
      param = tryGetRouterParam() as Params;
    } else {
      param = this.navigationPageInfos
        .getParamByName(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION)[0] as Params;
    }
    if (param) {
      this.parseParam(param);
    }
    this.onActive();
    this.dataSourceBroadCast.on(Constants.ON_LOADING_FINISHED, this.onLoadFinishedFun);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
    this.broadCast.on(BroadCastConstants.MEDIA_OPERATION, this.onMediaOperationFun);
    this.listCardWidth = ColumnsWidth.updateListCardWidth();
    this.updateActionBar();
    if (DeviceInfo.isGRLFoldScreen()) {
      LocalStorage.getShared()?.setOrCreate<boolean>(Constants.APP_KEY_GRL_MOVING_TO_PAGE, true);
    }
    Log.info(TAG, `mediaOperationBasePage abouttoappear end`);
  }

  private parseParam(param: Params) {
    Log.info(TAG, `router getParams ${JSON.stringify(param)}`);
    this.pageType = param.pageType;
    this.pageFrom = param.pageFrom;
    this.listener = param.listener;
    this.browserControllerId = param.browserControllerId;
    /* instrument ignore if */
    if (param.mediaUri) {
      this.mediaUri = param.mediaUri;
    }
    this.currentAlbum = param.albumInfo;
    if (this.currentAlbum) {
      this.sourceAlbumUri = this.currentAlbum.uri;
    }
    this.mediaType = param.mediaType;
      switch (this.pageFrom) {
        case Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER:
          this.mediaType = param.mediaType;
          break;
        case Constants.MEDIA_OPERATION_FROM_TIMELINE:
          this.selectedItems = param.selectedItems;
          break;
        case Constants.MEDIA_OPERATION_FROM_PHOTO_GRID:
          this.selectedItems = param.selectedItems;
          break;
        case Constants.MEDIA_OPERATION_FROM_THIRD_CAMERA_ADD:
          /* instrument ignore next */
          this.isFromShareBrowserAdd = true;
          break;
        default:
        /* instrument ignore next */
          break;
      }
    Log.info(TAG, `moveAlbums this.sourceAlbumUri:${this.sourceAlbumUri}`);
    this.moveAlbums.setSourceAlbumUri(this.sourceAlbumUri);
    this.moveAlbums.setBlackLpath(this.mediaType);
    MediaObserver.getInstance().registerObserver(this.moveAlbums);
    this.moveAlbums.initData();
  }

  private onLoadFinished(): void {
    this.loadingFinish = true;
  }

  private onWindowSizeChanged(): void {
    this.listCardWidth = ColumnsWidth.updateListCardWidth();
  }

  private onMediaOperation(displayName: string, albumUri: string, completedFunc?: Function): void {
    Log.info(TAG, `broadCast on mediaOperation, albumName: ${AlbumDefine.getAnonymizeAlbumName(displayName)}, ` +
      `albumUri: ${albumUri}, isFromShareBrowserAdd: ${this.isFromShareBrowserAdd}`);
    ReportToBigDataUtil.report(BigDataConstants.COPY_MENU_RESPONSE);
    /* instrument ignore if */
    if (this.isFromShareBrowserAdd) {
      this.moveOperation(displayName, albumUri);
      return;
    }
    let navigationPageFunc = (): void => {
      this.navigationPageInfos.pop();
    }
    this.navigationBroadCast.emit(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK,
      [this.pageType, displayName, albumUri, navigationPageFunc, this.browserControllerId]);
    this.listener?.onAlbumChosen(displayName, albumUri, navigationPageFunc);
    this.dataSourceBroadCast.emit(BroadCastConstants.CLEAR_BLACK_URI_LIST, []);
    completedFunc?.();
  }

  /* instrument ignore next */
  private addOperation(albumName: string, albumUri: string): void {
    let mediaItem: MediaItem = new MediaItem();
    mediaItem.setUri(this.mediaUri);
    let funcEndCallback = (): void => this.endCallback();
    new MenuContext()
      .withMediaItem(mediaItem)
      .withBroadCast(this.broadCast)
      .withOperationEndCallback(funcEndCallback)
      .withTargetAlbumName(albumName)
      .withAlbumUri(albumUri)
      .operate(Action.ADD.actionID);
  }

  /* instrument ignore next */
  private moveOperation(albumName: string, albumUri: string): void {
    let mediaItem: MediaItem = new MediaItem();
    mediaItem.setUri(this.mediaUri);
    let funcEndCallback = (): void => this.endCallback();
    new MenuContext()
      .withMediaItem(mediaItem)
      .withBroadCast(this.broadCast)
      .withOperationEndCallback(funcEndCallback)
      .withTargetAlbumName(albumName)
      .withAlbumUri(albumUri)
      .operate(Action.MOVE.actionID);
  }

  /* instrument ignore next */
  private endCallback(isOnBackground?: boolean): void {
    Log.info(TAG, `endCallback, isOnBackground: ${isOnBackground}`);
    (LocalStorage.getShared()
      .get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext).terminateSelfWithResult({
      resultCode: isOnBackground ? 100 : 0,
      want: {}
    });
  }

  /* instrument ignore next */
  private getSelectIndex(isHover: boolean, index: number | undefined): void {
    if (isHover) {
      this.hoverSelectIndex = index;
    } else {
      this.hoverSelectIndex = undefined;
    }
  }

  /* instrument ignore next */
  private statusBarHeightChange(): void {
    Log.info(TAG, 'statusBarHeightChange');
    if (!DeviceInfo.isPcOrTablet()) {
      this.actionBarPaddingTop = px2vp(this.statusBarHeight);
    }
  }

  createNewAlbum(): void {
    Log.info(TAG, 'createNewAlbum');
    let menuContext = new MenuContext()
      .withUIContext(this.getUIContext().getHostContext() as common.UIAbilityContext)
      .withOperationStartCallback((): void => this.onOperationStart())
      .withOperationEndCallback((): void => this.onOperationEnd())
      .withAlbumInfo(this.currentAlbum ?? undefined)
      .withBroadCast(this.broadCast)
      .withJumpSourceToMain(JumpSourceToMain.ALBUM)
      .withSourceScene(this.pageFrom === Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER ?
        SourceSceneType.BIG_PHOTO_COMPONENT : SourceSceneType.INVALID);
    MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewMenuOperation, menuContext).doAction();
  }

  onOperationStart(): void {
  }

  onOperationEnd(): void {
  }

  private onBackPressed(): boolean {
    Log.info(TAG, 'navDestination onBackPressed');
    /* instrument ignore if */
    if (this.isFromShareBrowserAdd) {
      global.terminateSelf('MediaOperationBasePage', 'isFromShareBrowserAdd');
    } else {
      this.navigationBroadCast.emit(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK, []);
      this.navigationPageInfos.pop();
    }
    this.clearBlackUriList();
    if (DeviceInfo.isGRLFoldScreen()) {
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_MOVING_TO_PAGE);
      if (DeviceInfo.isPhoneUx() && this.navigationPageInfos.size() !== 0) {
        AppStorage.setOrCreate<number>('albumActionBarOpacity', 1);
        AppStorage.setOrCreate<number>('albumOpacity', 1);
        AppStorage.setOrCreate<boolean>('isShowPhotoGridView', false);
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OTHER_SCALE, 1);
        AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, '');
        let controller: PhotoGridViewController = new PhotoGridViewController();
        controller.setIsShow(TAG, 'onBackPressed is thirdFold', controller.isShow, false);
        this.getUIContext()?.getSharedLocalStorage()?.setOrCreate(PhotoGridViewConstants.KEY_INDEX_GRID_VIEW_CONTROLLER,
          controller);
      }
    }
    return true;
  }

  // Callback when the page is in the foreground
  onActive(): void {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      this.moveAlbums?.resume();
    }
  }

  /* instrument ignore next */
  isSelectedItemsContainsVideo(): boolean {
    for (let i = 0; i < this.selectedItems.length; i++) {
      let item = this.selectedItems[i];
      if (item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        Log.info(TAG, 'Selected items contain video.');
        return true;
      }
    }
    Log.info(TAG, 'all selected items are images.');
    return false;
  }

  /* instrument ignore next */
  getBorderRadius(index: number): BorderRadiuses | undefined {
    if (this.moveAlbums != null && index === 0 && index + 1 === this.moveAlbums.totalCount()) {
      return {
        topLeft: this.listCardBorderRadius,
        topRight: this.listCardBorderRadius,
        bottomLeft: this.listCardBorderRadius,
        bottomRight: this.listCardBorderRadius,
      };
    } else if (this.moveAlbums != null && index + 1 === this.moveAlbums.totalCount()) {
      return { bottomLeft: this.listCardBorderRadius, bottomRight: this.listCardBorderRadius };
    } else if (index === 0) {
      return { topLeft: this.listCardBorderRadius, topRight: this.listCardBorderRadius };
    }

    return undefined;
  }

  /* instrument ignore next */
  private onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    if (Action.NEW_ALBUM.equals(action)) {
      this.createNewAlbum();
    } else {
      this.onBackPressed();
    }
  }

  /* instrument ignore next */
  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  /* instrument ignore next */
  private onIsVerdeFoldableChanged(): void {
    this.updateActionBar();
  }

  private getActionBarPaddingTop(): number | Resource {
    /* instrument ignore next */
    if (DeviceInfo.isPhoneVde()) {
      return this.isHorizontal || this.isVerdeFoldable ? 0 : Constants.StatusBarHeight;
    }
    /* instrument ignore next */
    if (this.isHorizontal && (!this.isFoldExpanded && !DeviceInfo.isTablet())) {
      return 0;
    }
    return this.actionBarPaddingTop;
  }

  private contentStartOffset(): number {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return Constants.WindowDecorHeight;
    }
    /* instrument ignore next */
    if (this.isVerdeFoldable) {
      return Constants.ActionBarHeight;
    }
    if (!this.isHorizontal || DeviceInfo.isTablet() || this.isFoldExpanded) {
      return px2vp(this.statusBarHeight) + Constants.ActionBarHeight;
    }
    /* instrument ignore next */
    return Constants.ActionBarHeight;
  }

  @Builder
  AlbumListCardBuilder(album: AlbumInfo) {
    AlbumListCard({
      item: album,
      broadCast: this.broadCast,
    })
  }

  @Builder
  buildMediaList() {
    ListItemGroup({ style: ListItemGroupStyle.CARD }) {
      LazyForEach(this.moveAlbums, (album: AlbumInfo, index?: number) => {
        if (album) {
          ListItem(){
            this.AlbumListCardBuilder(album)
          } .key(`MediaOperationPageAlbum${index}`)
          .padding({
            left: $r('sys.float.corner_radius_level4'),
          })
          .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level6') : $r('sys.float.corner_radius_level8'))
          .hoverEffect(HoverEffect.Highlight)
          .backgroundColor(this.hoverSelectIndex === index && this.currentMode ===
          ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('sys.color.comp_background_list_card') : undefined)
          .tabIndex(FocusCtrl.IndexFocusOrder.PHOTO_GRID_VIEW)
          .stateStyles({
            focused: {
              .borderWidth(2.5)
              .borderColor($r('sys.color.interactive_focus'))
            },
            pressed: {
              .backgroundColor($r('sys.color.interactive_click'))
            },
            selected: {
              .backgroundColor($r('sys.color.comp_background_emphasize'))
            },
            normal: {
              .backgroundColor(undefined)
              .borderWidth(2.5)
              .borderColor(Color.Transparent)
            }
          })
          /* instrument ignore next */
          .onHover((isHover: boolean, event: HoverEvent): void => {
            this.getSelectIndex(isHover, index);
          })
          // HdsListItem({
          //   customItemBuilder: this.AlbumListCardBuilder.bind(this, album)
          // })
          //   .key(`MediaOperationPageAlbum${index}`)
          //   .padding({
          //     left: $r('sys.float.corner_radius_level4'),
          //   })
          //   .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level6') : $r('sys.float.corner_radius_level8'))
          //   .hoverEffect(HoverEffect.Highlight)
          //   .backgroundColor(this.hoverSelectIndex === index && this.currentMode ===
          //   ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('sys.color.comp_background_list_card') : undefined)
          //   .tabIndex(FocusCtrl.IndexFocusOrder.PHOTO_GRID_VIEW)
          //   .stateStyles({
          //     focused: {
          //       .borderWidth(2.5)
          //       .borderColor($r('sys.color.interactive_focus'))
          //     },
          //     pressed: {
          //       .backgroundColor($r('sys.color.interactive_click'))
          //     },
          //     selected: {
          //       .backgroundColor($r('sys.color.comp_background_emphasize'))
          //     },
          //     normal: {
          //       .backgroundColor(undefined)
          //       .borderWidth(2.5)
          //       .borderColor(Color.Transparent)
          //     }
          //   })
          //   /* instrument ignore next */
          //   .onHover((isHover: boolean, event: HoverEvent): void => {
          //     this.getSelectIndex(isHover, index);
          //   })
        } else {
          ListItem().visibility(Visibility.None)
          // HdsListItem().visibility(Visibility.None)
        }
      }, (item: AlbumSetDataInfo, index?: number): string => {
        /* instrument ignore if */
        if (!item?.data) {
          return TAG + String(index);
        }
        /* instrument ignore if */
        if (item.data.mediaItem) {
          return item.data.getHashCode() + item.data.mediaItem.getHashCode();
        }
        return item.data.getHashCode();
      });
    }
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10'))
    .divider({
      strokeWidth: '1px',
      startMargin: $r('app.float.list_card_margin_left'),
      endMargin: this.dividerMarginRight,
      color: $r('sys.color.ohos_id_color_list_separator'),
    })
  }

  @Builder
  buildActionBar() {
    Column() {
      ActionBar({
        actionBarProp: this.actionBarProp,
        onMenuClicked: this.onMenuClickedFunc,
        isNeedPlaceholder: this.isNeedPlaceholder,
        actionMoreMenuList: undefined,
        isFromMediaOperationBase: true,
      })
        .padding({
          top: this.getActionBarPaddingTop(),
        })
    }
    .zIndex(2)
    .position({ y: 0 })
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
    .backgroundColor($r('app.color.transparent'))
  }

  @Builder
  buildMediaNavigationContent() {
    Column() {
      Stack() {
        this.buildActionBar();
        List({ scroller: this.scroller }) {
          this.buildMediaList();
        }
        .alignListItem(ListItemAlign.Center)
        .scrollBar(BarState.Off)
        .height('100%')
        .padding({ top: DeviceInfo.isPc() ? $r('sys.float.padding_level8') : $r('sys.float.padding_level4') })
        .contentStartOffset(this.contentStartOffset())
        .contentEndOffset(this.getMarginBottom())
        .width(this.listCardWidth + this.albumListCardWidthAddLength)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      }
      .height('100%')

      CustomDialogView({ broadCast: $broadCast })
    }
    .backgroundColor($r('sys.color.background_secondary')) // ux: colorSubBackground
    .height('100%')
    .padding({
      top: this.isHorizontal ? 0 : this.leftBlank[1],
    })
    .margin({
      left: this.calcMargin(true),
      right: this.calcMargin(false),
    })
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM]);
  }

  private calcMargin(isLeftMargin: boolean): Length {
    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      return this.isHorizontal ? $r('app.float.list_item_right_icon1_size')
        : $r('app.float.list_item_right_icon1_margin_left');
    }
    /* instrument ignore next */
    if (this.isHorizontal && DeviceInfo.isPhoneUx() && !this.isFoldExpanded) {
      return isLeftMargin ? this.diggingHoleCameraArea.left : this.diggingHoleCameraArea.right;
    }
    return 0;
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.End }) {
        this.buildMediaNavigationContent();

        ScrollBar({ scroller: this.scroller })
          .margin({
            top: this.contentStartOffset(),
            bottom: this.getMarginBottom(),
          })
      }
    }
    .backButtonIcon(this.isFromShareBrowserAdd
      ? $r('sys.media.ohos_ic_public_cancel') : $r('sys.symbol.chevron_backward'))
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onBackPressed((): boolean => {
      return this.onBackPressed();
    })
  }

  private getMarginBottom(): number {
    /* instrument ignore if */
    if (this.isVerdeFoldable) {
      return Constants.COLUMN_MARGIN;
    }
    return this.leftBlank[3] + Constants.ToolBarHeight;
  }

  onPageHide(): void {
    Log.info(TAG, `onPageHide`);
    this.endCallback();
  }

  private onIndexPageShow(): void {
    Log.info(TAG, `onIndexPageShow isShow = ${this.isShow}, pageFrom: ${this.pageFrom}`);
    if (!this.isShow && this.pageFrom === Constants.MEDIA_OPERATION_FROM_THIRD_CAMERA_ADD) {
      this.endCallback(true);
    }
  }
}