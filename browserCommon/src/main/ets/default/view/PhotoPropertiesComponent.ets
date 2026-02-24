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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy {
  Constants as BrowserConstants,
  VideoType,
  DragonFruitTemplateNameType,
  XMageColorModeType
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { UserFileManagerAccess, PhotoAlbum } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  WindowMode
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { MenuOperationFactory } from '@ohos/common/src/main/ets/default/interface/MenuOperationFactory';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy lockedScreenMgr from '@ohos/common/src/main/ets/default/utils/LockedScreen';
import lazy image from '@ohos.multimedia.image';
import lazy { Histogram } from './Histogram';
import lazy {
  OnCompletedResult,
  RenameMenuOperation
} from '@ohos/common/src/main/ets/default/view/browserOperation/RenameMenuOperation';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { MenuContextConstants } from '@ohos/common/src/main/ets/default/model/common/MenuContextConstants';
import lazy taskpool from '@ohos.taskpool';
import lazy { updatePhotoNoteAsync } from './PhotoPropertiesAsync';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { PhotoPropertiesUtil } from '@ohos/common/src/main/ets/default/utils/PhotoPropertiesUtil';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { PhonePropertiesViewModel } from '../viewModel/phone/PhonePropertiesViewModel';
import lazy { PhotoBrowserStateMachine } from '../viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { window } from '@kit.ArkUI';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import { dataSharePredicates } from '@kit.ArkData';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { CameraAlbumInstance } from '@ohos/common/src/main/ets/default/utils/CameraAlbumInstance';
import lazy {
  CameraAuthLocationCardView,
  CameraAuthLocationFromEnum,
  CameraAuthorizeDialog
} from '@ohos/common/src/main/ets/default/view/CameraAuthLocationCardView';
import lazy { CameraAuthLocationManager } from '@ohos/common/src/main/ets/default/viewmodel/CameraAuthLocationManager';
import screenLock from '@ohos.screenLock';
import { JSON } from '@kit.ArkTS';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';

/* instrument ignore file */
const TAG: string = 'PhotoPropertiesComponent';

const OUTLINE_WIDTH: number = 1;

//AI隐式标识的key是首字母大写，因此此处变量命名首字母大写，请勿修改
interface LabelValue {
  Label: string;
  ContentProducer: string;
  ProduceID: string;
  ReservedCode1: string;
  ContentPropagator: string;
  PropagateID: string;
  ReservedCode2: string;
}

interface AiLabel {
  AIGC: LabelValue;
}

/**
 * 图片详情控件
 */
@Component
export struct PhotoPropertiesComponent {
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  private albumInfo?: AlbumInfo;
  @State title: string = '';
  @State model: string | null = '';
  @State isoSpeedRatings: string | null = '';
  @State recommendedExposureIndex: string | null = '';
  @State exposureTime: string | null = '';
  @State @Watch('onFNumberUpdate') fNumber: string | null = '';
  @State exposureBiasValue: string | null = '';
  @State lightSource: string | null = '';
  @State whiteBalance: string | null = '';
  @State flash: string | null = '';
  @State meteringMode: string | null = '';
  @State focalLengthIn35mmFilm: string | null = '';
  @State focusMode: string | null = '';
  private xtStyleTemplateNameArray: string[] =
    [DragonFruitTemplateNameType.N, DragonFruitTemplateNameType.F, DragonFruitTemplateNameType.C,
      DragonFruitTemplateNameType.A, DragonFruitTemplateNameType.V, DragonFruitTemplateNameType.B,
      DragonFruitTemplateNameType.H];
  private xMageColorModeArray: string[] =
    [XMageColorModeType.ORIGINAL, XMageColorModeType.VIVID, XMageColorModeType.BRIGHT,
      XMageColorModeType.MONO];
  private xtStyleTemplateName: string | null = '';
  private xtStyleCustomHue: string | null = '';
  private xtStyleCustomSaturation: string | null = '';
  private xtStyleCustomLightAndShadow: string | null = '';
  @State dragonFruitInfo: string | null = '';
  @State xMageColorMode: string | null = '';
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @State imageProperties: Record<PropertyKey, string | null> = {};
  @State detailAddress: string | undefined = '';
  @StorageLink('isEditEnabled') isEditEnabled: boolean = true;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isFullMode') private isFullMode: boolean = getScreen().isFullMode();
  private broadCast: BroadCast = new BroadCast();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  scroller: Scroller = new Scroller();
  private portraitScroller: Scroller = new Scroller();
  @Link item: MediaItem;
  @State gridWidth: number = 0;
  private albumUri: string = '';
  @State private photoDateTime: string = '';
  @State private videoDuration: string = '';
  @State private isNoteTextAreaFocused: boolean = false;
  private isNameInputFocused: boolean = false;
  @State private isTitleFocused: boolean = false;
  private controllerTextArea: TextAreaController | undefined = undefined;
  private controllerTextInput: TextInputController | undefined = undefined;
  private controllerPortraitInput: TextInputController | undefined = undefined;
  private menuOperation: RenameMenuOperation | undefined = undefined;
  private onScrollChange: (OffsetResult: OffsetResult) => void = () => {
  };
  @State photoNote: string = '';
  @State shootingMode: Resource | string = '';
  @State filePosition: photoAccessHelper.PositionType | undefined = undefined;
  @Consume mPosition: number;
  @Prop @Watch('onMIsCurrentChanged') mIsCurrent: boolean = false;
  foldedScreenDetailsWidthLeft: number = 12;
  foldedScreenDetailsWidthRight: number = 24;
  foldedScreenDetailsHeight: number = 44;
  foldedScreenDetailsPaddingBottom: number = 12;
  @State photoDetailsPaddingBottom: number = 44;
  private setTitleFunc: Function = (title: string): void => this.setTitle(title);
  private onPageChangedFunc: Function = (): void => this.onPageChanged();
  private onWinModeChangedFunc: Function = (winMode: WindowMode): void => this.updateShowProperties(winMode);
  @State isShowPhotoProperties: boolean = false;
  @Consume @Watch('onChangeItem') histogramNextItem: MediaItem;
  @State scrollDirection: ScrollDirection = ScrollDirection.Vertical;
  // 禁止swipe滑动
  @Consume disableSwipe: boolean;
  // image组件完成渲染后的宽高
  private imageCompleteWidth: number | undefined = 0;
  private imageCompleteHeight: number | undefined = 0;
  private dataSource: PhotoDataSource | undefined = undefined;
  @Link imageTargetPullHeight: number;
  @State private imageFaceData: AlbumInfo[] = [];
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  @State private focalLengthIn35mmFilmFormat: string = '';
  @State private equivalentLensFocalLengthFormat: string = '';
  @StorageLink('currentLanguage') @Watch('updateCurrentLanguage') currentLanguage: string | undefined = undefined;
  @StorageProp('fontSizeScale') @Watch('fontSizeScaleChange') private fontSizeScale: number = 1;
  @State private textInputFontSize: string | Resource = $r('sys.float.Body_L');
  @State private isScreenLockProtected: boolean = false;
  @StorageLink('windowStatus') @Watch('onWindowStatusChange') windowStatus: number | undefined = undefined;
  private viewModel = new PhonePropertiesViewModel();
  @Prop @Watch('onIsDoingImageSlideAnimation') isDoingImageSlideAnimation: boolean = true;
  @State cameraAuthCardShow: boolean = false;
  @State cameraAuthorizeDialogShow: boolean = false;

  private fontSizeScaleChange(): void {
    this.textInputFontSize = $r('sys.float.Body_L');
    if (this.fontSizeScale >= Constants.FONT_SCALE_LEVEL3_SIZE) {
      this.textInputFontSize = `${Constants.FONT_SCALE_LEVEL3_SIZE * Constants.TEXT_SIZE_SUB_TITLE2}vp`;
    }
    Log.info(TAG,
      `fontSizeScaleChange textInputFontSize: ${this.textInputFontSize}, fontSizeScale:${this.fontSizeScale}`);
  }

  private onIsDoingImageSlideAnimation(): void {
  }

  private updateCurrentLanguage(): void {
    Log.info(TAG, `updateCurrentLanguage:${this.currentLanguage}`);
    this.onPageChanged();
    this.getFocalLengthIn35mmFile();
    this.getEquivalentLensFocalLength();
  }

  private setTitle(title: string): void {
    Log.info(TAG, `isTitleFocused status: ${this.isTitleFocused}`);
    if (!this.isTitleFocused && this.item.uri) {
      this.title = `${title}`;
    } else {
      this.title = title;
    }
  }

  private onChangeItem() {
    if (this.histogramNextItem.uri === this.item.uri) {
      this.viewModel.getPhotoDateTime(this.getDetailTime());
      this.photoDateTime = `${this.viewModel.photoDate} ${this.viewModel.photoTime}`;
      if (this.canShowCameraAuthCard()) {
        this.getCameraAuthStatus();
      }
    }
  }

  private getDetailTime(): number {
    let detailTime = DateUtil.convertDateToTimestamp(this.item?.getDetailTimeString?.());
    if (!detailTime) {
      return this.item.getDetailTime();
    }
    return detailTime;
  }

  private onWindowStatusChange(): void {
    Log.info(TAG, ` onWindowStatusChange:${this.windowStatus}  getWindowMode: ${getScreen().getWinMode()}` );
  }

  private async UpdatePhotoNote(): Promise<void> {
    this.photoNote = await taskpool.execute(updatePhotoNoteAsync, getContext(this), this.item.uri,
      false) as string;
    if (this.checkAiLabelValid(this.photoNote)) {
      this.photoNote = '';
    }
  }

  private checkAiLabelValid(str: string): boolean {
    if (!str || str === '') {
      return false;
    }
    try {
      let aiLabel = JSON.parse(this.photoNote) as AiLabel;
      if (aiLabel?.AIGC?.Label && aiLabel.AIGC.ContentProducer && aiLabel.AIGC.ProduceID &&
      aiLabel.AIGC.ContentPropagator && aiLabel.AIGC.PropagateID) {
        return true;
      }
    } catch (error) {
      Log.error(TAG, `parse aiLabel error: ${JSON.stringify(error)}`);
    }
    return false;
  }

  async updateFilePosition(): Promise<void> {
    this.filePosition = this.item.getPosition();
    let photoProperties = await this.viewModel.updateFilePosition(this.item, this.dataSource);
    if (!photoProperties) {
      return;
    }
    this.filePosition = photoProperties.filePosition;
    if (photoProperties.imageProperties) {
      this.model = photoProperties.imageProperties[image.PropertyKey.MODEL];
      this.isoSpeedRatings = photoProperties.imageProperties[image.PropertyKey.ISO_SPEED_RATINGS];
      this.recommendedExposureIndex = photoProperties.imageProperties[image.PropertyKey.RECOMMENDED_EXPOSURE_INDEX];
      this.exposureTime = photoProperties.imageProperties[image.PropertyKey.EXPOSURE_TIME];
      this.exposureBiasValue = photoProperties.imageProperties[image.PropertyKey.EXPOSURE_BIAS_VALUE];
      this.lightSource = photoProperties.imageProperties[image.PropertyKey.LIGHT_SOURCE];
      this.whiteBalance = photoProperties.imageProperties[image.PropertyKey.WHITE_BALANCE];
      this.flash = photoProperties.imageProperties[image.PropertyKey.FLASH];
      this.meteringMode = photoProperties.imageProperties[image.PropertyKey.METERING_MODE];
      this.fNumber = photoProperties.imageProperties[image.PropertyKey.F_NUMBER];
      this.focalLengthIn35mmFilm = photoProperties.imageProperties[image.PropertyKey.FOCAL_LENGTH_IN_35_MM_FILM];
      this.focusMode = photoProperties.imageProperties[image.PropertyKey.FOCUS_MODE];
      try {
        this.xtStyleTemplateName = photoProperties.imageProperties[BrowserConstants.XT_STYLE_TEMPLATE_NAME];
        this.xtStyleCustomHue = photoProperties.imageProperties[BrowserConstants.XT_STYLE_CUSTOM_HUE];
        this.xtStyleCustomSaturation = photoProperties.imageProperties[BrowserConstants.XT_STYLE_CUSTOM_SATURATION];
        this.xtStyleCustomLightAndShadow =
          photoProperties.imageProperties[BrowserConstants.XT_STYLE_CUSTOM_LIGHT_AND_SHADOW];
        this.xMageColorMode = photoProperties.imageProperties[BrowserConstants.X_MAGE_COLOR_MODE];
      } catch (error) {
        Log.error(TAG,
          `getImageProperties dragon Fruit or XMAGE error, error msg: ${error?.msg}, code: ${error?.code}`);
      }
    }
    if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.videoDuration = DateUtil.getFormattedDuration(this.item?.duration);
      Log.info(TAG, `videoDuration: ${this.videoDuration}`);
    }
  }

  onFNumberUpdate(): void {
    Log.info(TAG, `fNumber changed: ${this.fNumber}`);
  }

  getMenuOperation(): void {
    let menuContext: MenuContext = new MenuContext();
    menuContext.withMediaItem(this.item).withBroadCast(this.broadCast).withAlbumUri(this.albumUri);
    menuContext.set(MenuContextConstants.PHOTO_DATA_IMPL, this.dataSource?.getAlbumDataSource()?.photoDataImpl);
    this.menuOperation = MenuOperationFactory.getInstance().createMenuOperation(RenameMenuOperation, menuContext);
    this.menuOperation.onCompleted = (result: OnCompletedResult): void => {
      this.item.setTitle(result.title);
      this.item.displayName = result.displayName;
      AppStorage.setOrCreate<OnCompletedResult>(`renameResult${this.item.uri}`, result);
    }
  }

  private onMIsCurrentChanged():void {
    if (this.mIsCurrent) {
      this.reportPropertiesBigDataFunc();
    }
  }

  private reportPropertiesBigDataFunc(): void {
    if (!(this.isDragonFruitType() || this.isXMageColorModeType())) {
      Log.info(TAG, 'The image type is neither dragon fruit nor XMAGE');
      return;
    }
    let type: string = '';
    let value: string = '';
    if (this.isDragonFruitType()) {
      type = BrowserConstants.X_MAGE_DRAGON_FRUIT;
      value = this.dragonFruitInfo ?? '';
    } else if (this.isXMageColorModeType()) {
      type = BrowserConstants.X_MAGE_STYLE;
      value = this.xMageColorMode ?? '';
    }
    const msg: Record<string, string> = {
      'type': type,
      'value': value
    };
    Log.info(TAG, `reportPropertiesBigData type:${type}, value:${value}`);
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_X_MAGE_STYLE, msg);
  };

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.fontSizeScaleChange();
    this.isShowPhotoProperties = getScreen().getDetailShow();
    WindowUtil.prepareWinRouter();
    if (this.item.uri) {
      this.title = `${this.viewModel.getTitle(this.item)}`;
    }
    // 详情中显示dateTaken
    this.viewModel.getPhotoDateTime(this.getDetailTime());
    this.UpdatePhotoNote();
    this.photoDateTime = `${this.viewModel.photoDate} ${this.viewModel.photoTime}`;
    this.broadCast.on(BrowserConstants.UPDATE_PHOTO_NAME + this.item.path, this.setTitleFunc);
    this.broadCast.on(Constants.ON_PAGE_SHOW, this.onPageChangedFunc);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinModeChangedFunc);
    this.updateFilePosition().then((): void => {
      this.getFocalLengthIn35mmFile();
      this.getDragonFruitInfo();
      if (this.mIsCurrent) {
        this.reportPropertiesBigDataFunc();
      }
    });
    this.getEquivalentLensFocalLength();
    this.getMenuOperation();
    if (this.canShowCameraAuthCard()) {
      this.getCameraAuthStatus();
    }
    this.isScreenLockProtected = getScreen().screenIsLock();
  }

  aboutToDisappear(): void {
    Log.debug(TAG, `aboutToDisappear isCommentChanged: ${this.viewModel.isCommentChanged}`);
    this.broadCast.off(BrowserConstants.UPDATE_PHOTO_NAME + this.item.path, this.setTitleFunc);
    this.broadCast.off(Constants.ON_PAGE_SHOW);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinModeChangedFunc);
    if (this.viewModel.isCommentChanged) {
      UserFileManagerAccess.getInstance()
        .getUserComment(this.item.uri, false)
        .then((result: string) => {
          Log.info(TAG, 'getUserComment');
          this.photoNote = this.photoNote?.trim();
          if (result !== this.photoNote) {
            this.viewModel.updateCommit(this.item.uri, this.photoNote, false);
          }
        });
    }
  }

  private canShowCameraAuthCard(): boolean {
    if (this.albumInfo?.isTrashAlbum) {
      return false;
    }
    if (screenLock.isLocked()) {
      return false;
    }
    return true;
  }

  private async getCameraAuthStatus(): Promise<void> {
    // 相机场景只需判断权限
    if (PhotoConfig.isLibrary()) {
      this.cameraAuthCardShow = await CameraAuthLocationManager.getIsShowCameraAuthLocationCard(getContext(this),
        CameraAuthLocationFromEnum.Browser);
      return;
    }

    let cameraAlbum: PhotoAlbum | undefined = await CameraAlbumInstance.getInstance();
    if (!cameraAlbum) {
      return;
    }

    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('uri', this.item.uri);
    let systemFetchOption: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [],
    };
    let result = cameraAlbum.getAssets(systemFetchOption);
    if (!result) {
      Log.warn(TAG, 'asset not from camera');
      return;
    }
    this.cameraAuthCardShow = await CameraAuthLocationManager.getIsShowCameraAuthLocationCard(getContext(this),
      CameraAuthLocationFromEnum.Browser);
  }

  private isDragonFruitType(): boolean {
    return this.xtStyleTemplateNameArray.includes(this.xtStyleTemplateName ?? '');
  }

  /* instrument ignore next */
  private isDragonFruitTypeV1() {
    const dragonFruitTypeV1Array: string[] = [DragonFruitTemplateNameType.N, DragonFruitTemplateNameType.F,
      DragonFruitTemplateNameType.C, DragonFruitTemplateNameType.A];
    return dragonFruitTypeV1Array.includes(this.xtStyleTemplateName ?? '')
  }

  private isXMageColorModeType(): boolean {
    return this.xMageColorModeArray.includes(this.xMageColorMode ?? '');
  }

  private calcDragonFruitParam(normalizedValue: number, minValue: number, maxValue: number): number {
    return normalizedValue * (maxValue - minValue) + minValue;
  }

  private getDragonFruitInfo(): void {
    Log.info(TAG,
      `properties dragon fruit info, displayName:${this.title}, xtStyleTemplateName:${this.xtStyleTemplateName}, xtStyleCustomHue:${this.xtStyleCustomHue}, xtStyleCustomSaturation:${this.xtStyleCustomSaturation}, xtStyleCustomLightAndShadow:${this.xtStyleCustomLightAndShadow}, xMageColorMode:${this.xMageColorMode}`);
    if (this.isDragonFruitType()) {
      let templateName = this.viewModel.getTemplateName(this.xtStyleTemplateName);
      let customHue = this.calcDragonFruitParam(Number(this.xtStyleCustomHue), BrowserConstants.XT_STYLE_MIN_HUE_VALUE,
        BrowserConstants.XT_STYLE_MAX_HUE_VALUE).toString().padStart(2, `0`);
      let customSaturation =
        this.calcDragonFruitParam(Number(this.xtStyleCustomSaturation), BrowserConstants.XT_STYLE_MIN_SATURATION,
          BrowserConstants.XT_STYLE_MAX_SATURATION).toString().padStart(2, `0`);
      let customLightAndShadow =
        this.calcDragonFruitParam(Number(this.xtStyleCustomLightAndShadow),
          BrowserConstants.XT_STYLE_MIN_LIGHT_AND_SHADOW,
          BrowserConstants.XT_STYLE_MAX_LIGHT_AND_SHADOW).toString().padStart(2, `0`);
      this.dragonFruitInfo = templateName + customHue + customSaturation + customLightAndShadow;
      Log.info(TAG, `properties displayName:${this.title}, dragonFruitInfo: ${this.dragonFruitInfo}`);
    }
  }

  private getFocalLengthIn35mmFile(): void {
    if (Number.isFinite(Number(this.focalLengthIn35mmFilm))) {
      this.focalLengthIn35mmFilmFormat = ImageUtil.getFormatMMStr(Number(this.focalLengthIn35mmFilm));
    } else {
      Log.info(TAG, `focalLengthIn35mmFilmFormat:${this.focalLengthIn35mmFilm}`);
      this.focalLengthIn35mmFilmFormat = `${this.focalLengthIn35mmFilm} mm`;
    }
  }

  private getEquivalentLensFocalLength(): void {
    this.equivalentLensFocalLengthFormat = ImageUtil.getFormatMMStr(Constants.EQUIVALENT_LENS_FOCAL_LENGTH);
  }

  updateShowProperties(winMode: WindowMode): void {
    Log.info(TAG, `window change mode: ${winMode}`)
    this.isShowPhotoProperties = getScreen().getDetailShow();
  }

  private onPageChanged(): void {
    this.viewModel.getPhotoDateTime(this.getDetailTime());
    this.photoDateTime = `${this.viewModel.photoDate} ${this.viewModel.photoTime}`;
  }

  /* instrument ignore next */
  private convertDragonFruit2XMageMode(xtStyleTemplateName: string | null): string {
    if (!xtStyleTemplateName) {
      return XMageColorModeType.ORIGINAL;
    }
    let map: Map<string, string> = new Map([
      [DragonFruitTemplateNameType.V, XMageColorModeType.VIVID],
      [DragonFruitTemplateNameType.B, XMageColorModeType.BRIGHT],
      [DragonFruitTemplateNameType.H, XMageColorModeType.MONO]
    ]);
    if (!map.has(xtStyleTemplateName)) {
      return XMageColorModeType.ORIGINAL;
    }
    return map.get(xtStyleTemplateName) ?? XMageColorModeType.ORIGINAL;
  }

  @Styles
  detailImage() {
    .draggable(false)
    .width(Constants.PHOTO_DETAIL_IMAGE_SVG_WIDTH)
  }

  @Styles
  detailImageColumn() {
    .width(Constants.PHOTO_DETAIL_IMAGE_INFO_WIDTH)
    .height(Constants.PHOTO_DETAIL_IMAGE_INFO_HEIGHT)
    .borderRadius($r('sys.float.corner_radius_level2'))
    .backgroundColor($r('sys.color.ohos_id_color_hover'))
  }

  @Styles
  bindremarkstextInputStyles() {
    .onTouch((event: TouchEvent): void => {
      if (event.type === TouchType.Up && getScreen().screenIsLock()) {
        getScreen().screenUnlock((unlockResult: boolean) => {
          this.isScreenLockProtected = !unlockResult;
        });
      }
    })
    .onFocus((): void => {
      this.scrollDirection = ScrollDirection.None;
      this.isNoteTextAreaFocused = true;
    })
    .onBlur((): void => {
      this.isNoteTextAreaFocused = false;
      this.scrollDirection = ScrollDirection.Vertical;
      if (this.viewModel.checkPhotoNoteInvalid(this.photoNote)) {
        this.UpdatePhotoNote();
        return;
      }
      Log.info(TAG, `onBlur isCommentChanged: ${this.viewModel.isCommentChanged}`);
      if (this.viewModel.isCommentChanged) {
        this.photoNote = this.photoNote?.trim();
        setTimeout((): void => {
          this.viewModel.updateCommit(this.item.uri, this.photoNote, false);
        }, 500)
      }
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll(this.scroller) {
        Column() {
          Column() {
            // title + 直方图 + detail
            Column() {
              Row() {
                Column() {
                  if ((UserFileManagerAccess?.isRecycleBin(this.albumUri) ||
                  lockedScreenMgr().isFromLockedScreen) && !PhotoConfig.isLibrary()) {
                    Text(this.title)
                      .copyOption(CopyOptions.LocalDevice)
                      .draggable(false)
                      .key('PhotoDetailTitle')
                      .fontSize($r('sys.float.Body_L'))
                      .fontColor($r('sys.color.font_primary'))
                      .textAlign(TextAlign.Start)
                      .fontWeight(FontWeight.Medium)
                      .backgroundColor($r('app.color.transparent'))
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(1)
                      .maxFontScale(1.45)
                      .padding({
                        left: Constants.PHOTO_EDIT_PAGE_TEXT_INPUT_PADDING,
                        right: Constants.PHOTO_EDIT_PAGE_TEXT_INPUT_PADDING,
                        bottom: Constants.PHOTO_EDIT_PAGE_TEXT_INPUT_PADDING,
                      })
                      .accessibilityLevel('yes')
                  } else {
                    TextInput({ text: this.title, controller: this.controllerTextInput })
                      .draggable(false)
                      .key('PhotoDetailTitle')
                      .attributeModifier(this.viewModel.config.titleTextInputAttr)
                      .fontWeight(FontWeight.Medium)
                      .focusable(this.isScreenLockProtected ? false : true)
                      .onChange((value: string) => {
                        if (value.length >= Constants.RENAME_MAX_LENGTH && this.isNameInputFocused) {
                          UiUtil.showToast($r('app.string.Maximum_length_reached'));
                        }
                        Log.info(TAG, `TextInputUri:${this.item.uri},value:${StringUtil.garbleFileName(value)}`);
                        this.title = value;
                      })
                      .onTouch((event) => {
                        if (event.type === TouchType.Up && getScreen().screenIsLock()) {
                          getScreen().screenUnlock((unlockResult: boolean) => {
                            this.isScreenLockProtected = !unlockResult;
                          });
                        }
                        this.isTitleFocused = true;
                        if (event.type === TouchType.Down) {
                          Log.info(TAG, 'title textinput onTouch down');
                          this.disableSwipe = true;
                        }

                        if (event.type === TouchType.Up) {
                          Log.info(TAG, 'title textinput onTouch up');
                          this.disableSwipe = false;
                        }
                      })
                      .onKeyEvent((event: KeyEvent): void => {
                        if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER) {
                          event.stopPropagation();
                        }
                      })
                      .onFocus((): void => {
                        this.scrollDirection = ScrollDirection.None;
                        this.isNameInputFocused = true;
                        this.isTitleFocused = true;
                        Log.debug(TAG, `aboutToAppear onFocus: ${this.title}`);
                        this.title = this.viewModel.getTitle(this.item);
                      })
                      .onBlur(async () => {
                        this.scrollDirection = ScrollDirection.Vertical;
                        this.isNameInputFocused = false;
                        this.isTitleFocused = false;
                        Log.debug(TAG, `aboutToAppear onBlur: ${this.title}`);
                        if (this.viewModel.checkTitleInvalid(this.title)) {
                          this.title = `${this.item.getTitle()}`;
                        } else {
                          this.menuOperation?.confirmCallback?.(this.title.trim());
                          this.title = `${this.title}`;
                        }
                      })
                      .borderRadius(Constants.PHOTO_DETAIL_INPUT_RADIUS)
                      .backgroundColor($r('app.color.transparent'))
                      .padding(Constants.PHOTO_DETAIL_INPUT_RADIUS)
                      .maxLength(Constants.RENAME_MAX_LENGTH)
                      .style(this.isTitleFocused ? TextInputStyle.Default : TextContentStyle.INLINE)
                      .maxLines(Constants.ADD_NOTES_MAX_LINE)
                      .enterKeyType(EnterKeyType.Done)
                      .enableKeyboardOnFocus(false)
                      .defaultFocus(false)
                      .accessibilityLevel('yes')
                  }
                }
                .accessibilityLevel('yes')
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
              }
              .accessibilityLevel('yes')
              .justifyContent(FlexAlign.SpaceBetween)
              .width(Constants.PERCENT_100)
              .height(Constants.PHOTO_TITLE_EDIT_HEIGHT)
              .margin(this.viewModel.config.titleMargin)

              // 日期时间
              Column() {
                Text(this.photoDateTime)
                  .draggable(false)
                  .attributeModifier(this.viewModel.config.dateTimeAttr)
                  .maxFontScale(1.45)
                  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                  .textAlign(TextAlign.Start)
                  .fontWeight(FontWeight.Medium)
                  .key('PhotoDetailDateTime')
                  .accessibilityLevel('yes')
              }
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .margin({ top: Constants.PHOTO_DATE_TOP_MARGIN })
              .constraintSize({
                minHeight: Constants.PHOTO_DATE_FONT_HEIGHT,
              })
              .width(Constants.PERCENT_100)

              Divider()
                .vertical(false)
                .color($r('sys.color.comp_divider'))
                .width(Constants.PERCENT_100)
                .margin(this.viewModel.config.dividerMargin)

              Row() {
                // 文件大小
                Text() {
                  Span(`\u202A${this.item.width}\u202C x ${this.item.height}  ${ImageUtil.getDisplaySize(this.item.size)} `)
                }
                .accessibilityText(`${this.item.width}*${this.item.height} ${ImageUtil.getDisplaySize(this.item.size)}`)
                .draggable(false)
                .maxFontScale(1.0)
                .minFontScale(1.0)
                .attributeModifier(this.viewModel.config.photoSizeAttr)
                .textAlign(TextAlign.Start)
                .direction(i18n.isRTL(i18n.System.getSystemLanguage()) ? Direction.Rtl : Direction.Ltr)
                .fontWeight(FontWeight.Regular)
                .key('PhotoDetailResolutionAndSize')
                .maxLines(Constants.FILE_SIZE_MAX_LINE)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .layoutWeight(1)
                .accessibilityLevel('yes')
                .lineHeight(Constants.PHOTO_DETAIL_IMAGE_INFO_HEIGHT)

                Row() {
                  //   设备、型号
                  if (this.model) {
                    Row() {
                      Text(this.model)
                        .draggable(false)
                        .fontSize(Constants.PHOTO_DETAIL_TEXT_INFO_SIZE)
                        .maxFontScale(1.0)
                        .minFontScale(1.0)
                        .fontWeight(FontWeight.Medium)
                        .fontColor($r('sys.color.ohos_id_color_text_hint'))
                        .textAlign(TextAlign.Center)
                        .accessibilityLevel('yes')
                        .key('photoPropertiesComponent_model')
                    }
                    .height(Constants.PHOTO_DETAIL_IMAGE_INFO_HEIGHT)
                    .padding(Constants.PHOTO_DETAIL_IMAGE_INFO_PADDING)
                    .borderRadius($r('sys.float.corner_radius_level2'))
                    .backgroundColor($r('sys.color.ohos_id_color_hover'))
                    .alignItems(VerticalAlign.Center)
                    .justifyContent(FlexAlign.Center)
                  }

                  // 文件后缀
                  Column() {
                    Text(this.viewModel.getUriSuffixByMimeType(this.item))
                      .fontSize(this.viewModel.config.photoSuffixFontSize)
                      .maxFontScale(1.0)
                      .minFontScale(1.0)
                      .fontWeight(FontWeight.Medium)
                      .fontFamily('HarmonyHeiTi')
                      .textAlign(TextAlign.Center)
                      .align(Alignment.Center)
                      .fontColor($r('sys.color.ohos_id_color_text_hint'))
                      .accessibilityLevel('yes')
                      .key('photoPropertiesComponent_suffix')
                  }
                  .height(Constants.PHOTO_DETAIL_IMAGE_INFO_HEIGHT)
                  .padding(this.viewModel.config.photoSuffixPadding)
                  .margin(i18n.isRTL(i18n.System.getSystemLanguage()) ?
                    { right: Constants.PHOTO_DETAIL_SUFFIX_LEFT_MARGIN } :
                    { left: Constants.PHOTO_DETAIL_SUFFIX_LEFT_MARGIN })
                  .borderRadius($r('sys.float.corner_radius_level2'))
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor($r('sys.color.ohos_id_color_hover'))
                }
                .margin(i18n.isRTL(i18n.System.getSystemLanguage()) ?
                  { right: Constants.PHOTO_DETAIL_MODEL_AND_SUFFIX_MARGIN } :
                  { left: Constants.PHOTO_DETAIL_MODEL_AND_SUFFIX_MARGIN })
              }
              .alignItems(VerticalAlign.Top)
              .justifyContent(FlexAlign.SpaceBetween)
              .margin(this.viewModel.config.photoInfoMargin)
              .width(Constants.PERCENT_100)

              Histogram({
                stateMachine: this.stateMachine,
                item: $item,
                imageCompleteWidth: this.imageCompleteWidth,
                imageCompleteHeight: this.imageCompleteHeight
              })
                .margin(this.viewModel.config.histogramMargin)
                .height(this.viewModel.config.histogramHeight)
                .width(this.viewModel.config.histogramWidth)

              if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
                Column() {
                  Row() {
                    //  视频时长
                    Text($r('app.string.video_duration', `${this.videoDuration}`))
                      .accessibilityLevel('yes')
                      .draggable(false)
                      .fontSize($r('sys.float.ohos_id_text_size_caption'))
                      .maxFontScale(1.0)
                      .minFontScale(1.0)
                      .fontColor($r('sys.color.ohos_id_color_text_hint'))
                      .textAlign(TextAlign.Start)
                      .fontWeight(FontWeight.Regular)
                      .fontFamily('HarmonyHeiTi')
                      .key('PhotoDetailVideoDuration')
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width(Constants.PERCENT_100)
                }
                .margin({ top: Constants.PHOTO_DETAIL_IMAGE_INFO_MARGIN_TOP })
              }
            }
            .accessibilityLevel('yes')
            .alignItems(HorizontalAlign.Center)
            .borderRadius(Constants.COLUMN_RADIUS)
            .attributeModifier(this.viewModel.config.photoInfoAttr)
            .margin({
              top: UserFileManagerAccess?.isRecycleBin(this.albumUri)
                ? Constants.COLUMN_MARGIN_BOTTOM : 0
            })
          }
          .accessibilityLevel('no')
          .alignItems(HorizontalAlign.Start)
          .margin(this.viewModel.config.propertiesMargin)

          if (this.cameraAuthCardShow) {
            CameraAuthLocationCardView({
              from: CameraAuthLocationFromEnum.Browser,
              cameraAuthCardShow: $cameraAuthCardShow,
              cameraAuthorizeDialogShow: $cameraAuthorizeDialogShow
            })
          }

          if (this.cameraAuthorizeDialogShow) {
            CameraAuthorizeDialog({
              cameraAuthCardShow: $cameraAuthCardShow,
              cameraAuthorizeDialogShow: $cameraAuthorizeDialogShow,
              from: CameraAuthLocationFromEnum.Browser
            })
          }
        }
      }
      .accessibilityLevel('no')
      .scrollBar(BarState.Auto)
      .scrollable(this.scrollDirection)
      .padding({
        top: this.isFullMode ? 0 : Constants.WINDOW_HEIGHT,
        bottom: this.photoDetailsPaddingBottom,
      })
      .scrollBarWidth(0)
      .onDidScroll((xOffset: number, yOffset: number) => {
        this.onScrollChange(this.scroller.currentOffset())
      })
    }
    .accessibilityLevel('no')
    .height(this.isFullMode ? this.imageTargetPullHeight : Constants.PERCENT_100)
  }
}