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

import lazy { Constants, SelectMediaType } from '../../model/common/Constants';
import lazy { RightClickMenuGroup } from './MenuController';
import lazy {
  MenuController,
  PopType,
  MenuPopUpParams,
} from './MenuController';
import lazy { MORE_MENU_ITEM_HEIGHT } from '../../view/actionbar/MoreAction';
import lazy { Log } from '../../utils/Log';
import lazy {
  Action,
  ActionID,
} from '../browserOperation/Action';
import lazy { AlbumSetDataInfo } from '../../model/common/AlbumSetDataInfo';
import lazy { AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { MediaOperationType } from '../../model/common/MediaOperationType';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { SymbolGlyphModifier } from '@ohos.arkui.modifier';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'MenuPopUp';

/**
 * popUp型 菜单弹框
 */
@Component
export struct MenuPopUp {
  @Link @Watch('onControllerChanged') controller: MenuController;
  @Prop menuPopUpParams: MenuPopUpParams;

  private onControllerChanged(): void {
    Log.info(TAG, `onControllerChanged ${this.controller.id}`);
  }

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
    let mediaItem: MediaItem | undefined = this.menuPopUpParams?.mediaItem;
    let videoFlag: boolean = false;
    let screenshotsFlag: boolean = false;
    let selectMediaType: number | undefined = this.menuPopUpParams?.selectMediaType;
    Log.info(TAG, `mediaType: ${mediaItem?.mediaType}`);
    if (!this.menuPopUpParams.isSelected) {
      // 长按图片弹出菜单，移动到菜单屏蔽；
      videoFlag = (albumInfo?.lpath === '/Pictures/Screenrecords' &&
        mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE);
      screenshotsFlag = (albumInfo?.lpath === '/Pictures/Screenshots' &&
        mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO);
    } else {
      // 选中图片右键弹出菜单
      videoFlag = (albumInfo?.lpath === '/Pictures/Screenrecords' &&
        (selectMediaType === SelectMediaType.IMAGE || selectMediaType === SelectMediaType.IMAGE_VIDEO));
      // videoFlag:只有图片或图片视频都有，视频录制相册不显示；
      screenshotsFlag = (albumInfo?.lpath === '/Pictures/Screenshots' &&
        (selectMediaType === SelectMediaType.VIDEO || selectMediaType === SelectMediaType.IMAGE_VIDEO));
      // screenshotsFlag:只有视频或视频图片都有，截图相册不显示；
    }
    return videoFlag || screenshotsFlag;
  }

  @Builder
  buildAlbumMenu(albumInfo?: AlbumInfo, index?: number) {
    if (albumInfo && !albumInfo?.isSystemAlbum && albumInfo?.uri !== this.menuPopUpParams.albumUri &&
      !this.moveMenuBlock(albumInfo)) {
      MenuItem({
        content: albumInfo.albumName,
      })
        .key(`AlbumMenu${index}`)
        .margin({ top: albumInfo.isUserCreatedAlbum && index == 0 ? 0 : $r('sys.float.padding_level1') })
        .height(Constants.MENU_ITEM_HEIGHT_PC)
        .onClick((): void => {
          Log.info(TAG, `buildAlbumMenu click: ${albumInfo.uri}`);
          this.menuPopUpParams.appBroadCast?.emit(this.menuPopUpParams.moveBroadCastKey ?
          this.menuPopUpParams.moveBroadCastKey : BroadCastConstants.PC_MEDIA_OPERATION,
            [MediaOperationType.MOVE, albumInfo.albumName, albumInfo.uri]);
        })
    } else {
      MenuItem()
        .visibility(Visibility.None)
        .height(Constants.MENU_ITEM_HEIGHT_PC)
    }
  }

  @Builder
  buildMoveSubMenu() {
    Menu() {
      MenuItemGroup() {
        MenuItem({
          content: Action.NEW_ALBUM.textRes,
        })
          .height(Constants.MENU_ITEM_HEIGHT_PC)
          .onClick((): void => {
            let logMsg: string[] = ['buildMoveSubMenu click'];
            logMsg.push(`actionID: ${ActionID[Action.NEW_ALBUM.actionID]}`);
            logMsg.push(`moveBroadCastKey: ${this.menuPopUpParams.moveBroadCastKey}`);
            Log.info(TAG, logMsg.join(', '));
            this.menuPopUpParams.appBroadCast?.emit(this.menuPopUpParams.moveBroadCastKey ?
            this.menuPopUpParams.moveBroadCastKey : BroadCastConstants.PC_MEDIA_OPERATION, [MediaOperationType.NEW]);
          })
        // MenuItemGroup 无法marginBottom
        MenuItem()
          .margin({
            bottom: $r('sys.float.padding_level2'),
          })
      }
      .width('auto')
      .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })
      MenuItemGroup() {
        LazyForEach(this.menuPopUpParams.albums as AlbumSetDataSource,
          (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => {
          return this.getAlbumHashCode(item, index);
        });

        LazyForEach(this.menuPopUpParams.sourceTypeAlbumsDataSource,
          (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
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

  @Builder
  MenuItemBuilderMove(menu: Action, isAddMarginBetweenItems: boolean = false, isLastItem: boolean = false) {
    MenuItem({
      content: menu.textRes,
      labelInfo: this.menuPopUpParams.isUseCustomShortKey ? '' : menu.shortKey,
      builder: menu.equals(Action.MOVE) ? (): void => this.buildMoveSubMenu() : undefined,
      symbolEndIcon: menu.equals(Action.MOVE) ?
      new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize('24vp') : undefined,
    })
      .enabled(true)
      .height(MORE_MENU_ITEM_HEIGHT)
      .margin({
        top: isAddMarginBetweenItems ? $r('sys.float.padding_level1') : undefined,
        bottom: isLastItem ? $r('sys.float.padding_level2') : undefined,
      })
      .onClick((): void => {
        Log.info(TAG, `MenuItemBuilderMove ${this.menuPopUpParams.onMenuClick}`);
        this.menuPopUpParams.onMenuClick(menu);
      })
  }

  private isEnable(menu: Action): boolean | undefined {
    return menu.equals(Action.SELECT_ALL) || menu.equals(Action.DESELECT_ALL)
  }

  @Builder
  MenuItemBuilderGrid(menu: Action, isAddMarginBetweenItems: boolean = false, isLastItem: boolean = false) {
    if (menu.equals(Action.PASTE_FROM_PASTEBOARD) && this.menuPopUpParams.isPasteboardHasData) {
      MenuItem({
        content: menu.textRes,
        labelInfo: menu.shortKey,
      }) {
        PasteButton({
          text: PasteDescription.PASTE,
        })
          .backgroundColor('#fff')
          .fontColor('#000')
          .onClick((): void => {
            Log.info(TAG, 'PasteButton onclick');
            this.menuPopUpParams.onMenuClick(menu);
            ContextMenu.close();
          })
      }
      .height(Constants.MENU_ITEM_HEIGHT_PC)
      .margin({
        top: isAddMarginBetweenItems ? $r('sys.float.padding_level1') : undefined,
        bottom: isLastItem ? $r('sys.float.padding_level2') : undefined,
      })
      .enabled(true)
    } else {
      MenuItem({
        content: menu.textRes,
        labelInfo: menu.shortKey,
      })
        .onClick((): void => {
          Log.info(TAG, 'MenuItem onclick');
          this.menuPopUpParams.onMenuClick(menu);
          ContextMenu.close();
        })
        .enabled(Boolean(this.isEnable(menu)))
        .height(Constants.MENU_ITEM_HEIGHT_PC)
        .margin({
          top: isAddMarginBetweenItems ? $r('sys.float.padding_level1') : undefined,
          bottom: isLastItem ? $r('sys.float.padding_level2') : undefined,
        })
    }
  }

  @Builder
  MenuItemBuilder(menu: Action, isAddMarginBetweenItems: boolean = false, isLastItem: boolean = false) {
    MenuItem({ content: menu.textRes, labelInfo: menu.shortKey })
      .height(Constants.MENU_ITEM_HEIGHT_PC)
      .margin({
        top: isAddMarginBetweenItems ? $r('sys.float.padding_level1') : undefined,
        bottom: isLastItem ? $r('sys.float.padding_level2') : undefined,
      })
      .width('auto')
      .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })
      .onClick((): void => {
        Log.info(TAG, `onMenuClick menu: ${menu.componentKey}`);
        this.menuPopUpParams.onMenuClick(menu);
      })
  }

  @Builder
  MenuItemBuilderNormal(menuGroup: RightClickMenuGroup, groupIndex: number, groupNumber: number) {
    MenuItemGroup() {
      ForEach(menuGroup.menuList, (menu: Action, index: number) => {
        if (this.menuPopUpParams.type === PopType.GRID) {
          // 只有每一个group最后的item才加 bottom间距，除了最后一个group
          this.MenuItemBuilderGrid(menu, index > 0, index === menuGroup.menuList.length - 1 &&
            groupIndex !== groupNumber - 1)
        } else if (this.menuPopUpParams.type === PopType.MOVE) {
          // 只有每一个group最后的item才加 bottom间距，除了最后一个group
          this.MenuItemBuilderMove(menu, index > 0, index === menuGroup.menuList.length - 1 &&
            groupIndex !== groupNumber - 1)
        } else {
          // 只有每一个group最后的item才加 bottom间距，除了最后一个group
          this.MenuItemBuilder(menu, index > 0, index === menuGroup.menuList.length - 1 &&
            groupIndex !== groupNumber - 1)
        }
      }, (item: Action) => `${item.componentKey}${item.actionID}`)
    }
    .width('auto')
    // 商务感规范 分割线上间距为4，但是第一个group默认上边距已有4 要排除
    .margin({ top: groupIndex !== 0 ? $r('sys.float.padding_level2') : undefined })
    .constraintSize({ minWidth: Constants.MENU_ITEM_WIDTH_PC })
  }

  build() {
    Menu() {
      ForEach(this.controller?.getMenuGroupListWithoutEmpty(), (menuGroup: RightClickMenuGroup, groupIndex: number) => {
        this.MenuItemBuilderNormal(menuGroup, groupIndex, this.controller?.getMenuGroupListWithoutEmpty().length);
      }, (menuGroup: RightClickMenuGroup) => JSON.stringify(menuGroup.menuList.map(action => action.actionID)))
    }
  }
}