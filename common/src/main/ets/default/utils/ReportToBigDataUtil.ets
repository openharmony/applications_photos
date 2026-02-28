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

import lazy hiSysEvent from '@ohos.hiSysEvent';
import lazy { Log } from './Log';
import type { MediaItem } from '../model/browser/photo/MediaItem';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import type { ValueType } from '@ohos.data.ValuesBucket';
import lazy { Constants } from '../model/common/Constants';
import lazy { Obj } from '@ohos/tools/tsIgnore/standardLibrary/Obj.e';
import lazy { process } from '@kit.ArkTS';
import lazy { AlbumInfo } from '../../../ets/default/model/browser/album/AlbumInfo'

export interface AlbumScaleDFXOption {
  from: number,
  target: number,
  count: number,
}

const TAG: string = 'ReportToBigDataUtil';

export declare type BigDataMsg = Record<string, ValueType | undefined>;

export class ReportToBigDataUtil {
  /**
   * 前缀的字符个数是4（IMG_,VID_）
   */
  private static readonly PREFIX_NUMBER: number = 4;
  /**
   * DFT打点域
   */
  public static readonly PHOTOS_DFX_DOMAIN: string = 'PHOTOS';
  /**
   * UE打点域
   */
  private static readonly PHOTOS_UE_DOMAIN: string = 'PHOTOS_UE';
  /**
   * 应用版本及包信息
   */
  private static currentBundleInfo: bundleManager.BundleInfo | undefined = undefined;

  public static report(eventId: string, eventMsg?: object | BigDataMsg): void {
    ReportToBigDataUtil.constructEventMsg(eventMsg).then((msg: object): void => {
      ReportToBigDataUtil.reportByType(hiSysEvent.EventType.BEHAVIOR, eventId, msg, true);
    });
  }

  public static statisticReport(eventId: string, eventMsg?: object | BigDataMsg): void {
    ReportToBigDataUtil.constructEventMsg(eventMsg).then((msg: object): void => {
      ReportToBigDataUtil.reportByType(hiSysEvent.EventType.STATISTIC, eventId, msg, true);
    });
  }

  public static urlAnonymize(url: string): string {
    let splitterIndex: number = url.lastIndexOf('/');
    return `${url.substring(0, splitterIndex)}/****`;
  }

  public static reportOperationLatency(scienceType: string,
    startTime: number,
    e2eLatency: number,
    totalCount: number): void {
    try {
      bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).then((data) => {
        let eventMsg: Record<string, number | string> = {
          'APP_PID': process.pid,
          'VERSION_CODE': data.versionCode,
          'VERSION_NAME': data.versionName,
          'PROCESS_NAME': data.name,
          'BUNDLE_NAME': data.name,
          'ABILITY_NAME': data.name,
          'PAGE_URL': scienceType,
          'PAGE_NAME': scienceType,
          'SCENCE_TYPE': scienceType,
          'INPUT_TIME': startTime,
          'E2E_LATENCY': e2eLatency,
          'FAULT_THRESHOLD': BigDataConstants.FAULT_THRESHOLD,
          'TOTAL_COUNT': totalCount
        };
        Log.info(TAG, `reportOperationLatency, eventMsg: ${JSON.stringify(eventMsg)}`)
        ReportToBigDataUtil.statisticEventReport(BigDataConstants.APP_OPERATION_LATENCY, eventMsg);
      })
    } catch (err) {
      Log.error(TAG, `reportOperationLatency fail, errCode: ${err?.code}, msg: ${err?.message}`)
    }
  }

  /**
   * 打印DFX公共逻辑
   *
   * @param selectedItems 媒体项
   * @param dfxOption 打点配置项
   */
  /* instrument ignore next */
  public static albumScaleDfxHandler(dfxOption: AlbumScaleDFXOption): void {
    /* instrument ignore if*/
    if (!dfxOption) {
      Log.info(TAG, 'albumScaleDfxHandler has been executed');
      return;
    }
    // 判断打印打点必须的参数
    const msg: Record<string, number | string | boolean> = {
      // 原始相册风格 小宫格0 大宫格1
      'albumStyleFrom': dfxOption.from,
      // 目标相册风格
      'albumStyleTarget': dfxOption.target,
      // 相册页相册的数量
      'albumNumber': dfxOption.count,
    };
    ReportToBigDataUtil.report(BigDataConstants.albumStyleSwitch, msg);
  }

  /* instrument ignore next */
  public static downloadOriginReport(
    scene: string,
    timeCost: number,
    exception: string,
    count: number = 1,
    failCount: number = 0,
  ): void {
    const triggerTime = new Date(Date.now() - timeCost).toISOString();
    const msg: Record<string, number | string> = {
      'scene': scene,
      'triggerTime': triggerTime,
      'count': count,
      'timeCost': timeCost,
      'failCount': count === 1 && exception !== '' ? 1 : failCount,
      'exception': exception,
    };
    ReportToBigDataUtil.report(BigDataConstants.HAVE_EXP_TYPE_DOWNLOAD_ORIGIN, msg);
  }

  private static async constructEventMsg(eventMsg?: object | BigDataMsg): Promise<object | BigDataMsg> {
    let bundleInfo = await ReportToBigDataUtil.loadBundleInfo();
    // instrument ignore if
    if (!bundleInfo && eventMsg) {
      return eventMsg;
    }
    let packInfo: Record<string, string> = { 'pNameId': bundleInfo.name, 'pVersionId': bundleInfo.versionName };
    let msg = eventMsg ? Obj.assign({}, packInfo, eventMsg) : packInfo;
    return msg;
  }

  private static async loadBundleInfo(): Promise<bundleManager.BundleInfo> {
    if (ReportToBigDataUtil.currentBundleInfo) {
      return ReportToBigDataUtil.currentBundleInfo;
    }

    let bundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
    return await bundleManager.getBundleInfoForSelf(bundleFlag);
  }


  public static errEventReport(eventId: string, eventMsg?: object | BigDataMsg): void {
    ReportToBigDataUtil.reportByType(hiSysEvent.EventType.FAULT, eventId, eventMsg);
  }

  /* 统计打点 */
  public static statisticEventReport(eventId: string, eventMsg?: object | BigDataMsg): void {
    ReportToBigDataUtil.reportByType(hiSysEvent.EventType.STATISTIC, eventId, eventMsg);
  }

  public static reportByType(eventType: hiSysEvent.EventType, eventId: string, eventMsg?: object |
  BigDataMsg, isUE ?: boolean):

    void {
    let info: hiSysEvent.SysEventInfo = {
      domain: isUE ? ReportToBigDataUtil.PHOTOS_UE_DOMAIN : ReportToBigDataUtil.PHOTOS_DFX_DOMAIN,
      name: eventId,
      eventType: eventType,
      params: eventMsg,
    };
    hiSysEvent.write(info, (err, val) => {
      /* instrument ignore if*/
      if (err) {
        Log.error(TAG, JSON.stringify({ err, info, val }));
      } else {
        Log.info(TAG, eventMsg ? ` ${info.domain} eventId: ${info.name} eventType: ${info.eventType} ${info.params}` :
          `eventId: ${eventId} eventType: ${eventType}`);
      }
    });
  }

  // 获取相机拍摄照片视频的名称
  public static getFileNameOfPhotoTakenByCamera(mediaItem?: MediaItem): string {
    if (!mediaItem) {
      return '';
    }
    let name = mediaItem.getTitle();
    if (!name) {
      return '';
    }
    // 匹配相机拍摄照片视频的命名格式
    let formatExp: RegExp = /^(IMG|VID)\_\d{8}\_\d{6}$/;
    if (!name.match(formatExp)) {
      return '';
    }
    // 去除前缀
    return name.slice(ReportToBigDataUtil.PREFIX_NUMBER, name.length);
  }

  public static setFileNameProperty(eventMsg: BigDataMsg, name: string): void {
    /* instrument ignore if*/
    if (!eventMsg || !name) {
      return;
    }
    eventMsg['FileName'] = name;
  }

  public static getEnterPhotoBrowserPosition(barIndex: number): number {
    // 打开大图的位置，0-搜索实时搜索界面，1-搜索“更多”界面，2-照片页，3-相册页，4-时刻页，5-其他界面
    /* instrument ignore if*/
    if (barIndex === 0) {
      return BigDataConstants.OPERATION_IN_TIMELINE_PAGE;
    } else if (barIndex === 1) {
      return BigDataConstants.OPERATION_IN_ALBUM_PAGE;
    }
    return BigDataConstants.OPERATION_IN_OTHER_PAGE;
  }

  public static getPhotoBrowserScenario(index: number): number {
    let isSearch: boolean = LocalStorage?.getShared()?.get<boolean>('isSearch') ?? false;
    if (isSearch) {
      return Scenario.SEARCH_PAGE;
    }
    if (index === 0) {
      return Scenario.PHOTO_PAGE;
    } else if (index === 1) {
      return Scenario.ALBUM_PAGE;
    } else if (index === 2) {
      return Scenario.HIGHLIGHT_PAGE;
    }
    return Scenario.OTHER_PAGE;
  }

  public static getDisplayName(albumInfo: AlbumInfo): Resource | string {
    let map = new Map<string, Resource>([
      ['10001', $r('app.string.delicacy')],
      ['10002', $r('app.string.landscape')],
      ['10003', $r('app.string.document')],
      ['4', $r('app.string.id_card')],
      ['6', $r('app.string.bank_card')],
      ['10007', $r('app.string.motion')],
      ['10008', $r('app.string.means_of_transportation')],
      ['11', $r('app.string.aircraft')],
      ['14', $r('app.string.cats')],
      ['25', $r('app.string.blossom')],
      ['40', $r('app.string.city_overlook')],
      ['47', $r('app.string.night_view')],
      ['52', $r('app.string.high_mountain')],
      ['53', $r('app.string.construct')],
      ['55', $r('app.string.waterfall')],
      ['59', $r('app.string.rainbow')],
      ['62', $r('app.string.Statue_of_liberty')],
      ['63', $r('app.string.ppt')],
      ['68', $r('app.string.dinner_party')],
      ['69', $r('app.string.eiffel_tower')],
      ['97', $r('app.string.graduation_photo')],
      ['102', $r('app.string.wrist_watch')],
      ['105', $r('app.string.fountain')],
      ['107', $r('app.string.fireworks')],
      ['108', $r('app.string.business_card')],
      ['112', $r('app.string.panda')],
      ['113', $r('app.string.birthday_cake')],
      ['117', $r('app.string.the_oriental_pearl_tower')]
    ])
    if (typeof albumInfo.albumName === 'string') {
      return map.get(albumInfo.albumName as string) ?? '';
    }
    return albumInfo.albumName;
  }
}

export class BigDataConstants {
  // drag event name
  public static readonly ALBUM_DRAG_OPERATION: string = 'ALBUM_DRAG_OPERATION';
  // 相册拖拽排序
  public static readonly ALBUM_SORT_OPERATION: string = 'ALBUM_SORT_OPERATION';
  public static readonly SLIDE_SHOW: string = 'SLIDE_SHOW';
  // 进入图库方式
  public static readonly ENTER_PHOTOS_ID: string = 'ENTER_PHOTO';
  // 进入图库参数错误
  public static readonly ENTER_PHOTOS_PARAM_ERROR: string = 'ENTER_PHOTOS_PARAM_ERROR';
  // param
  public static readonly ENTER_BY_CAMERA: string = 'ENTER_BY_CAMERA';
  public static readonly ENTER_BY_PETALCLIP: string = 'ENTER_BY_PETALCLIP';
  // Tab切换
  public static readonly TAB_SWITCH_ID: string = 'TAB_SWITCH';
  // param
  public static readonly CLICK_SWITCH: string = 'Click';
  // 查看大图
  public static readonly ENTER_PHOTO_BROWSER_ID: string = 'ENTER_PHOTO_BROWSER';
  // param
  public static readonly LOCAL_MEDIA: string = 'LOCAL_MEDIA';
  // 查看大图
  public static readonly PHOTO_BROWSER_SLIDE_ID: string = 'PHOTO_BROWSER_SLIDE';
  // param
  public static readonly NORMAL_PHOTO: string = 'PHOTO';
  public static readonly VIDEO: string = 'VIDEO';
  // 调整宫格大小
  public static readonly GRID_MAGNITUDE_CHANGE: string = 'GRID_MAGNITUDE_CHANGE';
  // 删除类型操作
  public static readonly DELETE_TYPE_ID: string = 'DELETE_TYPE';
  // param
  public static readonly DELETE_LOCAL_ONLY: string = 'DELETE_LOCAL_ONLY';
  public static readonly REMOVE: string = 'REMOVE';
  // 删除类型操作
  public static readonly SPLIT_SCREEN_ID: string = 'SPLIT_SCREEN';
  // 相机进入大图操作
  public static readonly BROWSE_PHOTO_FROM_CAMERA_ID: string = 'BROWSE_PHOTO_FROM_CAMERA';
  // 进入大图组件时
  public static readonly BROWSE_PHOTO_FROM_APP_LOCK: string = 'BROWSE_PHOTO_FROM_APP_LOCK';
  // 下拉返回操作
  public static readonly PHOTO_PULL_DOWN_ID: string = 'PHOTO_PULL_DOWN';
  // 大图查看体验操作
  public static readonly PHOTO_GESTURE_ACTION_ID: string = 'PHOTO_GESTURE_ACTION';
  //长按浮起菜单
  public static readonly LONG_PRESS: string = 'PHOTOS_LONG_PRESS_MENU';
  //长按浮起菜单点击
  public static readonly LONG_PRESS_MENU_CLICK: string = 'PHOTOS_LONG_PRESS_MENU_CLICK';
  // 全选操作
  public static readonly SELECT_ALL_ID: string = 'PHOTOS_SELECT_ALL';
  // 多选模式
  public static readonly MULTI_SELECT_MODE: string = 'MULTI_SELECT_MODE';
  // 多选分享操作
  public static readonly MULTI_SHARE_ID: string = 'MULTI_SHARE';
  // 发送至U盘结果
  public static readonly CREATE_FA_CARD_ID: string = 'CREATE_FA_CARD';
  public static readonly CREATE_THIRD_EDIT: string = 'CREATE_THIRD_EDIT';
  public static readonly CREATE_THIRD_EDIT_SAVE: string = 'CREATE_THIRD_EDIT_SAVE';
  public static readonly DELETE_FA_CARD_ID: string = 'DELETE_FA_CARD';
  public static readonly CHANGE_FA_CARD_IMAGE_ID: string = 'CHANGE_FA_CARD_IMAGE';
  public static readonly SET_FA_CARD_IS_NAME_ID: string = 'SET_FA_CARD_IS_NAME';
  // 选择Picker操作
  public static readonly SELECT_PICKER_ID: string = 'SELECT_PICKER';
  public static readonly SELECT_PICKER_RESULT: string = 'SELECT_PICKER_RESULT';
  public static readonly SELECT_PICKER_CLICK_CAMERA_ID: string = 'SELECT_PICKER_CLICK_CAMERA';
  public static readonly SELECT_PICKER_CLICK_PREVIEW: string = 'SELECT_PICKER_CLICK_PREVIEW';
  public static readonly SELECT_PICKER_INPUT_NUMBER: string = 'SELECT_PICKER_INPUT_NUMBER';
  public static readonly SELECT_PICKER_INDEX: string = 'SELECT_PICKER_INDEX';
  // picker隐私保护页
  public static readonly PICKER_ENTER_PRIVACY_VIEW: string = 'PICKER_ENTER_PRIVACY_VIEW';
  public static readonly PICKER_EXIT_PRIVACY_VIEW: string = 'PICKER_EXIT_PRIVACY_VIEW';
  public static readonly PICKER_PRIVACY_OPTION_CHANGE: string = 'PICKER_PRIVACY_OPTION_CHANGE';
  // ERROR
  public static readonly FA_CARD_ERROR: string = 'FA_CARD_ERROR';
  public static readonly CREATE_FA_CARD_ERROR: string = 'CREATE_FA_CARD_ERROR';
  public static readonly CHANGE_FA_CARD_IMAGE_ERROR: string = 'CHANGE_FA_CARD_IMAGE_ERROR';
  public static readonly SET_FA_CARD_IS_NAME_ERROR: string = 'SET_FA_CARD_IS_NAME_ERROR';
  // Tab
  public static readonly PHOTO_TAB: string = 'TIME';
  public static readonly ALBUM_TAB: string = 'LIST';
  public static readonly HIGHLIGHT_TAB: string = 'HIGHLIGHT';
  // 大数据打点tab转换
  public static readonly TAB_KEYS: ReadonlyMap<string, string> = new Map(
    [
      [Constants.COMPONENT_KEY_PHOTOS, BigDataConstants.PHOTO_TAB],
      [Constants.COMPONENT_KEY_ALBUMS, BigDataConstants.ALBUM_TAB],
      [Constants.COMPONENT_KEY_HIGHLIGHTS, BigDataConstants.HIGHLIGHT_TAB]
    ]);
  // 大图编辑操作
  public static readonly PHOTO_EDIT_TYPE_ID: string = 'PHOTO_EDIT_OPERATION';
  // 大图 - 图片是否支持编辑
  public static readonly SUPPORT_IMAGE_EDITOR: string = 'SUPPORT_IMAGE_EDITOR';
  // param
  public static readonly PHOTO_EDIT_ROTATE: string = 'ROTATE';
  public static readonly PHOTO_EDIT_MIRROR: string = 'MIRROR';
  public static readonly PHOTO_EDIT_RESET: string = 'RESET';
  // 编辑保存
  public static readonly PHOTO_EDIT_SAVE_ID: string = 'PHOTO_EDIT_SAVE';
  //param
  public static readonly SAVE_AS_NEW: string = 'SAVE_AS_NEW';
  public static readonly SAVE_REPLACE: string = 'SAVE_REPLACE';
  // 进入照片页、相册页、设置页
  public static readonly ENTER_TIMELINE_PAGE: string = 'ENTER_TIMELINE_PAGE';
  public static readonly ENTER_ALBUM_SET_PAGE: string = 'ENTER_ALBUM_SET_PAGE';
  public static readonly ENTER_SETTINGS_PAGE: string = 'ENTER_SETTINGS_PAGE';
  // 编辑保存失败
  public static readonly PHOTO_EDIT_SAVE_ERROR_ID: string = 'GALLERY_FILE_EDIT_SAVE_FAIL';
  // 进入大图方式
  public static readonly ENTER_PHOTO_BROWSER_WAY: string = 'ENTER_PHOTO_BROWSER_WAY';
  // 退出大图方式
  public static readonly ESC_PHOTO_BROWSER_WAY: string = 'ESC_PHOTO_BROWSER_WAY';
  // 方式
  public static readonly BY_KEYBOARD: string = 'BY_KEYBOARD';
  public static readonly BY_CLICK: string = 'BY_CLICK';
  // 大图打开动画
  public static readonly PHOTO_BROWSER_ANIMATION_START: string = 'PHOTO_BROWSER_ANIMATION_START';
  public static readonly PHOTO_BROWSER_ANIMATION_FINISH: string = 'PHOTO_BROWSER_ANIMATION_FINISH';
  // 大图组件初始化接口加载组件
  public static readonly PHOTO_BROWSER_CONTROLLER_INIT: string = 'PHOTO_BROWSER_CONTROLLER_INIT';
  // 大图组件初始化接口加载组件
  public static readonly PHOTO_BROWSER_VIEW_ABOUT: string = 'PHOTO_BROWSER_VIEW_ABOUT';
  public static readonly PHOTO_BROWSER_VIEW_ABOUT_TO_APPEAR: string = 'aboutToAppear';
  public static readonly PHOTO_BROWSER_VIEW_ABOUT_TO_DISAPPEAR: string = 'aboutToDisappear';
  // 相机拉起大图组件时延
  public static readonly PULL_UP_PHOTO_BROWSER_VIEW_DELAY: string = 'PULL_UP_PHOTO_BROWSER_VIEW_DELAY';
  // 相册操作
  public static readonly ALBUM_OPERATION_ID: string = 'ALBUM_OPERATION';
  public static readonly ALBUM_CREATE: string = 'ALBUM_CREATE';
  public static readonly ALBUM_RENAME: string = 'ALBUM_RENAME';
  public static readonly MEDIA_COPY: string = 'MEDIA_COPY';
  public static readonly ALBUM_DELETE: string = 'ALBUM_DELETE';
  public static readonly ALBUM_ADD: string = 'ALBUM_ADD';
  public static readonly albumStyleSwitch: string = 'ALBUM_STYLE_SWITCH';
  public static readonly ALBUM_BROWSING_DURATION: string = 'ALBUM_BROWSING_DURATION';
  // error
  public static readonly ALBUM_OPERATION_ERROR_ID: string = 'ALBUM_OPERATION_ERROR';
  public static readonly ALBUM_CREATE_ERROR: string = 'ALBUM_CREATE_ERROR';
  public static readonly ALBUM_RENAME_ERROR: string = 'ALBUM_RENAME_ERROR';
  public static readonly MEDIA_COPY_ERROR: string = 'MEDIA_COPY_ERROR';
  public static readonly MEDIA_REMOVE_ERROR: string = 'MEDIA_REMOVE_ERROR';
  // 是否显示菜单栏
  public static readonly IS_SHOW_MENU_ID: string = 'IS_SHOW_MENU_FROM_THIRDVIEW';
  // 打开系统相册的次数，24小时内不重复上报
  public static readonly OPEN_SYSTEM_ALBUM_TIMES_ID: string = 'NEW_OPEN_SYSTEM_ALBUM_TIMES';
  // 系统相册显示与消失事件打点ID
  public static readonly SYSTEM_ALBUM_IS_SHOW_ID: string = 'SYSTEM_ALBUM_IS_SHOW';
  public static readonly SYSTEM_ALBUM_APPEAR: string = 'APPEAR';
  public static readonly SYSTEM_ALBUM_DISAPPEAR: string = 'DISAPPEAR';
  // 端云下载原图
  public static readonly DOWNLOAD_ORIGIN_PHOTO_ID: string = 'DOWNLOAD_ORIGIN_PHOTO_ID';
  public static readonly ENTER_COLLAGE_FAIL: string = 'ENTER_COLLAGE_FAIL';
  public static readonly ENTER_COLLAGE_ID: string = 'ENTER_COLLAGE_ID';
  // 触发下载场景
  public static readonly DOWNLOAD_FOR_EDIT: string = 'DOWNLOAD_FOR_EDIT';
  public static readonly DOWNLOAD_FOR_COMPARE: string = 'DOWNLOAD_FOR_COMPARE';
  public static readonly DOWNLOAD_FOR_COLLAGE: string = 'DOWNLOAD_FOR_COLLAGE';
  public static readonly DOWNLOAD_FOR_VIDEO_PLAY: string = 'DOWNLOAD_FOR_VIDEO_PLAY';
  public static readonly DOWNLOAD_FOR_PHOTO_SCALE: string = 'DOWNLOAD_FOR_PHOTO_SCALE';
  public static readonly DOWNLOAD_FOR_PHOTO_PRINT: string = 'DOWNLOAD_FOR_PHOTO_PRINT';
  public static readonly DOWNLOAD_FOR_DOCUMENT_SCAN: string = 'DOWNLOAD_FOR_DOCUMENT_SCAN';
  // 点击图库设置中账号菜单行为事件（账号未登录）
  public static readonly NOT_LOG_IN_ACCOUNT_CLICK: string = 'NOT_LOG_IN_ACCOUNT_CLICK';
  // 下载网络情况
  public static readonly NETWORK_AVAILABLE: string = 'NETWORK_AVAILABLE';
  public static readonly NETWORK_UNAVAILABLE: string = 'NETWORK_UNAVAILABLE';
  // 下载文件耗时
  public static readonly DOWNLOAD_PHOTO_TIME_COST: string = 'DOWNLOAD_PHOTO_TIME_COST';
  // 下载失败原因
  public static readonly DOWNLOAD_FAIL_REASON: string = 'DOWNLOAD_FAIL_REASON';
  // 照片页顶部数量信息
  public static readonly MEDIA_COUNT_ID: string = 'MEDIA_COUNT_ID';
  // 设置页同步开关切换
  public static readonly SPACE_RELEASE_TOGGLE_ID: string = 'SPACE_RELEASE_TOGGLE_ID';
  // 无限量使用移动网络
  public static readonly MOBILE_NETWORK_TOGGLE_ID: string = 'MOBILE_NETWORK_TOGGLE_ID';
  // 用户照片页下拉触发端云同步
  public static readonly TOUCH_DOWN_START_SYNC: string = 'TOUCH_DOWN_START_SYNC';
  // 图库网络连接
  public static readonly NETWORK_CONNECTION_TOGGLE_ID: string = 'NETWORK_CONNECTION_TOGGLE_ID';
  // 图库网络连接切换
  public static readonly NETWORK_CONNECTION_SWITCH: string = 'NETWORK_CONNECTION_SWITCH';
  // 图库网络连接-开启
  public static readonly NETWORK_CONNECTION_OPEN_STATUS: string = 'NETWORK_CONNECTION_OPEN_STATUS';
  // 图库网络连接-关闭
  public static readonly NETWORK_CONNECTION_CLOSE_STATUS: string = 'NETWORK_CONNECTION_CLOSE_STATUS';
  // 云增强相关
  // 点击“增强”图标触发云增强
  public static readonly TRIGGER_AI_CLOUD_ENHANCE: string = 'TRIGGER_AI_CLOUD_ENHANCE';
  // 大图浏览到已触发、未完成云增强图片时，调整云端增强优先级
  public static readonly PRIORITIZE_AI_CLOUD_ENHANCE: string = 'PRIORITIZE_AI_CLOUD_ENHANCE';
  // 图库大图页_云助端隐私协议的弹出、同意、取消
  public static readonly AI_CLOUD_ENHANCE_PRIVACY_DIALOG: string = 'AI_CLOUD_ENHANCE_PRIVACY_DIALOG';
  // 图库设置_扩展服务页云增强隐私开关状态切换（默认关闭）
  public static readonly AI_CLOUD_ENHANCE_PRIVACY_SWITCH: string = 'AI_CLOUD_ENHANCE_PRIVACY_SWITCH';
  // 设置页云增强服务开关状态切换（默认开启）
  public static readonly AI_CLOUD_ENHANCE_SERVICE_SWITCH: string = 'AI_CLOUD_ENHANCE_SERVICE_SWITCH';
  // 设置页云增强水印开关状态切换（默认开启）
  public static readonly CLOUD_ENHANCE_WATERMARK_SWITCH: string = 'CLOUD_ENHANCE_WATERMARK_SWITCH';
  // 用户打开自动云增强照片（待增强及增强中）时，进行手动点击魔法棒进行手动云增强
  public static readonly CLOUD_ENHANCE_WHEN_TRIGGERED: string = 'CLOUD_ENHANCE_WHEN_TRIGGERED';
  // 浏览触发自动云增强
  public static readonly TRIGGER_CLOUD_ENHANCE_AUTO: string = 'TRIGGER_CLOUD_ENHANCE_AUTO';
  // 自动云增强引导弹窗
  public static readonly AUTO_CLOUD_ENHANCE_GUIDE_POPUP: string = 'AUTO_CLOUD_ENHANCE_GUIDE_POPUP';
  // 设置页自动云增强服务开关状态切换（默认关闭）
  public static readonly AUTO_CLOUD_ENHANCE_SWITCH: string = 'AUTO_CLOUD_ENHANCE_SWITCH';
  // 账号登录异常
  public static readonly ACCOUNT_LOGIN_ERROR: string = 'ACCOUNT_LOGIN_ERROR';
  // 用户详情查看情况
  public static readonly PHOTO_DETAIL_OPEN_COUNT: string = 'PHOTO_DETAIL_OPEN_COUNT';
  public static readonly PHOTO_DETAIL_PULL_UP: string = 'PHOTO_DETAIL_PULL_UP';
  public static readonly PHOTO_DETAIL_CLICK: string = 'PHOTO_DETAIL_CLICK';
  public static readonly PHOTO_DETAIL_SWIPER: string = 'PHOTO_DETAIL_SWIPER';
  // 浅层交互
  public static readonly PHOTO_FAST_EDIT_BEAUTY: string = 'PHOTO_FAST_EDIT_BEAUTY';
  public static readonly DO_FAST_EDIT_BEAUTY: string = 'DO_FAST_EDIT_BEAUTY';
  public static readonly DO_FAST_EDIT_BEAUTY_FINISH: string = 'DO_FAST_EDIT_BEAUTY_FINISH';
  public static readonly CANCEL_FAST_EDIT_BEAUTY: string = 'CANCEL_FAST_EDIT_BEAUTY';
  public static readonly CANCEL_FAST_EDIT_BEAUTY_FINISH: string = 'CANCEL_FAST_EDIT_BEAUTY_FINISH';
  // 最佳呈现信息
  public static readonly PHOTO_SALIENCY_PULL_UP: string = 'PHOTO_SALIENCY_PULL_UP';
  public static readonly PHOTO_SALIENCY_CLICK_DETAIL: string = 'PHOTO_SALIENCY_CLICK_DETAIL';
  public static readonly PHOTO_SALIENCY_SHOW: string = 'PHOTO_SALIENCY_SHOW';
  public static readonly PHOTO_ERROR_FOR_NO_ANALYSIS: string = 'PHOTO_ERROR_FOR_NO_ANALYSIS';
  public static readonly PHOTO_ERROR_FOR_NOT_SUPPORT: string = 'PHOTO_ERROR_FOR_NOT_SUPPORT';
  public static readonly PHOTO_SHOW_FOR_FAILED: string = 'PHOTO_SHOW_FOR_FAILED';
  // 冷启动
  public static readonly ABILITY_START: string = 'ABILITY_START';
  public static readonly DATA_LOAD_START: string = 'DATA_LOAD_START';
  public static readonly DATA_LOAD_FINISH: string = 'DATA_LOAD_FINISH';
  public static readonly INDEX_APPEAR: string = 'INDEX_APPEAR';
  // 宫格图片来源
  public static readonly GRID_ALBUM_PHOTO: string = 'GRID_ALBUM_PHOTO';
  // 复制操作
  public static readonly COPY_MENU_RESPONSE: string = 'COPY_MENU_RESPONSE';
  public static readonly COPY_FILE_OPERATION_START: string = 'COPY_FILE_OPERATION_START';
  public static readonly COPY_FILE_OPERATION_FINISH: string = 'COPY_FILE_OPERATION_FINISH';
  // 删除操作
  public static readonly DELETE_MENU_RESPONSE: string = 'DELETE_MENU_RESPONSE';
  public static readonly DELETE_FILE_OPERATION_START: string = 'DELETE_FILE_OPERATION_START';
  public static readonly APP_OPERATION_LATENCY: string = 'APP_OPERATION_LATENCY';
  public static readonly FAULT_THRESHOLD: number = 3200;
  public static readonly DELETE_FILE_OPERATION_FINISH: string = 'DELETE_FILE_OPERATION_FINISH';
  // 回收站删除
  public static readonly DELETE_FROM_TRASH: string = 'DELETE_FROM_TRASH';
  // 原图下载
  public static readonly HAVE_EXP_TYPE_DOWNLOAD_ORIGIN: string = 'HAVE_EXP_TYPE_DOWNLOAD_ORIGIN';
  //隐藏
  public static readonly HIDE_MENU_RESPONSE: string = 'HIDE_MENU_RESPONSE';
  public static readonly HIDE_FILE_OPERATION_START: string = 'HIDE_FILE_OPERATION_START';
  public static readonly HIDE_FILE_OPERATION_FINISH: string = 'HIDE_FILE_OPERATION_FINISH';
  // 移除操作
  public static readonly REMOVE_MENU_RESPONSE: string = 'REMOVE_MENU_RESPONSE';
  public static readonly REMOVE_FILE_OPERATION_START: string = 'REMOVE_FILE_OPERATION_START';
  public static readonly REMOVE_FILE_OPERATION_FINISH: string = 'REMOVE_FILE_OPERATION_FINISH';
  // 移除大图图片来源
  public static readonly REMOVE_LARGER_ALBUM_PHOTO: string = 'REMOVE_LARGER_ALBUM_PHOTO';
  // 批量删除宫格图片
  public static readonly BATCH_DELETE_PHOTO_GRID_ALBUM: string = 'BATCH_DELETE_PHOTO_GRID_ALBUM';
  // 批量删除宫格图片
  public static readonly BATCH_HIDE_PHOTO_GRID_ALBUM: string = 'BATCH_HIDE_PHOTO_GRID_ALBUM';
  // 照片大图来源
  public static readonly DELETE_PHOTO_LARGER_ALBUM: string = 'DELETE_PHOTO_LARGER_ALBUM';
  // 隐藏-照片大图来源
  public static readonly HIDE_PHOTO_LARGER_ALBUM: string = 'HIDE_PHOTO_LARGER_ALBUM';
  // 恢复操作
  public static readonly RECOVER_MENU_RESPONSE: string = 'RECOVER_MENU_RESPONSE';
  // 添加备注
  public static readonly PHOTO_NOTE_ADD: string = 'PHOTO_NOTE_ADD';
  //修改备注
  public static readonly PHOTO_NOTE_CHANGE: string = 'PHOTO_NOTE_CHANGE';
  //复制到剪贴板
  public static readonly PHOTO_COPY_PASTEBOARD: string = 'PHOTO_COPY_PASTEBOARD';
  //滑动多选
  public static readonly PHOTO_SLIDE_SELECT: string = 'PHOTO_SLIDE_SELECT';
  public static readonly PHOTO_SLIDE_SELECT_TYPE: string = 'select';
  public static readonly PHOTO_SLIDE_DESELECT_TYPE: string = 'deselect';
  // 缩略图来源
  public static readonly PHOTO_THUMBNAIL: string = 'PHOTO_THUMBNAIL';
  // 缩略图切换数量
  public static readonly THUMBNAIL_SCROLL_COUNT_ID: string = 'THUMBNAIL_SCROLL_COUNT_ID';
  public static readonly THUMBNAIL_CLICK_COUNT_ID: string = 'THUMBNAIL_CLICK_COUNT_ID';
  // 打印
  public static readonly PHOTO_PRINT_ID: string = 'PHOTO_PRINT_ID';
  // 宫格打印
  public static readonly PHOTO_PRINT_GRID_POSITION: string = 'PHOTO_PRINT_GRID_POSITION';
  // 大图打印
  public static readonly PHOTO_PRINT_BIG_PICTURE_POSITION: string = 'PHOTO_PRINT_BIG_PICTURE_POSITION';
  // 地点相册-进入地点相册
  public static readonly LOCATION_ALBUM_ENTER_ID: string = 'LOCATION_ALBUM_ENTER_ID';
  // 地点相册-地图和城市切换
  public static readonly LOCATION_ALBUM_SWITCH_ID: string = 'LOCATION_ALBUM_SWITCH_ID';
  // 地点相册-进入自定义标点相册
  public static readonly MAP_ALBUM_TO_GRID_PAGE_ID: string = 'MAP_ALBUM_TO_GRID_PAGE_ID';
  // 地点相册-进入城市相册
  public static readonly CITY_ALBUM_TO_GRID_PAGE_ID: string = 'CITY_ALBUM_TO_GRID_PAGE_ID';
  // 地点相册-有效城市相册
  public static readonly CITY_ALBUM_GRID_PAGE_INFO_ID: string = 'CITY_ALBUM_GRID_PAGE_INFO_ID';
  // 地点相册-地图缩放模式切换打点统计
  public static readonly MAP_ZOOM_MODE_SWITCH_ID: string = 'MAP_ZOOM_MODE_SWITCH_ID';
  // 隐藏相册-隐藏操作
  public static readonly ACTION_HIDDEN_ID: string = 'ACTION_HIDDEN_ID';
  // 隐藏相册进入弹窗操作-加锁
  public static readonly HIDE_VIEW_DIALOG_ACTION: string = 'HIDE_VIEW_DIALOG_ACTION';
  // 打点隐藏相册-恢复操作
  public static readonly ACTION_UNHIDDEN_ID: string = 'ACTION_UNHIDDEN_ID';
  // 打点隐藏相册-进入隐藏相册
  public static readonly HIDE_ALBUM_ID: string = 'HIDE_ALBUM_ID';
  // 隐藏相册界面切换
  public static readonly HIDE_ALBUM_STYLE_SWITCH: string = 'HIDE_ALBUM_STYLE_SWITCH';
  //用户保存图片后
  public static readonly SAVE_COLLAGE_ID: string = 'SAVE_COLLAGE_ID';
  // 沉浸式对比-图片校验
  public static readonly ENTER_COMPARE_FAIL: string = 'ENTER_COMPARE_FAIL';
  // 沉浸式对比-选择
  public static readonly ENTER_COMPARE_ID: string = 'ENTER_COMPARE_ID';
  // 沉浸式对比-跳转picker选择
  public static readonly COMPARE_RESOURCE_REPLACE: string = 'COMPARE_RESOURCE_REPLACE';
  // 沉浸式对比收藏
  public static readonly FAVOR_MENU_RESPONSE: string = 'FAVOR_MENU_RESPONSE';
  // 沉浸式退出信息统计
  public static readonly COMPARE_EXIT_RESPONSE: string = 'COMPARE_EXIT_RESPONSE';
  // 拍摄相册入口进入拍摄模式相册
  public static readonly ENTER_SHOOTING_ALBUMS_ID: string = 'ENTER_SHOOTING_ALBUMS_ID';
  // 拍摄模式相册进入图片宫格
  public static readonly SPECIFIC_SHOOTING_GRID_ID: string = 'SPECIFIC_SHOOTING_GRID_ID';
  // 分类入口
  public static readonly CLASSIFY_ALBUMS_ID: string = 'CLASSIFY_ALBUMS_ID';
  // 进入分类相册
  public static readonly ENTER_CLASSIFY_ALBUMS_ID: string = 'ENTER_CLASSIFY_ALBUMS_ID';
  // 进入具体分类
  public static readonly SPECIFIC_CLASSIFY_GRID_ID: string = 'SPECIFIC_CLASSIFY_GRID_ID';
  // 分类删除操作
  public static readonly ACTION_DELETE_ID: string = 'ACTION_DELETE_ID';
  // 进入来源相册
  public static readonly SOURCE_ALBUM_ID: string = 'SOURCE_ALBUM_ID';
  // 人像-相册首页进入人像相册
  public static readonly PORTRAIT_ALBUM_ENTER_ID: string = 'PORTRAIT_ALBUM_ENTER_ID';
  // 人像-大图详情进入人像宫格页
  public static readonly PORTRAIT_PHOTO_PROPERTIES_ENTER_ID: string = 'PORTRAIT_PHOTO_PROPERTIES_ENTER_ID';
  // 人像-相册个人和合影切换
  public static readonly PORTRAIT_ALBUM_SWITCH_ID: string = 'PORTRAIT_ALBUM_SWITCH_ID';
  // 人像-人像相册定期打点
  public static readonly PORTRAIT_ALBUM_PAGE_INFO_ID: string = 'PORTRAIT_ALBUM_PAGE_INFO_ID';
  // 人像-人像相册拖拽排序打点
  public static readonly PERSON_PORTRAIT_ORDER_ID: string = 'PERSON_PORTRAIT_ORDER_ID';
  // 人像-人像相册操作行为打点
  public static readonly PORTRAIT_ALBUM_BEHAVIOR_ID: string = 'PORTRAIT_ALBUM_BEHAVIOR_ID';
  // 大图组件数据源环境
  public static readonly PHOTO_BROWSER_ENV_ID: string = 'PHOTO_BROWSER_ENV_ID';
  // 大图组件显示窗口
  public static readonly PHOTO_BROWSER_COMPONENT_ID: string = 'PHOTO_BROWSER_COMPONENT_ID';
  // 大图浏览耗时信息点位
  public static readonly PHOTO_BROWSER_COST_INFO: string = 'PHOTO_BROWSER_COST_INFO';
  // 方式
  public static readonly ENV_MEDIA: string = 'ENV_MEDIA';
  public static readonly ENV_SANDBOX: string = 'ENV_SANDBOX';
  /**
   * 操作位置
   */
  public static readonly OPERATION_IN_INVALID_POSITION: number = -1;
  public static readonly OPERATION_IN_REAL_TIME_PAGE: number = 0;
  public static readonly OPERATION_IN_SEARCH_RESULT_PAGE: number = 1;
  public static readonly OPERATION_IN_TIMELINE_PAGE: number = 2;
  public static readonly OPERATION_IN_ALBUM_PAGE: number = 3;
  public static readonly OPERATION_IN_HIGHLIGHT_PAGE: number = 4;
  public static readonly OPERATION_IN_OTHER_PAGE: number = 5;
  public static readonly OPERATION_IN_CAMERA_PAGE: number = 6;
  // 搜索结果分享
  public static readonly SEARCH_RESULT_SHARE_POSITION: string = 'SearchResultSharePosition';
  public static readonly SEARCH_RESULT_SHARE: string = 'SEARCH_RESULT_SHARE'; // 点位key

  /**
   * 进入搜索界面的位置
   */
  public static readonly CLICK_SEARCH_ICON_FROM_PHOTO: number = 0;
  public static readonly CLICK_SEARCH_ICON_FROM_ALBUM: number = 1;
  public static readonly CLICK_SEARCH_ICON_FROM_HIGHLIGHT: number = 2;
  // 三方选图 智能推荐
  public static readonly SMART_PICKER_THIRD_APP_USE: string = 'SMART_PICKER_THIRD_APP_USE';
  public static readonly SMART_PICKER_SELECT_RESULT: string = 'SMART_PICKER_SELECT_RESULT';
  // picker搜索
  public static readonly PICKER_SEARCH_RESULT_COUNT: string = 'PICKER_SEARCH_RESULT_COUNT';
  public static readonly ENTER_PICKER_SEARCH: string = 'ENTER_PICKER_SEARCH';
  public static readonly IS_PICKER_SEARCH_ENABLED: string = 'IS_PICKER_SEARCH_ENABLED';
  //视频播放
  public static readonly VIDEO_PLAY: string = 'VIDEO_PLAY';
  public static readonly VIDEO_PAUSE: string = 'VIDEO_PAUSE';
  public static readonly VIDEO_PLAY_START_SUCCESS: string = 'VIDEO_PLAY_START_SUCCESS';
  public static readonly VIDEO_PLAYER_ERROR_HAPPENED: string = 'VIDEO_PLAYER_ERROR_HAPPENED';
  public static readonly CLOUD_VIDEO_BUFFER_TIMES: string = 'CLOUD_VIDEO_BUFFER_TIMES';
  public static readonly CLOUD_VIDEO_BUFFER_TIME_OVER: string = 'CLOUD_VIDEO_BUFFER_TIME_OVER';
  public static readonly CLOUD_VIDEO_NETWORK_NO_SERVICE: string = 'CLOUD_VIDEO_NETWORK_NO_SERVICE';
  public static readonly CLOUD_VIDEO_BUFFERING_SHORT: string = 'CLOUD_VIDEO_BUFFERING_SHORT';
  public static readonly CLOUD_VIDEO_CATON_TIME: string = 'CLOUD_VIDEO_CATON_TIME';
  public static readonly CLOUD_VIDEO_FIRST_BUFFERING: string = 'CLOUD_VIDEO_FIRST_BUFFERING';
  public static readonly VIDEO_PLAY_FINISH: string = 'VIDEO_PLAY_FINISH';
  public static readonly VIDEO_FAST_PLAY: string = 'VIDEO_FAST_PLAY';
  // 逐帧播放
  public static readonly VIDEO_SLIDE_BY_FRAME: string = 'VIDEO_SLIDE_BY_FRAME';
  // 逐帧滑动预览条起手事件
  public static readonly VIDEO_SLIDE_BY_FRAME_START: string = 'VIDEO_SLIDE_BY_FRAME_START';
  // 逐帧滑动预览条离手事件
  public static readonly VIDEO_SLIDE_BY_FRAME_END: string = 'VIDEO_SLIDE_BY_FRAME_END';
  //打开右键菜单
  public static readonly OPEN_RIGHT_CLICK_MENU: string = 'OPEN_RIGHT_CLICK_MENU';
  // 年月日视图切换
  public static readonly TIMELINE_CHANGE: string = 'TIMELINE_CHANGE';
  // 缩略图视图切换事件
  public static readonly PHOTO_PAGE_STATE_SWITCH: string = 'PHOTO_PAGE_STATE_SWITCH';
  // 拖动滚动条
  public static readonly SCROLL_BAR_BROWSE: string = 'SCROLL_BAR_BROWSE';
  // 点击地址跳转地图导航面板
  public static readonly PHOTO_DETAIL_ADDRESS_CLICK: string = 'PHOTO_DETAIL_ADDRESS_CLICK';
  // 设置页状态
  public static readonly SETTINGS_PAGE_STATUS: string = 'SETTINGS_PAGE_STATUS';
  // 普通相册
  public static readonly FILE_COUNT: string = 'FILE_COUNT';
  public static readonly USER_ALBUMS_COUNT: string = 'USER_ALBUMS_COUNT';
  public static readonly PHOTO_ALBUM_FILE_COUNT: string = 'PHOTO_ALBUM_FILE_COUNT';
  public static readonly CLOUD_ENHANCE_ALBUM_FILE_COUNT: string = 'CLOUD_ENHANCE_ALBUM_FILE_COUNT';
  public static readonly VIDEO_ALBUM_FILE_COUNT: string = 'VIDEO_ALBUM_FILE_COUNT';
  public static readonly FAVOR_ALBUM_FILE_COUNT: string = 'FAVOR_ALBUM_FILE_COUNT';
  public static readonly HIDDEN_ALBUMS_COUNT: string = 'HIDDEN_ALBUMS_COUNT';
  public static readonly SOURCE_ALBUMS_COUNT: string = 'SOURCE_ALBUMS_COUNT';
  public static readonly MORE_ALBUMS_FILE_COUNT: string = 'MORE_ALBUMS_FILE_COUNT';
  // 智慧相册
  public static readonly SMART_ALBUM_COUNT: string = 'SMART_ALBUM_COUNT';
  public static readonly PROTRAIT_ALBUMS_COUNT: string = 'PROTRAIT_ALBUMS_COUNT';
  // 大图浏览统计
  public static readonly PHOTO_BROWSER_STATISTIC: string = 'PHOTO_BROWSER_STATISTIC';
  // 大图浏览ocr文字高亮
  public static readonly PHOTO_BROWSER_HIGHLIGHT_WORDS: string = 'PHOTO_BROWSER_HIGHLIGHT_WORDS';
  // 雷达打点
  public static readonly OPEN_BROWSER: string = 'OPEN_BROWSER';
  public static readonly BROWSER_SWIPE: string = 'BROWSER_SWIPE';
  public static readonly OPEN_ALBUM: string = 'OPEN_ALBUM';
  // 故障打点
  public static readonly DOWNLOAD_ORIGIN_ERROR: string = 'DOWNLOAD_ORIGIN_ERROR';
  public static readonly BROWER_THUMBNAIL_LOAD_ERROR: string = 'BROWER_THUMBNAIL_LOAD_ERROR';
  public static readonly BROWER_IMAGE_LOAD_ERROR: string = 'BROWER_IMAGE_LOAD_ERROR';
  public static readonly GRID_CACHEDIMAGE_LOAD_ERROR: string = 'GRID_CACHEDIMAGE_LOAD_ERROR';
  public static readonly GRID_IMAGE_LOAD_ERROR: string = 'GRID_IMAGE_LOAD_ERROR';
  public static readonly BROWER_IMAGE_LOAD_TIME_OVER: string = 'BROWER_IMAGE_LOAD_TIME_OVER';
  public static readonly BROWER_HIGHLIGHT_DATA_ERROR: string = 'BROWER_HIGHLIGHT_DATA_ERROR';
  // 时刻打点
  public static readonly HIGHLIGHT_TAB_STAY_DURATION: string = 'HIGHLIGHT_TAB_STAY_DURATION';
  public static readonly HIGHLIGHT_COVER_STAY_DURATION: string = 'HIGHLIGHT_COVER_STAY_DURATION';
  public static readonly HIGHLIGHT_COVER_SCREEN_STATUS: string = 'HIGHLIGHT_COVER_SCREEN_STATUS';
  public static readonly HIGHLIGHT_PLAY_ENTER: string = 'HIGHLIGHT_PLAY_ENTER';
  public static readonly HIGHLIGHT_PLAY_SCREEN_STATUS: string = 'HIGHLIGHT_PLAY_SCREEN_STATUS';
  public static readonly HIGHLIGHT_PLAY_FINISH: string = 'HIGHLIGHT_PLAY_FINISH';
  public static readonly HIGHLIGHT_SLIDE_IN_ARTGRIDPAGE: string = 'HIGHLIGHT_SLID_IN_ARTGRIDPAGE';
  public static readonly HIGHLIGHT_LOAD_MUSIC_PLAYER: string = 'HIGHLIGHT_LOAD_MUSIC_PLAYER';
  public static readonly HIGHLIGHT_LOAD_COVER: string = 'HIGHLIGHT_LOAD_COVER';
  public static readonly HIGHLIGHT_SET_DEFAULT_TIMELINE: string = 'HIGHLIGHT_SET_DEFAULT_TIMELINE';
  public static readonly HIGHLIGHT_LOAD_PLAY_INFO: string = 'HIGHLIGHT_LOAD_PLAY_INFO';
  public static readonly HIGHLIGHT_SLIDESHOW_LOAD_LCD: string = 'HIGHLIGHT_SLIDESHOW_LOAD_LCD';
  public static readonly HIGHLIGHT_REMOVE_FROM_HIGHLIGHT: string = 'HIGHLIGHT_REMOVE_FROM_HIGHLIGHT';
  public static readonly HIGHLIGHT_DELETE: string = 'HIGHLIGHT_DELETE';
  public static readonly HIGHLIGHT_DELETE_CONFIRM: string = 'HIGHLIGHT_DELETE_CONFIRM';
  public static readonly HIGHLIGHT_SHARE_TYPE: string = 'HIGHLIGHT_SHARE_TYPE';
  public static readonly HIGHLIGHT_MUTE_MUSIC: string = 'HIGHLIGHT_MUTE_MUSIC';
  // 动态照片
  public static readonly LONG_PRESS_MOVING_PHOTO_PLAY: string = 'LONG_PRESS_MOVING_PHOTO_PLAY';
  public static readonly PLAY_MOVING_PHOTO: string = 'PLAY_MOVING_PHOTO';
  public static readonly PLAY_MOVING_PHOTO_ERROR: string = 'PLAY_MOVING_PHOTO_ERROR';
  public static readonly ENTER_EDIT_FROM: string = 'ENTER_EDIT_FROM';
  public static readonly MOVING_PHOTO_SWITCH_COST: string = 'MOVING_PHOTO_SWITCH_COST';
  public static readonly MOVING_PHOTO_VERSION_AND_MENU: string = 'MOVING_PHOTO_VERSION_AND_MENU';
  //图片\视频保存弹框
  public static readonly SAVE_DIALOG_INFO: string = 'SAVE_DIALOG_INFO';
  public static readonly SAVE_DIALOG_STATUS: string = 'SAVE_DIALOG_STATUS';
  // 详情XMAGE风格
  public static readonly PHOTO_X_MAGE_STYLE: string = 'PHOTO_X_MAGE_STYLE';
  // 进入连拍界面
  public static readonly ENTER_BURST: string = 'ENTER_BURST';
  public static readonly EXIT_BURST: string = 'EXIT_BURST';
  public static readonly BURST_SAVE: string = 'BURST_SAVE';
  public static readonly BURST_SAVE_DELETE: string = 'DELETE';
  public static readonly BURST_SAVE_KEEP: string = 'KEEP';
  public static readonly BURST_SAVE_CANCEL: string = 'CANCEL';
  //记录日视图模式
  public static readonly RECORD_DAY_SUBTYPE: string = 'RECORD_DAY_SUBTYPE';
  public static readonly NORMAL_TYPE_DAY_VIEW: string = 'NORMAL';
  public static readonly GROUP_TYPE_DAY_VIEW: string = 'GROUP';
  // 设置壁纸打点
  public static readonly SET_WALLPAPER: string = 'SET_WALLPAPER';
  // 扫描为文档打点
  public static readonly SET_DOCUMENT_SCAN: string = 'SET_DOCUMENT_SCAN';
  public static readonly CLICK_DOCUMENT_SCAN: string = 'CLICK_DOCUMENT_SCAN';
  public static readonly DOCUMENT_SCAN_USED_INFO: string = 'DOCUMENT_SCAN_USED_INFO';
  // 课程表特性打点
  public static readonly CALENDER_CLASS_INFO: string = 'CALENDER_CLASS_INFO';
  // 从第三方拖拽视频或图片进入图库
  public static readonly DRAG_MEDIA_TO_PHOTOS: string = 'DRAG_MEDIA_TO_PHOTOS';
  // 动态照片导出视频
  public static readonly LIVE_EXPORT_VIDEO: string = 'LIVE_EXPORT_VIDEO';
  public static readonly EXPORT_VIDEO_ERROR: string = 'EXPORT_VIDEO_ERROR';
  // 云同步卡片（后缀）
  public static readonly CLOUD_CARD: string = 'CLOUD_CARD';
  // 云同步负反馈弹窗
  public static readonly NEG_SYNC_DIALOG: string = 'NEG_SYNC_DIALOG';
  // 查看大图解码是否为YUV
  public static readonly PIXELMAP_DECODE_YUV: string = 'PIXELMAP_DECODE_YUV';
  // 视频导出单帧图片
  public static readonly EXPORT_IMAGE_ERROR: string = 'EXPORT_IMAGE_ERROR';
  public static readonly VIDEO_EXPORT_IMAGE: string = 'VIDEO_EXPORT_IMAGE';
  // picker启动时应用锁加锁状态
  public static readonly PHOTO_PICKER_LOCKED_STATUS: string = 'PHOTO_PICKER_LOCKED_STATUS';
  // photoPickerComponent 浏览模式
  public static readonly PHOTO_PICKER_COMP_BROWSE_MODE: string = 'PHOTO_PICKER_COMP_BROWSE_MODE';
  // photoPicker 恢复现场
  public static readonly SET_CONTEXT_RECOVERY_INFO: string = 'SET_CONTEXT_RECOVERY_INFO';
  // 动态照片视频拼接
  public static readonly MOVING_PHOTO_SPLICE_COUNT: string = 'MOVING_PHOTO_SPLICE_COUNT';
  // pc隔空分享一个资源
  public static readonly PC_AIR_SHARE_ONE_RESOURCE: string = 'PC_AIR_SHARE_ONE_RESOURCE';
  // 图库清理需求打点
  // 设置_触发视频与图片清理推荐卡片（需满足一定的清理条件）
  public static readonly GET_GALLERY_CLEANUP_SIZE: string = 'GET_GALLERY_CLEANUP_SIZE';
  // 设置_点击视频与图片清理推荐卡片_进入图库清理页面
  public static readonly ENTER_GALLERY_CLEANUP: string = 'ENTER_GALLERY_CLEANUP';
  // 设置_图库清理_进入视频删除页面
  public static readonly ENTER_VIDEO_CLEANUP: string = 'ENTER_VIDEO_CLEANUP';
  // 设置_图库清理_删除视频
  public static readonly CLEANUP_DELETE_VIDEOS: string = 'CLEANUP_DELETE_VIDEOS';
  // 设置_图库清理_进入截屏相册
  public static readonly CLEANUP_ENTER_SCREENSHOTS: string = 'CLEANUP_ENTER_SCREENSHOTS';
  // 设置_图库清理_删除截屏图片
  public static readonly CLEANUP_DELETE_SCREENSHOTS: string = 'CLEANUP_DELETE_SCREENSHOTS';
  // 设置_图库清理_进入最近删除页面
  public static readonly ENTER_RECENTLY_DELETED: string = 'ENTER_RECENTLY_DELETED';
  // 设置_图库清理_删除最近删除相册文件
  public static readonly RECENTLY_DELETE_FILES: string = 'RECENTLY_DELETE_FILES';
  // 设置_视频专清_进入视频专清
  public static readonly ENTER_VIDEO_CLEANUP_ENTRY: string = 'ENTER_VIDEO_CLEANUP_ENTRY';
  // 设置_专项清理_获取可清理视频大小
  public static readonly GET_VIDEO_CLEANUP_SIZE: string = 'GET_VIDEO_CLEANUP_SIZE';
  // 设置_专项清理_获取可清理图片大小
  public static readonly GET_IMAGE_CLEANUP_SIZE: string = 'GET_IMAGE_CLEANUP_SIZE';
  // 设置_图片专清_进入图片专清入口
  public static readonly ENTER_IMAGE_CLEANUP_ENTRY: string = 'ENTER_IMAGE_CLEANUP_ENTRY';
  // 设置_图片清理_进入图片清理页面
  public static readonly ENTER_IMAGE_CLEANUP: string = 'ENTER_IMAGE_CLEANUP';
  // 设置_图片清理_删除图片
  public static readonly CLEANUP_DELETE_IMAGES: string = 'CLEANUP_DELETE_IMAGES';
  // 切换相册视图
  public static readonly TOGGLE_ALBUM_VIEW: string = 'TOGGLE_ALBUM_VIEW';
  // pc宫格切换形态
  public static readonly TOGGLE_GRID_VIEW_STYLE: string = 'TOGGLE_GRID_VIEW_STYLE';
  // 点击相册
  public static readonly CLICK_ON_THE_ALBUM: string = 'CLICK_ON_THE_ALBUM';
  // 相册宫格排序
  public static readonly ALBUM_GRID_SORT_RULE: string = 'ALBUM_GRID_SORT_RULE';
  // 宫格appear超时打点
  public static readonly GRID_APPEAR_TIMEOUT: string = 'GRID_APPEAR_TIMEOUT';
  // 宫格reuse超时打点
  public static readonly GRID_REUSE_TIMEOUT: string = 'GRID_REUSE_TIMEOUT';
  // 隐藏相册浏览时发生多人注视情况变化时
  public static readonly HIDDEN_ALBUM_MULTIPLE_EYE_CHANGED: string = 'HIDDEN_ALBUM_MULTIPLE_EYE_STATUS';
  // 用户在隐藏相册内容隐匿保护时点击“查看图片/视频”操作
  public static readonly HIDDEN_ALBUM_IN_RISK_TEMPORARY_BYPASS: string = 'HIDDEN_ALBUM_PROTECTING_BYPASS';
  // 个性相册退出打点
  public static readonly SELECT_PICKER_FOR_STYLE_PHOTO: string = 'STYLE_PHOTO_PICKER_SELECT_RESULT';
  // Heic转JPG打点
  public static readonly HEIC_TO_JPG: string = 'HEIC_TO_JPG';
  // dataShare
  public static readonly CREATE_DATA_SHARE_FAIL: string = 'CREATE_DATA_SHARE_FAIL';
  // 卡片打点
  public static readonly CARD_CREATE_CARD: string = 'CARD_CREATE_CARD';
  public static readonly CARD_DELETE_CARD: string = 'CARD_DELETE_CARD';
  public static readonly CARD_CLICK_NORMAL_CARD: string = 'CARD_CLICK_NORMAL_CARD';
  public static readonly CARD_CLICK_SELECTION: string = 'CARD_CLICK_SELECTION';
  public static readonly CARD_CLICK_SELECTION_DETAIL: string = 'CARD_CLICK_SELECTION_DETAIL';
  public static readonly CARD_CLICK_PLAYBACK_INTERVAL: string = 'CARD_CLICK_PLAYBACK_INTERVAL';
  public static readonly CARD_UPDATE_ALBUM_NAME_STATE: string = 'CARD_UPDATE_ALBUM_NAME_STATE';
  public static readonly CARD_INSERT_NEW_TURN: string = 'CARD_INSERT_NEW_TURN';
  public static readonly CARD_CLICK_HIGHLIGHT_CARD: string = 'CARD_CLICK_HIGHLIGHT_CARD';
  public static readonly CARD_UPDATE_HIGHLIGHT_CARD: string = 'CARD_UPDATE_HIGHLIGHT_CARD';
  // 云图库自动空间清理和立即清理需求打点
  // 进入图库的设置界面,云图库卡片开关的状态点(一周上报一次)
  public static readonly GET_SHOW_CLOUD_SYNC_CARD_STATUS: string = 'GET_SHOW_CLOUD_SYNC_CARD_STATUS';
  // 进入图库的设置界面,开启/关闭云图库卡片开关的操作点
  public static readonly SHOW_CLOUD_SYNC_CARD: string = 'SHOW_CLOUD_SYNC_CARD';
  // 进入图库的设置界面, 优化设备存储空间/保留本设备原片的状态(一周上报一次)
  public static readonly GET_STORAGE_OPTIMIZE_STATUS: string = 'GET_STORAGE_OPTIMIZE_STATUS';
  // 进入图库的设置界面,用户选择 优化设备存储空间/保留本设备原片选项
  public static readonly SELECT_STORAGE_OPTIMIZE_METHOD: string = 'SELECT_STORAGE_OPTIMIZE_METHOD';
  // 进入图库的设置界面,用户点击存储空间优化二次确认弹窗的立即优化和取消
  public static readonly CONFIRM_CLEANUP_IMMEDIATELY: string = 'CONFIRM_CLEANUP_IMMEDIATELY';
  // 进入图库的设置界面,点击本地没有可优化的空间时弹窗“知道了”
  public static readonly CONFIRM_NO_SPACE_CLEANUP: string = 'CONFIRM_NO_SPACE_CLEANUP';
  // 进入画中画打点
  public static readonly ENTER_IMAGE_INNER_PHOTO: string = 'ENTER_IMAGE_INNER_PHOTO';
  // 统计插入设备次数
  public static readonly INSERT_EXTERNAL_STORAGE_COUNT: string = 'INSERT_EXTERNAL_STORAGE_COUNT';
  // 统计移除设备次数
  public static readonly REMOVE_EXTERNAL_STORAGE_COUNT: string = 'REMOVE_EXTERNAL_STORAGE_COUNT';
  // 插入设备打点时间
  public static readonly INSERT_EXTERNAL_STORAGE_TIME: string = 'INSERT_EXTERNAL_STORAGE_TIME';
  // 移除设备打点时间
  public static readonly REMOVE_EXTERNAL_STORAGE_TIME: string = 'REMOVE_EXTERNAL_STORAGE_TIME';
  // 跳转文件管理打点
  public static readonly CLICK_VIEW_FILE_MANAGER: string = 'CLICK_VIEW_FILE_MANAGER';
  //图库克隆打点
  public static readonly PHOTO_LIBRARY_CLONE: string = 'PHOTO_LIBRARY_CLONE';
  //图库更换封面打点
  public static readonly SET_ALBUM_COVER: string = 'SET_ALBUM_COVER';
  public static readonly RESTORE_ALBUM_COVER: string = 'RESTORE_ALBUM_COVER';
  // 手动旋转屏幕打点
  public static readonly PHONE_ROTATE_ACTION: string = 'PHONE_ROTATE_ACTION';
  // 应用调用最近图片组件
  public static readonly SEND_RECENT_PHOTO: string = 'SEND_RECENT_PHOTO';
  // 手动关闭视图切换向导
  public static readonly CLOSE_DAY_GUIDE: string = 'CLOSE_DAY_GUIDE';
  // 三四宫格切换
  public static readonly TOGGLE_DAY_VIEW: string = 'TOGGLE_DAY_VIEW';
  // 显示切换向导次数
  public static readonly SHOW_GUIDE_COUNT: string = 'SHOW_GUIDE_COUNT';
  // 设置开启或关闭 AI 标识
  public static readonly CHANGE_AI_LABLE_SETTING: string = 'CHANGE_AI_LABLE_SETTING';

  public static readonly SHOOTING_MODE_TAG_MAP = new Map<string, string>([
    ['2', 'PRO_PHOTO_ALBUM_TAG'],
    ['7', 'NIGHT_SHOT_ALBUM_TAG'],
    ['9', 'TAIL_LIGHT_ALBUM_TAG'],
    ['10', 'LIGHT_GRAFFITI_TAG'],
    ['11', 'SILKY_WATER_TAG'],
    ['12', 'STAR_TRACK_TAG'],
    ['23', 'PORTRAIT_ALBUM_TAG'],
    ['19', 'WIDE_APERTURE_ALBUM_TAG'],
    ['42', 'REAR_CAMERA_NIGHT_SHOT_TAG'],
    ['20', 'MOVING_PICTURE_ALBUM_TAG'],
    ['42', 'REAR_CAMERA_NIGHT_SHOT_TAG'],
    ['42', 'REAR_CAMERA_NIGHT_SHOT_TAG'],
    ['42', 'REAR_CAMERA_NIGHT_SHOT_TAG'],
    ['53', 'HIGH_PIXEL_ALBUM_TAG'],
    ['47', 'SUPER_MACRO_ALBUM_TAG'],
    ['TypeSlowMotion', 'SLOW_MOTION_ALBUM_TAG'],
    ['TypeSSlowMotion', 'SUPER_SLOW_MOTION_ALBUM_TAG']
  ]);
  // 编辑异常打点
  public static readonly EDITOR_ERROR: string = 'EDITOR_ERROR';
  // 图库卡片空间化动效
  public static readonly PHOTO_CARD_LIGHT_GLIMPSE_EDIT: string = 'CARD_LIGHT_GLIMPSE_EDIT';
  public static readonly PHOTO_CARD_LIGHT_GLIMPSE_DISPLAY: string = 'CARD_LIGHT_GLIMPSE_DISPLAY';

  // 扫描图中二维码打点
  public static readonly SCAN_QRCODE: string = 'SCAN_QRCODE';
  public static readonly CLICK_BROWSER_MORE_MENU: string = 'CLICK_BROWSER_MORE_MENU';

  // 相机快捷地理位置授权打点
  public static readonly AUTH_CAMERA_LOCATION: string = 'AUTH_CAMERA_LOCATION';
  /**
   * 合影相册点位
   */
  public static readonly ENTER_GROUP_ALBUM: string = 'ENTER_GROUP_ALBUM';
  public static readonly DELETE_GROUP_ALBUM_COUNT: string = 'DELETE_GROUP_ALBUM_COUNT';
  public static readonly GROUP_ALBUM_MANAGE: string = 'GROUP_ALBUM_MANAGE';
  //音乐下载打点
  public static readonly SINGLE_MUSIC_DOWNLOAD: string = 'SINGLE_MUSIC_DOWNLOAD';
  /**
   * XXX特效点位
   */
  public static readonly SHOT_FOR_MORE_PHOTO_BROWSER: string = 'SHOT_FOR_MORE_PHOTO_BROWSER';
  public static readonly SHOT_FOR_MORE_PHOTO_SWITCH_COST: string = 'SHOT_FOR_MORE_PHOTO_SWITCH_COST';
  // picker下载远程文件区分文件来源
  public static readonly PICKER_DOWNLOAD_FILE_SOURCE: string = 'PICKER_DOWNLOAD_FILE_SOURCE';
  // 进入图库的选择同步相册界面，统计打点
  public static readonly ALBUM_UPDATE_SWITCH: string = 'ALBUM_UPDATE_SWITCH';
  public static readonly STATIC_ALBUM_UPDATE_STATUS: string = 'STATIC_ALBUM_UPDATE_STATUS';
}

export namespace PhotoInfo {
  export let scenarioIndex: number;
  export let mediaType: number;
}

export namespace AlbumBrowsingInfo {
  export let enterAlbumTime: number;
  export let albumName : string | Resource;
  export let albumSubtype: number;
  export let albumLongPress: boolean = false;
  export let openFavoriteAlbum: boolean = false;
}

export interface IFACardBigDataParams {
  formId?: string;
  formType?: string;
  cardType?: number;
  costTime?: number;
  type?: IFACardEditorAction;
  playbackInterval?: number;
  albumType?: string;
  albumName?: string;
  isShowAlbumName?: number;
}

export enum IFACardEditorAction {
  SELECT_PHOTO = 1,
  SELECT_ALBUM = 2,
}

export enum AlbumType {
  NORMAL = 'NORMAL_ALBUM',
  PORTRAIT = 'PORTRAIT_ALBUM',
  CATEGORY = 'CATEGORY_ALBUM',
  SOURCE = 'SOURCE_ALBUM',
}

export enum Scenario {
  PHOTO_PAGE = 10,
  ALBUM_PAGE = 20,
  HIGHLIGHT_PAGE = 30,
  SEARCH_PAGE = 40,
  OTHER_PAGE = 50,
}

export enum SwitchType {
  BUTTON,
  VIEW,
  PINCH
}

export interface CountMsg {
  type: string;
  count: number;
}

export interface EnvMsg {
  env: string;
}

export interface ErrMsg {
  err: string;
}

interface FromMsg {
  from: string;
}

/* instrument ignore next */
export function errMsg(value: Error): ErrMsg {
  return {
    err: String(value),
  };
}

/* instrument ignore next */
export function fromMsg(value: string): FromMsg {
  return {
    from: String(value),
  };
}