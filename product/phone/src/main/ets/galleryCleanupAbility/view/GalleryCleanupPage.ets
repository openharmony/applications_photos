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

import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  updateAlbumPageGridPaddingLeftAndRight
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { ActionBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { ActionBarMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { CleanupAlbumsDataSource } from '@ohos/common/src/main/ets/default/model/browser/album/CleanupAlbumsDataSource';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { VideoCleanupPage } from './VideoCleanupPage';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { GridCleanupPage } from './GridCleanupPage';
import lazy { OnAlbumClickListener } from '@ohos/common/src/main/ets/default/utils/AlbumRefreshUtil';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { common } from '@kit.AbilityKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy ThirdAppLockUtil from '@ohos/common/src/main/ets/default/utils/ThirdAppLockUtil';
import lazy { NoPhotoComponent } from '@ohos/common/src/main/ets/default/view/NoPhotoComponent';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';

let storage: LocalStorage = LocalStorage.getShared();
/* instrument ignore file */
const TAG: string = 'GalleryCleanupPage';

export enum ColumnSize {
  COLUMN_ONE_POINT_FIVE = 1.5,
  COLUMN_TWO = 2,
  COLUMN_THREE = 3,
  COLUMN_FOUR = 4,
  COLUMN_FIVE = 5,
  COLUMN_SIX = 6,
  COLUMN_EIGHT = 8,
  COLUMN_TWELVE = 12,
}

@Entry(storage)
@Component
export struct GalleryCleanupPage {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @StorageLink('topRectHeight') topRectHeight: number = 0;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('getFoldStatus') @Watch('onIsFoldExpandedChanged') private isFoldExpanded: boolean =
    DeviceInfo.isFoldable();
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State dataSourceBroadCast: BroadCast = new BroadCast();
  @Provide loadingFinish: boolean = false;
  @State screenHeight: number = getScreen().getWinHeight();
  @State listCardMargin: number = updateAlbumPageGridPaddingLeftAndRight(true);
  @State listCardPaddingBottom: number = 24;
  @State private hoverSelectIndex: number | undefined = undefined;
  public scroller: Scroller = new Scroller();
  private onWindowSizeChangedFun: Function = (): void => this.onWindowSizeChanged();
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @State moreMenuList: Action[] = [];
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @State private isNeedPlaceholder: boolean = false;
  @State isEmptyAlbum: boolean = false;
  @State private cleanupAlbums: CleanupAlbumsDataSource | undefined = undefined;
  private videoAlbumInfo: AlbumInfo | undefined = undefined;
  private trashAlbumInfo: AlbumInfo | undefined = undefined;
  private screenshotAlbum: AlbumInfo | undefined = undefined;
  @State private listPaddingTopAndBottom: Resource = $r('sys.float.padding_level6');
  @State selectId: string = '';
  private onMenuClickedFunc: Function = (action: Action): void => this.onMenuClicked(action);
  public onClickListener: OnAlbumClickListener | undefined = undefined;
  @Provide pageInfo: NavPathStack = new NavPathStack();
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  private dividerMarginStart: number = 0;
  // 前往图库清理数据入口
  private isFromShortcutEntryPage: boolean = false;
  // 应用锁是否展示
  @State isAppLockShow: boolean = false;
  @State appLockUtil: ThirdAppLockUtil = new ThirdAppLockUtil();
  private isUIExt = ScreenManager.getInstance(storage).isUIExtensionEnv();
  @StorageLink('isCleanupPageShow') @Watch('onPageChanged') isCleanupPageShow: boolean = true;
  @State private isAgreed: boolean = false;

  private appLockUpdate = (state: boolean) => {
    Log.info(TAG, `appLockUpdate ${state}`);
    this.isAppLockShow = state;
  };

  private onIsFoldExpandedChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear: this.isHorizontal=${this.isHorizontal}`);
    this.updateIsAgreed();
    storage?.setOrCreate<boolean>(Constants.IS_GALLERY_CLEANUP_PAGE, true);
    this.appBroadCast.on(Constants.THIRD_APP_LOCK_UPDATE, this.appLockUpdate);
    this.appLockUtil.init(Constants.GALLERY_CLEANUP_ON_FOREGROUND);
    this.breakpointSystem.registerOrientationChange();
    this.cleanupAlbums = new CleanupAlbumsDataSource(this.dataSourceBroadCast);
    if (this.isAgreed) {
      this.cleanupAlbums.loadData();
      MediaObserver.getInstance().registerObserver(this.dataObserver);
    }
    WindowUtil.prepareWinRouter();
    this.listCardPaddingBottom = px2vp(UiUtil.getResourceNumber($r('sys.float.padding_level8')));
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
    this.updateActionBar();
    this.onWindowSizeChanged();
    this.dividerMarginStart =
      px2vp(new RscGetter(getContext().resourceManager).getNumber($r('sys.float.corner_radius_level6')) +
      new RscGetter(getContext().resourceManager).getNumber($r('app.float.list_item_left_icon_bg_size')) +
      new RscGetter(getContext().resourceManager).getNumber($r('app.float.list_item_text_left_margin')));
    this.isFromShortcutEntryPage = storage?.get<boolean>('isFromShortcut') ?? false;
    ReportToBigDataUtil.report(BigDataConstants.ENTER_GALLERY_CLEANUP);
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    this.cleanupAlbums?.onNotify(nfyInfo);
  }

  private getAlbumAssetCount(album: AlbumInfo): number {
    let albumAssetCount: number = album.albumLocalAssetCount;
    if (album.isVideoAlbum) {
      albumAssetCount = this.cleanupAlbums?.albums?.[0]?.albumLocalAssetCount ?? albumAssetCount;
      this.videoAlbumInfo?.setAlbumLocalAssetCount(albumAssetCount);
    } else if (album.isScreenShotAlbum) {
      albumAssetCount = this.cleanupAlbums?.albums?.[1]?.albumLocalAssetCount ?? albumAssetCount;
      this.screenshotAlbum?.setAlbumLocalAssetCount(albumAssetCount);
    } else if (album.isTrashAlbum) {
      albumAssetCount = this.cleanupAlbums?.albums?.[2]?.albumLocalAssetCount ?? albumAssetCount;
      this.trashAlbumInfo?.setAlbumLocalAssetCount(albumAssetCount);
    }
    Log.info(TAG, `getAlbumAssetCount finished! albumAssetCount=${albumAssetCount}`);
    return albumAssetCount;
  }

  private getAlbumAssetSize(album: AlbumInfo): number {
    let albumAssetSize: number = album.albumLocalAssetSize;
    if (album.isVideoAlbum) {
      albumAssetSize = this.cleanupAlbums?.albums?.[0]?.albumLocalAssetSize ?? albumAssetSize;
    } else if (album.isScreenShotAlbum) {
      albumAssetSize = this.cleanupAlbums?.albums?.[1]?.albumLocalAssetSize ?? albumAssetSize;
    } else if (album.isTrashAlbum) {
      albumAssetSize = this.cleanupAlbums?.albums?.[2]?.albumLocalAssetSize ?? albumAssetSize;
    }
    Log.info(TAG, `sgetAlbumAssetSize finished! albumAssetSize=${albumAssetSize}`);
    return albumAssetSize;
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.cleanupAlbums?.onChange(changeType);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    storage?.delete(Constants.IS_GALLERY_CLEANUP_PAGE);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.appBroadCast.off(Constants.THIRD_APP_LOCK_UPDATE, this.appLockUpdate);
    this.appLockUtil.destroy();
  }

  private onWindowSizeChanged(): void {
    Log.info(TAG, `onWindowSizeChanged, this.isHorizontal=${this.isHorizontal}`);
    this.listCardMargin = updateAlbumPageGridPaddingLeftAndRight(true);
  }

  private createActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle($r('app.string.optimize_gallery_space'))
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
    return actionBarProp;
  }

  private createHorizontalActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle($r('app.string.optimize_gallery_space'))
      .setTitleFontSize(DeviceInfo.isPc() ? ActionBarProp.TITLE_TEXT_SIZE :
      ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE)
      .setIsLevelOneHeadTitle(true)
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

  private getSelectIndex(isHover: boolean, index: number | undefined): void {
    if (isHover) {
      this.hoverSelectIndex = index;
    } else {
      this.hoverSelectIndex = undefined;
    }
  }

  build() {
    Stack() {
      Navigation(this.pageInfo) {
        Stack({ alignContent: Alignment.End }) {
          this.buildGalleryCleanupContent();
        }
      }
      .backButtonIcon($r('sys.symbol.chevron_backward'))
      .backgroundColor($r('sys.color.background_secondary'))
      .hideTitleBar(true)
      .opacity(1)
      .mode(NavigationMode.Stack)
      .title('GalleryCleanupPage')
      .hideToolBar(true)
      .navDestination(this.PageMap)
      .transition(TransitionEffect.OPACITY)

      // 单独对UIExt的页面添加应用锁
      if (this.isAppLockShow && this.isUIExt) {
        // PickerMaskLayer({
        //   onclose: () => {
        //     Log.info(TAG, 'PickerMaskLayer onclose!');
        //   },
        //   appInfos: [{
        //     bundleName: 'com.ohos.photos',
        //     appIndex: 0,
        //   }],
        //   maskShow: this.isAppLockShow,
        //   unlockProxy: true,
        //   currentMode: this.currentMode,
        // })
      }
    }
  }

  @Builder
  PageMap(name: string) {
    if (name === NavigationConstants.NAVIGATION_VIDEO_CLEANUP_PAGE) {
      VideoCleanupPage({
        albumInfo: this.videoAlbumInfo,
        storage: storage,
      });
    } else if (name === NavigationConstants.NAVIGATION_SCREENSHOT_PHOTO_PAGE ||
    NavigationConstants.NAVIGATION_RECENTLY_DELETED_CLEANUP_PAGE) {
      GridCleanupPage({
        albumInfo: this.getAlbumInfo(name),
        storage: storage,
      })
    }
  }

  private getAlbumInfo(name: string): AlbumInfo | undefined {
    if (name === NavigationConstants.NAVIGATION_RECENTLY_DELETED_CLEANUP_PAGE) {
      return this.trashAlbumInfo;
    } else if (name === NavigationConstants.NAVIGATION_SCREENSHOT_PHOTO_PAGE) {
      return this.screenshotAlbum;
    }
    return undefined;
  }

  private getImageCover(album: AlbumInfo): Resource {
    if (album.isTrashAlbum) {
      return $r('sys.symbol.trash_fill');
    } else if (album.isVideoAlbum) {
      return $r('sys.symbol.video_fill');
    }
    return $r('sys.symbol.picture_fill');
  }

  /**
   * 点击时间处理
   *
   * @param album 点击的相册对象
   */
  private handleClick(album: AlbumInfo): void {
    Log.info(TAG, 'handleClick');
    this.selectId = album.uri;
    if (album.isTrashAlbum) {
      this.pageInfo.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_RECENTLY_DELETED_CLEANUP_PAGE, null));
    } else if (album.isVideoAlbum) {
      this.pageInfo.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_VIDEO_CLEANUP_PAGE, null));
    } else if (album.isScreenShotAlbum) {
      this.pageInfo.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_SCREENSHOT_PHOTO_PAGE, null));
    }
    Log.info(TAG, `handleClick: this.pageInfo=${this.pageInfo.getAllPathName()}`);
  }

  @Builder
  buildAlbumNameAndSize(item: AlbumInfo) {
    Column() {
      Text(item.albumName)
        .draggable(false)
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.ohos_id_color_primary'))
        .maxLines(1)
        .maxFontScale(Constants.GALLERY_CLEANUP_PAGE_MAX_FONT_SCALE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          bottom: '2vp',
        });

      Text(ImageUtil.formatFileSize(this.getAlbumAssetSize(item)))// 相册总大小
        .draggable(false)
        .fontColor($r('sys.color.font_secondary'))
        .fontFamily('HarmonyHeiTi')
        .fontSize(Constants.TEXT_SIZE_BODY2)
        .maxFontScale(Constants.GALLERY_CLEANUP_PAGE_MAX_FONT_SCALE)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis });
    }
    .flexShrink(1)
    .alignItems(HorizontalAlign.Start)
    .margin({
      left: $r('app.float.crop_vertical_padding'),
      right: $r('app.float.list_card_margin'),
      top: this.listPaddingTopAndBottom,
      bottom: this.listPaddingTopAndBottom,
    })
    .alignRules({
      left: { anchor: 'row1', align: HorizontalAlign.End },
      right: { anchor: 'row4', align: HorizontalAlign.Start },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    })
    .id('row2')
  }

  @Builder
  buildImage(iconResource: Resource, album: AlbumInfo) {
    Row() {
      if (album.isScreenShotAlbum) {
        Image($r('app.media.rectangle_and_cut_fill'))
          .draggable(false)
          .aspectRatio(1)
          .width($r('app.float.list_item_left_icon_size'))
          .fillColor($r('sys.color.ohos_id_color_secondary'))
      } else {
        SymbolGlyph(iconResource)
          .draggable(false)
          .fontSize($r('app.float.list_item_left_icon_size'))
          .fontColor([$r('sys.color.icon_secondary')])
      }
    }
    .width($r('app.float.list_item_left_icon_bg_size'))
    .height($r('app.float.list_item_left_icon_bg_size'))
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .border({
      radius: $r('sys.float.ohos_id_corner_radius_grid'),
    })
    .borderWidth($r('app.float.checkbox_unselected_border_width'))
    .borderColor($r('app.color.highlight_border_color'))
    .justifyContent(FlexAlign.Center)
    .alignRules({
      left: { anchor: '__container__', align: HorizontalAlign.Start },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    })
    .id('row1')
  }

  @Builder
  albumListItem(item: AlbumInfo) {
    Row() {
      RelativeContainer() {
        this.buildImage(this.getImageCover(item), item);
        this.buildAlbumNameAndSize(item);

        SymbolGlyph($r('sys.symbol.chevron_right'))
          .draggable(false)
          .fontSize($r('app.float.list_item_right_icon2_height'))
          .fontColor([$r('sys.color.icon_fourth')])
          .alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .id('row3');

        Row() {
          Text(String(this.getAlbumAssetCount(item)))
            .draggable(false)
            .fontColor($r('sys.color.font_secondary'))
            .fontFamily('HarmonyHeiTi')
            .fontSize(Constants.TEXT_SIZE_BODY2)
            .maxLines(1)
            .maxFontScale(Constants.GALLERY_CLEANUP_PAGE_MAX_FONT_SCALE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({
              right: '4vp',
            })
        }.alignRules({
          right: { anchor: 'row3', align: HorizontalAlign.Start },
          center: { anchor: '__container__', align: VerticalAlign.Center },
        })
        .id('row4');
      }
      .height('100%')
    }
    .width('100%')
    .height($r('app.float.list_item_height'))
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .constraintSize({ minHeight: $r('app.float.list_item_height') })
  }

  @Builder
  buildGalleryCleanupContent() {
    Column() {
      Stack() {
        this.buildActionBar();
        if (!this.isAgreed) {
          NoPhotoComponent({
            title: $r('app.string.no_photos_videos_head_title_album'),
            isFromEmptyAlbum: true,
          });
        } else {
          List() {
            this.buildCleanupAlbumList();
          }
          .alignListItem(ListItemAlign.Center)
          .scrollBar(BarState.Off)
          .height('100%')
          .padding({ top: DeviceInfo.isPc() ? $r('sys.float.padding_level8') : $r('sys.float.padding_level4') })
          .contentStartOffset(this.contentStartOffset())
          .contentEndOffset(this.getMarginBottom())
          .margin({
            left: this.listCardMargin,
            right: this.listCardMargin
          })
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        }
      }
      .height('100%')
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .height('100%')
    .padding({
      top: this.getTopHeight(),
    })
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM]);
  }

  private getTopHeight(): number {
    let uiExtensionAbilityTop: number = this.isHorizontal ? 0 : px2vp(this.topRectHeight);
    return this.isFromShortcutEntryPage ? px2vp(this.topRectHeight) : uiExtensionAbilityTop;
  }

  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action?.actionID]}`);
    if (action.actionID === Action.BACK.actionID) {
      this.onHandBack();
    }
  }

  private onHandBack() {
    Log.info(TAG, 'onHandBack');
    let session: UIExtensionContentSession | undefined =
      storage?.get<UIExtensionContentSession>('GalleryCleanupSession');
    if (!session) {
      Log.info(TAG, 'ability terminate page');
      let context = storage.get<Context>('photosAbilityContext') as common.UIAbilityContext
      context?.terminateSelf();
      return
    }
    session?.sendData({ 'isShowCleanupPage': false });
    session?.terminateSelf();
  }

  private getListItemCode(item: AlbumSetDataInfo, index: number | undefined): string {
    if (!item || !item.data) {
      return (TAG + index) as string;
    }
    if (item.data.mediaItem) {
      return item.data.getHashCode() + item.data.mediaItem.getHashCode();
    }
    return item.data.getHashCode();
  }

  @Builder
  buildCleanupAlbumList() {
    ListItemGroup({ style: ListItemGroupStyle.NONE }) {
      LazyForEach(this.cleanupAlbums, (item: AlbumSetDataInfo, index?: number) => {
        ListItem() {
          if (this.checkAlbum(item?.data)) {
            this.albumListItem(item.data);
          }
        }
        .key(`MediaOperationPageAlbum${index}`)
        .padding({
          left: $r('app.float.MediaOperation_list_card_padding'),
          right: $r('app.float.MediaOperation_list_card_padding'),
        })
        .margin({
          top: index === 0 ? $r('app.float.list_item_top_bottom_padding') : 0,
          bottom: this.cleanupAlbums !== undefined && index === this.cleanupAlbums.totalCount() - 1 ?
            $r('app.float.list_item_top_bottom_padding') : 0,
        })
        .borderRadius($r('sys.float.corner_radius_level8'))
        .hoverEffect(HoverEffect.Highlight)
        .backgroundColor(this.hoverSelectIndex === index && this.currentMode ===
        ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('sys.color.comp_background_list_card') : undefined)
        .stateStyles({
          focused: {
            .backgroundColor($r('sys.color.interactive_click'))
          },
          pressed: {
            .backgroundColor($r('sys.color.interactive_click'))
          },
          selected: {
            .backgroundColor($r('sys.color.comp_background_emphasize'))
          }
        })
        .onHover((isHover: boolean, event: HoverEvent): void => {
          this.getSelectIndex(isHover, index);
        })
        .onClick((): void => {
          this.handleClick(item.data);
          Log.info(TAG, `sourceCard click and albumName = ${item.data.albumName}`);
        })
      }, (item: AlbumSetDataInfo, index?: number) => {
        return this.getListItemCode(item, index);
      })
    }
    .padding({
      left: $r('app.float.list_item_left_right_padding'),
      right: $r('app.float.list_item_left_right_padding'),
    })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10'))
    .divider({
      strokeWidth: '1px',
      startMargin: this.dividerMarginStart,
      endMargin: $r('app.float.list_item_right_icon2_margin_right'),
      color: $r('sys.color.ohos_id_color_list_separator'),
    })
  }

  checkAlbum(albumInfo: AlbumInfo | undefined): boolean {
    if (albumInfo) {
      if (albumInfo.isVideoAlbum) {
        this.videoAlbumInfo = albumInfo;
      } else if (albumInfo.isTrashAlbum) {
        this.trashAlbumInfo = albumInfo;
      } else if (albumInfo.isScreenShotAlbum) {
        this.screenshotAlbum = albumInfo;
      }
      return true;
    }
    return false;
  }

  @Builder
  buildActionBar() {
    Column() {
      ActionBar({
        actionBarProp: this.actionBarProp,
        isNeedPlaceholder: this.isNeedPlaceholder,
        actionMoreMenuList: undefined,
        onMenuClicked: this.onMenuClickedFunc,

      })
    }
    .zIndex(2)
    .position({ y: 0 })
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
    .backgroundColor($r('app.color.transparent'))
  }

  private onBackPressed(): boolean {
    Log.info(TAG, 'navDestination onBackPressed');
    this.onHandBack();
    return true;
  }

  private calcMargin(isLeftMargin: boolean): Length {
    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      return this.isHorizontal ? $r('app.float.list_item_right_icon1_size')
        : $r('app.float.list_item_right_icon1_margin_left');
    }
    if (this.isHorizontal && DeviceInfo.isPhoneUx() && !this.isFoldExpanded) {
      return isLeftMargin ? this.diggingHoleCameraArea.left : this.diggingHoleCameraArea.right;
    }
    return 0;
  }

  private contentStartOffset(): number {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return Constants.WindowDecorHeight;
    }
    return Constants.ActionBarHeight;
  }

  private getMarginBottom(): number {
    if (this.isVerdeFoldable) {
      return Constants.COLUMN_MARGIN;
    }
    return this.leftBlank[3] + Constants.ToolBarHeight;
  }

  private onPageChanged(): void {
    Log.info(TAG, `onPageChanged: this.isCleanupPageShow=${this.isCleanupPageShow}`);
    if (this.isCleanupPageShow) {
      this.updateIsAgreed();
    }
  }

  private async updateIsAgreed(): Promise<void> {
    if (this.isAgreed) {
      return;
    }
    let context: common.UIAbilityContext | undefined =
      storage.get<common.UIAbilityContext>('photosAbilityContext');
    if (context) {
      this.isAgreed = await Protocol.getIsAgreedPref(context) ?? false;
    }
    if (this.isAgreed && this.cleanupAlbums) {
      this.cleanupAlbums.loadData();
      MediaObserver.getInstance().registerObserver(this.dataObserver);
      Log.info(TAG, `GalleryCleanupPage: cleanupAlbums load data!`)
    }
    Log.info(TAG, `GalleryCleanupPage-isAgreed=${this.isAgreed}`)
  }
}
