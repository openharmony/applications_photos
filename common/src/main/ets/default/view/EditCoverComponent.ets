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

import lazy { AppBar, AppBarController } from '../../default/view/actionbar/AppBar';
import lazy { CommSheetAppBarStyler } from '../../default/view/actionbar/CommSheetAppBarStyler';
import lazy { Constants } from '../../default/model/common/Constants';
import lazy { getScreen, isOrientationHorizontal, } from '../../default/model/common/ScreenManager';
import lazy { Log } from '../../default/utils/Log';
import lazy { MenuConstants, MenuHelper, ParamsWrapper } from '../../default/view/actionbar/Menu';
import lazy { firstLevelTitleBuilder, FirstLevelTitleProp } from '../../default/view/actionbar/FirstLevelTitle';
import lazy { CancelActionRegister } from './actionbar/CancelAction';
import lazy { ConfirmActionRegister } from './actionbar/ConfirmAction';
import lazy { ImageUtil } from '../../default/utils/ImageUtil';
import lazy { MediaItem } from '../../default/model/browser/photo/MediaItem';
import lazy { UiUtil } from '../../default/utils/UiUtil';
import lazy { DeviceInfo } from '../../default/utils/DeviceInfo';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { Matrix4x4 } from '../../default/utils/Matrix4x4';
import lazy { image } from '@kit.ImageKit';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { Region } from '../../default/model/common/DataTypes';
import lazy { UserFileManagerAccess } from '../../default/access/UserFileManagerAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { PhotoAccessHelperAccess } from '../../default/access/PhotoAccessHelperAccess';



const TAG = 'EditCoverComponent';
const RENAME_MAX_LENGTH: number = 82;
const ANONYMIZATION_MIN_LENGTH: number = 3;
const ANONYMIZATION_MAX_LENGTH: number = 8;
const ANONYMIZATION_LEFT_LENGTH: number = 2;
const IPHONE_EDIT_COVER_ITEM_HEIGHT: number = 120; // 封面编辑 封面卡片 手机设备固定高度 174
const BLANK_COLUMN_HEIGHT: number = 72;
const HIGH_LIGHT_FLAG: string = 'Highlight';


@Component
export struct EditCoverComponent {
  @State private appBarController: AppBarController = new AppBarController();
  private appBarStyler: CommSheetAppBarStyler | undefined = undefined;
  private readonly menuHelper: MenuHelper = new MenuHelper();
  @State public navPathStack: NavPathStack = new NavPathStack();
  private title: string | Resource = '';
  private scroller: Scroller = new Scroller();
  private fromPage: string = '';
  @Prop @Watch('onCoverItemChanged') newCoverItem: MediaItem = new MediaItem();
  @Link navPathStackBindSheet: NavPathStack;
  private editCoverItemHeight: number = IPHONE_EDIT_COVER_ITEM_HEIGHT;
  private isShowSubTitle: boolean = false;
  private textInputController: TextInputController = new TextInputController();
  @Prop editCoverItemWidth: number = 0;
  @State titleCancelBtnStyle: number = CancelButtonStyle.INVISIBLE;
  @State subTitleCancelBtnStyle: number = CancelButtonStyle.INVISIBLE;
  @Link inputTitleName: string; // 时刻主标题
  @Link inputSubTitleName: string; // 时刻副标题
  @Prop keyboardHeight: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @State @Watch('onIsVerdeFoldableChanged') private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State @Watch('registerActions') private isColdStart: boolean = true;
  @State blanksGridHeight: number = BLANK_COLUMN_HEIGHT;
  @State albumInfo: AlbumInfo = new AlbumInfo();
  @State private albumMatrix: Matrix4x4 | undefined = undefined;
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  private originalName: string | Resource = ''
  cancelFunc: Function = (): void => {
  };
  confirmFunc: Function = (): void => {
  };

  private initPlaceholder(): string | Resource {
    if (this.originalName != '') {
      return this.originalName;
    }
    return $r('app.string.name_input');
  }

  cancelTransitionFunc(): void {
    this.cancelFunc?.();
  }

  confirmTransitionFunc(): void {
    this.confirmFunc?.();
  }

  private registerActions(): void {
    // 清空内容
    this.appBarController.builders = [];
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_MENU_HELPER, this.menuHelper)
      .set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.appBarController)
      .set(MenuConstants.KEY_NAV_PATH_STACK, this.navPathStack)

    new CancelActionRegister(() => this.cancelTransitionFunc()).register(params);

    // 标题
    let titleProp: FirstLevelTitleProp = new FirstLevelTitleProp();
    titleProp.content = this.title;
    titleProp.fontSize = $r('sys.float.Title_S');
    this.appBarController.builders.push({
      builder: firstLevelTitleBuilder,
      builderParams: titleProp,
      key: 'Title_' + this.title,
    });

    new ConfirmActionRegister(() => this.confirmTransitionFunc()).register(params);

    this.appBarController.backgroundBlurStyle = BlurStyle.NONE;
    this.appBarController.transitionEffect = TransitionEffect
      .move(TransitionEdge.TOP)
      .animation({
        duration: this.isVerdeFoldable && !this.isColdStart ? Constants.TABBAR_SEGMENT_BUTTON_ANIMATION_DURATION : 0,
        curve: Curve.Friction,
      });
  }

  private getAnonymizeAlbumName(value: Resource | string): Resource | string {
    return (typeof value === 'string') ? this.getAnonymizeString(value) : value;
  }

  /**
   * 字符串脱敏
   *
   * @param str
   * @returns AnonymizeString
   */
  private getAnonymizeString(str: string): string {
    if (!str) {
      return str;
    }

    let strLength: number = str.length;
    if (strLength <= ANONYMIZATION_MIN_LENGTH) { // 对于长度小于3的字串，保留最后一位
      return '****' + str.substring(strLength - 1) + '****';
    } else if (strLength <= ANONYMIZATION_MAX_LENGTH) { // 对于长度介于4-8之间的字串，保留最后两位
      return '***' + str.substring(strLength - ANONYMIZATION_LEFT_LENGTH) + '***';
    } else { // 对于长度大于8的文件名，从第8位开始保留
      return '**' + str.substring(ANONYMIZATION_MAX_LENGTH) + '**';
    }
  }

  private onIsVerdeFoldableChanged(): void {
    this.registerActions();
  }

  private showSubTitle(): void {
    this.isShowSubTitle = this.fromPage.includes(HIGH_LIGHT_FLAG);
  }

  onCoverItemChanged() {
    this.getCoverFaceRegion(this.newCoverItem.uri).then((region: Region) => {
      Log.info(TAG, `new portrai cover face region: ${JSON.stringify(region)}`);
      this.albumInfo.region = region;
      this.onWidthChanged();
      /* instrument ignore next */
      this.navPathStackBindSheet.clear();
    })
  }

  /* instrument ignore next */
  private async getCoverFaceRegion(imageUri: string): Promise<Region> {
    let region: Region = { x: 0, y: 0, width: 0, height: 0 };
    let coverAsset = await UserFileManagerAccess.getInstance()
      .getPhotoAssetByUri(imageUri, UserFileManagerAccess.getInstance().getAllFetchColumns());
    return region;
  }

  private refreshSize(coverAsset: photoAccessHelper.PhotoAsset) {
    let width: number = Number(coverAsset.get(photoAccessHelper.PhotoKeys.WIDTH) || 0);
    let height: number = Number(coverAsset.get(photoAccessHelper.PhotoKeys.HEIGHT) || 0);
    Log.info(TAG, 'setCoverImgSize' + width + `/${height}`);
    let size: Size = { width, height };
    const orientation = coverAsset?.get(photoAccessHelper.PhotoKeys.ORIENTATION);
    if (orientation === Constants.ANGLE_90 || orientation === Constants.ANGLE_270) {
      // 交换长宽
      size = { width: height, height: width };
    }
    if (width === 0 || height === 0) {
      let lcdSize: Size | undefined = PhotoAccessHelperAccess.getLcdSize(coverAsset);
      let thmSize: Size | undefined = PhotoAccessHelperAccess.getThmSize(coverAsset);
      size = lcdSize || thmSize || size;
    }
    this.albumInfo.coverImgSize = size;
  }

  onWidthChanged() {
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear`);
    this.appBarStyler = new CommSheetAppBarStyler(getContext(), this.appBarController, getScreen());
    this.appBarStyler?.register();
    this.registerActions();
    this.showSubTitle();
    this.onCoverItemChanged();
  }

  aboutToDisappear(): void {
    this.appBarStyler?.unregister();
  }

  build() {
    Column() {
      AppBar({ controller: this.appBarController })
      Column() {
        Column()
          .width('100%')
          .height(this.isVerdeFoldable ? Constants.LIST_HEIGHT : this.blanksGridHeight)
        this.buildCoverEditSheetArea();
      }
      .padding({ left: '16vp', right: '16vp' })
      .height('100%')
      .width('100%')
    }
  }

  @Builder
  buildCoverEditSheetArea() {
    Scroll(this.scroller) {
      Column() {
        Column() {
          Stack({ alignContent: Alignment.TopStart }) {
            Image(ImageUtil.getHighlightCoverLcdUri(this.newCoverItem, { width: -1, height: -1, }))
              .draggable(false)
              .rotate({
                x: 0,
                y: 0,
                z: 1,
                angle: 0,
              })
              .transform(this.albumMatrix)
              .objectFit(this.albumMatrix ? ImageFit.Contain : ImageFit.Cover)
              .width('100%')
              .height('100%')
              .onComplete(() => {
                Log.info(TAG, `edit cover complete`);
              })
              .onError((event: ImageError): void => {
                Log.error(TAG, `coverUri: ${this.albumInfo?.coverUri}  error: ${event.message}`);
              })
          }
          .clip(true)
          .width('100%')
          .height('100%')
          .border({
            radius: Constants.COLUMN_RADIUS,
            width: $r('app.float.album_card_border_width'),
            color: this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
              $r('app.color.portrait_edit_border_dark_color') : $r('app.color.portrait_edit_border_light_color'),
          })
        }
        .width(this.editCoverItemWidth)
        .height(this.editCoverItemHeight)

        Column() {
          Button($r('app.string.replace_cover'), { buttonStyle: ButtonStyleMode.NORMAL })
            .key('select_cover_button')
            .margin({ top: '8vp' })
            .controlSize(ControlSize.SMALL)
            .type(ButtonType.Normal)
            .borderRadius($r('sys.float.corner_radius_level7'))
            .fontSize($r('sys.float.Body_M'))
            .onClick((event: ClickEvent) => {
              Log.info(TAG, 'Cover Edit Area select cover button click');
              this.navPathStackBindSheet.pushPathByName(Constants.COVER_SELECT_SHEET, null);
            })
        }

        Column() {
          TextInput({ placeholder: this.initPlaceholder(),
            controller: this.textInputController, text: this.inputTitleName })
            .draggable(false)
            .key('Rename_Title_TextInput')
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .placeholderColor($r('sys.color.font_secondary'))
            .maxLength(RENAME_MAX_LENGTH)
            .enterKeyType(EnterKeyType.Done)
            .width('100%')
            .defaultFocus(true)
            .margin({ top: '16vp' })
            .cancelButton({
              style: this.inputTitleName.length > 0 ? CancelButtonStyle.CONSTANT : CancelButtonStyle.INVISIBLE,
            })
            .onFocus(() => {
              this.titleCancelBtnStyle = CancelButtonStyle.CONSTANT;
            })
            .onBlur(() => {
              this.titleCancelBtnStyle = CancelButtonStyle.INVISIBLE;
            })
            .onChange((value: string): void => {
              Log.info(TAG, `TextInput  title onChange : ${this.getAnonymizeAlbumName(value)}`);
              this.inputTitleName = value;
              if (value?.length === RENAME_MAX_LENGTH) {
                UiUtil.showToast($r('app.string.Maximum_length_reached'));
              }
            })
        }

        Column() {
          TextInput({ placeholder: '', controller: this.textInputController, text: this.inputSubTitleName })
            .draggable(false)
            .key('Rename_SubTitle_TextInput')
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .maxLength(RENAME_MAX_LENGTH)
            .enterKeyType(EnterKeyType.Done)
            .margin({ top: '12vp' })
            .width('100%')
            .cancelButton({
              style: this.subTitleCancelBtnStyle,
            })
            .onFocus(() => {
              this.subTitleCancelBtnStyle = CancelButtonStyle.CONSTANT;
            })
            .onBlur(() => {
              this.subTitleCancelBtnStyle = CancelButtonStyle.INVISIBLE;
            })
            .onChange((value: string): void => {
              Log.info(TAG, `TextInput subtitle onChange : ${this.getAnonymizeAlbumName(value)}`);
              this.inputSubTitleName = value;
              if (value?.length === RENAME_MAX_LENGTH) {
                UiUtil.showToast($r('app.string.Maximum_length_reached'));
              }
            })
        }
        .visibility(this.isShowSubTitle ? Visibility.Visible : Visibility.None)

        Column() {
        }
        .key('null_Column')
        .width('100%')
        .height(this.keyboardHeight)
      }
    }
    .margin({ bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed') })
    .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
    .scrollBar(BarState.Off) // 滚动条常驻显示
    .align(Alignment.Top)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }
}