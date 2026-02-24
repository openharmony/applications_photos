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

import lazy audio from '@ohos.multimedia.audio';
import lazy UIAbility from '@ohos.app.ability.UIAbility';
import lazy AbilityConstant from '@ohos.app.ability.AbilityConstant';
import lazy wantConstant from '@ohos.ability.wantConstant';
import lazy data_preferences from '@ohos.data.preferences';
import lazy common from '@ohos.app.ability.common';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy router from '@ohos.router';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy {
  AlbumSetDataSourceManager
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSourceManager';
import lazy {
  BigDataConstants,
  ReportToBigDataUtil
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { DaySubType } from '@ohos/common/src/main/ets/default/model/common/DaySubType';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy {
  Constants,
  ViewType,
  SubjectType,
  CoursesParams
} from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { UserConstraintUtil } from '@ohos/common/src/main/ets/default/utils/UserConstraintUtil';
import lazy { Heic2JPGManagerAccess } from '@ohos/common/src/main/ets/default/access/Heic2JPGManagerAccess';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy {
  getScreen,
  ScreenManager,
  setHorizontal
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy lockedScreenMgr from '@ohos/common/src/main/ets/default/utils/LockedScreen';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { NetworkConnectionAccess } from '@ohos/privacy/src/main/ets/access/NetworkConnectionAccess';
import lazy { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import lazy { reportEmpty } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { StatusBarColorController } from '@ohos/common/src/main/ets/default/model/common/StatusBarColorController';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy {
  PhotoAlbum,
  PhotoAsset,
  UserFileManagerAccess
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { SendablePhotoAccessHelper } from '@ohos/common/src/main/ets/default/access/SendablePhotoAccessHelper';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { TimeLineModelManager } from '@ohos/common/src/main/ets/default/view/TimeLineModelManager';
import lazy systemParameterEnhance from '@ohos.systemParameterEnhance';
import lazy { ValueType } from '@ohos.data.ValuesBucket';
import lazy { BusinessError } from '@ohos.base';
import lazy Want from '@ohos.app.ability.Want';
import lazy window from '@ohos.window';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy Bundles from '@ohos/tools/src/main/utils/Bundle';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { errors } from '@ohos/tools/src/main/utils/errors';
import lazy { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import lazy { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy settings from '@ohos.settings';
import lazy { JumpSourceToMain } from '@ohos/common/src/main/ets/default/model/browser/photo/JumpSourceToMain';
import lazy { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { TimelineDataSourceManager } from '@ohos/timeline/src/main/ets/model/TimelineDataSourceManager';
import lazy display from '@ohos.display';
import lazy { accessibility } from '@kit.AccessibilityKit';
import lazy { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';
import lazy { rpc } from '@kit.IPCKit';
import lazy contextConstant from '@ohos.app.ability.contextConstant';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { AlbumRatioUtils } from '@ohos/common/src/main/ets/default/utils/AlbumRatioUtils';
import lazy { AlbumGridSortHelper } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { FormControllerManager } from '@ohos/dataprovider/src/main/ets/controller/FormControllerManager';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { RelationStoreUtil } from '@ohos/common/src/main/ets/default/utils/RelationStoreUtil';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { AccessUtil } from '@ohos/dataprovider/src/main/ets/AccessUtil';
import lazy { PromiseDivider } from '@ohos/dataprovider/src/main/ets/promise/PromiseDivider';
import lazy { AgreementConfig } from '@ohos/privacy/src/main/ets/about/AgreementConfig';
import lazy FaCardService from '@ohos/dataprovider/src/main/ets/database/service/FaCardService';
import lazy { AlbumType } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable'

export interface FormEditorParams {
  interval?: number,
  isShowAlbumName?: number,
  albumUri?: string,
  albumName?: string,
  cardType: AlbumType,
}

/* instrument ignore next */
@Concurrent
async function preLoad(): Promise<void> {
  Log.info('CommonAbility', 'preLoad import lazy so start');
  await import('@ohos.arkui.advanced.SubHeader');
  await import('@ohos.telephony.call');
  await import('@ohos.arkui.advanced.Chip');
  await import('@ohos.fileshare');
  await import('@ohos.arkui.modifier');
    await import('@ohos.print');
  await import('@ohos.font');
  await import('@ohos.arkui.performanceMonitor');
    await import('@ohos.userIAM.userAuth');
  await import('@ohos.arkui.componentUtils');
  await import('@ohos.multimodalInput.inputConsumer');
  await import('@ohos.multimodalInput.keyCode');
    await import('@ohos.arkui.advanced.Dialog');
  await import('@ohos.multimodalInput.pointer');
  await import('@ohos.filemanagement.userFileManager');
    await import('@ohos.events.emitter');
  await import('@ohos.multimedia.movingphotoview');
  await import('@ohos.util.TreeSet');
      Log.info('CommonAbility', 'preLoad import lazy so end');
}

const TAG: string = 'CommonAbility';
const ITEM_AIR_SHARE_SWITCH = 'item_air_share_switch';
// 为1时，代表隔空分享能力打开
const IS_SWING_SHARE_OPEN = '1';
const LARGE_PICTURE_BROWSING_STATUS = 'large_picture_browsing_status';

const BROWSING_STATUS_ZERO = '0';

let isFromCard = false;
let isFromMomentCard = false;
let isFromViewData = false;
let isFromCardDefault = false;
let isFromCamera = false;
let isFromPetalClip = false;
let isFromCardEditor = false;
let mCallerBundleName: string = '';
let mMaxSelectCount: number = 0;
let mFilterMediaType: string = AlbumDefine.FILTER_MEDIA_TYPE_ALL;
let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
let isShowMenuFromThirdView: boolean;
let cameraAble: boolean = true;
let editAble: boolean = true;
let searchAble: boolean = true;
let preData: string[] = [];
let isShowSerialNum: boolean = false;
let searchWord: String;
let reqFromFileMgr: string;
let albumInfo: AlbumInfo;
let albumInfoForMe: AlbumInfo;
let targetPageId: number = 0;
let tabName: string;
let albumLpathName: string;
let settingComponentId: string;
let mediaItem: MediaItem;
// let location: mapCommon.LatLng;
let courses: CoursesParams;
let isFromFormPortrait = false;
let isFromFormProfile = false;

export default abstract class CommonAbility extends UIAbility {
  protected storage: LocalStorage = new LocalStorage();
  private formCurrentUri: string = Constants.NULL_STRING;
  private formCurrentAlbumUri: string = Constants.NULL_STRING;
  private formAlbumUriChanged: boolean = false;
  private formId: string = '';
  private isOnDestroy: boolean = false;
  private isOnNewWant: boolean = false;
  public isFromPicker: boolean = false;
  private originOrientation: number = 0;
  private onLeftBlankChangedFunc: Function = (data: number[]): void => this.onLeftBlankChanged(data);
  private onSplitModeChangedFunc: Function = (mode: boolean): void => this.onSplitModeChanged(mode);
  private audioManager: audio.AudioManager = audio.getAudioManager();
  private audioVolumeManager: audio.AudioVolumeManager = this.audioManager.getVolumeManager();
  private networkConnectionStatus: boolean = true;
  private onWindowStageEventFunc: Callback<window.WindowStageEventType> =
    (type: window.WindowStageEventType): void => this.onWindowStageEvent(type);

  abstract getTimelineDataSourceManagerInstance(): void;

  private onLeftBlankChanged(data: number[]): void {
    Log.info(TAG, `onleftBlankChanged: ${data}`);
    AppStorage.setOrCreate('leftBlank', data);
  }

  /* instrument ignore next */
  private onSplitModeChanged(mode: boolean): void {
    Log.info(TAG, `onSplitModeChanged: ${JSON.stringify(mode)}`);
    ReportToBigDataUtil.report(BigDataConstants.SPLIT_SCREEN_ID, undefined);
    AppStorage.setOrCreate('isSplitMode', mode);
  }

  onCreate(want: Want, param: AbilityConstant.LaunchParam): void {
    Log.info(TAG, `Application onCreate start, isTraceEnabled: ${TraceControllerUtils.isTraceEnabled()}`);
    let applicationContext = this.context.getApplicationContext();
    try {
      applicationContext.setSupportedProcessCache(true);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(`setSupportedProcessCache fail, code: ${code}, msg: ${message}`);
    }
    ReportToBigDataUtil.report(BigDataConstants.ABILITY_START);
    this.formId = want.parameters?.formID ? String(want.parameters.formID) :
      want.parameters?.formId ? String(want.parameters.formId) : '';
    this.checkWantIsFromFa(want);
    Log.info(TAG, 'CommonAbility onCreate formId ' + this.formId);
    //应用冷启动打点
    let reportLabel: string = 'drawnCompleted reportTime:';
    let reportTaskId: number = new Date().getTime();
    Global.setString('appStartDrawnCompletedReportLabel', reportLabel);
    Global.setNumber('appStartDrawnCompletedReportTaskId', reportTaskId);
    TraceControllerUtils.startTraceWithTaskId(reportLabel + reportTaskId, reportTaskId);
    // 子线程加载so
    taskpool.execute(preLoad).then((res): void => {
      Log.info(TAG, `preLoad res：${res}`);
    }).catch((error: string): void => {
      Log.error(TAG, `preLoad error：${error}`);
    })
    //系统音量
    AppStorage.setOrCreate('isMute', false);
    AppStorage.setOrCreate<boolean>('IsShowSearchPage', false);
    this.registerAudioEvent();
    // LocalStorage.getShared() 暂不可用
    Global.setBoolean('canGetSharedStorage', false);
    // 获取进程沙盒目录
    AppStorage.setOrCreate('filesDir', this.context.filesDir);
    this.storage?.setOrCreate('photosAbilityContext', this.context);
    AppStorage.setOrCreate('formContext', this.context);
    AppStorage.setOrCreate<boolean>('pageShowFlag', false);
    global.setCtx(this.context);
    this.isOnDestroy = false;
    this.setIsFromPicker(want);
    NetworkConnectionAccess.register();
    this.initPhotosPref();
    systemParameterEnhance.get('const.photos.enable_piano', 'true').then((value: string): void => {
      Log.info(TAG, `const.photos.enable_piano = ${value}`);
      AppStorage.setOrCreate(Constants.ENABLE_PIANO, value);
    });

    systemParameterEnhance.get('system.photos.rotate.enable', 'true').then((value: string): void => {
      Log.info(TAG, `system.photos.rotate.enable = ${value}`);
      AppStorage.setOrCreate<boolean>(Constants.ENABLE_ROTATE, value === 'true');
    });

    systemParameterEnhance.get('system.photos.innerpic.enable', 'false').then((value: string): void => {
      Log.info(TAG, `system.photos.innerpic.enable = ${value}`);
      AppStorage.setOrCreate<boolean>(Constants.ENABLE_INNERPIC, value === 'false');
    });

    settings.getValue(this.context, 'device_enable_retail').then((value) => {
      Log.info(TAG, `device_enable_retail = ${value}`);
      AppStorage.setOrCreate<boolean>(Constants.DEVICE_ENABLE_RETAIL, value === 'true');
    });

    UserConstraintUtil.initConstraints();

    //设置ai分析模式
    Global.setBoolean('aicontroller', true);

    // 是否自动播放，当前默认全为非自动播放，后续待评估是否允许用户设置
    Global.setBoolean('autoPlayEnable', false);
    setTimeout(() => {
      let context: common.Context | undefined = this.storage?.get<common.UIAbilityContext>('photosAbilityContext');
      UserFileManagerAccess.getInstance()
        .onCreate(context, (isForced?: boolean) => {
          Log.info(TAG, `onCreate callback`)
          MediaObserver.getInstance().subscribe(context, TAG);
          TraceControllerUtils.startTrace('judgeAlbumAreaIsValid');
          // 初始化相册区域是否有效
          TraceControllerUtils.finishTrace('judgeAlbumAreaIsValid');
          if (isForced) {
            MediaObserver.getInstance().forceNotify();
          }
        });
      SendablePhotoAccessHelper.getInstance().onCreate(context);
    }, 0);

    this.checkWantIsFromViewData(want);
    const entry = this.parseWantParameter(false, want);
    Log.info(TAG, `thirdRouterPage entry: ${entry}, entryFromHap: ${AppStorage.get('entryFromHap')},`);
    this.checkAndReportSubType();
    appBroadCast.on(BroadCastConstants.COMMON_ABILITY_DATA_INIT, (): void => this.initData());

    AppStorage.setOrCreate<TimeLineModelManager>('TimeLineModelManager', TimeLineModelManager.getInstance());
    DataStoreUtil.getInstance().getData('albumStyle', '').then((value: ValueType): void => {
      AppStorage.setOrCreate(Constants.albumScreenScale, value);
    });
    AppStorage.setOrCreate<boolean>(Constants.OPEN_TOUCH_GUIDE, accessibility.isOpenTouchGuideSync());
    accessibility.on('accessibilityStateChange', (state: boolean) => {
      AppStorage.setOrCreate<boolean>(Constants.OPEN_TOUCH_GUIDE, state);
    });
    Log.info(TAG, 'Application onCreate end');
  }

  // 保证升级用户正常使用，如果同意过隐私并且对应key值不存在，就要主动写入setting
  private async initAnalysisParam() {
    Log.info(TAG, `initAnalysisParam`);
    // 图库网络连接
    settings.getValue(this.context, 'photo_network_connection_status').then((networkConnectionStatus: string) => {
      Log.info(TAG, `current photo_network_connection_status:${networkConnectionStatus}`);
    }, () => {
    })
    // 媒体智慧分析
    settings.getValue(this.context, 'analysis_service_switch_on').then((analysisService: string) => {
      Log.info(TAG, `current analysis_service_switch_on:${analysisService}`);
    }, () => {
    });
  }

  private isAccessedFullGuide(): boolean {
    let isAccessCloudPage: boolean = true;
    if (!DeviceInfo.isPc()) {
      let isCloudPageTmp: boolean = Protocol.get<boolean>(Constants.FULL_SCREEN_GUIDE, false);
      isAccessCloudPage = isCloudPageTmp;
    }
    return isAccessCloudPage;
  }

  private reportSubTypeByBigData(): void {
    DataStoreUtil.getInstance().getData(Constants.DAY_PERSISTENT_KEY, DaySubType.NORMAL)
      .then((value: ValueType): void => {
        const valueNumber: number = parseInt(value.toString());
        if (Number.isFinite(valueNumber)) {
          if (valueNumber === DaySubType.NORMAL) {
            const msg: Record<string, number | string | boolean> = {
              'daySubType': BigDataConstants.NORMAL_TYPE_DAY_VIEW
            };
            ReportToBigDataUtil.report(BigDataConstants.RECORD_DAY_SUBTYPE, msg);
            Log.info(TAG, `reportSubType NORMAL, ${Date.now().valueOf()}`);
          } else {
            const msg: Record<string, number | string | boolean> = {
              'daySubType': BigDataConstants.GROUP_TYPE_DAY_VIEW
            };
            ReportToBigDataUtil.report(BigDataConstants.RECORD_DAY_SUBTYPE, msg);
            Log.info(TAG, `reportSubType GROUP, ${Date.now().valueOf()}`);
          }
          try {
            DataStoreUtil.getInstance().putData(Constants.RECORD_TIME_PERSISTENT_KEY, Date.now().valueOf());
            DataStoreUtil.getInstance().flush();
          } catch (err) {
            Log.info(TAG, `restoreRecordDaySubTypeTime error: ${err}`);
          }
        }
      });
  }

  private checkAndReportSubType(): void {
    DataStoreUtil.getInstance().getData(Constants.RECORD_TIME_PERSISTENT_KEY, '0').then((value: ValueType): void => {
      if ('0' === value.toString()) {
        Log.info(TAG, 'reportSubType firstTime');
        this.reportSubTypeByBigData();
        return;
      }
      const valueNumber: number = parseFloat(value.toString());
      if (Number.isFinite(valueNumber)) {
        Log.info(TAG, `reportSubType lastTime ${valueNumber}`);
        if (Date.now().valueOf() - valueNumber > 86400000) {
          this.reportSubTypeByBigData();
        }
      } else {
        Log.error(TAG, `reportSubType parseError ${valueNumber}`);
      }
    });
  }

  private initNetworkStatus(): void {
  }

  private isNeedInitIndexPageAssert(): boolean {
    return !isFromCardEditor && !isFromCardDefault && !isFromCard && !isFromCamera && !isFromPetalClip;
  }

  private initData(): void {
    Log.warn(TAG, 'initData start');
    if (this.isNeedInitIndexPageAssert()) {
      this.getTimelineDataSourceManagerInstance();
    }

    // Init system album information
    UserFileManagerAccess.getInstance().prepareSystemAlbums().then((): void => {
      Log.info(TAG, 'prepareSystemAlbums end');
      if (this.isNeedInitIndexPageAssert()) {
        AlbumSetDataSourceManager.getInstance();
      }
      appBroadCast.on(BroadCastConstants.THIRD_ROUTE_PAGE, (): Promise<void> => this.thirdRouterPage());
      if (AppStorage.get<boolean>('pageShowFlag')) {
        this.thirdRouterPage();
      }
    });
  }

  private setIsFromPicker(want: Want): void {
    Log.info(TAG, `setIsFromPicker`);
    let uri = assert.asDefault(want.parameters?.uri, '');
    this.isFromPicker = uri === Constants.WANT_PARAM_URI_SELECT_SINGLE ||
      uri === Constants.WANT_PARAM_URI_SELECT_MULTIPLE;
  }

  onNewWant(want: Want): void {
    Log.info(TAG, `want=${JSON.stringify(want)}`);
    let isFromSubScreen = assert.asDefault(want.parameters?.isFromSubScreen, false);
    if (want.parameters?.currentUri && !isFromSubScreen) {
      this.routerFa(want);
      this.storage.setOrCreate<boolean>(Constants.KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_FA_CARD, false);
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_MOMENT_CARD, false);
      AppStorage.setOrCreate<string>('cameraShotKey', '');
      LocalStorage.getShared()?.delete('is_from_sub_screen');
      return;
    }
    this.formId = want.parameters?.formId as string;
    // 人像卡片跳转人像宫格
    if (want.parameters?.uri === Constants.WANT_PARAM_URI_FORM_PROFILE) {
      let photoGridAppearArray: string[] =
        AppStorage.get<string[]>(Constants.PHOTO_GRID_BASE_PAGE_APPEAR) ?? new Array();
      // 如果正在显示宫格，仅更新宫格
      if (photoGridAppearArray[photoGridAppearArray.length - 1] !== undefined) {
        Log.info(TAG, `PHOTO_GRID_BASE_PAGE_APPEAR, ${this.formId} update photoGridBasePage `);
        appBroadCast.emit(BroadCastConstants.UPDATE_PHOTO_GRID_BASE_PAGE,
          [want.parameters?.formId, want.parameters?.albumUri]);
        return;
      }
      // 重新跳转宫格
      let options: router.RouterOptions = {
        url: this.getPortraitPath(),
        params: {
          formId: want.parameters?.formId,
          albumUri: want.parameters?.albumUri,
          isFromFormProfile: true,
        }
      }
      AppStorage.get<Router>('router')?.pushUrl(options);
      return;
    }

    this.storage.setOrCreate<boolean>(Constants.KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_FA_CARD, true);
    AppStorage.setOrCreate<boolean>(Constants.KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_MOMENT_CARD, true);

    this.formId = want.parameters?.formID ? String(want.parameters.formID) : want.parameters?.formId ?
      String(want.parameters.formId) : '';
    if (lockedScreenMgr().isFromLockedScreen) {
      Log.error(TAG, 'call form LockedScreen');
      if (want.parameters && !Bundles.isFromCamera(want.parameters)) {
        Log.error(TAG, 'call NOT form Camera');
        lockedScreenMgr().onExit(false, true, TAG);
      }
    }
    DeviceInfo.isPhoneUx() && AppStorage.setOrCreate(Constants.CURRENT_TIME, new Date().getTime());
    if (this.isOnDestroy) {
      Log.error(TAG, 'Application is already on isOnDestroy, do nothing in onNewWant');
      return;
    }
    try {
      this.originOrientation = display.getDefaultDisplaySync().orientation;
    } catch (error) {
      Log.error(TAG, `getDefaultDisplaySync failed, error: ${error}, code: ${error?.code}`);
    }
    Log.info(TAG, `display orientatio=${this.originOrientation}`);
    this.setIsFromPicker(want);
    this.checkWantIsFromFa(want, true);
    Log.info(TAG, `onNewWant checkWantIsFromFa: ` + isFromCard);
    this.checkWantIsFromViewData(want);
    this.parseWantParameter(true, want);
    this.thirdRouterPage();
    Log.info(TAG, 'Application onNewWant end');
  }

  private getPortraitPath(): string {
    return 'FormAbility/view/CoverPage';
  }

  routerFa(want: Want) {
    Log.info(TAG, `routerFa`);
    // 卡片跳转避免展示气泡
    AppStorage.setOrCreate<boolean>(Constants.FROM_FACARD_POPUP_OFF, true);
    this.formId = assert.asDefault(want.parameters?.formId, '');
    this.formCurrentUri = assert.asDefault(want.parameters?.currentUri, '');
    this.formCurrentAlbumUri = assert.asDefault(want.parameters?.albumUri, '');
    AppStorage.setOrCreate<string>('form_currentUri', this.formCurrentUri);
    AppStorage.setOrCreate<string>('form_albumUri', this.formCurrentAlbumUri);
    AppStorage.setOrCreate<string>(Constants.KEY_OF_REFRESH_FA_CARD_ID, this.formId);
    const cardType: string = assert.asDefault(want.parameters?.cardType, '');
    Log.info(TAG, 'routerFa cardType: ' + cardType);
    const isFromMoment: boolean = cardType === 'MomentCard';
    Log.info(TAG, 'routerFa isFromMoment: ' + isFromMoment);
    const isFromFormPortrait: boolean = cardType === 'portraitCard';
    Log.info(TAG, 'routerFa isFromFormPortrait: ' + isFromFormPortrait);
    const routerName = AppStorage.get<Router>('router')?.getState().name;
    Log.info(TAG,
      `routerFa router getState name = ${routerName}, formId = ${this.formId}, formCurrentUri = ${this.formCurrentUri}, formCurrentAlbumUri = ${this.formCurrentAlbumUri}`);
    if (routerName === 'PhotoBrowserSnapshot' && !isFromMoment && !isFromFormPortrait) {
      appBroadCast.emit(BroadCastConstants.UPDATE_SNAPSHOT_IMAGE_URI);
    } else if (isFromFormPortrait) {
      this.routerToPortrait();
    } else {
      appBroadCast.emit(BroadCastConstants.CHANGE_PAGE_EXIT_TRANSITION);
      Log.info(TAG, `routerFa router begin length = ${AppStorage.get<Router>('router')?.getLength()}`);
      AppStorage.get<Router>('router')?.pushUrl({
        url: this.getFaCardPath(),
        params: {
          isFromFaCard: true,
        }
      });
      Log.info(TAG, `routerFa router after length = ${AppStorage.get<Router>('router')?.getLength()}`);
    }
  }

  routerToPortrait() {
    if (appBroadCast.has(BroadCastConstants.SET_CURRENT_IMAGE_URI)) {
      appBroadCast.emit(BroadCastConstants.SET_CURRENT_IMAGE_URI);
      Log.info(TAG, `photoBrowserComponet appear: ${AppStorage.get<string>('current_image_uri_from_card')}`);
      if (this.formCurrentUri === AppStorage.get<string>('current_image_uri_from_card')) {
        Log.info(TAG, `routerToPortrait, ${this.formCurrentUri} do not handle`);
        return;
      }
    }

    appBroadCast.emit(BroadCastConstants.CHANGE_PAGE_EXIT_TRANSITION);
    AppStorage.get<Router>('router')?.pushUrl({
      url: this.getPortraitPath(),
      params: {
        isFromFaCard: true,
        isFromFormPortrait: true,
        formId: this.formId,
        albumUri: this.formCurrentAlbumUri,
      }
    });
  }

  /* instrument ignore next */
  checkWantIsFromFa(want: Want, isOnNewWant = false) {
    Log.info(TAG, `checkWantIsFromFa`);
    this.formCurrentUri = Constants.NULL_STRING;
    this.formCurrentAlbumUri = Constants.NULL_STRING;
    isFromCard = false;
    isFromCardDefault = false;
    isFromCardEditor = false;
    isFromMomentCard = false;
    isFromFormPortrait = false;
    isFromFormProfile = false;
    this.storage.delete(Constants.KEY_OF_VIDEO_PLAY_CTRL_RESET_ONCE);
    this.storage.delete(Constants.KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_FA_CARD);
    AppStorage.delete(Constants.KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_MOMENT_CARD);
    switch (assert.asDefault(want.parameters?.uri, '')) {
      case Constants.WANT_PARAM_URI_FORM:
        isFromCard = true;
        this.preloadFaCardLibs();
        this.formCurrentUri = assert.asDefault(want.parameters?.currentUri, '');
        this.formCurrentAlbumUri = assert.asDefault(want.parameters?.albumUri, '');
        this.formAlbumUriChanged = AppStorage.get<string>('form_albumUri') !== this.formCurrentAlbumUri;
        Log.info(TAG,
          `checkWantIsFromFa formCurrentUri: ${this.formCurrentUri}, formId: ${this.formId}, albumUri: ${this.formCurrentAlbumUri}, prevAlbumUri: ${AppStorage.get<string>('form_albumUri')}, changed: ${this.formAlbumUriChanged}`);
        AppStorage.setOrCreate<string>('form_currentUri', this.formCurrentUri);
        AppStorage.setOrCreate<string>('form_albumUri', this.formCurrentAlbumUri);
        AppStorage.setOrCreate<string>(Constants.KEY_OF_REFRESH_FA_CARD_ID, this.formId);
        this.storage.setOrCreate<boolean>(Constants.KEY_OF_VIDEO_PLAY_CTRL_RESET_ONCE, true);
        /* instrument ignore next */
        let isFromSubScreen = assert.asDefault(want.parameters?.isFromSubScreen, false);
        if (DeviceInfo.isSmallFoldScreen() && isFromSubScreen) {
          this.saveSmallFoldWant(want);
        }
        break;
      case Constants.WANT_PARAM_URI_FORM_PORTRAIT:
        Log.info(TAG, `checkWantIsFromFa WANT_PARAM_URI_FORM_PORTRAIT`);
        isFromFormPortrait = true;
        this.preloadFaCardLibs();
        this.formCurrentUri = assert.asDefault(want.parameters?.currentUri, '');
        this.formCurrentAlbumUri = assert.asDefault(want.parameters?.albumUri, '');
        this.formAlbumUriChanged = AppStorage.get<string>('form_albumUri') !== this.formCurrentAlbumUri;
        Log.info(TAG,
          `checkWantIsFromFa formCurrentUri: ${this.formCurrentUri}, formId: ${this.formId}, albumUri: ${this.formCurrentAlbumUri}, prevAlbumUri: ${AppStorage.get<string>('form_albumUri')}, changed: ${this.formAlbumUriChanged}`);
        AppStorage.setOrCreate<string>('form_currentUri', this.formCurrentUri);
        AppStorage.setOrCreate<string>('form_albumUri', this.formCurrentAlbumUri);
        AppStorage.setOrCreate<string>(Constants.KEY_OF_REFRESH_FA_CARD_ID, this.formId);
        this.storage.setOrCreate<boolean>(Constants.KEY_OF_VIDEO_PLAY_CTRL_RESET_ONCE, true);
        /* instrument ignore next */
        if (DeviceInfo.isSmallFoldScreen()) {
          this.saveSmallFoldWant(want);
        }
        break;
      case Constants.WANT_PARAM_URI_FORM_PROFILE:
        this.formCurrentAlbumUri = want.parameters?.albumUri as string;
        this.formId = want.parameters?.formId as string;
        isFromFormProfile = true;
        Log.info(TAG, `checkWantIsFromFa WANT_PARAM_URI_FORM_PROFILE`);
        break;
      case Constants.WANT_PARAM_URI_FORM_NONE:
        Log.info(TAG, `checkWantIsFromFa WANT_PARAM_URI_FORM_NONE`);
        isFromCardDefault = true;
        break;
      default:
        if (want.parameters?.formId) {
          isFromCardEditor = true;
          AppStorage.setOrCreate('FASetting_FormId', want.parameters?.formId);
        }
        Log.info(TAG, `checkWantIsFromFa isFromCardEditor: ${isFromCardEditor} `);
        break;
    }
    if (isOnNewWant) {
      let isCard = isFromFormPortrait || isFromCard;
      this.storage.setOrCreate<boolean>(Constants.KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_FA_CARD, !isCard);
    }
  }

  checkWantIsFromViewData(want: Want) {
    isFromViewData = want.action === wantConstant.Action.ACTION_VIEW_DATA;
    Log.info(TAG, `checkWantIsFromViewData isFromViewData=${isFromViewData}`);
    if (isFromViewData && want.parameters) {
      let callerBundleName: string = want.parameters[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string ?? '';
      AppStorage.setOrCreate('callerBundleName', callerBundleName);
    }
  }

  parseWantParameter(isOnNewWant: boolean, want: Want): number {
    Log.info(TAG, `Application isOnNewWant=${isOnNewWant}, want=${JSON.stringify(want)}`);
    this.isOnNewWant = isOnNewWant;
    DeviceInfo.isPhoneUx() && this.storage?.setOrCreate('placeholderIndex', -1);
    let entryFromHapValue: number = Constants.ENTRY_FROM_NONE;
    let wantParam: Record<string, Object> | undefined = want.parameters;
    if (!wantParam) {
      Log.error(TAG, 'wantParam empty');
      return entryFromHapValue;
    }
    /* instrument ignore next */
    switch (assert.asDefault(wantParam.uri, '')) {
      case Constants.WANT_PARAM_URI_SHARE_BROWSER_ADD:
        entryFromHapValue = Constants.ENTRY_FROM_THIRD_CAMERA_ADD;
        AppStorage.setOrCreate(Constants.SHARE_BROWSER_ADD_MEDIA_URI, assert.asDefault(wantParam.mediaUri, ''));
        break;
      case Constants.WANT_PARAM_URI_PORTRAIT_ALBUM:
        entryFromHapValue = Constants.ENTRY_FROM_THIRD_CAMERA_TO_PORTRAIT_ALBUM;
        albumInfo = wantParam?.albumInfo as AlbumInfo;
        albumInfoForMe = wantParam?.albumInfoForMe as AlbumInfo;
        break;
      case Constants.WANT_PARAM_URI_SETTINGS:
        entryFromHapValue = Constants.ENTRY_FROM_THIRD_CAMERA_TO_SETTING;
        settingComponentId = wantParam?.componentId as string;
        break;
      case Constants.WANT_PARAM_URI_DETAIL:
        isFromCamera = true;
        entryFromHapValue = Constants.ENTRY_FROM_CAMERA;
        break;
      case Constants.WANT_PARAM_URI_SELECT_SINGLE:
        entryFromHapValue = Constants.ENTRY_FROM_SINGLE_SELECT;
        this.parseWantForPickerSingleSelect(wantParam);
        break;
      case Constants.WANT_PARAM_URI_SELECT_MULTIPLE:
        entryFromHapValue = Constants.ENTRY_FROM_MULTIPLE_SELECT;
        this.parseWantForPickerMultiSelect(wantParam);
        break;
      case Constants.WANT_PARAM_URI_PHOTO_VIEW:
        entryFromHapValue = Constants.ENTRY_FROM.PHOTO_VIEW;
        this.parseWantForPhotoView(wantParam);
        break;
      default:
        entryFromHapValue = this.parseWantParameterPart(wantParam, entryFromHapValue, want);
        break;
    }
    AppStorage.setOrCreate('entryFromHap', entryFromHapValue);
    const msg: Record<string, number | string | boolean> = {
      'entryFromHap': entryFromHapValue
    };
    ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTOS_ID, msg);
    return entryFromHapValue;
  }

  private parseWantForPhotoView(wantParam: Record<string, Object>): void {
    mCallerBundleName = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string;
    courses = {
      jumpSource: JumpSourceToMain.PHOTO_VIEW,
      pageFrom: Constants.ENTRY_FROM.PHOTO_VIEW,
      subjectType: assert.asDefault(wantParam.subject_type, 0),
      subjectTitle: assert.asDefault(wantParam.subject_title, ''),
      subjectStartTime: assert.asDefault(wantParam.start_time, 0),
      subjectStopTime: assert.asDefault(wantParam.stop_time, 0),
    };
    const msg: Record<string, number | string> = {
      'SUBJECT_TYPE': courses.subjectType,
      'SUBJECT_TITLE': courses.subjectTitle,
      'SUBJECT_START_TIME': courses.subjectStartTime,
      'SUBJECT_STOP_TIME': courses.subjectStopTime,
      'bundleName': mCallerBundleName,
    };
    ReportToBigDataUtil.report(BigDataConstants.ENTER_TIMELINE_PAGE, msg);
  }

  /* instrument ignore next */
  private parseWantForPickerSingleSelect(wantParam: Record<string, Object>): void {
    mCallerBundleName = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string;
    mMaxSelectCount = 1; // Max select count must be 1 in single select mode
    mFilterMediaType = assert.asDefault(wantParam.filterMediaType, '');
    cameraAble = (wantParam?.isPhotoTakingSupported as boolean) ?? true;
    editAble = (wantParam?.isEditSupported as boolean) ?? true;
    searchAble = (wantParam?.isSearchSupported as boolean) ?? true;
    const msg: Record<string, number | string | boolean> = {
      'IS_PICKER_SEARCH_CONFIGURED': (wantParam?.isSearchSupported as boolean | undefined) !== undefined,
      'IS_SEARCH_ENABLED': searchAble,
      'bundleName': mCallerBundleName,
    };
    ReportToBigDataUtil.report(BigDataConstants.IS_PICKER_SEARCH_ENABLED, msg);
  }

  /* instrument ignore next */
  private parseWantForPickerMultiSelect(wantParam: Record<string, Object>): void {
    mCallerBundleName = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string;
    mMaxSelectCount = wantParam?.maxSelectCount as number;
    mFilterMediaType = assert.asDefault(wantParam.filterMediaType, '');
    cameraAble = (wantParam?.isPhotoTakingSupported as boolean) ?? true;
    editAble = (wantParam?.isEditSupported as boolean) ?? true;
    searchAble = (wantParam?.isSearchSupported as boolean) ?? true;
    const msg: Record<string, number | string | boolean> = {
      'IS_PICKER_SEARCH_CONFIGURED': (wantParam?.isSearchSupported as boolean | undefined) !== undefined,
      'IS_SEARCH_ENABLED': searchAble,
      'bundleName': mCallerBundleName,
    };
    ReportToBigDataUtil.report(BigDataConstants.IS_PICKER_SEARCH_ENABLED, msg);
    preData = assert.asDefault<string[]>(wantParam.preData, []);
    isShowSerialNum = (wantParam?.isShowSerialNum as boolean) ?? false;
  }

  /* instrument ignore next */
  parseWantParameterPart(wantParam: Record<string, Object>, entryFromHapValue: number, want: Want): number {
    switch (assert.asDefault(wantParam.uri, '')) {
      case Constants.WANT_PARAM_URI_FORM:
        entryFromHapValue = Constants.ENTRY_FROM_FORM_ABILITY;
        break;
      case Constants.WANT_PARAM_URI_FORM_PORTRAIT:
        entryFromHapValue = Constants.ENTRY_FROM_FORM_ABILITY_PORTRAIT;
        break;
      case Constants.WANT_PARAM_URI_PETALCLIP:
        isFromPetalClip = true;
        entryFromHapValue = Constants.ENTRY_FROM_PETALCLIP;
        break;
      case Constants.WANT_PARAM_URI_FORM_NONE:
        entryFromHapValue = Constants.ENTRY_FROM_FORM_DEFAULT_ABILITY;
        break;
      case Constants.WANT_PARAM_URI_GLOBAL_SEARCH:
        entryFromHapValue = Constants.ENTRY_FROM_GLOBAL_SEARCH;
        searchWord = assert.asDefault(wantParam.searchWord, '');
        if (searchWord === undefined || searchWord.length <= 0) {
          const msg: Record<string, number | string | boolean> = {
            'error': 'no search word'
          };
          ReportToBigDataUtil.errEventReport(BigDataConstants.ENTER_PHOTOS_PARAM_ERROR, msg);
        }
        break;
      case Constants.WANT_PARAM_URI_FILE_MANAGER:
        entryFromHapValue = Constants.ENTRY_FROM_FILE_MANAGER;
        reqFromFileMgr = assert.asDefault(wantParam.reqFromFileMgr, '');
        if (!reqFromFileMgr) {
          const msg: Record<string, number | string | boolean> = {
            'error': 'reqFromFileMgr param error'
          };
          ReportToBigDataUtil.errEventReport(BigDataConstants.ENTER_PHOTOS_PARAM_ERROR, msg);
        }
        Log.info(TAG, `entry photo form fileManager, param target page is: ${reqFromFileMgr}`);
        break;
      case Constants.WANT_PARAM_URI_CAMERA:
        entryFromHapValue = Constants.ENTRY_FROM_CAMERA;
        break;
      default:
        entryFromHapValue = this.parseWantWithoutUri(want, wantParam);
        break;
    }
    Log.info(TAG, 'parseWantParameterPart entryFromHapValue=' + entryFromHapValue);
    return entryFromHapValue;
  }

  /* instrument ignore next */
  onDestroy(): void | Promise<void> {
    Global.setBoolean('canGetSharedStorage', false);
    // harmonyShare.off('knockShare');
    let isOpen = settings.getValueSync(this.context, ITEM_AIR_SHARE_SWITCH, '0', settings.domainName.USER_SECURITY);
    settings.setValueSync(this.context, LARGE_PICTURE_BROWSING_STATUS, BROWSING_STATUS_ZERO);
    Log.info(TAG,
      `open: ${settings.getValueSync(this.context, ITEM_AIR_SHARE_SWITCH, '0', settings.domainName.USER_SECURITY)}`);
    if (IS_SWING_SHARE_OPEN === isOpen) {
      // (harmonyShare.off as Function)('swingShare');
    }
    this.cancelDialListen();
    // Ability is creating, release resources for this ability
    Log.info(TAG, 'Application onDestroy');
    appBroadCast.off(BroadCastConstants.THIRD_ROUTE_PAGE);
    this.isOnDestroy = true;
    let statusBarColorController: StatusBarColorController = StatusBarColorController.getInstance();
    statusBarColorController.release();
    UserFileManagerAccess.getInstance().onDestroy();
    SendablePhotoAccessHelper.getInstance().onDestroy();
    NetworkConnectionAccess.unregister();
    appBroadCast.emit(BroadCastConstants.CAST_STOP_ABILITY, []);
    VideoPlayController.release();
    accessibility.off('accessibilityStateChange');
    this.appStorageClear();
    this.clearInstance();
    CommonUtil.unregisterProgDispSwitchObserver();
    LocalStorage.getShared()?.delete(Constants.ALREADY_LOAD_MAP_SO);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_FIRST_INDEX);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GROUP_FIRST_INDEX);
    if (DeviceInfo.isGRLFoldScreen()) {
      AppStorage.delete(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
      AppStorage.delete(Constants.KEY_OF_SELECTED_ALBUM_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_KEEP_SEARCH);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_CATEGORY_GRID_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_SHOOTING_MODE_GRID_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_POSITION);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_ENTRY);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_SELECT_FRAME);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_IS_SELECT_ALL);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_KEEP_CLASSIFIED);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_KEEP_SHOOTING);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_RECOVER_SIDEBAR_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GRID_SCROLL_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GRID_SCROLL_INDEX_TMP);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_RECOVER_GRID_VIEW);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PHOTO_GRID_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PHOTO_GRID_SELECT_FRAME);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_CURRENT_VIEW);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GROUP_VIEW_ZINDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_DAY_VIEW_ZINDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_MONTH_VIEW_ZINDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_YEAR_VIEW_ZINDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_SHOW_SIDEBAR);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_MOVING_TO_PAGE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_HIDDEN_GRID_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_HIDDEN_GRID_SELECT_FRAME);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PHOTO_GRID_VIEW_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GRID_PORTRAIT_SELECT_MANAGER);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_ALBUM_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PORTRAIT_MORE_ENTRY);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_MORE_PORTRAIT_SELECT_MANAGER);
    }
  }

  /* instrument ignore next */
  private appStorageClear(): void {
    Log.info(TAG, 'appStorageClear');
    //进程没有杀掉,geometryTransitionBrowserId 无法删除，导致宫格白块。
    AppStorage.set<string>('geometryTransitionBrowserId', '');
    AppStorage.delete('entryFromHap');
    AppStorage.delete(Constants.DESTROY_FROM_CAMERA);
    AppStorage.delete('isMute');
    AppStorage.delete('filesDir');
    this.storage?.delete('photosAbilityContext');
    AppStorage.delete('formContext');
    AppStorage.delete('form_currentUri');
    AppStorage.delete('form_albumUri');
    AppStorage.delete(Constants.KEY_OF_REFRESH_FA_CARD_ID);
    AppStorage.delete('pageShowFlag');
    AppStorage.delete('TimeLineModelManager');
    Global.deleteBoolean('hdrEnable');
    AppStorage.delete(Constants.ENABLE_PIANO);
    this.storage?.delete('photosAbilityContext');
    AppStorage.delete(Constants.CURRENT_TIME);
    AppStorage.delete(Constants.APP_KEY_PHOTO_BROWSER);
    AppStorage.delete(Constants.IS_FIRST_TIME_DELETE);
    AppStorage.delete(Constants.PHOTOS_STORE_KEY);
    // 宫格进大图
    this.storage?.delete('placeholderIndex');
    this.storage?.delete('geometryTransitionBrowserId');
    // 图片视频编辑
    AppStorage.delete('isDefaultTab');
    AppStorage.delete('editor_isPortrait');
    AppStorage.delete('device_isFold');
    AppStorage.delete('winWidth');
    AppStorage.delete('winHeight');
    AppStorage.delete('container_width');
    this.storage?.delete('photosWindowStage');
    AppStorage.delete('change_background');
    this.storage?.delete('mainWindow');
    AppStorage.delete(Constants.PHOTO_DIRECTLY_ENTER_AI_EDITING);
    AppStorage.delete(Constants.PHOTO_DIRECTLY_ENTER_XTSTYLE);
    // 侧边栏
    AppStorage.delete('router');
    AppStorage.delete('isFromCategory');
    AppStorage.delete('isFromShootView');
    AppStorage.delete('photoGridViewAlbumItem');
    AppStorage.delete('albumUri');
    AppStorage.delete('focusPosition');
    AppStorage.delete('isShowPhotoGridView');
    AppStorage.delete('photoGridActionBarOpacity');
    AppStorage.delete('photoGridViewOpacity');
    // 相册
    AppStorage.delete('albumOpacity');
    AppStorage.delete('albumActionBarOpacity');
    AppStorage.delete('albumOtherScale');
    AppStorage.delete('selectedAlbumUri');
    AppStorage.delete(Constants.OPEN_TOUCH_GUIDE);
    AppStorage.delete('windowStageType');
    AppStorage.delete('viewDataToHwShareGird');
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_FIRST_INDEX);
    LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GROUP_FIRST_INDEX);
    if (DeviceInfo.isGRLFoldScreen()) {
      AppStorage.delete(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
      AppStorage.delete(Constants.KEY_OF_SELECTED_ALBUM_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_KEEP_SEARCH);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_CATEGORY_GRID_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_SHOOTING_MODE_GRID_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_TIMELINE_SELECT_FRAME);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_KEEP_CLASSIFIED);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_IS_KEEP_SHOOTING);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_RECOVER_SIDEBAR_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GRID_SCROLL_INDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_RECOVER_GRID_VIEW);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PHOTO_GRID_SELECT_MODE);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_PHOTO_GRID_SELECT_FRAME);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_CURRENT_VIEW);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_GROUP_VIEW_ZINDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_DAY_VIEW_ZINDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_MONTH_VIEW_ZINDEX);
      LocalStorage.getShared()?.delete(Constants.APP_KEY_GRL_YEAR_VIEW_ZINDEX);
    }
  }

  private clearInstance(): void {
    // 窗口参数初始化
    this.storage?.delete(Constants.APP_KEY_SCREEN_MANAGER);
    TimelineDataSourceManager.onDestroy();
    AlbumSetDataSourceManager.onDestroy();
  }

  private cancelDialListen(): void {
    // serviceBrowser.unpublishService(JSON.stringify(Constants.DIAL_INIT_AND_CANCEL_PARAMETER));
  }

  private onWindowStageEvent(type: window.WindowStageEventType): void {
    if (type === undefined ||
      type === window.WindowStageEventType.SHOWN ||
      type === window.WindowStageEventType.ACTIVE ||
      type === window.WindowStageEventType.RESUMED) {
      AppStorage.setOrCreate<boolean>('windowFocused', true);
      Log.info(TAG, `windowType:${type}`)
    } else {
      AppStorage.setOrCreate<boolean>('windowFocused', false);
      Log.info(TAG, `windowType:${type}`)
    }
    if (type) {
      AppStorage.setOrCreate<window.WindowStageEventType>('windowStageType', type);
    }
  }

  private createWindowFocusListener(windowStage: window.WindowStage): void {
    try {
      windowStage?.on('windowStageEvent', this.onWindowStageEventFunc);
    } catch (err) {
      Log.error(TAG, `on windowStageEvent error ${err?.code}, ${err?.message}`);
    }
  }

  private destroyWindowFocusListener(): void {
    try {
      let windowStage: window.WindowStage | undefined =
        LocalStorage.getShared()?.get<window.WindowStage>('photosWindowStage');
      if (!windowStage) {
        Log.error(TAG, 'destroyWindowFocusListener windowStage null');
        windowStage = this.storage.get<window.WindowStage>('photosWindowStage');
      }
      if (windowStage) {
        windowStage.off('windowStageEvent', this.onWindowStageEventFunc);
        Log.info(TAG, 'destroyWindowFocusListener off');
      } else {
        Log.error(TAG, 'destroyWindowFocusListener windowStage null');
      }
    } catch (err) {
      Log.error(TAG, 'on windowStageEvent error');
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Log.info(TAG, 'Application onWindowStageCreate');
    // PafEngine.init(windowStage, this.context, {
    //   config: {
    //     region: Region.CN,
    //   },
    // });
    this.storage?.setOrCreate<window.WindowStage>('photosWindowStage', windowStage);
    // Default orientation
    setHorizontal(DeviceInfo.isPc(), this.storage);
    let screenManager: ScreenManager = getScreen(this.storage);
    screenManager.on(ScreenManager.ON_LEFT_BLANK_CHANGED, this.onLeftBlankChangedFunc);
    screenManager.on(ScreenManager.ON_SPLIT_MODE_CHANGED, this.onSplitModeChangedFunc);
    try {
      windowStage.getMainWindowSync().on('windowStatusChange', screenManager.windowStatusChangeCallBackFunc);
    } catch (error) {
      Log.error(TAG, 'registerWindowStatusChange error: ' + error + `, code: ${error?.code}`);
    }
    Log.info(TAG, 'Application onCreate finish');
    windowStage.getMainWindow().then((win: window.Window): void => {
      AppStorage.setOrCreate('getFoldStatus', DeviceInfo.isFoldable());
      AppStorage.setOrCreate(Constants.FOLD_DISPLAY_MODE, display.getFoldDisplayMode());
      this.storage?.setOrCreate('mainWindow', win);
      global.setWindow(windowStage, win);
      settings.getValue(global.uiAbilityContext(), 'window_pcmode_switch_status', settings.domainName.USER_PROPERTY,)
        .then((value: string) => {
          Log.info(TAG, `windowPcmodeSwitchStatus: ${value}`);
          AppStorage.setOrCreate<boolean>('windowPcmodeSwitchStatus', value === 'true');
        });
      screenManager.initWindowMode(); // 应用沉浸式背景色设置，欢迎页初始化需要
      screenManager.registerWindowAvoidArea();
      screenManager.getAvoidArea(); // 状态栏数据初始化
      Protocol.initPreferences().then(() => {
        this.loadPage(windowStage);
      });
      screenManager.openColorSpaceWideGamut(win);
      screenManager.initializationSize().then((): void => {
        screenManager.getWindowStatus();
        if (!DeviceInfo.isPc()) {
          return;
        }
        let size: window.Rect = getScreen(this.storage).getWinRect();
        display.getAllDisplays((err, data) => {
          let screenWidth: number = data[0].width;
          let screenHeight: number = data[0].height;
          Log.info(TAG, `screenWidth = ${screenWidth} screenHeight = ${screenHeight}`);
          if (size.width === screenWidth && (screenHeight - size.height) / screenHeight < 0.08) {
            let topWindow: window.Window = getScreen(this.storage).getMainWindow();
            topWindow?.maximize(window.MaximizePresentation.FOLLOW_APP_IMMERSIVE_SETTING);
          }
        })
      }).catch((): void => {
        Log.error(TAG, 'get device screen info failed.');
      });
      const INIT_DELAY_TIME: number = 500;
      setTimeout((): void => {
        this.initNetworkStatus();
        this.registerCloudSync();
        CommonUtil.registerProgDispSwitchObserver();
      }, INIT_DELAY_TIME);
    });
    this.createWindowFocusListener(windowStage);
  }

  public loadPage(windowStage: window.WindowStage): void {
    AppStorage.delete('router');
    let isAgreed: boolean = true;
    if (!isAgreed) {
      isAgreed = assert.asDefault(
        AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.getSync('PERMISSION_AGREED',
          false), false, TAG);
      Protocol.set('PERMISSION_AGREED', isAgreed);
      AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.putSync('PERMISSION_AGREED', false);
      AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.flush();
    } else {
      this.initAnalysisParam();
    }

    const isPopup = !isAgreed && !lockedScreenMgr().isFromLockedScreen && !this.isFromPicker;
    if (isAgreed) {
      setTimeout((): void => {
        this.processContentPath(isPopup, windowStage);
      }, 0);
      return;
    }

    appBroadCast.on(BroadCastConstants.COMMON_ABILITY_RESTORE_FA_CARD, (): void => {
      FormControllerManager.getInstance(this.context).restore();
    });
    DeviceInfo.isPhoneUx() && windowStage.disableWindowDecor();
  }

  private async getFormEditorPageParams(): Promise<FormEditorParams> {
    const faCardService: FaCardService = new FaCardService(this.context);
    const formEditorParams = await faCardService.queryFormEditorPageParam(this.formId);
    return formEditorParams;
  }

  public async processContentPath(isPopup: boolean, windowStage: window.WindowStage) {
    Log.info(TAG, `isPopup is ${isPopup}`);
    if (!isPopup) {
      this.initData();
    }
    let contentPath: string = 'MainAbility/view/index';
    let isAccessUserGuide: boolean = true;
    if (!DeviceInfo.isPc() && !DeviceInfo.isTv()) {
      let isGuideTmp: boolean = Protocol.get<boolean>(Constants.USER_GUIDE, false);
      if (!isGuideTmp) {
        isGuideTmp = assert.asDefault(
          AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.getSync(Constants.USER_GUIDE,
            false), false, TAG);
        Protocol.set(Constants.USER_GUIDE, isGuideTmp);
        AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.putSync(Constants.USER_GUIDE, false);
        AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY)?.flush();
      }
      isAccessUserGuide = assert.asDefault(isGuideTmp, false, TAG);
    }
    Log.info(TAG, `Application processContentPath isAccessUserGuide === ${isAccessUserGuide}`);
    if (lockedScreenMgr().isFromLockedScreen) {
      contentPath = 'MainAbility/view/PhotoBrowser';
    } else if (isPopup) {
      contentPath = PageTitle.prefix + PageTitle.permissionNormal;
    } else if (isFromCard) {
      Log.info(TAG, 'processContentPath isFromCard');
      this.storage?.setOrCreate('isFromFa', true);
      contentPath = this.getFaCardPath();
    } else if (isFromCardEditor) {
      const params: FormEditorParams = await this.getFormEditorPageParams();
      this.storage?.setOrCreate<FormEditorParams>('formEditorParameters', params)
      contentPath = 'FormAbility/view/FormEditorPage';
    } else if (isFromFormProfile) {
      Log.info(TAG, 'processContentPath isFromFormProfile');
      contentPath = this.getPortraitPath();
    } else if (isFromFormPortrait) {
      Log.info(TAG, 'processContentPath isFromFormPortrait');
    } else if (isFromCardDefault) {
      contentPath = 'MainAbility/view/DefaultPhotoPage';
    } else if (!DeviceInfo.isPc() && !isAccessUserGuide) {
      contentPath = PageTitle.prefix + PageTitle.userGuide;
    } else {
      this.preload();
    }

    Log.warn(TAG, 'Application onCreate finish. isFromCard:' + isFromCard + '; contentPath:' +
      contentPath + lockedScreenMgr().isFromLockedScreen + ' isFromMomentCard: ' + isFromMomentCard);
    windowStage.loadContent('MainAbility/view/index' , this.storage, (err: BusinessError, data): void => {
      if (err.code) {
        Log.error(TAG, `Failed to load the content. Cause: %{public}s${errors.toString(err)}`);
        return;
      }
      this.afterLoadContent();

      Global.deleteBoolean('canGetSharedStorage');
      WindowUtil.prepareWinRouter();
      Log.info(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  /**
   * 页面加载之后
   */
  protected afterLoadContent(): void {
  }

  protected async preload(): Promise<void> {
    AlbumUtils.init(this.context);
    AlbumRatioUtils.init(this.context);
  }

  protected async preloadFaCardLibs() {
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    Log.info(TAG, 'onWindowStageWillDestroy');
    this.destroyWindowFocusListener();
    getScreen(this.storage).destroyWindowMode();
    getScreen(this.storage).unRegisterWindowAvoidArea();
    getScreen(this.storage).unRegisterWindowStatusChange();
  }

  /* instrument ignore next */
  onWindowStageDestroy(): void {
    Log.info(TAG, 'onWindowStageDestroy');
    appBroadCast?.off(BroadCastConstants.COMMON_ABILITY_DATA_INIT);
    getScreen(this.storage).off(ScreenManager.ON_LEFT_BLANK_CHANGED, this.onLeftBlankChangedFunc);
    getScreen(this.storage).off(ScreenManager.ON_SPLIT_MODE_CHANGED, this.onSplitModeChangedFunc);
    getScreen(this.storage).release();
    this.unregisterAudioEvent();
  }

  /* instrument ignore next */
  onForeground(): void {
    Log.info(TAG, 'onForeground');
    AlbumGridSortHelper.getInstance().resume(this.context);
  }

  /* instrument ignore next */
  onBackground(): void {
    Log.info(TAG, 'onBackground');
    RelationStoreUtil.getInstance().reset();
    AlbumUtils.reset();
    AlbumRatioUtils.reset();
  }

  /* instrument ignore next */
  public async thirdRouterPage(): Promise<void> {
    let entryFrom: number = AppStorage.get('entryFromHap') ?? Number.NaN;
    Log.info(TAG, `thirdRouterPage entryFromHap: ${entryFrom}`);
    if (entryFrom === Constants.ENTRY_FROM_NONE) {
      return;
    }
    if (entryFrom === Constants.ENTRY_FROM_CAMERA) {
      const options: router.RouterOptions = {
        url: 'MainAbility/view/index',
        params: {
          pageFrom: Constants.ENTRY_FROM.CAMERA,
          jumpSource: JumpSourceToMain.CAMERA,
        }
      };
      AppStorage.get<Router>('router')?.replaceUrl(options);
    } else if (entryFrom === Constants.ENTRY_FROM_THIRD_CAMERA_ADD) {
      let photoAsset: PhotoAsset =
        await UserFileManagerAccess.getPhotoByUri(AppStorage.get<string>(Constants.SHARE_BROWSER_ADD_MEDIA_URI) ?? '');
      let blackUris: string[] =
        await UserFileManagerAccess.getInstance().getSystemAlbumUriByMediaType(photoAsset.photoType);
      const options: router.RouterOptions = {
        url: 'MainAbility/view/MediaOperationPage',
        params: {
          pageFrom: Constants.MEDIA_OPERATION_FROM_THIRD_CAMERA_ADD,
          mediaUri: AppStorage.get<string>(Constants.SHARE_BROWSER_ADD_MEDIA_URI),
          mediaType: photoAsset.photoType,
          blackUriList: blackUris,
        }
      };
      AppStorage.get<Router>('router')?.replaceUrl(options);
    } else if (entryFrom === Constants.ENTRY_FROM_SINGLE_SELECT) {
      this.entryFromSingleSelect();
    } else if (entryFrom === Constants.ENTRY_FROM_FORM_DEFAULT_ABILITY) {
      if (this.isOnNewWant) {
        let options: router.RouterOptions = {
          url: 'MainAbility/view/DefaultPhotoPage',
        };
        AppStorage.get<Router>('router')?.replaceUrl(options);
      }
    } else if (entryFrom === Constants.ENTRY_FROM_MULTIPLE_SELECT) {
      this.entryFromMultipleSelect();
    } else {
      this.thirdRouterPagePart(entryFrom);
    }
    if (!isFromViewData) {
      AppStorage.setOrCreate<number>('entryFromHap', Constants.ENTRY_FROM_NONE);
    }
    setTimeout((): void => {
      if (isFromViewData) {
        AppStorage.setOrCreate<number>('entryFromHap', Constants.ENTRY_FROM_NONE);
      }
      try {
        if (!DeviceInfo.isPhoneUx() || entryFrom !== Constants.ENTRY_FROM_PETALCLIP) {
          AppStorage.get<Router>('router')?.clear();
        }
      } catch (error) {
        Log.error(TAG, `ability destroy before clear msg:${error}`);
      }
    }, 50);
  }

  /* instrument ignore next */
  private async thirdRouterPagePart(entryFrom: number) {
    if (entryFrom === Constants.ENTRY_FROM_FORM_ABILITY) {
      Log.info(TAG, `this.formCurrentUri.length = ${
      this.formCurrentUri.length} this.isOnNewWant = ${this.isOnNewWant}}`);
      const albumUri: string | undefined = AppStorage.get<string>('form_albumUri');
      Log.info(TAG, `thirdRouterPagePart albumUri is: ${albumUri}`);
      if (albumUri) {
        // 判断相册是否存在（重命名的相册可能不存在）
        const album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
        Log.info(TAG, `thirdRouterPagePart get album is: ${album}`);
        if (album) {
          AppStorage.setOrCreate<string>('form_albumUri', albumUri);
        } else {
          Log.info(TAG, `thirdRouterPagePart album is undefined`);
          AppStorage.setOrCreate<string>('form_albumUri', '');
        }
      }
      let options: router.RouterOptions | undefined = undefined;
      if (this.formCurrentUri.length > 0) {
        Log.info(TAG, 'thirdRouterPagePart jump to PhotoBrowser');
        options = {
          url: this.getFaCardPath(),
          params: {
            isFromFaCard: true,
          }
        };
        Log.info(TAG,
          `hasBroadCast: ${appBroadCast.has(BroadCastConstants.UPDATE_FA_CARD_URI)}, formAlbumUriChanged: ${this.formAlbumUriChanged}`);
        if (appBroadCast.has(BroadCastConstants.UPDATE_FA_CARD_URI) && !this.formAlbumUriChanged) {
          Log.info(TAG, 'formAlbumUri not Changed, emit update formCurrentUri');
          appBroadCast.emit(BroadCastConstants.UPDATE_FA_CARD_URI, [this.formCurrentUri, this.formCurrentAlbumUri]);
        } else {
          Log.info(TAG, `replaceUrl options = ${JSON.stringify(options)}`);
          AppStorage.get<Router>('router')?.replaceUrl(options)
        }
      } else {
        Log.error(TAG, 'form current uri length is zero');
      }
    } else if (entryFrom === Constants.ENTRY_FROM_FORM_ABILITY_PORTRAIT) {
      AppStorage.setOrCreate<boolean>(Constants.FROM_FACARD_POPUP_OFF, true);
      appBroadCast.emit(BroadCastConstants.CHANGE_PAGE_EXIT_TRANSITION);
      AppStorage.get<Router>('router')?.pushUrl({
        url: this.getPortraitPath(),
        params: {
          isFromFaCard: true,
          isFromFormPortrait: true,
          formId: this.formId,
          albumUri: this.formCurrentAlbumUri,
        }
      });
    } else if (entryFrom === Constants.ENTRY_FROM_FORM_FORM_EDITOR) {
      Log.info(TAG, `router is ${AppStorage.get<Router>('router')}`);
      const params: FormEditorParams = await this.getFormEditorPageParams();
      const options: router.RouterOptions = {
        url: 'FormAbility/view/FormEditorPage',
        params: params,
      };
      AppStorage.get<Router>('router')?.replaceUrl(options);
    } else if (entryFrom === Constants.ENTRY_FROM_VIEW_DATA) {
      Log.info(TAG, `param viewDataToHwShareGird: ${AppStorage.get('viewDataToHwShareGird')}`)
      if (AppStorage.get('viewDataToHwShareGird') === Constants.IS_VIEW_SHARE_GRID) {
        // 跳转宫格
        const options: router.RouterOptions = {
          url: 'MainAbility/view/PhotoGridPage',
          params: {
            pageFrom: Constants.WANT_PARAM_URI_HW_SHARE,
            targetPage: Constants.ENTER_HW_SHARE_PAGE_FROM_SHARE,
          }
        };
        AppStorage.get<Router>('router')?.replaceUrl(options);
        return;
      }
      AppStorage.SetOrCreate(Constants.Jump_TO_BROWSER_TIME, Date.now());
      this.jumpToPhotoBrowser();
    } else if (entryFrom === Constants.ENTRY_FROM_PETALCLIP) {
      this.entryFromPetalClip();
    } else if (entryFrom === Constants.ENTRY_FROM_GLOBAL_SEARCH) {
      this.entryFromGlobalSearch();
    } else if (entryFrom === Constants.ENTRY_FROM_FILE_MANAGER) {
      this.entryFromFileManager(reqFromFileMgr);
    } else if (entryFrom === Constants.ENTRY_FROM_THIRD_CAMERA_TO_SETTING) {
      this.entrySettingPage(settingComponentId);
    } else if (entryFrom === Constants.ENTRY_FROM_PROTOTYPE_EXPERIENCE_APP) {
      this.entryFromExperienceApp();
    } else if (entryFrom === Constants.ENTRY_FROM.PHOTO_VIEW) {
      this.entryFromPhotoView();
    }
  }

  protected getFaCardPath(): string {
    return 'MainAbility/view/PhotoBrowser';
  }

  /**
   * 从日历课程表跳转过来
   *
   * @param targetPage 需要跳转到图库的照片页
   */
  private entryFromPhotoView(): void {
    Log.info(TAG, `entryFromPhotoView`);
    const options: router.RouterOptions = {
      url: 'MainAbility/view/index',
      params: {
        jumpSource: JumpSourceToMain.PHOTO_VIEW,
        pageFrom: Constants.ENTRY_FROM.PHOTO_VIEW,
        targetPage: Constants.ENTER_TIMELINE_PAGE,
        subjectTitle: courses.subjectTitle,
        subjectStopTime: courses.subjectStopTime,
        subjectStartTime: courses.subjectStartTime,
      }
    };
    AppStorage.set<boolean>(Constants.KEY_OF_IS_FROM_CATEGORY, false);
    AppStorage.set<boolean>(Constants.KEY_OF_IS_FROM_SHOOT_VIEW, false);
    AppStorage.set<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);
    LocalStorage.getShared()?.set<string>('geometryTransitionBrowserId', '');
    LocalStorage.getShared()?.set<boolean>('isBrowserShow', false);
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }

  /* instrument ignore next */
  private entryFromSingleSelect(): void {
    if (mFilterMediaType && mMaxSelectCount !== undefined) {
      const pickerId: Record<string, number | string | boolean> = {
        'selectType': Constants.ENTRY_FROM_SINGLE_SELECT,
        'filterMediaType': mFilterMediaType,
        'maxSelectCount': mMaxSelectCount,
        'bundleName': mCallerBundleName,
      };
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_ID, pickerId);
    }
    const options: router.RouterOptions = {
      url: 'pickerability/view/ThirdSelectPhotoGridPage',
      params: {
        bundleName: mCallerBundleName,
        isMultiPick: false,
        isFirstEnter: true,
        filterMediaType: mFilterMediaType,
        maxSelectCount: mMaxSelectCount,
        uri: '',
        cameraAble: cameraAble,
        editAble: editAble,
        searchAble: searchAble,
        isNeedSelectBar: true,
        isNeedActionBar: true,
        isFromPickerView: false,
      }
    };
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }

  /* instrument ignore next */
  private entryFromMultipleSelect(): void {
    if (mMaxSelectCount !== undefined) {
      const pickerInput: Record<string, number | string | boolean> = {
        // 是否有配置预选择列表 1: 有 0: 无
        'PREDATA': preData?.length > 0 ? 1 : 0,
        // 预选择列表长度
        'PREDATA_NUMBER': preData?.length > 0 ? preData.length : 0,
        // 应用指定的Picker最多选择数量
        'MAX_NUMBER': mMaxSelectCount
      };
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_INPUT_NUMBER, pickerInput);
      if (mFilterMediaType) {
        const pickerId: Record<string, number | string | boolean> = {
          'selectType': Constants.ENTRY_FROM_MULTIPLE_SELECT,
          'filterMediaType': mFilterMediaType,
          'maxSelectCount': mMaxSelectCount,
          'bundleName': mCallerBundleName,
        };
        ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_ID, pickerId);
      }
    }
    const options: router.RouterOptions = {
      url: 'pickerability/view/ThirdSelectPhotoGridPage',
      params: {
        bundleName: mCallerBundleName,
        isMultiPick: true,
        isFirstEnter: true,
        filterMediaType: mFilterMediaType,
        maxSelectCount: mMaxSelectCount,
        uri: '',
        cameraAble: cameraAble,
        editAble: editAble,
        searchAble: searchAble,
        preData,
        isShowSerialNum,
        isNeedSelectBar: true,
        isNeedActionBar: true,
        isFromPickerView: false,
      }
    };
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }

  /* instrument ignore next */
  private entryFromPetalClip(): void {
    const options: router.RouterOptions = {
      url: 'MainAbility/view/PhotoBrowser',
      params: {
        pageFrom: Constants.ENTRY_FROM.PETALCLIP_VIDEO,
      }
    };
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }


  /**
   * 从文件管理app跳转过来
   *
   * @param targetPage 需要跳转到图库的目标页面
   */
  private entryFromFileManager(targetPage: string): void {
    Log.info(TAG, `entryFromFileManager: ${targetPage}`);
    if (targetPage === Constants.ENTER_VIDEO_PAGE_FROM_FILE_MANAGER ||
      targetPage === Constants.ENTER_CAMERA_PAGE_FROM_FILE_MANAGER ||
      targetPage === Constants.ENTER_HW_SHARE_PAGE_FROM_FILE_MANAGER) {
      // 跳转宫格
      const options: router.RouterOptions = {
        url: 'MainAbility/view/PhotoGridPage',
        params: {
          pageFrom: Constants.WANT_PARAM_URI_FILE_MANAGER,
          targetPage: targetPage,
        }
      };
      AppStorage.get<Router>('router')?.replaceUrl(options);
    } else if (targetPage === Constants.ENTER_ALBUM_PAGE_FROM_FILE_MANAGER) {
      let router: Router | undefined = AppStorage.get<Router>('router');
      if (router?.getState()?.name === 'index') {
        // 在index.ets中触发：文件管理跳转到相册首页，便于判断当前页面是否已经在相册、照片、时刻首页，可以直接直接tabChange
        appBroadCast.emit(BroadCastConstants.JUMP_TO_ALBUM_FOR_FILE_MANAGER, []);
      } else {
        // 跳转相册首页
        this.jumpToIndexPage();
      }
    }
  }

  /**
   * 跳转相册首页
   */
  private jumpToIndexPage(): void {
    const options: router.RouterOptions = {
      url: 'MainAbility/view/index',
      params: {
        jumpSource: JumpSourceToMain.FILE_MANAGER,
      }
    };
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }

  /**
   * 从门店体验、演示app跳转过来
   */
  private entryFromExperienceApp(): void {
    Log.info(TAG, `entryFromFileManager: ${targetPageId}`);
    if (targetPageId === ViewType.PHOTO_GRID_PAGE) {
      // 跳转宫格
      const options: router.RouterOptions = {
        url: 'MainAbility/view/PhotoGridPage',
        params: {
          pageFrom: Constants.WANT_PARAM_URI_FILE_MANAGER,
          targetPage: Constants.ENTER_USER_ALBUM_PAGE,
          albumLpathName: albumLpathName,
        }
      };
      AppStorage.get<Router>('router')?.replaceUrl(options);
    } else if (targetPageId === ViewType.TAB_PAGE) {
      this.jumpToTabPage();
    } else if (targetPageId === ViewType.PHOTO_BROWSER) {
      if (!AppStorage.get<boolean>(Constants.PHOTO_DIRECTLY_ENTER_XTSTYLE)) {
        AppStorage.setOrCreate<boolean>(Constants.PHOTO_DIRECTLY_ENTER_AI_EDITING, true);
      }
      //照片不存在，返回照片页
      if (!AppStorage.get('viewDataUri') && AppStorage.get<boolean>(Constants.PHOTO_DIRECTLY_ENTER_XTSTYLE)) {
        return;
      }
      this.jumpToPhotoBrowser();
    }
  }

  /**
   * 跳转大图预览
   */
  private jumpToPhotoBrowser(): void {
    const options: router.RouterOptions = {
      url: 'MainAbility/view/PhotoBrowser',
      params: {
        pageFrom: Constants.ENTRY_FROM.VIEW_DATA,
        viewData: AppStorage.get('viewDataUri') ?? '',
        viewDataAlbum: AppStorage.get('viewDataAlbumUri') ?? '',
        viewDataIndex: AppStorage.get('viewDataIndex') ?? '',
        viewDataType: AppStorage.get('viewDataType') ?? '',
        cameraShotKey: AppStorage.get<string>('cameraShotKey') ?? '',
        isShowTabMenu: Global.getBoolean('isShowTabMenu', true),
        isAllMediaData: AppStorage.get<boolean>('isAllMediaData') ?? false,
        imageArea: {
          width: AppStorage.get<number>('viewDataPhotoWidth'),
          height: AppStorage.get<number>('viewDataPhotoHeight'),
        },
        isShowMenuFromThirdView: isShowMenuFromThirdView,
      }
    };
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }

  /**
   * 跳转TAB首页
   */
  private jumpToTabPage(): void {
    const options: router.RouterOptions = {
      url: 'MainAbility/view/index',
      params: {
        jumpSource: JumpSourceToMain.TAB_PAGE,
        tabName: tabName,
      }
    };
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }

  /**
   * 大图组件跳转到设置页面
   */
  private entrySettingPage(settingComponentId: string): void {
    AppStorage.setOrCreate(Constants.IS_SHOW_SETTINGS_PAGE, true);
    let options: router.RouterOptions = {
      url: 'MainAbility/view/index',
      params: {
        jumpSource: JumpSourceToMain.SETTINGS,
        componentId: settingComponentId,
      }
    }
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }

  /* instrument ignore next */
  private entryFromGlobalSearch(): void {
    const options: router.RouterOptions = {
      url: 'MainAbility/view/index',
      params: {
        pageFrom: Constants.ENTRY_FROM.GLOBAL_SEARCH,
        searchParam: searchWord,
      }
    };
    AppStorage.get<Router>('router')?.replaceUrl(options);
  }

  /* instrument ignore next */
  private parseWantWithoutUri(want: Want, wantParam: Record<string, Object>): number {
    const fromName = assert.asDefault(wantParam.fromName, '');
    if (fromName === Constants.WANT_PARAM_FROM_NAME_RETAILDEMO ||
      fromName === Constants.WANT_PARAM_FROM_NAME_BASEEXPERIENCE) {
      targetPageId = assert.asDefault(wantParam.targetPageId, ViewType.TAB_PAGE);
      if (targetPageId === ViewType.TAB_PAGE) {
        tabName = assert.asDefault(wantParam.tabName, '');
      } else if (targetPageId === ViewType.PHOTO_GRID_PAGE) {
        albumLpathName = assert.asDefault(wantParam.albumLpathName, '');
      } else if (targetPageId === ViewType.PHOTO_BROWSER) {
        AppStorage.setOrCreate<string>('viewDataUri', want.uri ? want.uri : (wantParam.uri as string));
        if (wantParam?.colorStyle === 'default') {
          AppStorage.setOrCreate<boolean>(Constants.PHOTO_DIRECTLY_ENTER_XTSTYLE, true);
        }
      }
      Log.info(TAG, `entry photo form experience app, param targetPageId: ${targetPageId}, tabName: ${tabName},
          albumLpathName: ${StringUtil.getAnonymizeString(albumLpathName)}`);
      return Constants.ENTRY_FROM_PROTOTYPE_EXPERIENCE_APP;
    }

    const entry = lockedScreenMgr().wakenByLockScreen(wantParam);
    if (want.action === wantConstant.Action.ACTION_VIEW_DATA) {
      if (want.type?.startsWith?.(PhotoDataSource.VIDEO_TYPE_PREFIX_STR)) {
        AppStorage.setOrCreate<photoAccessHelper.PhotoType>('viewDataType', UserFileManagerAccess.MEDIA_TYPE_VIDEO);
      } else {
        AppStorage.setOrCreate<photoAccessHelper.PhotoType>('viewDataType', UserFileManagerAccess.MEDIA_TYPE_IMAGE);
      }
      if (!wantParam) {
        return Constants.ENTRY_FROM_VIEW_DATA;
      }
      isShowMenuFromThirdView = wantParam?.isShowMenu as boolean;
      AppStorage.setOrCreate<string>('viewDataUri', want.uri ? want.uri : (wantParam?.uri as string));
      AppStorage.setOrCreate<boolean>('isAllMediaData',
        wantParam?.isAllMediaData ? wantParam.isAllMediaData as boolean : false);
      AppStorage.setOrCreate<string>('viewDataAlbumUri', wantParam?.albumUri ? wantParam.albumUri as string : '');
      AppStorage.setOrCreate<string>('viewDataIndex', wantParam?.viewIndex ? wantParam.viewIndex as string : '');
      AppStorage.setOrCreate<string>('viewDataPhotoWidth', wantParam?.width ? wantParam.width as string : '0');
      AppStorage.setOrCreate<string>('viewDataPhotoHeight', wantParam?.height ? wantParam.height as string : '0');
      AppStorage.setOrCreate<string>('viewDataToHwShareGird',
        wantParam?.hwShareGird ? wantParam.hwShareGird as string : '0');
      return Constants.ENTRY_FROM_VIEW_DATA;
    } else if (isFromCardEditor) {
      return Constants.ENTRY_FROM_FORM_FORM_EDITOR;
    }
    return entry;
  }

  private initPhotosPref(): void {
    Log.info(TAG, 'Application initPhotosPref start');
    const photosAbilityContext: common.UIAbilityContext | undefined =
      this.storage?.get<common.UIAbilityContext>('photosAbilityContext');
    if (!photosAbilityContext) {
      reportEmpty('photosAbilityContext is empty');
      return;
    }
    let oldArea: contextConstant.AreaMode = photosAbilityContext.area;
    photosAbilityContext.area = contextConstant.AreaMode.EL1;
    try {
      data_preferences.getPreferences(photosAbilityContext, Constants.PHOTOS_STORE_KEY)
        .then((pref: data_preferences.Preferences): void => {
          pref.get(Constants.IS_FIRST_TIME_DELETE, true).then((data: data_preferences.ValueType): void => {
            AppStorage.setOrCreate<boolean>(Constants.IS_FIRST_TIME_DELETE, data as boolean);
          }).catch((err: BusinessError): void => {
            Log.error(TAG, `Failed to get whether first time delete, err: ${err}, code: ${err?.code}`);
          });
          AppStorage.setOrCreate<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY, pref);
          this.storage?.setOrCreate(Constants.LOCAL_KEY_PREFERENCES, pref);
        })
        .catch((err: Error): void => {
          Log.error(TAG, `Failed to get preferences.${err}`);
        }).finally(() => {
        photosAbilityContext.area = oldArea;
      });
    } catch (err) {
      Log.error(TAG, `Failed to get preferences, Cause: ${err}`);
    }

  }

  /**
   * 注册系统音量监听
   */
  /* instrument ignore next */
  private registerAudioEvent(): void {
    Log.info(TAG, '[videoPlayer] register audio event');
    try {
      this.audioVolumeManager.on('volumeChange', (event: audio.VolumeEvent): void => {
        let isMute = AppStorage.get<boolean>('isMute');
        Log.info(TAG, `[videoPlayer] system volume changed, volumeType: ${
        event.volumeType}, volume: ${event.volume}, updateUI: ${event.updateUi}, isMute: ${isMute}`);
        if (event.volumeType === audio.AudioVolumeType.MEDIA && isMute) {
          AppStorage.set<boolean>('isMute', false);
        }
        if (event.volumeType === audio.AudioVolumeType.MEDIA && event.volume === 0) {
          AppStorage.set<boolean>('isMute', true);
        }
      });
    } catch (err) {
      Log.error(TAG, `[videoPlayer] register audio event error msg: ${err?.msg}, code: ${err?.code}`);
    }
  }

  private unregisterAudioEvent(): void {
      this.audioVolumeManager?.off?.('volumeChange');
  }

  /**
   * 注册图库云同步
   */
  private registerCloudSync(): void {
    Log.info(TAG, '[cloudSync] register');
  }

  /* instrument ignore next */
  private saveSmallFoldWant(want: Want): void {
    if (want.parameters?.cameraShotKey) {
      AppStorage.setOrCreate<string>('cameraShotKey', assert.asDefault(want.parameters?.cameraShotKey, ''));
    }
    if (want.parameters?.videoPlayProgress) {
      AppStorage.setOrCreate<number>('video_play_progress', assert.asDefault(want.parameters?.videoPlayProgress, 0));
    } else {
      AppStorage.setOrCreate<number | undefined>('video_play_progress', undefined);
    }
    if (want.parameters?.isDeleting) {
      AppStorage.setOrCreate<boolean>('is_deleting', assert.asDefault(want.parameters?.isDeleting, false));
    } else {
      AppStorage.setOrCreate<boolean>('is_deleting', false);
    }
    this.storage?.setOrCreate<boolean>('is_from_sub_screen', true);
  }
}
