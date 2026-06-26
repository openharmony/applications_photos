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
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { NoPhotoComponent } from '@ohos/common/src/main/ets/default/view/NoPhotoComponent';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy DBHelper from '@ohos/dataprovider/src/main/ets/database/DBHelper';
import lazy { dataShare } from '@kit.ArkData';
import lazy { PickerSelectTip } from '@ohos/thirdselect/src/main/ets/default/view/PickerSelectTip';
import lazy { Task, TaskUri } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo';
import lazy { FormControllerManager } from '@ohos/dataprovider/src/main/ets/controller/FormControllerManager';
import lazy { AlbumType } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { Constants as GalleryConstants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy { FaCardAlbumDataViewModel } from '../view/FaCardAlbumDataViewModel';
import lazy { FaCardAlbumSelectTipView } from './FaCardAlbumSelectTipView';

/* instrument ignore file */
const TAG: string = 'FormEditorSelectAlbumPage';
const TEXT_MAX_LINE = 1;
const TEXT_COLUMN_SPACE = 4;
const TEXT_SAFE_MARGIN = 8;
const SCALE_SPACE = 2;
const FLEX_GROW_NO = 2;
const NORMAL_ITEM_ROW_SPACE = 16;
const EDITOR_ENTRY_ALBUM_INDEX = 0;

const dsOptions: dataShare.DataShareHelperOptions = {
  isProxy: true,
};

@Component
export struct FormEditorSelectAlbumPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @Link private appBroadCast: BroadCast;
  @StorageLink('FASetting_FormId') formId: string = '0';
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  albumScroller: Scroller = new Scroller();
  @State isAlbumEmpty: boolean = false;
  @StorageLink('navigationBarBottomHeight') @Watch('onUpdateBreakpoint') private navigationBarBottomHeight: number = 0;
  @Provide bottomSafeAreaHeight: number = GalleryConstants.DIALOG_BOTTOM_OFFSET;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @StorageLink('currentBreakpoint') @Watch('onUpdateBreakpoint') currentBreakpoint: string =
    GalleryConstants.BREAKPOINT_LG;
  dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  @State private hoverSelectUrl: number | undefined = undefined;
  @State selectId: string = '';
  color: number = ((UiUtil.getResourceNumber($r('sys.float.alpha_fifth')) * 255) << 24 & 0xff000000) |
    (UiUtil.getResourceColorSync($r('sys.color.brand')) & 0x00ffffff);
  @State contentHeight: number = 0;
  private dbHelper: DBHelper | null = null;
  private interval: number = 15;
  @Prop listPaddingTopAndBottom: Resource;
  @Prop currentFontSizeScale: number
  @State public isClickable: boolean = true;
  @State private startInsertAlbum: boolean = false;
  private faCardAlbumDataViewModel?: FaCardAlbumDataViewModel;
  private readonly albumDataListener = () => {
    this.checkTheAlbumIsEmpty();
  };

  private getSelectUri(isHover: boolean, index: number | undefined): void {
    if (isHover) {
      this.hoverSelectUrl = index;
    } else {
      this.hoverSelectUrl = undefined;
    }
  }

  private checkTheAlbumIsEmpty(): void {
    this.isAlbumEmpty = this.faCardAlbumDataViewModel?.checkTheAlbumIsEmpty() ?? false;
    Log.info(TAG, `checkTheAlbumIsEmpty: ${this.isAlbumEmpty}`);
  }

  /**
   * 媒体查询,当breakpoint发生变化时触发
   * 1. XS,SM 时 底部安全区域 || 16
   * 2. 其它， 16
   * */
  private onUpdateBreakpoint(): void {
    this.bottomSafeAreaHeight = GalleryConstants.DIALOG_BOTTOM_OFFSET;
    if (this.currentBreakpoint === GalleryConstants.BREAKPOINT_XS ||
      this.currentBreakpoint === GalleryConstants.BREAKPOINT_SM) {
      this.bottomSafeAreaHeight = Math.floor(px2vp(this.navigationBarBottomHeight)) || this.bottomSafeAreaHeight;
    }
    Log.debug(TAG, `onUpdateBreakpoint currentBreakpoint ${this.currentBreakpoint}`);
  }

  aboutToAppear(): void {
    this.breakpointSystem.register(this.currentBreakpoint);
    this.onUpdateBreakpoint();
    // 注册媒体库监听, 给normal和 source 使用
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.dbHelper = DBHelper.getInstance(getContext());
    this.faCardAlbumDataViewModel?.registerAlbumData(this.albumDataListener);
    this.checkTheAlbumIsEmpty();
    Log.info(TAG, 'aboutToAppear end.');
  }

  aboutToDisappear(): void {
    this.unregister();
  }

  unregister() {
    this.breakpointSystem.unregister();
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    // 移除数据监听
    this.faCardAlbumDataViewModel?.removeCallBack();
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    // 媒体库通知要通知到对应的相册
    this.faCardAlbumDataViewModel?.getAlbums()?.onNotify(nfyInfo);
    this.faCardAlbumDataViewModel?.getSourceAlbums()?.onNotify(nfyInfo);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
  }

  /**
   * 点击处理
   * @param album
   */
  private async handleClick(album: AlbumInfo, albumType: AlbumType): Promise<void> {
    if (!this.isClickable) {
      return;
    }
    Log.info(TAG, `handleClick album: ${JSON.stringify(album)}`);
    this.isClickable = false;
    this.startInsertAlbum = true;
    const nowTask: Task = {
      formId: this.formId,
      taskUri: TaskUri.TASK_SELECT_ALBUM_URI,
      album: album,
      interval: this.interval,
      albumType: albumType,
    }
    Log.info(TAG, `handleClick send task ${JSON.stringify(nowTask)}`);
    await FormControllerManager.getInstance(getContext()).doTask(nowTask);
    this.startInsertAlbum = false;
    this.isClickable = true;
    this.unregister();
  }

  private setAlbumCoverUri(item: AlbumInfo, isAllPhoto: boolean): Resource | string {
    Log.info(TAG, `setAlbumCoverUri isAllPhoto: ${isAllPhoto}`)
    const altPlaceholder = $r('app.media.alt_placeholder');
    if (item?.coverUris[0]) {
      return item.coverUris[0];
    }
    if (!item.coverUri) {
      return altPlaceholder;
    }
    return item.coverUri;
  }

  private getAlbumName(item: AlbumInfo, isAllPhoto: Boolean, albumType: string): string | Resource {
    if (albumType === 'normal') {
      return isAllPhoto ? $r('app.string.album_all') : item.albumName
    } else {
      return albumType;
    }
  }

  @Builder
  BuildAlbumItem(albumType: string, routerType: AlbumType, item: AlbumInfo, index?: number) {
    ListItem() {
      this.AlbumListItem(item, false, albumType);
    }
    .width('100%')
    .onClick(async (): Promise<void> => {
      if (albumType === 'normal') {
        await this.handleClick(item, routerType)
      } else {
        this.pageInfos.pushPath({ name: routerType })
      }
    })
    .key('ListItem_' + index)
    .hoverEffect(HoverEffect.Highlight)
    .stateStyles({
      normal: {
        .backgroundColor(undefined)
      },
      pressed: {
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
        .borderColor($r('sys.color.comp_background_list_card'))
        .borderRadius($r('sys.float.corner_radius_level8'))
      },
    })
    .onHover((isHover: boolean, event: HoverEvent): void => {
      Log.info(TAG, `ishover:${isHover}, index:${index}`)
      this.getSelectUri(isHover, index);
    })
    .borderColor($r('sys.color.comp_background_list_card'))
    .constraintSize({ minHeight: $r('app.float.edit_horizontal_toolBar_size') })
    .borderRadius($r('sys.float.corner_radius_level8')) // 每个单独的ListItem圆角'16vp'
    .padding({
      left: $r('app.float.picker_list_item_padding'),
      right: $r('app.float.picker_list_item_padding'),
    })
  }

  @Builder
  BuildAlbumItemGroup(dataSource: IDataSource | undefined, albumType: string, routerType: AlbumType) {
    LazyForEach(dataSource, (item: AlbumSetDataInfo, index?: number) => {
      this.BuildAlbumItem(albumType, routerType, item.data, index);
    }, (item: AlbumSetDataInfo, index?: number) => `${item.data.uri}_${index}_${item.dateModified}`)
  }

  @Builder
  TabAlbums() {
    // 相册
    if (!this.isAlbumEmpty) {
      ListItemGroup({ style: ListItemGroupStyle.CARD }) {
        this.BuildAlbumItemGroup(this.faCardAlbumDataViewModel?.getAlbums(), 'normal', AlbumType.NORMAL);

        // 来源相册
        this.BuildAlbumItemGroup(this.faCardAlbumDataViewModel?.getSourceAlbums(), 'normal', AlbumType.SOURCE);
      }
      .divider({
        strokeWidth: '1px',
        color: $r('sys.color.ohos_fa_list_separator'),
        endMargin: $r('app.float.extended_services_listcard_padding_left_and_right'),
        startMargin: '64vp',
      })
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .borderRadius($r('sys.float.corner_radius_level10'))
      .margin({
        left: $r('app.float.margin_safe_left_and_right'),
        right: $r('app.float.margin_safe_left_and_right'),
      })
    } else {
      NoPhotoComponent({
        title: $r('app.string.no_distributed_photo_head_title_album'),
        winHeight: getScreen().getWinWidth(),
        isThird: true,
      })
    }
  }

  private getIsFontLargeScale(): boolean {
    return this.currentFontSizeScale >= GalleryConstants.FONT_SCALE_LARGE_SIZE;
  }

  @Builder
  AlbumListItem(item: AlbumInfo, isAllPhoto: boolean, albumType: string) {
    Flex({
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: this.getIsFontLargeScale() && albumType === 'normal' ? ItemAlign.Start : ItemAlign.Center,
      direction: this.getIsFontLargeScale() && albumType === 'normal' ? FlexDirection.Column : FlexDirection.Row
    }) {
      Row({ space: NORMAL_ITEM_ROW_SPACE }) {
        Image(this.setAlbumCoverUri(item, isAllPhoto))
          .height(40)
          .width(40)
          .border({
            radius: $r('sys.float.corner_radius_level6'),
            color: $r('sys.color.ohos_id_color_component_normal'),
            width: 0.5,
          })

        Column({ space: TEXT_COLUMN_SPACE }) {
          Text(this.getAlbumName(item, isAllPhoto, albumType))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .maxLines(TEXT_MAX_LINE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Medium)
            .focusable(true)
            .draggable(false)
        }
        .width(DeviceInfo.isFoldable() ? '55%' : '65%')
        .flexBasis('auto')
        .flexGrow(FLEX_GROW_NO)
        .margin({
          top: this.getIsFontLargeScale() ? 0 : TEXT_SAFE_MARGIN,
          bottom: this.getIsFontLargeScale() ? 0 : TEXT_SAFE_MARGIN,
        })
        .alignItems(HorizontalAlign.Start)
      }
      .flexGrow(FLEX_GROW_NO)

      if (albumType === 'normal') {
        Text(item.count.toString())
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_secondary'))
          .focusable(true)
          .draggable(false)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({
            left: this.getIsFontLargeScale() ? 56 : $r('sys.float.ohos_id_text_margin_horizontal'),
            top: this.getIsFontLargeScale() ? SCALE_SPACE : 0,
          })
      } else {
        Row() {
          Image($r('app.media.ic_gallery_form_arrow'))
            .draggable(false)
            .width($r('app.float.form_list_card_more_arrow_w'))
            .height($r('app.float.form_list_card_more_arrow_h'))
            .fillColor($r('sys.color.icon_fourth'))
            .margin({
              left: $r('sys.float.ohos_id_text_margin_horizontal'),
            })
        }
      }
    }
    .width('100%')
    .margin({
      top: this.listPaddingTopAndBottom,
      bottom: this.listPaddingTopAndBottom,
    })
  }

  @Builder
  ListForPhone() {
    List({ space: 4, scroller: this.albumScroller }) {
      this.TabAlbums();
    }
    .onAppear((): void => {
      this.albumScroller.scrollTo({ xOffset: 0, yOffset: 0 })
    })
    .sticky(StickyStyle.Header)
    .borderRadius($r('sys.float.corner_radius_level10'))
    .margin({
      left: $r('app.float.picker_list_margin_left_and_right'),
      right: $r('app.float.picker_list_margin_left_and_right'),
    })
    .alignListItem(ListItemAlign.Center)
    .width('100%')
    .flexGrow(1)
  }

  @Builder
  PageMap(name: string) {
  }

  build() {
    Navigation(this.pageInfos) {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Text($r('app.string.title_select_album'))
          .height($r('app.float.title_default'))
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .width('100%')
          .padding({ left: GalleryConstants.COLUMN_MARGIN_FOUR, right: GalleryConstants.COLUMN_MARGIN_FOUR })
          .margin({ top: 8, bottom: 8 })
          .flexShrink(0)

          .maxFontScale(1)
        this.ListForPhone();
        PickerSelectTip({ playEveryTime: true })
          .flexShrink(0)
          .margin({
            top: $r('app.float.picker_select_tips_margin_bottom'),
            bottom: this.bottomSafeAreaHeight,
          })
      }
      .borderRadius($r('sys.float.corner_radius_level10'))

      FaCardAlbumSelectTipView({
        startInsertAlbum: $startInsertAlbum,
        formId: this.formId,
      })
    }
    .hideTitleBar(true)
    .navDestination(this.PageMap)
  }
}