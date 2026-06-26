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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MenuPopUp } from '@ohos/common/src/main/ets/default/view/menu/MenuView';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { MORE_MENU_ITEM_HEIGHT } from '@ohos/common/src/main/ets/default/view/actionbar/MoreAction';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';
import lazy { AlbumSetDataSource } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSource';
import lazy {
  AlbumSetDataSourceManager
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSourceManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy {
  Constants as BrowserConstants,
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { RightClickMenuVM } from '../viewModel/base/RightClickMenuVm';
import lazy {
  SourceTypeAlbumDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/SourceTypeAlbumDataSource';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { MediaOperationType } from '@ohos/common/src/main/ets/default/model/common/MediaOperationType';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { MenuController, MenuPopUpParams, PopType } from '@ohos/common/src/main/ets/default/view/menu/MenuController';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { SymbolGlyphModifier } from '@kit.ArkUI';
import lazy { PhotoPropertiesUtil } from '@ohos/common/src/main/ets/default/utils/PhotoPropertiesUtil';

/* instrument ignore file  */
const TAG: string = 'common_RightClickMenu';

/**
 * 菜单参数
 */
export interface UpdateMenuParam {
  pageFrom: number;
  isUserCreatedAlbum: boolean;
  isVideoPlaying: boolean;
  isInSelectedMode: boolean;
  isSelected: boolean;
  isFromPCPhotoBrowserModule: boolean;
}

/**
 * 右键菜单逻辑控制器工厂
 */
class RightClickMenuVMFactory {
  /**
   * 获取右键菜单逻辑控制器
   *
   * @param item 菜单选项
   * @returns 目标产品右键菜单逻辑控制器
   */
  public static getRightClickMenuVM(item: MediaItem): RightClickMenuVM {
    return new RightClickMenuVM(item);
  }
}

/**
 * 右键菜单
 */
@Component
export struct RightClickMenu {
  @Prop @Watch('setMenuGroup') isVideoPlaying: boolean;
  @Link item: MediaItem;
  @Link isFirstClickPlay: boolean;
  /**
   * 广播，用于保存关键监听回调
   */
  /* instrument ignore next */
  @Link broadCast: BroadCast;
  /* instrument ignore next */
  @Consume pageFrom: number;
  albumUri: string = '';
  /**
   * 是否是pc相机场景拉起的大图
   */
  isPcCameraPull: boolean = false;
  isUserCreatedAlbum: boolean = false;
  /**
   * 判断是否处于选择模式
   */
  isInSelectedMode: boolean = false;
  isFromPCPhotoBrowserModule: boolean = false;

  /* instrument ignore next */
  selectStateChange: Function = (): void => {
  };

  handlePauseClick: Function = (): void => {
  };

  /* instrument ignore next */
  isSelected: Function = (): boolean => {
    return false;
  };

  @State private viewModel: RightClickMenuVM = RightClickMenuVMFactory.getRightClickMenuVM(this.item);
  @State private menuController: MenuController = this.viewModel.menuController;
  /* instrument ignore next */
  private albumBroadCast: BroadCast = AlbumSetDataSourceManager.getInstance().getBroadCast();
  /* instrument ignore next */
  private albums: AlbumSetDataSource = AlbumSetDataSourceManager.getInstance().getDataSource();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  /* instrument ignore next */
  private sourceTypeAlbumsDataSource: SourceTypeAlbumDataSource =
    new SourceTypeAlbumDataSource(getContext(this), Constants.SOURCE_ALBUM_MIN_COUNT, new BroadCast());
  /**
   * isUseCustomShortKey,是否使用自定义的shortKey
   */
  private isUseCustomShortKey: boolean = false;

  private currentAlbumUri = AppStorage.get<string>(Constants.KEY_OF_ALBUM_URI);

  private setMenuGroupFunc: Function = (): void => this.setMenuGroup();

  /* instrument ignore next */
  private onPCMoveCompletedFunc: Function = (albumInfo: AlbumInfo, index?: number): void => {
    this.onPCMoveCompleted(albumInfo, index)
  };

  aboutToAppear(): void {
    this.viewModel.onLoadRightClickMenu(this.getUpdateMenuParam());
    this.setMenuGroup();
    this.broadCast.on(BrowserConstants.SET_MENU_GROUP_PHOTO_ITEM, this.setMenuGroupFunc);
  }

  aboutToDisappear(): void {
    this.broadCast.off(BrowserConstants.SET_MENU_GROUP_PHOTO_ITEM, this.setMenuGroupFunc);
  }

  private getUpdateMenuParam(): UpdateMenuParam {
    let param: UpdateMenuParam = {
      pageFrom: this.pageFrom,
      isUserCreatedAlbum: this.isUserCreatedAlbum,
      isVideoPlaying: this.isVideoPlaying,
      isInSelectedMode: this.isInSelectedMode,
      isSelected: this.isSelected(),
      isFromPCPhotoBrowserModule: this.isFromPCPhotoBrowserModule,
    }
    return param;
  }

  private setMenuGroup(): void {
    this.viewModel.setMenuGroup(this.getUpdateMenuParam());
  }

  /* instrument ignore next */
  public onPCMoveCompleted(albumInfo: AlbumInfo, index?: number): void {
    Log.info(TAG, `PhotoItem onPCMoveCompleted: album=${albumInfo.uri}`);
    this.albumBroadCast.emit(BroadCastConstants.SIDEBAR_VIEW_SWITCH, [albumInfo, Action.MOVE.actionID, index]);
  }

  /* instrument ignore next */
  private changeTextRes(action: Action): Resource {
    Log.info(TAG, `changeTextRes:${action.componentKey}`);
    let textStr: Resource = action.textRes;
    if (Action.NOT_FAVORITE.equals(action) || Action.FAVORITE.equals(action)) {
      textStr = this.item.isFavor ? Action.FAVORITE.textRes : Action.NOT_FAVORITE.textRes;
    }
    return textStr;
  }

  /* instrument ignore next */
  private isPcMoveMenu(menu: Action): boolean {
    return menu.equals(Action.MOVE) && DeviceInfo.isPc();
  }

  /* instrument ignore next */
  private getAlbumHashCode(item: AlbumSetDataInfo, index?: number): string {
    if (!item?.data) {
      return TAG + String(index);
    }
    if (item.data.mediaItem) {
      return item.data.getHashCode() + item.data.mediaItem.getHashCode();
    }
    return item.data.getHashCode();
  }

  private moveMenuBlock(albumInfo?: AlbumInfo): boolean {
    Log.info(TAG, `mediaType: ${this.item.mediaType}`);
    let videoFlag: boolean = (albumInfo?.lpath === '/Pictures/Screenrecords' &&
      this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE);
    let screenshotsFlag: boolean = (albumInfo?.lpath === '/Pictures/Screenshots' &&
      this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO);
    return videoFlag || screenshotsFlag;
  }

  private getMenuPopUpParams(): MenuPopUpParams {
    Log.info(TAG, `getMenuPopUpParams, isUseCustomShortKey: ${this.isUseCustomShortKey}`);
    const params: MenuPopUpParams = {
      isSelected: this.isSelected(),
      mediaItem: this.item,
      appBroadCast: this.appBroadCast,
      onMenuClick: (menu: Action): void => this.onMenuClick(menu),
      albumUri: this.albumUri,
      albums: this.albums,
      sourceTypeAlbumsDataSource: this.sourceTypeAlbumsDataSource,
      type: PopType.MOVE,
      moveBroadCastKey: BroadCastConstants.PC_MEDIA_OPERATION_BROWSER,
      isUseCustomShortKey: this.isUseCustomShortKey,
    }
    return params;
  }

  private onMenuClick(menu: Action): void {
    Log.info(TAG, `on right click menu, action: ${ActionID[menu.actionID]}`);
    if ([Action.SELECTED.actionID, Action.MATERIAL_SELECT.actionID].includes(menu.actionID)) {
      this.selectStateChange();
      this.setMenuGroup();
    } else if (Action.VIDEO_PAUSE.equals(menu) && this.isFirstClickPlay) {
      this.handlePauseClick();
    } else {
      if (this.isPcCameraPull) {
        this.appBroadCast.emit(BroadCastConstants.MENU_ACTION_FROM_PHOTO_CAMERA, [menu, menu.actionID]);
      } else {
        this.appBroadCast.emit(BroadCastConstants.MENU_ACTION_FROM_PHOTO_ITEM, [menu]);
      }
    }
  }

  /* instrument ignore next */
  @Builder
  buildMoveSubMenu() {
    Menu() {
      MenuItemGroup() {
        MenuItem({
          content: this.changeTextRes(Action.NEW_ALBUM),
        })
          .height(Constants.MENU_ITEM_HEIGHT_PC)
          .onClick((): void => {
            Log.info(TAG, `buildMoveSubMenu click: ${ActionID[Action.NEW_ALBUM.actionID]}`);
            this.appBroadCast.emit(BroadCastConstants.PC_MEDIA_OPERATION_BROWSER, [MediaOperationType.NEW]);
          })
        MenuItem()
          .margin({
            bottom: $r('sys.float.padding_level2'),
          })
      }
      .width('auto')
      .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })

      MenuItemGroup() {
        LazyForEach(this.albums as AlbumSetDataSource, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => {
          return this.getAlbumHashCode(item, index);
        });

        LazyForEach(this.sourceTypeAlbumsDataSource, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => {
          return this.getAlbumHashCode(item, index);
        });
      }
      .width('auto')
      .margin({ top: $r('sys.float.padding_level2') })
      .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })
    }
  }

  /* instrument ignore next */
  @Builder
  buildAlbumMenu(albumInfo?: AlbumInfo, index?: number) {
    /* instrument ignore next */
    if (albumInfo && !albumInfo?.isSystemAlbum && albumInfo?.uri !== this.currentAlbumUri &&
      !this.moveMenuBlock(albumInfo)) {
      MenuItem({
        content: albumInfo.albumName,
      })
        .key(`AlbumMenu${index}`)
        .height(Constants.MENU_ITEM_HEIGHT_PC)
        .onClick((): void => {
          if (albumInfo.isSourceAlbum) {
            this.appBroadCast.emit(BroadCastConstants.PC_MEDIA_OPERATION_BROWSER,
              [MediaOperationType.MOVE, albumInfo.albumName, albumInfo.uri,
                this.onPCMoveCompletedFunc(albumInfo, index)]);
          } else {
            this.appBroadCast.emit(BroadCastConstants.PC_MEDIA_OPERATION_BROWSER,
              [MediaOperationType.MOVE, albumInfo.albumName, albumInfo.uri, this.onPCMoveCompletedFunc(albumInfo)]);
          }
        })
    } else {
      MenuItem()
        .visibility(Visibility.None)
        .height(Constants.MENU_ITEM_HEIGHT_PC)
    }
  }

  /* instrument ignore next */
  @Builder
  MenuItemBuilder(menu: Action, isAddMarginBetweenItems: boolean = false) {
    /* instrument ignore next */
    MenuItem({
      content: this.changeTextRes(menu),
      labelInfo: menu.shortKey,
      builder: this.isPcMoveMenu(menu) ? (): void => this.buildMoveSubMenu() : undefined,
      symbolEndIcon: this.isPcMoveMenu(menu) ?
      new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize('24vp') : undefined,
    }) {
    }
    .height(MORE_MENU_ITEM_HEIGHT)
    .margin({
      top: isAddMarginBetweenItems && DeviceInfo.isPc() ? $r('sys.float.padding_level1') : undefined,
      left: Constants.MENU_ITEM_START_MARGIN,
      right: Constants.MENU_ITEM_START_MARGIN,
    })
    /* instrument ignore next */
    .onClick((): void => {
      Log.info(TAG, `on right click menu, action: ${ActionID[menu.actionID]}`);
      if ([Action.SELECTED.actionID, Action.MATERIAL_SELECT.actionID].includes(menu.actionID)) {
        this.selectStateChange();
        this.setMenuGroup();
      } else if (Action.VIDEO_PAUSE.equals(menu) && this.isFirstClickPlay) {
        this.handlePauseClick();
      } else {
        if (this.isPcCameraPull) {
          this.appBroadCast.emit(BroadCastConstants.MENU_ACTION_FROM_PHOTO_CAMERA, [menu, menu.actionID]);
        } else {
          this.appBroadCast.emit(BroadCastConstants.MENU_ACTION_FROM_PHOTO_ITEM, [menu]);
        }
      }
    })
  }

  /* instrument ignore next */
  @Builder
  MenuItemBuilderNormal(menuGroup: Action[]) {
    MenuItemGroup() {
      ForEach(menuGroup, (menu: Action, index: number) => {
        this.MenuItemBuilder(menu, index > 0);
      }, (item: Action) => JSON.stringify(item))
    }
    .width(DeviceInfo.isPc() ? 'auto' : undefined)
    .constraintSize({ minWidth: DeviceInfo.isPc() ? Constants.FORTH_MENU_ITEM_WIDTH_PC : undefined })
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
    }) {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        MenuPopUp({
          controller: this.menuController,
          menuPopUpParams: this.getMenuPopUpParams(),
        })
          .width($r('app.float.more_menu_width'))
          .key('PhotoItem_Menu')
      } else {
        Menu() {
          ForEach(this.viewModel.rightClickMenuList, (menuGroup: Action[]) => {

          })
        }
        .menuItemGroupDivider(undefined)
        .padding({
          left: Constants.MENU_LEFT_PADDING,
          right: Constants.MENU_LEFT_PADDING,
          top: Constants.MENU_TOP_PADDING,
          bottom: Constants.MENU_TOP_PADDING,
        })
        .key('PhotoItem_Menu')
        .width($r('app.float.more_menu_width'))
        .radius($r('sys.float.corner_radius_level10'))
      }
    }
  }
}