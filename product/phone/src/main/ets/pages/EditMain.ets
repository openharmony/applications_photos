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

import router from '@ohos.router';
import {
  Action,
  BigDataConstants,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  Log,
  MediaItem,
  ReportToBigDataUtil,
  ScreenManager,
  UiUtil
} from '@ohos/common';
import { CustomDialogView } from '@ohos/common/CommonComponents';
import { PhotoEditCrop, PhotoEditMode, PhotoEditorManager } from '@ohos/editor';
import { CropImageShow, MainMenuBar, TitleBar } from '@ohos/editor/EditorComponnts';

const TAG: string = 'EditMain';

@Entry
@Component
export struct EditMain {
  @Provide editorManager: PhotoEditorManager = PhotoEditorManager.getInstance();
  @Provide('compare') isCompare: boolean = false;
  @Provide('angle') rotateAngle: number = Constants.NUMBER_0;
  @Provide isCropReset: boolean = false;
  @Provide isBigTextShow: boolean = false;
  @Provide bigText: string = '';
  @Provide('scale') imageScale: number = Constants.NUMBER_0;
  @Provide('barSize') barScale: Resource = $r('app.float.menuBar_edit');
  @Provide('selected') selectedMode: number = PhotoEditMode.EDIT_MODE_CROP;
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide('verticalScreen') isVerticalScreen: boolean = !ScreenManager.getInstance().isHorizontal();
  @Provide screenWidth: number = Constants.NUMBER_0;
  @Provide screenHeight: number = Constants.NUMBER_0;
  @Provide cropEdit: PhotoEditCrop | undefined = undefined;
  @Provide isRedo: boolean = false;
  @Provide isUndo: boolean = false;
  @Provide isMagnifier: boolean = false;
  @Provide mainBottomSize: number = Constants.BOTTOM_TOOL_BAR_SIZE;
  @Provide titleSize: number = Constants.TOP_BAR_SIZE;
  @Provide filterBottomSize: number = Constants.FILTER_BOTTOM_TOOL_BAR_SIZE;
  @Provide moreMenuList: Action[] = [];
  @StorageLink('leftBlank') leftBlank: number[] =
    [
  Constants.NUMBER_0,
  ScreenManager.getInstance().getStatusBarHeight(),
  Constants.NUMBER_0,
  ScreenManager.getInstance().getNaviBarHeight()
  ];
  @State imageScaleWidth: number = Constants.NUMBER_0;
  appEventBus: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @StorageLink('currentBreakpoint') @Watch('updateIsVerticalScreen') currentBreakpoint: string = Constants.BREAKPOINT_MD;
  private mediaItem: MediaItem = AppStorage.get<MediaItem>('EditorMediaItem') as MediaItem;
  private screenManager = ScreenManager.getInstance();
  private isLoadFailed: boolean = false;
  private albumUri: string = AppStorage.get<string>('EditorAlbumUri') as string;
  private onWindowSizeChangeCallBack: Function = (): void => this.updateIsVerticalScreen();

  updateIsVerticalScreen(): void {
    if (this.currentBreakpoint == Constants.BREAKPOINT_LG) {
      this.isVerticalScreen = false;
      this.screenHeight = Math.ceil(this.screenManager.getWinHeight()) - this.leftBlank[3] - Constants.ActionBarHeight;
      this.screenWidth = Math.ceil(this.screenManager.getWinWidth()) - Constants.HORIZONTAL_RESET_BUTTON_WIDTH -
      Constants.HORIZONTAL_RESET_BUTTON_MARGIN - Constants.HORIZONTAL_CROP_STYLE_BAR_HEIGHT -
      Constants.HORIZONTAL_RULER_COMPONENT_WIDTH - Constants.HORIZONTAL_TOOL_BAR_WIDTH;
    } else {
      this.isVerticalScreen = true;
      this.screenHeight = Math.ceil(this.screenManager.getWinHeight()) - this.leftBlank[3] -
      Constants.ActionBarHeight - Constants.PUNCH_HOLE_HEIGHT -
      Constants.VERTICAL_RESET_BUTTON_HEIGHT - Constants.VERTICAL_RESET_BUTTON_MARGIN -
      Constants.VERTICAL_CROP_STYLE_BAR_HEIGHT - Constants.VERTICAL_RULER_COMPONENT_HEIGHT -
      Constants.VERTICAL_TOOL_BAR_HEIGHT;
      this.screenWidth = Math.ceil(this.screenManager.getWinWidth());
    }
    this.imageScale = this.isVerticalScreen
      ? (this.screenWidth - this.titleSize - this.mainBottomSize) : (this.screenWidth - this.titleSize);
    this.imageScaleWidth = this.isVerticalScreen ? this.screenHeight : (this.screenHeight - this.mainBottomSize);
  }

  onBackPress(): boolean {
    if (this.isCropReset) {
      this.broadCast.emit(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [(): void => this.discardCallback()]);
    } else {
      router.back();
    }
    return true;
  }

  discardCallback(): void {
    Log.debug(TAG, 'discardCallback called');
  }

  loadFailedCallback(): void {
    this.isLoadFailed = true;
  }

  aboutToAppear(): void {
    Log.debug(TAG, 'EditMain init start');
    ScreenManager.getInstance().setSystemUi(false);
    if (this.mediaItem) {
      this.isLoadFailed = false;
      this.editorManager.initialize(
        this.mediaItem, this.albumUri, PhotoEditMode.EDIT_MODE_CROP, (): void => this.loadFailedCallback());
    }
    this.cropEdit = this.editorManager.getPhotoEditBaseInstance(PhotoEditMode.EDIT_MODE_CROP) as PhotoEditCrop;
    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.updateIsVerticalScreen();
    ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTO_EDIT_ID, undefined);
  }

  aboutToDisappear(): void {
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    Log.debug(TAG, 'aboutToDisappear');

    AppStorage.setOrCreate<MediaItem | undefined>('EditorMediaItem', undefined);
    PhotoEditorManager.getInstance().clear();
    ScreenManager.getInstance().setSystemUi(true);
  }

  onPageShow(): void {
    this.appEventBus.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    if (this.isLoadFailed) {
      router.back();
    }
  }

  build() {
    // 根布局
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      // ActionBar
      Row() {
        TitleBar({
          name: $r('app.string.editBar_text'),
          isPcStyle: false
        })
      }
      .height(this.isVerticalScreen ? Constants.ActionBarHeight +
      Constants.PUNCH_HOLE_HEIGHT : Constants.ActionBarHeight)
      .width(Constants.PERCENT_100)
      .backgroundColor($r('app.color.transparent'))
      .padding({ top: this.isVerticalScreen ? Constants.PUNCH_HOLE_HEIGHT : Constants.NUMBER_0 })

      Flex({
        direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: this.isVerticalScreen ? FlexAlign.Center : FlexAlign.Start
      }) {
        // 图片编辑区域与菜单列
        if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
          CropImageShow()
        }

        if (!this.isVerticalScreen) {
          // 菜单工具栏
          Column() {
            if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
              MainMenuBar()
            }
          }
          .width(Constants.HORIZONTAL_MAIN_MENU_WIDTH)
          .height(Constants.PERCENT_100)
        } else {
          // 菜单工具栏
          Row() {
            if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
              MainMenuBar()
            }
          }
          .height(Constants.VERTICAL_MAIN_MENU_BAR_HEIGHT)
          .width(Constants.PERCENT_100)
        }

        // 对话框
        CustomDialogView({ broadCast: $broadCast })
      }
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
    .backgroundColor(Color.Black)
  }
}
