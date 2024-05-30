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

import Curves from '@ohos.curves';
import { Log } from '../utils/Log';
import { Constants } from '../model/common/Constants';
import { Constants as PhotoConstants } from '../model/browser/photo/Constants';
import { MediaItem } from '../model/browser/photo/MediaItem';
import { DateUtil } from '../utils/DateUtil';
import { BroadCast } from '../utils/BroadCast';
import { BroadCastConstants } from '../model/common/BroadCastConstants';
import { Action } from './browserOperation/Action';
import { ImageUtil } from '../utils/ImageUtil';
import { ColumnSize, ScreenManager } from '../model/common/ScreenManager';
import { TraceControllerUtils } from '../utils/TraceControllerUtils';
import { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import { MultimodalInputManager } from '../model/common/MultimodalInputManager';
import { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';
import { AlbumDefine } from '../model/browser/AlbumDefine';
import { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import { BroadCastManager } from '../model/common/BroadCastManager';

const TAG: string = 'common_ImageGridItemComponent';

@Extend(Image) 
function focusSetting(uri: string, handleEvent: Function) {
  .key('ImageGridFocus_' + uri)
  .focusable(true)
  .onKeyEvent((event?: KeyEvent) => {
    handleEvent((event as KeyEvent));
  })
}

interface Msg {
  from: string;
}

// General grid picture control
@Component
export struct ImageGridItemComponent {
  item: MediaItem | null = null;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @Consume @Watch('onModeChange') isSelectedMode: boolean;
  @State isSelected: boolean = false;
  isRecycle: boolean = false;
  @Consume broadCast: BroadCast;
  @Consume @Watch('onShow') isShow: boolean;
  @Link selectedCount: number;
  @State autoResize: boolean = true;
  loaded = false;
  mPosition: number = 0;
  pageName = '';
  @State isLoadImageError: boolean = false;
  @State pressAnimScale: number = 1.0;
  @State recycleDays: number = 0;
  @Consume rightClickMenuList: Array<Action>;
  onMenuClicked: Function = (): void => {};
  onMenuClickedForSingleItem: Function = (): void => {};
  @State geometryTransitionString: string = 'default_id';
  @State isTap: boolean = false;
  @StorageLink('placeholderIndex') @Watch('verifyTapStatus') placeholderIndex: number = -1;
  @StorageLink('geometryTransitionBrowserId') @Watch('verifyTapStatus') geometryTransitionBrowserId: string = '';
  private imageThumbnail: string = '';
  private transitionId: string = '';
  private isEnteringPhoto = false;
  private isThird = false;
  private isThirdMultiPick: boolean = false;
  private albumUri: string = '';
  private dataSource: MediaDataSource | null = null;
  private geometryTapIndex: number = 0;
  private isTapStatusChange: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private updateSelectFunc: Function = (updateUri: string, select: boolean): void =>
  this.updateSelect(updateUri, select);

  verifyTapStatus() {
    if (this.placeholderIndex === Constants.INVALID) {
      this.isTap = false;
      return;
    }
    this.updateGeometryTapInfo();
    let pageFromGlobal = this.geometryTransitionBrowserId.split(':')[0];
    let pageFrom = this.geometryTransitionString.split(':')[0];
    let oldTapStatus = this.isTap;
    let newTapStatus = (pageFromGlobal === pageFrom) && (this.placeholderIndex === this.geometryTapIndex);
    this.isTapStatusChange = oldTapStatus !== newTapStatus;
    this.isTap = newTapStatus;
    if (this.isTap) {
      this.geometryTransitionString = this.geometryTransitionBrowserId;
      Log.debug(TAG, 'update placeholderIndex = ' + this.placeholderIndex +
        'geometryTapIndex = ' + this.geometryTapIndex + ', isTap = ' + this.isTap +
        ', geometryTransitionString = ' + this.geometryTransitionString);
    }
  }

  aboutToAppear(): void {
    this.imageThumbnail = this.item?.thumbnail ?? '';
    this.albumUri = AppStorage.get<string>(Constants.KEY_OF_ALBUM_URI) as string;
    if (this.item != null) {
      if (this.isSelected) {
        this.transitionId = `${this.item.hashCode}_${this.albumUri}_${this.isSelected}`;
      } else {
        this.transitionId = `${this.item.hashCode}_${this.albumUri}`;
      }
    }
    if (this.isRecycle) {
      this.calculateRecycleDays();
    }
    Log.info(TAG, `transitionId: ${this.transitionId}`);
    this.isTap = this.geometryTransitionString === this.geometryTransitionBrowserId;
    this.appBroadCast.on(BroadCastConstants.UPDATE_SELECT, this.updateSelectFunc);
  }

  updateSelect(updateUri: string, select: boolean): void {
    if (updateUri === this.item?.uri) {
      this.isSelected = select;
    }
  }

  aboutToDisappear(): void {
    this.appBroadCast.off(BroadCastConstants.UPDATE_SELECT, this.updateSelectFunc);
    this.resetPressAnim();
  }

  onModeChange(newMode: boolean): void {
    Log.debug(TAG, `newMode ${newMode}`);
    if (!this.isSelectedMode) {
      this.isSelected = false;
    }
  }

  onAllSelect(newMode: boolean): boolean {
    Log.debug(TAG, `onAllSelect ${newMode}`);
    return newMode;
  }

  async routePage(isError: boolean) {
    Log.info(TAG, `routePage ${isError}`);
    try {
      TraceControllerUtils.startTrace('enterPhotoBrowser');
      if (this.isThird) {
        this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.item]);
      } else {
        this.broadCast.emit(BroadCastConstants.JUMP_PHOTO_BROWSER, [this.pageName, this.item]);
      }
    } catch (err) {
      Log.error(TAG, `fail callback, code: ${err.code}, msg: ${err.msg}`);
    }
  }

  async routeToPreviewPage() {
    try {
      Log.info(TAG, 'routeToPreviewPage');
      this.updateGeometryTapInfo();
      this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
        [this.pageName, this.item, this.geometryTapIndex, this.geometryTransitionString]);
    } catch (err) {
      Log.error(TAG, `fail callback, code: ${err.code}, msg: ${err.msg}`);
    }
  }

  selectStateChange() {
    Log.info(TAG, 'change selected.');
    let newState = !this.isSelected;
    AppStorage.setOrCreate('focusUpdate', true);
    if (this.item != null && this.item.uri) {
      this.mPosition = this.getPosition();
      this.broadCast.emit(BroadCastConstants.SELECT,
        [this.mPosition, this.item.uri, newState,  (isSelected: boolean): void => {
        let itemUri: string = this.item == null ? '' : this.item.uri;
        Log.info(TAG, `enter callback, select status ${this.mPosition} ${itemUri} ${newState} ${this.isSelected}`);
        this.isSelected = isSelected == undefined ? newState : isSelected;
      }]);
    }
  }

  @Builder
  RightClickMenuBuilder() {
    Column() {
      ForEach(this.rightClickMenuList, (menu: Action) => {
        Text(this.changeTextResToPlural(menu))
          .key('RightClick_' + this.mPosition + menu.componentKey)
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
              if (this.isSelectedMode && this.isSelected) {
                this.onMenuClicked && this.onMenuClicked(menu);
              } else {
                this.onMenuClickedForSingleItem && this.onMenuClickedForSingleItem(menu, this.item);
              }
            }
          })
      }, (item: Action) => JSON.stringify(item))
    }
    .width(ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_TWO))
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


  build() {
    Column() {
      if (this.isTap) {
        Column() {
        }
        .aspectRatio(1)
        .rotate({ x: 0, y: 0, z: 1, angle: 0 })
        .backgroundColor($r('app.color.default_background_color'))
        .width('100%')
        .height('100%')
        .zIndex(-1)
      } else {
        this.buildNormal()
      }
    }
  }

  @Builder
  buildImage() {
    Image(this.imageThumbnail)
      .width('100%')
      .height('100%')
      .rotate({ x: 0, y: 0, z: 1, angle: 0 })
      .objectFit(ImageFit.Cover)
      .autoResize(false)
      .focusSetting(this.item == null ? '' : this.item.uri, (event: KeyEvent): void => this.handleKeyEvent(event))
      .onError(() => {
        this.isLoadImageError = true;
        AppStorage.setOrCreate('focusUpdate', true);
        Log.error(TAG, 'item Image error');
      })
      .onComplete(() => {
        Log.debug(TAG, `Draw the image! ${this.imageThumbnail}`);
      })
      .onAppear(() => {
        this.requestFocus('ImageGridFocus_');
      })
      .geometryTransition(this.geometryTransitionString)
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.scale({ x: AppStorage.get('geometryScale'), y: AppStorage.get('geometryScale') }),
        TransitionEffect.opacity(0.99)))

    if (this.geometryTransitionBrowserId === '' || !this.isTapStatusChange) {
      this.buildIcon();
    }
  }

  @Builder
  buildIcon() {
    if (this.item != null && this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO || this.isRecycle) {
      Row() {
        // 缩略图左下角视频时长
        if (this.item != null && this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
          Text(DateUtil.getFormattedDuration(this.item.duration))
            .fontSize($r('sys.float.ohos_id_text_size_caption'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('app.color.text_color_above_picture'))
            .lineHeight(12)
            .margin({
              left: $r('app.float.grid_item_text_margin_lr'),
              bottom: $r('app.float.grid_item_text_margin_bottom')
            })
            .key('VideoDurationOfIndex' + this.mPosition)
        }
        // 缩略图右下角距离删除天数
        if (this.isRecycle && !this.isSelectedMode) {
          Blank()

          Text($r('app.plural.recycle_days', this.recycleDays, this.recycleDays))
            .fontSize($r('sys.float.ohos_id_text_size_caption'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor(this.recycleDays <= Constants.RECYCLE_DAYS_WARN ? $r('sys.color.ohos_id_color_warning') : $r('app.color.text_color_above_picture'))
            .lineHeight(12)
            .margin({
              right: $r('app.float.grid_item_text_margin_lr'),
              bottom: $r('app.float.grid_item_text_margin_bottom')
            })
        }
      }
      .position({ x: '0%', y: '50%' })
      .height('50%')
      .width('100%')
      .alignItems(VerticalAlign.Bottom)
      .linearGradient({ angle: 0, colors:
      [[$r('app.color.album_cover_gradient_start_color'), 0], [$r('app.color.transparent'), 1.0]] })
    }

    if (this.item != null && this.item.isFavor) {
      Image($r('app.media.ic_favorite_overlay'))
        .height($r('app.float.overlay_icon_size'))
        .width($r('app.float.overlay_icon_size'))
        .fillColor($r('sys.color.ohos_id_color_primary_dark'))
        .objectFit(ImageFit.Contain)
        .position({ x: '100%', y: '0%' })
        .markAnchor({
          x: $r('app.float.grid_item_favor_markAnchor_x'),
          y: $r('app.float.grid_item_favor_markAnchor_y')
        })
        .key('Favor_' + this.mPosition)
    }

    // 当三方拉起 picker 时, 只有多选模式下才显示蒙层
    if (this.isSelected && this.isSelectedMode && (!this.isThird || this.isThirdMultiPick)) {
      Column()
        .key('MaskLayer_' + this.mPosition)
        .height('100%')
        .width('100%')
        .backgroundColor($r('app.color.item_selection_bg_color'))
    }

    // 缩略图上方功能图标
    if (this.isSelectedMode) {
      Image($r('app.media.ic_photo_preview'))
        .key('Previewer_' + this.mPosition)
        .height($r('app.float.icon_size'))
        .width($r('app.float.icon_size'))
        .position({ x: '0%', y: '0%' })
        .markAnchor({
          x: $r('app.float.grid_item_preview_padding'),
          y: $r('app.float.grid_item_preview_padding')
        })
        .onClick(() => {
          Log.info(TAG, 'onClick loadThumbnailUri' + this.imageThumbnail);
          this.routeToPreviewPage();
          Log.info(TAG, 'expand.');
        })
    }
    if (this.isSelectedMode && (!this.isThird || this.isThirdMultiPick)) {
      Checkbox()
        .key('Selector_' + this.mPosition)
        .select(this.isSelected)
        .margin(0)
        .position({ x: '100%', y: '100%' })
        .markAnchor({
          x: $r('app.float.grid_item_checkbox_markAnchor'),
          y: $r('app.float.grid_item_checkbox_markAnchor')
        })
        .focusable(false)
        .hitTestBehavior(HitTestMode.None)
    }
  }

  @Builder
  buildNormal() {
    Stack({ alignContent: Alignment.Start }) {
      // 缩略图
      if (this.isLoadImageError) {
        Image((this.item != null && this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO)
          ? $r('app.media.alt_video_placeholder') : $r('app.media.alt_placeholder'))
          .aspectRatio(1)
          .rotate({ x: 0, y: 0, z: 1, angle: 0 })
          .objectFit(ImageFit.Cover)
          .autoResize(false)
          .focusSetting(this.item == null ? '' : this.item.uri, (event: KeyEvent): void => this.handleKeyEvent(event))
          .onAppear(() => {
            Log.debug(TAG, `appear the default image!`);
          })

        if (this.geometryTransitionBrowserId === '' || !this.isTapStatusChange) {
          this.buildIcon();
        }
      } else {
        if (this.albumUri === UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE) ||
          this.pageName === Constants.PHOTO_TRANSITION_TIMELINE) {
          this.buildImage();
        } else {
          Stack() {
            this.buildImage();
          }
          .borderRadius(0)
          .clip(true)
          .geometryTransition(this.transitionId)
        }
      }
    }
    .key('Gesture_' + this.mPosition)
    .height('100%')
    .width('100%')
    .bindContextMenu(this.RightClickMenuBuilder, ResponseType.RightClick) // 右键点击菜单，后续整改至新组件
    .scale({
      x: this.pressAnimScale,
      y: this.pressAnimScale
    })
    .onTouch(event => {
      Log.debug(TAG, `onTouch trigger: isSelectedMode: ${this.isSelectedMode},
                    isEnteringPhoto: ${this.isEnteringPhoto}, ${JSON.stringify(event)}`);
      if (this.isSelectedMode) {
        return;
      }

      // Press animation
      if (event?.type === TouchType.Down) {
        animateTo({
          duration: Constants.PRESS_ANIM_DURATION,
          curve: Curve.Ease
        }, () => {
          this.pressAnimScale = Constants.PRESS_ANIM_SCALE;
        })
      }

      if ((event?.type == TouchType.Up || event?.type == TouchType.Cancel) && this.pressAnimScale != 1) {
        animateTo({
          duration: Constants.PRESS_ANIM_DURATION,
          curve: Curve.Ease
        }, () => {
          this.pressAnimScale = 1;
        })
      }
    })
    .gesture(GestureGroup(GestureMode.Exclusive,
      TapGesture().onAction((event?: GestureEvent) => {
        let ret: boolean = focusControl.requestFocus('ImageGridFocus_' + (this.item == null ? '' : this.item.uri));
        if (ret !== true) {
          let itemUri: string = this.item == null ? '' : this.item.uri;
          Log.error(TAG, `requestFocus${'ImageGridFocus_' + itemUri}, ret:${ret}`);
        }
        let msg: Msg = {
          from: BigDataConstants.BY_CLICK,
        }
        ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTO_BROWSER_WAY, msg);
        this.openPhotoBrowser();
      }),
      LongPressGesture().onAction((event?: GestureEvent) => {
        Log.info(TAG, `LongPressGesture ${event as GestureEvent}`);
        this.selectStateChange();
        this.pressAnimScale = 1;
      })
    ))
  }

  private resetPressAnim(): void {
    this.pressAnimScale = 1;
    this.isEnteringPhoto = false;
  }

  private onShow(): void {
    this.resetPressAnim();
  }

  private generateSampleSize(imageWidth: number, imageHeight: number): number {
    let width = ScreenManager.getInstance().getWinWidth();
    let height = ScreenManager.getInstance().getWinHeight();
    width = width == 0 ? ScreenManager.DEFAULT_WIDTH : width;
    height = height == 0 ? ScreenManager.DEFAULT_HEIGHT : height;
    let maxNumOfPixels = width * height;
    let minSide = Math.min(width, height);
    return ImageUtil.computeSampleSize(imageWidth, imageHeight, minSide, maxNumOfPixels);
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

  // 获取最近删除中，待回收照片倒计天数
  private calculateRecycleDays(): void {
    let currentTimeSeconds: number = new Date().getTime() / 1000;
    let itemDateTrashed: number = this.item == null ? 0 : this.item.dateTrashed;
    let trashedDay = DateUtil.convertSecondsToDays(currentTimeSeconds - itemDateTrashed);
    Log.debug(TAG, `currentSec=${currentTimeSeconds}, trashedSec=${itemDateTrashed}, trashedDay=${trashedDay}`);
    if (trashedDay > Constants.RECYCLE_DAYS_MAX) {
      this.recycleDays = 0;
    } else if (trashedDay <= 0) {
      this.recycleDays = Constants.RECYCLE_DAYS_MAX - 1;
    } else {
      this.recycleDays = Number.parseInt((Constants.RECYCLE_DAYS_MAX - trashedDay) + '');
    }
  }

  private requestFocus(keyName: string): void {
    if (AppStorage.get<string>('deviceType') == Constants.DEFAULT_DEVICE_TYPE) {
      return;
    }
    let positionUri = AppStorage.get<string>('focusPosition');
    let isUpdate = AppStorage.get<boolean>('focusUpdate');
    if (this.item !== null && isUpdate && positionUri === this.item.uri) {
      let ret: Boolean = focusControl.requestFocus(keyName + this.item.uri);
      if (ret !== true) {
        Log.error(TAG, `requestFocus${keyName + this.item.uri}, ret:${ret}`);
      }
      AppStorage.setOrCreate('focusUpdate', false);
    }
  }

  private openPhotoBrowser(): void {
    if (this.isSelectedMode) {
      this.selectStateChange();
    } else {
      Log.info(TAG, 'item onClick loadBmp');
      Log.info(TAG, 'onClick loadThumbnailUri' + this.imageThumbnail);
      this.updateGeometryTapInfo();
      if (this.isThird) {
        this.broadCast.emit(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER,
          [this.pageName, this.item, this.geometryTapIndex, this.geometryTransitionString]);
      } else {
        this.broadCast.emit(BroadCastConstants.JUMP_PHOTO_BROWSER,
          [this.pageName, this.item, this.geometryTapIndex, this.geometryTransitionString]);
      }
      this.isEnteringPhoto = true;
    }
  }

  private handleKeyEvent(event: KeyEvent): void {
    if (KeyType.Up == event.type) {
      switch (event.keyCode) {
        case MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER:
          let msg: Msg = {
            from: BigDataConstants.BY_KEYBOARD,
          }
          ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTO_BROWSER_WAY, msg);
          this.openPhotoBrowser();
          break;
        case MultimodalInputManager.KEY_CODE_KEYBOARD_ESC:
          this.onMenuClicked && this.onMenuClicked(Action.BACK);
          break;
        default:
          Log.info(TAG, `on key event Up, default`);
          break;
      }
    }
  }

  private updateGeometryTapInfo(): void {
    this.geometryTapIndex = this.getPosition();
  }

  private getPosition(): number {
    if (this.dataSource == null || this.item == null) {
        return 0;
    }
    return this.dataSource.getDataIndex(this.item) + this.dataSource.getGroupCountBeforeItem(this.item);
  }
}