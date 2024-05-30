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

import {
  Action,
  AlbumInfo,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  BrowserConstants,
  ColumnSize,
  Constants,
  Log,
  MultimodalInputManager,
  ScreenManager,
  UiUtil,
  UserFileManagerAccess
} from '@ohos/common';
import { EmptyAlbumComponent } from './EmptyAlbumComponent';
import router from '@ohos.router';

const TAG: string = 'browser_AlbumGridItemNewStyle';

@Extend(Image) 
function focusSetting(id: string) {
  .key('AlbumFocus_' + id)
  .focusable(true)
}

interface ParamAlbumInfo {
  item: string;
  isFromFACard?: boolean;
}

// The item of album grid, and it's new style.
@Component
export struct AlbumGridItemNewStyle {
  @State @Watch('updateCard') item: AlbumInfo = new AlbumInfo(undefined);
  @State isEmptyAlbum: boolean = false;
  @State isSelected: boolean = false;
  @State selectable: boolean = true;
  @Provide gridHeight: number = 0;
  @Provide gridWidth: number = 0;
  @Link bottomHeight: number;
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @Consume broadCast: BroadCast;
  @Consume('selectedCount') selectedCount: number;
  @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
  @Consume rightClickMenuList: Array<Action>;
  currentRightClickMenuList: Array<Action> = [];
  onMenuClicked: Function = (): void => {};
  onMenuClickedForSingleItem: Function = (): void => {};
  gridAspectRatio = Constants.CARD_ASPECT_RATIO;
  albumCountMarginRight = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN * 2;
  iconMarkAnchorX = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  iconMarkAnchorY = Constants.ALBUM_SET_NEW_ICON_SIZE + Constants.ALBUM_SET_NEW_ICON_MARGIN;
  @StorageLink('deviceType') deviceType: string | undefined = AppStorage.get<string>('deviceType');
  @State transitionId: string = '';
  @StorageLink('isShowPhotoGridView') isShowPhotoGridView: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private keyIndex?: number;
  private fp2vpUnit: number = px2vp(fp2px(Constants.NUMBER_1));
  private recycleAlbumOfPhoneHeight: number = Constants.RECYCLE_ALBUM_OF_PHONE_HEIGHT;
  private updateCardSizeFunc: Function = (): void => this.updateCardSize();

  doAnimation(): void {
    let albumToPhotoGridDuration: number;
    let albumToPhotoGridScaleDuration: number;
    let albumActionBarDuration: number;
    let photoGridActionBarDuration: number;
    let photoGridActionBarDelay: number;
    if (this.deviceType !== Constants.PC_DEVICE_TYPE) {
      albumToPhotoGridDuration = BrowserConstants.PHONE_LINK_ALBUM_TO_PHOTO_GRID_DURATION;
      albumToPhotoGridScaleDuration = BrowserConstants.PHONE_LINK_ALBUM_TO_PHOTO_GRID_SCALE_DURATION;
      albumActionBarDuration = BrowserConstants.PHONE_LINK_ALBUM_ACTIONBAR_DURATION;
      photoGridActionBarDuration = BrowserConstants.PHONE_LINK_IN_PHOTO_GRID_ACTIONBAR_DURATION;
      photoGridActionBarDelay = BrowserConstants.PHONE_LINK_PHOTO_GRID_ACTIONBAR_DELAY
    } else {
      albumToPhotoGridDuration = BrowserConstants.PC_LINK_ALBUM_TO_PHOTO_GRID_DURATION;
      albumToPhotoGridScaleDuration = BrowserConstants.PC_LINK_ALBUM_TO_PHOTO_GRID_SCALE_DURATION;
      albumActionBarDuration = BrowserConstants.PC_LINK_IN_ALBUM_ACTIONBAR_DURATION;
      photoGridActionBarDuration = BrowserConstants.PC_LINK_IN_PHOTO_GRID_ACTIONBAR_DURATION;
      photoGridActionBarDelay = BrowserConstants.PC_LINK_PHOTO_GRID_ACTIONBAR_DELAY;
    }
    animateTo({
      duration: albumToPhotoGridDuration,
      curve: Curve.Friction,
    }, () => {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW,!this.isShowPhotoGridView);
      AppStorage.setOrCreate<number>(Constants.KEY_OF_SELECTED_ALBUM_INDEX, this.keyIndex ? this.keyIndex : -1);
      AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, this.item.uri);
    })
    animateTo({
      duration: albumActionBarDuration,
      curve: Curve.Sharp
    }, () => {
      if (AppStorage.get<string>('deviceType') !== Constants.PC_DEVICE_TYPE) {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 0);
      }
      AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_ACTIONBAR_OPACITY, 0);
    })
    animateTo({
      duration: albumActionBarDuration,
      curve: Curve.Sharp,
      delay: BrowserConstants.LINK_IN_PHOTO_GRID_DELAY,
    }, () => {
      if (AppStorage.get<string>('deviceType') !== Constants.PC_DEVICE_TYPE) {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
      }
    })
    animateTo({
      duration: albumToPhotoGridScaleDuration,
      curve: Curve.Friction
    }, () => {
      AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OTHER_SCALE, BrowserConstants.Album_Scale);
    })
    animateTo({
      duration: photoGridActionBarDuration,
      delay: photoGridActionBarDelay,
      curve: Curve.Sharp
    }, () => {
      AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);
    })

    if (AppStorage.get<string>('deviceType') !== Constants.PC_DEVICE_TYPE) {
      animateTo({
        duration: BrowserConstants.PC_LINK_IN_PHOTO_GRID_DURATION,
        delay: BrowserConstants.LINK_IN_PHOTO_GRID_DELAY,
        curve: Curve.Sharp
      }, () => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
      })
      animateTo({
        duration: BrowserConstants.PC_LINK_ALBUM_DURATION,
        curve: Curve.Sharp
      }, () => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 0);
      })
      animateTo({
        duration: BrowserConstants.PC_LINK_IN_SIDEBAR_DURATION,
        curve: Curve.Sharp
      }, () => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_SIDE_BAR_OPACITY, 0);
        AppStorage.setOrCreate<number>(Constants.KEY_OF_SIDE_BAR_BOUNDARY_LINE_OPACITY, 0);
      })
    }

    Log.info(TAG, `doanimation`);
  }

  aboutToAppear(): void {
    Log.debug(TAG, `aboutToAppear`);
    this.selectable = !this.item.isTrashAlbum;

    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.updateCardSizeFunc);
    }
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
    this.updateCardSize();
    this.initCurrentRightClickMenuList();
  }

  aboutToDisappear(): void {
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.updateCardSizeFunc);
    }
  }

  updateCard() {
    Log.debug(TAG, 'Album changed and update card size.');
    this.updateCardSize();
  }

  updateCardSize(): void {
    let sideBarWidth: number = 0;
    let count: number = 0;
    let currentBreakpoint = AppStorage.get<string>('currentBreakpoint');
    if (currentBreakpoint === Constants.BREAKPOINT_LG && this.deviceType == Constants.PAD_DEVICE_TYPE) {
      sideBarWidth = Constants.PAD_TAB_BAR_WIDTH;
      count = UiUtil.getAlbumGridCount(true);
    } else {
      sideBarWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
      count = UiUtil.getAlbumGridCount(this.isSidebar);
    }
    let contentWidth = ScreenManager.getInstance().getWinWidth() - sideBarWidth;
    this.gridWidth = ((contentWidth - Constants.ALBUM_SET_MARGIN *
      2 - (Constants.ALBUM_SET_GUTTER * (count - 1))) / count);
    let numberHeight = Constants.TEXT_SIZE_BODY2 * this.fp2vpUnit;
    let nameHeight = Constants.TEXT_SIZE_SUB_TITLE1 * this.fp2vpUnit;

    UiUtil.getResourceNumber($r('sys.float.ohos_id_elements_margin_vertical_m')).then((value: number) => {
      this.bottomHeight = px2vp(value) + nameHeight + Constants.NUMBER_2 + numberHeight;
      this.gridHeight = this.gridWidth + this.bottomHeight;

      Log.info(TAG, 'updateCardSize gridWidth : ' + this.gridWidth + ',  gridHeight : ' + this.gridHeight);

      AppStorage.setOrCreate(Constants.KEY_OF_ALBUM_HEIGHT, this.gridHeight);
      AppStorage.setOrCreate(Constants.KEY_OF_ALBUM_WIDTH, this.gridWidth);
    });

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

  selectStateChange() {
    Log.info(TAG, `change selected.`);
    if (!this.isAlbumSetSelectedMode) {
      this.isAlbumSetSelectedMode = true;
    }
    if (this.selectable) {
      let newState: boolean = !this.isSelected;
      this.broadCast.emit(BroadCastConstants.SELECT,
        [this.item.uri, newState, this.item.isSystemAlbum, this.item.isSystemAlbum, (): void => {
          Log.info(TAG, 'enter callback');
          this.isSelected = newState;
        }]);
    }
  }

  initCurrentRightClickMenuList() {
    this.currentRightClickMenuList = [];
    if (!this.isAlbumSetSelectedMode) {
      this.currentRightClickMenuList.push(Action.MULTISELECT);
    }
    if (!this.item.isSystemAlbum) {
      this.currentRightClickMenuList.push(Action.RENAME);
      this.currentRightClickMenuList.push(Action.DELETE);
    }
  }

  @Builder
  RightClickMenuBuilder() {
    Column() {
      ForEach(this.isAlbumSetSelectedMode && this.isSelected ? this.rightClickMenuList : this.currentRightClickMenuList,
        (menu: Action) => {
          Text(this.changeTextResToPlural(menu))
            .width('100%')
            .height($r('app.float.menu_height'))
            .fontColor(menu.fillColor)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Regular)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .onClick(() => {
              Log.info(TAG, 'on right click menu, action: ' + menu.actionID);
              if (menu == Action.MULTISELECT) {
                this.selectStateChange();
              } else {
                // 1.当鼠标对着被选中的项按右键时，菜单中的功能，针对所有被选中的项做处理
                // 2.当鼠标对着未被选中的项按右键时，菜单中的功能，仅针对当前项处理，其他被选中的项不做任何处理
                if (this.isAlbumSetSelectedMode && this.isSelected) {
                  this.onMenuClicked && this.onMenuClicked(menu);
                } else {
                  this.onMenuClickedForSingleItem && this.onMenuClickedForSingleItem(menu, this.item);
                }
              }
            })
        }, (menu: Action) => menu.actionID.toString())
    }
    .width(ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_ONE_POINT_FIVE))
    .borderRadius($r('sys.float.ohos_id_corner_radius_card'))
    .padding({
      top: $r('app.float.menu_padding_vertical'),
      bottom: $r('app.float.menu_padding_vertical'),
      left: $r('app.float.menu_padding_horizontal'),
      right: $r('app.float.menu_padding_horizontal')
    })
    .backgroundColor(Color.White)
    .margin({
      right: $r('sys.float.ohos_id_max_padding_end'),
      bottom: $r('app.float.menu_margin_bottom')
    })
  }

  isRecycleAlbumOfPhoneLikeDevice(): boolean {
    return this.deviceType != Constants.PC_DEVICE_TYPE && this.item.isTrashAlbum;
  }

  @Builder
  recycleCard() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Image($r('app.media.ic_gallery_public_delete_line'))
        .width($r('app.float.phone_recycle_ico_size'))
        .height($r('app.float.phone_recycle_ico_size'))
        .fillColor($r('sys.color.ohos_id_color_button_normal'))
        .focusSetting(this.item.uri)
    }
    .width(this.gridWidth)
    .height(this.gridWidth)
    .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
    .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m')
    })
  }

  @Builder
  normalAlbumCard() {
    Image(this.item.coverUri)
      .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m') })
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Cover)
      .onError(() => {
        Log.debug(TAG, 'album is empty or its cover is error');
        this.isEmptyAlbum = true;
      })
      .focusSetting(this.item.uri)
  }

  @Builder
  albumCardInfo() {
    Column() {
      Text(this.getDisplayName(this.item))
        .key('AlbumCardDisplayName')
        .margin({ right: $r('app.float.album_set_name_margin_right') })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Text(String(this.item.count))
        .key('AlbumCardItemCount')
        .margin({ right: this.albumCountMarginRight, top: $r('app.float.photo_grid_gap') })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body3'))
    }
    .width('100%')
    .margin({ bottom: this.gridWidth - this.gridHeight })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.End)
    .padding({
      left: $r('sys.float.ohos_id_elements_margin_horizontal_m')
    })
  }

  @Builder
  selectedModeCheckBox() {
    Image(this.isSelected ? $r('app.media.ic_checkbox_on') : $r('app.media.ic_checkbox_off_overlay'))
      .height($r('app.float.album_set_new_style_icon'))
      .aspectRatio(1)
      .position({ x: '100%', y: '100%' })
      .markAnchor({ x: this.iconMarkAnchorX, y: this.iconMarkAnchorY })
  }

  @Builder
  favorAndVideoAlbumIcoDisplay() {
    Image(this.item.isFavorAlbum ? $r('app.media.ic_favorite_overlay') : $r('app.media.ic_video'))
      .height($r('app.float.album_set_new_style_icon'))
      .aspectRatio(1)
      .position({ x: '0%', y: '100%' })
      .markAnchor({ x: 0 - Constants.ALBUM_SET_NEW_ICON_MARGIN, y: this.iconMarkAnchorY })
  }

  @Builder
  maskLayer() {
    Image($r('app.media.gradient_mask_layer'))
      .height('50%')
      .width('100%')
      .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m') })
  }

  @Builder
  selectedModeBg() {
    Column()
      .height(this.gridWidth)
      .width(this.gridWidth)
      .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m') })
      .backgroundColor(this.isSelected && this.isAlbumSetSelectedMode && this.selectable
        ? $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.isEmptyAlbum) {
          EmptyAlbumComponent()
        }

        if (this.item.isTrashAlbum) {
          this.recycleCard()
        } else {
          this.normalAlbumCard()
        }

        if (!this.isSelected && (this.item.isFavorAlbum || this.item.isVideoAlbum ||
          (this.isAlbumSetSelectedMode && this.selectable))) {
          this.maskLayer()
        }

        this.albumCardInfo()

        if (this.item.isFavorAlbum || this.item.isVideoAlbum) {
          this.favorAndVideoAlbumIcoDisplay()
        }

        this.selectedModeBg()

        if (this.isAlbumSetSelectedMode && this.selectable) {
          this.selectedModeCheckBox()
        }
      }
    }
    .width(this.gridWidth)
    .height(this.gridWidth)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
    .geometryTransition(this.transitionId)
    .gesture(
      LongPressGesture()
        .onAction(() => {
          this.selectStateChange();
        })
    )
    .onClick(() => {
      if (!this.isRecycleAlbumOfPhoneLikeDevice() && this.item.mediaItem) {
        this.transitionId = `${this.item.mediaItem?.getHashCode()}_${this.item.uri}`;
      }
      this.albumOnClick();
    })
    .bindContextMenu(this.RightClickMenuBuilder, this.showRightClickPopup() ? ResponseType.RightClick : -1)
    .onKeyEvent((event?: KeyEvent) => {
      if (event != null && KeyType.Up == event.type) {
        switch (event.keyCode) {
          case MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER:
            this.albumOnClick();
            break;
          default:
            break;
        }
      }
    })
  }

  private changeTextResToPlural(action: Action): Resource {
    let textStr: Resource = action.textRes;
    if (Action.RECOVER.equals(action)) {
      textStr = this.isSelected
        ? $r('app.plural.action_recover_count', this.selectedCount, this.selectedCount)
        : $r('app.string.action_recover');
    } else if (Action.DELETE.equals(action)) {
      textStr = this.isSelected
        ? $r('app.plural.action_delete_count', this.selectedCount, this.selectedCount)
        : $r('app.string.action_delete');
    } else if (Action.MOVE.equals(action)) {
      textStr = this.isSelected
        ? $r('app.plural.move_to_album_count', this.selectedCount, this.selectedCount)
        : $r('app.string.move_to_album');
    } else if (Action.ADD.equals(action)) {
      textStr = this.isSelected
        ? $r('app.plural.add_to_album_count', this.selectedCount, this.selectedCount)
        : $r('app.string.add_to_album');
    }
    return textStr;
  }

  private albumOnClick() {
    if (this.isAlbumSetSelectedMode) {
      this.selectStateChange();
    } else {
      Log.info(TAG, `After onClick, MediaSet is: ${JSON.stringify(this.item)}`);
      if (this.item.isTrashAlbum && (AppStorage.get<string>('deviceType') !== Constants.PC_DEVICE_TYPE)) {
        router.pushUrl({
          url: 'pages/PhotoGridPage',
          params: {
            item: JSON.stringify(this.item)
          }
        });
      } else if (!this.isShowPhotoGridView) {
        let albumInfo: ParamAlbumInfo = { item: JSON.stringify(this.item) }
        AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, albumInfo);
        AppStorage.setOrCreate(Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT, this.transitionId);
        AppStorage.setOrCreate(Constants.KEY_OF_ALBUM_URI, this.item.uri);
        this.doAnimation();
      } else {
        Log.info(TAG, `PhotoGridView is show, has no focus, Users need to manually activate the focus.`);
      }
    }
  }

  private showRightClickPopup(): boolean {
    if (this.isAlbumSetSelectedMode && this.isSelected) {
      Log.debug(TAG, `Album ${this.item?.albumName} length1: ${this.rightClickMenuList.length}`);
      return this.rightClickMenuList.length > 0
    } else {
      Log.debug(TAG, `Album ${this.item?.albumName} length2: ${this.currentRightClickMenuList.length}`);
      return this.currentRightClickMenuList.length > 0
    }
  }

  private getDisplayName(albumInfo : AlbumInfo): Resource | string {
    let res = UiUtil.getDisplayNameResourceByAlbumInfo(albumInfo);
    if (res != null) {
      return res;
    }
    return this.item.albumName;
  } 
}