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

import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { LengthMetrics, display } from '@kit.ArkUI';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { PickerSelectTip } from './PickerSelectTip';
import lazy { DataSourceWrapper } from '@ohos/common/src/main/ets/default/model/DataSourceWrapper';
import lazy { PhotoDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImplAsync';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { BindSheetController } from '../AlbumPhotoGridView';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { UnionAlbumDataSource } from '@ohos/common/src/main/ets/default/model/UnionAlbumDataSource';
import lazy { PhotoAlbum, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import RscGetter from '@ohos/tools/src/main/global/RscGetter';
const TAG = 'AlbumCoverSelectPage';

@Component
export struct AlbumCoverSelectPage {
  public persistentId: number = 0;
  @State dataSource: MediaDataSource =
    new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, new PhotoDataImplAsync(TAG));
  // bindSheet 控制器
  @ObjectLink private bindSheetController : BindSheetController;

  @State itemWrap: FlexWrap = FlexWrap.NoWrap;
  @State slideShowInterval: number = 3;
  @Link private selectCoverItem: MediaItem;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private navPathStackBindSheet: NavPathStack = new NavPathStack();
  public scroller: Scroller = new Scroller();
  @State @Watch('onAlbumInfoChanged') private albumInfo: AlbumInfo = new AlbumInfo();
  private scrollIndex: number = 0;
  private rsc: RscGetter = new RscGetter(getContext().resourceManager);
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;

  private onAlbumInfoChanged() {
    Log.info(TAG, 'onAlbumInfoChanged')
  }

  async aboutToAppear(): Promise<void> {
    Log.info(TAG, `aboutToAppear`);
    // albumDataSource 和 unionAlbumDataSouce
    if (this.albumInfo.isSourceAlbum && this.albumInfo.unionAlbumUris.length > 0) {
      this.dataSource = new UnionAlbumDataSource({ context: getContext(), albumInfo: this.albumInfo });
    } else {
      this.dataSource = new AlbumDataSource({ context: getContext(), albumInfo: this.albumInfo });
    }
    this.dataSource?.notifyDirty();
    this.dataSource?.registerCallback('updateCount', (newCount: number): void => {
      Log.info(TAG, `updateCount: dataSource newCount is ${newCount}!`);
      this.dataSource?.onDataReloaded();
    });
    await this.onAlbumInfoCheck();
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear`);
  }

  private getCoverSelectedImageText(item: ViewData, index?: number): string {
    let selected = '';
    if (this.isShowMark(item)) {
      selected = this.rsc.toString($r('app.string.selected'));
    }
    let indexStr = '';
    if (index !== undefined && index !== null) {
      indexStr = `${index +1}`;
    }
    return `${selected} ${this.rsc.getString($r('app.string.album_photos'))} ${indexStr}`;
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          this.buildCoverSelectSheetTopBar();
          this.buildCoverSelectSheetArea();
        }
        if (!this.isVerdeFoldable) {
          // 底部背景，在非Verde外屏状态下显示
          // 高度暂时写死为56vp和44vp，为PickerSelectTip.margin.bottom + PickerSelectTip.tipsHeight
          Column() {}
            .width('100%')
            .height(DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() ? '56vp' : '44vp')
            .backgroundColor(Color.Transparent)
            .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
        }
        PickerSelectTip()
          .margin({
            bottom: (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() ?
              $r('app.float.navigation_margin_bottom') : $r('app.float.navigation_margin_bottom_pc'))
          });
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    }
    .backgroundColor(Color.Transparent)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    .hideTitleBar(true)
  }

  @Builder
  buildCoverSelectSheetTopBar() {
    Row() {
      Text($r('app.string.replace_cover'))
        .layoutWeight(1)
        .fontSize(`20vp`)
        .fontWeight(FontWeight.Bold)
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_primary'))

      // 更换封面 关闭按钮
      Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontSize($r('app.float.icon_size'))
            .fontColor([$r('sys.color.ohos_fa_icon_primary')])
            .draggable(false)
            .flexShrink(0)
      }
      .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
      .onClick(() => {
        this.bindSheetController.isShow = false;
        this.appBroadCast?.emit(BroadCastConstants.CLOSE_ALBUM_COVER_CHANGE_SHEET, ['']);
        Log.info(TAG, 'close album cover change sheet');
      })
      .width($r('app.float.picker_action_bar_button_width'))
      .height($r('app.float.picker_action_bar_button_height'))
    }
    .width('100%')
    .height('56vp')
    .margin({ top: '8vp', bottom: '8vp' })
    .padding({ left: '16vp', right: '16vp' })
  }

  private isSelected: boolean = true;

  @Builder
  buildCoverSelectSheetArea() {
    Scroll(this.scroller) {
      Column() {
        Grid() {
          LazyForEach(this.dataSource, (item: ViewData, index?: number) => {
            GridItem() {
                if (item.mediaItem) {
                  Stack({ alignContent: Alignment.BottomEnd }) {
                    Image(ImageUtil.getThumbnailUri(item?.mediaItem?.uri, item?.mediaItem?.path,
                      item?.mediaItem?.getDateModified?.(),
                      false, item?.mediaItem?.getThumbnailReady?.()))
                      .aspectRatio(1)
                      .draggable(false)
                      .onComplete(() => {
                      })
                      .onError((error: ImageError) => {
                        Log.error(TAG, `Item loading failed ${error}`)
                      })
                      .width('100%')
                      .height('100%')
                    if (this.isShowMark(item)) {
                      this.buildMark();
                    }
                  }
                  .accessibilityRole(AccessibilityRoleType.STACK)
                  .onClick((): void => {
                    this.selectCoverItem = item.mediaItem as MediaItem;
                    this.navPathStackBindSheet.pushPathByName('AlbumCoverPreviewPage', null);
                  })
                  .accessibilityText(this.getCoverSelectedImageText(item, index))
                }
              }
            })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(Constants.GRID_GUTTER)
        .rowsGap(Constants.GRID_GUTTER)
        .scrollBar(BarState.Off) // 进度条样式 BarState.Off 关闭进度条
        .cachedCount(4)
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
    .layoutWeight(1)
    .align(Alignment.Top)
    .scrollBar(BarState.Off) // 滚动条常驻显示
    .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
  }

  @Builder
  buildMark() {
    Checkbox()
      .margin(0)
      .accessibilityLevel('no-hide-descendants')
      .select(this.isSelected)
      .hitTestBehavior(HitTestMode.None)
      .opacity(this.isSelected ? $r('app.float.no_opacity') : $r('sys.float.alpha_20'))
      .border({ radius: $r('app.float.checkbox_border_radius') })
      .margin({
        right: $r('app.float.album_cover_checkbox_margin_right'),
        bottom: $r('app.float.album_cover_checkbox_margin_bottom')
      })
  }

  private isShowMark(item: ViewData): boolean {
    return item?.mediaItem?.uri === this?.albumInfo?.coverPhotoUri;
  }

  async onAlbumInfoCheck() {
    // 先查看albumInfo 中coverUri
    try {
      let targetAlbum: PhotoAlbum | undefined =
        await UserFileManagerAccess.getInstance().getAlbumByUri(this.albumInfo?.uri);
      if (targetAlbum === undefined || targetAlbum === null) {
        Log.info(TAG, 'targetAlbum has not find');
      }
      this.albumInfo = new AlbumInfo(targetAlbum);
      this.albumInfo.coverPhotoUri = targetAlbum?.coverUri ?? '';
    } catch (error) {
      Log.info(TAG, 'onSheetShowChange has error');
    }
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }
}