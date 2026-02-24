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

import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy {
  PickerSelectAlbumDataSource
} from '@ohos/common/src/main/ets/default/model/browser/album/PickerSelectAlbumDataSource';
import lazy { PickerAlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/PickerAlbumInfo';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';

/* instrument ignore file */
const TAG: string = 'ThirdSelectPhoneAlbumBase';

const TEXT_MAX_LINE = 1;
const TEXT_COLUMN_SPACE = 4;
const TEXT_SAFE_MARGIN = 8;
const NORMAL_ITEM_ROW_SPACE = 16;

@Component
export struct ThirdSelectPhoneAlbumBase {
  public albums: PickerSelectAlbumDataSource | undefined = undefined;
  @State broadCast: BroadCast = new BroadCast();
  public isActive = false;
  public dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  @Provide selectParams: SelectParams = SelectParams.defaultParam();
  // 滑动组件控制器
  public albumScroller: Scroller = new Scroller();
  @State selectId: string = '';
  @State isAlbumEmpty: boolean = true;
  public color: number = 0;
  @State albumPadding: Resource = $r('app.float.same_name_date_dialog_bottom');
  @State leftDividerPadding: Resource = $r('app.float.picker_album_divider_normal_padding');
  @StorageLink('isHorizontal') @Watch('updateItemPadding') isHorizontal: boolean = isOrientationHorizontal();
  @State themeColorMode: number = 0;
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  private onThirdSelectAlbumPhotosUpdateFunc: Function = (size: number): void => {
    this.onThirdSelectAlbumPhotosUpdate(size);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    WindowUtil.prepareWinRouter();
    this.isAlbumEmpty = true;

    let queryParam: QueryParam = {
      filterMediaType: this.selectParams.filterMediaType,
      filterConditions: {
        recommendationType: this.selectParams.recommendationType,
      },
    };
    let userId: number = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    this.albums = new PickerSelectAlbumDataSource(this.broadCast, getContext(this), queryParam, userId);
    if (this.selectParams.filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_ALL || DeviceInfo.isTv()) {
      this.albums.setShowAllAlbumInfo();
    }
    this.albums.setBlackList([]);

    Log.debug(TAG, `select params ${JSON.stringify(this.selectParams)}`);
    this.color = ((UiUtil.getResourceNumber($r('sys.float.alpha_fifth')) * 255) << 24 & 0xff000000) |
      (UiUtil.getResourceColorSync($r('sys.color.brand')) & 0x00ffffff);
    this.themeColorMode = this.selectParams.themeColorMode;
    this.broadCast.on(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, this.onThirdSelectAlbumPhotosUpdateFunc);
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.onActive();
    this.albums.initialize();
    this.updateItemPadding();
    let storage = LocalStorage.getShared();
    let session: UIExtensionContentSession | undefined =
      storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
    if (session) {
      Log.info(TAG, 'set ReceiveDataCallback');
      session.setReceiveDataCallback((data) => {
        this.handleDataCallback(data, session);
      });
    }
    Log.info(TAG, `aboutToAppear albums size:${this.albums.albums.length}`);
  }

  handleDataCallback(data: Record<string, Object>, session: UIExtensionContentSession | undefined): void {
    Log.info(TAG, `ReceiveDataCallback`);
    let fontSize: Object = data['fontSize'];
    if (fontSize) {
      if (typeof fontSize === 'string' || typeof fontSize === 'number') {
        this.selectParams.fontSize = fontSize;
      }
    }
  }

  onPageChanged(): void {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onPageShow() {
    Log.info(TAG, 'onPageShow');
    this.onActive();
  }

  onPageHide() {
    Log.info(TAG, 'onPageHide');
    this.onInActive();
  }

  aboutToDisappear(): void {
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.onInActive();
    this.broadCast.off(Constants.THIRD_SELECT_ALBUM_PHOTOS_UPDATE, this.onThirdSelectAlbumPhotosUpdateFunc);
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    this.albums?.onNotify(nfyInfo);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
  }

  onActive(): void {
    Log.info(TAG, `onActive ${this.isActive}`);
    if (!this.isActive) {
      this.isActive = true;
      this.albums?.onActive();
    }
  }

  onInActive(): void {
    Log.info(TAG, `onInActive ${this.isActive}`);
    if (this.isActive) {
      this.isActive = false;
      this.albums?.onInActive();
    }
  }

  /**
   * 相册数量变化的回调
   *
   * @param size 相册数量
   */
  private onThirdSelectAlbumPhotosUpdate(size: number): void {
    // data concat
    Log.info(TAG, `broadCast ON_LOADING_FINISHED size: ${size}`);
    // 判断是否仅有垃圾箱相册目录
    this.isAlbumEmpty = size === 0;
  }

  /**
   * 点击时间处理
   *
   * @param album 点击的相册对象
   */
  private handleClick(album: PickerAlbumInfo): void {
    let storage = LocalStorage.getShared();
    this.selectId = album.uri;
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      let session: UIExtensionContentSession | undefined =
        storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      let albumUri: string = album.uri;
      if (album.unionAlbumUris.length > 0) {
        albumUri = Constants.UNION_ALBUM_URI_HEAD + album.unionAlbumUris.join('|');
      }
      session?.sendData({ 'dataType': 'selectAlbum', 'albumUri': albumUri, 'albumName': album.albumName });
      Log.info(TAG, `album.albumName: ${AlbumDefine.getAnonymizeAlbumName(album.albumName)}`);
    }
  }

  /**
   * 设置相册图片的地址
   *
   * @param item 相册对象
   * @returns 相册图片地址
   */
  private setAlbumCoverUri(item: PickerAlbumInfo): string | Resource {
    if (item.coverUri) {
      return item.coverUri;
    }
    const altPlaceholder = $r('app.media.alt_placeholder');
    const altVideoPlaceholder = $r('app.media.alt_video_placeholder');
    return this.selectParams.filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO ?
        altPlaceholder : altVideoPlaceholder
  }

  /**
   * 设置相册显示的内容数量
   *
   * @param item 相册对象
   * @returns 相册内容数量
   */
  private setAlbumCoverCount(item: PickerAlbumInfo): string {
    return item.count.toString();
  }

  private updateItemPadding(): void {
    if (DeviceInfo.isPhoneUx()) {
      this.albumPadding =
        this.isHorizontal ? $r('app.float.image_margin_horizontal') : $r('app.float.picker_album_list_item_padding');
      this.leftDividerPadding = this.isHorizontal ? $r('app.float.picker_album_divider_medium_padding') :
      $r('app.float.picker_album_divider_normal_padding');
    } else if (DeviceInfo.isFoldable()) {
      this.albumPadding = $r('app.float.image_margin_horizontal');
      this.leftDividerPadding = $r('app.float.picker_album_divider_medium_padding');
    } else {
      this.albumPadding =
        this.isHorizontal ? $r('app.float.grid_item_duration_margin_right') : $r('app.float.image_margin_horizontal');
      this.leftDividerPadding = this.isHorizontal ? $r('app.float.picker_album_divider_large_padding') :
      $r('app.float.picker_album_divider_medium_padding');
    }
  }

  @Styles
  pressedStyles(): void {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
  }

  @Styles
  clickedStyles(): void {
    .backgroundColor(this.color)
  }

  @Styles
  albumListItemStyles(): void {
    .height($r('app.float.edit_horizontal_toolBar_size'))
    .padding({ left: this.albumPadding, right: this.albumPadding })
  }

  @Builder
  AlbumListItem(item: PickerAlbumInfo) {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row({ space: NORMAL_ITEM_ROW_SPACE }) {
        Image(this.setAlbumCoverUri(item))
          .height(40)
          .width(40)
          .border({
            radius: $r('sys.float.corner_radius_level6'),
            color: $r('sys.color.comp_background_tertiary'),
            width: 0.5,
          })

        Column({ space: TEXT_COLUMN_SPACE }) {
          Text(item.getAlbumNameResource())
            .fontSize(this.selectParams.fontSize === 0 ? $r('sys.float.Subtitle_M') : this.selectParams.fontSize)
            .fontColor($r('sys.color.font_primary'))
            .maxLines(TEXT_MAX_LINE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Medium)
            .focusable(true)
            .draggable(false)
        }
        .width(DeviceInfo.isFoldable() ? '55%' : '65%')
        .margin({
          top: TEXT_SAFE_MARGIN,
          bottom: TEXT_SAFE_MARGIN,
        })
        .alignItems(HorizontalAlign.Start)
      }

      Text(this.setAlbumCoverCount(item))
        .fontSize(this.selectParams.fontSize === 0 ? $r('sys.float.Subtitle_M') : this.selectParams.fontSize)
        .fontColor($r('sys.color.font_secondary'))
        .focusable(true)
        .draggable(false)
        .maxLines(TEXT_MAX_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
  }

  @Builder
  TabAlbums() {
    // 相册
    ListItemGroup() {
      LazyForEach(this.albums, (item: PickerAlbumInfo, index2?: number) => {
        ListItem() {
          WithTheme({ colorMode: this.themeColorMode }) {
            this.AlbumListItem(item);
          }
        }
        .key(`ListItem_${index2}`)
        .backgroundColor((this.selectId === item?.uri) ? this.color : undefined)
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .onClick((): void => this.handleClick(item))
        .stateStyles({ clicked: this.clickedStyles, pressed: this.pressedStyles })
        .albumListItemStyles()
      }, (item: PickerAlbumInfo, index2?: number) => `${item?.uri}_${index2}_${item?.count}`)
    }
    .divider({
      strokeWidth: '1px',
      color: $r('sys.color.ohos_id_color_subheading_separator'),
      endMargin: this.albumPadding,
      startMargin: this.leftDividerPadding,
    })
  }

  @Builder
  ListForPhone() {
    List({ space: 4, scroller: this.albumScroller }) {
      if (!this.isAlbumEmpty) {
        this.TabAlbums();
      }
    }
    .onAppear((): void => {
      this.albumScroller.scrollTo({ xOffset: 0, yOffset: 0 })
    })
    .sticky(StickyStyle.Header)
    .padding({
      top: $r('app.float.dialog_offset_bottom'),
      bottom: $r('app.float.dialog_offset_bottom'),
    })
    .alignListItem(ListItemAlign.Center)
    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
  }

  build() {
    Column() {
      WithTheme({ colorMode: this.themeColorMode }) {
        this.ListForPhone();
      }
    }
    .onClick((event?: ClickEvent) => {
      Log.info(TAG, 'Click extraTransparentInteractiveArea');
      if (event) {
        let storage = LocalStorage.getShared();
        if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
          let session: UIExtensionContentSession | undefined =
            storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
          session?.sendData({ 'dataType': 'emptyAreaClick' });
        }
      }
    }, 10)
    .opacity(1)
    .width('100%')
    .height('100%')
    .position({ x: '0%', y: '0%' })
    .align(Alignment.Start)
  }
}