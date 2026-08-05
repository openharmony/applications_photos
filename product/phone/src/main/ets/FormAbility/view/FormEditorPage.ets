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

import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy {
  BigDataConstants,
  IFACardBigDataParams,
  IFACardEditorAction,
  ReportToBigDataUtil
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { getScreen, ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { DisplayName } from '@ohos/common/src/main/ets/default/model/common/DataTypes';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { Constants } from '@ohos/formability/src/main/ets/default/common/Constants';
import lazy { Constants as GalleryConstants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy {
  NavigationBroadCastManager
} from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { PickerBasePageParams } from '../../pickerability/view/PickerBasePage';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy common from '@ohos.app.ability.common';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { FormEditorSelectAlbumPage } from './FormEditorSelectAlbumPage';
import lazy { DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy FaCardService from '@ohos/dataprovider/src/main/ets/database/service/FaCardService';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { display, LengthMetrics, LengthUnit, Router, SubHeader, TextModifier, window } from '@kit.ArkUI';
import lazy { JSON, process } from '@kit.ArkTS';
import lazy { FaCardAlbumUtils } from '@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService';
import lazy {
  AlbumType,
  AlbumType as FATableAlbumType,
  FaCardTable,
  IsShowAlbumName
} from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable';
import lazy { Task, TaskUri } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo';
import lazy { FormControllerManager } from '@ohos/dataprovider/src/main/ets/controller/FormControllerManager';
import lazy { FontUtil } from '@ohos/common/src/main/ets/default/utils/FontUtil';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy deviceInfo from '@ohos.deviceInfo';
import lazy { FaCardAlbumDataViewModel } from '../view/FaCardAlbumDataViewModel';
import lazy { formInfo, formProvider } from '@kit.FormKit';
import lazy { appManager } from '@kit.AbilityKit';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'FormEditorPage';

const DELAY_REFRESH = 1000;
const DELAY_REFRESH_PORTRAIT_SHOW = 100;

export interface FormEditorParams {
  interval?: number,
  isShowAlbumName?: number,
  isNormalPortraitCard?: boolean,
}

@Entry(LocalStorage.getShared())
@Component
struct FormEditorPage {
  @StorageLink('FASetting_FormId') formId: string = '0';
  @StorageLink('isSidebar') isSidebar: boolean = getScreen().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  currentIndex: number = 0;
  @State isShowName: boolean = true;
  isShowAlbums: boolean = true;
  fd: number = Constants.FA_FD_NULL;
  fileAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
  displayName: string = '';
  albumUri: string = '';
  albumName: string = '';
  uri: string = '';
  @State private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Provide private isShow: boolean = true;
  @Provide displaySearchWords: string = '';
  private saveDataFunc = async (
    albumName: string, albumUri: string, displayName: DisplayName, uri: string, isShowAlbums: boolean, uriArray?: string[]
  ): Promise<void> => this.saveData(albumName, albumUri, displayName, uri, isShowAlbums, uriArray);
  private isSaving: boolean = false;
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  // 图片播放间隔
  @State playbackInterval: PlaybackInterval = PlaybackInterval.FIFTEEN_SECONDS;
  playbackIntervalOptions: PlaybackInterval[] = [PlaybackInterval.FIFTEEN_SECONDS, PlaybackInterval.THIRTY_SECONDS];
  @State private isHighlight: boolean = false;
  @State private isNone: boolean = true;
  private cardFormat: number = 0;
  private isNeedTerminate: boolean = true;
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') private currentFontSizeScale: number = 1;
  @State private listPaddingTopAndBottom: Resource = $r('sys.float.padding_level6');
  @StorageLink('navigationBarHeight') @Watch('navigationBarHeightChange') private navigationBarHeight: number = 0;
  @StorageLink('navigationBarBottomHeight') @Watch('navigationBarHeightChange')
  private navigationBarBottomHeight: number = 0;
  @StorageLink('isFullMode') @Watch('updateFullMode') private isFullMode: boolean = getScreen().isFullMode();
  @State columnBottomPadding: number = 0;
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  @Provide('navigationPageInfos') navigationPageInfos: NavPathStack = new NavPathStack();
  private onPickerOperationBackFunc: Function = (): void => this.onPickerOperationBack();
  private loadNavigationPageFun: Function = (name: string): Promise<void> => this.loadNavigationPage(name);
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @StorageLink('currentBreakpoint') @Watch('onUpdateBreakpoint') currentBreakpoint: string =
    GalleryConstants.BREAKPOINT_LG;
  @State editorPageMargin: number = GalleryConstants.COLUMN_MARGIN_FOUR;
  private onWinResizeFunc = () => this.setUpWinOrientation();
  resourceManager = getContext().resourceManager
  private faCardAlbumData: FaCardAlbumDataViewModel = FaCardAlbumDataViewModel.getInstance();
  @State isShowAlbumName: number = 0;
  private userFileManagerAccess: UserFileManagerAccess = new UserFileManagerAccess();

  /**
   * 媒体查询，当breakpoint发生变化时触发
   * 1. XS,SM 时 边距为16vp
   * 2. MD 时 边距为24vp
   * 2. LG 时 边距为32vp
   * */
  private onUpdateBreakpoint(): void {
    Log.info(TAG, 'onUpdateBreakpoint : ' + this.currentBreakpoint );
    switch (this.currentBreakpoint) {
      case GalleryConstants.BREAKPOINT_MD:
        this.editorPageMargin = GalleryConstants.COLUMN_MARGIN_SIX;
        break;
      case GalleryConstants.BREAKPOINT_LG:
        this.editorPageMargin = GalleryConstants.COLUMN_MARGIN_EIGHT;
        break;
      default:
        this.editorPageMargin = GalleryConstants.COLUMN_MARGIN_FOUR;
        break;
    }
  }

  private setUpWinOrientation(): void {
    Log.info(TAG,
      `setUpWinOrientation : ${JSON.stringify(deviceInfo.deviceType)}`);
    let winOrientation = window.Orientation.PORTRAIT;
    if (!DeviceInfo.isPhoneUx()) {
      winOrientation = window.Orientation.AUTO_ROTATION_UNSPECIFIED;
    }
    const context: common.UIAbilityContext =
      AppStorage.get<common.UIAbilityContext>('formContext') as common.UIAbilityContext;
    WindowUtil.setPreferredOrientation(context, winOrientation);
    Log.info(TAG, `setUpWinOrientation : ${JSON.stringify(deviceInfo.deviceType)} winOrientation ${winOrientation}`);
  }

  onPickerOperationBack(): void {
    Log.info(TAG, 'onPickerOperationBack');
    this.isNeedTerminate = true;
  }

  async saveData(
    albumName: string,
    albumUri: string,
    displayName: DisplayName,
    uri: string,
    isShowAlbums: boolean,
    uriArray?: string[]
  ): Promise<void> {
    if (this.isSaving) {
      Log.info(TAG, 'saveData return because is saving');
      return;
    }
    this.isSaving = true;
    Log.info(TAG, `updateFormData start! ${albumName}/|${albumUri}/|${displayName}/|${uri}/|${isShowAlbums}, uriArray length: ${uriArray?.length ?? 0}`);
    ReportToBigDataUtil.report(BigDataConstants.CHANGE_FA_CARD_IMAGE_ID);
    this.isShowAlbums = isShowAlbums;
    this.albumUri = albumUri;
    this.uri = uri;
    const isMultiplePhotos = uriArray && uriArray.length > 1;
    let value: ValuesBucket = {
      'album_uri': albumUri,
      'cover_uri': uri,
      'album_type': isMultiplePhotos ? FATableAlbumType.ALBUM : FATableAlbumType.SINGLE,
      'playback_interval': this.playbackInterval,
    };
    const nowTask: Task = {
      formId: this.formId,
      taskUri: TaskUri.TASK_SELECT_PHOTO_URI,
      values: value,
      albumUri: albumUri,
    };
    if (isMultiplePhotos && uriArray) {
      nowTask.photoUris = uriArray;
    }
    Log.info(TAG, `send task ${JSON.stringify(nowTask)}`);
    await FormControllerManager.getInstance(getContext()).doTask(nowTask);
    this.isSaving = false;
  }

  routerPhotos(): void {
    const params: SelectParams = new SelectParams();
    params.bundleName = GalleryConstants.PHOTO_BUNDLE_NAME;
    params.isMultiPick = true;
    params.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_IMAGE;
    params.isFirstEnter = true;
    params.maxSelectCount = 120;
    params.uri = '';
    params.cameraAble = false;
    params.editAble = false;
    params.albumName = '';
    params.albumUri = '';
    params.isNewAlbum = true;
    params.isFromFa = true;

    this.navigationBroadCast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_PICKER_BASE_PAGE]).then(() => {
      this?.navigationPageInfos?.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_PICKER_BASE_PAGE, params), false);

    });
  }

  selectPhoto(): void {
    this.routerPhotos();
    const msg: IFACardBigDataParams = {
      formId: this.formId,
      type: IFACardEditorAction.SELECT_PHOTO,
      cardType: FATableAlbumType.ALBUM,
    };
    ReportToBigDataUtil.report(BigDataConstants.CARD_CLICK_SELECTION, msg);
  }

  selectAlbum(): void {
    this.isShowSelectAlbum = true;
    const msg: IFACardBigDataParams = {
      formId: this.formId,
      type: IFACardEditorAction.SELECT_ALBUM,
      cardType: FATableAlbumType.ALBUM,
    };
    ReportToBigDataUtil.report(BigDataConstants.CARD_CLICK_SELECTION, msg);
  }

  aboutToAppear(): void {
    Log.debug(TAG, 'formeditor aboutToAppear start! formid: ' + this.formId);
    WindowUtil.prepareWinRouter();
    getScreen().setSystemUi(true);
    this.breakpointSystem.register(this.currentBreakpoint);
    this.onUpdateBreakpoint();
    this.setUpWinOrientation();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinResizeFunc);
    this.appBroadCast.on(BroadCastConstants.SAVE_FORM_EDITOR_DATA, this.saveDataFunc);
    this.navigationBroadCast.on(
      NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK, this.onPickerOperationBackFunc);
    this.navigationBroadCast.on(NavigationConstants.LOAD_PAGE, this.loadNavigationPageFun);
    this.userFileManagerAccess.onCreate(getContext(this));
    this.currentFontSizeScaleChange();
    this.updateBarPadding();
    this.loadFaCardInfo().then(() => {
      this.faCardAlbumData.initData(this.appBroadCast, getContext(this));
    })
    Log.info(TAG, 'formEditor aboutToAppear complete ' + this.formId);
  }

  private async loadFaCardInfo(): Promise<void> {
    Log.info(TAG, `loadFaCardInfo faCardInfo`);
    try {
      const infoRet = await formProvider.getPublishedFormInfoById(this.formId);
      let infoStr: string = JSON.stringify(infoRet);
      let info: object | null = JSON.parse(infoStr);
      Log.info(TAG, `loadFaCardInfo, info = ${JSON.stringify(info)}`);
      if (info && info['formName']?.indexOf('widget') >= 0) {
        this.isNone = false;
      } else {
        UiUtil.showToast($r('app.string.occure_error_and_retry'));
      }
    } catch (err) {
      Log.error(TAG, `loadFaCardInfo error ${err?.code} ${err?.message}`);
    }
    let params: FormEditorParams = {} as FormEditorParams;
    params = AppStorage.get<Router>('router')?.getParams() as FormEditorParams;
    if (!params){
      params= LocalStorage.getShared().get<FormEditorParams>('formEditorParameters') as FormEditorParams;
    }
    // 查询图片播放时间
    this.playbackInterval = params?.interval ?? PlaybackInterval.FIFTEEN_SECONDS;
    Log.info(TAG, 'appear query interval result ' + this.playbackInterval);
    // 查询相册名是否显示
    this.isShowAlbumName = params?.isShowAlbumName ?? IsShowAlbumName.OFF;
    Log.info(TAG, 'appear query isShowAlbumName result ' + this.isShowAlbumName);
  }

  private async isLiveFormExist(): Promise<boolean> {
    let data = await appManager.getRunningProcessInformation();
    Log.info(TAG, `isLiveFormExist success, data: ${JSON.stringify(data)}`);
    for (let i = 0; i < data.length; i++) {
      let processInformation = data[i];
      Log.info(TAG, `isLiveFormExist processInformation: ${processInformation.processName}`);
      if (processInformation.processName === 'com.ohos.photos:liveForm' &&
        processInformation.state <= appManager.ProcessState.STATE_ACTIVE) {
        return true;
      }
    }
    return false;
  }

  async aboutToDisappear(): Promise<void> {
    Log.info(TAG, 'formEditor aboutToDisappear')
    this.breakpointSystem.unregister();
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinResizeFunc);
    this.appBroadCast.off(BroadCastConstants.SAVE_FORM_EDITOR_DATA, this.saveDataFunc);
    this.navigationBroadCast.off(
      NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK, this.onPickerOperationBackFunc);
    this.navigationBroadCast.off(NavigationConstants.LOAD_PAGE, this.loadNavigationPageFun);
    this.faCardAlbumData.destroy();
  }

  private async loadNavigationPage(name: string): Promise<void> {
    try {
      Log.info(TAG, `loadNavigationPage name: ${name}`);
      if (name === NavigationConstants.NAVIGATION_PICKER_BASE_PAGE) {
        let pageObj = await import('../../pickerability/view/PickerBasePage');
        this.pickerBasePageLoader = pageObj.PickerBasePageLoader;
      }
      Log.info(TAG, 'loadNavigationPage success.');
    } catch (error) {
      Log.error(TAG, `loadNavigationPage error: ${error}`);
    }
  }

  onPageShow() {
    getScreen().setSystemUi(true);
  }

  onPageHide(): void {
    Log.info(TAG, 'onpagehide pid: ' + process.tid + ' start time: ' + process.getStartRealtime());
  }

  onBackPress(): boolean | void {
    this.terminateSelf();
    return true;
  }

  terminateSelf(isDelayTerminate = false) {
    if (this.isNeedTerminate) {
      this.isNeedTerminate = false;
      if (!isDelayTerminate) {
        FaCardAlbumUtils.terminate();
        return;
      }
      setTimeout(() => {
        FaCardAlbumUtils.terminate();
      }, 300);
    }
  }

  private async updatePlaybackInterval(time: PlaybackInterval): Promise<void> {
    let result: DataShareResultSet | undefined = undefined;
    try {
      this.playbackInterval = time;
      const faCardService: FaCardService = new FaCardService(getContext());
      Log.info(TAG, 'updatePlaybackInterval form_id is ' + this.formId);
      let albumType: number | null = null;
      result = await faCardService.queryByFormId(this.formId);
      if (result && result.rowCount > 0) {
        result.goToFirstRow();
        albumType = Number(result.getString(0));
      }
      if (albumType === null) {
        Log.error(TAG, `updatePlaybackInterval error: albumType is null`);
        return;
      }
      const msg: IFACardBigDataParams = {
        formId: this.formId,
        cardType: albumType,
        playbackInterval: this.playbackInterval,
      };
      ReportToBigDataUtil.report(BigDataConstants.CARD_CLICK_PLAYBACK_INTERVAL, msg);
      let value: ValuesBucket = {
        'playback_interval': time,
      }
      const updatedNO = await faCardService.update(this.formId, value);
      if (updatedNO !== undefined) {
        const formContext: Context | undefined = AppStorage.get<Context>('formContext') as Context;
        Log.info(TAG, `update form ${this.formId} playback_interval to ${time}s, !formContext: ${!formContext}`);
        setTimeout(() => {
          Log.info(TAG, 'DELAY_REFRESH updateScheduler formId ' + this.formId);
          FaCardAlbumUtils.updateScheduler(this.formId, this.playbackInterval, true, formContext);
        }, DELAY_REFRESH);
      }
    } catch (error) {
      Log.error(TAG, `updatePlaybackInterval error: ${error}`);
    } finally {
      result?.close();
    }
  }

  /**
   * 根据字体放大倍数，调整列表上下间距高度
   */
  private currentFontSizeScaleChange(): void {
    this.listPaddingTopAndBottom = FontUtil.getPaddingByFontScale(this.currentFontSizeScale);
    Log.info(TAG, `currentFontSizeScaleChange listPaddingTopAndBottom: ` +
      `${px2vp(UiUtil.getResourceNumber(this.listPaddingTopAndBottom))}`);
  }

  updateFullMode(): void {
    this.updateBarPadding();
  }

  private navigationBarHeightChange(): void {
    this.updateBarPadding();
  }

  private updateBarPadding(): void {
    this.columnBottomPadding = (this.isFullMode ?
      px2vp(this.navigationBarHeight) : px2vp(this.navigationBarBottomHeight)) + 16;
  }

  private async updateAlbumNameOpenState(isShowAlbumName: number): Promise<void> {
    let result: DataShareResultSet | undefined = undefined;
    try {
      this.isShowAlbumName = isShowAlbumName;
      const faCardService: FaCardService = new FaCardService(getContext());
      Log.info(TAG, `update formId[${this.formId}] openState is ${isShowAlbumName}`);
      let albumType: number | null = null;
      let albumUri: string = '';
      result = await faCardService.queryByFormId(this.formId);
      const albumTypeIndex = result?.getColumnIndex(FaCardTable.ALBUM_TYPE);
      const albumUriIndex = result?.getColumnIndex(FaCardTable.ALBUM_URI);
      if (result && result.rowCount > 0) {
        result.goToFirstRow();
        albumType = Number(result.getString(albumTypeIndex));
        albumUri = result.getString(albumUriIndex);
      }
      if (albumType === null) {
        Log.error(TAG, `updatePlaybackInterval error: albumType is null`);
        return;
      }
      const msg: IFACardBigDataParams = {
        formId: this.formId,
        cardType: albumType,
        isShowAlbumName: this.isShowAlbumName,
      }
      ReportToBigDataUtil.report(BigDataConstants.CARD_UPDATE_ALBUM_NAME_STATE, msg);
      let value: ValuesBucket = {};
      if (this.isShowAlbumName) {
        const albumName: string = await this.userFileManagerAccess.getAlbumNameByUri(albumUri, getContext(this));
        value = {
          'album_name': albumName,
          'is_show_album_name': this.isShowAlbumName,
        }
      } else {
        value = {
          'is_show_album_name': this.isShowAlbumName,
        }
      }
      const updatedNO = await faCardService.update(this.formId, value);
      if (updatedNO !== undefined) {
        const formContext: Context | undefined = AppStorage.get<Context>('formContext') as Context;
        Log.info(TAG,
          `update form ${this.formId} isShowAlbumName to ${this.isShowAlbumName}, !formContext: ${!formContext}`);
        setTimeout(() => {
          Log.info(TAG, 'DELAY_REFRESH updateScheduler formId ' + this.formId);
          FaCardAlbumUtils.updateScheduler(this.formId, this.playbackInterval, true, formContext);
        }, DELAY_REFRESH);
      }
    } catch (error) {
      Log.error(TAG, `updateAlbumNameOpenState error: ${error}`);
    }
  }

  @BuilderParam navigationPageLoader: () => void;
  @BuilderParam pickerBasePageLoader: ($$: PickerBasePageParams) => void;

  @Builder
  PageMap(name: string, param: Object) {
    if (name === NavigationConstants.NAVIGATION_PICKER_BASE_PAGE) {
      this.pickerBasePageLoader({
        params: param as SelectParams,
        navPageInfos: this.navigationPageInfos,
      });
    }

  }

  build() {
    Navigation(this.navigationPageInfos) {
      Stack({ alignContent: Alignment.Top }) {
        Scroll() {
          this.buildContent();
        }
        this.buildCloseButton()
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .width('100%')
      .height('100%')
      .padding({ top: getScreen().getStatusBarHeight() })
      .bindSheet(this.isShowSelectAlbum, this.buildAlbumPage(), {
        height: SheetSize.LARGE,
        preferType: SheetType.CENTER,
        backgroundColor: $r('sys.color.ohos_id_color_panel_bg'),
        onWillDisappear: () => {
          this.isShowSelectAlbum = false;
        },
        onDisappear: () => {
          this.isNeedTerminate = true;
          this.pageInfos.clear();
        },
        showClose: true,
      })
      .clip(true)
    }
    .navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .onNavBarStateChange((isVisible: boolean) => {
      Log.info(TAG, `onNavBarStateChange = ${isVisible}`);
      if (isVisible) {
        NavigationBroadCastManager.getInstance().targetName = '';
      }
    })
  }

  @Builder
  buildCloseButton() {
    Column() {
      Button({ type: ButtonType.Normal, stateEffect: true }) {
        SymbolGlyph($r('sys.symbol.xmark'))
          .draggable(false)
          .width($r('app.float.icon_size'))
          .height($r('app.float.icon_size'))
          .fontSize($r('app.float.icon_size'))
          .fontColor([$r('sys.color.icon_primary')])
      }
      .height($r('app.float.action_bar_button_height'))
      .width($r('app.float.action_bar_button_height'))
      .borderRadius($r('app.float.action_bar_button_height'))
      .backgroundColor($r('app.color.icon_bg_color'))
      .onClick((): void => {
        this.terminateSelf();
      })
      .accessibilityText($r('app.string.disable'))
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .height($r('app.float.title_default'))
    .width('100%')
    .padding({ left: this.editorPageMargin, right: this.editorPageMargin })
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  buildContent() {
    Column() {
      GridRow({columns: {xs: 4, sm:  4, md: 8, lg: 12}}) {
        GridCol({span: {xs: 4, sm:  4, md: 6, lg: 8}, offset: {xs: 0, sm: 0, md: 1, lg: 2}}) {
          this.buildMainContent()
        }
      }
      .onAppear(() => {
        Log.info(TAG, `buildContent onAppear`);
      })
    }
    .padding({
      left: this.editorPageMargin,
      right: this.editorPageMargin,
      top: $r('app.float.title_default'),
      bottom: this.columnBottomPadding,
    })
  }

  @Builder
  buildSettingShowAlbumName() {
    ListItemGroup({ style: ListItemGroupStyle.CARD }) {
      ListItem() {
        this.buildSettingShowAlbumNameItem($r('app.string.display_album_name'));
      }
    }
    .borderRadius($r('sys.float.corner_radius_level10'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .margin({
      bottom: GalleryConstants.STATEMENT_CARDS_BOTTOM_PADDING,
    })
  }

  @Builder
  buildSettingShowAlbumNameItem(resource: ResourceStr) {
    Row() {
      Column(){
        Text(resource)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .flexGrow(Constants.FLEX_GROW)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Row() {
        Row() {
          Toggle({ type: ToggleType.Switch, isOn: this.isShowAlbumName === IsShowAlbumName.ON })
            .onChange((isOn: boolean) => {
              this.updateAlbumNameOpenState(isOn ? IsShowAlbumName.ON : IsShowAlbumName.OFF);
            })
            .width(GalleryConstants.FORM_EDITOR_TOGGLE_WIDTH)
            .height(GalleryConstants.FORM_EDITOR_TOGGLE_HEIGHT)
            .accessibilityGroup(true)
            .accessibilityLevel("yes")
        }
        .height($r('app.float.album_set_page_spinner_size'))
        .justifyContent(FlexAlign.Center)
      }
      .borderRadius($r('sys.float.corner_radius_level8'))
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .padding({
      top: this.listPaddingTopAndBottom,
      bottom: this.listPaddingTopAndBottom,
      left: $r('app.float.extended_services_listcard_padding_left_and_right'),
      right: $r('app.float.extended_services_listcard_padding_left_and_right'),
    })
    .accessibilityGroup(true)
  }

  @Builder
  buildMainContent() {
    Column() {
      if (!this.isNone) {
        if (!this.isHighlight) {
          Column() {
            Text($r('app.string.tab_albums'))
              .fontSize($r('sys.float.Title_S'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Bold)

            Text($r('app.string.fa_title_text'))
              .fontSize($r('sys.float.Body_L'))
              .margin({ top: $r('app.float.tab_bar_padding_top') })
              .fontColor($r('sys.color.font_secondary'))
              .fontWeight(FontWeight.Medium)
          }
          .margin({ top: $r('app.float.FA_subTitle_margin_top'), bottom: $r('app.float.FA_title_margin_bottom') })

          List() {
            this.buildSelectPhoto();

            this.buildSelectAlbum();
          }

          SubHeader({
            primaryTitle: $r('app.string.title_general_settings'),
            primaryTitleModifier: new TextModifier()
              .fontColor($r('sys.color.font_secondary'))
              .fontWeight(FontWeight.Medium)
              .fontSize($r('sys.float.Body_M')),
            contentPadding: { start: LengthMetrics.vp(12) },
            contentMargin: { start: LengthMetrics.vp(0) },
          })
        } else {
          Column() {
            Text($r('app.string.tab_highlights'))
              .fontSize($r('sys.float.Title_S'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Bold)

            Text($r('app.string.fa_title_text'))
              .fontSize($r('sys.float.Body_L'))
              .margin({ top: $r('app.float.tab_bar_padding_top') })
              .fontColor($r('sys.color.font_secondary'))
          }
          .margin({ top: $r('app.float.FA_subTitle_margin_top'), bottom: $r('app.float.FA_title_margin_bottom') })
        }

        List() {
          this.buildSettingIntervals();
          // if (!this.isHighlight) {
          //   this.buildSettingShowAlbumName();
          // }
        }
      }
    }
  }

  @Builder
  buildAlbumPage() {
    Column() {
      FormEditorSelectAlbumPage({
        interval: this.playbackInterval,
        listPaddingTopAndBottom: this.listPaddingTopAndBottom,
        currentFontSizeScale: this.currentFontSizeScale,
        appBroadCast: $appBroadCast,
        faCardAlbumDataViewModel: this.faCardAlbumData
      });
    }
    .width('100%')
    .height('100%')
  }

  @State sheetHeight: number = 300;
  @State isShowSelectAlbum: boolean = false

  @Builder
  buildSettingIntervalsMenu() {
    Menu() {
      ForEach(this.playbackIntervalOptions, (interval: PlaybackInterval) => {
        MenuItem({
          content: $r('app.plural.seconds', interval, interval),
          endIcon: this.playbackInterval === interval ? $r('sys.media.ohos_ic_public_ok') :
            undefined
        })
          .onClick(() => {
            this.updatePlaybackInterval(interval)
          })
          .accessibilityText(`${
          this.resourceManager.getPluralStringValueSync($r('app.plural.seconds', interval), interval)
          }  ${
          this.resourceManager.getStringSync(
            this.playbackInterval === interval
              ? $r('app.string.selected')
              : $r('app.string.deselected')
          )
          }`)
      }, (interval: PlaybackInterval) => String(interval))
    }
    .width(224)
    .menuItemDivider({
      strokeWidth: { value: 1, unit: LengthUnit.PX },
      startMargin: { value: 16, unit: LengthUnit.PX },
      endMargin: { value: 16, unit: LengthUnit.PX },
      color: $r('sys.color.comp_divider'),
    })
  }

  @Builder
  buildSettingIntervalsItem(resource: ResourceStr) {
    Row() {
      Text(resource)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_primary'))
        .flexGrow(Constants.FLEX_GROW)
      Row() {
        Text($r('app.plural.seconds', this.playbackInterval, this.playbackInterval))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_secondary'))
          .margin({
            left: $r('sys.float.ohos_id_text_margin_horizontal'),
          })
          .fontWeight(FontWeight.Regular)
        Row() {
          SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
            .draggable(false)
            .fontSize('14vp')
            .fontColor([$r('sys.color.icon_fourth')])
        }
        .width($r('app.float.album_set_page_spinner_size'))
        .height($r('app.float.album_set_page_spinner_size'))
        .justifyContent(FlexAlign.Center)
      }
      .borderRadius($r('sys.float.corner_radius_level8'))
      .stateStyles({
        focused: {
          .backgroundColor($r('sys.color.interactive_click'))
        },
        pressed: {
          .backgroundColor($r('sys.color.interactive_click'))
        },
        selected: {
          .backgroundColor($r('sys.color.comp_background_emphasize'))
        },
        normal: {
          .backgroundColor(undefined)
        }
      })
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .padding({
      top: this.listPaddingTopAndBottom,
      bottom: this.listPaddingTopAndBottom,
      left: $r('app.float.extended_services_listcard_padding_left_and_right'),
      right: $r('app.float.extended_services_listcard_padding_left_and_right'),
    })
    .bindMenu(this.buildSettingIntervalsMenu, {
      placement: Placement.BottomRight,
    })
    .accessibilityGroup(true)
    .accessibilityText(`${
    this.resourceManager.getStringSync(resource as Resource)
    }  ${
    this.resourceManager.getPluralStringValueSync(
      $r('app.plural.seconds', this.playbackInterval),
      this.playbackInterval
    )
    }`)
  }

  @Builder
  buildSelectItem(resource: Resource) {
    Row() {
      Text(resource)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_primary'))
        .flexGrow(Constants.FLEX_GROW)
      Row() {
        Image($r('app.media.ic_gallery_form_arrow'))
          .matchTextDirection(true)
          .draggable(false)
          .width($r('app.float.form_list_card_more_arrow_w'))
          .height($r('app.float.form_list_card_more_arrow_h'))
          .fillColor($r('sys.color.icon_fourth'))
      }
      .margin({
        left: $r('sys.float.ohos_id_text_margin_horizontal'),
      })
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .padding({
      top: this.listPaddingTopAndBottom,
      bottom: this.listPaddingTopAndBottom,
    })
    .accessibilityGroup(true)
  }

  @Builder
  buildSettingIntervals() {
    ListItemGroup({ style: ListItemGroupStyle.CARD }) {
      ListItem() {
        if (this.currentFontSizeScale < GalleryConstants.FONT_SCALE_LARGE_SIZE) {
          this.buildSettingIntervalsItem($r('app.string.slideshow_interval'));
        } else {
          Column({ space: 2 }) {
            Row() {
              Text($r('app.string.slideshow_interval'))
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.Body_L'))
                .fontColor($r('sys.color.font_primary'))
                .flexGrow(Constants.FLEX_GROW)
            }
            .padding({
              left: $r('app.float.extended_services_listcard_padding_left_and_right'),
              right: $r('app.float.extended_services_listcard_padding_left_and_right'),
            })
            .alignItems(VerticalAlign.Center)
            .width('100%')

            Row() {
              Text($r('app.plural.seconds', this.playbackInterval, this.playbackInterval))
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_secondary'))
              Row() {
                SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
                  .draggable(false)
                  .fontSize('14vp')
                  .fontColor([$r('sys.color.icon_fourth')])
              }
              .width($r('app.float.album_set_page_spinner_size'))
              .height($r('app.float.album_set_page_spinner_size'))
              .justifyContent(FlexAlign.Center)
            }
            .padding({
              left: $r('app.float.extended_services_listcard_padding_left_and_right'),
              right: $r('app.float.extended_services_listcard_padding_left_and_right'),
            })
            .borderRadius($r('sys.float.corner_radius_level8'))
            .stateStyles({
              focused: {
                .backgroundColor($r('sys.color.interactive_click'))
              },
              pressed: {
                .backgroundColor($r('sys.color.interactive_click'))
              },
              selected: {
                .backgroundColor($r('sys.color.comp_background_emphasize'))
              },
              normal: {
                .backgroundColor(undefined)
              }
            })
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .margin({
            top: this.listPaddingTopAndBottom,
          })
          .bindMenu(this.buildSettingIntervalsMenu, {
            placement: Placement.BottomRight,
          })
          .accessibilityGroup(true)
          .accessibilityText(`${
          this.resourceManager.getStringSync($r('app.string.slideshow_interval'))
          }  ${
          this.resourceManager.getPluralStringValueSync(
            $r('app.plural.seconds', this.playbackInterval),
            this.playbackInterval
          )
          }`)
        }
      }
      .width('100%')
      .borderRadius($r('sys.float.corner_radius_level8'))
    }
    .borderRadius($r('sys.float.corner_radius_level10'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .margin({
      bottom: GalleryConstants.STATEMENT_CARDS_BOTTOM_PADDING,
    })
  }

  @Builder
  buildSelectAlbum() {
    ListItemGroup({ style: ListItemGroupStyle.CARD }) {
      ListItem() {
        this.buildSelectItem($r('app.string.title_select_album'))
      }
      .onClick((): void => {
        this.selectAlbum();
      })
      .listItemStyle()
    }
    .borderRadius($r('sys.float.corner_radius_level10'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .margin({
      top: GalleryConstants.STATEMENT_CARDS_BOTTOM_PADDING,
    })
  }

  @Builder
  buildSelectPhoto() {
    ListItemGroup({ style: ListItemGroupStyle.CARD }) {
      ListItem() {
        this.buildSelectItem($r('app.string.fa_select_image_text'))
      }
      .onClick((): void => {
        this.selectPhoto();
      })
      .listItemStyle()
    }
    .borderRadius($r('sys.float.corner_radius_level10'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .margin({
      left: 0,
      right: 0,
    })
  }

  @Styles
  listItemStyle() {
    .width('100%')
    .padding({
      left: $r('app.float.extended_services_listcard_padding_left_and_right'),
      right: $r('app.float.extended_services_listcard_padding_left_and_right'),
    })
    .stateStyles({
      focused: {
        .backgroundColor($r('sys.color.interactive_click'))
      },
      pressed: {
        .backgroundColor($r('sys.color.interactive_click'))
      },
      selected: {
        .backgroundColor($r('sys.color.comp_background_emphasize'))
      },
      normal: {
        .backgroundColor(undefined)
      }
    })
    .borderRadius($r('sys.float.corner_radius_level8'))
  }
}

enum PlaybackInterval {
  TWO_SECONDS = 1,

  FIFTEEN_SECONDS = 15,

  THIRTY_SECONDS = 30,
}
