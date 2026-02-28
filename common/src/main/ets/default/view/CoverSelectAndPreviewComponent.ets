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

import lazy { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import lazy { DeviceInfo } from '../../default/utils/DeviceInfo';
import lazy { PickerSelectTip } from '../../../../../../feature/thirdselect/src/main/ets/default/view/PickerSelectTip';
import lazy { Log } from '../../default/utils/Log';
import lazy { ImageUtil } from '../../default/utils/ImageUtil';
import type { ViewData } from '../model/browser/photo/ViewData';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { Constants } from '../model/common/Constants';
import lazy { AppBar, AppBarController } from '../../default/view/actionbar/AppBar';
import lazy { CommSheetAppBarStyler } from '../../default/view/actionbar/CommSheetAppBarStyler';
import lazy { MenuConstants, MenuHelper, ParamsWrapper } from '../../default/view/actionbar/Menu';
import lazy {
  firstLevelTitleBuilder,
  FirstLevelTitleProp
} from '../../default/view/actionbar/FirstLevelTitle';
import lazy { CancelActionRegister } from './actionbar/CancelAction';
import lazy { BackActionRegister } from './actionbar/BackAction';
import lazy {
  getScreen,
  ScreenManager,
  isOrientationHorizontal
} from '../../default/model/common/ScreenManager';
import lazy { Action } from '../../default/view/browserOperation/Action';
import lazy { ActionButtonProp } from '../../default/view/actionbar/ActionButton';
import lazy { AlbumInfo } from '../../default/model/browser/album/AlbumInfo';
import lazy { AlbumDataSource } from '../../default/model/AlbumDataSource';
import lazy { ActionUtils } from '../../default/utils/ActionUtils';
import lazy { DataListener, LoadingResult } from '../../default/model/DataSource';

/* instrument ignore file */
const TAG = 'CoverSelectAndPreviewComponent';
const BLANK_COLUMN_HEIGHT: number = 72;
const PICKER_SELECT_MARGIN: number = 16;
const COLUMN_HEIGHT: number = 56;
export interface NavParams {
  cover: MediaItem;
}

@Component
export struct CoverSelectComponent {
  private navPathStackBindSheet: NavPathStack = new NavPathStack();
  private album: MediaDataSource | undefined = undefined;
  @State albumInfo: AlbumInfo = new AlbumInfo();
  public scroller: Scroller = new Scroller();
  @State private appBarController: AppBarController = new AppBarController();
  private appBarStyler: CommSheetAppBarStyler | undefined = undefined;
  private readonly menuHelper: MenuHelper = new MenuHelper();
  @State public navPathStack: NavPathStack = new NavPathStack();
  @State @Watch('onIsVerdeFoldableChanged') private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State @Watch('registerActions') private isColdStart: boolean = true;
  @State blanksGridHeight: number = BLANK_COLUMN_HEIGHT;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @State columnNumber: number = 4;
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  cancelFunc: Function = (): void => {
  };
  private readonly dataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.onDataLoadingFinished(result),
  } as DataListener<MediaItem>;

  private onDataLoadingFinished(result: LoadingResult<MediaItem>): void {
    let loadStart: number = result.info.start;
    let loadEnd: number = result.info.start + result.info.count;
    Log.info(TAG, `onDataLoadingFinished range: (${loadStart}, ${loadEnd})`);
    this.album?.onDataReloaded();
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear ${this.album?.totalCount()}`)
    this.album = new AlbumDataSource({context: getContext(), albumInfo: this.albumInfo});
    this.album?.notifyDirty();
    this.album?.addListener(this.dataListener);
    this.appBarStyler = new CommSheetAppBarStyler(getContext(), this.appBarController, getScreen());
    this.appBarStyler?.register();
    this.registerActions();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
  }

  aboutToDisappear(): void {
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.album?.removeListener(this.dataListener);
  }

  private onWinSizeChanged: Function = (): void => {
    if (DeviceInfo.isPhone() && !this.isHorizontal) {
      this.columnNumber = 4;
      return;
    }
    this.columnNumber = 5;
  };

  private cancelTransitionFunc(): void {
    this.cancelFunc?.()
  }

  private onIsVerdeFoldableChanged(): void {
    this.registerActions();
  }

  private registerActions(): void {
    // 清空内容
    this.appBarController.builders = [];
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_MENU_HELPER, this.menuHelper)
      .set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.appBarController)
      .set(MenuConstants.KEY_NAV_PATH_STACK, this.navPathStack)

    // 标题
    let titleProp: FirstLevelTitleProp = new FirstLevelTitleProp();
    titleProp.content = $r('app.string.replace_cover');
    titleProp.fontSize = $r('sys.float.Title_S')
    this.appBarController.builders.push({
      builder: firstLevelTitleBuilder,
      builderParams: titleProp,
      key: 'Title_' + TAG,
    });

    new CancelActionRegister( () => this.cancelTransitionFunc()).register(params);

    this.appBarController.backgroundColor = Color.Transparent;
    this.appBarController.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THICK;
    this.appBarController.transitionEffect = TransitionEffect
      .move(TransitionEdge.TOP)
      .animation({
        duration: this.isVerdeFoldable && !this.isColdStart ? Constants.TABBAR_SEGMENT_BUTTON_ANIMATION_DURATION : 0,
        curve: Curve.Friction,
      });

    let cancalProp: ActionButtonProp | undefined = this.getProp(Action.CANCEL);
    if (!cancalProp) {
      return;
    }
    cancalProp.iconSize = $r('app.float.cancel_right_icon_size');
  }

  protected getProp(action: Action): ActionButtonProp | undefined {
    let props: (ActionButtonProp | undefined)[] = ActionUtils.getProps(this.appBarController);
    let prop: ActionButtonProp | undefined;
    for (let prop of props) {
      if (prop?.action === action) {
        return prop;
      }
    }
    return prop;
  }

  build() {
    NavDestination() {
      Column() {
        AppBar({ controller: this.appBarController })
        this.buildCoverSelectSheetArea();

        PickerSelectTip()
          .margin({
            bottom: PICKER_SELECT_MARGIN,
          });
      }
      .backgroundColor(Color.Transparent)
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    }
    .hideTitleBar(true)
    .onBackPressed(() => {
      return false;
    })
  }

  private getImageCoverUri(mediaItem: MediaItem): string {
    return ImageUtil.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified?.(),
      false, mediaItem.getThumbnailReady?.());
  }

  @Builder
  buildCoverSelectSheetArea() {
    Column()
      .width('100%')
      .height(this.isVerdeFoldable ? Constants.LIST_HEIGHT : this.blanksGridHeight)
      .backgroundColor(Color.Transparent)
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    Column() {
      Grid() {
        LazyForEach(this.album, (item: ViewData, index?: number) => {
          GridItem() {
            if (item?.mediaItem?.uri) {
              Image(this.getImageCoverUri(item.mediaItem))
                .aspectRatio(1)
                .draggable(false)
                .onClick((): void => {
                  this.navPathStackBindSheet.pushPathByName(Constants.COVER_PREVIEW_SHEET, {
                    cover: item.mediaItem,
                  } as NavParams);
                })
                .onComplete(() => {
                })
                .onError((error: ImageError) => {
                  Log.error(TAG, `Item loading failed ${error.message}`)
                })
            }
          }
        }, (item: ViewData, index?: number) => {
          return item.mediaItem?.uri;
        })
      }
      .columnsTemplate('1fr '.repeat(this.columnNumber))
      .columnsGap(Constants.GRID_GUTTER)
      .rowsGap(Constants.GRID_GUTTER)
      .scrollBar(BarState.Off) // 进度条样式 BarState.Off 关闭进度条
      .cachedCount(4)
    }
    .backgroundColor(Color.Transparent)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    .width('100%')
    .height('100%')
    .layoutWeight(1)
  }
}

// 封面编辑 封面预览页面
@Component
export struct CoverPreviewSheet {
  private navPathStackBindSheet: NavPathStack = new NavPathStack();
  public scroller: Scroller = new Scroller();
  // 选择的封面照片
  @Link selectCoverItem: MediaItem;
  // 进入该界面时的照片
  private coverItem: MediaItem = new MediaItem();
  @State private appBarController: AppBarController = new AppBarController();
  private appBarStyler: CommSheetAppBarStyler | undefined = undefined;
  private readonly menuHelper: MenuHelper = new MenuHelper();
  @State public navPathStack: NavPathStack = new NavPathStack();
  @State @Watch('onIsVerdeFoldableChanged') private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State @Watch('registerActions') private isColdStart: boolean = true;
  @State blanksGridHeight: number = BLANK_COLUMN_HEIGHT;
  cancelFunc: Function = (): void => {
  };

  aboutToAppear() {
    Log.info(TAG, `aboutToAppear. ${JSON.stringify(this.navPathStackBindSheet.getParamByName(Constants.COVER_PREVIEW_SHEET))}`);
    let coverParam: NavParams =
      this.navPathStackBindSheet.getParamByName(Constants.COVER_PREVIEW_SHEET)[0] as NavParams;
    this.coverItem = coverParam.cover;
    this.appBarStyler = new CommSheetAppBarStyler(getContext(), this.appBarController, getScreen());
    this.appBarStyler?.register();
    this.registerActions();
  }

  private onIsVerdeFoldableChanged(): void {
    this.registerActions();
  }

  private cancelTransitionFunc(): void {
    this.cancelFunc?.()
  }

  private backFunc(): void {
    this.navPathStackBindSheet.pop();
  }

  private registerActions(): void {
    // 清空内容
    this.appBarController.builders = [];
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_MENU_HELPER, this.menuHelper)
      .set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.appBarController)
      .set(MenuConstants.KEY_NAV_PATH_STACK, this.navPathStack)

    new BackActionRegister( () => this.backFunc()).register(params);

    // 标题
    let titleProp: FirstLevelTitleProp = new FirstLevelTitleProp();
    titleProp.content = $r('app.string.replace_cover');
    titleProp.fontSize = $r('sys.float.Title_S')
    this.appBarController.builders.push({
      builder: firstLevelTitleBuilder,
      builderParams: titleProp,
      key: 'Title_' + TAG,
    });

    new CancelActionRegister( () => this.cancelTransitionFunc()).register(params);

    this.appBarController.backgroundColor = Color.Transparent;
    this.appBarController.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THICK;
    this.appBarController.transitionEffect = TransitionEffect
      .move(TransitionEdge.TOP)
      .animation({
        duration: this.isVerdeFoldable && !this.isColdStart ? Constants.TABBAR_SEGMENT_BUTTON_ANIMATION_DURATION : 0,
        curve: Curve.Friction,
      });

    let cancalProp: ActionButtonProp | undefined = this.getProp(Action.CANCEL);
    if (!cancalProp) {
      return;
    }
    cancalProp.iconSize = $r('app.float.cancel_right_icon_size');
  }

  protected getProp(action: Action): ActionButtonProp | undefined {
    let props: (ActionButtonProp | undefined)[] = ActionUtils.getProps(this.appBarController);
    let prop: ActionButtonProp | undefined;
    for (let prop of props) {
      if (prop?.action === action) {
        return prop;
      }
    }
    return prop;
  }

  build() {
    NavDestination() {
      Column() {
        AppBar({ controller: this.appBarController })
        Column()
          .height(COLUMN_HEIGHT)
          .width('100%')
        this.coverPreview()
        this.buildBottomArea()

        PickerSelectTip()
          .margin({
            bottom: PICKER_SELECT_MARGIN
          });
      }
      .backgroundColor(Color.Transparent)
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    }
    .hideTitleBar(true)
  }

  @Builder
  coverPreview() {
    Column() {
      Image(ImageUtil.getHighlightCoverLcdUri(this.coverItem, { width: -1, height: -1, }))
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .layoutWeight(1)
    .backgroundColor(Color.Transparent)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    .margin({ top: $r('sys.float.padding_level4') })
  }

  @Builder
  buildBottomArea() {
    Row() {
      this.buildButton()
    }
    .backgroundColor(Color.Transparent)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    .width('100%')
    .justifyContent(FlexAlign.End)
  }

  @Builder
  buildButton() {
    Button() {
      Row() {
        Text($r('app.string.complete'))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .maxFontScale(1.45)
          .fontColor($r('sys.color.font_on_primary'))
          .textAlign(TextAlign.Center)
      }
      .alignItems(VerticalAlign.Center)
      .margin({
        left: '22vp',
        right: '22vp',
      })
    }
    .constraintSize({
      minWidth: '72vp',
      minHeight: '28vp',
    })
    .key('Complete')
    .onClick((): void => {
      let coverParam: NavParams =
        this.navPathStackBindSheet.getParamByName(Constants.COVER_PREVIEW_SHEET)[0] as NavParams;
      let mediaItem: MediaItem = coverParam.cover;
      mediaItem.setThumbnail(mediaItem.getThumbnailSafe({ width: -1, height: -1 }));
      Log.info(TAG, `${mediaItem.thumbnail}`)
      this.selectCoverItem = mediaItem;
      this.navPathStackBindSheet.clear();
    })
    .margin({
      top: $r('app.float.third_selected_panel_image_padding_top'),
      bottom: $r('app.float.third_selected_panel_image_padding_top'),
      right: 16,
    })
  }
}