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

import lazy { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy { Constants as BrowserConstants } from '../../../default/model/browser/photo/Constants';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { EventHelper } from '../../../default/view/ViewEventHelper';
import lazy { Log } from '../../../default/utils/Log';
import lazy { NavigationConstants } from '../../../default/model/common/NavigationConstants';
import lazy { ReportSmartAlbumDataUtil } from '../../../default/utils/ReportSmartAlbumDataUtil';
import lazy Curves from '@ohos.curves';
import lazy {
  getDelayConst,
  getDurationConst,
  GridLink
} from '../../../default/model/browser/photo/const/GridLinkDelay';
import lazy { AlbumGrid } from '../../../default/model/AlbumGrid';
import lazy { NavigationBroadCastManager } from '../../../default/model/common/NavigationBroadCastManager';
import lazy { AlbumDefine } from '../../../default/model/browser/AlbumDefine';
import lazy { ParamsWrapper } from '../../../default/view/actionbar/Menu';
import lazy { AlbumRefreshConst, OnAlbumClickListener } from '../../../default/utils/AlbumRefreshUtil';
import lazy { FontUtil } from '../../../default/utils/FontUtil';
import lazy { UiUtil } from '../../../default/utils/UiUtil';
import lazy { AlbumDataSource } from '../../../default/model/AlbumDataSource';
import lazy { UnionAlbumDataSource } from '../../../default/model/UnionAlbumDataSource';
import lazy { DataSourceCommonUtil } from '../../../default/utils/DataSourceCommonUtil';
import lazy { Configuration } from '@kit.ArkUI';
import lazy { BigDataConstants, ReportToBigDataUtil, AlbumBrowsingInfo } from '../../../default/utils/ReportToBigDataUtil';
import lazy { AlbumBigDataConstants } from '../../model/browser/album/ReportAlbumDataUtil';
import lazy { TrashAlbumAccurateUpdater } from '../../model/TrashAlbumAccurateUpdater';
import lazy { AccurateChecker } from '../../model/AlbumAccurateUpdater';
import { MediaObserver } from '../../../default/model/browser/dataObserver/MediaObserver';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG: string = 'AlbumMore';

interface ParamAlbumInfo {
  item: string;
  isFromFACard?: boolean;
}

@Extend(Image)
function coverImage() {
  .draggable(false)
  .width($r('app.float.list_item_left_icon_bg_size'))
  .height($r('app.float.list_item_left_icon_bg_size'))
  .border({
    radius: $r('sys.float.ohos_id_corner_radius_grid'),
    width: $r('app.float.album_card_border_width'),
    color: $r('app.color.album_card_border_color'),
  })
}


@Extend(SymbolGlyph)
function countImage() {
  .draggable(false)
  .fontSize($r('app.float.list_item_right_icon2_height'))
  .fontColor([$r('sys.color.icon_fourth')])
}

@Extend(Text)
function coverText() {
  .draggable(false)
  .fontWeight(FontWeight.Medium)
  .fontSize($r('sys.float.ohos_id_text_size_body1'))
  .fontColor($r('sys.color.font_primary'))
  .fontFamily('HarmonyHeiTi')
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .constraintSize({ minWidth: '115vp' })
  .margin({
    left: $r('app.float.list_item_text_left_margin'),
    right: $r('app.float.list_item_right_icon2_width'),
  })
}

@Extend(Text)
function countText() {
  .draggable(false)
  .fontColor($r('sys.color.font_secondary'))
  .fontFamily('HarmonyHeiTi')
  .fontSize(Constants.TEXT_SIZE_BODY2)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
}

/* instrument ignore next */
@Component
export struct AlbumMore {
  public onClickListener: OnAlbumClickListener | undefined = undefined;
  // 是否显示照片宫格视图
  @StorageLink('isShowPhotoGridView') isShowPhotoGridView: boolean = false;
  @State @Watch('updatedItem') item: AlbumInfo = new AlbumInfo();
  @State isEmptyAlbum: boolean = false;
  private keyIndex: number = -1;
  @Prop albumCount: number;
  @Consume isAlbumSetSelectedMode: boolean;
  @Consume isShowPhotoHiddenView: boolean;
  @Prop private isSourceAlbumShow: boolean;
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  private readonly onClickHelper: EventHelper<ClickEvent> = new EventHelper<ClickEvent>();
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') private currentFontSizeScale: number = 1;
  @State private listPaddingTopAndBottom: Resource = $r('sys.float.padding_level6');
  private albumContext?: Context;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    // 选择模式直接拦截，不作任何响应
    this.onClickHelper.register((event: ClickEvent) => this.isAlbumSetSelectedMode);
    this.onClickHelper.register((event: ClickEvent) => {
      if (this.item.isSourceAlbum) {
        Log.info(TAG, `sourceCard click and albumName = ${this.item.albumName}`);
        this.albumOnClickSource();
      } else {
        this.albumOnClick();
      }
      if (DeviceInfo.isGRLFoldScreen()) {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_SELECTED_ALBUM_INDEX, this.keyIndex);
        AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, this.item.uri);
      }
      return false;
    });
    this.currentFontSizeScaleChange();
  }

  updatedItem(): void {
    Log.info(TAG, JSON.stringify(this.item));
  }

  @Builder
  sourceEmptyCard() {
    Row() {
      SymbolGlyph($r('sys.symbol.picture_fill'))
        .draggable(false)
        .fontSize($r('app.float.list_item_left_icon_size'))
        .fontColor([$r('sys.color.icon_secondary')])
    }
    .width($r('app.float.list_item_left_icon_bg_size'))
    .height($r('app.float.list_item_left_icon_bg_size'))
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_grid'))
    .justifyContent(FlexAlign.Center)
    .alignRules({
      left: { anchor: '__container__', align: HorizontalAlign.Start },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    })
    .id('row1')
  }

  @Builder
  sourceNormalCard() {
    Row() {
      Image(this.item.coverUri)
        .interpolation(ImageInterpolation.Medium)
        .onError((event: ImageError): void => {
          Log.error(TAG, `album is empty or its cover is error, path333: ${this.item.coverUri}, ` +
            `${AlbumDefine.getAnonymizeAlbumName(this.item.albumName)}, error: ${event.message}`);
          this.isEmptyAlbum = true;
        })
        .coverImage()
    }
    .alignRules({
      left: { anchor: '__container__', align: HorizontalAlign.Start },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    })
    .id('row1')
  }

  // instrument ignore next
  @Builder
  largeFontSourceEmptyCard() {
    Column() {
      SymbolGlyph($r('sys.symbol.picture_fill'))
        .draggable(false)
        .fontSize($r('app.float.list_item_left_icon_size'))
        .fontColor([$r('sys.color.icon_secondary')])
    }
    .width($r('app.float.list_item_left_icon_bg_size'))
    .height($r('app.float.list_item_left_icon_bg_size'))
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_grid'))
    .justifyContent(FlexAlign.Center)
  }

  // instrument ignore next
  @Builder
  largeFontSourceNormalCard() {
    Column() {
      Image(this.item.coverUri)
        .interpolation(ImageInterpolation.Medium)
        .onError((event: ImageError): void => {
          Log.error(TAG, `album is empty or its cover is error, path333: ${this.item.coverUri}, ` +
            `${AlbumDefine.getAnonymizeAlbumName(this.item.albumName)}, error: ${event.message}`);
          this.isEmptyAlbum = true;
        })
        .coverImage()
    }
  }

  @Builder
  sourceCard() {
    // instrument ignore else
    if (this.currentFontSizeScale < Constants.FONT_SCALE_LARGE_SIZE) {
      // 小于1.75倍不需要换行处理
      Column() {
        RelativeContainer() {
          this.buildSourceCardRows();
          Row() {
            SymbolGlyph($r('sys.symbol.chevron_right'))
              .countImage()
          }.alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .id('row3')

          Row() {
            Text(String(this.item.count))
              .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
              .countText()
          }.alignRules({
            right: { anchor: 'row3', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .margin({ right: 4 })
          .id('row4')
        }
        .height('63vp')
      }
      .width('100%')
      .height($r('app.float.list_height'))
    } else {
      // 大于等于1.75倍需要换行处理
      this.largeFontSourceCard();
    }
  }

  // instrument ignore next
  @Builder
  largeFontSourceCard() {
    Column({ space: 2 }) {
      Row() {
        if (this.isEmptyAlbum) {
          this.largeFontSourceEmptyCard();
        } else {
          this.largeFontSourceNormalCard();
        }
        this.largeFontCoverText(String(this.item.albumName));
      }
      .width('100%')

      Row() {
        Text(String(this.item.count))
          .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
          .draggable(false)
          .fontColor($r('sys.color.font_secondary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize(Constants.TEXT_SIZE_BODY2)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({
            left: $r('app.float.account_list_card_height'),
            right: $r('app.float.list_item_right_icon2_width'),
          });

        SymbolGlyph($r('sys.symbol.chevron_right'))
          .countImage()
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ top: this.listPaddingTopAndBottom, bottom: this.listPaddingTopAndBottom })
    .width('100%')
  }

  @Builder
  buildSourceCardRows() {
    if (this.isEmptyAlbum) {
      this.sourceEmptyCard();
    } else {
      this.sourceNormalCard();
    }
    Row() {
      Text(this.item.albumName)
        .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
        .coverText()
    }
    .alignRules({
      left: { anchor: 'row1', align: HorizontalAlign.End },
      right: { anchor: 'row4', align: HorizontalAlign.Start },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    })
    .id('row2');
  }

  // instrument ignore next
  @Builder
  sourceCardCollapse() {
    if (this.currentFontSizeScale < Constants.FONT_SCALE_LARGE_SIZE) {
      // 小于1.75倍不需要换行处理
      Column() {
        RelativeContainer() {
          this.buildSourceCardCollapseRows();
          Row() {
            SymbolGlyph($r('sys.symbol.chevron_right'))
              .countImage()
              .animation({
                curve: Curves.interpolatingSpring(0, 1, Constants.IMAGE_ITEM_PRESS_CURVE_STIFFNESS,
                  Constants.IMAGE_ITEM_PRESS_CURVE_DAMPING)
              })
          }.alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .id('row3')

          Row() {
            Text(String(this.item.count))
              .countText()
              .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
              .animation({
                curve: Curves.interpolatingSpring(0, 1, Constants.IMAGE_ITEM_PRESS_CURVE_STIFFNESS,
                  Constants.IMAGE_ITEM_PRESS_CURVE_DAMPING)
              })
          }.alignRules({
            right: { anchor: 'row3', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .margin({ right: 4 })
          .id('row4')
        }
        .visibility(this.isSourceAlbumShow ? Visibility.Visible : Visibility.None)
        .opacity(this.isSourceAlbumShow ? 1 : 0)
        .animation({
          curve: Curves.interpolatingSpring(0, 1, Constants.GROUP_ITEM_PRESS_CURVE_STIFFNESS, Constants.CARD_CONTAINER),
        })
        .height('63vp')
      }
      .width('100%')
      .height($r('app.float.list_height'))
    } else {
      // 大于等于1.75倍需要换行处理
      this.largeFontSourceCardCollapse();
    }
  }

  // instrument ignore next
  @Builder
  largeFontSourceCardCollapse() {
    Column({ space: 2 }) {
      Row() {
        if (this.isEmptyAlbum) {
          this.largeFontSourceEmptyCard();
        } else {
          this.largeFontSourceNormalCard();
        }
        this.largeFontCoverText(String(this.item.albumName));
      }
      .width('100%')

      Row() {
        Text(String(this.item.count))
          .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
          .draggable(false)
          .fontColor($r('sys.color.font_secondary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize(Constants.TEXT_SIZE_BODY2)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .animation({
            curve: Curves.interpolatingSpring(0, 1, Constants.IMAGE_ITEM_PRESS_CURVE_STIFFNESS,
              Constants.IMAGE_ITEM_PRESS_CURVE_DAMPING)
          })
          .margin({
            left: $r('app.float.account_list_card_height'),
            right: $r('app.float.list_item_right_icon2_width'),
          });

        SymbolGlyph($r('sys.symbol.chevron_right'))
          .countImage()
          .animation({
            curve: Curves.interpolatingSpring(0, 1, Constants.IMAGE_ITEM_PRESS_CURVE_STIFFNESS,
              Constants.IMAGE_ITEM_PRESS_CURVE_DAMPING)
          })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .visibility(this.isSourceAlbumShow ? Visibility.Visible : Visibility.None)
    .opacity(this.isSourceAlbumShow ? 1 : 0)
    .animation({
      curve: Curves.interpolatingSpring(0, 1, Constants.GROUP_ITEM_PRESS_CURVE_STIFFNESS, Constants.CARD_CONTAINER),
    })
    .alignItems(HorizontalAlign.Start)
    .margin({ top: this.listPaddingTopAndBottom, bottom: this.listPaddingTopAndBottom })
    .width('100%')
  }

  // instrument ignore next
  @Builder
  buildSourceCardCollapseRows() {
    if (this.isEmptyAlbum) {
      this.sourceEmptyCard();
    } else {
      this.sourceNormalCard();
    }
    Row() {
      Text(this.item.albumName)
        .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
        .coverText()
        .animation({
          curve: Curves.interpolatingSpring(0,
            1, Constants.IMAGE_ITEM_PRESS_CURVE_STIFFNESS, Constants.IMAGE_ITEM_PRESS_CURVE_DAMPING)
        });
    }
    .alignRules({
      left: { anchor: 'row1', align: HorizontalAlign.End },
      right: { anchor: 'row4', align: HorizontalAlign.Start },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    })
    .id('row2');
  }

  // instrument ignore next
  doAnimation(): void {
    let albumToPhotoGridDuration: number;
    let albumActionBarDuration: number;
    let photoGridActionBarDuration: number;
    let photoGridActionBarDelay: number;
    albumToPhotoGridDuration = getDurationConst(GridLink.ALBUM_TO_PHOTO_GRID);
    photoGridActionBarDuration = getDurationConst(GridLink.IN_PHOTO_GRID_ACTION_BAR);
    photoGridActionBarDelay = getDelayConst(GridLink.PHOTO_GRID_ACTIONBAR);
    if (!DeviceInfo.isPc()) {
      albumActionBarDuration = getDurationConst(GridLink.ALBUM_ACTIONBAR);
    } else {
      albumActionBarDuration = getDurationConst(GridLink.IN_ALBUM_ACTIONBAR);
    }
    animateTo({
      duration: albumToPhotoGridDuration,
      curve: Curve.Friction,
      onFinish: (): void => {
        AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, false);
      }
    }, (): void => {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, !this.isShowPhotoGridView);
      AppStorage.setOrCreate<number>(Constants.KEY_OF_SELECTED_ALBUM_INDEX, this.keyIndex ? this.keyIndex : -1);
      AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, this.item.uri);
    })
    animateTo({
      duration: albumActionBarDuration,
      curve: Curve.Sharp,
    }, (): void => {
      if (!DeviceInfo.isPc()) {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 0);
      }
      AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_ACTIONBAR_OPACITY, 0);
    })
    animateTo({
      duration: albumActionBarDuration,
      curve: Curve.Sharp,
      delay: getDelayConst(GridLink.IN_PHOTO_GRID),
    }, (): void => {
      if (!DeviceInfo.isPc()) {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
      }
    })
    animateTo({
      duration: photoGridActionBarDuration,
      delay: photoGridActionBarDelay,
      curve: Curve.Sharp,
    }, (): void => {
      AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);
    })

    if (DeviceInfo.isPc()) {
      animateTo({
        duration: getDurationConst(GridLink.IN_PHOTO_GRID),
        delay: getDelayConst(GridLink.IN_PHOTO_GRID),
        curve: Curve.Sharp,
      }, (): void => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
      })
      animateTo({
        duration: getDurationConst(GridLink.ALBUM),
        curve: Curve.Sharp,
      }, (): void => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 0);
      })
      animateTo({
        duration: getDurationConst(GridLink.IN_SIDEBAR),
        curve: Curve.Sharp,
      }, (): void => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_SIDE_BAR_BOUNDARY_LINE_OPACITY, 0);
      })
    }
    Log.info(TAG, 'do animation');
  }

  private setStatusOnAnimationFinish(): void {
    setTimeout((): void => {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, false);
    }, getDurationConst(GridLink.ALBUM_TO_PHOTO_GRID))
  }

  private albumOnClick(): void {
    Log.info(TAG, `After onclick, albumList uri: ${this.item?.uri}, albumName: ${AlbumDefine.getAnonymizeAlbumName(this.item?.albumName)}`);
    // instrument ignore if
    if (this.isShowPhotoGridView) {
      Log.info(TAG, 'PhotoGridView is show, has no focus, Users need to manually activate the focus.');
      return;
    }
    Log.info(TAG, 'isShowPhoto', JSON.stringify(this.isShowPhotoGridView));
    this.setStatusOnAnimationFinish();
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, true);
    const albumInfo: ParamAlbumInfo = { item: JSON.stringify(this?.item) };
    AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, albumInfo);
    AlbumGrid.firstItem = this.item?.mediaItem?.data;
    AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_URI, this?.item.uri);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);

    let listener = this.onClickListener?.onAlbumClicked(this.item);
    let params: ParamsWrapper = new ParamsWrapper().set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_LISTENER, listener);
    // instrument ignore if
    if (DeviceInfo.isPhoneUx() && this.item.isTrashAlbum) {
      Log.info(TAG, 'this item is trash album.');
      let isDataSourceNormalization: boolean = DataSourceCommonUtil.isDataSourceNormalizationEnabled();
      if (isDataSourceNormalization) {
        let targetAlbumInfo: AlbumInfo = JSON.parse(albumInfo.item) as AlbumInfo;
        targetAlbumInfo.subType = Number(photoAccessHelper.AlbumSubtype.TRASH);
        let targetDataSource: AlbumDataSource =
          new AlbumDataSource({
            context: getContext(),
            albumInfo: targetAlbumInfo,
            isAccurateNotify: true,
          });
        MediaObserver.getInstance()
          .register(MediaObserver.REGISTER_TRASH_PHOTO_CHANGE, targetDataSource, 'AlbumMore_TrashAlbum');
        params.set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_DATASOURCE, targetDataSource);
      }
    }
    NavigationBroadCastManager.getInstance().getBroadCast().emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE]).then(() => {
      this.navigationPageInfos.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE, params));
    });
  }

  private async albumOnClickSource(): Promise<void> {
    Log.info(TAG, `After onclick, sourceAlbum uri: ${this.item?.uri}, albumName: ${this.item?.albumName}`);
    const msg: Record<string, number | string | boolean | Resource> = {
      'ALBUM_TYPE': this.item.subType,
      'ALBUM_NAME': this.item.albumName,
      'PICTURES_COUNT': this.item.count,
      'VIEW_STYLE': this.item.viewMode
    };
    ReportToBigDataUtil.report(BigDataConstants.CLICK_ON_THE_ALBUM, msg);
    this.reportMoreAlbumToBigData(this.item);
    let albumInfo: ParamAlbumInfo = { item: JSON.stringify(this?.item) };
    AppStorage.delete(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
    AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, albumInfo);
    AlbumGrid.firstItem = this.item?.mediaItem?.data;
    ReportSmartAlbumDataUtil.enterSourceAlbums(this.item.albumName as string, this.item.count)
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);

    let listener = this.onClickListener?.onAlbumClicked(this.item);
    let params: ParamsWrapper = new ParamsWrapper().set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_LISTENER, listener);
    if (DeviceInfo.isPhoneUx() && this.item.isSourceAlbum) {
      let isDataSourceNormalization: boolean = DataSourceCommonUtil.isDataSourceNormalizationEnabled();
      if (isDataSourceNormalization) {
        let targetAlbumInfo: AlbumInfo = this.item;
        let targetDataSource: AlbumDataSource;
        if (this.item.isSourceAlbum && this.item.unionAlbumUris.length > 0) {
          targetDataSource = new UnionAlbumDataSource({ context: getContext(), albumInfo: targetAlbumInfo });
        } else {
          targetDataSource = new AlbumDataSource({ context: getContext(), albumInfo: targetAlbumInfo,
            isAccurateNotify: true, });
        }
        params.set(AlbumRefreshConst.KEY_OF_ALBUM_NAV_PARAM_DATASOURCE, targetDataSource);
      }
    }

    NavigationBroadCastManager.getInstance().getBroadCast().emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE]).then(() => {
      this.navigationPageInfos.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_OTHER_ALBUM_PAGE, params));
    });
  }

  private reportMoreAlbumToBigData(item: AlbumInfo) {
    const content: Record<string, number> = {
      'imageCount': (item.count - item.videoCount),
      'videoCount': item.videoCount
    };
    const msg: Record<string, number | string> = {
      'albumEvent': AlbumBigDataConstants.ENTER_SOURCE_ALBUM,
      'albumType': item.subType,
      'content': JSON.stringify(content)
    };
    AlbumBrowsingInfo.albumSubtype = item.subType;
    ReportToBigDataUtil.report(AlbumBigDataConstants.ALBUM_CONTENT_REPORT, msg);
  }

  // instrument ignore next
  @Builder
  hiddenCard() {
    // 已隐藏
    Column() {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Start,
      }) {
        Column() {
          SymbolGlyph($r('sys.symbol.eye_slash'))
            .draggable(false)
            .fontSize($r('app.float.list_item_left_icon_size'))
            .fontColor([$r('sys.color.icon_secondary')])

        }
        .width($r('app.float.list_item_left_icon_bg_size'))
        .height($r('app.float.list_item_left_icon_bg_size'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .border({
          radius: $r('sys.float.ohos_id_corner_radius_grid'),
        })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)

        Column() {
          Text($r('app.string.hidden_album'))
            .draggable(false)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontColor($r('sys.color.font_primary'))
            .fontFamily('HarmonyHeiTi')
        }
        .flexGrow(1)
        .margin({
          left: $r('app.float.list_item_text_left_margin'),
        })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        Row() {
          SymbolGlyph($r('sys.symbol.lock_fill'))
            .draggable(false)
            .fontSize($r('app.float.list_item_right_icon1_size'))
            .fontColor([$r('sys.color.icon_secondary')])
          SymbolGlyph($r('sys.symbol.chevron_right'))
            .draggable(false)
            .fontSize($r('app.float.list_item_right_icon2_height'))
            .fontColor([$r('sys.color.icon_fourth')])
            .margin({
              left: $r('app.float.list_item_right_icon2_margin_left'),
            })
        }
        .margin({
          left: $r('app.float.list_item_right_icon1_margin_left'),
        })
        .align(Alignment.End)
      }
      .height($r('app.float.list_height'))
    }
    .height($r('app.float.list_height'))
  }

  // instrument ignore next
  @Builder
  largeFontCommonCard(iconResource: Resource, textResource: Resource | string) {
    Column({ space: 2 }) {
      Row() {
        Column() {
          SymbolGlyph(iconResource)
            .draggable(false)
            .fontSize($r('app.float.list_item_left_icon_size'))
            .fontColor([$r('sys.color.icon_secondary')])
        }
        .width($r('app.float.list_item_left_icon_bg_size'))
        .height($r('app.float.list_item_left_icon_bg_size'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .border({ radius: $r('sys.float.ohos_id_corner_radius_grid') })
        .justifyContent(FlexAlign.Center)

        this.largeFontCoverText(textResource);
      }
      .width('100%')

      Row() {
        Text(String(this.item.count))
          .draggable(false)
          .fontColor($r('sys.color.font_secondary'))
          .fontFamily('HarmonyHeiTi')
          .fontSize(Constants.TEXT_SIZE_BODY2)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({
            left: $r('app.float.account_list_card_height'),
            right: $r('app.float.list_item_right_icon2_width'),
          });

        SymbolGlyph($r('sys.symbol.chevron_right'))
          .countImage()
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ top: this.listPaddingTopAndBottom, bottom: this.listPaddingTopAndBottom })
    .width('100%')
  }

  /**
   * 最近删除风格一致的通用列表元素
   *
   * @param iconResource 列表左侧图片
   * @param textResource 列表相册名称
   */
  @Builder
  commonCard(iconResource: Resource, textResource: Resource | string) {
    // instrument ignore else
    if (this.currentFontSizeScale < Constants.FONT_SCALE_LARGE_SIZE) {
      // 小于1.75倍不需要换行处理
      Column() {
        RelativeContainer() {
          Row() {
            SymbolGlyph(iconResource)
              .draggable(false)
              .fontSize($r('app.float.list_item_left_icon_size'))
              .fontColor([$r('sys.color.icon_secondary')])
          }
          .width($r('app.float.list_item_left_icon_bg_size'))
          .height($r('app.float.list_item_left_icon_bg_size'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .border({
            radius: $r('sys.float.ohos_id_corner_radius_grid'),
          })
          .justifyContent(FlexAlign.Center)
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .id('row1')

          Row() {
            Text(textResource)
              .coverText()
          }
          .alignRules({
            left: { anchor: 'row1', align: HorizontalAlign.End },
            right: { anchor: 'row4', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .id('row2')

          Row() {
            SymbolGlyph($r('sys.symbol.chevron_right'))
              .countImage()
          }.alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .id('row3')

          Row() {
            Text(String(this.item.count))
              .countText()
          }.alignRules({
            right: { anchor: 'row3', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
          .margin({ right: 4 })
          .id('row4')
        }
        .height('63vp')
      }
      .height($r('app.float.list_height'))
    } else {
      // 大于等于1.75倍需要换行处理
      this.largeFontCommonCard(iconResource, textResource);
    }
  }

  // instrument ignore next
  build() {
    Stack() {
      // 获取占位组件，不显示，大字体时撑大列表高度（必须放在列表元素前面，使其被列表元素覆盖，否则会覆盖列表元素影响列表的点击事件）
      this.buildPlaceHolderForBigFontMargin();

      Column() {
        // instrument ignore if
        if (this.item.isTrashAlbum) {
          // 最近删除
          this.commonCard($r('sys.symbol.trash'), $r('app.string.album_recycle'));
        }
        else if (this.item.isDuplicateAlbum) {
          // 重复照片
          this.commonCard($r('sys.symbol.repeat_track'), $r('app.string.duplicate_photo'));
        } else {
          if (this.keyIndex <= 4) {
            this.sourceCard();
          } else {
            this.sourceCardCollapse();
          }
        }
      }
    }
    .accessibilityDescription(this.getCheckActionStr())
    .onClick((event: ClickEvent): void => {
      this.onClickHelper.process(event);
    })
    .key(`AlbumMore_${this.keyIndex}`)
  }

  /**
   * 无障碍多选模式下，朗读增加不可用
   * @returns
   */
  private getCheckActionStr(): string {
    let checkActionStr = '';

    if (this.isAlbumSetSelectedMode) {
      if (!this.albumContext) {
        this.albumContext = getContext();
      }
      let rsc: RscGetter = new RscGetter(this.albumContext.resourceManager);
      // 不可用
      checkActionStr = rsc.getString($r('app.string.disabled'));
    }
    return checkActionStr;
  }

  /**
   * 根据字体放大倍数，调整列表上下间距高度
   */
  private currentFontSizeScaleChange(): void {
    this.listPaddingTopAndBottom = FontUtil.getPaddingByFontScale(this.currentFontSizeScale);
    Log.info(TAG,
      `currentFontSizeScaleChange listPaddingTopAndBottom: ${px2vp(UiUtil.getResourceNumber(this.listPaddingTopAndBottom))}`);
  }

  // instrument ignore next
  @Builder
  largeFontCoverText(itemName: string | Resource) {
    Text(itemName)
      .direction(Configuration.getLocale().dir === 'ltr' ? Direction.Ltr : Direction.Rtl)
      .draggable(false)
      .fontWeight(FontWeight.Medium)
      .fontSize($r('sys.float.ohos_id_text_size_body1'))
      .fontColor($r('sys.color.font_primary'))
      .fontFamily('HarmonyHeiTi')
      .wordBreak(WordBreak.BREAK_ALL)
      .maxLines(2)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .layoutWeight(1)
      .margin({
        left: $r('app.float.list_item_text_left_margin'),
        right: $r('app.float.list_item_right_icon2_width'),
      })
  }

  /**
   * 获取占位组件，不显示，大字体时撑大列表高度，解决RelativeContainer内大字体不能撑大容器的问题
   */
  @Builder
  buildPlaceHolderForBigFontMargin() {
    if (this.currentFontSizeScale !== Constants.FONT_SCALE_LARGE_SIZE) {
      // text占位不显示，用于大字体撑大列表高度
      Text('placeholder').visibility(Visibility.Hidden).zIndex(-1)
        .margin({ top: this.listPaddingTopAndBottom, bottom: this.listPaddingTopAndBottom })
        .accessibilityLevel('no')
    }
  }
}