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


import lazy UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PickerColorMode, PickerOrientation, PreselectedInfo, SingleLineConfig } from '@ohos.file.PhotoPickerComponent';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { PickerDataSourceManager } from '@ohos/thirdselect/src/main/ets/default/common/PickerDataSourceManager';
import lazy { PickerForegroundManager } from '@ohos/thirdselect/src/main/ets/default/common/PickerForegroundManager';
import lazy { BusinessError, osAccount } from '@kit.BasicServicesKit';
import lazy { ContextRecoveryInfo } from '@ohos/common/src/main/ets/default/model/common/ContextRecoveryInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { ThirdSelectConstants } from '@ohos/thirdselect/src/main/ets/default/utils/ThirdSelectConstants';
import lazy { NetworkConnectionAccess } from '@ohos/privacy/src/main/ets/access/NetworkConnectionAccess';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';
import lazy { CustomColors } from '@ohos.arkui.theme';
import lazy Bundles from '@ohos/tools/src/main/utils/Bundle';
import lazy uiExtensionHost from '@ohos.uiExtensionHost';
import lazy { PickerInstanceUtil } from '@ohos/common/src/main/ets/default/utils/PickerInstanceUtil';
import lazy { InitRecoverInfo } from '@ohos/thirdselect/src/main/ets/default/utils/recoverScene/InitRecoverInfo';
import lazy { MaskLayerUtils } from '@ohos/thirdselect/src/main/ets/default/utils/MaskLayerUtils';
import lazy { toString } from '@ohos/common/src/main/ets/default/model/FetchOption';
import lazy { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import lazy {
  PickerAlbumsFilterEnhanceBuilder,
  MediaTypeFilter
} from '@ohos/common/src/main/ets/default//model/PickerFilterEnhanceBuilder';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';

/* instrument ignore file */
const TAG: string = '[CommonPickerUIExtensionAbility]';

interface FilterToTransfer {
  photoViewMimeType: photoAccessHelper.PhotoViewMIMETypes;
  filterOperator: photoAccessHelper.FilterOperator;
  fileSize: number;
  extraFileSize: number | undefined;
}

export default class CommonPickerUIExtensionAbility extends UIExtensionAbility {
  private storage = new LocalStorage();
  private pickerDataSourceManager: PickerDataSourceManager | undefined;
  private initRecoverInfo: InitRecoverInfo = new InitRecoverInfo();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  onCreate() {
    Log.info(TAG, 'onCreate');
    try {
      this.context.getApplicationContext().setSupportedProcessCache(true);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Log.info(TAG, `PickerUIExtensionAbility setSupported returns code ${code}, returns msg ${message}`)
    }
  }

  onForeground() {
    Log.info(TAG, 'onForeground');
    PickerForegroundManager.getInstance().addForegroundInstance();
    this.context?.eventHub?.emit(Constants.PHOTO_PICKER_ON_FOREGROUND, true);
    MaskLayerUtils.getInstance().setPickerProtectedState(this.storage, false);
  }

  onBackground() {
    let foregroundCount: number = PickerForegroundManager.getInstance().deleteInstance();
    Log.info(TAG, `onBackground check foreground instance count : ${foregroundCount}`);
    if (foregroundCount <= 0) {

    }
    this.context?.eventHub?.emit(Constants.PHOTO_PICKER_ON_FOREGROUND, false);
    MaskLayerUtils.getInstance().setPickerProtectedState(this.storage, true);
  }

  onDestroy() {
    Log.info(TAG, 'onDestroy');
    this.storage?.delete(Constants.APP_KEY_SCREEN_MANAGER);
  }

  private setCallerBundleName(wantParam: Record<string, Object>) : void {
    let callerBundleName: string = wantParam?.['ohos.aafwk.param.callerBundleName'] as string;
    let pickerNameList: Record<string, boolean | undefined> = AppStorage.get('pickerNameList') ?? {};
    // 如果 pickerNameList 中没有对应的 callerBundleName键，则默认追加设为false
    if (typeof pickerNameList[callerBundleName] === 'undefined') {
      pickerNameList[callerBundleName] = false;
    }
    AppStorage.setOrCreate('pickerNameList', pickerNameList);
    Log.info(TAG, `onSessionCreate: ${callerBundleName}, ${JSON.stringify(AppStorage.get('pickerNameList'))}`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    Log.info(TAG, 'PhotoPickerComponent onRemoteReadyonSessionCreate');
    let extensionWindow: uiExtensionHost.UIExtensionHostWindowProxy | undefined =
      session.getUIExtensionHostWindowProxy();
    extensionWindow?.hidePrivacyContentForHost(true);
    this.storage?.setOrCreate('photosAbilityContext', this.context);
    this.storage?.setOrCreate(Constants.PHOTO_PICKER_EXTENSION_WINDOW, extensionWindow);
    this.storage?.setOrCreate<boolean>(Constants.IS_THIRD_PICKER_SUBWINDOW, false);
    AppStorage.setOrCreate<boolean>('isPickerPage', true);
    PickerInstanceUtil.createPickerInstance(this.storage);
    let wantParam: Record<string, Object> = want.parameters as Record<string, Object>;
    let isAlbumPage: boolean = wantParam?.targetPage as string === 'albumPage';
    let isGrantPhotoUrisPage: boolean = wantParam?.targetPage as string === 'requestPhotoUrisPage';
    let pagePath: string;
    let params: SelectParams = SelectParams.defaultParam();
    this.setCallerBundleName(wantParam);
    if (isAlbumPage) {
      pagePath = 'pickerability/view/ThirdSelectAlbumPage';
      params.themeColorMode = wantParam?.themeColorMode as number ?? 0;
      params.fontSize = wantParam?.fontSize as number | string ?? 0;
      params.bundleName = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string ?? '';
      params.appCloneIndex = wantParam['ohos.param.callerAppCloneIndex'] as number;
      this.setFilterMediaType(params, wantParam);
      this.parseRecommendType(params, wantParam);
    } else if (isGrantPhotoUrisPage) {
      pagePath = 'pickerability/view/GrantPhotoUrisPage';
      this.parseGrantPageWant(params, wantParam, this.storage);
    } else {
      pagePath = 'pickerability/view/PickerSheetPage';
      params = this.parseWant(want, this.storage);
    }

    this.setCombinedMediaTypeFilter(params, wantParam);
    if(params.userId === -1) {
      this.setStorageAndDataSourceManager(params, wantParam, session,
        isAlbumPage, isGrantPhotoUrisPage, pagePath, extensionWindow).catch((error: BusinessError) => {
        Log.error(TAG, `setStorageAndDataSourceManager failed: ${error.message}`);
      });
    } else {
      this.isMainSpace().then(async (isMainSpace) => {
        if(isMainSpace) {
          Log.info(TAG, 'isMainSpace');
          params.userId = -1;
        }
        await this.setStorageAndDataSourceManager(params, wantParam, session,
          isAlbumPage, isGrantPhotoUrisPage, pagePath, extensionWindow);
      }).catch((error: BusinessError) => {
        Log.error(TAG, `setStorageAndDataSourceManager failed: ${error.message}`);
      });
    }
  }

  private async setStorageAndDataSourceManager(params: SelectParams, wantParam: Record<string, Object>,
    session: UIExtensionContentSession, isAlbumPage: boolean, isGrantPhotoUrisPage: boolean,
    pagePath: string, extensionWindow: uiExtensionHost.UIExtensionHostWindowProxy | undefined): Promise<void> {
    if (!params.combinedMediaTypeFilter) {
      this.setPhotoViewMimeTypeFilter(params, wantParam);
    }
    params.fileSizeFilter = wantParam?.fileSizeFilter as photoAccessHelper.FileSizeFilter;
    params.videoDurationFilter = wantParam?.videoDurationFilter as photoAccessHelper.VideoDurationFilter;
    params.photoViewMimeTypeFileSizeFilters =
      wantParam?.photoViewMimeTypeFileSizeFilters as Array<photoAccessHelper.PhotoViewMimeTypeFileSizeFilter>;
    if (params.photoViewMimeTypeFileSizeFilters && params.photoViewMimeTypeFileSizeFilters.length !== 0) {
      // 当配置photoViewMimeTypeFileSizeFilters参数时，MIMEType的配置自动失效
      params.filterMediaType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    }
    MaskLayerUtils.getInstance().init();
    this.storage?.setOrCreate(Constants.PHOTO_PICKER_SESSION_KEY, session);
    this.storage?.setOrCreate(Constants.PHOTO_PICKER_PARAMS_KEY, params);
    this.storage?.setOrCreate('isOnItemClickedSet', wantParam?.isOnItemClickedSet as boolean ?? false);
    this.storage?.setOrCreate('targetPage', wantParam?.targetPage as string ?? '');
    UserFileManagerAccess.getInstance(this.storage).onCreate(this.context);
    await this.parseContextRecoveryInfo(params, wantParam);
    if (!(isGrantPhotoUrisPage || isAlbumPage)) {
      this.pickerDataSourceManager = new PickerDataSourceManager(this.storage);
      this.pickerDataSourceManager.getDataImpl().setContext(this.context);
      this.pickerDataSourceManager.initDataWithType(params.filterMediaType, params);
      this.storage?.setOrCreate(Constants.PHOTO_PICKER_PICKER_DATA_SOURCE_MANAGER, this.pickerDataSourceManager);
    }
    NetworkConnectionAccess.register();
    MediaObserver.getInstance().subscribe(this.context, TAG);
    getScreen(this.storage).initializationSize().then((): void => {
      if (!params.isFromPickerView) { // 组件化picker可以不监听挖孔区域
        getScreen(this.storage).getAvoidArea();
        getScreen(this.storage).registerWindowAvoidArea();
      }
      getScreen(this.storage).setMainWindow();
      if (!this.createPickerSubWindow(session, this.storage)) {
        session.loadContent(pagePath, this.storage);
      }
      session.setWindowBackgroundColor('#00000000');
      const extensionWindowProxy = session.getUIExtensionWindowProxy();
      this.storage?.setOrCreate('extensionWindowProxy', extensionWindowProxy);
      Log.info(TAG, `onSessionCreate${extensionWindow}`);
    });
    this.parseBigData(params)
  }

  protected createPickerSubWindow(session: UIExtensionContentSession, storage: LocalStorage): boolean {
    // 在产品模块重写此方法自行实现 默认不使用subWindow
    return false;
  }

  protected destroyPickerSubWindow(): void {
    // 在产品模块重写此方法自行实现
  }

  private async parseBigData(params: SelectParams): Promise<void> {
    if (params.fontSize){
      Log.info(TAG, 'params.fontSize report');
      let msg: Record<string, number | string | boolean> = {
        'FONT_SIZE': params.fontSize,
      }
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_COMP_BROWSE_MODE, msg);
    }
    if (params.photoViewMimeTypeFileSizeFilters) {
      Log.info(TAG, 'params.photoViewMimeTypeFileSizeFilters report');
      let filterToTransfers: FilterToTransfer[] = [];
      for (let filter of params.photoViewMimeTypeFileSizeFilters) {
        let filterToTransfer: FilterToTransfer = {
          photoViewMimeType : filter.photoViewMimeType,
          filterOperator : filter.sizeFilter.filterOperator,
          fileSize : filter.sizeFilter.fileSize,
          extraFileSize : filter.sizeFilter.extraFileSize,
        }
        filterToTransfers.push(filterToTransfer);
      }
      let msg: Record<string, number | string | boolean> = {
        'FILE_SIZE_FILTER': toString(filterToTransfers),
      }
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_COMP_BROWSE_MODE, msg);
    }
    if (params.combinedMediaTypeFilter) {
      Log.info(TAG, 'params.combinedMediaTypeFilter report');
      let msg: Record<string, number | string | boolean> = {
        'COMBINED_FILTER': toString(params.combinedMediaTypeFilter),
      }
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_COMP_BROWSE_MODE, msg);
    }
    if (params.pickerIndex) {
      Log.info(TAG, 'params.pickerIndex report');
      let msg: Record<string, number | string | boolean> = {
        'PICKER_INDEX': toString(params.pickerIndex),
      }
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_COMP_BROWSE_MODE, msg);
    }
  }

  private parseGrantPageWant(params: SelectParams, wantParam: Record<string, Object>, storage: LocalStorage): void {
    let uris = wantParam['ability.params.stream'] as string[] ?? [];
    params.cameraAble = false;
    params.editAble = false;
    params.searchAble = false;
    params.isMultiPick = true;
    params.isNeedActionBar = false;
    params.maxSelectCount = 100; // 最大授权数量100
    params.itemDisplayName = '';
    params.isOriginalSupported = false;
    params.completeButtonText = ThirdSelectConstants.COMPLETE_BUTTON_TEXT_GRANT;
    params.tokenId = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_TOKEN] as number ?? 0;
    params.appId = wantParam['ohos.aafwk.param.callerAppId'] as string;
    params.appCloneIndex = wantParam['ohos.param.callerAppCloneIndex'] as number;
    if (uris?.length > 100) {
      uris = uris.slice(0, 100);
    }
    storage?.setOrCreate(Constants.PHOTO_PICKER_GRANT_PHOTO_URIS, uris);
    storage?.setOrCreate(Constants.PHOTO_PICKER_GRANT_PHOTO_APP_NAME, wantParam.appName as string);
    Log.info(TAG, 'parseGrantPageWant');
  }

  private deleteCallerBundleName(param: SelectParams): void {
    let pickerNameList: Record<string, boolean | undefined> = AppStorage.get('pickerNameList') ?? {};
    let count = Object.values(pickerNameList).filter(item => item !== undefined).length;
    Log.info(TAG, 'onSessionDestroy' + count + pickerNameList[param?.bundleName]);
    if (count === 1) {
      if (pickerNameList[param?.bundleName]) {
        Log.info(TAG, 'Running a single instance and in large image');
        VideoPlayController.release();
        AppStorage.delete('pickerNameList');
      } else if (pickerNameList[param?.bundleName] === false) {
        Log.info(TAG, 'Running a single instance and in grid image');
        AppStorage.delete('pickerNameList');
      }
    } else if (count > 1) {
      pickerNameList[param?.bundleName] = undefined;
      Log.info(TAG, 'Multiple instances running');
    } else {
      Log.info(TAG, 'no release videoPlayController');
    }
    Log.info(TAG, 'onSessionDestroy' + JSON.stringify(AppStorage.get('pickerNameList')));
  }
  onSessionDestroy(session: UIExtensionContentSession) {
    Log.info(TAG, 'onSessionDestroy');
    this.destroyPickerSubWindow();
    let param = this.storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
    this.deleteCallerBundleName(param);
    NetworkConnectionAccess.unregister();
    getScreen(this.storage).destroyMainWindow();
    getScreen(this.storage).unRegisterWindowAvoidArea();
    MediaObserver.getInstance().clearCallbacks();
    UserFileManagerAccess.getInstance(this.storage).onDestroy();
    this.pickerDataSourceManager?.release();
    MaskLayerUtils.getInstance().setPickerProtectedState(this.storage, false);
    this.storage?.delete(Constants.PHOTO_PICKER_DATA_SOURCE_MANAGER);
    this.storage?.delete(Constants.PHOTO_PICKER_APP_ID_KEY);
    this.storage?.delete(Constants.PHOTO_PICKER_EXTENSION_WINDOW);
    this.storage?.delete('photosAbilityContext');
    this.storage?.delete(Constants.PHOTO_PICKER_SESSION_KEY);
    this.storage?.delete(Constants.PHOTO_PICKER_PARAMS_KEY);
    this.storage?.delete('isOnItemClickedSet');
    this.storage?.delete(Constants.PHOTO_PICKER_GRANT_PHOTO_URIS);
    this.storage?.delete(Constants.PHOTO_PICKER_GRANT_PHOTO_APP_NAME);
    this.storage?.delete(Constants.PHOTO_USER_FILE_MANAGER_ACCESS);
    this.storage?.delete(Constants.PHOTO_MEDIA_OBSERVER);
    this.storage?.delete('key_image_editor_project');
    this.storage?.delete(Constants.APP_KEY_ALL_PHOTO_DATASOURCE);
    this.storage?.delete(Constants.APP_KEY_PHOTO_BROWSER);
    this.storage?.delete(Constants.THIRD_SELECT_MANAGER);
    this.storage?.delete('geometryScale');
    this.storage?.delete('geometryOffsetX');
    this.storage?.delete('geometryOffsetY');
    this.storage?.delete('geometryOpacity');
    this.storage?.delete('placeholderIndex');
    this.storage?.delete('geometryTransitionBrowserId');
    this.storage?.delete(Constants.PHOTO_PICKER_PICKER_DATA_SOURCE_MANAGER);
    this.storage?.clear();
    CommonUtil.unregisterProgDispSwitchObserver(this.context);
  }

  private parseWant(want: Want, storage: LocalStorage): SelectParams {
    let wantParam: Record<string, Object> = want.parameters as Record<string, Object>;
    let params: SelectParams = SelectParams.defaultParam();
    let selectType: string = wantParam?.uri as string;
    if (selectType) {
      params.isMultiPick = (selectType == Constants.WANT_PARAM_URI_SELECT_MULTIPLE) ? true : false;
      params.maxSelectCount = params.isMultiPick ? wantParam?.maxSelectCount as number : 1;
      params.bundleName = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string;
      params.callerAbilityName = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_ABILITY_NAME] as string;
      if (params.bundleName === Constants.SCENEBOARD_BUNDLE_NAME) {
        params.statusBarHeight = wantParam?.statusBarHeight as number ?? 0;
      }
      params.tokenId = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_TOKEN] as number ?? 0;
      params.appId = wantParam['ohos.aafwk.param.callerAppId'] as string;
      params.appCloneIndex = wantParam['ohos.param.callerAppCloneIndex'] as number;
      params.filterMediaType = wantParam?.filterMediaType as string;
      params.cameraAble = (wantParam?.isPhotoTakingSupported as boolean) ?? true;
      params.editAble = (wantParam?.isEditSupported as boolean) ?? false;
      params.searchAble = (wantParam?.isSearchSupported as boolean) ?? true;
      params.preData = wantParam?.preselectedUris as string[];
      params.isFirstEnter = true;
      params.customColor = wantParam?.themeColor as CustomColors;
      params.userId = wantParam?.userId as number;
      params.callerPid = String(wantParam?.['ohos.aafwk.param.callerPid']);
      this.parseNewWant(params, wantParam);
      const msg: Record<string, number | string | boolean> = {
        'IS_PICKER_SEARCH_CONFIGURED': !((wantParam?.isSearchSupported as boolean) === undefined),
        'IS_SEARCH_ENABLED': params.searchAble,
        'bundleName': params.bundleName,
      };
      ReportToBigDataUtil.report(BigDataConstants.IS_PICKER_SEARCH_ENABLED, msg);
      const selectMsg: Record<string, number | string | boolean> = {
        'selectType': selectType,
        'filterMediaType': params.filterMediaType,
        'maxSelectCount': params.maxSelectCount,
        'bundleName': params.bundleName,
      };
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_ID, selectMsg);
    } else {
      Log.error(TAG, 'selectType is undefined');
    }
    Log.info(TAG, 'parseWant:' +
    JSON.stringify(wantParam, StringUtil.textContextInfoReplacer) + `params = ${JSON.stringify(params)}`);
    return params;
  }

  private async parseNewWant(params: SelectParams, wantParam: Record<string, Object>): Promise<void> {
    params.isFromPickerView = wantParam?.isFromPickerView as boolean ?? false;
    params.isNeedSelectBar = wantParam?.isNeedSelectBar as boolean ?? true;
    params.isNeedActionBar = wantParam?.isNeedActionBar as boolean ?? true;
    params.isShowSerialNum = params.isFromPickerView;
    const pickerOptions: Record<string, Object> | undefined = wantParam?.pickerOptions as Record<string, Object>;
    this.updateParamsByPickerOptions(params, pickerOptions);
    params.checkBoxColor = wantParam?.checkBoxColor as string ?? params.checkBoxColor ?? '';
    params.checkboxTextColor = wantParam?.checkboxTextColor as string ?? params.checkboxTextColor ?? '';
    params.backgroundColor = wantParam?.backgroundColor as string ?? params.backgroundColor ?? '';
    params.isOriginalSupported = wantParam?.isOriginalSupported as boolean ?? true;
    params.isPreviewForSingleSelectionSupported = wantParam?.isPreviewForSingleSelectionSupported as boolean ?? true;
    params.singleSelectionMode = wantParam?.singleSelectionMode as number ?? 0;
    params.isRepeatSelectSupported = wantParam?.isRepeatSelectSupported as boolean ??
      params.isRepeatSelectSupported ?? false;
    params.pickerIndex = wantParam?.pickerIndex as number ?? params.pickerIndex ?? -1 ;
    params.preselectedInfos = wantParam?.preselectedInfos as PreselectedInfo[] ?? params.preselectedInfos ?? [];
    // 如果外部应用传入了 completeButtonText，使用传入的值；否则根据 bundleName 自动设置
    if (wantParam?.completeButtonText !== undefined && wantParam?.completeButtonText !== null) {
      params.completeButtonText = wantParam?.completeButtonText as number;
    } else {
      params.completeButtonText = this.getCompleteButtonTextByBundleName(params.bundleName);
    }
    if (params.isFromPickerView) {
      this.parsePickerViewParam(params, wantParam, pickerOptions);
      this.storage?.setOrCreate(Constants.IS_FROM_PICKER_VIEW, params.isFromPickerView);
    }
    this.parseRecommendType(params, wantParam);
  }

  private updateParamsByPickerOptions(params: SelectParams, pickerOptions: Record<string, Object> | undefined): void {
    if (!pickerOptions) {
      return;
    }
    params.filterMediaType = pickerOptions?.['MIMEType'] as string ?? params.filterMediaType;
    params.cameraAble = pickerOptions?.['isPhotoTakingSupported'] as boolean ?? params.cameraAble;
    params.editAble = pickerOptions?.['isEditSupported'] as boolean ?? params.editAble;
    params.searchAble = pickerOptions?.['isSearchSupported'] as boolean ?? params.searchAble;
    params.preData = pickerOptions?.['preselectedUris'] as string[] ?? params.preData;
    params.isRepeatSelectSupported = pickerOptions?.['isRepeatSelectSupported'] as boolean ?? params.isRepeatSelectSupported;
    params.maxSelectCount = pickerOptions?.['maxSelectNumber'] as number ?? params.maxSelectCount;
    params.maxPhotoSelectNumber = pickerOptions?.['maxPhotoSelectNumber'] as number ?? params.maxPhotoSelectNumber;
    params.maxVideoSelectNumber = pickerOptions?.['maxVideoSelectNumber'] as number ?? params.maxVideoSelectNumber;
    params.maxSelectedReminderMode = pickerOptions?.['maxSelectedReminderMode'] as number ?? params.maxSelectedReminderMode;
    params.photoBrowserBackgroundColorMode = pickerOptions?.['photoBrowserBackgroundColorMode'] as number ??
      params.photoBrowserBackgroundColorMode;
    params.checkBoxColor = pickerOptions?.['checkBoxColor'] as string ?? params.checkBoxColor;
    params.checkboxTextColor = pickerOptions?.['checkboxTextColor'] as string ?? params.checkboxTextColor;
    params.backgroundColor = pickerOptions?.['backgroundColor'] as string ?? params.backgroundColor;
    params.orientation = pickerOptions?.['orientation'] as PickerOrientation ?? params.orientation;
    params.singleLineConfig = pickerOptions?.['singleLineConfig'] as SingleLineConfig ?? params.singleLineConfig;
    params.isSlidingSelectionSupported = pickerOptions?.['isSlidingSelectionSupported'] as boolean ??
      params.isSlidingSelectionSupported;
    params.photoBrowserCheckboxPosition = pickerOptions?.['photoBrowserCheckboxPosition'] as [number, number] ??
      params.photoBrowserCheckboxPosition;
    params.gridMargin = pickerOptions?.['gridMargin'] as Margin ?? params.gridMargin;
    params.photoBrowserMargin = pickerOptions?.['photoBrowserMargin'] as Margin ?? params.photoBrowserMargin;
    params.pickerIndex = pickerOptions?.['pickerIndex'] as number ?? params.pickerIndex;
    params.preselectedInfos = pickerOptions?.['preselectedInfos'] as PreselectedInfo[] ?? params.preselectedInfos;
  }

  /**
   * 根据调用方的 bundleName 自动设置完成按钮的文字
   */
  private getCompleteButtonTextByBundleName(bundleName: string): number {
    if (!bundleName) {
      return ThirdSelectConstants.COMPLETE_BUTTON_TEXT_DONE;
    }
    // 聊天应用("发送")
    const chatKeywords = ['message', 'chat', 'messenger', 'wechat', 'qq'];
    const lowerBundleName = bundleName.toLowerCase();
    for (let keyword of chatKeywords) {
      if (lowerBundleName.includes(keyword)) {
        Log.info(TAG, `BundleName ${bundleName} detected as chat app, set button text to SEND`);
        return ThirdSelectConstants.COMPLETE_BUTTON_TEXT_SEND;
      }
    }
    // 相册应用(“添加”)
    const albumKeywords = ['album', 'gallery'];
    for (let keyword of albumKeywords) {
      if (lowerBundleName.includes(keyword) && !lowerBundleName.includes('photos')) {
        Log.info(TAG, `BundleName ${bundleName} detected as album app, set button text to ADD`);
        return ThirdSelectConstants.COMPLETE_BUTTON_TEXT_ADD;
      }
    }
    // 默认显示"完成"
    return ThirdSelectConstants.COMPLETE_BUTTON_TEXT_DONE;
  }

  private async parsePickerViewParam(params: SelectParams, wantParam: Record<string, Object>,
    pickerOptions?: Record<string, Object>): Promise<void> {
    params.preData = pickerOptions?.['preselectedUris'] as string[] ?? wantParam?.preselectedUri as string[];
    this.parsePickerViewParam1(params, wantParam, pickerOptions);
    params.maxSelectedReminderMode = pickerOptions?.['maxSelectedReminderMode'] as number ??
      wantParam?.maxSelectedReminderMode as number ?? params.maxSelectedReminderMode ?? Constants.TOAST_REMIND_MODE;
    params.photoBrowserBackgroundColorMode = pickerOptions?.['photoBrowserBackgroundColorMode'] as number ??
      wantParam?.photoBrowserBackgroundColorMode as number ?? params.photoBrowserBackgroundColorMode ?? 0;
    params.isSlidingSelectionSupported = pickerOptions?.['isSlidingSelectionSupported'] as boolean ??
      wantParam?.isSlidingSelectionSupported as boolean ?? params.isSlidingSelectionSupported;
    params.photoBrowserCheckboxPosition = pickerOptions?.['photoBrowserCheckboxPosition'] as [number, number] ??
      wantParam?.photoBrowserCheckboxPosition as [number, number] ?? params.photoBrowserCheckboxPosition ?? [0, 0];
    params.gridMargin = pickerOptions?.['gridMargin'] as Margin ?? wantParam?.gridMargin as Margin ??
      params.gridMargin ?? {};
    params.photoBrowserMargin = pickerOptions?.['photoBrowserMargin'] as Margin ?? wantParam?.photoBrowserMargin as Margin ??
      params.photoBrowserMargin ?? {};
    params.gridStartOffset = wantParam?.gridStartOffset as number ?? 0;
    params.gridEndOffset = wantParam?.gridEndOffset as number ?? 0;
    if (params.gridStartOffset > 0 || params.gridEndOffset > 0) {
      const offsetMsg: Record<string, number | string | boolean> = {
        'BUNDLENAME': params.bundleName,
        'START_OFFSET': params.gridStartOffset,
        'END_OFFSET': params.gridEndOffset
      };
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_COMP_BROWSE_MODE, offsetMsg);
    }
    params.orientation = pickerOptions?.['orientation'] as PickerOrientation ??
      wantParam?.orientation as PickerOrientation ?? params.orientation ?? PickerOrientation.VERTICAL;
    params.singleLineConfig = pickerOptions?.['singleLineConfig'] as SingleLineConfig ??
      wantParam?.singleLineConfig ? wantParam?.singleLineConfig as SingleLineConfig : params.singleLineConfig ?? undefined;
    params.uiComponentColorMode = wantParam?.uiComponentColorMode as number ?? PickerColorMode.AUTO;
    Log.info(TAG, 'parsePickerViewParam uiComponentColorMode = ' + params.uiComponentColorMode);
    if (params.uiComponentColorMode !== PickerColorMode.AUTO) {
      const msg: Record<string, number | string | boolean> = {
        'BUNDLENAME': params.bundleName,
        'UICOMPONENT_COLOR_MODE': params.uiComponentColorMode,
      };
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_COMP_BROWSE_MODE, msg);
    }
    // 支持2D PhotoPicker宫格、大图显示自定义
    // 注意：由于Builder函数无法序列化，无法通过want参数直接传递自定义构建器函数
    // 当前通过以下参数支持自定义显示：
    // 
    // 宫格显示自定义字段：
    // - gridMargin: Margin类型，宫格边距（支持通过pickerOptions或wantParam传递）
    // - gridStartOffset: number类型，宫格起始偏移量
    // - gridEndOffset: number类型，宫格结束偏移量
    // - orientation: PickerOrientation类型，显示方向（VERTICAL/HORIZONTAL）
    // - singleLineConfig: SingleLineConfig类型，单行显示配置
    // - backgroundColor: string类型，背景颜色
    // 
    // 大图显示自定义字段：
    // - photoBrowserMargin: Margin类型，大图边距（支持通过pickerOptions或wantParam传递）
    // - photoBrowserBackgroundColorMode: number类型，大图背景颜色模式
    // - photoBrowserCheckboxPosition: [number, number]类型，大图复选框位置
    // - isPhotoBrowserCheckboxVisible: boolean类型，是否显示大图复选框
    // - isPhotoBrowserBackButtonVisible: boolean类型，是否显示大图返回按钮
    // 
    // 其他自定义字段：
    // - checkBoxColor: string类型，复选框颜色
    // - checkboxTextColor: string类型，复选框文字颜色
    // - maxSelectedReminderMode: number类型，超出最大选择数量提醒模式
    // - isSlidingSelectionSupported: boolean类型，是否支持滑动选择
    // - uiComponentColorMode: number类型，UI组件颜色模式
    // 
    // 如需更高级的自定义功能，可通过配置参数来实现
    Log.info(TAG, 'parsePickerViewParam: 2D PhotoPicker custom display support enabled');
  }

  private async parseContextRecoveryInfo(params: SelectParams, wantParam: Record<string, Object>): Promise<void> {
    Log.info(TAG, `Initinal contextRecoveryInfo is ${JSON.stringify(wantParam?.contextRecoveryInfo)}`)
    if (!wantParam?.contextRecoveryInfo) {
      return;
    }
    if (Reflect.get(wantParam?.contextRecoveryInfo, 'albumUri') === '') {
      Log.info(TAG, `albumUri is undefined, recover scene is not supported.`)
      return;
    }
    let msg: Record<string, string> = {
      'BUNDLENAME': params.bundleName,
    };
    ReportToBigDataUtil.report(BigDataConstants.SET_CONTEXT_RECOVERY_INFO, msg);
    try {
      let contextRecoveryInfo: ContextRecoveryInfo = wantParam.contextRecoveryInfo as ContextRecoveryInfo;
      params.albumUriForRecover = contextRecoveryInfo.albumUri;
      params.albumUri = contextRecoveryInfo.albumUri;
      if (typeof contextRecoveryInfo.time === 'string') {
        params.timeAnchorForRecover = parseInt(contextRecoveryInfo.time);
      } else {
        params.timeAnchorForRecover = contextRecoveryInfo.time;
      }
      params.displayNameForRecover = contextRecoveryInfo.displayName;
      params.recommendationTypeForRecover = contextRecoveryInfo.recommendationType;
      params.selectedRecommendationType = contextRecoveryInfo.selectedRecommendationType;
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Log.info(TAG, `ParseContextRecoveryInfo failed, error code ${code}, error msg ${message}.`);
    }
    params.recoverSceneEnabled = true;
    let dataIndexForRecover: number =
      await this.initRecoverInfo.getAnchorDataIndexForRecover(params, UserFileManagerAccess.getInstance(this.storage));
    Log.info(TAG, `get dataIndexForRecover done, dataIndexForRecover is: ${dataIndexForRecover}`);
    params.hasGotRecoverAnchor = true;
    params.dataIndexForRecover = dataIndexForRecover;
    this.appBroadCast.emit(BroadCastConstants.UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR, [dataIndexForRecover]);
  }

  private async parseRecommendType(params: SelectParams, wantParam: Record<string, Object>): Promise<void> {
    if (!wantParam?.recommendationOptions) {
      Log.info(TAG, 'parseRecommendType recommend options is invalid');
      return;
    }
    let recommendationOptions: photoAccessHelper.RecommendationOptions = wantParam.recommendationOptions;
    let recommendationType: number | undefined = recommendationOptions.recommendationType;
    if (!recommendationType) {
      Log.info(TAG, 'parseRecommendType without recommendationType');
      return;
    }
    if (!Object.values(photoAccessHelper.RecommendationType).includes(recommendationType)) {
      Log.info(TAG, 'parseRecommendType with inValid recommendationType');
    }
    let isTextInValid: boolean = StringUtil.isInvalid(recommendationOptions.textContextInfo?.text);
    if (!isTextInValid) {
      Log.info(TAG, 'parseRecommendType with textInfo');
      return;
    }
    Log.info(TAG, `parseRecommendType with recommendationType : ${recommendationType}`);
    params.recommendationType = recommendationType;
  }

  private async parsePickerViewParam1(params: SelectParams, wantParam: Record<string, Object>,
    pickerOptions?: Record<string, Object>): Promise<void> {
    let pickerViewSelectMode: number = pickerOptions?.['selectMode'] as number ??
      wantParam?.selectMode as number ?? 1;
    if (!pickerViewSelectMode) {
      params.isMultiPick = false;
    } else {
      params.isMultiPick = true;
    }
    if (params.isMultiPick) {
      const maxSelectNumber = pickerOptions?.['maxSelectNumber'] as number ?? wantParam?.maxSelectNumber as number;
      params.maxSelectCount = (maxSelectNumber !== undefined && maxSelectNumber >= 0) ?
        maxSelectNumber : params.maxSelectCount ?? Constants.LIMIT_MAX_THIRD_SELECT_COUNT;
      const maxPhotoSelectNumber = pickerOptions?.['maxPhotoSelectNumber'] as number ??
        wantParam?.maxPhotoSelectNumber as number;
      params.maxPhotoSelectNumber =
        (maxPhotoSelectNumber !== undefined && maxPhotoSelectNumber >= 0) ?
          maxPhotoSelectNumber : params.maxPhotoSelectNumber ?? Constants.LIMIT_MAX_THIRD_SELECT_PHOTO_COUNT;
      const maxVideoSelectNumber = pickerOptions?.['maxVideoSelectNumber'] as number ??
        wantParam?.maxVideoSelectNumber as number;
      params.maxVideoSelectNumber =
        (maxVideoSelectNumber !== undefined && maxVideoSelectNumber >= 0) ?
          maxVideoSelectNumber : params.maxVideoSelectNumber ?? Constants.LIMIT_MAX_THIRD_SELECT_VIDEO_COUNT;
    } else {
      params.maxSelectCount = 1;
      params.maxPhotoSelectNumber = 1;
      params.maxVideoSelectNumber = 1;
    }
  }

  private setPhotoViewMimeTypeFilter(params: SelectParams, wantParam: Record<string, Object>): void {
    params.photoViewMimeTypeFilter = wantParam?.mimeTypeFilter as photoAccessHelper.MimeTypeFilter;
    if (params.photoViewMimeTypeFilter) {
      if (!params.photoViewMimeTypeFilter.mimeTypeArray) {
        params.photoViewMimeTypeFilter.mimeTypeArray = [];
      }
      if (params.photoViewMimeTypeFilter.mimeTypeArray.length > 10) {
        params.photoViewMimeTypeFilter.mimeTypeArray = params.photoViewMimeTypeFilter.mimeTypeArray.slice(0, 10);
      }
      // 当配置MIMETypeFilter参数时，MIMEType的配置自动失效
      params.filterMediaType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    }
    Log.info(TAG, `params.photoViewMimeTypeFilter=${toString(params.photoViewMimeTypeFilter)}`)
  }

  /**
   * 校验combinedMediaTypeFilter是否合法，非法捕获异常，后续操作终止
   * @param params
   */
  private checkCombinedMediaTypeFilter(params: SelectParams): void {
    try {
      let parsedPhotoTypeArray: MediaTypeFilter[] = new PickerAlbumsFilterEnhanceBuilder(undefined,
        this.storage).parsePhotoTypeArray(params?.combinedMediaTypeFilter ?? []);
      Log.info(TAG, `parsedPhotoTypeArray = ${toString(parsedPhotoTypeArray)}`);
    } catch (e) {
      if (e instanceof Error) {
        Log.error(TAG, `combinedMediaTypeFilter error message is: ${e.message}`);
      } else {
        Log.error(TAG, `unknown type of error caught.`);
      }
      params.isCombinedMediaTypeFilterError = true;
      this.storage?.setOrCreate(Constants.IS_PHOTO_PICKER_COMBINED_FILTER_ERROR,
        params.isCombinedMediaTypeFilterError);
      return;
    }
  }

  private setCombinedMediaTypeFilter(params: SelectParams, wantParam: Record<string, Object>): void {
    if (!wantParam?.combinedMediaTypeFilter) {
      Log.warn(TAG, 'combinedMediaTypeFilter is undefined!');
      return;
    }
    params.combinedMediaTypeFilter = wantParam?.combinedMediaTypeFilter as Array<string>;
    if (params.combinedMediaTypeFilter) {
      this.checkCombinedMediaTypeFilter(params);

      if (params?.combinedMediaTypeFilter.length > Constants.PICKER_FILTER_LIMIT_SIZE) {
        params.combinedMediaTypeFilter = params.combinedMediaTypeFilter.slice(0, Constants.PICKER_FILTER_LIMIT_SIZE);
      }
      // 当配置combinedMediaTypeFilter参数时，MIMEType和MIMETypeFilter的配置自动失效
      params.filterMediaType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
      params.photoViewMimeTypeFilter = undefined;
    }
    Log.info(TAG, `params.combinedMediaTypeFilter=${toString(params.combinedMediaTypeFilter)}`);
  }

  private setFilterMediaType(params: SelectParams, wantParam: Record<string, Object>): void {
    let filterType = wantParam?.filterType as photoAccessHelper.PhotoViewMIMETypes;
    Log.info(TAG, `wantParam?.filterMediaType=${wantParam?.filterType}`)
    if (!filterType) {
      params.filterMediaType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    }
    params.filterMediaType = AlbumDefine.getFilterMediaTypeUpperCase(filterType);
  }

  private async isMainSpace(): Promise<boolean> {
    //不是跨用户访问直接返回false
    try {
      const manager: osAccount.AccountManager = osAccount.getAccountManager();
      const osAccountType = await manager.getOsAccountType();
      Log.info(TAG, `osAccountType: ${osAccountType.toString()}`);
      //若为主空间跨用户访问私有空间则需要屏蔽
      return osAccountType !== osAccount.OsAccountType.PRIVATE;
    } catch (e) {
      Log.error(TAG, `isMainSpace check failed: ${e.message}`)
      return true;
    }
  }
}